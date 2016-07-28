//
//  ViewController.m
//  EYE
//
//  Created by BIGBO on 16/5/26.
//  Copyright © 2016年 BIGBO. All rights reserved.
//

#import "ViewController.h"
#import "ColorView.h"
#import "CoverView.h"

@interface ViewController ()
@property (nonatomic, strong) CoverView *cv;

@property (weak, nonatomic) IBOutlet UILabel *answer_label;
@property (weak, nonatomic) IBOutlet UILabel *question_label;
@property (weak, nonatomic) IBOutlet UIButton *next_btn;
@property (weak, nonatomic) IBOutlet UIButton *againBtn;
@property (weak, nonatomic) IBOutlet UIButton *setUp_btn;

@end

@implementation ViewController

- (void)setCv:(CoverView *)cv{
    [_cv removeObserver:self forKeyPath:@"color"];
    _cv  = cv;
    [_cv addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    
    if ([u objectForKey:@"bgColor_r"]) {
        self.view.backgroundColor = [UIColor colorWithRed:[u floatForKey:@"bgColor_r"] green:[u floatForKey:@"bgColor_g"] blue:[u floatForKey:@"bgColor_b"] alpha:1.0];
        self.question_label.textColor =  [UIColor colorWithRed:[u floatForKey:@"tColor_r"] green:[u floatForKey:@"tColor_g"] blue:[u floatForKey:@"tColor_b"] alpha:1.0];
        
    }

    _setUp_btn.tintColor = [UIColor blackColor];
    [_question_label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    
    
    const CGFloat *colors = CGColorGetComponents(self.view.backgroundColor.CGColor);
    [u setFloat:colors[0] forKey:@"bgColor_r"];
    [u setFloat:colors[1] forKey:@"bgColor_g"];
    [u setFloat:colors[2] forKey:@"bgColor_b"];
    
//    [u setValue:[NSNumber numberWithFloat:colors[0]] forKey:@"bgColor_r"];
//    [u setValue:[NSNumber numberWithFloat:colors[1]] forKey:@"bgColor_g"];
//    [u setValue:[NSNumber numberWithFloat:colors[2]] forKey:@"bgColor_b"];
    
    colors = CGColorGetComponents(self.question_label.textColor.CGColor);
    [u setFloat:colors[0] forKey:@"tColor_r"];
    [u setFloat:colors[1] forKey:@"tColor_g"];
    [u setFloat:colors[2] forKey:@"tColor_b"];
//    [u setValue:[NSNumber numberWithFloat:colors[0]] forKey:@"tColor_r"];
//    [u setValue:[NSNumber numberWithFloat:colors[1]] forKey:@"tColor_g"];
//    [u setValue:[NSNumber numberWithFloat:colors[2]] forKey:@"tColor_b"];
    
    [u synchronize];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
}

- (void)initUI{
    _question_label.text = [self creatCode];
    _next_btn.layer.borderWidth = 1.0;
    _next_btn.layer.borderColor = [UIColor whiteColor].CGColor;
    _againBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _againBtn.layer.borderWidth = 1;
}

- (IBAction)again:(UIButton *)sender {
    if ([_next_btn isEnabled]) {
        _answer_label.hidden = YES;
        _question_label.text = [self creatCode];
    }else{
        [self reset];
    }
}

- (IBAction)next:(UIButton *)sender {
    
    if (!_answer_label.hidden) _answer_label.hidden = YES;
    
    _question_label.text = [self creatCode];
    NSLog(@"%f", [self font:_question_label.font.pointSize]);
    _question_label.font = [UIFont boldSystemFontOfSize:_question_label.font.pointSize-[self font:_question_label.font.pointSize]];
    
    if (_question_label.font.pointSize == 0) {
        sender.enabled = NO;
        sender.backgroundColor = [UIColor lightGrayColor];
    }
    
    NSLog(@"%f", _question_label.font.pointSize);
  
}

- (CGFloat )font:(CGFloat)f{
    if (f>50)return 10;
    else if(f>20) return 5;
    else if(f>10)return 2;
    else return 1;
    
}

- (NSString *)creatCode{
    static NSString * codeStr;
    codeStr = [NSString stringWithFormat:@"%d", arc4random()%10000];
    if (codeStr.length != 4) {
        codeStr = [self creatCode];
    }
    NSLog(@"%@", codeStr);
    return codeStr;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"text"]) {
       _answer_label.text = [change valueForKey:@"new"];
    }
    
    if ([keyPath isEqualToString:@"bgColor"]) {
        CoverView *v = (CoverView *)object;
        self.view.backgroundColor = v.bgColor;
    }
    
    if ([keyPath isEqualToString:@"tColor"]) {
        CoverView *v = (CoverView *)object;
        self.question_label.textColor = v.tColor;
    }
    
}

#define w 50
#define h 50    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGRect frame = CGRectZero;
    if (_question_label.frame.size.width<40) {
        frame = CGRectMake((self.view.frame.size.width-w)*.5, (self.view.frame.size.height-h)*.5, w, h);
    }else{
        frame = _question_label.frame;
    }
    if (CGRectContainsPoint(frame, point)) {
        _answer_label.hidden = NO;
    }else{
        [self reset];
    }
    
}
- (void)reset{
    if (!_answer_label.hidden) _answer_label.hidden = YES;
    _next_btn.enabled = YES;
    _next_btn.backgroundColor = [UIColor greenColor];
    _question_label.text = [self creatCode];
    _question_label.font = [UIFont boldSystemFontOfSize:100];
}

- (IBAction)setUp:(UIButton *)sender {
    
    _cv = [[CoverView alloc]initWithFrame:self.view.bounds];
    _cv.controller = self;
    _cv.bgColor = self.view.backgroundColor;
    _cv.tColor = _question_label.textColor;
    [_cv show];
    [_cv addObserver:self forKeyPath:@"bgColor" options:NSKeyValueObservingOptionNew context:nil];
    [_cv addObserver:self forKeyPath:@"tColor" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

}

@end
