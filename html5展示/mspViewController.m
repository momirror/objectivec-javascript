//
//  mspViewController.m
//  html5展示
//
//  Created by mac on 14-4-23.
//  Copyright (c) 2014年 msp. All rights reserved.
//

#import "mspViewController.h"

@interface mspViewController ()

@end

@implementation mspViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _webView =  [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_webView];
    
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
     NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    [_webView loadRequest:request];
}


/**
 *  在这里实现javascript调用objectivec
 *
 *  @param webView        webView
 *  @param request        请求
 *  @param navigationType 类型
 *
 *  @return
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@":"];

    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
        
    {
        
        NSString *funcStr = [urlComps objectAtIndex:1];
        
        if([funcStr isEqualToString:@"doFunc1"])
            
        {
            
            [self doFunc1];
            
        }
        
        else if([funcStr isEqualToString:@"doFunc2"])
            
        {
            NSLog(@"%@",[self replaceUnicode:urlString]);
            [self doFunc2:[urlComps objectAtIndex:2] UserId:[urlComps objectAtIndex:3]];
            
        }
        
        return NO;
        
    }
    
    return YES;
    

}


- (void)webViewDidStartLoad:(UIWebView *)webView
{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{


//    NSString *js_result = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('button')[0].value='bbb';"];
//    [webView stringByEvaluatingJavaScriptFromString:@"userId = 'aa'"];
//    [webView stringByEvaluatingJavaScriptFromString:@"userName = 'bb'"];
    
    [self objectivecCallJavascript:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error:%@",[error description]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
     message:@"网址访问失败"
     delegate:self
     cancelButtonTitle:@"确认"
     otherButtonTitles:nil, nil];
     [alert show];
}

/**
 *  在oc中调用javascript
 *
 *  @param webView 调用对象
 */
- (void)objectivecCallJavascript:(UIWebView*)webView
{
    NSString * strName = @"张三";
    NSString * strId = @"124436456456";
    NSString * strJavaScript = [NSString stringWithFormat:@"setUserInfomation('%@','%@')",strName,strId];
    
    [webView stringByEvaluatingJavaScriptFromString:strJavaScript];
    
    [webView stringByEvaluatingJavaScriptFromString:@"myJavascriptFunction()"];
}


- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (void)doFunc1
{
    NSLog(@"doFunc1");
}

- (void)doFunc2:(NSString*)strName UserId:(NSString*)strId
{
    NSLog(@"doFunc2:%@,%@",strName,strId);
}

@end
