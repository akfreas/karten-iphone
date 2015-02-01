#import "KTProfileViewController.h"
#import "User+Helpers.h"
#import "KTUser.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface KTProfileViewController ()

@property (nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UIImageView *profilePicView;
@property (nonatomic) IBOutlet UIButton *addFriendButton;
@end

@implementation KTProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addFriendButton.hidden = self.showAddFriendButton == NO;
    [self configureForUser];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(KTUser *)user
{
    _user = user;
    [self configureForUser];
}

- (void)configureForUser
{
    self.usernameLabel.text = self.user.username;
    self.nameLabel.text = [self.user fullName];
    if (self.user.profilePicURL != nil) {
        [self.profilePicView setImageWithURL:[NSURL URLWithString:self.user.profilePicURL]];
    }
}


- (IBAction)addFriendButtonAction:(id)sender
{
    
}
@end
