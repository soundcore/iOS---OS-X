/*****************************************************************************

File:			cbUtilsCarbonPath.cp

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

******************************************************************************/

#include <cb.h>

#include "cbUtilsCarbonPath.h"
#include <cbUtilsMac.h>
#include <cbUtilsXPLATPath.h>

#pragma mark --------------------------
#pragma mark General system paths
#pragma mark --------------------------

////////////////////////////////////////////////////////////
// Get the full path to the current user dir as a CFString.
// String is POSIX format.
////////////////////////////////////////////////////////////

CFStringRef CreateUserPrefsDirFullPathCFString( void )
{
	char			finalPath[ kTempCStringBufferLength ] = { 0 };
	FSRef			userPrefsFolderRef;
	CFStringRef		finalPathStringCFString = NULL;
	OSStatus		fileErr = noErr;
	OSStatus		err = noErr;
	
	// Ask system for /Users dir localized...
	
	fileErr = FSFindFolder( kUserDomain, kPreferencesFolderType, kDontCreateFolder, &userPrefsFolderRef );
	if( !fileErr )
	{	
		err = WMTM_MakeFullPathNameFromFSRef( &userPrefsFolderRef, finalPath, kTempCStringBufferLength, kWindowsStringPathType );
		if( !err )
		{
			ReplaceSlashes( finalPath, '\\' );
			
			finalPathStringCFString = CFStringCreateWithCString( kCFAllocatorDefault, finalPath, kCFStringEncodingASCII );
		}
	}
	
	return finalPathStringCFString;
}

////////////////////////////////////////////////////////////
// Get the full path to the current user dir as a C string.
// String is POSIX format.
////////////////////////////////////////////////////////////

void GetUserPrefsDirFullPathCString( char *outBuffer, short outBufferLength )
{
	CFStringRef		finalPathStringCFString = NULL;
	
	memset( outBuffer, 0, outBufferLength );
	
	finalPathStringCFString = CreateUserPrefsDirFullPathCFString();
	if( finalPathStringCFString )
	{
		// Copy to output...
		
		(void)CFStringGetCString( finalPathStringCFString, outBuffer, (CFIndex)outBufferLength, kCFStringEncodingASCII );
		
		CFRelease( finalPathStringCFString );
		
		finalPathStringCFString = NULL;
	}
}

/////////////////////////////////////////////////////////////////////////////
// Get a CFStringRef for the file system name of the FSRef object passed in.
// The returned string is a full path based on the path style also passed in.
// Caller must dispose of the returned string when done.
/////////////////////////////////////////////////////////////////////////////

void WMTM_CFStringPathFromFSRef( FSRef *fileRef, short pathNameType, CFStringRef *outCFString )
{
	CFURLRef		url = NULL;
	CFStringRef		cfString = NULL;
	
	if( fileRef && outCFString )
	{
		*outCFString = NULL;
	
		url = CFURLCreateFromFSRef( kCFAllocatorDefault, fileRef );
		if( url )
		{	
			switch( pathNameType )
			{
				case kPOSIXStringPathType:
				
					// Standard POSIX path...
					
					cfString = CFURLCopyFileSystemPath( url, kCFURLPOSIXPathStyle );
						
					break;
					
				case kHFSPathType:
				
					// HFS-style path
					
					cfString = CFURLCopyFileSystemPath( url, kCFURLHFSPathStyle );
					
					break;
					
				case kWindowsStringPathType:
				case kWindowsAbsoluteStringPathType:
				
					// Windows-style path
					
					cfString = CFURLCopyFileSystemPath( url, kCFURLWindowsPathStyle );
					
					break;
					
				default:
				
					break;
			}
			
			CFRelease( url );
					
			url = NULL;
			
			if( cfString )
			{
				// Make final copy to return...
			
				*outCFString = CFStringCreateCopy( kCFAllocatorDefault, cfString );
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////
// Make a full pathname of the type specified by pathNameType such that it
// points at the object specified by fileRef. outlpFileName must be allocated by
// the caller. On success the return value is noErr.
//
// We let Core Foundation give us the path to avoid encoding issues.
// pathNameType must be one of the path conversion types defined in
// WinMacTypesMapping.h.
//
// NOTE: outlpFileName must be kTempCStringBufferLength bytes in length.
//////////////////////////////////////////////////////////////////////////////////

OSStatus WMTM_MakeFullPathNameFromFSRef( FSRef *fileRef, char *outlpFileName, short outlpFileNameLen, short pathNameType )
{
	Boolean					converted = false;
	char					tmpBuffer[ kTempCStringBufferLength ] = { 0 };
	char					tempString[ kTempCStringBufferLength ] = { 0 };
	char					homeDirString[ kTempCStringBufferLength ] = { 0 };
	char					*ext = NULL;
	size_t					len = 0;
	CFStringRef				cfString = NULL;
	CFStringRef				cfString2 = NULL;
	FSRef					libraryFolderRef = { 0 };
	OSStatus				err = noErr;
	OSStatus				fileErr = noErr;
	
	if( fileRef && outlpFileName )
	{
		memset( (void*)outlpFileName, 0, (size_t)outlpFileNameLen );
		
		WMTM_CFStringPathFromFSRef( fileRef, pathNameType, &cfString );
		if( cfString )
		{
			// Convert to C string and copy to output buffer...
						
			converted = WMTM_CFStringGetFileSystemRepresentationUniversal( cfString, tempString, kTempCStringBufferLength );
			if( converted )
			{
				/////////////////////////////////////////////////////////////////
				// First check to see if an absolute Windows path was requested.
				// If so, massage the paths to contain "C:\" at the front.
				/////////////////////////////////////////////////////////////////
				
				if( pathNameType == kWindowsAbsoluteStringPathType )
				{
					strcat( homeDirString, kCDriveLetterPrefixCStringNoSlash );
					
					// Ask system for /Library dir localized...
					
					// Begin GetSystemDirectory replacement
					
					// (WAS // GetSystemDirectory( homeDirString, MAX_PATH ); )
					
					fileErr = FSFindFolder( kLocalDomain, kDomainLibraryFolderType, kDontCreateFolder, &libraryFolderRef );
					if( !fileErr )
					{	
						strcat( homeDirString, kCDriveLetterPrefixCStringNoSlash );
						
						WMTM_CFStringPathFromFSRef( &libraryFolderRef, kWindowsStringPathType, &cfString2 );
						if( cfString2 )
						{
							converted = WMTM_CFStringGetFileSystemRepresentationUniversal( cfString, tmpBuffer, ( kTempCStringBufferLength - 1 ) );
							if( converted )
							{
								strcat( homeDirString, tmpBuffer );
								
								ReplaceSlashes( homeDirString, '\\' );
							}
							
							CFRelease( cfString2 );
							
							cfString2 = NULL;
						}
					}

					// End GetSystemDirectory replacement
					
					// GetSystemDirectory always returns a path prefixed with "C:" so  search after that...
					
					ext = strstr( tempString, &homeDirString[ 2 ] );
					if( ext )
					{
						// Reset homeDirString...
						
						memset( homeDirString, 0, kTempCStringBufferLength );
						
						// Add "C:" back...
						
						len = strlen( "C:" );
						
						BlockMoveData( "C:", homeDirString, len );
						
						// Copy rest of user string back to homeDirString
						
						BlockMoveData( ext, &homeDirString[ 2 ], (Size)strlen( ext ) );
						
						// Copy final string to output...
						
						memcpy( (void*)outlpFileName, homeDirString, (size_t)outlpFileNameLen );
					}
				}
				else
				{
					// No mods to string so copy initial string to output...
					
					memcpy( (void*)outlpFileName, tempString, (size_t)outlpFileNameLen );
				}
			}
			
			CFRelease( cfString );
			
			cfString = NULL;
		}
	}
	else
	{
		// lpFileName is bad...
		
		err = paramErr;
	}
	
	return err;
}

/////////////////////////////////////////////////////////////////////////////
// Same as CFStringGetFileSystemRepresentation but works on both 10.4 & 10.3
/////////////////////////////////////////////////////////////////////////////

Boolean WMTM_CFStringGetFileSystemRepresentationUniversal( CFStringRef string, char *buffer, CFIndex maxBufLen )
{
	Boolean		converted = false;
	long		result = 0;
	OSStatus	err = noErr;
	
	if( string && buffer )
	{
		err = Gestalt( gestaltSystemVersion, &result );
		if( !err )
		{
			// 10.3/10.4 check...
			
			if( result >= kMacOSTenPointFour )
			{
				// 10.4
				
				if( CFStringGetFileSystemRepresentation != NULL )
				{
					converted = CFStringGetFileSystemRepresentation( string, buffer, maxBufLen );
				}
			}
			else if( ( result >= kMacOSTenPointThree ) && ( result < kMacOSTenPointFour ) )
			{
				// 10.3 - just copy the string as-is and hope it's valid!
				
				(void)CFStringGetCString( string, buffer, maxBufLen, kCFStringEncodingASCII );
				
				converted = true;
			}
		}
	}
	
	return converted;
}
