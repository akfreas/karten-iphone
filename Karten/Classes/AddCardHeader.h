@class Stack;

@interface AddCardHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) id<UISearchBarDelegate> delegate;
@property (nonatomic) Stack *stack;

@end
