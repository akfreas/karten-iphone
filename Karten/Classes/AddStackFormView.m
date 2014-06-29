#import "AddStackFormView.h"
#import "GraphicsUtils.h"
#import "Stack+Helpers.h"
#import "Stack+Helpers.h"
#import "User+Helpers.h"

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
        self.backgroundColor = rgb(181, 186, 199);
        self.layer.cornerRadius = 5.0f;
        [self createNameTextField];
        [self createAddButton];
        [self createCancelButton];
        [self addLayoutConstraints];
    }
    return self;
}

- (void)setCancelButtonAction:(void (^)(id))cancelButtonAction
{
    _cancelButtonAction = cancelButtonAction;
    [self.cancelButton bk_addEventHandler:self.cancelButtonAction forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSaveButtonAction:(void (^)(id, Stack *))saveButtonAction
{
    _saveButtonAction = saveButtonAction;
    [self.addButton bk_addEventHandler:^(id sender) {
        if ([self formValid] == NO)
            return;
        [self.nameTextField resignFirstResponder];
        if (self.saveButtonAction) {
            self.saveButtonAction(sender, [self buildStackFromForm]);
            self.nameTextField.text = @"";
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)formValid
{
    BOOL isValid = YES;
    if ([self.nameTextField.text isEqualToString:@""]){
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"Missing Info" message:@"Please enter a name!"];
        [alertView bk_addButtonWithTitle:@"OK" handler:^{
            [self.nameTextField becomeFirstResponder];
        }];
        [alertView show];
        isValid = NO;
    }
    return isValid;
}

- (Stack *)buildStackFromForm
{
    Stack *newStack = [Stack MR_createEntity];
    newStack.name = self.nameTextField.text;
    newStack.owner = [User mainUser];
    newStack.creationDate = [NSDate date];
    return newStack;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(300.0f, 150.0f);
}

- (void)createNameTextField
{
    self.nameTextField = [[UITextField alloc] initForAutoLayout];
    self.nameTextField.placeholder = @"Stack Name";
    [self.nameTextField setTextColor:[UIColor whiteColor]];
    [self.nameTextField setTintColor:[UIColor whiteColor]];
    [self.nameTextField setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
        [textField resignFirstResponder];
        return YES;
    }];
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
