
#import <WebKit/WebView.h>
#import "PBGitHistoryController.h"

@class PBWebHistoryController;

@interface PBCommitList : NSTableView {
	IBOutlet WebView* webView;
	IBOutlet PBWebHistoryController *webController;
	IBOutlet PBGitHistoryController *controller;

	NSPoint mouseDownPoint;
}

@property (readonly) NSPoint mouseDownPoint;
@end
