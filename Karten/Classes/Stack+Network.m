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
        NSManagedObjectContext *ctx = [NSManagedObjectContext MR_contextForCurrentThread];
        NSMutableArray *allStacks = [NSMutableArray arrayWithArray:[Stack MR_findAllInContext:ctx]];
        for (Stack *stack in stacks) {
            [allStacks removeObject:stack];
        }
        for (Stack *deletedStack in allStacks) {
            [deletedStack MR_deleteInContext:ctx];
        }
        [ctx MR_saveOnlySelfAndWait];
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
