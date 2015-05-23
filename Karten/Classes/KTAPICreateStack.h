#import "KartenAPICall.h"
@class KTStack;
@interface KTAPICreateStack : NSObject <KartenAPICall>
- (id)initWithStack:(KTStack *)stack;
@end
