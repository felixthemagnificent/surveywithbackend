//
//  RadioCell.m
//  customtableview
//
//  Created by Felix on 8/28/14.
//  Copyright (c) 2014 Felix. All rights reserved.
//

#import "RadioCell.h"

@implementation RadioCell
{
    
}
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
