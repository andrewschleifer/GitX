
#import "PBSplitViewController.h"

@implementation PBSplitViewController

- (BOOL) splitView: (NSSplitView *) sender canCollapseSubview: (NSView *) subview {
    return TRUE;
}

- (BOOL) splitView: (NSSplitView *) splitView shouldCollapseSubview: (NSView *) subview forDoubleClickOnDividerAtIndex: (NSInteger) dividerIndex {
    int index = [[splitView subviews] indexOfObject: subview];
    // this method (and canCollapse) are called by the splitView to decide how to collapse on double-click
    // we compare our two subviews, so that always the smaller one is collapsed.
    if([[[splitView subviews] objectAtIndex: index] frame].size.height < [[[splitView subviews] objectAtIndex: ((index+1)%2)] frame].size.height) {
        return TRUE;
    }
    return FALSE;
}

- (CGFloat) splitView: (NSSplitView *) sender constrainMinCoordinate: (CGFloat) proposedMin ofSubviewAt: (NSInteger) offset {
    return proposedMin + 68;
}

- (CGFloat) splitView: (NSSplitView *) sender constrainMaxCoordinate: (CGFloat) proposedMax ofSubviewAt: (NSInteger) offset {
    return [sender frame].size.height - 68;
}

@end
