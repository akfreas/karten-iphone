#import "FacebookLoginViewController.h"
#import "FacebookSessionManager.h"
#import "NetworkSyncUtil.h"

@interface FacebookLoginViewController () <FBLoginViewDelegate>
@property (nonatomic) FBLoginView *loginButton;
@end

@implementation FacebookLoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createLoginButton];
    [self addLayoutConstraints];
}

#pragma mark Private Methods

- (void)createLoginButton
{
    self.loginButton = [[FBLoginView alloc] initForAutoLayout];
    self.loginButton.delegate = self;
    [self.loginButton setReadPermissions:@[@"public_profile", @"user_friends"]];
    [self.view addSubview:self.loginButton];
    
}

- (void)addLayoutConstraints
{
    UIBind(self.loginButton);
    [self.view addConstraintWithVisualFormat:@"H:|-[loginButton]-|" bindings:BBindings];
    [self.view addConstraintWithVisualFormat:@"V:[loginButton(44)]" bindings:BBindings];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loginButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    FBSession *session = [FBSession activeSession];
    [[FacebookSessionManager sharedInstance] sessionStateChanged:session state:session.state error:nil];
    [[FacebookSessionManager sharedInstance] createUserFromFacebookSession:^(User *user, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NetworkSyncUtil syncAllDataWithCompletion:NULL];
            [self dismissViewControllerAnimated:YES completion:NULL];
        });
    }];
}

@end
