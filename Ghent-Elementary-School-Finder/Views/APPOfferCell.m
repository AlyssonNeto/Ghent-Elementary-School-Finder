//
//  APPOfferCell.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 18/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPOfferCell.h"

@implementation APPOfferCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(10, 0, 320, 20);
}

@end
