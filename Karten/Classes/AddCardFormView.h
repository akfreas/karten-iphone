@class Card;
@interface AddCardFormView : UIView

@property (nonatomic, copy) void(^cancelButtonAction)(id sender);
@property (nonatomic, copy) void(^saveButtonAction)(id sender, Card *newCard);
@end
