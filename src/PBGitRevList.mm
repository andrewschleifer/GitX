
#import "PBGitRevList.h"
#import "PBGitRepository.h"
#import "PBGitCommit.h"
#import "PBGitGrapher.h"
#import "PBGitRevSpecifier.h"

#include <git/oid.h>
#include <ext/stdio_filebuf.h>
#include <iostream>
#include <string>

using namespace std;

@interface PBGitRevList ()

- (void)walkRevisionListWithSpecifier:(PBGitRevSpecifier *)rev;

@end

@implementation PBGitRevList

@synthesize commits;
- (id)initWithRepository:(PBGitRepository *)repo
{
    repository = repo;
    [repository addObserver:self forKeyPath:@"currentBranch" options:0 context:nil];

    return self;
}

- (void) reload
{
    [self readCommitsForce: YES];
}

- (void) readCommitsForce: (BOOL) force
{
    // We use refparse to get the commit sha that we will parse. That way,
    // we can check if the current branch is the same as the previous one
    // and in that case we don't have to reload the revision list.

    // If no branch is selected, don't do anything
    if (![repository currentBranch])
        return;

    PBGitRevSpecifier* newRev = [repository currentBranch];
    NSString* newSha = nil;

    if (!force && newRev && [newRev isSimpleRef]) {
        newSha = [repository parseReference:[newRev simpleRef]];
        if ([newSha isEqualToString:lastSha])
            return;
    }
    lastSha = newSha;

    NSThread * commitThread = [[NSThread alloc] initWithTarget: self selector: @selector(walkRevisionListWithSpecifier:) object:newRev];
    [commitThread start];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
    change:(NSDictionary *)change context:(void *)context
{
    if (object == repository)
        [self readCommitsForce: NO];
}

- (void) walkRevisionListWithSpecifier: (PBGitRevSpecifier*) rev
{
    NSDate *start = [NSDate date];
    NSMutableArray* revisions = [NSMutableArray array];
    PBGitGrapher* grapher = [[PBGitGrapher alloc] initWithRepository: repository];

    NSString *formatString = @"--pretty=format:%H\01%an\01%s\01%P\01%at";

    BOOL showSign = [rev hasLeftRight];
    if (showSign)
        formatString = [formatString stringByAppendingString:@"\01%m"];

    NSMutableArray *arguments = [NSMutableArray arrayWithObjects:@"log", @"-z", @"--early-output", @"--topo-order", @"--children", formatString, nil];
    if (rev)
        [arguments addObjectsFromArray:[rev parameters]];
    else
        [arguments addObject:@"HEAD"];

    NSString *directory = rev.workingDirectory ? rev.workingDirectory.path : repository.fileURL.path;
    NSTask *task = [PBEasyPipe taskForCommand:[PBGitBinary path] withArgs:arguments inDir:directory];
    [task launch];
    NSFileHandle* handle = [task.standardOutput fileHandleForReading];

    int fd = [handle fileDescriptor];
    __gnu_cxx::stdio_filebuf<char> buf(fd, std::ios::in);
    std::istream stream(&buf);

    int commitCount = 0;
    while (true) {
        string sha;
        if (!getline(stream, sha, '\1'))
            break;

        // We reached the end of some temporary output. Show what we have
        // until now, and then start again. The sha of the next thing is still
        // in this buffer. So, we use a substring of current input.
        if (sha[1] == 'i') // Matches 'Final output'
        {
            commitCount = 0;
            [self performSelectorOnMainThread:@selector(setCommits:) withObject:revisions waitUntilDone:NO];
            revisions = [NSMutableArray array];

            // If the length is < 40, then there are no commits.. quit now
            if (sha.length() < 40)
                break;

            sha = sha.substr(sha.length() - 40, 40);
        }

        // From now on, 1.2 seconds
        git_oid oid;
        git_oid_mkstr(&oid, sha.c_str());
        PBGitCommit* newCommit = [[PBGitCommit alloc] initWithRepository:repository andSha:oid];

        string author;
        getline(stream, author, '\1');

        string subject;
        getline(stream, subject, '\1');

        string parentString;
        getline(stream, parentString, '\1');
        if (parentString.size() != 0)
        {
            if (((parentString.size() + 1) % 41) != 0) {
                NSLog(@"invalid parents: %ld", parentString.size());
                continue;
            }
            int nParents = (parentString.size() + 1) / 41;
            git_oid *parents = (git_oid *)malloc(sizeof(git_oid) * nParents);
            int parentIndex;
            for (parentIndex = 0; parentIndex < nParents; ++parentIndex)
                git_oid_mkstr(parents + parentIndex, parentString.substr(parentIndex * 41, 40).c_str());
   
            newCommit.parentShas = parents;
            newCommit.nParents = nParents;
        }

        int time;
        stream >> time;

        [newCommit setSubject:[NSString stringWithCString:subject.c_str() encoding:NSUTF8StringEncoding]];
        [newCommit setAuthor:[NSString stringWithCString:author.c_str() encoding:NSUTF8StringEncoding]];
        [newCommit setTimestamp:time];

        if (showSign)
        {
            char c;
            stream >> c; // Remove separator
            stream >> c;
            if (c != '>' && c != '<' && c != '^' && c != '-')
                NSLog(@"Error loading commits: sign not correct");
            [newCommit setSign: c];
        }

        char c;
        stream >> c;
        if (c != '\0')
            cout << "Error" << endl;

        [revisions addObject: newCommit];
        [grapher decorateCommit: newCommit];

        if (++commitCount % 1000 == 0)
            [self performSelectorOnMainThread:@selector(setCommits:) withObject:revisions waitUntilDone:NO];
    }

    [grapher release];
    NSTimeInterval duration = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"Loaded %i commits in %f seconds", commitCount, duration);
    // Make sure the commits are stored before exiting.
    [self performSelectorOnMainThread:@selector(setCommits:) withObject:revisions waitUntilDone:YES];
    [task waitUntilExit];
}

@end
