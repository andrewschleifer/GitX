
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface PBWebController : NSObject {
	IBOutlet WebView* view;
	NSString *startFile;
	BOOL finishedLoading;

	// For async git reading
	NSMapTable *callbacks;

	// For the repository access
	IBOutlet id repository;
}

@property (retain) NSString *startFile;
@property (retain) id repository;

- (WebScriptObject *) script;
- (void) closeView;
@end
