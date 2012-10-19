
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <fcntl.h>

@interface NSFileHandle(NSFileHandleExt)
- (NSString*)readLine;
@end
