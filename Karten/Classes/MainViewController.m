#import "MainViewController.h"
#import "FacebookLoginViewController.h"
#import "StackListViewController.h"
#import "FacebookLoginViewController.h"
#import "User+Helpers.h"
#import <RNBlurModalView/RNBlurModalView.h>
#import "AddStackFormView.h"
#import "Stack.h"
#import "Stack+Network.h"
#import "NetworkSyncUtil.h"

@interface MainViewController ()
@property (nonatomic) UITabBarController *tabBarController;
@property (nonatomic) FacebookLoginViewController *loginViewController;
@property (nonatomic) StackListViewController *stackListController;
@property (nonatomic) RNBlurModalView *blurView;
@property (nonatomic) AddStackFormView *addStackForm;
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
        AddStackFormView *addStackView;
        if (self.addStackForm == nil) {
            addStackView = [[AddStackFormView alloc] initForAutoLayout];
            self.addStackForm = addStackView;
        } else {
            addStackView = self.addStackForm;
        }
        self.blurView = [[RNBlurModalView alloc] initWithParentView:self.view view:self.addStackForm];
        [self.blurView hideCloseButton:YES];
        [addStackView setCancelButtonAction:^(id sender) {
            [self.blurView hide];
        }];
        [addStackView setSaveButtonAction:^(id sender, Stack *newStack) {
            [newStack createStackOnServerWithCompletion:^{
                [self.blurView hide];
            } success:^(AFHTTPRequestOperation *operation, Stack *responseObject) {
                [responseObject.managedObjectContext MR_saveOnlySelfAndWait];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSManagedObjectContext *ctx = [NSManagedObjectContext MR_contextForCurrentThread];
                Stack *ourStack = (Stack *)[ctx objectWithID:newStack.objectID];
                [ourStack MR_deleteInContext:ctx];
                [ctx MR_saveOnlySelfAndWait];
            }];
        }];
        [self.blurView show];
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
                    [NetworkSyncUtil syncAllDataWithCompletion:^{
                    }];
                    self.stackListController.userForStacks = [User mainUser];
                }
            }];
        }
    }
}

@end
