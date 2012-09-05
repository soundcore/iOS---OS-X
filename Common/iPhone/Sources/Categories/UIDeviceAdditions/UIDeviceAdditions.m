/****************************************************************************

File:			UIDeviceAdditions.m

Date:			10/5/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Implementation of UIDeviceAdditions.

				See comments in header.

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore.

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE FULL EXTENT OF
				INTERNATIONAL LAW.

******************************************************************************/

#import "UIDeviceAdditions.h"
#import <cb.h>

@implementation UIDevice ( UIDeviceAdditions )

#pragma mark- Game Center

///////////////////////////////////////////////////
// See if we have a valid Game Center OS running.
///////////////////////////////////////////////////
	
- (BOOL)hasGameCenterOS
{
	Class					gcClass = nil;
	NSArray					*systemVersionStringComponentStringsArray = nil;
	NSString				*systemVersionString = nil;
	NSString				*foundMajorSystemVersionString = nil;
	NSString				*foundMinorSystemVersionString = nil;
	NSComparisonResult		majorResult = 0;
	NSComparisonResult		minorResult = 0;
	BOOL					hasIt = NO;
	BOOL					keepGoing = NO;
	
	// Check for availability of GKLocalPlayer class...
	
	gcClass = ( NSClassFromString( @"GKLocalPlayer" ) );

	// Check OS version...
		
	systemVersionString = [ UIDevice currentDevice ].systemVersion;
	if( systemVersionString )
	{
		// Get version string components array...
		
		systemVersionStringComponentStringsArray = [ systemVersionString componentsSeparatedByString:kDotStringKey ];
		if( systemVersionStringComponentStringsArray )
		{
			//////////////////////////////////////
			// Compare 1st component to major...
			//////////////////////////////////////
			
			foundMajorSystemVersionString = [ systemVersionStringComponentStringsArray objectAtIndexSafe:0 ];
			if( foundMajorSystemVersionString )
			{
				majorResult = [ foundMajorSystemVersionString compare:kMinGameCenterMajorOSVersionString ];
				if( ( majorResult == NSOrderedSame ) || ( majorResult == NSOrderedDescending ) )
				{
					// Major is good...
					
					if( ( [ systemVersionStringComponentStringsArray count ] > 1 ) && ( majorResult == NSOrderedSame ) )
					{
						// Keep going because we have more than one component and we're on version 4.x...
						
						keepGoing = YES;
					}
					else if( ( majorResult == NSOrderedDescending ) && ( gcClass != nil ) )
					{
						// No need to continue since we know we're on a later *major* version than 4.x...
						
						hasIt = YES;
					}
				}
			}
			
			//////////////////////////////////////////////
			// Compare 2nd component to minor, if any...
			//////////////////////////////////////////////
		
			if( keepGoing )
			{
				foundMinorSystemVersionString = [ systemVersionStringComponentStringsArray objectAtIndexSafe:1 ];
				if( foundMinorSystemVersionString )
				{
					minorResult = [ foundMinorSystemVersionString compare:kMinGameCenterMinorOSVersionString ];
					if( ( ( minorResult == NSOrderedSame ) || ( minorResult == NSOrderedDescending ) ) && ( gcClass != nil ) )
					{
						// We're on at least 4.x or later so return YES...
						
						hasIt = YES;
					}
				}
			}
		}
	}
	
	return hasIt;
}

///////////////////////////////////////
// See if we are on iOD 4.0 or later.
///////////////////////////////////////
	
- (BOOL)isIOS4OrLater
{
	NSArray					*systemVersionStringComponentStringsArray = nil;
	NSString				*systemVersionString = nil;
	NSString				*foundMajorSystemVersionString = nil;
	NSComparisonResult		majorResult = 0;
	BOOL					hasIt = NO;
	
	// Check OS version...
		
	systemVersionString = [ UIDevice currentDevice ].systemVersion;
	if( systemVersionString )
	{
		// Get version string components array...
		
		systemVersionStringComponentStringsArray = [ systemVersionString componentsSeparatedByString:kDotStringKey ];
		if( systemVersionStringComponentStringsArray )
		{
			//////////////////////////////////////
			// Compare 1st component to major...
			//////////////////////////////////////
			
			foundMajorSystemVersionString = [ systemVersionStringComponentStringsArray objectAtIndexSafe:0 ];
			if( foundMajorSystemVersionString )
			{
				majorResult = [ foundMajorSystemVersionString compare:kMinGameCenterMajorOSVersionString ];
				if( ( majorResult == NSOrderedSame ) || ( majorResult == NSOrderedDescending ) )
				{
					// Major is good...
					
					if( ( [ systemVersionStringComponentStringsArray count ] > 1 ) && ( majorResult == NSOrderedSame ) )
					{
						hasIt = YES;
					}
				}
			}
		}
	}
	
	return hasIt;
}

//////////////////////////////////////////////////////////////////////////
// Given orientation passed in, return a matching UIInterfaceOrientation.
//////////////////////////////////////////////////////////////////////////

- (UIInterfaceOrientation)theHeadingWithRotationalAdjustment:(UIDeviceOrientation)orientation
{
	UIInterfaceOrientation mappedOrient = 0;
	
	switch( orientation )
	{
		case UIDeviceOrientationPortrait:
		
			mappedOrient = UIInterfaceOrientationPortrait;
			
			break;
			
		case UIDeviceOrientationPortraitUpsideDown:
		
			mappedOrient = UIInterfaceOrientationPortraitUpsideDown;
		
			break;
			
		case UIDeviceOrientationLandscapeLeft:
		
			mappedOrient = UIInterfaceOrientationLandscapeLeft;
			
			break;
		
		case UIDeviceOrientationLandscapeRight:
		
			mappedOrient = UIInterfaceOrientationLandscapeRight;
			
			break;
			
		default:
			
			break;
	}
	
	return mappedOrient;
}

@end
