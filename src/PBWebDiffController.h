
#import <Cocoa/Cocoa.h>
#import "PBWebController.h"
#import "PBDiffWindowController.h"

@interface PBWebDiffController : PBWebController {
	IBOutlet PBDiffWindowController *diffController;
}

- (void) showDiff:(NSString *)diff;
@end
