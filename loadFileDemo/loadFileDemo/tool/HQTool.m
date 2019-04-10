
//
//  HQTool.m
//  loadFileDemo
//
//  Created by 洪清 on 2019/4/9.
//  Copyright © 2019 autoforce. All rights reserved.
//

#import "HQTool.h"
#import <UIKit/UIKit.h>

@implementation HQTool
+ (void)showAlertWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *contentView = [[UIApplication sharedApplication].keyWindow viewWithTag:10000];
        if(contentView)
        {
            [contentView removeFromSuperview];
            contentView = nil;
        }
        
        contentView = [[UIView alloc] init];
        
        contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        contentView.layer.cornerRadius = 3;
        contentView.layer.masksToBounds = YES;
        contentView.tag = 10000;
        [[UIApplication sharedApplication].keyWindow addSubview:contentView];
        
        UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        alertLabel.backgroundColor = [UIColor clearColor];
        alertLabel.textColor = [UIColor whiteColor];
        alertLabel.numberOfLines = 0;
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.font = [UIFont systemFontOfSize:15];
        alertLabel.text = message;
        [contentView addSubview:alertLabel];
        
        if( message && message.length )
        {
            CGSize size = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            CGFloat width;
            if( size.width >  [UIApplication sharedApplication].keyWindow.bounds.size.width-80 )
            {
                width = [UIApplication sharedApplication].keyWindow.bounds.size.width-80;
            }
            else
            {
                width = size.width;
            }
            
            CGRect rect = [message boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            contentView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
            contentView.bounds = CGRectMake(0, 0, width+30, rect.size.height+30);
            alertLabel.frame = CGRectMake(15, 15, width, rect.size.height);
        }
        
        [contentView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
    });
}
@end
