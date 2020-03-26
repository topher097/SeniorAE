S4 = [0, 100; 0.01, 275; 0.02, 330; 0.029, 370; 0.039, 400; 
    0.058, 450; 0.079, 480; .098, 500; .117, 560; .139, 625;
    .158, 660; .177, 690; .198, 705; .210, 725; .234, 730];
S6 = [0, 0; 0.01, 190; 0.02, 340; 0.03, 440; 0.039, 610; 
    0.058, 910; 0.077, 1125; .098, 1260; .118, 1370; .138, 1440;
    .158, 1475; .177, 1500; 0.197, 1525; .217, 1560; .236, 1600];
S7 = [0.003, 160; 0.009, 940; 0.019, 1300; 0.029, 1480; 0.038, 1590; 
    0.058, 1730; 0.078, 1800; .097, 1850; .117, 1880; .137, 1900;
    .157, 1940; .176, 1940; 0.197, 1950; .216, 1960; .236, 1960];

mat2np(S4, 'S4.pkl', 'float64')
mat2np(S7, 'S7.pkl', 'float64')
mat2np(S6, 'S6.pkl', 'float64')