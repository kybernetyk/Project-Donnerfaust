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
			
			if (_touchdown_handled)
			{
				_is_touch_active = false;
				_touchdown_handled = false;
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
			_touchdown_handled = true;
			return _is_touch_active;
		}
		
		void setTouchActive (bool b)
		{
			_touchdown_handled = false;
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
		
		void setLeftActive ()
		{
			_state_left_active = true;
		}
		
		bool getLeftActive ()
		{
			if (!_state_left_active)
				return false;
			
			_state_left_active = false;
			return true;
		}

		void setRightActive ()
		{
			_state_right_active = true;
		}
		
		bool getRightActive ()
		{
			if (!_state_right_active)
				return false;
			
			_state_right_active = false;
			return true;
		}
		

		void setUpActive ()
		{
			_state_up_active = true;
		}
		
		bool getUpActive ()
		{
			if (!_state_up_active)
				return false;
			
			_state_up_active = false;
			return true;
		}
		
		
	protected:
		Uint8 *m_pBuffer;
		vector2D _touch_location;
		bool _is_touch_active;
		bool _is_touchup_active;
		bool _touchup_handled;
		
		bool _touchdown_handled;
		
		bool _state_left_active;
		bool _state_right_active;
		bool _state_up_active;
		
	private:
		InputDevice (void);
		~InputDevice (void);
		
		static InputDevice* _sharedInstance;

	};

}