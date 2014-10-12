#import "CircleImageView.h"
#import "CircleImageLayer.h"

@implementation CircleImageView {
    
    CircleImageLayer *circleLayer;
}


+(Class)layerClass {
    return [CircleImageLayer class];
}

-(id)initWithImage:(UIImage *)theImage radius:(CGFloat)theRadius {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.radius = theRadius;
        self.backgroundColor = [UIColor clearColor];
        self.contentScaleFactor = [UIScreen mainScreen].scale;
        [(CircleImageLayer *)self.layer setRadius:theRadius];
        [(CircleImageLayer *)self.layer setImage:theImage];
        [(CircleImageLayer *)self.layer setBorderWidth:2.0f];
    }
    return self;
}

-(void)setImage:(UIImage *)image {
    [(CircleImageLayer *)self.layer setImage:image];
}

-(void)setRadius:(CGFloat)radius {
    _radius = radius;
    [(CircleImageLayer *)self.layer setRadius:radius];
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    [(CircleImageLayer *)self.layer setBorderWidth:borderWidth];
}

-(void)setBorderColor:(UIColor *)borderColor {
    [(CircleImageLayer *)self.layer setBorderColor:borderColor.CGColor];
}

-(void)layoutSubviews {
    self.layer.frame = self.frame;
    [super layoutSubviews];
}

-(void)setFrame:(CGRect)frame {
    self.layer.frame = frame;
    [super setFrame:frame];
}

-(CGSize)intrinsicContentSize {
    CGSize contentSize = CGSizeMake(_radius * 2, _radius * 2);
    return contentSize;
}

@end
