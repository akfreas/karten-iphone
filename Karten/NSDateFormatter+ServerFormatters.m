#import "NSDateFormatter+ServerFormatters.h"

@implementation NSDateFormatter (ServerFormatters)

+ (NSDateFormatter *)serverFormatter
{
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return formatter;
}
@end
