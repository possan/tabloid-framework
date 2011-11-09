//
//  ViewController.m
//  tidningstest1
//
//  Created by Per-Olov Jernberg on 2011-11-08.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "WebViewMod.h"

@implementation ViewController
{
    UIScrollView *s1;
    UIScrollView *s2;
    UIScrollView *s3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) createWebViewAtRow:(int)row withFilename:(NSString *)filename inView:(UIView*)parent {
    
    CGRect r = CGRectMake(0,1024*row,768,1024);
/*    UIView *v = [[UIView alloc] initWithFrame:r];
    [v setBackgroundColor:[UIColor colorWithHue:(float)(rand()%100) / 100.0f
                                     saturation:1.0f
                                     brightness:0.5f 
                                          alpha:1.0f]];
     [parent addSubview:v];
*/
    WebViewMod *b1 = [[WebViewMod alloc] initWithFrame:r];
    for (id subview in b1.subviews)
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]){
            ((UIScrollView *)subview).bounces = NO;
            ((UIScrollView *)subview).scrollEnabled = NO;
            ((UIScrollView *)subview).scrollsToTop = NO;
            ((UIScrollView *)subview).delaysContentTouches = TRUE;
        }
    [parent addSubview:b1];
    [b1 setUserInteractionEnabled:TRUE];    
    [b1 loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:@"html"] isDirectory:NO]]];         
    [b1 resignFirstResponder];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.

    s1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,768,1024)];
    s1.contentSize = CGSizeMake(768*2,1024);
    s1.contentOffset = CGPointMake(0,0);
    s1.delaysContentTouches = TRUE;
    s1.scrollEnabled = TRUE;
    s1.delegate = self;
    s1.pagingEnabled = TRUE;
    
    s2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,768,1024)];
    s2.contentSize = CGSizeMake(768,1024*4);
    s2.contentOffset = CGPointMake(0,0);
    s2.delaysContentTouches = TRUE;
    s2.scrollEnabled = TRUE;
    s2.pagingEnabled = TRUE;
    [self createWebViewAtRow:0 withFilename:@"test1" inView:s2];
    [self createWebViewAtRow:1 withFilename:@"test2" inView:s2];
    [self createWebViewAtRow:2 withFilename:@"test3" inView:s2];
    [self createWebViewAtRow:3 withFilename:@"test4" inView:s2];
    [s2 resignFirstResponder];
    [s1 addSubview:s2];
//    [self.view addSubview:s2];
  //  [s2 becomeFirstResponder];

    s3 = [[UIScrollView alloc] initWithFrame:CGRectMake(768,0,768,1024)];
    s3.contentSize = CGSizeMake(768,1024*3);
    s3.contentOffset = CGPointMake(0,0);
    s3.delaysContentTouches = TRUE;
    s3.scrollEnabled = TRUE;
    s3.pagingEnabled = TRUE;
    [self createWebViewAtRow:0 withFilename:@"test5" inView:s3];
    [self createWebViewAtRow:1 withFilename:@"test6" inView:s3];
    [self createWebViewAtRow:2 withFilename:@"test7" inView:s3];
    [s3 resignFirstResponder];
    [s1 addSubview:s3];

    [self.view addSubview:s1];
    [s1 becomeFirstResponder];
    
    [self scrollViewDidEndDecelerating:s1];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)homeOrResetVertical:(UIScrollView*)view forX:(int)x {
    
    if( (int)s1.contentOffset.x != x )           
        view.contentOffset = CGPointMake(0,0);
    else
        for (id subview in view.subviews)
            if ([[subview class] isSubclassOfClass: [UIWebView class]]){
                [((UIWebView *)subview) stringByEvaluatingJavaScriptFromString:@"pageReset();"];
            }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    // top all pages but the current one
    // and restart the current page...
    
    if( scrollView != s1 )
        return;
    
    [self homeOrResetVertical:s2 forX:0];
    [self homeOrResetVertical:s3 forX:768];
}

@end
