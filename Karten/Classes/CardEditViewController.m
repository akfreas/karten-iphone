#import "CardEditViewController.h"
#import "FlashCardDisplayView.h"
#import "Card.h"
#import "Card+Network.h"


@interface CardEditViewController ()
@property (nonatomic) FlashCardDisplayView *flashDisplay;
@property (nonatomic) Card *card;
@end

@implementation CardEditViewController


- (id)init
{
    self = [super init];
    if (self) {
        [self createflashDisplay];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"Save" style:UIBarButtonItemStyleDone handler:^(id sender) {
            Card *editedCard = self.flashDisplay.card;
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

- (void)setCard:(Card *)card
{
    _card = card;
    [self.flashDisplay setCard:card];
}

- (void)createflashDisplay
{
    self.flashDisplay = [[FlashCardDisplayView alloc] initForAutoLayout];
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
