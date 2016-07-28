//
//  CoverView.h
//  EYE
//
//  Created by DINGYONGGANG on 16/6/12.
//  Copyright © 2016年 BIGBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverView : UIView

@property (nonatomic, weak) UIViewController *controller;

@property (nonatomic, strong) UIColor *tColor;
@property (nonatomic, strong) UIColor *bgColor;

- (void)show;

@end
