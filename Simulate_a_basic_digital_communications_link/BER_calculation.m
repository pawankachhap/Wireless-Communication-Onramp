% Calculating the Bit Error Rate

% Simulation parameters 
numBits = 20000;
modOrder = 16;
% Create source signal and apply 16-QAM modulation
srcBits = randi([0,1],numBits,1);
modOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);

% Apply AWGN
SNR = 15;  % dB
chanOut = awgn(modOut,SNR);
scatterplot(chanOut)
% Demodulate received signal
demodOut = qamdemod(chanOut,modOrder,"OutputType","bit","UnitAveragePower",true);

% Compare the source bits srcBits and received bits
% demodOut element-by-element to identify bit errors.

isBitError = srcBits~=demodOut

% Count the number of bit errors, and store it in a variable named numBitErrors.
numBitErrors = nnz(isBitError)

% Calculating bit error rate
BER = numBitErrors/numBits