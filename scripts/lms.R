# generate AR process data
library(signal)


lms <- function(ts, alpha=0.01, AR=2) {
  series = as.matrix(ts)
  n = length(series)
  
  weights = matrix(0, nrow=AR, ncol=n)
  weights[, AR+1] = c(3, -1);
  
  for (i in (AR+2):n-1) {

    xp <- t(-weights[,i]) %*% as.matrix(series[(i-1):(i-AR)]);
    print(dim(xp))
    error = as.numeric(series[i]) - as.numeric(xp);
  
    weights[,i+1] = weights[,i] - alpha*error*series[(i-1):(i-AR)];
  }
  
  print('Estimated weights')
  print(-weights[,n]);
  
  return(-weights)
}


n = 150;
series = arima.sim(n, model=list(ar=c(0.3, -0.8745)), rand.gen=rnorm);
#series = filter(1, c(1, 1.75, 0.8745), rnorm(n+50)) - 0.5;

AR = 2
alpha = 0.01;

result <- lms(series, alpha, AR);

plot(result[1,], ylim=c(-2, 2), type='l', col='red', main='Least Mean Square', xlab='Time', ylab='Weights',)
lines(result[2,], type='l', col='blue')
abline(h=0.3, col='red')
abline(h=-0.8745, col='blue')
legend("topright", lty=1, pch=1, col=c('red', 'blue'),
    c("0.3","-0.8745"))


# Notes
# w = matrix(c(4,1), nrow=2, ncol=15)
# s = matrix(c(9,2,4,7,5,8,1,8,1,3,11,2,13,14,15), nrow=15, ncol=1)
# t(-w[,3]) %*% s[2:1]