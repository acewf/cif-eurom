//
//  ResultBoard.h
//  Cif
//
//  Created by Rodrigo Amado on 01/04/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultBoard : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *teamName;
@property (strong, nonatomic) IBOutlet UILabel *teamPoints;
@property (strong, nonatomic) IBOutlet UILabel *teamTotalGames;
@property (strong, nonatomic) IBOutlet UILabel *teamWins;
@property (strong, nonatomic) IBOutlet UILabel *teamDraws;
@property (strong, nonatomic) IBOutlet UILabel *teamLoses;
@property (strong, nonatomic) IBOutlet UILabel *teamPosition;
@property (strong, nonatomic) IBOutlet UILabel *lastupdate;

@end
