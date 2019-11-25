#-------------------------------------------------------------------------------
# Install packages (only once!)

# install.packages("caret")
# install.packages("nnet")

#-------------------------------------------------------------------------------
# Load packages

library("caret")

#-------------------------------------------------------------------------------
# Read data

wine <- readRDS(file = paste0("/Users/irudnyts/Documents/post_phd/courses/mlba",
                              "/slides/caret/data/generated/wine.rds"))

str(wine)
head(wine)

#-------------------------------------------------------------------------------
# Split data
?createDataPartition

set.seed(1)
train_indices <- createDataPartition(y = wine$quality, p = 0.75, list = FALSE)
train_wine <- wine[train_indices, ]
test_wine <- wine[-train_indices, ]

# Check balancing
prop.table(table(train_wine$quality))
prop.table(table(test_wine$quality))

#-------------------------------------------------------------------------------
# Fit models without parameter tuning

?train
set.seed(11)
fit_knn <- train(form = quality ~ .,
                 data = train_wine,
                 method = "knn",
                 trControl = trainControl(method = "none"),
                 tuneGrid = data.frame(k = 3))

print(fit_knn)

# Predict based on test data
predict.train(fit_knn, newdata = test_wine)

# Evaluate the performance
confusionMatrix(
    predict.train(fit_knn, newdata = test_wine),
    test_wine$quality
)

# Use preprocessing of the data
set.seed(111)
fit_knn <- train(form = quality ~ .,
                 data = train_wine,
                 method = "knn",
                 preProcess = c("center", "scale"),
                 trControl = trainControl(method = "none"),
                 tuneGrid = data.frame(k = 3))

print(fit_knn)
predict.train(fit_knn, newdata = test_wine)

confusionMatrix(
    predict.train(fit_knn, newdata = test_wine),
    test_wine$quality
)


set.seed(1111)
fit_glm <- train(form = quality ~ .,
                 data = train_wine,
                 method = "glm",
                 trControl = trainControl(method = "none"),
                 family = binomial(link = "logit"))

predict.train(fit_glm, newdata = test_wine)

confusionMatrix(
    predict.train(fit_glm, newdata = test_wine),
    test_wine$quality
)

set.seed(1111)
fit_nn <- train(form = quality ~ .,
                data = train_wine,
                method = "nnet",
                trControl = trainControl(method = "none"),
                tuneGrid = data.frame(size = 10, decay = 0))

predict.train(fit_nn, newdata = test_wine)

confusionMatrix(
    predict.train(fit_nn, newdata = test_wine),
    test_wine$quality
)

#-------------------------------------------------------------------------------
# Tune models using resampling

# Define the control of the `train()`
train_control <- trainControl(method = "cv", number = 5)

# Define the set of values of KNN hyperparameter `k`
hp_knn <- expand.grid(k = 2:10) # a simple function `data.frame()` also
                                # would do the trick

# Fit the KNN with different k's
set.seed(11111)
fit_knn <- train(form = quality ~ .,
                 data = train_wine,
                 method = "knn",
                 preProcess = c("center", "scale"),
                 trControl = train_control,
                 tuneGrid = hp_knn)
print(fit_knn)
plot(fit_knn)

# Define the sets of values of NN hyperparameters `size` and `decay`
hp_nn <- expand.grid(size = 6:8, decay = c(0, 0.5))

set.seed(111111)
fit_nn <- train(form = quality ~ .,
                 data = train_wine,
                 method = "nnet",
                 preProcess = c("center", "scale"),
                 trControl = train_control,
                 tuneGrid = hp_nn)
print(fit_nn)
plot(fit_nn)

# Compare models 

confusionMatrix(
    predict.train(fit_knn, newdata = test_wine),
    test_wine$quality
)

confusionMatrix(
    predict.train(fit_nn, newdata = test_wine),
    test_wine$quality
)
