DLL=NavBallDockingAlignmentIndicator.dll
SRC=NavBallDockingAlignmentIndicator.cs
TGZ=NavBallDockingAlignmentIndicator.tar.gz
ZIP=NavBallDockingAlignmentIndicator.zip

$(DLL): $(SRC)
	@test "$(KSP_DIR)" || echo 'You need to set $$KSP_DIR'
	@test "$(KSP_DIR)"
	dmcs -r:"$(KSP_DIR)/KSP_Data/Managed/Assembly-CSharp.dll" -r:"$(KSP_DIR)/KSP_Data/Managed/UnityEngine.dll" -t:library $(SRC) -out:$(DLL)

install: $(DLL)
	@test "$(KSP_DIR)" || echo 'You need to set $$KSP_DIR'
	@test "$(KSP_DIR)"
	cp $(DLL) "$(KSP_DIR)/KSP_Data"

uninstall:
	@test "$(KSP_DIR)" || echo 'You need to set $$KSP_DIR'
	@test "$(KSP_DIR)"
	rm "$(KSP_DIR)/KSP_Data/$(DLL)"

clean:
	rm -f $(DLL) $(TGZ) $(ZIP)

$(TGZ): $(DLL)
	tar cz license Makefile readme $(SRC) $(DLL) > $(TGZ)

$(ZIP): $(DLL)
	zip $(ZIP) license Makefile readme $(SRC) $(DLL)

tgz: $(TGZ)
zip: $(ZIP)

all: $(DLL) $(TGZ) $(ZIP)

.PHONY: install uninstall clean all tgz
