CC=ghdl
PROG=Timer
SRC=$(PROG).vhdl
MOD1=diviseurN4.vhdl
MOD2=prediviseur.vhdl
MOD3=PWM.vhdl
VCD=$(PROG).vcd
SRCTB=$(PROG)_tb.vhdl
ENTITE=$(PROG)_tb
OPTIONS= --ieee=synopsys -fexplicit
AOPTIONS= -Wc,-m32 -Wa,--32
EOPTIONS= -Wa,--32 -Wl,-m32
STOPTIME=50000ns

all:
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(MOD1)
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(MOD2)
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(MOD3)
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRC)
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRCTB)
	$(CC) -e $(EOPTIONS) $(OPTIONS) $(ENTITE)
	$(CC) -r $(OPTIONS) $(ENTITE) --vcd=$(VCD) --stop-time=$(STOPTIME)

view:
	gtkwave $(VCD)

clean:
	$(CC) --clean
	rm  $(VCD) *.cf
