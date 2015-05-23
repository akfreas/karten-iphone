#import "KartenAPICall.h"
@class KTStack;
@interface KTAPIAddUserToStack : NSObject <KartenAPICall>

- (id)initWithStack:(KTStack *)stack linkToUserID:(NSString *)userID;

@end
