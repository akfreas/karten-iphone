#import "NSManagedObject+JSONParsable.h"
#import "JSONParsable.h"
#import "NSDateFormatter+ServerFormatters.h"

@implementation NSManagedObject (JSONParsable)

static NSString *kLocalServerID = @"serverID";
static NSString *kRemoteServerID = @"id";

+ (id)objectWithJSONDictionary:(NSDictionary *)dictionary
{
    return [self objectWithJSONDictionary:dictionary context:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (NSManagedObject *)objectWithJSONDictionary:(NSDictionary *)dictionary context:(NSManagedObjectContext *)ctx
{
    
    if ([self conformsToProtocol:@protocol(JSONParsable)] == NO) {
        return nil;
    }
    
    NSManagedObject *object = [self MR_findFirstByAttribute:kLocalServerID withValue:dictionary[kRemoteServerID] inContext:ctx];
    if (object == nil) {
        object = [self MR_createInContext:ctx];
    }
    [object updateWithJSONDictionary:dictionary inContext:ctx];
    
    return object;
}

- (void)updateWithJSONDictionary:(NSDictionary *)dictionary
{
    [self updateWithJSONDictionary:dictionary inContext:[NSManagedObjectContext MR_defaultContext]];
}

- (void)updateWithJSONDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)ctx
{
    NSDictionary *attributes = self.entity.attributesByName;
    for (NSString *attribute in attributes) {
        NSAttributeDescription *description = attributes[attribute];
        NSString *serverKey = description.userInfo[@"server_key"];
        if (serverKey != nil) {
            id value = dictionary[serverKey];
            if (value != nil && [value class] != [NSNull class]) {
                if ([description attributeType] == NSDateAttributeType) {
                    value = [[NSDateFormatter serverFormatter] dateFromString:[NSString stringWithString:value]];
                }
                [self setValue:value forKey:attribute];
            }
        }
    }
    
    NSDictionary *relationships = self.entity.relationshipsByName;
    for (NSString *relationship in relationships) {
        NSRelationshipDescription *relationshipDescription = relationships[relationship];
        id relatedObjectData = dictionary[relationshipDescription.userInfo[@"server_key"]];
        if (relatedObjectData == nil) {
            continue;
        }
        Class parseClass = NSClassFromString(relationshipDescription.destinationEntity.managedObjectClassName);
        if (relationshipDescription.maxCount == 1) {
            NSManagedObject *relatedObject = [parseClass objectWithJSONDictionary:relatedObjectData context:ctx];
            [self setValue:relatedObject forKey:relationshipDescription.name];
        } else if ([relatedObjectData conformsToProtocol:@protocol(NSFastEnumeration)]) {
            NSMutableSet *newSet = [NSMutableSet set];
            for (id object in relatedObjectData) {
                id newObject = [parseClass objectWithJSONDictionary:object];
                [newSet addObject:newObject];
            }
            [self setValue:newSet forKey:relationshipDescription.name];
        }
    }
}

@end
