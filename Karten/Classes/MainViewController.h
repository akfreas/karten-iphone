@class KTStack;

@interface MainViewController : UIViewController
+ (instancetype)sharedInstance;
+ (void)goToMainView;
+ (void)pushViewController:(UIViewController *)viewController;
+ (void)showActionViewForStack:(KTStack *)stack;
+ (void)showQuizViewForCards:(NSArray *)cards;
+ (void)showCardListForStack:(KTStack *)stack;
+ (void)showShareControllerForStack:(KTStack *)stack;
+ (void)showFriendListController;
@end
