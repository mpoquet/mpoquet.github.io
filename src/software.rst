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
It emerged from the desire to conduct sounder experiments to assess platform-level resource management algorithms,
and the desire to bridge the gap between theory and practice in this context.

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

`SimGrid <http://simgrid.gforge.inria.fr/>`__ is a simulation toolkit to study distributed systems.
As SimGrid is the simulation core used by Batsim,
I work on SimGrid on a regular basis (mostly around simulation models issues and bugs when many SimGrid features are used together).

I worked on `Remote SimGrid <https://framagit.org/simgrid/remote-simgrid/>`__ during a postdoc in 2018-2019.
This project enables the use of SimGrid with a **simulation** code split between several processes.
This is done thanks to a server-client architecture, where the server has a SimGrid simulation instance in memory,
and where clients trigger remote actions on the server.
Remote SimGrid is intended as a core tool to **emulate** the execution distributed applications with SimGrid:
real application code is executed on real processes, but the distributed platform they run on is simulated.
The most direct use case for Remote SimGrid is the deterministic execution of distributed application test scenarios.
In the very long run, it could be a base for model-checking distributed applications with SimGrid's model checker.

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
