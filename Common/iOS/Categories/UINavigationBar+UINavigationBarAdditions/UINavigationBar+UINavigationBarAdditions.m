/******************************************************************************

File:			UINavigationBar+UINavigationBarAdditions.h

Date:			2/6/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Implementaion for UINavigationBarAdditions

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore.

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE
				FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	XCode 3.2.1
				iPhone SDK 3.1+
Changes:		

2/6/10			MCA - Initial version.

******************************************************************************/

#import "UINavigationBar+UINavigationBarAdditions.h"

@implementation UINavigationBar ( UINavigationBarAdditions )

////////////////////////////////////////////////////////////////
// Draw a .png image as the background of UINavigationBars
// Use this to draw a UINavigationBar with a custom background
// image. Note that including this category in your project
// will cause ALL UINavigationBars to have a clear background
// unless you set its image. Your project must also include a
// .png file named kNavigationBarBackgroundImageFileName
////////////////////////////////////////////////////////////////

- (void)drawRect:(CGRect)rect
{
	// Load the image...
	
	UIImage *image = nil;
	
	image = [ UIImage imageNamed:kNavigationBarBackgroundImageFileName ];
	if( image )
	{
		// Draw .png...
		
		[ image drawInRect:CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height ) ];
	}
	else
	{
		// Draw grey background if image failed to load...
		
		[ super drawRect:rect ];
	}
}
 
@end
