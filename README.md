# Cyjon

Prosty i wielozadaniowy system operacyjny, napisany w języku asemblera dla procesorów z rodziny amd64/x86-64.

### Wymagania:

  - 2 MiB pamięci RAM

### Kompilacja:

	nasm -f bin kernel/kernel.asm	-o build/kernel
	nasm -f bin zero/zero.asm	-o build/disk.raw

### Uruchomienie:

	qemu-system-x86_64 -drive file=build/disk.raw,media=disk,format=raw -m 2
