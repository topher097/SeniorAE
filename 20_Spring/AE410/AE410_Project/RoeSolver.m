function [ Fip ] = RoeSolver ( ql , qr , gamma )
    % RoeSolver calculates fluxes at boundaries using Roe ’s method
    % INPUT: 
    %   ql: left side states
    %   qr: right side states
    %   gamma: gamma for fluid
    % OUTPUT:
    %   Fip: numerical flux of cell 

    % calculate primitive variables
    ul = ql (2)/ ql (1);
    ur = qr (2)/ qr (1);
    rhol = ql (1);
    rhor = qr (1);
    pl = (gamma -1)*( ql (3) -0.5* rhol *ul ^2 );
    pr = (gamma -1)*( qr (3) -0.5* rhor *ur ^2 );

    % compute speed of sound
    al = sqrt ( gamma * pl / rhol );
    ar = sqrt ( gamma * pr / rhor );
    % compute total specific enthalpy
    Hl = al ^2 / ( gamma - 1.0) + 0.5 * ul ^2;
    Hr = ar ^2 / ( gamma - 1.0) + 0.5 * ur ^2;

    % compute Roe averages

    rt = sqrt ( rhor / rhol );
    rm = sqrt ( rhol * rhor );
    um = (ul + rt * ur) / (1.0 + rt );
    Hm = (Hl + rt * Hr) / (1.0 + rt );
    am = sqrt (( gamma - 1.0) * (Hm - 0.5 * um ^2));

    % compute primitive variable differences
    dr = rhor - rhol ;
    du = ur - ul;
    dp = pr - pl;

    % compute wave strength
    alpha = [ (dp - am * rm * du) / (2.0 * am ^2);...
    dr - dp / am ^2;...
    (dp + am * rm * du) / (2.0 * am ^2)];

    % compute eigenvalues
    wm = [um - am; um; um + am ];

    % compute eigenvectors
    v1 = [1.0 , 1.0 , 1.0];
    v2 = [um - am , um , um + am ];
    v3 = [Hm - um * am , 0.5 * um ^2 , Hm + um * am ];
    V = [v1;v2;v3 ];
    
    % compute fluxes
    fl = [ql (2); ql (2)* ul+pl; ul *( ql (3)+ pl )];
    fr = [qr (2); qr (2)* ur+pr; ur *( qr (3)+ pr )];

    Fip = 0.5 * (fr + fl) - 0.5 * V*( abs (wm ).* alpha );
end