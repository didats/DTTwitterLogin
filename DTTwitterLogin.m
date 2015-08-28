//
//  DTTwitterLogin.m
//  Qwisia
//
//  Created by Didats on 28/08/15.
//  Copyright (c) 2015 Rimbunesia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTwitterLogin.h"
#import <objc/runtime.h>
#import <Social/Social.h>

#define errorDomain @"com.rimbunesia.DTTwitterLogin"

#pragma mark - UIAlertView
@interface UIAlertView (Block)

- (void)showAlertViewWithButtonClickBlock:(void (^) (NSInteger buttonIndex))block;;

@end

@implementation UIAlertView (Block)

static char key;

- (void)showAlertViewWithButtonClickBlock:(void (^) (NSInteger buttonIndex))block
{
    if (block) {
        objc_setAssociatedObject(self, &key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.delegate = self;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^block) (NSInteger buttonIndex) = objc_getAssociatedObject(self, &key);
    if (block) {
        block(buttonIndex);
    }
}

@end

#pragma mark - DTTwitterLogin implementation
@implementation DTTwitterLogin

+(void) loginWithCompletion:(DTTwitterCompletionBlock) successBlock andError:(DTTwitterErrorBlock) errorBlock {

    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSDictionary *options;

    // To hold the variables needed
    NSMutableArray *twitterAccounts = [NSMutableArray arrayWithCapacity:0];

    // request for reading the account
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            // granted for permission
            if(granted) {
                NSArray *accountArray = [accountStore accountsWithAccountType:accountType];

                for (ACAccount *account in accountArray) {
                    [twitterAccounts addObject:@{@"id": [[account valueForKey:@"properties"] valueForKey:@"user_id"], @"name": account.username, [NSString stringWithFormat:@"%@", [[account valueForKey:@"properties"] valueForKey:@"user_id"]]: account.username, @"account": account}];
                }

                // if the account more than 1
                if ([accountArray count] > 1) {

                    // create an alert view
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Which account" message:@"Choosen an account to use:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];

                    for (NSInteger i = 0; i < [twitterAccounts count]; i++) {
                        ACAccount *account = [[twitterAccounts objectAtIndex:i] objectForKey:@"account"];
                        [alert addButtonWithTitle:account.username];
                    }

                    // alert completion block
                    [alert showAlertViewWithButtonClickBlock:^(NSInteger buttonIndex) {
                        if (buttonIndex > 0) {
                            // user select one of the account
                            successBlock([twitterAccounts objectAtIndex:buttonIndex - 1], [[twitterAccounts objectAtIndex:buttonIndex - 1] objectForKey:@"account"]);
                        }
                        else {
                            // user tap cancel
                            NSError *error = [NSError errorWithDomain:errorDomain code:105 userInfo:@{@"ErrorMessage": @"No account chosen by the user"}];
                            errorBlock(error);
                        }
                    }];

                }
                // the account is only one
                else if([accountArray count] == 1){
                    successBlock([twitterAccounts objectAtIndex:0], [[twitterAccounts objectAtIndex:0] objectForKey:@"account"]);
                }
                // no account found
                else {
                    NSError *error = [NSError errorWithDomain:errorDomain code:101 userInfo:@{@"ErrorMessage": @"No account found in the settings app"}];
                    errorBlock(error);
                }
            }
            else {
                if (errno == 0) {
                    NSError *error = [NSError errorWithDomain:errorDomain code:101 userInfo:@{@"ErrorMessage": @"No account found in the settings app"}];
                    errorBlock(error);
                }
                else if(errno == 3) {
                    NSError *error = [NSError errorWithDomain:errorDomain code:102 userInfo:@{@"ErrorMessage": @"Not getting permission to read the Twitter account"}];
                    errorBlock(error);
                }
                else {
                    NSError *error = [NSError errorWithDomain:errorDomain code:103 userInfo:@{@"ErrorMessage": @"Unknown error reason"}];
                    errorBlock(error);
                }
            }
        });
    }];
}

+(void) requestLoginWithAccount:(ACAccount *) account completionBlock:(void (^)(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)) callbackHandler   {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", account.username]];

    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:nil];
    [request setAccount:account];

    [request performRequestWithHandler:callbackHandler];
}

@end
