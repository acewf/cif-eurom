//
//  GamesResultControlerViewController.h
//  Cif
//
//  Created by Pedro Martins on 30/03/15.
//  Copyright (c) 2015 pixelkiller.net . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppBestStrikers : UIViewController <UITableViewDelegate, UITableViewDataSource,UINavigationBarDelegate,UINavigationControllerDelegate>


@property (nonatomic,strong) NSMutableArray *listStrikers;
@property (strong, nonatomic) IBOutlet UITableView *tableStrikers;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationbaritem;

@end
