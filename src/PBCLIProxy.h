
@interface PBCLIProxy : NSObject
{
    NSConnection *connection;
}
@property (retain) NSConnection* connection;
@end

#define ConnectionName @"GitX DO Connection"
#define PBCLIProxyErrorDomain @"PBCLIProxyErrorDomain"

@protocol GitXCliToolProtocol
- (BOOL)openRepository:(NSURL*)repositoryPath arguments: (NSArray*) args error:(NSError**)error;
- (void)openDiffWindowWithDiff:(NSString *)diff;
@end
