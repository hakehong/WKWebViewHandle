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
#import "NSURLProtocol+WKWebView.h"
#import "SDWebImageManager.h"
#import "UIImage+Ext.h"
#import "UIImage+WebP.h"
#import "UIImage+WebP2.h"

@interface HQWKWebViewController ()<WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation HQWKWebViewController

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self registerWeb];
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self unRegisterWeb];
//}

- (void)registerWeb{
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
}

- (void)unRegisterWeb{
    [NSURLProtocol wk_unregisterScheme:@"http"];
    [NSURLProtocol wk_unregisterScheme:@"https"];
}


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
    NSString *path;
    if (self.viewType ==normalImgType) {
        path =[NSString stringWithFormat:@"file://%@test/a.html",CachesDirectory];
    }else{
        path =[NSString stringWithFormat:@"file://%@test2/a.html",CachesDirectory];
    }
        
//    NSString *path =[NSString stringWithFormat:@"file://%@test/a.html",CachesDirectory];
    NSLog(@"html地址-----:%@",path);
    NSURL *accessURL = [[NSURL URLWithString:path] URLByDeletingLastPathComponent];
    [_webView loadFileURL:[NSURL URLWithString:path] allowingReadAccessToURL:accessURL];
    // Do any additional setup after loading the view.
}

-(void)setupUI
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
//    [[UIBarButtonItem alloc] initWithImage:@"navi_back" target:self action:@selector(goBack)];
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
            __weak __typeof(self)wself = self;
            NSString *fileStr =@"file://";
            NSString *resImg;
            if ([imgUrl containsString:fileStr]) {
               resImg =  [imgUrl substringFromIndex:fileStr.length];
            }
//            NSData *data = [[NSData alloc] initWithContentsOfFile:resImg];
//            UIImage *image2;
            resImg = [[NSBundle mainBundle] pathForResource:@"test22" ofType:@"webp"];
            NSData *data = [[NSData alloc] initWithContentsOfFile:resImg];
//            UIImage *tempImg =  [UIImage imageWithWebPData:data];
            UIImage *tempImg =[UIImage sd_imageWithWebPData:data];
            if (tempImg) {
                NSString *base64Image = [tempImg imageToBase64Data];
//                NSString *base64Image =[self htmlForJPGImage:tempImg];
//                base64Image=@"http://pic29.nipic.com/20130601/12122227_123051482000_2.jpg";
                NSString *jsString = [NSString stringWithFormat:@"talentcReplaceWebPImg('%@','%@')",imgUrl,base64Image];
                
                WKWebView *webView = (WKWebView *)self.webView;
                
                [webView evaluateJavaScript:jsString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                    NSLog(@"error : %@ webView:%p",error,webView);
                }];
            }
            
//            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:NULL completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//                __strong __typeof (wself) sself = wself;
//                if (!sself) {
//                    return;
//                }
//                if(image){
//                    NSString *base64Image = [image imageToBase64Data];
//                    NSString *jsString = [NSString stringWithFormat:@"talentcReplaceWebPImg('%@','%@')",imageURL,base64Image];
//
//                    WKWebView *webView = (WKWebView *)sself.webView;
//
//                    [webView evaluateJavaScript:jsString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
//                        NSLog(@"error : %@ webView:%p",error,webView);
//                    }];
//                }
//            }];
        }
    }
}

- (NSString *)htmlForJPGImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString   stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return imageSource;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
