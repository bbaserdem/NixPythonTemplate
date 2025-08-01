# Text Utils

Text processing utility functions with workspace dependency demonstration.

## Features

- Word counting
- Text reversal
- Text statistics (using math-utils workspace dependency)
- Type hints for better IDE support

## Usage

```python
from text_utils import count_words, reverse_text, text_stats

words = count_words("hello world")  # 2
reversed_text = reverse_text("hello")  # "olleh"
stats = text_stats("hello world")  # {"words": 2, "chars": 11, "total_units": 13}
```

## Dependencies

This package demonstrates workspace dependencies by depending on the `math-utils` package in the same workspace.
