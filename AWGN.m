clc;
close all;

%number of bits
bits=10^4;

%possibilities
poss=[-1 1];

%transmitted signal
x=[];

for i=1:bits
    x(i)=poss(randi(length(poss)));
end

%snr in decibels
snr_db=0:1:15;
t_snr_db=0:0.01:15;

%converting the snr from decibels to original
snr=10.^(snr_db/20);
t_snr=10.^(t_snr_db/20);

%since possible valuesof x = +1,-1 so A=1 hence variance=1/snr
var=1./snr; 

P_err=[];

for j=1:length(var)
    %generating noise as normal distribution with variance
    n=sqrt(var(j))*randn(1,bits);
    
    %received bits
    recv=x+n;
    
    %decoding the received bits
    r=[];
    for k=1:bits
        if recv(k)<0
            r(k)=poss(1,1);
        else
            r(k)=poss(1,2);
        end
    end
    
    %finding the error    
    err=0;
    for l=1:bits
        if r(l)~=x(l)
            err=err+1;
        end
    end
    
    %evaluating the probability for different values of snr
    P_err(j)=err/bits;
end

%plotting the observed error probability vs snr in decibels
figure(1);
semilogy(snr_db,P_err,'r','linewidth',1)
hold on

%calculating the error probability using q function and snr
P_id=qfunc(sqrt(t_snr));

%plotting the calculated error probability vs snr in decibels
semilogy(t_snr_db,P_id,'g','linewidth',1.3)
ylabel("P(error)= error/10^4")
xlabel("SNR(db)")
title("Bit Error Rate of BPSK")
grid on
hold off