//
//  Card.h
//  Karten
//
//  Created by Alexander Freas on 3/9/14.
//  Copyright (c) 2014 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * term;
@property (nonatomic, retain) NSString * definition;

@end
