% Frequency Domain Equalization

modOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder)  % modOrder = 2^bitsPerSymbol

mpChan = [0.8; zeros(7,1); -0.5; zeros(7,1); 0.34];  % multipath channel
SNR = 15   % dB, signal-to-noise ratio of AWGN

% Define the number of subcarriers to be 8192
numCarr = 8192;
numBits = numCarr * bitsPerSymbol; %number of source bits to generate

% Create source bit sequence and modulate
if exist("numBits","var")  % code runs after you complete Task 1
    srcBits = randi([0,1],numBits,1);
    qamModOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
end

% Define cyclic prefix length to be 32 (at least long as the impulse response length)
cycPrefLen = 32;

% Perform OFDM modulation on the signal qamModOut
ofdmModOut = ofdmmod(qamModOut,numCarr,cycPrefLen)

% multipath channel and AWGN
if exist("ofdmModOut","var")  % code runs after you complete Task 3
    mpChanOut = filter(mpChan,1,ofdmModOut);
    chanOut = awgn(mpChanOut,SNR,"measured");
end

% Perform OFDM demodulation on the signal chanOut
ofdmDemodOut = ofdmdemod(chanOut,numCarr,cycPrefLen)
scatterplot(ofdmDemodOut)

% Transform the multipath channel impulse response mpChan to the frequency domain
% Make sure the zero-frequency component of mpChanFreq is in the center of the frequency range.
mpChanFreq = fftshift(fft(mpChan,numCarr))

% Equalize the signal ofdmDemodOut by dividing by mpChanFreq
eqOut = ofdmDemodOut./mpChanFreq
scatterplot(eqOut)

% Demodulation and BER calculation
if exist("eqOut","var")  % code runs after you complete Task 6
    qamDemodOut = qamdemod(eqOut,modOrder,"OutputType","bit","UnitAveragePower",true);
    numBitErrors = nnz(srcBits~=qamDemodOut)
    BER = numBitErrors/numBits
end