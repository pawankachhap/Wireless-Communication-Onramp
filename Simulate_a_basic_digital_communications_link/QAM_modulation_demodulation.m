%{
TASK 1
Create a column vector named srcBits containing 20,000
randomly-generated bits.
%}

srcBits = randi([0,1],20000,1);

% TASK 2
%Create a variable named modOrder and set its value to 16.

modOrder = 16;

% TASK 3
% Create a 16-QAM signal from the bit sequence
% srcBits. Name the modulated signal modOut.

modOut = qammod(srcBits,modOrder,"InputType","bit")
%When the input sequence is made up of bits, set the
%property "InputType" to "bit".

% TASK 4
% Create a scatter plot of modulated signal modOut.

scatterplot(modOut)

% TASK 5
% Create a variable named chanOut and set it equal to
% the modulated 16-QAM signal modOut.

chanOut = modOut

% TASK 6
% Demodulate the recieved signal chanOut. Name the output demodOut.

demodOut = qamdemod(chanOut,modOrder,"OutputType","bit")

% TASK 7
% Check if the source bits srcBits and recieved bits demodOut
% are identical. Name the output check.

check = isequal(srcBits,demodOut)
