#import "Card.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
@interface FlashCardView : MDCSwipeToChooseView

@property (nonatomic) Card *card;
- (id)initWithFrame:(CGRect)frame card:(Card *)card options:(MDCSwipeToChooseViewOptions *)options;
@end
