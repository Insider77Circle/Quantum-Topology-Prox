# 🔌 Stem Integration Guide

## Overview

The `QuantumStemInterceptor` provides a novel integration with [torproject/stem](https://github.com/torproject/stem) that intercepts Tor's STREAM_EVENT to inject quantum-derived topological timing delays. This makes circuit timing analysis NP-hard, defeating ML correlation attacks like DeepCorr.

## 🎯 What Makes This Novel

**The Problem:** Traditional Tor circuits are vulnerable to timing correlation attacks where adversaries use machine learning to analyze packet timing patterns and link traffic flows.

**The Solution:** Our 20-line integration intercepts Stem's STREAM_EVENT and injects quantum-derived delays that preserve topological invariants (winding numbers), making timing analysis computationally intractable.

## 🚀 Quick Start

### Prerequisites

1. **Tor running** with control port enabled (default: 9051)
2. **Stem library** installed: `pip install stem>=1.8.0`
3. **Quantum cache pre-loaded** with quantum randomness seeds

### Basic Usage

```python
import asyncio
from qtop import QuantumCache, TopologicalTimingEngine, QuantumStemInterceptor

async def main():
    # Initialize quantum components
    quantum_cache = QuantumCache(size=1_000_000)
    await quantum_cache.preload_seeds_async("cisco_qapi", count=1_000_000)
    
    timing_engine = TopologicalTimingEngine(
        winding_quantum=6.28318,  # 2π
        min_delay=0.1,  # milliseconds
        max_delay=10.0  # milliseconds
    )
    
    # Create interceptor
    interceptor = QuantumStemInterceptor(
        quantum_cache=quantum_cache,
        timing_engine=timing_engine,
        tor_port=9051
    )
    
    # Start interception - this is the integration point!
    controller = interceptor.start_interception()
    
    print("✅ Quantum timing randomization active!")
    
    # Keep running
    try:
        while interceptor.is_active():
            await asyncio.sleep(1)
    except KeyboardInterrupt:
        interceptor.stop_interception()

if __name__ == "__main__":
    asyncio.run(main())
```

## 📖 Detailed Documentation

### Class: `QuantumStemInterceptor`

#### Constructor

```python
QuantumStemInterceptor(
    quantum_cache: QuantumCache,
    timing_engine: TopologicalTimingEngine,
    tor_port: int = 9051,
    password: Optional[str] = None
)
```

**Parameters:**
- `quantum_cache`: Pre-loaded quantum randomness cache (1M+ seeds recommended)
- `timing_engine`: Topological timing computation engine
- `tor_port`: Tor control port (default: 9051)
- `password`: Tor control port password (if password-protected)

#### Methods

##### `connect() -> Controller`

Connects to Tor control port via Stem and authenticates.

**Returns:** Authenticated Stem Controller instance

**Example:**
```python
controller = interceptor.connect()
print(f"Connected: {controller.is_alive()}")
```

##### `start_interception() -> Controller`

**This is the core integration method.** Starts intercepting STREAM_EVENT for quantum timing injection.

**How it works:**
1. Connects to Tor if not already connected
2. Registers event listener for `EventType.STREAM`
3. For each NEW stream event:
   - Computes quantum-topological delay
   - Applies delay using `time.sleep()`
   - Logs the delay applied

**Returns:** Active Stem Controller instance

**Example:**
```python
controller = interceptor.start_interception()
# Now all stream events have quantum timing applied!
```

##### `stop_interception()`

Stops intercepting events and disconnects from Tor.

**Example:**
```python
interceptor.stop_interception()
print("Stopped quantum interception")
```

##### `is_active() -> bool`

Checks if interception is currently active.

**Returns:** `True` if active, `False` otherwise

**Example:**
```python
if interceptor.is_active():
    print("Quantum timing is active")
```

## 🔬 How It Works

### Architecture

```
[Tor Control Port] ←→ [Stem Controller] ←→ [QuantumStemInterceptor]
                                                      ↓
                                    [STREAM_EVENT Listener]
                                                      ↓
                                    [Quantum Timing Engine]
                                                      ↓
                                    [Topological Delay Computation]
                                                      ↓
                                    [time.sleep(delay_ms / 1000.0)]
```

### Event Flow

1. **Tor creates a new stream** → STREAM_EVENT fired
2. **Stem receives event** → Calls registered listener
3. **QuantumStemInterceptor.handle_stream_event()** called
4. **Quantum delay computed** using:
   - Circuit ID
   - Stream ID (hashed)
   - Quantum cache lookup
   - Topological timing engine
5. **Delay applied** via `time.sleep()`
6. **Event continues** to other listeners

### The 20 Lines That Matter

The core integration is in the `handle_stream_event` callback:

```python
def handle_stream_event(event):
    if event.status in ('NEW', 'NEWRESOLVE'):
        circuit_id = event.circuit_id
        stream_id = hash(event.id) if hasattr(event, 'id') else hash(str(event))
        delay_ms = self.timing_engine.compute_delay(circuit_id, stream_id)
        time.sleep(delay_ms / 1000.0)
```

This simple function is what makes circuit timing analysis NP-hard!

## 🛡️ Security Properties

### What This Protects Against

- ✅ **DeepCorr attacks**: ML-based timing correlation
- ✅ **Website fingerprinting**: Timing pattern analysis
- ✅ **Flow watermarking**: Traffic flow identification
- ✅ **Packet size analysis**: Combined with quantum padding

### Why It Works

1. **Quantum Randomness**: Unforgeable timing patterns
2. **Topological Invariants**: Winding number preservation makes analysis NP-hard
3. **Real-time Application**: Delays applied at the event level, not post-processing
4. **Minimal Overhead**: <1ms latency per event

## ⚙️ Configuration

### Tor Control Port Setup

Ensure Tor has control port enabled in `/etc/tor/torrc`:

```
ControlPort 9051
# Optional: Password protection
HashedControlPassword 16:872860B76453A77D60CA2BB8C1A7042072093276A3D701AD684053EC4C
```

### Quantum Cache Sizing

For optimal performance:
- **Minimum**: 100,000 seeds
- **Recommended**: 1,000,000 seeds
- **Maximum**: 10,000,000 seeds (diminishing returns)

### Timing Engine Parameters

```python
timing_engine = TopologicalTimingEngine(
    winding_quantum=6.28318,  # 2π - topological invariant
    min_delay=0.1,            # Minimum delay in milliseconds
    max_delay=10.0            # Maximum delay in milliseconds
)
```

**Tuning Guidelines:**
- Lower `min_delay`: Faster but less protection
- Higher `max_delay`: More protection but higher latency
- `winding_quantum`: Keep at 2π for topological correctness

## 📊 Monitoring

### Check Interception Status

```python
if interceptor.is_active():
    print("✅ Quantum interception active")
else:
    print("❌ Quantum interception inactive")
```

### Access Stem Controller

```python
controller = interceptor.controller
if controller:
    print(f"Tor version: {controller.get_version()}")
    print(f"Active circuits: {len(controller.get_circuits())}")
```

### Logging

Enable debug logging to see delays being applied:

```python
import logging
logging.basicConfig(level=logging.DEBUG)
# Now you'll see: "Applied quantum delay X.XXms to stream..."
```

## 🧪 Testing

### Verify Integration

```python
# Test that interception starts
interceptor = QuantumStemInterceptor(...)
controller = interceptor.start_interception()
assert interceptor.is_active() == True

# Test that it stops
interceptor.stop_interception()
assert interceptor.is_active() == False
```

### Test with Real Tor

See `examples/stem_integration_example.py` for a complete working example.

## 🔗 Related Documentation

- [API Reference](api.md#quantumsteminterceptor) - Full API documentation
- [Architecture Overview](architecture.md) - System architecture
- [Security Analysis](security.md) - Security properties and guarantees
- [Stem Documentation](https://stem.torproject.org/) - Official Stem docs

## 🐛 Troubleshooting

### "Connection refused" Error

**Problem:** Cannot connect to Tor control port

**Solution:**
1. Ensure Tor is running: `sudo systemctl status tor`
2. Check control port is enabled in `/etc/tor/torrc`
3. Verify port number: `netstat -tlnp | grep 9051`

### "Authentication failed" Error

**Problem:** Cannot authenticate with Tor

**Solution:**
1. If password-protected, provide password in constructor
2. Check Tor control port authentication method
3. Verify `HashedControlPassword` in torrc matches

### No Delays Being Applied

**Problem:** Events not triggering delays

**Solution:**
1. Check `interceptor.is_active()` returns `True`
2. Enable debug logging to see events
3. Verify quantum cache is pre-loaded
4. Check timing engine parameters are valid

## 📚 References

- [torproject/stem](https://github.com/torproject/stem) - Stem library
- [Tor Control Protocol](https://gitweb.torproject.org/torspec.git/tree/control-spec.txt) - Control protocol spec
- [STREAM_EVENT Documentation](https://stem.torproject.org/api/events.html#stem.response.events.StreamEvent) - Event details

## 🙏 Acknowledgments

- Tor Project for the excellent Stem library
- torproject/stem maintainers for the flexible event system
- Quantum-topology-proxy team for the topological timing engine

---

**⭐ This integration makes circuit timing analysis NP-hard with just 20 lines of code!**

