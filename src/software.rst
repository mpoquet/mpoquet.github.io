Software
========

This page presents some of the software projects I work on.
Please refer to the following links for up-to-date information.

- `my GitHub account <https://github.com/mpoquet>`__
- `my Framagit account <https://framagit.org/mpoquet>`__
- `my Inria’s Gitlab account <https://gitlab.inria.fr/mpoquet>`__

Batsim
------

Batsim is a simulator that focuses on the study of resource management policies in distributed systems.
It emerged from the desire to conduct sounder experiments to assess
platform-level resource management algorithms,
and the desire tobridge the gap between theory and practice at this context.

The first prototypes have been developed by Olivier Richard.
I then quickly became the main Batsim developer during my PhD in the Datamove (ex MOAIS) team.

- Batsim repositories (
  `GitHub <https://github.com/oar-team/batsim>`__
  `Framagit <https://framagit.org/batsim/batsim>`__
  `Inria’s Gitlab <https://gitlab.inria.fr/batsim/batsim>`__
  ).
- Initial paper `HAL <https://hal.archives-ouvertes.fr/hal-01333471v1>`__
- My `PhD thesis manuscript <./2017-phd-manuscript.pdf>`__ (notably chapters 3 and 4)

A software ecosystem exists around Batsim. Here are some notable projects:

- `batexpe <https://gitlab.inria.fr/batsim/batexpe>`__
  Tools to manage the execution of Batsim simulations. Written in Go.
- `batsched <https://gitlab.inria.fr/batsim/batsched>`__
  Scheduling algorithms for Batsim and `WRENCH <http://wrench-project.org/>`__.
  Written in C++.
- `evalys <https://github.com/oar-team/evalys>`__
  Tools for visualization and analysis of resource management traces.
  Written in Python.


SimGrid
-------

`SimGrid <http://simgrid.gforge.inria.fr/>`__ is a simulation toolkit to
study distributed systems.

I used SimGrid during my PhD and conducted minor modifications to it.

My postdoc aims at improving the debugging functionalities of SimGrid,
notably by allowing to start a simulation from a real world application
checkpoint. To this end, I also work on `Remote
SimGrid <https://github.com/simgrid/remote-simgrid>`__, which allows to
run SimGrid simulations with several (Unix) processes.

netorcai
--------

`netorcai <https://github.com/mpoquet/netorcai>`__ is a network *server*
to manage artificial intelligence games.

The idea here is to see the game logic (the component in charge of
managing the game state) as a separate entity from the network
orchestrator (the component in charge of managing the different
clients). This is great for separation of concerns, as with such
architecture developing a new game no longer requires to develop a
robust network server — which typically takes more time than developing
the game itself.

The server is in Go and many client libraries are available
(C++, D, Fortran, Java, Python).
