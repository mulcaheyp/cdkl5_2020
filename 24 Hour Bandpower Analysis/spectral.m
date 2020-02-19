function [bands]= spectral(data, fs)
%normPxx= power spectrum normalized to AUC for power spectrum for whole record
%f=frequencies of power spectrum in Hz
%bands= array to hold AUC of each of the frequency bands (delta, theta, alpha, beta, gamma, 50-100hz) from the normalized power spectrum

[pxx, f]=periodogram(data, [], [], fs);
normPxx=pxx/trapz(pxx);

i=1;
bands=0;
while(i <(length(f)+1))
 if f(i)>=0.1 && f(i)<=4 %% find delta vector 0.1-4 Hz   
    delta(i, 1)= normPxx(i);
    delta(i, 2)= f(i);
 end
 if f(i)>4 && f(i)<=8 %% find theta vector 4-8 Hz    
    theta(i, 1)= normPxx(i);
    theta(i, 2)= f(i);
 end
 
  if f(i)>8 && f(i)<=13 %% find alpha vector 8-13Hz 
    alpha(i, 1)= normPxx(i);
    alpha(i, 2)= f(i);
  end
 
   if f(i)>13 && f(i)<=25 %% find beta vector 13.1-25Hz  
    beta(i, 1)= normPxx(i);
    beta(i, 2)= f(i);
   end
   
 if f(i)>25 && f(i)<=50 %% find gamma vector 25-50Hz    
    gamma(i, 1)= normPxx(i);
    gamma(i, 2)= f(i);
 end
 i=i+1;
end
bands(1,1)=trapz(delta(:,1));
% bands(1,2)=max(delta(:,1));
bands(2,1)=trapz(theta(:,1));
% bands(2,2)=max(theta(:,1));
bands(3,1)=trapz(alpha(:,1));
% bands(3,2)=max(alpha(:,1));
bands(4,1)=trapz(beta(:,1));
% bands(4,2)=max(beta(:,1));
bands(5,1)=trapz(gamma(:,1));
% bands(5,2)=max(gamma(:,1));
end