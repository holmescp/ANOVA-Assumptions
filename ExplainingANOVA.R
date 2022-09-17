#F-Ratio is used to conduct an ANOVA (F=group mean square/error mean square)
#Assumptions:
  #Measurements of each group represent random samples from the population
  #Residuals are normally distributed around their means
  #ANOVAs are robust to modest deviations when the sample sizes are large
  #ANOVAs are robust to heteroscedasticity when samples are large, balanced, and variances differ by < 10x
#ANOVA hypothesis testing
  #1 state hypothesis
  #2 define model, check assumptions
  #3 run ANOVA for F-stat and p-value
  #4 if p<0.05, apply appropriate measures to determine differences between the means
  #5
#ANOVA uses a general linear model in the generic form: Y(ij)=B(naught)+B(1)X(i)+Error(ij)
                                                 #(slope)Y    =b        +  mx

#Kruskal-Walls Transformation: Non-parametric ANOVA when assumptions are violated and transforming doesn't help
#Uses ranks like Mann-Whitney U-Test, less powerful when n is large, assumes distribution shapes are the same

# Fit a linear model to the data
z <- lm(Relabund~Taxon, data=PipelineComparisons)

# Basic 'visreg' plot
visreg(z)

# Plots for checking the assumption of homoscedasticity
# using standardized residuals plotted against predicted values (plot '1')
# or by factor level (plot '5')
plot(z, which=1)
plot(z, which=5)

# Normal quantile plot (Q-Q plot) for testing assumption of normality
plot(z, which=2)

# Useful double check of normality
# Standardized residuals should look normally distributed
hist(rstandard(z))

# Basic ANOVA
anova(z)

# Type I is default, Type II is recommended for systems with more factors (Justify and Report)

# ANOVA in 'car', with Type II sums of squares stipulated
Anova(z, type=2)

# ANOVA in 'car', with Type III sums of squares stipulated
Anova(z, type=3)

# The issue with running multiple pairwise comparisons is that the risk of Type I error increases [1-(1-a)^N]
# e.g. with 1 comparison 1-(1-0.05)^1 = 0.05 : 5% chance of having a false positive
# e.g. with 20 comparisons 1-(1-0.05)^20 = 0.6415 : 64% chance of having a false positive

# Tukey-Kramer multiple comparisons (for 4+ comparisons, 2-3 can use Bonferroni)
TukeyHSD(aov(model), ordered=FALSE, conf.level=0.95)

# Plotting the Tukey-Kramer comparisons
plot(TukeyHSD(aov(z)))

#perform a power analysis
library(pwr)

#this data has 2 factors (u) with 3 and 11 levels, we have (see table above) 16 observations per group
#our mean squared df = 3*11(16-1)=495=(v)
#choose an effect size... small-medium maybe (0.25)=(f2)...?
#"the sample size needed to detect an effect of ____ this small would be ____."

#Effect Size     d     Ref
#very small      0.01  1
#small           0.20  2
#medium          0.50  2
#large           0.80  2
#very large      1.20  1
#huge            >2.0  1

#References 
#1)Sawilowsky, S (2009). "New effect size rules of thumb." Journal of Modern Applied Statistical Methods 8(2): 467-474.
#2)Cohen, J (1988) Statistical Power Analysis for Behavioral Sciences

pwr.f2.test(u=2,v=495,f2=(.25*.25))