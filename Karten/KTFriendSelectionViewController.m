#import "KTFriendSelectionViewController.h"
#import "KartenNetworkClient.h"
#import "FriendListSearchViewController.h"
#import "AccessoryViews.h"

#import "KTAPIGetUserFriends.h"
#import "KartenNetworkClient.h"

#import "User+Helpers.h"
#import "KTUser.h"
#import "FriendsListSearchUpdater.h"

static NSString *kFriendCellID = @"kFriendCellID";

@interface KTFriendSelectionViewController () <UITableViewDelegate,
                                        UISearchBarDelegate,
                                        UITableViewDataSource,
                                        UISearchResultsUpdating,
                                        NSFetchedResultsControllerDelegate>

@property (nonatomic) IBOutlet UITableView *friendTableView;
@property (nonatomic) IBOutlet UISearchController *searchController;
@property (nonatomic) KTUser *user;
@property (nonatomic) FriendListSearchViewController *searchDisplayViewController;
@property (nonatomic) FriendsListSearchUpdater *searchUpdater;
@property (nonatomic) NSFetchedResultsController *fetchController;

@property (nonatomic) NSMutableDictionary *friendSelection;
@end

@implementation KTFriendSelectionViewController

- (instancetype)initWithUser:(KTUser *)user
{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.user = user;
        self.searchUpdater = [FriendsListSearchUpdater new];
        self.searchDisplayViewController = [[FriendListSearchViewController alloc] init];
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchDisplayViewController];
        self.searchController.searchResultsUpdater = self;
        self.friendSelection = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendTableView.dataSource = self;
    self.friendTableView.delegate = self;
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.friendTableView.frame.size.width, 44.0f);
    self.searchController.searchBar.delegate = self;
    self.friendTableView.tableHeaderView = self.searchController.searchBar;
    [self setupFetchController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchFriends];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Accessors

- (void)setInitialSelection:(NSArray *)initialSelection
{
    _initialSelection = initialSelection;
    [initialSelection enumerateObjectsUsingBlock:^(KTUser *selectedUser, NSUInteger idx, BOOL *stop) {
        self.friendSelection[selectedUser.serverID] = @(YES);
    }];
}

- (BOOL)pinInitialSelectionToTop
{
    if ([self.initialSelection count] > 0 && _pinInitialSelectionToTop) {
        return YES;
    }
    return NO;
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

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(friendsList:didDeselectFriend:)]) {
        KTUser *friend = [self userAtIndexPath:indexPath];
        [self.delegate friendsList:self didDeselectFriend:friend];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KTUser *friend;
    if (indexPath.section == 0 && self.pinInitialSelectionToTop) {
        friend = self.initialSelection[indexPath.row];
    } else {
        NSIndexPath *mappedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        friend = [self userAtIndexPath:mappedIndexPath];
    }
    if ([self.friendSelection[friend.serverID] boolValue] == YES) {
        [self deselectFriend:friend];
    } else {
        [self selectFriend:friend];
    }
}

- (void)selectFriend:(KTUser *)friend
{
    self.friendSelection[friend.serverID] = @(YES);
    [self setPinnedFriend:friend selected:YES];
    NSIndexPath *fetchedIndexPath = [self.fetchController indexPathForObject:friend];
    UITableViewCell *cell = [self.friendTableView cellForRowAtIndexPath:[self globalIndexPathForFetchControllerIndexPath:fetchedIndexPath]];
    if (cell.accessoryView == nil) {
        cell.accessoryView = [[SharedAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
    }
    cell.accessoryView.hidden = NO;
    [self.delegate friendsList:self didSelectFriend:friend];
}

- (void)deselectFriend:(KTUser *)friend
{
    [self.friendSelection removeObjectForKey:friend.serverID];
    NSIndexPath *fetchedIndexPath = [self.fetchController indexPathForObject:friend];
    UITableViewCell *cell = [self.friendTableView cellForRowAtIndexPath:[self globalIndexPathForFetchControllerIndexPath:fetchedIndexPath]];
    cell.accessoryView.hidden = YES;
    [self setPinnedFriend:friend selected:NO];
    [self.delegate friendsList:self didDeselectFriend:friend];
}

- (void)setPinnedFriend:(KTUser *)friend selected:(BOOL)isSelected
{
    if (self.pinInitialSelectionToTop) {
        NSInteger initialSelectionIndex = [self.initialSelection indexOfObject:friend];
        if (initialSelectionIndex != NSNotFound) {
            UITableViewCell *cell = [self.friendTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:initialSelectionIndex inSection:0]];
            cell.accessoryView.hidden = isSelected == NO;
        }
        
    }
}

- (void)setupFetchController
{
    NSPredicate *pred;
    if (self.initialSelection != nil) {
        pred = [NSPredicate predicateWithFormat:@"(ANY friends = %@) AND (SELF <> %@)", self.user, self.user];
    } else {
        pred = [NSPredicate predicateWithFormat:@"ANY friends == %@", self.user];
    }
    self.fetchController = [KTUser MR_fetchAllSortedBy:@"serverID" ascending:YES withPredicate:pred groupBy:nil delegate:self];
}

- (KTUser *)userAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchController objectAtIndexPath:indexPath];
}

- (void)fetchFriends
{
    NSError *err = nil;
    [self.fetchController performFetch:&err];
    if (err) {
        DLog(@"Error fetching friends: %@", err);
    }
    KTAPIGetUserFriends *getFriendsCall = [[KTAPIGetUserFriends alloc] initWithUser:self.user];
    [KartenNetworkClient makeRequest:getFriendsCall
                          completion:^{
                              
                          } success:^(AFHTTPRequestOperation *operation, NSArray *friends) {
                              self.user.friends = [NSSet setWithArray:friends];
                              [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsedError) {
                              
                          }];
}

- (NSIndexPath *)globalIndexPathForFetchControllerIndexPath:(NSIndexPath *)indexPath
{
    return [NSIndexPath indexPathForRow:indexPath.row inSection:1];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    KTUser *friend;
    if (indexPath.section == 0 && self.pinInitialSelectionToTop) {
        friend = self.initialSelection[indexPath.row];
    } else {
        NSIndexPath *mappedIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        friend = [self.fetchController objectAtIndexPath:mappedIndex];
    }
    cell.accessoryView = [SharedAccessoryView new];
    if (([self.delegate respondsToSelector:@selector(friendsList:shouldSelectFriend:)] && [self.delegate friendsList:self shouldSelectFriend:friend]) || [self.initialSelection containsObject:friend]) {
        if ([self.dataSource respondsToSelector:@selector(friendsList:accessoryViewForUser:)]) {
            cell.accessoryView = [self.dataSource friendsList:self accessoryViewForUser:friend];
        }
        cell.accessoryView.hidden = NO;
    } else {
        cell.accessoryView.hidden = YES;
    }
    cell.textLabel.text = friend.username;
}

#pragma mark NSFetchedResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.friendTableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.friendTableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSIndexPath *adjustedIndexPath;
    NSIndexPath *adjustedNewIndexPath;
    
    if (self.pinInitialSelectionToTop) {
        adjustedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
        adjustedNewIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section + 1];
    } else {
        adjustedIndexPath = indexPath;
        adjustedNewIndexPath = newIndexPath;
    }
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.friendTableView insertRowsAtIndexPaths:@[adjustedNewIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self tableView:nil cellForRowAtIndexPath:adjustedIndexPath] atIndexPath:adjustedIndexPath];
            break;
        case NSFetchedResultsChangeDelete:
            [self.friendTableView deleteRowsAtIndexPaths:@[adjustedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        default:
            break;
    }
}

#pragma mark UITableView DataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:@selector(friendsList:titleForHeaderInSection:)]) {
        return [self.dataSource friendsList:self titleForHeaderInSection:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.pinInitialSelectionToTop) {
        NSInteger sub = [self.initialSelection count];
        if (section == 0) {
            return sub;
        } else {
            return [self.fetchController.sections[section - 1] numberOfObjects];
        }
    }
    return [self.fetchController.sections[section] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (self.pinInitialSelectionToTop) {
        return [self.fetchController.sections count] + 1;
    }
    return [self.fetchController.sections count];
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFriendCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

@end
