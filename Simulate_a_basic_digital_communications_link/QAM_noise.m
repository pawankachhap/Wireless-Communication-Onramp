% 16-QAM link with AWGN

% Simulation parameters
numBits = 20000
modOrder = 16

% creating source bit sequence
srcBits = randi([0,1],modOrder,1)

% Create a 16-QAM signal from the bit sequence.
% Specify the output signal to have unit average power.

modOut = qammod(srcBits,modOrder,"InputType","bit",...
	"UnitAveragePower",true)

% Applying AWGN
SNR = 15 %dB
chanOut = awgn(modOut,SNR)

% create scatterplot
scatterplot(chanOut)

% Demodulating and checking the recieved bit sequence
demodOut = qammod(chanOut,modOrder,"OutputType","bit",...
	   "UnitAveragePower",true)

check = isequal(srcBits,demodOut)