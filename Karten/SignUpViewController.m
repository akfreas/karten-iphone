#import "SignUpViewController.h"
#import "KTAPICreateUser.h"
#import "KartenNetworkClient.h"

#import "User.h"

@interface SignUpViewController ()

@property (nonatomic) IBOutlet UITextField *usernameField;
@property (nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic) IBOutlet UITextField *emailField;

@end

@implementation SignUpViewController

- (void)reset
{
    self.usernameField.text = nil;
    self.passwordField.text = nil;
    self.emailField.text = nil;
}

- (void)showAlertForInvalidEntry
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hey!" message:@"All fields are required."  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:action];
    self.validationErrorAction(alert);
}

- (IBAction)closeButtonAction:(id)sender
{
    self.closeButtonAction();
}

- (IBAction)signUpAction:(id)sender
{
    User *newUser = [User MR_createEntity];
    newUser.username = self.usernameField.text;
    newUser.emailAddress = self.emailField.text;
    KTAPICreateUser *createUser = [[KTAPICreateUser alloc] initWithUser:newUser password:self.passwordField.text];
    
    [KartenNetworkClient makeRequest:createUser
                          completion:^{
                            
                          } success:^(AFHTTPRequestOperation *operation, User *responseObject) {
                              self.signUpSuccessAction(responseObject, self.passwordField.text);
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [self showAlertForInvalidEntry];
                          }];
}

@end
