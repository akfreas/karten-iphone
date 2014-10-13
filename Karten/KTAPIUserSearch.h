#import "KartenAPICall.h"

@interface KTAPIUserSearch : NSObject <KartenAPICall>
- (instancetype)initWithQuery:(NSString *)query;
@end
