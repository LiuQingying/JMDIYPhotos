//
//  JMBubbleView.m
//  actoys
//
//  Created by LiuQingying on 16/4/14.
//  Copyright © 2016年 Actoys.net. All rights reserved.
//

#import "JMBubbleView.h"
#define PASTER_SLIDE        150.0
#define FLEX_SLIDE          15.0
#define BT_SLIDE            30.0
#define BORDER_LINE_WIDTH   1.0
#define SECURITY_LENGTH     75.0
/**
 传递保存的贴纸信息
 */
#define ACTOYSPASSPASTERARR  @"ACTOYSCLEARPASSPASTERARR"
#define ACTOYSCLEARALLONFIRST @"ACTOYSCLEARCLEARALLONFIRST" // 清除贴纸的第一响应
#define ACTOYSREMOVEPASTER @"ACTOYSCLEARREMOVEPASTER" // 移除贴纸
#define ACTOYSREMOVEBUBBLE @"ACTOYSCLEARREMOVEBUBBLE" // 移除气泡

@interface JMBubbleView ()<UITextViewDelegate>
{
    CGFloat minWidth;
    CGFloat minHeight;
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGPoint touchStart;
    CGRect  bgRect ;
    BOOL isEdit;
}
@property (nonatomic,weak) UITextView *textView;

@end

@implementation JMBubbleView
- (void)remove
{
    [self removeFromSuperview] ;
    if ([_delegate respondsToSelector:@selector(removeBubble:)]) {
        [self.delegate removeBubble:self.bubbleID] ;
    }else{
        NSDictionary *dict = [NSDictionary dictionaryWithObject:self forKey:@"bubble"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ACTOYSREMOVEBUBBLE object:nil userInfo:dict];
    }
}

#pragma mark -- Initial
- (instancetype)initWithBgView:(XTPasterStageView *)bgView
                      bubbleID:(int)bubbleID
                           img:(UIImage *)img
                     imageName:(NSString *)imageName{
    self = [super init];
    if (self)
    {
        self.bubbleID = bubbleID ;
        self.imageBubble = img ;
        self.imageName = imageName;
         bgRect = bgView.frame ;
        NSLog(@"%@",NSStringFromCGRect(bgView.frame));
        [self setupWithBGFrame:bgRect] ;
        [self imgContentView] ;
        [self setupTextView];
        [self btDelete] ;
        [self btSizeCtrl] ;
        [bgView addSubview:self] ;
        self.isOnFirst = YES ;
    }
    return self;
}


- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    
    CGRect rect = CGRectZero ;
    CGFloat sliderContent = PASTER_SLIDE - FLEX_SLIDE * 2 ;
    rect.origin = CGPointMake(FLEX_SLIDE, FLEX_SLIDE) ;
    rect.size = CGSizeMake(sliderContent, sliderContent) ;
    self.imgContentView.frame = rect ;
    
    self.imgContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        prevPoint = [recognizer locationInView:self];
        //        NSLog(@"++++++%@",NSStringFromCGPoint(prevPoint));
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        NSLog(@"%@",NSStringFromCGRect(self.bounds));
        // preventing from the picture being shrinked too far by resizing
        if (self.bounds.size.width < minWidth || self.bounds.size.height < minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     minWidth + 1 ,
                                     minHeight + 1);
            if ([self.imageName isEqualToString:@"bubble_2"]) {
                self.textView.frame = CGRectMake(4,
                                                 minWidth*0.3,
                                                 minWidth *0.5 ,
                                                 minWidth *0.4) ;
            }else{
                self.textView.frame = CGRectMake(4  ,
                                                 4 ,
                                                 minWidth *0.5 ,
                                                 minHeight * 0.4) ;

            }
            
            self.btSizeCtrl.frame =CGRectMake(self.bounds.size.width-BT_SLIDE,
                                              self.bounds.size.height-BT_SLIDE,
                                              BT_SLIDE,
                                              BT_SLIDE);
            prevPoint = [recognizer locationInView:self];
            //            NSLog(@"++++++%@",NSStringFromCGPoint(prevPoint));
        }
        // Resizing
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            
            wChange = (point.x - prevPoint.x);
            float wRatioChange = (wChange/(float)self.bounds.size.width);
            
            hChange = wRatioChange * self.bounds.size.height;
            
            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
            {
                prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }
            
            CGFloat finalWidth  = self.bounds.size.width + (wChange) ;
            CGFloat finalHeight = self.bounds.size.height + (wChange) ;
            
            if (finalWidth > PASTER_SLIDE*(1+0.5))
            {
                finalWidth = PASTER_SLIDE*(1+0.5) ;
            }
            if (finalWidth < PASTER_SLIDE*(1-0.5))
            {
                finalWidth = PASTER_SLIDE*(1-0.5) ;
            }
            if (finalHeight > PASTER_SLIDE*(1+0.5))
            {
                finalHeight = PASTER_SLIDE*(1+0.5) ;
            }
            if (finalHeight < PASTER_SLIDE*(1-0.5))
            {
                finalHeight = PASTER_SLIDE*(1-0.5) ;
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     finalWidth,
                                     finalHeight) ;
            if ([self.imageName isEqualToString:@"bubble_2"]) {
                self.textView.frame = CGRectMake(7,
                                                 finalWidth*0.3,
                                                 finalWidth -40 ,
                                                 finalHeight *0.46-5) ;
            }else{
                _textView.frame = CGRectMake(finalWidth*0.1,
                                             finalWidth*0.17,
                                             finalWidth -finalWidth*0.2-20 ,
                                             finalHeight *0.46-10);

            }
            NSLog(@"%@",NSStringFromCGRect(self.bounds));
            self.btSizeCtrl.frame = CGRectMake(self.bounds.size.width-BT_SLIDE  ,
                                               self.bounds.size.height-BT_SLIDE ,
                                               BT_SLIDE ,
                                               BT_SLIDE) ;
            
            prevPoint = [recognizer locationOfTouch:0
                                             inView:self] ;
        }
        
        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x) ;
        
        float angleDiff = deltaAngle - ang ;
        
        self.transform = CGAffineTransformMakeRotation(-angleDiff) ;
        //        NSLog(@"旋转角度%f",angleDiff);
        [self setNeedsDisplay] ;
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    
}

- (void)setImageBubble:(UIImage *)imageBubble
{
    _imageBubble = imageBubble ;
    
    self.imgContentView.image = imageBubble ;
}
- (void)setupWithBGFrame:(CGRect)bgFrame
{
    CGRect rect = CGRectZero ;
    rect.size = CGSizeMake(PASTER_SLIDE, PASTER_SLIDE) ;
    self.frame = rect ;
    self.center = CGPointMake(bgFrame.size.width / 2, bgFrame.size.height / 2) ;
    self.backgroundColor = nil ;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] ;
    [self addGestureRecognizer:tapGesture] ;
    
    //    UIPinchGestureRecognizer *pincheGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)] ;
    //    [self addGestureRecognizer:pincheGesture] ;
    
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)] ;
    [self addGestureRecognizer:rotateGesture] ;
    
    self.userInteractionEnabled = YES ;
    
    minWidth   = self.bounds.size.width * 0.5;
    minHeight  = self.bounds.size.height * 0.5;
    
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x) ;
    
}
- (void)setupTextView{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, _imgContentView.bounds.size.width-20, _imgContentView.bounds.size.height - 60)];
    if ([self.imageName isEqualToString:@"bubble_2"]) {
        textView.frame = CGRectMake(6, 40, _imgContentView.bounds.size.width-8, _imgContentView.bounds.size.height - 52);
    }
    self.textView = textView;
    self.textView.delegate = self;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dragTextView:)];
    [_textView addGestureRecognizer:pan] ;
    textView.backgroundColor = [UIColor clearColor];
//    textView.centerY = _imgContentView.bounds.size.height*0.5;
//    textView.layer.cornerRadius = 15;
    textView.font = [UIFont systemFontOfSize:15];
    _imgContentView.userInteractionEnabled = YES;
    [_imgContentView addSubview:textView];
    _imgContentView.clipsToBounds = YES;

}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.isOnFirst = YES ;
    [self.delegate makeBubbleBecomeFirstRespond:self.bubbleID];
    return YES;
}
-(void)dragTextView:(UIPanGestureRecognizer *)panGesture{
    if (panGesture.state != UIGestureRecognizerStateEnded && panGesture.state != UIGestureRecognizerStateFailed) {
        CGPoint location = [panGesture locationInView:self.superview];
        self.center = location;
    }else if (panGesture.state == UIGestureRecognizerStateEnded){
        self.isOnFirst = NO;
    }
}
- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    [self.textView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTOYSCLEARALLONFIRST object:nil];
    NSLog(@"tap paster become first respond") ;
    self.isOnFirst = YES ;
    //    NSLog(@"贴纸id____%d",_pasterID);
    [self.delegate makeBubbleBecomeFirstRespond:self.bubbleID] ;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture
{
    [self.textView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTOYSCLEARALLONFIRST object:nil];
    self.isOnFirst = YES ;
    [self.delegate makeBubbleBecomeFirstRespond:self.bubbleID] ;
    
    self.imgContentView.transform = CGAffineTransformScale(self.imgContentView.transform,
                                                           pinchGesture.scale,
                                                           pinchGesture.scale) ;
    self.textView.transform = CGAffineTransformScale(self.textView.transform,
                                                     pinchGesture.scale,
                                                     pinchGesture.scale) ;
    pinchGesture.scale = 1 ;
}

- (void)handleRotation:(UIRotationGestureRecognizer *)rotateGesture
{
    [self.textView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTOYSCLEARALLONFIRST object:nil];
    self.isOnFirst = YES ;
    [self.delegate makeBubbleBecomeFirstRespond:self.bubbleID] ;
    
    self.transform = CGAffineTransformRotate(self.transform, rotateGesture.rotation) ;
    rotateGesture.rotation = 0 ;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTOYSCLEARALLONFIRST object:nil];
    self.isOnFirst = YES ;
    [self.delegate makeBubbleBecomeFirstRespond:self.bubbleID] ;
    UITouch *touch = [touches anyObject] ;
    touchStart = [touch locationInView:self.superview] ;
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    [self.textView resignFirstResponder];
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                    self.center.y + touchPoint.y - touchStart.y) ;
    
    // Ensure the translation won't cause the view to move offscreen. BEGIN
    CGFloat midPointX = CGRectGetMidX(self.bounds) ;
    if (newCenter.x > self.superview.bounds.size.width - midPointX + SECURITY_LENGTH)
    {
        newCenter.x = self.superview.bounds.size.width - midPointX + SECURITY_LENGTH;
    }
    if (newCenter.x < midPointX - SECURITY_LENGTH)
    {
        newCenter.x = midPointX - SECURITY_LENGTH;
    }
    
    CGFloat midPointY = CGRectGetMidY(self.bounds);
    if (newCenter.y > self.superview.bounds.size.height - midPointY + SECURITY_LENGTH)
    {
        newCenter.y = self.superview.bounds.size.height - midPointY + SECURITY_LENGTH;
    }
    if (newCenter.y < midPointY - SECURITY_LENGTH)
    {
        newCenter.y = midPointY - SECURITY_LENGTH;
    }
    
    // Ensure the translation won't cause the view to move offscreen. END
    self.center = newCenter;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.btSizeCtrl.frame, touchLocation)) {
        return;
    }
    
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    
    [self translateUsingTouchLocation:touch] ;
    touchStart = touch;
}

#pragma mark -- Properties
- (void)setIsOnFirst:(BOOL)isOnFirst
{
    
    _isOnFirst = isOnFirst ;
    self.btDelete.hidden = !isOnFirst ;
    self.btSizeCtrl.hidden = !isOnFirst ;
    self.imgContentView.layer.borderWidth = isOnFirst ? BORDER_LINE_WIDTH : 0.0f ;
    
    if (isOnFirst)
    {
        NSLog(@"pasterID : %d is On",self.bubbleID) ;
    }
}

- (UIImageView *)imgContentView
{
    if (!_imgContentView)
    {
        CGRect rect = CGRectZero ;
        CGFloat sliderContent = PASTER_SLIDE - FLEX_SLIDE * 2 ;
        rect.origin = CGPointMake(FLEX_SLIDE, FLEX_SLIDE) ;
        rect.size = CGSizeMake(sliderContent, sliderContent) ;
        
        _imgContentView = [[UIImageView alloc] initWithFrame:rect] ;
        _imgContentView.backgroundColor = nil ;
        _imgContentView.layer.borderColor = [UIColor whiteColor].CGColor ;
        _imgContentView.layer.borderWidth = BORDER_LINE_WIDTH ;
        _imgContentView.contentMode = UIViewContentModeScaleAspectFit ;
        
        if (![_imgContentView superview])
        {
            [self addSubview:_imgContentView] ;
        }
    }
    
    return _imgContentView ;
}

- (UIImageView *)btSizeCtrl
{
    if (!_btSizeCtrl)
    {
        _btSizeCtrl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - BT_SLIDE  ,
                                                                   self.frame.size.height - BT_SLIDE ,
                                                                   BT_SLIDE ,
                                                                   BT_SLIDE)
                       ] ;
        _btSizeCtrl.userInteractionEnabled = YES;
        _btSizeCtrl.image = [UIImage imageNamed:@"bt_paster_transform"] ;
        
        UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(resizeTranslate:)] ;
        [_btSizeCtrl addGestureRecognizer:panResizeGesture] ;
        if (![_btSizeCtrl superview]) {
            [self addSubview:_btSizeCtrl] ;
        }
    }
    
    return _btSizeCtrl ;
}

- (UIImageView *)btDelete
{
    if (!_btDelete)
    {
        CGRect btRect = CGRectZero ;
        btRect.size = CGSizeMake(BT_SLIDE, BT_SLIDE) ;
        
        _btDelete = [[UIImageView alloc]initWithFrame:btRect] ;
        _btDelete.userInteractionEnabled = YES;
        _btDelete.image = [UIImage imageNamed:@"bt_paster_delete"] ;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(btDeletePressed:)] ;
        [_btDelete addGestureRecognizer:tap] ;
        
        if (![_btDelete superview]) {
            [self addSubview:_btDelete] ;
        }
    }
    
    return _btDelete ;
}

- (void)btDeletePressed:(id)btDel
{
    NSLog(@"btDel") ;
    [self.textView resignFirstResponder];
    [self remove] ;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACTOYSCLEARALLONFIRST object:nil];
    
}
@end

