#import "FlashCardDisplayView.h"
@class Card;

@interface FlashCardDisplayView : UIView
@property (nonatomic) BOOL editing;
@property (nonatomic) NSAttributedString *mainText;
@property (nonatomic) NSAttributedString *supplementaryText;
@property (nonatomic) Card *card;
@end
