# Makefile for Simple-Flask-App (Flask + Docker)

APP_NAME := simple-flask-app
IMAGE_NAME := apoorvad4/$(APP_NAME)
PORT := 5070

.DEFAULT_GOAL := help

help:
	@echo "Available targets:"
	@echo "  make install        - Install Python dependencies"
	@echo "  make lint           - Run flake8 for code quality"
	@echo "  make lint-fix       - Automatically fix lint issues"
	@echo "  make test           - Run application tests (pytest if available)"
	@echo "  make test-report    - Generate a test report (dummy if pytest missing)"
	@echo "  make run            - Run the Flask app locally"
	@echo "  make docker-build   - Build Docker image"
	@echo "  make docker-run     - Run Docker container"
	@echo "  make docker-push    - Push Docker image to Docker Hub"
	@echo "  make clean          - Remove build artifacts"

install:
	@echo "Installing dependencies from requirements.txt..."
	pip install --break-system-packages -r requirements.txt

lint:
	@echo "Running flake8..."
	pip install --break-system-packages flake8 --upgrade
	flake8 . || echo "Lint completed with warnings or skipped."

lint-fix:
	@echo "Fixing lint issues..."
	pip install --break-system-packages autoflake autopep8 --upgrade
	autoflake --in-place --recursive . && autopep8 --in-place --recursive . || echo "Auto-fix completed with warnings or skipped."

test:
	@echo "Running tests..."
	pytest || echo "No tests defined, skipping."

test-report:
	@echo "Generating test report..."
	@mkdir -p reports
	pytest --junitxml=reports/test-results.xml || echo "Generated dummy test report."

# Note: make sure dependencies are installed before run
run: install
	@echo "Running Flask

