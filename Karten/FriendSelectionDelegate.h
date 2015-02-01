@class KTFriendSelectionViewController;
@class KTUser;

@protocol FriendSelectionDelegate <NSObject>

@optional
- (void)friendsList:(KTFriendSelectionViewController *)friendsList didSelectFriend:(KTUser *)selectedFriend;
- (void)friendsList:(KTFriendSelectionViewController *)friendsList didDeselectFriend:(KTUser *)deselectedFriend;
- (BOOL)friendsList:(KTFriendSelectionViewController *)friendsList shouldSelectFriend:(KTUser *)user;
@end

@protocol FriendSelectionDataSource <NSObject>
@optional
- (UIView *)friendsList:(KTFriendSelectionViewController *)friendsList accessoryViewForUser:(KTUser *)user;
- (NSString *)friendsList:(KTFriendSelectionViewController *)friendsList titleForHeaderInSection:(NSInteger)section;

@end