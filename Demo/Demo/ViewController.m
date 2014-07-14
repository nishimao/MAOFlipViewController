//
//  ViewController.m
//  Demo
//
//  Created by Mao Nishi on 2014/05/06.
//  Copyright (c) 2014年 Mao Nishi. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "MAOFlipViewController.h"

@interface ViewController ()<MAOFlipViewControllerDelegate>
@property (nonatomic) MAOFlipViewController *flipViewController;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.flipViewController = [[MAOFlipViewController alloc]init];
    self.flipViewController.delegate = self;
    [self addChildViewController:self.flipViewController];
    self.flipViewController.view.frame = self.view.frame;
    [self.view addSubview:self.flipViewController.view];
    [self.flipViewController didMoveToParentViewController:self];
}

#pragma mark - MAOFlipViewControllerDelegate

- (UIViewController*)flipViewController:(MAOFlipViewController *)flipViewController contentIndex:(NSUInteger)contentIndex
{
    //新規作成
    DetailViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    c.requestNumberText = [NSString stringWithFormat:@"%lu", (unsigned long)contentIndex];
    return c;
}

- (NSUInteger)numberOfFlipViewControllerContents
{
    return 5;
}



@end
