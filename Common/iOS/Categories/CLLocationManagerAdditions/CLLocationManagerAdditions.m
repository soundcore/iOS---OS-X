/****************************************************************************

File:			CLLocationManagerAdditions.m

Date:			11/12/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Implementation of CLLocationManagerAdditions.

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

******************************************************************************/

#import "CLLocationManagerAdditions.h"
#import "UIDeviceAdditions.h"

#import <cb.h>

@implementation CLLocationManager ( CLLocationManagerAdditions )

////////////////////////////////////
// See if we have headingAvailable.
////////////////////////////////////
	
- (BOOL)headingServicesAvailable
{
	BOOL	headingsAvail = NO;
	double	osVersion = 0.0;
	
	osVersion = [ [ UIDevice currentDevice ].systemVersion floatValue ];
	if( ( osVersion >= 4.0 ) )
	{
		headingsAvail = [ CLLocationManager headingAvailable ];
	}
	else
	{
		headingsAvail = [ CLLocationManager headingAvailable ];
	}
		
	return headingsAvail;
}

//////////////////////////////////////////////
// See if location services are available.
//////////////////////////////////////////////
	
- (BOOL)locationServicesAvailable
{
	BOOL	locsAvail = NO;
	double	osVersion = 0.0;
	
	osVersion = [ [ UIDevice currentDevice ].systemVersion floatValue ];
	if( ( osVersion >= 4.0 ) )
	{
		#ifdef __IPHONE_4_0
		locsAvail = [ CLLocationManager locationServicesEnabled ];
		#endif
	}
	else
	{
		#ifdef __IPHONE_3_0
		locsAvail = [ CLLocationManager locationServicesEnabled ];
		#endif
	}
		
	return locsAvail;
}

@end
