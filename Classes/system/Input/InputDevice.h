#pragma once
#include "Util.h"

#define SDLKey unsigned char
#define Uint8 unsigned char

namespace mx3 
{
	
		
	class InputDevice
	{
	public:
		//Singletonshit
		static InputDevice *sharedInstance (void);
		static void unload (void);
			

	public:
		inline bool isKeyPressed (SDLKey key)
		{
			return m_pBuffer [key];
		}

		inline void update (void)
		{
			if (_touchup_handled)
			{
				_is_touchup_active = false;
				_touchup_handled = false;
			}
			
		}
		
		vector2D touchLocation ()
		{
			return _touch_location;
		}
		
		void setTouchLocation (vector2D vec)
		{
			_touch_location = vec;
		}
		
		bool isTouchActive ()
		{
			return _is_touch_active;
		}
		
		void setTouchActive (bool b)
		{
			_is_touch_active = b;
		}
		
		bool touchUpReceived ()
		{
			_touchup_handled = true;
			return _is_touchup_active;
		}
		
		void setTouchUpReceived (bool b)
		{
			_is_touchup_active = b;
			_touchup_handled = false;
		}

	protected:
		Uint8 *m_pBuffer;
		vector2D _touch_location;
		bool _is_touch_active;
		bool _is_touchup_active;
		bool _touchup_handled;
		
	private:
		InputDevice (void);
		~InputDevice (void);
		
		static InputDevice* _sharedInstance;

	};

}