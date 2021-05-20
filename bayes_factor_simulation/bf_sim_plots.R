# Simulation Results ------------------------------------------------------

# Packages

library(tidyverse)
library(gridExtra)
library(cowplot)
library(ggridges)

# Loading data

load("results/sim.rda")

# Plots

bf_plot <- sim %>% 
    ggplot(., aes(x = log_bf)) +
    facet_grid(scale_cauchy~mean_eff) +
    geom_histogram(bins = 100) +
    theme_minimal() +
    coord_cartesian(xlim = c(-5, 10)) +
    labs(fill = "BF") +
    xlab("Log BF") +
    ylab("Count") +
    ggtitle("BF Simulation") +
    geom_vline(xintercept = 0, linetype = "dashed", size = 1, color = "red")

priors <- lapply(unique(sim$scale_cauchy), function(i) {
    ggplot(data = data.frame(x = c(-1, 1)), aes(x)) +
        stat_function(fun = dcauchy, n = 1000, args = list(location = 0, scale = i)) +
        theme_minimal() +
        ylab("") +
        xlab("") +
        scale_y_continuous(breaks = NULL)
})

prior_plot <- grid.arrange(grobs = priors, ncol = 1, top = "H1 Prior distribution")

plot_grid(bf_plot, prior_plot, rel_widths = c(5/4, 1/5))

# p-value, Bayes Factor and effect size

sim %>% 
    pivot_longer(c(log_bf, p_value), names_to= "measure", values_to = ".value") %>% 
    ggplot(aes(x = .value)) +
    facet_grid(scale_cauchy~mean_eff + measure, scales = "free") +
    geom_histogram(bins = 50) +
    theme_minimal()


sim %>% 
    ggplot(aes(x = p_value, y = log_bf, color = factor(scale_cauchy))) +
    geom_point() +
    xlab("P-Value") +
    ylab("Log BF") +
    labs(color = "Cauchy Scale") +
    theme_minimal()

sim %>% 
    ggplot(aes(x = obs_eff, y = log_bf, color = factor(scale_cauchy))) +
    geom_point() +
    xlab("Observed Effect Size") +
    ylab("Log BF") +
    labs(color = "Cauchy Scale") +
    theme_minimal()
