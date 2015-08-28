[![Rimbunesia](http://rimbunesia.com/images/github-rimbunesia.png)](http://rimbunesia.com)

# DTTwitterLogin
Easily login with twitter account using the social account framework with a minimal effort

## How to use
1. Include Social Framework and Accounts Framework to your project from "Link Binary With Libraries"  
2. Import the required file  
Put `#import "DTTwitterLogin.h"` at the top, and put this code whereever you want (usually after a button clicked)  

```ObjectiveC
// get twitter account from the settings
[DTTwitterLogin loginWithCompletion:^(NSDictionary *twitterDetail, ACAccount *twitterAccount) {
   // do request to get basic info of the user selected
   [DTTwitterLogin requestLoginWithAccount:twitterAccount completionBlock:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {

       dispatch_sync(dispatch_get_main_queue(), ^{
          // only if its success
           if (error == nil) {
               NSError *jsonError;
               NSDictionary *item = [NSJSONSerialization JSONObjectWithData:responseData
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:&jsonError];
               // Now you got the item you need
               NSLog(@"Item: %@", item);
           }
       });
   }];
} andError:^(NSError *error) {
   // Now get the error message
   NSLog(@"Error: %@", error);
}];
```

##Contact
I wrote this code for my own use, and making it available to anyone for the benefit of iOS Developer community.  

You are not encourage to do, but sure I will be glad if you buy one of my apps here.   [http://appstore.com/dianagustriadi](http://appstore.com/dianagustriadi)  

If you have any questions regarding this code, you could contact me here:  
Website: [http://didatstriadi.com](http://didatstriadi.com)  
Twitter: [@didats](http://twitter.com/didats)  

If you have any project to share with me, you could contact my team below. We are available for iOS and Android Development from the scratch with affordable price:  
Website: [http://rimbunesia.com](http://rimbunesia.com)

##License
This code is distributed under the terms and conditions of the MIT license.

Copyright (c) 2015 Didats Triadi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
