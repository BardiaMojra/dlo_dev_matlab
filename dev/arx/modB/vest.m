clear;clc;close all; 

% install Statistics and Machine Learning Toolbox

% activate vision toolbox by Peter Corke
% addpath(genpath('./'));
addpath('rtb'); 
addpath('smtb'); 
addpath('vision'); 
addpath('Helpers'); 
run('./rtb/startup_rtb.m'); 



% % show points and optical flows -------------------------------------------
% figure(1); 
% quiver(m(1,:), m(2,:), m_dot(1,:), m_dot(2,:),0); 
% quiver(m5(1,:), m5(2,:), m5_dot(1,:), m5_dot(2,:)); 

num_trials = 21; 
noise_max = 2; 
noise_increment = .1; 
noise_list = 0:noise_increment:noise_max; 

w_true = [0.8;1.3;0.5]; 
v_true = [0;0;0.000001]; 
v_true_norm = v_true / (norm(v_true)); 
% v_true_norm = v_true; 

v_error_buffer = zeros(1,num_trials); 
w_error_buffer = zeros(1,num_trials); 
v_error_list = zeros(1,length(noise_list)); 
w_error_list = zeros(1,length(noise_list)); 

for i = 1:(length(noise_list))   
        
    noise = noise_list(i); 
    
    for j = 1:num_trials 
    
        [m, m_dot] = Create_M_and_Mdot(v_true,w_true,noise);    % find m and mdot using simulated points 

        [v_est,w_est] = PoCo(m,m_dot); % call algorithm 
        
%         v_est_norm = v_est; 
        v_est_norm = v_est / norm(v_est); % normalize v answer 
        if(v_est_norm(3)<0) 
            v_est_norm = -v_est_norm; 
        end 
        
%         error_v = sqrt( (v_est_norm(1)-v_true_norm(1))^2 + (v_est_norm(2)-v_true_norm(2))^2 + (v_est_norm(3)-v_true_norm(3))^2 ); 
        error_v =1/pi*acos((v_est_norm'*v_true_norm)); 
        error_w = sqrt( (w_est(1)-w_true(1))^2 + (w_est(2)-w_true(2))^2 + (w_est(3)-w_true(3))^2 ); 
        
        v_error_buffer(1, j) = error_v; 
        w_error_buffer(1, j) = error_w; 
        
    end 
    
    i 
    
    v_err = mean(v_error_buffer); 
    w_err = mean(w_error_buffer); 
    
    v_error_list(1,i) = v_err; 
    w_error_list(1,i) = w_err; 
    
end 

%% plot error data 

figure(1) 
subplot(2,1,1)
plot(noise_list, w_error_list,'linewidth',2); 
xlabel('Noise standard deviation (pixels)'); 
ylabel('error of \omega (rad/s)'); 
set(gca,'fontsize',20)
ylim([0,0.005])
%title('angular estimation error with pixel noise', 'FontSize', 14); 
grid on 

subplot(2,1,2)
plot(noise_list, v_error_list,'linewidth',2); 
xlabel('Noise standard deviation (pixels)'); 
ylabel('error in v'); 
set(gca,'fontsize',20)
ylim([0,0.5])
% title('linear estimation error with pixel noise', 'FontSize', 14); 
grid on 










    
