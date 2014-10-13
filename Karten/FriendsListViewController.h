@class User;
@interface FriendsListViewController : UIViewController

@property (nonatomic) BOOL showSearchBar;

- (instancetype)initWithUser:(User *)user;

@end
