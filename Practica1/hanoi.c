#include <stdio.h>
#include <stdlib.h>

void hanoi(int n, char from, char aux, char to) {
    if (n == 1) {
        printf("Move disk 1 from %c to %c\n", from, to);
    } else {
        hanoi(n - 1, from, to, aux);
        printf("Move disk %d from %c to %c\n", n, from, to);
        hanoi(n - 1, aux, from, to);
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Wrong arguments. Use: $ ./hanoi <number of disks>\n");
        exit(1);
    }
    hanoi(atoi(argv[1]), 'A', 'B', 'C');
    return 0;
}
