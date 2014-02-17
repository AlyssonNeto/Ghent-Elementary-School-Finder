//
//  APPSchoolCell.h
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPSchoolCell.h"

@interface APPSchoolCell()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UIImageView *veganImageView;
@property (strong, nonatomic) NSDictionary *valuesDict;

@end

@implementation APPSchoolCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = CELL_BACKGROUND;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CENTER_IN_PARENT_Y(self, 20), WIDTH(self) - 95, 20)];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.highlightedTextColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:AVENIR_ROMAN size:16];
        [self.contentView addSubview:self.titleLabel];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(RIGHT(self) - 85, CENTER_IN_PARENT_Y(self, 16), 50, 16)];
        self.distanceLabel.textColor = CELL_DETAIL_TEXTCOLOR;
        self.distanceLabel.highlightedTextColor = [UIColor whiteColor];
        
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        self.distanceLabel.font = [UIFont fontWithName:AVENIR_ROMAN size:16];
        [self.contentView addSubview:self.distanceLabel];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *backView = [[UIView alloc] initWithFrame:self.frame];
        backView.backgroundColor = [UIColor darkGrayColor];
        self.selectedBackgroundView = backView;
    }
    return self;
}

-(void)setValues:(NSDictionary *)values {
    
    self.valuesDict = values;
    
    if ([self.valuesDict valueForKey:@"naam"]) {
        [self.titleLabel setText:[values objectForKey:@"naam"]];
    }
    else {
        [self.titleLabel setText:[values objectForKey:@"roepnaam"]];
    }
    
    if ([[values objectForKey:@"distance"] intValue] == 0) {
        [self.distanceLabel setText:@""];
    }
    else {
        [self.distanceLabel setText:[self getDistanceToSchool]];
    }
}

-(NSString *)getDistanceToSchool {
    NSString *distance;
    
    if ([self.valuesDict objectForKey:@"distance"] && [[self.valuesDict objectForKey:@"distance"] intValue] < 100000 && [[self.valuesDict objectForKey:@"distance"] intValue] > 0) {
        if ([[self.valuesDict objectForKey:@"distance"] intValue] < 1000) {
            distance = [NSString stringWithFormat:@"%dm", [[self.valuesDict objectForKey:@"distance"] intValue]];
        }
        else {
            distance = [NSString stringWithFormat:@"%dkm", ([[self.valuesDict objectForKey:@"distance"] intValue] / 1000)];
        }
    }
    return distance;
}

@end
