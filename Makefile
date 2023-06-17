all: fastapi fastapi.service
.PHONY: all fastapi install uninstall
lib_dir=/usr/local/lib/fastapi
conf_dir=/usr/local/etc/fastapi
service_dir=/etc/systemd/system
venv=$(lib_dir)/venv

install: $(service_dir) fastapi.service
	@echo Installing the service files...
	cp fastapi.service $(service_dir)
	chown root:root $(service_dir)/fastapi.service
	chmod 644 $(service_dir)/fastapi.service

	@echo Installing library files...
	mkdir -p $(lib_dir)
	cp main.py $(lib_dir)
	chown root:root $(lib_dir)/*
	chmod 644 $(lib_dir)/*

	@echo Installing configuration files...
	mkdir -p $(conf_dir)
	@echo No configuration files to install
	chown root:root $(conf_dir)/*
	chmod 644 $(conf_dir)/*

	@echo Creating python virtual environment and install packages...
	python3 -m venv $(venv)
	$(venv)/bin/pip3 install -r requirements.txt

	@echo Installation complete...
	@echo run 'systemctl start fastapi' to start service
	@echo run 'systemctl status fastapi' to view status

uninstall:
	-systemctl stop fastapi
	-systemctl disable fastapi
	-rm -r $(lib_dir)
	-rm -r $(conf_dir)
	-rm -r $(service_dir)/fastapi.service