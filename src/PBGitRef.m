
#import "PBGitRef.h"


@implementation PBGitRef

@synthesize ref;
- (NSString*) shortName
{
	if ([self type])
		return [ref substringFromIndex:[[self type] length] + 7];
	return ref;
}

- (NSString*) type
{
	if ([ref hasPrefix:@"refs/heads"])
		return @"head";
	if ([ref hasPrefix:@"refs/tags"])
		return @"tag";
	if ([ref hasPrefix:@"refs/remotes"])
		return @"remote";
	return nil;
}

+ (PBGitRef*) refFromString: (NSString*) s
{
	return [[PBGitRef alloc] initWithString:s];
}

- (PBGitRef*) initWithString: (NSString*) s
{
	ref = s;
	return self;
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector
{
	return NO;
}

+ (BOOL)isKeyExcludedFromWebScript:(const char *)name {
	return NO;
}

@end
