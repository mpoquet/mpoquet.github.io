Isolated dynamic library loading with ``dlmopen``
=================================================

I am working on the Batsim_ simulator and want to add a feature in it.
My goal is to enable scheduling algorithms to be implemented as *good old* shared libraries (``.so`` ELF files) and to load them dynamically when the Batsim process starts (depending on command-line arguments).
Currently, scheduling algorithms must be implemented as separate processes that communicate with Batsim with a network protocol.

This led me to test whether loading several libraries in the same process was possible with the following constraints.

- Loaded libraries have a common C API, from which the main program (Batsim) will call them.
  The main program must be able to select a library instance and call functions from the common C API on it.
- Loaded libraries can have non-disjoint dynamic dependencies.
  For example, all loaded libraries can have a ``(NEEDED) libsomedependency.so`` in the dynamic section of their ELF files.
- Loaded libraries and the main program can have non-disjoint dynamic dependencies.
- All of loaded libraries, their dependencies,
  Batsim and its dependencies can have global variables.
  Global variables can be mutable.
- All global variables must be *privatized*
  so that each loaded library live in a separate *world* that have no side effect
  on other libraries nor with Batsim.

While reading ``man dlopen`` to search whether some flags enables this behavior,
I found dlmopen_ which looked like a perfect candidate so I tried it on a toy example.

Test setup
----------

All the code presented here is available on the `dlmopen-test`_ git repository.

This repository contains two shared libraries (compiled as ``.so`` ELF files)
and an executable program (also compiled into an ELF file, but with a ``main`` function to directly execute it).

- The ``base`` library.
- The ``user`` library, that uses the ``base`` library (dynamic link).
- The ``runner`` program, that uses the ``base`` library (dynamic link)
  and loads ``user`` libraries at runtime (via ``dlmopen``) depending on its command-line arguments.

A version number is given to all libraries/programs when they are compiled.
All compiled ELFs contain a function that **always** returns the version that was given to them at compile-time, and a global **mutable** variable that is initialized with the same value.

More precisely, the ELFs have the following symbols.

- ``base``: ``int base_version()`` function, ``int base_global_value`` variable.
- ``user``: ``int version()`` function, ``int global_value`` variable and ``char * fullname()`` that returns a dynamically allocated string that recaps information about a user.
- ``runner``: ``int version()`` function, ``int global_value`` variable and ``char * fullname()`` that returns a dynamically allocated string that recaps information about the runner.

The corresponding code is straightforward.

.. literalinclude:: base.c
   :language: c
   :caption: :download:`base.c <base.c>`

.. literalinclude:: user.c
   :language: c
   :caption: :download:`user.c <user.c>`

The build system (Meson_ here) defines ``VERSION`` at build-time.

.. literalinclude:: meson.build
   :language: text
   :lines: 1-6
   :emphasize-lines: 5
   :caption: Part of ``base``'s build definition (:download:`meson.build <meson.build>`)

Several instances of ``base`` and ``user`` are compiled with various ``VERSION`` values.

- ``base-0``, ``base-1`` and ``base-2`` with ``VERSION=x`` for ``base-x``.
- ``user-1`` with ``VERSION=1``, that uses ``base-1``.
- ``user-2`` with ``VERSION=2``, that uses ``base-2``.
- ``runner-0`` with ``VERSION=0``, that uses ``base-0``.

These various ELFs are compiled thanks to the Nix_ package manager.
Nix makes the definition of these combinations simple and makes sure that
all generated ELFs have fully defined dependencies.
As I write these lines, this is done by setting ``DT_RUNPATH`` in compiled ELFs so that
they load the right versions of their dependencies at runtime.
Here is the Nix code that describes these combinations.

.. literalinclude:: default.nix
   :language: nix
   :caption: :download:`default.nix <default.nix>`

Runner code
-----------

The runner full code is :download:`runner.c <runner.c>`.
It starts with the same code as in ``user``.

.. literalinclude:: runner.c
   :language: c
   :lines: 1-31
   :caption: :download:`runner.c <runner.c>`

It then defines a ``struct User`` that enables the runner to access the variables and functions of a ``user`` instance loaded in memory (via pointers and function pointers).

.. literalinclude:: runner.c
   :language: c
   :lines: 33-42
   :caption: :download:`runner.c <runner.c>`

The code to load a ``user`` into a ``struct User`` uses ``dlmopen`` and ``dlsym``.

.. literalinclude:: runner.c
   :language: c
   :lines: 44-78
   :emphasize-lines: 3, 13-14
   :caption: :download:`runner.c <runner.c>`

The rest of :download:`runner.c <runner.c>` defines a quick experiment to check whether ``dlmopen`` fits my need. First, the ``main`` function reads its command-line arguments (that are paths to ``user`` ELF files) and load all of them in memory.

.. literalinclude:: runner.c
   :language: c
   :lines: 80-96
   :emphasize-lines: 9, 12
   :caption: :download:`runner.c <runner.c>`

Then it prints the various values (by calling the ``fullname`` function from the ``runner``'s ELF itself or from ``user`` ELFs).

.. literalinclude:: runner.c
   :language: c
   :lines: 98-108
   :caption: :download:`runner.c <runner.c>`

During its execution, ``runner`` changes the values of all global variables to make sure the desired ones get updated (**and them only**).

.. literalinclude:: runner.c
   :language: c
   :lines: 110-117
   :caption: :download:`runner.c <runner.c>`

Printings are done at the following steps.

- At the ``main`` function's beginning (only for ``runner``).
- After all ``user`` ELFs have been loaded.
- After all global variables have been modified.
- At the ``main`` function's ending (only for ``runner``).

Does it work?
-------------

First, ``user`` ELFs can be compiled via ``nix-build`` commands.

.. literalinclude:: generate-elfs.bash
   :language: bash
   :caption: :download:`generate-elfs.bash <generate-elfs.bash>`

The following code loads ``user-1`` and ``user-2``.

.. literalinclude:: run-different-libs.bash
   :language: bash
   :caption: :download:`run-different-libs.bash <run-different-libs.bash>`

**Everything looks great in the output log :).**
All values are the expected one when the ``user`` ELFs are loaded,
and changing global variables had the expected outcome.

.. code-block:: text
   :caption: Output log of :download:`run-different-libs.bash <run-different-libs.bash>`

   runner fullname: my_glob='0', my_version=0, base_glob='0', base_version=0
   All users have been loaded.
   runner fullname: my_glob='0', my_version=0, base_glob='0', base_version=0
   user 0 fullname: my_glob='1', my_version=1, base_glob='1', base_version=1
   user 1 fullname: my_glob='2', my_version=2, base_glob='2', base_version=2
   Changing global values.
   Printing fullnames again.
   runner fullname: my_glob='42', my_version=0, base_glob='420', base_version=0
   user 0 fullname: my_glob='10', my_version=1, base_glob='100', base_version=1
   user 1 fullname: my_glob='20', my_version=2, base_glob='200', base_version=2
   Removing user libs from memory.
   runner fullname: my_glob='42', my_version=0, base_glob='420', base_version=0

And **everything also looks great when the exact same library is loaded twice :)**.
``user`` ELFs have independent global variable, and their ``base`` dependency too.

.. literalinclude:: run-same-lib.bash
   :language: bash
   :caption: :download:`run-same-lib.bash <run-same-lib.bash>`

.. code-block:: text
   :caption: Output log of :download:`run-same-lib.bash <run-same-lib.bash>`

   runner fullname: my_glob='0', my_version=0, base_glob='0', base_version=0
   All users have been loaded.
   runner fullname: my_glob='0', my_version=0, base_glob='0', base_version=0
   user 0 fullname: my_glob='1', my_version=1, base_glob='1', base_version=1
   user 1 fullname: my_glob='1', my_version=1, base_glob='1', base_version=1
   Changing global values.
   Printing fullnames again.
   runner fullname: my_glob='42', my_version=0, base_glob='420', base_version=0
   user 0 fullname: my_glob='10', my_version=1, base_glob='100', base_version=1
   user 1 fullname: my_glob='20', my_version=1, base_glob='200', base_version=1
   Removing user libs from memory.
   runner fullname: my_glob='42', my_version=0, base_glob='420', base_version=0

.. _Batsim: https://batsim.org
.. _dlmopen: https://man7.org/linux/man-pages/man3/dlmopen.3.html
.. _dlmopen-test: https://github.com/mpoquet/dlmopen-test
.. _Meson: https://mesonbuild.com/
.. _Nix: https://nixos.org/
