#import "Stack+CouchBase.h"
#import "Database.h"
#import "CouchManager.h"

@implementation KTStack (CouchBase)

- (void)enqueueDatabaseForSyncing
{
    Database *db = [[Database alloc] initWithStack:self];
    [CouchManager addDatabaseForSyncing:db];
}

- (void)beginCouchDBSync
{
    [CouchManager beginSyncingDatabaseForStack:self];
}
@end
