//
//  User.h
//  
//
//  Created by Alexander Freas on 29/08/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * externalService;
@property (nonatomic, retain) NSString * externalUserID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * mainUser;
@property (nonatomic, retain) NSNumber * serverID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *friends;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(User *)value;
- (void)removeFriendsObject:(User *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

@end
