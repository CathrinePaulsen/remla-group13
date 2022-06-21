from setuptools import find_packages, setup
from src.version import __version__

linter_requires = [
    'pylint==2.12.2',
    'dslinter==2.0.6'
]

tests_requires = [
    'pytest==7.1.2'
]

setup(
    name='src',
    packages=find_packages(),
    version=__version__,
    extras_require={
        'linter': linter_requires,
        'tests': tests_requires,
        'all': linter_requires + tests_requires
    }
)

