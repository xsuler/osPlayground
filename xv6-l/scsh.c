#include "fcntl.h"
#include "types.h"
#include "user.h"

// Parsed command representation
#define ATOM 1
#define LIST 2
#define APPLY 3

#define MAXARGS 10
#define MAXARGL 10
#define MAXFUNC 10
#define MAXFUNNAME 10
#define SYMBOLLENG 10

struct sexp {
  int type;
};

struct atom {
  int type;
  char *symbol;
  char *esymbol;
};

struct list {
  int type;
  int length;
  struct sexp *sexps[MAXARGS];
};

struct func {
  char name[MAXFUNNAME];
  char argv[MAXARGS][MAXARGL];
  int argc;
  struct sexp *sexp;
};

struct shared {
  int nfunc;
  struct func funcs[MAXFUNC];
  char xargv[MAXARGS][MAXARGL];
  char *top;
};

int fork1(void); // Fork but panics on failure.
void panic(char *);
struct sexp *parseexp(char *);
void runexp(struct sexp *exp);

void replaceAtom(struct sexp *exp, char *o, char *d) {
  int i;
  struct atom *atm;
  struct list *lst;
  switch (exp->type) {
  case ATOM:
    atm = (struct atom *)exp;
    if (strcmp(atm->symbol, o) == 0)
      atm->symbol = d;
    break;
  case LIST:
  case APPLY:
    lst = (struct list *)exp;
    for (i = 0; i < lst->length; i++) {
      replaceAtom(lst->sexps[i], o, d);
    }
    break;
  }
}

void storeexp(struct sexp **st, struct sexp *exp) {
  struct atom *atm;
  struct atom *atm0;
  struct list *lst;
  struct list *lst0;
  int i;

  switch (exp->type) {
  case ATOM:
    atm = (struct atom *)exp;
    atm0 = (struct atom *)*st;
    atm0->type = ATOM;
    strcpy((char *)atm0 + sizeof(struct atom), atm->symbol);
    atm0->symbol = (char *)atm0 + sizeof(struct atom);
    *st += sizeof(struct atom) + (atm->esymbol - atm->symbol);
    break;
  case LIST:
  case APPLY:
    lst = (struct list *)exp;
    lst0 = (struct list *)*st;
    lst0->type = lst->type;
    lst0->length = lst->length;
    *st += sizeof(struct list);
    for (i = 0; i < lst->length; i++) {
      lst0->sexps[i] = *st;
      storeexp(st, lst->sexps[i]);
    }
    break;
  }
}

void defunc(struct list *lst) {
  int i;
  struct shared *sh = (struct shared *)getsharem(0);
  struct func *fn = &sh->funcs[sh->nfunc];
  struct list *argv = (struct list *)lst->sexps[2];
  sh->nfunc++;

  strcpy(fn->name, ((struct atom *)lst->sexps[1])->symbol);
  fn->argc = argv->length;

  struct sexp *st = (struct sexp *)sh->top;
  storeexp((struct sexp **)&sh->top, lst->sexps[3]);
  fn->sexp = st;

  for (i = 0; i < fn->argc; i++)
    strcpy(fn->argv[i], ((struct atom *)argv->sexps[i])->symbol);
}

// Execute exp.  Never returns.
void runexp(struct sexp *exp) {

  int i;
  char *argv[MAXARGS];
  char xargv[MAXARGS][MAXARGL];
  struct list *lst;

  if (exp == 0)
    exit();

  switch (exp->type) {
  default:
    panic("runexp type error");

  case ATOM:
    break;

  case LIST:
    lst = (struct list *)exp;
    for (i = 0; i < lst->length; i++)
      runexp(lst->sexps[i]);
    break;

  case APPLY:
    lst = (struct list *)exp;
    argv[lst->length] = 0;
    for (i = 0; i < lst->length; i++) {
      if (lst->sexps[i]->type == ATOM)
        argv[i] = ((struct atom *)lst->sexps[i])->symbol;
      else if (lst->sexps[i]->type == LIST)
        panic("syntax error");
      else if (lst->sexps[i]->type == APPLY) {
        if (fork1() == 0) {
          close(1);
          getsharem(0);
          if (open(".etemp", O_WRONLY | O_CREATE) < 0) {
            printf(2, "open console temp file failed\n");
            exit();
          }
          runexp(lst->sexps[i]);
        }
        wait();

        close(2);
        int ffd;
        if ((ffd = open(".etemp", O_RDONLY)) < 0) {
          printf(1, "open console temp file failed\n");
          exit();
        }

        argv[i] = xargv[i];
        int n=read(2, argv[i], 20);
        argv[i][n] = 0;
        close(2);
        unlink(".etemp");
        open("console", O_RDWR);
      }
      if ((i == 0) && (strcmp(argv[0], "defun") == 0)) {
        if (fork1() == 0) {
          if (argv[0] == 0)
            exit();
          defunc(lst);
        }
        wait();
        break;
      }
      if (i == lst->length - 1) {
        int j, k, flg = 0;
        struct shared *sh = (struct shared *)getsharem(0);
        for (j = 0; j < MAXFUNC; j++) {
          if (strcmp(argv[0], sh->funcs[j].name) == 0) {

            argv[sh->funcs[j].argc+1] = 0;
            for (k = 0; k < MAXARGS; k++) {
              if (argv[k] == 0)
                break;
              strcpy(sh->xargv[k], argv[k]);
            }
            for (k = 0; k < sh->funcs[j].argc; k++)
            {
              replaceAtom(sh->funcs[j].sexp, sh->funcs[j].argv[k], sh->xargv[k + 1]);
              strcpy(sh->funcs[j].argv[k],argv[k+1]);
            }
            flg = 1;
            break;
          }
        }
        if (fork1() == 0) {
          if (argv[0] == 0)
            exit();
          if (flg == 1) {
            struct shared *sh = (struct shared *)getsharem(0);
            runexp(sh->funcs[j].sexp);
          } else {
            getsharem(0);
            int j;
            for (j = 0; j < MAXARGS; j++) {
              if (argv[j] == 0)
                break;
              if(argv[j]!=xargv[j])
              {
                strcpy(xargv[j], argv[j]);
                argv[j] = xargv[j];
              }
            }
            exec(argv[0], argv);
          }
        }
        wait();
      }
    }
    break;
  }

  exit();
}

int getcmd(char *buf, int nbuf) {
  printf(2, "> ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if (buf[0] == 0) // EOF
    return -1;
  return 0;
}


int main(void) {
  static char buf[100];
  int fd = 0;
  struct shared *sh = (struct shared *)getsharem(0);
  sh->nfunc = 0;
  sh->top = (char *)sh + sizeof(struct shared);
  split(-2);

  // Ensure that three file descriptors are open.
  while ((fd = open("console", O_RDWR)) >= 0) {
    if (fd >= 3) {
      close(fd);
      break;
    }
  }

  // Read and run input commands.
  while (getcmd(buf, sizeof(buf)) >= 0) {
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf) - 1] = 0; // chop \n
      if (chdir(buf + 3) < 0)
        printf(2, "cannot cd %s\n", buf + 3);
      continue;
    }
    if (fork1() == 0) {
      getsharem(0);
      runexp(parseexp(buf));
    }
    wait();
  }
  exit();
}

void panic(char *s) {
  printf(2, "%s\n", s);
  exit();
}

int fork1(void) {
  int pid;

  pid = fork();
  if (pid == -1)
    panic("fork");

  return pid;
}

// PAGEBREAK!
// Constructors

struct sexp *atom(void) {
  struct atom *exp;

  exp = malloc(sizeof(*exp));
  memset(exp, 0, sizeof(*exp));
  return (struct sexp *)exp;
}

struct sexp *list(void) {
  struct list *exp;

  exp = malloc(sizeof(*exp));
  memset(exp, 0, sizeof(*exp));
  return (struct sexp *)exp;
}

// PAGEBREAK!
// Parsing

char whitespace[] = " \t\r\n\v";
char esymbols[] = "()";

int peek(char **ps, char *es, char *toks) {
  char *s;

  s = *ps; while (s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
}

struct sexp *parselist(char **, char *);
struct sexp *parseatom(char **, char *);
struct sexp *parsesexp(char **, char *);
struct sexp *snulterminate(struct sexp *);

struct sexp *parselist(char **ps, char *es) {

  struct list *lst;
  struct sexp *ret;

  ret = list();
  lst = (struct list *)ret;
  lst->type = LIST;

  int i = 1;
  char *res = *ps;

  while (res < es) {
    if (*res == '(')
      i++;
    if (*res == ')') {
      i--;
      if (i == 0) {
        break;
      }
    }
    res++;
  }
  if (res == es)
    panic("syntax error");

  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
    lst->sexps[i] = parsesexp(ps, res);
  }
  lst->length = i;

  return ret;
}

struct sexp *parseatom(char **ps, char *es) {
  struct atom *atm;
  struct sexp *ret;

  char *s = *ps;
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
         !strchr(esymbols, *(*ps))) // peek whitespace
    (*ps)++;

  ret = atom();
  atm = (struct atom *)ret;

  atm->type = ATOM;
  atm->symbol = s;
  atm->esymbol = *ps;

  return ret;
}

struct sexp *parsesexp(char **ps, char *es) {
  struct sexp *ret = 0;

  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
    (*ps)++;
  switch (*(*ps)) {
  case 0:

    break;
  case '(':
    (*ps)++;
    ret = parselist(ps, es);
    ret->type = APPLY;
    (*ps)++;
    break;
  case '\'':
    (*ps) += 2;
    ret = parselist(ps, es);
    (*ps)++;
    break;
  default:
    ret = parseatom(ps, es);
    break;
  }
  return ret;
}

struct sexp *parseexp(char *s) {
  char *es;
  struct sexp *exp;

  es = s + strlen(s);
  exp = parsesexp(&s, es);
  peek(&s, es, "");
  if (s != es) {
    printf(2, "leftovers: %s\n", s);
    panic("syntax error");
  }
  snulterminate(exp);
  return exp;
}

struct sexp *snulterminate(struct sexp *exp) {
  int i;
  struct list *lst;
  struct atom *atm;

  if (exp == 0)
    return 0;

  switch (exp->type) {
  case ATOM:
    atm = (struct atom *)exp;
    *atm->esymbol = 0;
    break;

  case APPLY:
  case LIST:
    lst = (struct list *)exp;
    for (i = 0; i < lst->length; i++)
      snulterminate(lst->sexps[i]);
    break;
  }
  return exp;
}
