# OpenConstruct Integration Hub — Build System
# Build targets for the SuperInstance ecosystem

.PHONY: all rust python ts c esp32 jetson clean test help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

all: rust python ts c ## Build everything

# ─── Rust ────────────────────────────────────────────

rust: ## Build Rust workspace
	cargo build --workspace --release

rust-test: ## Run Rust tests
	cargo test --workspace

rust-docs: ## Generate Rust docs
	cargo doc --workspace --no-deps --open

# ─── Python ──────────────────────────────────────────

python: ## Build Python bindings
	pip install -e . --no-deps

python-test: ## Run Python tests
	python -m pytest tests/ -v

# ─── TypeScript ──────────────────────────────────────

ts: ## Build TypeScript bindings
	npm run build

ts-test: ## Run TypeScript tests
	npm test

# ─── C (header-only) ────────────────────────────────

c: ## Verify C headers compile
	@echo "C libraries are header-only (STB-style). No build needed."
	@for f in $$(find . -name '*.h' -path '*/c/*'); do \
		echo "  Checking $$f..."; \
		gcc -fsyntax-only "$$f" 2>/dev/null || echo "  Warning: $$f needs headers from submodule"; \
	done

# ─── ESP32 ───────────────────────────────────────────

esp32: ## Build ESP32 firmware (requires ESP-IDF)
	@if [ ! -d openconstruct-esp32 ]; then \
		git clone https://github.com/SuperInstance/openconstruct-esp32; \
	fi
	cd openconstruct-esp32 && idf.py build

esp32-flash: ## Flash ESP32 firmware
	cd openconstruct-esp32 && idf.py flash

esp32-monitor: ## Monitor ESP32 serial output
	cd openconstruct-esp32 && idf.py monitor

# ─── Jetson ──────────────────────────────────────────

jetson: ## Build Jetson edge node (requires JetPack)
	@if [ ! -d openconstruct-jetson ]; then \
		git clone https://github.com/SuperInstance/openconstruct-jetson; \
	fi
	cd openconstruct-jetson && mkdir -p build && cd build && cmake .. && make -j$$(nproc)

# ─── Utilities ───────────────────────────────────────

clean: ## Clean all build artifacts
	cargo clean 2>/dev/null || true
	rm -rf dist/ node_modules/ build/
	rm -rf openconstruct-esp32/build/ openconstruct-jetson/build/

test: rust-test python-test ts-test ## Run all tests

update-modules: ## Pull latest from all submodule repos
	@git submodule update --remote --merge 2>/dev/null || echo "No submodules configured. Clone individual repos as needed."
