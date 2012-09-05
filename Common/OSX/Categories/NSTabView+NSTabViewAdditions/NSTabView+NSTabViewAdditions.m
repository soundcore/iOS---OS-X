/****************************************************************************

File:			NSTabView+NSTabViewAdditions.m

Date:			5/4/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore.
				All rights reserved worldwide.

Notes:			Implementation for NSTabView+NSTabViewAdditions

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore. ANY SUCH DISTRIBUTION CARRIES
				SEVERE CRIMINAL AND CIVIL PENALTIES AND IS A
				VIOLATION OF INTERNATIONAL COPYRIGHT LAW. VIOLATORS
				WILL BE PROSECUTED TO THE FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	See header.

Changes:		See header.

******************************************************************************/

#import "NSTabView+NSTabViewAdditions.h"

@implementation NSTabView ( NSTabViewAdditions )

///////////////////////////////////////////////////
// Amazingly, NSTabView has no selectedItemIndex
// method. But we almost always seem to need one
// and this method gives us that. If the index
// cannot be found, NSNotFound is returned.
// All tab item indicies are zero-based.
///////////////////////////////////////////////////

- (NSInteger)selectedTabItemIndex
{
	NSInteger		result = NSNotFound;
	NSTabViewItem	*item = nil;
	
	// See which tab is selected...
		
	item = [ self selectedTabViewItem ];
	if( item )
	{
		// Get index...
		
		result = [ self indexOfTabViewItem:item ];
	}
	
	return result;
}

/////////////////////////////////////////////////////////////
// Amazingly, NSTabView has no removeTabItemAtIndex method.
// All tab item indicies are zero-based.
/////////////////////////////////////////////////////////////

- (void)removeTabItemAtIndex:(NSInteger)itemIndex
{
	NSTabViewItem *item = nil;
	
	if( ( itemIndex >= 0 ) && ( itemIndex <= ( [ self numberOfTabViewItems ] - 1 ) ) )
	{
		// Get tab view item for itemIndex...
		
		item = [ self tabViewItemAtIndex:itemIndex ];
		if( item )
		{
			[ self removeTabViewItem:item ];
		}
	}
}

@end
