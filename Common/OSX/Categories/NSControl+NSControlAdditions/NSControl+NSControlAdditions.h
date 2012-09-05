/****************************************************************************

File:			NSControl+NSControlAdditions.h

Date:			2/13/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Header for NSControl+NSControlAdditions.m

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

2/13/10			MCA Initial version.

******************************************************************************/

#import <CoreFoundation/CoreFoundation.h>
#import <Cocoa/Cocoa.h>

// Classes

@interface NSControl ( NSControlAdditions )

// Utils

- (void)setEnabledAndDisplay:(BOOL)enable;

- (void)setHiddenAndDisplay:(BOOL)hide;

- (void)setStringValue:(NSString*)string andSetEnabledAndDisplay:(BOOL)enable;

- (void)setStringValue:(NSString*)string andSetHiddenAndDisplay:(BOOL)hide;

- (void)setStringValue:(NSString*)string andSetEnabledAndDisplay:(BOOL)enable andSetHiddenAndDisplay:(BOOL)hide;

@end