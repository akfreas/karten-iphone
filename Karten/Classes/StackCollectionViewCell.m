#import "Stack.h"
#import "StackCollectionViewCell.h"

@interface StackCollectionViewCell ()
@property (nonatomic) UILabel *stackNameAbbrLabel;
@property (nonatomic) UILabel *fullStackNameLabel;
@end

@implementation StackCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = rgb(154, 224, 157);
        [self createAbbrLabel];
        [self createStackNameLabel];
        [self addLayoutConstraints];
    }
    return self;
}


- (void)setStack:(Stack *)stack
{
    _stack = stack;
    [self configureAbbrLabel];
    [self configureStackNameLabel];
}

- (void)createAbbrLabel
{
    self.stackNameAbbrLabel = [[UILabel alloc] initForAutoLayout];
    [self addSubview:self.stackNameAbbrLabel];
}

- (void)createStackNameLabel
{
    self.fullStackNameLabel = [[UILabel alloc] initForAutoLayout];
    [self addSubview:self.fullStackNameLabel];
}

- (void)configureStackNameLabel
{
    NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc] init];
    par.alignment = NSTextAlignmentCenter;
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f], NSParagraphStyleAttributeName : par};
    self.fullStackNameLabel.attributedText = [[NSAttributedString alloc] initWithString:self.stack.name attributes:attrs];
}

- (void)configureAbbrLabel
{
    if (self.stack == nil) {
        return;
    }
    NSMutableString *abbr = [NSMutableString stringWithString:[[self.stack.name substringToIndex:1] capitalizedString]];
    NSMutableParagraphStyle *par = [[NSMutableParagraphStyle alloc] init];
    par.alignment = NSTextAlignmentCenter;
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:35.0f], NSParagraphStyleAttributeName : par};
    
    NSString *vowelsRemoved = [[self.stack.name substringFromIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"AEIOUaeuio"]];
    [abbr appendString:[[vowelsRemoved substringToIndex:1] capitalizedString]];
    self.stackNameAbbrLabel.attributedText = [[NSAttributedString alloc] initWithString:abbr attributes:attrs];
//    self.stackNameAbbrLabel.text = abbr;
}

- (void)addLayoutConstraints
{
    UIBind(self.stackNameAbbrLabel, self.fullStackNameLabel);
    [self addConstraintWithVisualFormat:@"H:|[stackNameAbbrLabel]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"H:|[fullStackNameLabel]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|[stackNameAbbrLabel][fullStackNameLabel(15)]-|" bindings:BBindings];
}

@end
