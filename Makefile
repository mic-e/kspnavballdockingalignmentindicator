NAME=NavBallDockingAlignmentIndicator

DLL=$(NAME).dll
SRC=$(NAME).cs
TGZ=$(NAME).tar.gz
ZIP=$(NAME).zip

SOURCES=license readme Makefile $(SRC)

testkspdir:
	@test "$(KSP_DIR)" || echo 'You need to set $$KSP_DIR'
	@test "$(KSP_DIR)"

$(DLL): $(SRC) testkspdir
	dmcs -r:"$(KSP_DIR)/KSP_Data/Managed/Assembly-CSharp.dll" -r:"$(KSP_DIR)/KSP_Data/Managed/UnityEngine.dll" -t:library $(SRC) -out:$(DLL)

install: $(DLL) testkspdir
	cp $(DLL) "$(KSP_DIR)/Plugins"

uninstall: testkspdir
	rm "$(KSP_DIR)/Plugins/$(DLL)"

clean:
	rm -f $(DLL) $(TGZ) $(ZIP) $(NAME)

$(TGZ): $(SOURCES) $(DLL)
	tar cz $^ > $@

$(ZIP): $(SOURCES) $(DLL)
	@rm -rf $(ZIP) $(NAME)
	mkdir -p $(NAME)/GameData/$(NAME)
	cp $(DLL) $(NAME)/GameData/$(NAME)
	mkdir -p $(NAME)/src
	cp $(SOURCES) $(NAME)/src
	cp readme $(NAME)/readme.txt
	zip $@ $(NAME)

tgz: $(TGZ)
zip: $(ZIP)

all: $(DLL) $(TGZ) $(ZIP)

.PHONY: install uninstall clean tgz zip all testkspdir
