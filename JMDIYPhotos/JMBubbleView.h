//
//  JMBubbleView.h
//  actoys
//
//  Created by LiuQingying on 16/4/14.
//  Copyright © 2016年 Actoys.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTPasterStageView.h"

@class JMBubbleView;

@protocol JMBubbleViewDelegate <NSObject>
- (void)makeBubbleBecomeFirstRespond:(int)bubbleID ;
- (void)removeBubble:(int)bubbleID ;
@end

@interface JMBubbleView : UIView
@property (nonatomic,strong) UIImageView    *imgContentView;
@property (nonatomic,strong) UIImageView    *btDelete;
@property (nonatomic,strong) UIImageView    *btSizeCtrl;
@property (nonatomic,strong)    UIImage *imageBubble;
/**
 贴纸名字
 */
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, assign)           int     bubbleID;
@property (nonatomic, assign)           BOOL    isOnFirst;
@property (nonatomic, weak)    id <JMBubbleViewDelegate> delegate ;
- (instancetype)initWithBgView:(XTPasterStageView *)bgView
                      bubbleID:(int)bubbleID
                           img:(UIImage *)img
                     imageName:(NSString *)imageName;
- (void)remove ;

@end
