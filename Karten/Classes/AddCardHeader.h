@class KTStack;

@interface AddCardHeader : UITableViewHeaderFooterView

@property (nonatomic, weak) id<UISearchBarDelegate> delegate;
@property (nonatomic) KTStack *stack;

@end
