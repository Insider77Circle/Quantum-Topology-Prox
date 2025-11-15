# 🔌 Quantum Topology Proxy API Reference

## 📋 Table of Contents

- [Overview](#overview)
- [Python API](#python-api)
- [Rust API](#rust-api)
- [C API](#c-api)
- [Configuration API](#configuration-api)
- [Monitoring API](#monitoring-api)
- [CLI Commands](#cli-commands)
- [REST API](#rest-api)
- [WebSocket API](#websocket-api)

## 🎯 Overview

The Quantum Topology Proxy provides multiple APIs for different use cases:

- **🔧 Core APIs**: Python, Rust, and C libraries for integration
- **⚙️ Configuration**: YAML and JSON configuration formats
- **📊 Monitoring**: Prometheus metrics and health checks
- **🖥️ CLI**: Command-line interface for operations
- **🌐 REST**: HTTP API for remote management
- **🔌 WebSocket**: Real-time event streaming

## 🐍 Python API

### Core Classes

#### `QuantumTopologyProxy`

Main orchestrator class for managing the entire system.

```python
from qtop import QuantumTopologyProxy

# Initialize with configuration
proxy = QuantumTopologyProxy(
    config_path="/etc/qtop/qtop.conf",
    quantum_source="cisco_qapi",
    cache_size=1_000_000
)

# Start the proxy
proxy.start()

# Get status
status = proxy.get_status()
print(f"Active circuits: {status.active_circuits}")
print(f"Cache hits: {status.cache_hits}")
```

#### `QuantumCache`

Quantum randomness cache manager.

```python
from qtop.quantum import QuantumCache

# Create cache
cache = QuantumCache(size=1000000)

# Get quantum random value
random_value = cache.get_random()

# Get complex quantum amplitude
real, imag = cache.get_complex_amplitude()

# Pre-load seeds
cache.preload_seeds(source="cisco_qapi", count=1000000)
```

#### `TopologicalTimingEngine`

Computes quantum-topological delays.

```python
from qtop.timing import TopologicalTimingEngine

# Initialize engine
engine = TopologicalTimingEngine(
    winding_quantum=2 * math.pi,
    min_delay=0.1,  # milliseconds
    max_delay=10.0  # milliseconds
)

# Compute delay for packet
delay = engine.compute_delay(
    circuit_id=12345,
    packet_hash=0xabcdef123456
)

# Verify winding number
is_valid = engine.verify_winding(circuit_id, phase)
```

#### `TorCircuitController`

Manages Tor circuits with quantum enhancement.

```python
from qtop.tor import TorCircuitController

# Connect to Tor
controller = TorCircuitController(
    tor_port=9051,
    tor_password="your_password"
)

# Create quantum-enhanced circuit
circuit = controller.create_quantum_circuit(
    path_length=3,
    quantum_seed=0x1234567890abcdef
)

# Monitor circuit events
for event in controller.stream_events():
    if event.type == "CIRC":
        print(f"Circuit {event.id}: {event.status}")
```

### Utility Functions

#### `compute_packet_hash()`

Computes hash for packet identification.

```python
from qtop.utils import compute_packet_hash

# Hash packet data
packet_hash = compute_packet_hash(
    data=b"HTTP/1.1 GET /index.html",
    src_ip="192.168.1.100",
    dst_ip="10.0.0.1",
    src_port=54321,
    dst_port=80
)
```

#### `validate_quantum_randomness()`

Validates quality of quantum randomness.

```python
from qtop.quantum import validate_quantum_randomness

# Test randomness quality
is_valid = validate_quantum_randomness(
    values=quantum_values,
    min_entropy=0.99,
    max_bias=0.01
)
```

## 🦀 Rust API

### Core Structures

#### `WindingVerifier`

Topological invariant verifier.

```rust
use qtop_verifier::WindingVerifier;

// Create verifier
let verifier = WindingVerifier::new(VerifierConfig {
    check_interval: Duration::from_millis(100),
    tolerance: 1e-6,
    emergency_shutdown: true,
});

// Verify winding number
match verifier.verify_winding(circuit_id, phase) {
    Ok(()) => println!("Winding number valid"),
    Err(e) => println!("Winding violation: {}", e),
}

// Start monitoring
verifier.start_monitoring();
```

#### `QuantumState`

Manages quantum state for circuits.

```rust
use qtop_verifier::QuantumState;

// Create quantum state
let mut state = QuantumState::new(circuit_id);
state.update_phase(new_phase);
state.add_entropy(external_entropy);

// Get current phase
let current_phase = state.current_phase();

// Check validity
if state.is_valid() {
    // Process normally
} else {
    // Handle invalid state
}
```

#### `MetricsCollector`

Prometheus metrics collection.

```rust
use qtop_verifier::MetricsCollector;

// Create collector
let metrics = MetricsCollector::new("qtop_verifier");

// Record metrics
metrics.record_winding_check(circuit_id, duration);
metrics.record_violation(circuit_id, violation_type);
metrics.record_cache_hit();

// Export metrics
let prometheus_output = metrics.export_prometheus();
```

### Async API

#### `AsyncCircuitMonitor`

Real-time circuit monitoring.

```rust
use qtop_verifier::AsyncCircuitMonitor;
use tokio::stream::StreamExt;

#[tokio::main]
async fn main() -> Result<()> {
    let monitor = AsyncCircuitMonitor::new();
    let mut events = monitor.subscribe_events();
    
    while let Some(event) = events.next().await {
        match event {
            CircuitEvent::WindingViolation { circuit_id, phase } => {
                println!("Winding violation on circuit {}", circuit_id);
            }
            CircuitEvent::QuantumCacheExhausted => {
                println!("Quantum cache needs refill");
            }
            _ => {}
        }
    }
    
    Ok(())
}
```

## C API

### Library Initialization

```c
#include <qtop.h>

// Initialize qtop library
int result = qtop_init("/etc/qtop/qtop.conf");
if (result != 0) {
    fprintf(stderr, "Failed to initialize qtop: %s\n", 
            qtop_error_string(result));
    return 1;
}

// Set up quantum cache
qtop_quantum_cache_t* cache = qtop_quantum_cache_create(1000000);
qtop_quantum_cache_preload(cache, "cisco_qapi", "api_key_here");
```

### Timing Functions

```c
// Compute topological delay
double delay = qtop_compute_delay(
    circuit_id, 
    packet_hash, 
    current_time
);

// Verify winding number
int is_valid = qtop_verify_winding(circuit_id, phase);
if (!is_valid) {
    qtop_emergency_shutdown(circuit_id);
}
```

### Memory Management

```c
// Create circuit state
qtop_circuit_state_t* state = qtop_circuit_state_create(circuit_id);

// Update state
qtop_circuit_state_update(state, new_phase, timestamp);

// Clean up
qtop_circuit_state_destroy(state);
qtop_quantum_cache_destroy(cache);
qtop_cleanup();
```

## ⚙️ Configuration API

### YAML Configuration

```yaml
# qtop.conf
quantum:
  cache_size: 1000000
  api_endpoint: "https://quantum-api.cisco.com/v1"
  backup_source: "/dev/qrandom"
  prefetch_threshold: 0.1

timing:
  min_delay: 0.1        # milliseconds
  max_delay: 10.0       # milliseconds
  winding_quantum: 6.283185307179586  # 2π
  jitter_enabled: true
  jitter_factor: 0.1

verifier:
  check_interval: 100   # milliseconds
  tolerance: 1e-6
  emergency_shutdown: true
  prometheus_port: 9090

monitoring:
  enabled: true
  metrics_interval: 10  # seconds
  log_level: "INFO"
  log_file: "/var/log/qtop/qtop.log"
```

### JSON Configuration

```json
{
  "quantum": {
    "cache_size": 1000000,
    "api_endpoint": "https://quantum-api.cisco.com/v1",
    "backup_source": "/dev/qrandom",
    "sources": [
      {
        "name": "cisco_qapi",
        "type": "cloud",
        "priority": 1,
        "config": {
          "api_key": "${CISCO_QAPI_KEY}",
          "timeout": 30
        }
      },
      {
        "name": "local_qrng",
        "type": "hardware",
        "priority": 2,
        "config": {
          "device": "/dev/qrandom"
        }
      }
    ]
  },
  "timing": {
    "min_delay": 0.1,
    "max_delay": 10.0,
    "winding_quantum": 6.283185307179586,
    "algorithms": {
      "primary": "topological",
      "fallback": "cryptographic"
    }
  },
  "verifier": {
    "check_interval": 100,
    "tolerance": 1e-6,
    "emergency_shutdown": true,
    "alerting": {
      "webhook": "https://alerts.example.com/qtop",
      "email": "security@example.com"
    }
  }
}
```

### Environment Variables

```bash
# Quantum API configuration
export QTOP_QUANTUM_API_KEY="your_cisco_qapi_key"
export QTOP_QUANTUM_CACHE_SIZE="1000000"
export QTOP_QUANTUM_TIMEOUT="30"

# Timing configuration
export QTOP_TIMING_MIN_DELAY="0.1"
export QTOP_TIMING_MAX_DELAY="10.0"
export QTOP_TIMING_WINDING_QUANTUM="6.283185307179586"

# Verifier configuration
export QTOP_VERIFIER_CHECK_INTERVAL="100"
export QTOP_VERIFIER_TOLERANCE="1e-6"
export QTOP_VERIFIER_PROMETHEUS_PORT="9090"

# Monitoring configuration
export QTOP_MONITORING_LOG_LEVEL="INFO"
export QTOP_MONITORING_LOG_FILE="/var/log/qtop/qtop.log"
```

## 📊 Monitoring API

### Prometheus Metrics

```python
from qtop.monitoring import PrometheusMetrics

# Initialize metrics
metrics = PrometheusMetrics(port=9090)

# Record custom metrics
metrics.counter(
    name="qtop_custom_events_total",
    description="Total number of custom events",
    labels={"type": "winding_violation"}
).inc()

metrics.histogram(
    name="qtop_custom_delay_seconds",
    description="Custom delay measurements",
    buckets=[0.001, 0.005, 0.01, 0.05, 0.1]
).observe(delay_seconds)

# Start metrics server
metrics.start_server()
```

### Health Checks

```python
from qtop.monitoring import HealthChecker

# Create health checker
health = HealthChecker()

# Add custom health checks
@health.check("quantum_cache")
def check_quantum_cache():
    cache = QuantumCache()
    if cache.get_hit_rate() < 0.99:
        return False, "Cache hit rate too low"
    return True, "Cache healthy"

@health.check("winding_verifier")
def check_winding_verifier():
    verifier = WindingVerifier()
    if verifier.get_violation_count() > 100:
        return False, "Too many winding violations"
    return True, "Verifier healthy"

# Get health status
status = health.get_status()
if status.healthy:
    print("All systems operational")
else:
    for check in status.failed_checks:
        print(f"Failed: {check.name} - {check.message}")
```

## 🖥️ CLI Commands

### qtop - Main CLI

```bash
# Show version
qtop --version

# Start with configuration file
qtop --config /etc/qtop/qtop.conf

# Start with custom quantum source
qtop --quantum-source cisco_qapi --api-key YOUR_KEY

# Enable debug logging
qtop --log-level DEBUG --log-file /tmp/qtop.log

# Run in background
qtop --daemon --pid-file /var/run/qtop.pid

# Show current status
qtop status

# Stop running instance
qtop stop
```

### qtop-orchestrator - Orchestrator CLI

```bash
# Start orchestrator
qtop-orchestrator --port 8080 --config /etc/qtop/orchestrator.yaml

# Show connected nodes
qtop-orchestrator --list-nodes

# Add new node
qtop-orchestrator --add-node node3.example.com:8080

# Remove node
qtop-orchestrator --remove-node node3.example.com:8080

# Show cluster status
qtop-orchestrator --cluster-status

# Trigger circuit redistribution
qtop-orchestrator --rebalance
```

### qtop-verifier - Verifier CLI

```bash
# Start verifier
qtop-verifier --monitor --port 9090

# Run verification check
qtop-verifier --check-circuit 12345

# Show verification statistics
qtop-verifier --stats

# Export metrics
qtop-verifier --export-metrics prometheus

# Run in audit mode
qtop-verifier --audit --input-file circuits.log

# Emergency shutdown
qtop-verifier --emergency-shutdown --circuit 12345
```

### qtop-preload - Preload CLI

```bash
# Preload quantum seeds
qtop-preload --source cisco_qapi --count 1000000 --api-key YOUR_KEY

# Preload from file
qtop-preload --source file --input-file quantum_seeds.bin

# Preload with custom cache size
qtop-preload --cache-size 2000000 --output-file cache.qcache

# Verify preloaded cache
qtop-preload --verify --cache-file cache.qcache

# Show cache statistics
qtop-preload --stats --cache-file cache.qcache
```

## 🌐 REST API

### API Endpoints

#### GET /api/v1/status

Get system status.

```bash
curl -X GET http://localhost:8080/api/v1/status
```

Response:
```json
{
  "status": "healthy",
  "version": "0.1.0",
  "uptime": 3600,
  "active_circuits": 42,
  "cache_hit_rate": 0.998,
  "total_packets": 1234567,
  "quantum_seeds_remaining": 987654
}
```

#### GET /api/v1/circuits

List active circuits.

```bash
curl -X GET http://localhost:8080/api/v1/circuits
```

Response:
```json
{
  "circuits": [
    {
      "id": 12345,
      "state": "active",
      "path": ["relay1", "relay2", "relay3"],
      "quantum_seed": 987654321,
      "winding_violations": 0,
      "packets_processed": 1234,
      "created_at": "2025-01-15T10:30:00Z"
    }
  ],
  "total": 42
}
```

#### POST /api/v1/circuits

Create new circuit.

```bash
curl -X POST http://localhost:8080/api/v1/circuits \
  -H "Content-Type: application/json" \
  -d '{
    "path_length": 3,
    "quantum_seed": 123456789,
    "timeout": 60
  }'
```

#### DELETE /api/v1/circuits/{id}

Close specific circuit.

```bash
curl -X DELETE http://localhost:8080/api/v1/circuits/12345
```

#### GET /api/v1/metrics

Get Prometheus metrics.

```bash
curl -X GET http://localhost:8080/api/v1/metrics
```

#### GET /api/v1/health

Health check endpoint.

```bash
curl -X GET http://localhost:8080/api/v1/health
```

Response:
```json
{
  "status": "healthy",
  "checks": {
    "quantum_cache": "healthy",
    "winding_verifier": "healthy",
    "tor_connection": "healthy"
  },
  "timestamp": "2025-01-15T10:30:00Z"
}
```

## 🔌 WebSocket API

### Connection

```javascript
const ws = new WebSocket('ws://localhost:8080/api/v1/events');

ws.onopen = function() {
  console.log('Connected to qtop events');
  
  // Subscribe to events
  ws.send(JSON.stringify({
    action: 'subscribe',
    events: ['circuit_created', 'winding_violation', 'cache_exhausted']
  }));
};

ws.onmessage = function(event) {
  const data = JSON.parse(event.data);
  console.log('Event received:', data);
};

ws.onerror = function(error) {
  console.error('WebSocket error:', error);
};
```

### Event Types

#### circuit_created

```json
{
  "event": "circuit_created",
  "data": {
    "circuit_id": 12345,
    "path": ["relay1", "relay2", "relay3"],
    "quantum_seed": 987654321,
    "timestamp": "2025-01-15T10:30:00Z"
  }
}
```

#### winding_violation

```json
{
  "event": "winding_violation",
  "data": {
    "circuit_id": 12345,
    "expected_winding": 3,
    "actual_winding": 3.14159,
    "severity": "high",
    "timestamp": "2025-01-15T10:30:00Z"
  }
}
```

#### cache_exhausted

```json
{
  "event": "cache_exhausted",
  "data": {
    "remaining_seeds": 100,
    "threshold": 1000,
    "timestamp": "2025-01-15T10:30:00Z"
  }
}
```

## 📚 Examples

### Complete Python Example

```python
#!/usr/bin/env python3
"""
Complete example of using qtop Python API
"""

import asyncio
import logging
from qtop import QuantumTopologyProxy
from qtop.quantum import QuantumCache
from qtop.timing import TopologicalTimingEngine
from qtop.tor import TorCircuitController
from qtop.monitoring import PrometheusMetrics, HealthChecker

async def main():
    # Set up logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    # Initialize components
    logger.info("Initializing qtop components...")
    
    # Quantum cache
    cache = QuantumCache(size=100000)
    await cache.preload_seeds_async(source="cisco_qapi", api_key="your_key")
    
    # Timing engine
    timing_engine = TopologicalTimingEngine(
        min_delay=0.1,
        max_delay=10.0,
        winding_quantum=2 * 3.14159
    )
    
    # Tor controller
    tor_controller = TorCircuitController(tor_port=9051)
    await tor_controller.connect()
    
    # Metrics
    metrics = PrometheusMetrics(port=9090)
    metrics.start_server()
    
    # Health checker
    health = HealthChecker()
    
    @health.check("quantum_cache")
    def check_cache():
        hit_rate = cache.get_hit_rate()
        if hit_rate < 0.99:
            return False, f"Cache hit rate too low: {hit_rate}"
        return True, f"Cache healthy: {hit_rate} hit rate"
    
    # Main processing loop
    logger.info("Starting main processing loop...")
    
    packet_count = 0
    try:
        async for packet in tor_controller.stream_packets():
            packet_count += 1
            
            # Compute packet hash
            packet_hash = hash(packet.data)
            
            # Get quantum delay
            delay = timing_engine.compute_delay(
                circuit_id=packet.circuit_id,
                packet_hash=packet_hash
            )
            
            # Apply delay
            await asyncio.sleep(delay / 1000)  # Convert to seconds
            
            # Record metrics
            metrics.histogram(
                name="qtop_packet_delay_ms",
                description="Packet processing delay"
            ).observe(delay)
            
            # Log progress
            if packet_count % 1000 == 0:
                logger.info(f"Processed {packet_count} packets")
                
    except KeyboardInterrupt:
        logger.info("Shutting down...")
    finally:
        # Cleanup
        await tor_controller.disconnect()
        metrics.stop_server()
        
        # Final status
        status = health.get_status()
        logger.info(f"Final health status: {status.healthy}")
        logger.info(f"Cache hit rate: {cache.get_hit_rate()}")
        logger.info(f"Total packets processed: {packet_count}")

if __name__ == "__main__":
    asyncio.run(main())
```

### Complete Rust Example

```rust
use qtop_verifier::{WindingVerifier, QuantumState, MetricsCollector};
use tokio::time::{sleep, Duration};
use std::error::Error;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    // Initialize verifier
    let verifier = WindingVerifier::new(Default::default());
    
    // Initialize metrics
    let metrics = MetricsCollector::new("qtop_example");
    
    // Test circuit
    let circuit_id = 12345u64;
    let mut state = QuantumState::new(circuit_id);
    
    println!("Starting qtop verifier example...");
    
    // Simulate circuit operation
    for i in 0..100 {
        // Update quantum phase
        let new_phase = (i as f64) * 0.1;
        state.update_phase(new_phase);
        
        // Verify winding number
        match verifier.verify_winding(circuit_id, new_phase) {
            Ok(()) => {
                println!("✅ Circuit {} winding valid: {}", circuit_id, new_phase);
                metrics.counter("winding_checks_passed").inc();
            }
            Err(e) => {
                println!("❌ Circuit {} winding violation: {}", circuit_id, e);
                metrics.counter("winding_checks_failed").inc();
                
                // Emergency shutdown on violation
                if verifier.config().emergency_shutdown {
                    println!("🚨 Emergency shutdown triggered!");
                    break;
                }
            }
        }
        
        // Record metrics
        metrics.gauge("current_phase").set(new_phase);
        metrics.gauge("circuit_id").set(circuit_id as f64);
        
        // Small delay
        sleep(Duration::from_millis(10)).await;
    }
    
    // Export final metrics
    let prometheus_output = metrics.export_prometheus();
    println!("\nFinal metrics:\n{}", prometheus_output);
    
    Ok(())
}
```

This comprehensive API reference covers all the interfaces available in Quantum Topology Proxy, from low-level C APIs to high-level Python and Rust interfaces, configuration options, monitoring capabilities, and complete usage examples.
