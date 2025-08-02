"""Main entry point for the template package."""

import sys
from typing import Optional


def main(argv: Optional[list[str]] = None) -> int:
    """Main entry point for the template package.
    
    Args:
        argv: Command line arguments (defaults to sys.argv[1:])
        
    Returns:
        Exit code (0 for success)
    """
    args = argv if argv is not None else sys.argv[1:]
    
    if not args:
        print("Hello from template!")
        print("\nThis is a Python project template with monorepo support.")
        print("It can handle both single packages and workspace packages.")
    else:
        name = " ".join(args)
        print(f"Hello, {name}!")
    
    # Import and use workspace packages to demonstrate integration
    from math_utils import add
    from text_utils import count_words
    
    print(f"\nDemo: 2 + 3 = {add(2, 3)}")
    print(f"Word count in greeting: {count_words(f'Hello {name if args else 'World'}')}")
    
    return 0


if __name__ == "__main__":
    sys.exit(main())