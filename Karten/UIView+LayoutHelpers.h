#import <UIKit/UIKit.h>

#define UIBind(...) NSDictionary *BBindings = AKDictionaryOfVariableBindings(__VA_ARGS__)
#define AKDictionaryOfVariableBindings(...) _AKDictionaryOfVariableBindings(@"" # __VA_ARGS__, __VA_ARGS__, nil)
NSDictionary * _AKDictionaryOfVariableBindings(NSString *commaSeparatedKeysString, id firstValue, ...);

@interface NSDictionary (MXConstraint)
+ (NSDictionary *)MXTranslateAutoresizingMaskIntoConstraints:(NSDictionary *)bindings;
@end


@interface UIView (LayoutHelpers)
-(NSArray *)addConstraintWithVisualFormat:(NSString *)format bindings:(NSDictionary *)bindings;
@end
