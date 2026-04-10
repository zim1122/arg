%% 📂 SECTION 1: LINE CODING TECHNIQUES

%% 1.1 Polar Non-Return-to-Zero (NRZ)
clc; clear;

d=[0 1 0 0 1 1 1 0];
bd=1; fs=100;
t=0:1/fs:bd-1/fs;
n=length(d);
tm=0:1/fs:bd*n-1/fs;

s=[];
for i=1:n
    if d(i)==0
        s=[s ones(1,length(t))];
    else
        s=[s -ones(1,length(t))];
    end
end

figure; plot(tm,s,'LineWidth',2);
title('Polar NRZ'); grid on;


%% 1.2 Polar Return-to-Zero (RZ)
clc;

d=[1 1 0 1 0 1 0 0];
bd=1; fs=1000;
n=length(d);
spb=fs*bd; h=spb/2;
tm=0:1/fs:(n*bd)-1/fs;

s=[];
for i=1:n
    if d(i)==1
        w=[ones(1,h) zeros(1,h)];
    else
        w=[-ones(1,h) zeros(1,h)];
    end
    s=[s w];
end

figure; plot(tm,s,'LineWidth',2);
title('Polar RZ'); grid on;


%% 1.3 Unipolar NRZ
clc;

d=[1 0 1 1 0 0 1 0];
bd=1; fs=30;
t=0:1/fs:bd-1/fs;
n=length(d);
tm=0:1/fs:bd*n-1/fs;

s=[];
for i=1:n
    if d(i)==1
        s=[s ones(1,length(t))];
    else
        s=[s zeros(1,length(t))];
    end
end

figure; plot(tm,s,'LineWidth',2);
title('Unipolar NRZ'); grid on;


%% 1.4 Bipolar AMI
clc;

d=[1 0 1 1 0 1 0 0 1];
bd=1; fs=100;
spb=fs*bd;
tm=0:1/fs:(length(d)*bd)-1/fs;

s=[]; p=-1;
for i=1:length(d)
    if d(i)==1
        p=-p;
        w=p*ones(1,spb);
    else
        w=zeros(1,spb);
    end
    s=[s w];
end

figure; plot(tm,s,'LineWidth',2);
title('Bipolar AMI'); grid on;


%% 1.5 2B1Q
clc;

d=[1 0 0 0 1 1 0 1];
fs=100; sd=1;
sps=fs*sd;
ns=length(d)/2;
tm=0:1/fs:(ns*sd)-1/fs;

mp=containers.Map({'00','01','10','11'},[-3 -1 3 1]);
s=[];

for i=1:2:length(d)
    pr=sprintf('%d%d',d(i),d(i+1));
    s=[s mp(pr)*ones(1,sps)];
end

figure; plot(tm,s,'LineWidth',2);
title('2B1Q'); grid on;


%% 1.6 Manchester Encoding
clc;

d=[1 0 1 1 0 0 1 0];
bd=1; fs=500;
spb=fs*bd; h=spb/2;
tm=0:1/fs:(length(d)*bd)-1/fs;

s=[];
for i=1:length(d)
    if d(i)==0
        w=[ones(1,h) -ones(1,h)];
    else
        w=[-ones(1,h) ones(1,h)];
    end
    s=[s w];
end

figure; plot(tm,s,'LineWidth',2);
title('Manchester'); grid on;


%% 📡 SECTION 2: ANALOG & DIGITAL MODULATION

%% 2.1 Amplitude Modulation (AM)
clc;

Fs=10000;
t=0:1/Fs:0.01;
fc=1000; fm=100;
mu=0.5;

m=cos(2*pi*fm*t);
c=cos(2*pi*fc*t);
s=(1+mu*m).*c;

figure;
subplot(3,1,1); plot(t,m); title('Message');
subplot(3,1,2); plot(t,c); title('Carrier');
subplot(3,1,3); plot(t,s); title('AM');


%% 2.2 Frequency Modulation (FM)
clc;

Fs=10000;
t=0:1/Fs:0.01;
fc=1000; fm=100;
kf=2*pi*75;

m=cos(2*pi*fm*t);
im=cumsum(m)/Fs;
s=cos(2*pi*fc*t+kf*im);

figure;
subplot(3,1,1); plot(t,m); title('Message');
subplot(3,1,2); plot(t,cos(2*pi*fc*t)); title('Carrier');
subplot(3,1,3); plot(t,s); title('FM');


%% 2.3 PCM
clc;

f=5; fs=100;
t=0:1/fs:1;
x=sin(2*pi*f*t);

nb=2; L=2^nb;
xmin=min(x); xmax=max(x);
qs=(xmax-xmin)/(L-1);

xi=round((x-xmin)/qs);
xq=xi*qs+xmin;

figure; plot(t,x); hold on;
stairs(t,xq);
title('PCM'); grid on;


%% 2.4 Delta Modulation
clc;

fs=200;
t=0:1/fs:1;
x=sin(2*pi*5*t);
dlt=0.2;

xr=zeros(size(x));
for i=2:length(x)
    if x(i)>xr(i-1)
        xr(i)=xr(i-1)+dlt;
    else
        xr(i)=xr(i-1)-dlt;
    end
end

figure; plot(t,x); hold on;
stairs(t,xr);
title('Delta Modulation'); grid on;


%% 〰️ SECTION 3: WAVEFORM GENERATION & ANALYSIS

%% 3.1 Basic Waves
clc;

t=0:0.01:10;
figure;

subplot(2,2,1); plot(t,sign(sin(2*pi*t))); title('Square');
subplot(2,2,2); plot(t,sawtooth(2*pi*t)); title('Sawtooth');
subplot(2,2,3); plot(t,sawtooth(2*pi*t,0.5)); title('Triangular');
subplot(2,2,4); plot(t,(square(2*pi*5*t)+1)/2); title('Pulse');


%% 3.2 Sinusoidal Signals
clc;

t=0:0.01:4;
y1=sin(2*pi*2*t);
y2=cos(2*pi*2*t);

figure; plot(t,y1); hold on;
plot(t,y2);
title('Sin & Cos');


%% 3.3 Exponential Signal
clc;

t=0:0.05:2;
x=5*exp(-2*t);

figure; plot(t,x);
title('Exponential');


%% 3.4 FFT
clc;

Fs=50;
t=0:1/Fs:1-1/Fs;
x=sin(2*pi*5*t);

N=length(x);
X=fft(x);
f=(0:N-1)*(Fs/N);

figure; plot(f,abs(X)/N);
title('FFT');
