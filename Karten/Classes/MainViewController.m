#import "MainViewController.h"
#import "FacebookLoginViewController.h"

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([FBSession.activeSession state] != FBSessionStateCreatedTokenLoaded) {
        FacebookLoginViewController *loginVC = [[FacebookLoginViewController alloc] init];
        [self presentViewController:loginVC animated:NO completion:NULL];
        
    }
}

@end
