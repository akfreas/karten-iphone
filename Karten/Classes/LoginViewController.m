#import "LoginViewController.h"
#import "FormEntryTableViewCell.h"
#import "ButtonActionTableViewCell.h"


@interface LoginViewControllerHeader : UIView
@property (nonatomic) UIImageView *logoView;
@property (nonatomic) UILabel *teaserLabel;
@end

@implementation LoginViewControllerHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createLogoView];
        [self createTeaserLabel];
        [self addLayoutConstraints];
    }
    return self;
}

- (void)createLogoView
{
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"karten-login"]];
    [self addSubview:logoView];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoView = logoView;
}

- (void)createTeaserLabel
{
    UILabel *teaserLabel = [UILabel new];
    
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"Futura" size:14.0f], NSParagraphStyleAttributeName : para};
    teaserLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Sign In" attributes:attributes];
    [self addSubview:teaserLabel];
    self.teaserLabel = teaserLabel;
}

- (void)addLayoutConstraints
{
    UIBind(self.teaserLabel, self.logoView);
    [self addConstraintWithVisualFormat:@"H:|[teaserLabel]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"H:|[logoView]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|[logoView][teaserLabel]|" bindings:BBindings];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(320.0f, 200.0f);
}

@end


@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *formTable;
@property (nonatomic) NSArray *cellIDOrder;
@property (nonatomic) NSArray *cellTitleOrder;
@property (nonatomic) LoginViewControllerHeader *headerView;
@end

static NSString *kUsernameEntryCell = @"kUsernameEntryCell";
static NSString *kPasswordEntryCell = @"kPasswordEntryCell";
static NSString *kEmailEntryCell = @"kEmailEntryCell";
static NSString *kSubmitCell = @"kSubmitCell";
static CGFloat cellHeight = 50.0f;
@implementation LoginViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellTitleOrder = @[@"Username", @"Password", @"Email"];
        self.cellIDOrder = @[kUsernameEntryCell, kPasswordEntryCell, kEmailEntryCell, kSubmitCell];

    }
    return self;
}

- (void)createFormTable
{
    UITableView *formTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    formTable.delegate = self;
    formTable.dataSource = self;
    formTable.scrollEnabled = YES;
    LoginViewControllerHeader *header = [[LoginViewControllerHeader alloc] init];

    formTable.tableHeaderView = header;
    [formTable registerClass:[FormEntryTableViewCell class] forCellReuseIdentifier:kUsernameEntryCell];
    [formTable registerClass:[FormEntryTableViewCell class] forCellReuseIdentifier:kPasswordEntryCell];
    [formTable registerClass:[FormEntryTableViewCell class] forCellReuseIdentifier:kEmailEntryCell];
    [formTable registerClass:[ButtonActionTableViewCell class] forCellReuseIdentifier:kSubmitCell];
    [self.view addSubview:formTable];
    self.formTable = formTable;
}

- (void)createHeaderView
{
    LoginViewControllerHeader *header = [[LoginViewControllerHeader alloc] init];
    [self.view addSubview:header];
    self.headerView = header;
}

- (void)addLayoutConstraints
{
    CGFloat tableHeight = [self.cellIDOrder count] * cellHeight + self.formTable.tableHeaderView.frame.size.height;
    NSNumber *height = @(tableHeight);
    UIBind(self.formTable, self.topLayoutGuide, self.headerView);
    [self.view addConstraintWithVisualFormat:@"H:|[formTable]|" bindings:BBindings];
//    [self.view addConstraintWithVisualFormat:@"V:[topLayoutGuide][headerView][formTable(height)]" bindings:BBindings];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][headerView][formTable(height)]" options:NSLayoutFormatAlignAllCenterX metrics:@{@"height" : height} views:BBindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][formTable(height)]" options:NSLayoutFormatAlignAllCenterX metrics:@{@"height" : height} views:BBindings]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createFormTable];
    [self createHeaderView];
    [self addLayoutConstraints];
    [self.formTable reloadData];
}

#pragma mark UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 2) {
        
        FormEntryTableViewCell *formEntryCell = [tableView dequeueReusableCellWithIdentifier:self.cellIDOrder[indexPath.row]];
        [formEntryCell setTitleText:self.cellTitleOrder[indexPath.row]];
        return formEntryCell;
    }
    
    ButtonActionTableViewCell *buttonActionCell = [tableView dequeueReusableCellWithIdentifier:self.cellIDOrder[indexPath.row]];
    buttonActionCell.title = @"Submit";
    return buttonActionCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellIDOrder count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 3) {
        return;
    }
}

@end


