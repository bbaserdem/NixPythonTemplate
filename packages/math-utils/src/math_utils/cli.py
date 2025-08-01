"""Command-line interface for math-utils."""

import argparse
import sys
from . import add, multiply, fibonacci, __version__


def main() -> None:
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        description="Mathematical utility calculator",
        prog="math-calc"
    )
    parser.add_argument("--version", action="version", version=f"math-utils {__version__}")
    
    subparsers = parser.add_subparsers(dest="command", help="Available commands")
    
    # Add command
    add_parser = subparsers.add_parser("add", help="Add two numbers")
    add_parser.add_argument("a", type=float, help="First number")
    add_parser.add_argument("b", type=float, help="Second number")
    
    # Multiply command
    mul_parser = subparsers.add_parser("multiply", help="Multiply two numbers")
    mul_parser.add_argument("a", type=float, help="First number")
    mul_parser.add_argument("b", type=float, help="Second number")
    
    # Fibonacci command
    fib_parser = subparsers.add_parser("fibonacci", help="Calculate Fibonacci number")
    fib_parser.add_argument("n", type=int, help="Fibonacci index (non-negative integer)")
    
    args = parser.parse_args()
    
    if args.command == "add":
        result = add(args.a, args.b)
        print(f"{args.a} + {args.b} = {result}")
    elif args.command == "multiply":
        result = multiply(args.a, args.b)
        print(f"{args.a} × {args.b} = {result}")
    elif args.command == "fibonacci":
        if args.n < 0:
            print("Error: Fibonacci index must be non-negative", file=sys.stderr)
            sys.exit(1)
        result = fibonacci(args.n)
        print(f"fibonacci({args.n}) = {result}")
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
