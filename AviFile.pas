{
 AVISubDetector by Pavel Batuev (Shalcker) - hard-burned subtitle extraction tool
 Copyright (C) 2003-2005 Pavel Batuev

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit AVIFile;

interface

uses
  SysUtils, VFW, Ole2,
  Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, FileCtrl, CheckLst, Math;

var
  pavi:PAVIFile;
  pavis:PAVIStream;
  ob:PGetFrame;
  pbmi:PBitmapInfoHeader;
  FrameRate, FrameScale, MovieLength: integer;
  FrameWidth, FrameHeight {, FrameIndex}: integer;
  ImageSaved: TBitmap;
  ImagePreprocessed: TBitmap;
  han: integer;
  bmi: TBitmapInfoHeader;
  LastFrameRequested: integer;
procedure OpenAvi(FFilename : string);
procedure GetFrame(FrameNum: integer); overload;
procedure GetFrame(FrameNum: integer; Bmp:TBitmap); overload;
procedure FrameToBitmap(Bitmap:TBitmap;pbmi:PBitmapInfoHeader);
procedure CloseAVI;

implementation

//uses ActivePreview;


procedure OpenAvi(FFilename : string);
var
 principio,fin:integer;
   info  : PAVISTREAMINFOA;
   AviOpen : int64;
   s: string;
begin
  AviOpen := AVIFIleOpen(pavi,Pchar(FFilename),OF_READ,nil);
  if 0<>AviOpen then
  begin
    s:='Error Opening AVI : ';
    if AviOpen=AVIERR_UNSUPPORTED then s:=s+'UNSUPPORTED';
    if AviOpen=AVIERR_BADFORMAT   then s:=s+'BADFORMAT';
    if AviOpen=AVIERR_MEMORY      then s:=s+'MEMORY';
    if AviOpen=AVIERR_INTERNAL    then s:=s+'INTERNAL';
    if AviOpen= AVIERR_BADFLAGS   then s:=s+'BADFLAGS';
    if AviOpen=AVIERR_BADPARAM    then s:=s+'BADPARM';
    if AviOpen=AVIERR_BADSIZE     then s:=s+'BADSIZE';
    if AviOpen=AVIERR_BADHANDLE   then s:=s+'BADHANDLE';
    if AviOpen=AVIERR_FILEREAD    then s:=s+'FILEREAD';
    if AviOpen=AVIERR_FILEWRITE   then s:=s+'FILEWRITE';
    if AviOpen=AVIERR_FILEOPEN    then s:=s+'FILEOPEN';
    if AviOpen=AVIERR_COMPRESSOR  then s:=s+'COMPRESSOR';
    if AviOpen=AVIERR_NOCOMPRESSOR then s:=s+'NOCOMPRESSOR';
    if AviOpen=AVIERR_READONLY    then s:=s+'READONLY';
    if AviOpen=AVIERR_NODATA      then s:=s+'NODATA';
    if AviOpen=AVIERR_BUFFERTOOSMALL then s:=s+'BUFFERTOOSMALL';
    if AviOpen=AVIERR_CANTCOMPRESS then s:=s+'CANTCOMPRESS';
    if AviOpen=AVIERR_USERABORT    then s:=s+'USERABORT';
    if AviOpen=AVIERR_ERROR        then s:=s+'ERROR';
    if AviOpen=REGDB_E_CLASSNOTREG	then  s:=s+'Class Not Registered';
   //else ShowMessage('Unknown Error');
    Raise Exception.Create(s{'Cannot open AVI'});
 end;

 if AVIERR_NODATA=AVIFILEGetStream(pavi,pavis,streamtypeVIDEO,0) then
  Raise Exception.Create('Error - no video stream');

 //starting frame opens
 principio:=AVIStreamStart(pavis);
 fin:=AVIStreamEnd(pavis);

// bmi.biBitCount:=24;
// ob:=AVIStreamGetFrameOpen(pavis,nil);
 bmi.biBitCount:=24;
 bmi.biPlanes:=1;
 bmi.biSize:=40;
 bmi.biCompression:=BI_RGB;
 bmi.biClrUsed:=0;
 bmi.biClrImportant:=0;
 bmi.biWidth:=640;
 bmi.biHeight:=480;
 ob:=AVIStreamGetFrameOpen(pavis,@bmi);
 if (ob=nil) then ob:=AVIStreamGetFrameOpen(pavis,nil); //try default is RGB24 fails
 if (ob=nil) then Raise Exception.Create('Error in FrameOpen - conversion to RGB24 not available.'#13#10'Check that you have required codec installed.');
 
 if nil=ob then
  Raise Exception.Create('Error in Frameopen');
 try
           new(info);
           AviStreamInfo(pavis,info,sizeof(TAVISTREAMINFOA));
           FrameRate:=info.dwRate;
           FrameScale:=info.dwScale;
           MovieLength:=info.dwLength;
           FrameWidth:=info.rcFrame.Right-info.rcFrame.Left;
           FrameHeight:=info.rcFrame.Bottom-info.rcFrame.Top;
           dispose(info);
except
  CloseAVI;
//  AVIStreamRelease(pavis);
 end;

  LastFrameRequested:=-1;
  if 0<>AVIStreamBeginStreaming(pavis,principio,fin,1000) then
   Raise Exception.Create('Error in AVIBegin');

end;

procedure FrameToBitmap(Bitmap:TBitmap;pbmi:PBitmapInfoHeader);
var Dest: TCanvas;
begin
 Dest:=Bitmap.Canvas;
 Bitmap.Height:=pbmi^.biHeight;
 Bitmap.Width:=pbmi^.biWidth;
 Bitmap.PixelFormat:=pf24bit;

 DrawDIBBegin(han,Dest.handle,0,0,pbmi,-1,-1,0);
 DrawDIBDraw(han,Dest.handle,0,0,pbmi^.biWidth,pbmi^.biHeight,pbmi,
             Pointer(Integer(pbmi)+pbmi^.biSize),0, 0,pbmi^.biwidth,pbmi^.biheight,0);
 Bitmap.PixelFormat:=pf24bit;
             
end;

procedure GetFrame(FrameNum: integer);
begin
  if LastFrameRequested=Framenum then exit;
  if pavis=nil then exit;
  if (FrameNum>=MovieLength) then exit;
  pbmi:=AVIStreamGetFrame(ob,FrameNum);
  if pbmi=nil then exit;
//  FrameWidth:=pbmi^.biWidth;
//  FrameHeight:=pbmi^.biHeight;

  ImageSaved.Width:=FrameWidth;
  ImageSaved.Height:=FrameHeight;

  FrameToBitmap(ImageSaved, pbmi);

  //  FrameIndex:=FrameNum;
  LastFrameRequested:=FrameNum;
end;

procedure GetFrame(FrameNum: integer; Bmp:TBitmap); overload;
begin
  Bmp.Width:=FrameWidth;
  Bmp.Height:=FrameHeight;
  if LastFrameRequested=Framenum then begin Bmp.Canvas.Draw(0,0,ImageSaved); exit; end;

  if pavis=nil then exit;
  if (FrameNum>=MovieLength) then exit;
  pbmi:=AVIStreamGetFrame(ob,FrameNum);

  if pbmi=nil then exit;

//  FrameWidth:=pbmi^.biWidth;
//  FrameHeight:=pbmi^.biHeight;

  Bmp.Width:=FrameWidth;
  Bmp.Height:=FrameHeight;

  FrameToBitmap(ImageSaved, pbmi);
  FrameToBitmap(Bmp, pbmi);

//  FrameIndex:=FrameNum;
  LastFrameRequested:=FrameNum;
end;

procedure CloseAVI;
begin
 if (ob<>nil) then AVIStreamGetFrameClose(ob);
 if (pavis<>nil) then AVIStreamRelease(pavis);
 if (pavi<>nil) then AVIFileRelease(pavi);
 ob:=nil; pavis:=nil; pavi:=nil;

end;

initialization
begin
  LastFrameRequested:=-1;
  ImageSaved:=TBitmap.Create;
  ImageSaved.Height:=80;
  ImageSaved.Width:=640;
  ImageSaved.PixelFormat:=pf24bit;
  FrameHeight:=ImageSaved.Height;
  FrameWidth:=ImageSaved.Width;
  ImagePreProcessed:=TBitmap.Create;
  ImagePreProcessed.PixelFormat:=pf24bit;
  han:=DrawDIBOpen;
  ob:=nil; pavis:=nil; pavi:=nil;
  CoInitialize(nil);
end;


finalization
begin
  ImageSaved.Free;
  ImagePreProcessed.Free;
  DrawDIBEnd(han);
  DrawDIBClose(han);
  if (pavi<>nil) then CloseAVI;
  CoUnInitialize();
end;



end.
