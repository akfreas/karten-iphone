#import "CouchManager.h"
#import "Database.h"
#import "KTStack.h"

@interface CouchManager ()
@property (nonatomic) NSMutableDictionary *databases;
@end

@implementation CouchManager


+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)addDatabaseForSyncing:(Database *)database
{
    [[self sharedInstance] addDatabaseForSyncing:database];
}

+ (void)beginSyncingAllDatabases
{
    [[self sharedInstance] beginSyncingAllDatabases];
}

+ (void)beginSyncingDatabaseForStack:(KTStack *)stack
{
    [[self sharedInstance] beginSyncingDatabaseForStack:stack];
}

+ (Database *)databaseForStack:(KTStack *)stack
{
    Database *db = [[[self sharedInstance] databases] objectForKey:stack.serverID];
    return db;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.databases = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)addDatabaseForSyncing:(Database *)database
{
    [self.databases setObject:database forKey:database.stack.serverID];
}

- (void)beginSyncingDatabaseForStack:(KTStack *)stack
{
    Database *db = [self.databases objectForKey:stack.serverID];
    [db startSyncing];
}

- (void)beginSyncingAllDatabases;
{
    for (Database *database in self.databases) {
        [database startSyncing];
    }
}



@end
