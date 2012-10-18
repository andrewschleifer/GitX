
#import <Cocoa/Cocoa.h>


@interface PBIconAndTextCell : NSTextFieldCell
{
    NSImage *image;
    BOOL mouseDownInButton;
    BOOL mouseHoveredInButton;
}
@property (retain) NSImage *image;

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (NSSize)cellSize;
@end
