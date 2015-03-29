//
//  MovieCell.h
//  CustomizingTableViewCell
//
//  Created by Arthur Knopper on 1/2/13.
//  Copyright (c) 2013 Arthur Knopper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goalsteam1;
@property (weak, nonatomic) IBOutlet UILabel *schedule;
@property (weak, nonatomic) IBOutlet UILabel *goalsteam2;
@property (weak, nonatomic) IBOutlet UILabel *team2;
@property (weak, nonatomic) IBOutlet UILabel *team1;
@property (weak, nonatomic) IBOutlet UIImageView *imgteam1;
@property (weak, nonatomic) IBOutlet UIImageView *imgteam2;

@end