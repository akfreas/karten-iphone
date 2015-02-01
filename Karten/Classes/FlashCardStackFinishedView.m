//
//  FlashCardStackFinishedView.m
//  Karten
//
//  Created by Alexander Freas on 13/06/14.
//  Copyright (c) 2014 Sashimiblade. All rights reserved.
//

#import "FlashCardStackFinishedView.h"

@interface FlashCardStackFinishedView ()
@property (nonatomic) UIButton *finishedButton;
@end

@implementation FlashCardStackFinishedView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createFinishedButton];
        [self addLayoutConstraints];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createFinishedButton
{
    self.finishedButton = [UIButton new];
    [self.finishedButton bk_addEventHandler:^(id sender) {
        [MainViewController goToMainView];
    } forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.finishedButton];
    [self.finishedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.finishedButton setTitle:@"Finished!" forState:UIControlStateNormal];
}

- (void)addLayoutConstraints
{
    UIBind(self.finishedButton);
    [self addConstraintWithVisualFormat:@"H:|[finishedButton]|" bindings:BBindings];
    [self addConstraintWithVisualFormat:@"V:|[finishedButton]|" bindings:BBindings];
}

@end
