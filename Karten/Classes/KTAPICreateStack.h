#import "KartenAPICall.h"
@class Stack;
@interface KTAPICreateStack : NSObject <KartenAPICall>
- (id)initWithStack:(Stack *)stack;
@end
