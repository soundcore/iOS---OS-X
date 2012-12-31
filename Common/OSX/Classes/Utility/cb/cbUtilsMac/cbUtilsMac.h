/*****************************************************************************

File:			cbUtilsMac.h

Date:			9/29/08

Version:		1.0

Authors:		Michael C. Amorose

				�2008 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			Header for cbUtilsMac.c

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

Dependencies:	Carbon/Carbon.h
				CoreFoundation/CoreFoundation.h
				Application Services Framework
				Core Graphics (Quartz)
				I/O Kit

Changes:		

9/29/08			MCA	Inital version.

******************************************************************************/

#include <CoreFoundation/CoreFoundation.h>
#include <ApplicationServices/ApplicationServices.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/network/IOEthernetInterface.h>
#include <IOKit/network/IONetworkInterface.h>
#include <IOKit/network/IOEthernetController.h>

////////////////////////////////
// Protos
////////////////////////////////

#ifdef __cplusplus
extern "C" {
#endif

// Bundle utils

CFBundleRef		GetCFBundleForFSRef( FSRef *ref	);
								
CFStringRef		GetBundleNonLocalizedName( CFBundleRef  *ref );

void			GetBundleNonLocalizedNameCString( CFBundleRef *ref, char *buf, unsigned bufLen );

CFDictionaryRef CopyBundleInfoDict( CFBundleRef ref );

// Login/Session utils

void			GetSessionInfo(	CFStringRef		*shortUserName,
								CFNumberRef		*userUID,
								CFBooleanRef	*userIsActive,
								CFBooleanRef	*loginCompleted	);
								
// Network utils

void			GetPrimaryMACAddress( UInt8 *MACAddress, char *MACAddressString, unsigned MACAddressStringLen  );

void			OpenURLFromCString( char *url );

// Number utils

CFStringRef		GetTickCountString( void );

// Prefs Pane utils

OSStatus		OpenPrefsPanel( CFStringRef paneNameStr );

// C arrays

Boolean			BoolArrayHasAllValuesToMatch( bool boolArray[], size_t arraySize, bool valueToMatch );

Boolean			BoolArrayHasNonZero( bool boolArray[], size_t arraySize );

// Resource

Handle Get1DetachedResourceFromClosedFile(	ResType 		type,
											short 			resID,
											OSErr			*err,
											const FSRef		*resFileRef );
											
// Debug stuff

void			CFShowDebug( CFStringRef string );

void			CFShowDebugCString( char *string );

void			CFShowDebugCStringAppending( char *string1, char *string2 );

void			CFShowDebugWithNum( CFStringRef string, long number );

void			CFShowOSStatus( OSStatus err );

#ifdef __cplusplus
}
#endif
