//
//  JSBridge.h
//  HybirdApp
//
//  Created by sunner on 2023/7/6.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKUIDelegate.h>
#import <WebKit/WKNavigation.h>
#import "MessageBody.h"

NS_ASSUME_NONNULL_BEGIN


@protocol JSBridgeWKUIDelegate <NSObject>


@end

@protocol JSBridgeWKNavigation <NSObject>


@end

typedef void (^CallbackHandler)(NSDictionary *params);

typedef void (^MethodHandler)(NSDictionary *params, ResponseHandler handler);

@interface JSBridge : NSObject

@property (nonatomic, weak) id<JSBridgeWKUIDelegate> wkUIDelegate;
@property (nonatomic, weak) id <JSBridgeWKNavigation> wkNavigation;

- (void)bindWithWKWebView:(WKWebView *)webView;

- (void)registerMethod:(NSString *)method handler:(MethodHandler)handler;

- (void)postMessage:(NSString *)method params:(NSDictionary *)params handler:(CallbackHandler)handler;

@end

NS_ASSUME_NONNULL_END
