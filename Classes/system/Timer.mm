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
	
	double getDoubleTime(void)
	{
		mach_timebase_info_data_t base;
		mach_timebase_info(&base);
		
		uint64_t nanos = (mach_absolute_time()*base.numer)/base.denom;
		return (double)nanos*1.0e-9;
	}

		
	void Timer::update (void)
	{
		m_ulLastTickCount = m_ulTickCount;
		m_ulTickCount = getDoubleTime();
		
		m_ulDelta = (m_ulTickCount - m_ulLastTickCount);
	}

}