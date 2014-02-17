//
//  APPSchoolCategoryButton.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 11/02/14.
//  Copyright (c) 2014 Appreciate. All rights reserved.
//

#import "APPSchoolCategoryButton.h"

@implementation APPSchoolCategoryButton

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andImage:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:BLACK_TYPO forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 20.0f)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 10.0f, 0.0f, 0.0f)];
        self.titleLabel.font = [UIFont fontWithName:AVENIR_ROMAN size:16];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
