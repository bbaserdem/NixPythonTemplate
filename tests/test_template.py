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
    
    # Test successful execution with no args
    result = main([])
    assert result == 0
    
    # Test with args
    result = main(["World"])
    assert result == 0


def test_main_with_workspace_packages():
    """Test that main function can use workspace packages."""
    from template.main import main
    
    # This will import and use math_utils and text_utils
    result = main(["Test User"])
    assert result == 0