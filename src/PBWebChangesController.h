
#import "PBWebController.h"
#import "PBGitCommitController.h"
#import "PBChangedFile.h"

@class PBGitIndexController;

@interface PBWebChangesController : PBWebController {
    IBOutlet NSArrayController *unstagedFilesController;
    IBOutlet NSArrayController *cachedFilesController;
    IBOutlet PBGitCommitController *controller;
    IBOutlet PBGitIndexController *indexController;

    PBChangedFile *selectedFile;
    BOOL selectedFileIsCached;
}

- (void) refresh;
- (void) setStateMessage:(NSString *)state;

- (void) showMultiple:(NSArray *)files;
@end
