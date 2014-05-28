@protocol KartenAPICall <NSObject>

@required

@property (nonatomic, readonly) NSString *path;

@optional

@property (nonatomic, readonly) Class classToParse;
@property (nonatomic, readonly) NSDictionary *params;

@end
