#import "AddStackFormView.h"

@interface AddStackFormView ()
@property (nonatomic) UITextField *nameTextField;
@property (nonatomic) UIButton *addButton;
@property (nonatomic) UIButton *cancelButton;
@end

@implementation AddStackFormView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createNameTextField];
        [self createAddButton];
        [self createCancelButton];
        [self addLayoutConstraints];
    }
    return self;
}


- (void)createNameTextField
{
    self.nameTextField = [[UITextField alloc] initForAutoLayout];
    [self addSubview:self.nameTextField];
}

- (void)createAddButton
{
    self.addButton = [[UIButton alloc] initForAutoLayout];
    [self.addButton setTitle:@"Save" forState:UIControlStateNormal];
    [self addSubview:self.addButton];
}

- (void)createCancelButton
{
    self.cancelButton = [[UIButton alloc] initForAutoLayout];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self addSubview:self.cancelButton];
}

- (void)addLayoutConstraints
{
    UIBind(self.nameTextField, self.cancelButton, self.addButton);
    [self addConstraintWithVisualFormat:@"H:|-[nameTextField]-|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"H:|-[addButton]-|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"H:|-[cancelButton]-|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|-[nameTextField]-[addButton]-[cancelButton]-|" bindings:BBindings];
}

@end
