//
//  Card.h
//  Karten
//
//  Created by Alexander Freas on 13/06/14.
//  Copyright (c) 2014 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stack;

@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * couchID;
@property (nonatomic, retain) NSString * couchRev;
@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSNumber * knowledgeScore;
@property (nonatomic, retain) NSString * term;
@property (nonatomic, retain) Stack *stack;

@end
