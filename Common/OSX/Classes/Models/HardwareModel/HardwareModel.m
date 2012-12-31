/*********************************************************************************
File:			HardwareModel.h.m

Date:			5/2/11

Version:		1.0

Authors:		soundcore

				Copyright 2011 by soundcore All rights reserved worldwide.

Notes:			HardwareModel.h implementation. See notes in header.

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore. ANY SUCH DISTRIBUTION CARRIES SEVERE
				CRIMINAL AND CIVIL PENALTIES AND IS A VIOLATION OF
				INTERNATIONAL COPYRIGHT LAW. VIOLATORS WILL BE
				PROSECUTED TO THE FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	See header.

Changes:		See header.

*********************************************************************************/

#import <mach/mach.h>
#import <sys/param.h>
#import <sys/sysctl.h>
#import <sys/time.h>
#import <sys/types.h>

#import <SystemConfiguration/SCDynamicStoreCopySpecific.h>

#import "HardwareModel.h"
#import "HardwareModelLocalizableStrings.h"

@implementation HardwareModel

@synthesize osVersion,
appHardwareModelNameInternalString,
computerNameString,
macModelNameString,
cpuTypeString,
numProcessors,
processorNameString,
processorSpeedString,
physicalRAMString,
userNameString,
machineIconImage,
displayCount,
displayIDsArray;

#pragma mark-
#pragma mark Init & Term
#pragma mark-

+ (void)initialize
{
}

+ (id)init
{
	return [ [ [ HardwareModel alloc ] init ] autorelease ];
}

////////////////////////////////
// - 'init' message override.
////////////////////////////////

- (id)init
{
	 SInt32		response = 0;
	 OSStatus	err = noErr;
	
	if( ( self = [ super init ] ) )
	{
		// Load OS version (We should probably cut this over to sysctl at some point)...
		
		err = Gestalt( gestaltSystemVersion, &response );
		if( !err )
		{
			self.osVersion = response;
		}
		
		// Load base hardware model string...
		
		[ self loadHardwareModelName ];
		
		// Load computer name...
			
		[ self loadComputerName ];
		
		// Load Mac model string...
			
		[ self loadMacModelName ];
		
		// Load CPU type string...
		
		[ self loadCPUTypeString ];
		
		// Load # processors...
		
		[ self loadNumProcessors ];
		
		// Load processor marketing name string...
		
		[ self loadProcessorName ];
		
		// Load processor speed string...
		
		[ self loadProcessorSpeed ];
		
		// Load physical RAM string...
		
		[ self loadPhysicalRAM ];
		
		// Load user name...
		
		[ self loadUserName ];
		
		// Load machine icon...
		
		[ self loadMachineIcon ];
		
		// Load displays info...
		
		[ self loadDisplays ];
	}
	
	return self;
}

//////////////////////////////////
// - 'dealloc' message override.
//////////////////////////////////

- (void)dealloc
{
	self.appHardwareModelNameInternalString = nil;
	
	[ self.computerNameString release ];
	
	[ self.macModelNameString release ];
	
	[ self.cpuTypeString release ];
	
	[ self.processorNameString release ];
	
	[ self.processorSpeedString release ];
	
	[ self.physicalRAMString release ];
	
	[ self.userNameString release ];
	
	[ self.machineIconImage release ];
	
	[ self.displayIDsArray release ];
	
	[ super dealloc ];
}

#pragma mark-
#pragma mark Internal - Machine Names
#pragma mark-

///////////////////////////////////////////////////////////////////////////
// Get the raw sysctlbyname hardware model string. This is typically what
// shows up in System Profiler.app under "Model Identifier" and looks
// like "MacBook2,1" for example.
///////////////////////////////////////////////////////////////////////////

- (void)loadHardwareModelName
{
    char		buffer[ 256 ];
	size_t		length = sizeof( buffer );
	NSString	*hardwareModelString = nil;
    
	memset( buffer, 0, length );
	
	// Release old if any...
	
	self.appHardwareModelNameInternalString = nil;
	
	// Use sysctlbyname to get name...
	
	if( !sysctlbyname( ksysctlbyname_hw_model_CString, &buffer, &length, NULL, 0 ) )
	{
		hardwareModelString = [ [ NSString alloc ] initWithCString:buffer encoding:NSASCIIStringEncoding ];
	}
	
	if( !hardwareModelString || ![ hardwareModelString length ] )
	{
		// Release empty if it was allocated...
		
		if( hardwareModelString )
		{
			[ hardwareModelString release ];
		}
		
		// Unknown model so just use "Unknown"...
	
		hardwareModelString = [ [ NSString alloc ] initWithString:kUnknownMacModelName ];
	}
	
    // Copy...
	
	if( hardwareModelString )
	{
		self.appHardwareModelNameInternalString = hardwareModelString;
	
		// Release hardwareModelString since assignment above copies it...
	
		[ hardwareModelString release ];
	}
}

////////////////////////////////////////////////////////////////////////////////
// Get the name of the computer using sysctl, which on OS X is the hostname.
////////////////////////////////////////////////////////////////////////////////

- (void)loadComputerName
{
	char		nameStringC[ kTempCStringBufferLength ];
	int			mib[ 6 ];
	size_t		needed = kTempCStringBufferLength;
	
	memset( nameStringC, 0, sizeof( nameStringC ) );
		
	// Release old if any...
	
	[ self.computerNameString release ];
	
	memset( mib, 0, sizeof( mib ) );
	
	mib[ 0 ] = CTL_KERN;
	mib[ 1 ] = KERN_HOSTNAME;
	
	sysctl( mib, 2, nameStringC, &needed, 0, 0 );
	
	// Make NSString...
			
	self.computerNameString = [ [ NSString alloc ] initWithCString:nameStringC encoding:NSASCIIStringEncoding  ];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Attempt to load a human-readable Mac model name from the Macintosh.dict file stored in the app's bundle.
// If that fails, use the original, less-readable hardware model name from -loadHardwareModelName.
// Macintosh.dict maps -loadHardwareModelName strings to human-readable Mac machine model names.
//
// Note that the Macintosh.dict file is in old-style OpenStep format (NSPropertyListOpenStepFormat).
// This is for easy modification compared to a new-style .plist file. Hence when we load the Macintosh.dict
// file, we must use NSPropertyListSerialization to convert it from the old-style to new .plist-style.
//
// Note that the Macintosh.dict file should be updated from time to time with new model strings.
///////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadMacModelName
{
	NSString				*computerModelString = nil;
	NSString				*path = nil;
	NSString				*noMatchingEntryFoundString = nil;
	NSMutableString			*noMatchingHardwareModelStringMutable = nil;
	NSData					*plistData = nil;
	NSPropertyListFormat	format = NSPropertyListOpenStepFormat;
	id						plist = nil;
	NSString				*error = nil;
	
	// Release old if any...
	
	[ self.macModelNameString release ];
	
	// Make mutable...
	
	noMatchingHardwareModelStringMutable = [ NSMutableString stringWithCapacity:0 ];
			
	// Make path to the Macintosh.dict file inside the app bundle...
	
	path = [ kMainBundle pathForResource:kMacModelsFileName ofType:kStaticDictFilenameExtension ];
	
	if( noMatchingHardwareModelStringMutable && path && self.appHardwareModelNameInternalString )
	{
		// Load Macintosh.dict as NSData...
		
		plistData = [ NSData dataWithContentsOfFile:path ];
		if( plistData )
		{
			// Convert OpenStep-style data to new .plist format...
			
			plist = [ NSPropertyListSerialization propertyListFromData:plistData
													mutabilityOption:NSPropertyListImmutable
													format:&format errorDescription:&error ];
			
			// Load the matching human-readable model name from Macintosh.dict, given the less-readble raw Apple hardware model value (such as "Mac10,1")...
				
			computerModelString = [ plist objectForKey:self.appHardwareModelNameInternalString ];
			if( ( !computerModelString || ![ computerModelString length ] ) )
			{
				// If that failed, just make a raw hardware string. Load "No matching entry found" loacalized string...
				
				noMatchingEntryFoundString = [ kMainBundle localizedStringForKey:kHMNoMatchingHardwareModelFoundErrStringKey value:nil table:kHardwareModelStringsFileName ];
				if( noMatchingEntryFoundString )
				{
					// Append labels, etc...
					
					if( ![ noMatchingEntryFoundString isEqualToString:kHMNoMatchingHardwareModelFoundErrStringKey ] )
					{
						[ noMatchingHardwareModelStringMutable appendString:noMatchingEntryFoundString ];
						
						[ noMatchingHardwareModelStringMutable appendString:kSpaceStringKey ];
						
						[ noMatchingHardwareModelStringMutable appendString:[ kMainBundle localizedStringForKey:kHWMachineInfoHardwareModelIsLabelKey value:nil table:kHardwareModelStringsFileName ] ];
						
						[ noMatchingHardwareModelStringMutable appendString:kSpaceStringKey ];
						
						[ noMatchingHardwareModelStringMutable appendString:self.appHardwareModelNameInternalString ];
						
						computerModelString = [ NSString stringWithString:noMatchingHardwareModelStringMutable ];
					}
					else
					{
						// Just use raw Apple hardware model with message...
						
						computerModelString = [ NSString stringWithFormat:[ kMainBundle localizedStringForKey:kHWMachineInfoHardwareModelNoMatchingEntryFoundKey
																							value:nil
																							table:kHardwareModelStringsFileName ], self.appHardwareModelNameInternalString ];
					}
				}
			}
		}
    }
	
    // Assign...
	
	self.macModelNameString = [ NSString stringWithString:computerModelString ];
}

#pragma mark-
#pragma mark Internal - Processors
#pragma mark-

/////////////////////////////////////////////////
// Load CPU type as a string.
// TODO: CPU_TYPE strings need to be localized.
/////////////////////////////////////////////////

- (void)loadCPUTypeString
{
	host_basic_info_data_t		hostInfo;
    mach_msg_type_number_t		infoCount = HOST_BASIC_INFO_COUNT;
    NSString					*cpuString = nil;
	mach_port_t					port = 0;
	kern_return_t				ret = 0;
	
	memset( &hostInfo, 0, sizeof( hostInfo ) );

	// Release old if any...
	
	[ self.cpuTypeString release ];
	
	// Get host basic info...
	
	port = mach_host_self();
	
	ret = host_info( port, HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount );
    if( ret == KERN_SUCCESS )
    {
        // Allocate and init CPU type string...
		
		if( hostInfo.cpu_type == CPU_TYPE_POWERPC )
        {
			// PowerPC
			
			cpuString = [ kMainBundle localizedStringForKey:MY_CPU_TYPE_PPC value:nil table:kHardwareModelStringsFileName ];
		}
        else if( hostInfo.cpu_type == CPU_TYPE_I386 )
        {
           // Intel x86
		   
			cpuString = [ kMainBundle localizedStringForKey:MY_CPU_TYPE_I386 value:nil table:kHardwareModelStringsFileName ];
		 }
        else
        {
             // Unknown
			 
			 cpuString = [ kMainBundle localizedStringForKey:MY_CPU_TYPE_DEFAULT value:nil table:kHardwareModelStringsFileName ];
		}
    }
    else
    {
		 // Unknown
		 
		 cpuString = [ kMainBundle localizedStringForKey:MY_CPU_TYPE_DEFAULT value:nil table:kHardwareModelStringsFileName ];
	}
	
	// Copy...
	
	self.cpuTypeString = [ NSString stringWithString:cpuString ];
}

////////////////////////////////////////////
// Load # of cores or CPUs as an NSInteger.
////////////////////////////////////////////

- (void)loadNumProcessors
{
	int			mib[ 2 ];
	NSUInteger	cores = 0;
	size_t		len = sizeof( cores );
	
	// Set up command...
	
	mib[ 0 ] = CTL_HW;
	mib[ 1 ] = HW_NCPU;
	
	(void)sysctl( mib, 2, &cores, &len, NULL, 0 );
	
	self.numProcessors = cores;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Get the CPU marketing name using sysctlbyname. Note that "machdep.cpu.brand_string" only works
// on Intel CPUs and will fail if we are on a PPC Mac. The only possible values for the Gestalt
// selector 'gestaltNativeCPUtype' are:
//
// See HardwareModelLocalizableStrings.h for possible processor types.
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadProcessorName
{
	char				buffer[ kTempCStringBufferLength ];
	size_t				length = sizeof( buffer );
	SInt32				aResult = 0;
	NSString			*keyString = nil;
	OSStatus			err = noErr;
	
	memset( buffer, 0, length );
	
	// Release old if any...
	
	[ self.processorNameString release ];
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	// First see if we are on a PPC or Intel Mac. If Intel, use sysctlbyname to get the direct
	// marketing name. If PPC, we need to use Gestalt to get the PPC CPU type, then do a lookup
	// using the constant for the returned value as the key into the localizable strings file.
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	// Use sysctlbyname (assume Intel Mac first)...
	
	if( !sysctlbyname( ksysctlbyname_hw_machine_cpu_name_CString, &buffer, &length, NULL, 0 ) )
	{
		self.processorNameString = [ [ NSString alloc ] initWithCString:buffer encoding:NSASCIIStringEncoding ];
	}
	
	// If the string was nil, try PPC and do a lookup to get the name......
	
	if ( !self.processorNameString || ![ self.processorNameString length ] )
	{
		// Get CPU value from Gestalt...
		
		err = Gestalt( gestaltNativeCPUtype, &aResult );
		if( !err )
		{
			// Make a key string from the Gestalt value so we can lookup the name in Localizable.strings...
			
			switch( aResult )
			{
				// PowerPC
				
				case gestaltCPU601:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU601 ];
					
					break;
					
				case gestaltCPU603:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU603];
					
					break;
					
				case gestaltCPU604:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU604 ];
					
					break;
					
				case gestaltCPU603e:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU603e ];
					
					break;
					
				case gestaltCPU603ev:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU603ev ];
					
					break;
					
				case gestaltCPU750:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU750 ];
					
					break;
					
				case gestaltCPU604e:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU604e ];
					
					break;
					
				case gestaltCPU604ev:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU604ev ];
					
					break;
					
				case gestaltCPUG4:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPUG4 ];
					
					break;
					
				case gestaltCPUG47450:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPUG47450 ];
					
					break;
					
				// Later PowerPC
				
				case gestaltCPUApollo:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPUApollo ];
					
					break;
					
				case gestaltCPUG47447:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPUG47447 ];
					
					break;
					
				case gestaltCPU750FX:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU750FX ];
					
					break;
					
				case gestaltCPU970:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU970 ];
					
					break;
					
				case gestaltCPU970FX:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU970FX ];
					
					break;
					
				case gestaltCPU970MP:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU970MP ];
					
					break;
					
				// Intel
				
				case gestaltCPU486:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPU486 ];
					
					break;
					
				case gestaltCPUPentium:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPUPentium ];
					
					break;
					
				case gestaltCPUPentiumPro:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPUPentiumPro ];
					
					break;
					
				case gestaltCPUPentiumII:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPUPentiumII ];
					
					break;
					
				case gestaltCPUX86:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPUX86 ];
					
					break;
					
				case gestaltCPUPentium4:
				
					keyString = [ [ NSString alloc ] initWithString:kgestaltCPUPentium4 ];
					
					break;
					
				default:
				
					// Unknown...
					
					keyString = [ [ NSString alloc ] initWithString:[ kMainBundle localizedStringForKey:kHWUnknownLabelKey value:nil table:kHardwareModelStringsFileName ] ];
					
					break;
			}
			
			// Get the human-readable processor name string using the key string...
			
			self.processorNameString = [ [ NSString alloc ] initWithString:[ kMainBundle localizedStringForKey:keyString value:nil table:kHardwareModelStringsFileName ] ];
		}
	}
}

//////////////////////////////////////////////////////////
// Get the CPU speed as a string. Get the CPU frequency,
// chop it down to a readable size, add the Mhz or Ghz
// label to it.
///////////////////////////////////////////////////////////

- (void)loadProcessorSpeed
{
	int					mib[ 2 ];
	NSUInteger			val = 0;
	size_t				size = sizeof( val );
	double				finalSpeed = 0.0;
	NSString			*tempString = nil;
	NSMutableString		*speedLabelStr = nil;
	
	// Release old if any...
	
	[ self.processorSpeedString release ];
	
	mib[ 0 ] = CTL_HW;
	mib[ 1 ] = HW_CPU_FREQ;
	
	(void)sysctl( mib, 2, &val, &size, NULL, 0 );
	
	////////////////////////////
	// Convert to MHz or GHz...
	////////////////////////////
	
	if( val >= kOneGhz )
	{
		// GHz
		
		finalSpeed = ( val / kOneGhzDecimal );
		
		// Get Ghz label...
		
		tempString = [ kMainBundle localizedStringForKey:kHWMachineInfoGHzLabelKey value:nil table:kHardwareModelStringsFileName ];
	}
	else
	{
		// MHz
		
		finalSpeed = ( val / kOneMhzDecimal );
		
		// Get Mhz label...
		
		tempString = [ kMainBundle localizedStringForKey:kHWMachineInfoMHzLabelKey value:nil table:kHardwareModelStringsFileName ];
	}
	
	// Make mutable...
		
	speedLabelStr = [ NSMutableString stringWithCapacity:0 ];
	
	[ speedLabelStr appendString: [ [ NSNumber numberWithDouble:finalSpeed ] stringValue ] ];
	
	[ speedLabelStr appendString:tempString ];
	
	// Copy...
	
	self.processorSpeedString = [ [ NSString alloc ] initWithString:speedLabelStr ];
}

#pragma mark-
#pragma mark Internal - Memory
#pragma mark-

///////////////////////////////////////////////////////////////////////
// Get physical RAM size with MB, GB or TB label appended to end.
//
// Note that both Gestalt and sysctl report incorrect memory
// sizes if the machine is using certain high-performance SO-DIMM
// modules. With these kinds of DIMMs both routines will always
// report a max of 2GB even if the amount of RAM is higher.
//
// Also note that as of 10.6 Gestalt RAM sizes no longer seem to be
// correct.
//
// We need to dive into Darwin and find out how the Finder's Get Info
// window reports RAM sizes because it does it correctly - even with
// the high-performance DIMMs.
//
// Also note that for later systems, HW_PHYSMEM is no longer valid
// and HW_MEMSIZE must always be used to get the correct amount of RAM,
// especially if the system has more than 1GB.
////////////////////////////////////////////////////////////////////////

- (void)loadPhysicalRAM
{
	int					error = 0;
	uint64_t			aResult = 0;
	size_t				length = sizeof( aResult );
	int					selection[ 2 ] = { CTL_HW, HW_MEMSIZE };
	long long			num = 0;
	NSMutableString		*finalString = nil;
	NSString			*labelString = nil;
	NSString			*unknownString = nil;
	
	// Release old if any...
	
	[ self.physicalRAMString release ];
	
	// Make mutable...
	
	finalString = [ NSMutableString stringWithCapacity:0 ];
	
	// Get "Unknown" label just in case...
	
	unknownString = [ kMainBundle localizedStringForKey:kHWUnknownLabelKey value:nil table:kHardwareModelStringsFileName ];

	if( finalString && unknownString )
	{
		// Get RAM size...
		
		error = sysctl( selection, 2, &aResult, &length, NULL, 0 );
		if( !error )
		{
			// Calc if RAM is a MB/GB/TB sized value...
			
			if( ( aResult < kOneGB ) )
			{
				// MB
				
				labelString = kMBLabelNSString;
				
				// Chop number down to # of MBs
				
				num = (long long)( aResult / kOneMB );
			}
			else if( ( aResult >= kOneGB ) && ( aResult < kOneTB ) )
			{
				// GB
				
				labelString = kGBLabelNSString;
				
				// Chop number down to # of GBs: If <= 8GB, calc one way, else calc another way...
				
				if( ( aResult <= 8589934592 ) )
				{
					num = (long long)( aResult / kOneGB );
				}
				else
				{
					num = (long long)( aResult / 1073741824 );		// 1073741824 == Real 1GB (1024 * 1024 * 1024)
				}
			}
			else if( ( aResult >= kOneTB ) )
			{
				// TB
				
				labelString = kTBLabelNSString;
				
				// Chop number down to # of TBs
				
				num = (long long)( aResult / kOneTB );
			}
			
			// Assemble final string...
		
			[ finalString appendString:[ [ NSNumber numberWithLongLong:num ] stringValue ] ];	// Number
				
			[ finalString appendString:kSpaceStringKey ];										// Space
				
			[ finalString appendString:labelString ];											// Label
		}
		else
		{
			// Unknown RAM size...
			
			[ finalString appendString:unknownString ];
		}
	}
	
	// Copy..
	
	self.physicalRAMString = [ [ NSString alloc ] initWithString:finalString ];
}

#pragma mark-
#pragma mark Internal - Current User
#pragma mark-

///////////////////////////////////////
// Load the current console user name.
///////////////////////////////////////

- (void)loadUserName
{
	NSString *consoleUserName = nil;
		
	// Get user name from System Config Framework...
		
	consoleUserName = (NSString*)SCDynamicStoreCopyConsoleUser( NULL, NULL, NULL );
	if( consoleUserName )
	{
		// Allocate copy...
		
		self.userNameString = [ NSString stringWithString:consoleUserName ];
		
		// Clean up...
		
		CFRelease( consoleUserName );
	}
}

#pragma mark-
#pragma mark Internal - Machine Icon
#pragma mark-

////////////////////////////////////////////////////////////////////////
// Use the IconFamily library to load the machine icon as an NSImage.
// We only load the icon if it has not already been loaded previously.
// Otherwise we keep it cached to improve performance since the icon
// cannot change within the same app session. We convert the icon to
// an NSImage here once and store it in the model so that we have it
// available when we need it.
// http://iconfamily.sourceforge.net
////////////////////////////////////////////////////////////////////////

- (void)loadMachineIcon
{
	IconFamily			*family = nil;
	NSBitmapImageRep	*familyImageRep = nil;
	
	// Only load the icon if it's not already loaded...
	
	if( !self.machineIconImage )
	{
		////////////////////////////////////////////////////////////////////////
		// Use IconFamily lib to make an NSImage from the ystem icon family...
		////////////////////////////////////////////////////////////////////////
		
		family = [ [ IconFamily alloc ] initWithSystemIcon:kComputerIcon ];
		if( family )
		{
			// Make an NSBitmapImageRep for the icon at the size specified...
			
			familyImageRep = [ family bitmapImageRepWithAlphaForIconFamilyElement:kLarge32BitData ];
			if( familyImageRep )
			{
				// Make a new NSImage from the rep...
				
				self.machineIconImage = [ [ NSImage alloc ] init ];
				if( self.machineIconImage )
				{
					// Add it to the object...
					
					[ self.machineIconImage addRepresentation:(NSImageRep*)familyImageRep ];
				}
			}
			
			[ family release ];
		}
	}
}

#pragma mark-
#pragma mark Internal - Displays
#pragma mark-

/////////////////////////////////////////////////
// Load # of displays and array of display IDs.
/////////////////////////////////////////////////

- (void)loadDisplays
{
	CGDisplayCount			i = 0;
	CGDirectDisplayID		tempArray[ kMaxDisplaysSupported ] = { 0 };
	CGDisplayCount			dspCount = 0;
	NSNumber				*tempDisplayID = nil;
	CGDisplayErr			err = noErr;
	
	// Get display count & array...
	
	err = CGGetOnlineDisplayList( kMaxDisplaysSupported, tempArray, &dspCount );
	if( !err )
	{
		// Assign dspCount...
		
		self.displayCount = dspCount;
		
		// Create empty array...
		
		self.displayIDsArray = [ [ NSMutableArray alloc ] initWithCapacity:0 ];
		
		// Loop all displays found...
		
		for( i = 0; i < self.displayCount; i++ )
		{
			// Make a new NSNumber from this display index...
			
			tempDisplayID = [ NSNumber numberWithUnsignedLong:(unsigned long)tempArray[ i ] ];
			
			// Add to array...
			
			[ self.displayIDsArray addObject:tempDisplayID ];
		}
	}
}

@end
