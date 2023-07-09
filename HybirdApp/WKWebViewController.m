//
//  WKWebViewController.m
//  HybirdApp
//
//  Created by sunner on 2023/7/6.
//

#import "WKWebViewController.h"
#import <WebKit/WKWebView.h>
#import "JSBridge.h"

@interface WKWebViewController ()

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) JSBridge *jsBridge;
@property (nonatomic, weak) UITextView *logView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.webView = webView;
    
    self.webView.inspectable = true;    
    
    CGRect logFrame = CGRectMake(0, self.view.bounds.size.height - 200, self.view.bounds.size.width, 200);
    UITextView *logView = [[UITextView alloc] initWithFrame:logFrame];
    logView.backgroundColor = [UIColor systemPinkColor];
    [self.view addSubview:logView];
    self.logView = logView;
    
    self.jsBridge = [[JSBridge alloc] init];
    [self.jsBridge bindWithWKWebView:self.webView];
    
    UIButton *postMessageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    postMessageBtn.frame = CGRectMake(0, self.view.bounds.size.height -250, 100, 30);
    [postMessageBtn setTitle:@"postMessage" forState:UIControlStateNormal];
    [postMessageBtn addTarget:self action:@selector(postMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postMessageBtn];
    
    [self.jsBridge registerMethod:@"OCLog" handler:^(NSDictionary * _Nonnull params, __autoreleasing ResponseHandler handler) {
        self.logView.text = [NSString stringWithFormat:@"js->oc: params: %@", params];
        if (handler) {
            handler(@{
                @"result1": @"result1",
                @"result2": @"result2",
            });
        };
    }];
    
    
    
    
    
    NSLog(@"%s", __func__);
}

- (void)postMessage:(UIButton *)button {
    [self.jsBridge postMessage:@"JSLog" params:@{@"params1":@"params1\n",@"params2":@"params2"} handler:^(NSDictionary * _Nonnull params) {
        self.logView.text = [NSString stringWithFormat:@"oc->js: callback: %@", params];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:5173/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    NSLog(@"%s", __func__);
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
