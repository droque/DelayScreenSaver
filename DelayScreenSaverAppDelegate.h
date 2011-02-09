/*
 *  DelayScreenSaverAppDelegate.h
 *  DelayScreenSaver
 *
 *  Created by Dan Roque on 4.11.2010
 *
 */

#import <AppKit/NSMenu.h>

@interface DelayScreenSaverAppDelegate : NSMenu <NSApplicationDelegate> {
	NSMenu *statusMenu;
	NSMenuItem *mExitMenu;
	NSMenuItem *mScreenSaverTime;
	NSMenuItem *mRemainingTime;
	NSStatusItem *statusItem;
	NSImage *menuIcon;
	NSTimer *t1;
	NSTimer *t2;
	NSInteger count;
	NSInteger icon;
}

#pragma mark -
#pragma mark IBOutlet declarations
@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) IBOutlet NSMenuItem *mExitMenu;
@property (nonatomic, retain) IBOutlet NSMenuItem *mScreenSaverTime;
@property (nonatomic, retain) IBOutlet NSMenuItem *mRemainingTime;

#pragma mark -
#pragma mark GUI actions
- (IBAction)setScreenSaver_Off:(id)sender;
- (IBAction)setScreenSaverDelayTime:(id)sender;
- (IBAction)exitMenu:(id)sender;

#pragma mark -
#pragma mark Helper methods
- (void)showAboutPanel:(id)sender;
- (void)setScreenSaverDelay:(int)time;
- (void)stopTimers;


@end
