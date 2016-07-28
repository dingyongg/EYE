//
//  CoverView.m
//  EYE
//
//  Created by DINGYONGGANG on 16/6/12.
//  Copyright © 2016年 BIGBO. All rights reserved.
//

#import "CoverView.h"
#import "ColorView.h"

@interface CoverView ()

@property (nonatomic, strong) ColorView *colorView;

@end



@implementation CoverView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _colorView = [[[NSBundle mainBundle]loadNibNamed:@"ColorView" owner:self options:nil]firstObject];
        _colorView.frame = CGRectMake(self.frame.size.width, 25, self.frame.size.width*.7, 270);
        
        self.bgColor = _colorView.bgColor;
        self.tColor = _colorView.tColor;
        [self addSubview:_colorView];
    }
    return self;
    
}



- (void)show{
    
    _colorView.bgColor = _bgColor;
    _colorView.tColor = _tColor;
    
    UIWindow *key_window = [UIApplication sharedApplication].keyWindow;
    [key_window addSubview:self];
    
    [UIView animateWithDuration:.4 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:.9 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _colorView.transform = CGAffineTransformMakeTranslation(-_colorView.frame.size.width, 0);
    } completion:nil];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(_colorView.frame, point)) {
        
        [UIView animateWithDuration:.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _colorView.transform = CGAffineTransformMakeTranslation(_colorView.frame.size.width, 0);
        } completion:^(BOOL finished) {
            [self removeObserver:_controller forKeyPath:@"bgColor"];
            [self removeObserver:_controller forKeyPath:@"tColor"];
            [self removeFromSuperview];
        
        }];
        
    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
