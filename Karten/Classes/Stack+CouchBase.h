#import "KTStack.h"
@class Database;
@class CouchManager;

@interface KTStack (CouchBase)

- (void)enqueueDatabaseForSyncing;
- (void)beginCouchDBSync;

@end
