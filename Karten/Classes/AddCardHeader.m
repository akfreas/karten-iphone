#import "AddCardHeader.h"
#import "Card.h"
#import "KartenModelHelpers.h"
#import "Database.h"
#import "CouchManager.h"

@interface AddCardHeader ()

@property (nonatomic, retain) UITextField *termTextField;
@property (nonatomic, retain) UITextField *definitionTextField;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic) UISearchBar *wordSearchBar;

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
    UIBind(self.termTextField, self.definitionTextField, self.submitButton, self.wordSearchBar);
    [self.contentView addConstraintWithVisualFormat:@"H:|-[termTextField]-[definitionTextField]-[submitButton(64)]|" bindings:BBindings];
    [self.contentView addConstraintWithVisualFormat:@"V:|-[definitionTextField]" bindings:BBindings];
    [self.contentView addConstraintWithVisualFormat:@"V:|-[termTextField]" bindings:BBindings];
    [self.contentView addConstraintWithVisualFormat:@"V:|-[submitButton]" bindings:BBindings];
    [self.contentView addConstraintWithVisualFormat:@"V:[termTextField][wordSearchBar(>=30)]|" bindings:BBindings];
    [self.contentView addConstraintWithVisualFormat:@"H:|[wordSearchBar]|" bindings:BBindings];
}

-(void)addUIComponents {
    
    [self addTermTextField];
    [self addDefinitionTextField];
    [self addSubmitButton];
    [self addSearchBar];
}

-(void)addTermTextField {
    self.termTextField = [UITextField new];
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
    self.definitionTextField = [UITextField new];
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

- (void)addSearchBar {
    self.wordSearchBar = [UISearchBar new];
    self.wordSearchBar.placeholder = @"Search";
    [self.contentView addSubview:self.wordSearchBar];
}

-(void)addSubmitButton {
    self.submitButton = [UIButton new];
    [self.submitButton setTitle:@"+" forState:UIControlStateNormal];
    self.submitButton.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.submitButton];
    [self.submitButton bk_addEventHandler:^(id sender) {
        if ([self.definitionTextField isValid] && [self.termTextField isValid]) {
            NSDictionary *cardDocument = @{@"term": self.termTextField.text,
                                           @"definition" : self.definitionTextField.text,
                                           @"created_at" : [CBLJSON JSONObjectWithDate:[NSDate date]]};
            CBLDocument *newDoc = [[[CouchManager databaseForStack:self.stack] couchDatabase] createDocument];
            NSError *err = nil;
            if (![newDoc putProperties:cardDocument error:&err]) {
                NSLog(@"Couldn't put doc %@. %@", cardDocument, err);
            } else {
                self.definitionTextField.text = nil;
                self.termTextField.text = nil;
                [self.termTextField resignFirstResponder];
                [self.definitionTextField resignFirstResponder];
            }
        }
    } forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark Accessors

- (void)setDelegate:(id<UISearchBarDelegate>)delegate {
    self.wordSearchBar.delegate = delegate;
}

@end
