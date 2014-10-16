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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    typeof(&*self) weakself = self;
    [self.usernameField setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
        [weakself.passwordField becomeFirstResponder];
        return YES;
    }];
    [self.passwordField setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
        [weakself.emailField becomeFirstResponder];
        return YES;
    }];
    [self.emailField setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
        [weakself signUpAction:textField];
        return YES;
    }];
}

- (void)reset
{
    self.usernameField.text = nil;
    self.passwordField.text = nil;
    self.emailField.text = nil;
}

- (void)showAlertForInvalidEntryWithError:(NSDictionary *)err
{
    
    NSMutableString *errorString = [NSMutableString new];
    NSArray *keys = [err allKeys];
    NSInteger last = [keys count] - 1;
    for (int i=0; i<[keys count]; i++) {
        NSString *key = keys[i];
        [errorString appendFormat:@"%@:", [key capitalizedString]];
        NSArray *errors = err[key];
        for (NSString *error in errors) {
            [errorString appendFormat:@" %@ ", error];
        }
        if (i != last)
            [errorString appendFormat:@"\n"];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hey!" message:errorString  preferredStyle:UIAlertControllerStyleAlert];
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
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsedError) {
                              [self showAlertForInvalidEntryWithError:parsedError];
                          }];
}

@end
