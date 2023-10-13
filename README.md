# PyO3 Playground

This serves as a personal development environment to tinker around with
[PyO3](https://github.com/PyO3/pyo3).

I'm mainly focusing on [implementing support for Python sub-interpreters](https://github.com/PyO3/pyo3/issues/3451)
at the moment.

## Overview

This repository consists of two parts, a Python module with bindings to PyO3
and a rather primitive C++ application that uses 
### The Python Module: `playground`

`playground` is a Python module with bindings to PyO3 that contains functions,
objects, etc. that bind to whatever PyO3 code I'm testing at the moment.
The sources of this module can be found in `src`.

### The C++ Application

This (yet to be named) C++ application uses [Python's C API](https://docs.python.org/3.11/c-api/index.html)
to play around with the stuff that's in the `playground` module.

In the future, this application might support a REPL of some sort, but for the
time being it just does whatever I want to experiment with.

#### Okay but why is it in C++ and not Rust?

Well, initially I thought it would be easier to just use C or C++ to quickly
set up something that allows me to mess around with Python's C API - and it was!
Eventually I decided to use `cmake` to "make my life easier" which ended up in
my life being made harder.

Either way, it now builds and it's (more or less) easy to use,
[so I'm reluctant to rewrite the whole thing](https://en.wikipedia.org/wiki/Sunk_cost).

## Instructions For The Curious

**Note:** Open an issue if you're actually interested in using this repository
to play around with PyO3, too. These instructions may not be complete; right
now, they've only been tested on my machine.

### Prerequisites

* Be on some Linux distribution of your choice (WSL should probably work too)
* [Python](https://www.python.org/), preferably via [`pyenv`](https://www.python.org/)
* [`cmake`](https://cmake.org/) (optionally with `ctest`)
* [Rust](https://rustup.rs/)
* Make sure you've cloned this repository with its submodules:
  ```bash
  git clone --recurse-submodules git@github.com:Aequitosh/pyo3-playground.git
  ```
* Alternatively, if you've already cloned it, run:
  ```bash
  git submodule update --init --recursive
  ```

### Build Steps

**Note:** This was tested using Python 3.11. Older or newer Python versions
might or might not work. Good luck!

01. Prepare and activate a [virtual environment](https://docs.python.org/3.11/library/venv.html).
    I highly recommend using [pyenv](https://github.com/pyenv/pyenv) to install
    your desired Python version in order to not mess with your system's Python
    installation.
02. Congratulations, you can now build the `playground` module from the repo's directory:
    ```bash
    pip install -e .
    ```
    Yeah, it's suprisingly easy, I know!
03. To test the module, import it in the `python` REPL:
    ```py
    >>> import playground
    >>> playground.hello_world()
    'Hello, World!'
    ```

After confirming that the module builds and runs correctly, you may also build
the C++ application:

04. Enter the `interpreter/` directory
    ```bash
    cd interpreter
    ```
05. Configure `cmake`:
    ```bash
    ./configure.sh
    ```
06. Once everything's configured successfully, you should be able to build and
    run in `debug` and `release` each:
    ```bash
    ./debug.sh && ./build/debug/test-interpreter
    ```
    ```bash
    ./release.sh && ./build/release/test-interpreter
    ```

Once you completed the above steps and everything's built, can also run the
(currently not very useful) tests for either build variant. The tests are
built automatically for both builds.

07. Run the test executable directly:
    ```bash
    ./build/debug/tests/run_tests
    ```
    ```bash
    ./build/release/tests/run_tests
    ```
08. You may also run the tests with `ctest`:
    ```bash
    ctest --test-dir ./build/debug
    ```
    ```bash
    ctest --test-dir ./build/release
    ```

## License

Even though this is just a (more or less literal) playground for PyO3,
this project is licensed under the [AGPL-3.0](LICENSE).

Should this at any point become more relevant (which I doubt) I might adapt
the license correspondingly.

