#import "UIView+LayoutHelpers.h"

@implementation NSDictionary (MXConstraint)

+(NSDictionary *)MXTranslateAutoresizingMaskIntoConstraints:(NSDictionary *)bindings
{
    for (id key in bindings)
    {
        UIView *view = (UIView *)[bindings objectForKey:key];
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return bindings;
}

@end

#pragma mark -
@implementation UIView (LayoutHelpers)

- (NSArray *)addConstraintWithVisualFormat:(NSString *)format bindings:(NSDictionary *)bindings
{
   NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                            options:0
                                            metrics:nil
                                              views:bindings];
    [self addConstraints:constraints];
    return constraints;
}

NSDictionary * _AKDictionaryOfVariableBindings(NSString *commaSeparatedKeysString, UIView *firstView, ...) {
    NSArray *keys = [commaSeparatedKeysString componentsSeparatedByString:@", "];
    va_list listPtr;
    va_start(listPtr, [keys count]);
    UIView *currentView = firstView;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (int i=0; i<[keys count]; i++) {
        currentView.translatesAutoresizingMaskIntoConstraints = NO;
        NSString *key = [keys[i] stringByReplacingOccurrencesOfString:@"self." withString:@""];
        [dict setObject:currentView forKey:key];
        currentView = va_arg(listPtr, UIView *);
    }
    return dict;
}

@end