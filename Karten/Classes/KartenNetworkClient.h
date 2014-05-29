#import "KartenAPICall.h"
#import <AFNetworking/AFHTTPRequestOperation.h>

typedef void(^KartenNetworkCompletion)();
typedef void(^KartenNetworkSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^KartenNetworkFailure)(AFHTTPRequestOperation *operation, NSError *error);
@interface KartenNetworkClient : NSObject

+ (void)makeRequest:(id<KartenAPICall>)request
         completion:(KartenNetworkCompletion)completion
            success:(KartenNetworkSuccess)success
            failure:(KartenNetworkFailure)failure;

@end
