# 🤝 Contributing to Quantum Topology Proxy

Thank you for your interest in contributing to **Quantum Topology Proxy (qtop)**! This project represents cutting-edge research in quantum-enhanced cybersecurity, and we welcome contributions from the community.

## 🌟 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)
- [Security Issues](#security-issues)
- [Community](#community)

## 📜 Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:

- **Be respectful** and inclusive to all contributors
- **Welcome newcomers** and help them get started
- **Focus on constructive criticism** and solutions
- **Respect differing viewpoints** and experiences
- **Prioritize community benefit** over personal gain

## 🚀 Getting Started

### Prerequisites

- **Python 3.8+** with pip
- **Rust 1.70+** (install via [rustup](https://rustup.rs/))
- **GCC** or compatible C compiler
- **Git** for version control
- **Tor** and **ProxyChains-NG** for testing

### Quick Start

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/quantum-topology-proxy.git
   cd quantum-topology-proxy
   ```
3. **Set up development environment**:
   ```bash
   make install-dev
   ```
4. **Run tests** to ensure everything works:
   ```bash
   make test
   ```

## 🔧 Development Setup

### Using Make (Recommended)

```bash
# Install all dependencies and set up development environment
make install-dev

# Activate virtual environment
source venv/bin/activate

# Run tests
make test

# Format code
make format

# Run linting
make lint
```

### Manual Setup

```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt
pip install -e .[dev,docs,benchmark]

# Build C and Rust components
make build

# Verify installation
qtop --version
qtop-verifier --version
```

## 🎯 How to Contribute

### Types of Contributions

- **🐛 Bug Reports**: Found something broken? Let us know!
- **💡 Feature Requests**: Have an idea for improvement?
- **📝 Documentation**: Help improve our docs
- **🔧 Code Contributions**: Submit bug fixes or new features
- **⚡ Performance**: Optimize existing code
- **🔒 Security**: Report vulnerabilities or security improvements
- **🧪 Testing**: Add test cases or improve test coverage

### Contribution Workflow

1. **Create an issue** first to discuss your proposed changes
2. **Fork the repository** and create a feature branch
3. **Make your changes** following our coding standards
4. **Add tests** for new functionality
5. **Update documentation** as needed
6. **Submit a pull request** with a clear description

## 📝 Coding Standards

### Python Code Style

We follow **PEP 8** with some additional guidelines:

```python
# Use type hints
def compute_delay(circuit_id: int, packet_hash: int) -> float:
    """Compute quantum topological delay.
    
    Args:
        circuit_id: Unique circuit identifier
        packet_hash: Packet hash for randomness
        
    Returns:
        Delay in milliseconds
        
    Raises:
        ValueError: If circuit_id is invalid
    """
    if circuit_id < 0:
        raise ValueError("Circuit ID must be non-negative")
    
    # Implementation here
    return delay

# Use black formatting
# Use isort for imports
# Use mypy for type checking
```

### Rust Code Style

We follow **Rust RFC style** guidelines:

```rust
/// Quantum winding number verifier
/// 
/// # Examples
/// ```
/// let verifier = WindingVerifier::new();
/// assert!(verifier.check_invariant(3.14159));
/// ```
pub struct WindingVerifier {
    /// Cache of computed winding numbers
    cache: DashMap<u64, f64>,
}

impl WindingVerifier {
    /// Create a new verifier instance
    pub fn new() -> Self {
        Self {
            cache: DashMap::new(),
        }
    }
}
```

### C Code Style

We use **Linux kernel style** for C code:

```c
/*
 * Quantum cache manager - Provides O(1) quantum seed lookup
 * Copyright (C) 2025 Quantum Topology Proxy Project
 */

#include <stdint.h>
#include <stdlib.h>

/**
 * preload_quantum_seeds() - Pre-load quantum seeds from API
 * @api_key: Cisco QAPI key
 * @count: Number of seeds to load
 * 
 * Return: 0 on success, negative error code on failure
 */
int preload_quantum_seeds(const char *api_key, size_t count)
{
    if (!api_key || count == 0)
        return -EINVAL;
        
    /* Implementation */
    return 0;
}
```

## 🧪 Testing Guidelines

### Test Structure

```
tests/
├── python/           # Python unit tests
├── rust/            # Rust unit tests
├── integration/     # Integration tests
├── benchmark/       # Performance benchmarks
└── security/        # Security tests
```

### Writing Tests

**Python Tests:**
```python
import pytest
from qtop.quantum import QuantumCache

class TestQuantumCache:
    def test_cache_initialization(self):
        """Test quantum cache initialization"""
        cache = QuantumCache(size=1000)
        assert cache.size == 1000
        assert cache.hits == 0
        
    def test_quantum_randomness(self):
        """Test quantum randomness quality"""
        cache = QuantumCache()
        values = [cache.get_random() for _ in range(1000)]
        # Test statistical properties
        assert abs(sum(values) / len(values)) < 0.1
```

**Rust Tests:**
```rust
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_winding_number_calculation() {
        let verifier = WindingVerifier::new();
        let phase = std::f64::consts::PI;
        assert!(verifier.check_winding(phase).is_ok());
    }
    
    #[test]
    fn test_constant_time_execution() {
        // Ensure no timing side channels
        let start = std::time::Instant::now();
        // ... operation ...
        let duration = start.elapsed();
        assert!(duration.as_nanos() < 1000); // < 1μs
    }
}
```

### Running Tests

```bash
# Run all tests
make test

# Run specific test suites
make test-python
make test-rust
make test-integration

# Run with coverage
make test && coverage report

# Run benchmarks
make benchmark

# Run security tests
make audit
```

## 🔄 Pull Request Process

### Before Submitting

1. **Sync with main branch**:
   ```bash
   git fetch upstream
   git checkout main
   git merge upstream/main
   ```

2. **Create feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make atomic commits** with clear messages:
   ```bash
   git commit -m "feat: add quantum cache prefetching
   
   - Implement predictive cache loading
   - Add configuration options
   - Update documentation"
   ```

### PR Requirements

- ✅ **Descriptive title** and detailed description
- ✅ **Tests** for new functionality
- ✅ **Documentation** updates
- ✅ **No breaking changes** (or clearly documented)
- ✅ **All CI checks** passing
- ✅ **Signed commits** (recommended)

### PR Template

```markdown
## 📝 Description
Brief description of changes

## 🔗 Related Issues
Closes #123

## 🧪 Testing
- [ ] Unit tests added
- [ ] Integration tests pass
- [ ] Manual testing completed

## 📋 Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] No breaking changes

## 🎯 Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Security enhancement
```

## 🐛 Issue Reporting

### Bug Reports

Use this template for bug reports:

```markdown
## 🐛 Bug Description
Clear description of the bug

## 🔄 Steps to Reproduce
1. Step one
2. Step two
3. Step three

## ✅ Expected Behavior
What should have happened

## ❌ Actual Behavior
What actually happened

## 📋 Environment
- OS: [e.g., Ubuntu 22.04]
- Python version: [e.g., 3.11.0]
- Rust version: [e.g., 1.70.0]
- qtop version: [e.g., 0.1.0]

## 📎 Additional Context
Any other relevant information
```

### Feature Requests

```markdown
## 💡 Feature Description
Clear description of the proposed feature

## 🎯 Use Case
Why is this feature needed?

## 🔧 Proposed Solution
How should it work?

## 🔄 Alternatives Considered
Other approaches considered

## 📋 Additional Context
Any other relevant information
```

## 🔒 Security Issues

**DO NOT** report security vulnerabilities publicly!

Instead:
1. **Email us directly**: security@quantum-proxy.org
2. **Use GitHub Security Advisories**: Create a private security advisory
3. **Include detailed information**: Steps to reproduce, impact assessment, proposed fix

We follow **responsible disclosure** and will work with you to address issues promptly.

## 👥 Community

### Communication Channels

- **💬 GitHub Discussions**: For questions and general discussion
- **🐛 GitHub Issues**: For bug reports and feature requests
- **📧 Mailing List**: quantum-proxy-dev@googlegroups.com
- **💼 LinkedIn**: [Quantum Topology Proxy](https://linkedin.com/company/quantum-topology-proxy)

### Regular Meetings

- **Weekly Dev Call**: Thursdays 2PM UTC (Discord)
- **Monthly Community Call**: First Monday of each month
- **Security Review**: Bi-weekly on Wednesdays

### Recognition

Contributors are recognized in:
- **README.md** contributors section
- **Release notes** for significant contributions
- **Annual contributor awards**
- **Conference presentations** (with permission)

## 📚 Additional Resources

### Development Documentation

- [Architecture Overview](docs/architecture.md)
- [API Reference](docs/api.md)
- [Security Guidelines](docs/security.md)
- [Performance Guide](docs/performance.md)
- [Deployment Guide](docs/deployment.md)

### External Resources

- [Tor Project Documentation](https://2019.www.torproject.org/docs/)
- [Rust Security Guidelines](https://rust-lang.org/policies/security)
- [Python Security Best Practices](https://python.org/dev/security/)
- [Quantum Cryptography Resources](https://quantum-computing.ibm.com/)

## 🙏 Thank You!

Your contributions make **Quantum Topology Proxy** better for everyone. Whether it's a small documentation fix or a major feature implementation, every contribution is valued and appreciated.

**Happy coding!** 🚀

---

*This contributing guide is licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)*
