# Unit 3 Exercise 1:
# Tidying up the data from the refine set out of Springboard.
library(plyr)
library(dplyr)
library(tidyr)

# Apply the original table to a new name to keep the integrity of the original data
refine_next <- refine_original

# Clean up the 'company' column
philip_index <- grep("^[pPf]", refine_next$company)
refine_next$company[philip_index] <- "philips"
akzo_index <- grep("^[aA]", refine_next$company)
refine_next$company[akzo_index] <- "akzo"
vanhouten_index <- grep("^[vV]", refine_next$company)
refine_next$company[vanhouten_index] <- "van houten"
unilever_index <- grep("^[uU]", refine_next$company)
refine_next$company[unilever_index] <- "unilever"

# Separate the product code and product number into their own columns
refine_again <- refine_next %>%
  separate(`Product code / number`, sep = "-", into = c("product_code", "product_number"))

# Add product categories corresponding to the product code
# assigning the names to a vector
products <- c(p = "Smartphone", v = "TV", x = "Laptop", q = "Tablet")
# mutating the product category column to the current definition of the data frame
refine_again <- refine_again %>% 
  dplyr::mutate(product_category = products[product_code])

# add the full address from the address, city, and country
refine_again <- refine_again %>% 
  unite(address, city, country, col = "full_address", sep = ", ")

# Create dummy variables for company and product category
company_dummy <- data.frame(model.matrix(~ company + 0, data = refine_again))
product_dummy <- data.frame(model.matrix(~ product_code + 0, data = refine_again))
names(company_dummy) <- c("company_akzo", "company_philips", "company_unilever", "company_van_houten")
names(product_dummy) <- c("product_smartphone", "product_tablet", "product_tv", "product_laptop")
refine_clean <- bind_cols(refine_again, company_dummy, product_dummy)
refine_clean <- refine_clean %>% arrange(company)
View(refine_clean)