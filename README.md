# Adaptive_neurofeedback
Test verison of adaptive neurofeedback

main executable file "show_interface.m"

Before starting the program, you should connect the EEG to the computer through the LSLsmartBCI program
The program show_interface.m combines various modules.

After its launch, the first window of the program appears, it is possible to specify the sampling frequency on it (so far only the first of three edits works). The drop-down menu is also a stub so far, in the future there should appear the choice of the subject.

The “Save” and “Download” buttons help speed up the testing of the program, avoiding sometimes unnecessary settings. If there is no need to recalculate the CSP filter, then you MUST use the download button.

The “Connect EEG” button launches the second window of the interface (hides the first)
it is at this point that the eeg should already be connected via LSLsmartBCI.

The second window has two displays. The first is to display raw data,
the second to display the processed data. The slider next to the first display is able to perform all the functions required of it alone (you need to look for another way to beautifully draw raw data graphs).

The “Configure CSP Filter” button brings up the setup window.
While it is still possible to write all the data in turn (for a relaxed state, for movement with the right hand, for movement with the left hand). After that, it becomes possible to configure two CSP - filters and after that the settings window can be safely closed. It was planned three edits to indicate the amount of data for each type of recorded activity. And maybe three displays to show how data is being written.

After the filter is configured, the “Start experiment” button can function normally. YES, you should not press it before that! will have to protect her! This button starts the timer (a system object, it has an executable function and it calls it to be executed once in its period). In general, there were three timers earlier (they still exist), but all power was given to one (the functions of other timers are called in it). This was done temporarily and needs to be fixed. (The edit-s on the first window of the interface just do not work for this. They set the time for timers that are not used now.)

So the timer does everything:
 1) draws raw data (filtering them before that in the band 1-40 Hz)
 2) draws processed data (feedback)
 3) takes data from lsl stream
 4) if the user wants, then he can send data to the robot
 5) or build two columns in a separate window (though the windows blink due to the constant change of the current shape)


As mentioned above, the function for the “feedback” timer (this is one of two idle timers) is called in the “receive data” timer.
And it is in it that the functions that transmit the signal to the robot and the drawing columns are called. Data is transmitted to the robot only if a certain threshold value, which is now set by a constant, is exceeded, and this can be changed in the timer_feedback function. THIS IS WORTH EVERY TIME or to figure out how to generally calculate the threshold for a person.

Another important note! The columns have fixed Y axes and if it is possible to determine how to generally calculate the maximum and minimum of these axes, then it is worth doing it. Otherwise, in the function “cb_b_control_bars” you can always change the highs and lows manually.

Another important note! The setup time of the CSP filter is now fixed in the function "control_tune_CSP" and for each experiment it can be changed there. You can add the ability to change (as planned) on the CSP filter settings window.
