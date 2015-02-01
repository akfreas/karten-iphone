@import UIKit;
@class KTUser;
@protocol KTFriendSelectionDelegate;
@protocol KTFriendSelectionDataSource;

@interface KTFriendSelectionViewController : UIViewController

@property (nonatomic) BOOL showSearchBar;
@property (nonatomic, weak) id<KTFriendSelectionDelegate> delegate;
@property (nonatomic, weak) id<KTFriendSelectionDataSource> dataSource;
@property (nonatomic) NSArray *initialSelection;
@property (nonatomic) BOOL pinInitialSelectionToTop;
- (instancetype)initWithUser:(KTUser *)user;

@end

@protocol KTFriendSelectionDelegate <NSObject>

@optional
- (void)friendsList:(KTFriendSelectionViewController *)friendsList didSelectFriend:(KTUser *)selectedFriend;
- (void)friendsList:(KTFriendSelectionViewController *)friendsList didDeselectFriend:(KTUser *)deselectedFriend;
- (BOOL)friendsList:(KTFriendSelectionViewController *)friendsList shouldSelectFriend:(KTUser *)user;
@end

@protocol KTFriendSelectionDataSource <NSObject>
@optional
- (UIView *)friendsList:(KTFriendSelectionViewController *)friendsList accessoryViewForUser:(KTUser *)user;
- (NSString *)friendsList:(KTFriendSelectionViewController *)friendsList titleForHeaderInSection:(NSInteger)section;

@end