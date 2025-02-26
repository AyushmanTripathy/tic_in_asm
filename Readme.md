# Tic Tac Toe in x86_64 NASM

Tic Tac Toe (or noughts and crosses :) ) in NASM  
This assembley program is runs in Real mode (as the boot sector in a vm) in 16 bit addressing mode, and is assisted by BIOS.  
Other assembley programs of mine can be found at [asm](https://github.com/AyushmanTripathy/asm).   

### Running Locally

You will need,

1. nasm
1. qemu (qemu-common package generally)

Then clone the repo and execute the run.sh script.

```sh
git clone https://github.com/AyushmanTripathy/tic_in_asm
sh run.sh
```

### Screenshots

![Game Start](https://github.com/user-attachments/assets/ed075c14-cadf-408f-a2c7-267420c3ecb6)
![X Won](https://github.com/user-attachments/assets/c2f9b49e-465a-4d19-bf03-4aaee8495dc3)

### Resources

some links you may find useful.

- [NASM Cheat Sheet](https://www.cs.uaf.edu/2017/fall/cs301/reference/x86_64.html)
- [Making an OS, Daedalus Community](https://www.youtube.com/watch?v=MwPjvJ9ulSc)
- [Plain old ASCII Table](https://www.cs.cmu.edu/~pattis/15-1XX/common/handouts/ascii.html)
