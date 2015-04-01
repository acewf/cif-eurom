//
//  RenderClassificacaoTableViewController.h
//  Cif
//
//  Created by Pedro Martins on 27/03/15.
//  Copyright (c) 2015 pixelkiller.net . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenderClassificacaoTableViewController :  UIViewController <UITableViewDelegate, UITableViewDataSource,UINavigationBarDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) NSMutableArray *listResults;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationbaritem;
@property (strong, nonatomic) IBOutlet UITableView *tableResultBoard;

@end
