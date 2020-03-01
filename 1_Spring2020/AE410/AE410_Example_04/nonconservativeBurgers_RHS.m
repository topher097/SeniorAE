function udot = advODE(t,u,D1);
udot = -u .* (D1 * u);