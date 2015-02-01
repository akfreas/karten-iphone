#import "FlashCardView.h"
#import "FlashCardDisplayView.h"
#import "FlashCardQuestionView.h"


@interface FlashCardView ()

@property (nonatomic) FlashCardDisplayView *answerView;
@property (nonatomic) FlashCardDisplayView *questionView;
@property (nonatomic) NSMutableArray *constraintArray;
@property (nonatomic, weak) UIView *currentFlashView;
@end

@implementation FlashCardView

- (id)initWithFrame:(CGRect)frame card:(Card *)card options:(MDCSwipeToChooseViewOptions *)options mode:(FlashCardViewMode)mode
{
    self = [super initWithFrame:frame options:options];
    if (self) {
        self.card = card;
        self.currentMode = mode;
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
    [self createQuestionView];
    [self createAnswerView];
    if (self.currentMode == FlashCardViewShowDefinition) {
        self.currentFlashView = self.answerView;
    } else {
        self.currentFlashView = self.questionView;
    }
    [self addSubview:self.currentFlashView];
    [self setLayoutConstraints];
}

- (void)createAnswerView
{
    self.answerView = [[FlashCardDisplayView alloc] initForAutoLayout];
    [self.answerView setCard:self.card];
}

- (void)createQuestionView
{
    self.questionView = [[FlashCardDisplayView alloc] initForAutoLayout];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.card.term attributes:@{}];
    [self.questionView setCard:self.card];
}

- (void)setLayoutConstraints
{
    UIBind(self.currentFlashView);
    [self addConstraintWithVisualFormat:@"H:|-[currentFlashView]-|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|[currentFlashView]|" bindings:BBindings];
}
@end
