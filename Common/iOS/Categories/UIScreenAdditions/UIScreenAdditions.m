/******************************************************************************
 
 File:			UIScreenAdditions.m
 
 Date:			10/20/10
 
 Version:		1.0
 
 Authors:		Glob Design, LLC
 
				Copyright 2010-2012 Glob Design, LLC
				All rights reserved worldwide.
 
 Notes:			Additions for UIScreen
 
 Dependencies:	See header.

 Changes:		See header.
 
******************************************************************************/

#import "UIScreenAdditions.h"

@implementation UIScreen ( UIScreenAdditions )

///////////////////////////////////////////////
// Return the second UIScreen object, if any.
///////////////////////////////////////////////

+ (UIScreen*)externalScreen
{
	UIScreen *secondScreen = nil;
	
	if( [ UIScreen numScreens ] > 1 )
    {
        // Get the screen object that represents the external display...
		
		secondScreen = [ [ UIScreen screens ] objectAtIndex:1 ];
	}
	
	return secondScreen;
}

/////////////////////////////////////////////////////
// Return total number of screens on current device.
/////////////////////////////////////////////////////

+ (NSUInteger)numScreens
{
	NSUInteger num = [ [ UIScreen screens ] count ];
	
	return num;
}

@end
