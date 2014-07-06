#import "FlashCardDisplayView.h"
@class Card;
@interface FlashCardAnswerView : UIView// <FlashCardDisplayView>
@property (nonatomic) BOOL editing;
@property (nonatomic, readwrite) Card *card;
@end
