#import "KTFlashCardDisplayView.h"
@class KTCard;

@interface KTFlashCardDisplayView : UIView
@property (nonatomic) BOOL editing;
@property (nonatomic) NSAttributedString *mainText;
@property (nonatomic) NSAttributedString *supplementaryText;
@property (nonatomic) KTCard *card;
@end
