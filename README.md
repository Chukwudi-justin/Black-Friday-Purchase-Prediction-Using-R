# Black-Friday-Purchase-Prediction-Using-R
### INTRODUCTION
Black Friday is a colloquial term for the Friday after Thanksgiving in the United States. It traditionally marks the start of the Christmas shopping season in the United States. Many stores offer highly promoted sales at discounted prices and often open early, sometimes as early as midnight or even on Thanksgiving.\
source: Wikipedia\
This Project seeks to predict the amount of purchase in a retail store on a black friday using R programming language.

The data set was obtained from kaggle.
# DATASET DESCRIPTION
The dataset consist of 537577 rows and 12 columns.
# Data Overview
User_ID: Unique ID of the user. There are a total of 5891 users in the dataset.\
Product_ID: Unique ID of the product. There are a total of 3623 products in the dataset.\
Gender: indicates the gender of the person making the transaction.\
Age: indicates the age group of the person making the transaction.\
Occupation: shows the occupation of the user, already labeled with numbers 0 to 20.\
City_Category: User's living city category. Cities are categorized into 3 different categories 'A', 'B' and 'C'.\
Stay_In_Current_City_Years: Indicates how long the users has lived in this city.\
Marital_Status: is 0 if the user is not married and 1 otherwise.\
Product_Category_1 to _3: Category of the product. All 3 are already labaled with numbers.\
Purchase: Purchase amount.

# This project intends to achieve the following:
1. Predict the amount of purchases by a customer using simple regression model based on certain predictor variables.\
2. To identify most important variables that help predict the purchasing price.


### EXPLORATORY DATA ANALYSIS OF DATA SET
## Gender 
![Gend](black_gender.png)

As can be observed that there were more male customers for the balck friday sales than the females.

## Age Distribution By Gender
![Age](black_Age.png)

We observe that most for the customers where between the age brackets 18 - 45, with the predominant age bracket being 26 - 35. This is expected because most youths prefer buying during discount promo, since they are getting the same product at a discounted price.


## City Category
![City](black_city.png)

City Category B had most users from the data set, We need to find out if the city has any influence on customer purchase.

## Number Of years In City
![CityYear](black_num_city.png)

We see that most city occupants love spending only a year in any city.

## Marital Status
![Marry](new_marital.png)

Black friday sales had more of single customers than married.

## Distribution Of Purchase Amount
![Purchase](black_amount_purchase.png)

We observe that the distribution can be fairly classified as bell shaped.

## City Vs Total Purchase
![cityPur](cityVSpurchase.png)

Not much can be observed from the chart, however we notice some outliers in city A and B.

## City Vs Year In City
![cityYear](newcity_vs_years.png)

Interestingly customers prefer spending only a year, regardless the city they live in.

## Age Vs Purchases
![Agepur](AgevsPurchase.png)

As we observed earlier people within the age of 26 - 35 had most purchases.



