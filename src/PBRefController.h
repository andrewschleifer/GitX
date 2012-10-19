
#import "PBGitHistoryController.h"
#import "PBCommitList.h"
#import "PBGitRef.h"
#import "PBGitCommit.h"
#import "PBRefContextDelegate.h"

@class PBRefMenuItem;

@interface PBRefController : NSObject <PBRefContextDelegate> {
	IBOutlet __weak PBGitHistoryController *historyController;
	IBOutlet NSArrayController *commitController;
	IBOutlet PBCommitList *commitList;

	IBOutlet NSWindow *newBranchSheet;
	IBOutlet NSTextField *newBranchName;
	IBOutlet NSTextField *errorMessage;

	IBOutlet NSPopUpButton *branchPopUp;
}

- (void)removeRef:(PBRefMenuItem *)sender;
- (void)checkoutRef:(PBRefMenuItem *)sender;
- (void)tagInfo:(PBRefMenuItem *)sender;

- (IBAction)addRef:(id)sender;
- (IBAction)closeSheet:(id) sender;
- (IBAction)saveSheet:(id) sender;

- (NSArray *) menuItemsForRef:(PBGitRef *)ref commit:(PBGitCommit *)commit;

- (void) changeBranch:(NSMenuItem *)sender;
- (void) selectCurrentBranch;
- (void) updateBranchMenu;

@end
