/*****************************************************************************

File:			cbUtilsCarbonPath.h

Date:			9/29/08

Version:		1.0

Authors:		soundcore

				�2008 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			Header for cbUtilsCarbonPath.cp

				Carbon/Core Foundation path utils.
								
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

Dependencies:	Carbon
				XCode 2.5
				cbUtilsMac
				WinMacTypesMapping

Changes:		

9/29/08			MCA Initial version.

******************************************************************************/

#pragma once

#include <Carbon/Carbon.h>

////////////////////////
// Protos
////////////////////////

CFStringRef		CreateUserPrefsDirFullPathCFString( void );

void			GetUserPrefsDirFullPathCString( char *outBuffer, short outBufferLength );

OSStatus		WMTM_MakeFullPathNameFromFSRef( FSRef *fileRef, char *outlpFileName, short outlpFileNameLen, short pathNameType );

void			WMTM_CFStringPathFromFSRef( FSRef *fileRef, short pathNameType, CFStringRef *outCFString );

Boolean			WMTM_CFStringGetFileSystemRepresentationUniversal( CFStringRef string, char *buffer, CFIndex maxBufLen );
