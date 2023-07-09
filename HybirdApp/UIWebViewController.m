//
//  UIWebViewController.m
//  HybirdApp
//
//  Created by sunner on 2023/7/6.
//

#import "UIWebViewController.h"

@interface UIWebViewController()

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation UIWebViewController


- (NSString *)userAgent {
    UIScreen *screen = [UIScreen mainScreen];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion]; // 14.0 或 15.1
    NSString *deviceType = [[UIDevice currentDevice] model]; // iPhone 或 iPad
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary]  objectForKey:@"CFBundleShortVersionString"]; // app 版本号
    NSString *userAgent = [NSString stringWithFormat:@"UIBridge_w%.0f_h%.0f_OS%@_%@_app%@", screen.bounds.size.width,
        screen.bounds.size.height,
        systemVersion,
        deviceType,
        appVersion
    ];
    return userAgent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.webView = webView;
    [self changeAppGlobalUA];
    NSLog(@"%s", __func__);
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths firstObject];
//    NSLog(@"沙盒路径: %@", documentsDirectory);
}

- (void)changeAppGlobalUA {
    // 获取 ua 的 WebView 和 发起请求的 ua 不能是同一份，否则会出现第一个页面ua失效
    UIWebView *tmpWebView = [[UIWebView alloc] init];
    NSString *ua = [tmpWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *myUA = [NSString stringWithFormat:@"%@%@", ua, [self userAgent]];
    NSDictionary *dictionary = @{
        @"UserAgent": myUA
    };
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}


- (void)restoreAppGlobalUA {
    UIWebView *tmpWebView = [[UIWebView alloc] init];
    NSString *replaceStr = [NSString stringWithFormat:@" %@", [self userAgent]];
    NSString *ua = [tmpWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *myUA = [ua stringByReplacingOccurrencesOfString:replaceStr withString:@""];
    NSDictionary *dictionary = @{
        @"UserAgent": myUA
    };
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self restoreAppGlobalUA];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:5173/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    NSLog(@"%s", __func__);
}

@end
