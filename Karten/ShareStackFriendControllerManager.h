#import "FriendSelectionDelegate.h"
@class KTFriendSelectionViewController;
@class Stack;

@interface ShareStackFriendControllerManager : NSObject
@property (nonatomic) Stack *stack;
- (void)setFriendsListViewController:(KTFriendSelectionViewController *)friendsList forSharingStack:(Stack *)stack;

@end
