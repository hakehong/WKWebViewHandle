
//
//  HQURLProtocolViewController.m
//  loadFileDemo
//
//  Created by 洪清 on 2019/4/11.
//  Copyright © 2019 autoforce. All rights reserved.
//

#import "HQURLProtocolViewController.h"
#import <WebKit/WebKit.h>
#import "Header.h"
#import "SDWebImageManager.h"
#import "UIImage+Ext.h"
#import "UIImage+WebP.h"
#import "NSURLProtocol+MagicWebView.h"

@interface HQURLProtocolViewController ()<WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation HQURLProtocolViewController

- (void)registerWeb{
    [NSURLProtocol wk_registerScheme:@"file"];
    [NSURLProtocol wk_registerScheme:@"https"];
}

- (void)unRegisterWeb{
    [NSURLProtocol wk_unregisterScheme:@"file"];
    [NSURLProtocol wk_unregisterScheme:@"https"];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self registerWeb];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unRegisterWeb];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    self.webView =[[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate =self;
    [self.view addSubview:self.webView];
    NSString *path =[NSString stringWithFormat:@"file://%@test/a.html",CachesDirectory];
    NSLog(@"html地址-----:%@",path);
    NSURL *accessURL = [[NSURL URLWithString:path] URLByDeletingLastPathComponent];
    [_webView loadFileURL:[NSURL URLWithString:path] allowingReadAccessToURL:accessURL];
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

@end
