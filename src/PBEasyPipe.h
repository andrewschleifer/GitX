
#import <Cocoa/Cocoa.h>


@interface PBEasyPipe : NSObject {

}
+ (NSTask *) taskForCommand:(NSString *)cmd withArgs:(NSArray *)args inDir:(NSString *)dir;

+ (NSFileHandle*) handleForCommand: (NSString*) cmd withArgs: (NSArray*) args;
+ (NSFileHandle*) handleForCommand: (NSString*) cmd withArgs: (NSArray*) args inDir: (NSString*) dir;

+ (NSString*) outputForCommand: (NSString*) cmd withArgs: (NSArray*) args;
+ (NSString*) outputForCommand: (NSString*) cmd withArgs: (NSArray*) args inDir: (NSString*) dir;
+ (NSString*) outputForCommand:(NSString *) cmd
					  withArgs:(NSArray *)  args
						 inDir:(NSString *) dir
				      retValue:(int *)      ret;
+ (NSString*) outputForCommand:(NSString *) cmd
					  withArgs:(NSArray *)  args
						 inDir:(NSString *) dir
				   inputString:(NSString *)input
				      retValue:(int *)      ret;
+ (NSString*) outputForCommand:(NSString *) cmd
					  withArgs:(NSArray *)  args
						 inDir:(NSString *) dir
		byExtendingEnvironment:(NSDictionary *)dict
				   inputString:(NSString *)input
				      retValue:(int *)      ret;


@end
