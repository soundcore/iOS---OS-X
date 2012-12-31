/******************************************************************************

File:			UIEventAdditions.h

Date:			5/11/12

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Header for UIViewAdditions.m

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore. ANY SUCH DISTRIBUTION CARRIES SEVERE
				CRIMINAL AND CIVIL PENALTIES AND IS A VIOLATION OF
				INTERNATIONAL COPYRIGHT LAW. VIOLATORS WILL BE PROSECUTED
				TO THE FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	XCode 4.3.2+
				iPhone SDK 5.0+
				Fake GSEventProxy
 
Changes:		5/11/12 MCA - Initial version.

******************************************************************************/

#import <UIKit/UIKit.h>

// Faking GSEventProxy

@interface GSEventProxy : NSObject
{
	@public
	
	unsigned int flags;
	unsigned int type;
	unsigned int ignored1;
	float x1;
	float y1;
	float x2;
	float y2;
	unsigned int ignored2[10];
	unsigned int ignored3[7];
	float sizeX;
	float sizeY;
	float x3;
	float y3;
	unsigned int ignored4[3];
}
@end

// UIEvent category

@interface UIEvent (Creation)

- (id)_initWithEvent:(GSEventProxy*)fp8 touches:(id)fp12;

- (id)initWithTouch:(UITouch*)touch;

@end
