#include <maUtilsProcess.h>

#pragma mark ---------------
#pragma mark Process Utils
#pragma mark ---------------

//////////////////////////////////////////////////////////////////////////
// Returns a list of all BSD processes on the system. This routine
// allocates the list and puts it in *procList and a count of the
// number of entries in *procCount. You are responsible for freeing
// this list (use "free" from System framework). On success, the function
// returns 0. On error, the function returns a BSD errno value.
//
// This routine is only available when compiling using XCode and is
// unavailable when compiling in CodeWarrior.
//////////////////////////////////////////////////////////////////////////

int GetBSDProcessList( struct kinfo_proc **procList, size_t *procCount )
{
    bool				done = false;
    int					err = 0;
    size_t				length = 0;
	static const int	name[] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0 };
	kinfo_proc			*result = NULL;
    
	if( procList && procCount )
	{
		*procCount = 0;

		////////////////////////////////////////////////////////////////////
		// We start by calling sysctl with result == NULL and length == 0.
		// That will succeed, and set length to the appropriate length.
		// We then allocate a buffer of that size and call sysctl again
		// with that buffer. If that succeeds, we're done. If that fails
		// with ENOMEM, we have to throw away our buffer and loop. Note
		// that the loop causes use to call sysctl with NULL again; this
		// is necessary because the ENOMEM failure case sets length to
		// the amount of data returned, not the amount of data that
		// could have been returned.
		////////////////////////////////////////////////////////////////////
		
		do
		{
			// Call sysctl with a NULL buffer.

			length = 0;
			
			err = sysctl(	(int*)name,
							( sizeof( name ) / sizeof( *name ) ) - 1,
							NULL,
							&length,
							NULL,
							0	);
			
			if( err == -1 )
			{
				err = errno;
			}

			// Allocate an appropriately sized buffer based on the results
			// from the previous call.

			if( err == 0 )
			{
				result = (kinfo_proc*)malloc( length );
				if( result == NULL )
				{
					err = ENOMEM;
				}
			}

			// Call sysctl again with the new buffer.  If we get an ENOMEM
			// error, toss away our buffer and start again.

			if( err == 0 )
			{
				err = sysctl(	(int*)name,
								( sizeof( name ) / sizeof( *name ) ) - 1,
								result,
								&length,
								NULL,
								0	);
								
				if( err == -1 )
				{
					err = errno;
				}
				
				if( err == 0 )
				{
					done = true;
				}
				else if ( err == ENOMEM )
				{
					assert( result != NULL );
					
					free( result );
					
					result = NULL;
					
					err = 0;
				}
			}
		} while ( err == 0 && !done );

		// Clean up and establish post conditions.

		if( err != 0 && result != NULL )
		{
			free( result );
			
			result = NULL;
		}
		
		*procList = result;
		if( err == 0 )
		{
			*procCount = length / sizeof( kinfo_proc );
		}
	}
    
    return err;
}