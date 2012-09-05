/******************************************************************************

File:			UIImageView+UIImageViewAdditions.h

Date:			12/19/09

Version:		1.1

Authors:		soundcore & Lane Roathe

				Copyright 2009 soundcore
				All rights reserved worldwide.

Notes:			Header for UIImageView+UIImageViewAdditions.m

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

11/20/09		MCA - Initial version.

12/19/09		MCA - Fixed comments and added Lane Roathe's
						-setImageFromContentsOfFile: method.

******************************************************************************/

#import <UIKit/UIKit.h>

@interface UIImageView ( UIImageViewAdditions )

- (UIImageView*)imageViewWithContentsOfFile:(NSString*)path;

- (void)setImageFromContentsOfFile:(NSString*)path;

@end
