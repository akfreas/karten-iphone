#import "Card.h"

typedef enum CardCellMode {
    CardCellModeDefinition,
    CardCellModeTerm
} CardCellMode;

@interface CardCell : UITableViewCell

@property (nonatomic, retain) NSDictionary *cardData;
@property (assign, nonatomic) CardCellMode mode;

-(void)flipMode;

@end
