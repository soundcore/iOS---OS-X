/****************************************************************************

File:			NSArray+NSArrayAdditions.m

Date:			10/12/10

Version:		1.0

Authors:		Michael Amorose

				Copyright 2010 Michael Amorose
				All rights reserved worldwide.

Notes:			Implementation for NSArray+NSArrayAdditions

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF MICHAEL AMOROSE.

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE FULL EXTENT OF
				INTERNATIONAL LAW.

Dependencies:	See header.

Changes:		

10/12/10		MCA Initial version.

******************************************************************************/

#import <NSArray+NSArrayAdditions.h>

@implementation NSArray ( NSArrayAdditions )

/////////////////////////////////////////////////////
// Just a wrappper for objectAtIndex. This prevents
// crashes in the event of an empty array.
/////////////////////////////////////////////////////

- (id)objectAtIndexSafe:(NSUInteger)objIndex
{
	id object = nil;
	
	if( ( objIndex <= [ self count ] ) )
	{
		// Make sure the array has something in it first...
		
		if( ( [ self count ] >= 1 ) )
		{
			// Now get the object...
			
			object = [ self objectAtIndex:objIndex ];
		}
	}
	
	return object;
}

@end
