

@interface FormEntryTableViewCell : UITableViewCell
@property (nonatomic) BOOL textFieldSecured;
@property (nonatomic) NSString *text;

- (void)reset;
- (void)setTitleText:(NSString *)titleText;
@end
