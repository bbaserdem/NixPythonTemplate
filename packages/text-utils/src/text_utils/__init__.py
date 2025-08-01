"""Text processing utility functions."""

from math_utils import add  # Workspace dependency

__version__ = "0.1.0"
__package_name__ = "text-utils"

__all__ = [
    "count_words", 
    "reverse_text", 
    "text_stats",
    "__version__", 
    "__package_name__",
]

def count_words(text: str) -> int:
    """Count the number of words in text."""
    return len(text.split())

def reverse_text(text: str) -> str:
    """Reverse the given text."""
    return text[::-1]

def text_stats(text: str) -> dict[str, int]:
    """Get statistics about the text using workspace dependency."""
    words = count_words(text)
    chars = len(text)
    # Use math-utils function to demonstrate workspace dependency
    total_units = add(words, chars)
    
    return {
        "words": words,
        "chars": chars,
        "total_units": total_units,
    }
