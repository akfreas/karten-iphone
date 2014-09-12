#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (nonatomic, copy) void(^loginBlock)(NSString *username, NSString *password);
@end
