#import "Card.h"
#import <CoreData/CoreData.h>
@interface Card (Helpers)

+ (instancetype)getOrCreateCardWithCouchDBQueryRow:(CBLQueryRow *)row inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allCards;

@end
