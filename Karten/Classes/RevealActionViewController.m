#import "RevealActionViewController.h"
#import "Karten-Swift.h"
#import "KartenUserManager.h"
#import "RevealControllerManager.h"

@interface RevealActionViewController ()
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
    // Do any additional setup after loading the view.
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

#pragma mark UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self logoutAction];
            break;
        default:
            break;
    }
}
@end
