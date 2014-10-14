@class FriendsListViewController;
@class User;

@protocol FriendsListDelegate <NSObject>

@optional
- (void)friendsList:(FriendsListViewController *)friendsList didSelectFriend:(User *)selectedFriend;
- (void)friendsList:(FriendsListViewController *)friendsList didDeselectFriend:(User *)deselectedFriend;
- (BOOL)friendsList:(FriendsListViewController *)friendsList shouldSelectFriend:(User *)user;
@end

@protocol FriendsListDataSource <NSObject>
@optional
- (UIView *)friendsList:(FriendsListViewController *)friendsList accessoryViewForUser:(User *)user;
- (NSString *)friendsList:(FriendsListViewController *)friendsList titleForHeaderInSection:(NSInteger)section;

@end