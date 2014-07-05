#import "CardEditViewController.h"
#import "FlashCardAnswerView.h"

@interface CardEditViewController ()
@property (nonatomic) FlashCardAnswerView *flashDisplay;
@end

@implementation CardEditViewController


- (id)init
{
    self = [super init];
    if (self) {
        [self createflashDisplay];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"Save" style:UIBarButtonItemStyleDone handler:^(id sender) {
            
        }];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    return self;
}

- (void)setCard:(Card *)card
{
    [self.flashDisplay setCard:card];
    [self.flashDisplay setNeedsUpdateConstraints];
}

- (void)createflashDisplay
{
    self.flashDisplay = [[FlashCardAnswerView alloc] initForAutoLayout];
    self.flashDisplay.editing = YES;
    [self.view addSubview:self.flashDisplay];
}

- (void)addLayoutConstraints
{
    UIBind(self.flashDisplay);
    [self.view addConstraintWithVisualFormat:@"H:|[flashDisplay]|" bindings:BBindings];
    [self.view addConstraintWithVisualFormat:@"V:|[flashDisplay]|" bindings:BBindings];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createflashDisplay];
    [self addLayoutConstraints];
}

@end
