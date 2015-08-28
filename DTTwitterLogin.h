//
//  DTTwitterLogin.h
//  Qwisia
//
//  Created by Didats on 28/08/15.
//  Copyright (c) 2015 Rimbunesia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

// success and error blocks
typedef void (^DTTwitterCompletionBlock)(NSDictionary *twitterDetail, ACAccount *twitterAccount);
typedef void (^DTTwitterErrorBlock)(NSError *error);

@interface DTTwitterLogin : NSObject <UIAlertViewDelegate>

@property (strong,nonatomic) DTTwitterCompletionBlock callback;

// available class methods
+ (void) loginWithCompletion:(DTTwitterCompletionBlock) successBlock andError:(DTTwitterErrorBlock) errorBlock;
+ (void) requestLoginWithAccount:(ACAccount *) account completionBlock:(void (^)(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)) callbackHandler;

@end
