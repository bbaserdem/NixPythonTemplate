"""Integration tests for workspace packages."""

import pytest


def test_math_utils_import():
    """Test that math-utils package can be imported."""
    import math_utils
    assert math_utils is not None


def test_text_utils_import():
    """Test that text-utils package can be imported."""
    import text_utils
    assert text_utils is not None


def test_math_utils_cli():
    """Test that math-utils CLI is available."""
    from math_utils.cli import main
    assert callable(main)


def test_workspace_packages_interaction():
    """Test that workspace packages can work together."""
    from math_utils import add, multiply
    from text_utils import uppercase, lowercase
    
    # Test basic functionality
    assert add(2, 3) == 5
    assert multiply(2, 3) == 6
    assert uppercase("hello") == "HELLO"
    assert lowercase("WORLD") == "world"
    
    # Test combining results
    result = add(2, 3)
    text = f"Result is {result}"
    assert uppercase(text) == "RESULT IS 5"