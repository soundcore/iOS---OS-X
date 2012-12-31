/****************************************************************************

File:			NSNumber+NSNumberAdditions.h

Date:			12/23/11

Version:		1.0

Authors:		soundcore

				Copyright 2011 soundcore
				All rights reserved worldwide.

Notes:			Header for NSNumber+NSNumberAdditions

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore. ANY SUCH DISTRIBUTION CARRIES
				SEVERE CRIMINAL AND CIVIL PENALTIES AND IS A
				VIOLATION OF INTERNATIONAL COPYRIGHT LAW. VIOLATORS
				WILL BE PROSECUTED TO THE FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	HDTUtils.cp

Changes:		12/7/09	MCA Initial version.

******************************************************************************/

// Interfaces

@interface NSNumber ( NSNumberAdditions )

// Methods

+ (NSNumber*)stringToNumber:(NSString*)_inStr base:(int)_base;

- (NSString*)capacityWithLabelStringOptionallyTruncatingToTwoDecimalPlaces:(BOOL)truncate;

@end
