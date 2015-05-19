@class Stack;
@class KTCard;

@interface CardTableView : UITableView

@property (nonatomic, copy) void(^cardSelected)(KTCard *);
@property (nonatomic) Stack *stack;
- (void)startUpdating;
@end
