#import "CardListViewController.h"
#import "CardTableView.h"
#import "Stack.h"
#import "Stack+CouchBase.h"
#import "AddCardFormView.h"
#import <RNBlurModalView/RNBlurModalView.h>
#import "Card+Network.h"
#import "Card.h"

@interface CardListViewController ()
@property (nonatomic) CardTableView *tableView;
@property (nonatomic) RNBlurModalView *blurView;
@property (nonatomic) AddCardFormView *addCardView;
@end

@implementation CardListViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.tableView = [[CardTableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return self;
}

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
        AddCardFormView *addCardView;
        if (self.addCardView == nil) {
            addCardView = [[AddCardFormView alloc] initForAutoLayout];
        } else {
            addCardView = self.addCardView;
        }
        self.blurView = [[RNBlurModalView alloc] initWithParentView:self.view view:addCardView];
        [self.blurView hideCloseButton:YES];
        [addCardView setSaveButtonAction:^(id sender, Card *newCard) {
            [self.blurView hide];
            NSError *err = nil;
            [newCard addCardToStackOnServer:self.stack error:err];
        }];
        [self.blurView show];
    }];
}

- (void)setStack:(Stack *)stack
{
    self.tableView.stack = stack;
    [stack enqueueDatabaseForSyncing];
    [stack beginCouchDBSync];
}

- (Stack *)stack
{
    return self.tableView.stack;
}

@end
