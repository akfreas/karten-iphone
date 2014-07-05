@class Stack;
@class Card;

@interface CardTableView : UITableView

@property (nonatomic, copy) void(^cardSelected)(Card *);
@property (nonatomic) Stack *stack;
- (void)startUpdating;
@end
