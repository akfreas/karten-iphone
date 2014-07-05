#import "Database.h"
#import "Stack.h"
#import "Stack+Helpers.h"
#import "StackServer.h"


@interface Database ()
@property (nonatomic) BOOL waitForSyncCompletion;
@property (nonatomic) CBLLiveQuery *activeQuery;
@property (nonatomic) NSError* syncError;

@end

@implementation Database

- (id)initWithStack:(Stack *)stack
{
    self = [super init];
    if (self) {
        self.stack = stack;
        [self setup];
    }
    return self;
}

- (NSUInteger)hash
{
    return [self.stack.objectID hash];
}

-(void)setup {
    
    
    NSString *pushAndPullURLString = [self.stack fullServerURL] ;
    NSError *err = nil;
    self.couchDatabase = [[CBLManager sharedInstance] databaseNamed:self.stack.serverStackName error:&err];
    if (err != nil) {
        NSLog(@"Couldn't connect to DB! %@", err);
    }
    [[self.couchDatabase viewNamed:@"byDate"] setMapBlock:MAPBLOCK({
        id date = doc[@"created_at"];
        if (date) {
            emit(date, doc);
        }
    }) reduceBlock:nil version:@"1.0"];
    
//    [[self.database viewNamed:@"search"] setMapBlock:MAPBLOCK({
//        id
//    }) reduceBlock:REDUCEBLOCK({}) version:@"1.0"];
//    
    self.pullReplication = [self.couchDatabase createPullReplication:[NSURL URLWithString:pushAndPullURLString]];
    self.pushReplication = [self.couchDatabase createPushReplication:[NSURL URLWithString:pushAndPullURLString]];
    self.pushReplication.continuous = self.pullReplication.continuous = YES;
}

- (void) replicationProgress: (NSNotification*)n {
    if (self.pullReplication.status == kCBLReplicationActive || self.pushReplication.status == kCBLReplicationActive) {
        // Sync is active -- aggregate the progress of both replications and compute a fraction:
        unsigned completed = self.pullReplication.completedChangesCount + self.pushReplication.completedChangesCount;
        unsigned total = self.pullReplication.changesCount+ self.pushReplication.changesCount;
        NSLog(@"SYNC progress: %u / %u", completed, total);
        // Update the progress bar, avoiding divide-by-zero exceptions:
        //        progress.progress = (completed / (float)MAX(total, 1u));
        self.waitForSyncCompletion = YES;
    } else if (self.waitForSyncCompletion && self.pushReplication.status != kCBLReplicationActive && self.pullReplication.status != kCBLReplicationActive) {
        self.waitForSyncCompletion = NO;
        [self copyDataToAppDB];
    }
    
    // Check for any change in error status and display new errors:
    NSError* error = self.pullReplication.lastError ? self.pullReplication.lastError : self.pushReplication.lastError;
    if (error != _syncError) {
        _syncError = error;
        if (error)
            NSLog(@"Error syncing %@",error);
    }
}


- (void)copyDataToAppDB
{
    self.activeQuery = [[[self.couchDatabase viewNamed:@"byDate"] createQuery] asLiveQuery];
    [self.activeQuery addObserver:self forKeyPath:@"rows" options:0 context:nil];
    [self.activeQuery start];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.activeQuery) {
        [self.stack.managedObjectContext performBlock:^{
            
            NSMutableArray *cards = [[Card MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"stack.server == %@", self.stack.server] inContext:self.stack.managedObjectContext] mutableCopy];
            for (CBLQueryRow *row in self.activeQuery.rows) {
                NSInteger index = [cards indexOfObjectPassingTest:^BOOL(Card *filterCard, NSUInteger idx, BOOL *stop) {
                    if ([filterCard.couchID isEqualToString:row.documentID]) {
                        *stop = YES;
                        return YES;
                    }
                    return NO;
                }];
                Card *aCard = [Card getOrCreateCardWithCouchDBQueryRow:row inContext:self.stack.managedObjectContext];
                aCard.stack = self.stack;
                if (aCard == nil) {
                    NSLog(@"Could not create card with doc %@", row);
                }
                if (index != NSNotFound) {
                    [cards removeObjectAtIndex:index];
                }
            }
            if ([cards count] > 0) {
                [cards enumerateObjectsUsingBlock:^(Card *cardToDelete, NSUInteger idx, BOOL *stop) {
                    [cardToDelete MR_deleteInContext:self.stack.managedObjectContext];
                }];
            }
            [self.stack.managedObjectContext MR_saveOnlySelfAndWait];
        }];
    }
}

- (void)startSyncing
{
    NSNotificationCenter* nctr = [NSNotificationCenter defaultCenter];
    [nctr addObserver: self selector: @selector(replicationProgress:)
                 name: kCBLReplicationChangeNotification object: self.pullReplication];
    [nctr addObserver: self selector: @selector(replicationProgress:)
                 name: kCBLReplicationChangeNotification object: self.pushReplication];
    [self.pullReplication start];
    [self.pushReplication start];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
