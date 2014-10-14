#import "AccessoryViews.h"

@interface SharedAccessoryView ()
@property (nonatomic) UIImageView *imageView;
@end

@implementation SharedAccessoryView


- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView
{
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Friend"]];
    self.imageView.frame = self.bounds;
    [self addSubview:self.imageView];
}


@end
