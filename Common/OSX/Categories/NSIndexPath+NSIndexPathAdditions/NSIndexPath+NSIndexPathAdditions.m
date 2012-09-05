/****************************************************************************

File:			NSIndexPath+NSIndexPathAdditions.m

Date:			1/26/11

Version:		1.0

Authors:		soundcore

				Copyright 2011 soundcore
				All rights reserved worldwide.

Notes:			NSIndexPath+NSIndexPathAdditions

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

Changes:		See header.

******************************************************************************/

#import <NSIndexPath+NSIndexPathAdditions.h>

@implementation NSIndexPath ( NSIndexPathAdditions )

//////////////////////////////////////////////////////////////////////////
// Given an NSIndexPath and an index into it, return that index's value.
//////////////////////////////////////////////////////////////////////////

- (NSUInteger)indexPathValueforIndex:(NSUInteger)arrayIndex
{
	NSUInteger indexValue = 0;
	
	if( arrayIndex )
	{
		NSUInteger	indicies[ [ self length ] ];
		
		memset( indicies, 0, sizeof( indicies ) );
		
		// Get path indicies - we want only item #1 in the returned array...
						
		[ self getIndexes:indicies ];

		// Get just the value of array item #1 from the indicies array...

		indexValue = indicies[ arrayIndex ];
	}
	
	return indexValue;
}

@end
