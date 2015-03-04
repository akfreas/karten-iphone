#import "KTFlashCardDisplayView.h"
@class Card;

@interface KTFlashCardDisplayView : UIView
@property (nonatomic) BOOL editing;
@property (nonatomic) NSAttributedString *mainText;
@property (nonatomic) NSAttributedString *supplementaryText;
@property (nonatomic) Card *card;
@end
