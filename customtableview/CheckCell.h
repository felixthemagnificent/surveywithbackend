@class CheckCell;
@protocol CheckBtn <NSObject>
-(void)checkBtn:(CheckCell*)cell andBtn:(UIButton*)btn;
@end

@interface CheckCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UILabel *checkLabel;
@property (nonatomic,weak) id<CheckBtn> delegate;
@end
NSInteger checkSelected;