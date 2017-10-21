CC=ghdl
PROG=SPI_write
COMPOSANT=diviseur_programmable.vhdl
SRC=$(PROG).vhdl
VCD=$(PROG).vcd
SRCTB=$(PROG)_test.vhdl
ENTITE=$(PROG)_tb
OPTIONS= --ieee=synopsys -fexplicit
AOPTIONS= -Wc,-m32 -Wa,--32
EOPTIONS= -Wa,--32 -Wl,-m32
STOPTIME=500000ns

all:
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(COMPOSANT)
	# $(CC) -a $(OPTIONS) $(SRC)
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRC)
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRCTB)
	$(CC) -e $(EOPTIONS) $(OPTIONS) $(ENTITE)
	$(CC) -r $(OPTIONS) $(ENTITE) --vcd=$(VCD) --stop-time=$(STOPTIME)

test:
	$(CC) -s $(OPTIONS) $(COMPOSANT)
	$(CC) -s $(OPTIONS) $(SRC)

view:
	gtkwave $(VCD)

clean:
	$(CC) --clean
	rm  $(VCD) *.cf
