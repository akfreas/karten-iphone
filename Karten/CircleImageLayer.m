#import "CircleImageLayer.h"
#import "CGRectUtils.h"

@implementation CircleImageLayer {
    

    CGFloat _radius;
    CGFloat _borderWidth;
    CGMutablePathRef circlePath;
    CGColorRef ourBorderColor;
}


@dynamic radius;


-(id)initWithRadius:(CGFloat)theRadius {
    self = [self init];
    if (self) {
        _radius = theRadius;
        self.frame = CGRectMake(0, 0, theRadius * 2 + 2.0f, theRadius * 2 + 2.0f);
        self.borderWidth = 2.0f;
    }
    return self;
}

-(id)init {
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
        ourBorderColor = [UIColor clearColor].CGColor;
        [self setNeedsDisplay];
    }
    return self;
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.frame = CGRectMake(0, 0, _radius * 2 + borderWidth, _radius * 2 + self.borderWidth);
}

-(id)initWithImage:(UIImage *)theImage radius:(CGFloat)theRadius {
    
    if (self == [self initWithRadius:theRadius]) {
        _image = theImage;
//        [self drawImageInHostingLayer];
    }
    
    return self;
}

-(id)initWithLayer:(id)layer {
    if (self = [super initWithLayer:layer]) {
        if ([layer isKindOfClass:[CircleImageLayer class]]) {
            CircleImageLayer *imageLayer = (CircleImageLayer *)layer;
            self.image = imageLayer.image;
        }
    }
    return self;
}

-(CAAnimation *)makeAnimationForKey:(NSString *)key {
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    if ([key isEqualToString:@"radius"]) {
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
        
        anim.fromValue = [[self presentationLayer] valueForKey:key];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        anim.duration = 2.0;
    }
    return animGroup;
}


-(id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"radius"]) {
        return [self makeAnimationForKey:event];
    }
    return [super actionForKey:event];
}

-(void)setRadius:(CGFloat)radius {
    _radius = radius;
    [self setNeedsDisplay];
}

+(BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"transform"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

-(void)setBorderColor:(CGColorRef)borderColor {
    ourBorderColor = CGColorCreateCopy(borderColor);
    [self setNeedsDisplay];
}

-(void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}


-(void)drawInContext:(CGContextRef)ctx {
    
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);

    CGFloat height = self.bounds.size.height;
    CGContextTranslateCTM(ctx, 0.0, height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, center.x, center.y);
    
    CGContextAddArc(ctx, center.x, center.y, _radius - 2, 0, M_PI * 2, 1);
    CGContextClosePath(ctx);
    
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    CGPathDrawingMode drawingMode;
    
    if (_image != nil) {
        
        CGSize imgSize = _image.size;
        CGFloat scale = MAX((_radius * 2) / imgSize.width, (_radius * 2) / imgSize.height);
        CGFloat imageWidth = _image.size.width * scale;
        CGFloat imageHeight = _image.size.height * scale;
        CGRect imgRect;
        imgRect = CGRectMakeFrameForDeadCenterInRect(self.bounds, CGSizeMake(imageWidth, imageHeight));
        CGContextDrawImage(ctx, imgRect, _image.CGImage);
        CGContextRestoreGState(ctx);
        drawingMode = kCGPathStroke;

    } else {
        CGContextSetFillColorWithColor(ctx, [UIColor grayColor].CGColor);
        drawingMode = kCGPathFillStroke;
    }
    if (_borderWidth > 0) {
        CGContextAddArc(ctx, center.x, center.y, _radius - _borderWidth / 2 - 2, 0, M_PI * 2, 1);
        CGContextSetLineWidth(ctx, _borderWidth + 0.5f);
        CGContextSetStrokeColorWithColor(ctx, ourBorderColor);
        CGContextDrawPath(ctx, drawingMode);
    }
}

@end
