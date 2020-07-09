%% gps_tracking_onlydll_hwcosim_test
% gps_tracking_onlydll_hwcosim_test is an automatically generated example MCode
% function that can be used to open a hardware co-simulation (hwcosim) target,
% load the bitstream, write data to the hwcosim target's input blocks, fetch
% the returned data, and verify that the test passed. The returned value of
% the test is the amount of time required to run the test in seconds.
% Fail / Pass is indicated as an error or displayed in the command window.

%%
% PLEASE NOTE that this file is automatically generated and gets re-created
% every time the Hardware Co-Simulation flow is run. If you modify any part
% of this script, please make sure you save it under a new name or in a
% different location.

%%
% The following sections exist in the example test function:
% Initialize Bursts
% Initialize Input Data & Golden Vectors
% Open and Simulate Target
% Release Target on Error
% Test Pass / Fail
clc;close all;clear all;
eta = 0;

%%
% ncycles is the number of cycles to simulate for and should be adjusted if
% the generated testbench simulation vectors are substituted by user data.
ncycles = 50*1.636800e+05;

%%
% Initialize Input Data & Golden Vectors
% xlHwcosimTestbench is a utility function that reformats fixed-point HDL Netlist
% testbench data vectors into a double-precision floating-point MATLAB binary
% data array.
xlHwcosimTestbench('.','gps_tracking_onlydll');

%%
% The testbench data vectors are both stimulus data for each input port, as
% well as expected (golden) data for each output port, recorded during the
% Simulink simulation portion of the Hardware Co-Simulation flow.
% Data gets loaded from the data file ('<name>_<port>_hwcosim_test.dat')
% into the corresponding 'testdata_<port>' workspace variables using
% 'getfield(load('<name>_<port>_hwcosim_test.dat' ... ' commands.
% 
% Alternatively, the workspace variables holding the stimulus and / or golden
% data can be assigned other data (including dynamically generated data) to
% test the design with. If using alternative data assignment, please make
% sure to adjust the "ncycles" variable to the proper number of cycles, as
% well as to disable the "Test Pass / Fail" section if unused.
testdata_if_in = getfield(load('gps_tracking_onlydll_if_in_hwcosim_test.dat', '-mat'), 'values');
fid = fopen('E:\sysgen_workspace\myGNSSdata_BB.bin');
fseek(fid, 16364, 0);
testdata_if_in = fread(fid, ncycles, 'int8')'+(rand(1,ncycles)-0.5)*3;

%% 
% The 'result_<port>' workspace variables are arrays to receive the actual results
% of a Hardware Co-Simulation read from the FPGA. They will be compared to the
% expected (golden) data at the end of the Co-Simulation.
len_dllfilteredout = ncycles;
len_dllrawdiscriminatorout = ncycles;
len_i_e_out = ncycles;
len_i_l_out = ncycles;
len_i_p_out = ncycles;

%%
% gps_tracking_onlydll.hwc is the data structure containing the Hardware Co-Simulation
% design information returned after netlisting the Simulink / System 
% Generator model.
% Hwcosim(project) instantiates and returns a handle to the API shared library object.
project = 'gps_tracking_onlydll.hwc';
h = Hwcosim(project);
try 
    %% Open the Hardware Co-Simulation target and co-simulate the design
    open(h); 
    cosim_t_start = tic;
    h('if_in') = testdata_if_in;
    run(h, ncycles);
    result_dllfilteredout = h('dllfilteredout',len_dllfilteredout);
    result_dllrawdiscriminatorout = h('dllrawdiscriminatorout',len_dllrawdiscriminatorout);
    result_i_e_out = h('i_e_out',len_i_e_out);
    result_i_l_out = h('i_l_out',len_i_l_out);
    result_i_p_out = h('i_p_out',len_i_p_out);
    eta = toc(cosim_t_start);
    % Release the handle for the Hardware Co-Simulation target
    release(h);

%% Release Target on Error
catch err
    release(h); 
    rethrow(err); 
    error('Error running hardware co-simulation testbench. Please refer to hwcosim.log for details.'); 
end 

%% Test Pass / Fail
disp(['Hardware Co-Simulation successful. Data matches the Simulink simulation and completed in ' num2str(eta) ' seconds.']) ;

figure(209)
plot(testdata_if_in)
figure(300)
plot(result_dllfilteredout)
figure(301)
plot(result_dllrawdiscriminatorout)
figure(302)
hold on
plot(result_i_e_out*256)
plot(result_i_l_out*256)
plot(result_i_p_out*256)
hold off
