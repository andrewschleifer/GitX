
#import "PBGitGraphLine.h"

@implementation PBGitGraphLine
@synthesize upper, from, to, colorIndex;
- (id)initWithUpper: (char) u From: (char) f to: (char) t  color: (char) c;
{
    upper = u;
    from = f;
    to = t;
    colorIndex = c;
    return self;
}

+ (PBGitGraphLine*) lowerLineFrom:(char) f to: (char) t color: (char) c
{
    return [[PBGitGraphLine alloc] initWithUpper:0 From:f to:t color:c];
}

+ (PBGitGraphLine*) upperLineFrom:(char) f to: (char) t color: (char) c
{
    return [[PBGitGraphLine alloc] initWithUpper:1 From:f to:t color: c];
}
@end
