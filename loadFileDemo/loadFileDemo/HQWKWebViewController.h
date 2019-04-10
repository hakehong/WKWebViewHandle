//
//  HQWKWebViewController.h
//  loadFileDemo
//
//  Created by 洪清 on 2019/4/9.
//  Copyright © 2019 autoforce. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    normalImgType =0,
    webpImgType,
}webViewType;
@interface HQWKWebViewController : UIViewController
@property (nonatomic,assign) webViewType viewType;
@end

NS_ASSUME_NONNULL_END
