#import "AddCardFormView.h"
#import "GraphicsUtils.h"
#import "KTCard.h"
#import "Card+Helpers.h"
#import "User+Helpers.h"

@interface AddCardFormView ()
@property (nonatomic) UITextField *termTextField;
@property (nonatomic) UITextField *definitionTextField;
@property (nonatomic) UIButton *addButton;
@property (nonatomic) UIButton *cancelButton;
@end

@implementation AddCardFormView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = 5.0f;
        [self createTermTextField];
        [self createAddButton];
        [self createDefinitionTextField];
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

- (void)setSaveButtonAction:(void (^)(id, KTCard *))saveButtonAction
{
    _saveButtonAction = saveButtonAction;
    [self.addButton bk_addEventHandler:^(id sender) {
        if ([self formValid] == NO)
            return;
        [self.termTextField resignFirstResponder];
        if (self.saveButtonAction) {
            self.saveButtonAction(sender, [self buildCardFromForm]);
            self.definitionTextField.text = @"";
            self.termTextField.text = @"";
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)formValid
{
    BOOL isValid = YES;
    if ([self.termTextField.text isEqualToString:@""]){
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"Missing Info" message:@"Please enter a term!"];
        [alertView bk_addButtonWithTitle:@"OK" handler:^{
            [self.termTextField becomeFirstResponder];
        }];
        [alertView show];
        isValid = NO;
    }
    return isValid;
}

- (KTCard *)buildCardFromForm
{
    KTCard *newCard = [KTCard MR_createEntity];
    newCard.term = self.termTextField.text;
    newCard.definition = self.definitionTextField.text;
    return newCard;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(300.0f, 120.0f);
}

- (void)createTermTextField
{
    UITextField *termTextField = [UITextField new];
    termTextField.placeholder = @"Term";
    [termTextField setTextColor:[UIColor blackColor]];
    [termTextField setTintColor:[UIColor blackColor]];
    [termTextField setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
        [self.definitionTextField becomeFirstResponder];
        return YES;
    }];
    self.termTextField = termTextField;
    [self addSubview:self.termTextField];
}

- (void)createDefinitionTextField
{
    UITextField *definitionTextField = [UITextField new];
    definitionTextField.placeholder = @"Definition";
    [definitionTextField setTextColor:[UIColor blackColor]];
    [definitionTextField setTintColor:[UIColor blackColor]];
    [definitionTextField setBk_shouldReturnBlock:^BOOL(UITextField *textField) {
        [textField resignFirstResponder];
        return YES;
    }];
    self.definitionTextField = definitionTextField;
    [self addSubview:self.definitionTextField];
}

- (void)createAddButton
{
    self.addButton = [UIButton new];
    [self.addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addButton setTitle:@"Save" forState:UIControlStateNormal];
    [self addSubview:self.addButton];
}

- (void)createCancelButton
{
    self.cancelButton = [UIButton new];
    [self.cancelButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:self.cancelButton];
}

- (void)addLayoutConstraints
{
    UIBind(self.termTextField, self.cancelButton, self.addButton, self.definitionTextField);
    [self addConstraintWithVisualFormat:@"H:|-[termTextField]-|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"H:|[cancelButton][addButton(==cancelButton)]|" bindings:BBindings];
//    [self addConstraintWithVisualFormat:@"H:|-[cancelButton]-|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"H:|-[definitionTextField]-|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|[termTextField][definitionTextField(==termTextField)]" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:[definitionTextField][addButton]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:[definitionTextField][cancelButton]|" bindings:BBindings];
//    [self addConstraintWithVisualFormat:@"H:|-[addButton]-[cancelButton(]-|" bindings:BBindings];
}

@end
