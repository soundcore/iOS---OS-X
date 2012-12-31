/***********************************************************************************

File:			cbUtilsXPLATPath.cp

Date:			3/5/09

Version:		1.0

Authors:		soundcore

				Copyright 2009 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			cbUtilsXPLATPath.cp implementation.

				See comment in header.
				
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

***********************************************************************************/

#include <cb.h>

#include <cbUtilsXPLATPath.h>

#pragma mark ------------------------
#pragma mark XPLAT Path C Routines
#pragma mark ------------------------

/////////////////////////////////////////////////////////////////////////////
// Make an FSRef from the pathname passed in lpFileName. pathNameType
// denotes what type of pathname is being passed in. fileRef must be a
// pointer to an unallocated/invalid FSRef. On exit fileRef will contain a
// ref if the return value is noErr AND the file exists. If the file does
// not exist, fnfErr (-43) will be returned.
//
// NOTE: Right now only kPOSIXStringPathType-style paths are supported!
/////////////////////////////////////////////////////////////////////////////

OSStatus MakeFSRefFromFullPathName( FSRef *fileRef, char *pFileName, short pathNameType )
{
	Boolean		isDirectory = false;
	UInt8		tempPath[ kTempCStringBufferLength ] = { 0 };
	OSStatus	err = noErr;
	
	if( pFileName && fileRef )
	{
		switch( pathNameType )
		{
			case kPOSIXStringPathType:
			case kWindowsStringPathType:
			
				// Make copy of path so we don't mess up the original...
				
				BlockMoveData( pFileName, tempPath, (Size)( kTempCStringBufferLength * sizeof( tempPath[ 0 ] ) ) );
				
				if( pathNameType == kWindowsStringPathType )
				{
					StripDriveLetter( (char*)tempPath );
					
					ReplaceSlashes( (char*)tempPath, '/' );
				}
				
				// Convert to FSRef
				
				err = FSPathMakeRef( tempPath, fileRef, &isDirectory );
				
				break;
				
			default:
			
				break;
		}
	}
	else
	{
		err = paramErr;
	}
	
	return err;
}

//////////////////////////////////////////////////////////////////////////////////////
// Strip the Windows drive letter and the leading ':' off the string. Note that this
// routine IS destructive so you may want to work off a copy before passing it
// in. 'path' MUST be a NULL-terminated string!
//////////////////////////////////////////////////////////////////////////////////////

void StripDriveLetter( char *path )
{
	size_t	len = 0;
	
	if( path )
	{
		len = strlen( path );
		
		if( ( path[ 1 ] == ':' ) && ( path[ 2 ] == '\\' ) )
		{
			// String has drive letter and colon so just shift the whole thing left by 2...
			
			BlockMoveData( &path[ 2 ], path, (Size)( len - 2 )  );
			
			// NULL-terminate
			
			path[ len ] = 0;
			
			path[ len - 1 ] = 0;
			
			path[ len - 2 ] = 0;
		}
	}
}

/////////////////////////////////////////////////////////////////////////
// Replace any backslashes in the path passed in with forward slashes.
/////////////////////////////////////////////////////////////////////////

void ReplaceSlashes( char *path, char newSlashChar )
{
	short	i = 0;
	
	if( path )
	{
		while( path[ i ] != '\0' )
		{
			// Replace
			
			if( ( path[ i ] == '\\' ) || ( path[ i ] == '/' ) )
			{
				path[ i ] = newSlashChar;
			}
			
			i++;
		}
	}
}
