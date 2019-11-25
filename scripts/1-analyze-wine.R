#-------------------------------------------------------------------------------
# Load packages

packages <- c("here", "caret")
lapply(packages, library, character.only = TRUE, quietly = TRUE,
       logical.return = TRUE)

#-------------------------------------------------------------------------------
# Read data

wine <- readRDS(file = here("data/wine.rds"))

str(wine)
head(wine)

#-------------------------------------------------------------------------------
# Split data

# Check balancing

#-------------------------------------------------------------------------------
# Fit models without parameter tuning

# Predict based on test data

# Evaluate the performance

# Use preprocessing of the data

#-------------------------------------------------------------------------------
# Tune models using resampling

# Define the control of the `train()`

# Define the set of values of KNN hyperparameter `k`

# Fit the KNN with different `k`'s

# Define the sets of values of NN hyperparameters `size` and `decay`

# Compare models 
