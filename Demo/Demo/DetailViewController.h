//
//  DetailViewController.h
//  Demo
//
//  Created by Mao Nishi on 2014/05/06.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, copy) NSString *requestNumberText;
@end
