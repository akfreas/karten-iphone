//
//  Card.h
//  Karten
//
//  Created by Alexander Freas on 4/22/14.
//  Copyright (c) 2014 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * term;
@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSNumber * knowledgeScore;
@property (nonatomic, retain) NSString * couchID;
@property (nonatomic, retain) NSString * couchRev;

@end
