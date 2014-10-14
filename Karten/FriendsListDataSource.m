#import "FriendsListDataSource.h"
#import "User.h"
#import "KTAPIGetUserFriends.h"
#import "KartenNetworkClient.h"
static NSString *kFriendCellID = @"kFriendCellID";

@interface FriendsListDataSource () <NSFetchedResultsControllerDelegate>
@property (nonatomic) User *user;
@property (nonatomic) NSFetchedResultsController *fetchController;
@end

@implementation FriendsListDataSource

#pragma mark - Public Methods

- (instancetype)initWithUser:(User *)user
{
    self = [super init];
    if (self) {
        self.user = user;
        [self setupFetchController];
    }
    return self;
}

- (User *)userAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchController objectAtIndexPath:indexPath];
}

#pragma mark - Private Methods

- (void)setupFetchController
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"ANY friends == %@", self.user];
    self.fetchController = [User MR_fetchAllSortedBy:@"serverID" ascending:YES withPredicate:pred groupBy:nil delegate:self];
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
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              
                          }];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    User *friend = [self.fetchController objectAtIndexPath:indexPath];
    cell.textLabel.text = friend.username;
}

#pragma mark NSFetchedResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self tableView:nil cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        default:
            break;
    }
}

#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchController.sections[section] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
