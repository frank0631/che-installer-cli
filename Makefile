
install-cli:
	$(MAKE) -C cli install

install-fish: install-cli
	. cli/env/bin/activate; \
	cd fish; \
	che_install_rest com.frank0631.code.fish

install-cmake: install-cli
	. cli/env/bin/activate; \
	cd cmake; \
	che_install_rest com.frank0631.code.cmake

install-tree: install-cli
	. cli/env/bin/activate; \
	cd tree; \
	che_install_rest com.frank0631.code.tree

install-thrift: install-cli
	. cli/env/bin/activate; \
	cd thrift; \
	che_install_rest com.frank0631.code.thrift

unix-lf:
	find Makefile -type f -exec sed -i 's/\r//' {} \;
	find fish/*.sh -type f -exec sed -i 's/\r//' {} \;
	find cmake/*.sh -type f -exec sed -i 's/\r//' {} \;
	find tree/*.sh -type f -exec sed -i 's/\r//' {} \;
	find thrift/*.sh -type f -exec sed -i 's/\r//' {} \;