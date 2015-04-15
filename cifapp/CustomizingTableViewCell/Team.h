//
//  Movie.h
//  CustomizingTableViewCell
//
//  Created by Arthur Knopper on 1/2/13.
//  Copyright (c) 2013 Arthur Knopper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (assign) NSInteger id;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic) NSInteger goals;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *teamId;
@property (nonatomic) NSInteger penaltis;

@end
