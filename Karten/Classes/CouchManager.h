@class Database;
@class KTStack;

@interface CouchManager : NSObject

+ (void)addDatabaseForSyncing:(Database *)database;
+ (void)beginSyncingAllDatabases;
+ (void)beginSyncingDatabaseForStack:(KTStack *)stack;
+ (Database *)databaseForStack:(KTStack *)stack;

@end
