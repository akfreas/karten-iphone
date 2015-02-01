#import "Stack+Network.h"
#import "KTAPIGetUserStacks.h"
#import "KTAPICreateStack.h"
#import "KartenNetworkClient.h"
#import "KTAPIRemoveStack.h"
@implementation Stack (Network)
+ (void)syncStacksForUser:(KTUser *)user
                     completion:(KartenNetworkCompletion)completion
                        success:(KartenNetworkSuccess)success
                        failure:(KartenNetworkFailure)failure
{
    KTAPIGetUserStacks *userStackCall = [[KTAPIGetUserStacks alloc] initWithUser:user];
    [KartenNetworkClient makeRequest:userStackCall completion:completion success:^(AFHTTPRequestOperation *operation, NSArray *stacks) {
        NSManagedObjectContext *ctx = [NSManagedObjectContext MR_defaultContext];
        [ctx performBlockAndWait:^{
            NSMutableArray *allStacks = [NSMutableArray arrayWithArray:[Stack MR_findAllInContext:ctx]];
            if ([allStacks count] == 0) {
                if (success == NULL) {
                    return;
                }
                success(operation, nil);
                return;
            }
            for (Stack *stack in stacks) {
                [allStacks removeObject:stack];
            }
            for (Stack *deletedStack in allStacks) {
                [deletedStack MR_deleteInContext:ctx];
            }
            if ([allStacks count] > 0) {
                [ctx MR_saveOnlySelfAndWait];
            }
            if (success) {
                success(operation, stacks);
            }
        }];
    } failure:failure];
}

- (void)createStackOnServerWithCompletion:(KartenNetworkCompletion)completion success:(KartenNetworkSuccess)success failure:(KartenNetworkFailure)failure
{
    KTAPICreateStack *createStackCall = [[KTAPICreateStack alloc] initWithStack:self];
    [KartenNetworkClient makeRequest:createStackCall completion:completion
                             success:success
                             failure:failure];
}

- (void)removeMyStackOnServerWithCompletion:(KartenNetworkCompletion)completion success:(KartenNetworkSuccess)success failure:(KartenNetworkFailure)failure
{
    KTAPIRemoveStack *removeStack = [[KTAPIRemoveStack alloc] initWithStack:self];
    [KartenNetworkClient makeRequest:removeStack
                          completion:completion
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [self MR_deleteInContext:self.managedObjectContext];
                                 [self.managedObjectContext MR_saveOnlySelfAndWait];
                                 success(operation, responseObject);
                             } failure:failure];
}
@end
