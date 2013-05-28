FLOPPY_IMAGE = PongOS.flp
CP_DIR = /home/anay/dev-codes/github/pong-os/cp

.PHONY: emulate image

image: bootload.bin kernel.bin
	dd status=noxfer conv=notrunc if=boot.bin of=$(FLOPPY_IMAGE)
	sudo mount $(FLOPPY_IMAGE) $(CP_DIR) -o loop -t vfat
	sudo cp kernel.bin $(CP_DIR)
	sudo umount $(CP_DIR)

bootload.bin: bootload.asm
	nasm -f bin bootload.asm -o bootload.bin

kernel.bin: kernel.asm
	nasm -f bin kernel.asm -o kernel.bin

emulate: $(FLOPPY_IMAGE)
	qemu-system-i386 -fda $(FLOPPY_IMAGE)
