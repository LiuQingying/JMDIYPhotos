//
//  XTPasterStageView.m
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTPasterStageView.h"
#import "XTPasterView.h"
#import "JMBubbleView.h"
#import "UIImage+Extension.h"
#define APPFRAME    [UIScreen mainScreen].bounds
/**
 传递保存的贴纸信息
 */
#define ACTOYSPASSPASTERARR  @"ACTOYSCLEARPASSPASTERARR"
#define ACTOYSCLEARALLONFIRST @"ACTOYSCLEARCLEARALLONFIRST" // 清除贴纸的第一响应
#define ACTOYSREMOVEPASTER @"ACTOYSCLEARREMOVEPASTER" // 移除贴纸
#define ACTOYSREMOVEBUBBLE @"ACTOYSCLEARREMOVEBUBBLE" // 移除气泡
@interface XTPasterStageView () <XTPasterViewDelegate,JMBubbleViewDelegate>
{
    CGPoint         startPoint ;
    CGPoint         touchPoint ;
}

@property (nonatomic,strong) UIButton       *bgButton ;
@property (nonatomic,strong) UIImageView    *imgView ;
@property (nonatomic,strong) XTPasterView   *pasterCurrent ;
@property (nonatomic)        int            newPasterID ;
@property (nonatomic,strong) JMBubbleView   *bubbleCurrent ;
@property (nonatomic)        int            newBubbleID ;
@end

@implementation XTPasterStageView
- (NSMutableArray *)m_listPaster{
    if (!_m_listPaster) {
        _m_listPaster = [NSMutableArray arrayWithCapacity:1];
    }
    return _m_listPaster;

}
- (NSMutableArray *)m_listBubble{
    if (!_m_listBubble) {
        _m_listBubble = [NSMutableArray arrayWithCapacity:1];
    }
    return _m_listBubble;
}
- (void)setOriginImage:(UIImage *)originImage
{
    _originImage = originImage ;
    
    self.imgView.image = originImage ;
}

- (int)newPasterID
{
    _newPasterID++ ;
    
    return _newPasterID ;
}
- (int)newBubbleID{

    _newBubbleID++;
    return _newBubbleID;
}
- (void)setPasterCurrent:(XTPasterView *)pasterCurrent
{
    _pasterCurrent = pasterCurrent ;
    
    [self bringSubviewToFront:_pasterCurrent] ;
}
- (void)setBubbleCurrent:(JMBubbleView *)bubbleCurrent{
    _bubbleCurrent = bubbleCurrent;
    [self bringSubviewToFront:_bubbleCurrent];
}
- (UIButton *)bgButton
{
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] initWithFrame:self.frame] ;
        _bgButton.tintColor = nil ;
        _bgButton.backgroundColor = nil ;
        [_bgButton addTarget:self
                      action:@selector(backgroundClicked:)
            forControlEvents:UIControlEventTouchUpInside] ;
        if (![_bgButton superview]) {
            [self addSubview:_bgButton] ;
        }
    }
    
    return _bgButton ;
}

- (UIImageView *)imgView
{
    if (!_imgView)
    {
        CGRect rect = CGRectZero ;
        rect.size.width = self.frame.size.width ;
        rect.size.height = self.frame.size.width ;
        rect.origin.y = ( self.frame.size.height - self.frame.size.width ) / 2.0 ;
        _imgView = [[UIImageView alloc] initWithFrame:rect] ;
        
        _imgView.contentMode = UIViewContentModeScaleAspectFit ;
        
        if (![_imgView superview])
        {
            [self addSubview:_imgView] ;
        }
    }
    
    return _imgView ;
}

#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        m_listPaster = [[NSMutableArray alloc] initWithCapacity:1] ;
//        m_listPaster = [NSMutableArray array];
        [self imgView] ;
        [self bgButton] ;
    }
    
    return self;
}

#pragma mark - public
- (void)addPasterWithImg:(UIImage *)imgP
{
    [self clearAllOnFirst] ;
    self.pasterCurrent = [[XTPasterView alloc] initWithBgView:self
                                                     pasterID:self.newPasterID
                                                          img:imgP] ;
    _pasterCurrent.delegate = self ;
    [self.m_listPaster addObject:_pasterCurrent] ;
    NSLog(@"m_listPaster+++++++++%@",_m_listPaster);
    if ([_delegate respondsToSelector:@selector(xTpasterStageViewSavePaster:)]) {
        [_delegate xTpasterStageViewSavePaster:self];
    }
}
- (void)addBubbleWithImage:(UIImage *)image imageName:(NSString *)imageName{
    [self clearAllOnFirst] ;
    self.bubbleCurrent = [[JMBubbleView alloc] initWithBgView:self bubbleID:self.newBubbleID img:image imageName:imageName] ;
    _bubbleCurrent.delegate = self ;
    [self.m_listBubble addObject:_bubbleCurrent] ;
    NSLog(@"m_listPaster+++++++++%@",_m_listPaster);
    if ([_delegate respondsToSelector:@selector(xTpasterStageViewSaveBubble:)]) {
        [_delegate xTpasterStageViewSaveBubble:self];
    }
}
- (UIImage *)doneEdit:(CGRect)frame
{
//    NSLog(@"done") ;
    [self clearAllOnFirst] ;
    
    NSLog(@"self.originImage.size : %@",NSStringFromCGSize(self.originImage.size)) ;
    CGFloat org_width = self.originImage.size.width ;
    CGFloat org_heigh = self.originImage.size.height ;
    CGFloat rateOfScreen = org_width / org_heigh ;
    CGFloat inScreenH = self.frame.size.width / rateOfScreen ;
    
    CGRect rect = CGRectZero ;
    rect.size = CGSizeMake(APPFRAME.size.width, inScreenH) ;
    rect.origin = CGPointMake(0, (self.frame.size.height - inScreenH) / 2) ;
    
    UIImage *imgTemp = [UIImage getImageFromView:self] ;
//    NSLog(@"imgTemp.size : %@",NSStringFromCGSize(imgTemp.size)) ;
    
//    UIImage *imgCut = [UIImage squareImageFromImage:imgTemp scaledToSize:rect.size.width] ;
    UIImage *imgCut = [UIImage squareImageFromImage:imgTemp scaledToSize:frame.size.width] ;
    return imgCut ;
}


- (void)backgroundClicked:(UIButton *)btBg
{
    NSLog(@"back clicked") ;
    NSLog(@"_m_listPaster%@",_m_listPaster);
    [self clearAllOnFirst] ;
    [self endEditing:YES];
}

- (void)clearAllOnFirst
{
    _pasterCurrent.isOnFirst = NO ;
    _bubbleCurrent.isOnFirst = NO;
    [self.m_listPaster enumerateObjectsUsingBlock:^(XTPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
         pasterV.isOnFirst = NO ;
    }] ;
    [self.m_listBubble enumerateObjectsUsingBlock:^(JMBubbleView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        pasterV.isOnFirst = NO ;
    }] ;
    [[NSNotificationCenter defaultCenter] postNotificationName:ACTOYSCLEARALLONFIRST object:nil];
}

#pragma mark - PasterViewDelegate
- (void)makePasterBecomeFirstRespond:(int)pasterID ;
{
    [self.m_listPaster enumerateObjectsUsingBlock:^(XTPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        
        pasterV.isOnFirst = NO ;
        
        if (pasterV.pasterID == pasterID)
        {
            self.pasterCurrent = pasterV ;
            pasterV.isOnFirst = YES ;
        }
        
    }] ;
}

- (void)removePaster:(int)pasterID
{
    [self.m_listPaster enumerateObjectsUsingBlock:^(XTPasterView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pasterV.pasterID == pasterID)
        {
            [self.m_listPaster removeObjectAtIndex:idx] ;
            if ([_delegate respondsToSelector:@selector(xTpasterStageView:didRemovePaster:)]) {
                [_delegate xTpasterStageView:self didRemovePaster:pasterV];
                
            }
            *stop = YES ;
        }
    }] ;
}
#pragma mark - BubbleViewDelegate
-(void)makeBubbleBecomeFirstRespond:(int)bubbleID{
    [self.m_listBubble enumerateObjectsUsingBlock:^(JMBubbleView *bubbleView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        bubbleView.isOnFirst = NO ;
        
        if (bubbleView.bubbleID == bubbleID)
        {
            self.bubbleCurrent = bubbleView ;
            bubbleView.isOnFirst = YES ;
        }
        
    }] ;

}
- (void)removeBubble:(int)bubbleID{
    [self.m_listBubble enumerateObjectsUsingBlock:^(JMBubbleView *bubbleView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (bubbleView.bubbleID == bubbleID)
        {
            [self.m_listBubble removeObjectAtIndex:idx] ;
            if ([_delegate respondsToSelector:@selector(xTpasterStageView:didRemoveBubble:)]) {
                [_delegate xTpasterStageView:self didRemoveBubble:bubbleView];
            }
            *stop = YES ;
        }
    }] ;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACTOYSCLEARALLONFIRST object:nil];
    
}
@end

