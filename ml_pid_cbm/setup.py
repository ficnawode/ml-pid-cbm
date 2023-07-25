from setuptools import setup, find_packages

setup(
    name='ml-pid-cbm',
    version='0.1.0',
    url='https://github.com/ficnawode/ml-pid-cbm.git',
    author='Tobiasz Fic',
    author_email='author@gmail.com',
    description='particle identification for the cbm experiment',
    packages=find_packages(),    
    install_requires=['numpy >= 1.11.1', 'matplotlib >= 1.5.1'],
)