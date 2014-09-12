#import "ButtonActionTableViewCell.h"

@interface ButtonActionTableViewCell ()
@property (nonatomic) UILabel *mainLabel;
@end

@implementation ButtonActionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createMainLabel];
        [self addLayoutConstraints];
    }
    return self;
}

- (void)createMainLabel
{
    UILabel *mainLabel = [UILabel new];
    [self.contentView addSubview:mainLabel];
    self.mainLabel = mainLabel;
}

- (void)addLayoutConstraints
{
    UIBind(self.mainLabel);
    [self.contentView addConstraintWithVisualFormat:@"H:|[mainLabel]|" bindings:BBindings];
    [self.contentView addConstraintWithVisualFormat:@"V:|[mainLabel]|" bindings:BBindings];
}

@end
