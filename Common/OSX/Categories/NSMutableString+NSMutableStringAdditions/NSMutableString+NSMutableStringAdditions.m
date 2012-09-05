/****************************************************************************

File:			NSMutableString+NSMutableStringAdditions.m

Date:			1/20/11

Version:		1.0

Authors:		soundcore

				Copyright 2011 soundcore
				All rights reserved worldwide.

Notes:			Implementation of NSMutableString+NSMutableStringAdditions

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

Dependencies:	See header

Changes:		See header

******************************************************************************/

#import <cb.h>

#import "NSMutableString+NSMutableStringAdditions.h"

@implementation NSMutableString ( NSMutableStringAdditions )

///////////////////////////////////////////////////////////////
// Given an NSMutableString, append a comma to the end of it.
// Also note string passed in cannot have zero length.
// Returned string may be different than one passed in.
///////////////////////////////////////////////////////////////

- (NSMutableString*)appendTrailingComma
{
	[ self appendString:kCommaStringKey ];
	
	return self;
}

//////////////////////////////////////////////////////////////////////
// Given an NSMutableString, append a comma & space to the end of it.
// Also note string passed in cannot have zero length.
// Returned string may be different than one passed in.
//////////////////////////////////////////////////////////////////////

- (NSMutableString*)appendTrailingCommaAndSpace
{
	[ self appendTrailingComma ];
		
	[ self appendTrailingSpace ];
	
	return self;
}

///////////////////////////////////////////////////////////////
// Given an NSMutableString, append a space to the end of it.
// Also note string passed in cannot have zero length.
// Returned string may be different than one passed in.
///////////////////////////////////////////////////////////////

- (NSMutableString*)appendTrailingSpace
{
	[ self appendString:kSpaceStringKey ];
	
	return self;
}

@end
