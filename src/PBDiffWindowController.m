
#import "PBDiffWindowController.h"

@implementation PBDiffWindowController
@synthesize diff;

- (id) initWithDiff:(NSString *)aDiff
{
    if (![super initWithWindowNibName:@"PBDiffWindow"])
        return nil;

    diff = aDiff;
    return self;
}

@end
