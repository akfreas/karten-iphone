@class Database;
@class Stack;

@interface CouchManager : NSObject

+ (void)addDatabaseForSyncing:(Database *)database;
+ (void)beginSyncingAllDatabases;
+ (void)beginSyncingDatabaseForStack:(Stack *)stack;
+ (Database *)databaseForStack:(Stack *)stack;

@end
