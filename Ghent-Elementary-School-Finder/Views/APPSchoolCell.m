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
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.highlightedTextColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 100, 20)];
        [self.distanceLabel setFont:[UIFont systemFontOfSize:12]];
        self.distanceLabel.textColor = [UIColor lightGrayColor];
        self.distanceLabel.highlightedTextColor = [UIColor whiteColor];
        self.distanceLabel.backgroundColor = [UIColor clearColor];
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
        self.titleLabel.frame = CGRectMake(15, 0, 210, 45);
        [self.distanceLabel setText:@""];
    }
    else {
        self.titleLabel.frame = CGRectMake(15, 5, 210, 45);
        [self.titleLabel sizeToFit];
        CGRect frame = self.titleLabel.frame;
        frame.size.width = 210;
        self.titleLabel.frame = frame;
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
