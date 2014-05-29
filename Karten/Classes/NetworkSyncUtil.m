#import "NetworkSyncUtil.h"
#import "Stack.h"
#import "User.h"
#import "User+Helpers.h"
#import "Stack+Network.h"

@implementation NetworkSyncUtil


+ (void)syncAllDataWithCompletion:(void (^)())completion
{
    User *mainUser = [User mainUser];
    if (mainUser != nil) {
        [Stack syncStacksForUser:mainUser completion:^{
            if (completion)
                completion();
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        }];
     }
}

@end
