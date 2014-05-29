
#import <Foundation/Foundation.h>

@protocol JSONParsable <NSObject>

+ (id)objectWithJSONDictionary:(NSDictionary *)dictionary;
- (void)updateWithJSONDictionary:(NSDictionary *)dictionary;
@end
