
#import <Cocoa/Cocoa.h>


@interface PBDiffWindowController : NSWindowController {
	NSString *diff;
}

- initWithDiff:(NSString *)diff;
@property (readonly) NSString *diff;
@end
