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
#import "FriendPickerDelegate.h"

#import "KTAPICreateUser.h"
#import "KTAPILoginUser.h"

#import "Karten-Swift.h"

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
    FBFriendPickerViewController *friendPicker = [[FBFriendPickerViewController alloc] init];
    friendPicker.session = [FBSession activeSession];
    friendPicker.userID = [User mainUser].externalUserID;
    FriendPickerDelegate *delegate = [FriendPickerDelegate sharedInstance];
    delegate.stack = stack;
    friendPicker.delegate = delegate;
    [friendPicker loadData];
    [friendPicker clearSelection];
    [[self sharedInstance] presentViewController:friendPicker animated:YES completion:NULL];
}

+ (void)showLoginViewController
{
    LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    [loginController setLoginBlock:^(NSString *username, NSString *password) {
        
        KTAPILoginUser *loginUserAPI = [[KTAPILoginUser alloc] initWithUsername:username password:password];
        [KartenNetworkClient makeRequest:loginUserAPI
                              completion:^{
                                  
                              } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [KartenSessionManager setToken:responseObject[@"token"]];
                                  [[self sharedInstance] dismissViewControllerAnimated:YES completion:nil];
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                              }];
    }];
    [[self sharedInstance] presentViewController:loginController animated:NO completion:^{
        [[[self sharedInstance] navigationController] popToRootViewControllerAnimated:NO];
    }];
}

+ (void)pushViewController:(UIViewController *)viewController
{
    [[[self sharedInstance] navigationController] pushViewController:viewController animated:YES];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

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
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    }];
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
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    [self.view addSubview:self.stackListController.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkForValidSession];
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


@end
