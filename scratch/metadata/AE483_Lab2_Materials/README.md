#Lab 2 Data and Code

The files included were used to design and implement the controller. The data contained were from the pitch test stand and were analyzed and plotted against simulation data obtained from MATLAB.

1. Kf_data.csv 
	> Kf_data.csv was recieved from the lab TA. The data in this file was used to determine the Kf value for the controller.
	
2. Km_data.csv
	> Km_data.csv was recieved from the lab TA. The data in this file was used to determine the Km value for the controller.
	
3. period_0_5.csv
	> Data obtained from the pitch test stand at a period of what was believed to be 1/2 second.
	
4. period_1.csv
	> Data obtained from the pitch test stand at a period of 1 second.
	
5. period_2.csv
	> Data obtained from the pitch test stand at a period of 2 seconds.
	
6. period_3.csv
	> Data obtained from the pitch test stand at a period of 3 seconds.
	
7. period_5.csv
	> Data obtained from the pitch test stand at a period of 5 seconds.
	
8. Simulation_2.xls
	> Data obtained from the MATLAB simulation at a period of 2 seconds. This only contains pitch_desired, ang_pitch, angvel_pitch, and u2. 
	
9. Simulation_3.xls
	> Data obtained from the MATLAB simulation at a period of 3 seconds. This only contains pitch_desired, ang_pitch, angvel_pitch, and u2.
	
10. AE483_lab2.py
	> Python script used to read in Km_data and Kf_data and then figure out the Kf and Km values from the data.
	
11. alphabeta.m
	> MATLAB script used to determine the alpha and beta values from Km_data and Kf_data.
	
12. ae483_01_findeoms.m
	> MATLAB script used to find the equations of motion.
	
13. ae483_02_docontroldesign.m
	> MATLAB script used to do control design.
	
14. ae483_03_simulate.m
	> MATLAB script used to simulate controller.
	
15. ae483_04_experiment.m

16. ae483_test.m
	> MATLAB script used to get a bode plot for frequency response.
	
17. lab1_visualize.m
	> MATLAB script used to get a visual simulation of controller designed.
	
18. Simulation_0.5.xls
	> Data obtained from the MATLAB simulation at a period of what was thought to 1/2 second. This only contains pitch_desired, ang_pitch, angvel_pitch, and u2.
	
19. Simulation_1.xls
	> Data obtained from the MATLAB simulation at a period of 1 second. This only contains pitch_desired, ang_pitch, angvel_pitch, and u2.
	
20. Simulation_5.xls
	> Data obtained from the MATLAB simulation at a period of 5 seconds. This only contains pitch_desired, ang_pitch, angvel_pitch, and u2.
	
21. Motor spin rate data.xlsx

22. AE483_lab2_data_plot.py
	> Python script used to read in pitch stand test data and plot it vs. the simulation data.
	
23. AE483_lab2_kf_km.py
	> Python script used to plot kf and km from Kf_data dn Km_data to figure out kf and km values.

24. pitch_test_video.mp4
	> Video of a test on the pitch test stand
	