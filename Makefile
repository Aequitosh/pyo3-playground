SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.DEFAULT_GOAL := all

PIP_WHEEL_DIR := build/wheel

PIP_WHEEL_SENTINEL := \
	$(addprefix $(PIP_WHEEL_DIR)/, .whl.sentinel)

INTERPRETER_DIR := interpreter

INTERPRETER_DEBUG_DIR := \
	$(addprefix $(INTERPRETER_DIR)/, debug)

INTERPRETER_RELEASE_DIR := \
	$(addprefix $(INTERPRETER_DIR)/, release)


INTERPRETER_CMAKE_FILES := \
	CMakeCache.txt \
	cmake_install.cmake \
	CTestFile.cmake \
	Makefile

INTERPRETER_DEBUG_CMAKE_FILES := \
	$(addprefix $(INTERPRETER_DEBUG_DIR)/, $(INTERPRETER_CMAKE_FILES))

INTERPRETER_RELEASE_CMAKE_FILES := \
	$(addprefix $(INTERPRETER_RELEASE_DIR)/, $(INTERPRETER_CMAKE_FILES))


INTERPRETER_BIN := test-interpreter

INTERPRETER_DEBUG_BIN := \
	$(addprefix $(INTERPRETER_DEBUG_DIR)/, $(INTERPRETER_BIN))

INTERPRETER_RELEASE_BIN := \
	$(addprefix $(INTERPRETER_RELEASE_DIR)/, $(INTERPRETER_BIN))


.PHONY: .test-venv
.test-venv:
	@if [[ -n "$${VIRTUAL_ENV:-}" ]]; \
	    then exit 0; \
	    else echo "No virtual environment activated. Aborting." && exit 1; \
	fi


.PHONY: all
all: install interpreter

.PHONY: install
install: .test-venv $(PIP_WHEEL_SENTINEL)
	pip install --no-index --find-links="${PIP_WHEEL_DIR}" --force-reinstall pyo3-playground

.PHONY: build
build: .test-venv $(PIP_WHEEL_SENTINEL)

$(PIP_WHEEL_SENTINEL): $(PIP_WHEEL_DIR)
	pip wheel --find-links="${PIP_WHEEL_DIR}" --wheel-dir="${PIP_WHEEL_DIR}" -e . && touch $(PIP_WHEEL_SENTINEL)

$(PIP_WHEEL_DIR):
	mkdir -p "${PIP_WHEEL_DIR}"



.PHONY: interpreter
interpreter: interpreter-debug interpreter-release

.PHONY: interpreter-debug
interpreter-debug: .test-venv $(INTERPRETER_DEBUG_BIN)

.PHONY: interpreter-release
interpreter-release: .test-venv $(INTERPRETER_RELEASE_BIN)

$(INTERPRETER_DEBUG_BIN): $(INTERPRETER_CMAKE_FILES)
	cd interpreter && bash debug.sh

$(INTERPRETER_RELEASE_BIN): $(INTERPRETER_CMAKE_FILES)
	cd interpreter && bash release.sh

$(INTERPRETER_CMAKE_FILES):
	cd interpreter && bash configure.sh


.PHONY: clean
clean: clean-python clean-interpreter

.PHONY: clean-python
clean-python:
	rm -rf build/*
	rm -rf src/*.egg-info

.PHONY: clean-interpreter
clean-interpreter:
	cd interpreter && bash clean.sh


.PHONY: compile_commands.json
compile_commands.json: interpreter/compile_commands.json

interpreter/compile_commands.json: .test-venv clean-interpreter
	bear -- $(MAKE) interpreter
	cp -a compile_commands.json interpreter/compile_commands.json
	rm compile_commands.json

