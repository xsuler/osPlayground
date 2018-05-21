
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
      13:	e8 92 0d 00 00       	call   daa <getsharem>
  sh->nfunc = 0;
  sh->top = (char *)sh + sizeof(struct shared);
      18:	8d 90 1c 05 00 00    	lea    0x51c(%eax),%edx
  sh->nfunc = 0;
      1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  sh->top = (char *)sh + sizeof(struct shared);
      24:	89 90 18 05 00 00    	mov    %edx,0x518(%eax)
  split(-2);
      2a:	c7 04 24 fe ff ff ff 	movl   $0xfffffffe,(%esp)
      31:	e8 84 0d 00 00       	call   dba <split>

  // Ensure that three file descriptors are open.
  while ((fd = open("console", O_RDWR)) >= 0) {
      36:	83 c4 10             	add    $0x10,%esp
      39:	eb 0a                	jmp    45 <main+0x45>
      3b:	90                   	nop
      3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (fd >= 3) {
      40:	83 f8 02             	cmp    $0x2,%eax
      43:	7f 7a                	jg     bf <main+0xbf>
  while ((fd = open("console", O_RDWR)) >= 0) {
      45:	83 ec 08             	sub    $0x8,%esp
      48:	6a 02                	push   $0x2
      4a:	68 04 12 00 00       	push   $0x1204
      4f:	e8 ee 0c 00 00       	call   d42 <open>
      54:	83 c4 10             	add    $0x10,%esp
      57:	85 c0                	test   %eax,%eax
      59:	79 e5                	jns    40 <main+0x40>
      5b:	eb 23                	jmp    80 <main+0x80>
      5d:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }

  // Read and run input commands.
  while (getcmd(buf, sizeof(buf)) >= 0) {
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      60:	80 3d 82 17 00 00 20 	cmpb   $0x20,0x1782
      67:	0f 84 83 00 00 00    	je     f0 <main+0xf0>
}

int fork1(void) {
  int pid;

  pid = fork();
      6d:	e8 88 0c 00 00       	call   cfa <fork>
  if (pid == -1)
      72:	83 f8 ff             	cmp    $0xffffffff,%eax
      75:	74 3b                	je     b2 <main+0xb2>
    if (fork1() == 0) {
      77:	85 c0                	test   %eax,%eax
      79:	74 57                	je     d2 <main+0xd2>
    wait();
      7b:	e8 8a 0c 00 00       	call   d0a <wait>
  while (getcmd(buf, sizeof(buf)) >= 0) {
      80:	83 ec 08             	sub    $0x8,%esp
      83:	6a 64                	push   $0x64
      85:	68 80 17 00 00       	push   $0x1780
      8a:	e8 91 02 00 00       	call   320 <getcmd>
      8f:	83 c4 10             	add    $0x10,%esp
      92:	85 c0                	test   %eax,%eax
      94:	78 37                	js     cd <main+0xcd>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      96:	80 3d 80 17 00 00 63 	cmpb   $0x63,0x1780
      9d:	75 ce                	jne    6d <main+0x6d>
      9f:	80 3d 81 17 00 00 64 	cmpb   $0x64,0x1781
      a6:	74 b8                	je     60 <main+0x60>
  pid = fork();
      a8:	e8 4d 0c 00 00       	call   cfa <fork>
  if (pid == -1)
      ad:	83 f8 ff             	cmp    $0xffffffff,%eax
      b0:	75 c5                	jne    77 <main+0x77>
    panic("fork");
      b2:	83 ec 0c             	sub    $0xc,%esp
      b5:	68 ea 11 00 00       	push   $0x11ea
      ba:	e8 b1 02 00 00       	call   370 <panic>
      close(fd);
      bf:	83 ec 0c             	sub    $0xc,%esp
      c2:	50                   	push   %eax
      c3:	e8 62 0c 00 00       	call   d2a <close>
      break;
      c8:	83 c4 10             	add    $0x10,%esp
      cb:	eb b3                	jmp    80 <main+0x80>
  exit();
      cd:	e8 30 0c 00 00       	call   d02 <exit>
      getsharem(0);
      d2:	83 ec 0c             	sub    $0xc,%esp
      d5:	6a 00                	push   $0x0
      d7:	e8 ce 0c 00 00       	call   daa <getsharem>
      runexp(parseexp(buf));
      dc:	c7 04 24 80 17 00 00 	movl   $0x1780,(%esp)
      e3:	e8 58 09 00 00       	call   a40 <parseexp>
      e8:	89 04 24             	mov    %eax,(%esp)
      eb:	e8 a0 02 00 00       	call   390 <runexp>
      buf[strlen(buf) - 1] = 0; // chop \n
      f0:	83 ec 0c             	sub    $0xc,%esp
      f3:	68 80 17 00 00       	push   $0x1780
      f8:	e8 33 0a 00 00       	call   b30 <strlen>
      if (chdir(buf + 3) < 0)
      fd:	c7 04 24 83 17 00 00 	movl   $0x1783,(%esp)
      buf[strlen(buf) - 1] = 0; // chop \n
     104:	c6 80 7f 17 00 00 00 	movb   $0x0,0x177f(%eax)
      if (chdir(buf + 3) < 0)
     10b:	e8 62 0c 00 00       	call   d72 <chdir>
     110:	83 c4 10             	add    $0x10,%esp
     113:	85 c0                	test   %eax,%eax
     115:	0f 89 65 ff ff ff    	jns    80 <main+0x80>
        printf(2, "cannot cd %s\n", buf + 3);
     11b:	50                   	push   %eax
     11c:	68 83 17 00 00       	push   $0x1783
     121:	68 0c 12 00 00       	push   $0x120c
     126:	6a 02                	push   $0x2
     128:	e8 43 0d 00 00       	call   e70 <printf>
     12d:	83 c4 10             	add    $0x10,%esp
     130:	e9 4b ff ff ff       	jmp    80 <main+0x80>
     135:	66 90                	xchg   %ax,%ax
     137:	66 90                	xchg   %ax,%ax
     139:	66 90                	xchg   %ax,%ax
     13b:	66 90                	xchg   %ax,%ax
     13d:	66 90                	xchg   %ax,%ax
     13f:	90                   	nop

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
     197:	e8 44 09 00 00       	call   ae0 <strcmp>
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
     235:	e8 76 08 00 00       	call   ab0 <strcpy>
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
     26e:	e8 37 0b 00 00       	call   daa <getsharem>
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
     292:	e8 19 08 00 00       	call   ab0 <strcpy>
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
     2f9:	e8 b2 07 00 00       	call   ab0 <strcpy>
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
     32e:	68 c8 11 00 00       	push   $0x11c8
     333:	6a 02                	push   $0x2
     335:	e8 36 0b 00 00       	call   e70 <printf>
  memset(buf, 0, nbuf);
     33a:	83 c4 0c             	add    $0xc,%esp
     33d:	56                   	push   %esi
     33e:	6a 00                	push   $0x0
     340:	53                   	push   %ebx
     341:	e8 1a 08 00 00       	call   b60 <memset>
  gets(buf, nbuf);
     346:	58                   	pop    %eax
     347:	5a                   	pop    %edx
     348:	56                   	push   %esi
     349:	53                   	push   %ebx
     34a:	e8 71 08 00 00       	call   bc0 <gets>
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
     379:	68 00 12 00 00       	push   $0x1200
     37e:	6a 02                	push   $0x2
     380:	e8 eb 0a 00 00       	call   e70 <printf>
  exit();
     385:	e8 78 09 00 00       	call   d02 <exit>
     38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000390 <runexp>:
void runexp(struct sexp *exp) {
     390:	55                   	push   %ebp
     391:	89 e5                	mov    %esp,%ebp
     393:	57                   	push   %edi
     394:	56                   	push   %esi
     395:	53                   	push   %ebx
     396:	81 ec bc 00 00 00    	sub    $0xbc,%esp
     39c:	8b 75 08             	mov    0x8(%ebp),%esi
  if (exp == 0)
     39f:	85 f6                	test   %esi,%esi
     3a1:	74 7d                	je     420 <runexp+0x90>
  switch (exp->type) {
     3a3:	8b 06                	mov    (%esi),%eax
     3a5:	83 f8 02             	cmp    $0x2,%eax
     3a8:	74 1e                	je     3c8 <runexp+0x38>
     3aa:	83 f8 03             	cmp    $0x3,%eax
     3ad:	74 76                	je     425 <runexp+0x95>
     3af:	83 e8 01             	sub    $0x1,%eax
     3b2:	74 6c                	je     420 <runexp+0x90>
    panic("runexp type error");
     3b4:	83 ec 0c             	sub    $0xc,%esp
     3b7:	68 cb 11 00 00       	push   $0x11cb
     3bc:	e8 af ff ff ff       	call   370 <panic>
     3c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < lst->length; i++)
     3c8:	8b 7e 04             	mov    0x4(%esi),%edi
     3cb:	85 ff                	test   %edi,%edi
     3cd:	7e 51                	jle    420 <runexp+0x90>
      runexp(lst->sexps[i]);
     3cf:	83 ec 0c             	sub    $0xc,%esp
     3d2:	ff 76 08             	pushl  0x8(%esi)
     3d5:	e8 b6 ff ff ff       	call   390 <runexp>
      if ((i == 0) && (strcmp(argv[0], "defun") == 0)) {
     3da:	51                   	push   %ecx
     3db:	51                   	push   %ecx
     3dc:	68 ef 11 00 00       	push   $0x11ef
     3e1:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     3e7:	e8 f4 06 00 00       	call   ae0 <strcmp>
     3ec:	83 c4 10             	add    $0x10,%esp
     3ef:	85 c0                	test   %eax,%eax
     3f1:	75 5f                	jne    452 <runexp+0xc2>
  pid = fork();
     3f3:	e8 02 09 00 00       	call   cfa <fork>
  if (pid == -1)
     3f8:	83 f8 ff             	cmp    $0xffffffff,%eax
     3fb:	0f 84 f4 02 00 00    	je     6f5 <runexp+0x365>
        if (fork1() == 0) {
     401:	85 c0                	test   %eax,%eax
     403:	75 15                	jne    41a <runexp+0x8a>
          if (argv[0] == 0)
     405:	83 bd 5c ff ff ff 00 	cmpl   $0x0,-0xa4(%ebp)
     40c:	74 12                	je     420 <runexp+0x90>
          defunc(lst);
     40e:	83 ec 0c             	sub    $0xc,%esp
     411:	56                   	push   %esi
     412:	e8 49 fe ff ff       	call   260 <defunc>
     417:	83 c4 10             	add    $0x10,%esp
        wait();
     41a:	e8 eb 08 00 00       	call   d0a <wait>
     41f:	90                   	nop
  exit();
     420:	e8 dd 08 00 00       	call   d02 <exit>
    argv[lst->length] = 0;
     425:	8b 46 04             	mov    0x4(%esi),%eax
    for (i = 0; i < lst->length; i++) {
     428:	85 c0                	test   %eax,%eax
    argv[lst->length] = 0;
     42a:	c7 84 85 5c ff ff ff 	movl   $0x0,-0xa4(%ebp,%eax,4)
     431:	00 00 00 00 
    for (i = 0; i < lst->length; i++) {
     435:	7e e9                	jle    420 <runexp+0x90>
     437:	31 ff                	xor    %edi,%edi
     439:	eb 28                	jmp    463 <runexp+0xd3>
     43b:	90                   	nop
     43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      else if (lst->sexps[i]->type == LIST)
     440:	83 f8 02             	cmp    $0x2,%eax
     443:	0f 84 68 02 00 00    	je     6b1 <runexp+0x321>
      else if (lst->sexps[i]->type == APPLY) {
     449:	83 f8 03             	cmp    $0x3,%eax
     44c:	74 2c                	je     47a <runexp+0xea>
      if ((i == 0) && (strcmp(argv[0], "defun") == 0)) {
     44e:	85 ff                	test   %edi,%edi
     450:	74 88                	je     3da <runexp+0x4a>
      if (i == lst->length - 1) {
     452:	8b 46 04             	mov    0x4(%esi),%eax
     455:	8d 50 ff             	lea    -0x1(%eax),%edx
     458:	39 fa                	cmp    %edi,%edx
     45a:	74 4a                	je     4a6 <runexp+0x116>
    for (i = 0; i < lst->length; i++) {
     45c:	83 c7 01             	add    $0x1,%edi
     45f:	39 c7                	cmp    %eax,%edi
     461:	7d bd                	jge    420 <runexp+0x90>
      if (lst->sexps[i]->type == ATOM)
     463:	8b 54 be 08          	mov    0x8(%esi,%edi,4),%edx
     467:	8b 02                	mov    (%edx),%eax
     469:	83 f8 01             	cmp    $0x1,%eax
     46c:	75 d2                	jne    440 <runexp+0xb0>
        argv[i] = ((struct atom *)lst->sexps[i])->symbol;
     46e:	8b 42 04             	mov    0x4(%edx),%eax
     471:	89 84 bd 5c ff ff ff 	mov    %eax,-0xa4(%ebp,%edi,4)
     478:	eb d4                	jmp    44e <runexp+0xbe>
  pid = fork();
     47a:	e8 7b 08 00 00       	call   cfa <fork>
  if (pid == -1)
     47f:	83 f8 ff             	cmp    $0xffffffff,%eax
     482:	0f 84 6d 02 00 00    	je     6f5 <runexp+0x365>
     488:	6b df 0a             	imul   $0xa,%edi,%ebx
     48b:	8d 4d 84             	lea    -0x7c(%ebp),%ecx
     48e:	01 cb                	add    %ecx,%ebx
        if (fork1() == 0) {
     490:	85 c0                	test   %eax,%eax
     492:	0f 84 26 02 00 00    	je     6be <runexp+0x32e>
        wait();
     498:	e8 6d 08 00 00       	call   d0a <wait>
        argv[i] = xargv[i];
     49d:	89 9c bd 5c ff ff ff 	mov    %ebx,-0xa4(%ebp,%edi,4)
     4a4:	eb a8                	jmp    44e <runexp+0xbe>
        struct shared *sh = (struct shared *)getsharem(0);
     4a6:	83 ec 0c             	sub    $0xc,%esp
     4a9:	31 db                	xor    %ebx,%ebx
     4ab:	6a 00                	push   $0x0
     4ad:	e8 f8 08 00 00       	call   daa <getsharem>
        for (j = 0; j < MAXFUNC; j++) {
     4b2:	31 c9                	xor    %ecx,%ecx
        struct shared *sh = (struct shared *)getsharem(0);
     4b4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
     4ba:	83 c0 04             	add    $0x4,%eax
     4bd:	89 bd 50 ff ff ff    	mov    %edi,-0xb0(%ebp)
     4c3:	89 75 08             	mov    %esi,0x8(%ebp)
     4c6:	83 c4 10             	add    $0x10,%esp
     4c9:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
     4cf:	89 cf                	mov    %ecx,%edi
     4d1:	89 de                	mov    %ebx,%esi
     4d3:	90                   	nop
     4d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     4d8:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
          if (strcmp(argv[0], sh->funcs[j].name) == 0) {
     4de:	83 ec 08             	sub    $0x8,%esp
     4e1:	8d 1c 30             	lea    (%eax,%esi,1),%ebx
     4e4:	53                   	push   %ebx
     4e5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     4eb:	e8 f0 05 00 00       	call   ae0 <strcmp>
     4f0:	83 c4 10             	add    $0x10,%esp
     4f3:	85 c0                	test   %eax,%eax
     4f5:	0f 84 c3 00 00 00    	je     5be <runexp+0x22e>
        for (j = 0; j < MAXFUNC; j++) {
     4fb:	83 c7 01             	add    $0x1,%edi
     4fe:	83 c6 78             	add    $0x78,%esi
     501:	83 ff 0a             	cmp    $0xa,%edi
     504:	75 d2                	jne    4d8 <runexp+0x148>
     506:	89 bd 48 ff ff ff    	mov    %edi,-0xb8(%ebp)
     50c:	8b 75 08             	mov    0x8(%ebp),%esi
        int j, k, flg = 0;
     50f:	31 db                	xor    %ebx,%ebx
     511:	8b bd 50 ff ff ff    	mov    -0xb0(%ebp),%edi
  pid = fork();
     517:	e8 de 07 00 00       	call   cfa <fork>
  if (pid == -1)
     51c:	83 f8 ff             	cmp    $0xffffffff,%eax
     51f:	0f 84 d0 01 00 00    	je     6f5 <runexp+0x365>
        if (fork1() == 0) {
     525:	85 c0                	test   %eax,%eax
     527:	0f 85 84 00 00 00    	jne    5b1 <runexp+0x221>
          if (argv[0] == 0)
     52d:	83 bd 5c ff ff ff 00 	cmpl   $0x0,-0xa4(%ebp)
     534:	0f 84 e6 fe ff ff    	je     420 <runexp+0x90>
          if (flg == 1) {
     53a:	83 fb 01             	cmp    $0x1,%ebx
     53d:	0f 84 97 01 00 00    	je     6da <runexp+0x34a>
            getsharem(0);
     543:	83 ec 0c             	sub    $0xc,%esp
     546:	6a 00                	push   $0x0
     548:	e8 5d 08 00 00       	call   daa <getsharem>
     54d:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
     553:	89 75 08             	mov    %esi,0x8(%ebp)
     556:	83 c4 10             	add    $0x10,%esp
     559:	89 bd 50 ff ff ff    	mov    %edi,-0xb0(%ebp)
     55f:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
     565:	89 c6                	mov    %eax,%esi
              if (argv[j] == 0)
     567:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
     56a:	85 c0                	test   %eax,%eax
     56c:	74 24                	je     592 <runexp+0x202>
     56e:	6b d3 0a             	imul   $0xa,%ebx,%edx
     571:	8d 4d 84             	lea    -0x7c(%ebp),%ecx
     574:	8d 3c 0a             	lea    (%edx,%ecx,1),%edi
              if(argv[j]!=xargv[j])
     577:	39 f8                	cmp    %edi,%eax
     579:	74 0f                	je     58a <runexp+0x1fa>
                strcpy(xargv[j], argv[j]);
     57b:	52                   	push   %edx
     57c:	52                   	push   %edx
     57d:	50                   	push   %eax
     57e:	57                   	push   %edi
     57f:	e8 2c 05 00 00       	call   ab0 <strcpy>
                argv[j] = xargv[j];
     584:	89 3c 9e             	mov    %edi,(%esi,%ebx,4)
     587:	83 c4 10             	add    $0x10,%esp
            for (j = 0; j < MAXARGS; j++) {
     58a:	83 c3 01             	add    $0x1,%ebx
     58d:	83 fb 0a             	cmp    $0xa,%ebx
     590:	75 d5                	jne    567 <runexp+0x1d7>
            exec(argv[0], argv);
     592:	50                   	push   %eax
     593:	50                   	push   %eax
     594:	ff b5 54 ff ff ff    	pushl  -0xac(%ebp)
     59a:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     5a0:	8b bd 50 ff ff ff    	mov    -0xb0(%ebp),%edi
     5a6:	8b 75 08             	mov    0x8(%ebp),%esi
     5a9:	e8 8c 07 00 00       	call   d3a <exec>
     5ae:	83 c4 10             	add    $0x10,%esp
        wait();
     5b1:	e8 54 07 00 00       	call   d0a <wait>
     5b6:	8b 46 04             	mov    0x4(%esi),%eax
     5b9:	e9 9e fe ff ff       	jmp    45c <runexp+0xcc>
     5be:	89 c2                	mov    %eax,%edx
     5c0:	89 f8                	mov    %edi,%eax
            argv[sh->funcs[j].argc+1] = 0;
     5c2:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
     5c8:	6b c0 78             	imul   $0x78,%eax,%eax
     5cb:	89 bd 48 ff ff ff    	mov    %edi,-0xb8(%ebp)
     5d1:	8b bd 50 ff ff ff    	mov    -0xb0(%ebp),%edi
              strcpy(sh->xargv[k], argv[k]);
     5d7:	89 95 44 ff ff ff    	mov    %edx,-0xbc(%ebp)
     5dd:	89 9d 50 ff ff ff    	mov    %ebx,-0xb0(%ebp)
            for (k = 0; k < MAXARGS; k++) {
     5e3:	31 db                	xor    %ebx,%ebx
              strcpy(sh->xargv[k], argv[k]);
     5e5:	81 c1 b4 04 00 00    	add    $0x4b4,%ecx
            argv[sh->funcs[j].argc+1] = 0;
     5eb:	8b 84 01 c0 fb ff ff 	mov    -0x440(%ecx,%eax,1),%eax
              strcpy(sh->xargv[k], argv[k]);
     5f2:	89 bd 40 ff ff ff    	mov    %edi,-0xc0(%ebp)
     5f8:	89 cf                	mov    %ecx,%edi
            argv[sh->funcs[j].argc+1] = 0;
     5fa:	c7 84 85 60 ff ff ff 	movl   $0x0,-0xa0(%ebp,%eax,4)
     601:	00 00 00 00 
     605:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
     60b:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
              strcpy(sh->xargv[k], argv[k]);
     611:	89 c6                	mov    %eax,%esi
              if (argv[k] == 0)
     613:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
     616:	85 c0                	test   %eax,%eax
     618:	74 19                	je     633 <runexp+0x2a3>
              strcpy(sh->xargv[k], argv[k]);
     61a:	52                   	push   %edx
     61b:	52                   	push   %edx
     61c:	50                   	push   %eax
     61d:	6b c3 0a             	imul   $0xa,%ebx,%eax
            for (k = 0; k < MAXARGS; k++) {
     620:	83 c3 01             	add    $0x1,%ebx
              strcpy(sh->xargv[k], argv[k]);
     623:	01 f8                	add    %edi,%eax
     625:	50                   	push   %eax
     626:	e8 85 04 00 00       	call   ab0 <strcpy>
            for (k = 0; k < MAXARGS; k++) {
     62b:	83 c4 10             	add    $0x10,%esp
     62e:	83 fb 0a             	cmp    $0xa,%ebx
     631:	75 e0                	jne    613 <runexp+0x283>
            for (k = 0; k < sh->funcs[j].argc; k++)
     633:	6b 8d 48 ff ff ff 78 	imul   $0x78,-0xb8(%ebp),%ecx
     63a:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
     640:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
     646:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
     64c:	89 d3                	mov    %edx,%ebx
     64e:	89 bd 44 ff ff ff    	mov    %edi,-0xbc(%ebp)
     654:	01 c1                	add    %eax,%ecx
              replaceAtom(sh->funcs[j].sexp, sh->funcs[j].argv[k], sh->xargv[k + 1]);
     656:	05 b4 04 00 00       	add    $0x4b4,%eax
     65b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
     661:	89 cf                	mov    %ecx,%edi
     663:	eb 34                	jmp    699 <runexp+0x309>
     665:	83 c3 01             	add    $0x1,%ebx
     668:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
     66e:	52                   	push   %edx
     66f:	6b c3 0a             	imul   $0xa,%ebx,%eax
     672:	8d 34 08             	lea    (%eax,%ecx,1),%esi
     675:	03 85 4c ff ff ff    	add    -0xb4(%ebp),%eax
     67b:	50                   	push   %eax
     67c:	56                   	push   %esi
     67d:	ff 77 78             	pushl  0x78(%edi)
     680:	e8 bb fa ff ff       	call   140 <replaceAtom>
              strcpy(sh->funcs[j].argv[k],argv[k+1]);
     685:	59                   	pop    %ecx
     686:	58                   	pop    %eax
     687:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
     68d:	ff 34 98             	pushl  (%eax,%ebx,4)
     690:	56                   	push   %esi
     691:	e8 1a 04 00 00       	call   ab0 <strcpy>
            for (k = 0; k < sh->funcs[j].argc; k++)
     696:	83 c4 10             	add    $0x10,%esp
     699:	39 5f 74             	cmp    %ebx,0x74(%edi)
     69c:	7f c7                	jg     665 <runexp+0x2d5>
     69e:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
     6a4:	8b 75 08             	mov    0x8(%ebp),%esi
            flg = 1;
     6a7:	bb 01 00 00 00       	mov    $0x1,%ebx
     6ac:	e9 66 fe ff ff       	jmp    517 <runexp+0x187>
        panic("syntax error");
     6b1:	83 ec 0c             	sub    $0xc,%esp
     6b4:	68 dd 11 00 00       	push   $0x11dd
     6b9:	e8 b2 fc ff ff       	call   370 <panic>
          getsharem(0);
     6be:	83 ec 0c             	sub    $0xc,%esp
     6c1:	6a 00                	push   $0x0
     6c3:	e8 e2 06 00 00       	call   daa <getsharem>
          memo(xargv[i]);
     6c8:	89 1c 24             	mov    %ebx,(%esp)
     6cb:	e8 f2 06 00 00       	call   dc2 <memo>
          runexp(lst->sexps[i]);
     6d0:	5b                   	pop    %ebx
     6d1:	ff 74 be 08          	pushl  0x8(%esi,%edi,4)
     6d5:	e8 b6 fc ff ff       	call   390 <runexp>
            struct shared *sh = (struct shared *)getsharem(0);
     6da:	83 ec 0c             	sub    $0xc,%esp
     6dd:	6a 00                	push   $0x0
     6df:	e8 c6 06 00 00       	call   daa <getsharem>
            runexp(sh->funcs[j].sexp);
     6e4:	6b 95 48 ff ff ff 78 	imul   $0x78,-0xb8(%ebp),%edx
     6eb:	59                   	pop    %ecx
     6ec:	ff 74 10 78          	pushl  0x78(%eax,%edx,1)
     6f0:	e8 9b fc ff ff       	call   390 <runexp>
    panic("fork");
     6f5:	83 ec 0c             	sub    $0xc,%esp
     6f8:	68 ea 11 00 00       	push   $0x11ea
     6fd:	e8 6e fc ff ff       	call   370 <panic>
     702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000710 <fork1>:
int fork1(void) {
     710:	55                   	push   %ebp
     711:	89 e5                	mov    %esp,%ebp
     713:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     716:	e8 df 05 00 00       	call   cfa <fork>
  if (pid == -1)
     71b:	83 f8 ff             	cmp    $0xffffffff,%eax
     71e:	74 02                	je     722 <fork1+0x12>

  return pid;
}
     720:	c9                   	leave  
     721:	c3                   	ret    
    panic("fork");
     722:	83 ec 0c             	sub    $0xc,%esp
     725:	68 ea 11 00 00       	push   $0x11ea
     72a:	e8 41 fc ff ff       	call   370 <panic>
     72f:	90                   	nop

00000730 <atom>:

// PAGEBREAK!
// Constructors

struct sexp *atom(void) {
     730:	55                   	push   %ebp
     731:	89 e5                	mov    %esp,%ebp
     733:	53                   	push   %ebx
     734:	83 ec 10             	sub    $0x10,%esp
  struct atom *exp;

  exp = malloc(sizeof(*exp));
     737:	6a 0c                	push   $0xc
     739:	e8 92 09 00 00       	call   10d0 <malloc>
  memset(exp, 0, sizeof(*exp));
     73e:	83 c4 0c             	add    $0xc,%esp
  exp = malloc(sizeof(*exp));
     741:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     743:	6a 0c                	push   $0xc
     745:	6a 00                	push   $0x0
     747:	50                   	push   %eax
     748:	e8 13 04 00 00       	call   b60 <memset>
  return (struct sexp *)exp;
}
     74d:	89 d8                	mov    %ebx,%eax
     74f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     752:	c9                   	leave  
     753:	c3                   	ret    
     754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     75a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000760 <list>:

struct sexp *list(void) {
     760:	55                   	push   %ebp
     761:	89 e5                	mov    %esp,%ebp
     763:	53                   	push   %ebx
     764:	83 ec 10             	sub    $0x10,%esp
  struct list *exp;

  exp = malloc(sizeof(*exp));
     767:	6a 30                	push   $0x30
     769:	e8 62 09 00 00       	call   10d0 <malloc>
  memset(exp, 0, sizeof(*exp));
     76e:	83 c4 0c             	add    $0xc,%esp
  exp = malloc(sizeof(*exp));
     771:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     773:	6a 30                	push   $0x30
     775:	6a 00                	push   $0x0
     777:	50                   	push   %eax
     778:	e8 e3 03 00 00       	call   b60 <memset>
  return (struct sexp *)exp;
}
     77d:	89 d8                	mov    %ebx,%eax
     77f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     782:	c9                   	leave  
     783:	c3                   	ret    
     784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     78a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000790 <peek>:
// Parsing

char whitespace[] = " \t\r\n\v";
char esymbols[] = "()";

int peek(char **ps, char *es, char *toks) {
     790:	55                   	push   %ebp
     791:	89 e5                	mov    %esp,%ebp
     793:	57                   	push   %edi
     794:	56                   	push   %esi
     795:	53                   	push   %ebx
     796:	83 ec 0c             	sub    $0xc,%esp
     799:	8b 7d 08             	mov    0x8(%ebp),%edi
     79c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps; while (s < es && strchr(whitespace, *s))
     79f:	8b 1f                	mov    (%edi),%ebx
     7a1:	39 f3                	cmp    %esi,%ebx
     7a3:	72 12                	jb     7b7 <peek+0x27>
     7a5:	eb 28                	jmp    7cf <peek+0x3f>
     7a7:	89 f6                	mov    %esi,%esi
     7a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
     7b0:	83 c3 01             	add    $0x1,%ebx
  s = *ps; while (s < es && strchr(whitespace, *s))
     7b3:	39 de                	cmp    %ebx,%esi
     7b5:	74 18                	je     7cf <peek+0x3f>
     7b7:	0f be 03             	movsbl (%ebx),%eax
     7ba:	83 ec 08             	sub    $0x8,%esp
     7bd:	50                   	push   %eax
     7be:	68 60 17 00 00       	push   $0x1760
     7c3:	e8 b8 03 00 00       	call   b80 <strchr>
     7c8:	83 c4 10             	add    $0x10,%esp
     7cb:	85 c0                	test   %eax,%eax
     7cd:	75 e1                	jne    7b0 <peek+0x20>
  *ps = s;
     7cf:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     7d1:	0f be 13             	movsbl (%ebx),%edx
     7d4:	31 c0                	xor    %eax,%eax
     7d6:	84 d2                	test   %dl,%dl
     7d8:	74 17                	je     7f1 <peek+0x61>
     7da:	83 ec 08             	sub    $0x8,%esp
     7dd:	52                   	push   %edx
     7de:	ff 75 10             	pushl  0x10(%ebp)
     7e1:	e8 9a 03 00 00       	call   b80 <strchr>
     7e6:	83 c4 10             	add    $0x10,%esp
     7e9:	85 c0                	test   %eax,%eax
     7eb:	0f 95 c0             	setne  %al
     7ee:	0f b6 c0             	movzbl %al,%eax
}
     7f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7f4:	5b                   	pop    %ebx
     7f5:	5e                   	pop    %esi
     7f6:	5f                   	pop    %edi
     7f7:	5d                   	pop    %ebp
     7f8:	c3                   	ret    
     7f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000800 <parseatom>:
  lst->length = i;

  return ret;
}

struct sexp *parseatom(char **ps, char *es) {
     800:	55                   	push   %ebp
     801:	89 e5                	mov    %esp,%ebp
     803:	57                   	push   %edi
     804:	56                   	push   %esi
     805:	53                   	push   %ebx
     806:	83 ec 0c             	sub    $0xc,%esp
     809:	8b 7d 08             	mov    0x8(%ebp),%edi
     80c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct atom *atm;
  struct sexp *ret;

  char *s = *ps;
     80f:	8b 37                	mov    (%edi),%esi
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     811:	39 de                	cmp    %ebx,%esi
     813:	89 f0                	mov    %esi,%eax
     815:	72 2e                	jb     845 <parseatom+0x45>
     817:	eb 44                	jmp    85d <parseatom+0x5d>
     819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
         !strchr(esymbols, *(*ps))) // peek whitespace
     820:	8b 07                	mov    (%edi),%eax
     822:	83 ec 08             	sub    $0x8,%esp
     825:	0f be 00             	movsbl (%eax),%eax
     828:	50                   	push   %eax
     829:	68 5c 17 00 00       	push   $0x175c
     82e:	e8 4d 03 00 00       	call   b80 <strchr>
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     833:	83 c4 10             	add    $0x10,%esp
     836:	85 c0                	test   %eax,%eax
     838:	75 23                	jne    85d <parseatom+0x5d>
    (*ps)++;
     83a:	8b 07                	mov    (%edi),%eax
     83c:	83 c0 01             	add    $0x1,%eax
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     83f:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
     841:	89 07                	mov    %eax,(%edi)
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     843:	73 18                	jae    85d <parseatom+0x5d>
     845:	0f be 00             	movsbl (%eax),%eax
     848:	83 ec 08             	sub    $0x8,%esp
     84b:	50                   	push   %eax
     84c:	68 60 17 00 00       	push   $0x1760
     851:	e8 2a 03 00 00       	call   b80 <strchr>
     856:	83 c4 10             	add    $0x10,%esp
     859:	85 c0                	test   %eax,%eax
     85b:	74 c3                	je     820 <parseatom+0x20>

  ret = atom();
     85d:	e8 ce fe ff ff       	call   730 <atom>
  atm = (struct atom *)ret;

  atm->type = ATOM;
     862:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  atm->symbol = s;
     868:	89 70 04             	mov    %esi,0x4(%eax)
  atm->esymbol = *ps;
     86b:	8b 17                	mov    (%edi),%edx
     86d:	89 50 08             	mov    %edx,0x8(%eax)

  return ret;
}
     870:	8d 65 f4             	lea    -0xc(%ebp),%esp
     873:	5b                   	pop    %ebx
     874:	5e                   	pop    %esi
     875:	5f                   	pop    %edi
     876:	5d                   	pop    %ebp
     877:	c3                   	ret    
     878:	90                   	nop
     879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000880 <parsesexp>:

struct sexp *parsesexp(char **ps, char *es) {
     880:	55                   	push   %ebp
     881:	89 e5                	mov    %esp,%ebp
     883:	56                   	push   %esi
     884:	53                   	push   %ebx
     885:	8b 75 08             	mov    0x8(%ebp),%esi
     888:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct sexp *ret = 0;

  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     88b:	8b 06                	mov    (%esi),%eax
     88d:	39 c3                	cmp    %eax,%ebx
     88f:	77 10                	ja     8a1 <parsesexp+0x21>
     891:	eb 28                	jmp    8bb <parsesexp+0x3b>
     893:	90                   	nop
     894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    (*ps)++;
     898:	83 c0 01             	add    $0x1,%eax
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     89b:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
     89d:	89 06                	mov    %eax,(%esi)
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     89f:	73 1a                	jae    8bb <parsesexp+0x3b>
     8a1:	0f be 00             	movsbl (%eax),%eax
     8a4:	83 ec 08             	sub    $0x8,%esp
     8a7:	50                   	push   %eax
     8a8:	68 60 17 00 00       	push   $0x1760
     8ad:	e8 ce 02 00 00       	call   b80 <strchr>
     8b2:	83 c4 10             	add    $0x10,%esp
     8b5:	85 c0                	test   %eax,%eax
    (*ps)++;
     8b7:	8b 06                	mov    (%esi),%eax
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     8b9:	75 dd                	jne    898 <parsesexp+0x18>
  switch (*(*ps)) {
     8bb:	0f b6 10             	movzbl (%eax),%edx
     8be:	80 fa 27             	cmp    $0x27,%dl
     8c1:	74 55                	je     918 <parsesexp+0x98>
     8c3:	80 fa 28             	cmp    $0x28,%dl
     8c6:	74 28                	je     8f0 <parsesexp+0x70>
     8c8:	84 d2                	test   %dl,%dl
     8ca:	74 14                	je     8e0 <parsesexp+0x60>
    (*ps) += 2;
    ret = parselist(ps, es);
    (*ps)++;
    break;
  default:
    ret = parseatom(ps, es);
     8cc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
     8cf:	89 75 08             	mov    %esi,0x8(%ebp)
    break;
  }
  return ret;
}
     8d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
     8d5:	5b                   	pop    %ebx
     8d6:	5e                   	pop    %esi
     8d7:	5d                   	pop    %ebp
    ret = parseatom(ps, es);
     8d8:	e9 23 ff ff ff       	jmp    800 <parseatom>
     8dd:	8d 76 00             	lea    0x0(%esi),%esi
}
     8e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  struct sexp *ret = 0;
     8e3:	31 c0                	xor    %eax,%eax
}
     8e5:	5b                   	pop    %ebx
     8e6:	5e                   	pop    %esi
     8e7:	5d                   	pop    %ebp
     8e8:	c3                   	ret    
     8e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret = parselist(ps, es);
     8f0:	83 ec 08             	sub    $0x8,%esp
    (*ps)++;
     8f3:	83 c0 01             	add    $0x1,%eax
     8f6:	89 06                	mov    %eax,(%esi)
    ret = parselist(ps, es);
     8f8:	53                   	push   %ebx
     8f9:	56                   	push   %esi
     8fa:	e8 41 00 00 00       	call   940 <parselist>
    ret->type = APPLY;
     8ff:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    break;
     905:	83 c4 10             	add    $0x10,%esp
    (*ps)++;
     908:	83 06 01             	addl   $0x1,(%esi)
}
     90b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     90e:	5b                   	pop    %ebx
     90f:	5e                   	pop    %esi
     910:	5d                   	pop    %ebp
     911:	c3                   	ret    
     912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ret = parselist(ps, es);
     918:	83 ec 08             	sub    $0x8,%esp
    (*ps) += 2;
     91b:	83 c0 02             	add    $0x2,%eax
     91e:	89 06                	mov    %eax,(%esi)
    ret = parselist(ps, es);
     920:	53                   	push   %ebx
     921:	56                   	push   %esi
     922:	e8 19 00 00 00       	call   940 <parselist>
    (*ps)++;
     927:	83 06 01             	addl   $0x1,(%esi)
    break;
     92a:	83 c4 10             	add    $0x10,%esp
}
     92d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     930:	5b                   	pop    %ebx
     931:	5e                   	pop    %esi
     932:	5d                   	pop    %ebp
     933:	c3                   	ret    
     934:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     93a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000940 <parselist>:
struct sexp *parselist(char **ps, char *es) {
     940:	55                   	push   %ebp
     941:	89 e5                	mov    %esp,%ebp
     943:	57                   	push   %edi
     944:	56                   	push   %esi
     945:	53                   	push   %ebx
     946:	83 ec 1c             	sub    $0x1c,%esp
     949:	8b 75 08             	mov    0x8(%ebp),%esi
     94c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  ret = list();
     94f:	e8 0c fe ff ff       	call   760 <list>
  lst->type = LIST;
     954:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  ret = list();
     95a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *res = *ps;
     95d:	8b 0e                	mov    (%esi),%ecx
  while (res < es) {
     95f:	39 f9                	cmp    %edi,%ecx
     961:	89 cb                	mov    %ecx,%ebx
     963:	73 3b                	jae    9a0 <parselist+0x60>
  int i = 1;
     965:	ba 01 00 00 00       	mov    $0x1,%edx
     96a:	eb 14                	jmp    980 <parselist+0x40>
     96c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (*res == ')') {
     970:	3c 29                	cmp    $0x29,%al
     972:	75 05                	jne    979 <parselist+0x39>
      if (i == 0) {
     974:	83 ea 01             	sub    $0x1,%edx
     977:	74 27                	je     9a0 <parselist+0x60>
    res++;
     979:	83 c3 01             	add    $0x1,%ebx
  while (res < es) {
     97c:	39 df                	cmp    %ebx,%edi
     97e:	74 11                	je     991 <parselist+0x51>
    if (*res == '(')
     980:	0f b6 03             	movzbl (%ebx),%eax
     983:	3c 28                	cmp    $0x28,%al
     985:	75 e9                	jne    970 <parselist+0x30>
    res++;
     987:	83 c3 01             	add    $0x1,%ebx
      i++;
     98a:	83 c2 01             	add    $0x1,%edx
  while (res < es) {
     98d:	39 df                	cmp    %ebx,%edi
     98f:	75 ef                	jne    980 <parselist+0x40>
    panic("syntax error");
     991:	83 ec 0c             	sub    $0xc,%esp
     994:	68 dd 11 00 00       	push   $0x11dd
     999:	e8 d2 f9 ff ff       	call   370 <panic>
     99e:	66 90                	xchg   %ax,%ax
  if (res == es)
     9a0:	39 df                	cmp    %ebx,%edi
     9a2:	74 ed                	je     991 <parselist+0x51>
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     9a4:	31 ff                	xor    %edi,%edi
     9a6:	eb 0a                	jmp    9b2 <parselist+0x72>
     9a8:	90                   	nop
     9a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9b0:	8b 0e                	mov    (%esi),%ecx
     9b2:	39 d9                	cmp    %ebx,%ecx
     9b4:	73 1c                	jae    9d2 <parselist+0x92>
    lst->sexps[i] = parsesexp(ps, res);
     9b6:	83 ec 08             	sub    $0x8,%esp
     9b9:	53                   	push   %ebx
     9ba:	56                   	push   %esi
     9bb:	e8 c0 fe ff ff       	call   880 <parsesexp>
     9c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     9c3:	83 c4 10             	add    $0x10,%esp
    lst->sexps[i] = parsesexp(ps, res);
     9c6:	89 44 ba 08          	mov    %eax,0x8(%edx,%edi,4)
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     9ca:	83 c7 01             	add    $0x1,%edi
     9cd:	83 ff 0a             	cmp    $0xa,%edi
     9d0:	75 de                	jne    9b0 <parselist+0x70>
  lst->length = i;
     9d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     9d5:	89 78 04             	mov    %edi,0x4(%eax)
}
     9d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9db:	5b                   	pop    %ebx
     9dc:	5e                   	pop    %esi
     9dd:	5f                   	pop    %edi
     9de:	5d                   	pop    %ebp
     9df:	c3                   	ret    

000009e0 <snulterminate>:
  }
  snulterminate(exp);
  return exp;
}

struct sexp *snulterminate(struct sexp *exp) {
     9e0:	55                   	push   %ebp
     9e1:	89 e5                	mov    %esp,%ebp
     9e3:	56                   	push   %esi
     9e4:	53                   	push   %ebx
     9e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;
  struct list *lst;
  struct atom *atm;

  if (exp == 0)
     9e8:	85 db                	test   %ebx,%ebx
     9ea:	74 2e                	je     a1a <snulterminate+0x3a>
    return 0;

  switch (exp->type) {
     9ec:	8b 03                	mov    (%ebx),%eax
     9ee:	83 f8 01             	cmp    $0x1,%eax
     9f1:	74 35                	je     a28 <snulterminate+0x48>
     9f3:	7c 25                	jl     a1a <snulterminate+0x3a>
     9f5:	83 f8 03             	cmp    $0x3,%eax
     9f8:	7f 20                	jg     a1a <snulterminate+0x3a>
    break;

  case APPLY:
  case LIST:
    lst = (struct list *)exp;
    for (i = 0; i < lst->length; i++)
     9fa:	8b 43 04             	mov    0x4(%ebx),%eax
     9fd:	31 f6                	xor    %esi,%esi
     9ff:	85 c0                	test   %eax,%eax
     a01:	7e 17                	jle    a1a <snulterminate+0x3a>
      snulterminate(lst->sexps[i]);
     a03:	83 ec 0c             	sub    $0xc,%esp
     a06:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
    for (i = 0; i < lst->length; i++)
     a0a:	83 c6 01             	add    $0x1,%esi
      snulterminate(lst->sexps[i]);
     a0d:	e8 ce ff ff ff       	call   9e0 <snulterminate>
    for (i = 0; i < lst->length; i++)
     a12:	83 c4 10             	add    $0x10,%esp
     a15:	3b 73 04             	cmp    0x4(%ebx),%esi
     a18:	7c e9                	jl     a03 <snulterminate+0x23>
    break;
  }
  return exp;
}
     a1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     a1d:	89 d8                	mov    %ebx,%eax
     a1f:	5b                   	pop    %ebx
     a20:	5e                   	pop    %esi
     a21:	5d                   	pop    %ebp
     a22:	c3                   	ret    
     a23:	90                   	nop
     a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *atm->esymbol = 0;
     a28:	8b 43 08             	mov    0x8(%ebx),%eax
     a2b:	c6 00 00             	movb   $0x0,(%eax)
}
     a2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
     a31:	89 d8                	mov    %ebx,%eax
     a33:	5b                   	pop    %ebx
     a34:	5e                   	pop    %esi
     a35:	5d                   	pop    %ebp
     a36:	c3                   	ret    
     a37:	89 f6                	mov    %esi,%esi
     a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a40 <parseexp>:
struct sexp *parseexp(char *s) {
     a40:	55                   	push   %ebp
     a41:	89 e5                	mov    %esp,%ebp
     a43:	56                   	push   %esi
     a44:	53                   	push   %ebx
  es = s + strlen(s);
     a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a48:	83 ec 0c             	sub    $0xc,%esp
     a4b:	53                   	push   %ebx
     a4c:	e8 df 00 00 00       	call   b30 <strlen>
  exp = parsesexp(&s, es);
     a51:	59                   	pop    %ecx
  es = s + strlen(s);
     a52:	01 c3                	add    %eax,%ebx
  exp = parsesexp(&s, es);
     a54:	8d 45 08             	lea    0x8(%ebp),%eax
     a57:	5e                   	pop    %esi
     a58:	53                   	push   %ebx
     a59:	50                   	push   %eax
     a5a:	e8 21 fe ff ff       	call   880 <parsesexp>
     a5f:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     a61:	8d 45 08             	lea    0x8(%ebp),%eax
     a64:	83 c4 0c             	add    $0xc,%esp
     a67:	68 03 12 00 00       	push   $0x1203
     a6c:	53                   	push   %ebx
     a6d:	50                   	push   %eax
     a6e:	e8 1d fd ff ff       	call   790 <peek>
  if (s != es) {
     a73:	8b 45 08             	mov    0x8(%ebp),%eax
     a76:	83 c4 10             	add    $0x10,%esp
     a79:	39 d8                	cmp    %ebx,%eax
     a7b:	75 12                	jne    a8f <parseexp+0x4f>
  snulterminate(exp);
     a7d:	83 ec 0c             	sub    $0xc,%esp
     a80:	56                   	push   %esi
     a81:	e8 5a ff ff ff       	call   9e0 <snulterminate>
}
     a86:	8d 65 f8             	lea    -0x8(%ebp),%esp
     a89:	89 f0                	mov    %esi,%eax
     a8b:	5b                   	pop    %ebx
     a8c:	5e                   	pop    %esi
     a8d:	5d                   	pop    %ebp
     a8e:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     a8f:	52                   	push   %edx
     a90:	50                   	push   %eax
     a91:	68 f5 11 00 00       	push   $0x11f5
     a96:	6a 02                	push   $0x2
     a98:	e8 d3 03 00 00       	call   e70 <printf>
    panic("syntax error");
     a9d:	c7 04 24 dd 11 00 00 	movl   $0x11dd,(%esp)
     aa4:	e8 c7 f8 ff ff       	call   370 <panic>
     aa9:	66 90                	xchg   %ax,%ax
     aab:	66 90                	xchg   %ax,%ax
     aad:	66 90                	xchg   %ax,%ax
     aaf:	90                   	nop

00000ab0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     ab0:	55                   	push   %ebp
     ab1:	89 e5                	mov    %esp,%ebp
     ab3:	53                   	push   %ebx
     ab4:	8b 45 08             	mov    0x8(%ebp),%eax
     ab7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     aba:	89 c2                	mov    %eax,%edx
     abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ac0:	83 c1 01             	add    $0x1,%ecx
     ac3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     ac7:	83 c2 01             	add    $0x1,%edx
     aca:	84 db                	test   %bl,%bl
     acc:	88 5a ff             	mov    %bl,-0x1(%edx)
     acf:	75 ef                	jne    ac0 <strcpy+0x10>
    ;
  return os;
}
     ad1:	5b                   	pop    %ebx
     ad2:	5d                   	pop    %ebp
     ad3:	c3                   	ret    
     ad4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     ada:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000ae0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ae0:	55                   	push   %ebp
     ae1:	89 e5                	mov    %esp,%ebp
     ae3:	53                   	push   %ebx
     ae4:	8b 55 08             	mov    0x8(%ebp),%edx
     ae7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     aea:	0f b6 02             	movzbl (%edx),%eax
     aed:	0f b6 19             	movzbl (%ecx),%ebx
     af0:	84 c0                	test   %al,%al
     af2:	75 1c                	jne    b10 <strcmp+0x30>
     af4:	eb 2a                	jmp    b20 <strcmp+0x40>
     af6:	8d 76 00             	lea    0x0(%esi),%esi
     af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
     b00:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     b03:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
     b06:	83 c1 01             	add    $0x1,%ecx
     b09:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
     b0c:	84 c0                	test   %al,%al
     b0e:	74 10                	je     b20 <strcmp+0x40>
     b10:	38 d8                	cmp    %bl,%al
     b12:	74 ec                	je     b00 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     b14:	29 d8                	sub    %ebx,%eax
}
     b16:	5b                   	pop    %ebx
     b17:	5d                   	pop    %ebp
     b18:	c3                   	ret    
     b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b20:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     b22:	29 d8                	sub    %ebx,%eax
}
     b24:	5b                   	pop    %ebx
     b25:	5d                   	pop    %ebp
     b26:	c3                   	ret    
     b27:	89 f6                	mov    %esi,%esi
     b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b30 <strlen>:

uint
strlen(char *s)
{
     b30:	55                   	push   %ebp
     b31:	89 e5                	mov    %esp,%ebp
     b33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     b36:	80 39 00             	cmpb   $0x0,(%ecx)
     b39:	74 15                	je     b50 <strlen+0x20>
     b3b:	31 d2                	xor    %edx,%edx
     b3d:	8d 76 00             	lea    0x0(%esi),%esi
     b40:	83 c2 01             	add    $0x1,%edx
     b43:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     b47:	89 d0                	mov    %edx,%eax
     b49:	75 f5                	jne    b40 <strlen+0x10>
    ;
  return n;
}
     b4b:	5d                   	pop    %ebp
     b4c:	c3                   	ret    
     b4d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
     b50:	31 c0                	xor    %eax,%eax
}
     b52:	5d                   	pop    %ebp
     b53:	c3                   	ret    
     b54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     b5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000b60 <memset>:

void*
memset(void *dst, int c, uint n)
{
     b60:	55                   	push   %ebp
     b61:	89 e5                	mov    %esp,%ebp
     b63:	57                   	push   %edi
     b64:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     b67:	8b 4d 10             	mov    0x10(%ebp),%ecx
     b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
     b6d:	89 d7                	mov    %edx,%edi
     b6f:	fc                   	cld    
     b70:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     b72:	89 d0                	mov    %edx,%eax
     b74:	5f                   	pop    %edi
     b75:	5d                   	pop    %ebp
     b76:	c3                   	ret    
     b77:	89 f6                	mov    %esi,%esi
     b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b80 <strchr>:

char*
strchr(const char *s, char c)
{
     b80:	55                   	push   %ebp
     b81:	89 e5                	mov    %esp,%ebp
     b83:	53                   	push   %ebx
     b84:	8b 45 08             	mov    0x8(%ebp),%eax
     b87:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
     b8a:	0f b6 10             	movzbl (%eax),%edx
     b8d:	84 d2                	test   %dl,%dl
     b8f:	74 1d                	je     bae <strchr+0x2e>
    if(*s == c)
     b91:	38 d3                	cmp    %dl,%bl
     b93:	89 d9                	mov    %ebx,%ecx
     b95:	75 0d                	jne    ba4 <strchr+0x24>
     b97:	eb 17                	jmp    bb0 <strchr+0x30>
     b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ba0:	38 ca                	cmp    %cl,%dl
     ba2:	74 0c                	je     bb0 <strchr+0x30>
  for(; *s; s++)
     ba4:	83 c0 01             	add    $0x1,%eax
     ba7:	0f b6 10             	movzbl (%eax),%edx
     baa:	84 d2                	test   %dl,%dl
     bac:	75 f2                	jne    ba0 <strchr+0x20>
      return (char*)s;
  return 0;
     bae:	31 c0                	xor    %eax,%eax
}
     bb0:	5b                   	pop    %ebx
     bb1:	5d                   	pop    %ebp
     bb2:	c3                   	ret    
     bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000bc0 <gets>:

char*
gets(char *buf, int max)
{
     bc0:	55                   	push   %ebp
     bc1:	89 e5                	mov    %esp,%ebp
     bc3:	57                   	push   %edi
     bc4:	56                   	push   %esi
     bc5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     bc6:	31 f6                	xor    %esi,%esi
     bc8:	89 f3                	mov    %esi,%ebx
{
     bca:	83 ec 1c             	sub    $0x1c,%esp
     bcd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     bd0:	eb 2f                	jmp    c01 <gets+0x41>
     bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     bd8:	8d 45 e7             	lea    -0x19(%ebp),%eax
     bdb:	83 ec 04             	sub    $0x4,%esp
     bde:	6a 01                	push   $0x1
     be0:	50                   	push   %eax
     be1:	6a 00                	push   $0x0
     be3:	e8 32 01 00 00       	call   d1a <read>
    if(cc < 1)
     be8:	83 c4 10             	add    $0x10,%esp
     beb:	85 c0                	test   %eax,%eax
     bed:	7e 1c                	jle    c0b <gets+0x4b>
      break;
    buf[i++] = c;
     bef:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     bf3:	83 c7 01             	add    $0x1,%edi
     bf6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     bf9:	3c 0a                	cmp    $0xa,%al
     bfb:	74 23                	je     c20 <gets+0x60>
     bfd:	3c 0d                	cmp    $0xd,%al
     bff:	74 1f                	je     c20 <gets+0x60>
  for(i=0; i+1 < max; ){
     c01:	83 c3 01             	add    $0x1,%ebx
     c04:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     c07:	89 fe                	mov    %edi,%esi
     c09:	7c cd                	jl     bd8 <gets+0x18>
     c0b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     c10:	c6 03 00             	movb   $0x0,(%ebx)
}
     c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c16:	5b                   	pop    %ebx
     c17:	5e                   	pop    %esi
     c18:	5f                   	pop    %edi
     c19:	5d                   	pop    %ebp
     c1a:	c3                   	ret    
     c1b:	90                   	nop
     c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c20:	8b 75 08             	mov    0x8(%ebp),%esi
     c23:	8b 45 08             	mov    0x8(%ebp),%eax
     c26:	01 de                	add    %ebx,%esi
     c28:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     c2a:	c6 03 00             	movb   $0x0,(%ebx)
}
     c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c30:	5b                   	pop    %ebx
     c31:	5e                   	pop    %esi
     c32:	5f                   	pop    %edi
     c33:	5d                   	pop    %ebp
     c34:	c3                   	ret    
     c35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c40 <stat>:

int
stat(char *n, struct stat *st)
{
     c40:	55                   	push   %ebp
     c41:	89 e5                	mov    %esp,%ebp
     c43:	56                   	push   %esi
     c44:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c45:	83 ec 08             	sub    $0x8,%esp
     c48:	6a 00                	push   $0x0
     c4a:	ff 75 08             	pushl  0x8(%ebp)
     c4d:	e8 f0 00 00 00       	call   d42 <open>
  if(fd < 0)
     c52:	83 c4 10             	add    $0x10,%esp
     c55:	85 c0                	test   %eax,%eax
     c57:	78 27                	js     c80 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     c59:	83 ec 08             	sub    $0x8,%esp
     c5c:	ff 75 0c             	pushl  0xc(%ebp)
     c5f:	89 c3                	mov    %eax,%ebx
     c61:	50                   	push   %eax
     c62:	e8 f3 00 00 00       	call   d5a <fstat>
  close(fd);
     c67:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     c6a:	89 c6                	mov    %eax,%esi
  close(fd);
     c6c:	e8 b9 00 00 00       	call   d2a <close>
  return r;
     c71:	83 c4 10             	add    $0x10,%esp
}
     c74:	8d 65 f8             	lea    -0x8(%ebp),%esp
     c77:	89 f0                	mov    %esi,%eax
     c79:	5b                   	pop    %ebx
     c7a:	5e                   	pop    %esi
     c7b:	5d                   	pop    %ebp
     c7c:	c3                   	ret    
     c7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     c80:	be ff ff ff ff       	mov    $0xffffffff,%esi
     c85:	eb ed                	jmp    c74 <stat+0x34>
     c87:	89 f6                	mov    %esi,%esi
     c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c90 <atoi>:

int
atoi(const char *s)
{
     c90:	55                   	push   %ebp
     c91:	89 e5                	mov    %esp,%ebp
     c93:	53                   	push   %ebx
     c94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     c97:	0f be 11             	movsbl (%ecx),%edx
     c9a:	8d 42 d0             	lea    -0x30(%edx),%eax
     c9d:	3c 09                	cmp    $0x9,%al
  n = 0;
     c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
     ca4:	77 1f                	ja     cc5 <atoi+0x35>
     ca6:	8d 76 00             	lea    0x0(%esi),%esi
     ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
     cb0:	8d 04 80             	lea    (%eax,%eax,4),%eax
     cb3:	83 c1 01             	add    $0x1,%ecx
     cb6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
     cba:	0f be 11             	movsbl (%ecx),%edx
     cbd:	8d 5a d0             	lea    -0x30(%edx),%ebx
     cc0:	80 fb 09             	cmp    $0x9,%bl
     cc3:	76 eb                	jbe    cb0 <atoi+0x20>
  return n;
}
     cc5:	5b                   	pop    %ebx
     cc6:	5d                   	pop    %ebp
     cc7:	c3                   	ret    
     cc8:	90                   	nop
     cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000cd0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     cd0:	55                   	push   %ebp
     cd1:	89 e5                	mov    %esp,%ebp
     cd3:	56                   	push   %esi
     cd4:	53                   	push   %ebx
     cd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
     cd8:	8b 45 08             	mov    0x8(%ebp),%eax
     cdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     cde:	85 db                	test   %ebx,%ebx
     ce0:	7e 14                	jle    cf6 <memmove+0x26>
     ce2:	31 d2                	xor    %edx,%edx
     ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
     ce8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     cec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     cef:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
     cf2:	39 d3                	cmp    %edx,%ebx
     cf4:	75 f2                	jne    ce8 <memmove+0x18>
  return vdst;
}
     cf6:	5b                   	pop    %ebx
     cf7:	5e                   	pop    %esi
     cf8:	5d                   	pop    %ebp
     cf9:	c3                   	ret    

00000cfa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     cfa:	b8 01 00 00 00       	mov    $0x1,%eax
     cff:	cd 40                	int    $0x40
     d01:	c3                   	ret    

00000d02 <exit>:
SYSCALL(exit)
     d02:	b8 02 00 00 00       	mov    $0x2,%eax
     d07:	cd 40                	int    $0x40
     d09:	c3                   	ret    

00000d0a <wait>:
SYSCALL(wait)
     d0a:	b8 03 00 00 00       	mov    $0x3,%eax
     d0f:	cd 40                	int    $0x40
     d11:	c3                   	ret    

00000d12 <pipe>:
SYSCALL(pipe)
     d12:	b8 04 00 00 00       	mov    $0x4,%eax
     d17:	cd 40                	int    $0x40
     d19:	c3                   	ret    

00000d1a <read>:
SYSCALL(read)
     d1a:	b8 05 00 00 00       	mov    $0x5,%eax
     d1f:	cd 40                	int    $0x40
     d21:	c3                   	ret    

00000d22 <write>:
SYSCALL(write)
     d22:	b8 10 00 00 00       	mov    $0x10,%eax
     d27:	cd 40                	int    $0x40
     d29:	c3                   	ret    

00000d2a <close>:
SYSCALL(close)
     d2a:	b8 15 00 00 00       	mov    $0x15,%eax
     d2f:	cd 40                	int    $0x40
     d31:	c3                   	ret    

00000d32 <kill>:
SYSCALL(kill)
     d32:	b8 06 00 00 00       	mov    $0x6,%eax
     d37:	cd 40                	int    $0x40
     d39:	c3                   	ret    

00000d3a <exec>:
SYSCALL(exec)
     d3a:	b8 07 00 00 00       	mov    $0x7,%eax
     d3f:	cd 40                	int    $0x40
     d41:	c3                   	ret    

00000d42 <open>:
SYSCALL(open)
     d42:	b8 0f 00 00 00       	mov    $0xf,%eax
     d47:	cd 40                	int    $0x40
     d49:	c3                   	ret    

00000d4a <mknod>:
SYSCALL(mknod)
     d4a:	b8 11 00 00 00       	mov    $0x11,%eax
     d4f:	cd 40                	int    $0x40
     d51:	c3                   	ret    

00000d52 <unlink>:
SYSCALL(unlink)
     d52:	b8 12 00 00 00       	mov    $0x12,%eax
     d57:	cd 40                	int    $0x40
     d59:	c3                   	ret    

00000d5a <fstat>:
SYSCALL(fstat)
     d5a:	b8 08 00 00 00       	mov    $0x8,%eax
     d5f:	cd 40                	int    $0x40
     d61:	c3                   	ret    

00000d62 <link>:
SYSCALL(link)
     d62:	b8 13 00 00 00       	mov    $0x13,%eax
     d67:	cd 40                	int    $0x40
     d69:	c3                   	ret    

00000d6a <mkdir>:
SYSCALL(mkdir)
     d6a:	b8 14 00 00 00       	mov    $0x14,%eax
     d6f:	cd 40                	int    $0x40
     d71:	c3                   	ret    

00000d72 <chdir>:
SYSCALL(chdir)
     d72:	b8 09 00 00 00       	mov    $0x9,%eax
     d77:	cd 40                	int    $0x40
     d79:	c3                   	ret    

00000d7a <dup>:
SYSCALL(dup)
     d7a:	b8 0a 00 00 00       	mov    $0xa,%eax
     d7f:	cd 40                	int    $0x40
     d81:	c3                   	ret    

00000d82 <getpid>:
SYSCALL(getpid)
     d82:	b8 0b 00 00 00       	mov    $0xb,%eax
     d87:	cd 40                	int    $0x40
     d89:	c3                   	ret    

00000d8a <sbrk>:
SYSCALL(sbrk)
     d8a:	b8 0c 00 00 00       	mov    $0xc,%eax
     d8f:	cd 40                	int    $0x40
     d91:	c3                   	ret    

00000d92 <sleep>:
SYSCALL(sleep)
     d92:	b8 0d 00 00 00       	mov    $0xd,%eax
     d97:	cd 40                	int    $0x40
     d99:	c3                   	ret    

00000d9a <uptime>:
SYSCALL(uptime)
     d9a:	b8 0e 00 00 00       	mov    $0xe,%eax
     d9f:	cd 40                	int    $0x40
     da1:	c3                   	ret    

00000da2 <trace>:
SYSCALL(trace)
     da2:	b8 16 00 00 00       	mov    $0x16,%eax
     da7:	cd 40                	int    $0x40
     da9:	c3                   	ret    

00000daa <getsharem>:
SYSCALL(getsharem)
     daa:	b8 17 00 00 00       	mov    $0x17,%eax
     daf:	cd 40                	int    $0x40
     db1:	c3                   	ret    

00000db2 <releasesharem>:
SYSCALL(releasesharem)
     db2:	b8 18 00 00 00       	mov    $0x18,%eax
     db7:	cd 40                	int    $0x40
     db9:	c3                   	ret    

00000dba <split>:
SYSCALL(split)
     dba:	b8 19 00 00 00       	mov    $0x19,%eax
     dbf:	cd 40                	int    $0x40
     dc1:	c3                   	ret    

00000dc2 <memo>:
SYSCALL(memo)
     dc2:	b8 1a 00 00 00       	mov    $0x1a,%eax
     dc7:	cd 40                	int    $0x40
     dc9:	c3                   	ret    
     dca:	66 90                	xchg   %ax,%ax
     dcc:	66 90                	xchg   %ax,%ax
     dce:	66 90                	xchg   %ax,%ax

00000dd0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     dd0:	55                   	push   %ebp
     dd1:	89 e5                	mov    %esp,%ebp
     dd3:	57                   	push   %edi
     dd4:	56                   	push   %esi
     dd5:	53                   	push   %ebx
     dd6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     dd9:	85 d2                	test   %edx,%edx
{
     ddb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
     dde:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
     de0:	79 76                	jns    e58 <printint+0x88>
     de2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     de6:	74 70                	je     e58 <printint+0x88>
    x = -xx;
     de8:	f7 d8                	neg    %eax
    neg = 1;
     dea:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     df1:	31 f6                	xor    %esi,%esi
     df3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
     df6:	eb 0a                	jmp    e02 <printint+0x32>
     df8:	90                   	nop
     df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
     e00:	89 fe                	mov    %edi,%esi
     e02:	31 d2                	xor    %edx,%edx
     e04:	8d 7e 01             	lea    0x1(%esi),%edi
     e07:	f7 f1                	div    %ecx
     e09:	0f b6 92 24 12 00 00 	movzbl 0x1224(%edx),%edx
  }while((x /= base) != 0);
     e10:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
     e12:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
     e15:	75 e9                	jne    e00 <printint+0x30>
  if(neg)
     e17:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     e1a:	85 c0                	test   %eax,%eax
     e1c:	74 08                	je     e26 <printint+0x56>
    buf[i++] = '-';
     e1e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
     e23:	8d 7e 02             	lea    0x2(%esi),%edi
     e26:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
     e2a:	8b 7d c0             	mov    -0x40(%ebp),%edi
     e2d:	8d 76 00             	lea    0x0(%esi),%esi
     e30:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
     e33:	83 ec 04             	sub    $0x4,%esp
     e36:	83 ee 01             	sub    $0x1,%esi
     e39:	6a 01                	push   $0x1
     e3b:	53                   	push   %ebx
     e3c:	57                   	push   %edi
     e3d:	88 45 d7             	mov    %al,-0x29(%ebp)
     e40:	e8 dd fe ff ff       	call   d22 <write>

  while(--i >= 0)
     e45:	83 c4 10             	add    $0x10,%esp
     e48:	39 de                	cmp    %ebx,%esi
     e4a:	75 e4                	jne    e30 <printint+0x60>
    putc(fd, buf[i]);
}
     e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e4f:	5b                   	pop    %ebx
     e50:	5e                   	pop    %esi
     e51:	5f                   	pop    %edi
     e52:	5d                   	pop    %ebp
     e53:	c3                   	ret    
     e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     e58:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     e5f:	eb 90                	jmp    df1 <printint+0x21>
     e61:	eb 0d                	jmp    e70 <printf>
     e63:	90                   	nop
     e64:	90                   	nop
     e65:	90                   	nop
     e66:	90                   	nop
     e67:	90                   	nop
     e68:	90                   	nop
     e69:	90                   	nop
     e6a:	90                   	nop
     e6b:	90                   	nop
     e6c:	90                   	nop
     e6d:	90                   	nop
     e6e:	90                   	nop
     e6f:	90                   	nop

00000e70 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     e70:	55                   	push   %ebp
     e71:	89 e5                	mov    %esp,%ebp
     e73:	57                   	push   %edi
     e74:	56                   	push   %esi
     e75:	53                   	push   %ebx
     e76:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     e79:	8b 75 0c             	mov    0xc(%ebp),%esi
     e7c:	0f b6 1e             	movzbl (%esi),%ebx
     e7f:	84 db                	test   %bl,%bl
     e81:	0f 84 b3 00 00 00    	je     f3a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
     e87:	8d 45 10             	lea    0x10(%ebp),%eax
     e8a:	83 c6 01             	add    $0x1,%esi
  state = 0;
     e8d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
     e8f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     e92:	eb 2f                	jmp    ec3 <printf+0x53>
     e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     e98:	83 f8 25             	cmp    $0x25,%eax
     e9b:	0f 84 a7 00 00 00    	je     f48 <printf+0xd8>
  write(fd, &c, 1);
     ea1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
     ea4:	83 ec 04             	sub    $0x4,%esp
     ea7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
     eaa:	6a 01                	push   $0x1
     eac:	50                   	push   %eax
     ead:	ff 75 08             	pushl  0x8(%ebp)
     eb0:	e8 6d fe ff ff       	call   d22 <write>
     eb5:	83 c4 10             	add    $0x10,%esp
     eb8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
     ebb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
     ebf:	84 db                	test   %bl,%bl
     ec1:	74 77                	je     f3a <printf+0xca>
    if(state == 0){
     ec3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
     ec5:	0f be cb             	movsbl %bl,%ecx
     ec8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     ecb:	74 cb                	je     e98 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ecd:	83 ff 25             	cmp    $0x25,%edi
     ed0:	75 e6                	jne    eb8 <printf+0x48>
      if(c == 'd'){
     ed2:	83 f8 64             	cmp    $0x64,%eax
     ed5:	0f 84 05 01 00 00    	je     fe0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     edb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     ee1:	83 f9 70             	cmp    $0x70,%ecx
     ee4:	74 72                	je     f58 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     ee6:	83 f8 73             	cmp    $0x73,%eax
     ee9:	0f 84 99 00 00 00    	je     f88 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     eef:	83 f8 63             	cmp    $0x63,%eax
     ef2:	0f 84 08 01 00 00    	je     1000 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     ef8:	83 f8 25             	cmp    $0x25,%eax
     efb:	0f 84 ef 00 00 00    	je     ff0 <printf+0x180>
  write(fd, &c, 1);
     f01:	8d 45 e7             	lea    -0x19(%ebp),%eax
     f04:	83 ec 04             	sub    $0x4,%esp
     f07:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     f0b:	6a 01                	push   $0x1
     f0d:	50                   	push   %eax
     f0e:	ff 75 08             	pushl  0x8(%ebp)
     f11:	e8 0c fe ff ff       	call   d22 <write>
     f16:	83 c4 0c             	add    $0xc,%esp
     f19:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     f1c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
     f1f:	6a 01                	push   $0x1
     f21:	50                   	push   %eax
     f22:	ff 75 08             	pushl  0x8(%ebp)
     f25:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     f28:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
     f2a:	e8 f3 fd ff ff       	call   d22 <write>
  for(i = 0; fmt[i]; i++){
     f2f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
     f33:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     f36:	84 db                	test   %bl,%bl
     f38:	75 89                	jne    ec3 <printf+0x53>
    }
  }
}
     f3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f3d:	5b                   	pop    %ebx
     f3e:	5e                   	pop    %esi
     f3f:	5f                   	pop    %edi
     f40:	5d                   	pop    %ebp
     f41:	c3                   	ret    
     f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
     f48:	bf 25 00 00 00       	mov    $0x25,%edi
     f4d:	e9 66 ff ff ff       	jmp    eb8 <printf+0x48>
     f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
     f58:	83 ec 0c             	sub    $0xc,%esp
     f5b:	b9 10 00 00 00       	mov    $0x10,%ecx
     f60:	6a 00                	push   $0x0
     f62:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     f65:	8b 45 08             	mov    0x8(%ebp),%eax
     f68:	8b 17                	mov    (%edi),%edx
     f6a:	e8 61 fe ff ff       	call   dd0 <printint>
        ap++;
     f6f:	89 f8                	mov    %edi,%eax
     f71:	83 c4 10             	add    $0x10,%esp
      state = 0;
     f74:	31 ff                	xor    %edi,%edi
        ap++;
     f76:	83 c0 04             	add    $0x4,%eax
     f79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     f7c:	e9 37 ff ff ff       	jmp    eb8 <printf+0x48>
     f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
     f88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     f8b:	8b 08                	mov    (%eax),%ecx
        ap++;
     f8d:	83 c0 04             	add    $0x4,%eax
     f90:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
     f93:	85 c9                	test   %ecx,%ecx
     f95:	0f 84 8e 00 00 00    	je     1029 <printf+0x1b9>
        while(*s != 0){
     f9b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
     f9e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
     fa0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
     fa2:	84 c0                	test   %al,%al
     fa4:	0f 84 0e ff ff ff    	je     eb8 <printf+0x48>
     faa:	89 75 d0             	mov    %esi,-0x30(%ebp)
     fad:	89 de                	mov    %ebx,%esi
     faf:	8b 5d 08             	mov    0x8(%ebp),%ebx
     fb2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
     fb5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
     fb8:	83 ec 04             	sub    $0x4,%esp
          s++;
     fbb:	83 c6 01             	add    $0x1,%esi
     fbe:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
     fc1:	6a 01                	push   $0x1
     fc3:	57                   	push   %edi
     fc4:	53                   	push   %ebx
     fc5:	e8 58 fd ff ff       	call   d22 <write>
        while(*s != 0){
     fca:	0f b6 06             	movzbl (%esi),%eax
     fcd:	83 c4 10             	add    $0x10,%esp
     fd0:	84 c0                	test   %al,%al
     fd2:	75 e4                	jne    fb8 <printf+0x148>
     fd4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
     fd7:	31 ff                	xor    %edi,%edi
     fd9:	e9 da fe ff ff       	jmp    eb8 <printf+0x48>
     fde:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
     fe0:	83 ec 0c             	sub    $0xc,%esp
     fe3:	b9 0a 00 00 00       	mov    $0xa,%ecx
     fe8:	6a 01                	push   $0x1
     fea:	e9 73 ff ff ff       	jmp    f62 <printf+0xf2>
     fef:	90                   	nop
  write(fd, &c, 1);
     ff0:	83 ec 04             	sub    $0x4,%esp
     ff3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
     ff6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
     ff9:	6a 01                	push   $0x1
     ffb:	e9 21 ff ff ff       	jmp    f21 <printf+0xb1>
        putc(fd, *ap);
    1000:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    1003:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1006:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    1008:	6a 01                	push   $0x1
        ap++;
    100a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    100d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    1010:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1013:	50                   	push   %eax
    1014:	ff 75 08             	pushl  0x8(%ebp)
    1017:	e8 06 fd ff ff       	call   d22 <write>
        ap++;
    101c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    101f:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1022:	31 ff                	xor    %edi,%edi
    1024:	e9 8f fe ff ff       	jmp    eb8 <printf+0x48>
          s = "(null)";
    1029:	bb 1a 12 00 00       	mov    $0x121a,%ebx
        while(*s != 0){
    102e:	b8 28 00 00 00       	mov    $0x28,%eax
    1033:	e9 72 ff ff ff       	jmp    faa <printf+0x13a>
    1038:	66 90                	xchg   %ax,%ax
    103a:	66 90                	xchg   %ax,%ax
    103c:	66 90                	xchg   %ax,%ax
    103e:	66 90                	xchg   %ax,%ax

00001040 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1040:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1041:	a1 e4 17 00 00       	mov    0x17e4,%eax
{
    1046:	89 e5                	mov    %esp,%ebp
    1048:	57                   	push   %edi
    1049:	56                   	push   %esi
    104a:	53                   	push   %ebx
    104b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    104e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    1051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1058:	39 c8                	cmp    %ecx,%eax
    105a:	8b 10                	mov    (%eax),%edx
    105c:	73 32                	jae    1090 <free+0x50>
    105e:	39 d1                	cmp    %edx,%ecx
    1060:	72 04                	jb     1066 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1062:	39 d0                	cmp    %edx,%eax
    1064:	72 32                	jb     1098 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1066:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1069:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    106c:	39 fa                	cmp    %edi,%edx
    106e:	74 30                	je     10a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1070:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1073:	8b 50 04             	mov    0x4(%eax),%edx
    1076:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1079:	39 f1                	cmp    %esi,%ecx
    107b:	74 3a                	je     10b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    107d:	89 08                	mov    %ecx,(%eax)
  freep = p;
    107f:	a3 e4 17 00 00       	mov    %eax,0x17e4
}
    1084:	5b                   	pop    %ebx
    1085:	5e                   	pop    %esi
    1086:	5f                   	pop    %edi
    1087:	5d                   	pop    %ebp
    1088:	c3                   	ret    
    1089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1090:	39 d0                	cmp    %edx,%eax
    1092:	72 04                	jb     1098 <free+0x58>
    1094:	39 d1                	cmp    %edx,%ecx
    1096:	72 ce                	jb     1066 <free+0x26>
{
    1098:	89 d0                	mov    %edx,%eax
    109a:	eb bc                	jmp    1058 <free+0x18>
    109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    10a0:	03 72 04             	add    0x4(%edx),%esi
    10a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    10a6:	8b 10                	mov    (%eax),%edx
    10a8:	8b 12                	mov    (%edx),%edx
    10aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    10ad:	8b 50 04             	mov    0x4(%eax),%edx
    10b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    10b3:	39 f1                	cmp    %esi,%ecx
    10b5:	75 c6                	jne    107d <free+0x3d>
    p->s.size += bp->s.size;
    10b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    10ba:	a3 e4 17 00 00       	mov    %eax,0x17e4
    p->s.size += bp->s.size;
    10bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    10c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
    10c5:	89 10                	mov    %edx,(%eax)
}
    10c7:	5b                   	pop    %ebx
    10c8:	5e                   	pop    %esi
    10c9:	5f                   	pop    %edi
    10ca:	5d                   	pop    %ebp
    10cb:	c3                   	ret    
    10cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000010d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10d0:	55                   	push   %ebp
    10d1:	89 e5                	mov    %esp,%ebp
    10d3:	57                   	push   %edi
    10d4:	56                   	push   %esi
    10d5:	53                   	push   %ebx
    10d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    10dc:	8b 15 e4 17 00 00    	mov    0x17e4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10e2:	8d 78 07             	lea    0x7(%eax),%edi
    10e5:	c1 ef 03             	shr    $0x3,%edi
    10e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    10eb:	85 d2                	test   %edx,%edx
    10ed:	0f 84 9d 00 00 00    	je     1190 <malloc+0xc0>
    10f3:	8b 02                	mov    (%edx),%eax
    10f5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    10f8:	39 cf                	cmp    %ecx,%edi
    10fa:	76 6c                	jbe    1168 <malloc+0x98>
    10fc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    1102:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1107:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    110a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    1111:	eb 0e                	jmp    1121 <malloc+0x51>
    1113:	90                   	nop
    1114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1118:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    111a:	8b 48 04             	mov    0x4(%eax),%ecx
    111d:	39 f9                	cmp    %edi,%ecx
    111f:	73 47                	jae    1168 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1121:	39 05 e4 17 00 00    	cmp    %eax,0x17e4
    1127:	89 c2                	mov    %eax,%edx
    1129:	75 ed                	jne    1118 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    112b:	83 ec 0c             	sub    $0xc,%esp
    112e:	56                   	push   %esi
    112f:	e8 56 fc ff ff       	call   d8a <sbrk>
  if(p == (char*)-1)
    1134:	83 c4 10             	add    $0x10,%esp
    1137:	83 f8 ff             	cmp    $0xffffffff,%eax
    113a:	74 1c                	je     1158 <malloc+0x88>
  hp->s.size = nu;
    113c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    113f:	83 ec 0c             	sub    $0xc,%esp
    1142:	83 c0 08             	add    $0x8,%eax
    1145:	50                   	push   %eax
    1146:	e8 f5 fe ff ff       	call   1040 <free>
  return freep;
    114b:	8b 15 e4 17 00 00    	mov    0x17e4,%edx
      if((p = morecore(nunits)) == 0)
    1151:	83 c4 10             	add    $0x10,%esp
    1154:	85 d2                	test   %edx,%edx
    1156:	75 c0                	jne    1118 <malloc+0x48>
        return 0;
  }
}
    1158:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    115b:	31 c0                	xor    %eax,%eax
}
    115d:	5b                   	pop    %ebx
    115e:	5e                   	pop    %esi
    115f:	5f                   	pop    %edi
    1160:	5d                   	pop    %ebp
    1161:	c3                   	ret    
    1162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1168:	39 cf                	cmp    %ecx,%edi
    116a:	74 54                	je     11c0 <malloc+0xf0>
        p->s.size -= nunits;
    116c:	29 f9                	sub    %edi,%ecx
    116e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1171:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1174:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    1177:	89 15 e4 17 00 00    	mov    %edx,0x17e4
}
    117d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1180:	83 c0 08             	add    $0x8,%eax
}
    1183:	5b                   	pop    %ebx
    1184:	5e                   	pop    %esi
    1185:	5f                   	pop    %edi
    1186:	5d                   	pop    %ebp
    1187:	c3                   	ret    
    1188:	90                   	nop
    1189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    1190:	c7 05 e4 17 00 00 e8 	movl   $0x17e8,0x17e4
    1197:	17 00 00 
    119a:	c7 05 e8 17 00 00 e8 	movl   $0x17e8,0x17e8
    11a1:	17 00 00 
    base.s.size = 0;
    11a4:	b8 e8 17 00 00       	mov    $0x17e8,%eax
    11a9:	c7 05 ec 17 00 00 00 	movl   $0x0,0x17ec
    11b0:	00 00 00 
    11b3:	e9 44 ff ff ff       	jmp    10fc <malloc+0x2c>
    11b8:	90                   	nop
    11b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    11c0:	8b 08                	mov    (%eax),%ecx
    11c2:	89 0a                	mov    %ecx,(%edx)
    11c4:	eb b1                	jmp    1177 <malloc+0xa7>
