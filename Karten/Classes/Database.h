@interface Database : NSObject

+(instancetype)sharedInstance;
+(CBLDatabase *)sharedDB;
+(void)setupDB;
@property (strong) CBLDatabase *database;

@end
