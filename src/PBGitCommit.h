
#import "PBGitRepository.h"
#import "PBGitTree.h"
#include <git/oid.h>

@interface PBGitCommit : NSObject {
    git_oid sha;
    git_oid *parentShas;
    int nParents;

    NSString* subject;
    NSString* author;
    NSString* details;
    NSString *_patch;
    NSArray* parents;

    int timestamp;
    char sign;
    id lineInfo;
    PBGitRepository* repository;
}

- (id)initWithRepository:(PBGitRepository *)repo andSha:(git_oid)sha;

- (void)addRef:(PBGitRef *)ref;
- (void)removeRef:(id)ref;

- (NSString *)realSha;

@property (readonly) git_oid *sha;
@property (copy) NSString* subject;
@property (copy) NSString* author;
@property (readonly) NSArray* parents; // TODO: remove this and its uses

@property (assign) git_oid *parentShas;
@property (assign) int nParents, timestamp;

@property (retain) NSMutableArray* refs;
@property (readonly) NSDate *date;
@property (readonly) NSString* dateString;
@property (readonly) NSString* patch;
@property (assign) char sign;

@property (readonly) NSString* details;
@property (readonly) PBGitTree* tree;
@property (readonly) NSArray* treeContents;
@property (retain) PBGitRepository* repository;
@property (retain) id lineInfo;
@end
