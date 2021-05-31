#! /usr/bin/env nix-shell
#! nix-shell ../../../src/rEnv.nix -i Rscript

# Please ignore the shabang above if you are reading the R showcase.
# It is just Nix things to execute the script in a controled environment.

# Libraries used by this script
library(tidyverse) # life saver
library(viridis) # colorblind-proof color schemes

data = read.csv("/tmp/athlete_events_subset.csv.gz")
summary(data)

# Globally, which countries have won the highest number of gold medals?
gold_data = data %>%
    filter(Medal == 'Gold') %>% # Only keep entries about gold medals
    group_by(Team) %>% # Create a group for each country
    summarize(gold_count = n()) %>% # Count how many gold medals the country won.
                                    # Store it in a "gold_count" column.
    top_n(n=10, wt=gold_count) %>% # Only keep top 10 countries.
    arrange(desc(gold_count)) # Sort the data by number of gold medals.

# Print what we just computed
gold_data

# Visualize this data
ggplot(gold_data) + # Create a plot about gold_data
    geom_col(aes(x=Team, y=gold_count)) + # Add bar charts in the plot
    theme_bw() + # Cosmetics for a black and white plot
    ggsave("./data/top-gold-countries-bc.png", width=10, height=5) # Save the plot in a file

# Globally, how medals are distributed among the previous countries?
ggplot(data %>%
        filter(Team %in% gold_data$Team) %>% # Only keep entries from the selected countries.
        filter(Medal %in% c('Gold', 'Silver', 'Bronze'))) + # Only keep entries that got a medal.
    geom_bar(aes(x=Team, fill=Medal)) + # Add an histogram (bar chart about distribution) in the plot
    scale_fill_manual(values=c("#824A02", "#FEE101", "#D7D7D7")) + # Custom colors
    theme_bw() +
    ggsave("./data/top-medal-distribution.png", width=10, height=5)

# How did the distribution of medals evolved over time for the global top 4 countries?
ggplot(data %>%
        filter(Team %in% c('Canada', 'United States', 'Germany', 'Sweden')) %>% # Only keep data for some countries
        filter(Medal %in% c('Gold', 'Silver', 'Bronze')) %>%
        group_by(Team, Medal, Year) %>% # Create groups on tuples!
        summarize(count=n())) + # Compute a count for each group
    geom_line(aes(x=Year, y=count, color=Team)) + # Add lines
    facet_wrap(~ Medal) + # Plot data of different Team on different facets
    scale_color_viridis(discrete=TRUE) + # colorblind-proof colors
    theme_bw() +
    ggsave("./data/top-medals-over-time.png", width=10, height=5)
