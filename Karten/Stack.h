//
//  Stack.h
//  Karten
//
//  Created by Alexander Freas on 29/08/14.
//  Copyright (c) 2014 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card, StackServer;

@interface Stack : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * serverID;
@property (nonatomic, retain) NSString * serverStackName;
@property (nonatomic, retain) NSString * stackDescription;
@property (nonatomic, retain) NSNumber * ownerServerID;
@property (nonatomic, retain) id allowedUserServerIDs;
@property (nonatomic, retain) NSSet *cards;
@property (nonatomic, retain) StackServer *server;
@end

@interface Stack (CoreDataGeneratedAccessors)

- (void)addCardsObject:(Card *)value;
- (void)removeCardsObject:(Card *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

@end
