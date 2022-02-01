% Transmit and Receive Filters 
% This code sets up a 16-QAM link.

% Simulation parameters 
numBits = 20000;
modOrder = 16;

% Create source bit sequence and modulate using 16-QAM.
srcBits = randi([0,1],numBits,1);
modOut = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);

% Create square-root raised cosine transmit and receive filters

txFilt = comm.RaisedCosineTransmitFilter
rxFilt = comm.RaisedCosineReceiveFilter

% Apply the transmit filter
txFiltOut = txFilt(modOut)

% Apply AWGN to the filtered signal
SNR = 7
chanOut = awgn(txFiltOut,SNR,"measured")

% Apply the receive filter
rxFiltOut = rxFilt(chanOut)

% Demodulation back into bits
if exist("rxFiltOut","var")  % code runs after you complete Task 4
    scatterplot(rxFiltOut)
    title("Receive Filter Output")
    demodOut = qamdemod(rxFiltOut,modOrder,"OutputType","bit","UnitAveragePower",true);
end

% Analyze the power spectrum of noiseless and noisy signal
specAn = dsp.SpectrumAnalyzer("NumInputPorts",2,"SpectralAverages",50);
specAn(txFiltOut,chanOut)