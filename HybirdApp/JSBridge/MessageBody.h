//
//  MessageBody.h
//  HybirdApp
//
//  Created by sunner on 2023/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ResponseHandler)(NSDictionary *params);


@interface MessageBody : NSObject

@property (nonatomic, copy) NSString *method; // 方法名
@property (nonatomic, copy) NSDictionary *params; // 方法参数
@property (nonatomic, copy) NSString *callbackId; // js回调的 callbackId
@property (nonatomic, copy) NSString *responseId; // js回调的 callbackId
@property (nonatomic, copy) ResponseHandler responseHandler;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)toDict;

@end

NS_ASSUME_NONNULL_END
