//
//  MessageBody.m
//  HybirdApp
//
//  Created by sunner on 2023/7/6.
//

#import "MessageBody.h"

@implementation MessageBody

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.method = [dict objectForKey:@"method"];
        self.params = [dict objectForKey:@"params"];
        self.responseId = [dict objectForKey:@"responseId"];
        self.callbackId = [dict objectForKey:@"callbackId"];
    }
    return self;
}

- (NSDictionary *)toDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.method forKey:@"method"];
    [dict setValue:self.params forKey:@"params"];
    [dict setValue:self.responseId forKey:@"responseId"];
    [dict setValue:self.callbackId forKey:@"callbackId"];
    return dict.copy;
}

@end
