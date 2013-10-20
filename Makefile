NAME=NavBallDockingAlignmentIndicator

DLL=$(NAME).dll
SRC=$(NAME).cs
TGZ=$(NAME).tar.gz
ZIP=$(NAME).zip

DEPLOY=license readme Makefile $(SRC) $(DLL)

$(DLL): $(SRC)
	@test "$(KSP_DIR)" || echo 'You need to set $$KSP_DIR'
	@test "$(KSP_DIR)"
	dmcs -r:"$(KSP_DIR)/KSP_Data/Managed/Assembly-CSharp.dll" -r:"$(KSP_DIR)/KSP_Data/Managed/UnityEngine.dll" -t:library $(SRC) -out:$(DLL)

install: $(DLL)
	@test "$(KSP_DIR)" || echo 'You need to set $$KSP_DIR'
	@test "$(KSP_DIR)"
	cp $(DLL) "$(KSP_DIR)/Plugins"

uninstall:
	@test "$(KSP_DIR)" || echo 'You need to set $$KSP_DIR'
	@test "$(KSP_DIR)"
	rm "$(KSP_DIR)/Plugins/$(DLL)"

clean:
	rm -f $(DLL) $(TGZ) $(ZIP)

$(TGZ): $(DEPLOY)
	tar cz $(DEPLOY) > $(TGZ)

$(ZIP): $(DEPLOY)
	@rm -f $(ZIP)
	zip $(ZIP) $(DEPLOY)

tgz: $(TGZ)
zip: $(ZIP)

all: $(DLL) $(TGZ) $(ZIP)

.PHONY: install uninstall clean tgz zip all
