#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""The setup script."""

import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
README = open(os.path.join(here, 'README.rst')).read()
CHANGES = open(os.path.join(here, 'CHANGES.rst')).read()

about = {}
with open(os.path.join(here, 'wrf_bc_extractor', '__version__.py'), 'r') as f:
    exec(f.read(), about)

reqs = [line.strip() for line in open('requirements.txt')]
dev_reqs = [line.strip() for line in open('requirements_dev.txt')]

classifiers = [
    'Development Status :: 3 - Alpha',
    'Intended Audience :: Developers',
    'Intended Audience :: Science/Research',
    'Operating System :: MacOS :: MacOS X',
    'Operating System :: POSIX',
    'Programming Language :: Python',
    'Natural Language :: English',
    'Programming Language :: Python :: 3',
    'Programming Language :: Python :: 3.5',
    'Programming Language :: Python :: 3.6',
    'Programming Language :: Python :: 3.7',
    'Topic :: Scientific/Engineering :: Atmospheric Science',
    'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
]

setup(name='wrf_bc_extractor',
      version=about['__version__'],
      description="A WPS for WRF model boundary conditions extraction",
      long_description=README + '\n\n' + CHANGES,
      author=about['__author__'],
      author_email=about['__email__'],
      url='https://github.com/zequihg50/wrf_bc_extractor',
      classifiers=classifiers,
      license="GNU General Public License v3",
      keywords='wps pywps birdhouse wrf_bc_extractor',
      packages=find_packages(),
      include_package_data=True,
      install_requires=reqs,
      extras_require={
          "dev": dev_reqs,              # pip install ".[dev]"
      },
      entry_points={
          'console_scripts': [
              'wrf_bc_extractor=wrf_bc_extractor.cli:cli',
          ]},)
