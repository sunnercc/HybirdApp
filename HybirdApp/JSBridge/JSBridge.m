//
//  JSBridge.m
//  HybirdApp
//
//  Created by sunner on 2023/7/6.
//

#import "JSBridge.h"
#import <WebKit/WebKit.h>
#import "MessageBody.h"
#import "MessageEncode.h"

@interface JSBridge () <WKScriptMessageHandler, WKUIDelegate>


@property (nonatomic, weak) WKWebView *wkWebView;

@property (nonatomic, strong) NSMutableDictionary<NSString *, CallbackHandler> *callbackHandlers;
@property (nonatomic, strong) NSMutableDictionary<NSString *, MethodHandler> *methodHandlers;

@end

@implementation JSBridge

- (instancetype)init {
    if (self = [super init]) {
        self.methodHandlers = [NSMutableDictionary dictionary];
        self.callbackHandlers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)bindWithWKWebView:(WKWebView *)webView {
    self.wkWebView = webView;
    self.wkWebView.UIDelegate = self;
//    webView.UIDelegate = self;
//    webView.navigationDelegate = self;
    // 配置对象注入
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"WKJSBridge"];
}


- (void)registerMethod:(NSString *)method handler:(MethodHandler)handler {
    if (method && handler) {
        self.methodHandlers[method] = handler;
    }
}

- (void)postMessage:(NSString *)method params:(NSDictionary *)params handler:(CallbackHandler)handler {
    MessageBody *messageBody = [[MessageBody alloc] init];
    messageBody.method = method;
    messageBody.params = params;
    if (handler) {
        NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970;
        NSString *responseId = [NSString stringWithFormat:@"%f", timeInterval];
        self.callbackHandlers[responseId] = handler;
        messageBody.responseId = responseId;
    }
    [self _sendMessage:messageBody];
}


- (void)_sendMessage:(MessageBody *)messageBody {
    NSString *message = [MessageEncode serializeMessageData:messageBody.toDict];
    NSString *messageCommand = [NSString stringWithFormat:@"window.bridge._recvMessage('%@')", message];
    if ([[NSThread currentThread] isMainThread]) {
        [self.wkWebView evaluateJavaScript:messageCommand completionHandler:nil];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.wkWebView evaluateJavaScript:messageCommand completionHandler:nil];
        });
    }
}

- (void)_revcMessage:(MessageBody *)messageBody {
    NSString *responseId = messageBody.responseId;
    if (messageBody.callbackId) { // 说明是回调
        ResponseHandler handler = self.callbackHandlers[messageBody.callbackId];
        if (handler) handler(messageBody.params);
    } else if (messageBody.method) {
        MethodHandler handler = self.methodHandlers[messageBody.method];
        if (handler) {
            if (messageBody.responseId) {
                messageBody.responseHandler = ^(NSDictionary *params) {
                    // 构建消息体
                    MessageBody *sendMessageBody = [[MessageBody alloc] init];
                    sendMessageBody.callbackId = responseId;
                    sendMessageBody.params = params;
                    [self _sendMessage:sendMessageBody];
                };
            }
            handler(messageBody.params, messageBody.responseHandler);
        }
    }
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    MessageBody *messageBody = [[MessageBody alloc] initWithDictionary:message.body];
    [self _revcMessage:messageBody];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    if (webView != self.wkWebView) return;
    NSData *jsonData = [prompt dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                              error:&err];
    MessageBody *messageBody = [[MessageBody alloc] initWithDictionary:dic];
    if (messageBody.method) {
        MethodHandler handler = self.methodHandlers[messageBody.method];
        if (handler) {
            messageBody.responseHandler = ^(NSDictionary *params) {
                NSString *result = [MessageEncode serializeMessageData:params];
                completionHandler(result);
            };
            handler(messageBody.params, messageBody.responseHandler);
        }
    }
}

- (void)dealloc {
    
    [self.wkWebView.configuration.userContentController removeAllScriptMessageHandlers];
}

@end
