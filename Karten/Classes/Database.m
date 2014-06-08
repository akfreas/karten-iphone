#import "Database.h"
#import "Stack.h"
#import "Stack+Helpers.h"
#import "StackServer.h"


@interface Database ()
@end

@implementation Database

- (id)initWithStack:(Stack *)stack
{
    self = [super init];
    if (self) {
        self.stack = stack;
        [self setup];
    }
    return self;
}

- (NSUInteger)hash
{
    return [self.stack.objectID hash];
}

-(void)setup {
    
    
    NSString *pushAndPullURLString = [self.stack fullServerURL] ;
    NSError *err = nil;
    self.couchDatabase = [[CBLManager sharedInstance] databaseNamed:self.stack.serverStackName error:&err];
    if (err != nil) {
        NSLog(@"Couldn't connect to DB! %@", err);
    }
    [[self.couchDatabase viewNamed:@"byDate"] setMapBlock:MAPBLOCK({
        id date = doc[@"created_at"];
        if (date) {
            emit(date, doc);
        }
    }) reduceBlock:nil version:@"1.0"];
    
//    [[self.database viewNamed:@"search"] setMapBlock:MAPBLOCK({
//        id
//    }) reduceBlock:REDUCEBLOCK({}) version:@"1.0"];
//    
    self.pullReplication = [self.couchDatabase createPullReplication:[NSURL URLWithString:pushAndPullURLString]];
    self.pushReplication = [self.couchDatabase createPushReplication:[NSURL URLWithString:pushAndPullURLString]];
    self.pushReplication.continuous = self.pullReplication.continuous = YES;
}

- (void)startSyncing
{
    [self.pullReplication start];
    [self.pushReplication start];
}

@end
