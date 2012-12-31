/****************************************************************************

File:			UIWindowAdditions.m

Date:			11/17/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Implementation of UIWindowAdditions

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

#import "UIWindowAdditions.h"
#import <cb.h>

@implementation UIWindow ( UIWindowAdditions )

#pragma mark Views in Window

//////////////////////////////////
// Return topmost view in window.
//////////////////////////////////

- (UIView*)topmostViewForWindow
{
	NSArray				*rootVContrSubviewsArray = nil;
	UIViewController	*rootVContr = nil;
	UIView				*rootVContrView = nil;
	UIView				*topMostView = nil;
	
	// Get root view controller...
	
	rootVContr = [ self rootViewController ];
	if( rootVContr )
	{
		// Get root view...
		
		rootVContrView = rootVContr.view;
		if( rootVContrView )
		{
			// Walk root view controller getting views til we hit the last one...
			
			rootVContrSubviewsArray = [ rootVContrView subviews ];
			if( rootVContrSubviewsArray )
			{
				// Make sure we got one or we will crash...
				
				if( [ rootVContrSubviewsArray count ] )
				{
					// Get topmost view...
				
					topMostView = [ rootVContrSubviewsArray objectAtIndex:( [ rootVContrSubviewsArray count ] - 1 ) ];
				}
				else
				{
					// Root is topmost so just return that...
				
					topMostView = rootVContrView;
				}
			}
			else
			{
				// Root is topmost so just return that...
				
				topMostView = rootVContrView;
			}
		}
	}
	
	return topMostView;
}

@end
