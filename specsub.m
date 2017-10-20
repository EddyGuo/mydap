function dx=specsub(x,fs)

if nargin < 2
    fprintf('Usage: specsub noisyfile.wav outFile.wav \n\n');
    return;
end
len = floor(20*fs/1000);            % Frame size in samples
if rem(len,2) == 1, len=len+1; end;
PERC = 50;                          % window overlap in percent of frame size
len1 = floor(len*PERC/100);
len2 = len-len1;
Thres = 3;      % VAD threshold in dB SNRseg
Expnt = 2.0;    % power exponent
beta = 0.002;
G = 0.9;
win = hamming(len);
winGain = len2/sum(win); % normalization gain for overlap+add with 50% overlap
% Noise magnitude calculations - assuming that the first 5 frames is noise/silence
nFFT = 2*2^nextpow2(len);
noise_mean = zeros(nFFT,1);
j=1;
for k = 1:5 
    noise_mean = noise_mean+abs(fft(win.*x(j:j+len-1),nFFT));
    j = j+len;
end
noise_mu = noise_mean/5;

%--- allocate memory and initialize various variables
k = 1;
img = sqrt(-1);
x_old = zeros(len1,1);
Nframes = floor(length(x)/len2)-1;
xfinal = zeros(Nframes*len2,1);

%=========================    Start Processing   ===============================
for n = 1:Nframes
    insign = win.*x(k:k+len-1);      % Windowing
    spec = fft(insign,nFFT);         % compute fourier transform of a frame
    sig = abs(spec);                 % compute the magnitude
    %save the noisy phase information
    theta = angle(spec);
    SNRseg = 10*log10(norm(sig,2)^2/norm(noise_mu,2)^2);
    if Expnt == 1.0     % 幅度谱  
        alpha = berouti1(SNRseg);   
    else    
        alpha = berouti(SNRseg); % 功率谱     
    end
    
    %&&&&&&&&&
    sub_speech = sig.^Expnt - alpha*noise_mu.^Expnt;
    diffw = sub_speech - beta*noise_mu.^Expnt;     % 当纯净信号小于噪声信号的功率时
    % beta negative components
    z = find(diffw <0);
    if~isempty(z)  
        sub_speech(z) = beta*noise_mu(z).^Expnt;   % 用估计出来的噪声信号表示下限值  
    end
    
    % --- implement a simple VAD detector --------------
    
    if (SNRseg < Thres)   % Update noise spectrum  
        noise_temp = G*noise_mu.^Expnt+(1-G)*sig.^Expnt;    % 平滑处理噪声功率谱
        noise_mu = noise_temp.^(1/Expnt);                   % 新的噪声幅度谱
    end
    
    % flipud函数实现矩阵的上下翻转，是以矩阵的“水平中线”为对称轴
    %交换上下对称元素
    sub_speech(nFFT/2+2:nFFT) = flipud(sub_speech(2:nFFT/2));
    x_phase = (sub_speech.^(1/Expnt)).*(cos(theta)+img*(sin(theta)));
    % take the IFFT
    xi = real(ifft(x_phase));
    % --- Overlap and add ---------------
    xfinal(k:k+len2-1)=x_old+xi(1:len1);
    x_old = xi(1+len1:len);
    k = k+len2;
end
dx=winGain*xfinal;

function a = berouti1(SNR)
if SNR >= -5.0 && SNR <= 20
    a = 3-SNR*2/20;
else
    if SNR < -5.0
        a = 4;  
    end
    if SNR > 20
        a = 1; 
    end
end

function a = berouti(SNR)
if SNR >= -5.0 && SNR <= 20  
    a = 4-SNR*3/20; 
else 
    if SNR < -5.0    
        a = 5;   
    end
    if SNR > 20 
        a = 1;  
    end
end