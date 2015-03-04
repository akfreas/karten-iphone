//
//  RevealControllerManager.m
//  Karten
//
//  Created by Alexander Freas on 27/09/14.
//  Copyright (c) 2014 Sashimiblade. All rights reserved.
//

#import "KTRevealControllerManager.h"
#import <SWRevealViewController/SWRevealViewController.h>

@implementation KTRevealControllerManager

+ (SWRevealViewController *)sharedRevealController
{
    static SWRevealViewController *revealController;
    if (revealController == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            revealController = [[SWRevealViewController alloc] init];
        });
    }
    return revealController;
}


@end
