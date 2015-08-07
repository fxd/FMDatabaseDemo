//
//  MFSideMenu.h
//
//  Created by Michael Frederick on 3/17/12.
//

#import "BaseNameVC.h"

@class MFSideMenu;

@protocol MFSideMenuPtc <NSObject>

- (void)sideMenuDidDismiss:(MFSideMenu *)sideMenu;

@end

static const CGFloat kMFSideMenuSidebarWidth = 270.0f;
static const CGFloat kMFSideMenuShadowWidth = 5.0f;
static const CGFloat kMFSideMenuAnimationDuration = 0.2f;
static const CGFloat kMFSideMenuAnimationMaxDuration = 0.4f;

typedef enum {
    MFSideMenuLocationLeft, // show the menu on the left hand side
    MFSideMenuLocationRight // show the menu on the right hand side
} MFSideMenuLocation;

typedef enum {
    MFSideMenuOptionMenuButtonEnabled = 1 << 0, // enable the 'menu' UIBarButtonItem
    MFSideMenuOptionBackButtonEnabled = 1 << 1, // enable the 'back' UIBarButtonItem
    MFSideMenuOptionShadowEnabled = 1 << 2, // enable the shadow between the navigation controller & side menu
} MFSideMenuOptions;

typedef enum {
    MFSideMenuStateHidden, // the menu is hidden
    MFSideMenuStateVisible // the menu is shown
} MFSideMenuState;

typedef enum {
    MFSideMenuStateEventMenuWillOpen, // the menu is going to open
    MFSideMenuStateEventMenuDidOpen, // the menu finished opening
    MFSideMenuStateEventMenuWillClose, // the menu is going to close
    MFSideMenuStateEventMenuDidClose // the menu finished closing
} MFSideMenuStateEvent;

typedef void (^MFSideMenuStateEventBlock)(MFSideMenuStateEvent);

@interface MFSideMenu : NSObject<UIGestureRecognizerDelegate>

@property (nonatomic, assign, readonly) BaseNameVC *mainBaseNameVC;
@property (nonatomic, assign, readonly) UIViewController *sideMenuController;
@property (nonatomic, assign, readonly) BaseNameVC *containerBaseNameVC;
@property (nonatomic, assign) MFSideMenuState menuState;
@property (nonatomic, assign) CGFloat sideOffset;
@property (nonatomic, weak) id <MFSideMenuPtc> delegate;

// this can be used to observe all MFSideMenuStateEvents
@property (copy) MFSideMenuStateEventBlock menuStateEventBlock;

+ (MFSideMenu *) menuWithBaseNameVC:(BaseNameVC *)controller
				 sideMenuController:(id)menuController
						containerVC:(BaseNameVC *)containerVC;

+ (MFSideMenu *) menuWithBaseNameVC:(BaseNameVC *)controller
				 sideMenuController:(UIViewController *)menuController
						containerVC:(BaseNameVC *)containerVC
						   location:(MFSideMenuLocation)side;

- (void)showSideMenu;

- (void)viewControllerWillAppear;
- (void)viewControllerDidAppear;
- (void)viewControllerDidDisappear;

@end
