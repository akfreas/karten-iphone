#import "Stack.h"
#import "StackCollectionViewCell.h"
#import "Stack+Network.h"
#import "DeleteButton.h"


@interface StackCollectionViewCell ()
@property (nonatomic) UILabel *stackNameAbbrLabel;
@property (nonatomic) UILabel *fullStackNameLabel;
@property (nonatomic) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic) DeleteButton *deleteButton;
@property (nonatomic) NSArray *deleteButtonConstraints;
@end

static CGFloat DeleteButtonSize = 30.0f;

@implementation StackCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FEFEFE"];
        self.layer.borderColor = [UIColor colorWithHexString:@"#C7C8C2"].CGColor;
        self.layer.borderWidth = 1.0f;
        [self createAbbrLabel];
        [self createStackNameLabel];
        [self addLayoutConstraints];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterDeletionMode) name:EnterDeletionModeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitDeletionMode) name:ExitDeletionModeNotification object:nil];
        [self addDeleteModeEnterGesture];
    }
    return self;
}
#define degreesToRadians(x) (M_PI * (x) / 180.0)

- (void)enterDeletionMode
{
    if (self.deleteButton == nil) {
        [self createDeleteButton];
        NSArray *constraints = @[
                                         [NSLayoutConstraint constraintWithItem:self.deleteButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f],
                                         [NSLayoutConstraint constraintWithItem:self.deleteButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f],
                                         ];
        [self addConstraints:constraints];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.deleteButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.deleteButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0.0f];
        self.deleteButtonConstraints = @[width, height];
        [self addConstraints:self.deleteButtonConstraints];
        [self layoutIfNeeded];
        width.constant = height.constant = DeleteButtonSize;
        [UIView animateWithDuration:0.1f animations:^{
            [self layoutIfNeeded];
        }];
    }
    
    NSInteger randomInt = arc4random_uniform(500);
    float r = (randomInt/500.0)+0.5;
    
    CGAffineTransform leftWobble = CGAffineTransformMakeRotation(degreesToRadians( (1.0 * -1.0) - r ));
    CGAffineTransform rightWobble = CGAffineTransformMakeRotation(degreesToRadians( 1.0 + r ));
    
    self.transform = leftWobble;  // starting point
    
    [[self layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
//                         [UIView setAnimationRepeatCount:NSNotFound];
                         self.transform = rightWobble;
                     } completion:nil];
    
    [self addDeleteModeExitGesture];
}

- (void)exitDeletionMode
{
    [self.deleteButtonConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        constraint.constant = 0.0f;
    }];
    [UIView animateWithDuration:0.2f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self addDeleteModeEnterGesture];
        [self.layer removeAllAnimations];
        self.transform = CGAffineTransformIdentity;
        [self.deleteButton removeFromSuperview];
        self.deleteButton = nil;
    }];
}

- (void)setStack:(Stack *)stack
{
    _stack = stack;
    [self configureAbbrLabel];
    [self configureStackNameLabel];
}

- (void)addDeleteModeEnterGesture
{
    if (self.longPressGesture) {
        [self removeGestureRecognizer:self.longPressGesture];
    }
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if (state != UIGestureRecognizerStateEnded) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EnterDeletionModeNotification object:nil];
        }
    }];
    [self addGestureRecognizer:self.longPressGesture];
}

- (void)addDeleteModeExitGesture
{
    [self removeGestureRecognizer:self.longPressGesture];
    self.longPressGesture = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if (state == UIGestureRecognizerStateEnded) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ExitDeletionModeNotification object:nil];
            }
    }];
    [self addGestureRecognizer:self.longPressGesture];
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

- (void)createDeleteButton
{
    self.deleteButton = [DeleteButton new];
    [self.deleteButton bk_addEventHandler:^(id sender) {
        UIAlertView *alert = [[UIAlertView alloc] bk_initWithTitle:@"Remove this stack?" message:[NSString stringWithFormat:@"Do you want to remove yourself from the '%@' stack?", self.stack.name]];
        [alert bk_addButtonWithTitle:@"Yes" handler:^{
            [self removeStackFromServer];
        }];
        [alert bk_setCancelButtonWithTitle:@"No" handler:^{
        }];
        [alert show];
    } forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];

    self.deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.deleteButton.layer.cornerRadius = DeleteButtonSize/2;
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
    if (vowelsRemoved.length > 0) {
        [abbr appendString:[[vowelsRemoved substringToIndex:1] capitalizedString]];
    } else {
        [abbr appendString:[self.stack.name substringWithRange:NSMakeRange(1, 1)]];
    }
    self.stackNameAbbrLabel.attributedText = [[NSAttributedString alloc] initWithString:abbr attributes:attrs];
//    self.stackNameAbbrLabel.text = abbr;
}

- (void)addLayoutConstraints
{
    UIBind(self.stackNameAbbrLabel, self.fullStackNameLabel);
    [self addConstraintWithVisualFormat:@"H:|[stackNameAbbrLabel]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"H:|[fullStackNameLabel]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|[stackNameAbbrLabel][fullStackNameLabel(35)]-|" bindings:BBindings];
}


- (void)removeStackFromServer
{
    [self.stack removeMyStackOnServerWithCompletion:^{
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, id parsedError) {
    }];
}

@end
