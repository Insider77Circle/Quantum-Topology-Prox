#!/usr/bin/env python3
"""
Quantum Topology Proxy - Setup Script
Advanced traffic obfuscation using quantum-derived topological noise
"""

import os
import sys
from setuptools import setup, find_packages, Extension
from setuptools.command.build_ext import build_ext
import subprocess

# Read version from __init__.py
def get_version():
    """Extract version from __init__.py"""
    version_file = os.path.join('src', 'qtop', '__init__.py')
    if os.path.exists(version_file):
        with open(version_file, 'r') as f:
            for line in f:
                if line.startswith('__version__'):
                    return line.split('=')[1].strip().strip('"\'')
    return '0.1.0'

# Read long description from README
def get_long_description():
    """Read README for long description"""
    with open('README.md', 'r', encoding='utf-8') as f:
        return f.read()

# Read requirements
def get_requirements():
    """Read requirements from requirements.txt"""
    with open('requirements.txt', 'r') as f:
        return [line.strip() for line in f if line.strip() and not line.startswith('#')]

class CustomBuildExt(build_ext):
    """Custom build extension to compile C/Rust components"""
    
    def run(self):
        """Build C and Rust components"""
        # Build C library
        self.build_c_library()
        # Build Rust verifier
        self.build_rust_verifier()
        super().run()
    
    def build_c_library(self):
        """Build the C quantum cache library"""
        print("Building C quantum cache library...")
        try:
            subprocess.check_call([
                'gcc', '-shared', '-fPIC', '-O3',
                '-o', 'src/libquantum_cache.so',
                'src/quantum_cache.c',
                '-lm', '-lpthread'
            ])
            print("✅ C library built successfully")
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to build C library: {e}")
            sys.exit(1)
    
    def build_rust_verifier(self):
        """Build the Rust winding verifier"""
        print("Building Rust winding verifier...")
        try:
            subprocess.check_call([
                'cargo', 'build', '--release'
            ], cwd='src/verifier')
            print("✅ Rust verifier built successfully")
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to build Rust verifier: {e}")
            print("Make sure Rust is installed: https://rustup.rs/")
            sys.exit(1)

# C extension for performance-critical components
quantum_extension = Extension(
    'qtop._quantum',
    sources=['src/extensions/quantum_module.c'],
    include_dirs=['src/include'],
    libraries=['m', 'pthread'],
    extra_compile_args=['-O3', '-Wall', '-Wextra'],
)

setup(
    name='quantum-topology-proxy',
    version=get_version(),
    author='Insider77Circle',
    author_email='quantum-proxy@insider77circle.com',
    description='Quantum-seeded traffic obfuscator for defeating ML timing attacks',
    long_description=get_long_description(),
    long_description_content_type='text/markdown',
    url='https://github.com/Insider77Circle/quantum-topology-proxy',
    project_urls={
        'Bug Reports': 'https://github.com/Insider77Circle/quantum-topology-proxy/issues',
        'Source': 'https://github.com/Insider77Circle/quantum-topology-proxy',
        'Documentation': 'https://github.com/Insider77Circle/quantum-topology-proxy/wiki',
    },
    
    packages=find_packages(where='src'),
    package_dir={'': 'src'},
    
    ext_modules=[quantum_extension],
    cmdclass={'build_ext': CustomBuildExt},
    
    install_requires=get_requirements(),
    
    extras_require={
        'dev': [
            'pytest>=7.0.0',
            'pytest-asyncio>=0.18.0',
            'pytest-cov>=3.0.0',
            'black>=22.0.0',
            'flake8>=4.0.0',
            'mypy>=0.950',
            'pre-commit>=2.17.0',
        ],
        'docs': [
            'sphinx>=4.5.0',
            'sphinx-rtd-theme>=1.0.0',
            'sphinx-autodoc-typehints>=1.17.0',
        ],
        'benchmark': [
            'pytest-benchmark>=3.4.1',
            'memory-profiler>=0.60.0',
            'line-profiler>=3.5.1',
        ],
    },
    
    entry_points={
        'console_scripts': [
            'qtop=qtop.cli:main',
            'qtop-orchestrator=qtop.orchestrator:main',
            'qtop-verifier=qtop.verifier:main',
            'qtop-preload=qtop.preload:main',
        ],
    },
    
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'Intended Audience :: Telecommunications Industry',
        'Topic :: Internet :: Proxy Servers',
        'Topic :: Security :: Cryptography',
        'Topic :: System :: Networking',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Programming Language :: C',
        'Programming Language :: Rust',
        'Operating System :: POSIX :: Linux',
        'Operating System :: MacOS',
        'Framework :: AsyncIO',
        'Framework :: Pytest',
    ],
    
    keywords='quantum topology proxy tor privacy cybersecurity ml-resistance',
    
    python_requires='>=3.8',
    
    include_package_data=True,
    package_data={
        'qtop': [
            'configs/*.conf',
            'configs/*.yaml',
            'scripts/*.sh',
            'tests/data/*',
        ],
    },
    
    zip_safe=False,
)
