/****************************************************************************

File:			NSOperationQueue+NSOperationQueueAdditions.h

Date:			9/6/11

Version:		1.0

Authors:		Michael Amorose

				Copyright 2011 Michael Amorose
				All rights reserved worldwide.

Notes:			Header for NSOperationQueue+NSOperationQueueAdditions.m

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF MICHAEL AMOROSE. ANY SUCH DISTRIBUTION CARRIES SEVERE
				CRIMINAL AND CIVIL PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW. VIOLATORS WILL BE PROSECUTED TO THE FULL EXTENT OF
				INTERNATIONAL LAW.

Dependencies:	See header.

Changes:		

9/6/11			MCA Initial version.

******************************************************************************/

#import <CoreFoundation/CoreFoundation.h>

#if TARGET_OS_IPHONE == 1
	#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC == 1
	#import <Cocoa/Cocoa.h>
#endif

// Classes

@interface NSOperationQueue ( NSOperationQueueAdditions )

// Utils

- (void)cancelOperationsFilteredByPredicate:(NSPredicate*)predicate;

@end
