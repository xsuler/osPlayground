#include "types.h"
#include "user.h"
#include "fcntl.h"

// Parsed command representation
#define ATOM  1
#define LIST  2
#define APPLY 3

#define MAXARGS 10
#define MAXFUNC 10
#define MAXFUNNAME 10
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

struct func{
  char name[MAXFUNNAME];
  char *argv[MAXARGS];
  int argc;
  struct sexp *sexp;
};

int fork1(void);  // Fork but panics on failure.
void panic(char*);
struct sexp *parseexp(char*);
void runexp(struct sexp *exp,struct func *funcs,int *nfunc);

void replaceAtom(struct sexp *exp,char *o,char *d)
{
  int i;
  struct atom *atm;
  struct list *lst;
  switch(exp->type)
  {
  case ATOM:
    atm=(struct atom*)exp;
    if(strcmp(atm->symbol,o)==0)
      atm->symbol=d;
    break;
  case LIST:
  case APPLY:
    lst=(struct list*)exp;
    for(i=0;i<lst->length;i++)
    {
      replaceAtom(lst->sexps[i], o, d);
    }
    break;
  }
}

void
defunc(struct list *lst,struct func *funcs,int *nfunc)
{
  printf(2, "start defun\n");
  int i;
  struct func *fn=funcs+*nfunc;
  struct list *argv=(struct list*)lst->sexps[2];
  (*nfunc)++;
  printf(2, "nfunc: %d\n", *nfunc);
  strcpy(fn->name, ((struct atom*)lst->sexps[1])->symbol);
  fn->argc=argv->length;
  fn->sexp=lst->sexps[3];
  for(i=0;i<fn->argc;i++)
    replaceAtom(fn->sexp, ((struct atom*)argv->sexps[i])->symbol, fn->argv[i]);
}

// Execute exp.  Never returns.
void
runexp(struct sexp *exp,struct func *funcs,int *nfunc)
{

  int i,bufs=0;
  char* argv[MAXARGS];
  static char argvbuf[100];
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
      runexp(lst->sexps[i],funcs,nfunc);
    break;

  case APPLY:
    printf(2, "in 1\n");
    lst = (struct list*)exp;
    argv[lst->length]=0;
    for(i=0;i<lst->length;i++)
    {

      /* if(i==0) */
      /* { */
      /*   if(lst->sexps[i]->type==ATOM) */
      /*     argv[i]=((struct atom*)lst->sexps[i])->symbol; */
      /*   break; */
      /* } */
          /* if(pipe(p) < 0) */
          /*   panic("pipe"); */
          /* if(fork1() == 0){ */
          /*   close(0); */
          /*   dup(p[0]); */
          /*   close(p[0]); */
          /*   close(p[1]); */

        /*     if(argv[0] == 0) */
        /*       exit(); */
        /*     exec(argv[0], argv); */
        /*     printf(2, "exec %s failed\n", argv[0]); */
        /*   } */
        /*   char *syb=((struct atom*)lst->sexps[i])->symbol; */
        /*   write(p[1], syb, sizeof(syb)); */
        /*   close(p[0]); */
        /*   close(p[1]); */
        /*   wait(); */
        /* } */
        /* if(lst->sexps[i]->type==LIST) */
        /* { */
        /*   panic("syntax"); */
        /* } */
        /* if(lst->sexps[i]->type==APPLY) */
        /* { */
        /*   if(pipe(p) < 0) */
        /*     panic("pipe"); */
        /*   if(fork1() == 0){ */
        /*     close(1); */
        /*     dup(p[1]); */
        /*     close(p[0]); */
        /*     close(p[1]); */
        /*     runexp(lst->sexps[i]); */
        /*   } */
        /*   if(fork1() == 0){ */
        /*     close(0); */
        /*     dup(p[0]); */
        /*     close(p[0]); */
        /*     close(p[1]); */

      /*       if(argv[0] == 0) */
      /*         exit(); */
      /*       exec(argv[0], argv); */
      /*       printf(2, "exec %s failed\n", argv[0]); */
      /*     } */
      /*     close(p[0]); */
      /*     close(p[1]); */
      /*     wait(); */
      /*     wait(); */
      /*   } */
      /*   break; */
      /* } */

      printf(2, "in 2, length:%d\n",lst->length);
      if(lst->sexps[i]->type==ATOM)
      {
        argv[i]=((struct atom*)lst->sexps[i])->symbol;
        printf(2, "in 3, length:%d\n",lst->length);
      }
      else if(lst->sexps[i]->type==LIST)
      {
        panic("syntax");
      }
      else if(lst->sexps[i]->type==APPLY)
      {
        if(fork1() == 0){
          close(1);
          if(open(".etemp", O_WRONLY|O_CREATE) < 0){
            printf(2, "open console temp file failed\n");
            exit();
          }
          printf(2, "start\n");
          runexp(lst->sexps[i],funcs,nfunc);
        }
        wait();

        printf(2, "end\n");
        close(2);
        int ffd;
        if((ffd=open(".etemp", O_RDONLY)) < 0){
          printf(1, "open console temp file failed\n");
          exit();
        }
        printf(1,"fd: %d\n",ffd);
        argv[i]=argvbuf+bufs;
        bufs+=read(2,argvbuf+bufs,20);
        argvbuf[bufs++]=0;
        printf(1, "sizeof : %d\n",bufs);
        close(2);
        unlink(".etemp");
        open("console", O_RDWR);
        printf(2,"argv%d: %s\n",i,argv[i]);
      }
      if((i==0)&&(strcmp(argv[0], "defun")==0))
      {
          if(fork1() == 0){
            if(argv[0] == 0)
              exit();
            defunc(lst,funcs,nfunc);
          }
          wait();
          break;
      }
      if(i==lst->length-1)
      {
        printf(2, "in 4, length:%d\n",lst->length);
        printf(2, "exec %s\n",argv[0]);
        int j,k,flg;
        printf(2, "nfunc: %d\n",*nfunc);
        for(j=0;j<MAXFUNC;j++)
        {
          if(strcmp(argv[0], funcs[j].name)==0)
          {
            for(k=0;k<funcs[j].argc;k++)
              funcs[j].argv[k]=argv[k+1];
            flg=1;
            printf(2, "find func\n");
            break;
          }
        }
        if(fork1() == 0){
          if(argv[0] == 0)
            exit();
          if(flg==1)
            runexp(funcs[j].sexp,funcs,nfunc);
          else
            exec(argv[0], argv);
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
  int fd=0;
  static int nfuncs;
  int *nfunc=&nfuncs;
  struct func funcs[MAXFUNC];

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
    if(fork1() == 0){
      printf(2, "nfunc: %d\n",*nfunc);
      runexp(parseexp(buf),funcs,nfunc);
    }
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
