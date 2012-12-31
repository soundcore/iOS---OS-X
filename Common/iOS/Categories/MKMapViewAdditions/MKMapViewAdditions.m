/****************************************************************************

File:			MKMapViewAdditions.m

Date:			10/29/10

Version:		1.1

Authors:		soundcore

				Copyright 2010 soundcore
				All rights reserved worldwide.

Notes:			Implementation of MKMapViewAdditions

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

#import <NSArray+NSArrayAdditions.h>
#import "MKMapViewAdditions.h"

#import <cb.h>

@implementation MKMapView ( MKMapViewAdditions )

#pragma mark Annotation lookup

////////////////////////////////////////////////////////
// Iterate through the map view's list of coordinates
// and return the first one whose coordinate matches
// the specified value exactly.
////////////////////////////////////////////////////////
	
/* - (MapLocation*)annotationForCoordinate:(CLLocationCoordinate2D)coord
{
	id<MKAnnotation> theObj = nil;
	
	for( id obj in [ self annotations ] )
	{
		if( ( [ obj isKindOfClass:[ MapLocation class ] ] ) )
		{
			MapLocation* anObj = (MapLocation*)obj;
			
			if( ( anObj.coordinate.latitude == coord.latitude ) && ( anObj.coordinate.longitude == coord.longitude ) )
			{
				theObj = anObj;
				
				break;
			}
		}
	}
	
	return theObj;
} */

#pragma mark Address Conversion

//////////////////////////////////////////////////////////////////////////////
// Return a CLLocationCoordinate2D for the address string passed in.
// If we get an error, set the returned lat & long to kAddressLookupNetError.
//////////////////////////////////////////////////////////////////////////////

- (CLLocationCoordinate2D)locationForAddress:(NSString*)addressToLookupString
{
	CLLocationCoordinate2D	foundLocationCoords = { kAddressLookupNetError, kAddressLookupNetError };
	NSString				*urlString = nil;
	NSString				*locationString = nil;
	NSArray					*foundItemsArray = nil;
	NSURL					*googleMapsNSURL = nil;
	NSString				*qS = NULL;
	
	if( addressToLookupString )
	{
		// Make Google Maps URL string...
		
		urlString = [ NSString stringWithFormat:kGoogleMapsAddressLookupStringWithAddressPlaceholder, [ addressToLookupString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ] ];
		if( urlString )
		{													
			// Make URL...
			
			googleMapsNSURL = [ NSURL URLWithString:urlString ];
			if( googleMapsNSURL )
			{
				// Get location string from Google...
				// TODO: Make this threaded
				
				locationString = [ NSString stringWithContentsOfURL:googleMapsNSURL encoding:NSUTF8StringEncoding error:nil ];
				if( locationString )
				{
					// Make array of found items...
					
					foundItemsArray = [ locationString componentsSeparatedByString:kCommaStringKey ];
					if( foundItemsArray )
					{
						// Make sure we got "OK" result...
						
						id q = [ foundItemsArray objectAtIndexSafe:0 ];
						
						qS = (br NSString*)( ( br CFStringRef )[ q class ] );
						if( qS )
						{
							CFShow( (br CFStringRef)qS );
						}
						
						if( ( [ foundItemsArray count ] >= 4 ) && [ [ foundItemsArray objectAtIndexSafe:0 ] isEqualToString:kHTTP_Result_OK ] )
						{
							// Get lat & long from the found results...
							
							foundLocationCoords.latitude = [ [ foundItemsArray objectAtIndexSafe:2 ] doubleValue ];
							
							foundLocationCoords.longitude = [ [ foundItemsArray objectAtIndexSafe:3 ] doubleValue ];
						}
					}
				}
			}
		}
	}
	
	return foundLocationCoords;
}

#pragma mark Centering

- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    return round( MERCATOR_OFFSET - MERCATOR_RADIUS * logf(((CGFloat)1 + sinf( (CGFloat)latitude * (CGFloat)M_PI / (CGFloat)180.0)) / ((CGFloat)1 - sinf( (CGFloat)latitude * (CGFloat)M_PI / (CGFloat)180.0))) / (CGFloat)2.0 );
}

- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView centerCoordinate:(CLLocationCoordinate2D)centerCoordinate andZoomLevel:(NSUInteger)zoomLevel
{
    // convert center coordiate to pixel space
    
	double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    
	NSInteger zoomExponent = 20 - (NSInteger)zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    
	CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    
	double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    
	CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    
	CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    
	MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    
	return span;
}

#pragma mark -
#pragma mark Public methods

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated
{
    // Clamp large numbers to 28
	
    zoomLevel = MIN( (NSUInteger)zoomLevel, (NSUInteger)28 );
    
    // Use the zoom level to compute the region
   
	MKCoordinateSpan span = [ self coordinateSpanWithMapView:self centerCoordinate:centerCoordinate andZoomLevel:zoomLevel ];
	
	MKCoordinateRegion region = MKCoordinateRegionMake( centerCoordinate, span );
    
	// Set the region like normal
   
	[ self setRegion:region animated:animated ];
} 

@end
