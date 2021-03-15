ENV_ROOT = env
SRC_ROOT = src

00bootonly: $(SRC_ROOT)/00_boot_only/Makefile
	cd $(SRC_ROOT)/00_boot_only/ && make || cd ../..

01bpb: $(SRC_ROOT)/01_bpb/Makefile
	cd $(SRC_ROOT)/01_bpb/ && make || cd ../..