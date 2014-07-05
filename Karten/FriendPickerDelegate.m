#import "FriendPickerDelegate.h"
#import "KTAPIAddUserToStack.h"
#import "KartenNetworkClient.h"

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

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    
    __block NSInteger operationCount = 0;
    for (id<FBGraphUser> facebookUser in self.friendSelection) {
        operationCount++;
            KTAPIAddUserToStack *addUserCall = [[KTAPIAddUserToStack alloc] initWithStack:self.stack linkToUserID:facebookUser.objectID];
        [KartenNetworkClient makeRequest:addUserCall completion:^{
            operationCount--;
            if (operationCount == 0) {
                [[MainViewController sharedInstance] dismissViewControllerAnimated:YES completion:NULL];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
           
    }
}
@end
