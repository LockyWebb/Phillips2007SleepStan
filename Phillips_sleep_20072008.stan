//
// This Stan program is the basic Phillips sleep model from 
// Phillips 2007 and 2008
// using cmdstan

//vector phillipssleep07(real Q_max, real theta, real sigma, real nu_ma_Q_ao, real nu_vm, real nu_mv, 
//real nu_vc, real nu_vh, real chi, real mu, real tau_m, real tau_v, real c_0, real omega, real alpha)



// 
// function dY = odefun(t, Y, Q_max, theta, sigma, nu_ma_Q_ao, nu_vm, nu_mv, nu_vc, nu_vh, chi, mu, tau_m, tau_v, c_0, omega, alpha)
// %function dY = odefun(t, Y)
// 	
// 	%dY(1) = (nu_vm*(Q_max/(1 + exp(-(Y(2)-theta)/sigma))) + nu_vc*(c_0 + cos(2*pi/24*t + alpha)) + nu_vh*Y(3) - Y(1))/(tau_v/3600);
// 	dY(1) = (nu_vm*Sigm(Y(2),Q_max,theta,sigma) + nu_vc*C_drv(t,c_0, omega,alpha) + nu_vh*Y(3) - Y(1))/(tau_v/3600);
// 	
// 	%dY(2) = (nu_ma_Q_ao + nu_mv*(Q_max/(1 + exp(-(Y(1)-theta)/sigma))) - Y(2))/(tau_m/3600);
// 	dY(2) = (nu_ma_Q_ao + nu_mv*Sigm(Y(1),Q_max,theta,sigma) - Y(2))/(tau_m/3600);
// 
// 	%dY(3) = (mu*(Q_max/(1 + exp(-(Y(2)-theta)/sigma))) - Y(3))/chi;
// 	dY(3) = (mu*Sigm(Y(2),Q_max,theta,sigma) - Y(3))/chi;
// 	
// 	dY = dY(:);
// end

functions {
  vector phillipssleep07(real t, 
                         vector Y, 
                         real Q_max, 
                         real theta, 
                         real sigma, 
                         real nu_ma_Q_ao, 
                         real nu_vm, 
                         real nu_mv,
                         real nu_vc, 
                         real nu_vh, 
                         real chi, 
                         real mu, 
                         real tau_m, 
                         real tau_v, 
                         real c_0, 
                         real omega, 
                         real alpha) {
    vector[3] dydt;
    
    dydt[1] = (nu_vm*Sigm(Y[2],Q_max,theta,sigma) + nu_vc*C_drv(t,c_0, omega,alpha) + nu_vh*Y[3] - Y[1])/(tau_v/3600);
	
    dydt[2] = (nu_ma_Q_ao + nu_mv*Sigm(Y[1],Q_max,theta,sigma) - Y[2])/(tau_m/3600);

  	dydt[3] = (mu*Sigm(Y[2],Q_max,theta,sigma) - Y[3])/chi;
  	
  	return dydt;
    
  }

  real Sigm(real x,
                real Q_max,
                real theta,
                real sigma) {
    Q = (Q_max/(1 + exp(-(x-theta)/sigma)));
    return Q;
  }
  
  real C_drv(real t,
                 real c_0, 
                 real omega,
                 real alpha) {
    C = c_0 + cos(omega*t + alpha);
    return C;
  }
  
}

data {
  int<lower = 1>    T;       // number of points
  real<lower = t0>  ts[T];   // times values
  vector[3]         y0;      // inital value
  //real              Y[T];    // function values
  //real            
}

transformed data{
  real t0 = 0;      // inital time 
  real Q_max = 100;
  real theta = 10; 
  real sigma = 3; 
  real nu_ma_Q_ao = 1.3;
  real nu_vm = -2.1;
  real nu_mv = -1.8;
  real nu_vc = -2.9; 
  real nu_vh = 1.0; 
  real chi = 45; 
  real mu = 4.4; 
  real tau_m = 10; 
  real tau_v = 10; 
  real c_0 = 4.5; 
  real omega = 2*pi/24; 
  real alpha = 0;
}

//parameters {
// 
//}

transformed parameters{
  vector[3] Y[T] = ode_rk45(phillipssleep07, y0, t0, t,
                            Q_max, theta, sigma, nu_ma_Q_ao, nu_vm, 
                            nu_mv, nu_vc, nu_vh, chi, mu,  tau_m, 
                            tau_v, c_0, omega, alpha);
}

//model {
//  
//}
