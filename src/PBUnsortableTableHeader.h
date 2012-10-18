
#import <Cocoa/Cocoa.h>


@interface PBUnsortableTableHeader : NSTableHeaderView {
	IBOutlet NSArrayController *controller;
	int clickCount;
	int columnIndex;
}

@end
