
#import <Cocoa/Cocoa.h>

#define MIN_GIT_VERSION "1.6.0"

@interface PBGitBinary : NSObject {

}

+ (NSString *) path;
+ (NSString *) version;
+ (NSArray *) searchLocations;
+ (NSString *) notFoundError;
@end
