//
//  ViewController.m
//  CoreImageFun
//
//  Created by Ray Wenderlich on 9/20/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "ViewController.h"
#import "MZBlurredParallax.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate>
{
    MZBlurredParallax* parallax;
}
@end

@implementation ViewController {
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //sort of IoC, you don't need to add your scrollview to view, just add parallax
    parallax=[[MZBlurredParallax alloc] initWithScrollView:self.scrollView background:[UIImage imageNamed:@"gdansk.jpg"]];
    //forwards UIScrollViewDelegate methods
    [parallax setDelegate:self];
    
    [self.view addSubview:parallax];
    [self.scrollView setContentSize:CGSizeMake(320, 506+400)];
}


@end
