
#import "PBGraphCellInfo.h"

@implementation PBGraphCellInfo
@synthesize lines, position, numColumns, sign, nLines;
- (id)initWithPosition:(int)p andLines:(struct PBGitGraphLine *)l
{
    position = p;
    lines = l;

    return self;
}

-(void) finalize
{
    free(lines);
    [super finalize];
}

@end
