#import "CardTableView.h"
#import "CardCell.h"
#import "AddCardHeader.h"
#import "Card.h"

@interface CardTableView () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSFetchedResultsController *fetchController;

@end

@implementation CardTableView

static NSString *kCellReuseID = @"CardCell";
static NSString *kHeaderReuseID = @"HeaderCell";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerClass:[CardCell class] forCellReuseIdentifier:kCellReuseID];
        [self registerClass:[AddCardHeader class] forHeaderFooterViewReuseIdentifier:kHeaderReuseID];
        self.fetchController = [Card MR_fetchAllSortedBy:@"timestamp" ascending:NO withPredicate:nil groupBy:nil delegate:self];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}


#pragma mark NSFetchedResultsController Delegate Methods

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [self insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case NSFetchedResultsChangeUpdate:
                [self configureCell:(CardCell *)[self cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
            case NSFetchedResultsChangeDelete:
                [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                break;
            default:
                break;
        }
    
}

#pragma mark UITableView Helpers

-(void)configureCell:(CardCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.card = [self.fetchController objectAtIndexPath:indexPath];
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CardCell *cell = (CardCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell flipMode];
}

#pragma mark UITableView Datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseID];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

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

@end
