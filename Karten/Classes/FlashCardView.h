#import "Card.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>


typedef enum {
    FlashCardViewShowTerm,
    FlashCardViewShowDefinition,
} FlashCardViewMode;

@interface FlashCardView : MDCSwipeToChooseView

@property (nonatomic) Card *card;
@property (nonatomic, assign) FlashCardViewMode currentMode;

- (id)initWithFrame:(CGRect)frame card:(Card *)card options:(MDCSwipeToChooseViewOptions *)options mode:(FlashCardViewMode)mode;

@end
