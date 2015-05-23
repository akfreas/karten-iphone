@class KTStack;

@interface Database : NSObject

- (id)initWithStack:(KTStack *)stack;
- (void)startSyncing;
@property (nonatomic) CBLReplication *pullReplication;
@property (nonatomic) CBLReplication *pushReplication;
@property (nonatomic) KTStack *stack;
@property (nonatomic) CBLDatabase *couchDatabase;

@end
