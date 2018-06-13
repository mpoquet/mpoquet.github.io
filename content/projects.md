---
title: "Projects"
date: 2017-12-22T20:18:38+01:00
draft: false
---

This page presents some of the projects I work on.  
As this page is non-exhaustive and very likely outdated,
feel free to give a look at my
[GitHub](https://github.com/mpoquet) and
[Inria's Gitlab](https://gitlab.inria.fr/mpoquet) pages.

## Batsim
Batsim is a simulator that allows to study resource management policies.  
It emerged from the desire to conduct sounder experiments to assess
platform-level resource management algorithms, and the desire to bridge
the gap between theory and practice at this context.

The first prototypes have been developed by Olivier Richard.  
I then quickly became the main Batsim developer during my PhD
in the Datamove (ex MOAIS) team.  

Links:

- Batsim repositories — [GitHub](https://github.com/oar-team/batsim) /
  [Inria's Gitlab](https://gitlab.inria.fr/batsim/batsim) /
  [GRICAD's Gitlab (CI)](https://gricad-gitlab.univ-grenoble-alpes.fr/batsim/batsim)
- Initial paper — [hal-01333471v1](https://hal.archives-ouvertes.fr/hal-01333471v1)
- My [thesis manuscript](/research/phd/manuscript.pdf) (notably chapters 3 and 4)

Notable related projects :

- [batexpe](https://gitlab.inria.fr/batsim/batexpe): Tools to manage the
  execution of Batsim simulations. Written in Go.
- [batsched](https://gitlab.inria.fr/batsim/batsched): Scheduling
  algorithms for Batsim and
  [WRENCH](http://wrench-project.org/). Written in C++.

## SimGrid
[SimGrid](http://simgrid.gforge.inria.fr/)
is a simulation toolkit to study distributed systems.

I used SimGrid during my PhD and conducted minor modifications to it.

My postdoc aims at improving the debugging functionalities of SimGrid,
notably by allowing to start a simulation from a real world application
checkpoint. To this end, I also work on
[Remote SimGrid](https://github.com/simgrid/remote-simgrid), which allows to
run SimGrid simulations with several (Unix) processes.

## netorcai
[netorcai](https://github.com/mpoquet/netorcai) is a network *server* to
manage artificial intelligence games.

The idea here is to see the game logic (the component in charge of managing
the game state) as a separate entity from the network orchestrator (the component in charge of managing the different clients).
This is great for separation of concerns, as with such architecture developing
a new game no longer requires to develop a robust network server — which
typically takes more time than developing the game itself.
