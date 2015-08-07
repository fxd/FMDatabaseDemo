//
//  KeyboardController.m
//  LoginAndCaptchaViewControllers
//
//  Created by fengshaobo on 14-6-5.
//
//

#import "KeyboardController.h"

@interface KeyboardController ()
@property (nonatomic, copy) KeyboardBlock keyboardBlock;
@end

@implementation KeyboardController

SYNTHESIZE_SINGLETON(KeyboardController)

- (id)init
{
    if((self = [super init])) {
        
        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
        
        [notificationCenter addObserver:self
                               selector:@selector(keyboardWillShowAction:)
                                   name:UIKeyboardWillShowNotification
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(keyboardDidShowAction:)
                                   name:UIKeyboardDidShowNotification
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(keyboardWillHideAction:)
                                   name:UIKeyboardWillHideNotification
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(keyboardDidHideAction:)
                                   name:UIKeyboardDidHideNotification
                                 object:nil];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >=5.0) {
            
            [notificationCenter addObserver:self
                                   selector:@selector(keyboardWillChangedAction:)
                                       name:UIKeyboardWillChangeFrameNotification
                                     object:nil];
            
            [notificationCenter addObserver:self
                                   selector:@selector(keyboardDidChangedAction:)
                                       name:UIKeyboardDidChangeFrameNotification
                                     object:nil];
        }
    }
    return self;
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardChanged:(KeyboardBlock)block
{
    self.keyboardBlock = block;
}

-(CGRect) rectForNotification:(NSNotification *) notification {
    return [[notification.userInfo valueForKey: UIKeyboardFrameEndUserInfoKey ] CGRectValue];
}

-(void) keyboardWillShowAction:(NSNotification *) notification {
    if (self.keyboardBlock) {
        self.keyboardBlock(KeyboardWillShow, [self rectForNotification:notification]);
    }
}

-(void) keyboardDidShowAction:(NSNotification *) notification{
    if (self.keyboardBlock) {
        self.keyboardBlock(KeyboardDidShow, [self rectForNotification:notification]);
    }
}

-(void) keyboardWillHideAction:(NSNotification *) notification{
    
    if (self.keyboardBlock) {
        self.keyboardBlock(KeyboardWillHide, [self rectForNotification:notification]);
    }
}

-(void) keyboardDidHideAction:(NSNotification *) notification{
    if (self.keyboardBlock) {
        self.keyboardBlock(KeyboardDidHide, [self rectForNotification:notification]);
    }
}

-(void) keyboardWillChangedAction:(NSNotification *) notification{
    if (self.keyboardBlock) {
        self.keyboardBlock(KeyboardWillChange, [self rectForNotification:notification]);
    }
}

-(void) keyboardDidChangedAction:(NSNotification *) notification{
    if (self.keyboardBlock) {
        self.keyboardBlock(KeyboardDidChange, [self rectForNotification:notification]);
    }
}

@end
