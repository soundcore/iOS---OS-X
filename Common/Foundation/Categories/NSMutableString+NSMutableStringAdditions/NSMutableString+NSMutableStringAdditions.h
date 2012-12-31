/****************************************************************************

File:			NSMutableString+NSMutableStringAdditions.h

Date:			1/20/11

Version:		1.0

Authors:		soundcore

				Copyright 2011 soundcore
				All rights reserved worldwide.

Notes:			Header for NSMutableString+NSMutableStringAdditions

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

Dependencies:	Xcode 3.2.x,
				Cocoa/Foundation
				NSMutableString
				cb.h

Changes:		

1/20/11			MCA Initial version.

******************************************************************************/

// Classes

@interface NSMutableString ( NSMutableStringAdditions )

// Methods

- (NSMutableString*)appendTrailingComma;

- (NSMutableString*)appendTrailingCommaAndSpace;

- (NSMutableString*)appendTrailingSpace;

@end
