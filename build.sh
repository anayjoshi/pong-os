nasm -f bin bootload.asm -o boot.bin
nasm -f bin kernel.asm -o kernel.bin
dd status=noxfer conv=notrunc if=boot.bin of=PongOS.flp
sudo mount PongOS.flp /home/anay/dev-codes/github/pong-os/cp -o loop -t vfat
sudo cp kernel.bin /home/anay/dev-codes/github/pong-os/cp
sudo umount /home/anay/dev-codes/github/pong-os/cp

