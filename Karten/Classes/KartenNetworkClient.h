#import "KartenAPICall.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

typedef void(^KartenNetworkCompletion)();
typedef void(^KartenNetworkSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^KartenNetworkFailure)(AFHTTPRequestOperation *operation, NSError *error, id parsedError);
@interface KartenNetworkClient : NSObject

+ (void)makeRequest:(id<KartenAPICall>)request
         completion:(void (^)())completion
            success:(void (^)(AFHTTPRequestOperation *, id))success
            failure:(void (^)(AFHTTPRequestOperation *, NSError *, id))failure;
@end
