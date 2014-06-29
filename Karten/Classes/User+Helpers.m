#import "User+Helpers.h"
#import "NSManagedObject+JSONParsable.h"
#import "KartenDBExceptions.h"
@implementation User (Helpers)

+ (User *)getOrCreateUserWithJSONDict:(NSDictionary *)JSON
{
    NSString *externalService = JSON[@"external_service"];
    NSString *externalID = JSON[@"external_user_id"];
    User *user = nil;
    if (externalService != nil && externalID != nil) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"externalService == %@ && externalUserID == %@", externalService, externalID];
        NSArray *users = [User MR_findAllWithPredicate:pred];
        if ([users count] > 1) {
            [NSException raise:kKartenDBErrorMultipleUsersMarkedAsMainUser format:@"Multiple users found that are marked as main user! Users: %@", users];
        } else if ([users count] == 0) {
            user = [User objectWithJSONDictionary:JSON];
        } else {
            user = [users firstObject];
        }
    } else {
        user = [User objectWithJSONDictionary:JSON];
    }
    return user;
}

+ (User *)mainUser
{
    NSPredicate *mainUserPred = [NSPredicate predicateWithFormat:@"mainUser == YES"];
    NSArray *users = [User MR_findAllWithPredicate:mainUserPred];
    if ([users count] > 1) {
        [NSException raise:kKartenDBErrorMultipleUsersMarkedAsMainUser format:@"Multiple users found that are marked as main user! Users: %@", users];
    }
    User *mainUser = [users firstObject];
    return mainUser;
}

@end
