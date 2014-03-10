#import "InfoDisplayView.h"

@interface InfoDisplayView ()

@property (nonatomic, retain) UILabel *displayTextLabel;

@end

@implementation InfoDisplayView

-(void)addDisplayTextLabel {
    self.displayTextLabel = [UILabel newAutoLayoutView];
    [self addSubview:self.displayTextLabel];
    self.displayTextLabel.font = [UIFont systemFontOfSize:20];
    UIBind(self.displayTextLabel);
//    [self addConstraintWithVisualFormat:@"H:|[displayTextLabel]|" bindings:BBindings];
//    [self addConstraintWithVisualFormat:@"V:|[displayTextLabel]|" bindings:BBindings];
}

-(void)setDisplayText:(NSString *)displayText {
    if (self.displayTextLabel == nil) {
        [self addDisplayTextLabel];
    }
    UIBind(self.displayTextLabel);

    [self addConstraintWithVisualFormat:@"H:|[displayTextLabel]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|[displayTextLabel]|" bindings:BBindings];
    self.displayTextLabel.text = displayText;
    _displayText = displayText;
}

@end
