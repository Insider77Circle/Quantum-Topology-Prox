# Quantum Topology Proxy - Makefile
# Advanced traffic obfuscation with quantum-derived topological noise

# Configuration
PYTHON := python3
PIP := pip3
CARGO := cargo
GCC := gcc
RUSTC := rustc

# Directories
SRC_DIR := src
BUILD_DIR := build
TARGET_DIR := target
DIST_DIR := dist
DOCS_DIR := docs
TESTS_DIR := tests
CONFIGS_DIR := configs
SCRIPTS_DIR := scripts

# Build artifacts
C_LIB := $(SRC_DIR)/libquantum_cache.so
RUST_BIN := $(TARGET_DIR)/release/qtop-verifier
PYTHON_PKG := $(DIST_DIR)/quantum_topology_proxy-*.whl

# Python virtual environment
VENV := venv
VENV_BIN := $(VENV)/bin
VENV_PYTHON := $(VENV_BIN)/python
VENV_PIP := $(VENV_BIN)/pip

# Default target
.PHONY: all
all: check-deps build test

# Check dependencies
.PHONY: check-deps
check-deps:
	@echo "🔍 Checking dependencies..."
	@command -v $(PYTHON) >/dev/null 2>&1 || { echo "❌ Python 3 not found"; exit 1; }
	@command -v $(CARGO) >/dev/null 2>&1 || { echo "❌ Cargo not found. Install Rust: https://rustup.rs/"; exit 1; }
	@command -v $(GCC) >/dev/null 2>&1 || { echo "❌ GCC not found"; exit 1; }
	@echo "✅ All dependencies found"

# Create virtual environment
.PHONY: venv
venv:
	@echo "🐍 Creating Python virtual environment..."
	$(PYTHON) -m venv $(VENV)
	$(VENV_PIP) install --upgrade pip setuptools wheel
	$(VENV_PIP) install -r requirements.txt
	@echo "✅ Virtual environment created. Activate with: source $(VENV_BIN)/activate"

# Build C library
.PHONY: build-c
build-c: $(C_LIB)

$(C_LIB): $(SRC_DIR)/quantum_cache.c
	@echo "🔨 Building C quantum cache library..."
	mkdir -p $(BUILD_DIR)
	$(GCC) -shared -fPIC -O3 -Wall -Wextra \
		-o $@ $< \
		-lm -lpthread
	@echo "✅ C library built: $@"

# Build Rust components
.PHONY: build-rust
build-rust: $(RUST_BIN)

$(RUST_BIN): src/verifier/Cargo.toml src/verifier/src/*.rs
	@echo "🦀 Building Rust verifier..."
	cd src/verifier && $(CARGO) build --release
	@echo "✅ Rust verifier built: $@"

# Build Python package
.PHONY: build-python
build-python: $(PYTHON_PKG)

$(PYTHON_PKG): setup.py $(SRC_DIR)/qtop/*.py
	@echo "📦 Building Python package..."
	mkdir -p $(DIST_DIR)
	$(PYTHON) setup.py bdist_wheel
	@echo "✅ Python package built: $@"

# Build everything
.PHONY: build
build: build-c build-rust build-python
	@echo "🚀 Build complete!"

# Install in development mode
.PHONY: install-dev
install-dev: venv
	@echo "🔧 Installing in development mode..."
	$(VENV_PIP) install -e .
	$(VENV_PIP) install -e .[dev,docs,benchmark]
	@echo "✅ Development installation complete"

# Run tests
.PHONY: test
test: test-python test-rust test-integration

.PHONY: test-python
test-python: venv
	@echo "🧪 Running Python tests..."
	$(VENV_PYTHON) -m pytest $(TESTS_DIR)/python/ -v --cov=qtop --cov-report=html
	@echo "✅ Python tests complete"

.PHONY: test-rust
test-rust:
	@echo "🧪 Running Rust tests..."
	cd src/verifier && $(CARGO) test --release
	@echo "✅ Rust tests complete"

.PHONY: test-integration
test-integration: venv
	@echo "🔗 Running integration tests..."
	$(VENV_PYTHON) -m pytest $(TESTS_DIR)/integration/ -v
	@echo "✅ Integration tests complete"

# Run benchmarks
.PHONY: benchmark
benchmark: benchmark-python benchmark-rust

.PHONY: benchmark-python
benchmark-python: venv
	@echo "⚡ Running Python benchmarks..."
	$(VENV_PYTHON) -m pytest $(TESTS_DIR)/benchmark/ --benchmark-only --benchmark-autosave
	@echo "✅ Python benchmarks complete"

.PHONY: benchmark-rust
benchmark-rust:
	@echo "⚡ Running Rust benchmarks..."
	cd src/verifier && $(CARGO) bench
	@echo "✅ Rust benchmarks complete"

# Security audit
.PHONY: audit
audit: audit-python audit-rust

.PHONY: audit-python
audit-python: venv
	@echo "🔒 Running Python security audit..."
	$(VENV_PIP) install safety bandit
	$(VENV_BIN)/safety check
	$(VENV_BIN)/bandit -r $(SRC_DIR)/qtop/
	@echo "✅ Python security audit complete"

.PHONY: audit-rust
audit-rust:
	@echo "🔒 Running Rust security audit..."
	cd src/verifier && $(CARGO) audit
	@echo "✅ Rust security audit complete"

# Code formatting
.PHONY: format
format: format-python format-rust

.PHONY: format-python
format-python: venv
	@echo "💅 Formatting Python code..."
	$(VENV_PIP) install black isort
	$(VENV_BIN)/black $(SRC_DIR)/qtop/ $(TESTS_DIR)/python/
	$(VENV_BIN)/isort $(SRC_DIR)/qtop/ $(TESTS_DIR)/python/
	@echo "✅ Python formatting complete"

.PHONY: format-rust
format-rust:
	@echo "💅 Formatting Rust code..."
	cd src/verifier && $(CARGO) fmt
	@echo "✅ Rust formatting complete"

# Linting
.PHONY: lint
lint: lint-python lint-rust

.PHONY: lint-python
lint-python: venv
	@echo "🔍 Linting Python code..."
	$(VENV_PIP) install flake8 mypy
	$(VENV_BIN)/flake8 $(SRC_DIR)/qtop/ $(TESTS_DIR)/python/
	$(VENV_BIN)/mypy $(SRC_DIR)/qtop/
	@echo "✅ Python linting complete"

.PHONY: lint-rust
lint-rust:
	@echo "🔍 Linting Rust code..."
	cd src/verifier && $(CARGO) clippy -- -D warnings
	@echo "✅ Rust linting complete"

# Generate documentation
.PHONY: docs
docs: docs-python docs-rust

.PHONY: docs-python
docs-python: venv
	@echo "📚 Generating Python documentation..."
	$(VENV_PIP) install sphinx sphinx-rtd-theme
	cd $(DOCS_DIR) && $(VENV_BIN)/sphinx-build -b html . _build
	@echo "✅ Python documentation generated"

.PHONY: docs-rust
docs-rust:
	@echo "📚 Generating Rust documentation..."
	cd src/verifier && $(CARGO) doc --no-deps --open
	@echo "✅ Rust documentation generated"

# Clean build artifacts
.PHONY: clean
clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf $(BUILD_DIR) $(TARGET_DIR) $(DIST_DIR) $(VENV)
	rm -f $(C_LIB) $(SRC_DIR)/qtop/*.so $(SRC_DIR)/qtop/*.pyd
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.coverage" -delete
	rm -rf htmlcov/ .coverage .pytest_cache/
	cd src/verifier && $(CARGO) clean
	@echo "✅ Clean complete"

# Install system dependencies
.PHONY: install-deps
install-deps:
	@echo "📦 Installing system dependencies..."
	sudo apt-get update
	sudo apt-get install -y build-essential gcc make cmake
	sudo apt-get install -y python3-dev python3-pip
	sudo apt-get install -y tor proxychains-ng
	sudo apt-get install -y pkg-config libssl-dev
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	source ~/.cargo/env
	@echo "✅ System dependencies installed"

# Docker build
.PHONY: docker-build
docker-build:
	@echo "🐳 Building Docker image..."
	docker build -t quantum-topology-proxy:latest .
	@echo "✅ Docker image built"

# Docker run
.PHONY: docker-run
docker-run:
	@echo "🐳 Running Docker container..."
	docker run -it --rm \
		--network host \
		-v $(PWD)/configs:/app/configs \
		quantum-topology-proxy:latest
	@echo "✅ Docker container stopped"

# Pre-commit hooks
.PHONY: pre-commit
pre-commit: venv
	@echo "🔧 Running pre-commit hooks..."
	$(VENV_PIP) install pre-commit
	$(VENV_BIN)/pre-commit run --all-files
	@echo "✅ Pre-commit hooks complete"

# Release build
.PHONY: release
release: clean test audit
	@echo "🚀 Building release artifacts..."
	$(PYTHON) setup.py sdist bdist_wheel
	cd src/verifier && $(CARGO) build --release
	@echo "✅ Release build complete"

# Install from source
.PHONY: install
install: build
	@echo "📦 Installing quantum-topology-proxy..."
	$(PIP) install $(PYTHON_PKG)
	cp $(RUST_BIN) /usr/local/bin/
	cp $(C_LIB) /usr/local/lib/
	ldconfig
	@echo "✅ Installation complete"

# Uninstall
.PHONY: uninstall
uninstall:
	@echo "🗑️ Uninstalling quantum-topology-proxy..."
	$(PIP) uninstall -y quantum-topology-proxy
	rm -f /usr/local/bin/qtop-verifier
	rm -f /usr/local/lib/libquantum_cache.so
	@echo "✅ Uninstallation complete"

# Help
.PHONY: help
help:
	@echo "🎯 Quantum Topology Proxy - Makefile Targets"
	@echo ""
	@echo "Setup & Build:"
	@echo "  make all          - Check deps, build, and test"
	@echo "  make venv         - Create Python virtual environment"
	@echo "  make build        - Build all components"
	@echo "  make install-dev  - Install in development mode"
	@echo ""
	@echo "Testing & Quality:"
	@echo "  make test         - Run all tests"
	@echo "  make benchmark    - Run performance benchmarks"
	@echo "  make audit        - Run security audits"
	@echo "  make format       - Format code"
	@echo "  make lint         - Lint code"
	@echo ""
	@echo "Documentation:"
	@echo "  make docs         - Generate documentation"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make install-deps - Install system dependencies"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-build - Build Docker image"
	@echo "  make docker-run   - Run Docker container"
	@echo ""
	@echo "Release:"
	@echo "  make release      - Build release artifacts"
	@echo "  make install      - Install from source"
	@echo "  make uninstall    - Uninstall"
	@echo ""
	@echo "Help:"
	@echo "  make help         - Show this help message"

# Default target when no target specified
.DEFAULT_GOAL := help
