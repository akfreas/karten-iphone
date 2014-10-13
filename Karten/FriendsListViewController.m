#import "FriendsListViewController.h"
#import "KartenNetworkClient.h"
#import "FriendsListDataSource.h"
#import "FriendListSearchViewController.h"

#import "User+Helpers.h"
#import "User.h"
#import "FriendsListSearchUpdater.h"

@interface FriendsListViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic) IBOutlet UITableView *friendTableView;
@property (nonatomic) IBOutlet UISearchController *searchController;
@property (nonatomic) User *user;
@property (nonatomic) FriendsListDataSource *friendDataSource;
@property (nonatomic) FriendListSearchViewController *searchDisplayViewController;
@property (nonatomic) FriendsListSearchUpdater *searchUpdater;
@end

@implementation FriendsListViewController

- (instancetype)initWithUser:(User *)user
{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.user = user;
        self.searchUpdater = [FriendsListSearchUpdater new];
        self.friendDataSource = [[FriendsListDataSource alloc] initWithUser:self.user];
        self.searchDisplayViewController = [[FriendListSearchViewController alloc] init];
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchDisplayViewController];
        self.searchController.searchResultsUpdater = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendTableView.dataSource = self.friendDataSource;
    self.friendDataSource.tableView = self.friendTableView;
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.friendTableView.frame.size.width, 44.0f);
    self.searchController.searchBar.delegate = self;
    self.friendTableView.tableHeaderView = self.searchController.searchBar;
    [self.friendDataSource fetchFriends];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchDisplayViewController.resultDisplay = @[];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] > 3) {
        [self.searchUpdater searchForUsernameWithString:searchText completionBlock:^(NSArray *array) {
            self.searchDisplayViewController.resultDisplay = array;
        }];
    } else {
        self.searchDisplayViewController.resultDisplay = @[];
    }
}

#pragma mark UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    return;
    NSString *query = searchController.searchBar.text;
    if ([query length] > 3) {
        [self.searchUpdater searchForUsernameWithString:query completionBlock:^(NSArray *array) {
            self.searchDisplayViewController.resultDisplay = array;
        }];
    }
}

@end
