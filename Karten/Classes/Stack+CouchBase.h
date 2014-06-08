#import "Stack.h"
@class Database;
@class CouchManager;

@interface Stack (CouchBase)

- (void)enqueueDatabaseForSyncing;
- (void)beginCouchDBSync;

@end
