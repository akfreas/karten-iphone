#import "LoginViewController.h"
#import "FormEntryTableViewCell.h"
#import "ButtonActionTableViewCell.h"
#import "KTAPILoginUser.h"
#import "KartenNetworkClient.h"
#import "Karten-Swift.h"
#import "KTAPIGetUser.h"
#import "User.h"
#import "KartenUserManager.h"
#import "SignUpViewController.h"
#import <RNBlurModalView/RNBlurModalView.h>
@interface LoginViewController ()
@property (nonatomic) IBOutlet UITextField *usernameTextField;
@property (nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic) IBOutlet SignUpViewController *signUpController;

@property (nonatomic) RNBlurModalView *modalView;
@end

@implementation LoginViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F2EA"];
    
    typeof(&*self) weakself = self;
    [self.signUpController setValidationErrorAction:^(UIAlertController *alert) {
        [weakself presentViewController:alert animated:YES completion:nil];
    }];
    [self.signUpController setCloseButtonAction:^{
        [weakself.modalView hide];
    }];
    [self.signUpController setSignUpSuccessAction:[self successActionBlock]];
    
    [self.usernameTextField setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
        [weakself.passwordTextField becomeFirstResponder];
        return YES;
    }];
    
    [self.passwordTextField setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
        [textField resignFirstResponder];
        [weakself loginAction:textField];
        return YES;
    }];
    
    [self.view bk_whenTapped:^{
        [self.view endEditing:YES];
    }];
    
    [super viewDidLoad];
}

- (void(^)(User *, NSString *))successActionBlock
{
    return ^(User *newUser, NSString *password) {
        [KartenUserManager logUserInWithUsername:newUser.username password:password completion:^(User *user) {
              [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSError *err) {
            
        }];
    };
}

- (void)loginUser:(User *)user
{
    
}

- (IBAction)signUpAction:(id)sender
{
    [self.signUpController reset];
    RNBlurModalView *blurView = [[RNBlurModalView alloc] initWithParentView:self.view view:self.signUpController];
    [blurView hideCloseButton:YES];
    [blurView show];
    self.modalView = blurView;
}

- (IBAction)loginAction:(id)sender
{
    
    if (self.usernameTextField.text == nil || self.passwordTextField.text == nil) {
        [self showInvalidUsernamePasswordComboAlert];
        return;
    }
    [KartenUserManager logUserInWithUsername:self.usernameTextField.text password:self.passwordTextField.text completion:^(User *user) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } failure: ^(NSError *err){
        [self showInvalidUsernamePasswordComboAlert];
    }];
}

- (void)showInvalidUsernamePasswordComboAlert
{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Your username and password are invalid! Please try again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}


@end


