@class User;
#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookSessionManager : NSObject <FBLoginViewDelegate>
@property (nonatomic) FBSession *session;
+(FacebookSessionManager *)sharedInstance;

-(void)checkToken; // Silent, on app load
-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
- (void)createUserFromFacebookSession:(void(^)(User *user, NSError *error))completion;
@end
