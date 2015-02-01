#import "CardListViewController.h"
#import "CardEditViewController.h"
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
@property (nonatomic) NSLayoutConstraint *layoutGuideTableViewConstraint;
@property (nonatomic) NSMutableArray *animatableCardFormConstraints;
@property (nonatomic) NSLayoutConstraint *layoutGuideAddCardFormViewConstraint;
@property (nonatomic) UIImageView *plusExView;
@property (nonatomic) UIView *plusContainer;
@property (nonatomic) BOOL addCardViewShown;
@end

@implementation CardListViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.addCardViewShown = NO;
        [self createTableView];
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.addCardViewShown) {
        [self hideAddCardFormView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView startUpdating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self addLayoutConstraints];
    self.plusExView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plus_button"]];
    self.plusContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
    [self.plusContainer bk_whenTouches:1 tapped:1 handler:^{
        if (self.addCardView == nil) {
            [self createAddCardFormView];
        }
        if (self.addCardViewShown) {
            [self hideAddCardFormView];
        } else {
            [self showAddCardFormView];
        }
    }];
    [self.plusContainer addSubview:self.plusExView];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
    }];
    [item setCustomView:self.plusContainer];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewDidLayoutSubviews
{
    self.plusExView.frame = CGRectInset(self.plusContainer.bounds, 12.0f, 12.0f);
}

- (void)setStack:(Stack *)stack
{
    self.tableView.stack = stack;
    self.title = stack.name;
}

- (void)createTableView
{
    self.tableView = [[CardTableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.tableView setCardSelected:^(Card *selectedCard) {
        CardEditViewController *editController = [[CardEditViewController alloc] init];
        [editController setCard:selectedCard];
        [self.navigationController pushViewController:editController animated:YES];
    }];
}

- (Stack *)stack
{
    return self.tableView.stack;
}

- (void)createAddCardFormView
{
    if (self.addCardView != nil) {
        return;
    }
    AddCardFormView *addCardView = [AddCardFormView new];
    [addCardView setCancelButtonAction:^(id sender) {
        [self hideAddCardFormView];
    }];
    [addCardView setSaveButtonAction:^(id sender, Card *newCard) {
        NSError *err = nil;
        [newCard addCardToStackOnServer:self.stack error:&err];
        if (err != nil) {
            DLog(@"Error saving card to couch! %@", newCard);
        }
    }];
    self.addCardView = addCardView;
}

- (void)showAddCardFormView
{
    [self.view addSubview:self.addCardView];
    self.animatableCardFormConstraints = [NSMutableArray array];
    [self.view removeConstraint:self.layoutGuideTableViewConstraint];
    UIBind(self.topLayoutGuide, self.addCardView, self.tableView);
    [self.animatableCardFormConstraints addObjectsFromArray:[self.view addConstraintWithVisualFormat:@"H:|[addCardView]|" bindings:BBindings]];
//    [self.view layoutIfNeeded];
    self.layoutGuideAddCardFormViewConstraint = [NSLayoutConstraint constraintWithItem:self.addCardView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    [self.animatableCardFormConstraints addObjectsFromArray:[self.view addConstraintWithVisualFormat:@"V:[addCardView][tableView]" bindings:BBindings]];
    [self.view addConstraint:self.layoutGuideAddCardFormViewConstraint];
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
        self.plusExView.transform = CGAffineTransformMakeRotation((M_PI/180)*45.0f);
    } completion:^(BOOL finished) {
        self.addCardViewShown = YES;
    }];
}

- (void)hideAddCardFormView
{
    [self.view removeConstraint:self.layoutGuideAddCardFormViewConstraint];
    NSLayoutConstraint *animatableConstraint = [NSLayoutConstraint constraintWithItem:self.addCardView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    [self.view addConstraint:animatableConstraint];
    [UIView animateWithDuration:0.2f animations:^{
        [self.view layoutIfNeeded];
        self.plusExView.transform = CGAffineTransformMakeRotation(0.0f);
    } completion:^(BOOL finished) {
        [self.view removeConstraint:animatableConstraint];
        [self.view removeConstraints:self.animatableCardFormConstraints];
        [self.view addConstraint:self.layoutGuideTableViewConstraint];
        [self.addCardView removeFromSuperview];
        [self.view layoutIfNeeded];
        self.addCardViewShown = NO;
    }];
    
}

- (void)addLayoutConstraints
{
    UIBind(self.tableView, self.topLayoutGuide);
    [self.view addConstraintWithVisualFormat:@"H:|[tableView]|" bindings:BBindings];
    [self.view addConstraintWithVisualFormat:@"V:|[topLayoutGuide]" bindings:BBindings];
    [self.view addConstraintWithVisualFormat:@"V:[tableView]|" bindings:BBindings];
    self.layoutGuideTableViewConstraint = [NSLayoutConstraint constraintWithItem:self.topLayoutGuide attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    [self.view addConstraint:self.layoutGuideTableViewConstraint];
}

@end
