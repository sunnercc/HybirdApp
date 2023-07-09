//
//  ViewController.m
//  HybirdApp
//
//  Created by sunner on 2023/7/6.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:@{
        NSHTTPCookieName: @"QiShareToken",
        NSHTTPCookieValue: @"QiShareTokenValue",
        NSHTTPCookiePath: @"/",
        NSHTTPCookieDomain: @".baidu.com"
    }];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}


@end
