/******************************************************************************

File:			UINavigationBar+UINavigationBarAdditions.h

Date:			2/6/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Header for UINavigationBar+UINavigationBarAdditions.m

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

#import <UIKit/UIKit.h>

// Defines

#define kNavigationBarBackgroundImageFileName	@"gojira.png"

// Categories

@interface UINavigationBar ( UINavigationBarAdditions )

- (void)drawRect:(CGRect)rect;

@end
