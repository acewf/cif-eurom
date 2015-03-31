//
//  GamesResultControlerViewController.h
//  Cif
//
//  Created by Rodrigo Amado on 30/03/15.
//  Copyright (c) 2015 Arthur Knopper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamesResultControlerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,UINavigationBarDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *pickerview;
- (IBAction)tooglejornada:(id)sender;

@property (nonatomic,strong) NSMutableArray *listGames;
@property (nonatomic,strong) NSArray *pickerData;

@property  (nonatomic) BOOL jornyePickerOpen;
@property (strong, nonatomic) IBOutlet UIView *GamesList;
@property (strong, nonatomic) IBOutlet UITableView *tableGames;
@end
