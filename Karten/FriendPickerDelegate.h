
@interface FriendPickerDelegate : NSObject <FBFriendPickerDelegate, FBViewControllerDelegate>
+ (instancetype)sharedInstance;
@property (nonatomic) Stack *stack;
@end
