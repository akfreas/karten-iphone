#import "AppDelegate.h"
#import "MainViewController.h"
#import "NetworkSyncUtil.h"
#import "FacebookSessionManager.h"
#import "KTRevealControllerManager.h"
#import "KTRevealActionViewController.h"
#import <SWRevealViewController/SWRevealViewController.h>

#import "CardCell.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    CardCell *cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nil"];
//    [cell setCardData:@{@"term" : @"Testing one cell", @"definition": @"Definition field"}];
//    cell.frame = CGRectMake(0, 0, self.window.frame.size.width, 44.0f);
//    [self.window addSubview:cell];
//    return YES;
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Karten.sqlite"];
    KTRevealActionViewController *actionController = [KTRevealActionViewController new];
    SWRevealViewController *mainController = [KTRevealControllerManager sharedRevealController];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[MainViewController sharedInstance]];
    [self configureAppearance];
    mainController.frontViewController = controller;
    mainController.rearViewController = actionController;
    self.mainViewController = mainController;
    [controller.navigationBar setBarStyle:UIBarStyleBlack];
    self.window.rootViewController = self.mainViewController;
    return YES;
}

- (void)configureAppearance
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#40988D"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:[FacebookSessionManager sharedInstance].session];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [[FacebookSessionManager sharedInstance] sessionStateChanged:session state:state error:error];
     }];
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}


@end
