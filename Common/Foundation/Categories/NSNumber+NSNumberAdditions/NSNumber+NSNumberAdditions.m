/*****************************************************************************
 
 File:			NSNumber+NSNumberAdditions.m
 
 Date:			12/23/11
 
 Version:		1.0
 
 Authors:		Michael Amorose
 
				Copyright 2011 Michael Amorose
				All rights reserved worldwide.
 
 Notes:			Header for NSNumber+NSNumberAdditions
 
				Set tab width and indent width both to 4 In XCode's
				Text Editing Preferences.
 
 WARNING:		UNDER NO CIRCUMSTANCES MAY THIS SOURCE CODE
				BE REDISTRIBUTED WITHOUT EXPRESS WRITTEN PERMISSION
				OF MICHAEL AMOROSE. ANY SUCH DISTRIBUTION CARRIES
				SEVERE CRIMINAL AND CIVIL PENALTIES AND IS A
				VIOLATION OF INTERNATIONAL COPYRIGHT LAW. VIOLATORS
				WILL BE PROSECUTED TO THE FULL EXTENT OF INTERNATIONAL LAW.
 
 Dependencies:	See header.
 
 Changes:		See header.
 
 ******************************************************************************/

#import <limits.h>

#import <NSNumber+NSNumberAdditions.h>
#import <NSString+NSStringAdditions.h>

#import <cb.h>

#import <HDTUtils.h>

@implementation NSNumber ( NSNumberAdditions )

//////////////////////////////////////////////////////
// Given a string in C base-16 hex notation, convert
// it to a decimal NSNumber.
//////////////////////////////////////////////////////

+ (NSNumber*)stringToNumber:(NSString*)_inStr base:(int)_base
{
    char		*end_ptr = NULL;
    long		tmpL = -0l;
    NSNumber	*outNum = nil;
	
	if( _inStr )
	{
		// WAS: tmpL = strtol( [ _inStr cString ], &end_ptr, _base );
		tmpL = strtol( [ _inStr UTF8String ], &end_ptr, _base );
		
		outNum = [ NSNumber numberWithLong:tmpL ];
	}
	
    return outNum;
}

//////////////////////////////////////////////////////
// Return a string with self capacity value
// formatted for MB/GB/TB, etc. and with a
// MB/GB/TB label appended to the end of the string.
// If capacity is 0, return a 0 string with no label.
// self MUST be a number representing RAW bytes.
//////////////////////////////////////////////////////

- (NSString*)capacityWithLabelStringOptionallyTruncatingToTwoDecimalPlaces:(BOOL)truncate
{
	NSMutableString		*deviceCapacityMutableString = nil;
	NSString			*labelString = nil;
	NSString			*outString = nil;
	NSNumber			*realCapacity = nil;
	double				formattedCapacity = 0.0;
	double				capacity = 0.0;
	
	// Capacity - Format with MB, GB, TB, or PB label...
	
	deviceCapacityMutableString = [ NSMutableString stringWithCapacity:0 ];
	if( deviceCapacityMutableString )
	{
		capacity = [ self doubleValue ];
		
		// Calc if size is a MB/GB/TB sized value...
		
		if( capacity == 0 )
		{
			formattedCapacity = 0.0;
		}
		else if( ( capacity < kOneGB ) && ( capacity > 0 ) )
		{
			// MB
			
			labelString = kMBLabelNSString;
			
			// Chop number down to # of MBs
			
			formattedCapacity = ( ( capacity / (double)kOneMB ) );
		}
		else if( ( ( capacity >= kOneGB ) && ( ( capacity < kOneTB ) && ( capacity > 0 ) ) ) )
		{
			// GB
			
			labelString = kGBLabelNSString;
			
			// // Chop number down to # of GBs
			
			formattedCapacity = ( ( capacity / (double)kOneGB ) );
		}
		else if( ( ( capacity >= kOneTB ) && ( capacity < kOnePB ) && ( capacity > 0 ) ) )
		{
			// TB
			
			labelString = kTBLabelNSString;
			
			// // Chop number down to # of TBs
			
			formattedCapacity = ( ( capacity / (double)kOneTB ) );
		}
		else if( ( ( capacity >= kOnePB ) && ( capacity > 0 ) ) )
		{
			// PB
			
			labelString = kPBLabelNSString;
			
			// // Chop number down to # of PBs
			
			formattedCapacity = ( ( capacity / (double)kOneTB ) );
		}
		
		// Remove decimal portion by rounding...
		
		if( ( formattedCapacity > 0 ) )
		{
			formattedCapacity = round_num( formattedCapacity, 2 );
		}
		
		// Make capacity number...
		
		realCapacity = [ NSNumber numberWithDouble:(double)formattedCapacity ];
		if( realCapacity )
		{
			// Get capacity number as string...
			
			if( [ realCapacity stringValue ] )
			{
				if( truncate )
				{
					// Truncate it to 2 decimals...
				
					outString = [ [ realCapacity stringValue ] truncateToTwoDecimals ];
				}
				else
				{
					outString = [ NSString stringWithString:[ realCapacity stringValue ] ];
				}
				
				// Need to check for nil outString here - if nil it means capacity was 0 so we just need to use @"0"...
				
				if( !outString )
				{
					outString = kZeroStringKey;
				}
				
				if( outString )
				{
					[ deviceCapacityMutableString appendString:outString ];
				}
			}
		}
		
		// Add label (only if bytes > 0)...
		
		if( labelString )
		{
			[ deviceCapacityMutableString appendString:kSpaceStringKey ];
			
			[ deviceCapacityMutableString appendString:labelString ];
		}
		
		// Make output...
		
		outString = [ NSString stringWithString:deviceCapacityMutableString ];
	}
	
	return outString;
}

@end
