.. _installation:

Installation
============

.. contents::
    :local:
    :depth: 1

Install from Conda
------------------

.. warning::

   TODO: Prepare Conda package.

Install from GitHub
-------------------

Check out code from the wrf-bc-extractor GitHub repo and start the installation:

.. code-block:: console

   $ git clone https://github.com/zequihg50/wrf_bc_extractor.git
   $ cd wrf_bc_extractor

Create Conda environment named `wrf_bc_extractor`:

.. code-block:: console

   $ conda env create -f environment.yml
   $ source activate wrf_bc_extractor

Install wrf-bc-extractor app:

.. code-block:: console

  $ pip install -e .
  OR
  make install

For development you can use this command:

.. code-block:: console

  $ pip install -e .[dev]
  OR
  $ make develop

Start wrf-bc-extractor PyWPS service
------------------------------------

After successful installation you can start the service using the ``wrf_bc_extractor`` command-line.

.. code-block:: console

   $ wrf_bc_extractor --help # show help
   $ wrf_bc_extractor start  # start service with default configuration

   OR

   $ wrf_bc_extractor start --daemon # start service as daemon
   loading configuration
   forked process id: 42

The deployed WPS service is by default available on:

http://localhost:5000/wps?service=WPS&version=1.0.0&request=GetCapabilities.

.. NOTE:: Remember the process ID (PID) so you can stop the service with ``kill PID``.

You can find which process uses a given port using the following command (here for port 5000):

.. code-block:: console

   $ netstat -nlp | grep :5000


Check the log files for errors:

.. code-block:: console

   $ tail -f  pywps.log

... or do it the lazy way
+++++++++++++++++++++++++

You can also use the ``Makefile`` to start and stop the service:

.. code-block:: console

  $ make start
  $ make status
  $ tail -f pywps.log
  $ make stop


Run wrf-bc-extractor as Docker container
----------------------------------------

You can also run wrf-bc-extractor as a Docker container.

.. warning::

  TODO: Describe Docker container support.

Use Ansible to deploy wrf-bc-extractor on your System
-----------------------------------------------------

Use the `Ansible playbook`_ for PyWPS to deploy wrf-bc-extractor on your system.


.. _Ansible playbook: http://ansible-wps-playbook.readthedocs.io/en/latest/index.html
