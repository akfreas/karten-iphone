@class Stack;

@interface MainViewController : UIViewController
+ (instancetype)sharedInstance;
+ (void)goToMainView;
+ (void)pushViewController:(UIViewController *)viewController;
+ (void)showActionViewForStack:(Stack *)stack;
+ (void)showQuizViewForCards:(NSArray *)cards;
+ (void)showCardListForStack:(Stack *)stack;
+ (void)showShareControllerForStack:(Stack *)stack;
+ (void)showFriendListController;
@end
