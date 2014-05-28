#import "KartenAPICall.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

@interface KartenNetworkClient : NSObject

+ (void)makeRequest:(id<KartenAPICall>)request
         completion:(void(^)())completion
            success:(void(^)(AFHTTPRequestOperation *, id responseObject))success
            failure:(void(^)(AFHTTPRequestOperation *, NSError *error))failure;

@end
