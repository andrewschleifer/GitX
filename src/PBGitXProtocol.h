
#import "PBGitRepository.h"

@interface PBGitXProtocol : NSURLProtocol {
    NSFileHandle *handle;
}
@end

@interface NSURLRequest (PBGitXProtocol)
@property (readonly) PBGitRepository *repository;
@end

@interface NSMutableURLRequest (PBGitXProtocol)
@property (retain) PBGitRepository *repository;
@end
