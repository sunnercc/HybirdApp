//
//  MessageEncode.m
//  HybirdApp
//
//  Created by sunner on 2023/7/6.
//

#import "MessageEncode.h"

@implementation MessageEncode

+ (NSString *)serializeMessageData:(NSDictionary *)message {
    if (message) {
        NSString *messageString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        return [self transcodingJavascriptMessage:messageString];
    }
    return nil;
}
+ (NSString *)transcodingJavascriptMessage:(NSString *)message
{
    message = [message stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    message = [message stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    message = [message stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    message = [message stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    message = [message stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    message = [message stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    message = [message stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    message = [message stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    return message;
}

@end
