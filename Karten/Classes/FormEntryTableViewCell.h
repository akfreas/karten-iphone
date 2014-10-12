

@interface FormEntryTableViewCell : UITableViewCell
@property (nonatomic) BOOL textFieldSecured;
@property (nonatomic) UITextAutocapitalizationType capitalizationType;
@property (nonatomic) NSString *text;
@property (nonatomic, copy) void(^returnButtonBlock)();
- (void)reset;
- (void)setTitleText:(NSString *)titleText;
@end
