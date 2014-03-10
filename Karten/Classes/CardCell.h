#import "Card.h"

typedef enum CardCellMode {
    CardCellModeDefinition,
    CardCellModeTerm
} CardCellMode;

@interface CardCell : UITableViewCell

@property (nonatomic, retain) Card *card;
@property (assign, nonatomic) CardCellMode mode;

-(void)flipMode;

@end
