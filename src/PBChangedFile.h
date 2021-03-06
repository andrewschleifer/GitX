
#import "PBGitRepository.h"

typedef enum {
    NEW,
    MODIFIED,
    DELETED
} PBChangedFileStatus;

@interface PBChangedFile : NSObject {
    NSString *path;
    BOOL hasStagedChanges;
    BOOL hasUnstagedChanges;

    // Index and HEAD stuff, to be used to revert changes
    NSString *commitBlobSHA;
    NSString *commitBlobMode;

    PBChangedFileStatus status;
}

@property (copy) NSString *path, *commitBlobSHA, *commitBlobMode;
@property (assign) PBChangedFileStatus status;
@property (assign) BOOL hasStagedChanges, hasUnstagedChanges;

- (NSImage *)icon;
- (NSString *)indexInfo;

- (id) initWithPath:(NSString *)p;
@end
