
#import <Cocoa/Cocoa.h>
#import "PBSplitViewController.h"

@class PBGitIndexController, PBIconAndTextCell, PBWebChangesController, PBGitIndex;

@interface PBGitCommitController : PBSplitViewController {
	// This might have to transfer over to the PBGitRepository
	// object sometime
	PBGitIndex *index;
	
	IBOutlet NSTextView *commitMessageView;
	IBOutlet NSArrayController *unstagedFilesController;
	IBOutlet NSArrayController *cachedFilesController;
	IBOutlet NSButton *commitButton;

	IBOutlet PBGitIndexController *indexController;
	IBOutlet PBWebChangesController *webController;

	NSString *status;
	BOOL busy;
}

@property(copy) NSString *status;
@property(readonly) PBGitIndex *index;
@property(assign) BOOL busy;

- (IBAction) refresh:(id) sender;
- (IBAction) commit:(id) sender;
- (IBAction)signOff:(id)sender;
@end
