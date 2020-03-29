function [actuators,data] = runControlSystem(sensors, references, parameters, data)
    w_e = [3 ; 0 ; 0];
    constant1=(parameters.J2-parameters.J3)/parameters.J1;
    constant2=(parameters.J1-parameters.J3)/parameters.J2;
    constant3=(parameters.J1-parameters.J2)/parameters.J3; 
    K = [2, 1, 1; 1, 1, 1];
    A=[0 constant1*w_e(3) constant1*w_e(2);-constant2*w_e(3) 0 constant2*w_e(1); constant3*w_e(2) constant3*w_e(1) 0];
    B=[1/parameters.J1 0; 0 0; 0 1/parameters.J3]; 
    F = eig(A-B*K); %--- Eig() test to check asymptotic stability
    actuators.tau1 = -K(1,1)*(sensors.w1 - w_e(1)) - K(1,2)*(sensors.w2 - w_e(2)) - K(1,3)*(sensors.w3 - w_e(3));
    actuators.tau3 = -K(2,1)*(sensors.w1 - w_e(1)) - K(2,2)*(sensors.w2 - w_e(2)) - K(2,3)*(sensors.w3 - w_e(3));
end
