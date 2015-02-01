#import "FriendSelectionDelegate.h"
@class User;
@interface KTFriendSelectionViewController : UIViewController

@property (nonatomic) BOOL showSearchBar;
@property (nonatomic, weak) id<FriendSelectionDelegate> delegate;
@property (nonatomic, weak) id<FriendSelectionDataSource> dataSource;
@property (nonatomic) NSArray *initialSelection;
@property (nonatomic) BOOL pinInitialSelectionToTop;
- (instancetype)initWithUser:(User *)user;

@end
