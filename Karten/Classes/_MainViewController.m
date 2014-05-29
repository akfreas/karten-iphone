#import "_MainViewController.h"
#import "CardTableView.h"
#import "CouchManager.h"

@interface _MainViewController ()

@property (nonatomic, retain) CardTableView *tableView;

@end

@implementation _MainViewController

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
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTableView];
    [CouchManager startSync:NULL];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


