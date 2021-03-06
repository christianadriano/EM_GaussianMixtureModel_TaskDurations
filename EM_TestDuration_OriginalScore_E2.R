"
Gaussian Mixture Model for the testDuration in E2
"

library(ggplot2)
library(dplyr)
library(hrbrthemes)
library(tidyr)
library(tidyverse)

#scripts to run EM algorithm
source("C://Users//Christian//Documents//GitHub//EM_GaussianMixtureModel_TaskDurations//util//main_bivariate_EM.R")
source("C://Users//Christian//Documents//GitHub//EM_GaussianMixtureModel_TaskDurations//util//prior_kmeans_EM.R")
source("C://Users//Christian//Documents//GitHub//EM_GaussianMixtureModel_TaskDurations//util//visualize_compute_membership.R")


#---------------------------------------------------------
#----------------------------------
#Load data from demographics and qualification test Experiment-2
source("C://Users//Christian//Documents//GitHub//CausalModel_FaultUnderstanding//data_loaders//load_consent_create_indexes_E2.R")
df_consent <- load_consent_create_indexes();


#Run for entire data set together
df_consent$testDuration_fastMembership <- NA
df_prior <- prior.df(wait = df_consent$test_duration)
m.step <- main(wait = df_consent$test_duration, wait.summary.df=df_prior)
df_consent <- compute_Memberships(m.step, df_consent)
plot <- plot_mixture_models(df_consent$test_duration,m.step,"All")
plot
#---------------------------------------------------------
#INVESTIGATE OUTCOMES
cor.test(df_consent$qualification_score,df_consent$test_duration,
         alternative = "two.sided", 
         method="pearson")
#Positive correlation = 0.2346014  

cor.test(df_consent$qualification_score,df_consent$testDuration_slowMembership,
         alternative = "two.sided", 
         method="pearson")
#Negative correlation = -0.2190735  

cor.test(df_consent$qualification_score,df_consent$testDuration_fastMembership,
         alternative = "two.sided", 
         method="pearson")
#Negative correlation = 0.2190735 

#-----------------------------------------------------
#REGRESSION MODELS WITH ADJUSTED SCORE

#With Interactions
model_1_fast <- lm(formula = qualification_score ~ test_duration + test_duration*testDuration_fastMembership, data=df_consent )
model_1_slow <- lm(formula = qualification_score ~ test_duration + test_duration*testDuration_slowMembership, data=df_consent )
summary(model_1_fast) 
summary(model_1_slow)
"
REJECTED MODEL
Does not matter if I use fast or slow in the regression
Only testDuration_fast/slowMembership is significant (p-value<0.05)
Adjusted R-squared is very small = 0.06
"
#-------------------------
#Without Interactions
model_2_fast <- lm(formula = qualification_score ~ test_duration + testDuration_fastMembership, data=df_consent )
model_2_slow <- lm(formula = qualification_score ~ test_duration + testDuration_slowMembership, data=df_consent )
summary(model_2_fast)
summary(model_2_slow)
"
All coefficients are significant (p-value<0.05), but Adjusted R-squared is small 0.06 
Looking at the coefficients, we can see that not only the membership has a large effect.
Membership: Coefficients(testDuration, testDuration_X_Membership)
Fast: (0.033991,1.089948)
Slow: (0.033991,-1.089948)
"
model_3_all <- lm(formula = qualification_score ~ test_duration, data=df_consent )
model_4_fast <- lm(formula = qualification_score ~ testDuration_fastMembership, data=df_consent )
model_5_slow <- lm(formula = qualification_score ~ testDuration_slowMembership, data=df_consent )
summary(model_3_all)
summary(model_4_fast)
summary(model_5_slow)

"
All coefficients are significant (p-value<0.05), but Adjusted R-squared is small 0.04 
Model: Coefficients(testDuration OR testDuration_X_Membership)
model_3_all: (0.04997)
model_4_fast: (2.08369)
model_5_slow: (-2.08369)

"
"Hence, overall, it seems that the membership information 
slighlty improved the explainability of the qualification_score score"

#---------------------------------------------
#REGRESSION MODELS WITH ORIGINAL SCORE

#Without Interactions
model_1_all <- lm(formula = qualification_score ~ test_duration, data=df_consent )
model_1_fast <- lm(formula = qualification_score ~ test_duration + testDuration_fastMembership, data=df_consent )
model_1_slow <- lm(formula = qualification_score ~ test_duration + testDuration_slowMembership, data=df_consent )
summary(model_1_all)
summary(model_1_fast)
summary(model_1_slow)
"
All coefficients are significant (p-value<0.05), but Adjusted R-squared is small 0.06 
Looking at the coefficients, we can see that not only the membership has a large effect.
Membership: Coefficients(testDuration, testDuration_X_Membership)
All: (0.11843)
Fast: (0.07582,2.90591)
Slow: (0.07582,-2.90591)
"

"
qualification_score has 60% weaker coefficients than qualification_score for E2
"

#--------------------------------------
#Hard clustering (not using the membership probability. Instead, using a categorical value - is_fast)
df_consent$is_fast <- FALSE
df_consent[df_consent$testDuration_fastMembership>=0.5,]$is_fast <- TRUE
View(df_consent[c("is_fast","testDuration_fastMembership")])

df_consent_slow <- df_consent[!df_consent$is_fast,]
df_consent_fast <- df_consent[df_consent$is_fast,]

model_2_fast <- lm(formula = qualification_score ~ test_duration + testDuration_fastMembership, data=df_consent_slow )
model_2_slow <- lm(formula = qualification_score ~ test_duration + testDuration_slowMembership, data=df_consent_slow )
summary(model_2_fast)
summary(model_2_slow)

model_2_fast <- lm(formula = qualification_score ~ test_duration + testDuration_fastMembership, data=df_consent_fast )
model_2_slow <- lm(formula = qualification_score ~ test_duration + testDuration_slowMembership, data=df_consent_fast )
summary(model_2_fast)
summary(model_2_slow)

model_2_fast_programmer <- lm(formula = qualification_score ~ test_duration + testDuration_fastMembership, data=df_consent_fast[df_consent_fast$profession=="Programmer",] )
model_2_slow_programmer <- lm(formula = qualification_score ~ test_duration + testDuration_slowMembership, data=df_consent_fast[df_consent_fast$profession=="Programmer",] )
summary(model_2_fast_programmer)
summary(model_2_slow_programmer)

df_consent %>% 
  group_by(profession,is_fast) %>% 
  summarize(count = n())

" The proportions changed with respect to when we computed for all population.
The data is more balanced for all,except Professionals, who none fit in two Gaussians.
"
# MOST Subjects fall in the Fast Cluster
# profession            is_fast count
# <fct>                 <lgl>   <int>
# 1 Professional          FALSE      65
# 2 Professional          TRUE      352
# 3 Programmer            FALSE       1
# 4 Programmer            TRUE       48
# 5 Hobbyist              FALSE      64
# 6 Hobbyist              TRUE      420
# 7 Graduate_Student      FALSE      59
# 8 Graduate_Student      TRUE      224
# 9 Undergraduate_Student FALSE      79
# 10 Undergraduate_Student TRUE      364
# 11 Other                 FALSE      11
# 12 Other                 TRUE      101

#----------------------------------------------------------------------
#----------------------------------------------------------------------
#Now compute the membership by each profession, 
#because professions have different mean values for test_duration.

source("C://Users//Christian//Documents//GitHub//CausalModel_FaultUnderstanding//data_loaders//load_consent_create_indexes_E2.R")
df_consent <- load_consent_create_indexes();

#Compute proportion by profession, because professions have distinct testDuration averages
profession_list <- as.character(unique(df_consent$profession))

df_consent$testDuration_fastMembership <- NA
for(profes in profession_list){
  #profes <- profession_list[6]
  print(profes)
  df_selected <- df_consent[df_consent$profession==profes,
                            c("worker_id","file_name","test_duration")]
  df_prior <- prior.df(wait = df_selected$test_duration)
  m.step <- main(wait = df_selected$test_duration, wait.summary.df=df_prior)
  df_selected <- compute_Memberships(m.step,df_selected) 
  df_consent$testDuration_fastMembership[which(df_consent$worker_id %in% df_selected$worker_id
                                     &
                                       df_consent$file_name %in% df_selected$file_name 
                                     & 
                                        df_consent$profession==profes)] <- df_selected$testDuration_fastMembership
 
  #plot model for the profession
  plot <- plot_mixture_models(df_selected$test_duration,m.step,profes)
  plot
 }

df_consent$is_fast <- FALSE
df_consent[df_consent$testDuration_fastMembership>=0.5,]$is_fast <- TRUE

#Save df_consent to file so we can retrieve the tesDuration_fast
path = "C://Users//Christian//Documents//GitHub//EM_GaussianMixtureModel_TaskDurations//output//"
write.csv(df_consent,paste0(path,"consent_with_testDuration_fastMembership_OriginalScore_.csv"));

#Check the proportion across professions.
df_consent %>% 
  group_by(profession,is_fast) %>% 
  summarize(count = n())
#   profession            is_fast count
#   <fct>                 <lgl>   <int>
# 1 Professional          TRUE      417
# 2 Programmer            FALSE      13
# 3 Programmer            TRUE       36
# 4 Hobbyist              FALSE      44
# 5 Hobbyist              TRUE      440
# 6 Graduate_Student      FALSE      23
# 7 Graduate_Student      TRUE      260
# 8 Undergraduate_Student FALSE      59
# 9 Undergraduate_Student TRUE      384
# 10 Other                FALSE      11
# 11 Other                TRUE      101

#-----------------------------------------------------------
#Evaluate how fast and slow can explain qualification_score score
df_consent_fast <- df_consent[df_consent$is_fast,]
df_consent_slow <- df_consent[!df_consent$is_fast,]

#by profession
prof_choice <- "Programmer"

#Starting from teh most complex to the most simplest model

model_1_fast <- lm(formula = qualification_score ~ test_duration + testDuration_fastMembership+ test_duration*testDuration_fastMembership, data=df_consent_fast[df_consent_fast$profession==prof_choice,] )
model_1_slow <- lm(formula = qualification_score ~ test_duration + testDuration_fastMembership+ test_duration*testDuration_fastMembership, data=df_consent_slow[df_consent_slow$profession==prof_choice,] )
summary(model_1_fast)
summary(model_1_slow)

model_2_fast <- lm(formula = qualification_score ~ test_duration + testDuration_fastMembership, data=df_consent_fast[df_consent_fast$profession==prof_choice,] )
model_2_slow <- lm(formula = qualification_score ~ test_duration + testDuration_fastMembership, data=df_consent_slow[df_consent_slow$profession==prof_choice,] )
summary(model_2_fast)
summary(model_2_slow)

model_3_fast <- lm(formula = qualification_score ~ test_duration, data=df_consent_fast[df_consent_fast$profession==prof_choice,] )
model_3_slow <- lm(formula = qualification_score ~ test_duration, data=df_consent_slow[df_consent_slow$profession==prof_choice,] )
summary(model_3_fast)
summary(model_3_slow)

#model without segregation of fast slow
model_4 <- lm(formula = qualification_score ~ test_duration, data=df_consent[df_consent$profession==prof_choice,] )
summary(model_4)
"
Professional coefficients
Model1 (fast): test_duration (+)*, fastMembership(-)
Model2 (fast): test_duration (+)*, fastMembership(+), interaction(-)
Model3 (fast): test_duration (+)*
Model4 (all): test_duration (+)

Programmer coefficients 
Model1 (fast, slow): test_duration (+,+)*, fastMembership (+, +)*, interaction (+,+)*
Model2 (fast, slow): test_duration (-,+), fastMembership (-, -)
Model3 (fast, slow): test_duration (-,+)*
Model4 (all): test_duration (zero)

Graduates coefficients 
Model1 (fast, slow): test_duration (+,+), fastMembership (+, -), interaction (-,-)  
Model2 (fast, slow): test_duration (+,+), fastMembership (+, -)
Model3 (fast, slow): test_duration (+,-)*
Model4 (all): test_duration (+)*

Hobbyist coefficients
Model1 (fast, slow): test_duration (-,+), fastMembership (-, -), interaction (+,-) 
Model2 (fast, slow): test_duration (+,+), fastMembership (+, -)
Model3 (fast, slow): test_duration (+,+)*
Model4 (all): test_duration (+)*

Undergrad coefficients
Model1 (fast, slow): test_duration (+,+), fastMembership (+, -)*, interaction (-,-) 
Model2 (fast, slow): test_duration (+,-), fastMembership (+, +)
Model3 (fast, slow): test_duration (+,-)*
Model4 (all): test_duration (+)*

  
Other coefficients
Model2 (fast, slow): test_duration (+,+), fastMembership (+, -), interaction (+,-)  
Model3 (fast, slow): test_duration (+,-), fastMembership (+, +)
Model3 (fast, slow): test_duration (+,-)*
Model4 (all): test_duration (+)*


Model 4 says that duration positively impacts score across all professions. However, this is not
true when we look at individual groups discovered by the mixture models.
Looking at Model 2 and Model 3, testDuration has a negative impact for slow group
in the following professsions: Undergrad, Other, Grad. F
Except for Programmer, duration has positive impact on score for the fast group across all other professions.
Programmers have the reverse. The longer the slow group took better the score, whereas the fast group was the opposite.

In conclusion, group membership within duration is a confounder for certain professions, but not others.



" 
#---------------
#PLOTS to show this phenomenon

df_consent_fast <- df_consent[df_consent$is_fast,]
df_consent_slow <- df_consent[!df_consent$is_fast,]
df_consent_slow <- rbind(df_consent_slow, c(1:32))
df_consent_slow[is.na(df_consent_slow$worker_id),]$profession <- "Professional"
df_consent_slow[is.na(df_consent_slow$worker_id),]$test_duration <- 0.5
df_consent_slow[is.na(df_consent_slow$worker_id),]$qualification_score <- 0
df_consent_slow[is.na(df_consent_slow$worker_id),]$is_fast <- FALSE


ggplot(df_consent, aes(x=test_duration, y=qualification_score)) + geom_point(aes(colour = profession))+
  stat_smooth(method = 'lm', formula = y ~ x, aes(colour = profession), se= FALSE)+
  theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 10),
    plot.title = element_text(size=12),
    axis.text.x = element_text(angle = 0, hjust = 1, size=10)
  ) +
  ylab("Score (Original)") +
  xlab("Test Duration (minutes)") +
  ggtitle("All: Duration impact on Score by Profession")


ggplot(df_consent_fast, aes(x=test_duration, y=qualification_score)) + geom_point(aes(colour = profession))+
  stat_smooth(method = 'lm', formula = y ~ x, aes(colour = profession), se= FALSE)+
theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 10),
    plot.title = element_text(size=12),
    axis.text.x = element_text(angle = 0, hjust = 1, size=10)
  ) +
  ylab("Score (Original)") +
  xlab("Test Duration (minutes)") +
  ggtitle("Fast speed-cluster: Duration impact on Score by Profession")

ggplot(df_consent_slow, aes(x=test_duration, y=qualification_score)) + geom_point(aes(colour = profession))+
  stat_smooth(method = 'lm', formula = y ~ x, aes(colour = profession), se= FALSE)+
  theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 10),
    plot.title = element_text(size=12),
    axis.text.x = element_text(angle = 0, hjust = 1, size=10)
  ) +
  ylab("Score (Original)") +
  xlab("Test Duration (minutes)") +
  ggtitle("Slow speed-cluster: Duration impact on Score by Profession")



