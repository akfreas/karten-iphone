#import "FriendsListDelegate.h"

@interface FriendListSearchViewController : UIViewController
@property (nonatomic) NSArray *resultDisplay;
@property (nonatomic, weak) id<FriendsListDelegate> delegate;
@end
