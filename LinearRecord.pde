//record vector cutting file generator 
//by Amanda Ghassaei
//2015
//http://www.instructables.com/id/Laser-Cut-Record/
//detailed instructions for using this code at http://www.instructables.com/id/Laser-Cut-Record/step7

/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
*/

//this script makes a straight path with audio encoded in it instead of spiraling into a record


import processing.pdf.*;

//parameters
String filename = "your_file_name_here.txt";//generate a txt file of your waveform using python wav to txt, and copy the file name here
float samplingRate = 44100;//sampling rate of incoming audio
float dpi = 1200.0;//dpi of cutter
int cutterWidth = 100;//width of laser cutter bed in inches
int cutterHeight = 5;//height of laser cutter bed in inches
float amplitude = 5.0;//in pixels - you might want to change this

float xScale = 1.0;//in pixels - depending on how fast you are reading the record, you will want to change this

void setup(){
  
  float[] songData = processAudioData();
  
  float scaleNum = 72.0;//scale factor of vectors (default 72 dpi)
  amplitude = amplitude/dpi*scaleNum;
  xScale = xScale/dpi*scaleNum;
  
  size(int(cutterWidth*scaleNum),int(cutterHeight*scaleNum));
  
  
  //change extension of file name
  int dotPos = filename.lastIndexOf(".");
  if (dotPos > 0)
    filename = filename.substring(0, dotPos);
  
  
  float x = 0;
  
  beginRecord(PDF, filename + ".pdf");//save as PDF
  background(255);//white background
  noFill();//don't fill loops
  strokeWeight(0.001);//hairline width
  
  beginShape();
  int i;
  for (i=0;i<songData.length;i++){
    x = i*xScale;
    if (x > cutterWidth*scaleNum) break;
    vertex(x,cutterHeight/2*scaleNum + amplitude*songData[i]);
  }
  
  println("sample " + i + " of " + songData.length);
  println(i/float(songData.length)*songData.length/samplingRate + " seconds of " + songData.length/samplingRate + " fit on this pdf");
  
  endShape();
  endRecord();
  
  exit();
  
  //tell me when it's over
  println("Finished.");

}

float[] processAudioData(){
  
  //get data out of txt file
  String rawData[] = loadStrings(filename);
  String rawDataString = rawData[0];
  float audioData[] = float(split(rawDataString,','));//separated by commas
  
  //normalize audio data to given bitdepth
  //first find max val
  float maxval = 0;
  for(int i=0;i<audioData.length;i++){
    if (abs(audioData[i])>maxval){
      maxval = abs(audioData[i]);
    }
  }
  //normalize amplitude to max val
  for(int i=0;i<audioData.length;i++){
    audioData[i]*=amplitude/maxval;
  }
  
  return audioData;
}


