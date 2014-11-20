#import "NSDateFormatter+ServerFormatters.h"

@implementation NSDateFormatter (ServerFormatters)

+ (NSDateFormatter *)serverFormatter
{
    static NSDateFormatter *formatter;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    }
    return formatter;
}
@end
