//
//  FacebookShare.m
//  RNShare
//
//  Created by Diseño Uno BBCL on 23-07-16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "LinkedInShare.h"

@implementation LinkedInShare
- (void)shareSingle:(NSDictionary *)options
    failureCallback:(RCTResponseErrorBlock)failureCallback
    successCallback:(RCTResponseSenderBlock)successCallback {

    NSLog(@"Try open view");

    if ([options objectForKey:@"message"] && [options objectForKey:@"message"] != [NSNull null]) {
        NSString *text = [RCTConvert NSString:options[@"message"]];
        NSString * urlLinkedIn = [NSString stringWithFormat:@"linkedin://"];
        NSURL * linkedInURL = [NSURL URLWithString:[urlLinkedIn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        if ([[UIApplication sharedApplication] canOpenURL: linkedInURL]) {
            [[UIApplication sharedApplication] openURL: linkedInURL];
            successCallback(@[]);
        } else {
          // Cannot open LinkedIn

          NSString *errorMessage = @"Cannot open LinkedIn";
          NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedString(errorMessage, nil)};
          NSError *error = [NSError errorWithDomain:@"com.rnshare" code:1 userInfo:userInfo];

          NSLog(errorMessage);
          failureCallback(error);
        }
    }

}


@end
