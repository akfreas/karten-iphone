#import "TestUtils.h"

id JSONFromFile(NSString *file) {
    id retval = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:@"json"]] options:0 error:NULL];
    return retval;
}