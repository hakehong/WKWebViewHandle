//
//  MyURLProtocol.m
//  iOSTest
//
//  Created by wangfangshuai on 16/8/8.
//  Copyright © 2016年 wangfangshuai. All rights reserved.
//

#import "MyURLProtocol.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSURLRequest+CYLNSURLProtocolExtension.h"

#import "SDWebImageCompat.h"
#ifdef SD_WEBP
#import "UIImageView+WebCache.h"
#endif

#define LibraryDirectory [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/NoCloud/cars"]

@interface MyURLProtocol()
@property (strong, nonatomic) NSURLConnection *connection;

@end
@implementation MyURLProtocol

//+ (void)start {
//    
//    NSArray *privateStrArr = @[@"Controller", @"Context", @"Browsing", @"K", @"W"];
//    NSString *className =  [[[privateStrArr reverseObjectEnumerator] allObjects] componentsJoinedByString:@""];
//    Class cls = NSClassFromString(className);
//    SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
//    
//    if (cls && sel) {
//        if ([(id)cls respondsToSelector:sel]) {
//            [(id)cls performSelector:sel withObject:@"http"];
//            [(id)cls performSelector:sel withObject:@"https"];
//        }
//    }
//    [NSURLProtocol registerClass:self];
//}
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *urlString = request.URL.absoluteString;
    if (!SD_WEBP || ([urlString.pathExtension compare:@"webp"] != NSOrderedSame)) {
        return NO;
    }
    if([NSURLProtocol propertyForKey:@"MyURLProtocolHandledKey" inRequest:request]) {
        return NO;
    }
    return [self checkUrl:request.URL.absoluteString];
}
+ (BOOL)checkUrl:(NSString *)url{
    
    BOOL existPath    = NO;
    NSString *baseUrl = @"https://cdn.autoforce.net/ixiao/cars";
    if ([url containsString:baseUrl] && ![url containsString:@"mp4"]) {
        
//        url                 = [url substringFromIndex:baseUrl.length];//截取掉下标baseUrl.length之后的字符串
//        NSString *localPath = [NSString stringWithFormat:@"%@%@",LibraryDirectory,url];
//        existPath           = [[NSFileManager defaultManager]fileExistsAtPath:localPath];
        existPath           = YES;
    }
    return existPath;

}
+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;

//    return [request cyl_getPostRequestIncludeBody];
;
}

+(BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    
    return [super requestIsCacheEquivalent:a toRequest:b];
}

-(void)startLoading
{
    NSMutableURLRequest *newRequest = [self cloneRequest:self.request];
    NSString *urlString = newRequest.URL.absoluteString;
    //NSLog(@"######截获WebP url:%@",urlString);
    [NSURLProtocol setProperty:@YES forKey:@"MyURLProtocolHandledKey" inRequest:newRequest];
    [self sendRequest:newRequest];
    return;
//    NSMutableURLRequest *newRequest = [self.request mutableCopy];
//    [NSURLProtocol setProperty:@YES forKey:@"MyURLProtocolHandledKey" inRequest:newRequest];
//    NSString *absoluteString        = newRequest.URL.absoluteString;
//    NSString *baseUrl               = @"https://cdn.autoforce.net/ixiao/cars";
//    absoluteString                  = [absoluteString substringFromIndex:baseUrl.length];//截取掉下标baseUrl.length之后的字符串
//    NSString *localPath             = [NSString stringWithFormat:@"%@%@",LibraryDirectory,absoluteString];
//    BOOL existPath                  = [[NSFileManager defaultManager]fileExistsAtPath:localPath];
//    if (existPath ) {
//        NSData *data = [NSData dataWithContentsOfFile:localPath];
//        if (data) {
////            NSString *type = [self getMimeTypeWithFilePath:localPath];
////            [self sendResponseWithData:data mimeType:type];
//
//        }else{
//            [self startWithSession:newRequest];
////            [[WebDownLoadManager shareInstance]beginDownloadWithUrl:newRequest.URL.absoluteString];
//        }
//
//    }else{
//            [self startWithSession:newRequest];
////            [[WebDownLoadManager shareInstance]beginDownloadWithUrl:newRequest.URL.absoluteString];
//    }
    
}

- (void)sendRequest:(NSURLRequest *)request{
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}



//复制Request对象
- (NSMutableURLRequest *)cloneRequest:(NSURLRequest *)request{
    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:request.URL cachePolicy:request.cachePolicy timeoutInterval:request.timeoutInterval];
    
    newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
    [newRequest setValue:@"image/webp,image/*;q=0.8" forHTTPHeaderField:@"Accept"];
    if (request.HTTPMethod) {
        newRequest.HTTPMethod = request.HTTPMethod;
    }
    if (request.HTTPBodyStream) {
        newRequest.HTTPBodyStream = request.HTTPBodyStream;
    }
    if (request.HTTPBody) {
        newRequest.HTTPBody = request.HTTPBody;
    }
    newRequest.HTTPShouldUsePipelining = request.HTTPShouldUsePipelining;
    newRequest.mainDocumentURL = request.mainDocumentURL;
    newRequest.networkServiceType = request.networkServiceType;
    return newRequest;
    
}


- (void)sendResponseWithData:(NSData *)data mimeType:(nullable NSString *)mimeType
{
    if (mimeType == nil) {
        mimeType = @"*/*";
    }
//    // 这里需要用到MIMEType
//    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:super.request.URL
//                                                        MIMEType:mimeType
//                                           expectedContentLength:data.length
//                                                textEncodingName:nil];
//
//
//    //硬编码 开始嵌入本地资源到web中
//    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//    if (data) {
////        if ([mimeType containsString:@"mp4"]) {
////            NSLog(@"data.length%ld",data.length);
////        }
//        [[self client] URLProtocol:self didLoadData:data];
//
//    }
//    [[self client] URLProtocolDidFinishLoading:self];
    NSMutableDictionary* responseHeaders = [[NSMutableDictionary alloc] init];
    responseHeaders[@"Cache-Control"] = @"no-cache";
    responseHeaders[@"Content-Type"] = mimeType;
    NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:super.request.URL
                                                          statusCode:200
                                                         HTTPVersion:@"HTTP/1.1"
                                                        headerFields:responseHeaders];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    if (data) {
        [[self client] URLProtocol:self didLoadData:data];
    }
    [[self client] URLProtocolDidFinishLoading:self];
}

//- (NSString *)getMimeTypeWithFilePath:(NSString *)filePath{
//    CFStringRef pathExtension = (__bridge_retained CFStringRef)[filePath pathExtension];
//    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
//    CFRelease(pathExtension);
//
//    //The UTI can be converted to a mime type:
//    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
//    if (type != NULL)
//        CFRelease(type);
//
//    return mimeType;
//}

- (void)startWithSession:(NSMutableURLRequest *)newRequest{
    
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session  = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:self.queue];
    self.task = [self.session dataTaskWithRequest:newRequest];
    [self.task resume];
}
- (void)stopLoading {
//    NSLog(@"stopLoading");
    if (_session) {
        [self.session invalidateAndCancel];
        _session = nil;
    }

}
- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != nil) {
        [self.client URLProtocol:self didFailWithError:error];
    }else
    {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
//    CYXLog(@"data:::::::%@",data);
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    completionHandler(proposedResponse);
}

//TODO: 重定向
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSMutableURLRequest*    redirectRequest;
    redirectRequest = [newRequest mutableCopy];
    [[self class] removePropertyForKey:@"MyURLProtocolHandledKey" inRequest:redirectRequest];
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    
    [self.task cancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}
@end
