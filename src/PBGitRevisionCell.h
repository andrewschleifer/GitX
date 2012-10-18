
#import <Cocoa/Cocoa.h>
#import "PBGitGrapher.h"
#import "PBGraphCellInfo.h"
#import "PBGitHistoryController.h"
#import "PBRefContextDelegate.h"

@interface PBGitRevisionCell : NSActionCell {
	PBGitCommit *objectValue;
	PBGraphCellInfo *cellInfo;
	NSTextFieldCell *textCell;
	IBOutlet PBGitHistoryController *controller;
	IBOutlet id<PBRefContextDelegate> contextMenuDelegate;
}

- (int) indexAtX:(float)x;
- (NSRect) rectAtIndex:(int)index;
- (void) drawLabelAtIndex:(int)index inRect:(NSRect)rect;

@property(retain) PBGitCommit* objectValue;
@end
