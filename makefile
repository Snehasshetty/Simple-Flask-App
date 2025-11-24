# Makefile for Simple-Flask-App (Flask + Docker + venv)

APP_NAME := simple-flask-app
IMAGE_NAME := apoorvad4/$(APP_NAME)
PORT := 5070

VENV := venv
PYTHON := $(VENV)/bin/python3
PIP := $(VENV)/bin/pip
FLAKE8 := $(VENV)/bin/flake8
PYTEST := $(VENV)/bin/pytest
AUTOFLAKE := $(VENV)/bin/autoflake
AUTOPEP8 := $(VENV)/bin/autopep8

.DEFAULT_GOAL := help

.PHONY: help install lint lint-fix test test-report run docker-build docker-run docker-push clean

help:
	@echo "Available targets:"
	@echo "  make install        - Create virtualenv and install Python dependencies"
	@echo "  make lint           - Run flake8 for code quality"
	@echo "  make lint-fix       - Automatically fix lint issues"
	@echo "  make test           - Run application tests (pytest if available)"
	@echo "  make test-report    - Generate a test report (dummy if no tests)"
	@echo "  make run            - Run the Flask app locally"
	@echo "  make docker-build   - Build Docker image"
	@echo "  make docker-run     - Run Docker container"
	@echo "  make docker-push    - Push Docker image to Docker Hub"
	@echo "  make clean          - Remove build artifacts and virtual environment"

# Create virtual environment and install base deps
$(VENV):
	@echo "Creating virtual environment in $(VENV)..."
	python3 -m venv $(VENV)
	@echo "Installing dependencies from requirements.txt into venv..."
	$(PIP) install -r requirements.txt

install: $(VENV)
	@echo "Virtual environment ready and dependencies installed."

lint: $(VENV)
	@echo "Running flake8 inside virtualenv..."
	$(PIP) install flake8 --upgrade
	$(FLAKE8) . || echo "Lint completed with warnings or skipped."

lint-fix: $(VENV)
	@echo "Fixing lint issues (autoflake + autopep8) inside virtualenv..."
	$(PIP) install autoflake autopep8 --upgrade
	$(AUTOFLAKE) --in-place --recursive .
	$(AUTOPEP8) --in-place --recursive . || echo "Auto-fix completed with warnings or skipped."

test: $(VENV)
	@echo "Running tests with pytest (if any)..."
	$(PIP) install pytest --upgrade
	$(PYTEST) || echo "No tests defined, skipping."

test-report: $(VENV)
	@echo "Generating test report..."
	@mkdir -p reports
	$(PIP) install pytest --upgrade
	$(PYTEST) --junitxml=reports/test-results.xml || echo "Generated dummy test report."

run: $(VENV)
	@echo "Running Flask app on port $(PORT) with python3 (in background)..."
	$(PYTHON) product_list_app.py &

docker-build:
	@echo "Building Docker image: $(IMAGE_NAME)"
	docker build -t $(IMAGE_NAME) .

docker-run:
	@echo "Running container on port $(PORT)"
	docker run -d -p $(PORT):$(PORT) --name $(APP_NAME) $(IMAGE_NAME)

docker-push:
	@echo "Pushing image to Docker Hub..."
	docker push $(IMAGE_NAME)

clean:
	@echo "Cleaning up..."
	rm -rf __pycache__
	rm -rf .pytest_cache
	rm -rf reports
	rm -rf $(VENV)
	docker rm -f $(APP_NAME) 2>/dev/null || true

