//
//  GamesResultControlerViewController.h
//  Cif
//
//  Created by Pedro Martins on 30/03/15.
//  Copyright (c) 2015 pixelkiller.net . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamesResultControlerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationBarDelegate,UINavigationControllerDelegate>
- (IBAction)tooglejornada:(id)sender;
-(void)jorneyPushed;

@property (strong, nonatomic) IBOutlet UINavigationItem *navigationbaritem;
@property (strong, nonatomic) IBOutlet UICollectionView *jorneySelector;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *openjorney;

@property (nonatomic,strong) NSMutableArray *daysList;
@property (nonatomic,strong) NSMutableArray *weekDays;
@property (nonatomic,strong) NSMutableArray *MonthNames;

@property (nonatomic,strong) NSMutableArray *imgsData;
@property (nonatomic,strong) NSMutableArray *listGames;
@property (nonatomic,strong) NSArray *pickerData;
@property (nonatomic,strong) NSMutableArray *listaData;

@property  (nonatomic) BOOL jornyePickerOpen;
@property (strong, nonatomic) IBOutlet UITableView *tableGames;

@end
