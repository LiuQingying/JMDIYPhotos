//
//  XTPasterStageView.h
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTPasterStageView;
@class XTPasterView;
@class JMBubbleView;
@protocol XTPasterStageViewDelegate <NSObject>
@optional
- (void)xTpasterStageViewSavePaster:(XTPasterStageView *)xTpasterStageView;
- (void)xTpasterStageViewSaveBubble:(XTPasterStageView *)xTpasterStageView;
- (void)xTpasterStageView:(XTPasterStageView *)xTpasterStageView didRemovePaster:(XTPasterView *)paster;
- (void)xTpasterStageView:(XTPasterStageView *)xTpasterStageView didRemoveBubble:(JMBubbleView *)bubble;
@end

@interface XTPasterStageView : UIView
{
// NSMutableArray  *m_listPaster ;
}
@property (nonatomic,strong) UIImage *originImage ;
/**
 代理
 */
@property (nonatomic, weak) id <XTPasterStageViewDelegate> delegate;
/**
 贴纸列表
 */
@property (nonatomic, strong) NSMutableArray *m_listPaster;
/**
 气泡
 */
@property (nonatomic, strong) NSMutableArray *m_listBubble;
- (instancetype)initWithFrame:(CGRect)frame ;
- (void)addPasterWithImg:(UIImage *)imgP ;
- (void)addBubbleWithImage:(UIImage *)image imageName:(NSString *)imageName;
- (UIImage *)doneEdit:(CGRect)frame ;
@end
