#import "CouchManager.h"
#import "Database.h"

@interface CouchManager ()

@property (nonatomic) CBLReplication* pull;
@property (nonatomic) CBLReplication* push;
@property (nonatomic) NSError* syncError;
@property (nonatomic, copy) void(^completionBlock)();
@property (nonatomic, assign) BOOL waitForSyncCompletion;
@property (nonatomic) CBLLiveQuery *activeQuery;
@property (nonatomic) NSManagedObjectContext *context;
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

+ (void)startSync:(void (^)())completion
{
    [[self sharedInstance] startSync:completion];
}

- (id)init {
    self = [super init];
    if (self) {
        self.waitForSyncCompletion = NO;
        self.context = [NSManagedObjectContext MR_defaultContext];
    }
    return self;
}

- (void)startSync:(void (^)())completion
{
    self.completionBlock = completion;
    NSURL* newRemoteURL = nil;
    NSString *pref = [[NSUserDefaults standardUserDefaults] objectForKey:@"syncpoint"];
    if (pref.length > 0)
        newRemoteURL = [NSURL URLWithString: pref];
    
    [self forgetSync];
    
    // Tell the database to use this URL for bidirectional sync.
    // This call returns an array of the pull and push replication objects:
    _pull = [[Database sharedDB] createPullReplication:newRemoteURL];
    _push = [[Database sharedDB] createPushReplication:newRemoteURL];
    _pull.continuous = _push.continuous = YES;
    // Observe replication progress changes, in both directions:
    NSNotificationCenter* nctr = [NSNotificationCenter defaultCenter];
    [nctr addObserver: self selector: @selector(replicationProgress:)
                 name: kCBLReplicationChangeNotification object: _pull];
    [nctr addObserver: self selector: @selector(replicationProgress:)
                 name: kCBLReplicationChangeNotification object: _push];
    [_push start];
    [_pull start];
    
}

// Called in response to replication-change notifications. Updates the progress UI.
- (void) replicationProgress: (NSNotification*)n {
    if (_pull.status == kCBLReplicationActive || _push.status == kCBLReplicationActive) {
        // Sync is active -- aggregate the progress of both replications and compute a fraction:
        unsigned completed = _pull.completedChangesCount + _push.completedChangesCount;
        unsigned total = _pull.changesCount+ _push.changesCount;
        NSLog(@"SYNC progress: %u / %u", completed, total);
        // Update the progress bar, avoiding divide-by-zero exceptions:
        //        progress.progress = (completed / (float)MAX(total, 1u));
        self.waitForSyncCompletion = YES;
    } else if (self.waitForSyncCompletion && _push.status != kCBLReplicationActive && _pull.status != kCBLReplicationActive) {
        self.waitForSyncCompletion = NO;
        [self copyDataToAppDB];
    }
    
    // Check for any change in error status and display new errors:
    NSError* error = _pull.lastError ? _pull.lastError : _push.lastError;
    if (error != _syncError) {
        _syncError = error;
        if (error)
            NSLog(@"Error syncing %@",error);
    }
}

- (void)copyDataToAppDB
{
    self.activeQuery = [[[[Database sharedDB] viewNamed:@"byDate"] createQuery] asLiveQuery];
    [self.activeQuery addObserver:self forKeyPath:@"rows" options:0 context:nil];
    [self.activeQuery start];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.activeQuery) {
        [self.context performBlock:^{
            
            for (CBLQueryRow *row in self.activeQuery.rows) {
                Card *aCard = [Card getOrCreateCardWithCouchDBQueryRow:row inContext:self.context];
            }
            [self.context MR_saveOnlySelfAndWait];
        }];
    }
    if (self.completionBlock) {
        self.completionBlock();
    }
}

- (void) forgetSync {
    NSNotificationCenter* nctr = [NSNotificationCenter defaultCenter];
    if (_pull) {
        [nctr removeObserver: self name: nil object: _pull];
        _pull = nil;
    }
    if (_push) {
        [nctr removeObserver: self name: nil object: _push];
        _push = nil;
    }
}


@end
