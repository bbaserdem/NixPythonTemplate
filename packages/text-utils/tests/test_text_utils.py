"""Tests for text-utils package."""

import pytest
from text_utils import count_words, reverse_text, text_stats


def test_count_words():
    """Test word counting function."""
    assert count_words("hello world") == 2
    assert count_words("one") == 1
    assert count_words("") == 0
    assert count_words("  multiple   spaces  ") == 2


def test_reverse_text():
    """Test text reversal function."""
    assert reverse_text("hello") == "olleh"
    assert reverse_text("") == ""
    assert reverse_text("a") == "a"
    assert reverse_text("racecar") == "racecar"


def test_text_stats():
    """Test text statistics function (tests workspace dependency)."""
    stats = text_stats("hello world")
    assert stats["words"] == 2
    assert stats["chars"] == 11
    assert stats["total_units"] == 13  # 2 + 11, using math_utils.add

    stats = text_stats("")
    assert stats["words"] == 0
    assert stats["chars"] == 0
    assert stats["total_units"] == 0


def test_package_metadata():
    """Test package metadata."""
    from text_utils import __version__, __package_name__
    assert __version__ == "0.1.0"
    assert __package_name__ == "text-utils"


def test_workspace_dependency():
    """Test that workspace dependency is accessible."""
    from math_utils import add
    assert add(1, 2) == 3
