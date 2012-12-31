/*****************************************************************************

File:			cbUtilsHacks.h

Date:			2/11/09

Version:		1.0

Authors:		soundcore

				Copyright 2009 by Code Beauty, LLC
				All rights reserved worldwide.

Notes:			Header for cbUtilsHacks.m

				Various odds & ends for Cocoa.
								
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

Dependencies:	Cocoa, XCode 2.5 as of this writing.

Changes:		

2/11/09			MCA Initial version.

******************************************************************************/

#ifdef __OBJC__

#import <Cocoa/Cocoa.h>

////////////
// Defines
////////////

#define kBlenderWAVSoundFileName	@"blender"

////////////
// Protos
////////////

#ifndef __OBJC__
	#ifdef __cplusplus
	extern "C" {
	#endif
#endif

void	CenterWindowOnScreen( NSWindow *window, NSScreen *screen );

#ifndef __OBJC__
	#ifdef __cplusplus
	}
	#endif
#endif

#endif