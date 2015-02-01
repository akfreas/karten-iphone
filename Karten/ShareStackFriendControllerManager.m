#import "ShareStackFriendControllerManager.h"
#import "KTFriendSelectionViewController.h"
#import "KartenNetworkClient.h"

#import "KTAPIShareStack.h"
#import "KTAPIUnShareStack.h"

#import "Stack.h"
#import "KTUser.h"
#import "User+Helpers.h"

@interface ShareStackFriendControllerManager () <FriendSelectionDataSource, FriendSelectionDelegate>
@property (nonatomic) NSArray *initialSelection;
@end

@implementation ShareStackFriendControllerManager

- (void)setFriendsListViewController:(KTFriendSelectionViewController *)friendsList forSharingStack:(Stack *)stack
{
    self.stack = stack;
    friendsList.pinInitialSelectionToTop = YES;
    self.initialSelection = friendsList.initialSelection = [KTUser MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"(serverID IN %@) AND (SELF <> %@)", self.stack.allowedUserServerIDs, [KTUser mainUser]]];
    friendsList.delegate = self;
    friendsList.dataSource = self;
}

#pragma mark FriendSelectionDataSource

- (NSString *)friendsList:(KTFriendSelectionViewController *)friendsList titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [self.initialSelection count] > 0) {
        return @"Shared Users";
    }
    return @"All Friends";
}

#pragma mark FriendSelectionDelegate

- (void)friendsList:(KTFriendSelectionViewController *)friendsList didSelectFriend:(KTUser *)selectedFriend
{
    KTAPIShareStack *shareStack = [[KTAPIShareStack alloc] initWithStack:self.stack shareUsers:@[selectedFriend]];
    [KartenNetworkClient makeRequest:shareStack
                          completion:^{
                              
                          } success:^(AFHTTPRequestOperation *operation, NSArray *allowedUsers) {
                              
                              NSMutableSet *users = [NSMutableSet set];
                              for (KTUser *allowedUser in allowedUsers) {
                                  [users addObject:allowedUser.serverID];
                              }
                              
                              self.stack.allowedUserServerIDs = users;
                              [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsedError) {
                              
                          }];
}

- (void)friendsList:(KTFriendSelectionViewController *)friendsList didDeselectFriend:(KTUser *)deselectedFriend
{
    
    KTAPIUnShareStack *shareStack = [[KTAPIUnShareStack alloc] initWithStack:self.stack unShareUsers:@[deselectedFriend]];
    [KartenNetworkClient makeRequest:shareStack
                          completion:^{
                              
                          } success:^(AFHTTPRequestOperation *operation, NSArray *allowedUsers) {
                              
                              NSMutableSet *users = [NSMutableSet set];
                              for (KTUser *allowedUser in allowedUsers) {
                                  [users addObject:allowedUser.serverID];
                              }
                              
                              self.stack.allowedUserServerIDs = users;
                              [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsederror) {
                              
                          }];
}

@end
