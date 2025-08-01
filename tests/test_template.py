"""Tests for the template package."""

import pytest
from template import __package_name__, __version__


def test_package_name():
    """Test that package name is set correctly."""
    assert __package_name__ == "template"


def test_version():
    """Test that version is set."""
    assert isinstance(__version__, str)
    assert len(__version__) > 0


def test_main_import():
    """Test that main module can be imported."""
    from template.main import main
    assert callable(main)


def test_main_function():
    """Test that main function returns correct exit code."""
    from template.main import main
    
    # Test successful execution with simple args
    result = main(["World"])
    assert result == 0
