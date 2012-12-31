/*******************************************************************************
File:			HardwareModel.h

Date:			5/2/11

Version:		1.0

Authors:		soundcore

				Copyright 2011 by soundcore
				All rights reserved worldwide.

Notes:			Header for HardwareModel.h.m

				This is a class to hold info about the machine we are running on.
				
				Note that we do not load any of our system profiler stuff
				here. That's because doing so is a VERY expensive operation
				and ideally we only want to do it once per app session or
				cache the loaded data so that it doesn't take too long to load.
				So we store that data elsewhere so we can just get the lightweight
				machine info in this model class.
				
				TODO: We need to move the "MY_CPU" strings to a strings file.
				
				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF soundcore. ANY SUCH DISTRIBUTION CARRIES SEVERE
				CRIMINAL AND CIVIL PENALTIES AND IS A VIOLATION OF
				INTERNATIONAL COPYRIGHT LAW. VIOLATORS WILL BE
				PROSECUTED TO THE FULL EXTENT OF INTERNATIONAL LAW.

Dependencies:	XCode 3.2.x as of this writing.
				Cocoa.
				SCF
				Core Graphics
				sysctl
				Macintosh.dict
				IconFamily by Troy Stephens - http://iconfamily.sourceforge.net/
				strings file
Changes:		

5/2/11			MCA Initial version.

*******************************************************************************/

#import <Cocoa/Cocoa.h>

#import <IconFamily.h>
#import <NSString+CarbonFSRefCreation.h>

////////////
// Defines
////////////

// Name of the HardwareModel.strings file as classname string

#define kHardwareModelStringsFileName					NSStringFromClass( [ self class ] )

// Hard-coded CPU type strings for sysctl

#define MY_CPU_TYPE_DEFAULT_CSTRING						"Unknown CPU Type"
#define MY_CPU_TYPE_I386_CSTRING						"Intel x86"
#define MY_CPU_TYPE_PPC_CSTRING							"Motorola PowerPC"

// Displays

#define kMaxDisplaysSupported							32																		// Max # of displays supported. Unlikely it will go beyond this.

////////////
// Classes
////////////

@interface HardwareModel : NSObject
{
	// OS
	
	SInt32												osVersion;																// Which version of OS X are we running?
																																// TODO: Need to change this to use sysctl.
	// Computer & CPU strings
	
	NSString											*appHardwareModelNameInternalString;									// Base machine hardware name - internal only.
	NSString											*computerNameString;													// Computer (host) name of this machine.
	NSString											*macModelNameString;													// Name of Mac model we are running on.
	NSString											*cpuTypeString;															// String for CPU type we are running.
	NSUInteger											numProcessors;															// Get # of procs or cores.
	NSString											*processorNameString;													// Marketing name for CPU type we are running.
	NSString											*processorSpeedString;													// CPU speed string with label.
	NSString											*physicalRAMString;														// Physical RAM & label.
	NSString											*userNameString;														// Console user name currently logged in.
	
	// Machine icon
	
	NSImage												*machineIconImage;														// Computer icon for this Mac.
	
	// Displays
	
	CGDisplayCount										displayCount;															// # of displays found.
	NSMutableArray										*displayIDsArray;														// Array of found CGDirectDisplayID's as NSNumbers.
}	

@property (nonatomic)			SInt32					osVersion;
@property (nonatomic, copy)		NSString				*appHardwareModelNameInternalString;
@property (nonatomic, copy)		NSString				*computerNameString;
@property (nonatomic, retain)	NSString				*macModelNameString;
@property (nonatomic, copy)		NSString				*cpuTypeString;
@property (nonatomic)			NSUInteger				numProcessors;
@property (nonatomic, copy)		NSString				*processorNameString;
@property (nonatomic, copy)		NSString				*processorSpeedString;
@property (nonatomic, copy)		NSString				*physicalRAMString;
@property (nonatomic, copy)		NSString				*userNameString;
@property (nonatomic, assign)	NSImage					*machineIconImage;
@property (nonatomic)			CGDisplayCount			displayCount;
@property (nonatomic, assign)	NSMutableArray			*displayIDsArray;

+ (id)init;

- (id)init;

- (void)dealloc;

// Internal - Hardware Info

- (void)loadHardwareModelName;

- (void)loadComputerName;

- (void)loadMacModelName;

- (void)loadCPUTypeString;

- (void)loadNumProcessors;

- (void)loadProcessorName;

- (void)loadProcessorSpeed;

- (void)loadPhysicalRAM;

- (void)loadUserName;

- (void)loadMachineIcon;

- (void)loadDisplays;

@end
