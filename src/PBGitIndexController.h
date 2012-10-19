
#import "PBGitCommitController.h"
#import "PBChangedFile.h"

@interface PBGitIndexController : NSObject {
	IBOutlet NSArrayController *stagedFilesController, *unstagedFilesController;
	IBOutlet PBGitCommitController *commitController;

	IBOutlet NSTableView *unstagedTable;
	IBOutlet NSTableView *stagedTable;	
}

- (IBAction) rowClicked:(NSCell *) sender;
- (IBAction) tableClicked:(NSTableView *)tableView;

- (NSMenu *) menuForTable:(NSTableView *)table;
@end
