#import "FriendsListDelegate.h"
@class User;
@interface FriendsListViewController : UIViewController

@property (nonatomic) BOOL showSearchBar;
@property (nonatomic, weak) id<FriendsListDelegate> delegate;
@property (nonatomic, weak) id<FriendsListDataSource> dataSource;
@property (nonatomic) NSArray *initialSelection;
@property (nonatomic) BOOL pinInitialSelectionToTop;
- (instancetype)initWithUser:(User *)user;

@end
