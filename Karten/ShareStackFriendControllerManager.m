#import "ShareStackFriendControllerManager.h"
#import "FriendsListViewController.h"
#import "KartenNetworkClient.h"

#import "KTAPIShareStack.h"
#import "KTAPIUnShareStack.h"

#import "Stack.h"
#import "User.h"
#import "User+Helpers.h"

@interface ShareStackFriendControllerManager () <FriendsListDataSource, FriendsListDelegate>
@property (nonatomic) NSArray *initialSelection;
@end

@implementation ShareStackFriendControllerManager

- (void)setFriendsListViewController:(FriendsListViewController *)friendsList forSharingStack:(Stack *)stack
{
    self.stack = stack;
    friendsList.pinInitialSelectionToTop = YES;
    self.initialSelection = friendsList.initialSelection = [User MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"(serverID IN %@) AND (SELF <> %@)", self.stack.allowedUserServerIDs, [User mainUser]]];
    friendsList.delegate = self;
    friendsList.dataSource = self;
}

#pragma mark FriendsListDataSource

- (NSString *)friendsList:(FriendsListViewController *)friendsList titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [self.initialSelection count] > 0) {
        return @"Shared Users";
    }
    return @"All Friends";
}

#pragma mark FriendsListDelegate

- (void)friendsList:(FriendsListViewController *)friendsList didSelectFriend:(User *)selectedFriend
{
    KTAPIShareStack *shareStack = [[KTAPIShareStack alloc] initWithStack:self.stack shareUsers:@[selectedFriend]];
    [KartenNetworkClient makeRequest:shareStack
                          completion:^{
                              
                          } success:^(AFHTTPRequestOperation *operation, NSArray *allowedUsers) {
                              
                              NSMutableSet *users = [NSMutableSet set];
                              for (User *allowedUser in allowedUsers) {
                                  [users addObject:allowedUser.serverID];
                              }
                              
                              self.stack.allowedUserServerIDs = users;
                              [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsedError) {
                              
                          }];
}

- (void)friendsList:(FriendsListViewController *)friendsList didDeselectFriend:(User *)deselectedFriend
{
    
    KTAPIUnShareStack *shareStack = [[KTAPIUnShareStack alloc] initWithStack:self.stack unShareUsers:@[deselectedFriend]];
    [KartenNetworkClient makeRequest:shareStack
                          completion:^{
                              
                          } success:^(AFHTTPRequestOperation *operation, NSArray *allowedUsers) {
                              
                              NSMutableSet *users = [NSMutableSet set];
                              for (User *allowedUser in allowedUsers) {
                                  [users addObject:allowedUser.serverID];
                              }
                              
                              self.stack.allowedUserServerIDs = users;
                              [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsederror) {
                              
                          }];
}

@end
