//
//  CheckCell.m
//  customtableview
//
//  Created by Felix on 8/28/14.
//  Copyright (c) 2014 Felix. All rights reserved.
//

#import "CheckCell.h"
#import "ViewController.h"
@implementation CheckCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
- (IBAction)processCheck:(id)sender
{
    
    UIButton *checkButton = sender;
//    NSLog(@"%d",checkButton.tag);
//    if (!checkButton.selected)
//        checkSelected = checkSelected + checkButton.tag;
//    else
//        checkSelected -= checkButton.tag;
//
    checkButton.selected?[checkButton setSelected:NO]:[checkButton setSelected:YES];
    
    [self.delegate checkBtn:self andBtn:sender];

}

//- (IBAction)processCheck:(id)sender {
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
