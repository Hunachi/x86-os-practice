ENV_ROOT = env
SRC_ROOT = src

00: $(SRC_ROOT)/00_boot_only/Makefile
	cd $(SRC_ROOT)/00_boot_only/ && make || cd ../..

01: $(SRC_ROOT)/01_bpb/Makefile
	cd $(SRC_ROOT)/01_bpb/ && make || cd ../..

02: $(SRC_ROOT)/02_save_data/Makefile
	cd $(SRC_ROOT)/02_save_data/ && make || cd ../..