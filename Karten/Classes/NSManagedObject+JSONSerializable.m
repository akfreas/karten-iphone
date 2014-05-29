#import "NSManagedObject+JSONSerializable.h"
#import <objc/runtime.h>

@implementation NSManagedObject (JSONSerializable)

- (NSDictionary *)JSONDictionarySerialization
{
    // Get a list of all properties in the class.
    NSMutableDictionary *JSONDict = [NSMutableDictionary dictionary];
    NSDictionary *attributes = self.entity.attributesByName;
    for (NSString *attribute in attributes) {
        NSAttributeDescription *description = attributes[attribute];
        NSString *serverKey = description.userInfo[@"server_key"];
        if (serverKey != nil) {
            id value = [self valueForKey:description.name];
            [JSONDict setValue:value forKey:serverKey];
        }
    }
    NSDictionary *relationships = self.entity.relationshipsByName;

    for (NSString *relationship in relationships) {
        NSRelationshipDescription *relationshipDescription = relationships[relationship];
        NSString *serverKey = relationshipDescription.userInfo[@"server_key"];
        if (serverKey == nil) {
            continue;
        }
        id value = [self valueForKey:relationshipDescription.name];
        if (relationshipDescription.maxCount == 1) {
            NSDictionary *relatedObjectDict = [value JSONDictionarySerialization];
            [JSONDict setValue:relatedObjectDict forKey:serverKey];
        } else if ([value conformsToProtocol:@protocol(NSFastEnumeration)] && [value count] > 0) {
            NSMutableSet *newSet = [NSMutableSet set];
            for (id object in value) {
                id newObject = [object JSONDictionarySerialization];
                [newSet addObject:newObject];
            }
            [JSONDict setValue:newSet forKey:serverKey];
        }
    }
    return JSONDict;
}

@end
