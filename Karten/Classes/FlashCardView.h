#import "KTCard.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>


typedef enum {
    FlashCardViewShowTerm,
    FlashCardViewShowDefinition,
} FlashCardViewMode;

@interface FlashCardView : MDCSwipeToChooseView

@property (nonatomic) KTCard *card;
@property (nonatomic, assign) FlashCardViewMode currentMode;

- (id)initWithFrame:(CGRect)frame card:(KTCard *)card options:(MDCSwipeToChooseViewOptions *)options mode:(FlashCardViewMode)mode;

@end
