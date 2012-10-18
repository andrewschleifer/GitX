
#import <Cocoa/Cocoa.h>

@class PBGitRepository;

@interface PBGitRevList : NSObject {
	NSArray* commits;
	PBGitRepository *repository;
	NSString* lastSha;
}

- (id)initWithRepository:(PBGitRepository *)repo;
- (void)readCommitsForce: (BOOL) force;
- (void)reload;

@property(retain) NSArray* commits;

@end
