#import "MainViewController.h"
#import "FacebookLoginViewController.h"
#import "StackListViewController.h"
#import "FacebookLoginViewController.h"
#import "User+Helpers.h"
#import <RNBlurModalView/RNBlurModalView.h>
#import "AddStackFormView.h"

@interface MainViewController ()
@property (nonatomic) UITabBarController *tabBarController;
@property (nonatomic) FacebookLoginViewController *loginViewController;
@property (nonatomic) StackListViewController *stackListController;
@property (nonatomic) RNBlurModalView *blurView;
@end

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setupStackListController];
        [self setupTabBarController];
        self.title = @"Karten";
        [self setupBarButton];
    }
    return self;
}


- (void)setupBarButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tabBarController.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkForFacebook];
}

- (void)setupStackListController
{
    self.stackListController = [StackListViewController new];
}

- (void)setupTabBarController
{
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[self.stackListController];
    [self addChildViewController:self.tabBarController];
}

- (void)checkForFacebook
{
    if ([[FBSession activeSession] state] != FBSessionStateOpen) {
        if ([[FBSession activeSession] state] == FBSessionStateCreated) {
            self.loginViewController = [FacebookLoginViewController new];
            [self presentViewController:self.loginViewController animated:NO completion:NULL];
        } else {
            [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"] allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if (status != FBSessionStateOpen) {
                    self.loginViewController = [FacebookLoginViewController new];
                    [self presentViewController:self.loginViewController animated:NO completion:NULL];
                } else {
                    self.stackListController.userForStacks = [User mainUser];
                }
            }];
        }
    }
}

@end
