#import "KartenAPICall.h"

@class Stack;

@interface KTAPIUnShareStack : NSObject <KartenAPICall>
- (instancetype)initWithStack:(Stack *)stack unShareUsers:(NSArray *)users;
@end
