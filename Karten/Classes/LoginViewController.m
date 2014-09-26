#import "LoginViewController.h"
#import "FormEntryTableViewCell.h"
#import "ButtonActionTableViewCell.h"
#import "KTAPILoginUser.h"
#import "KartenNetworkClient.h"
#import "Karten-Swift.h"
#import "KTAPIGetUser.h"
#import "User.h"

@interface LoginViewControllerHeader : UIView
@property (nonatomic) UIImageView *logoView;
@property (nonatomic) UILabel *teaserLabel;

@end

@implementation LoginViewControllerHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
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
@property (nonatomic) NSMutableArray *cellIDOrder;
@property (nonatomic) NSMutableArray *cellTitleOrder;
@property (nonatomic) LoginViewControllerHeader *headerView;

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
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
        self.cellTitleOrder = [@[@"Username", @"Password"] mutableCopy];
        self.cellIDOrder = [@[kUsernameEntryCell, kPasswordEntryCell, kSubmitCell] mutableCopy];
    }
    return self;
}

- (void)createFormTable
{
    UITableView *formTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    formTable.delegate = self;
    formTable.dataSource = self;
    formTable.scrollEnabled = YES;
//    formTable.tableHeaderView = self.headerView;
    [formTable registerClass:[FormEntryTableViewCell class] forCellReuseIdentifier:kUsernameEntryCell];
    [formTable registerClass:[FormEntryTableViewCell class] forCellReuseIdentifier:kPasswordEntryCell];
    [formTable registerClass:[FormEntryTableViewCell class] forCellReuseIdentifier:kEmailEntryCell];
    [formTable registerClass:[ButtonActionTableViewCell class] forCellReuseIdentifier:kSubmitCell];
    [self.view addSubview:formTable];
    self.formTable = formTable;
    [self.formTable setNeedsLayout];
}

- (LoginViewControllerHeader *)headerView
{
    if (_headerView == nil) {
        LoginViewControllerHeader *header = [[LoginViewControllerHeader alloc] init];
        self.headerView = header;
    }
    return _headerView;
}

- (void)addLayoutConstraints
{
    UIBind(self.formTable, self.topLayoutGuide);
    [self.view addConstraintWithVisualFormat:@"H:|[formTable]|" bindings:BBindings];
    [self.view addConstraintWithVisualFormat:@"V:|[formTable]|" bindings:BBindings];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][headerView][formTable(height)]" options:NSLayoutFormatAlignAllCenterX metrics:@{@"height" : height} views:BBindings]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][formTable]|" options:NSLayoutFormatAlignAllCenterX metrics:@{@"height" : height} views:BBindings]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createFormTable];
    [self addLayoutConstraints];
    [self.formTable reloadData];
}

- (void)showInvalidUsernamePasswordComboAlert
{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Your username and password are invalid! Please try again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark UITableView Datasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 200.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 1) {
        
        FormEntryTableViewCell *formEntryCell = [tableView dequeueReusableCellWithIdentifier:self.cellIDOrder[indexPath.row]];
        [formEntryCell setTitleText:self.cellTitleOrder[indexPath.row]];
        
        [formEntryCell bk_removeAllBlockObservers];
        if (indexPath.row == 0) {
            [formEntryCell bk_addObserverForKeyPath:@"text" options:NSKeyValueObservingOptionNew task:^(id sender, NSDictionary *change) {
                self.username = change[NSKeyValueChangeNewKey];
            }];
        } else if (indexPath.row == 1) {
            formEntryCell.textFieldSecured = YES;
            [formEntryCell bk_addObserverForKeyPath:@"text" options:NSKeyValueObservingOptionNew task:^(id sender, NSDictionary *change) {
                self.password = change[NSKeyValueChangeNewKey];
            }];
        }
        
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
    if (indexPath.row < 2) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        return;
    }
    KTAPILoginUser *loginUser = [[KTAPILoginUser alloc] initWithUsername:self.username password:self.password];
    KTAPIGetUser *getUser = [KTAPIGetUser new];
    [KartenNetworkClient makeRequest:loginUser completion:^{
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [KartenSessionManager setToken:responseObject[@"token"]];
        [KartenNetworkClient makeRequest:getUser completion:^{
        } success:^(AFHTTPRequestOperation *operation, User *authedUser) {
            authedUser.mainUser = @(YES);
            [authedUser.managedObjectContext MR_saveOnlySelfAndWait];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showInvalidUsernamePasswordComboAlert];
    }];
}

@end


