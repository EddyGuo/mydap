function audio_analyze(wavetype,handles)
sample_length=length(handles.Sample);
t=(0:sample_length-1)/handles.Fs;
nfft=pow2(nextpow2(sample_length));%fft长度，蝶形算法取2的幂次方提高速度
switch wavetype
    case 1
        %时域波形
        plot(handles.axes1,t,handles.Sample,'g');
        xlabel(handles.axes1,'时间(s)');
    case 2
        %幅频曲线
        fft_sample=fft(handles.Sample,nfft);
        y=abs(fft_sample/nfft);%矫正fft幅值
        %由于fft得到共轭对称的两部分分量，幅值为时域的一半（除了0处直流分量）
        y0=fftshift(y);%循环移位，取中间为0
        %The fftshift function rearranges the output from fft with a circular shift to produce a 0-centered periodogram.
        f0=(-nfft/2:nfft/2-1)*(handles.Fs/nfft);
        plot(handles.axes1,f0,y0,'r');
        xlabel(handles.axes1,'频率(Hz)');
    case 3
        %幅频曲线(DB)
        fft_sample=fft(handles.Sample,nfft);
        y=abs(fft_sample/nfft);
        y1=20*log10(y);
        y2=y1(1:nfft/2+1);%取频谱一半
        y2(2:end-1)=2*y2(2:end-1);%直流分量保持不变,其他乘2
        f=handles.Fs*(0:(nfft/2))/nfft;
        plot(handles.axes1,f,y2,'y');
        xlabel(handles.axes1,'频率(Hz)');
    case 4
        %相频曲线
        fft_sample=fft(handles.Sample,nfft);
        f0=(-nfft/2:nfft/2-1)*(handles.Fs/nfft);
        ph_y0=fftshift(fft_sample);
        phase=unwrap(angle(ph_y0));%矫正跳变范围为[-pi,pi]
        plot(handles.axes1,f0,phase,'b');
        xlabel(handles.axes1,'频率(Hz)');
    case 5
        %瀑布频谱图
        axes(handles.axes1);
        hammingwin=2^floor(log2(sample_length))/8;
        spectrogram(handles.Sample,hammingwin,hammingwin/2,sample_length,handles.Fs);
        set(colorbar,'Color','[0.5,0.5,0.5]');
    case 6
        %音压曲线
        audio_db=20*log10(abs(handles.Sample));%求音压
        plot(handles.axes1,t,audio_db,'c');
        xlabel(handles.axes1,'时间(s)');
        ylabel(handles.axes1,'音压(DB)');
end
set(handles.axes1,'Color','k','XColor','[0.5,0.5,0.5]','YColor','[0.5,0.5,0.5]','ZColor','[0.5,0.5,0.5]');
grid on;
    