/*
 *  Timer.cpp
 *  nxframework
 *
 *  Created by jrk on 08.04.09.
 *  Copyright 2009 flux forge. All rights reserved.
 *
 */

#include "Timer.h"
#include <sys/time.h>
#include "time.h"
#include <mach/mach.h>
#include <mach/mach_time.h>
namespace mx3 
{

	/* returns the system time in milliseconds */
	unsigned int GetTickCount()
	{
		timeval v;
		gettimeofday(&v, 0);
		//long millis = (v.tv_sec * 1000) + (v.tv_usec / 1000);
		//return millis;
		
		return (v.tv_sec * 1000) + (v.tv_usec / 1000);
	}
	
	double GetDoubleTime(void)
	{
		mach_timebase_info_data_t base;
		mach_timebase_info(&base);
		
		uint64_t nanos = (mach_absolute_time()*base.numer)/base.denom;
		return (double)nanos*1.0e-9;
	}

		
	void Timer::update (void)
	{
		m_ulLastTickCount = m_ulTickCount;
		m_ulTickCount = GetDoubleTime();
		
		m_ulDelta = (m_ulTickCount - m_ulLastTickCount);
	}

}