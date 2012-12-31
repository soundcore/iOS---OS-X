/******************************************************************************
 File:			UIEventAdditions.m
 
 Date:			5/11/12
 
 Version:		1.0
 
 Authors:		soundcore
 
				Copyright 2012 soundcore
				All rights reserved worldwide.
				 
				Implementation for UIEventAdditions
				 
				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.
				 
				WARNING: UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore. ANY SUCH DISTRIBUTION CARRIES SEVERE
				CRIMINAL AND CIVIL PENALTIES AND IS A VIOLATION OF
				INTERNATIONAL COPYRIGHT LAW. VIOLATORS WILL BE PROSECUTED
				TO THE FULL EXTENT OF INTERNATIONAL LAW.
 
 Dependencies:	XCode 4.3.2+
				iPhone SDK 5.0+
 
 Changes:		5/11/12 MCA - Initial version.
 ******************************************************************************/

#import "UIEventAdditions.h"

// Faking GSEventProxy

@implementation GSEventProxy
@end

// Category Implementation

@implementation UIEvent (Synthesize)

#pragma mark-
#pragma mark Faking UIEvent
#pragma mark-

///////////////////////////////////////////
// Generate a fake UIEvent from a UITouch.
///////////////////////////////////////////

- (id)initWithTouch:(UITouch*)touch
{
    CGPoint			location = [ touch locationInView:touch.window ];
    GSEventProxy	*gsEventProxy = [ [ GSEventProxy alloc ] init ];
    Class			touchesEventClass = { 0 };
	
	gsEventProxy->x1 = location.x;
    gsEventProxy->y1 = location.y;
    gsEventProxy->x2 = location.x;
    gsEventProxy->y2 = location.y;
    gsEventProxy->x3 = location.x;
    gsEventProxy->y3 = location.y;
    gsEventProxy->sizeX = 1.0;
    gsEventProxy->sizeY = 1.0;
    gsEventProxy->flags = ( [ touch phase ] == UITouchPhaseEnded ) ? 0x1010180 : 0x3010180;
    gsEventProxy->type = 3001;   
	
    // On SDK versions 3.0 and greater, we need to reallocate as a UITouchesEvent.
	
	touchesEventClass = NSClassFromString( @"UITouchesEvent" );
	
    if( touchesEventClass && ![ [ self class ] isEqual:touchesEventClass ] )
    {
        self = [ touchesEventClass alloc ];
    }
	
	if( ( self = [ self _initWithEvent:gsEventProxy touches:[ NSSet setWithObject:touch ] ] ) )
    {
    }
	
    return self;
}

@end
