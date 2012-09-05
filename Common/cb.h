/*****************************************************************************

File:			cb.h

Date:			5/7/09

Version:		2.2

Authors:		soundcore
				All rights reserved worldwide.

Notes:			Remember to keep it fun.

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

Dependencies:	XCode 2.5
				Cocoa
				Carbon
				Foundation
Changes:		

5/7/09			MCA Initial version.

*****************************************************************************/

#pragma once

// General

#define	kTempCStringBufferLength1									4096
#define	kTempCStringBufferLength									2048
#define	kTempCStringBufferLength2									1024
#define	kTempCStringBufferLength3									512
#define	kTempCStringBufferLength4									256
#define	kTempCStringBufferLength5									128
#define	kTempCStringBufferLength6									64
#define	kTempCStringBufferLength7									32

#define kMemsetBufferFillValue										0

#define kFloatZero													(CGFloat)0.0
#define kDoubleFloat												(CGFloat)2.0

#define kBogusNinetyNineValue										-99

#define kHardCodedMenuBarHeightHackSize								(CGFloat)22.0

#define kHardCodediPhone3xStatusBarHeightHackSize					(CGFloat)20.0
#define kHardCodediPhone4xStatusBarHeightHackSize					(CGFloat)20.0
#define kHardCodediPhone5xStatusBarHeightHackSize					(CGFloat)20.0
#define kHardCodediPhone6xStatusBarHeightHackSize					(CGFloat)20.0

// Some simple C chars

#define kEnterChar													'\x03'
#define kwChar														'w'
#define kPeriodChar													'.'
#define kReturnChar													'\r'

// Degrees, radians...

#define kDegreeToRadianPIFactor										(CGFloat)180.0

// Macros

#define degreesToRadian(x)											( (CGFloat)M_PI * (x) / kDegreeToRadianPIFactor )

// Temperateure

#define kCelsiusLabelString											@"C"
#define kFahrenheitLabelString										@"F"
#define kCelsiusToFahrenheitConversionFraction						1.8
#define kCelsiusToFahrenheitConversionAddition						32.0

// Some other various constants used all over the place

#define kSixty														60
#define	kFndrAlisID													0

// Networking
		
#define kCBNetworkReachabilityTimeoutInSeconds						10
#define kServerConnectivityTestHostnameCString						"google.com"

// NSError errors

#define kNoInternetConnectionNSErrorCode							-1009

// OS versions

#define kMacOSTenPointNine											0x00001090					// Mac OS X version 10.9	????
#define kMacOSTenPointEight											0x00001080					// Mac OS X version 10.8	Mountain Lion
#define kMacOSTenPointSeven											0x00001070					// Mac OS X version 10.7	Lion
#define kMacOSTenPointSix											0x00001060					// Mac OS X version 10.6	Snow Leopard
#define kMacOSTenPointFive											0x00001050					// Mac OS X version 10.5	Leopard
#define kMacOSTenPointFour											0x00001040					// Mac OS X version 10.4	Tiger
#define kMacOSTenPointThree											0x00001030					// Mac OS X version 10.3	Panther
#define kMacOSTenPointTwo											0x00001020					// Mac OS X version 10.2	Who cares...
#define kMacOSTenPointOne											0x00001010					// Mac OS X version 10.1
#define kMacOSXTenPointZero											0x00001000					// Mac OS X version 10.0

#ifdef __OBJC__

////////////////////////////////
// Begin Objective-C Constants
////////////////////////////////

#define kSixtyNSString												@"60"
#define kUnknownNSString											@"Unknown"

// Various handy strings...

#define kAmpersandStringKey											@"&"
#define kAsteriskStringKey											@"*"
#define kAtStringKey												@"@"
#define kCaratStringKey												@"^"
#define kCloseBraceStringKey										@"}"
#define kCloseParensStringKey										@")"
#define kColonStringKey												@":"
#define kCommaStringKey												@","
#define kDashStringKey												@"-"
#define kDashTripleStringKey										@"---"
#define kDegreeStringKey											@"º"
#define kDollarSignStringKey										@"$"
#define kDotStringKey												@"."
#define kElipsisStringKey											@"..."
#define kEmptyStringKey												@""
#define kEqualsStringKey											@"="
#define kEscapedQuoteStringKey										@"\""
#define kExclaimationStringKey										@"!"
#define kGreaterThanStringKey										@">"
#define kHexNumberPrefixString										@"0x"
#define kLessThanStringKey											@"<"
#define kNewlineStringKey											@"\n"
#define kNULLTerminationStringKey									@"\0"
#define kOpenBraceStringKey											@"{"
#define kOpenParensStringKey										@"("
#define kPaddedOpenParensString										@" ("
#define kPeriodString												@"."
#define kPlusStringKey												@"+"
#define kPlusMinusStringKey											@"±"
#define kPoundStringKey												@"#"
#define kQuestionMarkStringKey										@"?"
#define kReturnStringKey											@"\r"
#define kSchemeSeparatorStringKey									@"://"
#define kSemicolonStringKey											@";"
#define kSingleQuoteStringKey										@"\'"
#define kSlashStringKey												@"/"
#define kSpaceStringKey												@" "
#define kSpaceDoubleStringKey										@"  "
#define kSpaceTripleStringKey										@"   "
#define kTabStringKey												@"\t"
#define kZeroStringKey												@"0"
#define kOneStringKey												@"1"

// Special strings for some server comm...

#define kLessThanGreaterThanEqualSpaceStringKey						@"< >"

// Currency symbol strings...

#define kLabelCurrencyDollarString									@"$"
#define kLabelCurrencyEuroString									@"€"
#define kLabelCurrencyPoundString									@"£"
#define kLabelCurrencyYenString										@"¥"
#define kLabelCurrencyBrazilRealString								@"R$"
#define kLabelCurrencyChinaYuanString								@"元"
#define kLabelCurrencyIndonesianRupiahString						@"Rp"
#define kLabelCurrencyIndianRupeeString								@"रू"
#define kLabelCurrencyKuwaitiDinarString							@"دينار"
#define kLabelCurrencyPeruvianNuevoSolString						@"S/"
#define kLabelCurrencyPhillipinePesoString							@"₱"
#define kLabelCurrencySwedishKronaString							@"kr"
#define kLabelCurrencyTurkishLiraString								@"TL"
#define kLabelCurrencySouthAfricanRandString						@"R"

#define kPercentAtString											@"%@"

// true/false as strings

#define kTrueString													@"true"
#define kFalseString												@"false"

#define kNo															@"NO"
#define kYes														@"YES"

// Hard-coded button names (use localized strings instead)

#define kOKBUttonNameNSString										@"OK"
#define kCancelBUttonNameNSString									@"Cancel"
#define kClearBUttonNameNSString									@"Clear"
	
// Info.plist & InfoPlist.strings common file & key names

#define kInfoPlistTableNameString									@"InfoPlist"
#define kCFBundleInfoPlistFileNameAndExtensionNSString				@"Info.plist"
#define kCFBundleInfoPlistStringsFileNameNSString					@"InfoPlist"
#define kCFAppleHelpAnchorNameNSString								@"CFAppleHelpAnchor"
#define kCFBundleShortVersionString									@"CFBundleShortVersionString"
#define kCFBundleExecutableKeyNSString								@"CFBundleExecutable"
#define kCFBundleIconFileKeyNSString								@"CFBundleIconFile"
#define kNSHumanReadableCopyrightNameString							@"NSHumanReadableCopyright"

// Common OS X bundled subdir names

#define kMacAppBundleContentsSubDirNameNSString						@"Contents"
#define kMacAppBundleMacOSSubDirNSString							@"MacOS"
#define kMacAppBundleResourcesSubDirNSString						@"Resources"

#define kCFBundleGetInfoCFStringKey									@"CFBundleGetInfoString"
#define kCFBundleShortVersionCFStringKey							@"CFBundleShortVersionString"

// Common filename extensions

#define kAppBundleExtension											@"app"
#define kStaticDictFilenameExtension								@"dict"
#define kFileSystemBundleExtension									@"fs"
#define kKEXTExtension												@"kext"
#define kLockfileFilenameExtension									@"lockfile"
#define kLanguageFolderExtension									@"lproj"
#define kInstallerMetapackageBundleExtension						@"mpkg"
#define kInstallerPackageBundleExtension							@"pkg"
#define kStaticPlistFilenameExtension								@"plist"
#define kStaticShellScriptExtension									@"sh"
#define kStaticStringsFilenameExtension								@"strings"
#define kStaticZipFilenameExtension									@"zip"

#define kStaticHTMLFIleExtension									@"html"
#define kStaticXMLFIleExtension										@"xml"

#define kRTFFilenameExtension										@"rtf"
#define kRTFDFilenameExtension										@"rtfd"
#define kRFTDFilenameExtension										@"rftd"
#define kTextFilenameExtension										@"txt"

#define kIconsFileExtension											@"icns"
#define kIconsCapsFileExtension										@"ICNS"
#define kJPEGFileExtension											@"jpg"
#define kPNGFilenameExtension										@"png"
#define kPNGCapsFilenameExtension									@"PNG"
#define kTIFFFilenameExtension										@"tiff"
#define kTIFF2FilenameExtension										@"tif"

#define kAIFFSoundFileExtension										@"aif"
#define kSoundFileAUFileExtension									@"au"
#define kCAFSoundFileExtension										@"caf"
#define kSoundFileMIDFileExtension									@"mid"
#define kSoundFileMP3FileExtension									@"mp3"
#define kSoundFileWAVFileExtension									@"wav"

// MIME type constants

#define kMIMEImagePNGType											@"image/png"

// Carbon creator codes

#define kCarbonFinderCreatorNSString								@"MACS"

// Font names

#define kCourierFontName											@"Courier"
#define kHelveticaFontName											@"Helvetica"

// A few hard-coded Apple dir names that never localize:

#define kRootDirNameString											@"/"
#define	kbinDirStringName											@"bin"
#define	kvarDirStringName											@"var"
#define	kusrDirStringName											@"usr"
#define kCommandsDirNameString										@"Commands"
#define kDeveloperDirStringName										@"Developer"
#define kFrameworksDirNameString									@"Frameworks"
#define kGraphicsDirNameString										@"Graphics"
#define kPreferencesDirNameString									@"Preferences"
#define kReceiptsDirNameString										@"Receipts"
#define kScriptsDirNameString										@"Scripts"
#define	kXcode2_5_DirStringName										@"Xcode2.5"

// Hard-coded Apple iApp names which are all in English regardless of current language used...

#define kApplicationStubStringName									@"Application Stub.app"
#define kAutomatorStringName										@"Automator.app"
#define kDashboardStringName										@"Dashboard.app"
#define kFCEStringName												@"Final Cut Express.app"
#define kFCPStringName												@"Final Cut Pro.app"
#define kFrontRowStringName											@"Front Row.app"
#define kGarageBandStringName										@"GarageBand.app"
#define kiCalStringName												@"iCal.app"
#define kiChatStringName											@"iChat.app"
#define kiDVDStringName												@"iDVD.app"
#define kiMovieStringName											@"iMovie.app"
#define kiPhotoStringName											@"iPhoto.app"
#define kiSyncStringName											@"iSync.app"
#define kiTunesStringName											@"iTunes.app"
#define kiWebStringName												@"iWeb.app"
#define kKeynoteStringName											@"Keynote.app"
#define kLiveTypeStringName											@"LiveType.app"
#define kNumbersStringName											@"Numbers.app"
#define kPagesStringName											@"Pages.app"
#define kPhotoBoothStringName										@"Photo Booth.app"
#define kSafariStringName											@"Safari.app"
#define kSpacesStringName											@"Spaces.app"
#define kTimeMachineStringName										@"Time Machine.app"

// Apple app names & bundle IDs

#define kAppleDUBundleIDString										@"com.apple.DiskUtility"
#define kAppleFinderBundleIDString									@"com.apple.finder"
#define kAppleInstallerBundleIDString								@"com.apple.installer"
#define kAppleSafariBundleIDString									@"com.apple.safari"
#define kAppleXcodeBundleIDString									@"com.apple.Xcode"

#define	kTmpDirPathNSString											@"/tmp"												// Only use this to resolve the symlink to the real /tmp!
#define	kPrivateTmpDirPathNSString									@"/private/tmp"										// Only use this to resolve the symlink to the real /private/tmp!
#define	kPrivateTmpDirPathWithTrailingSlashNSString					@"/private/tmp/"									// Only use this to resolve the symlink to the real /private/tmp/!
#define kSystemVolumesPathPrefixWithSlash							@"/Volumes/"

// System dirs (TODO: these should be replaced with routines from the path utils)

#define kUsersDirPathComponentNSString								@"/Users/"
#define kDesktopDirPathComponentNSString							@"/Desktop/"

// Apple Installer files, keys, & paths...

#define kAppleInstallerPluginTitleKeyKey							@"Title"

#define kAppleInstallerDescriptionPlistFilenameKey					@"Description"
#define kAppleInstallerDescriptionTitleKey							@"IFPkgDescriptionTitle"

// Sort descriptor keys for NSSortDescriptor

#define kSortDescriptorKeyIntValueString							@"intValue"

// Sound file names

#define kInfoInFileName												@"info_in"
#define kInfoOutFileName											@"info_out"
#define knextFileName												@"next"
#define kpingFileName												@"ping"
#define ktapFileName												@"tap"
#define kWhooshFileName												@"whoosh"
#define kWhoosh2FileName											@"whoosh2"

// Other weird crap

#define kCapitalXString												@"X"
#define kAtTwoXString												@"@2X"

// KB/MB/GB/TB/PT labels

#define kKBLabelNSString											@"KB"
#define kMBLabelNSString											@"MB"
#define kGBLabelNSString											@"GB"
#define kTBLabelNSString											@"TB"
#define kTiBLabelNSString											@"TiB"
#define kPBLabelNSString											@"PB"

// MHz/GHz labels

#define kMHzLabelNSString											@"MHz"
#define kGHzLabelNSString											@"GHz"

// Drive interface speed labels

#define kGbSLabelNSString											@"Gb/s"

// A few error strings that should have constants in Cocoa headers, but don't:

#define kGenericErrorKeyString										@"Error"
#define kGenericErrorPathKeyString									@"Path"
#define kRemoveFailedErrorString									@"Remove failed"

#define kNSURLErrorDomainString										@"NSURLErrorDomain"
#define kNSErrorFailingURLKey										@"NSErrorFailingURLKey"
#define kNSErrorFailingURLStringKey									@"NSErrorFailingURLStringKey"
#define kNSLocalizedDescriptionStringKey							@"NSLocalizedDescription"
#define kNSUnderlyingErrorStringKey									@"NSUnderlyingError"

// Items that should be in NSBundle.h but aren't

#define kNSBundleInitialPathInfoDictKey								@"NSBundleInitialPath"

// Items that should be in NSFileManager.h but aren't

#define kNSFileTypeDirectoryKey										@"NSFileTypeDirectory"

// Items that should be in NSWorkspace.h but aren't

#define kNSApplicationProcessSerialNumberHighKey					@"NSApplicationProcessSerialNumberHigh"
#define NSApplicationProcessSerialNumberLowKey						@"NSApplicationProcessSerialNumberLow"

// Items from NSPasteboard.h that are defined in 10.6+ but back-defined here for backward compatibility on pre-10.6 systems.

#if !defined MAC_OS_X_VERSION_10_6 && ( MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_6 )
#define NSPasteboardTypePNG											@"PNG"
#endif

// Items that should be in I/O Kit but aren't in some versions of the SDK.

#define kDADiskDescriptionDeviceAppearanceTimeKey					CFSTR( "DAAppearanceTime"  )		// Should be in Disk Arb but is in DAInternal.c from Darwin instead.
#define kIOPMBatteryPowerKey										"Battery Power"

// Items that should be in USBSpec.h but aren't

#define kUSBAddress													"USB Address"
#define kIOKitUSBBusPowerAvailable									"Bus Power Available"
#define kIOKitUSBDeviceSpeed										"Device Speed"
#define kIOKitUSBLowPowerDisplayed									"Low Power Displayed"
#define kIOKitUSBRequestedPower										"Requested Power"
#define kIOKitUSBWakePowerAllocated									"PortUsingExtraPowerForWake"
// URL schemes

#define kHTTP_URL_Scheme											@"http"
#define kHTTPS_URL_Scheme											@"https"

// Keys in WebKit's _arguments dictionary passed to WebKit plugins

#define kWebPlugInAttributeSrcKey									@"src"

// Keys in Carbon Process Manager ProcessInformationCopyDictionary dict

#define kPSNNameKey													@"PSN"
#define kFlavorNameKey												@"Flavor"
#define kAttributesNameKey											@"Attributes"
#define kParentPSNNameKey											@"ParentPSN"
#define kFileTypeNameKey											@"FileType"
#define kFileCreatorNameKey											@"FileCreator"
#define kpidNameKey													@"pid"
#define kLSBackgroundOnlyNameKey									@"LSBackgroundOnly"
#define kLSUIElementNameKey											@"LSUIElement"
#define kIsHiddenAttrNameKey										@"IsHiddenAttr"
#define RequiresClassicNameKey										@"RequiresClassic"
#define kRequiresCarbonNameKey										@"RequiresCarbon"
#define kLSUserQuitOnlyNameKey										@"LSUserQuitOnly"
#define kBundlePathNameKey											@"BundlePath"

// NSWindow

#define kDefaultNSWindowResizeAnimationTime							0.20

// Core Animation

#define kFullScale													1.0

// Common Core Animation Names

#define kOpacityAnimationNameKey									@"opacity"
#define kAnimateFadeInOpacityNameKey								@"animateFadeInOpacity"

// HTTP Result Codes

#define kHTTP_Result_OK												@"200"
#define kHTTP_Result_NotFound										@"400"

// Formatters

#define kBytesNumberFormatString									@"###,###,###"
#define kBytesDecimalNumberFormatString								@"###,###,##0.###"
#define kBytesSubZeroDecimalNumberFormatString						@"###,###,##0.00000000001"		// See http://unicode.org/reports/tr35/tr35-10.html#Number_Format_Patterns

// Standard C string formatters

#define kHexFormatCocoaStringKey									@"0x%x"
#define kLowercaseHexFormatString									@"%x"

#endif

//////////////////////////////
// End Objective-C Constants
//////////////////////////////

// CF versions of above...

#define kQuoteStringCFKey											CFSTR( "\"" )
#define kSpaceStringKeyCF											CFSTR( " " )
#define kSlashStringKeyCF											CFSTR( "/" )
#define kDotStringKeyCF												CFSTR( "." )
#define kNewlineStringKeyCF											CFSTR( "\n" )

// Unichar/C versions of above...

#define kSlashCharA													'/'
#define kBackslashEscapedCharA										'\\'

// Special hex escape chars for POSIX paths...

#define kEscapedSpaceCharHexString									'\x20'
#define kEscapedSpaceCharHexCFString								CFSTR( "\x20" )

// Keys

#define kDeleteKey													0x08
#define kDELKey														0x7F
#define	kEnter														0x03
#define	kReturn														0x0D
#define kReturnKey													0x24
#define kCommandKey													0x37
#define kCapsLockKey												0x39
#define kControlKey													0x3B
#define kSpaceKey													0x31
#define	kEscapeKey													0x1B
#define	kPeriodKey													0x2E
#define	kTabKey														0x30
#define kLineFeed													0x0A
#define kNoKey														0x00
#define	kLeftKey													0x1C
#define	kRightKey													0x1D
#define	kUpKey														0x1E
#define kDownKey													0x1F
#define kHelpKey													0x05
#define kHomeKey													0x01
#define kEndKey														0x04
#define kOptionKey													0x3A
#define kPageUpKey													0x0B
#define kPageDownKey												0x0C
#define kShiftKey													0x38

// CFRange constants

#define kCFRangeNULL												{ 0, 0 }

// Drive letters - Kind of a hack. On OS X we assume all C:\ paths map to "\".
	
#define kCDriveLetterPrefixCString				"C:\\"
#define kCDriveLetterPrefixCStringNoSlash		"C:"
	
// Keystroke/event tap & special keys...

enum
{
	kFuncKeyData0 = 0,
	kF1 = 0x7A,
	kF2 = 0x78,
	kF3 = 0x63,
	kF4 = 0x76,
	kF5 = 0x60,
	kF6 = 0x61,
	kF7 = 0x62,
	kF8 = 0x64,
	kF9 = 0x65,
	kF10 = 0x6D,
	kF11 = 0x67,
	kF12 = 0x6F,
	kF13 = 0x69,
	kF14 = 0x6B,
	kF15 = 0x71,
	kF16 = 0x6A,
	kExpose = 0xA0,													// Undocumneted - Apple aluminum only. May be fragile.
	kDashboard = 0x82,												// Undocumneted - Apple aluminum only. May be fragile.
	kHelp = 0x72,
	kHome = 0x73,
	kPgUp = 0x74,
	kPgDn = 0x79,
	kDelete = 0x33,
	kDeletePC = 0x75,
	kEnd = 0x77,
	kUpArrow = 0x7E,
	kDownArrow = 0x7D,
	kLeftArrow = 0x7B,
	kRightArrow = 0x7C,
	kCancel = 0x1B,
};

// Percent-encoding constants as defined by RFC 1738...

#define kPercent20													"%20"
#define kPercent21													"%21"
#define kPercent2A													"%2A"
#define kPercent27													"%27"
#define kPercent28													"%28"
#define kPercent29													"%29"
#define kPercent3B													"%3B"
#define kPercent3A													"%3A"
#define kPercent40													"%40"
#define kPercent26													"%26"
#define kPercent3D													"%3D"
#define kPercent2B													"%2B"
#define kPercent24													"%24"
#define kPercent2C													"%2C"
#define kPercent2F													"%2F"
#define kPercent3F													"%3F"
#define kPercent25													"%25"
#define kPercent23													"%23"
#define kPercent5B													"%5B"
#define kPercent5D													"%5D"

// CF versions of the above

#define kCFBundleExecutableKeyCFString								CFSTR( "CFBundleExecutable" )

#define kCFBundleNameKeyCFStringKey									CFSTR( "CFBundleName" )
#define kCFBundleIdentifierKeyCFStringKey							CFSTR( "CFBundleIdentifier" )
#define kCFBundleSignatureCFStringKey								CFSTR( "CFBundleSignature" )
#define kCFBundleNSHumanReadableCopyrightgKey						CFSTR( "NSHumanReadableCopyright" )

// CF versions of above

#define kMacAppBundleContentsSubDirNameCFString						CFSTR( "Contents" )
#define kMacAppBundleMacOSSubDirCFString							CFSTR( "MacOS" )
#define kMacAppBundleResourcesSubDirCFString						CFSTR( "Resources" )

// CF versions of above

#define kAppBundleExtensionCF										CFSTR( ".app" )

// OSTypes for known Apple apps

#define	kDockCreatorString											'dock'
#define	kFinderInfoDiskUtil_4_2DiskImageFileTypeString				'dImg'
#define	kFinderInfoDiskUtil_4_2DiskImageFileExtensionString			".img"

// Older Carbon OSType/Creator values

#define kCarbonFinderCreatorOSType									'MACS'

// CF versions of above

#define kAppleSafariBundleIDCFString								CFSTR( "com.apple.safari" )

// Paths (TODO: these should be replaced with routines from the path utils)

#define kFileLocalHostPrefixPathCString								"file://localhost"
#define kFileLocalHostPrefixPathCFString							CFSTR( kFileLocalHostPrefixPathCString )

// Path conversion flags for path types
	
#define kPOSIXStringPathType										kCFURLPOSIXPathStyle								// POSIX path format (forward slash delimited)
#define kWindowsStringPathType										kCFURLWindowsPathStyle								// Windows-style delimited path
#define kWindowsAbsoluteStringPathType								( kCFURLWindowsPathStyle + 10 )						// Windows-style delimited path with drive letter (Must currently be "C:\\")
#define kHFSPathType												kCFURLHFSPathStyle									// HFS/HFS+ style path
	
// Message macros

#define kMainBundle													[ NSBundle mainBundle ]
#define kClearNSColor												[ NSColor clearColor ]
#define kClearColor													[ UIColor clearColor ]
#define UIApp														[ UIApplication sharedApplication ]					// Like the old NSApp but for iOS.
#define UIAppDelegate												[ UIApp delegate ]

// Run Loop Stuff

#define kDefaultRunLoopModeCommonModesArray							[ NSArray arrayWithObjects:NSDefaultRunLoopMode, NSRunLoopCommonModes, nil ]

// Core Graphics handy macros

#define kTotallyTransparent											(CGFloat)0.0
#define kTotallyOpaque												(CGFloat)1.0
#define kHalfView													(CGFloat)2.0
#define kJustInitCGPointWithZeros									{ 0, 0 }
#define kJustInitCGRectWithZeros									{ { 0, 0 }, { 0, 0 } }
#define kJustInitCGRectWithZerosFloat								{ { (CGFloat)0.0, (CGFloat)0.0 }, { (CGFloat)0.0, (CGFloat)0.0 } }
#define kJustInitCLLocationCoordinate2DWithZeros					{ 0, 0 }

#define kRGBAllWhiteFloat											(CGFloat)255.0
#define kZeroRect													NSMakeRect( (CGFloat)0.0, (CGFloat)0.0, (CGFloat)0.0, (CGFloat)0.0 )

// AppKit Message macros

#define kDefaultFileManager											[ NSFileManager defaultManager ]
#define kEmptyAutoReleasedMutableArray								[ NSMutableArray arrayWithCapacity:0 ]
#define kMainBundle													[ NSBundle mainBundle ]
#define kMainScreenFrame											[ NSScreen mainScreenFrame ]
#define kStandardUserDefaults										[ NSUserDefaults standardUserDefaults ]

// Custom Finder icon invisible volume icon name

#define kHiddenCutomVolumeIconFileName								@".VolumeIcon.icns"

// filesystemID for FSVolumeInfo - should be in headers, but aren't. May be fragile.

enum 
{
    kFileSysID_UFS				= 0x6375,							// 'cu' in ASCII
    kFileSysID_UDF				= 0x55DF,
    kFileSysID_AudioCD			= 0x4A48,							// 'JH' in ASCII
    kFileSysID_PhotoCD			= 0x4D4B,							// ? in ASCII
    kFileSysID_AppleShare		= 0x6173,							// 'as' in ASCII
    kFileSysID_MSDOS			= 0x4953,							// 'IS' in ASCII
	kFileSysID_NTFS				= 0x1111,							// TODO: Get real NTFS value!
    
    // For other values of filesystemID, check signature:
    
	kSigWord_MFS				= 0xD2D7,							// MFS volume signature - See /hfs/hfs_format.h for HFS/HFS+/HFSX signatures. From IM: Volume II - Data organization on volumes.
    kSigWord_ISO9660			= 0x4147,							// 'AG' in ASCII
    kSigWord_HighSierra			= 0x4242,							// 'BB' in ASCII
    kSigWord_AudioCD			= 0x4A48							// 'JH' in ASCII
};


// C string names for above filesytems

#define kUFSFSNameCString											"UFS"
#define kUDFFSNameCString											"UDF"
#define kAudioCDFSNameCString										"AudioCD"
#define kPhotoCDFSNameCString										"PhotoCD"
#define kAppleShareFSNameCString									"AppleShare"
#define kMSDOSFSNameCString											"MSDOS"
#define kMFSFSNameCString											"MFS"
#define kHFSFSNameCString											"HFS"
#define kHFSPlusFSNameCString										"HFS+"
#define kHFSXFSNameCString											"HFSX"
#define kISO9660FSNameCString										"ISO9660"
#define kHighSierraFSNameCString									"HighSierra"
#define kAudioCDFSNameCString										"AudioCD"
#define kFATFSNameCString											"FAT"
#define kNTFSFSNameCString											"NTSF"
#define kUnknownFSNameCString										"Unknown"

// Some constants we define for NSAnimations

#define kGLAnimationFrameRateAsFastAsPossible						0.0												// Use in -setFrameRate.
																			
// sysctlbyname constants

#define ksysctlbyname_hw_model_CString								"hw.model"
#define ksysctlbyname_hw_machine_CString							"hw.machine"
#define ksysctlbyname_hw_memsize_CString							"hw.memsize"
#define ksysctlbyname_hw_machine_cpu_name_CString					"machdep.cpu.brand_string"


// Our own processor types...

#define kUnknowmProcType											0
#define kPPCProcType												1
#define ki386ProcType												2

// Processor speed benchmarks

#define kOneMhz														1000000
#define kOneMhzDecimal												1000000.0
#define kOneGhz														1000000000
#define kOneGhzDecimal												1000000000.0

// RAM/Disk sizes

#define kOneKB														1024
#define kOneMB														1000000
#define kOneGB														1000000000
#define kOneTB														1000000000000									// Terabyte - SI units form
#define kOneTiB														1099511627776									// Tebibyte - IEEE/ISO (traditional interpretation).
#define kOnePB														1000000000000000

#define kOneMbit													( 125.00 * kOneKB )

// UTC/GMT/Time Zone strings

#define kGreenwichMeanTimeCFStr										CFSTR( "GMT" )
#define kGreenwichMeanTimeCStr										"GMT"
#define kGreenwichMeanTimePlusCStr									"GMT+"

#define kMillisecondsInSecond										1000
#define kMillisecondsInMinute										60000
#define kMillisecondsInHour											3600000
#define kSecondsInAYear												31536000										// Ignores leap years, so it will be off a little...

// iPhone rotation constants

#define kLandscapeRotationInDegrees									90

#define kPhoneLandscapeWidth										480
#define kPhoneLandscapeHeight										320
#define kLandscapeRectTouchOffsetFactor								-80

// Core Animation

#define kCA90DegreeRotateTransform									CGAffineTransformMakeRotation( M_PI / kDoubleFloat )

// Carbon Process Manager

#define kLowLongPSN													0x00000000FFFFFFFF
