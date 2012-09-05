/****************************************************************************

File:			UIImageView+UIImageViewAdditions.m

Date:			12/19/09

Version:		1.1

Authors:		soundcore & Lane Roathe

				Copyright 2009 soundcore
				All rights reserved worldwide.

Notes:			Implementation of UIImageView+UIImageViewAdditions

				See comments in header.

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

Dependencies:	XCode 3.1+
				iPhone SDK 3.0+

******************************************************************************/

#import "UIImageView+UIImageViewAdditions.h"

@implementation UIImageView ( UIImageViewAdditions )

////////////////////////////////////////////////////////////////
// Return an UIImageView from the image file located at 'path'.
////////////////////////////////////////////////////////////////

- (UIImageView*)imageViewWithContentsOfFile:(NSString*)path
{
	UIImage			*image = nil;
	UIImageView		*imageView = nil;
	
	if( path )
	{
		// Make sure image file exists...
		
		if( [ [ NSFileManager defaultManager ] fileExistsAtPath:path ] )
		{
			// Load image from file...
		
			image = [ UIImage imageWithContentsOfFile:path ];
			if( image )
			{
				// Make new UIImageView from image...
				
				imageView = [ [ UIImageView alloc ] initWithImage:image ];
			}
		}
	}
	
	return imageView;
}

//////////////////////////////////////////////////////////////////////////////////
// Change an existing UIImageView's image using the image file located at 'path'.
//////////////////////////////////////////////////////////////////////////////////

- (void)setImageFromContentsOfFile:(NSString*)path
{
	if( path )
	{
		// Make sure image file exists...
		
		if( [ [ NSFileManager defaultManager ] fileExistsAtPath:path ] )
		{
			// Set image from file...
		
			[ self setImage:[ UIImage imageWithContentsOfFile:path ] ];
		}
	}
}

@end
