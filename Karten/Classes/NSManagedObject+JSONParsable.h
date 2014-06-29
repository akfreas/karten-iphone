@interface NSManagedObject (JSONParsable)

+ (id)objectWithJSONDictionary:(NSDictionary *)dictionary;

- (void)updateWithJSONDictionary:(NSDictionary *)dictionary;
- (void)updateWithJSONDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)ctx;

@end
