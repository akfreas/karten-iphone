#import "NSObject+NSDictionaryRepresentation.h"
#import <objc/runtime.h>


@implementation NSURLRequest (CURL)
- (NSString *)curlCommand
{
    NSString *(^stringFromDict)(NSDictionary *dict) = ^NSString*(NSDictionary *dict){
        
        NSMutableString *paramString = [NSMutableString stringWithString:@"{ "];
        for (NSString *key in dict) {
            NSString *param = [NSString stringWithFormat:@"\"%@\" : \"%@\", ", key, dict[key]];
            [paramString appendString:param];
        }
        [paramString appendString:@" }"];
        return paramString;
    };
    
    NSMutableString *fullParamString = [NSMutableString stringWithString:@""];
    if (self.HTTPBody) {
        id data = [NSJSONSerialization JSONObjectWithData:self.HTTPBody options:0 error:nil];
        if ([data isKindOfClass:[NSArray class]]) {
            [fullParamString appendString:@"[%@"];
            for (NSDictionary *dict in data) {
                [fullParamString appendString:stringFromDict(dict)];
            }
            [fullParamString appendString:@"]"];
        } else {
            fullParamString =  [stringFromDict(data) mutableCopy];
        }
    }
    NSMutableString *headerString = [NSMutableString string];
    for (NSString *key in [self allHTTPHeaderFields]) {
        [headerString appendFormat:@" -H \"%@: %@\"", key, [self valueForHTTPHeaderField:key]];
    }
    NSString *command = [NSString stringWithFormat:@"curl -X %@ %@ -d '%@' %@", self.HTTPMethod, headerString, fullParamString, [self.URL absoluteString]];
    return command;
}
@end


@implementation NSObject (NSDictionaryRepresentation)

+(NSArray *)propertyList {
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *array = [NSMutableArray new];
    for (unsigned int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        // Only add to the NSDictionary if it's not nil.
        [array addObject:key];
    }
    
    free(properties);
    
    return array;
}

//- (NSString *)description {
//    return [self dictionaryRepresentation];
//}

- (NSDictionary *)dictionaryRepresentation {
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary setObject:self.class forKey:@"ObjectClass"];
    for (unsigned int i = 0; i < count; i++) {
        @try {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            NSString *value = [self valueForKey:key];
            
            // Only add to the NSDictionary if it's not nil.
            if (value)
                [dictionary setObject:value forKey:key];
        }
        @catch (NSException *exception) {
            DLog(@"Exception creating dict: %@", exception);
        }
        @finally {
            
        }
    }
    
    free(properties);
    
    return dictionary;
}

@end
