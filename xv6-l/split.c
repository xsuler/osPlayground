#include "types.h"
#include "stat.h"
#include "user.h"

void
panic(char *s)
{
  printf(2, "%s\n", s);
  exit();
}

int
fork1(void)
{
  int pid;

  pid = fork();
  if(pid == -1)
    panic("fork");
  return pid;
}

char *argv[] = { "scsh", 0 };

int
main(int argc, char *argv[])
{
  if(argc<1)
    exit();
  if(argv[1][0]=='-')
  {
    switch(argv[1][1])
    {
    case 'r':
      split(0);
      if(fork1()==0)
      {
        split(-1);
        exec("scsh", argv);
      }
      break;
    }
  }
  exit();
}
