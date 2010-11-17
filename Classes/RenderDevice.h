#pragma once
#include "Util.h"
#include <vector>
#include "Timer.h"

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
		
	private:
		void setupViewportAndProjection (int viewport_width_in_pixels, int viewport_height_in_pixels, float viewport_width_in_meters, float viewport_height_in_meters);

	//	float _pixelToMeterRatio;
		
	//	vector2D _pixelToMeterRatio;
	//	vector2D _meterToPixelRatio;
		
		vector2D _pixelViewportSize; //viewport size in pixels (e.g. window size 800x600)
		vector2D _meterViewportSize; //viewport size in meters (e.g. 10.0fx7.5f)
	//	vector2D _referenceScreenSize; //the screensize that is referenced. eg. all 32x32px sprites are 32x32px on this screen size (eg 800,600)
		
		//Timer _frameTimer;
		
		RenderDevice (void);
		~RenderDevice (void);

	   static RenderDevice* _sharedInstance;
		
	};


}