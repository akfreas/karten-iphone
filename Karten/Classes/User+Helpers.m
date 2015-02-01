#import "User+Helpers.h"
#import "NSManagedObject+JSONParsable.h"
#import "KartenDBExceptions.h"
@implementation KTUser (Helpers)

+ (KTUser *)getOrCreateUserWithJSONDict:(NSDictionary *)JSON
{
    NSString *externalService = JSON[@"external_service"];
    NSString *externalID = JSON[@"external_user_id"];
    KTUser *user = nil;
    if (externalService != nil && externalID != nil) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"externalService == %@ && externalUserID == %@", externalService, externalID];
        NSArray *users = [KTUser MR_findAllWithPredicate:pred];
        if ([users count] > 1) {
            [NSException raise:kKartenDBErrorMultipleUsersMarkedAsMainUser format:@"Multiple users found that are marked as main user! Users: %@", users];
        } else if ([users count] == 0) {
            user = [KTUser objectWithJSONDictionary:JSON];
        } else {
            user = [users firstObject];
        }
    } else {
        user = [KTUser objectWithJSONDictionary:JSON];
    }
    return user;
}

+ (KTUser *)mainUser
{
    NSPredicate *mainUserPred = [NSPredicate predicateWithFormat:@"mainUser == YES"];
    NSArray *users = [KTUser MR_findAllWithPredicate:mainUserPred];
    if ([users count] > 1) {
        [NSException raise:kKartenDBErrorMultipleUsersMarkedAsMainUser format:@"Multiple users found that are marked as main user! Users: %@", users];
    }
    KTUser *mainUser = [users firstObject];
    return mainUser;
}

- (NSString *)fullName
{
    NSMutableString *str = [NSMutableString new];
    if (self.firstName != nil) {
        [str appendString:self.firstName];
    }
    if (self.lastName != nil) {
        [str appendFormat:@" %@", self.lastName];;
    }
    return str;
}

@end
