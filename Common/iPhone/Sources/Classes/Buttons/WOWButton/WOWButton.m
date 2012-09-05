/******************************************************************************

File:			WOWButton.m

Date:			9/26/09

Version:		1.0

Authors:		See header.

Notes:			Implementation of WOWButton.

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

Dependencies:	See header.

Changes:		

9/26/09			See header.

******************************************************************************/

#import <cb.h>

#import "WOWButton.h"

@implementation WOWButton

@synthesize
animationDuration,
animatedButtonImagesArray;

+ (id)buttonWithType:(UIButtonType)buttonType
{
	if( ( self = [ super buttonWithType:buttonType ] ) )
	{
	}
	
    return self;
}

/////////////////////////////////////////
// Overide of UIView's -initWithFrame:
/////////////////////////////////////////

- (id)initWithFrame:(CGRect)frameRect
{
	if( ( self = [ super initWithFrame:frameRect ] ) )
	{
	}
	
    return self;
}

/////////////
// Clean up.
/////////////

- (void)dealloc
{
	[ self stopAnimating ];
	
	// Unload images array...
	
	if( self.animatedButtonImagesArray )
	{
		[ self.animatedButtonImagesArray release ];
	}

	[ super dealloc ];
}

///////////////////////////////
// Start animating the button
///////////////////////////////

- (void)startAnimating
{
	NSUInteger	i = 0;
	
	// Set the animation duration...
		
	self.animationDuration = kWOWButtonAnimationDurationInSeconds;
	
	/////////////////////////////////////////////////
	// Create UIImages array for animated button...
	/////////////////////////////////////////////////
	
	if( !self.animatedButtonImagesArray )
	{
		self.animatedButtonImagesArray = [ [ NSMutableArray alloc ] initWithCapacity:0 ];
		if( self.animatedButtonImagesArray )
		{
			/////////////////////
			// Load new images...
			/////////////////////
			
			for( i = 0; i < kNumImagesInButtonArray; i++ )
			{
				NSMutableString		*fileName = nil;
				NSNumber			*fileNameNum = nil;
				NSString			*imagePathString = nil;
				UIImage				*nextImage = nil;
				
				// Make mutable string to hold file name...
				
				fileName = [ NSMutableString stringWithCapacity:0 ];
				if( fileName )
				{
					// Convert loop counter to NSNumber string & append to string...
					
					fileNameNum = [ NSNumber numberWithInt:( i + 1 ) ];
					if( fileNameNum )
					{
						[ fileName appendString:[ fileNameNum stringValue ] ];
						
						// Append kWOWButtonFilenameSuffixString to string...
						
						[ fileName appendString:kWOWButtonFilenameSuffixString ];
						
						// Make path string for this file...
						
						imagePathString = [ [ NSBundle mainBundle ] pathForResource:fileName ofType:kPNGFilenameExtension ];
						if( imagePathString )
						{
							// Load image @ this path...
						
							nextImage = [ [ UIImage alloc ] initWithContentsOfFile:imagePathString ];
							if( nextImage )
							{
								// Add to array...
								
								[ self.animatedButtonImagesArray addObject:nextImage ];
								
								[ nextImage release ];
							}
						}
					}
				}
			}
		}
	}
	
	// Set images array into animationImages property on the button...
	
	if( self.imageView )
	{
		self.imageView.animationImages = self.animatedButtonImagesArray;
		
		// Start animating the button...
	
		[ self.imageView startAnimating ];
	}
}

//////////////////////////////
// Stop animating the button
//////////////////////////////

- (void)stopAnimating
{
	// Stop any animation...
	
	if( self.imageView )
	{
		[ self.imageView stopAnimating ];
			
		// Clear images array into animationImages property on the button...
		
		self.imageView.animationImages = nil;
	}
}
	
@end