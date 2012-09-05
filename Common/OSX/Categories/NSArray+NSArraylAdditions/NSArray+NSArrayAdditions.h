/****************************************************************************

File:			NSArray+NSArrayAdditions.h

Date:			10/12/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Header for NSArray+NSArrayAdditions.m

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

Dependencies:	See header.

Changes:		

10/12/10		MCA Initial version.

******************************************************************************/

#import <CoreFoundation/CoreFoundation.h>

#if TARGET_OS_IPHONE == 1
	#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC == 1
	#import <Cocoa/Cocoa.h>
#endif

// Classes

@interface NSArray ( NSArrayAdditions )

// Utils

- (id)objectAtIndexSafe:(NSUInteger)objIndex;

@end
