#include <mach/mach.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <strings.h>
#include <nlist.h>
#include <fcntl.h>
#include <string.h>

#include <sys/types.h>
#include <sys/param.h>
#include <sys/time.h>

#include <libc.h>

#include <cb.h>

#include "cbUtilsMac.h"
#include <cbUtilsPath.h>

@implementation cbUtilsMac

#pragma mark --------------------------------
#pragma mark cbUtilsMac Object - Overrides
#pragma mark --------------------------------

////////////////////
// - init
////////////////////

- (id)init
{
	self = [ super init ];
	
	return self;
}

////////////////////
// Release parent
////////////////////

- (void)dealloc
{
	[ super dealloc ];
}

#pragma mark -------------------------------------------
#pragma mark cbUtilsMac Object - Animation Utils
#pragma mark -------------------------------------------

/////////////////////////////////////////////////////////////////
// Run the poof animation in the center of the main display.
// 'poofSize' is the size of the image in pixels on one side.
/////////////////////////////////////////////////////////////////

- (void)poof:(unsigned)poofSize
{
	NSRect			screenRect = { 0, 0, 0, 0 };
	NSPoint			poofOrigin = { 0, 0 };
	NSSize			imageSize = { poofSize, poofSize };

	// Get the screen rect of our main display...
			
	screenRect = [ [ NSScreen mainScreen ] frame ];
				
	// Calc new vertical position for poof...
	
	poofOrigin.y = ( screenRect.origin.y + ( screenRect.size.height / 2.0 ) );
	
	// Calc new horizontal position for poof...
	
	poofOrigin.x = ( screenRect.origin.y + ( screenRect.size.width / 2.0 ) );
					
	NSShowAnimationEffect(	NSAnimationEffectPoof,
							poofOrigin,
							imageSize,
							nil,
							nil,
							nil	);
}

#pragma mark -------------------------------------
#pragma mark cbUtilsMac Object - App Utils
#pragma mark -------------------------------------

///////////////////////////////////////////////////////////////////////////////////////////
// Find an app on the boot volume by creator and return its bundle & FSRef.
// Caller must release outBundle. On input, outRef must not be NULL. On exit, outRef
// will contain the FSRef to the found bundle, if any, and outBundle will be the found
// NSBundle, if any was found.
//
// Note that we skip most hidden, system, and developer directories when searching for
// the target app as it would vastly increase the search time if we didn't. We also
// skip most of the big iApps in /Applications because some of them are huge and it would
// also take quite a long time to iterate through their bundles (which we know will never
// contain the target app we are looking for). More apps to skip can be added to the list
// in cb.h if desired.
//
// Unfortunately, one of the biggest holes in the Foundation/Cocoa file system API is that
// there is no efficient way in either Cocoa or Carbon to locate bundles by either
// creator or bundle identifier. The most efficient way is to do a FSGetVolumeInfo, and
// then use a NSDirectoryEnumerator on the volume's fullpath to iterate the volume. In
// nearly all cases, a search from the root of any volume with an OS on it is going to be
// expensive because a default OS X install is around 100,000 files - 150,000+ with the
// dev tools installed. Right now there is no way around this problem. Apple needs to add
// an efficient bundle-search API to Cocoa or Foundation in order to make this faster. We
// use the skip dir/iApp hack as a way to speed it up for now.
///////////////////////////////////////////////////////////////////////////////////////////

- (OSStatus)locateBundleOnDisk:(NSBundle**)outBundle forCreator:(OSType)creator withRef:(FSRef*)outRef
{
	Boolean							converted = false;
	
	NSString						*tempString = nil;
	
	NSMutableString					*volNameString = nil;									// Volume names & paths for for app search.
	NSMutableString					*itemFullPathString = nil;								// Full path to each item to inspect.
	
	FSVolumeRefNum					tempActualVolumeRefNumRefNum = 0;						// Stuff for FSGetVolumeInfo.
	FSVolumeInfo					tempVolInfo;
	HFSUniStr255					tempVolNameUniStr255;
	FSRef							tempVolRootDirectoryRef;
	
	NSString						*inputCreatorString = nil;								// String for creator.
	
	NSString						*bundleCreatorString = nil;								// Stuff for the found app/bundle.
	NSString						*bundlePathString = nil;
	NSURL							*bundleURL = nil;
	
	NSDirectoryEnumerator			*volumeEnumerator = nil;								// Enumerator stuff for app search.
	NSString						*enumeratedItem = nil;
	NSString						*enumeratedItemPathExtension = nil;
	NSBundle						*enemueratedItemBundle = nil;
	NSDictionary					*enumeratedItemDictionary = nil;
	
	NSFileManager					*defaultFileManager = nil;
	cbPathUtils						*pathUtils = nil;										// Path utils object.
	OSStatus						err = noErr;
	
	if( outRef )
	{
		// Make utils...
				
		pathUtils = [ [ cbPathUtils alloc ] init ];
		
		defaultFileManager = [ NSFileManager defaultManager ];
			
		// Convert creator passed in to a string...
																	
		err = CreatorToString( creator, &inputCreatorString );
																	
		if( pathUtils && defaultFileManager && inputCreatorString && !err )
		{
			// Get vol info for boot vol. In FSGetVolumeInfo, index 1 is always the boot volume.
			
			err = FSGetVolumeInfo(	kFSInvalidVolumeRefNum,									// For indexed iterations.
									(ItemCount)1,											// Vol vIndex.
									&tempActualVolumeRefNumRefNum,							// Found vol ref num if any.
									kFSVolInfoGettableInfo,									// Which info do we want for this vol?
									&tempVolInfo,											// Returned info on success.
									&tempVolNameUniStr255,									// Return name on success.
									&tempVolRootDirectoryRef );								// A ref to this vol's root directory. We use this later as the base of the search.
			if( !err )
			{
				// Get path to this volume...
				
				volNameString = [ NSMutableString stringWithCapacity:0 ];
				if( volNameString )
				{
					// Append "/Volumes/"...

					[ volNameString appendString:[ pathUtils getVolumesDirStaticName:YES:YES ] ];
					
					// Append name of boot vol...
					
					tempString = [ NSString stringWithCharacters:(const unichar*)tempVolNameUniStr255.unicode length:tempVolNameUniStr255.length ];
					if( tempString )
					{
						[ volNameString appendString:tempString ];
						
						[ volNameString appendString:kSlashStringKey ];
					
						// Make dir volumeEnumerator for entire volume...

						volumeEnumerator = [ defaultFileManager enumeratorAtPath:volNameString ];
						if( volumeEnumerator )
						{
							// Get next item...
							
							while( ( enumeratedItem = [ volumeEnumerator nextObject ] ) )
							{
								// If we got one...
								
								if( enumeratedItem )
								{
									//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
									// Skip monster system dirs like "Developer", "Library", "Network", "System", "bin", "usr", and "var" etc., or it will
									// take forever. Invisible dirs like "Network", "bin", etc. are always in English so it's safe to hard-code them here.
									//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
									
									// Skip:
									
									if( ![ enumeratedItem isEqualToString: kDeveloperDirStringName ] &&
										![ enumeratedItem isEqualToString: [ pathUtils getLibraryDirStaticName:NO ] ] &&
										![ enumeratedItem isEqualToString: [ pathUtils getNetworkDirStaticName:NO ] ] &&
										![ enumeratedItem isEqualToString: [ pathUtils getSystemDirStaticName:NO:NO ] ] &&
										![ enumeratedItem isEqualToString: [ pathUtils getVolumesDirStaticName:NO:NO ] ] &&
										![ enumeratedItem isEqualToString: kXcode2_5_DirStringName ] &&
										![ enumeratedItem isEqualToString: kbinDirStringName ] &&
										![ enumeratedItem isEqualToString: kusrDirStringName ] &&
										![ enumeratedItem isEqualToString: kvarDirStringName ] )
									{
										//////////////////////////////////////////////////////////////////////////////////////////////
										// Now see if this item ends in ".app". If it does, see if its creator matches Secuity Shield.
										// If not, just skip it because recursively scanning apps' packages can take forever,
										// especially for Apple's iApps and other large apps. Keep in mind that a Cocoa-based
										// iteration of a large volume from the root can be expensive.
										//////////////////////////////////////////////////////////////////////////////////////////////
										
										enumeratedItemPathExtension = [ enumeratedItem pathExtension ];
										if( enumeratedItemPathExtension ) 
										{ 
											// If the path extension is ".app"...
											
											if( [ enumeratedItemPathExtension isEqualToString:kAppBundleExtension ] )
											{
												//////////////////////////////////////////////////////////////////////////////////////////////
												// Skip known giant iApps or it will take forever. Luckily the iApps names' are all
												// in English regardless of the current language selected so we can hard-code them here. :-)
												//////////////////////////////////////////////////////////////////////////////////////////////
												
												tempString = [ enumeratedItem lastPathComponent ];
												if( tempString )
												{
													if( ![ tempString isEqualToString: kApplicationStubStringName ] &&
														![ tempString isEqualToString: kAutomatorStringName ] &&
														![ tempString isEqualToString: kDashboardStringName ] &&
														![ tempString isEqualToString: kFCEStringName ] &&
														![ tempString isEqualToString: kFCPStringName ] &&
														![ tempString isEqualToString: kFrontRowStringName ] &&
														![ tempString isEqualToString: kGarageBandStringName ] &&
														![ tempString isEqualToString: kiCalStringName ] &&
														![ tempString isEqualToString: kiChatStringName ] &&
														![ tempString isEqualToString: kiDVDStringName ] &&
														![ tempString isEqualToString: kiMovieStringName ] &&
														![ tempString isEqualToString: kiPhotoStringName ] &&
														![ tempString isEqualToString: kiSyncStringName ] &&
														![ tempString isEqualToString: kiTunesStringName ] &&
														![ tempString isEqualToString: kiWebStringName ] &&
														![ tempString isEqualToString: kKeynoteStringName ] &&
														![ tempString isEqualToString: kLiveTypeStringName ] &&
														![ tempString isEqualToString: kNumbersStringName ] &&
														![ tempString isEqualToString: kPagesStringName ] &&
														![ tempString isEqualToString: kPhotoBoothStringName ] &&
														![ tempString isEqualToString: kSafariStringName ] &&
														![ tempString isEqualToString: kSpacesStringName ] &&
														![ tempString isEqualToString: kTimeMachineStringName ] )
													{
														// Append relative bundle path to volume path...
													
														itemFullPathString = nil;
														
														itemFullPathString = [ NSMutableString stringWithCapacity:0 ];
														
														[ itemFullPathString appendString:volNameString ];
															
														[ itemFullPathString appendString:enumeratedItem ];
							
														// Get bundle for this item...
														
														enemueratedItemBundle = [ NSBundle bundleWithPath:itemFullPathString ];
														if( enemueratedItemBundle )
														{
															// Get attributes dictionary & see if the creator matches Security Shield app...
													
															enumeratedItemDictionary = [ enemueratedItemBundle infoDictionary ];
															if( enumeratedItemDictionary )
															{
																// Get creator string for this item from dictionary...
																
																bundleCreatorString = [ enumeratedItemDictionary objectForKey:(NSString*)kCFBundleSignatureCFStringKey ];
																if( [ bundleCreatorString isEqualToString:inputCreatorString ] )
																{
																	bundlePathString = [ enemueratedItemBundle bundlePath ];
																	if( bundlePathString )
																	{
																		// Make bundle URL from item's fullpath...
																		
																		bundleURL = [ NSURL fileURLWithPath:bundlePathString ];
																		if( bundleURL )
																		{
																			// Allocate output bundle from found bundle...
																		
																			*outBundle = (NSBundle*)CFBundleCreate( kCFAllocatorDefault, (CFURLRef)bundleURL );
																			
																			// Get output FSRef for this bundle also...
																		
																			converted = CFURLGetFSRef( (CFURLRef)bundleURL, outRef );
																			if( !converted )
																			{
																				err = fnfErr;
																			}
																		}
																	}
																	
																	///////////////////////////////////////////////////
																	// Bust out of the loop because we've found SS...
																	///////////////////////////////////////////////////
																	
																	break;
																}
																else
																{
																	// Don't iterate into non-Security Shield .app dirs or it will take forever...
															
																	[ volumeEnumerator skipDescendents ];
																}
															}
														}
													}
													else
													{
														// Don't iterate into iApp bundles or it will take forever...
												
														[ volumeEnumerator skipDescendents ];
													}
												}
											}
										}
									}
									else
									{
										// Don't iterate into large/unlikely/system dirs or it will take forever...
												
										[ volumeEnumerator skipDescendents ];
									}
								}
							}
						}
					}
				}
			}
			
			// Clean up...
			
			[ pathUtils release ];
			
			pathUtils = nil;
			
			[ inputCreatorString release ];
																			
			inputCreatorString = nil;
		}
	}
	
	return err;
}

#pragma mark -------------------------------------
#pragma mark cbUtilsMac Object - Error Utils
#pragma mark -------------------------------------
							
//////////////////////////////////////////////////////////////
// Log the contents of an entire NSError to the console.
//////////////////////////////////////////////////////////////

- (void)logNSError:(NSError*)error
{
	int						code = 0;
	NSNumber				*codeNumber = nil;
	NSString				*codeNumberString = nil;
	
	NSString				*domain = nil;
	
	NSDictionary			*errorDictionary = nil;
	
	NSString				*errLocalizedDescriptionString = nil;
	NSArray					*errLocalizedRecoveryOptionsArray = nil;
	NSString				*errLocalizedRecoverySuggestion = nil;
	NSString				*errLocalizedFailureReason = nil;
	
	if( error )
	{
		NSLog( @"" );
		NSLog( @"********************************************************" );
		NSLog( @"cbUtilsMac *** logNSError Error logging started ***" );
		NSLog( @"********************************************************" );
		
		// Get the code, domain, and userInfo dictionary for the error...
		
		code = [ error code ];
			
		domain = [ error domain ];
		
		errorDictionary = [ error userInfo ];
		
		// Also get the localized error strings themselves...
		
		errLocalizedDescriptionString = [ error localizedDescription ];
		
		errLocalizedRecoveryOptionsArray = [ error localizedRecoveryOptions ];
		
		errLocalizedRecoverySuggestion = [ error localizedRecoverySuggestion ];
		
		errLocalizedFailureReason = [ error localizedFailureReason ];
		
		// Now log everything to console...
		
		// Code
		
		codeNumber = [ NSNumber numberWithInt:code ];
		if( codeNumber )
		{
			codeNumberString = [ codeNumber stringValue ];
			if( codeNumberString )
			{
				NSLog( @"logNSError - The error code was:" );
				
				NSLog( codeNumberString );
			}
		}
		
		// Domain
		
		if( domain )
		{
			NSLog( @"logNSError - The error domain was:" );
			
			NSLog( domain );
		}
		
		// userInfo dictionary...
		
		if( errorDictionary )
		{
			NSLog( @"logNSError - The userInfo dictionary was:" );
			
			CFShow( errorDictionary );
		}
		
		// Direct strings...
		
		if( errLocalizedDescriptionString )
		{
			NSLog( @"logNSError - The errLocalizedDescriptionString was:" );
			
			NSLog( errLocalizedDescriptionString );
		}
		
		if( errLocalizedRecoveryOptionsArray )
		{
			NSLog( @"logNSError - The errLocalizedRecoveryOptionsArray was:" );
			
			CFShow( errLocalizedRecoveryOptionsArray );
		}
		
		if( errLocalizedRecoverySuggestion )
		{
			NSLog( @"logNSError - The errLocalizedRecoverySuggestion was:" );
			
			NSLog( errLocalizedRecoverySuggestion );
		}
		
		if( errLocalizedFailureReason )
		{
			NSLog( @"logNSError - The errLocalizedFailureReason was:" );
			
			NSLog( errLocalizedFailureReason );
		}
		
		NSLog( @"" );
		NSLog( @"******************************************************" );
		NSLog( @"cbUtilsMac *** logNSError Error logging ended ***" );
		NSLog( @"******************************************************" );
	}
}

#pragma mark -------------------------------------
#pragma mark Hardware utils
#pragma mark -------------------------------------

//////////////////////////////////////////
// Return CPU type as a string.
// Caller must release.
//////////////////////////////////////////

NSString* GetCPUType( void )
{
	mach_port_t					port;
	host_basic_info_data_t		hostInfo;
    mach_msg_type_number_t		infoCount = HOST_BASIC_INFO_COUNT;
    kern_return_t				ret = 0;
	NSString					*cpuString = nil;
	
	memset( &port, 0, sizeof( port ) );
	
	memset( &hostInfo, 0, sizeof( hostInfo ) );
	
	// Get host basic info...
	
	port = mach_host_self();
	
	ret = host_info( port, HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount );
    if( ret == KERN_SUCCESS )
    {
        // Allocate and init CPU type string...
		
		if( hostInfo.cpu_type == CPU_TYPE_POWERPC )
        {
			// PowerPC
			
			cpuString = [ [ NSString alloc ] initWithString:MY_CPU_TYPE_PPC ];
		}
        else if ( hostInfo.cpu_type == CPU_TYPE_I386 )
        {
           // Intel x86
		   
			cpuString = [ [ NSString alloc ] initWithString:MY_CPU_TYPE_I386 ];
		 }
        else
        {
             // Unknown
			 
			 cpuString = [ [ NSString alloc ] initWithString:MY_CPU_TYPE_DEFAULT ];
		}
    }
    else
    {
		 // Unknown
		 
		 cpuString = [ [ NSString alloc ] initWithString:MY_CPU_TYPE_DEFAULT ];
	}
	
	return cpuString;
}

#pragma mark -------------------------------------
#pragma mark String utils
#pragma mark -------------------------------------

////////////////////////////////////////////////////////////////////////
// Strip any # of characters from the end of an NSMutableString.
// If the number of chars to be stripped from the end of the string
// is < the string length, remove the characters, otherwise return NO.
// If the string passed in is not a NSMutableString, return an NO.
// If everything succeeds, return YES.
////////////////////////////////////////////////////////////////////////

- (BOOL)stripTrailingChars:(NSMutableString**)string numCharsToRemove:(unsigned)numChars
{
	BOOL		test = NO;
	BOOL		result = NO;
	unsigned	length = 0;
	NSRange		range = { 0, 0 };
	
	if( string )
	{
		if( *string )
		{
			// Check type...
		
			test = [ *string isKindOfClass:[ NSMutableString class ] ];
			if( test == YES )
			{
				// Get length...

				length = [ *string length ];
				if( length > 0 )
				{
					// Remove...
				
					range = NSMakeRange( ( length - numChars ), numChars );
			
					[ *string deleteCharactersInRange:range ];
				}
			}
		}
	}
	
	return result;
}

@end

///////////////////////////////////////////////////////////
// Some free-floating Obj-C routines with plain C wrappers
///////////////////////////////////////////////////////////

#pragma mark
#pragma mark cbUtilsMac Object - C Wrappers
#pragma mark

#pragma mark -------------------------------------
#pragma mark Bundle utils
#pragma mark -------------------------------------

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// C wrapper for locateBundleOnDisk:(NSBundle**)outBundle forCreator:(OSType)creator withRef:(FSRef*)outRef
// Caller must release outBundle.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

OSStatus LocateBundleOnDiskForCreatorWithRef( CFBundleRef *outBundle, OSType creator, FSRef *outRef )
{
	cbUtilsMac		*utils = nil;
	OSStatus		err = noErr;
	
	// Make cbUtilsMac object...
	
	utils = [ [ cbUtilsMac alloc ] init ];
	if( utils && outBundle && outRef )
	{
		// Send -locateBundleOnDisk message to object...
		
		err = [ utils locateBundleOnDisk:(NSBundle**)outBundle forCreator:creator withRef:outRef ];
		
		// Clean up...
		
		[ utils release ];
		
		utils = nil;
	}
	
	return err;
}

#pragma mark -------------------------------------
#pragma mark String utils
#pragma mark -------------------------------------

/////////////////////////////////////////////////////////////////////
// Given a creator code, render it as an NSString.
// On input, **outString must not be NULL, but must be
// unallocated. Caller must dispose outString.
//
// NOTE: Due to historical reasons, creators are always stored
// in Big Endian format, so on Intel machines we need to reverse
// the order. On PPC machines we don't need to do anything.
// Also note that the XCode 2.5 debugger will lie on Intel machines
// and display an OSType's value as if it were already reversed
// when in fact it isn't. View an OSType's value in memory on
// Intel Macs to see the actual byte order.
/////////////////////////////////////////////////////////////////////

OSStatus CreatorToString( OSType creator, NSString **outString )
{
	char		creatS[ 5 ];
	char		tempCreatS[ 5 ];
	NSString	*cpuString = nil;
	OSStatus	err = noErr;
	
	memset( creatS, 0, sizeof( creatS ) );
	
	memset( tempCreatS, 0, sizeof( tempCreatS ) );
	
	// Copy creator to temp C string...
	
	memcpy( tempCreatS, &creator, sizeof( tempCreatS ) );
		
	// Check CPU type to see if we need to reverse the string (on Intel Macs only)...
	
	cpuString = GetCPUType();
	if( cpuString )
	{
		if( [ cpuString isEqualToString:MY_CPU_TYPE_I386 ] )
		{
			// We need to reverse the string because the creator is always stored in Big Endian format regardless of architecture...
			
			creatS[ 0 ] = tempCreatS[ 3 ];
			
			creatS[ 1 ] = tempCreatS[ 2 ];
			
			creatS[ 2 ] = tempCreatS[ 1 ];
			
			creatS[ 3 ] = tempCreatS[ 0 ];
		}
		else
		{
			// Just copy to creatS...
			
			memcpy( creatS, &creator, sizeof( creatS ) );
		}
		
		//////////////////////
		// Copy to output...
		//////////////////////
		
		if( outString )
		{
			// Allocate new NSString into output...
			
			*outString = [ [ NSString alloc ] initWithCString:(const char*)creatS encoding:NSASCIIStringEncoding ];
		}
		else
		{
			// Bad outString ptr...
			
			err = paramErr;
		}

		// Clean up...
		
		[ cpuString release ];
		
		cpuString = nil;
	}
	
	return err;
}

#pragma mark -------------------------------------
#pragma mark URL utils
#pragma mark -------------------------------------

///////////////////////////////////////////////////////////////
// Open the URL passed in as a string in the default browser.
///////////////////////////////////////////////////////////////

void OpenNSStringURLInDefaultBrowser( CFStringRef url )
{
	NSURL *newURL = nil;
	
	if( url )
	{
		// Convert string to NSURL...
		
		newURL = [ NSURL URLWithString:(NSString*)url ];
		if( newURL )
		{
			OpenNSURLInDefaultBrowser( (CFURLRef)newURL );
		}
	}
}

/////////////////////////////////////////////////
// Open the URL passed in in the default browser.
/////////////////////////////////////////////////

void OpenNSURLInDefaultBrowser( CFURLRef url )
{
	OSStatus	err = noErr;
	
	if( url )
	{
		err = LSOpenCFURLRef( (CFURLRef)url, NULL );
	}
}

#pragma mark -------------------------------------
#pragma mark Logging utils
#pragma mark -------------------------------------

/////////////////////////////////////
// Log an OSStatus using NSLog...
/////////////////////////////////////

void NSLogOSStatus( OSStatus err )
{
	NSNumber	*n = nil;
	NSString	*s = nil;
	
	// Convert to NSNumber...
	
	n = [ NSNumber numberWithLong:err ];
	if( n )
	{
		// Convert to NSString...
		
		s = [ n stringValue ];
		if( s )
		{
			NSLog( s );
		}
	}
}

/////////////////////////////////////
// Log a C string using NSLog...
/////////////////////////////////////

void NSLogCString( char *string )
{
	NSString	*s = nil;
	
	if( string )
	{
		// Convert to NSString...
	
		s = [ NSString stringWithCString:string encoding:NSASCIIStringEncoding ];
		if( s )
		{
			NSLog( s );
		}
	}
}

#pragma mark -------------------------------------
#pragma mark Version utils
#pragma mark -------------------------------------

//////////////////////////////////////////////////////////////////////////////////////////
// Get 2 or 3 Apple-style version components from any given version string. Apple
// version strings always follow the format major.minor.bugfix. If bugfix is zero,
// it is normally simply omitted. Hence the version string for example should follow
// the form 8.2 or 8.1.1. Build numbers are ignored. The version # must be the first
// part of th string in all cases. The string can have other text or numbers after the
// version number but the version # must always come first in the string. If the version
// is a development or beta build any "d" or "b" and any dev or beta number is ignored.
// For example, "8.1.1d1" would return 8, 1, 1 in the returned version numbers,
// respectively and the "d1" would be ignored. If the passed in version string does not
// match the expected format, all bets are off.
//
// On input, major, minor, and bugfix must all be valid pointers to empty, unallocted
// NSStrings.
//////////////////////////////////////////////////////////////////////////////////////////

void GetVersionComponentsFromVersionString( CFStringRef versionString, unsigned *major, unsigned *minor, unsigned *bugfix )
{
	unsigned	i = 0;
	NSString	*s = nil;
	NSArray		*versionNumStringsArray = nil;
	
	if( versionString )
	{
		// Parse the string, and strip out the 3 version numbers as strings...
	
		versionNumStringsArray = [ (NSString*)versionString componentsSeparatedByString:kDotStringKey ];
		if( versionNumStringsArray )
		{
			// Now convert each component version string to a number for output...
			
			for( i = 0; i < 3; i++ )
			{
				s = [ versionNumStringsArray objectAtIndex:i ];
				if( s )
				{
					// Allocate new output string and copy component string to it...
					
					switch( i )
					{
						case 0:
						
							// Major - can never have other text after it so just convert direct to #...
								
							*major = [ s intValue ];
								
							break;
							
						case 1:
						
							// Minor - Get # up to first text char, if any, then convert to #...
							
							*minor = [ s intValue ];
								
							break;
							
						case 2:
						
							// Bugfix - Get # up to first text char, if any, then convert to #...
							
							*bugfix = [ s intValue ];
							
							break;
							
						default:
						
							break;
					}
				}
			}
		}
	}
}														
														