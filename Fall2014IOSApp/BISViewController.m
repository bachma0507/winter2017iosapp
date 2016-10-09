//
//  BISViewController.m
//  Winter2017IOSAppNew
//
//  Created by Barry on 10/6/16.
//  Copyright © 2016 BICSI. All rights reserved.
//

#import "BISViewController.h"

@implementation BISViewController

@synthesize webView;
@synthesize back;
//@synthesize activity;
//@synthesize adImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    
    //NSString *httpSource = @"https://speedyreference.com/bicsi2.html";
    NSString *httpSource = @"https://www.speedyreference.com/nppredirect.html";
    NSURL *fullUrl = [NSURL URLWithString:httpSource];
    NSURLRequest *httpRequest = [NSURLRequest requestWithURL:fullUrl];
    [webView loadRequest:httpRequest];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UIWebViewDelegate methods
//only used here to enable or disable the back and forward buttons
- (void)webViewDidStartLoad:(UIWebView *)thisWebView
{
    //	back.enabled = NO;
    back.enabled = NO;
    //[activity startAnimating];
    //
}
//
- (void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
    //[activity stopAnimating];
    //    activity.hidden = TRUE;
    //
    //	if(thisWebView.canGoBack == YES)
    //	{
    //		back.enabled = YES;
    //		back.highlighted = YES;
    //	}
    
    if (thisWebView.canGoBack == YES) {
        back.enabled = YES;
        back.highlighted = YES;
    }
}


@end
