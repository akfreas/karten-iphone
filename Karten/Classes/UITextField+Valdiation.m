#import "UITextField+Valdiation.h"
#import <objc/runtime.h>

char * const kValidatorKey = "ValidatorKey";

@implementation UITextField (Valdiation)

-(void)setValidationRule:(BOOL(^)(UITextField *sender))validationBlock {
    objc_setAssociatedObject(self, kValidatorKey, validationBlock, OBJC_ASSOCIATION_COPY);
}

-(BOOL(^)(UITextField *sender))validationRule {
    return objc_getAssociatedObject(self, kValidatorKey);
}

-(BOOL)isValid {
    BOOL(^validationBlock)(UITextField *sender) = self.validationRule;
    BOOL retVal = NO;
    if (validationBlock != NULL) {
        retVal = validationBlock(self);
    }
    return retVal;
}

@end
