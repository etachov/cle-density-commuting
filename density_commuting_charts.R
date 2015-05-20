## final charts for Belt article 

library(ggplot2)

cle_den <- read.csv("cle_density_commuting.csv", stringsAsFactors = F)

# start by setting text and panel themes
beltpaneltheme <- theme(#panel.grid = element_blank(),
  panel.background = element_blank(),
  axis.ticks = element_blank()) 

belttexttheme <-theme(plot.title = element_text(size = 28,
                                                hjust = 0,
                                                vjust = 2.2,
                                                family = "Garamond", 
                                                face = "bold", 
                                                colour = "#252525")) +
  theme(axis.title = element_text(size = 16,
                                  family = "Avenir Medium",
                                  face = "bold", 
                                  colour = "#252525"),
        axis.title.x = element_text(vjust = -.5),
        axis.title.y = element_text(vjust = 1.2)) +
  theme(axis.text = element_text(size = 14,
                                 family = "Avenir Medium",
                                 colour = "#252525")) 


# scatterplot for walking v. biking communters
cle_den %>%
  filter(city != "Louisville") %>% # no data for Louisville
  mutate(cle = factor(ifelse(city == "Cleveland", "True", "False")), # add a new factor various so we can single out cle
         city.label = factor(ifelse(per.bike.walk >= 7.3 | city == "Cleveland", city, "")), # and add a factor so we can direct label 
         city = reorder(factor(city), per.bike.walk)) %>%
         ggplot(., aes(x = per.bike, y = per.walk, colour = cle)) +
         scale_color_manual(values = c("#6C6C6C", "#E96B52")) +
         geom_point(alpha = .7, size = 3.5) +
         geom_text(aes(label = city.label, x = per.bike, y = per.walk+0.5)) +# not perfect label placement but close enough to fix up                 
         scale_x_continuous(breaks = c(0, 2, 4, 6, 8, 10),
                            labels = c("0%", "2%", "4%", "6%", "8%", "10%")) +
         scale_y_continuous(limits = c(0, 16),
                            breaks = c(0, 4,  8, 12, 16),
                            labels = c("0%", "4%", "8%", "12%", "16%")) +
         labs(title = "Percent of Commuters Biking v. Walking",
              x = "% of Commuters Biking to Work",
              y = "% of Commuters Walking to Work") +
         beltpaneltheme + belttexttheme +
         theme(legend.position = "none") 

ggsave("Biking v. Walking.png")

# density dotplot
cle_den %>%
  filter(city != "Louisville") %>%
  mutate(cle = factor(ifelse(city == "Cleveland", "True", "False"))) %>%
  mutate(city = reorder(factor(city), density)) %>%
  ggplot(., aes(density, city, colour = cle)) +
  geom_segment(aes(x = 0, xend = density, y = city, yend = city), linetype = "dashed", color = "#BFBFBF") +
  geom_point(size = 3) +
  scale_color_manual(values = c("#6C6C6C", "#E96B52")) +
  scale_x_continuous(breaks = c(0, 5000, 10000, 15000, 20000, 25000), 
                     labels = c("0","5k/m²", "10k/m²", "15k/m²", "20k/m²", "25k/m²")) +
  labs(title = "Population Density", 
       x = "Population Density (Population/m²)",
       y = "") +
  theme(panel.grid = element_blank(),
        panel.background = element_blank(),
        axis.ticks = element_blank()) +
  beltpaneltheme + belttexttheme +
  theme(legend.position = "none")

ggsave("DensityRank.png", width = 8, height = 10)


