//
//  ViewController.m
//  MHZImageBrowser
//
//  Created by muhuai on 4/16/16.
//  Copyright © 2016 MuHuai. All rights reserved.
//

#import "ViewController.h"
#import "MHZImageBrowser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 0, 0)];
    label.text = @"hello world";
    [label sizeToFit];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
    [label addGestureRecognizer:gesture];
    label.userInteractionEnabled = YES;
    [self.view addSubview:label];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClick:(id)sender {
    NSArray *images = @[[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"4.jpg"],[UIImage imageNamed:@"5.jpg"],[UIImage imageNamed:@"6.jpg"]];
    MHZImageBrowser *browser = [[MHZImageBrowser alloc] init];
    [browser showImages:images];
}
@end
