% NULL Subcarriers

modOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder)  % modOrder = 2^bitsPerSymbol

mpChan = [0.8; zeros(7,1); -0.5; zeros(7,1); 0.34];  % multipath channel
SNR = 15   % dB, signal-to-noise ratio of AWGN

numCarr = 8192;  % number of subcarriers
cycPrefLen = 32;  % cyclic prefix length

% Define the guard band size as numCarr/16
% Define the left and right guard band indices
numGBCarr = numCarr/16;
gbLeft = 1:numGBCarr;
gbRight = (numCarr-numGBCarr+1):numCarr;

% Define the DC null index
dcIdx = numCarr/2 + 1;

% Create a column vector containing the null subcarrier indices
nullIdx = [gbLeft dcIdx gbRight]';

% Calculate the number of data subcarriers
numDataCarr = numCarr - length(nullIdx)

% Then calculate the number of source bits to generate
numBits = numDataCarr * bitsPerSymbol

% Create source bit sequence and modulate
if exist("numBits","var")  % code runs after you complete Task 3
    srcBits = randi([0,1],numBits,1);
    qamModOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
end

% Perform OFDM modulation on the signal qamModOut
ofdmModOut = ofdmmod(qamModOut,numCarr,cycPrefLen,nullIdx)

% Multipath channel and AWGN
if exist("ofdmModOut","var")  % code runs after you complete Task 4
    mpChanOut = filter(mpChan,1,ofdmModOut);
    chanOut = awgn(mpChanOut,SNR,"measured");
end

% Perform OFDM demodulation on the received signal chanOut
% For the symbol sampling offset, use the cyclic prefix length cycPrefLen
ofdmDemodOut = ofdmdemod(chanOut,numCarr,cycPrefLen,cycPrefLen,nullIdx)

% Transform the multipath channel impulse response mpChan to the frequency domain
% and shift the zero-frequency component to the center of the spectrum.
mpChanFreq = fftshift(fft(mpChan,numCarr))

% Remove the elements of mpChanFreq that correspond to the null subcarrier indices
mpChanFreq(nullIdx) = []

% Equalize the signal ofdmDemodOut
eqOut = ofdmDemodOut./mpChanFreq

% Scatter plot of equalized signal
scatterplot(eqOut)

% Demodulation and BER calculation
if exist("eqOut","var")  % code runs after you complete Task 7
    qamDemodOut = qamdemod(eqOut,modOrder,"OutputType","bit","UnitAveragePower",true);
    numBitErrors = nnz(srcBits~=qamDemodOut)
    BER = numBitErrors/numBits
end

% Power spectrum of ofdm modulator output and channel output
specAn = dsp.SpectrumAnalyzer("NumInputPorts",2,"SpectralAverages",50);
specAn(ofdmModOut,chanOut)