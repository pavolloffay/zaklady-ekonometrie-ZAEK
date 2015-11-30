library(forecast)
library(FitAR)       # LjungBoxTest
library(fUnitRoots)  # adfTest

# Set working dir
dir = '/tmp/';
dir = '/home/pavol/projects/zaklady-ekonometrie-ZAEK/images/'
setwd(dir);

# Get data
#df = getBuckets();
load('R_df.RData'); # to variable df
heap = as.numeric(df$avg);

# Series plot
plot(heap, type='l', col='red', main='Java Heap Used', xlab='Time', ylab='byte');
dev.copy2pdf(file = 'heap_series.pdf');

# Acf and Pacf
Acf(heap, main='Java Heap Used', lag.max=20);
dev.copy2pdf(file = 'heap_acf.pdf');
Pacf(heap, main='Java Heap Used');
dev.copy2pdf(file = 'heap_pacf.pdf');

# Stationarity tests
adfTest(heap, lags = 0, type='nc');
kpss.test(heap);
kpss.test(heap, null='Trend');

# Diferencing
ndiffs = ndiffs(heap);
diff = diff(heap);
# Acf and Pacf of differenced series
Acf(diff, main='Java Heap Used diff');
dev.copy2pdf(file = 'heap_diff_acf.pdf');
Pacf(diff, main='Java Heap Used diff');
dev.copy2pdf(file = 'heap_diff_pacf.pdf');


# auto.arima()
arima = auto.arima(heap, approximation=FALSE, trace=TRUE, ic='aic', allowdrift=FALSE);
plot(forecast(arima, h=20));
dev.copy2pdf(file = 'heap_forecast.pdf');

# Residuals
standardized_residuals = arima$residuals/sd(arima$residuals);
plot(arima$residuals, main='Residuals', ylab='', xlab='Time');
dev.new();
plot(standardized_residuals, main='Standardized Residuals', ylab='', xlab='Time');

# maybe fitdf = p + q & lag > p + q
Box.test(arima$residuals, type='Ljung-Box', fitdf=1, lag=2)

lBox = LjungBoxTest(arima$residuals, lag.max=10, k=1);
plot(lBox[,1], lBox[,3], ylim=0, main='Ljung-Box Test', ylab='p-value', xlab='lag');
abline(h=0.05, col='blue', lty=2)

# Holt
holt = holt(heap, h=20)
plot(holt)

# SSE/ residuals^2
sum((arima$residuals)^2)
sum((holt$residuals)^2)
# pekny vypis 
#tsdisplay(as.numeric(df$avg), main='Java Heap Used', col='red')
