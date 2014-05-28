//
//  Stack.h
//  Karten
//
//  Created by Alexander Freas on 29/05/14.
//  Copyright (c) 2014 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StackServer, User;

@interface Stack : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * stackDescription;
@property (nonatomic, retain) NSString * serverStackName;
@property (nonatomic, retain) NSNumber * serverID;
@property (nonatomic, retain) NSSet *allowedUsers;
@property (nonatomic, retain) User *owner;
@property (nonatomic, retain) StackServer *server;
@end

@interface Stack (CoreDataGeneratedAccessors)

- (void)addAllowedUsersObject:(User *)value;
- (void)removeAllowedUsersObject:(User *)value;
- (void)addAllowedUsers:(NSSet *)values;
- (void)removeAllowedUsers:(NSSet *)values;

@end
