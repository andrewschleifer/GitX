
#import "PBFileChangesTableView.h"
#import "PBGitIndexController.h"

@implementation PBFileChangesTableView

#pragma mark NSTableView overrides
- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
    if ([self delegate]) {
        NSPoint eventLocation = [self convertPoint: [theEvent locationInWindow] fromView: nil];
        NSInteger rowIndex = [self rowAtPoint:eventLocation];
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:rowIndex] byExtendingSelection:TRUE];
        return [[self delegate] menuForTable: self];
    }

    return nil;
}

- (NSDragOperation) draggingSourceOperationMaskForLocal:(BOOL) local
{
    return NSDragOperationEvery;
}

@end
