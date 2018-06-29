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


int
main(int argc, char *argv[])
{
  if(argc<1)
    exit();
  char *argvt[] = { "sh", 0 };
  if(argv[1][0]=='-')
  {
    if(argv[1][1]=='n')
    {
      if(fork1()==0)
      {
        split(-1);
        exec("sh", argvt);
      }
    }
    if(argv[1][1]>='0'&&argv[1][1]<='9')
    {
      split(argv[1][1]-'0');
    }
  }
  exit();
}
