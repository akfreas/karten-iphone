#import "StackListTableView.h"
#import "StackListTableViewCell.h"
#import "StackActionTableViewCell.h"
#import "Stack+Helpers.h"
#import "Stack.h"

static NSString *kStackTableViewCellID = @"kStackTableViewCellID";
static NSString *kQuizActionTableViewCellID = @"kQuizActionTableViewCellID";
static NSInteger kRowOffset = 1;
static NSInteger kNumberOfActions = 1;

static NSInteger kStackSection = 0;
static NSInteger kActionSection = 1;

static NSInteger kNumberOfAdditionalSections = 1;



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
@property (nonatomic) NSMutableArray *actionTableViewCells;
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

- (void)createActionCells
{
    self.actionTableViewCells = [NSMutableArray array];
    StackActionTableViewCell *quizAction = [[StackActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kQuizActionTableViewCellID];
    quizAction.displayName = @"Quiz";
}

- (void)createFetchController
{
    self.fetchController = [Stack MR_fetchAllSortedBy:@"serverID" ascending:NO withPredicate:nil groupBy:nil delegate:self inContext:[NSManagedObjectContext MR_defaultContext]];
}

#pragma mark UITableView Datasource

- (UITableViewCell *)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kStackSection) {
        StackListTableViewCell *ourCell = (StackListTableViewCell *)cell;
        Stack *stackForCell = [self.fetchController objectAtIndexPath:indexPath];
        ourCell.stack = stackForCell;
    } else if (indexPath.section == kActionSection) {
        
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStackTableViewCellID];
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
    NSInteger numberOfSections = 0;
    if (section == kStackSection) {
        [[[self.fetchController sections] objectAtIndex:section] numberOfObjects];
    } else if (section == kActionSection) {
        
    }
    return numberOfSections;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchController sections] count] + kNumberOfAdditionalSections;
}




@end
