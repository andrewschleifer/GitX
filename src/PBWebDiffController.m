
#import "PBWebDiffController.h"

@implementation PBWebDiffController

- (void) awakeFromNib
{
    startFile = @"diff";
    [super awakeFromNib];
    [diffController addObserver:self forKeyPath:@"diff" options:0 context:@"ChangedDiff"];
}

- (void) didLoad
{
    [self showDiff:diffController.diff];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([(NSString *)context isEqualToString: @"ChangedDiff"])
        [self showDiff:diffController.diff];
}

- (void) showDiff: (NSString *) diff
{
    if (diff == nil || !finishedLoading)
        return;

    id script = [view windowScriptObject];
    [script callWebScriptMethod:@"showDiff" withArguments: [NSArray arrayWithObject:diff]];
}

@end
