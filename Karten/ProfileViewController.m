#import "ProfileViewController.h"
#import "User+Helpers.h"
#import "User.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileViewController ()

@property (nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UIImageView *profilePicView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(User *)user
{
    _user = user;
    self.usernameLabel.text = user.username;
    self.nameLabel.text = [user fullName];
    if (user.profilePicURL != nil) {
        [self.profilePicView setImageWithURL:[NSURL URLWithString:user.profilePicURL]];
    }
}

@end
