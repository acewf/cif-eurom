//
//  GamesResultControlerViewController.h
//  Cif
//
//  Created by Pedro Martins on 30/03/15.
//  Copyright (c) 2015 pixelkiller.net . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface appTeamDisciplina : UIViewController <UITableViewDelegate, UITableViewDataSource,UINavigationBarDelegate,UINavigationControllerDelegate>


@property (nonatomic,strong) NSMutableArray *listDisciplina;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationbaritem;
@property (strong, nonatomic) IBOutlet UITableView *tableDisciplina;

@end
