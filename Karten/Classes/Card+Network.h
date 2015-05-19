@class Stack;
#import "KTCard.h"


@interface KTCard (Network)
- (void)addCardToStackOnServer:(Stack *)stack error:(NSError **)error;
- (void)updateCardOnCouch:(NSError **)error;
@end
