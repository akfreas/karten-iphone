#import "StackListViewController.h"
#import "StackCollectionView.h"
#import "KTAPIGetUserStacks.h"
#import "KartenNetworkClient.h"
#import "Stack.h"
#import "Stack+Network.h"
#import "CardListViewController.h"


@interface StackListViewController () <UICollectionViewDelegate>
@property (nonatomic) StackCollectionView *stackCollectionView;
@property (nonatomic) CardListViewController *cardView;
@end

@implementation StackListViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark Accessors

- (void)setUserForStacks:(User *)userForStacks
{
    _userForStacks = userForStacks;
    [self fetchUsersStacks];
}

#pragma mark - Private Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createCollectionView];
    [self addLayoutConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self fetchUsersStacks];
}

- (void)createCollectionView
{
    self.stackCollectionView = [[StackCollectionView alloc] initWithFrame:CGRectZero];
    self.stackCollectionView.clipsToBounds = NO;
    [self.stackCollectionView setStackSelectedAction:^(Stack *selectedStack) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ExitDeletionModeNotification object:nil userInfo:nil];
        [MainViewController showActionViewForStack:selectedStack];
    }];
    [self.view addSubview:self.stackCollectionView];
}



- (void)addLayoutConstraints
{
    UIBind(self.stackCollectionView);
    [self.view addConstraintWithVisualFormat:@"H:|-(15)-[stackCollectionView]-(15)-|" bindings:BBindings];
    [self.view addConstraintWithVisualFormat:@"V:|-(15)-[stackCollectionView]-(15)-|" bindings:BBindings];
}

- (void)fetchUsersStacks
{
    [Stack syncStacksForUser:self.userForStacks completion:NULL success:NULL failure:NULL];
}


#pragma mark UITableViewDelegate Methods

@end
