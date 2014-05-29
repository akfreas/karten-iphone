#import "User+Helpers.h"
#import "NSManagedObject+JSONParsable.h"
#import "KartenDBExceptions.h"
@implementation User (Helpers)

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
