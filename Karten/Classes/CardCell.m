#import "CardCell.h"
#import "InfoDisplayView.h"

@interface CardCell ()

@property (nonatomic, retain) InfoDisplayView *termView;
@property (nonatomic, retain) NSMutableArray *constraintArray;

@end

@implementation CardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addDisplayViews];
        self.constraintArray = [NSMutableArray array];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addDisplayViews {
    self.termView = [InfoDisplayView new];
    [self.contentView addSubview:self.termView];

}


-(void)layoutSubviews {
    [super layoutSubviews];
}


-(void)updateConstraints {
    [self removeConstraintFromArray];
    [self configureLayoutConstraintsForView:self.termView];
    [super updateConstraints];
}

-(void)removeConstraintFromArray {
    if ([self.constraintArray count] > 0) {
        [self removeConstraints:self.constraintArray];
    }
}

-(void)configureLayoutConstraintsForView:(UIView *)view {
    UIBind(view);
    [self.constraintArray addObjectsFromArray:[self.contentView addConstraintWithVisualFormat:@"H:|-[view]-|" bindings:BBindings]];
    [self.constraintArray addObjectsFromArray:[self.contentView addConstraintWithVisualFormat:@"V:|[view]|" bindings:BBindings]];
}

#pragma mark Accessors

-(void)setCardData:(NSDictionary *)cardData {
    if (self.termView == nil) {
        [self addDisplayViews];
    }
    [self.termView setDisplayTextLeft:cardData[@"term"] right:cardData[@"definition"]];
}

@end
