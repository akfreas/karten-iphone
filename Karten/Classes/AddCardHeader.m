#import "AddCardHeader.h"
#import "Card.h"
#import "KartenModelHelpers.h"

@interface AddCardHeader ()

@property (nonatomic, retain) UITextField *termTextField;
@property (nonatomic, retain) UITextField *definitionTextField;
@property (nonatomic, retain) UIButton *submitButton;

@end

@implementation AddCardHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUIComponents];
        [self configureLayoutConstraints];
    }
    return self;
}

-(void)configureLayoutConstraints {
    UIBind(self.termTextField, self.definitionTextField, self.submitButton);
    [self.contentView addConstraintWithVisualFormat:@"H:|-[termTextField]-[definitionTextField]-[submitButton(64)]|" bindings:BBindings];
    [self.contentView addConstraintWithVisualFormat:@"V:|-[definitionTextField]-|" bindings:BBindings];
    [self.contentView addConstraintWithVisualFormat:@"V:|-[termTextField]-|" bindings:BBindings];
    [self.contentView addConstraintWithVisualFormat:@"V:|-[submitButton]-|" bindings:BBindings];
}

-(void)addUIComponents {
    
    [self addTermTextField];
    [self addDefinitionTextField];
    [self addSubmitButton];
}

-(void)addTermTextField {
    self.termTextField = [UITextField newAutoLayoutView];
    self.termTextField.placeholder = @"Term";
    [self.termTextField setValidationRule:^BOOL(UITextField *sender) {
        if([sender.text isEqualToString:@""] || sender.text == nil) {
            return NO;
        } else {
            return YES;
        }
    }];
    [self.contentView addSubview:self.termTextField];
}

-(void)addDefinitionTextField {
    self.definitionTextField = [UITextField newAutoLayoutView];
    self.definitionTextField.placeholder = @"Definition";
    [self.definitionTextField setValidationRule:^BOOL(UITextField *sender) {
        if (sender.text == nil || [sender.text isEqualToString:@""]) {
            return NO;
        } else {
            return YES;
        }
    }];
    [self.contentView addSubview:self.definitionTextField];
}

-(void)addSubmitButton {
    self.submitButton = [[UIButton alloc] initForAutoLayout];
    [self.submitButton setTitle:@"+" forState:UIControlStateNormal];
    self.submitButton.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.submitButton];
    [self.submitButton bk_addEventHandler:^(id sender) {
        if ([self.definitionTextField isValid] && [self.termTextField isValid]) {
            NSManagedObjectContext *ctx = [NSManagedObjectContext MR_contextForCurrentThread];
            [ctx performBlock:^{
                Card *newCard = [Card MR_createEntity];
                newCard.term = self.termTextField.text;
                newCard.definition = self.definitionTextField.text;
                [ctx MR_saveOnlySelfAndWait];
            }];
        }
    } forControlEvents:UIControlEventTouchUpInside];
}

@end
