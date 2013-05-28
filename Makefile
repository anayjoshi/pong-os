FLOPPY_IMAGE = PongOS.flp
CP_DIR = temp_mount

.PHONY: image emulate image clean umount mount

$(FLOPPY_IMAGE): kernel.bin bootload.bin
	mkdosfs -C $(FLOPPY_IMAGE) 1440
	mkdir $(CP_DIR) 
	sudo mount $(FLOPPY_IMAGE) $(CP_DIR) -o loop -t vfat
	dd status=noxfer conv=notrunc if=bootload.bin of=$(FLOPPY_IMAGE)
	sudo cp kernel.bin $(CP_DIR)
	sudo umount $(CP_DIR) -f

bootload.bin: bootload.asm
	nasm -f bin bootload.asm -o bootload.bin

kernel.bin: kernel.asm
	nasm -f bin kernel.asm -o kernel.bin

emulate: $(FLOPPY_IMAGE)
	qemu-system-i386 -fda $(FLOPPY_IMAGE)

umount:
	sudo umount $(CP_DIR) -f

mount:
	sudo mount $(FLOPPY_IMAGE) $(CP_DIR) -o loop -t vfat

clean:
	rm *.bin $(FLOPPY_IMAGE) -f
	sudo rm $(CP_DIR)/ -rf
