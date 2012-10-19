
#import "PBGitBinary.h"
#import "PBEasyPipe.h"

@interface PBGitConfig : NSObject {
	NSString *repositoryPath;
}

- (id)init;
- (id)initWithRepository:(NSString *)path;
@end
