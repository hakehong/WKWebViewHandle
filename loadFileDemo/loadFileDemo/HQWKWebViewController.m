//
//  HQWKWebViewController.m
//  loadFileDemo
//
//  Created by 洪清 on 2019/4/9.
//  Copyright © 2019 autoforce. All rights reserved.
//

#import "HQWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "Header.h"
#import "SDWebImageManager.h"
#import "UIImage+Ext.h"
#import "UIImage+WebP.h"

@interface HQWKWebViewController ()<WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation HQWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];

    //添加js交互代码
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"TanlentC-Webp.js" ofType:nil];
    NSString *scource = [NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
    WKUserScript * uScript = [[WKUserScript alloc] initWithSource:scource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [config.userContentController addUserScript:uScript];
    
    
    [config.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    self.webView =[[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate =self;
    [self.view addSubview:self.webView];
    NSString *path =[NSString stringWithFormat:@"file://%@test/a.html",CachesDirectory];
    NSLog(@"html地址-----:%@",path);
    NSURL *accessURL = [[NSURL URLWithString:path] URLByDeletingLastPathComponent];
    [_webView loadFileURL:[NSURL URLWithString:path] allowingReadAccessToURL:accessURL];
    // Do any additional setup after loading the view.
}

-(void)setupUI
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

-(void)goBack
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark-
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    //WKWebView 加载完毕
//    if (self.currentType == WEBType_WKjs) {
        //执行js 获取全部webp的图片地址
        __weak typeof(self)wself = self;
        //WKWebView 不知道什么原因 不延迟直接用会导致 偶尔出现不能对图片更新 这里延迟0.1s 原因以后在研究了
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [webView evaluateJavaScript:@"talentcGetAllImageSrc()" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                if (error == nil) {
                    [wself webViewGetAllImgSrc:obj];
                }
            }];
        });
//    }
}

- (void)webViewGetAllImgSrc:(NSString *)jsonString
{
    if (!jsonString || jsonString.length == 0)  {
        return;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *imgs = json;
    for (NSString *imgUrl in imgs) {
        if (imgUrl) {
            NSString *fileStr =@"file://";
            NSString *resImg;
            if ([imgUrl containsString:fileStr]) {
               resImg =  [imgUrl substringFromIndex:fileStr.length];
            }
            NSData *data = [[NSData alloc] initWithContentsOfFile:resImg];
            UIImage *tempImg =[UIImage sd_imageWithWebPData:data];
            if (tempImg) {
                NSString *base64Image = [tempImg imageToBase64Data];
                //这种base64的编码好像不行
//                NSString *base64Image =[self htmlForJPGImage:tempImg];
                NSString *jsString = [NSString stringWithFormat:@"talentcReplaceWebPImg('%@','%@')",imgUrl,base64Image];
                
                WKWebView *webView = (WKWebView *)self.webView;
                
                [webView evaluateJavaScript:jsString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                    NSLog(@"error : %@ webView:%p",error,webView);
                }];
            }
        }
    }
}

//此方法不行
- (NSString *)htmlForJPGImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString   stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return imageSource;
}

@end
