#import "CardTableView.h"
#import "CardCell.h"
#import "AddCardHeader.h"
#import "Card.h"
#import "Database.h"

@interface CardTableView () <NSFetchedResultsControllerDelegate,  CBLUITableDelegate>

@property (retain, nonatomic) NSFetchedResultsController *fetchController;
@property (strong) CBLDatabase *database;
@property (strong) CBLUITableSource *cbDatasource;
@end

@implementation CardTableView

static NSString *kCellReuseID = @"CardCell";
static NSString *kHeaderReuseID = @"HeaderCell";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self registerClass:[CardCell class] forCellReuseIdentifier:@"CBLUITableDelegate"];
        [self registerClass:[AddCardHeader class] forHeaderFooterViewReuseIdentifier:kHeaderReuseID];
               self.cbDatasource = [[CBLUITableSource alloc] init];
        CBLLiveQuery *query = [[[[Database sharedDB] viewNamed:@"byDate"] createQuery] asLiveQuery];
        self.cbDatasource.query = query;
        self.cbDatasource.tableView = self;
        self.cbDatasource.labelProperty = nil;
        self.delegate = self;
        self.dataSource = self.cbDatasource;
    }
    return self;
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
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    CardCell *cell = (CardCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell flipMode];
}

#pragma mark UITableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchController sections] objectAtIndex:section] numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchController sections] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 65.0f;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AddCardHeader *header = [self dequeueReusableHeaderFooterViewWithIdentifier:kHeaderReuseID];
    return header;
}

#pragma mark UIScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
