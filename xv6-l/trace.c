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
  struct shared{
    int n;
  };

  char *ssh;
  struct shared* sh;
  ssh=(char*)(uint)getsharem(0);
  sh=(struct shared*)ssh;
  printf(2, "try-1\n");
  sh->n=10;
  printf(2, "ssh: %d\n",(uint)ssh);
  printf(2, "ans: %d\n", sh->n);
  if(fork1()==0)
  {
    printf(2, "try1\n");
    char *ssh;
    struct shared* sh;
    ssh=(char*)getsharem(0);
    printf(2, "ssh: %d\n",(uint)ssh);
    sh=(struct shared*)ssh;
    printf(2, "ans: %d\n", sh->n);
    sh->n=100;
    printf(2, "ans: %d\n", sh->n);
    exit();
  }
  wait();
  printf(2, "ssh: %d\n",(uint)ssh);
  printf(2, "ans: %d\n", sh->n);
  sh->n=10;
  printf(2, "ans: %d\n", sh->n);
  releasesharem(0);
  /* struct shared* shared=(struct shared*)getshared */
  /* printf(1,"fib 4: %c\n",*t); */
  exit();
}
