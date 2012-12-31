/*****************************************************************************

File:			cbUtilsMac.cp

Date:			9/29/08

Version:		1.0

Authors:		Michael C. Amorose

				�2008 Code Beauty, LLC
				All rights reserved worldwide.

Notes:			Common utility routines

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

Dependencies:	

Changes:		

9/29/08			MCA	Inital version.

******************************************************************************/

#include "cb.h"
#include "cbUtilsMac.h"

#pragma mark -------------------------------------
#pragma mark Bundle Utils
#pragma mark -------------------------------------

//////////////////////////////////////
// Return a CFBundleRef for an FSRef
//////////////////////////////////////

CFBundleRef GetCFBundleForFSRef( FSRef *ref	)
{
	CFBundleRef		bundleRef = NULL;
	CFURLRef		urlRef = NULL;
	
	if( ref )
	{
		urlRef = CFURLCreateFromFSRef( kCFAllocatorDefault, ref );
		if( urlRef )
		{
			bundleRef = CFBundleCreate( kCFAllocatorDefault, urlRef );
		}
	}
	
	return bundleRef;
}

//////////////////////////////////////////////////////////
// Return the non-localized name of the CFBundle passed in
// as a CFString.
//////////////////////////////////////////////////////////

CFStringRef GetBundleNonLocalizedName( CFBundleRef *ref )
{
	CFStringRef			outString = NULL;
	CFDictionaryRef		bundleInfoDict = NULL;
	
	if( ref )
	{
		bundleInfoDict = CFBundleGetInfoDictionary( *ref );
		if( bundleInfoDict )
		{
			outString = (CFStringRef)CFDictionaryGetValue( bundleInfoDict, kCFBundleExecutableKeyCFString );
		}
	}
	
	return outString;
}

//////////////////////////////////////////////////////////
// Return the non-localized name of the CFBundle passed in
// as a C string.
//////////////////////////////////////////////////////////

void GetBundleNonLocalizedNameCString( CFBundleRef *ref, char *buf, unsigned bufLen )
{
	CFStringRef tmpBundleName = NULL;
	
	if( ref )
	{
		tmpBundleName = GetBundleNonLocalizedName( ref );
		if( tmpBundleName )
		{
			(void)CFStringGetCString( tmpBundleName, buf, (CFIndex)bufLen, kCFStringEncodingASCII );
		}
	}
}

//////////////////////////////////////////////////////////
// Return the info dictionary for the bundle passed
// in. Caller must release returned dictionary.
//////////////////////////////////////////////////////////

CFDictionaryRef CopyBundleInfoDict( CFBundleRef ref )
{
	CFDictionaryRef		dict = NULL;
	CFDictionaryRef		dictCopy = NULL;
	
	if( ref )
	{
		dict = CFBundleGetInfoDictionary( ref );
		if( dict )
		{
			// Allocate a copy of the dict and return it...
			
			dictCopy = CFDictionaryCreateCopy( kCFAllocatorDefault, dict );
		}
	}
	
	return dictCopy;
}

#pragma mark -------------------------------------
#pragma mark Login/Session Utils
#pragma mark -------------------------------------

/////////////////////////////////////////////////////////////
// Get user, computer, login, and session info using Quartz.
/////////////////////////////////////////////////////////////

void GetSessionInfo(	CFStringRef		*shortUserName,
						CFNumberRef		*userUID,
						CFBooleanRef	*userIsActive,
						CFBooleanRef	*loginCompleted	)
{

    CFDictionaryRef		sessionInfoDict = NULL;

	sessionInfoDict = CGSessionCopyCurrentDictionary();
	
	if( sessionInfoDict && shortUserName && userUID && userIsActive && loginCompleted )
	{
		*shortUserName = (CFStringRef)CFDictionaryGetValue( sessionInfoDict, kCGSessionUserNameKey );
		
		*shortUserName = (CFStringRef)CFRetain( *shortUserName );

		*userUID = (CFNumberRef)CFDictionaryGetValue( sessionInfoDict, kCGSessionUserIDKey );

		*userUID = (CFNumberRef)CFRetain( *userUID );
		
		*userIsActive = (CFBooleanRef)CFDictionaryGetValue( sessionInfoDict, kCGSessionOnConsoleKey );

		*userIsActive = (CFBooleanRef)CFRetain( *userIsActive );
		
		*loginCompleted = (CFBooleanRef)CFDictionaryGetValue( sessionInfoDict, kCGSessionLoginDoneKey );
		
		*loginCompleted = (CFBooleanRef)CFRetain( *loginCompleted );
		
		CFRelease( sessionInfoDict );
	}
}

#pragma mark -------------------------------------
#pragma mark Network Utils
#pragma mark -------------------------------------

///////////////////////////////////////////////////////////////////////////
// Get the primary Mac address as a UInt8 array of kIOEthernetAddressSize
// elements. The buffer passed in must be kIOEthernetAddressSize
// items in length. Just for fun also return a string represetning the
// MAC address as a string.
//
// Derived from http://developer.apple.com/samplecode/GetPrimaryMACAddress
////////////////////////////////////////////////////////////////////////////

void GetPrimaryMACAddress( UInt8 *MACAddress, char *MACAddressString, unsigned MACAddressStringLen  )
{
	char						tmpBuffer[ kTempCStringBufferLength ] = { 0 };
	kern_return_t				kernResult = KERN_SUCCESS;
	io_iterator_t				intfIterator1;
	CFMutableDictionaryRef		matchingDict = NULL;
	CFMutableDictionaryRef		propertyMatchDict = NULL;
	io_object_t					intfService;
    io_object_t					controllerService;
    UInt8						bufferSize = 0;
	
	// As a number...
	
	if( MACAddress )
	{
		memset( MACAddress, 0, sizeof( *MACAddress ) );
   
		// FindEthernetInterfaces
		
		matchingDict = IOServiceMatching( kIOEthernetInterfaceClass );
		if( matchingDict )
		{
			propertyMatchDict = CFDictionaryCreateMutable(	kCFAllocatorDefault,
															0,
															&kCFTypeDictionaryKeyCallBacks,
															&kCFTypeDictionaryValueCallBacks	);
		
			if( propertyMatchDict )
			{
				CFDictionarySetValue( propertyMatchDict, CFSTR(kIOPrimaryInterface), kCFBooleanTrue ); 
				
				CFDictionarySetValue( matchingDict, CFSTR(kIOPropertyMatchKey), propertyMatchDict );
			   
				CFRelease( propertyMatchDict );
			}
		}
		
		kernResult = IOServiceGetMatchingServices( kIOMasterPortDefault, matchingDict, &intfIterator1 );    
		
		// GetMACAddress
		
		kernResult = KERN_FAILURE;
		
		bufferSize = sizeof( *MACAddress );
		
		if( bufferSize >= kIOEthernetAddressSize )
		{
			bzero( MACAddress, bufferSize );
    
			while( ( intfService = IOIteratorNext( intfIterator1 ) ) )
			{
				CFTypeRef	MACAddressAsCFData;        

				kernResult = IORegistryEntryGetParentEntry( intfService, kIOServicePlane, &controllerService );
				
				MACAddressAsCFData = IORegistryEntryCreateCFProperty(	controllerService,
																		CFSTR( kIOMACAddress ),
																		kCFAllocatorDefault,
																		0 );
				if( MACAddressAsCFData )
				{
					CFDataGetBytes( (CFDataRef)MACAddressAsCFData, (CFRange)CFRangeMake( 0, kIOEthernetAddressSize ), MACAddress );
					
					CFRelease( MACAddressAsCFData );
				}
						
				(void)IOObjectRelease(controllerService);
				
				(void)IOObjectRelease(intfService);
			}
		}
		
		(void)IOObjectRelease( intfIterator1 );
	}
	
	// As a string...
	
	if( MACAddressString )
	{
		memset( MACAddressString, 0, sizeof( MACAddressString ) );
		
		sprintf(	tmpBuffer,
					"%02x:%02x:%02x:%02x:%02x:%02x",
					MACAddress[ 0 ],
					MACAddress[ 1 ],
					MACAddress[ 2 ],
					MACAddress[ 3 ],
					MACAddress[ 4 ],
					MACAddress[ 5 ] );
		
		BlockMoveData( tmpBuffer, MACAddressString, MACAddressStringLen );
	}
}

#pragma mark -----------------------------------
#pragma mark URL Utils
#pragma mark -----------------------------------

void OpenURLFromCString( char *url )
{
	CFStringRef		urlCFStringRef = NULL;
	CFURLRef		urlRef = NULL;
	OSStatus		err = noErr;
	
	if( url )
	{
		// Make a CFString from the URL C string...
		
		urlCFStringRef = CFStringCreateWithCString( kCFAllocatorDefault, url, kCFStringEncodingASCII );
		if( urlCFStringRef )
		{
			// Make a CFURLRef...
			
			urlRef = CFURLCreateWithString( kCFAllocatorDefault, urlCFStringRef, NULL );
			if( urlRef )
			{
				// Open URL
				
				err = LSOpenCFURLRef( urlRef, NULL );
				
				// Clean up...
				
				CFRelease( urlRef );
				
				urlRef = NULL;
			}
			
			// Clean up...
			
			CFRelease( urlCFStringRef );
				
			urlCFStringRef = NULL;
		}
	}
}

#pragma mark -------------------------------------
#pragma mark Number Utils
#pragma mark -------------------------------------

/////////////////////////////////////////////
// Get the current TickCount as a CFString.
/////////////////////////////////////////////

CFStringRef GetTickCountString( void )
{
	UInt32			tmpTicks = 0;
	CFNumberRef		tmpNum = NULL;
	CFStringRef		numStringRef = NULL;
	
	tmpTicks = TickCount();
			
	tmpNum = CFNumberCreate( kCFAllocatorDefault, kCFNumberLongType, (const void*)&tmpTicks );
			
	numStringRef = CFStringCreateWithFormat( kCFAllocatorDefault, NULL, CFSTR( "%@" ), tmpNum );
	
	CFRelease( tmpNum );
	
	return numStringRef;
}

#pragma mark ----------------
#pragma mark Prefs Pane Utils
#pragma mark ----------------

//////////////////////////////////////////////////////////////////
// Open the System Preferences prefs pane passed in paneNameStr
//////////////////////////////////////////////////////////////////

OSStatus OpenPrefsPanel( CFStringRef paneNameStr )
{
	FSRef			prefPane;
	FSRef			prefPaneFolder;
	HFSUniStr255	paneNameUnicode = { 0 };
	OSStatus		err = noErr;
	
	paneNameUnicode.length = CFStringGetLength( paneNameStr );
	
	CFStringGetCharacters( paneNameStr, CFRangeMake( 0, paneNameUnicode.length ), paneNameUnicode.unicode );
	
	/////////////////////////////////////////////////////////////////////////////////////
	// Locate the system prefs folder. (Not the prefs folder for the currently
	// logged-in user.
	/////////////////////////////////////////////////////////////////////////////////////
	
	err = FSFindFolder( kSystemDomain, kSystemPreferencesFolderType, false, &prefPaneFolder );
	if( err == noErr )
	{
        // Make an FSRef of the prefs pane...
		
		err = FSMakeFSRefUnicode(	&prefPaneFolder,
									paneNameUnicode.length,
									paneNameUnicode.unicode,
									kTextEncodingUnknown,
									&prefPane					);
									
		if( err == noErr )
		{
			// Open the prefs pane (which triggers System Preferences.app to load it...)
		
			err = LSOpenFSRef( &prefPane, NULL );
		}
	}
	
	return err;
}
			
#pragma mark --------------
#pragma mark C Array Utils
#pragma mark --------------

/////////////////////////////////////////////
// See if any values in the passed in bool
// array is set to 1. boolArray must be an
// array of bools or the routine  will fail.
// arraySize must specify the # of array
// elements.
/////////////////////////////////////////////

Boolean BoolArrayHasNonZero( bool boolArray[], size_t arraySize )
{
	Boolean		hasAllZeros = false;
	
	hasAllZeros = BoolArrayHasAllValuesToMatch( boolArray, arraySize, 0 );
	
	return !hasAllZeros;
}

/////////////////////////////////////////////
// See if all values in the passed in bool
// array are set to valueToMatch. boolArray
// must be an array of bools or the routine
// will fail. arraySize must be the # of
// array elements.
/////////////////////////////////////////////

Boolean BoolArrayHasAllValuesToMatch( bool boolArray[], size_t arraySize, bool valueToMatch )
{
	Boolean		hasAll = false;
	size_t		i = 0;
	size_t		counted = 0;
	
	if( boolArray )
	{
		// Loop elements looking for valueToMatch in every entry...
		
		for( i = 0; i < arraySize; i++ )
		{
			if( boolArray[ i ] == valueToMatch )
			{
				counted++;
			}
			else
			{
				break;
			}
		}
		
		if( counted == arraySize )
		{
			hasAll = true;
		}
	}
	
	return hasAll;
}

#pragma mark ---------------
#pragma mark Resource Utils
#pragma mark ---------------

/********************************************/
/* Gets a resource from a closed file. The 	*/
/* Handle returned is detached.				*/
/********************************************/

Handle Get1DetachedResourceFromClosedFile(	ResType 		type,
											short 			resID,
											OSErr			*err,
											const FSRef		*resFileRef )
{
	#pragma unused( err )
	
	short				oldResFile = 0;
	ResFileRefNum		resFileNum = 0;
	Handle				hRes = NULL;
	HFSUniStr255		forkName;
	
	memset( &forkName, 0, sizeof( forkName ) );
		
	if( resFileRef )
	{
		oldResFile = CurResFile();													// Get current res file
		
		*err = FSGetResourceForkName( &forkName );
		 
		*err = FSOpenResourceFile( resFileRef, forkName.length, forkName.unicode, fsRdWrPerm, &resFileNum );
		if( resFileNum != kResFileNotOpened )
		{
			UseResFile( resFileNum );												// Just to be safe
		
			hRes = Get1Resource( type, resID );										// Attempt to load the resource
			if( hRes != NULL )
			{
				DetachResource( hRes );												// Detach it
			}
			
			CloseResFile( resFileNum );												// Close the file we opened
		}
			
		UseResFile( oldResFile );													// Restore old resource file
	}
	
	return hRes;
}

#pragma mark ------------
#pragma mark Debug Utils
#pragma mark ------------

/////////////////////////////////////////////
// DIsplay a CFString in the console only if
// deugging is turned on.
/////////////////////////////////////////////

void CFShowDebug( CFStringRef string )
{
	#if DEBUG
	
		CFShow( string );
		
	#else
	
		#pragma unused( string )
	
	#endif
}

/////////////////////////////////////////////
// DIsplay a C string in the console only if
// deugging is turned on.
/////////////////////////////////////////////

void CFShowDebugCString( char *string )
{
	#if DEBUG
	
	CFStringRef s = NULL;
	 
	if( string )
	{
		s = CFStringCreateWithCString( kCFAllocatorDefault, string, kCFStringEncodingASCII );
		if( s )
		{
			CFShow( s );
				
			CFRelease( s );
				
			s = NULL;
		}
	}
		
	#else
	
		#pragma unused( string )
	
	#endif
}

/////////////////////////////////////////////
// DIsplay 2 C strings in the console only if
// deugging is turned on. Append the second
// string to the end of the first with a space
// between.
/////////////////////////////////////////////

void CFShowDebugCStringAppending( char *string1, char *string2 )
{
	#if DEBUG
	
	char			sFinal[ kTempCStringBufferLength ] = { 0 };
	CFStringRef		s = NULL;
	 
	if( string1 && string2 )
	{
		strcpy( sFinal, string1 );
		
		strcat( sFinal, " " );
		
		strcat( sFinal, string2 );
		
		s = CFStringCreateWithCString( kCFAllocatorDefault, sFinal, kCFStringEncodingASCII );
		if( s )
		{
			CFShow( s );
				
			CFRelease( s );
				
			s = NULL;
		}
	}
		
	#else
	
		#pragma unused( string1 )
		#pragma unused( string2 )
		
	#endif
}

///////////////////////////////////////////////////////
// DIsplay a string and a number in the console in the 
// form "<string> <" "> <number>". If debugging is
// turned off, do nothing.
///////////////////////////////////////////////////////

void CFShowDebugWithNum( CFStringRef string, long number )
{
	#if DEBUG
	
		CFNumberRef		numRef = NULL;
		CFStringRef		numStringRef = NULL;
		CFStringRef		finalString = NULL;
		CFStringRef		stringsArray[ 2 ] = { NULL, NULL };
		CFArrayRef		theArray = NULL;
		
		// Convert the passed in number to a CFNumber
		
		numRef = CFNumberCreate( kCFAllocatorDefault, kCFNumberLongType, (const void*)&number );
		if( numRef )
		{
			// Convert number to string...
			
			numStringRef = CFStringCreateWithFormat( NULL, NULL, CFSTR( "%@" ), numRef );
			if( numStringRef )
			{
				// Concatenate strings...
			
				stringsArray[ 0 ] = CFStringCreateCopy( kCFAllocatorDefault, string );

				stringsArray[ 1 ] = CFStringCreateCopy( kCFAllocatorDefault, numStringRef );
				
				if( stringsArray[ 0 ] && stringsArray[ 1 ] )
				{
					theArray = CFArrayCreate( kCFAllocatorDefault, (const void**)stringsArray, 2, NULL );
					if( theArray )
					{
						finalString = CFStringCreateByCombiningStrings( kCFAllocatorDefault, theArray, CFSTR(" ") );
						if( finalString )
						{
							CFShow( finalString );
						
							CFRelease( finalString );
						}
						
						CFRelease( theArray );
					}
					
					CFRelease( stringsArray[ 0 ] );
				
					CFRelease( stringsArray[ 1 ] );
				}
				
				CFRelease( numStringRef );
			}
			
			CFRelease( numRef );
		}
		
	#else
	
		#pragma unused( string )
		#pragma unused( number )
		
	#endif
}

/////////////////////////////////////////////////////////////////////
// DIsplay an OSStatus value in the console if debugging is turned on
/////////////////////////////////////////////////////////////////////

void CFShowOSStatus( OSStatus err )
{
	#if DEBUG
	
		CFStringRef		errString = NULL;
	
		errString = CFStringCreateWithFormat( kCFAllocatorDefault, NULL, CFSTR("%d"), err );
	
		CFShow( errString );
	
		CFRelease( errString );
		
	#else
	
		#pragma unused( err )
	
	#endif
}
