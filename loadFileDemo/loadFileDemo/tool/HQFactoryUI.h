//
//  HQFactoryUI.h
//  GoldTree
//
//  Created by hongqing on 16/12/4.
//  Copyright © 2016年 miracle. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface HQFactoryUI : NSObject
/**分割线view */
+ (UIView *)separatorLine;
/**背景色的view */
+ (UIView *)hq_createViewWithBgColor:(UIColor *)color;


/**UIButton按钮 */
+ (UIButton *)buttonWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;
+ (UIButton *)buttonWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action;

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor fontSize:(NSInteger)fontSize target:(id)target action:(SEL)action;
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor fontSize:(NSInteger)fontSize cornreRadius:(CGFloat)cornerRadius target:(id)target action:(SEL)action;


/**全局红色按钮 */
+ (UIButton *)createRedButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;


/**UILabel */
+ (UILabel *)labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize;

/**UIImageView */
+(UIImageView *)imageWithName:(NSString *)imageName target:(id)target action:(SEL)action;

@end

