#import "StackListTableView.h"
#import "StackListTableViewCell.h"
#import "Stack+Helpers.h"
#import "Stack.h"

static NSString *kStackTableViewCellID = @"kStackTableViewCellID";

static NSInteger kRowOffset = 1;

@interface NSIndexPath (Offset)
- (NSIndexPath *)offsetPathByRow;
@end

@implementation NSIndexPath (Offset)
- (NSIndexPath *)offsetPathByRow
{
    return [NSIndexPath indexPathForRow:self.row + kRowOffset inSection:self.section];
}
@end

@interface StackListTableView () <UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic) NSFetchedResultsController *fetchController;
@end

@implementation StackListTableView

#pragma mark - Public Methods

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerClass:[StackListTableViewCell class] forCellReuseIdentifier:kStackTableViewCellID];
        [self createFetchController];
        self.dataSource = self;
    }
    return self;
}

#pragma mark - Private Methods

- (void)createFetchController
{
    self.fetchController = [Stack MR_fetchAllSortedBy:@"serverID" ascending:NO withPredicate:nil groupBy:nil delegate:self inContext:[NSManagedObjectContext MR_defaultContext]];
}

- (UITableViewCell *)configureCell:(StackListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Stack *stackForCell = [self.fetchController objectAtIndexPath:indexPath];
    cell.stack = stackForCell;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StackListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStackTableViewCellID];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark NSFetchedResultsController Delegate

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (anObject != nil) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [self insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case NSFetchedResultsChangeUpdate:
                [self configureCell:(StackListTableViewCell *)[self cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
            case NSFetchedResultsChangeDelete:
                [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                break;
            default:
                break;
        }
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchController sections] objectAtIndex:section] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchController sections] count];
}

#pragma mark UITableView Datasource


@end
