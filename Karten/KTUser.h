//
//  User.h
//  Karten
//
//  Created by Alexander Freas on 16/10/14.
//  Copyright (c) 2014 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KTUser;

@interface KTUser : NSManagedObject

@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * externalService;
@property (nonatomic, retain) NSString * externalUserID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * mainUser;
@property (nonatomic, retain) NSNumber * serverID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * profilePicURL;
@property (nonatomic, retain) NSSet *friends;
@end

@interface KTUser (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(KTUser *)value;
- (void)removeFriendsObject:(KTUser *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

@end
