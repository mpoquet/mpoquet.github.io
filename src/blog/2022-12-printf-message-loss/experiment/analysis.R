#!/usr/bin/env Rscript
library(tidyverse)
library(GGally)

data_file = read_csv('buffer-expe-file.csv') %>% mutate(context='file')
data_pipe = read_csv('buffer-expe-pipe.csv') %>% mutate(context='pipe')
data_term = read_csv('buffer-expe-term.csv') %>% mutate(context='term')
data_termerr = read_csv('buffer-expe-termerr.csv') %>% mutate(context='termerr')

data = bind_rows(data_file, data_pipe, data_term, data_termerr) %>% mutate(
    init = as.factor(init),
    print = as.factor(print),
    exit = as.factor(exit),
    fin = as.factor(fin),
    context = as.factor(context)
)

# Check variance among runs of the same process launch
grouped = data %>%
    group_by(init, print, exit, fin, msg, context) %>%
    summarize(msg_min = min(msg), msg_max = max(msg)) %>%
    mutate(msg_diff = msg_max - msg_min)
summary(grouped$msg_diff) # should be 0: no variance at all
grouped = grouped %>% mutate(msg=as.factor(msg_min))

ggplot(grouped) +
    geom_bar(aes(x=msg)) +
    facet_grid(rows=vars(context), cols=vars(print)) +
    labs(x="Number of messages printed", y="Number of occurrences") +
    scale_y_continuous(breaks=seq(0,12,4)) +
    theme_bw()
ggsave("message-printed-overall-distribution.pdf", width=8, height=8)
ggsave("message-printed-overall-distribution.png", width=8, height=8)

grouped_p = grouped %>% filter(print=='p')
ggplot(grouped_p) +
    geom_bar(aes(x=msg)) +
    facet_grid(rows=vars(init), cols=vars(exit)) +
    labs(x="Number of messages printed", y="Number of occurrences") +
    scale_y_continuous(breaks=seq(0,12,4)) +
    theme_bw()
ggsave("message-printed-p-distribution.pdf", width=6, height=4)
ggsave("message-printed-p-distribution.png", width=6, height=4)

grouped_pn = grouped %>% filter(print=='pn')
ggplot(grouped_pn) +
    geom_bar(aes(x=msg)) +
    facet_grid(rows=vars(init), cols=vars(exit)) +
    labs(x="Number of messages printed", y="Number of occurrences") +
    scale_y_continuous(breaks=seq(0,12,4)) +
    theme_bw()
ggsave("message-printed-pn-distribution.pdf", width=6, height=4)
ggsave("message-printed-pn-distribution.png", width=6, height=4)

grouped_pn_nop = grouped_pn %>% filter(init=='nop')
ggplot(grouped_pn_nop) +
    geom_bar(aes(x=msg)) +
    facet_grid(rows=vars(context), cols=vars(exit)) +
    labs(x="Number of messages printed", y="Number of occurrences") +
    scale_y_continuous(breaks=seq(0,1)) +
    theme_bw()
ggsave("message-printed-pn-nop-distribution.pdf", width=6, height=4)
ggsave("message-printed-pn-nop-distribution.png", width=6, height=4)
