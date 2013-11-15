//
//  APPApiClient.h
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface APPApiClient : AFHTTPSessionManager

+ (APPApiClient *)sharedClient;

-(NSURLSessionDataTask *)getPath:(NSString *)path getParameters:(NSDictionary *)parameters getEndpointWithcompletion:(void (^)(NSArray *results, NSError *error))completion;

@end
