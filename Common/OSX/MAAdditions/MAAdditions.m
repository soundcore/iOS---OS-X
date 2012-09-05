#import <cb.h>

#import "MAAdditions.h"

#if TARGET_OS_IPHONE == 0

#import "NSWindow+NSWindowAdditions.h"
	
#pragma mark-
#pragma mark C Utils
#pragma mark-

///////////////////////////////////
// Return the height of the Dock.
///////////////////////////////////

CGFloat DockHeight( void )
{
	CGFloat		dockHeight = kFloatZero;
	
	dockHeight = ( ( [ [ NSScreen mainScreen ] frame ].size.height - [ [ NSScreen mainScreen ] visibleFrame ].size.height ) - kHardCodedMenuBarHeightHackSize );
	
	return dockHeight;
}

/////////////////////////////////////////////////////
// Return the height of the screen passed in.
// If screen passed in == nil, then use main screen.
/////////////////////////////////////////////////////

CGFloat ScreenHeight( NSScreen *screen )
{
	CGFloat screenHeight = kFloatZero;
	
	if( !screen )
	{
		screenHeight = [ [ NSScreen mainScreen ] frame ].size.height;
	}
	else
	{
		screenHeight = [ screen frame ].size.height;
	}
	
	return screenHeight;
}

#endif
