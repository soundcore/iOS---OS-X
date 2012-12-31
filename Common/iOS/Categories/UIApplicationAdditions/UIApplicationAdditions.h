/******************************************************************************
 
 File:			UIApplicationAdditions.h
 
 Date:			12/14/12
 
 Version:		1.0
 
 Authors:		soundcore
 
				Copyright 2012 soundcore
				All rights reserved worldwide.
 
 Notes:			Header for UIApplicationAdditions.m
 
				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.
				 
				WARNING: UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore. ANY SUCH DISTRIBUTION CARRIES
				SEVERE CRIMINAL AND CIVIL PENALTIES AND IS A
				VIOLATION OF INTERNATIONAL COPYRIGHT LAW. VIOLATORS
				WILL BE PROSECUTED TO THE FULL EXTENT OF INTERNATIONAL LAW.
 
 Dependencies:	XCode 4.2+
				iPhone SDK 5.0+
				cb.h
 
 Changes:		12/14/12 MCA - Initial version.
 
 ******************************************************************************/

#import <UIKit/UIKit.h>

#import <cb.h>

@interface UIApplication ( UIApplicationAdditions )

// iClod

- (BOOL)iCloudIsEnabledForUbiquityID:(NSString*)ubiqString;

// Local notifications

- (void)displayLocalNotification:(UILocalNotification*)aNotification immediately:(BOOL)immediate withSoundFile:(NSString*)soundFileName;

- (void)scheduleLocalNotification:(NSDate*)fireDate
							text:(NSString*)alertText
							action:(NSString*)alertAction
							sound:(NSString*)soundFileName
							launchImage:(NSString*)launchImage
							withInfo:(NSDictionary*)userInfo;

- (void)scheduleLocalNotificationInFuture:(NSUInteger)secondsFromNow
							text:(NSString*)alertText
							action:(NSString*)alertAction
							sound:(NSString*)soundFileName
							launchImage:(NSString*)launchImage
							withInfo:(NSDictionary*)userInfo;

@end
