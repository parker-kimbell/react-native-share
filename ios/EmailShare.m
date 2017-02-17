//
//  EmailShare.m
//  RNShare
//
//  Created by Diseño Uno BBCL on 23-07-16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "EmailShare.h"

@interface EmailShare () <MFMailComposeViewControllerDelegate>

@end

@implementation EmailShare

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [ctrl dismissViewControllerAnimated:YES completion:NULL];
}

- (void) viewDidLoad {
    [super viewDidLoad];
}


- (void)shareSingle:(NSDictionary *)options
    failureCallback:(RCTResponseErrorBlock)failureCallback
    successCallback:(RCTResponseSenderBlock)successCallback {

    NSLog(@"Try open view");

    // Documentation: https://developer.apple.com/reference/messageui/mfmailcomposeviewcontroller?language=objc
    if (![MFMailComposeViewController canSendMail]) { // Case: the user doesn't have their mail setup
        //This should have already been checked by the calling app, so currently we pretty much just fail silently
        NSLog(@"Mail services are not available.");
        return;
    }

    NSString *subject = @"";
    NSString *message = @"";
    NSString *mimeType= @"";
    NSString *attachmentFileName = @"";
    NSURL *url;

    // Extract data from react arguments
    if ([options objectForKey:@"subject"] && [options objectForKey:@"subject"] != [NSNull null]) {
        subject = [RCTConvert NSString:options[@"subject"]];
    }

    if ([options objectForKey:@"message"] && [options objectForKey:@"message"] != [NSNull null]) {
        message = [RCTConvert NSString:options[@"message"]];
    }

    if ([options objectForKey:@"url"] && [options objectForKey:@"url"] != [NSNull null]) {
        url = [RCTConvert NSURL:options[@"url"]];
    }

    if ([options objectForKey:@"type"] && [options objectForKey:@"type"] != [NSNull null]) {
        mimeType = [RCTConvert NSString:options[@"type"]];
    }

    if ([options objectForKey:@"attachmentName"] && [options objectForKey:@"attachmentName"] != [NSNull null]) {
        // Super brittle right now. Only accepting png and pdf mime types
        attachmentFileName = [RCTConvert NSString:options[@"attachmentName"]];
        if ([mimeType isEqualToString:@"image/png"]) {
            attachmentFileName = [attachmentFileName stringByAppendingString:@".png"];
        } else if ([mimeType isEqualToString:@"application/pdf"]) {
            attachmentFileName = [attachmentFileName stringByAppendingString:@".pdf"];
        }
    }

    MFMailComposeViewController* email = [[MFMailComposeViewController alloc] init];
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    email.mailComposeDelegate = self;

    // Attach an image to the email
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url
                                         options:(NSDataReadingOptions)0
                                           error:&error];
    if (!data) {
        failureCallback(error);
        return;
    }
    [email addAttachmentData:data mimeType:mimeType fileName:attachmentFileName];

    // // Configure the email fields
    [email setSubject:subject];
    [email setMessageBody:message isHTML:YES]; // Assuming that there is HTML in the body. Can't see a reason not to.
    //
    // // Present the view controller modally.
    //[self presentViewController:email animated:YES completion:Nil];
    [self presentViewController:email animated:YES completion:Nil];
    successCallback(@[]);
}

@end
