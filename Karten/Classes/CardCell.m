#import "CardCell.h"
#import "InfoDisplayView.h"

@interface CardCell ()

@property (nonatomic, retain) InfoDisplayView *definitionView;
@property (nonatomic, retain) InfoDisplayView *termView;
@property (nonatomic, weak) InfoDisplayView *currentView;
@property (nonatomic, retain) NSMutableArray *constraintArray;

@end

@implementation CardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addDisplayViews];
        self.mode = CardCellModeTerm;
        [self.contentView addSubview:self.currentView];
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
    self.definitionView = [[InfoDisplayView alloc] initForAutoLayout];
    self.termView = [[InfoDisplayView alloc] initForAutoLayout];
}

-(void)setMode:(CardCellMode)mode {
    if (mode == CardCellModeDefinition) {
        self.currentView = self.definitionView;
    } else if (mode == CardCellModeTerm) {
        self.currentView = self.termView;
    }
    _mode = mode;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

-(void)flipMode {
    InfoDisplayView *newView;
    CardCellMode newMode;
    if (self.mode == CardCellModeTerm) {
        newView = self.definitionView;
        newMode = CardCellModeDefinition;
    } else {
        newView = self.termView;
        newMode = CardCellModeTerm;
    }
    if (newView.superview == nil) {
        [self.contentView addSubview:newView];
    }
    [self configureLayoutConstraintsForView:newView];
    [UIView transitionFromView:self.currentView toView:newView duration:0.2f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        self.mode = newMode;
//        [self removeConstraintFromArray];
    }];
}

-(void)updateConstraints {
    [self removeConstraintFromArray];
    [self configureLayoutConstraintsForView:self.currentView];
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
    if (self.definitionView == nil || self.termView == nil) {
        [self addDisplayViews];
    }

    self.definitionView.displayText = cardData[@"definition"];
    self.termView.displayText = cardData[@"term"];
}

@end
