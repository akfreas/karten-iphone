#import "InfoDisplayView.h"

@interface InfoDisplayView ()

@property (nonatomic, retain) UILabel *displayTextLabel1;
@property (nonatomic, retain) UILabel *displayTextLabel2;

@property (nonatomic, retain) NSString *displayText1;
@property (nonatomic, retain) NSString *displayText2;

@end

@implementation InfoDisplayView

-(void)addDisplayTextLabel1 {
    self.displayTextLabel1 = [UILabel newAutoLayoutView];
    [self addSubview:self.displayTextLabel1];
    self.displayTextLabel1.font = [UIFont systemFontOfSize:20];
    self.displayTextLabel1.textAlignment = NSTextAlignmentLeft;
}


-(void)addDisplayTextLabel2 {
    self.displayTextLabel2 = [UILabel newAutoLayoutView];
    [self addSubview:self.displayTextLabel2];
    self.displayTextLabel2.font = [UIFont systemFontOfSize:20];
    self.displayTextLabel2.textAlignment = NSTextAlignmentRight;
}

-(void)setDisplayTextLeft:(NSString *)left right:(NSString *)right {
    if (self.displayTextLabel1 == nil && self.displayTextLabel2 == nil) {
        [self addDisplayTextLabel1];
        [self addDisplayTextLabel2];
        UIBind(self.displayTextLabel1, self.displayTextLabel2);
        
        [self addConstraintWithVisualFormat:@"H:|[displayTextLabel1][displayTextLabel2]|" bindings:BBindings];

        [self addConstraintWithVisualFormat:@"V:|[displayTextLabel1]|" bindings:BBindings];
        [self addConstraintWithVisualFormat:@"V:|[displayTextLabel2]|" bindings:BBindings];
    }
    self.displayTextLabel1.text = left;
    self.displayTextLabel2.text = right;
}
-(void)setDisplayText1:(NSString *)displayText {
    
    self.displayTextLabel1.text = displayText;
    _displayText1 = displayText;
}

- (void)setDisplayText2:(NSString *)displayText2
{
    if (self.displayTextLabel2 == nil) {
        [self addDisplayTextLabel2];
    }
    self.displayTextLabel2.text = displayText2;
    _displayText2 = displayText2;
}

@end
