@class Stack;

@interface MainViewController : UIViewController
+ (instancetype)sharedInstance;
+ (void)goToMainView;
+ (void)showQuizViewForStack:(Stack *)stack;
@end
