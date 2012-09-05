#import "MASpeedometerView.h"

@implementation MASpeedometerView

#pragma mark-
#pragma mark Init & Term (Required Overrides)
#pragma mark-

//////////////////////////////
// - 'init' message override.
//////////////////////////////

- (id)init
{
	self = [ super init ];
	if( self )
	{
	}
	
	return self;
}

///////////////////////////////////////
// - 'initWithFrame' message override.
///////////////////////////////////////

- (id)initWithFrame:(NSRect)frame
{
	NSImage	*nsImage = nil;
	// CALayer	*nLayer = nil;
	
	// Set up all the crap we need to draw the dial...
	
	self = [ super initWithFrame:frame ];
	if( self )
	{
		// Load dial background image from disk...
		
		nsImage = [ NSImage imageNamed:kSpeedometerBackingImageFileName ];
		if( nsImage )
		{
			[ nsImage setBackgroundColor:[ NSColor clearColor ] ];
			
			[ self setDialImage:[ nsImage copy ] ];
		}
		
		
		// TODO: Make a CALayer the size of our view to use as the overlay needle
		// Also clear in dealloc
		//[ self setWantsLayer:YES ];
		
		
		// Start needle angle so it looks like it's at "zero" on a speedometer...
		
		[ self setNeedleAngle:202.50 ];
	}
	
	return self;
}

/////////////////////////////////
// - 'dealloc' message override.
/////////////////////////////////

- (void)dealloc
{
	//[ needleLayer release ];
	
	[ dialImage release ];
	
	dialImage = nil;
	
	[ super dealloc ];
}

//////////////////
// -awakeFromNib
//////////////////

- (void)awakeFromNib
{
}

#pragma mark-
#pragma mark Drawing
#pragma mark-

//////////////////////////////////////
// - 'drawRect' message override.
// Draw the background, then the
// needle at the current needle angle.
// If dialImage hasn't been set
// we don't draw anything.
//////////////////////////////////////

- (void)drawRect:(NSRect)rect
{
	if( dialImage )
	{
		NSRect viewBounds = [ self bounds ];
		NSSize imageSize = [ dialImage size ];
		
		// Draw dial background...
		
		[ dialImage drawInRect:NSMakeRect( kFloatZero, kFloatZero, viewBounds.size.width, viewBounds.size.height )
					fromRect:NSMakeRect( kFloatZero, kFloatZero, imageSize.width, imageSize.height )
					operation:NSCompositeSourceOver
					fraction:kTotallyOpaque ];
	}
}

#pragma mark-
#pragma mark Getters
#pragma mark-

- (NSImage*)dialImage
{
	return dialImage;
}

- (CALayer*)needleLayer
{
	return needleLayer;
}

- (double)needleAngle
{
	return needleAngle;
}

- (double)lastSpeed;
{
	return lastSpeed;
}

- (double)currentSpeed;
{
	return currentSpeed;
}

#pragma mark-
#pragma mark Setters
#pragma mark-

- (void)setDialImage:(NSImage*)newImage
{
	if( newImage )
	{
		[ newImage retain ];
	}
	
	[ dialImage release ];
	
	dialImage = newImage;
}

- (void)setNeedleLayer:(CALayer*)newLayer
{
	if( newLayer )
	{
		[ newLayer retain ];
	}
	
	[ needleLayer release ];
	
	needleLayer = newLayer;
}

- (void)setLastSpeed:(double)newLastSpeed
{
	lastSpeed = newLastSpeed;
}

- (void)setCurrentSpeed:(double)newCurrentSpeed
{
	currentSpeed = newCurrentSpeed;
}

- (void)setNeedleAngle:(double)newAngle
{
	needleAngle = newAngle;
}

@end
