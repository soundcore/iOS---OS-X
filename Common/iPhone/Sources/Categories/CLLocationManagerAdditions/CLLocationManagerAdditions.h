/******************************************************************************

File:			CLLocationManagerAdditions.h

Date:			11/12/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Header for CLLocationManagerAdditions.m

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

Dependencies:	XCode 3.2
				iPhone SDK 4.0+
Changes:		

11/12/10		MCA - Initial version.

******************************************************************************/

#import <UIKit/UIKit.h>

// Protocols

@interface CLLocationManager ( CLLocationManagerAdditions )

- (BOOL)headingServicesAvailable;

- (BOOL)locationServicesAvailable;

@end
