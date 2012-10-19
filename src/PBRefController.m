
#import "PBRefController.h"
#import "PBGitRevisionCell.h"
#import "PBRefMenuItem.h"


@interface PBRefController ()

- (void)removeRefSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;

@end


@implementation PBRefController

- (void)awakeFromNib
{
	[commitList registerForDraggedTypes:[NSArray arrayWithObject:@"PBGitRef"]];
	[historyController addObserver:self forKeyPath:@"repository.branches" options:0 context:@"branchChange"];
	[historyController addObserver:self forKeyPath:@"repository.currentBranch" options:0 context:@"currentBranchChange"];
	[self updateBranchMenu];
	[self selectCurrentBranch];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([(NSString *)context isEqualToString: @"branchChange"]) {
		[self updateBranchMenu];
	}
	else if ([(NSString *)context isEqualToString:@"currentBranchChange"]) {
		[self selectCurrentBranch];
	}
	else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)removeRefSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo
{
	if (returnCode == NSAlertDefaultReturn) {
		int ret = 1;
        PBRefMenuItem *refMenuItem = contextInfo;
		[historyController.repository outputForArguments:[NSArray arrayWithObjects:@"update-ref", @"-d", [[refMenuItem ref] ref], nil] retValue: &ret];
		if (ret) {
			NSLog(@"Removing ref failed!");
			return;
		}
		[historyController.repository removeBranch:[[PBGitRevSpecifier alloc] initWithRef:[refMenuItem ref]]];
		[[refMenuItem commit] removeRef:[refMenuItem ref]];
		[commitController rearrangeObjects];
	}
}

- (void)removeRef:(PBRefMenuItem *)sender
{
	NSString *ref_desc = [NSString stringWithFormat:@"%@ %@", [[sender ref] type], [[sender ref] shortName]];
	NSString *question = [NSString stringWithFormat:@"Are you sure you want to remove the %@?", ref_desc];
    NSBeginAlertSheet([NSString stringWithFormat:@"Delete %@?", ref_desc], @"Delete", @"Cancel", nil, [[historyController view] window], self, @selector(removeRefSheetDidEnd:returnCode:contextInfo:), NULL, sender, question);
}

- (void) checkoutRef:(PBRefMenuItem *)sender
{
	int ret = 1;
	[historyController.repository outputInWorkdirForArguments:[NSArray arrayWithObjects:@"checkout", [[sender ref] shortName], nil] retValue: &ret];
	if (ret) {
		[[historyController.repository windowController] showMessageSheet:@"Checking out branch failed" infoText:@"There was an error checking out the branch. Perhaps your working directory is not clean?"];
		return;
	}
	[historyController.repository reloadRefs];
	[commitController rearrangeObjects];
}

- (void) tagInfo:(PBRefMenuItem *)sender
{
    NSString *message = [NSString stringWithFormat:@"Info for tag: %@", [[sender ref] shortName]];

    int ret = 1;
    NSString *info = [historyController.repository outputInWorkdirForArguments:[NSArray arrayWithObjects:@"tag", @"-n50", @"-l", [[sender ref] shortName], nil] retValue: &ret];

    if (!ret) {
	    [[historyController.repository windowController] showMessageSheet:message infoText:info];
    }
    return;
}

- (NSArray *) menuItemsForRef:(PBGitRef *)ref commit:(PBGitCommit *)commit
{
	return [PBRefMenuItem defaultMenuItemsForRef:ref commit:commit target:self];
}

# pragma mark Tableview delegate methods

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
	NSPoint location = [tv convertPointFromBase:[(PBCommitList *)tv mouseDownPoint]];
	int row = [tv rowAtPoint:location];
	int column = [tv columnAtPoint:location];
	int subjectColumn = [tv columnWithIdentifier:@"SubjectColumn"];
	if (column != subjectColumn)
		return NO;
	
	PBGitRevisionCell *cell = (PBGitRevisionCell *)[tv preparedCellAtColumn:column row:row];
	NSRect cellFrame = [tv frameOfCellAtColumn:column row:row];
	
	int index = [cell indexAtX:(location.x - cellFrame.origin.x)];
	
	if (index == -1)
		return NO;
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:row], [NSNumber numberWithInt:index], NULL]];
	[pboard declareTypes:[NSArray arrayWithObject:@"PBGitRef"] owner:self];
	[pboard setData:data forType:@"PBGitRef"];
	
	return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv
				validateDrop:(id <NSDraggingInfo>)info
				 proposedRow:(NSInteger)row
	   proposedDropOperation:(NSTableViewDropOperation)operation
{
	if (operation == NSTableViewDropAbove)
		return NSDragOperationNone;
	
	NSPasteboard *pboard = [info draggingPasteboard];
	if ([pboard dataForType:@"PBGitRef"])
		return NSDragOperationMove;
	
	return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView
	   acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)newRow
	dropOperation:(NSTableViewDropOperation)operation
{
	if (operation != NSTableViewDropOn)
		return NO;
	
	NSPasteboard *pboard = [info draggingPasteboard];
	NSData *data = [pboard dataForType:@"PBGitRef"];
	if (!data)
		return NO;
	
	NSArray *numbers = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	int oldRow = [[numbers objectAtIndex:0] intValue];
	int oldRefIndex = [[numbers objectAtIndex:1] intValue];
	PBGitCommit *oldCommit = [[commitController arrangedObjects] objectAtIndex:oldRow];
	PBGitCommit *newCommit = [[commitController arrangedObjects] objectAtIndex:newRow];
	PBGitRef *ref = [[oldCommit refs] objectAtIndex:oldRefIndex];

	NSAlert *alert = [NSAlert alertWithMessageText:@"Change branch"
								 defaultButton:@"Change"
							   alternateButton:@"Cancel"
								   otherButton:nil
					 informativeTextWithFormat:@"Do you want to change branch\n\n\t'%@'\n\n to point to commit\n\n\t'%@'", [ref shortName], [newCommit subject], nil];

	NSDictionary *contextInfo = [NSDictionary dictionaryWithObjectsAndKeys:
									[ref ref], @"ref",
									newCommit, @"newCommit",
									oldCommit, @"oldCommit",
									NULL];

	[alert beginSheetModalForWindow:[[historyController view] window]
					  modalDelegate:self
					 didEndSelector:@selector(changeBranchAlertDidEnd:returnCode:contextInfo:)
						contextInfo:contextInfo];
	return YES;
}

- (void) changeBranchAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)retValue contextInfo:(void *)contextInfo
{
	if(!retValue) // hit cancel button
		return;

	NSDictionary *context = (NSDictionary *)contextInfo;

	NSArray *arguments = [NSArray arrayWithObjects:
						  @"update-ref",
						  @"-mUpdate from GitX",
						  [context objectForKey:@"ref"],
						  [[context objectForKey:@"newCommit"] realSha],
						  NULL];
	[historyController.repository outputForArguments:arguments
 											retValue:&retValue];

	if(retValue) // git operation failed
		return;

	[[context objectForKey:@"newCommit"] addRef:[context objectForKey:@"ref"]];
	[[context objectForKey:@"oldCommit"] removeRef:[context objectForKey:@"ref"]];
	[commitController rearrangeObjects];
	[historyController.repository reloadRefs];
}

# pragma mark Add ref methods
-(void)addRef:(id)sender
{
	[errorMessage setStringValue:@""];
	[NSApp beginSheet:newBranchSheet
	   modalForWindow:[[historyController view] window]
		modalDelegate:NULL
	   didEndSelector:NULL
		  contextInfo:NULL];
}

-(void)saveSheet:(id) sender
{
	NSString *branchName = [@"refs/heads/" stringByAppendingString:[newBranchName stringValue]];
	
	if ([[commitController selectedObjects] count] == 0)
		return;

	PBGitCommit *commit = [[commitController selectedObjects] objectAtIndex:0];

	int retValue = 1;
	[historyController.repository outputForArguments:[NSArray arrayWithObjects:@"check-ref-format", branchName, nil] retValue:&retValue];
	if (retValue != 0) {
		[errorMessage setStringValue:@"Invalid name"];
		return;
	}

	retValue = 1;
	[historyController.repository outputForArguments:[NSArray arrayWithObjects:@"update-ref", @"-mCreate branch from GitX", branchName, [commit realSha], @"0000000000000000000000000000000000000000", NULL] retValue:&retValue];
	if (retValue)
	{
		[errorMessage setStringValue:@"Branch exists"];
		return;
	}
	[historyController.repository addBranch:[[PBGitRevSpecifier alloc] initWithRef:[PBGitRef refFromString:branchName]]];
	[self closeSheet:sender];
	[commit addRef:[PBGitRef refFromString:branchName]];
	[commitController rearrangeObjects];
}

-(void)closeSheet:(id) sender
{	
	[NSApp endSheet:newBranchSheet];
	[newBranchName setStringValue:@""];
	[newBranchSheet orderOut:self];
}

# pragma mark Branches menu

- (void) updateBranchMenu
{
	if (!branchPopUp)
		return;

	NSMutableArray *localBranches = [NSMutableArray array];
	NSMutableArray *remoteBranches = [NSMutableArray array];
	NSMutableArray *tags = [NSMutableArray array];
	NSMutableArray *other = [NSMutableArray array];

	NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Branch menu"];
	for (PBGitRevSpecifier *rev in historyController.repository.branches)
	{
		if (![rev isSimpleRef])
		{
			[other addObject:rev];
			continue;
		}

		NSString *ref = [rev simpleRef];

		if ([ref hasPrefix:@"refs/heads"])
			[localBranches addObject:rev];
		else if ([ref hasPrefix:@"refs/tags"])
			[tags addObject:rev];
		else if ([ref hasPrefix:@"refs/remote"])
			[remoteBranches addObject:rev];
	}

	for (PBGitRevSpecifier *rev in localBranches)
	{
		NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[rev description] action:@selector(changeBranch:) keyEquivalent:@""];
		[item setRepresentedObject:rev];
		[item setTarget:self];
		[menu addItem:item];
	}

	[menu addItem:[NSMenuItem separatorItem]];

	// Remotes
	NSMenu *remoteMenu = [[NSMenu alloc] initWithTitle:@"Remotes"];
	NSMenu *currentMenu = NULL;
	for (PBGitRevSpecifier *rev in remoteBranches)
	{
		NSString *ref = [rev simpleRef];
		NSArray *components = [ref componentsSeparatedByString:@"/"];
		
		NSString *remoteName = [components objectAtIndex:2];
		NSString *branchName = [[components subarrayWithRange:NSMakeRange(3, [components count] - 3)] componentsJoinedByString:@"/"];

		if (![[currentMenu title] isEqualToString:remoteName])
		{
			currentMenu = [[NSMenu alloc] initWithTitle:remoteName];
			NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:remoteName action:NULL keyEquivalent:@""];
			[item setSubmenu:currentMenu];
			[remoteMenu addItem:item];
		}

		NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:branchName action:@selector(changeBranch:) keyEquivalent:@""];
		[item setTarget:self];
		[item setRepresentedObject:rev];
		[currentMenu addItem:item];
	}

	NSMenuItem *remoteItem = [[NSMenuItem alloc] initWithTitle:@"Remotes" action:NULL keyEquivalent:@""];
	[remoteItem setSubmenu:remoteMenu];
	[menu addItem:remoteItem];

	// Tags
	NSMenu *tagMenu = [[NSMenu alloc] initWithTitle:@"Tags"];
	for (PBGitRevSpecifier *rev in tags)
	{
		NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[rev description] action:@selector(changeBranch:) keyEquivalent:@""];
		[item setTarget:self];
		[item setRepresentedObject:rev];
		[tagMenu addItem:item];
	}		
	
	NSMenuItem *tagItem = [[NSMenuItem alloc] initWithTitle:@"Tags" action:NULL keyEquivalent:@""];
	[tagItem setSubmenu:tagMenu];
	[menu addItem:tagItem];


	// Others
	[menu addItem:[NSMenuItem separatorItem]];

	for (PBGitRevSpecifier *rev in other)
	{
		NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[rev description] action:@selector(changeBranch:) keyEquivalent:@""];
		[item setRepresentedObject:rev];
		[item setTarget:self];
		[menu addItem:item];
	}
	
	[[branchPopUp cell] setMenu: menu];
}

- (void) changeBranch:(NSMenuItem *)sender
{
	PBGitRevSpecifier *rev = [sender representedObject];
	historyController.repository.currentBranch = rev;
}

- (void) selectCurrentBranch
{
	PBGitRevSpecifier *rev = historyController.repository.currentBranch;
	if (rev)
		[branchPopUp setTitle:[rev description]];
}

@end
