#import "FlashCardView.h"

typedef enum {
    FlashCardViewShowTerm,
    FlashCardViewShowDefinition,
} FlashCardViewMode;

@interface FlashCardView ()

@property (nonatomic) UILabel *termLabel;
@property (nonatomic) UILabel *definitionLabel;
@property (nonatomic) NSMutableArray *constraintArray;
@property (nonatomic, weak) UILabel *currentLabel;
@property (nonatomic, assign) FlashCardViewMode currentMode;
@end

@implementation FlashCardView

- (id)initWithFrame:(CGRect)frame card:(Card *)card options:(MDCSwipeToChooseViewOptions *)options
{
    self = [super initWithFrame:frame options:options];
    if (self) {
        self.card = card;
        self.constraintArray = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *re = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flip)];
        [self addGestureRecognizer:re];
        [self configureUIComponents];
    }
    return self;
}

- (void)flip
{
    
    UIView *previousLabel = self.currentLabel;
    self.currentMode = self.currentMode == FlashCardViewShowDefinition ? FlashCardViewShowTerm : FlashCardViewShowDefinition;
    self.currentLabel = self.currentMode == FlashCardViewShowDefinition ? self.definitionLabel : self.termLabel;
    if (self.currentLabel.superview == nil) {
        [self addSubview:self.currentLabel];
    }
    [UIView transitionFromView:previousLabel toView:self.currentLabel duration:0.4f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        [self setNeedsUpdateConstraints];
    }];
}

- (void)updateConstraints
{
    [self removeConstraintsFromArray];
    [self configureLayoutConstraintsForView:self.currentLabel];
    [super updateConstraints];
}

- (void)removeConstraintsFromArray
{
    if ([self.constraintArray count] > 0) {
        [self removeConstraints:self.constraintArray];
    }
}

-(void)configureLayoutConstraintsForView:(UIView *)view {
    UIBind(view);
    [self.constraintArray addObjectsFromArray:[self addConstraintWithVisualFormat:@"H:|-[view]-|" bindings:BBindings]];
    [self.constraintArray addObjectsFromArray:[self addConstraintWithVisualFormat:@"V:|[view]|" bindings:BBindings]];
}

- (void)configureUIComponents
{
    [self addCardLabel];
    [self addDefinitionLabel];
    [self setLayoutConstraints];
}

- (void)addDefinitionLabel
{
    self.definitionLabel = [[UILabel alloc] initForAutoLayout];
    self.definitionLabel.text  = self.card.definition;
    self.definitionLabel.font = [UIFont systemFontOfSize:26.0f];
    self.definitionLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)addCardLabel
{
    self.termLabel = [[UILabel alloc] initForAutoLayout];
    self.termLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.card.term, self.card.knowledgeScore];
    self.termLabel.font = [UIFont systemFontOfSize:26.0f];
    self.termLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.termLabel];
    self.currentLabel = self.termLabel;
}

- (void)setLayoutConstraints
{
    UIBind(self.currentLabel);
    [self addConstraintWithVisualFormat:@"H:|-[currentLabel]-|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|[currentLabel]|" bindings:BBindings];
}
@end
