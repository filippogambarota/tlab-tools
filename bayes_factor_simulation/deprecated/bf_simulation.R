library(BayesFactor)
library(tidyverse)

eff <- seq(0, 1, 0.2)
nsubj <- seq(10, 50, 10)
scale_bf <- seq(0.1, 100, 10)

sim <- expand_grid(eff, nsubj, scale_bf, nsim = 1:500)

sim$bf <- NA

for(i in 1:nrow(sim)){
  g1 <- rnorm(sim$nsubj[i], sim$eff[i], 1)
  g2 <- rnorm(sim$nsubj[i], 0, 1)
  sim$bf[i] <- extractBF(ttestBF(g1, g2, rscale = sim$scale_bf[i]), onlybf = T)
}

sim %>%
  group_by(nsubj, scale_bf, eff) %>% 
  summarise(bf = mean(bf)) %>% 
  ggplot(aes(x = scale_bf, y = log(bf), color = factor(nsubj))) +
  geom_point() +
  geom_line() +
  ylim(c(-30, 30)) +
  facet_wrap(~eff)
 
bf_dat %>% 
  pivot_longer(1:4, names_to = "effect", values_to = "bf") %>% 
  mutate(effect = parse_number(effect)) %>% 
  ggplot(aes(x = scale_list, y = log(bf), group = effect)) +
  geom_hline(yintercept = 0, linetype = "dashed", col = "red") +
  geom_path() +
  geom_point(size = 4, aes(col = stat(ifelse(y > 0, "support for H1", "support for H0")))) +
  cowplot::theme_minimal_grid() +
  facet_wrap(~effect, scales = "free") +
  labs(col = "BF Direction") +
  ylab(latex2exp::TeX("$Bayes Factor_{10}$")) +
  xlab("Prior uncertainty")


library(tidyverse)
library(BayesFactor)

eff <- 0.3
nsample <- 100
nsim <- 1000

dat <- tibble(
  id = 1:(nsample*2),
  cond = rep(c("a", "b"), each = nsample)
)

dat <- expand_grid(
  dat,
  nsim = 1:nsim
)

dat$y <- map_dbl(1:nrow(dat), function(i) {
  ifelse(dat$cond[i] == "a",
         rnorm(1, 0, 1),
         rnorm(1, eff, 1) + rnorm(1, 0, 1.5))
})

dat %>% 
  group_by(nsim) %>% 
  nest()  %>% 
  mutate(bf = map(data, function(x) ttestBF(formula = y ~ cond, data = x))) -> dat_sim

dat_sim %>% 
  mutate(bf_num = map_dbl(bf, function(x) extractBF(x, onlybf = T))) %>% 
  ggplot(aes(x = bf_num)) +
  geom_boxplot()
