@interface NSManagedObject (JSONParsable)

+ (id)objectWithJSONDictionary:(NSDictionary *)dictionary;

- (void)updateWithJSONDictionary:(NSDictionary *)dictionary;


@end
