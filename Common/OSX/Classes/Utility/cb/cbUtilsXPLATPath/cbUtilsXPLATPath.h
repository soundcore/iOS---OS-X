/***********************************************************************************

File:			cbUtilsXPLATPath.h

Date:			3/5/09

Version:		1.0

Authors:		soundcore

				Copyright 2009 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			Header for cbUtilsXPLATPath.

				Some generic C path manipulation routines used in
				several places.
				
				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF CODE BEAUTY, LLC

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE
				FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	XCode 2.5 as of this writing.

Changes:		3/5/09			MCA		Initial version.

***********************************************************************************/

#include <Carbon/Carbon.h>

////////////
// Protos
////////////

#ifdef __cplusplus
extern "C" {
#endif
	
OSStatus	MakeFSRefFromFullPathName( FSRef *fileRef, char *pFileName, short pathNameType );

void		StripDriveLetter( char *path );

void		ReplaceSlashes( char *path, char newSlashChar );

#ifdef __cplusplus
}
#endif
