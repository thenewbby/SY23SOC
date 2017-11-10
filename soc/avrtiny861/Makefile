CC=ghdl
PROG=microcontroleur
SRC=$(PROG).vhdl
VCD=$(PROG).vcd
SRCTB=$(PROG)_test.vhdl
ENTITE=$(PROG)_test
OPTIONS= --std=02 --ieee=synopsys -fexplicit
AOPTIONS= -Wc,-m32 -Wa,--32
EOPTIONS= -Wa,--32 -Wl,-m32
STOPTIME=100us
COMPOSANT=dm.vhd ioport.vhd   pm.vhd  usi.vhd  IODrdmux.vhd  mcu_core.vhd  timer.vhd


all: compile simule

test:
	$(CC) -s $(OPTIONS) $(COMPOSANT)
	$(CC) -s $(OPTIONS) $(SRC)

compile:
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(COMPOSANT)
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRC)
	$(CC) -s $(OPTIONS) $(SRCTB)
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRCTB)

simule:
	$(CC) -e  $(EOPTIONS) $(OPTIONS) $(ENTITE)

execute:
	$(CC) -r $(OPTIONS) $(ENTITE) --vcd=$(VCD) --stop-time=$(STOPTIME)

view:
	gtkwave $(VCD)

clean:
	$(CC) --clean
	rm  $(VCD)
	rm work-obj93.cf
