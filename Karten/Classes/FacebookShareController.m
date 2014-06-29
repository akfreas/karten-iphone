#import "FacebookShareController.h"
#import "FacebookSessionManager.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookShareController () <FBFriendPickerDelegate>
@property (nonatomic) FBFriendPickerViewController *friendPicker;
@end

@implementation FacebookShareController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendPicker = [[FBFriendPickerViewController alloc] init];
    self.friendPicker.session = [FBSession activeSession];
    self.friendPicker.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];   
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.friendPicker updateView];
    [self.friendPicker presentModallyFromViewController:self animated:NO handler:^(FBViewController *sender, BOOL donePressed) {
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
