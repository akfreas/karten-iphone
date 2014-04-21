#import "MainViewController.h"
#import "CardTableView.h"
#import "Database.h"

@interface MainViewController ()

@property (nonatomic, retain) CardTableView *tableView;

@end

@implementation MainViewController {
    
    CBLReplication* _pull;
    CBLReplication* _push;
    NSError* _syncError;
}

-(id)init {
    self = [super init];
    if (self) {
        self.tableView = [[CardTableView alloc] initForAutoLayout];
        self.title = @"Words";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Words" image:[UIImage imageNamed:@"33-cabinet"] tag:0];
        self.tabBarItem.title = @"Words";
    }
    
    return self;
}

-(void)addTableView {
    [self.view addSubview:self.tableView];
    UIBind(self.tableView);
    [self.view addConstraintWithVisualFormat:@"H:|[tableView]|" bindings:BBindings];
    [self.view addConstraintWithVisualFormat:@"V:|[tableView]|" bindings:BBindings];
    [self startSync];
}

-(void)startSync {
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
- (void) replicationProgress: (NSNotificationCenter*)n {
    if (_pull.status == kCBLReplicationActive || _push.status == kCBLReplicationActive) {
        // Sync is active -- aggregate the progress of both replications and compute a fraction:
        unsigned completed = _pull.completedChangesCount + _push.completedChangesCount;
        unsigned total = _pull.changesCount+ _push.changesCount;
        NSLog(@"SYNC progress: %u / %u", completed, total);
        // Update the progress bar, avoiding divide-by-zero exceptions:
        //        progress.progress = (completed / (float)MAX(total, 1u));
    } else {
        // Sync is idle -- hide the progress bar and show the config button:
    }
    
    // Check for any change in error status and display new errors:
    NSError* error = _pull.lastError ? _pull.lastError : _push.lastError;
    if (error != _syncError) {
        _syncError = error;
        if (error)
            NSLog(@"Error syncing %@",error);
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTableView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


