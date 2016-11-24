//
//  UIImage+Extension.h
//  actoys
//
//  Created by LiuQingying on 16/3/23.
//  Copyright © 2016年 Actoys.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
- (instancetype)circleImage;
+ (instancetype)circleImageWithNamed:(NSString *)name;
// 根据颜色生成一张尺寸为1*1的相同颜色图片
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)squareImageFromImage:(UIImage *)image
                     scaledToSize:(CGFloat)newSize ;

+ (UIImage *)getImageFromView:(UIView *)theView ;
/**
 *  生成带圆圈的圆形图片
 */
+ (instancetype)circleImageWithName:(UIImage *)oldImage
                              width:(CGFloat)width
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor;
+(UIImage *)coreBlurImage:(UIImage *)image
           withBlurNumber:(CGFloat)blur;
/**
 模糊图
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
@end
