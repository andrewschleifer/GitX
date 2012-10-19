
#import "PBViewController.h"

@interface PBSplitViewController : PBViewController {}

- (BOOL) splitView: (NSSplitView *) sender canCollapseSubview: (NSView *) subview;
- (BOOL) splitView: (NSSplitView *) splitView shouldCollapseSubview: (NSView *) subview forDoubleClickOnDividerAtIndex: (NSInteger) dividerIndex;
- (CGFloat) splitView: (NSSplitView *) sender constrainMinCoordinate: (CGFloat) proposedMin ofSubviewAt: (NSInteger) offset;
- (CGFloat) splitView: (NSSplitView *) sender constrainMaxCoordinate: (CGFloat) proposedMax ofSubviewAt: (NSInteger) offset;

@end
