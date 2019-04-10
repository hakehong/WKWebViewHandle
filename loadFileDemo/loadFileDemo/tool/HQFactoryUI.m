//
//  HQFactoryUI.m
//  GoldTree
//
//  Created by hongqing on 16/12/4.
//  Copyright © 2016年 miracle. All rights reserved.
//

#import "HQFactoryUI.h"
#import "UIColor+CCColor.h"

#define IsStringNotEmpty(string)        (string && ![@"" isEqualToString:string])

@implementation HQFactoryUI

+ (UIView *)separatorLine {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHex:@"DBDBDB"];
    return view;
}

+(UIView *)hq_createViewWithBgColor:(UIColor *)color
{
    UIView *view = [UIView new];
    view.backgroundColor = color;
    return view;
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    return [self buttonWithImageName:imageName highlightImageName:nil target:target action:action];
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IsStringNotEmpty(imageName)) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (IsStringNotEmpty(highlightImageName)) {
        [button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor fontSize:(NSInteger)fontSize target:(id)target action:(SEL)action {
    return [self buttonWithTitle:title titleColor:titleColor backgroundColor:backgroundColor fontSize:fontSize cornreRadius:0 target:target action:action];
}

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor fontSize:(NSInteger)fontSize cornreRadius:(CGFloat)cornerRadius target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.backgroundColor =backgroundColor;
    if (cornerRadius >0) {
        button.layer.cornerRadius=cornerRadius;
        button.clipsToBounds=YES;
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createRedButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor colorWithHex:@"D5001C"];
    button.layer.cornerRadius =5;
    button.layer.masksToBounds =YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UILabel *)labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize{
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}

+(UIImageView *)imageWithName:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIImageView *imageView =[[UIImageView alloc]init];
    if (IsStringNotEmpty(imageName)) {
        [imageView setImage:[UIImage imageNamed:imageName]];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
    return  imageView;
}
@end

