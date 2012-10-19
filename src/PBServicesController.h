


@interface PBServicesController : NSObject {

}

- (NSString *)completeSHA1For:(NSString *)sha;

- (void)completeSha:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error;
@end
