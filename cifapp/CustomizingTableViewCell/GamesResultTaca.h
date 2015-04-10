//
//  GamesResultControlerViewController.h
//  Cif
//
//  Created by Pedro Martins on 30/03/15.
//  Copyright (c) 2015 pixelkiller.net . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamesResultTaca : UIViewController <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationbaritem;
@property (nonatomic,strong) NSMutableArray *daysList;
@property (nonatomic,strong) NSMutableArray *weekDays;
@property (nonatomic,strong) NSMutableArray *MonthNames;


@property (nonatomic,strong) NSMutableArray *imgsData;
@property (nonatomic,strong) NSMutableArray *listCupGames;
@property (nonatomic,strong) NSMutableArray *listaData;
@property (strong, nonatomic) IBOutlet UITableView *tableGames;

@end
