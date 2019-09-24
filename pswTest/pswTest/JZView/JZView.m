//
//  JZView.m
//  pswTest
//
//  Created by hero on 2019/9/23.
//  Copyright © 2019年 Hero. All rights reserved.
//

#import "JZView.h"
#define btnCount 9
@interface JZView ()
@property (nonatomic ,strong) NSMutableArray *btns;//9个n按钮数组
@property (nonatomic ,strong) NSMutableArray *lineBtns;//所有需要连线的btn
@property (nonatomic ,assign) CGPoint currentPoint;
@end
@implementation JZView



//连线
- (void)drawRect:(CGRect)rect {
    if (self.lineBtns.count == 0) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:10];
    [[UIColor whiteColor]set];
    [path setLineJoinStyle:kCGLineJoinBevel];
    [path setLineCapStyle:kCGLineCapRound];
    for (int i = 0; i<self.lineBtns.count; i++) {
        UIButton *btn = self.lineBtns[i];
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
    
}
- (NSMutableArray *)btns{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}
- (NSMutableArray *)lineBtns{
    if (!_lineBtns) {
        _lineBtns = [NSMutableArray array];
    }
    return _lineBtns;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    for (int i = 0 ; i< btnCount; i++) {
        //循环创建btn
        UIButton *button = [[UIButton alloc]init];
        [button setImage:[UIImage imageNamed:@"fingerprint_unlock"] forState:UIControlStateNormal];
        button.tag = i;
        [button setImage:[UIImage imageNamed:@"circle_btn_selected"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"circle_btn_wrong"] forState:UIControlStateDisabled];
        button.userInteractionEnabled = NO;
        [self.btns addObject:button];
        [self addSubview:button];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = 74;
    CGFloat h = w;
    int colCount = 3;
    CGFloat margin = (self.frame.size.width -3 *w)/4;
    for (int i = 0 ;i < self.btns.count; i++) {
        CGFloat x = (i%colCount) * (margin + w) + margin;
        CGFloat y = (i/colCount) * (margin + w) + margin;
        [self.btns[i] setFrame:CGRectMake(x,y, w, h)];
    }
}
//手指触摸的时候调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取触摸对象
    UITouch *t =touches.anyObject;
    //获取手指位置
    CGPoint p = [t locationInView:t.view];
    for (int i = 0; i<self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        //如果btn的frame包含手指的点
        if (CGRectContainsPoint(btn.frame, p)){
            //让按钮高亮
            btn.selected = YES;
            [self.lineBtns addObject:btn];
        }
    }
}
- (void)clear{
    for (int i = 0; i<self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        btn.selected = NO;
        //让按钮取消错误样式
        btn.enabled = YES;
    }
    [self.lineBtns removeAllObjects];
    [self setNeedsDisplay];
}
//手指离开view的时候
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //修改最后手指的位置为最后一个按钮的中心
    self.currentPoint = [self.lineBtns.lastObject center];
    //chonghui
    [self setNeedsDisplay];
    //所有需要划线的button都转换样式
    for (int i = 0; i<self.lineBtns.count; i++) {
        UIButton *button = self.lineBtns[i];
        button.selected = NO;
        button.enabled = NO;
    }
    //拼接密码
    NSString *passWord = @"";
    for (int i = 0; i<self.lineBtns.count; i++) {
        UIButton *button = self.lineBtns[i];
        passWord = [passWord stringByAppendingString:[NSString stringWithFormat:@"%ld",button.tag]];
        
    }
    self.passWordBlock(passWord);
    if (self.passWordBlock) {
        NSLog(@"mimazhengque");
    }else{
        NSLog(@"mimacuowu");
    }
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clear];
        self.userInteractionEnabled = YES;
    });
}
//手指在view上移动的时候
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取触摸对象
    UITouch *t = touches.anyObject;
    //获取最新手指的位置
    CGPoint p = [t locationInView:t.view];
    self.currentPoint = p;
    for (int i = 0 ; i<self.btns.count; i++) {
        UIButton *btn = self.btns[i];
        if (CGRectContainsPoint(btn.frame, p)) {
            btn.selected = YES;
            //如果已经加入到数组当中 那么不再去重复添加
            if (![self.lineBtns containsObject:btn]) {
                [self.lineBtns addObject:btn];
            }
        }
    }
    //重绘
    [self setNeedsDisplay];
}
@end
