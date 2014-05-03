@interface CouchManager : NSObject

+ (void)startSync:(void(^)())completion;

@end
