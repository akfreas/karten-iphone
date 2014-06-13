@class Stack;

@interface CardTableView : UITableView

@property (nonatomic) Stack *stack;
- (void)startUpdating;
@end
