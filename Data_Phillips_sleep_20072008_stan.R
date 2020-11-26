# Phillips sleep 2007 2008 stan data

# initial values
y0 = c(-18, 1, 14)

## all time is in hours

# time step 
time_step = 0.05

# time values (not including time 0)
ts = seq(time_step,48, time_step)  

# number of points (not including time 0)
T_n = length(ts)

