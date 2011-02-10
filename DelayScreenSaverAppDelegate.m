/*
 *  DelayScreenSaverAppDelegate.m
 *  DelayScreenSaver
 *
 *  Created by Dan Roque on 4.11.2010
 *
 */

#import "DelayScreenSaverAppDelegate.h"

@implementation DelayScreenSaverAppDelegate

#pragma mark -
#pragma mark Property Implementation Directives
@synthesize statusMenu;
@synthesize mExitMenu;
@synthesize mScreenSaverTime;
@synthesize mRemainingTime;

#pragma mark -
#pragma mark Applicatoin startup
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (void)awakeFromNib {
	statusItem = [[[NSStatusBar systemStatusBar]statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setMenu:statusMenu];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"mac-stopwatch-icon-main" ofType:@"png"];
					  menuIcon = [[NSImage alloc] initWithContentsOfFile:path];
	[statusItem setHighlightMode:YES];
	[statusItem setImage:menuIcon];			  
	[menuIcon release];
	/* Get screensaver idleTime for current user */
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults addSuiteNamed:@"com.apple.screensaver"];
	NSString *sTime = [defaults objectForKey:@"idleTime"];
	int idleTime = [sTime intValue];
	idleTime = idleTime / 60;
	/* set current user idletime to our menu */
	[mScreenSaverTime setTitle:[NSString stringWithFormat:@"    %d minutes", idleTime]];	
}

#pragma mark -
#pragma mark Helper methods
/**
	Displays about panel.
 */
- (void)showAboutPanel:(id)sender {
	[[NSApplication sharedApplication]activateIgnoringOtherApps:YES];
	[[NSApplication sharedApplication]orderFrontStandardAboutPanel:sender];
}

/**
	Starts timers with given delay time so we can track it.
 */
- (void)setScreenSaverDelay: (int) time {
	NSNumber *seconds = [NSNumber numberWithInt:(60 * time)];
	count = 0;
	icon = time;
	
	t1 = [NSTimer scheduledTimerWithTimeInterval: 10.0
										  target: self
										selector:@selector(onTick:)
										userInfo:seconds repeats:YES];
	t2 = [NSTimer scheduledTimerWithTimeInterval: 60.0
										  target: self
										selector:@selector(updateIcon:)
										userInfo:nil repeats:YES];	
	
	[mRemainingTime setTitle:[NSString stringWithFormat:@"    %i minutes", icon]];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%i-16", icon] ofType:@"png"];
	menuIcon = [[NSImage alloc] initWithContentsOfFile:path];
	[statusItem setImage:menuIcon];
}

/**
	Disables all currently running timers.
 */
- (void)stopTimers {
	/* stop timers if running */
	[t1 invalidate];
	t1 = nil;
	[t2 invalidate];
	t2 = nil;
	/* reset timer vars */
	icon = 0;
	count = 0;
}

/**
	Tracks the current delay time. Issues a system activity event 
	every 10 seconds to delay screensaver.
 */
- (void)onTick:(NSTimer *)timer {
	count = count + 10;
	int num = [[timer userInfo] integerValue];
	if (count >= num) {
		[timer invalidate];
		timer = nil;
		/* disable icon timer since it will cause menu icon to disappear when this timer stops */
		[t2 invalidate];
		t2 = nil;
		NSBundle *bundle = [NSBundle bundleForClass:[self class]];
		NSString *path = [bundle pathForResource:@"mac-stopwatch-icon-main" ofType:@"png"];
		menuIcon = [[NSImage alloc] initWithContentsOfFile:path];
		[statusItem setImage:menuIcon];
		[menuIcon release];
		count = 0;
		icon = 0;
	}
	else {
		/* delay screensaver */
		UpdateSystemActivity(UsrActivity);
	}
}

/**
	Updates menu icon every 60 seconds with time remaining in minutes.
 */
- (void)updateIcon:(NSTimer *)timer {
	icon = icon - 1;
	/* if there are no more icons to display then the timer has finished so stop it */
	if (icon == 0) {
		[timer invalidate];
		timer = nil;
	}
	else {
		/* display the next time icon */
		NSString *iconNum = [NSString stringWithFormat:@"%d", icon];
		NSString *size = @"-16";
		NSString *newIcon = [NSString stringWithFormat:@"%@%@", iconNum, size];
		[mRemainingTime setTitle:[NSString stringWithFormat:@"    %@ minutes",iconNum]];
		NSBundle *bundle = [NSBundle bundleForClass:[self class]];
		NSString *path = [bundle pathForResource:newIcon ofType:@"png"];
		menuIcon = [[NSImage alloc] initWithContentsOfFile:path];
		[statusItem setImage:menuIcon];	
		[menuIcon release];
	}
}

#pragma mark -
#pragma mark GUI actions
/**
	Turns off the screensaver and restores all default settings.
 */
- (IBAction)setScreenSaver_Off:(id)sender {
	[t1 invalidate];
	t1 = nil;
	[t2 invalidate];
	t2 = nil;
	icon = 0;
	count = 0;
	[mRemainingTime setTitle:@"    choose from list"];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"mac-stopwatch-icon-main" ofType:@"png"];
	menuIcon = [[NSImage alloc] initWithContentsOfFile:path];
	[statusItem setImage:menuIcon];
	[menuIcon release];
}

- (IBAction)setScreenSaverDelayTime:(id)sender {
	/* stop all current timers */
	[self stopTimers];
	/* set the delay */
	[self setScreenSaverDelay: [sender tag]];
}

/**
	Exits application.
 */
- (IBAction)exitMenu:(id)sender {
	[NSApp terminate:nil];
}

/**
	Releases all retained variables.
 */
- (void)dealloc {
	[statusItem release];
	[statusMenu release];
	[mExitMenu release];
	[mRemainingTime release];
	[mScreenSaverTime release];
	[super dealloc];
}

@end
