
#import <Cocoa/Cocoa.h>


@interface NSBezierPath (RoundedRectangle)

+ (NSBezierPath *)bezierPathWithRoundedRect: (NSRect) aRect cornerRadius: (double) cRadius;

@end
