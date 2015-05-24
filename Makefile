NAME=NavBallDockingAlignmentIndicator

DLL=$(NAME).dll
SRC=$(NAME).cs
TGZ=$(NAME).tar.gz
ZIP=$(NAME).zip

SOURCES=license readme.md Makefile $(SRC)

INSTALLDIR="$(KSP_DIR)"/GameData/$(NAME)

$(DLL): $(SRC)
	@test "$(KSP_DIR)" || echo 'You need to set $$KSP_DIR'
	@test "$(KSP_DIR)"
	dmcs -debug -r:"$(KSP_DIR)/KSP_Data/Managed/Assembly-CSharp.dll" -r:"$(KSP_DIR)/KSP_Data/Managed/UnityEngine.dll" -t:library $(SRC) -out:$(DLL)

install: $(DLL)
	@test "$(KSP_DIR)" || echo 'You need to set $$KSP_DIR'
	@test "$(KSP_DIR)"
	mkdir -p "$(INSTALLDIR)"
	cp $(DLL) "$(INSTALLDIR)"

uninstall:
	@test "$(KSP_DIR)" || echo 'You need to set $$KSP_DIR'
	@test "$(KSP_DIR)"
	rm -r "$(INSTALLDIR)"

clean:
	rm -rf $(DLL) $(TGZ) $(ZIP) $(NAME)

$(TGZ): $(SOURCES) $(DLL)
	tar cz $^ > $@

$(ZIP): $(SOURCES) $(DLL)
	@rm -rf $(ZIP) $(NAME)
	mkdir -p $(NAME)/GameData/$(NAME)
	cp $(DLL) $(NAME)/GameData/$(NAME)
	mkdir -p $(NAME)/src
	cp $(SOURCES) $(NAME)/src
	cp readme.md $(NAME)/readme.txt
	cd $(NAME) && zip --recurse-paths ../$@ *

tgz: $(TGZ)
zip: $(ZIP)

all: $(DLL) $(TGZ) $(ZIP)

.PHONY: install uninstall clean tgz zip all testkspdir
