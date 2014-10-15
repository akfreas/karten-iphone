@class User;

@interface SignUpViewController : UIView

@property (nonatomic, copy) void(^signUpSuccessAction)(User *newUser, NSString *password);
@property (nonatomic, copy) void(^validationErrorAction)(UIAlertController *alertController);
@property (nonatomic, copy) void(^closeButtonAction)();
- (void)reset;


@end
