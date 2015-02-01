@class KTUser;

@interface SignUpViewController : UIView

@property (nonatomic, copy) void(^signUpSuccessAction)(KTUser *newUser, NSString *password);
@property (nonatomic, copy) void(^validationErrorAction)(UIAlertController *alertController);
@property (nonatomic, copy) void(^closeButtonAction)();
- (void)reset;


@end
