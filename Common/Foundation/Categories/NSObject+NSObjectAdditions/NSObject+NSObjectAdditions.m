/****************************************************************************

File:			NSObject+NSObjectAdditions.m

Date:			5/20/11

Version:		1.0

Authors:		Michael Amorose

				Copyright 2011 Michael Amorose.
				All rights reserved worldwide.

Notes:			Implementation for NSObject+NSObjectAdditions
 
				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE BE REDISTRIBUTED
				WITHOUT EXPRESS WRITTEN PERMISSION OF MICHAEL AMOROSE. ANY
				SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL PENALTIES
				AND IS A VIOLATION OF INTERNATIONAL COPYRIGHT LAW. VIOLATORS
				WILL BE PROSECUTED TO THE FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	See header.

Changes:		See header.

******************************************************************************/

#import <NSObject+NSObjectAdditions.h>

@implementation NSObject ( NSObjectAdditions )

////////////////////////////////////////////////////
// Return current IP address in IP4 or IP6 format.
////////////////////////////////////////////////////

+ (NSString*)ipAddress:(bool)ipv6
{
	struct ifaddrs			*myaddrs = NULL;
	struct ifaddrs			*ifa = NULL;
	struct sockaddr_in		*s4 = NULL;
	struct sockaddr_in6		*s6 = NULL;
	char					buf[ 64 ];							/* buf must be big enough for an IPv6 address (e.g. 3ffe:2fa0:1010:ca22:020a:95ff:fe8a:1cf8) */
	NSString				*ip1Str = @"::1";
	NSString				*ipLoopBackStr = @"127.0.0.1";
	int						status;
	
	// Get network interfaces...
	
	status = getifaddrs( &myaddrs );
	if( !status )
	{
		for( ifa = myaddrs; ifa; ifa = ifa->ifa_next )
		{
			NSString *ip = NULL;
			
			if( !ifa->ifa_addr || ( ( ifa->ifa_flags & IFF_UP ) == 0 ) )
			{
				continue;
			}
			
			if( ( ifa->ifa_addr->sa_family == AF_INET ) && !ipv6 )
			{
				s4 = (struct sockaddr_in*)ifa->ifa_addr;
				
				if( inet_ntop( ifa->ifa_addr->sa_family, (void*)&( s4->sin_addr ), buf, sizeof( buf ) ) == NULL )
				{
					//printf("%s: inet_ntop failed!\n", ifa->ifa_name);
				}
				else
				{
					//printf("%s: %s\n", ifa->ifa_name, buf);
					
					if( ![ [ NSString stringWithUTF8String:ifa->ifa_name ] hasPrefix:@"lo" ] )
					{
						freeifaddrs( myaddrs );
						
						ip = [ NSString stringWithUTF8String:buf ];
						if( ip )
						{
							return ip;
						}
					}
				}
			}
			else if( ( ifa->ifa_addr->sa_family == AF_INET6 ) && ipv6 )
			{
				s6 = (struct sockaddr_in6*)ifa->ifa_addr;
				
				if( inet_ntop( ifa->ifa_addr->sa_family, (void*)&( s6->sin6_addr ), buf, sizeof( buf ) ) == NULL )
				{
					//printf("%s: inet_ntop failed!\n", ifa->ifa_name);
				}
				else
				{
					//printf("%s: %s\n", ifa->ifa_name, buf);
					
					if( ![ [ NSString stringWithUTF8String:ifa->ifa_name ] hasPrefix:@"lo" ] )
					{
						freeifaddrs( myaddrs );
						
						ip = [ NSString stringWithUTF8String:buf ];
						if( ip )
						{
							return ip;
						}
					}
				}
			}
		}
		
		// Clean up...
		
		freeifaddrs( myaddrs );
	}
	
	return ipv6 ? ip1Str : ipLoopBackStr;
}

////////////////////////////////
// Get the ip name (host name)
////////////////////////////////

+ (NSString*)ipName
{	
	NSString			*hostname = nil;

	#if TARGET_OS_IPHONE == 0
	
	CFBundleRef			bundleRef = NULL;
	CFStringRef			mainBundleName = NULL;
	SCDynamicStoreRef	dynRef = NULL;
	
	bundleRef = CFBundleGetMainBundle();
	if( bundleRef )
	{
		mainBundleName = CFBundleGetIdentifier( bundleRef );
		if( mainBundleName )
		{
			dynRef = SCDynamicStoreCreate( kCFAllocatorSystemDefault, mainBundleName, NULL, NULL );
		}
	}
	
	if( dynRef )
	{
		#if !__has_feature( objc_arc )
			hostname = (NSString*)SCDynamicStoreCopyLocalHostName( dynRef );
		#else
			hostname = ( br NSString*)SCDynamicStoreCopyLocalHostName( dynRef );
		#endif
		
		CFRelease( dynRef );
		
		dynRef = NULL;
	}
	
    if( hostname )
	{
		hostname = [ hostname stringByAppendingString:kLocalHostExtensionNSString ];
	}
	else
	{
		hostname = kEmptyStringKey;
	}
	
	#endif
	
	return hostname;
}

////////////////////////////////////
// Get the machine's MAC address.
////////////////////////////////////

+ (NSString*)macAddress
{
	NSString		*result = kEmptyStringKey;
	
	#if TARGET_OS_IPHONE == 0
	
	uint8_t			i = 0;
	kern_return_t	kernResult = KERN_SUCCESS;
	UInt8			MACAddress[ kIOEthernetAddressSize ];
	io_iterator_t	intfIterator = 0;
	
	bzero( MACAddress, sizeof( MACAddress ) );
	
	kernResult = FindEthernetInterfaces( &intfIterator );
	if( kernResult == KERN_SUCCESS )
	{
		kernResult = GetMACAddress( intfIterator, MACAddress );
		if( kernResult == KERN_SUCCESS )
		{
			for( i = 0; i < kIOEthernetAddressSize; i++ )
			{
				if( ![ result isEqualToString:kEmptyStringKey ] )
				{
					result = [result stringByAppendingString:kColonStringKey ];
				}
				
				if( MACAddress[ i ] <= 15 )
				{
					result = [result stringByAppendingString:kZeroStringKey ];
				}
				
				result = [ result stringByAppendingFormat:kLowercaseHexFormatString, MACAddress[ i ] ];
			}
		}
	}
	
	(void)IOObjectRelease( intfIterator );
	
	#endif
	
	return result;
}

////////////////////////
// Get the machineType.
////////////////////////

+ (NSString*)machineType
{
	char	modelBuffer[ 256 ];
	size_t	sz = sizeof( modelBuffer );
	
	bzero( modelBuffer, sz  );
	
	if( sysctlbyname( "hw.model", modelBuffer, &sz, NULL, 0 ) == 0 )
	{
		modelBuffer[ sz - 1 ] = 0;
		
		return [ NSString stringWithUTF8String:modelBuffer ];
	}
	else
	{
		return kEmptyStringKey;
	}
}

/////////////////////////////////////
// Get the name for a given device.
/////////////////////////////////////

+ (NSString*)nameForDevice:(NSInteger)deviceNumber
{
	NSMutableString	*name = [ NSMutableString stringWithCapacity:12 ];
	
	#if TARGET_OS_IPHONE == 0
	
	ItemCount		volumeIndex = 0;
	OSStatus		result = noErr;
	
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// Iterate across all mounted volumes using FSGetVolumeInfo. This will return nsvErr
	// (no such volume) when volumeIndex becomes greater than the number of mounted volumes.
	//////////////////////////////////////////////////////////////////////////////////////////
	
	for( volumeIndex = 1; ( result || ( result != nsvErr ) ); volumeIndex++ )
	{
		GetVolParmsInfoBuffer	volumeParms;
		FSVolumeInfo			volumeInfo;
		HFSUniStr255			volumeName;
		NSString				*bsdName = nil;
		NSString				*shortBSDName = nil;
		NSArray					*components = nil;
		FSVolumeRefNum			actualVolume = 0;
		
		bzero( &volumeName, sizeof( volumeName ) );
		bzero( &volumeInfo, sizeof( volumeInfo ) );
		bzero( &volumeParms, sizeof( volumeParms ) );
		
		// We're mostly interested in the volume reference number (actualVolume)...
		
		result = FSGetVolumeInfo(	kFSInvalidVolumeRefNum,
									volumeIndex,
									&actualVolume,
									kFSVolInfoFSInfo,
									&volumeInfo,
									&volumeName,
									NULL	);
		if( result == noErr )
		{
			result = FSGetVolumeParms( actualVolume, &volumeParms, sizeof( volumeParms ) );
			if( result == noErr )
			{
				if( (char*)volumeParms.vMDeviceID )
				{
					bsdName = [ NSString stringWithUTF8String:(char*)volumeParms.vMDeviceID ];
					
					if( [ bsdName hasPrefix:@"disk" ] )
					{
						shortBSDName = [ bsdName substringFromIndex:4 ];
						
						components = [ shortBSDName componentsSeparatedByString:@"s" ];
						
						if( ( [ components count ] > 1 ) && ( !( [ shortBSDName isEqualToString:[ components objectAtIndex:0 ] ] ) ) )
						{
							if( [ [ components objectAtIndex:0 ] integerValue ] == deviceNumber )
							{
								if( ![ name isEqualToString:kEmptyStringKey ] )
								{
									[ name appendString:@", " ];
								}
								
								[ name appendString:[ NSString stringWithCharacters:volumeName.unicode length:volumeName.length ] ];
							}
						}
					}
				}
			}
		}
	}
	
	#else
	
		#pragma unused( deviceNumber )
	
	#endif
	
	return [ NSString stringWithString:name ];
}

////////////////////////////////////////
// Get the BSD path for a given volume.
////////////////////////////////////////

+ (NSString*)bsdPathForVolume:(NSString*)volume
{
	#if TARGET_OS_IPHONE == 0
	
	ItemCount	volumeIndex = 0;
	OSStatus	result = noErr;
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// Iterate across all mounted volumes using FSGetVolumeInfo. This will return nsvErr
	// (no such volume) when volumeIndex becomes greater than the number of mounted volumes.
	//////////////////////////////////////////////////////////////////////////////////////////
	
	for( volumeIndex = 1; ( result || ( result != nsvErr ) ); volumeIndex++ )
	{
		HFSUniStr255			volumeName;
		FSVolumeInfo			volumeInfo;
		GetVolParmsInfoBuffer	volumeParms;
		FSVolumeRefNum			actualVolume = 0;
		CFStringRef				volNameAsCFString = NULL;
		
		bzero( &volumeName, sizeof( volumeName ) );
		bzero( &volumeInfo, sizeof( volumeInfo ) );
		bzero( &volumeParms, sizeof( volumeParms ) );
		
		// We're mostly interested in the volume reference number (actualVolume)
		
		result = FSGetVolumeInfo(	kFSInvalidVolumeRefNum,
									volumeIndex,
									&actualVolume,
									kFSVolInfoFSInfo,
									&volumeInfo,
									&volumeName,
									NULL	);
		if( !result )
		{
			result = FSGetVolumeParms( actualVolume, &volumeParms, sizeof( volumeParms ) );
			if( !result )
			{
				if( (char*)volumeParms.vMDeviceID )
				{
					///////////////////////////////////////////////////////////////////////////
					// This code is just to convert the volume name from a HFSUniCharStr to
					// a plain C string so we can print it with printf. It'd be preferable to
					// use CoreFoundation to work with the volume name in its Unicode form.
					///////////////////////////////////////////////////////////////////////////
					
					volNameAsCFString = CFStringCreateWithCharacters( kCFAllocatorDefault, volumeName.unicode, volumeName.length );
					
					[ (NSString*)volNameAsCFString autorelease ];
					
					if( [ volume isEqualToString:(NSString*)volNameAsCFString ] )
					{
						return [ NSString stringWithFormat:@"/dev/rdisk%@", [ [ [ [ NSString stringWithUTF8String:(char*)volumeParms.vMDeviceID ] substringFromIndex:4 ] componentsSeparatedByString:@"s" ] objectAtIndex:0 ] ];
					}
				}
			}
		}
	}
	
	#else
	
		#pragma unused( volume )

	#endif
	
	return nil;
}

#pragma mark- Bundle
#pragma mark-

/////////////////////////////////////////////////////////////
// Return an array containing all main bundle localziations.
/////////////////////////////////////////////////////////////

- (NSArray*)allMainBundleLocalizations
{
	return [ kMainBundle localizations ];
}

/////////////////////////////////////////////////////////////
// See if the main bundle is on a locked volume by trying
// to create a temp file in its "Resources" dir.
// Should probably move this to an NSBundle category but
// currently we don't have one.
/////////////////////////////////////////////////////////////

- (BOOL)mainBundleIsOnLockedVolume
{
	NSString			*baseResourcesFolderPath = nil;
	NSMutableString		*finalPathMutableString = nil;
	NSData				*junkData = nil;
	BOOL				created = NO;
	BOOL				locked = YES;
	
	// Get path to "Resources" folder from NSBundle...
	
	baseResourcesFolderPath = [ kMainBundle resourcePath ];
	
	// Mutable...
	
	finalPathMutableString = [ NSMutableString stringWithCapacity:0 ];
	
	// Make some junk data...
	
	junkData = [ NSData dataWithBytes:"YT$UY^TF*TEUHFGDJY(#" length:(NSUInteger)strlen( "YT$UY^TF*TEUHFGDJY(#" ) ];
	
	if( baseResourcesFolderPath && finalPathMutableString && junkData )
	{
		// Make final path to test file...
			
		[ finalPathMutableString appendString:baseResourcesFolderPath ];
		
		[ finalPathMutableString appendString:kSlashStringKey ];
		
		[ finalPathMutableString appendString:@"HDT_temp_test_file" ];
		
		// Try to create it...
			
		created = [ [ NSFileManager defaultManager ] createFileAtPath:finalPathMutableString contents:junkData attributes:nil ];
		if( created )
		{
			locked = NO;
			
			// Now delete it...
			
			(void)[ [ NSFileManager defaultManager ] removeItemAtPath:finalPathMutableString error:nil ];
		}
	}
	
	return locked;
}

///////////////////////////////////////////////////////////////////
// Find which localization user has set in System Preferences...
///////////////////////////////////////////////////////////////////

- (NSString*)preferredLocalization
{
	NSArray		*preferredLocalizationsArray = nil;
	NSString	*languageString = nil;
	
	preferredLocalizationsArray = [ NSBundle preferredLocalizationsFromArray:[ kMainBundle localizations ] ];

	languageString = [ preferredLocalizationsArray objectAtIndex:0 ];
	
	return languageString;
}

///////////////////////////////////////////////////////////////////////////////////
// Return full path to the .lproj folder for the currently set language in Prefs.
///////////////////////////////////////////////////////////////////////////////////

- (NSString*)preferredLocalizationCurrentLprojFolderFullPath
{
	NSString			*languageString = nil;
	NSMutableString		*mutablePathString = nil;
	
	languageString = [ self preferredLocalization ];
	
	mutablePathString = [ NSMutableString stringWithCapacity:0 ];
	
	// Append bundle path...
	
	[ mutablePathString appendString:[ kMainBundle bundlePath ] ];
	
	// Append "/Contents/Resources/"...
	
	[ mutablePathString appendString:kSlashStringKey ];
	[ mutablePathString appendString:kMacAppBundleContentsSubDirNameNSString ];
	[ mutablePathString appendString:kSlashStringKey ];
	[ mutablePathString appendString:kMacAppBundleResourcesSubDirNSString ];
	[ mutablePathString appendString:kSlashStringKey ];
	
	// Append localized language folder name...
	
	[ mutablePathString appendString:languageString ];
	
	// Append .lproj folder extension...
	
	[ mutablePathString appendString:kDotStringKey ];
	[ mutablePathString appendString:kLanguageFolderExtension ];
	
	return [ NSString stringWithString:mutablePathString ];
}

#pragma mark- File
#pragma mark-

/////////////////////////////////////////////////////////////
// Add the extended attribute to the file indicated at URL.
/////////////////////////////////////////////////////////////

- (BOOL)addExtendedAttribute:(NSString*)attributeString toItemAtURL:(NSURL*)URL
{
	const char	*filePath = [ [ URL path ] fileSystemRepresentation];
	const char	*attrName = nil;
	u_int8_t	attrValue = 1;
	int			result = 0;
	
	attrName = [ attributeString UTF8String ];
	
	if( attributeString && URL && filePath && attrName )
	{
		result = setxattr( filePath, attrName, &attrValue, sizeof( attrValue ), 0, 0 );
	}
	
    return (BOOL)( result == 0 );
}

//////////////////////////////////////////////////////////////////
// Add the 'skip backup' attribute to the file indicated at URL.
//////////////////////////////////////////////////////////////////

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL
{
	int result = 0;
	
	if( URL )
	{
		result = (int)[ self addExtendedAttribute:@"com.apple.MobileBackup" toItemAtURL:URL ];
	}
	
     return (BOOL)( result == 0 );
}

#pragma mark- Power
#pragma mark-

///////////////////////////////////
// See if the host HAS a battery.
///////////////////////////////////

+ (BOOL)hasBattery
{
	BOOL		result = FALSE;
	
	#if TARGET_OS_IPHONE == 0
	
	BOOL		checked = FALSE;
	CFTypeRef	ps_info = IOPSCopyPowerSourcesInfo();
	
	if( !checked )
	{
		checked = TRUE;
		
		if( kCFBooleanTrue == IOPSPowerSourceSupported( ps_info, CFSTR( kIOPMBatteryPowerKey ) ) )
		{
			result = TRUE;
		}
	}
	
	CFRelease( ps_info );
	
	ps_info = NULL;
	
	#endif
	
	return result;
}

//////////////////////////////////////////////////
// See if thei host is running on battery power.
//////////////////////////////////////////////////

+ (BOOL)runsOnBattery
{
	BOOL			ret = NO;
	
	#if TARGET_OS_IPHONE == 0
	
	CFTypeRef		ps_info = IOPSCopyPowerSourcesInfo();
	CFStringRef		ps_name = NULL;
	
	if( ps_info )
	{
		ps_name = (CFStringRef)IOPSGetProvidingPowerSourceType( ps_info );
		if( ps_name )
		{
			ret = (BOOL)CFEqual( CFSTR( kIOPMBatteryPowerKey ), ps_name );
		}
		
		CFRelease( ps_info );
	}
	
	#endif
	
	return ret;
}

@end

#pragma mark- C Protos
#pragma mark-

#if TARGET_OS_IPHONE == 0

//////////////////////////////////////////////////////////////////////////////
// Returns an iterator containing the primary (built-in) Ethernet interface.
// The caller is responsible for releasing the iterator after the caller
// is done with it.
//////////////////////////////////////////////////////////////////////////////

kern_return_t FindEthernetInterfaces( io_iterator_t *matchingServices )
{
	kern_return_t			kernResult = 0;
	mach_port_t				masterPort = 0;
	CFMutableDictionaryRef	matchingDict = NULL;
	CFMutableDictionaryRef	propertyMatchDict = NULL;
	
	// Retrieve the Mach port used to initiate communication with I/O Kit...
	
	kernResult = IOMasterPort( MACH_PORT_NULL, &masterPort );
	if( kernResult == KERN_SUCCESS )
	{
		//////////////////////////////////////////////////////////////////////////
		// Ethernet interfaces are instances of class kIOEthernetInterfaceClass.
		// IOServiceMatching is a convenience function to create a dictionary
		// with the key kIOProviderClassKey and the specified value.
		//////////////////////////////////////////////////////////////////////////
		
		matchingDict = IOServiceMatching( kIOEthernetInterfaceClass );
	
		// Note that another option here would be: matchingDict = IOBSDMatching("en0");
		
		if( matchingDict )
		{
			// Each IONetworkInterface object has a Boolean property with the key kIOPrimaryInterface. Only the
			// primary (built-in) interface has this property set to TRUE.
			
			// IOServiceGetMatchingServices uses the default matching criteria defined by IOService. This considers
			// only the following properties plus any family-specific matching in this order of precedence
			// (see IOService::passiveMatch):
			//
			// kIOProviderClassKey (IOServiceMatching)
			// kIONameMatchKey (IOServiceNameMatching)
			// kIOPropertyMatchKey
			// kIOPathMatchKey
			// kIOMatchedServiceCountKey
			// family-specific matching
			// kIOBSDNameKey (IOBSDNameMatching)
			// kIOLocationMatchKey
			
			// The IONetworkingFamily does not define any family-specific matching. This means that in
			// order to have IOServiceGetMatchingServices consider the kIOPrimaryInterface property, we must
			// add that property to a separate dictionary and then add that to our matching dictionary
			// specifying kIOPropertyMatchKey.
			
			propertyMatchDict = CFDictionaryCreateMutable( kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks );
			if( propertyMatchDict )
			{
				// Set the value in the dictionary of the property with the given key, or add the key
				// to the dictionary if it doesn't exist. This call retains the value object passed in.
				
				CFDictionarySetValue( propertyMatchDict, CFSTR( kIOPrimaryInterface ), kCFBooleanTrue );
				
				// Now add the dictionary containing the matching value for kIOPrimaryInterface to our main
				// matching dictionary. This call will retain propertyMatchDict, so we can release our reference
				// on propertyMatchDict after adding it to matchingDict.
				
				CFDictionarySetValue( matchingDict, CFSTR( kIOPropertyMatchKey ), propertyMatchDict );
				
				CFRelease( propertyMatchDict );
			}
		}
	
		// IOServiceGetMatchingServices retains the returned iterator, so release the iterator when we're done with it.
		// IOServiceGetMatchingServices also consumes a reference on the matching dictionary so we don't need to release
		// the dictionary explicitly.
			
		kernResult = IOServiceGetMatchingServices( masterPort, matchingDict, matchingServices );
	}
	
	return kernResult;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Given an iterator across a set of Ethernet interfaces, return the MAC address of the last one.
// If no interfaces are found the MAC address is set to an empty string.
// In this sample the iterator should contain just the primary interface.
///////////////////////////////////////////////////////////////////////////////////////////////////

kern_return_t GetMACAddress( io_iterator_t intfIterator, UInt8 *MACAddress )
{
	kern_return_t	kernResult = KERN_FAILURE;
	
	io_object_t		intfService = 0;
	io_object_t		controllerService = 0;
	
	// Initialize the returned address...
	
	bzero( MACAddress, kIOEthernetAddressSize );
	
	// IOIteratorNext retains the returned object, so release it when we're done with it...
	
	while( ( intfService = IOIteratorNext( intfIterator ) ) )
	{
		CFTypeRef MACAddressAsCFData = NULL;
		
		// IONetworkControllers can't be found directly by the IOServiceGetMatchingServices call,
		// since they are hardware nubs and do not participate in driver matching. In other words,
		// registerService() is never called on them. So we've found the IONetworkInterface and will
		// get its parent controller by asking for it specifically.
		
		// IORegistryEntryGetParentEntry retains the returned object, so release it when we're done with it.
		
		kernResult = IORegistryEntryGetParentEntry( intfService, kIOServicePlane, &controllerService );
		if( kernResult == KERN_SUCCESS )
		{
			// Retrieve the MAC address property from the I/O Registry in the form of a CFData...
			
			MACAddressAsCFData = IORegistryEntryCreateCFProperty( intfService, CFSTR( kIOMACAddress ), kCFAllocatorDefault, 0	);
			if( MACAddressAsCFData )
			{
				// CFShowDebug(MACAddressAsCFData); for display purposes only; output goes to stderr
				
				// Get the raw bytes of the MAC address from the CFData...
				
				CFDataGetBytes( MACAddressAsCFData, CFRangeMake( 0, kIOEthernetAddressSize ), MACAddress );
				
				CFRelease( MACAddressAsCFData );
			}
			
			// Done with the parent Ethernet controller object so we release it...
			
			(void)IOObjectRelease( controllerService );
		}
		
		// Done with the Ethernet interface object so we release it...
		
		(void)IOObjectRelease( intfService );
	}
	
	return kernResult;
}

#endif

