% Single Carrier Link with Multipath Channel
% This code sets up a 16-QAM link with filtering

numBits = 20000;
modOrder = 16;  % for 16-QAM
bitsPerSymbol = log2(modOrder);  % modOrder = 2^bitsPerSymbol
txFilt = comm.RaisedCosineTransmitFilter;
rxFilt = comm.RaisedCosineReceiveFilter;

srcBits = randi([0,1],numBits,1);
modOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
txFiltOut = txFilt(modOut);

% Multipath Channel impulse response vector
% Create a column vector named mpChan with 17 elements.
%The 1st, 9th, and 17th element values should be 0.8, -0.5, and 0.34
mpChan = [0.8 0 0 0 0 0 0 0 -0.5 0 0 0 0 0 0 0 0.34].'

% Create a stem plot of the multipath channel's impulse response
stem(mpChan)

% Apply the multipath channel mpChan to the transmitted signal txFiltOut
mpChanOut = filter(mpChan,1,txFiltOut)

% Demodulation
if exist("mpChanOut","var")  % code runs after you complete Task 3
    
    SNR = 15;  % dB
    chanOut = awgn(mpChanOut,SNR,"measured");
    
    rxFiltOut = rxFilt(chanOut);
    scatterplot(rxFiltOut)
    title("Receive Filter Output")
    demodOut = qamdemod(rxFiltOut,modOrder,"OutputType","bit","UnitAveragePower",true);
    
    % Calculate the BER
    delayInSymbols = txFilt.FilterSpanInSymbols/2 + rxFilt.FilterSpanInSymbols/2;
    delayInBits = delayInSymbols * bitsPerSymbol;
    srcAligned = srcBits(1:(end-delayInBits));
    demodAligned = demodOut((delayInBits+1):end);

    numBitErrors = nnz(srcAligned~=demodAligned)
    BER = numBitErrors/length(srcAligned)
end

% Power spectrum
specAn = dsp.SpectrumAnalyzer("NumInputPorts",2,"SpectralAverages",50);
specAn(txFiltOut,chanOut)