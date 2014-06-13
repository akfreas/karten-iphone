#import "StackActionTableViewCell.h"

@implementation StackActionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    return self;
}

- (void)setDisplayName:(NSString *)displayName
{
    self.textLabel.text = displayName;
}

@end
