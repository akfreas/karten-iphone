#import "Database.h"


@implementation Database

+(CBLDatabase *)sharedDB {
    return [[self sharedInstance] database];
}

+(instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    if (sharedInstance == nil) {
        dispatch_once(&onceToken, ^{
                sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

+(void)setupDB {
    [[self sharedInstance] setup];
}

-(void)setup {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pushAndPullURLString = @"http://sync.couchbasecloud.com/krtncb2/";
    NSDictionary *appDefaults = @{@"syncpoint": pushAndPullURLString};
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    NSError *err = nil;
    self.database = [[CBLManager sharedInstance] databaseNamed:@"karten" error:&err];
    if (err != nil) {
        NSLog(@"Couldn't connect to DB! %@", err);
    }
    [[self.database viewNamed:@"byDate"] setMapBlock:MAPBLOCK({
        id date = doc[@"created_at"];
        if (date) {
            emit(date, doc);
        }
    }) reduceBlock:nil version:@"1.0"];
    
//    [[self.database viewNamed:@"search"] setMapBlock:MAPBLOCK({
//        id
//    }) reduceBlock:REDUCEBLOCK({}) version:@"1.0"];
//    
    [self.database createPullReplication:[NSURL URLWithString:pushAndPullURLString]];
    [self.database createPushReplication:[NSURL URLWithString:pushAndPullURLString]];
}

@end
