/***************************************************************************************

File:			cbUtilsAE.h

Date:			5/5/09

Version:		1.0

Authors:		soundcore

				Copyright 2008-2009 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			Header for cbUtilsAE.m

				Set tab width and indent width both to 4 In Project Builder's
				or XCode's Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF CODE BEAUTY, LLC

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE
				FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	XCode 2.5 as of this writing.
				Carbon
				Cocoa

Changes:		5/5/09			MCA Initial version.

***************************************************************************************/

#import <Carbon/Carbon.h>

#ifdef __OBJC__
#import <Cocoa/Cocoa.h>

enum
{
	kFinderFileType			= 'FNDR',
	kFinderCreatorType		= 'MACS',
	kFinderProcessType		= 'FNDR',
	kFinderProcessSignature	= 'MACS'
};

@interface cbAEUtils : NSObject
{
}

// Init & term

- (id)init;

- (void)dealloc;

- (NSString*)description;

// AE utils

- (BOOL)sendFinderResyncEvent:(AliasHandle)aliasH;

@end

#endif

///////////////
// C wrappers
///////////////

#ifdef __cplusplus
extern "C" {
#endif

Boolean SendFinderResyncEvent( AliasHandle aliasH );
									
#ifdef __cplusplus
}
#endif