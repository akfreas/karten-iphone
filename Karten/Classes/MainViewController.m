#import "MainViewController.h"
#import "FacebookLoginViewController.h"
#import "StackListViewController.h"
#import "FacebookLoginViewController.h"
#import "User+Helpers.h"
#import "AddStackFormView.h"
#import "Stack.h"
#import "Stack+Network.h"
#import "NetworkSyncUtil.h"
#import "QuizViewController.h"
#import "StackActionViewController.h"
#import "CardListViewController.h"
#import "FacebookShareController.h"
#import "FacebookSessionManager.h"
#import <BlocksKit/UIBarButtonItem+BlocksKit.h>
#import "KartenUserManager.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Karten-Swift.h"
#import "NotificationKeys.h"
#import "RevealControllerManager.h"
#import "KTFriendSelectionViewController.h"
#import "ShareStackViewController.h"



@interface MainViewController ()
@property (nonatomic) UITabBarController *tabBarController;
@property (nonatomic) FacebookLoginViewController *loginViewController;
@property (nonatomic) StackListViewController *stackListController;
@property (nonatomic) AddStackFormView *addStackForm;
@property (nonatomic) BOOL stackFormViewShown;
@end

static MainViewController *sharedInstance;

@implementation MainViewController


+ (void)goToMainView
{
    [[[self sharedInstance] navigationController] popToRootViewControllerAnimated:YES];
}

+ (void)pushViewController:(UIViewController *)viewController
{
    [[[self sharedInstance] navigationController] pushViewController:viewController animated:YES];
}

+ (void)showActionViewForStack:(Stack *)stack
{
    StackActionViewController *actionViewController = [[StackActionViewController alloc] init];
    actionViewController.stack = stack;
    [self pushViewController:actionViewController];
}

+ (void)showQuizViewForCards:(NSArray *)cards
{
    QuizViewController *quizListView = [[QuizViewController alloc] init];
    quizListView.quizCards = cards;
    [self pushViewController:quizListView];
}

+ (void)showCardListForStack:(Stack *)stack
{
    CardListViewController *cardList = [CardListViewController new];
    cardList.stack = stack;
    [self pushViewController:cardList];
}

+ (void)showShareControllerForStack:(Stack *)stack
{
    [self showFriendListController];
//    ShareStackViewController *friendPicker = [ShareStackViewController new];
//    [self pushViewController:friendPicker];
}

+ (void)showLoginViewController
{
    [[self sharedInstance] showLoginViewController];
}

+ (void)showFriendListController
{
    KTFriendSelectionViewController *controller = [[KTFriendSelectionViewController alloc] initWithUser:[User mainUser]];
    [self pushViewController:controller];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark Public

- (id)init
{
    self = [super init];
    if (self) {
        [self setupStackListController];
        [self setupTabBarController];
        self.title = @"Karten";
        [self addNotificationObservers];
        [self setupBarButton];
    }
    return self;
}

- (void)showLoginViewController
{
    LoginViewController *loginController = [[LoginViewController alloc] init];
    [loginController setLoginBlock:^(NSString *username, NSString *password) {
        [KartenUserManager logUserInWithUsername:username password:password completion:^(User *user) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSError *user) {
            UIAlertView *alert = [[UIAlertView alloc] bk_initWithTitle:@"Whoops!"
                                                               message:@"Your username and password combination is incorrect."];
            [alert bk_addButtonWithTitle:@"OK" handler:nil];
            [alert show];
        }];
    }];
    [self presentViewController:loginController animated:NO completion:^{
        [[self navigationController] popToRootViewControllerAnimated:NO];
    }];
}

#pragma mark Private

- (void)addNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewController) name:kKartenUserDidLogoutNotification object:nil];
}

- (void)removeNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupBarButton
{
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22.0f, 22.0f)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton bk_addEventHandler:^(id sender) {
        UIAlertView *addStackAlertView = [[UIAlertView alloc] bk_initWithTitle:@"Add Stack" message:@"Add Stack"];
        addStackAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[NSNotificationCenter defaultCenter] postNotificationName:ExitDeletionModeNotification object:nil];
        [addStackAlertView bk_addButtonWithTitle:@"Save" handler:^{
            UITextField *textField = [addStackAlertView textFieldAtIndex:0];
            if ([textField.text isEqualToString:@""]) {
                UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"Please enter a name for your stack"];
                [alert addButtonWithTitle:@"OK"];
                [alert show];
                return;
            }
            Stack *newStack = [Stack MR_createEntity];
            newStack.name = textField.text;
            newStack.ownerServerID = [[User mainUser] serverID];
            newStack.creationDate = [NSDate date];
            [newStack createStackOnServerWithCompletion:^{
                
            } success:^(AFHTTPRequestOperation *operation, Stack *responseObject) {
                [responseObject.managedObjectContext MR_saveOnlySelfAndWait];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsedError) {
                NSManagedObjectContext *ctx = [NSManagedObjectContext MR_contextForCurrentThread];
                Stack *ourStack = (Stack *)[ctx objectWithID:newStack.objectID];
                [ourStack MR_deleteInContext:ctx];
                [ctx MR_saveOnlySelfAndWait];
            }];
        }];
        [addStackAlertView addButtonWithTitle:@"Cancel"];
        [addStackAlertView setCancelButtonIndex:1];
        [addStackAlertView show];
        //        [self createAddStackFormView];
        //        if (self.stackFormViewShown == YES) {
        //            [self hideAddStackFormView];
        //        } else {
        //            [self showAddStackFormView];
        //        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *barButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [barButton setBackgroundImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
    //    barButton.contentEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f , 10.0f);
    //    barButton.contentMode = uiviewcontentmodeac;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    [barButton bk_addEventHandler:^(id sender) {
        [[RevealControllerManager sharedRevealController] revealToggleAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    item.customView = barButton;
    self.navigationItem.leftBarButtonItem = item;
}

- (void)createAddStackFormView
{
    if (self.addStackForm == nil) {
        self.addStackForm = [[AddStackFormView alloc] initForAutoLayout];;
    }
    [self.addStackForm setSaveButtonAction:^(id sender, Stack *newStack) {
        [newStack createStackOnServerWithCompletion:^{
            
        } success:^(AFHTTPRequestOperation *operation, Stack *responseObject) {
            [responseObject.managedObjectContext MR_saveOnlySelfAndWait];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsedError) {
            NSManagedObjectContext *ctx = [NSManagedObjectContext MR_contextForCurrentThread];
            Stack *ourStack = (Stack *)[ctx objectWithID:newStack.objectID];
            [ourStack MR_deleteInContext:ctx];
            [ctx MR_saveOnlySelfAndWait];
        }];
    }];
    
}

- (void)hideAddStackFormView
{
    
}

- (void)showAddStackFormView
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.stackListController.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self checkForValidSession];
    [super viewWillAppear:animated];
}

- (void)setupStackListController
{
    self.stackListController = [StackListViewController new];
}

- (void)setupTabBarController
{
    //    self.tabBarController = [[UITabBarController alloc] init];
    //    self.tabBarController.viewControllers = @[self.stackListController];
    [self addChildViewController:self.stackListController];
}

- (void)checkForValidSession
{
    if ([KartenSessionManager isSessionValid]) {
        [NetworkSyncUtil syncAllDataWithCompletion:^{
            
        }];
    } else {
        [[self class] showLoginViewController];
    }
}

- (void)dealloc
{
    [self removeNotificationObservers];
}


@end
