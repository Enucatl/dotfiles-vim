---
name: python-code
description: Apply standard uv-based packaging, development, testing, and container conventions whenever a task involves Python code, including Python components in mixed-language repositories.
---

# Python Code

Apply these conventions to the Python portions of any repository, whether Python is the whole project or one component of a larger codebase. Do not impose Python tooling or layout on non-Python portions. Follow explicit project or user requirements when they differ.

## Project structure and packaging

- Use a `src/` layout by default when adding a Python package or component.
- Make Python code a valid package, including an importable package under `src/` with package metadata in `pyproject.toml`.
- Use `pyproject.toml` for project metadata, dependencies, build configuration, and tool configuration. Do not introduce `requirements.txt`.
- For pure-Python packages, use `uv_build` as the build backend. Choose another backend only when native extensions or an explicit project requirement makes `uv_build` unsuitable.
- Use type annotations for function and method arguments and return values whenever possible.
- Add Google-style docstrings to all functions, methods, and classes. Use `"""` delimiters, a one-line summary of at most 80 characters ending in punctuation, then an optional blank line and useful detail about behavior and semantics rather than implementation.
- For functions and methods, use `Args:` with each parameter name and description, `Returns:` for meaningful return values, `Yields:` for generators, and `Raises:` for exceptions relevant to the public interface. Omit sections that do not apply or are already clear from the signature and summary.
- For classes, describe what the instance represents and document public attributes in an `Attributes:` section. Describe decorated functions and classes by their behavior after decoration; an overriding method may rely on its base-class docstring when explicitly marked with `@override` and it adds no behavior-specific detail.

## Dependencies and Docker

- Use `uv` as the project and dependency manager.
- When an HTTP client is needed, prefer `niquests` and avoid adding `httpx` or `requests` unless compatibility or an explicit project requirement makes them necessary.
- Prefer `uv sync` over `uv pip install` for project environments and dependency installation.
- In Dockerfiles that run Python code, provide `uv` either by starting from an appropriate uv image or by adding the uv binary to the chosen base image. Use the project's `pyproject.toml` and lockfile workflow rather than generating a `requirements.txt` intermediary.
- Preserve dependency-layer caching where practical: install dependencies before copying frequently changing application source, then install the project itself as needed.

## Verification

- Use `pytest` for tests.
- When Python files change, run `uv run ruff format .` and the relevant pytest suite before committing.
