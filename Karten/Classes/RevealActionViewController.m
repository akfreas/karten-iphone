#import "RevealActionViewController.h"
#import "Karten-Swift.h"
#import "KartenUserManager.h"
#import "RevealControllerManager.h"
#import "CircleImageView.h"
#import "MainViewController.h"
#import "User.h"
#import "User+Helpers.h"

@interface RevealActionViewController ()
@property (nonatomic) IBOutlet UIView *circleImageView;
@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) CircleImageView *imageView;
@end

@implementation RevealActionViewController

- (instancetype)init
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"Main"];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[CircleImageView alloc] initWithImage:[UIImage imageNamed:@"Request"] radius:self.circleImageView.frame.size.height/2.0f];
    [self.circleImageView addSubview:self.imageView];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *nameString = [NSString stringWithFormat:@"%@ %@", [User mainUser].firstName, [User mainUser].lastName];
    self.nameLabel.text = nameString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logoutAction
{
    [[RevealControllerManager sharedRevealController] revealToggleAnimated:NO];
    [KartenUserManager logoutCurrentUser];
}

- (void)showFriendListController
{
    [[RevealControllerManager sharedRevealController] revealToggleAnimated:YES];
    [MainViewController showFriendListController];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            [self showFriendListController];
            break;
        case 2:
            [self logoutAction];
            break;
        default:
            break;
    }
}
@end
