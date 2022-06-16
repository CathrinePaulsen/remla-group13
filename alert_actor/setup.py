from setuptools import find_packages, setup


setup(
    name='alert_actor',
    version='1.0',
    description='Triggers blue-green traffic switching upon receiving alerts',
    packages=find_packages(),
    install_requires=['Flask==2.0.3'],
    entry_points={
        'console_scripts': [
            'alert_actor=alert_actor:main'
        ]
    }
)
