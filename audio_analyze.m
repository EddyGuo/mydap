function audio_analyze(sample,fs,ax,handles)
% --- plot wave
wavetype=get(handles.wave_select_listbox,'value');
if ~isempty(sample)
    sample_length=length(sample);
    t=(0:sample_length-1)/fs;
    nfft=pow2(nextpow2(sample_length));% fft点数，基2fft取2的幂次方提高速度
    switch wavetype
        case 1
            % --- 时域波形
            plot(ax,t,sample);
            xlabel(ax,'时间(s)');
        case 2
            % --- 频率响应曲线
            fft_sample=fft(sample,nfft);
            y=abs(fft_sample)/nfft;
            % 由于fft得到共轭对称的两部分分量，幅值为时域的一半（除了0处直流分量）
            y0=fftshift(y);% 循环移位，取中间为0
            f0=(-nfft/2:nfft/2-1)*(fs/nfft);
            plot(ax,f0,y0);
            xlabel(ax,'频率(Hz)');
            ylabel(ax,'幅值');
        case 4
            % --- 能量谱
            fft_sample=fft(sample,nfft);
            y=abs(fft_sample).^2/nfft;% Parseval定理求能量
            y1=10*log10(y);
            y2=y1(1:nfft/2+1);% 取频谱一半
            y2(2:end-1)=2*y2(2:end-1);% 直流分量保持不变,其他乘2
            f=fs*(0:(nfft/2))/nfft;
            plot(ax,f,y2);
            xlabel(ax,'频率(Hz)');
            ylabel(ax,'谱密度(DB/Hz)');
        case 3
            % --- 相频曲线
            fft_sample=fft(sample,nfft);
            f0=(-nfft/2:nfft/2-1)*(fs/nfft);
            ph_y0=fftshift(fft_sample);
            phase=unwrap(angle(ph_y0));% 矫正相角跳变范围在pi以内
            plot(ax,f0,phase);
            xlabel(ax,'频率(Hz)');
        case 5
            % --- 瀑布频谱图
            axes(ax);
            spectrogram(sample,1024,512,nfft,fs);
            %hammingwin=2^floor(log2(sample_length))/8;
            %spectrogram(sample,hammingwin,hammingwin/2,nfft,fs);
            colorbar(ax);
            %colormap(hot);
            %colorbar(handles.axes2,'off');
        case 6
            % --- 音压曲线
            audio_db=20*log10(abs(sample));% 求音压
            plot(ax,t,audio_db);
            xlabel(ax,'时间(s)');
            ylabel(ax,'音压(DB)');
    end
end
    