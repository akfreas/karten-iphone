#import "KartenAPICall.h"

@class Stack;

@interface KTAPIShareStack : NSObject <KartenAPICall>
- (instancetype)initWithStack:(Stack *)stack shareUsers:(NSArray *)users;
@end
