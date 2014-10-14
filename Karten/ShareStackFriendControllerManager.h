#import "FriendsListDelegate.h"
@class FriendsListViewController;
@class Stack;

@interface ShareStackFriendControllerManager : NSObject
@property (nonatomic) Stack *stack;
- (void)setFriendsListViewController:(FriendsListViewController *)friendsList forSharingStack:(Stack *)stack;

@end
