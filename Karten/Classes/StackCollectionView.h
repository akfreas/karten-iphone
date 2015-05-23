
@interface StackCollectionView : UICollectionView
@property (nonatomic) NSFetchedResultsController *fetchController;
@property (nonatomic, copy) void(^stackSelectedAction)(KTStack *);
@end
