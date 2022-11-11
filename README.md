# Estimating maximum cross-neutralizing titers against SARS-CoV-2 variants.

## Summary
Estimating maximum cross-neutralizing titers against SARS-CoV-2 variants.
For each immuno-history, we estimated the neutralization titer and the time of immunization using a Bayesian hierarchical model. The log10 neutralization titer (NT) following breakthrough infection or booster vaccination is described using a three-parameter logistic model at each time interval between the second vaccination and the third immunization exposure. We inferred population means (μv) separately for neutralization titers against the ancestral strain, BA.1, BA.2, BA.2.75, BA.5. We used a hierarchical structure to describe the distribution of µhv for each immuno-history. Arrays in the model index over one or more indices: H=3 immuno-histories h; N=108 participants n; V=5 target viruses v; The model is:

### NTnvt ~ Normal (µhv / (1 + αv exp(- βv tn)), σ_NTv)
### µhv ~ Normal (µv, σ_µv) [0, 5]
### µv ~ Normal (2.5, 1) [0, 5]
### αv ~ Normal (2.5, 1) [0, 5]
### βv ~ Student_t (4, 0.05, 0.1) [0, 1]
### σ_µv ~ Student_t (4, 0, 0.5) [0, ∞]

The values in square brackets denote truncation bounds for the distributions. The explanatory variable was time, tn, and the outcome variable was NTnvt, which represented the neutralization titers against target virus v in participant n at time t. A noninformative prior was set for the standard distribution σ_NTv. The parameter αv and βv and controls the intercept and the steepness of the logistic function, respectively. The mean parameter for neutralization titers against target virus v in immuno-history h, µhv, was generated from a normal distribution with hyper parameters of the mean, µv, and the standard deviation, σ_µv. As the distribution generating βv and σ_µv, we used a Student’s t distribution with four degrees of freedom instead of a normal distribution to reduce the effects of outlier values of βv and σ_µv. 
The time interval days to 90% maximum neutralization titers against each virus (tMNT90v) was calculated according to the parameter αv and βv as:

### tMNT90v = log(9αv) / βv

Parameter estimation was performed via the MCMC approach implemented in rstan 2.26.1 (https://mc-stan.org). Four independent MCMC chains were run with 5,000 steps in the warmup and sampling iterations, subsampling every five iterations. We confirmed that all estimated parameters showed <1.01 R-hat convergence diagnostic values and >500 effective sampling size values, indicating that the MCMC runs were successfully convergent. The fitted model closely recapitulated the observed neutralizing titer increases in each immuno-history (Figs. 2A and 3A). The above analyses were performed in R 4.1.2 (https://www.r-project.org/). Information on the means of maximum neutralization titers against SARS-CoV-2 variants estimated in the present study is summarized in Table S2.

## Contents
はいってないわ

## Dependencies
### R 4.1.2
### Rstan 2.26.1
