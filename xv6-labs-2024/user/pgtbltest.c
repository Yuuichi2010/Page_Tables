#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void pgaccess_test()
{
  char *buf;
  unsigned int abits;
  printf("pgaccess_test starting\n");

  buf = malloc(32 * 4096);

  buf[0] = 1;          // truy cập trang 0
  buf[2 * 4096] = 1;   // truy cập trang 2

  if(pgaccess(buf, 3, &abits) < 0)
    printf("pgaccess FAILED: syscall error\n");

  if(abits != 0b101){
    printf("pgaccess FAILED: expected 0b101, got %d\n", abits);
  } else {
    printf("pgaccess_test: OK\n");
  }
  free(buf);
}

int main(int argc, char *argv[])
{
  pgaccess_test();
  exit(0);
}