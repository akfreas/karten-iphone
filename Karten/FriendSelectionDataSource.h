@class KTUser;
@interface KTFriendSelectionDataSource : NSObject <UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
- (instancetype)initWithUser:(KTUser *)user;
- (void)fetchFriends;

@end
