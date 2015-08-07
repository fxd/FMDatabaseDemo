//
//  KeyboardController.h
//  LoginAndCaptchaViewControllers
//
//  Created by fengshaobo on 14-6-5.
//
//

#import <Foundation/Foundation.h>
#import "SingletonTemplate.h"

typedef NS_ENUM(NSInteger, KeyboardStatus) {
    KeyboardWillShow,
    KeyboardDidShow,
    KeyboardWillHide,
    KeyboardDidHide,
    KeyboardWillChange,
    KeyboardDidChange
};


typedef void (^KeyboardBlock)(KeyboardStatus status, CGRect toFrame);

@interface KeyboardController : NSObject

DECLARE_SINGLETON(KeyboardController)

- (void)keyboardChanged:(KeyboardBlock)block;

@end
