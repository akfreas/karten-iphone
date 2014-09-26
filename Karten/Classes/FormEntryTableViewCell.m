#import "FormEntryTableViewCell.h"


@interface FormEntryTableViewCell ()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextField *inputTextField;
@end

@implementation FormEntryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createTitleLabel];
        [self createInputTextField];
        [self addLayoutConstraints];
    }
    return self;
}

- (void)createTitleLabel
{
    UILabel *titleLabel = [UILabel new];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)dealloc
{
    [self.inputTextField bk_removeAllBlockObservers];
}

- (void)createInputTextField
{
    UITextField *inputTextField = [UITextField new];
    self.text = @"";
    [inputTextField setBk_shouldChangeCharactersInRangeWithReplacementStringBlock:^BOOL(UITextField *textfield, NSRange range, NSString *string) {
        self.text = [self.text stringByReplacingCharactersInRange:range withString:string];
        return YES;
    }];
    [self.contentView addSubview:inputTextField];
    self.inputTextField = inputTextField;
}

- (void)addLayoutConstraints
{
    UIBind(self.inputTextField, self.titleLabel);
    [self.contentView addConstraintWithVisualFormat:@"H:|-(20)-[titleLabel(100)][inputTextField]|" bindings:BBindings];
    [self.contentView addConstraintWithVisualFormat:@"V:|[titleLabel]|" bindings:BBindings];
    [self.contentView addConstraintWithVisualFormat:@"V:|[inputTextField]|" bindings:BBindings];
}

#pragma mark Public Methods

- (void)reset
{
    self.inputTextField.text = @"";
}

#pragma mark Accessors

- (void)setTextFieldSecured:(BOOL)textFieldSecured
{
    self.inputTextField.secureTextEntry = textFieldSecured;
}

- (void)setTitleText:(NSString *)titleText
{
    self.titleLabel.text = titleText;
    self.inputTextField.placeholder = titleText;
}

@end