/****************************************************************************

File:			NSString+NSStringAdditions.h

Date:			12/7/09

Version:		1.0

Authors:		Michael Amorose

				Copyright 2009 Michael Amorose
				All rights reserved worldwide.

Notes:			Header for NSString+NSStringAdditions

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF MICHAEL AMOROSE.

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE FULL EXTENT OF
				INTERNATIONAL LAW.

Dependencies:	See header.

Changes:		

12/7/09			MCA Initial version.

******************************************************************************/

#import <NSString+NSStringAdditions.h>

#import <CoreFoundation/CoreFoundation.h>
#import <QuartzCore/QuartzCore.h>

#if TARGET_OS_IPHONE == 1
	#import <UIKit/UIKit.h>
	#import <MapKit/MapKit.h>
#elif TARGET_OS_MAC == 1
	#import <Cocoa/Cocoa.h>
#endif

// Classes

@interface NSString ( NSStringAdditions )

// Methods

- (NSString*)prettyFloat:(CGFloat)f;

- (NSString*)JRNSStringFromCATransform3D:(CATransform3D)transform;

- (BOOL)containsLeadingZero;

- (BOOL)containsLeadingZeroAllowingHexChars;

- (BOOL)containsOnlyNumericChars;

- (BOOL)containsString:(NSString*)string;

- (NSString*)convertEntities:(NSString*)string;

- (NSString*)stripEverythingAfterNthNewline:(NSUInteger)newLineIndex;

- (NSString*)stripEverythingAfterNthSpace:(NSUInteger)spaceIndex;

- (NSString*)stripLeadingZeros;

- (NSString*)stripMutipleSpaces;

- (NSString*)stripTrailingDecimals;

- (NSString*)stripTrailingDecimalZeros;

- (NSString*)truncateToTwoDecimals;

#if TARGET_OS_IPHONE == 1
- (NSMutableString*)convertCLLocationCoordinate2DToHoursMinsSecsStrings:(CLLocationCoordinate2D)loc outLongitude:(NSMutableString**)outLongitudeString;
#endif

- (NSString*)currentUsersDesktopPath;

- (NSString*)usersDirectoryPath;

#if TARGET_OS_IPHONE == 0

- (void)makeVisible:(BOOL)visible;

- (BOOL)toFSRef:(FSRef*)ref;

#endif

@end
