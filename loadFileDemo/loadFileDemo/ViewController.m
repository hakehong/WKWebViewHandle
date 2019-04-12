//
//  ViewController.m
//  loadFileDemo
//
//  Created by 洪清 on 2019/4/9.
//  Copyright © 2019 autoforce. All rights reserved.
//

#import "ViewController.h"
#import "HQFactoryUI.h"
#import "Masonry.h"
#import "PPNetworkHelper.h"
#import "Header.h"
#import "HQTool.h"
#import "HQWKWebViewController.h"
#import "PAirSandbox.h"
#import "SSZipArchive.h"
#import "AFNetworking.h"
#import "MagicURLProtocol.h"
#import "HQURLProtocolViewController.h"

@interface ViewController ()
@property (nonatomic,strong) UIButton *downloadBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PAirSandbox sharedInstance] enableSwipe];
    
    self.downloadBtn =[HQFactoryUI buttonWithTitle:@"下载" titleColor:[UIColor whiteColor] backgroundColor:[UIColor redColor] fontSize:16 target:self action:@selector(download)];
    self.downloadBtn.layer.cornerRadius =5;
    [self.view addSubview:self.downloadBtn];
    
    UIButton *btn2 =[HQFactoryUI buttonWithTitle:@"js代码替换WebP图片" titleColor:[UIColor whiteColor] backgroundColor:[UIColor blueColor] fontSize:16 target:self action:@selector(pushVc)];
    btn2.layer.cornerRadius =5;
    [self.view addSubview:btn2];
    
    UIButton *btn3 =[HQFactoryUI buttonWithTitle:@"拦截替换WebP图片" titleColor:[UIColor whiteColor] backgroundColor:[UIColor purpleColor] fontSize:16 target:self action:@selector(pushVc2)];
    btn3.layer.cornerRadius =5;
    [self.view addSubview:btn3];

    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(200);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.downloadBtn.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(btn2.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
}

- (IBAction)delectFile:(id)sender {
    NSError *error;
    [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@/test.zip",documentPath] error:&error];
    if (error) {
        [HQTool showAlertWithMessage:@"删除失败"];
    }else{
        [HQTool showAlertWithMessage:@"删除成功"];
    }
}

-(void)download
{
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/test.zip",documentPath]];
    if (result) {
        [HQTool showAlertWithMessage:@"已经下载过这个文件了"];
        return;
    }
    NSString *url = @"https://github.com/hakehong/testLocalWebView/raw/master/test.zip";
   
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            [HQTool showAlertWithMessage:@"下载完成"];
            [SSZipArchive unzipFileAtPath:filePath.absoluteString toDestination:CachesDirectory];
        }else{
            
            [HQTool showAlertWithMessage:@"下载失败"];
        }
    }];
    [downloadTask resume];
}

-(void)pushVc
{
    HQWKWebViewController *vc  =[HQWKWebViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)pushVc2
{
    [NSURLProtocol registerClass:[MagicURLProtocol class]];
    HQURLProtocolViewController *vc =[HQURLProtocolViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
