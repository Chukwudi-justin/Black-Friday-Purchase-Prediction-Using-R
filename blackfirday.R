# install packages, if needed, and then load the packages.
if (!require("pacman")) install.packages("pacman")

pacman::p_load(pacman, knitr, plyr, caret, gridExtra, scales, Rmisc, ggrepel, randomForest, psych, xgboost, dplyr, GGally, ggplot2, ggthemes, 
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny, 
               stringr, tidyr, tidyverse)

library(skimr)
#Load data set
df_test <- read.csv("black_test.csv", header = TRUE, stringsAsFactors = FALSE)
df_train <- read.csv("black_train.csv", header = TRUE, stringsAsFactors = FALSE)

colnames(df_train)

install.packages("caret")
install.packages('caret', dependencies = TRUE)
install.packages('e1071', dependencies=TRUE)
library("caret")
#important
install.packages("kableExtra")
library(knitr)
library(kableExtra)
#skim gives outlook of the dataset
df_train %>% skim() %>% kable()%>% kable_styling(latex_options = c("striped", "hold_position"),
                                                 full_width = F)
head(df_train)
str(df_train)

#Data Cleaning
# Coerce some character/integer columns to Factors(Categorical)
factcols <- c('Gender', 'Age', 'Occupation', 'City_Category', 'Stay_In_Current_City_Years', 'Marital_Status', 'Product_Category_1', 'Product_Category_2', 'Product_Category_3')
library(tidyverse)
library(magrittr)
set.seed(88)

df_train %<>% mutate_at(factcols, factor)

str(df_train)

#Check factor variables
colnames(dplyr::select_if(df_train, ~ !is.ordered(.) & is.factor(.)))

#missing values in two of the columns
NAcol <- which(colSums(is.na(df_train)) > 0)
sort((colSums(sapply(df_train[NAcol], is.na)) / 550068) * 100, decreasing = TRUE)


cat('There are', length(NAcol), 'columns with missing values')

#drop product_category_3 with 70% missing value
df_train <- dplyr::select(df_train, -Product_Category_3)

#Replacing Missing value for product_category_2
#check levels
levels(df_train$Product_Category_2)

#convert all NA's to 9(median)
df_train$Product_Category_2[is.na(df_train$Product_Category_2)] = 9

#Rechecking number of missing values
sum(is.na(df_train$Product_Category_2))

#Missing value for the dataframe
sum(is.na(df_train))

#Exploratory Data Analysis
#Gender
ggplot(df_train, aes(Gender, fill = "red")) +
  geom_bar() + labs(title =  "Age Count")

#Age
ggplot(df_train, aes(Age, fill= Gender)) +
  geom_bar() + labs(title =  "Age Distribution By Gender")
#City_category
install.packages("lessR")
library(lessR)

PieChart(City_Category, data = df_train, fill = "blues",
         hole_fill = "#B7E3E0",
         main = NULL)
#Number of Years in city
PieChart(Stay_In_Current_City_Years, data = df_train,
         fill = "viridis",
         main = NULL,
         color = "black",
         lwd = 1.5,
         values_color = c(rep("white", 4), 1),
         values_size = 0.85)
#Marital Status
ggplot(df_train, aes(Marital_Status)) +
  geom_bar(fill = 4) + labs(title = "Marrital Status 0 = Single/ 1 = Married")
#Purchase
set.seed(1)
hist(df_train$Purchase,
     col = 4,
     main = "Distribution of Purchase Amount", # Title
     xlab = "Amount",           # X-axis label
     ylab = "Frequency")

#Relationship Between Variables
#City vs Purchase
ggplot(df_train, aes(x = City_Category, y = Purchase, fill = City_Category)) + 
  stat_boxplot(geom = "errorbar",
               width = 0.25) + 
  geom_boxplot() + labs(title = "City_category VS Purchase")
#City Vs Years in city
ggplot(df_train, aes(Stay_In_Current_City_Years, fill = City_Category)) + 
  geom_bar() + labs(title = "Years Spent in city Vs city Category")
#Age Vs Purchase
ggplot(df_train, aes(x = Age, y = Purchase, fill = Age)) +
  geom_bar(stat = "identity") +
  guides(fill = guide_legend(title = "Age Groups")) + labs(title = "Age Distribution vs purchases")
#Model Development
#Drop User_ID and Product_ID
df_train <- dplyr::select(df_train, -User_ID, -Product_ID)
#Linear Regression
#cleaning Data before Model
#Gender
df_train$Gender <- str_replace(df_train$Gender, 'F', '0')
df_train$Gender <- str_replace(df_train$Gender, 'M', '1')
#Converting Gender from categorical to numerical value
df_train$Gender <- as.numeric(df_train$Gender)
table(df_train$Gender)
#Age
df_train$Age <- as.integer(df_train$Age)
table(df_train$Age)
#Occupation
df_train$Occupation <- as.numeric(df_train$Occupation)
#City_category
df_train$City_Category <- as.numeric(df_train$City_Category)
#Years in city
df_train$Stay_In_Current_City_Years <- as.integer(df_train$Stay_In_Current_City_Years)
#Marital_Status
df_train$Marital_Status <- as.numeric(df_train$Marital_Status)
#Product_Category_1
df_train$Product_Category_1 <- as.numeric(df_train$Product_Category_1)
#Product_Category_2
df_train$Product_Category_2 <- as.numeric(df_train$Product_Category_2)

#Correlation
cor_numVar <- cor(df_train, use="pairwise.complete.obs") #correlations of all numeric variables

#sort on decreasing correlations with Purchase
cor_sorted <- as.matrix(sort(cor_numVar[,'Purchase'], decreasing = TRUE))

cor_sorted %>% kable()%>% kable_styling(latex_options = c("striped", "hold_position"),
                             full_width = F)


install.packages('corrplot')
library(corrplot)

install.packages("psych")
library(psych)

corPlot(cor_numVar,
        scale = FALSE)


#Compute linear model with all features
lr <- lm(Purchase ~ ., data = df_train)
summary(lr)
#Improve Model
lr2 <- lm(Purchase ~ . -Stay_In_Current_City_Years, data = df_train)
summary(lr2)

#Analysis of Model
residuals <- data.frame('Residuals' = lr2$residuals)
res_hist <- ggplot(residuals, aes(x=Residuals)) + geom_histogram(color='black', fill='skyblue') + ggtitle('Histogram of Residuals') 
res_hist

plot(lr2, col='Sky Blue') #Plots for the linear model with all features


#Variable Importance
varImp(lr2) %>% kable() %>%
  kable_styling(bootstrap_options = "striped",
                full_width = F)


#Step_wise Regression
library(MASS)
install.packages("glmnet")
require(glmnet)
lm.step = stepAIC(lr2, direction = 'both')
lm.step$anova # ANOVA of the result
summary(lm.step)


#Prediction Data set
#Data Cleaning
df_test %<>% mutate_at(factcols, factor)

str(df_test)

#Check factor variables
colnames(dplyr::select_if(df_test, ~ !is.ordered(.) & is.factor(.)))

#Drop columns not needed
df_test <- dplyr::select(df_test, -User_ID, -Product_ID, -Product_Category_3)
str(df_test)

#Gender
df_test$Gender <- str_replace(df_test$Gender, 'F', '0')
df_test$Gender <- str_replace(df_test$Gender, 'M', '1')
#Converting Gender from categorical to numerical value
df_test$Gender <- as.numeric(df_test$Gender)
table(df_test$Gender)
#Age
df_test$Age <- as.integer(df_test$Age)
table(df_test$Age)
#Occupation
df_test$Occupation <- as.numeric(df_test$Occupation)
#City_category
df_test$City_Category <- as.numeric(df_test$City_Category)
#Years in city
df_test$Stay_In_Current_City_Years <- as.integer(df_test$Stay_In_Current_City_Years)
#Marital_Status
df_test$Marital_Status <- as.numeric(df_test$Marital_Status)
#Product_Category_1
df_test$Product_Category_1 <- as.numeric(df_test$Product_Category_1)
#Product_Category_2
df_test$Product_Category_2 <- as.numeric(df_test$Product_Category_2)

str(df_test)

#Prediction and Evaluation
y_prediction=predict(lr2,newdata = df_test)
y_pred1=data.frame(y_prediction)
head(y_pred1)

#add predicted value to test data set
df_test$Purchase <- y_prediction

#check Predicted prices for new data set
head(df_test$Purchase, 10) %>% kable() %>%
  kable_styling(bootstrap_options = "striped",
                full_width = F)

