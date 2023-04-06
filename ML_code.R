library(glmnet)
library(splines)

rm(list=ls())

set.seed(5082)
my.df = read.csv("zillow2223.csv", header=TRUE, sep=',', row.names="name", stringsAsFactors = TRUE)

x <- model.matrix(price~., my.df)[, -1] 
y <- my.df$price
n = nrow(my.df)
trainIndex = sample(1:n, size = n* 0.8)
train.x = x[trainIndex ,]
test.x = x[-trainIndex ,]
train.y = y[trainIndex]
test.y = y[-trainIndex]

my.df$zipcode <- factor(my.df$zipcode)
my.df$age <- 2023 - my.df$year
summary(my.df$age) 

my.df<-subset(my.df, select = -c(section,team, international, masonyear, zestimate, assessment, taxes, willingtopay, year))
attach(my.df)
x <- model.matrix(price~., my.df)[, -1]
y<- my.df$price
n <- nrow(my.df)
trainIndex <- sample(n, .8 * n)
train.x <- x[trainIndex, ]
test.x <- x[-trainIndex, ]
train.y <- my.df$price[trainIndex]
test.y <- my.df$price[-trainIndex]
trainIndex 
summary(test.y) 





grid = 10 ^ seq(4, -2, length=150)
mod.lasso <- glmnet(train.x,  
                    train.y, 
                    alpha=1, 
                    lambda=grid)

cv.out.lasso <- cv.glmnet(train.x,  
                          train.y, 
                          alpha=1, 
                          lambda=grid,
                          nfolds=12) 
bestlam.lasso <- cv.out.lasso$lambda.min
bestlam.lasso 

lasso.pred <- predict(mod.lasso, 
                      s=bestlam.lasso, 
                      newx=test.x)
lasso.pred 
MSE.lasso <- mean((lasso.pred - test.y)^2)
MSE.lasso #Q02-3

lasso.coefficients <- predict(mod.lasso, 
                              s=bestlam.lasso, 
                              type="coefficients")
lasso.coefficients #Q2-4
my.df["J.T.B", "price"]-lasso.pred["J.T.B",] 



set.seed(5082)
x = model.matrix(zipcode~., my.df)[, -1]
y<-my.df$zipcode
n <- nrow(my.df)
trainIndex <- sample(n, .8 * n)
train.x <- x[trainIndex, ]
test.x <- x[-trainIndex, ]
train.y <- my.df$zipcode[trainIndex]
test.y <- my.df$zipcode[-trainIndex]
mod.ridge <- glmnet(train.x,  
                    train.y, 
                    alpha=0, # ridge
                    lambda=grid,
                    family = binomial) 

cv.out.ridge <- cv.glmnet(train.x,  
                          train.y, 
                          alpha=0, 
                          lambda=grid,
                          nfolds=12,
                          family = binomial)

bestlam.ridge <- cv.out.ridge$lambda.min
bestlam.ridge #Q03-1

ridge.pred <- predict(mod.ridge, 
                      s=bestlam.ridge, 
                      newx=test.x, 
                      type = "response"
)
ridge.pred

ridge.coef <- predict(mod.ridge, 
                      s=bestlam.ridge, 
                      newx=test.x, 
                      type = "coefficients"
)
ridge.coef 
zipcode_hat <-ifelse(ridge.pred>=.5, 23188, 23185)
zipcode_hat
test.y == zipcode_hat 
mean(test.y == zipcode_hat) 



set.seed(5082)

y <- my.df$price
n = nrow(my.df)
trainIndex = sample(1:n, size = n* 0.8)
train.x = x[trainIndex ,]
test.x = x[-trainIndex ,]
train.y = y[trainIndex]
test.y = y[-trainIndex]

ns.cv.mse=seq(from=0, to=0, length.out=8)
#4. 
for(num.knots in 1:8){
  NSmodel <- lm(price~ns(sqft, df=3+ num.knots -2), data=my.df[trainIndex,])
  ns.pred <- predict(NSmodel, newdata=my.df[-trainIndex,])
  ns.cv.mse[num.knots] <- mean((ns.pred - test.y)^2)
}

ns.cv.mse #Q04-1
plot(ns.cv.mse[1:8])
(stdev <- sd(ns.cv.mse[1:8]))
(min <- which.min(ns.cv.mse))
abline(h=ns.cv.mse[min] + stdev, col = "red", lty = "dashed")
best.knots=5
BestNSModel <- lm(price~ns(sqft, df=3+ best.knots -2), data=my.df[trainIndex,])
price_hat_ns <- predict(BestNSModel, newdata=my.df[-trainIndex,])
price_hat_ns 