/******************************************************************************

File:			MKMapViewAdditions.h

Date:			10/29/10

Version:		1.0

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Header for MKMapViewAdditions.m

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

Dependencies:	XCode 3.2+
				iPhone SDK 4.0+
Changes:		

10/20/10		MCA - Initial version.

******************************************************************************/

#import <UIKit/UIKit.h>

// Defines

#define kAddressLookupNetError									9999.0

#define kGoogleMapsAddressLookupStringWithAddressPlaceholder	@"http://maps.google.com/maps/geo?q=%@&output=csv"

#define MERCATOR_OFFSET											(CGFloat)268435456
#define MERCATOR_RADIUS											(CGFloat)85445659.44705395

// Classes

@interface MKMapView ( MKMapViewAdditions )

// Annotation lookup

//- (MapLocation*)annotationForCoordinate:(CLLocationCoordinate2D)coord;

// Address Conversion

- (CLLocationCoordinate2D)locationForAddress:(NSString*)addressToLookupString;

// Centering

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

@end
