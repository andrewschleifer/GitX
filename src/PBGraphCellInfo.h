
#import "PBGitGraphLine.h"

@interface PBGraphCellInfo : NSObject
{
    int position;
    struct PBGitGraphLine *lines;
    int nLines;
    int numColumns;
    char sign;
}

@property(readonly) struct PBGitGraphLine *lines;
@property(assign) int nLines;
@property(assign) int position, numColumns;
@property(assign) char sign;

- (id)initWithPosition:(int) p andLines:(struct PBGitGraphLine *) l;

@end
