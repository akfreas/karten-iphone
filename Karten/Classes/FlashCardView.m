#import "FlashCardView.h"
#import "FlashCardAnswerView.h"
#import "FlashCardQuestionView.h"


typedef enum {
    FlashCardViewShowTerm,
    FlashCardViewShowDefinition,
} FlashCardViewMode;

@interface FlashCardView ()

@property (nonatomic) FlashCardAnswerView *answerView;
@property (nonatomic) FlashCardQuestionView *questionView;
@property (nonatomic) NSMutableArray *constraintArray;
@property (nonatomic, weak) UIView *currentFlashView;
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
    
    UIView *previousLabel = self.currentFlashView;
    self.currentMode = self.currentMode == FlashCardViewShowDefinition ? FlashCardViewShowTerm : FlashCardViewShowDefinition;
    self.currentFlashView = self.currentMode == FlashCardViewShowDefinition ? self.answerView : self.questionView;
    if (self.currentFlashView.superview == nil) {
        [self addSubview:self.currentFlashView];
    }
    [self.currentFlashView layoutIfNeeded];
    [self setNeedsUpdateConstraints];
    [UIView transitionFromView:previousLabel toView:self.currentFlashView duration:0.3f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
    }];
}

- (void)updateConstraints
{
    [self removeConstraintsFromArray];
    [self configureLayoutConstraintsForView:self.currentFlashView];
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
    self.answerView = [[FlashCardAnswerView alloc] initForAutoLayout];
    [self.answerView setCard:self.card];
}

- (void)addCardLabel
{
    self.questionView = [[FlashCardQuestionView alloc] initForAutoLayout];
    [self.questionView setCard:self.card];
    [self addSubview:self.questionView];
    self.currentFlashView = self.questionView;
}

- (void)setLayoutConstraints
{
    UIBind(self.currentFlashView);
    [self addConstraintWithVisualFormat:@"H:|-[currentFlashView]-|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|[currentFlashView]|" bindings:BBindings];
}
@end
