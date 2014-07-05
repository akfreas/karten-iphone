#import "QuizViewController.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "FlashCardView.h"
#import "Database.h"
#import "FlashCardStackFinishedView.h"

@interface QuizViewController () <MDCSwipeToChooseDelegate>

@property (nonatomic) FlashCardView *frontCardView;
@property (nonatomic) FlashCardView *backCardView;
@property (nonatomic) NSMutableArray *wordArray;

@end

@implementation QuizViewController


- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Quiz";
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.frontCardView = [self popFlashCardViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    self.backCardView = [self popFlashCardViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];

}

- (void)setQuizCards:(NSArray *)quizCards
{
    _quizCards = quizCards;
    self.wordArray = [quizCards mutableCopy];
}

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {

}

// This is called then a user swipes the view fully left or right.
- (void)view:(FlashCardView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    
    if (direction == MDCSwipeDirectionLeft) {
        view.card.knowledgeScore = @([view.card.knowledgeScore integerValue] - 1);
    } else if (direction == MDCSwipeDirectionRight) {
        view.card.knowledgeScore = @([view.card.knowledgeScore integerValue] + 1);
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popFlashCardViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

- (UIView *)popFlashCardViewWithFrame:(CGRect)frame
{
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 120.0f;
    options.likedText = @"KNOW";
    options.nopeText = @"NOPE";
    options.onPan = ^(MDCPanState *state) {
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    UIView *currentView;
    if ([self.wordArray count] > 0) {
        currentView = [[FlashCardView alloc] initWithFrame:frame card:self.wordArray[0] options:options];
        [self.wordArray removeObjectAtIndex:0];
    } else {
        currentView = [[FlashCardStackFinishedView alloc] initWithFrame:frame];
    }
    return currentView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 80.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}


@end
