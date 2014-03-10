@interface UITextField (Valdiation)

@property (nonatomic, copy) BOOL(^validationRule)(UITextField *sender);

-(BOOL)isValid;

@end
