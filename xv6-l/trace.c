#include "types.h"
#include "stat.h"
#include "user.h"

int
fib(int n)
{
  if(n<=1)
    return 1;
  return fib(n-1)+fib(n-2);
}

char whitespace[] = " \t\r\n\v";



int
main(int argc, char *argv[])
{
  char st[]="  12";
  char *t=st;
  char *s=t+5;
  while(t < s && strchr(whitespace, *t)) //skip whitespace
    t++;
  printf(1,"fib 4: %c\n",*t);
  /* printf(1,"timepiece: %d\n",trace()); */
  exit();
}
