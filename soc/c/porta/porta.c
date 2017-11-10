//      port.c
//      
//      Copyright 2014 Michel Doussot <michel@mustafar>
//      
//      This program is free software; you can redistribute it and/or modify
//      it under the terms of the GNU General Public License as published by
//      the Free Software Foundation; either version 2 of the License, or
//      (at your option) any later version.
//      
//      This program is distributed in the hope that it will be useful,
//      but WITHOUT ANY WARRANTY; without even the implied warranty of
//      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//      GNU General Public License for more details.
//      
//      You should have received a copy of the GNU General Public License
//      along with this program; if not, write to the Free Software
//      Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
//      MA 02110-1301, USA.

#include <avr/io.h>


// unite approximative 2us
void delai(unsigned long int delai) {
	volatile long int i=0;
	for(i=0;i<delai;i+=1);
} 

int main(void) {
	
	unsigned char tmp;
	
	DDRA = 0xff;
	DDRB = 0;
   	tmp = PORTB;		
	while (1) {
		PORTA = tmp;
		delai(1);
		tmp += 1;
	}
	return 0;
}

