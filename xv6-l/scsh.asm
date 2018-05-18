
_scsh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    return -1;
  return 0;
}


int main(void) {
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	51                   	push   %ecx
       e:	83 ec 10             	sub    $0x10,%esp
  static char buf[100];
  int fd = 0;
  struct shared *sh = (struct shared *)getsharem(0);
      11:	6a 00                	push   $0x0
      13:	e8 72 0e 00 00       	call   e8a <getsharem>
  sh->nfunc = 0;
  sh->top = (char *)sh + sizeof(struct shared);
      18:	8d 90 1c 05 00 00    	lea    0x51c(%eax),%edx
  sh->nfunc = 0;
      1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  // Ensure that three file descriptors are open.
  while ((fd = open("console", O_RDWR)) >= 0) {
      24:	83 c4 10             	add    $0x10,%esp
  sh->top = (char *)sh + sizeof(struct shared);
      27:	89 90 18 05 00 00    	mov    %edx,0x518(%eax)
  while ((fd = open("console", O_RDWR)) >= 0) {
      2d:	eb 06                	jmp    35 <main+0x35>
      2f:	90                   	nop
    if (fd >= 3) {
      30:	83 f8 02             	cmp    $0x2,%eax
      33:	7f 7a                	jg     af <main+0xaf>
  while ((fd = open("console", O_RDWR)) >= 0) {
      35:	83 ec 08             	sub    $0x8,%esp
      38:	6a 02                	push   $0x2
      3a:	68 c0 12 00 00       	push   $0x12c0
      3f:	e8 de 0d 00 00       	call   e22 <open>
      44:	83 c4 10             	add    $0x10,%esp
      47:	85 c0                	test   %eax,%eax
      49:	79 e5                	jns    30 <main+0x30>
      4b:	eb 23                	jmp    70 <main+0x70>
      4d:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }

  // Read and run input commands.
  while (getcmd(buf, sizeof(buf)) >= 0) {
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      50:	80 3d 82 18 00 00 20 	cmpb   $0x20,0x1882
      57:	0f 84 94 00 00 00    	je     f1 <main+0xf1>
}

int fork1(void) {
  int pid;

  pid = fork();
      5d:	e8 78 0d 00 00       	call   dda <fork>
  if (pid == -1)
      62:	83 f8 ff             	cmp    $0xffffffff,%eax
      65:	74 3b                	je     a2 <main+0xa2>
    if (fork1() == 0) {
      67:	85 c0                	test   %eax,%eax
      69:	74 57                	je     c2 <main+0xc2>
    wait();
      6b:	e8 7a 0d 00 00       	call   dea <wait>
  while (getcmd(buf, sizeof(buf)) >= 0) {
      70:	83 ec 08             	sub    $0x8,%esp
      73:	6a 64                	push   $0x64
      75:	68 80 18 00 00       	push   $0x1880
      7a:	e8 a1 02 00 00       	call   320 <getcmd>
      7f:	83 c4 10             	add    $0x10,%esp
      82:	85 c0                	test   %eax,%eax
      84:	78 37                	js     bd <main+0xbd>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      86:	80 3d 80 18 00 00 63 	cmpb   $0x63,0x1880
      8d:	75 ce                	jne    5d <main+0x5d>
      8f:	80 3d 81 18 00 00 64 	cmpb   $0x64,0x1881
      96:	74 b8                	je     50 <main+0x50>
  pid = fork();
      98:	e8 3d 0d 00 00       	call   dda <fork>
  if (pid == -1)
      9d:	83 f8 ff             	cmp    $0xffffffff,%eax
      a0:	75 c5                	jne    67 <main+0x67>
    panic("fork");
      a2:	83 ec 0c             	sub    $0xc,%esp
      a5:	68 b4 12 00 00       	push   $0x12b4
      aa:	e8 c1 02 00 00       	call   370 <panic>
      close(fd);
      af:	83 ec 0c             	sub    $0xc,%esp
      b2:	50                   	push   %eax
      b3:	e8 52 0d 00 00       	call   e0a <close>
      break;
      b8:	83 c4 10             	add    $0x10,%esp
      bb:	eb b3                	jmp    70 <main+0x70>
  exit();
      bd:	e8 20 0d 00 00       	call   de2 <exit>
      struct shared *sh = (struct shared *)getsharem(0);
      c2:	83 ec 0c             	sub    $0xc,%esp
      c5:	6a 00                	push   $0x0
      c7:	e8 be 0d 00 00       	call   e8a <getsharem>
      printf(2, "nfunc: %d\n", sh->nfunc);
      cc:	83 c4 0c             	add    $0xc,%esp
      cf:	ff 30                	pushl  (%eax)
      d1:	68 f5 12 00 00       	push   $0x12f5
      d6:	6a 02                	push   $0x2
      d8:	e8 63 0e 00 00       	call   f40 <printf>
      runexp(parseexp(buf));
      dd:	c7 04 24 80 18 00 00 	movl   $0x1880,(%esp)
      e4:	e8 37 0a 00 00       	call   b20 <parseexp>
      e9:	89 04 24             	mov    %eax,(%esp)
      ec:	e8 9f 02 00 00       	call   390 <runexp>
      buf[strlen(buf) - 1] = 0; // chop \n
      f1:	83 ec 0c             	sub    $0xc,%esp
      f4:	68 80 18 00 00       	push   $0x1880
      f9:	e8 12 0b 00 00       	call   c10 <strlen>
      if (chdir(buf + 3) < 0)
      fe:	c7 04 24 83 18 00 00 	movl   $0x1883,(%esp)
      buf[strlen(buf) - 1] = 0; // chop \n
     105:	c6 80 7f 18 00 00 00 	movb   $0x0,0x187f(%eax)
      if (chdir(buf + 3) < 0)
     10c:	e8 41 0d 00 00       	call   e52 <chdir>
     111:	83 c4 10             	add    $0x10,%esp
     114:	85 c0                	test   %eax,%eax
     116:	0f 89 54 ff ff ff    	jns    70 <main+0x70>
        printf(2, "cannot cd %s\n", buf + 3);
     11c:	50                   	push   %eax
     11d:	68 83 18 00 00       	push   $0x1883
     122:	68 e7 12 00 00       	push   $0x12e7
     127:	6a 02                	push   $0x2
     129:	e8 12 0e 00 00       	call   f40 <printf>
     12e:	83 c4 10             	add    $0x10,%esp
     131:	e9 3a ff ff ff       	jmp    70 <main+0x70>
     136:	66 90                	xchg   %ax,%ax
     138:	66 90                	xchg   %ax,%ax
     13a:	66 90                	xchg   %ax,%ax
     13c:	66 90                	xchg   %ax,%ax
     13e:	66 90                	xchg   %ax,%ax

00000140 <replaceAtom>:
void replaceAtom(struct sexp *exp, char *o, char *d) {
     140:	55                   	push   %ebp
     141:	89 e5                	mov    %esp,%ebp
     143:	57                   	push   %edi
     144:	56                   	push   %esi
     145:	53                   	push   %ebx
     146:	83 ec 0c             	sub    $0xc,%esp
     149:	8b 5d 08             	mov    0x8(%ebp),%ebx
     14c:	8b 75 0c             	mov    0xc(%ebp),%esi
  switch (exp->type) {
     14f:	8b 03                	mov    (%ebx),%eax
     151:	83 f8 01             	cmp    $0x1,%eax
     154:	74 3a                	je     190 <replaceAtom+0x50>
     156:	7c 29                	jl     181 <replaceAtom+0x41>
     158:	83 f8 03             	cmp    $0x3,%eax
     15b:	7f 24                	jg     181 <replaceAtom+0x41>
    for (i = 0; i < lst->length; i++) {
     15d:	8b 43 04             	mov    0x4(%ebx),%eax
     160:	31 ff                	xor    %edi,%edi
     162:	85 c0                	test   %eax,%eax
     164:	7e 1b                	jle    181 <replaceAtom+0x41>
      replaceAtom(lst->sexps[i], o, d);
     166:	83 ec 04             	sub    $0x4,%esp
     169:	ff 75 10             	pushl  0x10(%ebp)
     16c:	56                   	push   %esi
     16d:	ff 74 bb 08          	pushl  0x8(%ebx,%edi,4)
    for (i = 0; i < lst->length; i++) {
     171:	83 c7 01             	add    $0x1,%edi
      replaceAtom(lst->sexps[i], o, d);
     174:	e8 c7 ff ff ff       	call   140 <replaceAtom>
    for (i = 0; i < lst->length; i++) {
     179:	83 c4 10             	add    $0x10,%esp
     17c:	3b 7b 04             	cmp    0x4(%ebx),%edi
     17f:	7c e5                	jl     166 <replaceAtom+0x26>
}
     181:	8d 65 f4             	lea    -0xc(%ebp),%esp
     184:	5b                   	pop    %ebx
     185:	5e                   	pop    %esi
     186:	5f                   	pop    %edi
     187:	5d                   	pop    %ebp
     188:	c3                   	ret    
     189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (strcmp(atm->symbol, o) == 0)
     190:	83 ec 08             	sub    $0x8,%esp
     193:	56                   	push   %esi
     194:	ff 73 04             	pushl  0x4(%ebx)
     197:	e8 24 0a 00 00       	call   bc0 <strcmp>
     19c:	83 c4 10             	add    $0x10,%esp
     19f:	85 c0                	test   %eax,%eax
     1a1:	75 de                	jne    181 <replaceAtom+0x41>
      atm->symbol = d;
     1a3:	8b 45 10             	mov    0x10(%ebp),%eax
     1a6:	89 43 04             	mov    %eax,0x4(%ebx)
}
     1a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     1ac:	5b                   	pop    %ebx
     1ad:	5e                   	pop    %esi
     1ae:	5f                   	pop    %edi
     1af:	5d                   	pop    %ebp
     1b0:	c3                   	ret    
     1b1:	eb 0d                	jmp    1c0 <storeexp>
     1b3:	90                   	nop
     1b4:	90                   	nop
     1b5:	90                   	nop
     1b6:	90                   	nop
     1b7:	90                   	nop
     1b8:	90                   	nop
     1b9:	90                   	nop
     1ba:	90                   	nop
     1bb:	90                   	nop
     1bc:	90                   	nop
     1bd:	90                   	nop
     1be:	90                   	nop
     1bf:	90                   	nop

000001c0 <storeexp>:
void storeexp(struct sexp **st, struct sexp *exp) {
     1c0:	55                   	push   %ebp
     1c1:	89 e5                	mov    %esp,%ebp
     1c3:	57                   	push   %edi
     1c4:	56                   	push   %esi
     1c5:	53                   	push   %ebx
     1c6:	83 ec 1c             	sub    $0x1c,%esp
     1c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     1cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  switch (exp->type) {
     1cf:	8b 03                	mov    (%ebx),%eax
     1d1:	83 f8 01             	cmp    $0x1,%eax
     1d4:	74 4a                	je     220 <storeexp+0x60>
     1d6:	7c 7a                	jl     252 <storeexp+0x92>
     1d8:	83 f8 03             	cmp    $0x3,%eax
     1db:	7f 75                	jg     252 <storeexp+0x92>
    lst0 = (struct list *)*st;
     1dd:	8b 17                	mov    (%edi),%edx
    for (i = 0; i < lst->length; i++) {
     1df:	31 f6                	xor    %esi,%esi
    lst0->type = lst->type;
     1e1:	89 02                	mov    %eax,(%edx)
    lst0->length = lst->length;
     1e3:	8b 43 04             	mov    0x4(%ebx),%eax
     1e6:	89 42 04             	mov    %eax,0x4(%edx)
    *st += sizeof(struct list);
     1e9:	8b 07                	mov    (%edi),%eax
     1eb:	05 c0 00 00 00       	add    $0xc0,%eax
     1f0:	89 07                	mov    %eax,(%edi)
    for (i = 0; i < lst->length; i++) {
     1f2:	8b 4b 04             	mov    0x4(%ebx),%ecx
     1f5:	85 c9                	test   %ecx,%ecx
     1f7:	7e 59                	jle    252 <storeexp+0x92>
      storeexp(st, lst->sexps[i]);
     1f9:	83 ec 08             	sub    $0x8,%esp
      lst0->sexps[i] = *st;
     1fc:	89 44 b2 08          	mov    %eax,0x8(%edx,%esi,4)
      storeexp(st, lst->sexps[i]);
     200:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
     204:	57                   	push   %edi
      lst0->sexps[i] = *st;
     205:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < lst->length; i++) {
     208:	83 c6 01             	add    $0x1,%esi
      storeexp(st, lst->sexps[i]);
     20b:	e8 b0 ff ff ff       	call   1c0 <storeexp>
    for (i = 0; i < lst->length; i++) {
     210:	83 c4 10             	add    $0x10,%esp
     213:	39 73 04             	cmp    %esi,0x4(%ebx)
     216:	7e 3a                	jle    252 <storeexp+0x92>
     218:	8b 07                	mov    (%edi),%eax
     21a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     21d:	eb da                	jmp    1f9 <storeexp+0x39>
     21f:	90                   	nop
    atm0 = (struct atom *)*st;
     220:	8b 37                	mov    (%edi),%esi
    strcpy((char *)atm0 + sizeof(struct atom), atm->symbol);
     222:	83 ec 08             	sub    $0x8,%esp
     225:	8d 56 0c             	lea    0xc(%esi),%edx
    atm0->type = ATOM;
     228:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
    strcpy((char *)atm0 + sizeof(struct atom), atm->symbol);
     22e:	ff 73 04             	pushl  0x4(%ebx)
     231:	52                   	push   %edx
     232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
     235:	e8 56 09 00 00       	call   b90 <strcpy>
    atm0->symbol = (char *)atm0 + sizeof(struct atom);
     23a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    *st += sizeof(struct atom) + (atm->esymbol - atm->symbol);
     23d:	83 c4 10             	add    $0x10,%esp
    atm0->symbol = (char *)atm0 + sizeof(struct atom);
     240:	89 56 04             	mov    %edx,0x4(%esi)
    *st += sizeof(struct atom) + (atm->esymbol - atm->symbol);
     243:	8b 43 08             	mov    0x8(%ebx),%eax
     246:	2b 43 04             	sub    0x4(%ebx),%eax
     249:	8d 04 85 30 00 00 00 	lea    0x30(,%eax,4),%eax
     250:	01 07                	add    %eax,(%edi)
}
     252:	8d 65 f4             	lea    -0xc(%ebp),%esp
     255:	5b                   	pop    %ebx
     256:	5e                   	pop    %esi
     257:	5f                   	pop    %edi
     258:	5d                   	pop    %ebp
     259:	c3                   	ret    
     25a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000260 <defunc>:
void defunc(struct list *lst) {
     260:	55                   	push   %ebp
     261:	89 e5                	mov    %esp,%ebp
     263:	57                   	push   %edi
     264:	56                   	push   %esi
     265:	53                   	push   %ebx
     266:	83 ec 28             	sub    $0x28,%esp
     269:	8b 75 08             	mov    0x8(%ebp),%esi
  struct shared *sh = (struct shared *)getsharem(0);
     26c:	6a 00                	push   $0x0
     26e:	e8 17 0c 00 00       	call   e8a <getsharem>
  struct func *fn = &sh->funcs[sh->nfunc];
     273:	8b 18                	mov    (%eax),%ebx
  struct shared *sh = (struct shared *)getsharem(0);
     275:	89 c2                	mov    %eax,%edx
  struct list *argv = (struct list *)lst->sexps[2];
     277:	8b 7e 10             	mov    0x10(%esi),%edi
  strcpy(fn->name, ((struct atom *)lst->sexps[1])->symbol);
     27a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  sh->nfunc++;
     27d:	8d 43 01             	lea    0x1(%ebx),%eax
     280:	6b db 78             	imul   $0x78,%ebx,%ebx
     283:	89 02                	mov    %eax,(%edx)
  strcpy(fn->name, ((struct atom *)lst->sexps[1])->symbol);
     285:	58                   	pop    %eax
     286:	8b 46 0c             	mov    0xc(%esi),%eax
     289:	59                   	pop    %ecx
     28a:	ff 70 04             	pushl  0x4(%eax)
     28d:	8d 44 1a 04          	lea    0x4(%edx,%ebx,1),%eax
     291:	50                   	push   %eax
     292:	e8 f9 08 00 00       	call   b90 <strcpy>
  fn->argc = argv->length;
     297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     29a:	8b 4f 04             	mov    0x4(%edi),%ecx
     29d:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
  storeexp((struct sexp **)&sh->top, lst->sexps[3]);
     2a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  fn->argc = argv->length;
     2a3:	89 48 74             	mov    %ecx,0x74(%eax)
  struct sexp *st = (struct sexp *)sh->top;
     2a6:	8b 8a 18 05 00 00    	mov    0x518(%edx),%ecx
  fn->argc = argv->length;
     2ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  storeexp((struct sexp **)&sh->top, lst->sexps[3]);
     2af:	58                   	pop    %eax
  struct sexp *st = (struct sexp *)sh->top;
     2b0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  storeexp((struct sexp **)&sh->top, lst->sexps[3]);
     2b3:	59                   	pop    %ecx
     2b4:	ff 76 14             	pushl  0x14(%esi)
     2b7:	8d b2 18 05 00 00    	lea    0x518(%edx),%esi
     2bd:	56                   	push   %esi
     2be:	e8 fd fe ff ff       	call   1c0 <storeexp>
  fn->sexp = st;
     2c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
     2c6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  for (i = 0; i < fn->argc; i++)
     2c9:	83 c4 10             	add    $0x10,%esp
     2cc:	8b 70 74             	mov    0x74(%eax),%esi
  fn->sexp = st;
     2cf:	89 48 78             	mov    %ecx,0x78(%eax)
  for (i = 0; i < fn->argc; i++)
     2d2:	85 f6                	test   %esi,%esi
     2d4:	7e 33                	jle    309 <defunc+0xa9>
     2d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
     2d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     2dc:	8d 74 1a 0e          	lea    0xe(%edx,%ebx,1),%esi
     2e0:	31 db                	xor    %ebx,%ebx
     2e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    strcpy(fn->argv[i], ((struct atom *)argv->sexps[i])->symbol);
     2e8:	8b 44 9f 08          	mov    0x8(%edi,%ebx,4),%eax
     2ec:	83 ec 08             	sub    $0x8,%esp
  for (i = 0; i < fn->argc; i++)
     2ef:	83 c3 01             	add    $0x1,%ebx
    strcpy(fn->argv[i], ((struct atom *)argv->sexps[i])->symbol);
     2f2:	ff 70 04             	pushl  0x4(%eax)
     2f5:	56                   	push   %esi
     2f6:	83 c6 0a             	add    $0xa,%esi
     2f9:	e8 92 08 00 00       	call   b90 <strcpy>
  for (i = 0; i < fn->argc; i++)
     2fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     301:	83 c4 10             	add    $0x10,%esp
     304:	39 58 74             	cmp    %ebx,0x74(%eax)
     307:	7f df                	jg     2e8 <defunc+0x88>
}
     309:	8d 65 f4             	lea    -0xc(%ebp),%esp
     30c:	5b                   	pop    %ebx
     30d:	5e                   	pop    %esi
     30e:	5f                   	pop    %edi
     30f:	5d                   	pop    %ebp
     310:	c3                   	ret    
     311:	eb 0d                	jmp    320 <getcmd>
     313:	90                   	nop
     314:	90                   	nop
     315:	90                   	nop
     316:	90                   	nop
     317:	90                   	nop
     318:	90                   	nop
     319:	90                   	nop
     31a:	90                   	nop
     31b:	90                   	nop
     31c:	90                   	nop
     31d:	90                   	nop
     31e:	90                   	nop
     31f:	90                   	nop

00000320 <getcmd>:
int getcmd(char *buf, int nbuf) {
     320:	55                   	push   %ebp
     321:	89 e5                	mov    %esp,%ebp
     323:	56                   	push   %esi
     324:	53                   	push   %ebx
     325:	8b 75 0c             	mov    0xc(%ebp),%esi
     328:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "> ");
     32b:	83 ec 08             	sub    $0x8,%esp
     32e:	68 98 12 00 00       	push   $0x1298
     333:	6a 02                	push   $0x2
     335:	e8 06 0c 00 00       	call   f40 <printf>
  memset(buf, 0, nbuf);
     33a:	83 c4 0c             	add    $0xc,%esp
     33d:	56                   	push   %esi
     33e:	6a 00                	push   $0x0
     340:	53                   	push   %ebx
     341:	e8 fa 08 00 00       	call   c40 <memset>
  gets(buf, nbuf);
     346:	58                   	pop    %eax
     347:	5a                   	pop    %edx
     348:	56                   	push   %esi
     349:	53                   	push   %ebx
     34a:	e8 51 09 00 00       	call   ca0 <gets>
  if (buf[0] == 0) // EOF
     34f:	83 c4 10             	add    $0x10,%esp
     352:	31 c0                	xor    %eax,%eax
     354:	80 3b 00             	cmpb   $0x0,(%ebx)
     357:	0f 94 c0             	sete   %al
}
     35a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if (buf[0] == 0) // EOF
     35d:	f7 d8                	neg    %eax
}
     35f:	5b                   	pop    %ebx
     360:	5e                   	pop    %esi
     361:	5d                   	pop    %ebp
     362:	c3                   	ret    
     363:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <panic>:
void panic(char *s) {
     370:	55                   	push   %ebp
     371:	89 e5                	mov    %esp,%ebp
     373:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     376:	ff 75 08             	pushl  0x8(%ebp)
     379:	68 e3 12 00 00       	push   $0x12e3
     37e:	6a 02                	push   $0x2
     380:	e8 bb 0b 00 00       	call   f40 <printf>
  exit();
     385:	e8 58 0a 00 00       	call   de2 <exit>
     38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000390 <runexp>:
void runexp(struct sexp *exp) {
     390:	55                   	push   %ebp
     391:	89 e5                	mov    %esp,%ebp
     393:	57                   	push   %edi
     394:	56                   	push   %esi
     395:	53                   	push   %ebx
     396:	81 ec bc 00 00 00    	sub    $0xbc,%esp
     39c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if (exp == 0)
     39f:	85 ff                	test   %edi,%edi
     3a1:	0f 84 91 00 00 00    	je     438 <runexp+0xa8>
  switch (exp->type) {
     3a7:	8b 07                	mov    (%edi),%eax
     3a9:	83 f8 02             	cmp    $0x2,%eax
     3ac:	74 22                	je     3d0 <runexp+0x40>
     3ae:	83 f8 03             	cmp    $0x3,%eax
     3b1:	0f 84 86 00 00 00    	je     43d <runexp+0xad>
     3b7:	83 e8 01             	sub    $0x1,%eax
     3ba:	74 7c                	je     438 <runexp+0xa8>
    panic("runexp type error");
     3bc:	83 ec 0c             	sub    $0xc,%esp
     3bf:	68 9b 12 00 00       	push   $0x129b
     3c4:	e8 a7 ff ff ff       	call   370 <panic>
     3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < lst->length; i++)
     3d0:	8b 47 04             	mov    0x4(%edi),%eax
     3d3:	85 c0                	test   %eax,%eax
     3d5:	7e 61                	jle    438 <runexp+0xa8>
      runexp(lst->sexps[i]);
     3d7:	83 ec 0c             	sub    $0xc,%esp
     3da:	ff 77 08             	pushl  0x8(%edi)
     3dd:	e8 ae ff ff ff       	call   390 <runexp>
     3e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if ((i == 0) && (strcmp(argv[0], "defun") == 0)) {
     3e8:	83 ec 08             	sub    $0x8,%esp
     3eb:	68 c8 12 00 00       	push   $0x12c8
     3f0:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     3f6:	e8 c5 07 00 00       	call   bc0 <strcmp>
     3fb:	83 c4 10             	add    $0x10,%esp
     3fe:	85 c0                	test   %eax,%eax
     400:	75 74                	jne    476 <runexp+0xe6>
     402:	8b 7d 08             	mov    0x8(%ebp),%edi
  pid = fork();
     405:	e8 d0 09 00 00       	call   dda <fork>
  if (pid == -1)
     40a:	83 f8 ff             	cmp    $0xffffffff,%eax
     40d:	0f 84 96 03 00 00    	je     7a9 <runexp+0x419>
        if (fork1() == 0) {
     413:	85 c0                	test   %eax,%eax
     415:	75 15                	jne    42c <runexp+0x9c>
          if (argv[0] == 0)
     417:	83 bd 5c ff ff ff 00 	cmpl   $0x0,-0xa4(%ebp)
     41e:	74 18                	je     438 <runexp+0xa8>
          defunc(lst);
     420:	83 ec 0c             	sub    $0xc,%esp
     423:	57                   	push   %edi
     424:	e8 37 fe ff ff       	call   260 <defunc>
     429:	83 c4 10             	add    $0x10,%esp
        wait();
     42c:	e8 b9 09 00 00       	call   dea <wait>
     431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  exit();
     438:	e8 a5 09 00 00       	call   de2 <exit>
    argv[lst->length] = 0;
     43d:	8b 47 04             	mov    0x4(%edi),%eax
    for (i = 0; i < lst->length; i++) {
     440:	85 c0                	test   %eax,%eax
    argv[lst->length] = 0;
     442:	c7 84 85 5c ff ff ff 	movl   $0x0,-0xa4(%ebp,%eax,4)
     449:	00 00 00 00 
    for (i = 0; i < lst->length; i++) {
     44d:	7e e9                	jle    438 <runexp+0xa8>
     44f:	31 db                	xor    %ebx,%ebx
     451:	89 7d 08             	mov    %edi,0x8(%ebp)
     454:	89 df                	mov    %ebx,%edi
     456:	eb 36                	jmp    48e <runexp+0xfe>
     458:	90                   	nop
     459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      else if (lst->sexps[i]->type == LIST)
     460:	83 f8 02             	cmp    $0x2,%eax
     463:	0f 84 18 03 00 00    	je     781 <runexp+0x3f1>
      else if (lst->sexps[i]->type == APPLY) {
     469:	83 f8 03             	cmp    $0x3,%eax
     46c:	74 3a                	je     4a8 <runexp+0x118>
      if ((i == 0) && (strcmp(argv[0], "defun") == 0)) {
     46e:	85 ff                	test   %edi,%edi
     470:	0f 84 72 ff ff ff    	je     3e8 <runexp+0x58>
      if (i == lst->length - 1) {
     476:	8b 45 08             	mov    0x8(%ebp),%eax
     479:	8b 40 04             	mov    0x4(%eax),%eax
     47c:	8d 48 ff             	lea    -0x1(%eax),%ecx
     47f:	39 f9                	cmp    %edi,%ecx
     481:	0f 84 ef 00 00 00    	je     576 <runexp+0x1e6>
    for (i = 0; i < lst->length; i++) {
     487:	83 c7 01             	add    $0x1,%edi
     48a:	39 c7                	cmp    %eax,%edi
     48c:	7d aa                	jge    438 <runexp+0xa8>
      if (lst->sexps[i]->type == ATOM)
     48e:	8b 45 08             	mov    0x8(%ebp),%eax
     491:	8b 4c b8 08          	mov    0x8(%eax,%edi,4),%ecx
     495:	8b 01                	mov    (%ecx),%eax
     497:	83 f8 01             	cmp    $0x1,%eax
     49a:	75 c4                	jne    460 <runexp+0xd0>
        argv[i] = ((struct atom *)lst->sexps[i])->symbol;
     49c:	8b 41 04             	mov    0x4(%ecx),%eax
     49f:	89 84 bd 5c ff ff ff 	mov    %eax,-0xa4(%ebp,%edi,4)
     4a6:	eb c6                	jmp    46e <runexp+0xde>
  pid = fork();
     4a8:	e8 2d 09 00 00       	call   dda <fork>
  if (pid == -1)
     4ad:	83 f8 ff             	cmp    $0xffffffff,%eax
     4b0:	0f 84 f3 02 00 00    	je     7a9 <runexp+0x419>
        if (fork1() == 0) {
     4b6:	85 c0                	test   %eax,%eax
     4b8:	75 43                	jne    4fd <runexp+0x16d>
          close(1);
     4ba:	83 ec 0c             	sub    $0xc,%esp
     4bd:	89 fb                	mov    %edi,%ebx
     4bf:	8b 7d 08             	mov    0x8(%ebp),%edi
     4c2:	6a 01                	push   $0x1
     4c4:	e8 41 09 00 00       	call   e0a <close>
          getsharem(0);
     4c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     4d0:	e8 b5 09 00 00       	call   e8a <getsharem>
          if (open(".etemp", O_WRONLY | O_CREATE) < 0) {
     4d5:	5e                   	pop    %esi
     4d6:	58                   	pop    %eax
     4d7:	68 01 02 00 00       	push   $0x201
     4dc:	68 b9 12 00 00       	push   $0x12b9
     4e1:	e8 3c 09 00 00       	call   e22 <open>
     4e6:	83 c4 10             	add    $0x10,%esp
     4e9:	85 c0                	test   %eax,%eax
     4eb:	0f 88 e2 02 00 00    	js     7d3 <runexp+0x443>
          runexp(lst->sexps[i]);
     4f1:	83 ec 0c             	sub    $0xc,%esp
     4f4:	ff 74 9f 08          	pushl  0x8(%edi,%ebx,4)
     4f8:	e8 93 fe ff ff       	call   390 <runexp>
        wait();
     4fd:	e8 e8 08 00 00       	call   dea <wait>
        close(2);
     502:	83 ec 0c             	sub    $0xc,%esp
     505:	6a 02                	push   $0x2
     507:	e8 fe 08 00 00       	call   e0a <close>
        if ((ffd = open(".etemp", O_RDONLY)) < 0) {
     50c:	58                   	pop    %eax
     50d:	5a                   	pop    %edx
     50e:	6a 00                	push   $0x0
     510:	68 b9 12 00 00       	push   $0x12b9
     515:	e8 08 09 00 00       	call   e22 <open>
     51a:	83 c4 10             	add    $0x10,%esp
     51d:	85 c0                	test   %eax,%eax
     51f:	0f 88 9b 02 00 00    	js     7c0 <runexp+0x430>
     525:	6b c7 0a             	imul   $0xa,%edi,%eax
     528:	8d 55 84             	lea    -0x7c(%ebp),%edx
        argv[i] = xargv[i];
     52b:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
     531:	01 d0                	add    %edx,%eax
     533:	89 04 be             	mov    %eax,(%esi,%edi,4)
        int n=read(2, argv[i], 20);
     536:	51                   	push   %ecx
     537:	6a 14                	push   $0x14
     539:	50                   	push   %eax
     53a:	6a 02                	push   $0x2
     53c:	e8 b9 08 00 00       	call   dfa <read>
        argv[i][n] = 0;
     541:	8b 0c be             	mov    (%esi,%edi,4),%ecx
     544:	c6 04 01 00          	movb   $0x0,(%ecx,%eax,1)
        close(2);
     548:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     54f:	e8 b6 08 00 00       	call   e0a <close>
        unlink(".etemp");
     554:	c7 04 24 b9 12 00 00 	movl   $0x12b9,(%esp)
     55b:	e8 d2 08 00 00       	call   e32 <unlink>
        open("console", O_RDWR);
     560:	5b                   	pop    %ebx
     561:	5e                   	pop    %esi
     562:	6a 02                	push   $0x2
     564:	68 c0 12 00 00       	push   $0x12c0
     569:	e8 b4 08 00 00       	call   e22 <open>
     56e:	83 c4 10             	add    $0x10,%esp
     571:	e9 f8 fe ff ff       	jmp    46e <runexp+0xde>
        struct shared *sh = (struct shared *)getsharem(0);
     576:	83 ec 0c             	sub    $0xc,%esp
     579:	31 f6                	xor    %esi,%esi
     57b:	6a 00                	push   $0x0
     57d:	e8 08 09 00 00       	call   e8a <getsharem>
     582:	8d 58 04             	lea    0x4(%eax),%ebx
        for (j = 0; j < MAXFUNC; j++) {
     585:	31 d2                	xor    %edx,%edx
     587:	89 bd 54 ff ff ff    	mov    %edi,-0xac(%ebp)
        struct shared *sh = (struct shared *)getsharem(0);
     58d:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
     593:	89 f7                	mov    %esi,%edi
     595:	83 c4 10             	add    $0x10,%esp
     598:	89 de                	mov    %ebx,%esi
     59a:	89 d3                	mov    %edx,%ebx
     59c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          if (strcmp(argv[0], sh->funcs[j].name) == 0) {
     5a0:	8d 04 3e             	lea    (%esi,%edi,1),%eax
     5a3:	83 ec 08             	sub    $0x8,%esp
     5a6:	50                   	push   %eax
     5a7:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     5ad:	e8 0e 06 00 00       	call   bc0 <strcmp>
     5b2:	83 c4 10             	add    $0x10,%esp
     5b5:	85 c0                	test   %eax,%eax
     5b7:	0f 84 c6 00 00 00    	je     683 <runexp+0x2f3>
        for (j = 0; j < MAXFUNC; j++) {
     5bd:	83 c3 01             	add    $0x1,%ebx
     5c0:	83 c7 78             	add    $0x78,%edi
     5c3:	83 fb 0a             	cmp    $0xa,%ebx
     5c6:	75 d8                	jne    5a0 <runexp+0x210>
     5c8:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
     5ce:	89 9d 48 ff ff ff    	mov    %ebx,-0xb8(%ebp)
        int j, k, flg = 0;
     5d4:	31 db                	xor    %ebx,%ebx
  pid = fork();
     5d6:	e8 ff 07 00 00       	call   dda <fork>
  if (pid == -1)
     5db:	83 f8 ff             	cmp    $0xffffffff,%eax
     5de:	0f 84 c5 01 00 00    	je     7a9 <runexp+0x419>
        if (fork1() == 0) {
     5e4:	85 c0                	test   %eax,%eax
     5e6:	0f 85 87 00 00 00    	jne    673 <runexp+0x2e3>
          if (argv[0] == 0)
     5ec:	83 bd 5c ff ff ff 00 	cmpl   $0x0,-0xa4(%ebp)
     5f3:	0f 84 3f fe ff ff    	je     438 <runexp+0xa8>
          if (flg == 1) {
     5f9:	83 eb 01             	sub    $0x1,%ebx
     5fc:	0f 84 8c 01 00 00    	je     78e <runexp+0x3fe>
            getsharem(0);
     602:	83 ec 0c             	sub    $0xc,%esp
     605:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
     608:	6a 00                	push   $0x0
     60a:	e8 7b 08 00 00       	call   e8a <getsharem>
            printf(2, "argv: %s\n", argv[1]);
     60f:	83 c4 0c             	add    $0xc,%esp
     612:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
     618:	68 ce 12 00 00       	push   $0x12ce
     61d:	6a 02                	push   $0x2
     61f:	e8 1c 09 00 00       	call   f40 <printf>
     624:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
     62a:	83 c4 10             	add    $0x10,%esp
     62d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
     633:	89 c6                	mov    %eax,%esi
     635:	8d 76 00             	lea    0x0(%esi),%esi
              if (argv[j] == 0)
     638:	8b 06                	mov    (%esi),%eax
     63a:	85 c0                	test   %eax,%eax
     63c:	74 1f                	je     65d <runexp+0x2cd>
              if(argv[j]!=xargv[j])
     63e:	39 d8                	cmp    %ebx,%eax
     640:	74 0e                	je     650 <runexp+0x2c0>
                strcpy(xargv[j], argv[j]);
     642:	52                   	push   %edx
     643:	52                   	push   %edx
     644:	50                   	push   %eax
     645:	53                   	push   %ebx
     646:	e8 45 05 00 00       	call   b90 <strcpy>
                argv[j] = xargv[j];
     64b:	89 1e                	mov    %ebx,(%esi)
     64d:	83 c4 10             	add    $0x10,%esp
            for (j = 0; j < MAXARGS; j++) {
     650:	8d 45 84             	lea    -0x7c(%ebp),%eax
     653:	83 c6 04             	add    $0x4,%esi
     656:	83 c3 0a             	add    $0xa,%ebx
     659:	39 f0                	cmp    %esi,%eax
     65b:	75 db                	jne    638 <runexp+0x2a8>
            exec(argv[0], argv);
     65d:	50                   	push   %eax
     65e:	50                   	push   %eax
     65f:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
     665:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     66b:	e8 aa 07 00 00       	call   e1a <exec>
     670:	83 c4 10             	add    $0x10,%esp
        wait();
     673:	e8 72 07 00 00       	call   dea <wait>
     678:	8b 45 08             	mov    0x8(%ebp),%eax
     67b:	8b 40 04             	mov    0x4(%eax),%eax
     67e:	e9 04 fe ff ff       	jmp    487 <runexp+0xf7>
     683:	89 c1                	mov    %eax,%ecx
            argv[sh->funcs[j].argc+1] = 0;
     685:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
     68b:	89 9d 48 ff ff ff    	mov    %ebx,-0xb8(%ebp)
     691:	6b c3 78             	imul   $0x78,%ebx,%eax
              strcpy(sh->xargv[k], argv[k]);
     694:	89 bd 40 ff ff ff    	mov    %edi,-0xc0(%ebp)
            for (k = 0; k < MAXARGS; k++) {
     69a:	31 db                	xor    %ebx,%ebx
              strcpy(sh->xargv[k], argv[k]);
     69c:	89 8d 44 ff ff ff    	mov    %ecx,-0xbc(%ebp)
     6a2:	81 c2 b4 04 00 00    	add    $0x4b4,%edx
            argv[sh->funcs[j].argc+1] = 0;
     6a8:	8b 84 02 c0 fb ff ff 	mov    -0x440(%edx,%eax,1),%eax
              strcpy(sh->xargv[k], argv[k]);
     6af:	89 d7                	mov    %edx,%edi
            argv[sh->funcs[j].argc+1] = 0;
     6b1:	c7 84 85 60 ff ff ff 	movl   $0x0,-0xa0(%ebp,%eax,4)
     6b8:	00 00 00 00 
     6bc:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
     6c2:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
              strcpy(sh->xargv[k], argv[k]);
     6c8:	89 c6                	mov    %eax,%esi
              if (argv[k] == 0)
     6ca:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
     6cd:	85 c0                	test   %eax,%eax
     6cf:	74 19                	je     6ea <runexp+0x35a>
              strcpy(sh->xargv[k], argv[k]);
     6d1:	52                   	push   %edx
     6d2:	52                   	push   %edx
     6d3:	50                   	push   %eax
     6d4:	6b c3 0a             	imul   $0xa,%ebx,%eax
            for (k = 0; k < MAXARGS; k++) {
     6d7:	83 c3 01             	add    $0x1,%ebx
              strcpy(sh->xargv[k], argv[k]);
     6da:	01 f8                	add    %edi,%eax
     6dc:	50                   	push   %eax
     6dd:	e8 ae 04 00 00       	call   b90 <strcpy>
            for (k = 0; k < MAXARGS; k++) {
     6e2:	83 c4 10             	add    $0x10,%esp
     6e5:	83 fb 0a             	cmp    $0xa,%ebx
     6e8:	75 e0                	jne    6ca <runexp+0x33a>
            for (k = 0; k < sh->funcs[j].argc; k++)
     6ea:	6b 85 48 ff ff ff 78 	imul   $0x78,-0xb8(%ebp),%eax
     6f1:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
     6f7:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
     6fd:	8b 8d 44 ff ff ff    	mov    -0xbc(%ebp),%ecx
     703:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
     709:	01 d0                	add    %edx,%eax
     70b:	83 78 74 00          	cmpl   $0x0,0x74(%eax)
     70f:	0f 8e a1 00 00 00    	jle    7b6 <runexp+0x426>
     715:	81 c2 be 04 00 00    	add    $0x4be,%edx
              replaceAtom(sh->funcs[j].sexp, sh->funcs[j].argv[k], sh->xargv[k + 1]);
     71b:	89 bd 44 ff ff ff    	mov    %edi,-0xbc(%ebp)
     721:	89 cf                	mov    %ecx,%edi
     723:	89 d3                	mov    %edx,%ebx
     725:	8d 96 50 fb ff ff    	lea    -0x4b0(%esi),%edx
     72b:	89 c6                	mov    %eax,%esi
     72d:	89 95 4c ff ff ff    	mov    %edx,-0xb4(%ebp)
     733:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
     739:	52                   	push   %edx
     73a:	83 c7 01             	add    $0x1,%edi
     73d:	53                   	push   %ebx
     73e:	01 d8                	add    %ebx,%eax
     740:	83 c3 0a             	add    $0xa,%ebx
     743:	50                   	push   %eax
     744:	ff 76 78             	pushl  0x78(%esi)
     747:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
     74d:	e8 ee f9 ff ff       	call   140 <replaceAtom>
              strcpy(sh->funcs[j].argv[k],argv[k+1]);
     752:	59                   	pop    %ecx
     753:	58                   	pop    %eax
     754:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
     75a:	ff 34 b8             	pushl  (%eax,%edi,4)
     75d:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
     763:	50                   	push   %eax
     764:	e8 27 04 00 00       	call   b90 <strcpy>
            for (k = 0; k < sh->funcs[j].argc; k++)
     769:	83 c4 10             	add    $0x10,%esp
     76c:	3b 7e 74             	cmp    0x74(%esi),%edi
     76f:	7c c2                	jl     733 <runexp+0x3a3>
     771:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
            flg = 1;
     777:	bb 01 00 00 00       	mov    $0x1,%ebx
     77c:	e9 55 fe ff ff       	jmp    5d6 <runexp+0x246>
        panic("syntax");
     781:	83 ec 0c             	sub    $0xc,%esp
     784:	68 ad 12 00 00       	push   $0x12ad
     789:	e8 e2 fb ff ff       	call   370 <panic>
            struct shared *sh = (struct shared *)getsharem(0);
     78e:	83 ec 0c             	sub    $0xc,%esp
     791:	6a 00                	push   $0x0
     793:	e8 f2 06 00 00       	call   e8a <getsharem>
            runexp(sh->funcs[j].sexp);
     798:	6b 95 48 ff ff ff 78 	imul   $0x78,-0xb8(%ebp),%edx
     79f:	59                   	pop    %ecx
     7a0:	ff 74 10 78          	pushl  0x78(%eax,%edx,1)
     7a4:	e8 e7 fb ff ff       	call   390 <runexp>
    panic("fork");
     7a9:	83 ec 0c             	sub    $0xc,%esp
     7ac:	68 b4 12 00 00       	push   $0x12b4
     7b1:	e8 ba fb ff ff       	call   370 <panic>
            flg = 1;
     7b6:	bb 01 00 00 00       	mov    $0x1,%ebx
     7bb:	e9 16 fe ff ff       	jmp    5d6 <runexp+0x246>
          printf(1, "open console temp file failed\n");
     7c0:	57                   	push   %edi
     7c1:	57                   	push   %edi
     7c2:	68 00 13 00 00       	push   $0x1300
     7c7:	6a 01                	push   $0x1
     7c9:	e8 72 07 00 00       	call   f40 <printf>
          exit();
     7ce:	e8 0f 06 00 00       	call   de2 <exit>
            printf(2, "open console temp file failed\n");
     7d3:	51                   	push   %ecx
     7d4:	51                   	push   %ecx
     7d5:	68 00 13 00 00       	push   $0x1300
     7da:	6a 02                	push   $0x2
     7dc:	e8 5f 07 00 00       	call   f40 <printf>
            exit();
     7e1:	e8 fc 05 00 00       	call   de2 <exit>
     7e6:	8d 76 00             	lea    0x0(%esi),%esi
     7e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007f0 <fork1>:
int fork1(void) {
     7f0:	55                   	push   %ebp
     7f1:	89 e5                	mov    %esp,%ebp
     7f3:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     7f6:	e8 df 05 00 00       	call   dda <fork>
  if (pid == -1)
     7fb:	83 f8 ff             	cmp    $0xffffffff,%eax
     7fe:	74 02                	je     802 <fork1+0x12>

  return pid;
}
     800:	c9                   	leave  
     801:	c3                   	ret    
    panic("fork");
     802:	83 ec 0c             	sub    $0xc,%esp
     805:	68 b4 12 00 00       	push   $0x12b4
     80a:	e8 61 fb ff ff       	call   370 <panic>
     80f:	90                   	nop

00000810 <atom>:

// PAGEBREAK!
// Constructors

struct sexp *atom(void) {
     810:	55                   	push   %ebp
     811:	89 e5                	mov    %esp,%ebp
     813:	53                   	push   %ebx
     814:	83 ec 10             	sub    $0x10,%esp
  struct atom *exp;

  exp = malloc(sizeof(*exp));
     817:	6a 0c                	push   $0xc
     819:	e8 82 09 00 00       	call   11a0 <malloc>
  memset(exp, 0, sizeof(*exp));
     81e:	83 c4 0c             	add    $0xc,%esp
  exp = malloc(sizeof(*exp));
     821:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     823:	6a 0c                	push   $0xc
     825:	6a 00                	push   $0x0
     827:	50                   	push   %eax
     828:	e8 13 04 00 00       	call   c40 <memset>
  return (struct sexp *)exp;
}
     82d:	89 d8                	mov    %ebx,%eax
     82f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     832:	c9                   	leave  
     833:	c3                   	ret    
     834:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     83a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000840 <list>:

struct sexp *list(void) {
     840:	55                   	push   %ebp
     841:	89 e5                	mov    %esp,%ebp
     843:	53                   	push   %ebx
     844:	83 ec 10             	sub    $0x10,%esp
  struct list *exp;

  exp = malloc(sizeof(*exp));
     847:	6a 30                	push   $0x30
     849:	e8 52 09 00 00       	call   11a0 <malloc>
  memset(exp, 0, sizeof(*exp));
     84e:	83 c4 0c             	add    $0xc,%esp
  exp = malloc(sizeof(*exp));
     851:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     853:	6a 30                	push   $0x30
     855:	6a 00                	push   $0x0
     857:	50                   	push   %eax
     858:	e8 e3 03 00 00       	call   c40 <memset>
  return (struct sexp *)exp;
}
     85d:	89 d8                	mov    %ebx,%eax
     85f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     862:	c9                   	leave  
     863:	c3                   	ret    
     864:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     86a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000870 <peek>:
// Parsing

char whitespace[] = " \t\r\n\v";
char esymbols[] = "()";

int peek(char **ps, char *es, char *toks) {
     870:	55                   	push   %ebp
     871:	89 e5                	mov    %esp,%ebp
     873:	57                   	push   %edi
     874:	56                   	push   %esi
     875:	53                   	push   %ebx
     876:	83 ec 0c             	sub    $0xc,%esp
     879:	8b 7d 08             	mov    0x8(%ebp),%edi
     87c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     87f:	8b 1f                	mov    (%edi),%ebx
  while (s < es && strchr(whitespace, *s))
     881:	39 f3                	cmp    %esi,%ebx
     883:	72 12                	jb     897 <peek+0x27>
     885:	eb 28                	jmp    8af <peek+0x3f>
     887:	89 f6                	mov    %esi,%esi
     889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
     890:	83 c3 01             	add    $0x1,%ebx
  while (s < es && strchr(whitespace, *s))
     893:	39 de                	cmp    %ebx,%esi
     895:	74 18                	je     8af <peek+0x3f>
     897:	0f be 03             	movsbl (%ebx),%eax
     89a:	83 ec 08             	sub    $0x8,%esp
     89d:	50                   	push   %eax
     89e:	68 64 18 00 00       	push   $0x1864
     8a3:	e8 b8 03 00 00       	call   c60 <strchr>
     8a8:	83 c4 10             	add    $0x10,%esp
     8ab:	85 c0                	test   %eax,%eax
     8ad:	75 e1                	jne    890 <peek+0x20>
  *ps = s;
     8af:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     8b1:	0f be 13             	movsbl (%ebx),%edx
     8b4:	31 c0                	xor    %eax,%eax
     8b6:	84 d2                	test   %dl,%dl
     8b8:	74 17                	je     8d1 <peek+0x61>
     8ba:	83 ec 08             	sub    $0x8,%esp
     8bd:	52                   	push   %edx
     8be:	ff 75 10             	pushl  0x10(%ebp)
     8c1:	e8 9a 03 00 00       	call   c60 <strchr>
     8c6:	83 c4 10             	add    $0x10,%esp
     8c9:	85 c0                	test   %eax,%eax
     8cb:	0f 95 c0             	setne  %al
     8ce:	0f b6 c0             	movzbl %al,%eax
}
     8d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8d4:	5b                   	pop    %ebx
     8d5:	5e                   	pop    %esi
     8d6:	5f                   	pop    %edi
     8d7:	5d                   	pop    %ebp
     8d8:	c3                   	ret    
     8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008e0 <parseatom>:
  lst->length = i;

  return ret;
}

struct sexp *parseatom(char **ps, char *es) {
     8e0:	55                   	push   %ebp
     8e1:	89 e5                	mov    %esp,%ebp
     8e3:	57                   	push   %edi
     8e4:	56                   	push   %esi
     8e5:	53                   	push   %ebx
     8e6:	83 ec 0c             	sub    $0xc,%esp
     8e9:	8b 7d 08             	mov    0x8(%ebp),%edi
     8ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct atom *atm;
  struct sexp *ret;

  char *s = *ps;
     8ef:	8b 37                	mov    (%edi),%esi
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     8f1:	39 de                	cmp    %ebx,%esi
     8f3:	89 f0                	mov    %esi,%eax
     8f5:	72 2e                	jb     925 <parseatom+0x45>
     8f7:	eb 44                	jmp    93d <parseatom+0x5d>
     8f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
         !strchr(esymbols, *(*ps))) // peek whitespace
     900:	8b 07                	mov    (%edi),%eax
     902:	83 ec 08             	sub    $0x8,%esp
     905:	0f be 00             	movsbl (%eax),%eax
     908:	50                   	push   %eax
     909:	68 60 18 00 00       	push   $0x1860
     90e:	e8 4d 03 00 00       	call   c60 <strchr>
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     913:	83 c4 10             	add    $0x10,%esp
     916:	85 c0                	test   %eax,%eax
     918:	75 23                	jne    93d <parseatom+0x5d>
    (*ps)++;
     91a:	8b 07                	mov    (%edi),%eax
     91c:	83 c0 01             	add    $0x1,%eax
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     91f:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
     921:	89 07                	mov    %eax,(%edi)
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     923:	73 18                	jae    93d <parseatom+0x5d>
     925:	0f be 00             	movsbl (%eax),%eax
     928:	83 ec 08             	sub    $0x8,%esp
     92b:	50                   	push   %eax
     92c:	68 64 18 00 00       	push   $0x1864
     931:	e8 2a 03 00 00       	call   c60 <strchr>
     936:	83 c4 10             	add    $0x10,%esp
     939:	85 c0                	test   %eax,%eax
     93b:	74 c3                	je     900 <parseatom+0x20>

  ret = atom();
     93d:	e8 ce fe ff ff       	call   810 <atom>
  atm = (struct atom *)ret;

  atm->type = ATOM;
     942:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  atm->symbol = s;
     948:	89 70 04             	mov    %esi,0x4(%eax)
  atm->esymbol = *ps;
     94b:	8b 17                	mov    (%edi),%edx
     94d:	89 50 08             	mov    %edx,0x8(%eax)

  return ret;
}
     950:	8d 65 f4             	lea    -0xc(%ebp),%esp
     953:	5b                   	pop    %ebx
     954:	5e                   	pop    %esi
     955:	5f                   	pop    %edi
     956:	5d                   	pop    %ebp
     957:	c3                   	ret    
     958:	90                   	nop
     959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000960 <parsesexp>:

struct sexp *parsesexp(char **ps, char *es) {
     960:	55                   	push   %ebp
     961:	89 e5                	mov    %esp,%ebp
     963:	56                   	push   %esi
     964:	53                   	push   %ebx
     965:	8b 75 08             	mov    0x8(%ebp),%esi
     968:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct sexp *ret = 0;

  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     96b:	8b 06                	mov    (%esi),%eax
     96d:	39 c3                	cmp    %eax,%ebx
     96f:	77 10                	ja     981 <parsesexp+0x21>
     971:	eb 28                	jmp    99b <parsesexp+0x3b>
     973:	90                   	nop
     974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    (*ps)++;
     978:	83 c0 01             	add    $0x1,%eax
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     97b:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
     97d:	89 06                	mov    %eax,(%esi)
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     97f:	73 1a                	jae    99b <parsesexp+0x3b>
     981:	0f be 00             	movsbl (%eax),%eax
     984:	83 ec 08             	sub    $0x8,%esp
     987:	50                   	push   %eax
     988:	68 64 18 00 00       	push   $0x1864
     98d:	e8 ce 02 00 00       	call   c60 <strchr>
     992:	83 c4 10             	add    $0x10,%esp
     995:	85 c0                	test   %eax,%eax
    (*ps)++;
     997:	8b 06                	mov    (%esi),%eax
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     999:	75 dd                	jne    978 <parsesexp+0x18>
  switch (*(*ps)) {
     99b:	0f b6 10             	movzbl (%eax),%edx
     99e:	80 fa 27             	cmp    $0x27,%dl
     9a1:	74 55                	je     9f8 <parsesexp+0x98>
     9a3:	80 fa 28             	cmp    $0x28,%dl
     9a6:	74 28                	je     9d0 <parsesexp+0x70>
     9a8:	84 d2                	test   %dl,%dl
     9aa:	74 14                	je     9c0 <parsesexp+0x60>
    (*ps) += 2;
    ret = parselist(ps, es);
    (*ps)++;
    break;
  default:
    ret = parseatom(ps, es);
     9ac:	89 5d 0c             	mov    %ebx,0xc(%ebp)
     9af:	89 75 08             	mov    %esi,0x8(%ebp)
    break;
  }
  return ret;
}
     9b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
     9b5:	5b                   	pop    %ebx
     9b6:	5e                   	pop    %esi
     9b7:	5d                   	pop    %ebp
    ret = parseatom(ps, es);
     9b8:	e9 23 ff ff ff       	jmp    8e0 <parseatom>
     9bd:	8d 76 00             	lea    0x0(%esi),%esi
}
     9c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  struct sexp *ret = 0;
     9c3:	31 c0                	xor    %eax,%eax
}
     9c5:	5b                   	pop    %ebx
     9c6:	5e                   	pop    %esi
     9c7:	5d                   	pop    %ebp
     9c8:	c3                   	ret    
     9c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret = parselist(ps, es);
     9d0:	83 ec 08             	sub    $0x8,%esp
    (*ps)++;
     9d3:	83 c0 01             	add    $0x1,%eax
     9d6:	89 06                	mov    %eax,(%esi)
    ret = parselist(ps, es);
     9d8:	53                   	push   %ebx
     9d9:	56                   	push   %esi
     9da:	e8 41 00 00 00       	call   a20 <parselist>
    ret->type = APPLY;
     9df:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    break;
     9e5:	83 c4 10             	add    $0x10,%esp
    (*ps)++;
     9e8:	83 06 01             	addl   $0x1,(%esi)
}
     9eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
     9ee:	5b                   	pop    %ebx
     9ef:	5e                   	pop    %esi
     9f0:	5d                   	pop    %ebp
     9f1:	c3                   	ret    
     9f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ret = parselist(ps, es);
     9f8:	83 ec 08             	sub    $0x8,%esp
    (*ps) += 2;
     9fb:	83 c0 02             	add    $0x2,%eax
     9fe:	89 06                	mov    %eax,(%esi)
    ret = parselist(ps, es);
     a00:	53                   	push   %ebx
     a01:	56                   	push   %esi
     a02:	e8 19 00 00 00       	call   a20 <parselist>
    (*ps)++;
     a07:	83 06 01             	addl   $0x1,(%esi)
    break;
     a0a:	83 c4 10             	add    $0x10,%esp
}
     a0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     a10:	5b                   	pop    %ebx
     a11:	5e                   	pop    %esi
     a12:	5d                   	pop    %ebp
     a13:	c3                   	ret    
     a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000a20 <parselist>:
struct sexp *parselist(char **ps, char *es) {
     a20:	55                   	push   %ebp
     a21:	89 e5                	mov    %esp,%ebp
     a23:	57                   	push   %edi
     a24:	56                   	push   %esi
     a25:	53                   	push   %ebx
     a26:	83 ec 1c             	sub    $0x1c,%esp
     a29:	8b 75 08             	mov    0x8(%ebp),%esi
     a2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  ret = list();
     a2f:	e8 0c fe ff ff       	call   840 <list>
  lst->type = LIST;
     a34:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  ret = list();
     a3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *res = *ps;
     a3d:	8b 0e                	mov    (%esi),%ecx
  while (res < es) {
     a3f:	39 f9                	cmp    %edi,%ecx
     a41:	89 cb                	mov    %ecx,%ebx
     a43:	73 3b                	jae    a80 <parselist+0x60>
  int i = 1;
     a45:	ba 01 00 00 00       	mov    $0x1,%edx
     a4a:	eb 14                	jmp    a60 <parselist+0x40>
     a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (*res == ')') {
     a50:	3c 29                	cmp    $0x29,%al
     a52:	75 05                	jne    a59 <parselist+0x39>
      if (i == 0) {
     a54:	83 ea 01             	sub    $0x1,%edx
     a57:	74 27                	je     a80 <parselist+0x60>
    res++;
     a59:	83 c3 01             	add    $0x1,%ebx
  while (res < es) {
     a5c:	39 df                	cmp    %ebx,%edi
     a5e:	74 11                	je     a71 <parselist+0x51>
    if (*res == '(')
     a60:	0f b6 03             	movzbl (%ebx),%eax
     a63:	3c 28                	cmp    $0x28,%al
     a65:	75 e9                	jne    a50 <parselist+0x30>
    res++;
     a67:	83 c3 01             	add    $0x1,%ebx
      i++;
     a6a:	83 c2 01             	add    $0x1,%edx
  while (res < es) {
     a6d:	39 df                	cmp    %ebx,%edi
     a6f:	75 ef                	jne    a60 <parselist+0x40>
    panic("syntax");
     a71:	83 ec 0c             	sub    $0xc,%esp
     a74:	68 ad 12 00 00       	push   $0x12ad
     a79:	e8 f2 f8 ff ff       	call   370 <panic>
     a7e:	66 90                	xchg   %ax,%ax
  if (res == es)
     a80:	39 df                	cmp    %ebx,%edi
     a82:	74 ed                	je     a71 <parselist+0x51>
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     a84:	31 ff                	xor    %edi,%edi
     a86:	eb 0a                	jmp    a92 <parselist+0x72>
     a88:	90                   	nop
     a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a90:	8b 0e                	mov    (%esi),%ecx
     a92:	39 d9                	cmp    %ebx,%ecx
     a94:	73 1c                	jae    ab2 <parselist+0x92>
    lst->sexps[i] = parsesexp(ps, res);
     a96:	83 ec 08             	sub    $0x8,%esp
     a99:	53                   	push   %ebx
     a9a:	56                   	push   %esi
     a9b:	e8 c0 fe ff ff       	call   960 <parsesexp>
     aa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     aa3:	83 c4 10             	add    $0x10,%esp
    lst->sexps[i] = parsesexp(ps, res);
     aa6:	89 44 ba 08          	mov    %eax,0x8(%edx,%edi,4)
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     aaa:	83 c7 01             	add    $0x1,%edi
     aad:	83 ff 0a             	cmp    $0xa,%edi
     ab0:	75 de                	jne    a90 <parselist+0x70>
  lst->length = i;
     ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ab5:	89 78 04             	mov    %edi,0x4(%eax)
}
     ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
     abb:	5b                   	pop    %ebx
     abc:	5e                   	pop    %esi
     abd:	5f                   	pop    %edi
     abe:	5d                   	pop    %ebp
     abf:	c3                   	ret    

00000ac0 <snulterminate>:
  }
  snulterminate(exp);
  return exp;
}

struct sexp *snulterminate(struct sexp *exp) {
     ac0:	55                   	push   %ebp
     ac1:	89 e5                	mov    %esp,%ebp
     ac3:	56                   	push   %esi
     ac4:	53                   	push   %ebx
     ac5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;
  struct list *lst;
  struct atom *atm;

  if (exp == 0)
     ac8:	85 db                	test   %ebx,%ebx
     aca:	74 2e                	je     afa <snulterminate+0x3a>
    return 0;

  switch (exp->type) {
     acc:	8b 03                	mov    (%ebx),%eax
     ace:	83 f8 01             	cmp    $0x1,%eax
     ad1:	74 35                	je     b08 <snulterminate+0x48>
     ad3:	7c 25                	jl     afa <snulterminate+0x3a>
     ad5:	83 f8 03             	cmp    $0x3,%eax
     ad8:	7f 20                	jg     afa <snulterminate+0x3a>
    break;

  case APPLY:
  case LIST:
    lst = (struct list *)exp;
    for (i = 0; i < lst->length; i++)
     ada:	8b 43 04             	mov    0x4(%ebx),%eax
     add:	31 f6                	xor    %esi,%esi
     adf:	85 c0                	test   %eax,%eax
     ae1:	7e 17                	jle    afa <snulterminate+0x3a>
      snulterminate(lst->sexps[i]);
     ae3:	83 ec 0c             	sub    $0xc,%esp
     ae6:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
    for (i = 0; i < lst->length; i++)
     aea:	83 c6 01             	add    $0x1,%esi
      snulterminate(lst->sexps[i]);
     aed:	e8 ce ff ff ff       	call   ac0 <snulterminate>
    for (i = 0; i < lst->length; i++)
     af2:	83 c4 10             	add    $0x10,%esp
     af5:	3b 73 04             	cmp    0x4(%ebx),%esi
     af8:	7c e9                	jl     ae3 <snulterminate+0x23>
    break;
  }
  return exp;
}
     afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
     afd:	89 d8                	mov    %ebx,%eax
     aff:	5b                   	pop    %ebx
     b00:	5e                   	pop    %esi
     b01:	5d                   	pop    %ebp
     b02:	c3                   	ret    
     b03:	90                   	nop
     b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *atm->esymbol = 0;
     b08:	8b 43 08             	mov    0x8(%ebx),%eax
     b0b:	c6 00 00             	movb   $0x0,(%eax)
}
     b0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b11:	89 d8                	mov    %ebx,%eax
     b13:	5b                   	pop    %ebx
     b14:	5e                   	pop    %esi
     b15:	5d                   	pop    %ebp
     b16:	c3                   	ret    
     b17:	89 f6                	mov    %esi,%esi
     b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b20 <parseexp>:
struct sexp *parseexp(char *s) {
     b20:	55                   	push   %ebp
     b21:	89 e5                	mov    %esp,%ebp
     b23:	56                   	push   %esi
     b24:	53                   	push   %ebx
  es = s + strlen(s);
     b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
     b28:	83 ec 0c             	sub    $0xc,%esp
     b2b:	53                   	push   %ebx
     b2c:	e8 df 00 00 00       	call   c10 <strlen>
  exp = parsesexp(&s, es);
     b31:	59                   	pop    %ecx
  es = s + strlen(s);
     b32:	01 c3                	add    %eax,%ebx
  exp = parsesexp(&s, es);
     b34:	8d 45 08             	lea    0x8(%ebp),%eax
     b37:	5e                   	pop    %esi
     b38:	53                   	push   %ebx
     b39:	50                   	push   %eax
     b3a:	e8 21 fe ff ff       	call   960 <parsesexp>
     b3f:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     b41:	8d 45 08             	lea    0x8(%ebp),%eax
     b44:	83 c4 0c             	add    $0xc,%esp
     b47:	68 ff 12 00 00       	push   $0x12ff
     b4c:	53                   	push   %ebx
     b4d:	50                   	push   %eax
     b4e:	e8 1d fd ff ff       	call   870 <peek>
  if (s != es) {
     b53:	8b 45 08             	mov    0x8(%ebp),%eax
     b56:	83 c4 10             	add    $0x10,%esp
     b59:	39 d8                	cmp    %ebx,%eax
     b5b:	75 12                	jne    b6f <parseexp+0x4f>
  snulterminate(exp);
     b5d:	83 ec 0c             	sub    $0xc,%esp
     b60:	56                   	push   %esi
     b61:	e8 5a ff ff ff       	call   ac0 <snulterminate>
}
     b66:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b69:	89 f0                	mov    %esi,%eax
     b6b:	5b                   	pop    %ebx
     b6c:	5e                   	pop    %esi
     b6d:	5d                   	pop    %ebp
     b6e:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     b6f:	52                   	push   %edx
     b70:	50                   	push   %eax
     b71:	68 d8 12 00 00       	push   $0x12d8
     b76:	6a 02                	push   $0x2
     b78:	e8 c3 03 00 00       	call   f40 <printf>
    panic("syntax");
     b7d:	c7 04 24 ad 12 00 00 	movl   $0x12ad,(%esp)
     b84:	e8 e7 f7 ff ff       	call   370 <panic>
     b89:	66 90                	xchg   %ax,%ax
     b8b:	66 90                	xchg   %ax,%ax
     b8d:	66 90                	xchg   %ax,%ax
     b8f:	90                   	nop

00000b90 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     b90:	55                   	push   %ebp
     b91:	89 e5                	mov    %esp,%ebp
     b93:	53                   	push   %ebx
     b94:	8b 45 08             	mov    0x8(%ebp),%eax
     b97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b9a:	89 c2                	mov    %eax,%edx
     b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ba0:	83 c1 01             	add    $0x1,%ecx
     ba3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     ba7:	83 c2 01             	add    $0x1,%edx
     baa:	84 db                	test   %bl,%bl
     bac:	88 5a ff             	mov    %bl,-0x1(%edx)
     baf:	75 ef                	jne    ba0 <strcpy+0x10>
    ;
  return os;
}
     bb1:	5b                   	pop    %ebx
     bb2:	5d                   	pop    %ebp
     bb3:	c3                   	ret    
     bb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     bba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000bc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bc0:	55                   	push   %ebp
     bc1:	89 e5                	mov    %esp,%ebp
     bc3:	53                   	push   %ebx
     bc4:	8b 55 08             	mov    0x8(%ebp),%edx
     bc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     bca:	0f b6 02             	movzbl (%edx),%eax
     bcd:	0f b6 19             	movzbl (%ecx),%ebx
     bd0:	84 c0                	test   %al,%al
     bd2:	75 1c                	jne    bf0 <strcmp+0x30>
     bd4:	eb 2a                	jmp    c00 <strcmp+0x40>
     bd6:	8d 76 00             	lea    0x0(%esi),%esi
     bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
     be0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     be3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
     be6:	83 c1 01             	add    $0x1,%ecx
     be9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
     bec:	84 c0                	test   %al,%al
     bee:	74 10                	je     c00 <strcmp+0x40>
     bf0:	38 d8                	cmp    %bl,%al
     bf2:	74 ec                	je     be0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     bf4:	29 d8                	sub    %ebx,%eax
}
     bf6:	5b                   	pop    %ebx
     bf7:	5d                   	pop    %ebp
     bf8:	c3                   	ret    
     bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c00:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     c02:	29 d8                	sub    %ebx,%eax
}
     c04:	5b                   	pop    %ebx
     c05:	5d                   	pop    %ebp
     c06:	c3                   	ret    
     c07:	89 f6                	mov    %esi,%esi
     c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c10 <strlen>:

uint
strlen(char *s)
{
     c10:	55                   	push   %ebp
     c11:	89 e5                	mov    %esp,%ebp
     c13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     c16:	80 39 00             	cmpb   $0x0,(%ecx)
     c19:	74 15                	je     c30 <strlen+0x20>
     c1b:	31 d2                	xor    %edx,%edx
     c1d:	8d 76 00             	lea    0x0(%esi),%esi
     c20:	83 c2 01             	add    $0x1,%edx
     c23:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     c27:	89 d0                	mov    %edx,%eax
     c29:	75 f5                	jne    c20 <strlen+0x10>
    ;
  return n;
}
     c2b:	5d                   	pop    %ebp
     c2c:	c3                   	ret    
     c2d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
     c30:	31 c0                	xor    %eax,%eax
}
     c32:	5d                   	pop    %ebp
     c33:	c3                   	ret    
     c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000c40 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c40:	55                   	push   %ebp
     c41:	89 e5                	mov    %esp,%ebp
     c43:	57                   	push   %edi
     c44:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     c47:	8b 4d 10             	mov    0x10(%ebp),%ecx
     c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
     c4d:	89 d7                	mov    %edx,%edi
     c4f:	fc                   	cld    
     c50:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     c52:	89 d0                	mov    %edx,%eax
     c54:	5f                   	pop    %edi
     c55:	5d                   	pop    %ebp
     c56:	c3                   	ret    
     c57:	89 f6                	mov    %esi,%esi
     c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c60 <strchr>:

char*
strchr(const char *s, char c)
{
     c60:	55                   	push   %ebp
     c61:	89 e5                	mov    %esp,%ebp
     c63:	53                   	push   %ebx
     c64:	8b 45 08             	mov    0x8(%ebp),%eax
     c67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
     c6a:	0f b6 10             	movzbl (%eax),%edx
     c6d:	84 d2                	test   %dl,%dl
     c6f:	74 1d                	je     c8e <strchr+0x2e>
    if(*s == c)
     c71:	38 d3                	cmp    %dl,%bl
     c73:	89 d9                	mov    %ebx,%ecx
     c75:	75 0d                	jne    c84 <strchr+0x24>
     c77:	eb 17                	jmp    c90 <strchr+0x30>
     c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c80:	38 ca                	cmp    %cl,%dl
     c82:	74 0c                	je     c90 <strchr+0x30>
  for(; *s; s++)
     c84:	83 c0 01             	add    $0x1,%eax
     c87:	0f b6 10             	movzbl (%eax),%edx
     c8a:	84 d2                	test   %dl,%dl
     c8c:	75 f2                	jne    c80 <strchr+0x20>
      return (char*)s;
  return 0;
     c8e:	31 c0                	xor    %eax,%eax
}
     c90:	5b                   	pop    %ebx
     c91:	5d                   	pop    %ebp
     c92:	c3                   	ret    
     c93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ca0 <gets>:

char*
gets(char *buf, int max)
{
     ca0:	55                   	push   %ebp
     ca1:	89 e5                	mov    %esp,%ebp
     ca3:	57                   	push   %edi
     ca4:	56                   	push   %esi
     ca5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ca6:	31 f6                	xor    %esi,%esi
     ca8:	89 f3                	mov    %esi,%ebx
{
     caa:	83 ec 1c             	sub    $0x1c,%esp
     cad:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     cb0:	eb 2f                	jmp    ce1 <gets+0x41>
     cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     cb8:	8d 45 e7             	lea    -0x19(%ebp),%eax
     cbb:	83 ec 04             	sub    $0x4,%esp
     cbe:	6a 01                	push   $0x1
     cc0:	50                   	push   %eax
     cc1:	6a 00                	push   $0x0
     cc3:	e8 32 01 00 00       	call   dfa <read>
    if(cc < 1)
     cc8:	83 c4 10             	add    $0x10,%esp
     ccb:	85 c0                	test   %eax,%eax
     ccd:	7e 1c                	jle    ceb <gets+0x4b>
      break;
    buf[i++] = c;
     ccf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     cd3:	83 c7 01             	add    $0x1,%edi
     cd6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     cd9:	3c 0a                	cmp    $0xa,%al
     cdb:	74 23                	je     d00 <gets+0x60>
     cdd:	3c 0d                	cmp    $0xd,%al
     cdf:	74 1f                	je     d00 <gets+0x60>
  for(i=0; i+1 < max; ){
     ce1:	83 c3 01             	add    $0x1,%ebx
     ce4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     ce7:	89 fe                	mov    %edi,%esi
     ce9:	7c cd                	jl     cb8 <gets+0x18>
     ceb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     ced:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     cf0:	c6 03 00             	movb   $0x0,(%ebx)
}
     cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cf6:	5b                   	pop    %ebx
     cf7:	5e                   	pop    %esi
     cf8:	5f                   	pop    %edi
     cf9:	5d                   	pop    %ebp
     cfa:	c3                   	ret    
     cfb:	90                   	nop
     cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d00:	8b 75 08             	mov    0x8(%ebp),%esi
     d03:	8b 45 08             	mov    0x8(%ebp),%eax
     d06:	01 de                	add    %ebx,%esi
     d08:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     d0a:	c6 03 00             	movb   $0x0,(%ebx)
}
     d0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d10:	5b                   	pop    %ebx
     d11:	5e                   	pop    %esi
     d12:	5f                   	pop    %edi
     d13:	5d                   	pop    %ebp
     d14:	c3                   	ret    
     d15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d20 <stat>:

int
stat(char *n, struct stat *st)
{
     d20:	55                   	push   %ebp
     d21:	89 e5                	mov    %esp,%ebp
     d23:	56                   	push   %esi
     d24:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d25:	83 ec 08             	sub    $0x8,%esp
     d28:	6a 00                	push   $0x0
     d2a:	ff 75 08             	pushl  0x8(%ebp)
     d2d:	e8 f0 00 00 00       	call   e22 <open>
  if(fd < 0)
     d32:	83 c4 10             	add    $0x10,%esp
     d35:	85 c0                	test   %eax,%eax
     d37:	78 27                	js     d60 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     d39:	83 ec 08             	sub    $0x8,%esp
     d3c:	ff 75 0c             	pushl  0xc(%ebp)
     d3f:	89 c3                	mov    %eax,%ebx
     d41:	50                   	push   %eax
     d42:	e8 f3 00 00 00       	call   e3a <fstat>
  close(fd);
     d47:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     d4a:	89 c6                	mov    %eax,%esi
  close(fd);
     d4c:	e8 b9 00 00 00       	call   e0a <close>
  return r;
     d51:	83 c4 10             	add    $0x10,%esp
}
     d54:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d57:	89 f0                	mov    %esi,%eax
     d59:	5b                   	pop    %ebx
     d5a:	5e                   	pop    %esi
     d5b:	5d                   	pop    %ebp
     d5c:	c3                   	ret    
     d5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     d60:	be ff ff ff ff       	mov    $0xffffffff,%esi
     d65:	eb ed                	jmp    d54 <stat+0x34>
     d67:	89 f6                	mov    %esi,%esi
     d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d70 <atoi>:

int
atoi(const char *s)
{
     d70:	55                   	push   %ebp
     d71:	89 e5                	mov    %esp,%ebp
     d73:	53                   	push   %ebx
     d74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d77:	0f be 11             	movsbl (%ecx),%edx
     d7a:	8d 42 d0             	lea    -0x30(%edx),%eax
     d7d:	3c 09                	cmp    $0x9,%al
  n = 0;
     d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
     d84:	77 1f                	ja     da5 <atoi+0x35>
     d86:	8d 76 00             	lea    0x0(%esi),%esi
     d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
     d90:	8d 04 80             	lea    (%eax,%eax,4),%eax
     d93:	83 c1 01             	add    $0x1,%ecx
     d96:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
     d9a:	0f be 11             	movsbl (%ecx),%edx
     d9d:	8d 5a d0             	lea    -0x30(%edx),%ebx
     da0:	80 fb 09             	cmp    $0x9,%bl
     da3:	76 eb                	jbe    d90 <atoi+0x20>
  return n;
}
     da5:	5b                   	pop    %ebx
     da6:	5d                   	pop    %ebp
     da7:	c3                   	ret    
     da8:	90                   	nop
     da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000db0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     db0:	55                   	push   %ebp
     db1:	89 e5                	mov    %esp,%ebp
     db3:	56                   	push   %esi
     db4:	53                   	push   %ebx
     db5:	8b 5d 10             	mov    0x10(%ebp),%ebx
     db8:	8b 45 08             	mov    0x8(%ebp),%eax
     dbb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     dbe:	85 db                	test   %ebx,%ebx
     dc0:	7e 14                	jle    dd6 <memmove+0x26>
     dc2:	31 d2                	xor    %edx,%edx
     dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
     dc8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     dcc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     dcf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
     dd2:	39 d3                	cmp    %edx,%ebx
     dd4:	75 f2                	jne    dc8 <memmove+0x18>
  return vdst;
}
     dd6:	5b                   	pop    %ebx
     dd7:	5e                   	pop    %esi
     dd8:	5d                   	pop    %ebp
     dd9:	c3                   	ret    

00000dda <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     dda:	b8 01 00 00 00       	mov    $0x1,%eax
     ddf:	cd 40                	int    $0x40
     de1:	c3                   	ret    

00000de2 <exit>:
SYSCALL(exit)
     de2:	b8 02 00 00 00       	mov    $0x2,%eax
     de7:	cd 40                	int    $0x40
     de9:	c3                   	ret    

00000dea <wait>:
SYSCALL(wait)
     dea:	b8 03 00 00 00       	mov    $0x3,%eax
     def:	cd 40                	int    $0x40
     df1:	c3                   	ret    

00000df2 <pipe>:
SYSCALL(pipe)
     df2:	b8 04 00 00 00       	mov    $0x4,%eax
     df7:	cd 40                	int    $0x40
     df9:	c3                   	ret    

00000dfa <read>:
SYSCALL(read)
     dfa:	b8 05 00 00 00       	mov    $0x5,%eax
     dff:	cd 40                	int    $0x40
     e01:	c3                   	ret    

00000e02 <write>:
SYSCALL(write)
     e02:	b8 10 00 00 00       	mov    $0x10,%eax
     e07:	cd 40                	int    $0x40
     e09:	c3                   	ret    

00000e0a <close>:
SYSCALL(close)
     e0a:	b8 15 00 00 00       	mov    $0x15,%eax
     e0f:	cd 40                	int    $0x40
     e11:	c3                   	ret    

00000e12 <kill>:
SYSCALL(kill)
     e12:	b8 06 00 00 00       	mov    $0x6,%eax
     e17:	cd 40                	int    $0x40
     e19:	c3                   	ret    

00000e1a <exec>:
SYSCALL(exec)
     e1a:	b8 07 00 00 00       	mov    $0x7,%eax
     e1f:	cd 40                	int    $0x40
     e21:	c3                   	ret    

00000e22 <open>:
SYSCALL(open)
     e22:	b8 0f 00 00 00       	mov    $0xf,%eax
     e27:	cd 40                	int    $0x40
     e29:	c3                   	ret    

00000e2a <mknod>:
SYSCALL(mknod)
     e2a:	b8 11 00 00 00       	mov    $0x11,%eax
     e2f:	cd 40                	int    $0x40
     e31:	c3                   	ret    

00000e32 <unlink>:
SYSCALL(unlink)
     e32:	b8 12 00 00 00       	mov    $0x12,%eax
     e37:	cd 40                	int    $0x40
     e39:	c3                   	ret    

00000e3a <fstat>:
SYSCALL(fstat)
     e3a:	b8 08 00 00 00       	mov    $0x8,%eax
     e3f:	cd 40                	int    $0x40
     e41:	c3                   	ret    

00000e42 <link>:
SYSCALL(link)
     e42:	b8 13 00 00 00       	mov    $0x13,%eax
     e47:	cd 40                	int    $0x40
     e49:	c3                   	ret    

00000e4a <mkdir>:
SYSCALL(mkdir)
     e4a:	b8 14 00 00 00       	mov    $0x14,%eax
     e4f:	cd 40                	int    $0x40
     e51:	c3                   	ret    

00000e52 <chdir>:
SYSCALL(chdir)
     e52:	b8 09 00 00 00       	mov    $0x9,%eax
     e57:	cd 40                	int    $0x40
     e59:	c3                   	ret    

00000e5a <dup>:
SYSCALL(dup)
     e5a:	b8 0a 00 00 00       	mov    $0xa,%eax
     e5f:	cd 40                	int    $0x40
     e61:	c3                   	ret    

00000e62 <getpid>:
SYSCALL(getpid)
     e62:	b8 0b 00 00 00       	mov    $0xb,%eax
     e67:	cd 40                	int    $0x40
     e69:	c3                   	ret    

00000e6a <sbrk>:
SYSCALL(sbrk)
     e6a:	b8 0c 00 00 00       	mov    $0xc,%eax
     e6f:	cd 40                	int    $0x40
     e71:	c3                   	ret    

00000e72 <sleep>:
SYSCALL(sleep)
     e72:	b8 0d 00 00 00       	mov    $0xd,%eax
     e77:	cd 40                	int    $0x40
     e79:	c3                   	ret    

00000e7a <uptime>:
SYSCALL(uptime)
     e7a:	b8 0e 00 00 00       	mov    $0xe,%eax
     e7f:	cd 40                	int    $0x40
     e81:	c3                   	ret    

00000e82 <trace>:
SYSCALL(trace)
     e82:	b8 16 00 00 00       	mov    $0x16,%eax
     e87:	cd 40                	int    $0x40
     e89:	c3                   	ret    

00000e8a <getsharem>:
SYSCALL(getsharem)
     e8a:	b8 17 00 00 00       	mov    $0x17,%eax
     e8f:	cd 40                	int    $0x40
     e91:	c3                   	ret    

00000e92 <releasesharem>:
SYSCALL(releasesharem)
     e92:	b8 18 00 00 00       	mov    $0x18,%eax
     e97:	cd 40                	int    $0x40
     e99:	c3                   	ret    
     e9a:	66 90                	xchg   %ax,%ax
     e9c:	66 90                	xchg   %ax,%ax
     e9e:	66 90                	xchg   %ax,%ax

00000ea0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     ea0:	55                   	push   %ebp
     ea1:	89 e5                	mov    %esp,%ebp
     ea3:	57                   	push   %edi
     ea4:	56                   	push   %esi
     ea5:	53                   	push   %ebx
     ea6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ea9:	85 d2                	test   %edx,%edx
{
     eab:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
     eae:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
     eb0:	79 76                	jns    f28 <printint+0x88>
     eb2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     eb6:	74 70                	je     f28 <printint+0x88>
    x = -xx;
     eb8:	f7 d8                	neg    %eax
    neg = 1;
     eba:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     ec1:	31 f6                	xor    %esi,%esi
     ec3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
     ec6:	eb 0a                	jmp    ed2 <printint+0x32>
     ec8:	90                   	nop
     ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
     ed0:	89 fe                	mov    %edi,%esi
     ed2:	31 d2                	xor    %edx,%edx
     ed4:	8d 7e 01             	lea    0x1(%esi),%edi
     ed7:	f7 f1                	div    %ecx
     ed9:	0f b6 92 28 13 00 00 	movzbl 0x1328(%edx),%edx
  }while((x /= base) != 0);
     ee0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
     ee2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
     ee5:	75 e9                	jne    ed0 <printint+0x30>
  if(neg)
     ee7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     eea:	85 c0                	test   %eax,%eax
     eec:	74 08                	je     ef6 <printint+0x56>
    buf[i++] = '-';
     eee:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
     ef3:	8d 7e 02             	lea    0x2(%esi),%edi
     ef6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
     efa:	8b 7d c0             	mov    -0x40(%ebp),%edi
     efd:	8d 76 00             	lea    0x0(%esi),%esi
     f00:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
     f03:	83 ec 04             	sub    $0x4,%esp
     f06:	83 ee 01             	sub    $0x1,%esi
     f09:	6a 01                	push   $0x1
     f0b:	53                   	push   %ebx
     f0c:	57                   	push   %edi
     f0d:	88 45 d7             	mov    %al,-0x29(%ebp)
     f10:	e8 ed fe ff ff       	call   e02 <write>

  while(--i >= 0)
     f15:	83 c4 10             	add    $0x10,%esp
     f18:	39 de                	cmp    %ebx,%esi
     f1a:	75 e4                	jne    f00 <printint+0x60>
    putc(fd, buf[i]);
}
     f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f1f:	5b                   	pop    %ebx
     f20:	5e                   	pop    %esi
     f21:	5f                   	pop    %edi
     f22:	5d                   	pop    %ebp
     f23:	c3                   	ret    
     f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     f28:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     f2f:	eb 90                	jmp    ec1 <printint+0x21>
     f31:	eb 0d                	jmp    f40 <printf>
     f33:	90                   	nop
     f34:	90                   	nop
     f35:	90                   	nop
     f36:	90                   	nop
     f37:	90                   	nop
     f38:	90                   	nop
     f39:	90                   	nop
     f3a:	90                   	nop
     f3b:	90                   	nop
     f3c:	90                   	nop
     f3d:	90                   	nop
     f3e:	90                   	nop
     f3f:	90                   	nop

00000f40 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     f40:	55                   	push   %ebp
     f41:	89 e5                	mov    %esp,%ebp
     f43:	57                   	push   %edi
     f44:	56                   	push   %esi
     f45:	53                   	push   %ebx
     f46:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     f49:	8b 75 0c             	mov    0xc(%ebp),%esi
     f4c:	0f b6 1e             	movzbl (%esi),%ebx
     f4f:	84 db                	test   %bl,%bl
     f51:	0f 84 b3 00 00 00    	je     100a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
     f57:	8d 45 10             	lea    0x10(%ebp),%eax
     f5a:	83 c6 01             	add    $0x1,%esi
  state = 0;
     f5d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
     f5f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     f62:	eb 2f                	jmp    f93 <printf+0x53>
     f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     f68:	83 f8 25             	cmp    $0x25,%eax
     f6b:	0f 84 a7 00 00 00    	je     1018 <printf+0xd8>
  write(fd, &c, 1);
     f71:	8d 45 e2             	lea    -0x1e(%ebp),%eax
     f74:	83 ec 04             	sub    $0x4,%esp
     f77:	88 5d e2             	mov    %bl,-0x1e(%ebp)
     f7a:	6a 01                	push   $0x1
     f7c:	50                   	push   %eax
     f7d:	ff 75 08             	pushl  0x8(%ebp)
     f80:	e8 7d fe ff ff       	call   e02 <write>
     f85:	83 c4 10             	add    $0x10,%esp
     f88:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
     f8b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
     f8f:	84 db                	test   %bl,%bl
     f91:	74 77                	je     100a <printf+0xca>
    if(state == 0){
     f93:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
     f95:	0f be cb             	movsbl %bl,%ecx
     f98:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     f9b:	74 cb                	je     f68 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f9d:	83 ff 25             	cmp    $0x25,%edi
     fa0:	75 e6                	jne    f88 <printf+0x48>
      if(c == 'd'){
     fa2:	83 f8 64             	cmp    $0x64,%eax
     fa5:	0f 84 05 01 00 00    	je     10b0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     fab:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     fb1:	83 f9 70             	cmp    $0x70,%ecx
     fb4:	74 72                	je     1028 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     fb6:	83 f8 73             	cmp    $0x73,%eax
     fb9:	0f 84 99 00 00 00    	je     1058 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     fbf:	83 f8 63             	cmp    $0x63,%eax
     fc2:	0f 84 08 01 00 00    	je     10d0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     fc8:	83 f8 25             	cmp    $0x25,%eax
     fcb:	0f 84 ef 00 00 00    	je     10c0 <printf+0x180>
  write(fd, &c, 1);
     fd1:	8d 45 e7             	lea    -0x19(%ebp),%eax
     fd4:	83 ec 04             	sub    $0x4,%esp
     fd7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     fdb:	6a 01                	push   $0x1
     fdd:	50                   	push   %eax
     fde:	ff 75 08             	pushl  0x8(%ebp)
     fe1:	e8 1c fe ff ff       	call   e02 <write>
     fe6:	83 c4 0c             	add    $0xc,%esp
     fe9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     fec:	88 5d e6             	mov    %bl,-0x1a(%ebp)
     fef:	6a 01                	push   $0x1
     ff1:	50                   	push   %eax
     ff2:	ff 75 08             	pushl  0x8(%ebp)
     ff5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     ff8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
     ffa:	e8 03 fe ff ff       	call   e02 <write>
  for(i = 0; fmt[i]; i++){
     fff:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
    1003:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1006:	84 db                	test   %bl,%bl
    1008:	75 89                	jne    f93 <printf+0x53>
    }
  }
}
    100a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    100d:	5b                   	pop    %ebx
    100e:	5e                   	pop    %esi
    100f:	5f                   	pop    %edi
    1010:	5d                   	pop    %ebp
    1011:	c3                   	ret    
    1012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
    1018:	bf 25 00 00 00       	mov    $0x25,%edi
    101d:	e9 66 ff ff ff       	jmp    f88 <printf+0x48>
    1022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1028:	83 ec 0c             	sub    $0xc,%esp
    102b:	b9 10 00 00 00       	mov    $0x10,%ecx
    1030:	6a 00                	push   $0x0
    1032:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1035:	8b 45 08             	mov    0x8(%ebp),%eax
    1038:	8b 17                	mov    (%edi),%edx
    103a:	e8 61 fe ff ff       	call   ea0 <printint>
        ap++;
    103f:	89 f8                	mov    %edi,%eax
    1041:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1044:	31 ff                	xor    %edi,%edi
        ap++;
    1046:	83 c0 04             	add    $0x4,%eax
    1049:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    104c:	e9 37 ff ff ff       	jmp    f88 <printf+0x48>
    1051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1058:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    105b:	8b 08                	mov    (%eax),%ecx
        ap++;
    105d:	83 c0 04             	add    $0x4,%eax
    1060:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    1063:	85 c9                	test   %ecx,%ecx
    1065:	0f 84 8e 00 00 00    	je     10f9 <printf+0x1b9>
        while(*s != 0){
    106b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
    106e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
    1070:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
    1072:	84 c0                	test   %al,%al
    1074:	0f 84 0e ff ff ff    	je     f88 <printf+0x48>
    107a:	89 75 d0             	mov    %esi,-0x30(%ebp)
    107d:	89 de                	mov    %ebx,%esi
    107f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1082:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1085:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1088:	83 ec 04             	sub    $0x4,%esp
          s++;
    108b:	83 c6 01             	add    $0x1,%esi
    108e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    1091:	6a 01                	push   $0x1
    1093:	57                   	push   %edi
    1094:	53                   	push   %ebx
    1095:	e8 68 fd ff ff       	call   e02 <write>
        while(*s != 0){
    109a:	0f b6 06             	movzbl (%esi),%eax
    109d:	83 c4 10             	add    $0x10,%esp
    10a0:	84 c0                	test   %al,%al
    10a2:	75 e4                	jne    1088 <printf+0x148>
    10a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    10a7:	31 ff                	xor    %edi,%edi
    10a9:	e9 da fe ff ff       	jmp    f88 <printf+0x48>
    10ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    10b0:	83 ec 0c             	sub    $0xc,%esp
    10b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    10b8:	6a 01                	push   $0x1
    10ba:	e9 73 ff ff ff       	jmp    1032 <printf+0xf2>
    10bf:	90                   	nop
  write(fd, &c, 1);
    10c0:	83 ec 04             	sub    $0x4,%esp
    10c3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    10c6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    10c9:	6a 01                	push   $0x1
    10cb:	e9 21 ff ff ff       	jmp    ff1 <printf+0xb1>
        putc(fd, *ap);
    10d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    10d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    10d6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    10d8:	6a 01                	push   $0x1
        ap++;
    10da:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    10dd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    10e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    10e3:	50                   	push   %eax
    10e4:	ff 75 08             	pushl  0x8(%ebp)
    10e7:	e8 16 fd ff ff       	call   e02 <write>
        ap++;
    10ec:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    10ef:	83 c4 10             	add    $0x10,%esp
      state = 0;
    10f2:	31 ff                	xor    %edi,%edi
    10f4:	e9 8f fe ff ff       	jmp    f88 <printf+0x48>
          s = "(null)";
    10f9:	bb 20 13 00 00       	mov    $0x1320,%ebx
        while(*s != 0){
    10fe:	b8 28 00 00 00       	mov    $0x28,%eax
    1103:	e9 72 ff ff ff       	jmp    107a <printf+0x13a>
    1108:	66 90                	xchg   %ax,%ax
    110a:	66 90                	xchg   %ax,%ax
    110c:	66 90                	xchg   %ax,%ax
    110e:	66 90                	xchg   %ax,%ax

00001110 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1110:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1111:	a1 e4 18 00 00       	mov    0x18e4,%eax
{
    1116:	89 e5                	mov    %esp,%ebp
    1118:	57                   	push   %edi
    1119:	56                   	push   %esi
    111a:	53                   	push   %ebx
    111b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    111e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    1121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1128:	39 c8                	cmp    %ecx,%eax
    112a:	8b 10                	mov    (%eax),%edx
    112c:	73 32                	jae    1160 <free+0x50>
    112e:	39 d1                	cmp    %edx,%ecx
    1130:	72 04                	jb     1136 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1132:	39 d0                	cmp    %edx,%eax
    1134:	72 32                	jb     1168 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1136:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1139:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    113c:	39 fa                	cmp    %edi,%edx
    113e:	74 30                	je     1170 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1140:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1143:	8b 50 04             	mov    0x4(%eax),%edx
    1146:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1149:	39 f1                	cmp    %esi,%ecx
    114b:	74 3a                	je     1187 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    114d:	89 08                	mov    %ecx,(%eax)
  freep = p;
    114f:	a3 e4 18 00 00       	mov    %eax,0x18e4
}
    1154:	5b                   	pop    %ebx
    1155:	5e                   	pop    %esi
    1156:	5f                   	pop    %edi
    1157:	5d                   	pop    %ebp
    1158:	c3                   	ret    
    1159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1160:	39 d0                	cmp    %edx,%eax
    1162:	72 04                	jb     1168 <free+0x58>
    1164:	39 d1                	cmp    %edx,%ecx
    1166:	72 ce                	jb     1136 <free+0x26>
{
    1168:	89 d0                	mov    %edx,%eax
    116a:	eb bc                	jmp    1128 <free+0x18>
    116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1170:	03 72 04             	add    0x4(%edx),%esi
    1173:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1176:	8b 10                	mov    (%eax),%edx
    1178:	8b 12                	mov    (%edx),%edx
    117a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    117d:	8b 50 04             	mov    0x4(%eax),%edx
    1180:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1183:	39 f1                	cmp    %esi,%ecx
    1185:	75 c6                	jne    114d <free+0x3d>
    p->s.size += bp->s.size;
    1187:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    118a:	a3 e4 18 00 00       	mov    %eax,0x18e4
    p->s.size += bp->s.size;
    118f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1192:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1195:	89 10                	mov    %edx,(%eax)
}
    1197:	5b                   	pop    %ebx
    1198:	5e                   	pop    %esi
    1199:	5f                   	pop    %edi
    119a:	5d                   	pop    %ebp
    119b:	c3                   	ret    
    119c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000011a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    11a0:	55                   	push   %ebp
    11a1:	89 e5                	mov    %esp,%ebp
    11a3:	57                   	push   %edi
    11a4:	56                   	push   %esi
    11a5:	53                   	push   %ebx
    11a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    11ac:	8b 15 e4 18 00 00    	mov    0x18e4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11b2:	8d 78 07             	lea    0x7(%eax),%edi
    11b5:	c1 ef 03             	shr    $0x3,%edi
    11b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    11bb:	85 d2                	test   %edx,%edx
    11bd:	0f 84 9d 00 00 00    	je     1260 <malloc+0xc0>
    11c3:	8b 02                	mov    (%edx),%eax
    11c5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    11c8:	39 cf                	cmp    %ecx,%edi
    11ca:	76 6c                	jbe    1238 <malloc+0x98>
    11cc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    11d2:	bb 00 10 00 00       	mov    $0x1000,%ebx
    11d7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    11da:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    11e1:	eb 0e                	jmp    11f1 <malloc+0x51>
    11e3:	90                   	nop
    11e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    11ea:	8b 48 04             	mov    0x4(%eax),%ecx
    11ed:	39 f9                	cmp    %edi,%ecx
    11ef:	73 47                	jae    1238 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11f1:	39 05 e4 18 00 00    	cmp    %eax,0x18e4
    11f7:	89 c2                	mov    %eax,%edx
    11f9:	75 ed                	jne    11e8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    11fb:	83 ec 0c             	sub    $0xc,%esp
    11fe:	56                   	push   %esi
    11ff:	e8 66 fc ff ff       	call   e6a <sbrk>
  if(p == (char*)-1)
    1204:	83 c4 10             	add    $0x10,%esp
    1207:	83 f8 ff             	cmp    $0xffffffff,%eax
    120a:	74 1c                	je     1228 <malloc+0x88>
  hp->s.size = nu;
    120c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    120f:	83 ec 0c             	sub    $0xc,%esp
    1212:	83 c0 08             	add    $0x8,%eax
    1215:	50                   	push   %eax
    1216:	e8 f5 fe ff ff       	call   1110 <free>
  return freep;
    121b:	8b 15 e4 18 00 00    	mov    0x18e4,%edx
      if((p = morecore(nunits)) == 0)
    1221:	83 c4 10             	add    $0x10,%esp
    1224:	85 d2                	test   %edx,%edx
    1226:	75 c0                	jne    11e8 <malloc+0x48>
        return 0;
  }
}
    1228:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    122b:	31 c0                	xor    %eax,%eax
}
    122d:	5b                   	pop    %ebx
    122e:	5e                   	pop    %esi
    122f:	5f                   	pop    %edi
    1230:	5d                   	pop    %ebp
    1231:	c3                   	ret    
    1232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1238:	39 cf                	cmp    %ecx,%edi
    123a:	74 54                	je     1290 <malloc+0xf0>
        p->s.size -= nunits;
    123c:	29 f9                	sub    %edi,%ecx
    123e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1241:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1244:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    1247:	89 15 e4 18 00 00    	mov    %edx,0x18e4
}
    124d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1250:	83 c0 08             	add    $0x8,%eax
}
    1253:	5b                   	pop    %ebx
    1254:	5e                   	pop    %esi
    1255:	5f                   	pop    %edi
    1256:	5d                   	pop    %ebp
    1257:	c3                   	ret    
    1258:	90                   	nop
    1259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    1260:	c7 05 e4 18 00 00 e8 	movl   $0x18e8,0x18e4
    1267:	18 00 00 
    126a:	c7 05 e8 18 00 00 e8 	movl   $0x18e8,0x18e8
    1271:	18 00 00 
    base.s.size = 0;
    1274:	b8 e8 18 00 00       	mov    $0x18e8,%eax
    1279:	c7 05 ec 18 00 00 00 	movl   $0x0,0x18ec
    1280:	00 00 00 
    1283:	e9 44 ff ff ff       	jmp    11cc <malloc+0x2c>
    1288:	90                   	nop
    1289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    1290:	8b 08                	mov    (%eax),%ecx
    1292:	89 0a                	mov    %ecx,(%edx)
    1294:	eb b1                	jmp    1247 <malloc+0xa7>
