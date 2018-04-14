SML := sml
SMLFLAGS := -Cprint.depth=10 -m
MLTON := mlton

CM_FILE := parsimony.cm


compile:
	$(SML) $(SMLFLAGS) $(CM_FILE)
