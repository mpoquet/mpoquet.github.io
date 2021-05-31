Why I use R (2019-03)
=====================

As I love programming and know many different languages,
people are often surprised — to be polite — that I use R_ to analyze and visualize data.

The goal of this post is to explain why.

1. `My personal history with R`_ — AKA why I avoided R like plague for long
2. `Main mistakes to avoid in R`_ — Quick list for those in a hurry
3. `Showcase`_ — Shows R's potential conciseness, tunability and visualization output quality
4. `Final word`_ — Shameful propaganda on why you should think about using R

My personal history with R
---------------------------

I have been confronted with R several times in college,
notably for statistics and machine learning classes.
These classes included an introduction to **programming** in R:
Concepts, syntax, data frames...
Here are the first impressions I had after such classes.

- WTF is this syntax?
- Is it really so slow? Some benchmarks highlighted crazy performance drop (50+ times slower than C).

My conclusion was simple at this time. **Programming in R? No way.**
I therefore used different technologies to analyze and visualize data for several years
such as Python's (pandas_ + matplotlib_), LaTeX's pgfplots_, gnuplot_, spreadsheet_...

But I completely changed my mind about R at the middle of my PhD.
The main reasons for me to go for R were the following.

- I needed to do a lot of data analysis and visualization at this time —
  I was trying to gain insight about the behavior of some algorithms.
- I felt that the technologies I used were limiting me.
  I was mostly using Python at this time.
  I felt that matplotlib_ was clearly too low-level for what I needed.
  pandas_ gave nice wrappers around matplotlib_ in simple cases,
  but tuning the visualization for advanced cases was tedious.
- A `wise man`_ told me
  "If you are **programming** in R, you are doing it wrong!
  R is not a programming language, R is a tool to analyze and visualize data.".
- A `R guru`_ showed me how **expressive**, **tunable** and **powerful**
  R can be with the proper packages (tidyverse_).
  He also showed me how great R visualizations can look.

Since then, I have been using R for most of my data analysis/visualization needs.

.. _main_mistakes_in_R:

Main mistakes to avoid in R
---------------------------

- **Programming in R.**
  R can be a great tool to modify data and to analyze it.
  But if you plan to compare your data to complex things —
  mmh, let's say, simulation data — do not implement your simulator in R.
- **Using vanilla R.**
  R without packages is not worth the language flaws.
  Especially, I think that without tidyverse_ I would not use R at all.
  I therefore recommend to learn R+tidyverse rather than R alone.

.. _R_showcase:

Showcase
--------

First, we need data to analyze and visualize.
I found a CC0_ dataset about Olympics results `there <https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results>`_,
let's talk about sports today.
I generated a `data subset </2019-03-why-r/athlete_events_subset.csv.gz>`__ and hosted it here to make things easy.
Fun fact: While the original data has been gathered in R,
I also used R to create a subset of the data with the following script.

.. literalinclude:: generate-data-subset.R
   :language: R
   :caption: :download:`generate-data-subset.R <generate-data-subset.R>`
   :lines: 21-

From now on, I'll assume that you have downloaded the
`data subset </2019-03-why-r/athlete_events_subset.csv.gz>`__
in your ``/tmp`` directory.
What I usually do first with data is to load it (thanks, captain obvious) then
to print a summary about it. Vanilla R is very straightforward about this.

.. literalinclude:: analyze-data.R
   :language: R
   :caption: :download:`analyze-data.R <analyze-data.R>`
   :lines: 10-12

And here is the output R printed.

.. code-block:: none

         ID                                               Name
   Min.   :   126   Marit Bjrgen                            :  19
   1st Qu.: 40736   Evi Sachenbacher-Stehle                 :  18
   Median : 71120   Macarena Mara Simari Birkner            :  18
   Mean   : 72159   Chimene Mary "Chemmy" Alcott (-Crawford):  17
   3rd Qu.:105484   Teja Gregorin                           :  17
   Max.   :135550   Andrea Henkel (-Burke)                  :  16
                    (Other)                                 :7104
      Sex               Age            Height        Weight
   Mode :logical   Min.   :14.00   Min.   :146   Min.   :38.00
   FALSE:7209      1st Qu.:22.00   1st Qu.:163   1st Qu.:55.00
                   Median :25.00   Median :167   Median :60.00
                   Mean   :25.25   Mean   :167   Mean   :60.46
                   3rd Qu.:28.00   3rd Qu.:171   3rd Qu.:65.00
                   Max.   :48.00   Max.   :194   Max.   :96.00
                                   NA's   :23    NA's   :143
              Team           NOC               Games           Year
   United States: 537   USA    : 576   2002 Winter:1582   Min.   :2002
   Canada       : 502   CAN    : 533   2006 Winter:1757   1st Qu.:2006
   Russia       : 460   RUS    : 491   2010 Winter:1847   Median :2010
   Germany      : 440   GER    : 468   2014 Winter:2023   Mean   :2008
   Italy        : 369   ITA    : 383                      3rd Qu.:2014
   Japan        : 343   JPN    : 343                      Max.   :2014
   (Other)      :4558   (Other):4415
      Season                 City                            Sport
   Winter:7209   Salt Lake City:1582   Cross Country Skiing     :1419
                 Sochi         :2023   Biathlon                 :1276
                 Torino        :1757   Alpine Skiing            :1122
                 Vancouver     :1847   Speed Skating            : 695
                                       Ice Hockey               : 634
                                       Short Track Speed Skating: 513
                                       (Other)                  :1550
                                          Event         Medal
   Ice Hockey Women's Ice Hockey             : 634   Bronze: 309
   Biathlon Women's 7.5 kilometres Sprint    : 329   Gold  : 315
   Biathlon Women's 15 kilometres            : 322   Silver: 309
   Alpine Skiing Women's Giant Slalom        : 305   NA's  :6276
   Alpine Skiing Women's Slalom              : 304
   Cross Country Skiing Women's 10 kilometres: 286
   (Other)                                   :5029

This summary is an amazing starting point! It directly shows different things.

- Many columns have discrete values (Medal, Sport...).
  You have a direct overview of the distribution of values for these columns.
- Many columns have numeric values (Weight, Year...).
  You have well-known descriptive statistics about each column.
  You can directly check that Years of study are between 2002 and 2014 for example.

Now that we know a little more about the data, we can directly start analyzing it.
This will be done thanks to tidyverse_ — dplyr_ to do usual data manipulations
and ggplot_ to do visualization.
**Question 1**: Globally, which countries have won the highest number of gold medals?
The following R code explicitly computes it.

.. literalinclude:: analyze-data.R
   :language: R
   :caption: :download:`analyze-data.R <analyze-data.R>`
   :lines: 13-24

.. code-block:: none

   # A tibble: 10 x 2
      Team          gold_count
      <fct>              <int>
    1 Canada                97
    2 Germany               37
    3 Russia                22
    4 South Korea           21
    5 Sweden                17
    6 Norway                16
    7 China                 13
    8 United States         12
    9 Netherlands           10
   10 Great Britain          7

Okay that's nice. But visualizing it should be even nicer.

.. literalinclude:: analyze-data.R
   :language: R
   :caption: :download:`analyze-data.R <analyze-data.R>`
   :lines: 25-30

.. image:: top-gold-countries-bc.png

Okay, we visualized something.
However, these operations may seem complex to obtain such a simple plot.
And indeed, the explicit computations can directly be done by ggplot in such cases.
The good thing with tidyverse_ is that doing way more complex plots does not require much more work
that what we did.
**Question 2**: Globally, how medals are distributed among the previous countries?

.. literalinclude:: analyze-data.R
   :language: R
   :caption: :download:`analyze-data.R <analyze-data.R>`
   :lines: 31-39

.. image:: top-medal-distribution.png

Okay, 7 lines to get such a plot!
**Question 3**: How did the distribution of medals evolved over time for the global top 4 countries?

.. literalinclude:: analyze-data.R
   :language: R
   :caption: :download:`analyze-data.R <analyze-data.R>`
   :lines: 40-51

.. image:: top-medals-over-time.png

Okay, code looks very similar but the output plot is very different.
Here, we changed the ggplot_ function
(``geom_line`` instead of ``geom_bar``, to get lines instead of bars) and told it to separate data in facets.
On the dplyr_ side, we told it to compute summaries per groups, just as we did in the first example.
Groups were just tuples of columns, instead of a single column.

Final word
----------

I hope this example showed how R_ + tidyverse_ allows to quickly analyze your
data and to visualize it how you desire.

Once familiar with dplyr_ and ggplot_, you can easily plot your data in similar
ways and start thinking about how to visualize your data in the best possible way.
Before switching to R_ + tidyverse_, I often resigned to keep the only solution
that I could make work after a reasonable amount of hours fighting against
hard-to-tune APIs — and I do believe this is what happened for many papers out there.

The API and data structures of the different libraries are consistent,
so you will not need to learn again what you already master.
Documentation of the different functions is quite good and filled with examples,
and finding an example close to what you want to achieve is usually straightforward
on sites similar to stackoverflow_.

This example focused on operations that are done all the time:
Filtering, grouping, sorting, computing summaries per group, plotting data,
plotting on different facets... tidyverse_ can do many other things,
such as reshaping your data (tidyr_), read data efficiency and safely
(readr_), have lots of fun with dates (lubridate_)...

.. _R: https://en.wikipedia.org/wiki/R_(programming_language)
.. _pgfplots: http://pgfplots.sourceforge.net/
.. _spreadsheet: https://www.libreoffice.org/discover/calc/
.. _gnuplot: http://www.gnuplot.info/
.. _matplotlib: https://matplotlib.org/
.. _pandas: https://pandas.pydata.org/
.. _wise man: http://mescal.imag.fr/membres/arnaud.legrand/
.. _R guru: http://www.inf.ufrgs.br/~schnorr/
.. _tidyverse: https://www.tidyverse.org/
.. _CC0: https://creativecommons.org/publicdomain/zero/1.0/
.. _ggplot: https://ggplot2.tidyverse.org/reference/ggplot.html
.. _dplyr: https://dplyr.tidyverse.org/reference/index.html
.. _tidyr: https://tidyr.tidyverse.org/
.. _readr: https://readr.tidyverse.org/
.. _lubridate: https://lubridate.tidyverse.org/
.. _stackoverflow: https://stackoverflow.com/
