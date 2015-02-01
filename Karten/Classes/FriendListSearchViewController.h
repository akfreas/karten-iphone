#import "FriendSelectionDelegate.h"

@interface FriendListSearchViewController : UIViewController
@property (nonatomic) NSArray *resultDisplay;
@property (nonatomic, weak) id<FriendSelectionDelegate> delegate;
@end
