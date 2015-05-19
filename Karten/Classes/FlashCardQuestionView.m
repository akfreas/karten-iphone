#import "FlashCardQuestionView.h"

@interface FlashCardQuestionView ()
@property (nonatomic) UILabel *termLabel;
@end

@implementation FlashCardQuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTermLabel];
        [self addLayoutConstraints];
    }
    return self;
}

- (void)setCard:(KTCard *)card
{
    [self updateTermLabelText:card.term];
}

- (void)updateTermLabelText:(NSString *)string
{
    NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc] init];
    par.alignment = NSTextAlignmentCenter;
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0f],
                            NSParagraphStyleAttributeName : par};
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    self.termLabel.attributedText = attrString;
}

- (void)createTermLabel
{
    self.termLabel = [UILabel new];
    [self addSubview:self.termLabel];
}

- (void)addLayoutConstraints
{
    UIBind(self.termLabel);
    [self addConstraintWithVisualFormat:@"H:|[termLabel]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|[termLabel]|" bindings:BBindings];
}

@end
