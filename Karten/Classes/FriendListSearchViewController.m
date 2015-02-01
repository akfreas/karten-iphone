#import "FriendListSearchViewController.h"
#import "KTUser.h"

@interface FriendListSearchViewController () <UITableViewDataSource>
@property (nonatomic) IBOutlet UITableView *results;
@end

@implementation FriendListSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setResultDisplay:(NSArray *)resultDisplay
{
    _resultDisplay = resultDisplay;
    [self.results reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kSearchCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kSearchCell"];
    }
    KTUser *user = self.resultDisplay[indexPath.row];
    cell.textLabel.text = user.username;
    return cell;
}


@end
