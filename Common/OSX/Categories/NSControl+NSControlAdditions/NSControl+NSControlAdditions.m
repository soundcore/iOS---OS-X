/****************************************************************************

File:			NSControl+NSControlAdditions.m

Date:			2/13/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Implementation for NSControl+NSControlAdditions

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

Changes:		

2/13/10			MCA Initial version.

******************************************************************************/

#import <NSControl+NSControlAdditions.h>

@implementation NSControl ( NSControlAdditions )

/////////////////////////////////////////////////////
// Just a wrappper for setEnabled & setNeedsDisplay
/////////////////////////////////////////////////////

- (void)setEnabledAndDisplay:(BOOL)enable
{
	[ self setEnabled:enable ];
			
	[ self setNeedsDisplay:YES ];
}

/////////////////////////////////////////////////////
// Just a wrappper for setHidden & setNeedsDisplay
/////////////////////////////////////////////////////

- (void)setHiddenAndDisplay:(BOOL)hide
{
	[ self setHidden:hide ];
			
	[ self setNeedsDisplay:YES ];
}

//////////////////////////////////////////////////////////
// Set a control's string value and enable or disable it.
//////////////////////////////////////////////////////////

- (void)setStringValue:(NSString*)string andSetEnabledAndDisplay:(BOOL)enable
{
	NSAutoreleasePool *pool = nil;
		
	pool = [ [ NSAutoreleasePool alloc ] init ];
	
	if( string )
	{
		[ self setStringValue:string ];
	}
	
	[ self setEnabledAndDisplay:enable ];
	
	[ pool release ];
}

////////////////////////////////////////////////////////
// Set a control's string value and display or hide it.
////////////////////////////////////////////////////////

- (void)setStringValue:(NSString*)string andSetHiddenAndDisplay:(BOOL)hide
{
	NSAutoreleasePool *pool = nil;
		
	pool = [ [ NSAutoreleasePool alloc ] init ];
	
	if( string )
	{
		[ self setStringValue:string ];
	}
	
	[ self setHiddenAndDisplay:hide ];
	
	[ pool release ];
}

///////////////////////////////////////////////////////////////////
// Set a control's string value, display/hide, enable/disable it.
///////////////////////////////////////////////////////////////////

- (void)setStringValue:(NSString*)string andSetEnabledAndDisplay:(BOOL)enable andSetHiddenAndDisplay:(BOOL)hide
{
	NSAutoreleasePool *pool = nil;
		
	pool = [ [ NSAutoreleasePool alloc ] init ];
	
	if( string )
	{
		[ self setStringValue:string ];
	}
	
	[ self setEnabledAndDisplay:enable ];
	
	[ self setHiddenAndDisplay:hide ];
	
	[ pool release ];
}

@end