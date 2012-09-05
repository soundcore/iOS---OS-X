#import "MAGradientView.h"

@implementation MAGradientView

@synthesize
startingColor,
endingColor,
angle;

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
	NSColor *c = nil;
	
	self = [ super initWithFrame:frame ];
	if( self )
	{
		c = [ [ NSColor colorWithCalibratedWhite:1.0 alpha:1.0 ] copy ];
		
		self.startingColor = c;
		
		[ c release ];
		
		self.angle = 270.0;
	}
	
	return self;
}

/////////////////////////////////
// - 'dealloc' message override.
/////////////////////////////////

- (void)dealloc
{
	self.startingColor = nil;
	
	self.endingColor = nil;
	
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

//////////////////////////////////
// - 'drawRect' message override.
//////////////////////////////////

- (void)drawRect:(NSRect)rect
{
	NSGradient *aGradient = nil;
	
	if( ( self.endingColor == nil || [ self.startingColor isEqual:self.endingColor ] ) )
	{
		// Fill view with a standard background color
		
		[ self.startingColor set ];
		
		NSRectFill( rect );
	}
	else
	{
		// Fill view with a top-down gradient from startingColor to endingColor...
		
		aGradient = [ [ NSGradient alloc ] initWithStartingColor:self.startingColor endingColor:self.endingColor ];
		
		[ aGradient drawInRect:self.bounds angle:self.angle ];
		
		[ aGradient release ];
	}
}

@end
