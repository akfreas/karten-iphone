@class KTFriendSelectionViewController;
@class User;

@protocol FriendSelectionDelegate <NSObject>

@optional
- (void)friendsList:(KTFriendSelectionViewController *)friendsList didSelectFriend:(User *)selectedFriend;
- (void)friendsList:(KTFriendSelectionViewController *)friendsList didDeselectFriend:(User *)deselectedFriend;
- (BOOL)friendsList:(KTFriendSelectionViewController *)friendsList shouldSelectFriend:(User *)user;
@end

@protocol FriendSelectionDataSource <NSObject>
@optional
- (UIView *)friendsList:(KTFriendSelectionViewController *)friendsList accessoryViewForUser:(User *)user;
- (NSString *)friendsList:(KTFriendSelectionViewController *)friendsList titleForHeaderInSection:(NSInteger)section;

@end