# vif-viz
Visualization of multicollinearity to show why variance inflation factors (VIFs) matter in the SE of regression coefficients. 

# Overview
1. Generate "triangular" data. In DAG terms, we have three variables described by the following paths:
    1.1. C -> Y
    1.2. C -> X
    1.3. X -> Y
    1.4 Importantly, X & C will be generated to have a high correlation, i.e., cor(X, C) >= 0.9
2. Make plots to show Y ~ X and Y ~ X.C (i.e., Y regressed on the residuals from X ~ C) produce same regression line, but the var(X.C) is much lower than var(X).
3. Simulate sampling from a population with the above DGM and show that the regression line from Y ~ X.C is very sensitive compared to Y ~ X. 
