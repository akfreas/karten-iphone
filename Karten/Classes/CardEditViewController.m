#import "CardEditViewController.h"
#import "KTFlashCardDisplayView.h"
#import "KTCard.h"
#import "Card+Network.h"
#import "Karten-Swift.h"


@interface CardEditViewController ()
@property (nonatomic) KTFlashCardDisplayView *flashDisplay;
@property (nonatomic) KTCard *card;
@property (nonatomic) KTSpeechSynth *speechSynth;
@property (nonatomic) UIButton *speakButton;
@end

@implementation CardEditViewController


- (id)init
{
    self = [super init];
    if (self) {
        [self createflashDisplay];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.speechSynth = [[KTSpeechSynth alloc] init];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"Save" style:UIBarButtonItemStyleDone handler:^(id sender) {
            KTCard *editedCard = self.flashDisplay.card;
            [editedCard.managedObjectContext MR_saveToPersistentStoreAndWait];
            NSError *err = nil;
            [editedCard updateCardOnCouch:&err];
            if (err) {
                NSLog(@"Error updating card on couch! %@", err);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    return self;
}

- (void)setCard:(KTCard *)card
{
    _card = card;
    [self.flashDisplay setCard:card];
}

- (void)createflashDisplay
{
    self.flashDisplay = [KTFlashCardDisplayView new];
    self.flashDisplay.editing = YES;
    [self.view addSubview:self.flashDisplay];
}

- (void)addLayoutConstraints
{
    UIBind(self.flashDisplay);
    [self.view addConstraintWithVisualFormat:@"H:|[flashDisplay]|" bindings:BBindings];
    [self.view addConstraintWithVisualFormat:@"V:|[flashDisplay]-(45)-|" bindings:BBindings];
}


- (void)setupSpeakButton
{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:@"🔊" forState:UIControlStateNormal];
    [button bk_addEventHandler:^(id sender) {
        [self speakCard];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:button aboveSubview:self.flashDisplay];
    UIBind(button);
    [self.view addConstraintWithVisualFormat:@"H:|-[button(45)]" bindings:BBindings];
    [self.view addConstraintWithVisualFormat:@"V:[button(45)]-|" bindings:BBindings];
    self.speakButton = button;
}

- (void)speakCard
{
    [self.speechSynth speak:self.card.term];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createflashDisplay];
    [self setupSpeakButton];
    [self addLayoutConstraints];
}

@end
