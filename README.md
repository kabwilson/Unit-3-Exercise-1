# Unit 3 Exercise 1:
## Learning how to use plyr and dplyr to clean up basic data sets.
### Tidying up the data from the refine set out of Springboard.
library(plyr)
library(dplyr)
library(tidyr)

### Apply the original table to a new name to keep the integrity of the original data
refine_next <- refine_original

### Clean up the 'company' column
philip_index <- grep("^[pPf]", refine_next$company)
refine_next$company[philip_index] <- "philips"
akzo_index <- grep("^[aA]", refine_next$company)
refine_next$company[akzo_index] <- "akzo"
vanhouten_index <- grep("^[vV]", refine_next$company)
refine_next$company[vanhouten_index] <- "van houten"
unilever_index <- grep("^[uU]", refine_next$company)
refine_next$company[unilever_index] <- "unilever"

### Separate the product code and product number
refine_next <- refine_next %>% 
  separate(`Product code / number`, sep = "-", into = c("product_code", "product_number")) %>% 
  arrange(company) %>% 
  print(refine_next)

### Add product categories corresponding to the product code
#### Assigning the names to a vector
products <- c(p = "Smartphone", v = "TV", x = "Laptop", q = "Tablet")
#### Mutating the product category column to the current definition of the data frame
refine_next <- refine_next %>% 
  mutate(product_category = products[product_code]) %>% 
  arrange(company) %>% 
  print(refine_next)

### Add the full address from the address, city, and country
refine_next <- refine_next %>% 
  unite(address, city, country, col = "full_address", sep = ", ") %>% 
  arrange(company) %>% 
  print(refine_next)

### Create dummy variables for company and product category
company_dummy <- data.frame(model.matrix(~ company + 0, data = refine_again))
product_dummy <- data.frame(model.matrix(~ product + 0, data = refine_again))
#### Just need to rename the columns here
refine_again <- bind_cols(refine_again, company_dummy, product_dummy)
