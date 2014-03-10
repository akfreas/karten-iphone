#import "MainViewController.h"
#import "CardTableView.h"

@interface MainViewController ()

@property (nonatomic, retain) CardTableView *tableView;

@end

@implementation MainViewController

-(id)init {
    self = [super init];
    if (self) {
        self.tableView = [[CardTableView alloc] initForAutoLayout];
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


