//
//  StrikerCell.h
//  Cif
//
//  Created by Rodrigo Amado on 01/04/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StrikerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *playerName;
@property (strong, nonatomic) IBOutlet UILabel *playerPosition;
@property (strong, nonatomic) IBOutlet UILabel *teamName;
@property (strong, nonatomic) IBOutlet UILabel *playerGoals;

@end
