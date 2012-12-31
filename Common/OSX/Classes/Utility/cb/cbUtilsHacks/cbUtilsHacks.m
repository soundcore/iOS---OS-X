/*****************************************************************************

File:			cbUtilsHacks.m

Date:			9/29/08

Version:		1.0

Authors:		soundcore

				Copyright 2009 by Code Beauty, LLC
				All rights reserved worldwide.

Notes:			See comment in header.
								
				Set tab width and indent width both to 4 In Project Builder's
				or XCode's Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF CODE BEAUTY, LLC

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE
				FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	XCode 2.5 as of this writing.

Changes:		

9/29/08			MCA Initial version.

******************************************************************************/

#import <cbUtilsHacks.h>

#import <cb.h>

//////////////////////////////////////////////////////////////////////
// Center the window passed in on the screen passed in. If screen
// is nil, use the main display.
//////////////////////////////////////////////////////////////////////

void CenterWindowOnScreen( NSWindow *window, NSScreen *screen )
{
	unsigned	titleBarHeight = 0;
	NSRect		screenRect = { { 0.0, 0.0 }, { 0.0, 0.0 } };
	NSRect		windowFrameRect = { { 0.0, 0.0 }, { 0.0, 0.0 } };
	NSRect		windowContentRect = { { 0.0, 0.0 }, { 0.0, 0.0 } };
	NSPoint		newOrigin = { 0.0, 0.0 };
	
	if( window )
	{
		// Get window rect...
		
		windowFrameRect = [ window frame ];
		
		if( screen )
		{
			// Get the screen rect of our display...
			
			screenRect = [ screen visibleFrame ];
		}
		else
		{
			// Get the screen rect of our main display...
			
			screenRect = [ [ NSScreen mainScreen ] visibleFrame ];
		}
					
		// Calc center of screen rect...
		
		newOrigin.x = ( screenRect.origin.x + ( screenRect.size.width / 2.0 ) );
		
		newOrigin.y = ( screenRect.origin.y + ( screenRect.size.height / 2.0 ) );
		
		////////////////////////////////////////////////////////////////////
		// We need to take into account the width & height of the window
		// itself & menubar & window title height and subtract them out...
		////////////////////////////////////////////////////////////////////
		
		newOrigin.x -= ( windowFrameRect.size.width / 2.0 );
		
		newOrigin.y -= ( ( windowFrameRect.size.height / 2.0 ) - kHardCodedMenuBarHeightHackSize );
		
		// If the window has a title bar, also subtract out its height...
		
		if( [ window styleMask ] != NSBorderlessWindowMask )
		{
			// Frame rect height - content rect height...
			
			windowContentRect = [ window contentRectForFrameRect:windowFrameRect ];
			
			titleBarHeight = ( windowFrameRect.size.height - windowContentRect.size.height );
			
			newOrigin.y += ( titleBarHeight );
		}
		
		// Move it...
		
		[ window setFrameOrigin:newOrigin ];
	}
}