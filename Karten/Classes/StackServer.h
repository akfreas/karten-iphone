//
//  StackServer.h
//  Karten
//
//  Created by Alexander Freas on 29/08/14.
//  Copyright (c) 2014 Sashimiblade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StackServer : NSManagedObject

@property (nonatomic, retain) NSNumber * serverID;
@property (nonatomic, retain) NSString * host;
@property (nonatomic, retain) NSNumber * port;
@property (nonatomic, retain) NSString * protocol;

@end
