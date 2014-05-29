@class Stack;
@interface AddStackFormView : UIView

@property (nonatomic, copy) void(^cancelButtonAction)(id sender);
@property (nonatomic, copy) void(^saveButtonAction)(id sender, Stack *newStack);
@end
