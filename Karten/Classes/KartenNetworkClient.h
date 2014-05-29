#import "KartenAPICall.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

@interface KartenNetworkClient : NSObject

+ (void)makeRequest:(id<KartenAPICall>)request
         completion:(void(^)())completion
            success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
