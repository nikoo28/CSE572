sensors = {'Orth_x','Orth_y','Orth_z','Orth_w','Acc_x','Acc_y','Acc_z','Gyr_x','Gyr_y','Gyr_z','EMG_1','EMG_2','EMG_3','EMG_4','EMG_5','EMG_6','EMG_7','EMG_8'}; 

fid = fopen('eat_data.csv');
line = fgetl(fid);
d = 1;
n = 1;

while line~=-1
    timeSeries = strsplit(line,',');
    timeSeries = str2double(timeSeries(3:end-1));
    if d == length(sensors)+1
        n=n+1;
        d=1;
    end

    FFT(n,d) = norm(fft(timeSeries));
    DWT(n,d) = norm(dwt(timeSeries,'sym4'));
    STD(n,d) = std(timeSeries);
    MAX(n,d) = max(timeSeries);
    AVG(n,d) = mean(timeSeries);
    MIN(n,d) = min(timeSeries);
    RMS(n,d) = rms(timeSeries);
    MODE(n,d) = mode(timeSeries);
    RANGE(n,d) = MAX(n,d)-MIN(n,d);

    d = d+1;
    line = fgetl(fid);
end

fid = fopen('noneat_data.csv');
line = fgetl(fid);
d = 1;
n = 1;

while line~=-1

    timeSeries = strsplit(line,',');
    timeSeries = str2double(timeSeries(3:end-1));

    if d == length(sensors)+1
        n=n+1;
        d=1;
    end

    nFFT(n,d) = norm(fft(timeSeries));
    nDWT(n,d) = norm(dwt(timeSeries,'sym4'));
    nSTD(n,d) = std(timeSeries);
    nMAX(n,d) = max(timeSeries);
    nAVG(n,d) = mean(timeSeries);
    nMIN(n,d) = min(timeSeries);
    nRMS(n,d) = rms(timeSeries);
    nMODE(n,d) = mode(timeSeries);
    nRANGE(n,d) = nMAX(n,d)-nMIN(n,d);

    d = d+1;
    line = fgetl(fid);
end

[AVG,nAVG]=plotFeatures(AVG,nAVG,'AVG',sensors);
[STD,nSTD]=plotFeatures(STD,nSTD,'STD',sensors);
[MAX,nMAX]=plotFeatures(MAX,nMAX,'MAX',sensors);
[MIN,nMIN]=plotFeatures(MIN,nMIN,'MIN',sensors);
[RMS,nRMS]=plotFeatures(RMS,nRMS,'RMS',sensors);
[MODE,nMODE]=plotFeatures(MODE,nMODE,'MODE',sensors);
[RANGE,nRANGE]=plotFeatures(RANGE,nRANGE,'RANGE',sensors);
[FFT,nFFT]=plotFeatures(FFT,nFFT,'FFT',sensors);
[DWT,nDWT]=plotFeatures(DWT,nDWT,'DWT',sensors);

function [resX,resY] = plotFeatures(X,Y,method,sensors)

    resX = X;
    resY = Y;
    filename = strcat(method,'_',sensors);

    for i=1:length(sensors)

        fig = figure('visible','off');
        hold on
        norm = X(:,i) - min(X(:,i));
        norm = norm/(max(X(:,i))-min(X(:,i)));
        resX(:,i) = norm;
        plot(X(:,i))
        norm = Y(:,i) - min(Y(:,i));
        norm = norm/(max(Y(:,i)-min(Y(:,i))));
        resY(:,i) = norm;
        plot(Y(:,i))
        legend('eating','non-eating')
        saveas(fig,char(filename(i)),'png');
        hold off
        
    end
end