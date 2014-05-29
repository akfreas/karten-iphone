#import <XCTest/XCTest.h>
#import "User.h"
#import "User+Helpers.h"
#import "KTAPICreateUser.h"

@interface KartenUserTests : XCTestCase

@end

@implementation KartenUserTests

- (void)setUp
{
    [super setUp];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateUserFromJSON
{
    NSDictionary *userDict = JSONFromFile(@"UserListFetch")[10];
    User *newUser = [User objectWithJSONDictionary:userDict];
    XCTAssertTrue([newUser.serverID isEqualToNumber:userDict[@"id"]]);
    XCTAssertTrue([newUser.firstName isEqualToString:userDict[@"first_name"]], @"First name is not correct! %@ != %@", newUser.firstName, userDict[@"first_name"]);
    XCTAssertTrue([newUser.lastName isEqualToString:userDict[@"last_name"]], @"Last name is not correct!");
    XCTAssertTrue([newUser.externalService isEqualToString:userDict[@"external_service"]]);
    XCTAssertTrue([newUser.externalUserID isEqualToString:userDict[@"external_user_id"]]);
    
    NSDictionary *serialized = [newUser JSONDictionarySerialization];
    NSArray *serializedKeys = [serialized allKeys];
    for (NSString *key in serializedKeys) {
        XCTAssertTrue([serialized[key] isEqual:userDict[key]], @"");
    }
}

- (void)testAddUserFriendFromJSON
{
    NSInteger numberOfUsers = 10;
    NSArray *friends = [JSONFromFile(@"UserListFetch") subarrayWithRange:NSMakeRange(0, numberOfUsers)];
    NSMutableArray *friendArray = [NSMutableArray array];
    for (NSDictionary *friend in friends) {
        User *newUser = [User objectWithJSONDictionary:friend];
        [newUser.managedObjectContext MR_saveOnlySelfAndWait];
        [friendArray addObject:newUser];
    }
    NSString *mainID = [[friends firstObject] objectForKey:@"id"];
    User *mainUser = [friendArray firstObject];
    [friendArray removeObjectAtIndex:0];
    for (User *friend in friendArray) {
        [mainUser addFriendsObject:friend];
    }
    [mainUser.managedObjectContext MR_saveOnlySelfAndWait];
    
    User *userFromDB = [User MR_findFirstByAttribute:@"serverID" withValue:mainID];
    XCTAssertNotNil(userFromDB, @"User from db was nil!");
    NSSet *friendsFromDB = userFromDB.friends;
    XCTAssertEqual([friendsFromDB count], numberOfUsers - 1);

}

@end
