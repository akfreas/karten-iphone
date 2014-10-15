#import "FacebookSessionManager.h"
#import "KTAPICreateUser.h"
#import "KartenNetworkClient.h"
#import "User+Helpers.h"
#import "User.h"

@interface FacebookSessionManager ()

@property (nonatomic, strong) NSArray *friends; // of NSDictionaries
@end

@implementation FacebookSessionManager

static FacebookSessionManager *sharedInstance;

+(FacebookSessionManager *)sharedInstance
{
    //dispatch_once executes a block object only once for the lifetime of an application.
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Getters & Setters


-(void)checkToken
{
    if([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded){
        BOOL cachedTokenExists = [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"user_friends"]
                                                                    allowLoginUI:NO
                                                               completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                                                   [self sessionStateChanged:session state:status error:error];
                                                               }];
        if(cachedTokenExists){
            NSLog(@"Success! Facebook session is open, a cached token exists");
            [self updateBasicInformation];
        }
    } else {
        NSLog(@"cached token does not exist");
        [self closeAndClearSession];
    }
}

-(void)logInWithCompletion:(void (^)(BOOL loggedIn))completion
{
    NSLog(@"logInWithCompletion...");
    if([FBSession activeSession].state != FBSessionStateOpen || [FBSession activeSession].state != FBSessionStateOpenTokenExtended){
        // Open a session showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          [FBSession setActiveSession:session];
                                          if(status == FBSessionStateOpen || status == FBSessionStateOpenTokenExtended){
                                              [self updateBasicInformation];
                                              completion(YES);
                                              
                                          } else {
                                              completion(NO);
                                          }
                                          
                                          [self sessionStateChanged:session state:status error:error];
                                      }];
    } else {
        completion(YES);
    }
}

-(void)updateBasicInformation
{
    NSLog(@"updateBasicInformation...");
    [self checkPermissions];
    [self createUserFromFacebookSession:NULL];
    [self getFacebookFriends];
}

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    // Called EVERY time the session state changes
    self.session = session;
    [self handleStateChange:state];
    if(error){
        [self handleError:error];
    }
}

-(void)handleStateChange:(FBSessionState)status
{
    switch (status) {
            
        case FBSessionStateCreated:
            NSLog(@"FBSessionStateCreated");
            NSLog(@"  - no token has been found (yet).");
            break;
            
        case FBSessionStateCreatedTokenLoaded:
            NSLog(@"FBSessionStateCreatedTokenLoaded");
            NSLog(@"  - token has been found, but session isn't open");
            break;
            
        case FBSessionStateOpen:
            NSLog(@"FBSessionStateOpen");
            NSLog(@"  - session finished opening");
            NSLog(@"  - other API features can be accessed");
            break;
            
        case FBSessionStateClosed:
            NSLog(@"FBSessionStateClosed");
            [self closeAndClearSession];
            break;
            
        case FBSessionStateClosedLoginFailed:
            NSLog(@"FBSessionStateClosedLoginFailed");
            [self closeAndClearSession];
            break;
            
        case FBSessionStateCreatedOpening:
            NSLog(@"FBSessionStateCreatedOpening");
            break;
            
        case FBSessionStateOpenTokenExtended:
            NSLog(@"FBSessionStateOpenTokenExtended");
            break;
            
        default:
            NSLog(@"handleStateChange default");
            break;
    }
}

-(void)handleError:(NSError *)error
{
    NSString *alertMessage;
    NSString *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please connect with Facebook again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        
        NSString *errorString;
        switch ([FBErrorUtility errorCategoryForError:error]) {
            case 0:
                /*! Indicates that the error category is invalid and likely represents an error that
                 is unrelated to Facebook or the Facebook SDK */
                errorString = @"FBErrorCategoryInvalid";
                break;
            case 1:
                /*! Indicates that the error may be authentication related but the application should retry the operation.
                 This case may involve user action that must be taken, and so the application should also test
                 the fberrorShouldNotifyUser property and if YES display fberrorUserMessage to the user before retrying.*/
                errorString = @"FBErrorCategoryRetry";
                break;
            case 3:
                /*! Indicates that the error is permission related */
                errorString = @"FBErrorCategoryPermissions";
                break;
            case 4:
                /*! Indicates that the error implies that the server had an unexpected failure or may be temporarily down */
                errorString = @"FBErrorCategoryServer";
                break;
            case 5:
                /*! Indicates that the error results from the server throttling the client */
                errorString = @"FBErrorCategoryFacebookOther";
                break;
            case -1:
                /*! Indicates that the error is Facebook-related but is uncategorizable, and likely newer than the
                 current version of the SDK */
                errorString = @"FBErrorCategoryInvalid";
                break;
            case -2:
                /*! Indicates that the error is an application error resulting in a bad or malformed request to the server. */
                errorString = @"FBErrorCategoryBadRequest";
                break;
                
            default:
                NSLog(@"Unexpected error:%@", error);
                break;
        }
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

-(void)closeAndClearSession
{
    NSLog(@"closeAndClearSession...");
    [[FBSession activeSession] closeAndClearTokenInformation];
}


-(void)checkPermissions
{
    NSLog(@"checkPermissions...");
    
    // Check for publish permissions
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  if([result isKindOfClass:[NSArray class]]){
                                      for(NSString *permission in (NSArray *)[result data]){
                                          NSLog(@"permission = %@",permission);
                                      }
                                  }
                              } else {
                                  // Publish permissions found, publish the OG story
                                  
                                  NSLog(@"error retrieving permissions = %@",error.localizedDescription);
                              }
                          }];
}

- (FBSession *)session
{
    if (_session == nil) {
        _session = [[FBSession alloc] initWithPermissions:@[@"public_profile", @"user_friends"]];
    }
    return _session;
}

- (void)createUserFromFacebookSession:(void(^)(User *user, NSError *error))userCreationCompletion
{
    NSLog(@"getUserInfo...");
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            if([result isKindOfClass:[FBGraphObject class]]){
                FBGraphObject *graphObject = (FBGraphObject *)result;
                
                NSLog(@"graphObject = %@",graphObject);
                [graphObject setObject:graphObject[@"id"] forKey:@"external_user_id"];
                [graphObject setObject:@"facebook" forKey:@"external_service"];
                [graphObject removeObjectForKey:@"id"];
                [graphObject setObject:@YES forKey:@"registered"];
                User *currentUser = [User getOrCreateUserWithJSONDict:graphObject];
                currentUser.mainUser = @YES;
                [currentUser.managedObjectContext MR_saveOnlySelfAndWait];
                KTAPICreateUser *createUserCall;
                [KartenNetworkClient makeRequest:createUserCall
                                      completion:^{
                                          
                                      } success:^(AFHTTPRequestOperation *operation, User *responseObject) {
                                          NSManagedObjectContext *ctx = [NSManagedObjectContext MR_contextForCurrentThread];
                                          User *savedUser = (User *)[ctx objectWithID:currentUser.objectID];
                                          savedUser.serverID = responseObject.serverID;
                                          [ctx MR_saveOnlySelfAndWait];
                                          if (userCreationCompletion) {
                                              userCreationCompletion(savedUser, nil);
                                          }
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          
                                      }];
                
            }
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

-(void)getFacebookInfoAtGraphPath:(NSString *)path
{
    NSLog(@"getFacebookInfoAtGraphPath...");
    [FBRequestConnection startWithGraphPath:path
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Sucess! Include your code to handle the results here
                                  NSLog(@"user events: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}

-(void)getFacebookFriends
{
    NSLog(@"getFacebookFriends...");
    FBRequest *friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        self.friends = [result objectForKey:@"data"];
        NSLog(@"Found: %i friends", self.friends.count);
        
//        FacebookUserConverter *facebookUserConverter = [[FacebookUserConverter alloc] init];
        
        for (NSDictionary<FBGraphUser>* friend in self.friends) {
//            [facebookUserConverter createOrModifyObjectWithFacebookDictionary:friend];
        }
    }];
}


#pragma mark - FBLoginViewDelegate

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                           user:(id<FBGraphUser>)user
{
    NSLog(@"loginView is now in logged in mode");
    NSLog(@"user.id = %@",user.id);
    NSLog(@"user.name = %@",user.name);
    [self updateBasicInformation];
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"loginViewShowingLoggedInUser...");
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"loginViewShowingLoggedOutUser...");
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"FBLoginViewDelegate - There was a communication or authorization error - %@.",error.localizedDescription);
    [[FacebookSessionManager sharedInstance] sessionStateChanged:nil state:0 error:error];
}

@end
