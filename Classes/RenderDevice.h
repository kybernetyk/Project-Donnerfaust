#pragma once
#include "SystemConfig.h"
#include "Util.h"
#include <vector>
#include "Timer.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/Es1/glext.h>
#include "Texture2D.h"
#include "util.h"
namespace mx3 
{
	
		
	class RenderDevice
	{
	public:
		//Singletonshit
		static RenderDevice *sharedInstance (void);
		static void unload (void);

		
		void init (void);
		void release (void);

	//	void flip (void);
		
		void beginRender (void);
		
		void endRender (void);

#define RENDERTARGET_SCREEN 0
#define RENDERTARGET_TEXTURE 1		
		float r;
		int current_render_target;
		

		//das hier benutzen, wenn man etwas auf den reference screen in npixels will und es auf der aktuellen aufloesung hochskallieren soll
		//zb ein background bild mit w = reference_w wird zu einem bild mit w = 100% aktueller screen
		//im endeffekt wird das bild dann immer in seiner nativen pixelaufloesung gezeigt
		//es wird 400px bei 640x480 gross angezeigt und ebenso bei 1024x768
		/*float pixelToMeterInAccountOfReferenceScreenSize (float nPixels) //gibt die size von n-pixeln in metern zurueck
		{
			//vector2D ret;
			
			//ret.x = nPixels * (_meterViewportSize.x / _pixelViewportSize.x);
			//ret.y = nPixels * (_meterViewportSize.y / _pixelViewportSize.y);
			//x = 64 * (10.0f/800) = .8m
			//y = 64 * (7.5f/600) = .8m
			//return ret;
			printf("pixel to meter!\n");
			return nPixels * (_meterViewportSize.x / _referenceScreenSize.x);
		}
		
		vector2D pixelToMeterInAccountOfReferenceScreenSize (vector2D nPixels) //gibt die size von n-pixeln in metern zurueck
		{	
			vector2D ret;
			
			ret.x = nPixels.x * (_meterViewportSize.x / _referenceScreenSize.x);
			ret.y = nPixels.y * (_meterViewportSize.y / _referenceScreenSize.y);

	//		ret.x = nPixels.x/(_referenceScreenSize.x / _meterViewportSize.x);
	//		ret.y = nPixels.y/(_referenceScreenSize.y / _meterViewportSize.y);
			
			printf("pixel to meter:%f,%f = %f,%f\n",nPixels.x,nPixels.y,ret.x,ret.y);
			return ret;
		}
		/*
		
		vector2D pixelToMeterRatioInAccountOfReferenceScreenSize () //gibt die ratio fuer die transformation von pixel->meter zurueck
		{
			vector2D ret;
			ret.x = (_meterViewportSize.x / _referenceScreenSize.x);
			ret.y = (_meterViewportSize.y / _referenceScreenSize.y);
			printf("pixel to meter!\n");
			//ein pixelwert mit dieser ratio multipliziert ergibt die groesse der pixel in metern
			return ret;
		}*/
		
		//rechnet pixel in meter anhand der festgelegten ratio um
		//wenn zb festgelegt wurde, dass 32px = 1m sind, wird ein bild, das hier umgerechnet wird
		//korrekt skalliert in der aktuellen aufloesung
		//zu benutzen: fast immer, ausser man will einen background effekt ...

		//sollte aber nicht zu oft genutzt werden. lieber den sprites zb. feste groessen in metern zuweisen
	/*	float pixelToMeter (float nPixels) //gibt die size von n-pixeln in metern zurueck
		 {
			 return nPixels * _pixelToMeterRatio;
		 }
		 
		 vector2D pixelToMeter (vector2D nPixels) //gibt die size von n-pixeln in metern zurueck
		 {	
			 vector2D ret;
		 
			 ret.x = nPixels.x * _pixelToMeterRatio;
			 ret.y = nPixels.y * _pixelToMeterRatio;
			 return ret;
		 }
		 /*
		 

		//transformation meter <-> pixel
		
	/*	float pixelToMeter (float nPixels) //gibt die size von n-pixeln in metern zurueck
		{
			//vector2D ret;
			
			//ret.x = nPixels * (_meterViewportSize.x / _pixelViewportSize.x);
			//ret.y = nPixels * (_meterViewportSize.y / _pixelViewportSize.y);
			//x = 64 * (10.0f/800) = .8m
			//y = 64 * (7.5f/600) = .8m
			//return ret;
			printf("pixel to meter!\n");
			return nPixels * (_meterViewportSize.x / _pixelViewportSize.x);
			
			//return nPixels / _pixelToMeterRatio.x;
		}
		
		vector2D pixelToMeter (vector2D nPixels) //gibt die size von n-pixeln in metern zurueck
		{	
			vector2D ret;
			
			ret.x = nPixels.x * (_meterViewportSize.x / _pixelViewportSize.x);
			ret.y = nPixels.y * (_meterViewportSize.y / _pixelViewportSize.y);
			
			//ret.x = nPixels.x / _pixelToMeterRatio.x;
			//ret.y = nPixels.y / _pixelToMeterRatio.y;
			
			
			printf("pixel to meter!\n");
			return ret;
		}
	/*
		
		vector2D pixelToMeterTatio() //gibt die ratio fuer die transformation von pixel->meter zurueck
		{
			vector2D ret;
			ret.x = (_meterViewportSize.x / _pixelViewportSize.x);
			ret.y = (_meterViewportSize.y / _pixelViewportSize.y);
			printf("pixel to meter!\n");
			//ein pixelwert mit dieser ratio multipliziert ergibt die groesse der pixel in metern
			return ret;
		}
		*/
		/*vector2D meterToPixel (float nMeter) //gibt die groesse von n-metern als pixel zurueck
		{
			vector2D ret;
			
			ret.x = nMeter * (_pixelViewportSize.x / _meterViewportSize.x);
			ret.y = nMeter * (_pixelViewportSize.y / _meterViewportSize.y);
			//x = 3.40f * (800/10.0f) = 272
			//x = 3.40f * (600/7.5f) = 272
			return ret;
		}
		
		/*
		vector2D meterTopixelRatio() //gibt die ratio fuer die transformation von meter->pixel zurueck
		{
			vector2D ret;
			ret.x = (_pixelViewportSize.x / _meterViewportSize.x);
			ret.y = (_pixelViewportSize.y / _meterViewportSize.y);
			
			//ein meterwert mit dieser ratio multipliziert ergibt die groesse in pixeln
			return ret;
		}*/
		
	/*	vector2D calculate_viewportmetersize_for_one_meter_equals_n_pixel(v2d n, v2d viewportpixelsize)
		{
			//gibt bei gegebener viewportgroese in pixeln die groesse des viewports
			//in metern zurueck, wenn n pixel 1m entsprechen sollen
			ret.x = viewportpixelsize.x / n.x
			ret.y = viewportpixelsize.y / n.y
			
			//1m soll 64x64 pixel sein bei einem hardware-viewport von 800x600px:
			//ret.x = 800/64 = 12.5
			//ret.y = 600/64 = 9.375
		}
	*/	
		
	/*	void setReferenceScreenSize (vector2D ref)
		{
			_referenceScreenSize = ref;
		}*/
		
		inline vector2D viewportSize ()
		{
			return _meterViewportSize;
		}
		
	
//		-(CGPoint)convertToGL:(CGPoint)uiPoint;
		vector2D coord_convertScreenToWorld (vector2D vec)
		{
			//printf("input: %f, %f\n", vec.x,vec.y);
			
			vector2D ret;
			ret.x = vec.x * _xconv + camera.x - _meterViewportSize.x/2; //+ camera offset etc
			ret.y = vec.y * _yconv + camera.y - _meterViewportSize.y/2;
			
			
			//TODO: camera rotation
			
//			printf("output: %f, %f\n", ret.x, ret.y);
			
			return ret;
		}
		
		
		void setupViewportAndProjection (int viewport_width_in_pixels, int viewport_height_in_pixels, float viewport_width_in_meters, float viewport_height_in_meters);

		GLuint textureFrameBuffer;
		GLuint renderTexture;
		GLint prev;
		
		void setupBackingTexture ()
		{
#ifndef __ALLOW_RENDER_TO_TEXTURE__
			abort();
#endif
			renderTexture = make_empty_texture(512, 512);
			
			//Texture2D *rtx = new Texture2D("white.png");
			//rtx->setAliasTexParams();
			//renderTexture = rtx->_openGlTextureID;
			
			prev = 100;
			glGetIntegerv(GL_FRAMEBUFFER_BINDING_OES, &prev);
			
			glGenFramebuffersOES(1, &textureFrameBuffer);
			glBindFramebufferOES(GL_FRAMEBUFFER_OES, textureFrameBuffer);
			
			
			
			// attach renderbuffer
			glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, renderTexture, 0);
			
			if (0) 
			{
				GLint backingWidth;
				GLint backingHeight;
				GLuint depthRenderbuffer;
				// attach depth buffer
				glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
				glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
				
				glGenRenderbuffersOES(1, &depthRenderbuffer);
				glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
				glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
				glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
			}
			
			// unbind frame buffer
			 glBindFramebufferOES(GL_FRAMEBUFFER_OES, prev);
			r = 0;
		}

		void setRenderTargetBackingTexture ()
		{
#ifndef __ALLOW_RENDER_TO_TEXTURE__
			abort();
#endif
			if (current_render_target == RENDERTARGET_TEXTURE)
				return;
			current_render_target = RENDERTARGET_TEXTURE;
			
			glBindFramebufferOES(GL_FRAMEBUFFER_OES, textureFrameBuffer);
			glViewport(0, 0, 512, 512);

		}
		
		void setRenderTargetScreen ()
		{
#ifndef __ALLOW_RENDER_TO_TEXTURE__
			abort();
#endif
			
			if (current_render_target == RENDERTARGET_SCREEN)
				return;
			current_render_target = RENDERTARGET_SCREEN;
			
			glBindFramebufferOES(GL_FRAMEBUFFER_OES, prev);
			glViewport(0,0,_pixelViewportSize.x, _pixelViewportSize.y);
		}
		
		void renderBackingTextureToScreen ()
		{
#ifndef __ALLOW_RENDER_TO_TEXTURE__
			abort();
#endif
			//return;
		//	setRenderTargetScreen();
			
			//glLoadIdentity();
			//glPushMatrix();
//			glLoadIdentity();


			
//			glTranslatef( (0.5 * 320),  (0.5 * 480), 0);

/*			r+=1.0;
			glRotatef(r, 0, 0, 1);
			float xscale = fabs(sin (DEG2RAD (r)))+0.2;
			float yscale = fabs(cos (DEG2RAD (r)))+0.2;
//			xscale = MIN(xscale, 1.2);
//			yscale = MIN(yscale, 1.2);
			
			glScalef(xscale, yscale, 0.0);*/
//			glTranslatef( -(0.5 * 320),  -(0.5 * 480), 0);			
			
			
//						glTranslatef( x, y, 0);
			//glTranslatef(x, y, z);
			
			/*if (rotation != 0.0f )
				glRotatef( -rotation, 0.0f, 0.0f, 1.0f );
			
			if (scale_x != 1.0 || scale_y != 1.0)
				glScalef( scale_x, scale_y, 1.0f );*/
			
//			glTranslatef(- (0.5 * 320), - (0.5 * 480), 0);
			
			

			//glTranslatef(320/2, 480/2, 0);
			
			
//			glTranslatef(320/2, 480/2, 0);
//			glTranslatef(0/2, -480/2, 0);
			//glScalef(1.0, 1.0, 1.0);
			//glRotatef(45, 0, 0, 1);
			//glTranslatef(320/2, -480/2, 0);

		//	transform();
			
			
		/*	GLfloat		coordinates[] = { 0.0f,	1.0,
				1.0,	1.0,
				0.0f,	0.0f,
				1.0,	0.0f };
		*/
			
			GLfloat		coordinates[] = { 0.0f,	0.0,
				1.0,	0.0,
				0.0f,	1.0f,
				1.0,	1.0f };
			
			
			//inverse coords oO
		/*	GLfloat		coordinates[] = { 0.0f,	0.0,
				_pixelViewportSize.x/512.0,	0.0,
				0.0f,	_pixelViewportSize.y/512.0,
				_pixelViewportSize.x/512.0,	_pixelViewportSize.y/512.0 };*/
			
			
			
			
/*			GLfloat		vertices[] = 
			{	
				0,			0,			0,
				512,	0,			0,
				0,			512,	0,
				512,			512,	0
			};*/
			

			GLfloat		vertices[] = 
			 {	
			 0,			0,			0,
			 _pixelViewportSize.x*_xconv,	0,			0,
			 0,			_pixelViewportSize.y*_yconv,	0,
			 _pixelViewportSize.x*_xconv,			_pixelViewportSize.y*_yconv,	0
			 };
			
			
			
			
			//		glEnableClientState( GL_VERTEX_ARRAY);
			//		glEnableClientState( GL_TEXTURE_COORD_ARRAY );
			
			//		glEnable( GL_TEXTURE_2D);
			//			texture->makeActive();
			
			float alpha = 1.0;
			GLfloat colors[] = 
			{
				1.0,1.0,1.0,alpha,
				1.0,1.0,1.0,alpha,
				1.0,1.0,1.0,alpha,
				1.0,1.0,1.0,alpha,
			};
			glColorPointer(4, GL_FLOAT, 0, colors);
			
			if (mx3::Texture2D::boundTexture != renderTexture)
			{
				mx3::Texture2D::boundTexture = renderTexture;
				glBindTexture( GL_TEXTURE_2D, renderTexture );
			}

			//	glColor4f(1.0, 1.0,1.0, alpha);
			glVertexPointer(3, GL_FLOAT, 0, vertices);
			glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
			glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
			
		//	glPopMatrix();
			
		}
		
		vector2D camera;
		float cam_rot;
		
		
		
private:
		GLuint make_empty_texture (int width, int height)
		{
#ifndef __ALLOW_RENDER_TO_TEXTURE__
			abort();
#endif
			GLuint ret;
			
			glGenTextures(1, &ret);

			glBindTexture(GL_TEXTURE_2D, ret);
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );

			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
			
			glBindTexture(GL_TEXTURE_2D, ret);
			mx3::Texture2D::boundTexture = ret;
			
			return ret;
		}
		
		
	//	float _pixelToMeterRatio;
		
	//	vector2D _pixelToMeterRatio;
	//	vector2D _meterToPixelRatio;
		
		vector2D _pixelViewportSize; //viewport size in pixels (e.g. window size 800x600)
		vector2D _meterViewportSize; //viewport size in meters (e.g. 10.0fx7.5f)
	//	vector2D _referenceScreenSize; //the screensize that is referenced. eg. all 32x32px sprites are 32x32px on this screen size (eg 800,600)
		
		//Timer _frameTimer;
		
		float _xconv;
		float _yconv;
		
		vector2D cam_pos;
		
		RenderDevice (void);
		~RenderDevice (void);

	   static RenderDevice* _sharedInstance;
		
	};


}