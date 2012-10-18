
@interface PBGitDefaults : NSObject
{

}

+ (int) commitMessageViewVerticalLineLength;
+ (BOOL) isGistEnabled;
+ (BOOL) isGravatarEnabled;
+ (BOOL) confirmPublicGists;
+ (BOOL) isGistPublic;
+ (BOOL)showWhitespaceDifferences;
+ (BOOL)openCurDirOnLaunch;
+ (BOOL)showOpenPanelOnLaunch;

@end
