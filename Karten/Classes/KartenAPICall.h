@protocol KartenAPICall <NSObject>

@required

@property (nonatomic, readonly) NSString *path;

@optional

@property (nonatomic, readonly) Class classToParse;
@property (nonatomic, readonly) NSDictionary *params;
@property (nonatomic, readonly) BOOL updateOriginalObjectOnReturn;
@property (nonatomic, readonly) NSManagedObjectID *objectID;
@property (nonatomic) NSString *HTTPMethod;
@end
