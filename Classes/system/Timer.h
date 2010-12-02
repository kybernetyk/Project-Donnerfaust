#pragma once
//#include <SDL/SDL.h>
#include <string>
#include <sstream>
#include <stdio.h>
namespace mx3 
{
	double GetDoubleTime(void);
	unsigned int GetTickCount();
	
	class Timer
	{
	public:
		void update (void);
		
		Timer ()
		{
			m_ulDelta = 0;
			m_ulLastTickCount = 0;
			m_ulTickCount = 0;
			temp = 0.0;
			frames = 0.0;
		}

	/*	inline unsigned long delta (void)
		{
			return m_ulDelta;
		}*/
		
		inline double fdelta ()
		{
			return m_ulDelta;
		}

		std::string stringWithFPS (void)
		{
			float fps = 1.0 / m_ulDelta;
			std::stringstream s;
			s << "current fps: " << fps;
			return s.str();
		}
		
		double printFPS (bool printout)
		{
			frames ++;
			temp += m_ulDelta;
			//printf ("%f\n",temp);
			if (temp >= 0.5f)
			{
				if (printout)
					CV3Log  ("fps: %f\n", frames / temp);
				
				fps = frames / temp;
				
				temp = 0.0;
				frames = 0.0;
				
			}
			
			return fps;
		}
		
	protected:
		double m_ulTickCount;
		double m_ulLastTickCount;
		double m_ulDelta;
		
		double temp;
		double frames;
		
		double fps;
	};


}