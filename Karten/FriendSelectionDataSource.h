@class User;
@interface FriendSelectionDataSource : NSObject <UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
- (instancetype)initWithUser:(User *)user;
- (void)fetchFriends;

@end
