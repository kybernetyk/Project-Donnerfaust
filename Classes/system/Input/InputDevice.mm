// Input.cpp: implementation of the Input class.
//
//////////////////////////////////////////////////////////////////////

#include "InputDevice.h"
#include <stddef.h>
namespace mx3 
{
	
	InputDevice* InputDevice::_sharedInstance = 0;

	InputDevice::InputDevice (void)
	{
		_is_touch_active = false;
		_touchup_handled = false;
		_is_touchup_active = false;
		_state_right_active = _state_left_active = false;
		_state_up_active = false;
		
		_touchdown_handled = false;


	}

	InputDevice::~InputDevice (void)
	{
		
	}

	InputDevice* InputDevice::sharedInstance (void)
	{
		if(!_sharedInstance)
			_sharedInstance = new InputDevice;
		
		return _sharedInstance;
	}

	void InputDevice::unload (void)
	{
		if (_sharedInstance)
		{
			delete _sharedInstance;
			_sharedInstance = NULL;
		}
	}

}