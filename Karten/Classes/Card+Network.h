@class Stack;
#import "Card.h"


@interface Card (Network)
- (void)addCardToStackOnServer:(Stack *)stack error:(NSError *)error;

@end