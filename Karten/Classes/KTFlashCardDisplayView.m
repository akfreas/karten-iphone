#import "KTFlashCardDisplayView.h"

@interface KTFlashCardDisplayView () <UITextViewDelegate>
@property (nonatomic) UITextView *textView;
@property (nonatomic) UITextField *termLabel;
@end

@implementation KTFlashCardDisplayView {
    KTCard *_card;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTextView];
        [self createTermLabel];
        [self addLayoutConstraints];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createTextView
{
    self.textView = [UITextView new];
    self.textView.editable = NO;
    self.textView.scrollEnabled = NO;
//    self.textView.delegate = self;
    [self addSubview:self.textView];
}

- (void)createTermLabel
{
    UITextField *termLabel = [UITextField new];
    [termLabel setBk_shouldReturnBlock:^BOOL(UITextField *t) {
        return [self returnBlock];
    }];
    self.termLabel = termLabel;
    self.termLabel.enabled = NO;
    [self addSubview:self.termLabel];
}

- (void)addLayoutConstraints
{
    UIBind(self.termLabel, self.textView);
    [self addConstraintWithVisualFormat:@"H:|-[termLabel]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"H:|[textView]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|[termLabel(50)]" bindings:BBindings];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
}

- (void)setTermLabelText:(NSString *)string
{
    NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc] init];
    par.alignment = NSTextAlignmentCenter;

    NSDictionary *attrs = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0f],
                            NSParagraphStyleAttributeName : par};
    if (string==nil) {
        return;
    }
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    self.termLabel.attributedText = str;
}

- (void)setTextViewText:(NSString *)string
{
    NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc] init];
    par.alignment = NSTextAlignmentCenter;
    NSDictionary *attrs = @{
                            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0f],
                            NSParagraphStyleAttributeName : par
                            };
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    self.textView.attributedText = str;
    [self.textView sizeToFit];
}

- (void)setMainText:(NSAttributedString *)mainText
{
    self.textView.attributedText = mainText;
}

- (void)setSupplementaryText:(NSAttributedString *)supplementaryText
{
    self.termLabel.attributedText = supplementaryText;
}

#pragma mark Accessors

- (BOOL)returnBlock
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return YES;
}

- (void)setEditing:(BOOL)editing
{
    self.termLabel.userInteractionEnabled = editing;
    self.textView.editable = editing;
    self.termLabel.enabled = editing;
}

- (KTCard *)card
{
    _card.term = self.termLabel.text;
    _card.definition = self.textView.text;
    return _card;
}

- (void)setCard:(KTCard *)card
{
    _card = card;
    [self setTermLabelText:card.term];
    [self setTextViewText:card.definition];
    [self layoutIfNeeded];
}

@end
