PREFIX ?= /usr/local
BIN_DIR = $(PREFIX)/bin
SHARE_DIR = $(PREFIX)/share/tffy
SCRIPT_FILES = $(wildcard scripts/*)

.PHONY: install uninstall clean

install: tffy $(SCRIPT_FILES)
	@echo "Installing tffy to $(BIN_DIR)..."
	@mkdir -p "$(BIN_DIR)"
	@cp tffy "$(BIN_DIR)/tffy"
	@chmod +x "$(BIN_DIR)/tffy"
	@echo "Installing scripts to $(SHARE_DIR)/scripts..."
	@mkdir -p "$(SHARE_DIR)/scripts"
	@cp -r scripts/* "$(SHARE_DIR)/scripts/"
	@chmod +x $(SHARE_DIR)/scripts/*.sh 2>/dev/null || true
	@echo "Installation complete. You can now run 'tffy' from anywhere."

uninstall:
	@echo "Uninstalling tffy from $(BIN_DIR)..."
	@rm -f "$(BIN_DIR)/tffy"
	@echo "Removing scripts from $(SHARE_DIR)..."
	@rm -rf "$(SHARE_DIR)"
	@echo "Uninstallation complete."

clean:
	@echo "Clean target is not strictly necessary for this project but included for convention."

scripts:
	@mkdir -p scripts 