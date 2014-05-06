MAOFlipViewController
=====================

This is the OSS that provide interacition transition like FlipBoard.

Podfile is below.
```
platform :ios, '7.0'
pod 'MAOFlipViewController', :git => "https://github.com/nishimao/MAOFlipViewController.git"
```

Please import "MAOFlipViewController.h" only.
```
#import "MAOFlipViewController.h"
```

Please addSubview "MAOFlipViewController's instance"
Example below.
```
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
```
Please implements delegate method.
Example below.
```

#pragma mark - MAOFlipViewControllerDelegate

- (UIViewController*)flipViewController:(MAOFlipViewController *)flipViewController contentIndex:(NSUInteger)contentIndex
{
    //êVãKçÏê¨
    DetailViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    c.requestNumberText = [NSString stringWithFormat:@"%d", contentIndex];
    return c;
}

- (NSUInteger)numberOfFlipViewControllerContents
{
    return 5;
}
```
