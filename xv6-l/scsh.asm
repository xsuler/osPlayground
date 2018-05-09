
_scsh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
  11:	eb 0a                	jmp    1d <main+0x1d>
  13:	90                   	nop
  14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
  18:	83 f8 02             	cmp    $0x2,%eax
  1b:	7f 76                	jg     93 <main+0x93>
  while((fd = open("console", O_RDWR)) >= 0){
  1d:	83 ec 08             	sub    $0x8,%esp
  20:	6a 02                	push   $0x2
  22:	68 7d 0c 00 00       	push   $0xc7d
  27:	e8 c6 07 00 00       	call   7f2 <open>
  2c:	83 c4 10             	add    $0x10,%esp
  2f:	85 c0                	test   %eax,%eax
  31:	79 e5                	jns    18 <main+0x18>
  33:	eb 1f                	jmp    54 <main+0x54>
  35:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
  38:	80 3d 62 11 00 00 20 	cmpb   $0x20,0x1162
  3f:	74 7a                	je     bb <main+0xbb>
int
fork1(void)
{
  int pid;

  pid = fork();
  41:	e8 64 07 00 00       	call   7aa <fork>
  if(pid == -1)
  46:	83 f8 ff             	cmp    $0xffffffff,%eax
  49:	74 3b                	je     86 <main+0x86>
    if(fork1() == 0)
  4b:	85 c0                	test   %eax,%eax
  4d:	74 57                	je     a6 <main+0xa6>
    wait();
  4f:	e8 66 07 00 00       	call   7ba <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
  54:	83 ec 08             	sub    $0x8,%esp
  57:	6a 64                	push   $0x64
  59:	68 60 11 00 00       	push   $0x1160
  5e:	e8 9d 00 00 00       	call   100 <getcmd>
  63:	83 c4 10             	add    $0x10,%esp
  66:	85 c0                	test   %eax,%eax
  68:	78 37                	js     a1 <main+0xa1>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
  6a:	80 3d 60 11 00 00 63 	cmpb   $0x63,0x1160
  71:	75 ce                	jne    41 <main+0x41>
  73:	80 3d 61 11 00 00 64 	cmpb   $0x64,0x1161
  7a:	74 bc                	je     38 <main+0x38>
  pid = fork();
  7c:	e8 29 07 00 00       	call   7aa <fork>
  if(pid == -1)
  81:	83 f8 ff             	cmp    $0xffffffff,%eax
  84:	75 c5                	jne    4b <main+0x4b>
    panic("fork");
  86:	83 ec 0c             	sub    $0xc,%esp
  89:	68 62 0c 00 00       	push   $0xc62
  8e:	e8 bd 00 00 00       	call   150 <panic>
      close(fd);
  93:	83 ec 0c             	sub    $0xc,%esp
  96:	50                   	push   %eax
  97:	e8 3e 07 00 00       	call   7da <close>
      break;
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	eb b3                	jmp    54 <main+0x54>
  exit();
  a1:	e8 0c 07 00 00       	call   7b2 <exit>
      runexp(parseexp(buf));
  a6:	83 ec 0c             	sub    $0xc,%esp
  a9:	68 60 11 00 00       	push   $0x1160
  ae:	e8 3d 04 00 00       	call   4f0 <parseexp>
  b3:	89 04 24             	mov    %eax,(%esp)
  b6:	e8 b5 00 00 00       	call   170 <runexp>
      buf[strlen(buf)-1] = 0;  // chop \n
  bb:	83 ec 0c             	sub    $0xc,%esp
  be:	68 60 11 00 00       	push   $0x1160
  c3:	e8 18 05 00 00       	call   5e0 <strlen>
      if(chdir(buf+3) < 0)
  c8:	c7 04 24 63 11 00 00 	movl   $0x1163,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
  cf:	c6 80 5f 11 00 00 00 	movb   $0x0,0x115f(%eax)
      if(chdir(buf+3) < 0)
  d6:	e8 47 07 00 00       	call   822 <chdir>
  db:	83 c4 10             	add    $0x10,%esp
  de:	85 c0                	test   %eax,%eax
  e0:	0f 89 6e ff ff ff    	jns    54 <main+0x54>
        printf(2, "cannot cd %s\n", buf+3);
  e6:	50                   	push   %eax
  e7:	68 63 11 00 00       	push   $0x1163
  ec:	68 85 0c 00 00       	push   $0xc85
  f1:	6a 02                	push   $0x2
  f3:	e8 08 08 00 00       	call   900 <printf>
  f8:	83 c4 10             	add    $0x10,%esp
  fb:	e9 54 ff ff ff       	jmp    54 <main+0x54>

00000100 <getcmd>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	56                   	push   %esi
 104:	53                   	push   %ebx
 105:	8b 75 0c             	mov    0xc(%ebp),%esi
 108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
 10b:	83 ec 08             	sub    $0x8,%esp
 10e:	68 58 0c 00 00       	push   $0xc58
 113:	6a 02                	push   $0x2
 115:	e8 e6 07 00 00       	call   900 <printf>
  memset(buf, 0, nbuf);
 11a:	83 c4 0c             	add    $0xc,%esp
 11d:	56                   	push   %esi
 11e:	6a 00                	push   $0x0
 120:	53                   	push   %ebx
 121:	e8 ea 04 00 00       	call   610 <memset>
  gets(buf, nbuf);
 126:	58                   	pop    %eax
 127:	5a                   	pop    %edx
 128:	56                   	push   %esi
 129:	53                   	push   %ebx
 12a:	e8 41 05 00 00       	call   670 <gets>
  if(buf[0] == 0) // EOF
 12f:	83 c4 10             	add    $0x10,%esp
 132:	31 c0                	xor    %eax,%eax
 134:	80 3b 00             	cmpb   $0x0,(%ebx)
 137:	0f 94 c0             	sete   %al
}
 13a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(buf[0] == 0) // EOF
 13d:	f7 d8                	neg    %eax
}
 13f:	5b                   	pop    %ebx
 140:	5e                   	pop    %esi
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    
 143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <panic>:
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
 156:	ff 75 08             	pushl  0x8(%ebp)
 159:	68 79 0c 00 00       	push   $0xc79
 15e:	6a 02                	push   $0x2
 160:	e8 9b 07 00 00       	call   900 <printf>
  exit();
 165:	e8 48 06 00 00       	call   7b2 <exit>
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000170 <runexp>:
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 08             	sub    $0x8,%esp
 176:	8b 45 08             	mov    0x8(%ebp),%eax
  if(exp== 0)
 179:	85 c0                	test   %eax,%eax
 17b:	74 23                	je     1a0 <runexp+0x30>
  switch(exp->type){
 17d:	8b 10                	mov    (%eax),%edx
 17f:	83 fa 02             	cmp    $0x2,%edx
 182:	74 24                	je     1a8 <runexp+0x38>
 184:	83 fa 03             	cmp    $0x3,%edx
 187:	74 17                	je     1a0 <runexp+0x30>
 189:	83 ea 01             	sub    $0x1,%edx
 18c:	74 12                	je     1a0 <runexp+0x30>
    panic("runexp");
 18e:	83 ec 0c             	sub    $0xc,%esp
 191:	68 5b 0c 00 00       	push   $0xc5b
 196:	e8 b5 ff ff ff       	call   150 <panic>
 19b:	90                   	nop
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  exit();
 1a0:	e8 0d 06 00 00       	call   7b2 <exit>
 1a5:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0;i<lst->length;i++)
 1a8:	8b 50 04             	mov    0x4(%eax),%edx
 1ab:	85 d2                	test   %edx,%edx
 1ad:	7e f1                	jle    1a0 <runexp+0x30>
      runexp(lst->sexps[i]);
 1af:	83 ec 0c             	sub    $0xc,%esp
 1b2:	ff 70 08             	pushl  0x8(%eax)
 1b5:	e8 b6 ff ff ff       	call   170 <runexp>
 1ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001c0 <fork1>:
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
 1c6:	e8 df 05 00 00       	call   7aa <fork>
  if(pid == -1)
 1cb:	83 f8 ff             	cmp    $0xffffffff,%eax
 1ce:	74 02                	je     1d2 <fork1+0x12>
  return pid;
}
 1d0:	c9                   	leave  
 1d1:	c3                   	ret    
    panic("fork");
 1d2:	83 ec 0c             	sub    $0xc,%esp
 1d5:	68 62 0c 00 00       	push   $0xc62
 1da:	e8 71 ff ff ff       	call   150 <panic>
 1df:	90                   	nop

000001e0 <atom>:
//PAGEBREAK!
// Constructors

struct sexp*
atom(void)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	83 ec 10             	sub    $0x10,%esp
  struct atom *exp;

  exp= malloc(sizeof(*exp));
 1e7:	6a 0c                	push   $0xc
 1e9:	e8 72 09 00 00       	call   b60 <malloc>
  memset(exp, 0, sizeof(*exp));
 1ee:	83 c4 0c             	add    $0xc,%esp
  exp= malloc(sizeof(*exp));
 1f1:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
 1f3:	6a 0c                	push   $0xc
 1f5:	6a 00                	push   $0x0
 1f7:	50                   	push   %eax
 1f8:	e8 13 04 00 00       	call   610 <memset>
  return (struct sexp*)exp;
}
 1fd:	89 d8                	mov    %ebx,%eax
 1ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 202:	c9                   	leave  
 203:	c3                   	ret    
 204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 20a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000210 <list>:

struct sexp*
list(void)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	83 ec 10             	sub    $0x10,%esp
  struct list*exp;

  exp= malloc(sizeof(*exp));
 217:	6a 30                	push   $0x30
 219:	e8 42 09 00 00       	call   b60 <malloc>
  memset(exp, 0, sizeof(*exp));
 21e:	83 c4 0c             	add    $0xc,%esp
  exp= malloc(sizeof(*exp));
 221:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
 223:	6a 30                	push   $0x30
 225:	6a 00                	push   $0x0
 227:	50                   	push   %eax
 228:	e8 e3 03 00 00       	call   610 <memset>
  return (struct sexp*)exp;
}
 22d:	89 d8                	mov    %ebx,%eax
 22f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 232:	c9                   	leave  
 233:	c3                   	ret    
 234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 23a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000240 <peek>:
char whitespace[] = " \t\r\n\v";
char esymbols[] = "()";

int
peek(char **ps, char *es, char *toks)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	56                   	push   %esi
 245:	53                   	push   %ebx
 246:	83 ec 0c             	sub    $0xc,%esp
 249:	8b 7d 08             	mov    0x8(%ebp),%edi
 24c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
 24f:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
 251:	39 f3                	cmp    %esi,%ebx
 253:	72 12                	jb     267 <peek+0x27>
 255:	eb 28                	jmp    27f <peek+0x3f>
 257:	89 f6                	mov    %esi,%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
 260:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
 263:	39 de                	cmp    %ebx,%esi
 265:	74 18                	je     27f <peek+0x3f>
 267:	0f be 03             	movsbl (%ebx),%eax
 26a:	83 ec 08             	sub    $0x8,%esp
 26d:	50                   	push   %eax
 26e:	68 40 11 00 00       	push   $0x1140
 273:	e8 b8 03 00 00       	call   630 <strchr>
 278:	83 c4 10             	add    $0x10,%esp
 27b:	85 c0                	test   %eax,%eax
 27d:	75 e1                	jne    260 <peek+0x20>
  *ps = s;
 27f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
 281:	0f be 13             	movsbl (%ebx),%edx
 284:	31 c0                	xor    %eax,%eax
 286:	84 d2                	test   %dl,%dl
 288:	74 17                	je     2a1 <peek+0x61>
 28a:	83 ec 08             	sub    $0x8,%esp
 28d:	52                   	push   %edx
 28e:	ff 75 10             	pushl  0x10(%ebp)
 291:	e8 9a 03 00 00       	call   630 <strchr>
 296:	83 c4 10             	add    $0x10,%esp
 299:	85 c0                	test   %eax,%eax
 29b:	0f 95 c0             	setne  %al
 29e:	0f b6 c0             	movzbl %al,%eax
}
 2a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2a4:	5b                   	pop    %ebx
 2a5:	5e                   	pop    %esi
 2a6:	5f                   	pop    %edi
 2a7:	5d                   	pop    %ebp
 2a8:	c3                   	ret    
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002b0 <parseatom>:
  return ret;
}

struct sexp*
parseatom(char **ps, char *es)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
 2b5:	53                   	push   %ebx
 2b6:	83 ec 0c             	sub    $0xc,%esp
 2b9:	8b 7d 08             	mov    0x8(%ebp),%edi
 2bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct atom *atm;
  struct sexp *ret;

  char *s=*ps;
 2bf:	8b 37                	mov    (%edi),%esi
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
 2c1:	39 de                	cmp    %ebx,%esi
 2c3:	89 f0                	mov    %esi,%eax
 2c5:	72 2e                	jb     2f5 <parseatom+0x45>
 2c7:	eb 44                	jmp    30d <parseatom+0x5d>
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2d0:	8b 07                	mov    (%edi),%eax
 2d2:	83 ec 08             	sub    $0x8,%esp
 2d5:	0f be 00             	movsbl (%eax),%eax
 2d8:	50                   	push   %eax
 2d9:	68 3c 11 00 00       	push   $0x113c
 2de:	e8 4d 03 00 00       	call   630 <strchr>
 2e3:	83 c4 10             	add    $0x10,%esp
 2e6:	85 c0                	test   %eax,%eax
 2e8:	75 23                	jne    30d <parseatom+0x5d>
    (*ps)++;
 2ea:	8b 07                	mov    (%edi),%eax
 2ec:	83 c0 01             	add    $0x1,%eax
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
 2ef:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
 2f1:	89 07                	mov    %eax,(%edi)
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
 2f3:	73 18                	jae    30d <parseatom+0x5d>
 2f5:	0f be 00             	movsbl (%eax),%eax
 2f8:	83 ec 08             	sub    $0x8,%esp
 2fb:	50                   	push   %eax
 2fc:	68 40 11 00 00       	push   $0x1140
 301:	e8 2a 03 00 00       	call   630 <strchr>
 306:	83 c4 10             	add    $0x10,%esp
 309:	85 c0                	test   %eax,%eax
 30b:	74 c3                	je     2d0 <parseatom+0x20>

  ret=atom();
 30d:	e8 ce fe ff ff       	call   1e0 <atom>
  atm=(struct atom*)ret;

  atm->type=ATOM;
 312:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  atm->symbol=s;
 318:	89 70 04             	mov    %esi,0x4(%eax)
  atm->esymbol=*ps;
 31b:	8b 17                	mov    (%edi),%edx
 31d:	89 50 08             	mov    %edx,0x8(%eax)

  return ret;
}
 320:	8d 65 f4             	lea    -0xc(%ebp),%esp
 323:	5b                   	pop    %ebx
 324:	5e                   	pop    %esi
 325:	5f                   	pop    %edi
 326:	5d                   	pop    %ebp
 327:	c3                   	ret    
 328:	90                   	nop
 329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000330 <parsesexp>:

struct sexp*
parsesexp(char **ps, char *es)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	56                   	push   %esi
 334:	53                   	push   %ebx
 335:	8b 75 08             	mov    0x8(%ebp),%esi
 338:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct sexp *ret=0;

  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 33b:	8b 06                	mov    (%esi),%eax
 33d:	39 c3                	cmp    %eax,%ebx
 33f:	77 10                	ja     351 <parsesexp+0x21>
 341:	eb 28                	jmp    36b <parsesexp+0x3b>
 343:	90                   	nop
 344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    (*ps)++;
 348:	83 c0 01             	add    $0x1,%eax
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 34b:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
 34d:	89 06                	mov    %eax,(%esi)
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 34f:	73 1a                	jae    36b <parsesexp+0x3b>
 351:	0f be 00             	movsbl (%eax),%eax
 354:	83 ec 08             	sub    $0x8,%esp
 357:	50                   	push   %eax
 358:	68 40 11 00 00       	push   $0x1140
 35d:	e8 ce 02 00 00       	call   630 <strchr>
 362:	83 c4 10             	add    $0x10,%esp
 365:	85 c0                	test   %eax,%eax
    (*ps)++;
 367:	8b 06                	mov    (%esi),%eax
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
 369:	75 dd                	jne    348 <parsesexp+0x18>
  switch(*(*ps)){
 36b:	0f b6 10             	movzbl (%eax),%edx
 36e:	80 fa 27             	cmp    $0x27,%dl
 371:	74 55                	je     3c8 <parsesexp+0x98>
 373:	80 fa 28             	cmp    $0x28,%dl
 376:	74 28                	je     3a0 <parsesexp+0x70>
 378:	84 d2                	test   %dl,%dl
 37a:	74 14                	je     390 <parsesexp+0x60>
    (*ps)+=2;
    ret=parselist(ps, es);
    (*ps)++;
    break;
  default:
    ret=parseatom(ps, es);
 37c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
 37f:	89 75 08             	mov    %esi,0x8(%ebp)
    break;
  }
  return ret;
}
 382:	8d 65 f8             	lea    -0x8(%ebp),%esp
 385:	5b                   	pop    %ebx
 386:	5e                   	pop    %esi
 387:	5d                   	pop    %ebp
    ret=parseatom(ps, es);
 388:	e9 23 ff ff ff       	jmp    2b0 <parseatom>
 38d:	8d 76 00             	lea    0x0(%esi),%esi
}
 390:	8d 65 f8             	lea    -0x8(%ebp),%esp
  struct sexp *ret=0;
 393:	31 c0                	xor    %eax,%eax
}
 395:	5b                   	pop    %ebx
 396:	5e                   	pop    %esi
 397:	5d                   	pop    %ebp
 398:	c3                   	ret    
 399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret=parselist(ps, es);
 3a0:	83 ec 08             	sub    $0x8,%esp
    (*ps)++;
 3a3:	83 c0 01             	add    $0x1,%eax
 3a6:	89 06                	mov    %eax,(%esi)
    ret=parselist(ps, es);
 3a8:	53                   	push   %ebx
 3a9:	56                   	push   %esi
 3aa:	e8 41 00 00 00       	call   3f0 <parselist>
    ret->type=APPLY;
 3af:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    break;
 3b5:	83 c4 10             	add    $0x10,%esp
    (*ps)++;
 3b8:	83 06 01             	addl   $0x1,(%esi)
}
 3bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3be:	5b                   	pop    %ebx
 3bf:	5e                   	pop    %esi
 3c0:	5d                   	pop    %ebp
 3c1:	c3                   	ret    
 3c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ret=parselist(ps, es);
 3c8:	83 ec 08             	sub    $0x8,%esp
    (*ps)+=2;
 3cb:	83 c0 02             	add    $0x2,%eax
 3ce:	89 06                	mov    %eax,(%esi)
    ret=parselist(ps, es);
 3d0:	53                   	push   %ebx
 3d1:	56                   	push   %esi
 3d2:	e8 19 00 00 00       	call   3f0 <parselist>
    (*ps)++;
 3d7:	83 06 01             	addl   $0x1,(%esi)
    break;
 3da:	83 c4 10             	add    $0x10,%esp
}
 3dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3e0:	5b                   	pop    %ebx
 3e1:	5e                   	pop    %esi
 3e2:	5d                   	pop    %ebp
 3e3:	c3                   	ret    
 3e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003f0 <parselist>:
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 1c             	sub    $0x1c,%esp
 3f9:	8b 75 08             	mov    0x8(%ebp),%esi
 3fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  ret=list();
 3ff:	e8 0c fe ff ff       	call   210 <list>
  lst->type=LIST;
 404:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  ret=list();
 40a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *res=*ps;
 40d:	8b 0e                	mov    (%esi),%ecx
  while(res<es)
 40f:	39 f9                	cmp    %edi,%ecx
 411:	89 cb                	mov    %ecx,%ebx
 413:	73 3b                	jae    450 <parselist+0x60>
  int i=1;
 415:	ba 01 00 00 00       	mov    $0x1,%edx
 41a:	eb 14                	jmp    430 <parselist+0x40>
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*res==')')
 420:	3c 29                	cmp    $0x29,%al
 422:	75 05                	jne    429 <parselist+0x39>
      if(i==0)
 424:	83 ea 01             	sub    $0x1,%edx
 427:	74 27                	je     450 <parselist+0x60>
    res++;
 429:	83 c3 01             	add    $0x1,%ebx
  while(res<es)
 42c:	39 df                	cmp    %ebx,%edi
 42e:	74 11                	je     441 <parselist+0x51>
    if(*res=='(')
 430:	0f b6 03             	movzbl (%ebx),%eax
 433:	3c 28                	cmp    $0x28,%al
 435:	75 e9                	jne    420 <parselist+0x30>
    res++;
 437:	83 c3 01             	add    $0x1,%ebx
      i++;
 43a:	83 c2 01             	add    $0x1,%edx
  while(res<es)
 43d:	39 df                	cmp    %ebx,%edi
 43f:	75 ef                	jne    430 <parselist+0x40>
    panic("syntax");
 441:	83 ec 0c             	sub    $0xc,%esp
 444:	68 67 0c 00 00       	push   $0xc67
 449:	e8 02 fd ff ff       	call   150 <panic>
 44e:	66 90                	xchg   %ax,%ax
  if(res==es)
 450:	39 df                	cmp    %ebx,%edi
 452:	74 ed                	je     441 <parselist+0x51>
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
 454:	31 ff                	xor    %edi,%edi
 456:	eb 0a                	jmp    462 <parselist+0x72>
 458:	90                   	nop
 459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 460:	8b 0e                	mov    (%esi),%ecx
 462:	39 d9                	cmp    %ebx,%ecx
 464:	73 1c                	jae    482 <parselist+0x92>
    lst->sexps[i]=parsesexp(ps, res);
 466:	83 ec 08             	sub    $0x8,%esp
 469:	53                   	push   %ebx
 46a:	56                   	push   %esi
 46b:	e8 c0 fe ff ff       	call   330 <parsesexp>
 470:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
 473:	83 c4 10             	add    $0x10,%esp
    lst->sexps[i]=parsesexp(ps, res);
 476:	89 44 ba 08          	mov    %eax,0x8(%edx,%edi,4)
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
 47a:	83 c7 01             	add    $0x1,%edi
 47d:	83 ff 0a             	cmp    $0xa,%edi
 480:	75 de                	jne    460 <parselist+0x70>
  lst->length=i;
 482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 485:	89 78 04             	mov    %edi,0x4(%eax)
}
 488:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48b:	5b                   	pop    %ebx
 48c:	5e                   	pop    %esi
 48d:	5f                   	pop    %edi
 48e:	5d                   	pop    %ebp
 48f:	c3                   	ret    

00000490 <snulterminate>:
  return exp;
}

struct sexp*
snulterminate(struct sexp *exp)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	56                   	push   %esi
 494:	53                   	push   %ebx
 495:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;
  struct list *lst;
  struct atom *atm;

  if(exp== 0)
 498:	85 db                	test   %ebx,%ebx
 49a:	74 2e                	je     4ca <snulterminate+0x3a>
    return 0;

  switch(exp->type){
 49c:	8b 03                	mov    (%ebx),%eax
 49e:	83 f8 01             	cmp    $0x1,%eax
 4a1:	74 35                	je     4d8 <snulterminate+0x48>
 4a3:	7c 25                	jl     4ca <snulterminate+0x3a>
 4a5:	83 f8 03             	cmp    $0x3,%eax
 4a8:	7f 20                	jg     4ca <snulterminate+0x3a>
    break;

  case APPLY:
  case LIST:
    lst = (struct list*)exp;
    for(i=0;i<lst->length;i++)
 4aa:	8b 43 04             	mov    0x4(%ebx),%eax
 4ad:	31 f6                	xor    %esi,%esi
 4af:	85 c0                	test   %eax,%eax
 4b1:	7e 17                	jle    4ca <snulterminate+0x3a>
      snulterminate(lst->sexps[i]);
 4b3:	83 ec 0c             	sub    $0xc,%esp
 4b6:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
    for(i=0;i<lst->length;i++)
 4ba:	83 c6 01             	add    $0x1,%esi
      snulterminate(lst->sexps[i]);
 4bd:	e8 ce ff ff ff       	call   490 <snulterminate>
    for(i=0;i<lst->length;i++)
 4c2:	83 c4 10             	add    $0x10,%esp
 4c5:	3b 73 04             	cmp    0x4(%ebx),%esi
 4c8:	7c e9                	jl     4b3 <snulterminate+0x23>
    break;
  }
  return exp;
}
 4ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4cd:	89 d8                	mov    %ebx,%eax
 4cf:	5b                   	pop    %ebx
 4d0:	5e                   	pop    %esi
 4d1:	5d                   	pop    %ebp
 4d2:	c3                   	ret    
 4d3:	90                   	nop
 4d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *atm->esymbol = 0;
 4d8:	8b 43 08             	mov    0x8(%ebx),%eax
 4db:	c6 00 00             	movb   $0x0,(%eax)
}
 4de:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4e1:	89 d8                	mov    %ebx,%eax
 4e3:	5b                   	pop    %ebx
 4e4:	5e                   	pop    %esi
 4e5:	5d                   	pop    %ebp
 4e6:	c3                   	ret    
 4e7:	89 f6                	mov    %esi,%esi
 4e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004f0 <parseexp>:
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	56                   	push   %esi
 4f4:	53                   	push   %ebx
  es = s + strlen(s);
 4f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4f8:	83 ec 0c             	sub    $0xc,%esp
 4fb:	53                   	push   %ebx
 4fc:	e8 df 00 00 00       	call   5e0 <strlen>
  exp= parsesexp(&s, es);
 501:	59                   	pop    %ecx
  es = s + strlen(s);
 502:	01 c3                	add    %eax,%ebx
  exp= parsesexp(&s, es);
 504:	8d 45 08             	lea    0x8(%ebp),%eax
 507:	5e                   	pop    %esi
 508:	53                   	push   %ebx
 509:	50                   	push   %eax
 50a:	e8 21 fe ff ff       	call   330 <parsesexp>
 50f:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
 511:	8d 45 08             	lea    0x8(%ebp),%eax
 514:	83 c4 0c             	add    $0xc,%esp
 517:	68 7c 0c 00 00       	push   $0xc7c
 51c:	53                   	push   %ebx
 51d:	50                   	push   %eax
 51e:	e8 1d fd ff ff       	call   240 <peek>
  if(s != es){
 523:	8b 45 08             	mov    0x8(%ebp),%eax
 526:	83 c4 10             	add    $0x10,%esp
 529:	39 d8                	cmp    %ebx,%eax
 52b:	75 12                	jne    53f <parseexp+0x4f>
  snulterminate(exp);
 52d:	83 ec 0c             	sub    $0xc,%esp
 530:	56                   	push   %esi
 531:	e8 5a ff ff ff       	call   490 <snulterminate>
}
 536:	8d 65 f8             	lea    -0x8(%ebp),%esp
 539:	89 f0                	mov    %esi,%eax
 53b:	5b                   	pop    %ebx
 53c:	5e                   	pop    %esi
 53d:	5d                   	pop    %ebp
 53e:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
 53f:	52                   	push   %edx
 540:	50                   	push   %eax
 541:	68 6e 0c 00 00       	push   $0xc6e
 546:	6a 02                	push   $0x2
 548:	e8 b3 03 00 00       	call   900 <printf>
    panic("syntax");
 54d:	c7 04 24 67 0c 00 00 	movl   $0xc67,(%esp)
 554:	e8 f7 fb ff ff       	call   150 <panic>
 559:	66 90                	xchg   %ax,%ax
 55b:	66 90                	xchg   %ax,%ax
 55d:	66 90                	xchg   %ax,%ax
 55f:	90                   	nop

00000560 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	53                   	push   %ebx
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 56a:	89 c2                	mov    %eax,%edx
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 570:	83 c1 01             	add    $0x1,%ecx
 573:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 577:	83 c2 01             	add    $0x1,%edx
 57a:	84 db                	test   %bl,%bl
 57c:	88 5a ff             	mov    %bl,-0x1(%edx)
 57f:	75 ef                	jne    570 <strcpy+0x10>
    ;
  return os;
}
 581:	5b                   	pop    %ebx
 582:	5d                   	pop    %ebp
 583:	c3                   	ret    
 584:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 58a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000590 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	53                   	push   %ebx
 594:	8b 55 08             	mov    0x8(%ebp),%edx
 597:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 59a:	0f b6 02             	movzbl (%edx),%eax
 59d:	0f b6 19             	movzbl (%ecx),%ebx
 5a0:	84 c0                	test   %al,%al
 5a2:	75 1c                	jne    5c0 <strcmp+0x30>
 5a4:	eb 2a                	jmp    5d0 <strcmp+0x40>
 5a6:	8d 76 00             	lea    0x0(%esi),%esi
 5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 5b0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 5b3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 5b6:	83 c1 01             	add    $0x1,%ecx
 5b9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 5bc:	84 c0                	test   %al,%al
 5be:	74 10                	je     5d0 <strcmp+0x40>
 5c0:	38 d8                	cmp    %bl,%al
 5c2:	74 ec                	je     5b0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 5c4:	29 d8                	sub    %ebx,%eax
}
 5c6:	5b                   	pop    %ebx
 5c7:	5d                   	pop    %ebp
 5c8:	c3                   	ret    
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5d0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 5d2:	29 d8                	sub    %ebx,%eax
}
 5d4:	5b                   	pop    %ebx
 5d5:	5d                   	pop    %ebp
 5d6:	c3                   	ret    
 5d7:	89 f6                	mov    %esi,%esi
 5d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005e0 <strlen>:

uint
strlen(char *s)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 5e6:	80 39 00             	cmpb   $0x0,(%ecx)
 5e9:	74 15                	je     600 <strlen+0x20>
 5eb:	31 d2                	xor    %edx,%edx
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
 5f0:	83 c2 01             	add    $0x1,%edx
 5f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 5f7:	89 d0                	mov    %edx,%eax
 5f9:	75 f5                	jne    5f0 <strlen+0x10>
    ;
  return n;
}
 5fb:	5d                   	pop    %ebp
 5fc:	c3                   	ret    
 5fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 600:	31 c0                	xor    %eax,%eax
}
 602:	5d                   	pop    %ebp
 603:	c3                   	ret    
 604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 60a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000610 <memset>:

void*
memset(void *dst, int c, uint n)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 617:	8b 4d 10             	mov    0x10(%ebp),%ecx
 61a:	8b 45 0c             	mov    0xc(%ebp),%eax
 61d:	89 d7                	mov    %edx,%edi
 61f:	fc                   	cld    
 620:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 622:	89 d0                	mov    %edx,%eax
 624:	5f                   	pop    %edi
 625:	5d                   	pop    %ebp
 626:	c3                   	ret    
 627:	89 f6                	mov    %esi,%esi
 629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000630 <strchr>:

char*
strchr(const char *s, char c)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	53                   	push   %ebx
 634:	8b 45 08             	mov    0x8(%ebp),%eax
 637:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 63a:	0f b6 10             	movzbl (%eax),%edx
 63d:	84 d2                	test   %dl,%dl
 63f:	74 1d                	je     65e <strchr+0x2e>
    if(*s == c)
 641:	38 d3                	cmp    %dl,%bl
 643:	89 d9                	mov    %ebx,%ecx
 645:	75 0d                	jne    654 <strchr+0x24>
 647:	eb 17                	jmp    660 <strchr+0x30>
 649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 650:	38 ca                	cmp    %cl,%dl
 652:	74 0c                	je     660 <strchr+0x30>
  for(; *s; s++)
 654:	83 c0 01             	add    $0x1,%eax
 657:	0f b6 10             	movzbl (%eax),%edx
 65a:	84 d2                	test   %dl,%dl
 65c:	75 f2                	jne    650 <strchr+0x20>
      return (char*)s;
  return 0;
 65e:	31 c0                	xor    %eax,%eax
}
 660:	5b                   	pop    %ebx
 661:	5d                   	pop    %ebp
 662:	c3                   	ret    
 663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000670 <gets>:

char*
gets(char *buf, int max)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 676:	31 f6                	xor    %esi,%esi
 678:	89 f3                	mov    %esi,%ebx
{
 67a:	83 ec 1c             	sub    $0x1c,%esp
 67d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 680:	eb 2f                	jmp    6b1 <gets+0x41>
 682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 688:	8d 45 e7             	lea    -0x19(%ebp),%eax
 68b:	83 ec 04             	sub    $0x4,%esp
 68e:	6a 01                	push   $0x1
 690:	50                   	push   %eax
 691:	6a 00                	push   $0x0
 693:	e8 32 01 00 00       	call   7ca <read>
    if(cc < 1)
 698:	83 c4 10             	add    $0x10,%esp
 69b:	85 c0                	test   %eax,%eax
 69d:	7e 1c                	jle    6bb <gets+0x4b>
      break;
    buf[i++] = c;
 69f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 6a3:	83 c7 01             	add    $0x1,%edi
 6a6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 6a9:	3c 0a                	cmp    $0xa,%al
 6ab:	74 23                	je     6d0 <gets+0x60>
 6ad:	3c 0d                	cmp    $0xd,%al
 6af:	74 1f                	je     6d0 <gets+0x60>
  for(i=0; i+1 < max; ){
 6b1:	83 c3 01             	add    $0x1,%ebx
 6b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 6b7:	89 fe                	mov    %edi,%esi
 6b9:	7c cd                	jl     688 <gets+0x18>
 6bb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 6bd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 6c0:	c6 03 00             	movb   $0x0,(%ebx)
}
 6c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c6:	5b                   	pop    %ebx
 6c7:	5e                   	pop    %esi
 6c8:	5f                   	pop    %edi
 6c9:	5d                   	pop    %ebp
 6ca:	c3                   	ret    
 6cb:	90                   	nop
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6d0:	8b 75 08             	mov    0x8(%ebp),%esi
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	01 de                	add    %ebx,%esi
 6d8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 6da:	c6 03 00             	movb   $0x0,(%ebx)
}
 6dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e0:	5b                   	pop    %ebx
 6e1:	5e                   	pop    %esi
 6e2:	5f                   	pop    %edi
 6e3:	5d                   	pop    %ebp
 6e4:	c3                   	ret    
 6e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006f0 <stat>:

int
stat(char *n, struct stat *st)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	56                   	push   %esi
 6f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6f5:	83 ec 08             	sub    $0x8,%esp
 6f8:	6a 00                	push   $0x0
 6fa:	ff 75 08             	pushl  0x8(%ebp)
 6fd:	e8 f0 00 00 00       	call   7f2 <open>
  if(fd < 0)
 702:	83 c4 10             	add    $0x10,%esp
 705:	85 c0                	test   %eax,%eax
 707:	78 27                	js     730 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 709:	83 ec 08             	sub    $0x8,%esp
 70c:	ff 75 0c             	pushl  0xc(%ebp)
 70f:	89 c3                	mov    %eax,%ebx
 711:	50                   	push   %eax
 712:	e8 f3 00 00 00       	call   80a <fstat>
  close(fd);
 717:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 71a:	89 c6                	mov    %eax,%esi
  close(fd);
 71c:	e8 b9 00 00 00       	call   7da <close>
  return r;
 721:	83 c4 10             	add    $0x10,%esp
}
 724:	8d 65 f8             	lea    -0x8(%ebp),%esp
 727:	89 f0                	mov    %esi,%eax
 729:	5b                   	pop    %ebx
 72a:	5e                   	pop    %esi
 72b:	5d                   	pop    %ebp
 72c:	c3                   	ret    
 72d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 730:	be ff ff ff ff       	mov    $0xffffffff,%esi
 735:	eb ed                	jmp    724 <stat+0x34>
 737:	89 f6                	mov    %esi,%esi
 739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000740 <atoi>:

int
atoi(const char *s)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	53                   	push   %ebx
 744:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 747:	0f be 11             	movsbl (%ecx),%edx
 74a:	8d 42 d0             	lea    -0x30(%edx),%eax
 74d:	3c 09                	cmp    $0x9,%al
  n = 0;
 74f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 754:	77 1f                	ja     775 <atoi+0x35>
 756:	8d 76 00             	lea    0x0(%esi),%esi
 759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 760:	8d 04 80             	lea    (%eax,%eax,4),%eax
 763:	83 c1 01             	add    $0x1,%ecx
 766:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 76a:	0f be 11             	movsbl (%ecx),%edx
 76d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 770:	80 fb 09             	cmp    $0x9,%bl
 773:	76 eb                	jbe    760 <atoi+0x20>
  return n;
}
 775:	5b                   	pop    %ebx
 776:	5d                   	pop    %ebp
 777:	c3                   	ret    
 778:	90                   	nop
 779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000780 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	56                   	push   %esi
 784:	53                   	push   %ebx
 785:	8b 5d 10             	mov    0x10(%ebp),%ebx
 788:	8b 45 08             	mov    0x8(%ebp),%eax
 78b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 78e:	85 db                	test   %ebx,%ebx
 790:	7e 14                	jle    7a6 <memmove+0x26>
 792:	31 d2                	xor    %edx,%edx
 794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 798:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 79c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 79f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 7a2:	39 d3                	cmp    %edx,%ebx
 7a4:	75 f2                	jne    798 <memmove+0x18>
  return vdst;
}
 7a6:	5b                   	pop    %ebx
 7a7:	5e                   	pop    %esi
 7a8:	5d                   	pop    %ebp
 7a9:	c3                   	ret    

000007aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7aa:	b8 01 00 00 00       	mov    $0x1,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <exit>:
SYSCALL(exit)
 7b2:	b8 02 00 00 00       	mov    $0x2,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <wait>:
SYSCALL(wait)
 7ba:	b8 03 00 00 00       	mov    $0x3,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <pipe>:
SYSCALL(pipe)
 7c2:	b8 04 00 00 00       	mov    $0x4,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <read>:
SYSCALL(read)
 7ca:	b8 05 00 00 00       	mov    $0x5,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <write>:
SYSCALL(write)
 7d2:	b8 10 00 00 00       	mov    $0x10,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <close>:
SYSCALL(close)
 7da:	b8 15 00 00 00       	mov    $0x15,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <kill>:
SYSCALL(kill)
 7e2:	b8 06 00 00 00       	mov    $0x6,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <exec>:
SYSCALL(exec)
 7ea:	b8 07 00 00 00       	mov    $0x7,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <open>:
SYSCALL(open)
 7f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <mknod>:
SYSCALL(mknod)
 7fa:	b8 11 00 00 00       	mov    $0x11,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <unlink>:
SYSCALL(unlink)
 802:	b8 12 00 00 00       	mov    $0x12,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    

0000080a <fstat>:
SYSCALL(fstat)
 80a:	b8 08 00 00 00       	mov    $0x8,%eax
 80f:	cd 40                	int    $0x40
 811:	c3                   	ret    

00000812 <link>:
SYSCALL(link)
 812:	b8 13 00 00 00       	mov    $0x13,%eax
 817:	cd 40                	int    $0x40
 819:	c3                   	ret    

0000081a <mkdir>:
SYSCALL(mkdir)
 81a:	b8 14 00 00 00       	mov    $0x14,%eax
 81f:	cd 40                	int    $0x40
 821:	c3                   	ret    

00000822 <chdir>:
SYSCALL(chdir)
 822:	b8 09 00 00 00       	mov    $0x9,%eax
 827:	cd 40                	int    $0x40
 829:	c3                   	ret    

0000082a <dup>:
SYSCALL(dup)
 82a:	b8 0a 00 00 00       	mov    $0xa,%eax
 82f:	cd 40                	int    $0x40
 831:	c3                   	ret    

00000832 <getpid>:
SYSCALL(getpid)
 832:	b8 0b 00 00 00       	mov    $0xb,%eax
 837:	cd 40                	int    $0x40
 839:	c3                   	ret    

0000083a <sbrk>:
SYSCALL(sbrk)
 83a:	b8 0c 00 00 00       	mov    $0xc,%eax
 83f:	cd 40                	int    $0x40
 841:	c3                   	ret    

00000842 <sleep>:
SYSCALL(sleep)
 842:	b8 0d 00 00 00       	mov    $0xd,%eax
 847:	cd 40                	int    $0x40
 849:	c3                   	ret    

0000084a <uptime>:
SYSCALL(uptime)
 84a:	b8 0e 00 00 00       	mov    $0xe,%eax
 84f:	cd 40                	int    $0x40
 851:	c3                   	ret    

00000852 <trace>:
SYSCALL(trace)
 852:	b8 16 00 00 00       	mov    $0x16,%eax
 857:	cd 40                	int    $0x40
 859:	c3                   	ret    
 85a:	66 90                	xchg   %ax,%ax
 85c:	66 90                	xchg   %ax,%ax
 85e:	66 90                	xchg   %ax,%ax

00000860 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	57                   	push   %edi
 864:	56                   	push   %esi
 865:	53                   	push   %ebx
 866:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 869:	85 d2                	test   %edx,%edx
{
 86b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 86e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 870:	79 76                	jns    8e8 <printint+0x88>
 872:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 876:	74 70                	je     8e8 <printint+0x88>
    x = -xx;
 878:	f7 d8                	neg    %eax
    neg = 1;
 87a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 881:	31 f6                	xor    %esi,%esi
 883:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 886:	eb 0a                	jmp    892 <printint+0x32>
 888:	90                   	nop
 889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 890:	89 fe                	mov    %edi,%esi
 892:	31 d2                	xor    %edx,%edx
 894:	8d 7e 01             	lea    0x1(%esi),%edi
 897:	f7 f1                	div    %ecx
 899:	0f b6 92 9c 0c 00 00 	movzbl 0xc9c(%edx),%edx
  }while((x /= base) != 0);
 8a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 8a2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 8a5:	75 e9                	jne    890 <printint+0x30>
  if(neg)
 8a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 8aa:	85 c0                	test   %eax,%eax
 8ac:	74 08                	je     8b6 <printint+0x56>
    buf[i++] = '-';
 8ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 8b3:	8d 7e 02             	lea    0x2(%esi),%edi
 8b6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 8ba:	8b 7d c0             	mov    -0x40(%ebp),%edi
 8bd:	8d 76 00             	lea    0x0(%esi),%esi
 8c0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 8c3:	83 ec 04             	sub    $0x4,%esp
 8c6:	83 ee 01             	sub    $0x1,%esi
 8c9:	6a 01                	push   $0x1
 8cb:	53                   	push   %ebx
 8cc:	57                   	push   %edi
 8cd:	88 45 d7             	mov    %al,-0x29(%ebp)
 8d0:	e8 fd fe ff ff       	call   7d2 <write>

  while(--i >= 0)
 8d5:	83 c4 10             	add    $0x10,%esp
 8d8:	39 de                	cmp    %ebx,%esi
 8da:	75 e4                	jne    8c0 <printint+0x60>
    putc(fd, buf[i]);
}
 8dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8df:	5b                   	pop    %ebx
 8e0:	5e                   	pop    %esi
 8e1:	5f                   	pop    %edi
 8e2:	5d                   	pop    %ebp
 8e3:	c3                   	ret    
 8e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 8e8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 8ef:	eb 90                	jmp    881 <printint+0x21>
 8f1:	eb 0d                	jmp    900 <printf>
 8f3:	90                   	nop
 8f4:	90                   	nop
 8f5:	90                   	nop
 8f6:	90                   	nop
 8f7:	90                   	nop
 8f8:	90                   	nop
 8f9:	90                   	nop
 8fa:	90                   	nop
 8fb:	90                   	nop
 8fc:	90                   	nop
 8fd:	90                   	nop
 8fe:	90                   	nop
 8ff:	90                   	nop

00000900 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	57                   	push   %edi
 904:	56                   	push   %esi
 905:	53                   	push   %ebx
 906:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 909:	8b 75 0c             	mov    0xc(%ebp),%esi
 90c:	0f b6 1e             	movzbl (%esi),%ebx
 90f:	84 db                	test   %bl,%bl
 911:	0f 84 b3 00 00 00    	je     9ca <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 917:	8d 45 10             	lea    0x10(%ebp),%eax
 91a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 91d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 91f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 922:	eb 2f                	jmp    953 <printf+0x53>
 924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 928:	83 f8 25             	cmp    $0x25,%eax
 92b:	0f 84 a7 00 00 00    	je     9d8 <printf+0xd8>
  write(fd, &c, 1);
 931:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 934:	83 ec 04             	sub    $0x4,%esp
 937:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 93a:	6a 01                	push   $0x1
 93c:	50                   	push   %eax
 93d:	ff 75 08             	pushl  0x8(%ebp)
 940:	e8 8d fe ff ff       	call   7d2 <write>
 945:	83 c4 10             	add    $0x10,%esp
 948:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 94b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 94f:	84 db                	test   %bl,%bl
 951:	74 77                	je     9ca <printf+0xca>
    if(state == 0){
 953:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 955:	0f be cb             	movsbl %bl,%ecx
 958:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 95b:	74 cb                	je     928 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 95d:	83 ff 25             	cmp    $0x25,%edi
 960:	75 e6                	jne    948 <printf+0x48>
      if(c == 'd'){
 962:	83 f8 64             	cmp    $0x64,%eax
 965:	0f 84 05 01 00 00    	je     a70 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 96b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 971:	83 f9 70             	cmp    $0x70,%ecx
 974:	74 72                	je     9e8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 976:	83 f8 73             	cmp    $0x73,%eax
 979:	0f 84 99 00 00 00    	je     a18 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 97f:	83 f8 63             	cmp    $0x63,%eax
 982:	0f 84 08 01 00 00    	je     a90 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 988:	83 f8 25             	cmp    $0x25,%eax
 98b:	0f 84 ef 00 00 00    	je     a80 <printf+0x180>
  write(fd, &c, 1);
 991:	8d 45 e7             	lea    -0x19(%ebp),%eax
 994:	83 ec 04             	sub    $0x4,%esp
 997:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 99b:	6a 01                	push   $0x1
 99d:	50                   	push   %eax
 99e:	ff 75 08             	pushl  0x8(%ebp)
 9a1:	e8 2c fe ff ff       	call   7d2 <write>
 9a6:	83 c4 0c             	add    $0xc,%esp
 9a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 9ac:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 9af:	6a 01                	push   $0x1
 9b1:	50                   	push   %eax
 9b2:	ff 75 08             	pushl  0x8(%ebp)
 9b5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 9b8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 9ba:	e8 13 fe ff ff       	call   7d2 <write>
  for(i = 0; fmt[i]; i++){
 9bf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 9c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 9c6:	84 db                	test   %bl,%bl
 9c8:	75 89                	jne    953 <printf+0x53>
    }
  }
}
 9ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9cd:	5b                   	pop    %ebx
 9ce:	5e                   	pop    %esi
 9cf:	5f                   	pop    %edi
 9d0:	5d                   	pop    %ebp
 9d1:	c3                   	ret    
 9d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 9d8:	bf 25 00 00 00       	mov    $0x25,%edi
 9dd:	e9 66 ff ff ff       	jmp    948 <printf+0x48>
 9e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 9e8:	83 ec 0c             	sub    $0xc,%esp
 9eb:	b9 10 00 00 00       	mov    $0x10,%ecx
 9f0:	6a 00                	push   $0x0
 9f2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 9f5:	8b 45 08             	mov    0x8(%ebp),%eax
 9f8:	8b 17                	mov    (%edi),%edx
 9fa:	e8 61 fe ff ff       	call   860 <printint>
        ap++;
 9ff:	89 f8                	mov    %edi,%eax
 a01:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a04:	31 ff                	xor    %edi,%edi
        ap++;
 a06:	83 c0 04             	add    $0x4,%eax
 a09:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 a0c:	e9 37 ff ff ff       	jmp    948 <printf+0x48>
 a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 a18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 a1b:	8b 08                	mov    (%eax),%ecx
        ap++;
 a1d:	83 c0 04             	add    $0x4,%eax
 a20:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 a23:	85 c9                	test   %ecx,%ecx
 a25:	0f 84 8e 00 00 00    	je     ab9 <printf+0x1b9>
        while(*s != 0){
 a2b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 a2e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 a30:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 a32:	84 c0                	test   %al,%al
 a34:	0f 84 0e ff ff ff    	je     948 <printf+0x48>
 a3a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 a3d:	89 de                	mov    %ebx,%esi
 a3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a42:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 a45:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 a48:	83 ec 04             	sub    $0x4,%esp
          s++;
 a4b:	83 c6 01             	add    $0x1,%esi
 a4e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 a51:	6a 01                	push   $0x1
 a53:	57                   	push   %edi
 a54:	53                   	push   %ebx
 a55:	e8 78 fd ff ff       	call   7d2 <write>
        while(*s != 0){
 a5a:	0f b6 06             	movzbl (%esi),%eax
 a5d:	83 c4 10             	add    $0x10,%esp
 a60:	84 c0                	test   %al,%al
 a62:	75 e4                	jne    a48 <printf+0x148>
 a64:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 a67:	31 ff                	xor    %edi,%edi
 a69:	e9 da fe ff ff       	jmp    948 <printf+0x48>
 a6e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 a70:	83 ec 0c             	sub    $0xc,%esp
 a73:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a78:	6a 01                	push   $0x1
 a7a:	e9 73 ff ff ff       	jmp    9f2 <printf+0xf2>
 a7f:	90                   	nop
  write(fd, &c, 1);
 a80:	83 ec 04             	sub    $0x4,%esp
 a83:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 a86:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 a89:	6a 01                	push   $0x1
 a8b:	e9 21 ff ff ff       	jmp    9b1 <printf+0xb1>
        putc(fd, *ap);
 a90:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 a93:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a96:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 a98:	6a 01                	push   $0x1
        ap++;
 a9a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 a9d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 aa0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 aa3:	50                   	push   %eax
 aa4:	ff 75 08             	pushl  0x8(%ebp)
 aa7:	e8 26 fd ff ff       	call   7d2 <write>
        ap++;
 aac:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 aaf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 ab2:	31 ff                	xor    %edi,%edi
 ab4:	e9 8f fe ff ff       	jmp    948 <printf+0x48>
          s = "(null)";
 ab9:	bb 93 0c 00 00       	mov    $0xc93,%ebx
        while(*s != 0){
 abe:	b8 28 00 00 00       	mov    $0x28,%eax
 ac3:	e9 72 ff ff ff       	jmp    a3a <printf+0x13a>
 ac8:	66 90                	xchg   %ax,%ax
 aca:	66 90                	xchg   %ax,%ax
 acc:	66 90                	xchg   %ax,%ax
 ace:	66 90                	xchg   %ax,%ax

00000ad0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad1:	a1 c4 11 00 00       	mov    0x11c4,%eax
{
 ad6:	89 e5                	mov    %esp,%ebp
 ad8:	57                   	push   %edi
 ad9:	56                   	push   %esi
 ada:	53                   	push   %ebx
 adb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 ade:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae8:	39 c8                	cmp    %ecx,%eax
 aea:	8b 10                	mov    (%eax),%edx
 aec:	73 32                	jae    b20 <free+0x50>
 aee:	39 d1                	cmp    %edx,%ecx
 af0:	72 04                	jb     af6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af2:	39 d0                	cmp    %edx,%eax
 af4:	72 32                	jb     b28 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 af6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 af9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 afc:	39 fa                	cmp    %edi,%edx
 afe:	74 30                	je     b30 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 b00:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b03:	8b 50 04             	mov    0x4(%eax),%edx
 b06:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b09:	39 f1                	cmp    %esi,%ecx
 b0b:	74 3a                	je     b47 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 b0d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 b0f:	a3 c4 11 00 00       	mov    %eax,0x11c4
}
 b14:	5b                   	pop    %ebx
 b15:	5e                   	pop    %esi
 b16:	5f                   	pop    %edi
 b17:	5d                   	pop    %ebp
 b18:	c3                   	ret    
 b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b20:	39 d0                	cmp    %edx,%eax
 b22:	72 04                	jb     b28 <free+0x58>
 b24:	39 d1                	cmp    %edx,%ecx
 b26:	72 ce                	jb     af6 <free+0x26>
{
 b28:	89 d0                	mov    %edx,%eax
 b2a:	eb bc                	jmp    ae8 <free+0x18>
 b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 b30:	03 72 04             	add    0x4(%edx),%esi
 b33:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b36:	8b 10                	mov    (%eax),%edx
 b38:	8b 12                	mov    (%edx),%edx
 b3a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b3d:	8b 50 04             	mov    0x4(%eax),%edx
 b40:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b43:	39 f1                	cmp    %esi,%ecx
 b45:	75 c6                	jne    b0d <free+0x3d>
    p->s.size += bp->s.size;
 b47:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 b4a:	a3 c4 11 00 00       	mov    %eax,0x11c4
    p->s.size += bp->s.size;
 b4f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b52:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b55:	89 10                	mov    %edx,(%eax)
}
 b57:	5b                   	pop    %ebx
 b58:	5e                   	pop    %esi
 b59:	5f                   	pop    %edi
 b5a:	5d                   	pop    %ebp
 b5b:	c3                   	ret    
 b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b60 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b60:	55                   	push   %ebp
 b61:	89 e5                	mov    %esp,%ebp
 b63:	57                   	push   %edi
 b64:	56                   	push   %esi
 b65:	53                   	push   %ebx
 b66:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b69:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b6c:	8b 15 c4 11 00 00    	mov    0x11c4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b72:	8d 78 07             	lea    0x7(%eax),%edi
 b75:	c1 ef 03             	shr    $0x3,%edi
 b78:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 b7b:	85 d2                	test   %edx,%edx
 b7d:	0f 84 9d 00 00 00    	je     c20 <malloc+0xc0>
 b83:	8b 02                	mov    (%edx),%eax
 b85:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 b88:	39 cf                	cmp    %ecx,%edi
 b8a:	76 6c                	jbe    bf8 <malloc+0x98>
 b8c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 b92:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b97:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 b9a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 ba1:	eb 0e                	jmp    bb1 <malloc+0x51>
 ba3:	90                   	nop
 ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 baa:	8b 48 04             	mov    0x4(%eax),%ecx
 bad:	39 f9                	cmp    %edi,%ecx
 baf:	73 47                	jae    bf8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bb1:	39 05 c4 11 00 00    	cmp    %eax,0x11c4
 bb7:	89 c2                	mov    %eax,%edx
 bb9:	75 ed                	jne    ba8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 bbb:	83 ec 0c             	sub    $0xc,%esp
 bbe:	56                   	push   %esi
 bbf:	e8 76 fc ff ff       	call   83a <sbrk>
  if(p == (char*)-1)
 bc4:	83 c4 10             	add    $0x10,%esp
 bc7:	83 f8 ff             	cmp    $0xffffffff,%eax
 bca:	74 1c                	je     be8 <malloc+0x88>
  hp->s.size = nu;
 bcc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 bcf:	83 ec 0c             	sub    $0xc,%esp
 bd2:	83 c0 08             	add    $0x8,%eax
 bd5:	50                   	push   %eax
 bd6:	e8 f5 fe ff ff       	call   ad0 <free>
  return freep;
 bdb:	8b 15 c4 11 00 00    	mov    0x11c4,%edx
      if((p = morecore(nunits)) == 0)
 be1:	83 c4 10             	add    $0x10,%esp
 be4:	85 d2                	test   %edx,%edx
 be6:	75 c0                	jne    ba8 <malloc+0x48>
        return 0;
  }
}
 be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 beb:	31 c0                	xor    %eax,%eax
}
 bed:	5b                   	pop    %ebx
 bee:	5e                   	pop    %esi
 bef:	5f                   	pop    %edi
 bf0:	5d                   	pop    %ebp
 bf1:	c3                   	ret    
 bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 bf8:	39 cf                	cmp    %ecx,%edi
 bfa:	74 54                	je     c50 <malloc+0xf0>
        p->s.size -= nunits;
 bfc:	29 f9                	sub    %edi,%ecx
 bfe:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 c01:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 c04:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 c07:	89 15 c4 11 00 00    	mov    %edx,0x11c4
}
 c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 c10:	83 c0 08             	add    $0x8,%eax
}
 c13:	5b                   	pop    %ebx
 c14:	5e                   	pop    %esi
 c15:	5f                   	pop    %edi
 c16:	5d                   	pop    %ebp
 c17:	c3                   	ret    
 c18:	90                   	nop
 c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 c20:	c7 05 c4 11 00 00 c8 	movl   $0x11c8,0x11c4
 c27:	11 00 00 
 c2a:	c7 05 c8 11 00 00 c8 	movl   $0x11c8,0x11c8
 c31:	11 00 00 
    base.s.size = 0;
 c34:	b8 c8 11 00 00       	mov    $0x11c8,%eax
 c39:	c7 05 cc 11 00 00 00 	movl   $0x0,0x11cc
 c40:	00 00 00 
 c43:	e9 44 ff ff ff       	jmp    b8c <malloc+0x2c>
 c48:	90                   	nop
 c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 c50:	8b 08                	mov    (%eax),%ecx
 c52:	89 0a                	mov    %ecx,(%edx)
 c54:	eb b1                	jmp    c07 <malloc+0xa7>
