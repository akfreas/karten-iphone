#import "ProfileViewController.h"
#import "User+Helpers.h"
#import "KTUser.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileViewController ()

@property (nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UIImageView *profilePicView;
@property (nonatomic) IBOutlet UIButton *addFriendButton;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addFriendButton.hidden = self.showAddFriendButton == NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(KTUser *)user
{
    _user = user;
    self.usernameLabel.text = user.username;
    self.nameLabel.text = [user fullName];
    if (user.profilePicURL != nil) {
        [self.profilePicView setImageWithURL:[NSURL URLWithString:user.profilePicURL]];
    }
}


- (IBAction)addFriendButtonAction:(id)sender
{
    
}
@end
