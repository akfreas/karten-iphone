#import "FriendPickerDelegate.h"


static FriendPickerDelegate *sharedInstance;

@interface FriendPickerDelegate () 
@property (nonatomic) NSMutableArray *friendSelection;
@end

@implementation FriendPickerDelegate

+ (instancetype)sharedInstance
{
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    self.friendSelection = [friendPicker.selection mutableCopy];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    [[MainViewController sharedInstance] dismissViewControllerAnimated:YES completion:NULL];
}

@end
