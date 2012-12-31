/******************************************************************************
 
File:			UIScreenAdditions.h
 
Date:			10/20/10
 
Version:		1.0
 
Authors:		Glob Design, LLC
 
				Copyright 2010-2012 Glob Design, LLC
				All rights reserved worldwide.
 
Notes:			Header for UIScreenAdditions.h
 
Dependencies:	XCode 4.2+
				iPhone SDK 5.0+
				
Changes:		10/20/10 GD - Initial version.
 
******************************************************************************/

#import <UIKit/UIKit.h>

@interface UIScreen ( UIScreenAdditions )

+ (UIScreen*)externalScreen;

+ (NSUInteger)numScreens;

@end
