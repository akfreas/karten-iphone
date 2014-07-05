#import "KartenAPICall.h"
@class Stack;
@interface KTAPIAddUserToStack : NSObject <KartenAPICall>

- (id)initWithStack:(Stack *)stack linkToUserID:(NSString *)userID;

@end
