# Unit 3 Exercise 1:
## Learning how to use plyr, dplyr, and tidyr to clean up basic data sets.
### Tidying up the data from the refine set out of Springboard.
library(plyr)
library(dplyr)
library(tidyr)

### Clean up the 'company' column
philip_index <- grep("^[pPf]", refine_original$company)
refine_original$company[philip_index] <- "philips"
akzo_index <- grep("^[aA]", refine_original$company)
refine_original$company[akzo_index] <- "akzo"
vanhouten_index <- grep("^[vV]", refine_original$company)
refine_original$company[vanhouten_index] <- "van houten"
unilever_index <- grep("^[uU]", refine_original$company)
refine_original$company[unilever_index] <- "unilever"
refine_next <- refine_original

### Separate the product code and product number
refine_next <- refine_next %>% 
  separate(`Product code / number`, sep = "-", into = c("product_code", "product_number"))

### Add product categories corresponding to the product code
#### Assigning the names to a vector
products <- c(p = "Smartphone", v = "TV", x = "Laptop", q = "Tablet")
#### Mutating the product category column to the current definition of the data frame
refine_next <- refine_next %>% 
  mutate(product_category = products[product_code])

### Add the full address from the address, city, and country
refine_next <- refine_next %>% 
  unite(address, city, country, col = "full_address", sep = ", ") %>% 
  arrange(company) %>% 
  print(refine_next)

### Create dummy variables for company and product category and add them to the data frame
company_dummy <- data.frame(model.matrix(~ company, data = refine_next))
product_dummy <- data.frame(model.matrix(~ product_category, data = refine_next))
bind_cols(refine_next, company_dummy, product_dummy)
#### This is not complete yet. I need to remove the x-intercept from both of the model.matrix() outputs and rename the columns
