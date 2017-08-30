from distutils.core import setup
from Cython.Build import cythonize
import numpy
setup(
  name = 'median de noise',
  ext_modules = cythonize("medianDeNoise.pyx"),
  include_dirs=[numpy.get_include()]
)
