//
//  WebsiteViewController.m
//  Barteguiden
//
//  Created by Christian Rasmussen on 09.05.13.
//  Copyright (c) 2013 Under Dusken. All rights reserved.
//

#import "WebsiteViewController.h"
#import <PSPDFActionSheet.h>
#import <PSPDFAlertView.h>


static CGFloat kRefreshBarButtonItemWidth = 18;


@interface WebsiteViewController ()

@property (nonatomic, strong) UIBarButtonItem *activityIndicatorViewBarButtonItem;
@property (nonatomic) BOOL lastLoading;

@end


@implementation WebsiteViewController

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
    
    [self updateBackAndForwardButtons];
    
    self.webView.scalesPageToFit = YES;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.openURL];
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (void)back:(id)sender
{
    [self.webView goBack];
}

- (void)forward:(id)sender
{
    [self.webView goForward];
}

- (void)refresh:(id)sender
{
    [self.webView loadRequest:self.webView.request];
}

- (void)share:(id)sender
{
    NSString *openInSafariTitle = NSLocalizedStringWithDefaultValue(@"WEBSITE_OPEN_IN_SAFARI_BUTTON", nil, [NSBundle mainBundle], @"Open in Safari", @"Title of button to open website in Safari in alert sheet (Displayed when browsing the event's website)");
    NSString *copyLinkTitle = NSLocalizedStringWithDefaultValue(@"WEBSITE_COPY_LINK_BUTTON", nil, [NSBundle mainBundle], @"Copy Link", @"Title of button to copy link to website in alert sheet (Displayed when browsing the event's website)");
    NSString *cancelTitle = NSLocalizedStringWithDefaultValue(@"WEBSITE_CANCEL_BUTTON", nil, [NSBundle mainBundle], @"Cancel", @"Title of cancel button in alert sheet (Displayed when browsing the event's website)");
    PSPDFActionSheet *shareActionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];
    [shareActionSheet addButtonWithTitle:openInSafariTitle block:^{
        [[UIApplication sharedApplication] openURL:self.webView.request.URL];
    }];
    [shareActionSheet addButtonWithTitle:copyLinkTitle block:^{
        [[UIPasteboard generalPasteboard] setURL:self.webView.request.URL];
    }];
    [shareActionSheet setCancelButtonWithTitle:cancelTitle block:NULL];
    [shareActionSheet showWithSender:sender fallbackView:self.view animated:YES];
}


#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString *title = NSLocalizedStringWithDefaultValue(@"WEBSITE_CANNOT_OPEN_PAGE_TITLE", nil, [NSBundle mainBundle], @"Cannot Open Page", @"Title of alert view (Displayed when browser failed to load)");
    NSString *message = NSLocalizedStringWithDefaultValue(@"WEBSITE_CANNOT_OPEN_PAGE_MESSAGE", nil, [NSBundle mainBundle], @"Safari cannot open the page because the address is invalid", @"Message of alert view (Displayed when browser failed to load)");
    NSString *cancelButtonTitle = NSLocalizedStringWithDefaultValue(@"WEBSITE_CANNOT_OPEN_PAGE_CANCEL_BUTTON", nil, [NSBundle mainBundle], @"OK", @"Title of cancel button in alert view (Displayed when browser failed to load)");
    PSPDFAlertView *failedAlertView = [[PSPDFAlertView alloc] initWithTitle:title message:message];
    [failedAlertView setCancelButtonWithTitle:cancelButtonTitle block:NULL];
    [failedAlertView show];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateRefreshButton];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateBackAndForwardButtons];
    [self updateRefreshButton];
}


#pragma mark - Private methods

- (void)updateBackAndForwardButtons
{
    self.backBarButtonItem.enabled = self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.webView.canGoForward;
}

- (void)updateRefreshButton
{
    UIBarButtonItem *currentBarButtonItem = nil;
    UIBarButtonItem *replacementBarButtonItem = nil;
    if (self.webView.loading == YES && self.lastLoading == NO) {
        currentBarButtonItem = self.refreshBarButtonItem;
        replacementBarButtonItem = self.activityIndicatorViewBarButtonItem;
        
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    else if (self.webView.loading == NO && self.lastLoading == YES) {
        currentBarButtonItem = self.activityIndicatorViewBarButtonItem;
        replacementBarButtonItem = self.refreshBarButtonItem;
    }
    else {
        return;
    }
    
    NSMutableArray *items = [self.toolbar.items mutableCopy];
    NSUInteger currentIndex = [items indexOfObject:currentBarButtonItem];
    [items replaceObjectAtIndex:currentIndex withObject:replacementBarButtonItem];
    self.toolbar.items = [items copy];
//    self.refreshBarButtonItem = (self.webView.loading == YES) ? self.activityIndicatorViewBarButtonItem : self.originalRefreshBarButtonItem;
    
    self.lastLoading = self.webView.loading;
}

- (UIBarButtonItem *)activityIndicatorViewBarButtonItem
{
    static UIBarButtonItem *barButtonItem = nil;
    if (barButtonItem == nil) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        activityIndicatorView.color = [UIColor grayColor];
        [activityIndicatorView sizeToFit];
        [activityIndicatorView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [activityIndicatorView startAnimating];
        
        barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
        barButtonItem.width = kRefreshBarButtonItemWidth;
    }
    
    return barButtonItem;
}

@end
