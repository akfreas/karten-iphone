#import "Stack+Network.h"
#import "KTAPIGetUserStacks.h"
#import "KTAPICreateStack.h"
#import "KartenNetworkClient.h"

@implementation Stack (Network)
+ (void)syncStacksForUser:(User *)user
                     completion:(KartenNetworkCompletion)completion
                        success:(KartenNetworkSuccess)success
                        failure:(KartenNetworkFailure)failure
{
    KTAPIGetUserStacks *userStackCall = [[KTAPIGetUserStacks alloc] initWithUser:user];
    [KartenNetworkClient makeRequest:userStackCall completion:completion success:^(AFHTTPRequestOperation *operation, NSArray *stacks) {
        for (Stack *stack in stacks) {
            [stack.managedObjectContext MR_saveOnlySelfAndWait];
        }
        if (success) {
            success(operation, stacks);
        }
    } failure:failure];
}

- (void)createStackOnServerWithCompletion:(KartenNetworkCompletion)completion success:(KartenNetworkSuccess)success failure:(KartenNetworkFailure)failure
{
    KTAPICreateStack *createStackCall = [[KTAPICreateStack alloc] initWithStack:self];
    [KartenNetworkClient makeRequest:createStackCall completion:completion
                             success:success
                             failure:failure];
}
@end
