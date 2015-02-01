#import "StackCollectionView.h"
#import "StackCollectionViewCell.h"
#import "Stack.h"



@interface StackCollectionView () <UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic) UICollectionViewFlowLayout *layout;
@property (nonatomic) NSMutableArray *objectChanges;

@end

static NSString *kStackCollectionCell = @"kStackCollectionCell";
static CGFloat cellMargin = 15.0f;
static NSInteger numberOfCellsPerRow = 2;
@implementation StackCollectionView

- (id)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.layout = layout;
        self.backgroundColor = [UIColor clearColor];
        self.objectChanges = [NSMutableArray array];
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[StackCollectionViewCell class] forCellWithReuseIdentifier:kStackCollectionCell];
        [self createFetchController];
    }
    return self;
}

- (void)createFetchController
{
    self.fetchController = [Stack MR_fetchAllSortedBy:@"creationDate" ascending:NO withPredicate:nil groupBy:nil delegate:self inContext:[NSManagedObjectContext MR_defaultContext]];
    
    [self.fetchController performFetch:NULL];
}

- (void)configureCell:(StackCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Stack *cellStack = [self.fetchController objectAtIndexPath:indexPath];
    cell.stack = cellStack;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = ((self.bounds.size.width) / numberOfCellsPerRow) - cellMargin;
    self.layout.itemSize = CGSizeMake(width, width);
}

#pragma mark NSFetchedResultsControllerDelegate Methods


-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.objectChanges removeAllObjects];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if ([self.objectChanges count] > 0) {
        [self performBatchUpdates:^{
            for (NSDictionary *change in self.objectChanges) {
                
                [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type) {
                        case NSFetchedResultsChangeInsert:
                            [self insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self deleteItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [self moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                        default:
                            break;
                    }
                }];
            }
            [self.objectChanges removeAllObjects];
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    if (anObject != nil) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                change[@(type)] = newIndexPath;
                break;
            case NSFetchedResultsChangeUpdate:
                change[@(type)] = indexPath;
                break;
            case NSFetchedResultsChangeDelete:
                change[@(type)] = indexPath;
                break;
            case NSFetchedResultsChangeMove:
                change[@(type)] = @[indexPath, newIndexPath];
                break;
            default:
                break;
        }
    }
    [self.objectChanges addObject:change];
}


#pragma mark UICollectionViewDatasource Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StackCollectionViewCell *cell = (StackCollectionViewCell *)[self dequeueReusableCellWithReuseIdentifier:kStackCollectionCell forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[self.fetchController sections] objectAtIndex:section] numberOfObjects];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.stackSelectedAction) {
        Stack *selectedStack = [self.fetchController objectAtIndexPath:indexPath];
        self.stackSelectedAction(selectedStack);
    }
}

#pragma mark UICollectionViewDelegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.bounds.size.width - cellMargin) / numberOfCellsPerRow;
    return CGSizeMake(width, width);
}



@end
