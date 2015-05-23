@class KTStack;
#import "KTCard.h"


@interface KTCard (Network)
- (void)addCardToStackOnServer:(KTStack *)stack error:(NSError **)error;
- (void)updateCardOnCouch:(NSError **)error;
@end
