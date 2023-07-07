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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSLog(@"%s", __func__);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:5173/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    NSLog(@"%s", __func__);
}

@end
