<img src="https://github.com/BIAPT/Events-Finder/blob/master/Media/app_banner.png"/>
<h1>What is Events-Finder?</h1>
<p>Events-Finder is a MATLAB application used to find salient events in dyadic physiological data. This application was developped specifically for the <a href="http://www.moraeslab.com/biapt/research/">Moving in and Tuning in study</a> (MWTI): A participatory mixed methods study to foster social inclusion of individuals with dementia and their carers. Used in conjonction with the <a href="https://theconversation.com/how-we-can-design-the-music-of-our-emotions-91242">Biomusic</a> Android application, this software use blood volume pulse, skin conductance, heart rate and temperature signals to calculate features that are in turn used to detect salient events during a MWTI session. Once the events are found, the application output markers in JSON format which are compatible with <a href="https://github.com/yacineMahdid/VideoMarker">VideoMarker</a>.</p>  
<h1>Features</h1>
<ul>
  <li>Calculate features for BVP,SC,TEMP and HR</li>
  <li>Signal quality taken into consideration when finding events</li>
  <li>Plotting of the raw and filtered signals</li>
</ul>
<h1>Advantages</h1>
<ul>
  <li>Highly customizable</li>
  <li>Simple interface</li>
  <li>Fast processing time</li>
</ul>
<h1>How to use</h1>
<ol>
  <li>Download the full project</li>
  <li>Add the EventsFinder folder to your Matlab path</li>
  <li>Run the .mlapp</li>
  <li>Select the folder containing the physiological signals</li>
  <li>Select a start time (in system time) to sync the markers</li>
  <li>Select the numbers of marker you want to be outputed</li>
  <li>Run the application</li>
</ol>
<p>If you have questions or feedback on this software please direct it to "yacine.mahdid@mail.mcgill.ca"</p>
