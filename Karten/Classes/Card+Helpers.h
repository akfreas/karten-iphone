#import "KTCard.h"
#import <CoreData/CoreData.h>
@interface KTCard (Helpers)

+ (instancetype)getOrCreateCardWithCouchDBQueryRow:(CBLQueryRow *)row inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allCards;

@end
