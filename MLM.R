##Live Coding - Machine Learning Models

library(tidyverse)
install.packages('tidymodels')
library(tidymodels)


install.packages('rlang')
library(rlang)

#data
#covid by county
dat <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv", show_col_types = FALSE)

#census data
census <- read_csv("https://www2.census.gov/programs-surveys/popest/datasets/2020-2023/counties/totals/co-est2023-alldata.csv", show_col_types = FALSE)
census <- census %>%
  filter(COUNTY == '000') %>%
  mutate(fips = STATE) %>%
  select(fips, contains('2021'))

#Data Cleaning
#pmax ensures no negative value
state_dat <- dat %>%
  group_by(fips) %>%
  mutate(new_cases = pmax(0, cases - lag(cases)),
         new_deaths = pmax(0, deaths - lag(deaths))) %>%
  ungroup() %>%
  left_join(census, by = 'fips') %>%
  mutate(m = month(date),
         y = year(date),
         season = case_when(m %in% 3:5 ~ 'Spring',
                            m %in% 6:8 ~ 'Summer',
                            m %in% 9:11 ~ 'Fall',
                            m %in% c(1, 2, 12) ~ 'Winter')) %>%
  group_by(state, y, season) %>%
  mutate(season_cases = sum(new_cases, na.rm = TRUE),
         season_deaths = sum(new_deaths, na.rm = TRUE)) %>%
  distinct(state, y, season, .keep_all = TRUE) %>%
  ungroup() %>%
  drop_na() %>%
  mutate(logC = log(season_cases + 1)) %>% #add 1 because log(0) is NA
  select(logC, contains('season'), POPESTIMATE2021, DEATHS2021, BIRTHS2021, state)

install.packages('skimr')
library(skimr)

skimr::skim(state_dat) #really helps to analyze data before modeling

# Data Splitting
set.seed(87281)
split <- initial_split(state_dat, prop = 0.8, strata = season)
s_train <- training(split)
s_testing <- testing(split)
s_folds <- vfold_cv(s_train, v = 10)

# Feature Engineering - Recipe ensures that anytime you add more data, or use this data set, it will follow the steps you add to the recipe (step_center, step_scale)

rec <- recipe(logC ~ ., data = s_train) %>%
  step_rm(season_cases, state) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_scale(all_nominal_predictors()) %>%
  ste_center(all_nominal_predictors())

# Define Models (typically 3-5 are used to check)

lm_mod <- linear_reg() %>%
  set_enging('lm') %>%
  set_mode('regression')

rf_mod <- rand_forest() %>%
  set_enging('ranger', importance = 'impurity') %>%
  set_mode('regression')

boost_mod <- boost_tree() %>%
  set_enging('xgboost') %>%
  set_mode('regression')

neural_mod <- mlp() %>%
  set_enging('nnet') %>%
  set_mode('regression')

# Workflow Set

wf <- workflow_set(list(rec), list(lm_mod, rf_mod, boost_mod, neural_mod)) %>%
  workflow_map(wf, "fit_resamples", resamples = s_folds)


# Select Models
autoplot(wf) + theme_classic()

#random forest performs well
fit <- workflow() %>%
  add_recipe(rec) %>%
  add_model(rf_mod) %>%
  fit(data = s_train)

#VIP

vip::vip(fit)

#Metrics/Predictions
#use testing data finally - first time model has seen this data
predictions <- augment(fit, new_data = s_testing)
metrics(preditions, truth = logC, estimate = .pred)

#Plots
ggplot(predictions, aes(x = logC, y = .pred)) +
  geom_point() +
  geom_abline() +
  geom_smooth(method = 'lm') +
  theme_classic()
