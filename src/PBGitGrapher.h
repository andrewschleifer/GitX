
#import "PBGitCommit.h"
#import "PBGitGraphLine.h"
#import "PBGraphCellInfo.h"

@interface PBGitGrapher : NSObject {
	PBGraphCellInfo *previous;
	void *pl;
	void *endLane;
}

- (id) initWithRepository:(PBGitRepository *)repo;
- (void) decorateCommit:(PBGitCommit *)commit;
@end
