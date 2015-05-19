#import "Card+Helpers.h"

static NSString *kCouchIDAttr = @"couchID";
static NSString *kCouchRevAttr = @"couchRev";
static NSString *kCouchDefinitionKey = @"definition";
static NSString *kCouchTermKey = @"term";
static NSString *kCouchIDKey = @"_id";
//static NSString *kCouchRevKey = @"_re

@implementation KTCard (Helpers)
+ (instancetype)getOrCreateCardWithCouchDBQueryRow:(CBLQueryRow *)row inContext:(NSManagedObjectContext *)context
{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"couchID == %@", row.document.documentID];
    
    NSArray *cardArray = [KTCard MR_findAllWithPredicate:pred inContext:context];
    KTCard *card;
    if ([cardArray count] == 1) {
        card = [cardArray firstObject];
        if ([card.couchRev isEqualToString:row.documentRevisionID] == NO) {
            [card updateWithRow:row];
        }
    } else if ([cardArray count] == 0) {
        card = [KTCard newCardWithQueryRow:row inContext:context];
    }
    return card;
}

+ (instancetype)newCardWithQueryRow:(CBLQueryRow *)row inContext:(NSManagedObjectContext *)context
{
    KTCard *newCard = [KTCard MR_createInContext:context];
    [newCard updateWithRow:row];
    return newCard;
}

- (void)updateWithRow:(CBLQueryRow *)row
{
    self.definition = row.document[kCouchDefinitionKey];
    self.term = row.document[kCouchTermKey];
    self.couchID = row.documentID;
    self.couchRev = row.documentRevisionID;
    self.knowledgeScore = @(0);
}

- (void)updateCouchWithChanges
{
    
}

//+ (NSArray *)allCards {
////    [self
//}

@end
