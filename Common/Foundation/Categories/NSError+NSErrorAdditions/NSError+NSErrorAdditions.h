/****************************************************************************

File:			NSError+NSErrorAdditions.h

Date:			3/6/12

Version:		1.0

Authors:		soundcore

				Copyright 2012 soundcore
				All rights reserved worldwide.

Notes:			Header for NSError+NSErrorAdditions.m

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore. ANY SUCH DISTRIBUTION CARRIES
				SEVERE CRIMINAL AND CIVIL PENALTIES AND IS A
				VIOLATION OF INTERNATIONAL COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE FULL EXTENT OF
				INTERNATIONAL LAW.

Dependencies:	Cocoa, Xcode 4.2+.

Changes:		3/6/12 MCA Initial version.

******************************************************************************/

// Classes

@interface NSError ( NSErrorAdditions )

// Utils

+ (NSError*)simpleErrorFromDomain:(NSString*)domain andCode:(NSInteger)theCode andLocalizedDescription:(NSString*)localizedDescription;

- (NSError*)simpleErrorFromDomain:(NSString*)domain andCode:(NSInteger)theCode andLocalizedDescription:(NSString*)localizedDescription;

@end
