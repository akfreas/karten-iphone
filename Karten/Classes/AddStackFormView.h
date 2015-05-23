@class KTStack;
@interface AddStackFormView : UIView

@property (nonatomic, copy) void(^cancelButtonAction)(id sender);
@property (nonatomic, copy) void(^saveButtonAction)(id sender, KTStack *newStack);
@end
