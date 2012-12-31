/****************************************************************************

File:			NSString+NSStringAdditions.m

Date:			12/7/09

Version:		1.0

Authors:		Michael Amorose

				Copyright 2009 Michael Amorose
				All rights reserved worldwide.

Notes:			Implementation of NSString+NSStringAdditions

				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.

WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF MICHAEL AMOROSE.

				ANY SUCH DISTRIBUTION CARRIES SEVERE CRIMINAL AND CIVIL
				PENALTIES AND IS A VIOLATION OF INTERNATIONAL
				COPYRIGHT LAW.

				VIOLATORS WILL BE PROSECUTED TO THE FULL EXTENT OF
				INTERNATIONAL LAW.

Dependencies:	XCode 3.1+

Changes:		

12/7/09		MCA Initial version.

******************************************************************************/

#import "NSString+NSStringAdditions.h"
#import <cb.h>

@implementation NSString ( NSStringAdditions )

#pragma mark-
#pragma mark Numeric Conversions
#pragma mark-

////////////////////////////////
// Format a floating point #.
////////////////////////////////

- (NSString*)prettyFloat:(CGFloat)f
{
	if( f == 0 )
	{
		return kZeroStringKey;
	}
	else if( f == 1 )
	{
		return @"1";
    }
	else
	{
        return [ NSString stringWithFormat:@"%.3f", f ];
	}
}

//////////////////////////
// Format CATransform3D.
//////////////////////////

- (NSString*)JRNSStringFromCATransform3D:(CATransform3D)transform
{
    // Format: [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
    
    return CATransform3DIsIdentity( transform )
        ? @"CATransform3DIdentity"
        : [ NSString stringWithFormat:@"[%@ %@ %@ %@; %@ %@ %@ %@; %@ %@ %@ %@; %@ %@ %@ %@]",
						[ self prettyFloat:transform.m11 ],
						[ self prettyFloat:transform.m12 ],
						[ self prettyFloat:transform.m13 ],
						[ self prettyFloat:transform.m14 ],
						[ self prettyFloat:transform.m21 ],
						[ self prettyFloat:transform.m22 ],
						[ self prettyFloat:transform.m23 ],
						[ self prettyFloat:transform.m24 ],
						[ self prettyFloat:transform.m31 ],
						[ self prettyFloat:transform.m32 ],
						[ self prettyFloat:transform.m33 ],
						[ self prettyFloat:transform.m34 ],
						[ self prettyFloat:transform.m41 ],
						[ self prettyFloat:transform.m42 ],
						[ self prettyFloat:transform.m43 ],
						[ self prettyFloat:transform.m44 ] ];
}

#pragma mark-
#pragma mark Character Processing
#pragma mark-

/////////////////////////////////////////////////////////////////////
// See if a string contains one or more leading zeros.
// Note this only works on strings that are numeric & that have more
// than 1 char. Single-char strings are ignored.
// self must not contain more than kTempCStringBufferLength1 chars.
/////////////////////////////////////////////////////////////////////

- (BOOL)containsLeadingZero
{
	char		tempBuf[ kTempCStringBufferLength1 ];		// Be sure to change below if you change the array size! We don't use sizeof here for performance.
	NSString	*s = nil;
	unichar		uc = 0;
	BOOL		hasLeadingZero = NO;
	
	memset( tempBuf, 0, kTempCStringBufferLength1 );
	
	if( ( [ self length ] > 1 ) && [ self containsOnlyNumericChars ] )
	{
		// Get C string...
	
		if( [ self getCString:tempBuf maxLength:kTempCStringBufferLength1 encoding:NSASCIIStringEncoding ] )
		{
			// Get 1st & 2nd chars...
			
			uc = [ self characterAtIndex:0 ];
			
			// Makes 2 strings - one for each char...
			
			s = [ [ NSString alloc ] initWithCharacters:&uc length:1 ];
			if( s )
			{
				if( [ s isEqualToString:kZeroStringKey ] )
				{
					hasLeadingZero = YES;
				}
			}
		}
	}
	
	return hasLeadingZero;
}

/////////////////////////////////////////////////////////////////////
// Same as containsLeadingZero but allows hex digits in the string.
/////////////////////////////////////////////////////////////////////

- (BOOL)containsLeadingZeroAllowingHexChars
{
	char		tempBuf[ kTempCStringBufferLength1 ];			// Be sure to change below if you change the array size! We don't use sizeof here for performance.
	NSString	*s = nil;
	unichar		uc = 0;
	BOOL		hasLeadingZero = NO;
	
	memset( tempBuf, 0, kTempCStringBufferLength1 );
	
	if( ( [ self length ] > 1 ) )
	{
		// Get C string...
	
		if( [ self getCString:tempBuf maxLength:kTempCStringBufferLength1 encoding:NSASCIIStringEncoding ] )
		{
			// Get 1st & 2nd chars...
			
			uc = [ self characterAtIndex:0 ];
			
			// Makes 2 strings - one for each char...
			
			s = [ [ NSString alloc ] initWithCharacters:&uc length:1 ];
			if( s )
			{
				if( [ s isEqualToString:kZeroStringKey ] )
				{
					hasLeadingZero = YES;
				}
			}
		}
	}
	
	return hasLeadingZero;
}

/////////////////////////////////////////////////////////////////////
// See if a string contains ONLY numeric characters.
// self must not contain more than kTempCStringBufferLength1 chars.
/////////////////////////////////////////////////////////////////////

- (BOOL)containsOnlyNumericChars
{
	char		tempBuf[ kTempCStringBufferLength1 ];		// Be sure to change below if you change the array size! We don't use sizeof here for performance.
	unichar		uc = 0;
	NSUInteger	i = 0;
	BOOL		isOnlyNumericChars = YES;
	
	memset( tempBuf, 0, kTempCStringBufferLength1 );
	
	// Get C string...
	
	if( [ self getCString:tempBuf maxLength:kTempCStringBufferLength1 encoding:NSASCIIStringEncoding ] )
	{
		// Loop string length, examining each char for not 0-9...
		
		for( i = 0; i < (NSUInteger)strlen( tempBuf ); i++ )
		{
			NSString *s = nil;
			
			uc = [ self characterAtIndex:i ];
			
			s = [ [ NSString alloc ] initWithCharacters:&uc length:1 ];
			if( s )
			{
				if( ![ s isEqualToString:kZeroStringKey ] &&
					![ s isEqualToString:@"1" ] &&
					![ s isEqualToString:@"2" ] &&
					![ s isEqualToString:@"3" ] &&
					![ s isEqualToString:@"4" ] &&
					![ s isEqualToString:@"5" ] &&
					![ s isEqualToString:@"6" ] &&
					![ s isEqualToString:@"7" ] &&
					![ s isEqualToString:@"8" ] &&
					![ s isEqualToString:@"9" ] )
				{
					isOnlyNumericChars = NO;
				
					break;
				}
			}
		}
	}
	else
	{
		isOnlyNumericChars = NO;
	}

	return isOnlyNumericChars;
}

/////////////////////////////////////////////////////////
// Return whether a string contains the passed in string.
//////////////////////////////////////////////////////////

- (BOOL)containsString:(NSString*)string
{
	BOOL		contains = NO;
	NSRange		containedRange = kCFRangeNULL;
	
	if( string )
	{
		containedRange = [ self rangeOfString:string
								options:NSLiteralSearch
								range:NSMakeRange( 0, [ self length ] )
								locale:nil ];
		
		if( ( containedRange.length > 0 ) )
		{
			contains = YES;
		}
	}
	
	return contains;
}

///////////////////////////////////////////////////
// Convert HTML entities in the string passed in.
///////////////////////////////////////////////////

- (NSString*)convertEntities:(NSString*)string
{
	NSString *returnStr = nil;
   
	if( string )
	{
		returnStr = [ string stringByReplacingOccurrencesOfString:@"&amp;" withString: @"&"  ];
		
		returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""  ];
		
		returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x22;" withString:@"'"  ];
		
		returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x27;" withString:@"'"  ];
		
		returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x39;" withString:@"'"  ];
		
		returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x92;" withString:@"'"  ];
		
		returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x96;" withString:@"'"  ];
		
		returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"  ];
		
		returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"  ];
		
		returnStr = [ NSString stringWithString:returnStr ];
	}
	
    return returnStr;
}

///////////////////////////////////////////////////////
// Strip everything after the nth NL in the string.
// Indicies are 1-based.
///////////////////////////////////////////////////////

- (NSString*)stripEverythingAfterNthNewline:(NSUInteger)newLineIndex
{
	NSArray				*parts = nil;
	NSMutableString		*newMutableString = nil;
	NSUInteger			i = 0;
	NSRange				nlRange = { 0, 0 };
	NSString			*newString = nil;
	
	newMutableString = [ NSMutableString stringWithCapacity:0 ];
	
	if( newLineIndex > 0 )
	{
		// See if this string contains at least 1 newline at all...
		
		nlRange = [ self rangeOfString:kNewlineStringKey
							options:NSLiteralSearch
							range:NSMakeRange( 0, [ self length ] )
							locale:nil ];
		
		if( !( nlRange.location == NSNotFound ) )
		{
			parts = [ self componentsSeparatedByString:kNewlineStringKey ];
			if( parts )
			{
				// Reassemble string from parts up to nth string...
				
				for( i = 0; i < newLineIndex; i++ )
				{
					// Make sure array index does not exceed bounds or we will crash...
					
					if( i < [ parts count ] )
					{
						[ newMutableString appendString:[ parts objectAtIndex:i ] ];
						
						// Append space if i> 1...
						
						if( i != ( newLineIndex - 1 ) )
						{
							[ newMutableString appendString:kSpaceStringKey ];
						}
						
						if( i == newLineIndex )
						{
							break;
						}
					}
				}
				
				newString = [ NSString stringWithString:newMutableString ];
			}
			else
			{
				newString = self;
			}
		}
		else
		{
			newString = self;
		}
	}
	else
	{
		newString = self;
	}
	
	return newString;
}

///////////////////////////////////////////////////////
// Strip everything after the nth space in the string.
// Indicies are 1-based.
///////////////////////////////////////////////////////

- (NSString*)stripEverythingAfterNthSpace:(NSUInteger)spaceIndex
{
	NSArray				*parts = nil;
	NSMutableString		*newMutableString = nil;
	NSUInteger			i = 0;
	NSRange				nlRange = { 0, 0 };
	NSString			*newString = nil;
	
	newMutableString = [ NSMutableString stringWithCapacity:0 ];
	
	if( spaceIndex > 0 )
	{
		// See if this string contains at least 1 newline at all...
		
		nlRange = [ self rangeOfString:kSpaceStringKey
							options:NSLiteralSearch
							range:NSMakeRange( 0, [ self length ] )
							locale:nil ];
		
		if( !( nlRange.location == NSNotFound ) )
		{
			parts = [ self componentsSeparatedByString:kSpaceStringKey ];
			if( parts )
			{
				// Reassemble string from parts up to nth string...
				
				for( i = 0; i < spaceIndex; i++ )
				{
					// Make sure array index does not exceed bounds or we will crash...
					
					if( i < [ parts count ] )
					{
						[ newMutableString appendString:[ parts objectAtIndex:i ] ];
					
						// Append space if i> 1...
						
						if( i != ( spaceIndex - 1 ) )
						{
							[ newMutableString appendString:kSpaceStringKey ];
						}
						
						if( i == spaceIndex )
						{
							break;
						}
					}
				}
				
				newString = [ NSString stringWithString:newMutableString ];
			}
			else
			{
				newString = self;
			}
		}
		else
		{
			newString = self;
		}
	}
	else
	{
		newString = self;
	}
	
	return newString;
}

/////////////////////////////////////////////////////
// Strip leading zeroes off string.
// Note returned string may be different than self.
/////////////////////////////////////////////////////

- (NSString*)stripLeadingZeros
{
	NSRange				theRange = { 0, 0 };
	NSString			*returnString = nil;
	NSString			*newCharString = nil;
	unichar				character = 'x';
	NSUInteger			j = 0;
	
	// Find index into self where leading zeros end...
	
	while( character && ( j < [ self length ] ) )
	{
		character = [ self characterAtIndex:j ];
		
		if( character != '0' )
		{
			break;
		}
		
		j++;
	}
	
	// j is now the starting index into the string so copy j+ everything til end of string...
	
	theRange.location = j;
	
	theRange.length = ( [ self length ] - j );
	
	newCharString = [ self substringWithRange:theRange ];
	if( newCharString )
	{
		returnString = [ NSString stringWithString:newCharString ];
	}
	
	return returnString;
}

///////////////////////////////////////////////////////////////////////
// Strip all occurences of multiple spaces from the string passed in.
// Note returned string may be different than self.
///////////////////////////////////////////////////////////////////////

- (NSString*)stripMutipleSpaces
{
	NSCharacterSet	*whitespaces = [ NSCharacterSet whitespaceCharacterSet ];
	NSPredicate		*noEmptyStrings = nil;
	NSArray			*parts = nil;
	NSArray			*filteredArray = nil;
	NSString		*returnString = nil;
	
	noEmptyStrings = [ NSPredicate predicateWithFormat:@"SELF != ''" ];
	if( noEmptyStrings && whitespaces )
	{
		parts = [ self componentsSeparatedByCharactersInSet:whitespaces ];
		if( parts )
		{
			filteredArray = [ parts filteredArrayUsingPredicate:noEmptyStrings ];
			if( filteredArray )
			{
				returnString = [ filteredArray componentsJoinedByString:kSpaceStringKey ];
			}
		}
	}
	
	return returnString;
}

//////////////////////////////////////////////////////////////
// Strip all trailing decimals and decimal point off string.
// Note returned string may be different than self.
//////////////////////////////////////////////////////////////

- (NSString*)stripTrailingDecimals
{
	NSArray		*separatedStringsArray = nil;
	NSString	*outString = nil;
	
	// Break string into components separated by decimals...
	
	separatedStringsArray = [ self componentsSeparatedByString:kDotStringKey ];
	if( separatedStringsArray )
	{
		// Make sure we got one...
		
		if( [ separatedStringsArray count ] )
		{
			// Get 1st object...
		
			outString = [ separatedStringsArray objectAtIndex:0 ];
		}
	}
	
	return outString;
}

/////////////////////////////////////////////////////
// Strip trailing zeroes off a decimal string.
// If string has no decimal point, do nothing.
// Note returned string may be different than self.
/////////////////////////////////////////////////////

- (NSString*)stripTrailingDecimalZeros
{
	NSRange				theRange = { 0, 0 };
	NSString			*returnString = nil;
	NSString			*newCharString = nil;
	NSUInteger			j = 0;
	NSUInteger			numCharsChopped = 0;
	
	// Make sure self contains decimal place...
	
	if( [ self containsString:kPeriodString ] )
	{
		// Start at BACK of string...
		
		j = ( [ self length ] - 1 );
		
		// Loop til we hit no more zeros from back of string...
		
		while( 1 )
		{
			theRange.location = j;
			
			theRange.length = 1;
			
			newCharString = [ self substringWithRange:theRange ];
			if( newCharString )
			{
				if( ( ![ newCharString isEqualToString:kZeroStringKey ] || [ newCharString isEqualToString:kPeriodString ] ) )
				{
					break;
				}
				else
				{
					numCharsChopped++;
				}
			}
			
			j--;
		}
		
		// Now make output from self's start up to last non-zero decimal place...
		
		theRange.location = 0;
		
		theRange.length = ( [ self length ] - numCharsChopped );
		
		returnString = [ self substringWithRange:theRange ];
		
		// If last char in string is a period, chop it off too...
		
		theRange.location = ( [ returnString length ] - 1 );
		
		theRange.length = 1;
		
		newCharString = [ self substringWithRange:theRange ];
		if( newCharString )
		{
			if( [ newCharString isEqualToString:kPeriodString ] )
			{
				theRange.location = 0;
				
				theRange.length = ( [ returnString length ] - 1 );
				
				returnString = [ self substringWithRange:theRange ];
			}
		}
	}
	else
	{
		returnString = self;
	}
	
	return returnString;
}

////////////////////////////////////////////////////////////
// Given a decimal string such as 100.000000001, strip the
// decimals down to only 2 places at the end of the string.
// The string must not have any other characters after the
// decimal part of the number.
////////////////////////////////////////////////////////////

- (NSString*)truncateToTwoDecimals
{
	NSRange		periodRange = { 0, 0 };
	NSRange		tempRange = { 0, 0 };
	NSString	*tempString = nil;
	NSString	*finalString = nil;
	NSUInteger	origLen = 0;
	
	// Find location of period in self...
	
	periodRange = [ self rangeOfString:kPeriodString
							options:NSLiteralSearch
							range:NSMakeRange( 0, [ self length ] )
							locale:nil ];
	
	if( periodRange.length )
	{
		// Get full length of original string...
		
		origLen = [ self length ];
		
		// Get part up to period...
		
		tempRange = periodRange;
		
		tempRange.length = tempRange.location;
		
		tempRange.location = 0;
		
		finalString = [ self substringWithRange:tempRange ];
		
		// Add the period...
		
		finalString = [ finalString stringByAppendingString:kPeriodString ];
		
		// Add 1 or 2 of the decimal values after the period, depending on how many there are...
		
		tempRange = periodRange;
		
		if( ( ( origLen - ( periodRange.location + 1 ) ) == 1 ) )
		{
			// Only copy 1 decimal place, since there is only 1...
			
			tempRange.length = 1;
		}
		else
		{
			// Copy 2 decimal places...
			
			tempRange.length = 2;
		}
		
		tempRange.location += 1;
		
		tempString = [ self substringWithRange:tempRange ];
		if( tempString )
		{
			finalString = [ finalString stringByAppendingString:tempString ];
		}
	}
	else
	{
		// 'self' has no decimal portion so just return self...
		
		finalString = self;
	}
	
	return finalString;
}
				
#pragma mark-
#pragma mark Core Location
#pragma mark-

#if TARGET_OS_IPHONE == 1

/////////////////////////////////////////////////////////////
// Convert a CLLocationCoordinate2D to a string describing
// the degrees, minutes, seconds (DMS) for that location.
//
// Example:
//
// 38.203655 is a decimal value of degrees. There are 60
// minutes in a degree and 60 seconds in a minute
// (1degree == 60min == 3600s).
//
// So take the fractional part of the value, i.e. 0.203655
// and multiply it by 60 to get minutes, i.e. 12.2193,
// which is 12 minutes, and then repeat for the fractional
// part of minutes, i.e. 0.2193 = 13.158000 seconds.
//
// Result string is latitude string, outLongitudeString
// contains out longitude.
/////////////////////////////////////////////////////////////

- (NSMutableString*)convertCLLocationCoordinate2DToHoursMinsSecsStrings:(CLLocationCoordinate2D)loc outLongitude:(NSMutableString**)outLongitudeString
{
	NSMutableString		*outLatitudeMutableString = nil;
	NSMutableString		*tempLatRemainderMutableString = nil;
	NSMutableString		*tempLongiRemainderMutableString = nil;
	double				tempCrapDouble = kFloatZero;
	double				tempCrapRemainderDouble = kFloatZero;
	float				roundedDownFloat = kFloatZero;
	unsigned int		tempInt = 0;
	
	// Make mutables...
	
	outLatitudeMutableString = [ NSMutableString stringWithCapacity:0 ];
	
	tempLatRemainderMutableString = [ NSMutableString stringWithCapacity:0 ];
	
	tempLongiRemainderMutableString = [ NSMutableString stringWithCapacity:0 ];
	
	if( outLongitudeString && outLatitudeMutableString && tempLatRemainderMutableString && tempLongiRemainderMutableString )
	{
		if( [ *outLongitudeString isKindOfClass:[ NSMutableString class ] ] )
		{
			/////////////
			// Latitude
			/////////////
			
			// Make positive, if negative...
			
			tempCrapDouble = fabs( loc.latitude );
			
			// Split integer & fraction part...
			
			tempCrapRemainderDouble = modf( tempCrapDouble, &tempCrapDouble );
			
			// 1. -> Calc degrees (hours)
			
			tempInt = (unsigned int)tempCrapDouble;
			
			[ outLatitudeMutableString appendString:[ [ NSNumber numberWithInt:(int)tempInt ] stringValue ] ];
			
			[ outLatitudeMutableString appendString:kDegreeStringKey ];
			
			[ outLatitudeMutableString appendString:kSpaceStringKey ];
			
			// 2. -> Calc minutes
			
			tempCrapDouble = ( tempCrapRemainderDouble * 60.0 );
			
			// Split integer & fraction part...
			
			tempCrapRemainderDouble = modf( tempCrapDouble, &tempCrapDouble );
			
			tempInt = (unsigned int)tempCrapDouble;
			
			[ outLatitudeMutableString appendString:[ [ NSNumber numberWithInt:(int)tempInt ] stringValue ] ];
			
			[ outLatitudeMutableString appendString:kSingleQuoteStringKey ];
			
			[ outLatitudeMutableString appendString:kSpaceStringKey ];
			
			// 3. -> Calc seconds - retaining fraction as is customary for GPS coords...
			
			tempCrapDouble = ( tempCrapRemainderDouble * 60.0 );
			
			// Round to 2 decimal places...
			
			roundedDownFloat = ( floorf( (CGFloat)tempCrapDouble * (CGFloat)100.0 ) / (CGFloat)100.0 );

			[ outLatitudeMutableString appendString:[ [ NSNumber numberWithFloat:roundedDownFloat ] stringValue ] ];
			
			[ outLatitudeMutableString appendString:kEscapedQuoteStringKey ];
			
			[ outLatitudeMutableString appendString:kSpaceStringKey ];
			
			//////////////
			// Longitude
			//////////////
			
			// Make positive, if negative...
			
			tempCrapDouble = fabs( loc.longitude );
			
			// Split integer & fraction part...
			
			tempCrapRemainderDouble = modf( tempCrapDouble, &tempCrapDouble );
			
			// 1. -> Calc degrees
			
			tempInt = (unsigned int)tempCrapDouble;
			
			[ *outLongitudeString appendString:[ [ NSNumber numberWithInt:(int)tempInt ] stringValue ] ];
			
			[ *outLongitudeString appendString:kDegreeStringKey ];
			
			[ *outLongitudeString appendString:kSpaceStringKey ];
			
			// 2. -> Calc minutes
			
			tempCrapDouble = ( tempCrapRemainderDouble * 60.0 );
			
			// Split integer & fraction part...
			
			tempCrapRemainderDouble = modf( tempCrapDouble, &tempCrapDouble );
			
			tempInt = (unsigned int)tempCrapDouble;
			
			[ *outLongitudeString appendString:[ [ NSNumber numberWithInt:(int)tempInt ] stringValue ] ];
			
			[ *outLongitudeString appendString:kSingleQuoteStringKey ];
			
			[ *outLongitudeString appendString:kSpaceStringKey ];
			
			// 3. -> Calc seconds - retaining fraction as is customary for GPS coords...
			
			tempCrapDouble = ( tempCrapRemainderDouble * 60.0 );
			
			// Round to 2 decimal places...
			
			roundedDownFloat = ( floorf( (CGFloat)tempCrapDouble * (CGFloat)100.0 ) / (CGFloat)100.0 );
			
			[ *outLongitudeString appendString:[ [ NSNumber numberWithFloat:roundedDownFloat ] stringValue ] ];
			
			[ *outLongitudeString appendString:kEscapedQuoteStringKey ];
			
			[ *outLongitudeString appendString:kSpaceStringKey ];
		}
	}
	
	return outLatitudeMutableString;
}

#endif

#pragma mark-
#pragma mark Paths
#pragma mark-

//////////////////////////////////////////
// Return current user's Desktop location.
//////////////////////////////////////////

- (NSString*)currentUsersDesktopPath
{
    NSArray		*pathsArray = nil;
	NSString	*path = nil;
	
	// Get all possible paths that match...
	
	pathsArray = NSSearchPathForDirectoriesInDomains( NSDesktopDirectory, NSUserDomainMask, YES );
	if( pathsArray )
	{
		if( [ pathsArray count ] )
		{
			// 'Desktop' will always be first one...
		
			path = [ pathsArray objectAtIndex:0 ];
		}
	}
	
    return path;
}

/////////////////////////////////
// Return the '/Users' dir path.
//////////////////////////////////

- (NSString*)usersDirectoryPath
{
    NSArray		*pathsArray = nil;
	NSString	*path = nil;
	
	// Get all possible paths that match...
	
	pathsArray = NSSearchPathForDirectoriesInDomains( NSUserDirectory, NSLocalDomainMask, YES );
	if( pathsArray )
	{
		if( [ pathsArray count ] )
		{
			// '/Users' will always be first one...
		
			path = [ pathsArray objectAtIndex:0 ];
		}
	}
	
    return path;
}

#if TARGET_OS_IPHONE == 0

////////////////////////////////////////////////////////////////////////
// Given a valid path, make the item it points to visible or invisible.
////////////////////////////////////////////////////////////////////////

- (void)makeVisible:(BOOL)visible
{
	FSCatalogInfo	catalogInfo;
	FSRef			parentRef;
	FSRef			ref;
	BOOL			converted = NO;
	OSErr			result = noErr;
	OSErr			result2 = noErr;
	
	bzero( &catalogInfo, sizeof( catalogInfo ) );
	bzero( &parentRef, sizeof( parentRef ) );
	bzero( &ref, sizeof( ref ) );
	
	// Convert to ref...
		
	converted = [ self toFSRef:&ref ];
	if( converted )
	{
		/* get the current finderInfo */
		
		result = FSGetCatalogInfo( &ref, kFSCatInfoFinderInfo, &catalogInfo, NULL, NULL, &parentRef );
		
		/* set or clear the appropriate bits in the finderInfo.finderFlags */
		
		if( visible )
		{
			/* AND out the bits */
			
			((FileInfo *)&catalogInfo.finderInfo)->finderFlags &= ~kIsInvisible;
		}
		else
		{
			/* OR in the bits */
			
			((FileInfo *)&catalogInfo.finderInfo)->finderFlags |= kIsInvisible;
		}
		
		/* save the modified finderInfo */
		
		result2 = FSSetCatalogInfo( &ref, kFSCatInfoFinderInfo, &catalogInfo );
		
		if( result || result2 )
		{
			#if DEBUG
			NSLog( @"Error in makeVisible:(BOOL)visible" );
			#endif
		}
	}
}

////////////////////////////////////////////////////////////////
// Given a valid path to a file or folder, return its FSRef.
// Return YES if the path is converted to a ref, no otherwise.
////////////////////////////////////////////////////////////////

- (BOOL)toFSRef:(FSRef*)ref
{
	BOOL	converted = NO;
	NSURL	*pathURL = nil;
	
	if( ref )
	{
		// Make NSURL from path...
		
		pathURL = [ NSURL fileURLWithPath:self ];
		if( pathURL )
		{
			// Convert the URL to a ref...
						
			converted = (BOOL)CFURLGetFSRef( (CFURLRef)pathURL, ref );
		}
	}
	
	return converted;
}

#endif

@end
