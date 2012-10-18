
#import <Cocoa/Cocoa.h>
#import "PBGitRevSpecifier.h"


@interface PBRepositoryDocumentController : NSDocumentController
{

}

- (id) documentForLocation:(NSURL*) url;
@end
