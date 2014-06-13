#import <AFNetworking/AFNetworking.h>
#import "KartenNetworkClient.h"
#import "JSONParsable.h"
@interface KartenNetworkClient ()

@property (nonatomic) AFHTTPRequestOperationManager *manager;

@end

static NSString *BaseUrl = @"http://192.168.0.233";

@implementation KartenNetworkClient


+ (instancetype)sharedClient
{
    static dispatch_once_t onceToken;
    static id sharedObject;
    dispatch_once(&onceToken, ^{
        if (sharedObject == nil) {
            sharedObject = [[self alloc] init];
        }
    });
    return sharedObject;
}

+ (void)makeRequest:(id<KartenAPICall>)request
         completion:(void (^)())completion
            success:(void (^)(AFHTTPRequestOperation *, id))success
            failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    [[self sharedClient] makeRequest:request
                          completion:completion
                             success:success
                             failure:failure];
}

- (void)makeRequest:(id<KartenAPICall>)request
         completion:(void (^)())completion
            success:(void (^)(AFHTTPRequestOperation *, id))success
            failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSMutableURLRequest *URLrequest = [NSMutableURLRequest new];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:URLrequest];
    [operation setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    NSDictionary *params = nil;
    if ([request respondsToSelector:@selector(params)]) {
        params = request.params;
    }
    DLog(@"Fetching from %@/%@. Params: %@", self.manager.baseURL, request.path, params);
    [self.manager GET:request.path parameters:params success:
        ^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([self responseHasError:responseObject]) {
                if (failure) {
                    failure(responseObject, [self errorFromResponse:responseObject]);
                }
                return;
            }
            DLog(@"Finished fetch from %@%@. Response: %@", self.manager.baseURL, request.path, responseObject);
        if (responseObject != nil) {
            id returnObject = nil;
            if ([request.classToParse conformsToProtocol:@protocol(JSONParsable)]) {
                if ([responseObject conformsToProtocol:@protocol(NSFastEnumeration)] && [responseObject isKindOfClass:[NSDictionary class]] == NO) {
                    NSMutableArray *responseArray = [NSMutableArray array];
                    for (id objectData in responseObject) {
                        id<JSONParsable> newObj = [request.classToParse objectWithJSONDictionary:objectData];
                        [responseArray addObject:newObj];
                    }
                    returnObject = responseArray;
                } else {

                    if ([request respondsToSelector:@selector(updateOriginalObjectOnReturn)] && request.updateOriginalObjectOnReturn == YES) {
                        NSManagedObjectContext *ctx = [NSManagedObjectContext MR_contextForCurrentThread];
                        NSManagedObject <JSONParsable> *originalObject = (NSManagedObject <JSONParsable> *)[ctx objectWithID:request.objectID];
                        [originalObject updateWithJSONDictionary:responseObject];
                        returnObject = originalObject;
                } else {
                    id<JSONParsable> newObject = [request.classToParse objectWithJSONDictionary:responseObject];
                    returnObject = newObject;
                    }
                    
                }
            } else {
                returnObject = responseObject;
            }
            if (success) {
                success(operation, returnObject);
            }
        }
        if (completion) {
            completion();
        }

    }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion();
        }
          DLog(@"Finished fetch from %@%@. Error: %@", self.manager.baseURL, request.path, error);

          if (failure) {
              failure(operation, error);
          }
    }];
}

- (AFHTTPRequestOperationManager *)manager
{
    if (_manager == nil) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
        [_manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    return _manager;
}

- (BOOL)responseHasError:(NSDictionary *)responseObject
{
    BOOL retval = NO;
    if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"error_code"]) {
        retval = YES;
    }
    return retval;
}

- (NSError *)errorFromResponse:(NSDictionary *)responseObject
{
    NSError *error = [NSError errorWithDomain:@"KartenServerErrorDomain" code:1 userInfo:responseObject];
    return error;
}

@end
