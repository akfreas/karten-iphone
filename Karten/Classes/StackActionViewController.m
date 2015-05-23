#import "StackActionViewController.h"
#import "KTStack.h"
#import "Stack+CouchBase.h"
#import "KTUser.h"
#import "User+Helpers.h"
#import "KTFriendSelectionViewController.h"
#import "ShareStackFriendControllerManager.h"

@interface StackActionCollectionViewCell : UICollectionViewCell
@property (nonatomic) NSString *actionName;
@property (nonatomic) UILabel *actionLabel;
@end

@implementation StackActionCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createActionLabel];
        [self addLayoutConstraints];
        self.backgroundColor = [UIColor colorWithHexString:@"#FEFEFE"];
        self.layer.borderColor = [UIColor colorWithHexString:@"#C7C8C2"].CGColor;
        self.layer.borderWidth = 1.0f;
    }
    
    return self;
}

- (void)setActionName:(NSString *)actionName
{
    NSMutableParagraphStyle *par = [NSMutableParagraphStyle new];
    par.alignment = NSTextAlignmentCenter;
    par.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f], NSParagraphStyleAttributeName : par};
    self.actionLabel.attributedText = [[NSAttributedString alloc] initWithString:actionName attributes:attrs];
    self.actionLabel.numberOfLines = 3;
    [self.actionLabel sizeThatFits:self.bounds.size];
}

- (void)createActionLabel
{
    self.actionLabel = [UILabel new];
    [self addSubview:self.actionLabel];
}

- (void)addLayoutConstraints
{
    UIBind(self.actionLabel);
    [self addConstraintWithVisualFormat:@"H:|-[actionLabel]-|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|-[actionLabel]-|" bindings:BBindings];
    
}

@end


@interface StackActionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic) UICollectionView *actionCollectionView;
@property (nonatomic) NSArray *actionTitles;
@property (nonatomic) ShareStackFriendControllerManager *shareControllerManager;
@end

static NSString *kStackActionViewCellID = @"kStackActionViewCellID";

@implementation StackActionViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.actionTitles = @[@"Quiz All Words", @"Strengthen Words", @"Word List", @"Share Stack"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2ea"];
    [self createCollectionView];
    [self addLayoutConstraints];
    // Do any additional setup after loading the view.
}

- (void)setStack:(KTStack *)stack
{
    _stack = stack;
    self.title = stack.name;
    [self.stack enqueueDatabaseForSyncing];
    [self.stack beginCouchDBSync];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createCollectionView
{
    self.actionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.actionCollectionView.delegate = self;
    self.actionCollectionView.dataSource = self;
    self.actionCollectionView.backgroundColor = [UIColor clearColor];
    [self.actionCollectionView registerClass:[StackActionCollectionViewCell class] forCellWithReuseIdentifier:kStackActionViewCellID];
    [self.view addSubview:self.actionCollectionView];
}

- (void)addLayoutConstraints
{
    UIBind(self.actionCollectionView);
    [self.view addConstraintWithVisualFormat:@"H:|[actionCollectionView]|" bindings:BBindings];
    [self.view addConstraintWithVisualFormat:@"V:|-[actionCollectionView]-|" bindings:BBindings];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StackActionCollectionViewCell *cell = [self.actionCollectionView dequeueReusableCellWithReuseIdentifier:kStackActionViewCellID forIndexPath:indexPath];
    cell.actionName = [self.actionTitles objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.actionTitles count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"stack == %@", self.stack];
        NSArray *cards = [KTCard MR_findAllWithPredicate:pred];
        [MainViewController showQuizViewForCards:cards];
    } else if (indexPath.row == 1) {
        NSNumber *scoreAverage = [KTCard MR_aggregateOperation:@"average:" onAttribute:@"knowledgeScore" withPredicate:[NSPredicate predicateWithFormat:@"stack == %@", self.stack]];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"knowledgeScore <= %@", scoreAverage];
        NSArray *cards = [KTCard MR_findAllWithPredicate:pred];
        [MainViewController showQuizViewForCards:cards];
    } else if (indexPath.row == 2) {
        [MainViewController showCardListForStack:self.stack];
    } else if (indexPath.row == 3) {
        ShareStackFriendControllerManager *controllerManager = [ShareStackFriendControllerManager new];
        KTFriendSelectionViewController *friendController = [[KTFriendSelectionViewController alloc] initWithUser:[KTUser mainUser]];
        self.shareControllerManager = controllerManager;
        [controllerManager setFriendsListViewController:friendController forSharingStack:self.stack];
        [MainViewController pushViewController:friendController];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.actionCollectionView.bounds.size.width;
    return CGSizeMake(width, 55.0f);
}



@end
