#import "KartenAPICall.h"

@class KTStack;

@interface KTAPIUnShareStack : NSObject <KartenAPICall>
- (instancetype)initWithStack:(KTStack *)stack unShareUsers:(NSArray *)users;
@end
