#include "types.h"
#include "user.h"
#include "fcntl.h"

// Parsed command representation
#define ATOM  1
#define LIST  2
#define APPLY 3

#define MAXARGS 10
#define SYMBOLLENG 10

struct sexp{
  int type;
};

struct atom{
  int type;
  char *symbol;
  char *esymbol;
};

struct list{
  int type;
  int length;
  struct sexp *sexps[MAXARGS];
};

int fork1(void);  // Fork but panics on failure.
void panic(char*);
struct sexp *parseexp(char*);

// Execute exp.  Never returns.
void
runexp(struct sexp *exp)
{
  int p[2];
  int i;
  char* argv[MAXARGS];
  char argvt[MAXARGS][20];
  struct list *lst;

  if(exp== 0)
    exit();

  switch(exp->type){
  default:
    panic("runexp");

  case ATOM:
    break;

  case LIST:
    lst = (struct list*)exp;
    for(i=0;i<lst->length;i++)
      runexp(lst->sexps[i]);
    break;

  case APPLY:
    lst = (struct list*)exp;
    for(i=0;i<lst->length;i++)
    {
      if(i==0)
      {
        if(lst->sexps[i]->type==ATOM)
          argv[i]=((struct atom*)lst->sexps[i])->symbol;
        break;
      }
      if(i==lst->length-1)
      {
        if(lst->sexps[i]->type==ATOM)
        {
          if(pipe(p) < 0)
            panic("pipe");
          if(fork1() == 0){
            close(0);
            dup(p[0]);
            close(p[0]);
            close(p[1]);

            if(argv[0] == 0)
              exit();
            exec(argv[0], argv);
            printf(2, "exec %s failed\n", argv[0]);
          }
          char *syb=((struct atom*)lst->sexps[i])->symbol;
          write(p[1], syb, sizeof(syb));
          close(p[0]);
          close(p[1]);
          wait();
        }
        if(lst->sexps[i]->type==LIST)
        {
          panic("syntax");
        }
        if(lst->sexps[i]->type==APPLY)
        {
          if(pipe(p) < 0)
            panic("pipe");
          if(fork1() == 0){
            close(1);
            dup(p[1]);
            close(p[0]);
            close(p[1]);
            runexp(lst->sexps[i]);
          }
          if(fork1() == 0){
            close(0);
            dup(p[0]);
            close(p[0]);
            close(p[1]);

            if(argv[0] == 0)
              exit();
            exec(argv[0], argv);
            printf(2, "exec %s failed\n", argv[0]);
          }
          close(p[0]);
          close(p[1]);
          wait();
          wait();
        }
        break;
      }
      if(lst->sexps[i]->type==ATOM)
      {
        argv[i]=((struct atom*)lst->sexps[i])->symbol;
      }
      if(lst->sexps[i]->type==LIST)
      {
        panic("syntax");
      }
      if(lst->sexps[i]->type==APPLY)
      {
        if(fork1() == 0){
          close(1);
          if(open("./.etemp", O_WRONLY|O_CREATE) < 0){
            printf(2, "open console temp file failed\n");
            exit();
          }
          runexp(lst->sexps[i]);
          close(0);
          if(open("./.etemp", O_RDONLY) < 0){
            printf(2, "open console temp file failed\n");
            exit();
          }
          read(0,argvt[i],20);
          argv[i]=argvt[i];
          unlink("./.etemp");
        }
        wait();
      }
    }
    break;
  }
  exit();
}

int
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}

int
main(void)
{
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
      runexp(parseexp(buf));
      /* runcmd(parsecmd(buf)); */
    wait();
  }
  exit();
}

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

//PAGEBREAK!
// Constructors

struct sexp*
atom(void)
{
  struct atom *exp;

  exp= malloc(sizeof(*exp));
  memset(exp, 0, sizeof(*exp));
  return (struct sexp*)exp;
}

struct sexp*
list(void)
{
  struct list*exp;

  exp= malloc(sizeof(*exp));
  memset(exp, 0, sizeof(*exp));
  return (struct sexp*)exp;
}
//PAGEBREAK!
// Parsing

char whitespace[] = " \t\r\n\v";
char esymbols[] = "()";

int
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
}

struct sexp *parselist(char**, char*);
struct sexp *parseatom(char**, char*);
struct sexp *parsesexp(char**, char*);
struct sexp *snulterminate(struct sexp*);


struct sexp*
parselist(char **ps, char *es)
{
  struct list *lst;
  struct sexp *ret;

  ret=list();
  lst=(struct list*)ret;
  lst->type=LIST;

  int i=1;
  char *res=*ps;
  while(res<es)
  {
    if(*res=='(')
      i++;
    if(*res==')')
    {
      i--;
      if(i==0)
      {
        break;
      }
    }
    res++;
  }
  if(res==es)
    panic("syntax");

  for(i=0;i<MAXARGS&&(*ps)<res;i++)
  {
    lst->sexps[i]=parsesexp(ps, res);
  }
  lst->length=i;

  return ret;
}

struct sexp*
parseatom(char **ps, char *es)
{
  struct atom *atm;
  struct sexp *ret;

  char *s=*ps;
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
    (*ps)++;

  ret=atom();
  atm=(struct atom*)ret;

  atm->type=ATOM;
  atm->symbol=s;
  atm->esymbol=*ps;

  return ret;
}

struct sexp*
parsesexp(char **ps, char *es)
{
  struct sexp *ret=0;

  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
    (*ps)++;
  switch(*(*ps)){
  case 0:
   break;
  case '(':
    (*ps)++;
    ret=parselist(ps, es);
    ret->type=APPLY;
    (*ps)++;
    break;
  case '\'':
    (*ps)+=2;
    ret=parselist(ps, es);
    (*ps)++;
    break;
  default:
    ret=parseatom(ps, es);
    break;
  }
  return ret;
}

struct sexp*
parseexp(char *s)
{
  char *es;
  struct sexp *exp;

  es = s + strlen(s);
  exp= parsesexp(&s, es);
  peek(&s, es, "");
  if(s != es){
    printf(2, "leftovers: %s\n", s);
    panic("syntax");
  }
  snulterminate(exp);
  return exp;
}

struct sexp*
snulterminate(struct sexp *exp)
{
  int i;
  struct list *lst;
  struct atom *atm;

  if(exp== 0)
    return 0;

  switch(exp->type){
  case ATOM:
    atm= (struct atom*)exp;
    *atm->esymbol = 0;
    break;

  case APPLY:
  case LIST:
    lst = (struct list*)exp;
    for(i=0;i<lst->length;i++)
      snulterminate(lst->sexps[i]);
    break;
  }
  return exp;
}
