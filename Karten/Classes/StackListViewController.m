#import "StackListViewController.h"
#import "StackListTableView.h"
#import "KTAPIGetUserStacks.h"
#import "KartenNetworkClient.h"
#import "Stack.h"
#import "Stack+Network.h"
#import "CardListViewController.h"


@interface StackListViewController () <UITableViewDelegate>
@property (nonatomic) StackListTableView *stackTableView;
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
    [self createTableView];
    [self addLayoutConstraints];
}

- (void)createTableView
{
    self.stackTableView = [[StackListTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.stackTableView.delegate = self;
    [self.view addSubview:self.stackTableView];
}

- (void)addLayoutConstraints
{
    UIBind(self.stackTableView);
    [self.view addConstraintWithVisualFormat:@"H:|[stackTableView]|" bindings:BBindings];
    [self.view addConstraintWithVisualFormat:@"V:|[stackTableView]|" bindings:BBindings];
}

- (void)fetchUsersStacks
{
    [Stack syncStacksForUser:self.userForStacks completion:NULL success:NULL failure:NULL];
}


#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Stack *stack = [self.stackTableView.fetchController objectAtIndexPath:indexPath];
    if (self.cardView == nil) {
        self.cardView = [[CardListViewController alloc] init];
    }
    self.cardView.stack = stack;
    [self.navigationController pushViewController:self.cardView animated:YES];
}

@end
