@interface StackActionTableViewCell : UITableViewCell
@property (nonatomic) NSString *displayName;
@property (nonatomic, copy) void(^tappedAction)();
@end
