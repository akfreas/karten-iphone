#import "NetworkSyncUtil.h"
#import "KTStack.h"
#import "KTUser.h"
#import "User+Helpers.h"
#import "Stack+Network.h"
#import "KartenUserManager.h"

@implementation NetworkSyncUtil


+ (void)syncAllDataWithCompletion:(void (^)())completion
{
    KTUser *mainUser = [KTUser mainUser];
    if (mainUser != nil) {
        [KTStack syncStacksForUser:mainUser completion:^{
            if (completion)
                completion();
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsedError) {

        }];
        [KartenUserManager getCurrentAuthenticatedUserWithCompletion:^(KTUser *user) {
            
        } failure:^(NSError *err) {
            
        }];
     }
}

@end
