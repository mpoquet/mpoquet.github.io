#!/usr/bin/env Rscript
library(tidyverse)

understanding_vec = c('Not mentioned', 'Very poor', 'Poor', 'Strong', 'Very strong')
quality_vec = c('Very bad', 'Bad', 'Good', 'Very good')

col_understanding = col_factor(levels=understanding_vec, ordered=TRUE)
col_quality = col_factor(levels=quality_vec, ordered=TRUE)

eval_cols = cols(
  `Time` = col_datetime(format = ""),
  `Participant` = col_character(),
  `Your understanding of the vulnerability that has just been presented | General principles of the vulnerability` = col_understanding,
  `Your understanding of the vulnerability that has just been presented | What systems are exposed?` = col_understanding,
  `Your understanding of the vulnerability that has just been presented | How to exploit it?` = col_understanding,
  `Your understanding of the vulnerability that has just been presented | How to detect if my system is exposed?` = col_understanding,
  `Your understanding of the vulnerability that has just been presented | How can I protect my system from it?` = col_understanding,
  `Your understanding of the vulnerability that has just been presented | How has it been fixed?` = col_understanding,
  `Your opinion on the presentation quality | General opinion` = col_quality,
  `Your opinion on the presentation quality | Presentation slides` = col_quality,
  `Your opinion on the presentation quality | Oral communication` = col_quality,
  `Your opinion on the presentation quality | Answers to the questions` = col_quality
)

presentation1 = read_csv('cve-pwnkit.csv', col_names=TRUE, col_types=eval_cols) %>% mutate(group="pwnkit")
presentation2 = read_csv('cve-log4shell.csv', col_names=TRUE, col_types=eval_cols) %>% mutate(group="log4shell")
# ...
presentations = bind_rows(
  presentation1
 ,presentation2
#,...
)

# Shorten the column names
presentations = presentations %>% rename(
  `General principles of the vulnerability` = `Your understanding of the vulnerability that has just been presented | General principles of the vulnerability`,
  `What systems are exposed?` = `Your understanding of the vulnerability that has just been presented | What systems are exposed?`,
  `How to exploit it?` = `Your understanding of the vulnerability that has just been presented | How to exploit it?`,
  `How to detect if my system is exposed?` = `Your understanding of the vulnerability that has just been presented | How to detect if my system is exposed?`,
  `How can I protect my system from it?` = `Your understanding of the vulnerability that has just been presented | How can I protect my system from it?`,
  `How has it been fixed?` = `Your understanding of the vulnerability that has just been presented | How has it been fixed?`,
  `General opinion` = `Your opinion on the presentation quality | General opinion`,
  `Presentation slides` = `Your opinion on the presentation quality | Presentation slides`,
  `Oral communication` = `Your opinion on the presentation quality | Oral communication`,
  `Answers to the questions` = `Your opinion on the presentation quality | Answers to the questions`
)

# Identify questionnaire participants to students/teacher
identification = read_csv('identification.csv') %>% rename(gitlab_account = `What is your gitlab account?`) %>% select(-Time)
group_members = read_csv('group-members.csv') %>% rename(participant_group = group)

identified_presentations = left_join(
  presentations,
  inner_join(
    identification,
    group_members,
    by="gitlab_account"
  ),
  by=c("Participant")
)

# Some students evaluated their own group and I did not want to use such data.
presentations_no_selfgroup_eval = identified_presentations %>% filter(group != participant_group)

# Compute how many participants evaluated each group
participants_per_group = presentations_no_selfgroup_eval %>%
  group_by(group) %>%
  summarize(nb_participants = n_distinct(Participant)) %>%
  mutate(
    nb_participants_median = nb_participants/2,
    linetype = 'Median Opinion',
  )

# Data must be reshaped to fit what stacked bar charts expect
understanding_pivoted = presentations_no_selfgroup_eval %>% select(
  -`General opinion`,
  -`Presentation slides`,
  -`Oral communication`,
  -`Answers to the questions`
  ) %>% pivot_longer(cols=3:8, names_to="Question", values_to="Answer")

understanding_plot = understanding_pivoted %>% ggplot() +
    geom_bar(aes(Question, fill=Answer)) +
    facet_wrap(vars(group)) +
    geom_hline(data=participants_per_group, aes(yintercept=nb_participants_median, linetype=linetype)) +
    coord_flip() +
    theme_bw() +
    labs(x="", y="Number of partipants that have each opinion") +
    theme(legend.position="top", legend.title=element_blank())

quality_pivoted = presentations_no_selfgroup_eval %>% select(
  -`General principles of the vulnerability`,
  -`What systems are exposed?`,
  -`How to exploit it?`,
  -`How to detect if my system is exposed?`,
  -`How can I protect my system from it?`,
  -`How has it been fixed?`
  ) %>% pivot_longer(cols=3:6, names_to="Question", values_to="Answer")

quality_plot = quality_pivoted %>% ggplot() +
    geom_bar(aes(Question, fill=Answer)) +
    facet_wrap(vars(group)) +
    geom_hline(data=participants_per_group, aes(yintercept=nb_participants_median, linetype=linetype)) +
    coord_flip() +
    theme_bw() +
    labs(x="", y="Number of partipants that have each opinion") +
    theme(legend.position="top", legend.title=element_blank())

# Grade each group
group_grades = presentations_no_selfgroup_eval %>% mutate(
    grade = recode(`General opinion`,
      'Very bad' = 0,
      'Bad' = 6,
      'Good' = 14,
      'Very good' = 20
    )
  ) %>% group_by(group) %>% summarize(
    project_presentation_grade = round(mean(grade), digits=2)
  )
