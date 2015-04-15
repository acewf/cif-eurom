//
//  TeamDisciplina.h
//  Cif
//
//  Created by Rodrigo Amado on 01/04/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamDisciplina : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *position;
@property (strong, nonatomic) IBOutlet UILabel *teamName;
@property (strong, nonatomic) IBOutlet UILabel *amarelos;
@property (strong, nonatomic) IBOutlet UILabel *vermelhos;
@property (strong, nonatomic) IBOutlet UILabel *points;
@property (strong, nonatomic) IBOutlet UILabel *lastupdate;

@end
