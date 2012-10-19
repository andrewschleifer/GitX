
@interface PBGitRef : NSObject {
    NSString* ref;
}

- (NSString*) shortName;
- (NSString*) type;
+ (PBGitRef*) refFromString: (NSString*) s;
- (PBGitRef*) initWithString: (NSString*) s;
@property(readonly) NSString* ref;

@end
