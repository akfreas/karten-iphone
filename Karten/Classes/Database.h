@class Stack;

@interface Database : NSObject

- (id)initWithStack:(Stack *)stack;
- (void)startSyncing;
@property (nonatomic) CBLReplication *pullReplication;
@property (nonatomic) CBLReplication *pushReplication;
@property (nonatomic) Stack *stack;
@property (nonatomic) CBLDatabase *couchDatabase;

@end
