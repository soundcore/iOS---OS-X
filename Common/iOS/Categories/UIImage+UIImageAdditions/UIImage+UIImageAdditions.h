/******************************************************************************

File:			UIImage+UIImageAdditions.h

Date:			2/26/11

Version:		1.1

Authors:		soundcore & Lane Roathe

				Copyright 2009 soundcore
				All rights reserved worldwide.

Notes:			Header for UIImage+UIImageAdditions.m

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

Dependencies:	XCode 3.1.3
				iPhone SDK 3.0+

Changes:		

2/26/11			MCA - Initial version.

******************************************************************************/

#import <UIKit/UIKit.h>

@interface UIImage ( UIImageAdditions )

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (UIImage*)roundCornerImage:(UIImage*)img withCornerWidth:(int)cornerWidth andCornerHeight:(int)cornerHeight;

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end

void addRoundedRectToPath( CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight );
