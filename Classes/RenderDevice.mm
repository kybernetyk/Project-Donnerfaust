#include "SystemConfig.h"
#include "RenderDevice.h"
#include <memory.h>
#include <stdlib.h>
#include <algorithm>
#include "Util.h"

//#include "SDL.h"

//#include <windows.h>
//#include <OpenGL/gl.h>        // Header File For The OpenGL32 Library
//#include <OpenGL/glu.h>       // Header File For The GLu32 Library
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/Es1/glext.h>

namespace mx3 
{
	
		
	RenderDevice* RenderDevice::_sharedInstance = 0;

	RenderDevice::RenderDevice (void)
	{

	}

	RenderDevice::~RenderDevice (void)
	{

	}

	RenderDevice* RenderDevice::sharedInstance (void)
	{
		if(!_sharedInstance)
			_sharedInstance = new RenderDevice;

	   return _sharedInstance;
	}

	void RenderDevice::unload (void)
	{
	//   SDL_Quit ();

		if (_sharedInstance)
	   {
		  delete _sharedInstance;
		  _sharedInstance = NULL;
	   }
	}

	void RenderDevice::setupViewportAndProjection (int viewport_width_in_pixels, int viewport_height_in_pixels, float viewport_width_in_meters, float viewport_height_in_meters)
	{
		_xconv = (float)viewport_width_in_meters / (float)viewport_width_in_pixels;
		_yconv = (float)viewport_height_in_meters / (float)viewport_height_in_pixels;

		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();

		glViewport(0,0,viewport_width_in_pixels, viewport_height_in_pixels);
		
		glEnable(GL_TEXTURE_2D); //enable texture mapping
		glClearColor(0.0f, 0.0f, 0.0f, 0.0f); //Black Background

		/*glClearDepthf(1.0); //enables clearing of deapth buffer
		glDepthFunc(GL_LEQUAL); //type of depth test
		glEnable(GL_DEPTH_TEST); //enables depth testing*/

		glDisable(GL_DEPTH_TEST);
		glDisable(GL_ALPHA_TEST);
		
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );//GL_ONE_MINUS_SRC_ALPHA);      // Enable Alpha Blending (disable alpha testing)
		glEnable(GL_BLEND);
		
		glShadeModel(GL_SMOOTH); //enables smooth color shading
		//glEnable(GL_ALPHA_TEST);
		//glAlphaFunc(GL_GREATER, 0.1);
		

		
		
		
		
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity(); //Reset projection matrix

		//glOrthof(-viewport_width_in_meters/2.0 , viewport_width_in_meters/2.0 , -viewport_height_in_meters/2.0, viewport_height_in_meters/2.0 , -10.0 , 10.0 );

		glOrthof(0, viewport_width_in_meters, 0, viewport_height_in_meters, -10.0 , 10.0 );
		
		//landscape

	#ifdef MANUAL_LANDSCAPE
		glRotatef(-90, 0, 0, 1);
	#endif

		
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		
		
				glEnableClientState( GL_VERTEX_ARRAY);
				glEnableClientState( GL_TEXTURE_COORD_ARRAY );
				glEnableClientState( GL_COLOR_ARRAY);
		
				glEnable( GL_TEXTURE_2D);

	//	printf("OMFG");

	/*	_pixelViewportSize.x = viewport_width_in_pixels;
		_pixelViewportSize.y = viewport_height_in_pixels;
		
		_meterViewportSize.x = viewport_width_in_meters;
		_meterViewportSize.y = viewport_height_in_meters;*/

		
		//iphone landscape
		 _pixelViewportSize.x = viewport_width_in_pixels;
		 _pixelViewportSize.y = viewport_height_in_pixels;
		 
		/*
		 iPhone muessen wir die meter-size invertieren, da das ding ja um 90 grad landscape gehalten wird
		 */
		_meterViewportSize.x = viewport_width_in_meters;
		_meterViewportSize.y = viewport_height_in_meters;
		
		
	}

	void RenderDevice::init (void)
	{

	#ifdef ORIENTATION_LANDSCAPE
		float screen_size_x = SCREEN_W;
		float screen_size_y = SCREEN_H;	//change to 280 for a 40px high empty strip [eg for an ad banner]

		float viewport_size_x = SCREEN_W;// / pixeltometerratio;//viewport_size_x / xyratio;
		float viewport_size_y = SCREEN_H;	
	#endif

	#ifdef ORIENTATION_PORTRAIT
		float screen_size_x = SCREEN_W;
		float screen_size_y = SCREEN_H;	
		
		float viewport_size_x = SCREEN_W;// / pixeltometerratio;//viewport_size_x / xyratio;
		float viewport_size_y = SCREEN_H;	
	#endif	
		
		
		current_render_target = RENDERTARGET_SCREEN;
		cam_rot = 0.0;		
		camera = vector2D_make(viewport_size_x/2, viewport_size_y/2);
		
		//camera = vector2D_make(0, 0);
		setupViewportAndProjection(screen_size_x,screen_size_y,viewport_size_x,viewport_size_y);
		
	}


	/*void RenderDevice::flip (void)
	{
		//SDL_GL_SwapBuffers(); - WICHTIK
		//glClearColor(0.7,0.0,0.7,0.0);
		//glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);	 // Clear The Screen And The Depth Buffer
		glLoadIdentity();
		glTranslatef(-_pixelViewportSize.x/2.0, -_pixelViewportSize.y/2.0, 0);
	}*/

	void RenderDevice::beginRender (void)
	{
		glClearColor(0.0f, 0.0f, 0.5f, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT);
		
		glLoadIdentity();
		
		
		glTranslatef( _meterViewportSize.x/2.0, _meterViewportSize.y/2.0, 0);
		
		if (cam_rot != 0.0)
			glRotatef(cam_rot, 0.0, 0.0, 1.0);
		
		glTranslatef( -camera.x , -camera.y, 0.0);



	}

	void RenderDevice::endRender (void)
	{
		
	}


	void RenderDevice::release (void)
	{

	}



}