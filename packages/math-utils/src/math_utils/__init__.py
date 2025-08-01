"""Mathematical utility functions."""

__version__ = "0.1.0"
__package_name__ = "math-utils"

__all__ = [
    "add", 
    "multiply", 
    "fibonacci",
    "__version__", 
    "__package_name__",
]

def add(a: float, b: float) -> float:
    """Add two numbers."""
    return a + b

def multiply(a: float, b: float) -> float:
    """Multiply two numbers."""
    return a * b

def fibonacci(n: int) -> int:
    """Calculate the nth Fibonacci number."""
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
