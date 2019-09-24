# PasswordCode
代码使用的是xib创建手势视图 初始化方法写在- (void)awakeFromNib中 当然放在懒加载btns中也可以 
代码使用拼接btn.tag方式做检验判断 通过block传递参数 注意block返回值是bool类型 考虑更多的可能是用户在 view中做一些弹框判断 防止viewcontroller代码冗余
CGRectContainsPoint(btn.frame, p）这个方法更多的是在判断手指触摸区域P点是否在btn内部
[self setNeedsDisplay]; 这个方法为了重绘视图 重新调用- (void)drawRect:(CGRect)rect 方法
