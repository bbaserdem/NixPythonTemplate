"""Tests for math-utils package."""

import pytest
from math_utils import add, multiply, fibonacci


def test_add():
    """Test addition function."""
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0.5, 0.25) == 0.75


def test_multiply():
    """Test multiplication function."""
    assert multiply(2, 3) == 6
    assert multiply(-2, 3) == -6
    assert multiply(0, 5) == 0


def test_fibonacci():
    """Test Fibonacci function."""
    assert fibonacci(0) == 0
    assert fibonacci(1) == 1
    assert fibonacci(5) == 5
    assert fibonacci(10) == 55


def test_package_metadata():
    """Test package metadata."""
    from math_utils import __version__, __package_name__
    assert __version__ == "0.1.0"
    assert __package_name__ == "math-utils"
