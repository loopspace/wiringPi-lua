rm -f wiringpi_wrap.c wiringpi_wrap.o wiringPi.o wiringShift.o wiringSerial.o wiringpi.so
swig -lua wiringpi.i
gcc -I/usr/include/lua5.1 -c wiringpi_wrap.c
gcc -fpic -c -I/usr/include/lua5.1 WiringPi/wiringPi/wiringPi.c
gcc -fpic -c -I/usr/include/lua5.1 WiringPi/wiringPi/wiringShift.c
gcc -fpic -c -I/usr/include/lua5.1 WiringPi/wiringPi/wiringSerial.c
gcc -shared wiringpi_wrap.o wiringPi.o wiringShift.o wiringSerial.o -o wiringpi.so
