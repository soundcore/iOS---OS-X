/******************************************************************************
 
 File:			UIApplicationAdditions.m
 
 Date:			12/14/12
 
 Version:		1.0
 
 Authors:		soundcore
 
				Copyright 2012 soundcore
				All rights reserved worldwide.
				 
 Notes:			Implementation for UIApplicationAdditions.m
				 
				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.
	
				WARNING: UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore. ANY SUCH DISTRIBUTION CARRIES
				SEVERE CRIMINAL AND CIVIL PENALTIES AND IS A
				VIOLATION OF INTERNATIONAL COPYRIGHT LAW. VIOLATORS
				WILL BE PROSECUTED TO THE FULL EXTENT OF INTERNATIONAL LAW.
 
 Dependencies:	See header.
 Changes:		See header.
 
 ******************************************************************************/

#import "UIApplicationAdditions.h"

@implementation UIApplication ( UIApplicationAdditions )

#pragma mark- iClod
#pragma mark-

///////////////////////////////////////////////////////////////////////
// Determine whether iClod is configured for a given ubiquity key ID.
// Example: @"ABCDEFGHI0.com.acme.MyApp"
// Note this doesn't work in the sim as of iOS 5.x.
// NOTE: DO NOT CALL THIS FROM THE MAIN THREAD. ALWAYS US A GCD QUEUE.
///////////////////////////////////////////////////////////////////////

- (BOOL)iCloudIsEnabledForUbiquityID:(NSString*)ubiqString
{
	BOOL configed = NO;
	
	if( ubiqString )
	{
		#if !TARGET_IPHONE_SIMULATOR
		
			NSURL *ubiquityURL = [ kDefaultFileManager URLForUbiquityContainerIdentifier:ubiqString ];
			if( ubiquityURL )
			{
				// We got it...
				
				configed = YES;
			}
			
		#endif
	}
	
	return configed;
}

#pragma mark- Local Notifications
#pragma mark-

////////////////////////////////////////////////////
// Display the local notification passed in.
// Note that the UILocalNotification passed in
// must have alredy been completely configured.
//
// Note the notification will still be displayed
// by the OS even if the app is quit and the
// notification is scheduled for a future date.
//
// Remember local iOS notifications are ONLY
// *displayed* when the app is not running. If the
// app is running, the notification will be
// delivered to the app delegate but not displayed.
//
// If a sound file name is passed in, the sound file
// MUST be:
//
// Linear PCM
// MA4 (IMA/ADPCM)
// μLaw
// aLaw
/////////////////////////////////////////////////////

- (void)displayLocalNotification:(UILocalNotification*)aNotification immediately:(BOOL)immediate withSoundFile:(NSString*)soundFileName
{
	NSInteger				currentAppBadgeNumber = 0;
	UILocalNotification		*n = [ aNotification copy ];
	
	if( n )
	{
		// Add 1 to the app badge if any...
		
		currentAppBadgeNumber = UIApp.applicationIconBadgeNumber;
		
		n.applicationIconBadgeNumber = ( currentAppBadgeNumber + 1 );
		
		// Add sound if indicated...
		
		if( soundFileName )
		{
			n.soundName = [ soundFileName copy ];
		}
		
		if( immediate )
		{
			// Display immediately...
			
			[ UIApp presentLocalNotificationNow:n ];
		}
		else
		{
			// Display later...
			
			[ UIApp scheduleLocalNotification:n ];
		}
	}
}

/////////////////////////////////////////////////////
// Schedule a local notification using params
// passed in. Note in this case we create the
// notification itself from the params.
//
// Note the notification will still be displayed
// by the OS even if the app is quit and the
// notification is scheduled for a future date.
//
// Remember local iOS notifications are ONLY
// *displayed* when the app is not running. If the
// app is running, the notification will still be
// delivered to the app delegate but NOT displayed.
//
// If a sound file name is passed in, the sound file
// MUST be:
//
// Linear PCM
// MA4 (IMA/ADPCM)
// μLaw
// aLaw
//////////////////////////////////////////////////////

- (void)scheduleLocalNotification:(NSDate*)fireDate
		text:(NSString*)alertText
		action:(NSString*)alertAction
		sound:(NSString*)soundFileName
		launchImage:(NSString*)launchImage
		withInfo:(NSDictionary*)userInfo
{
	UILocalNotification *localNotification = nil;
	
	localNotification = [ [ UILocalNotification alloc ] init ];
	
	if( localNotification && fireDate )
	{
		localNotification.fireDate = fireDate;
		localNotification.timeZone = kDefaultTimeZone;
		localNotification.alertBody = alertText;
		localNotification.alertAction = alertAction;
		
		if( !soundFileName )
		{
			localNotification.soundName = UILocalNotificationDefaultSoundName;
		}
		else
		{
			localNotification.soundName = soundFileName;
		}
		
		localNotification.alertLaunchImage = launchImage;
		localNotification.userInfo = userInfo;
		
		// Schedule it on the OS...
		
		[ UIApp scheduleLocalNotification:localNotification ];
	}
}

/////////////////////////////////////////////////////
// Same as -scheduleLocalNotification except
// with a future seconds from now passed in instead
// of a complete future date.
//
// Note the notification will still be displayed
// by the OS even if the app is quit and the
// notification is scheduled for a future date.
//
// Remember local iOS notifications are ONLY
// *displayed* when the app is not running. If the
// app is running, the notification will still be
// delivered to the app delegate but NOT displayed.
//
// If a sound file name is passed in, the sound file
// MUST be:
//
// Linear PCM
// MA4 (IMA/ADPCM)
// μLaw
// aLaw
//////////////////////////////////////////////////////

- (void)scheduleLocalNotificationInFuture:(NSUInteger)secondsFromNow
		text:(NSString*)alertText
		action:(NSString*)alertAction
		sound:(NSString*)soundFileName
		launchImage:(NSString*)launchImage
		withInfo:(NSDictionary*)userInfo
{
	NSDate *date = [ NSDate dateWithTimeIntervalSinceNow:secondsFromNow ];
	
	[ self scheduleLocalNotification:date
			text:alertText
			action:alertAction
			sound:soundFileName
			launchImage:launchImage
			withInfo:userInfo ];
}

@end
