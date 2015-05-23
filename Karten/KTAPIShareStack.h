#import "KartenAPICall.h"

@class KTStack;

@interface KTAPIShareStack : NSObject <KartenAPICall>
- (instancetype)initWithStack:(KTStack *)stack shareUsers:(NSArray *)users;
@end
