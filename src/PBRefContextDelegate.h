
@protocol PBRefContextDelegate
- (NSArray *) menuItemsForRef:(PBGitRef *)ref commit:(PBGitCommit *)commit;
@end
