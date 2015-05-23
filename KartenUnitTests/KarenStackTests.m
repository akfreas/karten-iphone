#import <XCTest/XCTest.h>
#import "KTStack.h"
#import "Stack+Helpers.h"
#import "StackServer+Helpers.h"
#import "StackServer.h"
#import "KTUser.h"
#import "User+Helpers.h"
@interface KarenStackTests : XCTestCase

@end

@implementation KarenStackTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddStackFromJSON
{
    NSDictionary *stackDict = JSONFromFile(@"CreateDatabaseData");
    KTStack *newStack = [KTStack objectWithJSONDictionary:stackDict];
    XCTAssertNotNil(newStack, @"New stack is nil!");
    XCTAssertTrue([newStack.name isEqualToString:stackDict[@"name"]], @"");
    XCTAssertTrue([newStack.stackDescription isEqualToString:stackDict[@"description"]], @"%@ != %@", newStack.stackDescription, stackDict[@"description"]);
    XCTAssertTrue([newStack.serverStackName isEqualToString:stackDict[@"couchdb_name"]], @"");
    XCTAssertTrue([newStack.serverID isEqualToNumber:stackDict[@"id"]], @"");
    XCTAssertTrue([newStack.server.serverURL isEqualToString:stackDict[@"couchdb_server"][@"server_url"]], @"%@ != %@", newStack.server.serverURL, stackDict[@"couchdb_server"][@"server_url"]);
    XCTAssertTrue([newStack.server.serverID isEqualToNumber:stackDict[@"couchdb_server"][@"id"]], @"");
    XCTAssertTrue([newStack.owner.firstName isEqualToString:stackDict[@"owner"][@"first_name"]], @"");
    XCTAssertTrue([newStack.owner.lastName isEqualToString:stackDict[@"owner"][@"last_name"]], @"");
}
@end
