@class KTStack;
@class KTCard;

@interface CardTableView : UITableView

@property (nonatomic, copy) void(^cardSelected)(KTCard *);
@property (nonatomic) KTStack *stack;
- (void)startUpdating;
@end
