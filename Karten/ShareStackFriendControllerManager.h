@class KTFriendSelectionViewController;
@class KTStack;

@interface ShareStackFriendControllerManager : NSObject
@property (nonatomic) KTStack *stack;
- (void)setFriendsListViewController:(KTFriendSelectionViewController *)friendsList forSharingStack:(KTStack *)stack;

@end
