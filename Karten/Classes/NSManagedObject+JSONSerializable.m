#import "NSManagedObject+JSONSerializable.h"
#import <objc/runtime.h>

@implementation NSManagedObject (JSONSerializable)

- (NSDictionary *)JSONDictionarySerialization
{
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *JSONDict = [NSMutableDictionary dictionary];
    for (unsigned int i = 0; i < count; i++) {
        @try {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            NSString *value = [self valueForKey:key];
            
            // Only add to the NSDictionary if it's not nil.
            if (value) {
                NSEntityDescription *ourDescription = self.entity;
                if ([ourDescription.attributesByName.allKeys containsObject:key]) {
                    NSAttributeDescription *attributeDescription = ourDescription.attributesByName[key];
                    NSString *serverKey = attributeDescription.userInfo[@"server_info"];
                    JSONDict[serverKey] = value;
                }
            }
        }
        @catch (NSException *exception) {
        }
        @finally {
            
        }
    }
    
    free(properties);
   
}

@end
