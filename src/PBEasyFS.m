
#import "PBEasyFS.h"

@implementation PBEasyFS

+ (NSString*) tmpNameWithSuffix: (NSString*) path
{
    NSString* newName = [NSString stringWithFormat: @"%@/XXXXXX%@", NSTemporaryDirectory(), path];
    char *template = (char*) [newName fileSystemRepresentation];
    int fd = mkstemps(template, [path length]);
    close(fd);
    return [NSString stringWithUTF8String:template];
}

+ (NSString*) tmpDirWithPrefix: (NSString*) path
{
    NSString* newName = [NSString stringWithFormat: @"%@%@.XXXXXX", NSTemporaryDirectory(), path];
    char *template = (char*) [newName fileSystemRepresentation];
    template = mkdtemp(template);
    return [NSString stringWithUTF8String:template];
}

@end
