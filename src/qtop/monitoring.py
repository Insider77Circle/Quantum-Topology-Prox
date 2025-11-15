"""
Monitoring and metrics collection for qtop
"""

import logging
import time
from typing import Dict, Callable, Any, Optional
from dataclasses import dataclass, field

logger = logging.getLogger(__name__)

@dataclass
class HealthCheckResult:
    """Result of a health check"""
    name: str
    healthy: bool
    message: str
    timestamp: float = field(default_factory=time.time)

@dataclass
class HealthStatus:
    """Overall health status"""
    healthy: bool
    checks: Dict[str, HealthCheckResult]
    timestamp: float = field(default_factory=time.time)

class PrometheusMetrics:
    """Prometheus metrics collector"""
    
    def __init__(self, port: int = 9090):
        self.port = port
        self._counters: Dict[str, int] = {}
        self._gauges: Dict[str, float] = {}
        self._histograms: Dict[str, list] = {}
        self._running = False
        
    def start_server(self) -> None:
        """Start Prometheus metrics server"""
        logger.info(f"Starting Prometheus metrics server on port {self.port}")
        self._running = True
        # Placeholder - would implement actual HTTP server
    
    def stop_server(self) -> None:
        """Stop Prometheus metrics server"""
        logger.info("Stopping Prometheus metrics server")
        self._running = False
    
    def counter(self, name: str, description: str = "", labels: Optional[Dict[str, str]] = None):
        """Get or create a counter metric"""
        if name not in self._counters:
            self._counters[name] = 0
        return CounterMetric(self._counters, name)
    
    def gauge(self, name: str, description: str = "", labels: Optional[Dict[str, str]] = None):
        """Get or create a gauge metric"""
        if name not in self._gauges:
            self._gauges[name] = 0.0
        return GaugeMetric(self._gauges, name)
    
    def histogram(self, name: str, description: str = "", buckets: Optional[list] = None):
        """Get or create a histogram metric"""
        if name not in self._histograms:
            self._histograms[name] = []
        return HistogramMetric(self._histograms, name)
    
    def record_packet_processed(self, circuit_id: int, delay_ms: float) -> None:
        """Record packet processing metrics"""
        self.counter("qtop_packets_processed_total").inc()
        self.gauge("qtop_active_circuits").set(circuit_id)
        self.histogram("qtop_packet_delay_ms").observe(delay_ms)

class CounterMetric:
    """Prometheus counter metric"""
    
    def __init__(self, counters: Dict[str, int], name: str):
        self.counters = counters
        self.name = name
    
    def inc(self, amount: int = 1) -> None:
        """Increment counter"""
        self.counters[self.name] += amount
    
    def get(self) -> int:
        """Get current value"""
        return self.counters.get(self.name, 0)

class GaugeMetric:
    """Prometheus gauge metric"""
    
    def __init__(self, gauges: Dict[str, float], name: str):
        self.gauges = gauges
        self.name = name
    
    def set(self, value: float) -> None:
        """Set gauge value"""
        self.gauges[self.name] = value
    
    def get(self) -> float:
        """Get current value"""
        return self.gauges.get(self.name, 0.0)
    
    def inc(self, amount: float = 1.0) -> None:
        """Increment gauge"""
        self.gauges[self.name] = self.get() + amount
    
    def dec(self, amount: float = 1.0) -> None:
        """Decrement gauge"""
        self.gauges[self.name] = self.get() - amount

class HistogramMetric:
    """Prometheus histogram metric"""
    
    def __init__(self, histograms: Dict[str, list], name: str):
        self.histograms = histograms
        self.name = name
    
    def observe(self, value: float) -> None:
        """Observe a value"""
        self.histograms[self.name].append(value)

class HealthChecker:
    """Health check system"""
    
    def __init__(self):
        self._checks: Dict[str, Callable] = {}
        self._results: Dict[str, HealthCheckResult] = {}
    
    def check(self, name: str):
        """Decorator to register a health check"""
        def decorator(func: Callable) -> Callable:
            self._checks[name] = func
            return func
        return decorator
    
    def get_status(self) -> HealthStatus:
        """Get overall health status"""
        self._run_checks()
        
        all_healthy = all(result.healthy for result in self._results.values())
        
        return HealthStatus(
            healthy=all_healthy,
            checks=self._results.copy()
        )
    
    def _run_checks(self) -> None:
        """Run all registered health checks"""
        for name, check_func in self._checks.items():
            try:
                healthy, message = check_func()
                self._results[name] = HealthCheckResult(
                    name=name,
                    healthy=healthy,
                    message=message
                )
            except Exception as e:
                logger.error(f"Health check '{name}' failed: {e}")
                self._results[name] = HealthCheckResult(
                    name=name,
                    healthy=False,
                    message=f"Check failed: {e}"
                )
