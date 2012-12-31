/*****************************************************************************

File:			cbUtilsIcon.h

Date:			5/2/09

Version:		1.0

Authors:		Michael C. Amorose

				Copyright 2009 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			Header for cbUtilsIcon.m

				Set tab width and indent width both to 4 In Project Builder's
				or XCode's Text Editing Preferences. TURN OFF LINE WRAPPING.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF CODE BEAUTY, LLC
				
				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE
				FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	Carbon
				Cocoa
				
Changes:		

5/2/09			MCA	Inital version.

******************************************************************************/

#ifdef __OBJC__
#import <Cocoa/Cocoa.h>

/////////////
// Classes
/////////////

@interface cbIconUtils : NSObject
{
}

// Init & term

- (id)init;

- (void)dealloc;

- (NSString*)description;

// Icon utils

- (BOOL)setCustomFileIcon:(NSString*)targetPath fromBundlePath:(NSString*)sourcePath;

@end

#endif