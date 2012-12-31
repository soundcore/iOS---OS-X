#import <cb.h>
#import <MAAdditions.h>

#import <NSScreen+NSScreenAdditions.h>
#import <NSWindow+NSWindowAdditions.h>

@implementation NSWindow ( NSWindowAdditions )

#pragma mark-
#pragma mark Window Utils
#pragma mark-

///////////////////////////////////////////////////////////////////////////////////////
// Size & move the window to best fit the window size/position for the main screen
// while leaving an acceptably large size around the window. This does not zoom the
// window to full size, but rather makes it a nice size for any given main screen
// size. We calc the padding distance at the top & bottom of the window based on the
// difference between the top of the screen & the top of the window - in other words,
// some % of 1/2 of the difference between window height & screen height (and width).
//
// In effect, this method auto-scales the default window size for any size display.
//
// This method is intended for use with utility, inspector, prefs, and other non-
// document windows. If you need best-position window cascading or centering for
// document windows, you should use NSDocument instead.
///////////////////////////////////////////////////////////////////////////////////////

- (void)bestDefaultWindowSizeAndPositionForMainScreenAndCenter:(BOOL)centerIt
{
	NSRect		windowFrameRect = kJustInitCGRectWithZerosFloat;
	NSRect		screenRect = kJustInitCGRectWithZerosFloat;
	
	CGFloat		windowHeight = kFloatZero;
	CGFloat		windowWidth = kFloatZero;
	CGFloat		screenHeight = ScreenHeight( nil );
	CGFloat		screenWidth = kFloatZero;
	
	CGFloat		windowScreenHeightDiff = kFloatZero;
	CGFloat		windowScreenWidthDiff = kFloatZero;
	
	CGFloat		distanceAboveWindow = kFloatZero;
	CGFloat		distanceLeftOfWindow = kFloatZero;
	
	CGFloat		newWindowHeight = kFloatZero;
	CGFloat		newWindowWidth = kFloatZero;
	
	NSRect		newWindowFrameRect = kJustInitCGRectWithZerosFloat;
	
	// Get window rect...
	
	windowFrameRect = [ self frame ];
	
	// Get the screen rect of the main display...
		
	screenRect = [ NSScreen mainScreenFrame ];
				
	// Get height & width of window & screen...
	
	windowHeight = ( windowFrameRect.size.height );
	
	windowWidth = ( windowFrameRect.size.width );
	
	screenWidth = ( screenRect.size.width );
	
	windowScreenHeightDiff = ( screenHeight - windowHeight );
	
	windowScreenWidthDiff = ( screenWidth - windowWidth );
	
	// Calc 1/2 distance of difference between window height & screen height...
	
	distanceAboveWindow = ( ( windowScreenHeightDiff / (CGFloat)2.0 ) - (CGFloat)kHardCodedMenuBarHeightHackSize );
	
	distanceAboveWindow = ( distanceAboveWindow * (CGFloat)1.75 );
	
	// Calc 1/2 distance of difference between window width & screen width...
	
	distanceLeftOfWindow = ( windowScreenWidthDiff /  (CGFloat)2.0 );
	
	// Calc new window height & width...
	
	newWindowHeight = ( windowHeight + distanceAboveWindow );
	
	newWindowWidth = ( windowWidth + distanceLeftOfWindow );
	
	// If window width is > max content width, limit to max content width...
		
	if( newWindowWidth > [ self contentMaxSize ].width )
	{
		newWindowWidth = [ self contentMaxSize ].width;
	}
	
	// Set new size (but only if max best fit has not been reached already)...
	
	if( ( screenHeight - windowHeight ) >= windowScreenHeightDiff )
	{
		newWindowFrameRect = NSMakeRect(	windowFrameRect.origin.x,
											windowFrameRect.origin.y,
											windowFrameRect.size.width,
											windowFrameRect.size.height	);
	
		newWindowFrameRect.size.height = newWindowHeight;
		
		newWindowFrameRect.size.width = newWindowWidth;
		
		[ [ self animator ] setFrame:newWindowFrameRect display:YES animate:NO ];
		
		if( centerIt )
		{
			CenterWindowOnScreen( self, nil, NO );
		}
	}
}

/////////////////////////////////////////////////////
// Gloom out the main window. Make sure not to
// call this more than once without turning it off
// or else weird effects might occur! bView MUST
// be an NSView in your window controller's class
// and it MUST be nil! Note that in an unusal
// design pattern, this method allocates bView
// inside the caller. For this reason the caller
// MUST set it to nil when done!
/////////////////////////////////////////////////////

- (void)gloomWindow:(NSNumber*)gloomIt windowsBlankingView:(NSView*)bView
{
	NSView			*v = [ self contentView ];
	CATransition	*animation = nil;
	CIFilter		*exposureFilter = nil;
	CIFilter		*saturationFilter = nil;
	CIFilter		*blurFilter = nil;
	CIFilter		*gloomFilter = nil;
	
	if( v && !bView )
	{
		if( [ gloomIt boolValue ] )
		{
			animation = [ CATransition animation ];
			
			[ animation setType:kCATransitionFade ];
			
			[ v setWantsLayer:YES ];
			
			[ [ v layer] addAnimation:animation forKey:@"layerAnimation" ];
			
			// The effect will be applied to this new view that we'll lay over the top  of everything else
			
			bView = [ [ NSView alloc ] initWithFrame:[ v bounds ] ];
			if( bView )
			{
				[ v addSubview:bView ];
				
				// Release since add above retains it...
				
				[ bView release ];
				
				// Construct the three effects
				
				exposureFilter = [ CIFilter filterWithName:@"CIExposureAdjust" ];
				
				[ exposureFilter setDefaults ];
				[ exposureFilter setValue:[ NSNumber numberWithDouble:kGloominputEV ] forKey:@"inputEV" ];
				
				saturationFilter = [ CIFilter filterWithName:@"CIColorControls" ];
				
				[ saturationFilter setDefaults ];
				[ saturationFilter setValue:[ NSNumber numberWithDouble:kGloominputSaturation ] forKey:@"inputSaturation" ];
				
				blurFilter = [ CIFilter filterWithName:@"CIGaussianBlur" ];
				
				[ blurFilter setDefaults ];
				[ blurFilter setValue:[ NSNumber numberWithFloat:kGloominputBlur ] forKey:@"inputRadius" ];
				
				gloomFilter = [ CIFilter filterWithName:@"CIGloom" ];
				
				[ gloomFilter setDefaults ];
				[ gloomFilter setValue:[ NSNumber numberWithDouble:kGloominputIntensity ] forKey:@"inputIntensity" ];
				
				// Apply the effects to the blankingView layer
				
				[ [ bView layer ] setBackgroundFilters:[ NSArray arrayWithObjects:exposureFilter, saturationFilter, blurFilter, gloomFilter, nil ] ] ;
			}
		}
		else
		{
			// Remove the CIFilter layer from the main window since we don't need it anymore...
								
			if( bView )
			{
				[ bView removeFromSuperview ];
			}
			
			[ v setWantsLayer:NO ];
			
			// Clean up...
			
			[ bView release ];
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////
// Return whether self is physically located within the bounds of the main screen or not.
//////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isOnMainScreen
{
	BOOL isOnMain = [ self isOnScreen:[ NSScreen mainScreen ] ];
	
	return isOnMain;
}

///////////////////////////////////////////////
// Return whether self is on 'screen' or not.
///////////////////////////////////////////////

- (BOOL)isOnScreen:(NSScreen*)screen
{
	NSRect	selfRect = kJustInitCGRectWithZeros;
	NSRect	screenRect2 = kJustInitCGRectWithZeros;
	BOOL	contains = NO;
	
	if( screen )
	{
		selfRect = [ self frame ];
		
		screenRect2 = [ screen frame ];
		
		contains = NSContainsRect( screenRect2, selfRect );
	}
	
	return contains;
}


////////////////////////////////////////////////////////////////////////////
// Same as makeKeyAndOrderFront: but with a fade in. You can replace any
// call to makeKeyAndOrderFront: with this to make a window fade in instead
// of appearing onscreen instantly.
////////////////////////////////////////////////////////////////////////////

- (void)makeKeyAndOrderFrontWithFadeIn:(id)sender
{
	if( ![ self isVisible ] )
	{
		[ self setAlphaValue: (CGFloat)0.0 ];
	}
	
	[ self makeKeyAndOrderFront:sender ];
	
	[ [ self animator ] setAlphaValue: (CGFloat)1.0 ];
}

////////////////////////////////////////////////////////////////////////
// Move the window to the upper left corner of the screen passed in.
// If nil is passed in, use the main screen. Do not change the window's
// frame  or bounds.
////////////////////////////////////////////////////////////////////////

- (void)moveWindowToUpperLeftScreenCorner:(NSScreen*)screen
{
	NSPoint newOrigin = kJustInitCGPointWithZeros;
	
	newOrigin = [ self perfectUpperLeftWindowScreenPointForScreen:screen ];
	
	// Move it...
		
	[ self setFrameOrigin:newOrigin ];
}

////////////////////////////////////////////////////////////////////////
// Move the window to the upper right corner of the screen passed in.
// If nil is passed in, use the main screen. Do not change the window's
// frame  or bounds.
////////////////////////////////////////////////////////////////////////

- (void)moveWindowToUpperRightScreenCorner:(NSScreen*)screen
{
	CGFloat		dockHeight = kFloatZero;
	
	NSRect		windowFrameRect = kJustInitCGRectWithZerosFloat;
	NSRect		screenRect = kJustInitCGRectWithZerosFloat;
	
	CGFloat		windowWidth = kFloatZero;
	CGFloat		windowHeight = kFloatZero;
	CGFloat		screenWidth = kFloatZero;
	CGFloat		screenHeight = ScreenHeight( nil );
	
	CGFloat		tBarHeight = kFloatZero;
	
	NSPoint		newOrigin = kJustInitCGPointWithZeros;
	
	// Get Dock height...
		
	dockHeight = DockHeight();
	
	// Get window rect...
		
	windowFrameRect = [ self frame ];
	
	if( screen )
	{
		// Get the screen rect of our display...
		
		screenRect = [ screen visibleFrame ];
	}
	else
	{
		// Get the screen rect of the main display...
		
		screenRect = [ [ NSScreen mainScreen ] visibleFrame ];
	}
	
	// Get window & screen sizes...
	
	windowWidth = windowFrameRect.size.width;
	
	windowHeight = windowFrameRect.size.height;
	
	screenWidth = screenRect.size.width;
	
	// Add dock height...
	
	screenHeight += dockHeight;
	
	// Calc new origin...
	
	newOrigin.x = ( ( screenWidth - windowWidth ) - (CGFloat)4.0 );
	
	// Calc the last # here from the window's title BAR height
	
	tBarHeight = [ self titleBarHeight ];
	
	newOrigin.y = ( screenHeight - windowHeight - kHardCodedMenuBarHeightHackSize - ( tBarHeight * 3.409090909090909 ) );		// As magic as it gets.
	
	// Move it...
		
	[ self setFrameOrigin:newOrigin ];
}

//////////////////////////////////////////////
// Move the window by the amounts passed in.
//////////////////////////////////////////////

- (void)offsetWindowByY:(NSUInteger)y andX:(NSUInteger)x animate:(BOOL)anim
{
	NSRect	windowFrameRect = kJustInitCGRectWithZerosFloat;
	
	// Get window rect...
		
	windowFrameRect = [ self frame ];
	
	// Adjust by amounts passed in...
	
	windowFrameRect.origin.y += y;
	
	windowFrameRect.origin.x += x;
	
	// Set it...
	
	[ self setFrame:windowFrameRect display:YES animate:anim ];
}

//////////////////////////////////////////////////////////////////
// Return the perfect upper left corner window positioning point.
// To use the main screen, pass nil to the 'screen' paramter.
//////////////////////////////////////////////////////////////////

- (NSPoint)perfectUpperLeftWindowScreenPointForScreen:(NSScreen*)screen
{
	#pragma unused( screen )
	
	NSRect		windowFrameRect = kJustInitCGRectWithZerosFloat;
	NSPoint		newOrigin = kJustInitCGPointWithZeros;
	CGFloat		dockHeight = kFloatZero;
	CGFloat		windowHeight = kFloatZero;
	CGFloat		screenHeight = ScreenHeight( nil );
	
	// Get Dock height...
		
	dockHeight = DockHeight();
	
	// Get window rect...
		
	windowFrameRect = [ self frame ];
	
	// Get window & screen sizes...
	
	windowHeight = windowFrameRect.size.height;
	
	// Add dock height...
	
	screenHeight += dockHeight;
	
	// Calc new origin...
	
	newOrigin.x = 10;
		
	newOrigin.y = ( screenHeight - windowHeight - dockHeight - kHardCodedMenuBarHeightHackSize - (CGFloat)10.0 );
	
	return newOrigin;
}

//////////////////////////////////////////////////////////////////////////
// Replace the kWindowTitlePlaceholderChar character in the window's
// title with the localized string indicated by stringKey from
// Localizable.strings.
//
// 'stringKey' should be a *key* into Localizable.strings.
//
// NOTE: This can only be sent once! Once the window title has
// been set, this method no longer does anything (unless you
// happen to have a window whose title has a kWindowTitlePlaceholderChar
// in it - in that case the kWindowTitlePlaceholderChar will be
// erroneously replaced, which would be an error).
///////////////////////////////////////////////////////////////////////////

- (void)replaceWindowTitlePlaceholderCharsWithLocalizedString:(NSString*)stringKey
{
	NSString			*windowTitle = nil;
	NSString			*replacementString = nil;
	NSMutableString		*newWindowTitle = nil;
	
	// Get the window's title...
		
	windowTitle = [ self title ];
	
	// Get string passed in...
	
	replacementString = NSLocalizedString( stringKey, kEmptyStringKey );
	
	if( windowTitle && replacementString )
	{
		// Make blank mutable string...
		
		newWindowTitle = [ NSMutableString stringWithCapacity:0 ];
		if( newWindowTitle )
		{
			// Append old window title to mutable string...
			
			[ newWindowTitle appendString:windowTitle ];
			
			// Replace the placeholder with the title passed in...
			
			[ newWindowTitle replaceOccurrencesOfString:kWindowTitlePlaceholderChar
								withString:replacementString
								options:0
								range:NSMakeRange( 0, [ newWindowTitle length ] ) ];
			
			// Set the new title back on the window...
		
			[ self setTitle:newWindowTitle ];
		}
	}
}

////////////////////////////////////////////////////////////////////////////////
// Suppose you are about to display a window. You either want to:
//
// 1) Center it if it has no previously saved position on screen.
//
// or
//
// 2) Move it to its previously saved window position if it has a user
// defaults key that was saved using saveFrameUsingName.
//
// This routine will do that for you.
//
// Pass in the name of the user defaults key used in your window's
// saveFrameUsingName code. If a previously saved value for that key already
// exists in user defaults, the window will be moved to that location. If not,
// the window will be centered on the main screen.
//
// If the window is currently visible, then this routine does nothing since
// moving the window around to its previously saved position or to the center
// while it is onscreen would look weird.
//
// If 'realCenter' is YES, then the window wiil be centered in the absolute
// center of the display. If NO, then the window will be centered using Cocoa's
// -center method, which actually puts the window slightly higher than center.
//
// If you want a slick zoom animation, pass in a rect where you want the
// animation to start FROM, else pass in a rect containing ALL ZEROS for NO
// animation and to use the centering rect or the last saved rect.
////////////////////////////////////////////////////////////////////////////////

- (void)restoreLastSavedWindowPositionForDefaultsKeyOrCenter:(NSString*)defaultsStringKey fromRect:(NSRect)startingZoomRect compensateForDockHeight:(BOOL)compensate
{
	CAKeyframeAnimation		*zoomAnimation = nil;
	NSRect					windowFrameRect = kJustInitCGRectWithZerosFloat;
	CGMutablePathRef		zoomPath = NULL;
	CGPathRef				path = NULL;
			
	// Center or restore last position...
	
	if( ![ self isVisible ] )
	{
		CenterWindowOnScreen( self, nil, compensate );
		
		////////////////////////////////////////////////////////
		// Move window to last saved location & size (if any).
		// This does nothing if there is not already a
		// defaultsStringKey in the user defaults.
		////////////////////////////////////////////////////////

		if( defaultsStringKey )
		{
			(void)[ self setFrameUsingName:defaultsStringKey ];
		}
		
		/////////////////////////////////////////////////////////////////////////////////////
		// If the size values of the passed-in rect are NOT zeros, do a zoom animation...
		/////////////////////////////////////////////////////////////////////////////////////
		
		if( ( ( startingZoomRect.size.width ) || ( startingZoomRect.size.height ) ) && zoomAnimation )
		{
			// Make keyframe animation...
	
			zoomAnimation = [ CAKeyframeAnimation animation ];
	
			zoomAnimation.duration = 3.0;
	
			// Get *current* window frame rect which we will use later to know where the window dest is...
		
			windowFrameRect = [ self frame ];
			
			// Set the window *initial* size & origin to that of startingZoomRect...
			
			[ self setFrameOrigin:startingZoomRect.origin ];
			
			[ self setFrame:startingZoomRect display:YES animate:NO ];
			
			// Show it...
				
			[ self makeKeyAndOrderFront:self ];
			
			// Determine the animation's path.
			
			// TODO:
			NSPoint startPoint = NSMakePoint(startingZoomRect.origin.x + startingZoomRect.size.width / 4, startingZoomRect.origin.y + startingZoomRect.size.height / 4);
			NSPoint curvePoint1 = NSMakePoint(startPoint.x, startPoint.y + 100);
			NSPoint endPoint = NSMakePoint(windowFrameRect.origin.x, windowFrameRect.size.height - windowFrameRect.origin.y - windowFrameRect.size.height);
			NSPoint curvePoint2 = NSMakePoint(endPoint.x + 200, endPoint.y);

			// Create the animation's path.
			
			zoomPath = CGPathCreateMutable();
			CGPathMoveToPoint(zoomPath, NULL, startPoint.x, startPoint.y);
			CGPathAddCurveToPoint(zoomPath, NULL, curvePoint1.x, curvePoint1.y,
			curvePoint2.x, curvePoint2.y, endPoint.x, endPoint.y);
			path = CGPathCreateCopy(zoomPath);
			CGPathRelease(zoomPath);
		
			zoomAnimation.delegate = self;
			zoomAnimation.path = path;
			zoomAnimation.timingFunction = [ CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn ];
			// TODO: Constant needed here
			[ self setAnimations:[ NSDictionary dictionaryWithObject:zoomAnimation forKey:@"frameOrigin" ] ];
			
			[ [ self animator ] setFrameOrigin:endPoint ];
		}
	}
}

/////////////////////////////////////////////////////
// Return the NSWinow's titlebar height, in pixels.
/////////////////////////////////////////////////////

- (float)titleBarHeight
{
    NSRect	frame = NSMakeRect( 0.0, 0.0, 100.0, 100.0 );
	NSRect	contentRect = NSZeroRect;
	float	height = kFloatZero;
	
    contentRect = [ NSWindow contentRectForFrameRect:frame styleMask:NSTitledWindowMask ];

    height = ( frame.size.height - contentRect.size.height );
	
	return height;

}

///////////////////////////////////////////////////////////////////////
// Zoom the window to the perfect fit for the max size of the display.
///////////////////////////////////////////////////////////////////////

- (void)zoomToMaxBestFitSizeForMainScreen
{
	NSRect		windowFrameRect = kJustInitCGRectWithZerosFloat;
	NSRect		screenRect = kJustInitCGRectWithZeros;
	NSPoint		originPoint = kJustInitCGPointWithZeros;
	NSUInteger	newWindowHeight = 0;
	NSUInteger	newWindowWidth = 0;

	// Get dimensions...
		
	screenRect = [ NSScreen mainScreenFrame ];
			
	// Adjust y axis for Dock height...
	
	originPoint.y += DockHeight();
	
	// Adjust left x axis for inset from left side of display..
	
	originPoint.x += kPerfectDisplayInsetInPixels;
	
	// Move window origin to lower left...
			
	[ self setFrameOrigin:originPoint ];
			
	// Calc perfect size rectangle for max main screen size...
	
	newWindowHeight = (NSUInteger)( [ [ NSScreen mainScreen ] visibleFrame ].size.height - kPerfectDisplayInsetInPixels );
	
	newWindowWidth = (NSUInteger)( screenRect.size.width - ( kPerfectDisplayInsetInPixels * 2 ) );
	
	// Update window frame with new values...
	
	windowFrameRect = [ self frame ];
			
	windowFrameRect.size.height = newWindowHeight;
	
	windowFrameRect.size.width = newWindowWidth;
	
	// Set it...
	
	[ self setFrame:windowFrameRect display:YES animate:NO ];
}

@end

#pragma mark-
#pragma mark C Protos
#pragma mark-

///////////////////////////////////////////////////////////////////////
// Center the window passed in on the screen passed in. If screen
// is nil, use the main screen. This should be rolled into some
// Obj-C util class, rather than as a stand-alone C routine. Or better
// yet, a category on NSWindow. Unlike NSWindow's -center method,
// which actually places the window slightly higher than center, this
// routine really centers it.
///////////////////////////////////////////////////////////////////////

void CenterWindowOnScreen( NSWindow *window, NSScreen *screen, BOOL compensateForDockHeight )
{
	#pragma unused( compensateForDockHeight )
	
	CGFloat		titleBarHeight = kFloatZero;
	NSRect		screenRect = kJustInitCGRectWithZerosFloat;
	NSRect		windowFrameRect = kJustInitCGRectWithZerosFloat;
	NSRect		windowContentRect = kJustInitCGRectWithZerosFloat;
	NSPoint		newOrigin;
	
	memset( &newOrigin, 0, sizeof( newOrigin ) );
	
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
		
		newOrigin.x = ( screenRect.origin.x + ( screenRect.size.width / (CGFloat)2.0 ) );
		
		newOrigin.y = ( screenRect.origin.y + ( screenRect.size.height / (CGFloat)2.0 ) );
		
		////////////////////////////////////////////////////////////////////
		// We need to take into account the width & height of the window
		// itself & menubar & window title height and subtract them out...
		////////////////////////////////////////////////////////////////////
		
		newOrigin.x -= ( windowFrameRect.size.width / (CGFloat)2.0 );
		
		newOrigin.y -= ( ( windowFrameRect.size.height / (CGFloat)2.0 ) - kHardCodedMenuBarHeightHackSize );
		
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
