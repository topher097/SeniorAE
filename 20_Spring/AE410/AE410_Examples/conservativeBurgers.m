function udot = conservativeBurgers(t,u,D1);
udot = -0.5*(D1 * (u.*u));