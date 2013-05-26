nasm -f bin bootload.asm -o boot.bin
nasm -f bin kernel.asm -o kernel.bin
dd status=noxfer conv=notrunc if=boot.bin of=PongOS.flp
sudo mount PongOS.flp /home/anay/myWay/OS_dev/PongOS/cp -o loop -t vfat
sudo cp kernel.bin /home/anay/myWay/OS_dev/PongOS/cp
sudo umount /home/anay/myWay/OS_dev/PongOS/cp

