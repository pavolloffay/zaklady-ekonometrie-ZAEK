library(forecast)
library(FitAR) #  LjungBoxTest

# 
#df = getBuckets();

df = load('R_df');

arima = auto.arima(as.numeric(df$avg), approximation=FALSE, trace=TRUE, ic='aic', allowdrift=FALSE)
plot(forecast(arima, h=20))

# Rezidua
standardized_residuals = arima$residuals/sd(arima$residuals);
plot(arima$residuals, main='Residuals', ylab='', xlab='Time');
dev.new();
plot(standardized_residuals, main='Standardized Residuals', ylab='', xlab='Time');

# maybe fitdf = p + q & lag > p + q
Box.test(arima$residuals, type='Ljung-Box', fitdf=1, lag=2)

lBox = LjungBoxTest(arima$residuals, lag.max=10, k=1);
plot(lBox[,1], lBox[,3], ylim=0, main='Ljung-Box Test', ylab='p-value', xlab='lag');
abline(h=0.05, col='blue', lty=2)
