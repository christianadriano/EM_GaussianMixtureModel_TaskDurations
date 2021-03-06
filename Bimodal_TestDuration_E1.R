"
Is Test Duration Bimodal in experiment E1?

It is bimodal across all qualification score level, more strongly for Score=100%
TODO:
- Plot bimodality in histogram and density. Explain. Need to zoom in (remove outliers upper_wiskers)
- Separate this in a different file
- Discuss bimodality in E2 as well for different scores
- Prepare to run EM for E1
This will be my first generalization result across experiments E1 and E2!!!


"


library(ggplot2)
library(dplyr)
library(hrbrthemes)
library(tidyr)
library(tidyverse)


#---------------------------------------------------------
#----------------------------------
#Load data from demographics and qualification test Experiment-1
source("C://Users//Christian//Documents//GitHub//CausalModel_FaultUnderstanding//data_loaders//load_consent_create_indexes_E1.R")
source("C://Users//Christian//Documents//GitHub//EM_GaussianMixtureModel_TaskDurations//util//multiplot.R")


#IS TEST DURATION BIMODAL?
#YES, for all participants and also within the following groups:
#Score<2
#Score>=2 (qualified)
p1 <- ggplot(df_consent, aes(x=test_duration)) +
  geom_histogram(binwidth = 0.5, colour = "black", 
                 fill = "lightblue") +
  theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 12),
    plot.title = element_text(size=14),
    axis.text.x = element_text(angle = 0, hjust = 1, size=12)
  ) +
  ylab("Probability Density") +
  xlab("Test Duration (minutes)") +
  ggtitle("Test Duration All E1")

p2 <- ggplot(df_consent, aes(x=test_duration)) +
  geom_density(colour = "black", 
               fill = "lightblue") +
  theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 12),
    plot.title = element_text(size=14),
    axis.text.x = element_text(angle = 0, hjust = 1, size=12)
  ) +
  ylab("Probability Density") +
  xlab("Test Duration (minutes)") +
  ggtitle("Test Duration All E1")

#Only who qualified (qualification_score>=2)
p3 <- ggplot(df_consent[df_consent$qualification_score>=2,], 
             aes(x=test_duration)) +
  geom_density(colour = "black", 
               fill = "lightblue") +
  theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 12),
    plot.title = element_text(size=14),
    axis.text.x = element_text(angle = 0, hjust = 1, size=12)
  ) +
  ylab("Probability Density") +
  xlab("Test Duration (minutes)") +
  ggtitle("Test Duratio Qualified Participants (score>=50%) E1")

#Only who DID NOT qualified (qualification_score>=2)
p4 <- ggplot(df_consent[df_consent$qualification_score<2,], 
             aes(x=test_duration)) +
  geom_density(colour = "black", 
               fill = "lightblue") +
  theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 12),
    plot.title = element_text(size=14),
    axis.text.x = element_text(angle = 0, hjust = 1, size=12)
  ) +
  ylab("Probability Density") +
  xlab("Test Duration (minutes)") +
  ggtitle("Test Duration Qualified Participants (score<50%) E1")

multiplot(p1,p2,p3,p4,cols=2)


p0 <- ggplot(df_consent[df_consent$qualification_score==0,], 
             aes(x=test_duration)) +
  #geom_density(colour = "black", 
  #             fill = "lightblue") +
  geom_histogram(binwidth = 0.5, colour = "black", 
                 fill = "lightblue") +
  theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 12),
    plot.title = element_text(size=14),
    axis.text.x = element_text(angle = 0, hjust = 1, size=12)
  ) +
  ylab("Probability Density") +
  xlab("Test Duration (minutes)") +
  ggtitle("Test Duration for Score=0 E1")

p1 <- ggplot(df_consent[df_consent$qualification_score==1,], 
             aes(x=test_duration)) +
  #geom_density(colour = "black", 
  #             fill = "lightblue") +
  geom_histogram(binwidth = 0.5, colour = "black", 
                 fill = "lightblue") +
  theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 12),
    plot.title = element_text(size=14),
    axis.text.x = element_text(angle = 0, hjust = 1, size=12)
  ) +
  ylab("Probability Density") +
  xlab("Test Duration (minutes)") +
  ggtitle("Test Duration for Score=1 E1")

p2 <- ggplot(df_consent[df_consent$qualification_score==2,], 
             aes(x=test_duration)) +
  #geom_density(colour = "black", 
  #             fill = "lightblue") +
  geom_histogram(binwidth = 0.5, colour = "black", 
                 fill = "lightblue") +
  theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 12),
    plot.title = element_text(size=14),
    axis.text.x = element_text(angle = 0, hjust = 1, size=12)
  ) +
  ylab("Probability Density") +
  xlab("Test Duration (minutes)") +
  ggtitle("Test Duration for Score=2 E1")


p3 <- ggplot(df_consent[df_consent$qualification_score==3,], 
             aes(x=test_duration)) +
  #geom_density(colour = "black", 
  #             fill = "lightblue") +
  geom_histogram(binwidth = 0.5, colour = "black", 
                 fill = "lightblue") +
  theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 12),
    plot.title = element_text(size=14),
    axis.text.x = element_text(angle = 0, hjust = 1, size=12)
  ) +
  ylab("Probability Density") +
  xlab("Test Duration (minutes)") +
  ggtitle("Test Duration for Score=3 E1")

p4 <- ggplot(df_consent[df_consent$qualification_score==4,], 
             aes(x=test_duration)) +
  #geom_density(colour = "black", 
  #             fill = "lightblue") +
  geom_histogram(binwidth = 0.5, colour = "black", 
                 fill = "lightblue") +
  theme_minimal()+
  theme(
    legend.position="top",
    legend.justification = "left",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 12),
    plot.title = element_text(size=14),
    axis.text.x = element_text(angle = 0, hjust = 1, size=12)
  ) +
  ylab("Probability Density") +
  xlab("Test Duration (minutes)") +
  ggtitle("Test Duration for Score=4 E1")

multiplot(p0,p1,p2,p3,p4,cols=2)
