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
#import "MyURLProtocol.h"

@interface ViewController ()
@property (nonatomic,strong) UIButton *downloadBtn;
//0加载本地 1、拦截webp图片替换
@property (nonatomic,assign) NSInteger type;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = [[NSArray alloc]initWithObjects:@"本地webP",@"本地图片", nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
    segment.selectedSegmentIndex =0;
    [segment addTarget:self action:@selector(segmentSwitch:) forControlEvents:UIControlEventValueChanged];
    //添加到主视图
    [self.view addSubview:segment];
    self.type =0;
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(100);
    }];
    
    
    [[PAirSandbox sharedInstance] enableSwipe];
    //https://1111-1258193047.cos.ap-chengdu.myqcloud.com/test.zip
    self.downloadBtn =[HQFactoryUI buttonWithTitle:@"下载" titleColor:[UIColor whiteColor] backgroundColor:[UIColor redColor] fontSize:16 target:self action:@selector(download)];
    self.downloadBtn.layer.cornerRadius =5;
    UIButton *btn2 =[HQFactoryUI buttonWithTitle:@"加载本地webp_html" titleColor:[UIColor whiteColor] backgroundColor:[UIColor blueColor] fontSize:16 target:self action:@selector(pushVc)];
    btn2.layer.cornerRadius =5;
    [self.view addSubview:self.downloadBtn];
    [self.view addSubview:btn2];

    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_centerY).offset(-30);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_centerY).offset(30);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
}

-(void)segmentSwitch:(UISegmentedControl *)sender
{
    self.type =sender.selectedSegmentIndex;
}

- (IBAction)delectFile:(id)sender {
    NSError *error;
    [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@/%@.zip",documentPath,self.type==0?@"test":@"test2"] error:&error];
    if (error) {
        [HQTool showAlertWithMessage:@"删除失败"];
    }else{
        [HQTool showAlertWithMessage:@"删除成功"];
    }
}

-(void)download
{
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.zip",documentPath,self.type==0?@"test":@"test2"]];
    if (result) {
        [HQTool showAlertWithMessage:@"已经下载过这个文件了"];
        return;
    }
    NSString *url;
    if (self.type ==0) {
        url =@"https://github.com/hakehong/testLocalWebView/raw/master/test.zip";
    }else{
        url =@"https://github.com/hakehong/testLocalWebView/raw/master/test2.zip";
    }
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
    vc.viewType =self.type;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
