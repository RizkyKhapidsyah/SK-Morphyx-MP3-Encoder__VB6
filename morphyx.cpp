/*********************************************************
 * FILE: morphyx.cpp									 *
 * AUTHOR: Ultimatum									 *
 * DESCRIPTION: API "wrapper" for the various MP3        *
 *				encoding engines.                        *
 *********************************************************/


// Note to programmers: this file I wrote myself. However,
// I did NOT write the file bladedll.h, nor did I create
// the Blade Encoder DLL or the Lame Encoder DLL

#include <windows.h>
#include <stdio.h>
#include <string.h>
#include <io.h>
#include <fcntl.h>
#include <sys/stat.h>

// Lame and Blade have the same API prototypes, so only one header is needed.
// I chose the blade header.
#include "bladedll.h"

#define WINEXPORT __declspec(dllexport) WINAPI

// MP3 encoding prototypes
BEINITSTREAM	beInitStream;
BEENCODECHUNK	beEncodeChunk;
BEDEINITSTREAM	beDeinitStream;
BECLOSESTREAM	beCloseStream;

// enumerated encoder engine
#define ENC_LAME 0
#define ENC_BLADE 1

int				encoding_still;
DWORD			percent_done = 0;
LONG			thisEncoder;

HINSTANCE hBladeDLL;
HINSTANCE hLameDLL;

// enum to MP3 encoding status
typedef BOOL (CALLBACK* ENUMENC) (int);

// DLL startup
extern "C" int APIENTRY
DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
	if (dwReason == DLL_PROCESS_ATTACH)
	{
		// startup processing
		hBladeDLL = LoadLibrary("BLADEENC.DLL");
		hLameDLL  = LoadLibrary("LAME_ENC.DLL");
		thisEncoder = ENC_BLADE;
	}
	else if (dwReason == DLL_PROCESS_DETACH)
	{
		// cleanup processing
		if (hBladeDLL)
			FreeLibrary(hBladeDLL);
		if (hLameDLL)
			FreeLibrary(hLameDLL);

	}
	return 1;
}

LONG WINEXPORT SetEncoder(LONG enc)
{
	thisEncoder = enc;
	return 0;

}

LONG WINEXPORT EncodeMp3(LPCSTR lpszWavFile, ENUMENC &EnumEncoding)
{	
	if(lpszWavFile == "")
	{
		return -1;
	}

	// Load Encoding DLL

	if (thisEncoder == ENC_BLADE)
	{
		if(!hBladeDLL)
		{
			return -1;
		}
	}
	else
	{
		if(!hLameDLL)
		{
			return -1;
		}
	}

	// Get Interface

	if (thisEncoder == ENC_BLADE)
	{

		beInitStream	= (BEINITSTREAM) GetProcAddress(hBladeDLL, TEXT_BEINITSTREAM);
		beEncodeChunk	= (BEENCODECHUNK) GetProcAddress(hBladeDLL, TEXT_BEENCODECHUNK);
		beDeinitStream	= (BEDEINITSTREAM) GetProcAddress(hBladeDLL, TEXT_BEDEINITSTREAM);
		beCloseStream	= (BECLOSESTREAM) GetProcAddress(hBladeDLL, TEXT_BECLOSESTREAM);
	}
	else
	{
		beInitStream	= (BEINITSTREAM) GetProcAddress(hLameDLL, TEXT_BEINITSTREAM);
		beEncodeChunk	= (BEENCODECHUNK) GetProcAddress(hLameDLL, TEXT_BEENCODECHUNK);
		beDeinitStream	= (BEDEINITSTREAM) GetProcAddress(hLameDLL, TEXT_BEDEINITSTREAM);
		beCloseStream	= (BECLOSESTREAM) GetProcAddress(hLameDLL, TEXT_BECLOSESTREAM);
	}


	if(!beInitStream || !beEncodeChunk || !beDeinitStream || !beCloseStream)
	{
		return -1;
	}

	int hIn = open(lpszWavFile, O_RDONLY | O_BINARY);

	if(hIn == -1)
	{
		return -1;
	}


	char zOutputFilename[MAX_PATH + 1];	
	lstrcpy(zOutputFilename, lpszWavFile);
	int l = lstrlen(zOutputFilename);
	while(l && zOutputFilename[l] != '.')	{

		l--;
	}

	if(!l)	{

		l = lstrlen(zOutputFilename) - 1;
	}

	zOutputFilename[l] = '\0';

	lstrcat(zOutputFilename, ".mp3");

	int hOut = open(zOutputFilename, O_WRONLY | O_BINARY | O_TRUNC | O_CREAT, S_IWRITE);

	if(hOut == -1)	
	{
		return -1;
	}

	BE_CONFIG	beConfig;

	beConfig.dwConfig = BE_CONFIG_MP3;

	beConfig.format.mp3.dwSampleRate	= 44100;
	beConfig.format.mp3.byMode			= BE_MP3_MODE_STEREO;
	beConfig.format.mp3.wBitrate		= 128;
	beConfig.format.mp3.bCopyright		= FALSE;
	beConfig.format.mp3.bCRC			= FALSE;
	beConfig.format.mp3.bOriginal		= FALSE;
	beConfig.format.mp3.bPrivate		= FALSE;

	DWORD		dwSamples, dwMP3Buffer;
	HBE_STREAM	hbeStream;
	BE_ERR		err;

	err = beInitStream(&beConfig, &dwSamples, &dwMP3Buffer, &hbeStream);

	if(err != BE_ERR_SUCCESSFUL)
	{
		return -1;
	}

	PBYTE pMP3Buffer = new BYTE[dwMP3Buffer];

	PSHORT pBuffer = new SHORT[dwSamples];

	if(!pMP3Buffer || !pBuffer)
	{
		return -1;
	}

	DWORD	length = filelength(hIn);
	DWORD	done = 0;
	DWORD	dwWrite;
	DWORD	toread;
	DWORD	towrite;
	
	setbuf(stdout,NULL);

	while(done < length)
	{
		encoding_still = 1;
		if(done + dwSamples * 2 < length)
		{

			toread = dwSamples * 2;
		}
		else
		{

			toread = length - done;
		}

		if(read(hIn, pBuffer, toread) == -1)
		{
			encoding_still = 0;
			return -1;
		}		 

		err = beEncodeChunk(hbeStream, toread/2, pBuffer, pMP3Buffer, &towrite);

		if(err != BE_ERR_SUCCESSFUL)
		{

			beCloseStream(hbeStream);
			encoding_still = 0;
			return -1;
		}
		
		if(write(hOut, pMP3Buffer, towrite) == -1)
		{
			encoding_still = 0;
			return -1;
		}

		done += toread;

		percent_done = 100 * (float)done/(float)length;

		// call the enumerated function to display
		// completion of encoding process
		if ((EnumEncoding((int)percent_done)) == FALSE)
			return -2;	//indicate that encoding was stopped by user
	}
	encoding_still = 0;
	err = beDeinitStream(hbeStream, pMP3Buffer, &dwWrite);

	if(err != BE_ERR_SUCCESSFUL)
	{
		beCloseStream(hbeStream);
		return -1;
	}

	if(dwWrite)
	{

		if(write(hOut, pMP3Buffer, dwWrite) == -1)
		{
			return -1;
		}
	}

	beCloseStream(hbeStream);

	close(hIn);
	close(hOut);

	percent_done = 0;

	return 0;
}