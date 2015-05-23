#import "CardTableView.h"
#import "CardCell.h"
#import "KTCard.h"
#import "Card+Helpers.h"
#import "Database.h"
#import "CouchManager.h"
#import "KTStack.h"
#import "Stack+CouchBase.h"
#import "CardEditViewController.h"

@interface CardTableView () <NSFetchedResultsControllerDelegate,  CBLUITableDelegate, UISearchBarDelegate>

@property (strong) CBLDatabase *database;
@property (strong) CBLUITableSource *cbDatasource;
@property (strong) NSIndexPath *flippedIndexPath;
@end

@implementation CardTableView

static NSString *kCellReuseID = @"CardCell";
static NSString *kHeaderReuseID = @"HeaderCell";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerClass:[CardCell class] forCellReuseIdentifier:@"CBLUITableDelegate"];
        self.delegate = self;
    }
    return self;
}

- (void)startUpdating
{
    [self.cbDatasource reloadFromQuery];
    [self reloadData];
}

- (void (^)(KTCard *))cardSelected
{
    if (_cardSelected == NULL) {
        _cardSelected = ^(KTCard *c){};
    }
    return _cardSelected;
}

- (void)setStack:(KTStack *)stack
{
    self.cbDatasource = [[CBLUITableSource alloc] init];
    _stack = stack;
    Database *db = [CouchManager databaseForStack:stack];
    CBLLiveQuery *query = [[[db.couchDatabase viewNamed:@"byDate"] createQuery] asLiveQuery];
    query.descending = YES;
    self.cbDatasource.query = query;
    self.cbDatasource.tableView = self;
    self.cbDatasource.labelProperty = nil;
    self.dataSource = self.cbDatasource;
}

#pragma mark CBUITableSource

-(void)couchTableSource:(CBLUITableSource *)source willUseCell:(UITableViewCell *)cell forRow:(CBLQueryRow *)row {
    cell.textLabel.text = nil;
    [(CardCell *)cell setCardData:row.value];
}


#pragma mark NSFetchedResultsController Delegate Methods

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self endUpdates];
}
#pragma mark UITableView Helpers


#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KTCard *selectedCard = [KTCard getOrCreateCardWithCouchDBQueryRow:[self.cbDatasource rowAtIndexPath:indexPath] inContext:self.stack.managedObjectContext];
    self.cardSelected(selectedCard);
}

#pragma mark UITableView Datasource

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    self.cbDatasource.query.keys = @[@"a"];
//    [self.cbDatasource reloadFromQuery];
//    [self reloadData];
}

#pragma mark UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
