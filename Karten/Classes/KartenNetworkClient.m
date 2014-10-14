#import <AFNetworking/AFNetworking.h>
#import "KartenNetworkClient.h"
#import "JSONParsable.h"
#import "NSObject+NSDictionaryRepresentation.h"
#import "Karten-Swift.h"

@interface KartenNetworkClient ()

@property (nonatomic) AFHTTPRequestOperationManager *manager;

@end

static NSString *BaseUrl = @"http://54.73.59.208/";
//static NSString *BaseUrl = @"http://0.0.0.0:8000/";
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
    NSDictionary *params = nil;

    if ([request respondsToSelector:@selector(params)]) {
        params = request.params;
    }
    NSError *err = nil;
    NSMutableURLRequest *URLrequest = [self.manager.requestSerializer requestWithMethod:request.HTTPMethod
                                                                              URLString:[[NSURL URLWithString:request.path relativeToURL:self.manager.baseURL] absoluteString]
                                                                             parameters:params
                                                                                  error:&err];
    if ([request.HTTPMethod isEqualToString:@"POST"] || [request.HTTPMethod isEqualToString:@"DELETE"]) {
        [URLrequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:0 error:NULL]];
    }
    [URLrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [URLrequest setValue:[KartenNetworkTokenManager createAuthorizationHeaderString] forHTTPHeaderField:@"Authorization"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:URLrequest];
    [operation setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [self.manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    NSLog([URLrequest curlCommand]);
    DLog(@"Fetching from %@%@. Params: %@", self.manager.baseURL, request.path, params);
    void(^wrappedSuccess)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self responseHasError:responseObject]) {
            if (failure) {
                failure(responseObject, [self errorFromResponse:responseObject]);
            }
            return;
        }
        DLog(@"Finished fetch from %@%@. Response: %@", self.manager.baseURL, request.path, responseObject);
        if (responseObject != nil) {
            id returnObject = nil;
            if ([request respondsToSelector:@selector(classToParse)] && [request.classToParse conformsToProtocol:@protocol(JSONParsable)]) {
                if ([responseObject conformsToProtocol:@protocol(NSFastEnumeration)] && [responseObject isKindOfClass:[NSDictionary class]] == NO) {
                    NSMutableArray *responseArray = [NSMutableArray array];
                    for (id objectData in responseObject) {
                        id<JSONParsable> newObj = [request.classToParse objectWithJSONDictionary:objectData];
                        [responseArray addObject:newObj];
                    }
                    returnObject = responseArray;
                } else {
                    
                    if ([request respondsToSelector:@selector(updateOriginalObjectOnReturn)] && request.updateOriginalObjectOnReturn == YES && [request respondsToSelector:@selector(objectID)]) {
                        NSManagedObjectContext *ctx = [NSManagedObjectContext MR_defaultContext];
                        NSManagedObject <JSONParsable> *originalObject = (NSManagedObject <JSONParsable> *)[ctx objectWithID:request.objectID];
                        [originalObject updateWithJSONDictionary:responseObject inContext:ctx];
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
        
    };
    void(^wrappedFailure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion();
        }
        DLog(@"Finished fetch from %@%@. Error: %@", self.manager.baseURL, request.path, error);
        
        if (failure) {
            failure(operation, error);
        }
    };
    
    [operation setCompletionBlockWithSuccess:wrappedSuccess failure:wrappedFailure];
    [self.manager.operationQueue addOperation:operation];
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
