//
//  ColorView.m
//  EYE
//
//  Created by BIGBO on 16/5/27.
//  Copyright © 2016年 BIGBO. All rights reserved.
//

#import "ColorView.h"
#import "CoverView.h"
#define COLOR(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]

@interface ColorView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *background_color_btn;
@property (weak, nonatomic) IBOutlet UIButton *text_color_btn;
//R
@property (weak, nonatomic) IBOutlet UILabel *label_R;
@property (weak, nonatomic) IBOutlet UISlider *slider_R;

//G
@property (weak, nonatomic) IBOutlet UILabel *label_G;
@property (weak, nonatomic) IBOutlet UISlider *slider_G;

//B
@property (weak, nonatomic) IBOutlet UILabel *label_B;
@property (weak, nonatomic) IBOutlet UISlider *slider_B;


@property (weak, nonatomic) IBOutlet UICollectionView *color_view;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, weak) UIView *cover;

@property (nonatomic, assign) int colorStyle; //1:背景颜色，2:字体颜色

@end

@implementation ColorView

- (void)awakeFromNib{   
    
    [_color_view registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    _colors = @[[UIColor whiteColor], [UIColor blackColor], [UIColor blueColor],[UIColor brownColor], [UIColor purpleColor], [UIColor yellowColor], [UIColor redColor],[UIColor grayColor], [UIColor lightGrayColor], [UIColor greenColor]];
    self.bgColor = [UIColor clearColor];
    self.tColor = [UIColor clearColor];
    _colorStyle = 1;
}

- (void)layoutSubviews{
    _label_R.text = [NSString stringWithFormat:@"%d", (int)_slider_R.value];
    _label_G.text = [NSString stringWithFormat:@"%d", (int)_slider_G.value];
    _label_B.text = [NSString stringWithFormat:@"%d", (int)_slider_B.value];
    
    const CGFloat* colors =  CGColorGetComponents(_bgColor.CGColor);
    
    _slider_R.value = colors[0]*225;
    _slider_G.value = colors[1]*225;
    _slider_B.value = colors[2]*225;
}



#pragma UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = _colors[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIColor *c = _colors[indexPath.row];
    _colorStyle==1?(self.bgColor = c):(self.tColor=c);
//    if (_colorStyle == 1) {
//        
//        self.bgColor = c;
//        
//    }{
//        self.tColor  = c;
//    }
    
    const CGFloat* colors =  CGColorGetComponents(c.CGColor);
    
    
    [_slider_R setValue:colors[0]*225 animated:YES];
    [_slider_G setValue:colors[1]*225 animated:YES];
    [_slider_B setValue:colors[2]*225 animated:YES];
//    _slider_R.value = colors[0]*225;
//    _slider_G.value = colors[1]*225;
//    _slider_B.value = colors[2]*225;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    if (sender == _slider_R){
       _label_R.text = [NSString stringWithFormat:@"%d", (int)sender.value];
        if (_colorStyle==1) {
            self.bgColor =  COLOR(sender.value, _slider_G.value, _slider_B.value, 1);
        }else{
            self.tColor =  COLOR(sender.value, _slider_G.value, _slider_B.value, 1);
        }
    }
    if (sender == _slider_G){
        _label_G.text = [NSString stringWithFormat:@"%d", (int)sender.value];
        if (_colorStyle==1) {
            self.bgColor =  COLOR(_slider_R.value, sender.value, _slider_B.value, 1);
        }else{
            self.tColor =  COLOR(_slider_R.value, sender.value, _slider_B.value, 1);
        }
    
    }
    if (sender == _slider_B){
        _label_B.text = [NSString stringWithFormat:@"%d", (int)sender.value];
        
        _label_G.text = [NSString stringWithFormat:@"%d", (int)sender.value];
        if (_colorStyle==1) {
            self.bgColor = COLOR(_slider_R.value, _slider_G.value, sender.value, 1);
        }else{
            self.tColor =  COLOR(_slider_R.value, _slider_G.value, sender.value, 1);
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    
    if (!CGRectContainsPoint(self.frame, point)) {
        NSLog(@"23456");
    }
    
}

- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    ColorView *v = (ColorView *)self.superview;
    v.bgColor = bgColor;
    
}

- (void)setTColor:(UIColor *)tColor{
    _tColor = tColor;
    ColorView *v = (ColorView *)self.superview;
    v.tColor = tColor;
}

- (IBAction)bgColor:(UIButton *)sender {
    
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [_text_color_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _text_color_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    _colorStyle = 1;
    
    
    const CGFloat* colors =  CGColorGetComponents(_bgColor.CGColor);
    
    _slider_R.value = colors[0]*225;
    _slider_G.value = colors[1]*225;
    _slider_B.value = colors[2]*225;
    
    
}

- (IBAction)tColor:(UIButton *)sender {
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_background_color_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _background_color_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    _colorStyle = 2;
    
    
    const CGFloat* colors =  CGColorGetComponents(_tColor.CGColor);
    
    _slider_R.value = colors[0]*225;
    _slider_G.value = colors[1]*225;
    _slider_B.value = colors[2]*225;
    
}

- (void)dealloc{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
