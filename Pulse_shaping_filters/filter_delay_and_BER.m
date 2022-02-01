%Filter Delay and BER Calculation
%This code simulates a 16-QAM link with filtering and AWGN

numBits = 20000;
modOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder)  % modOrder = 2^bitsPerSymbol
txFilt = comm.RaisedCosineTransmitFilter;
rxFilt = comm.RaisedCosineReceiveFilter;

srcBits = randi([0,1],numBits,1);
modOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
txFiltOut = txFilt(modOut);

SNR = 7;  % dB
chanOut = awgn(txFiltOut,SNR,"measured");

rxFiltOut = rxFilt(chanOut);
demodOut = qamdemod(rxFiltOut,modOrder,"OutputType","bit","UnitAveragePower",true);

% Calculate the total delay (in symbols)
% by summing the transmit filter delay and receive filter delay.
% For each filter, the delay is half the filter length, in symbols.
delayInSymbols = (txFilt.FilterSpanInSymbols/2)+(rxFilt.FilterSpanInSymbols/2)

% Calculate the delay in bits
delayInBits = delayInSymbols * bitsPerSymbol

% Extract the aligned source bits from srcBits
srcAligned = srcBits(1:(end-delayInBits))

% Extract the aligned received bits from demodOut
demodAligned = demodOut((delayInBits+1):end)

% Count the number of bit errors between srcAligned and demodAligned
numBitErrors = nnz(srcAligned~=demodAligned)

% Calculate the bit error rate
numAlignedBits = length(srcAligned) %The aligned bit stream is shorter than original
BER = numBitErrors/numAlignedBits

% view the power spectrum
specAn = dsp.SpectrumAnalyzer("NumInputPorts",2,"SpectralAverages",50);
specAn(txFiltOut,chanOut)