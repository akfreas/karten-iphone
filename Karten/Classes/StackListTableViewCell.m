#import "StackListTableViewCell.h"
#import "KTStack.h"

@implementation StackListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setStack:(KTStack *)stack
{
    _stack = stack;
    self.textLabel.text = stack.name;
}

@end
