//
//  MessageEncode.h
//  HybirdApp
//
//  Created by sunner on 2023/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageEncode : NSObject

+ (NSString *)serializeMessageData:(NSDictionary *)message;

@end

NS_ASSUME_NONNULL_END
