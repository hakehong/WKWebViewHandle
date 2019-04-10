//
//  NSURLRequest+CYLNSURLProtocolExtension.h
//  iOSTest
//
//  Created by bjb on 2018/12/11.
//  Copyright © 2018年 wangfangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (CYLNSURLProtocolExtension)

- (NSURLRequest *)cyl_getPostRequestIncludeBody;


@end

NS_ASSUME_NONNULL_END
