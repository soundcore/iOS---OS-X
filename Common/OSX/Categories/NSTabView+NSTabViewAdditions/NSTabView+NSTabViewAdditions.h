/****************************************************************************

File:			NSTabView+NSTabViewAdditions.h

Date:			5/4/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore.
				All rights reserved worldwide.

Notes:			Header for NSTabView+NSTabViewAdditions.m

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore. ANY SUCH DISTRIBUTION CARRIES
				SEVERE CRIMINAL AND CIVIL PENALTIES AND IS A
				VIOLATION OF INTERNATIONAL COPYRIGHT LAW. VIOLATORS
				WILL BE PROSECUTED TO THE FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	See header.

Changes:		5/4/10	MCA Initial version.

******************************************************************************/

#import <CoreFoundation/CoreFoundation.h>
#import <Cocoa/Cocoa.h>

// Categories

@interface NSTabView ( NSTabViewAdditions )

// Utils

- (void)removeTabItemAtIndex:(NSInteger)itemIndex;

- (NSInteger)selectedTabItemIndex;

@end
