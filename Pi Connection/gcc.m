function time_delay = gcc(sig1, sig2, Fs)

[cross_corr, lags] = xcorr(sig1, sig2, Fs);
[~, val] = max(cross_corr);

%figure
%plot(lags,cross_corr)
time_delay = lags(val)/Fs;

end