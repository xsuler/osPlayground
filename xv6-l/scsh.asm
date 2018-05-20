
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
      13:	e8 52 0e 00 00       	call   e6a <getsharem>
  sh->nfunc = 0;
  sh->top = (char *)sh + sizeof(struct shared);
      18:	8d 90 1c 05 00 00    	lea    0x51c(%eax),%edx
  sh->nfunc = 0;
      1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  sh->top = (char *)sh + sizeof(struct shared);
      24:	89 90 18 05 00 00    	mov    %edx,0x518(%eax)
  split(-2);
      2a:	c7 04 24 fe ff ff ff 	movl   $0xfffffffe,(%esp)
      31:	e8 44 0e 00 00       	call   e7a <split>

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
      4a:	68 b6 12 00 00       	push   $0x12b6
      4f:	e8 ae 0d 00 00       	call   e02 <open>
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
      60:	80 3d 62 18 00 00 20 	cmpb   $0x20,0x1862
      67:	0f 84 83 00 00 00    	je     f0 <main+0xf0>
}

int fork1(void) {
  int pid;

  pid = fork();
      6d:	e8 48 0d 00 00       	call   dba <fork>
  if (pid == -1)
      72:	83 f8 ff             	cmp    $0xffffffff,%eax
      75:	74 3b                	je     b2 <main+0xb2>
    if (fork1() == 0) {
      77:	85 c0                	test   %eax,%eax
      79:	74 57                	je     d2 <main+0xd2>
    wait();
      7b:	e8 4a 0d 00 00       	call   dca <wait>
  while (getcmd(buf, sizeof(buf)) >= 0) {
      80:	83 ec 08             	sub    $0x8,%esp
      83:	6a 64                	push   $0x64
      85:	68 60 18 00 00       	push   $0x1860
      8a:	e8 91 02 00 00       	call   320 <getcmd>
      8f:	83 c4 10             	add    $0x10,%esp
      92:	85 c0                	test   %eax,%eax
      94:	78 37                	js     cd <main+0xcd>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      96:	80 3d 60 18 00 00 63 	cmpb   $0x63,0x1860
      9d:	75 ce                	jne    6d <main+0x6d>
      9f:	80 3d 61 18 00 00 64 	cmpb   $0x64,0x1861
      a6:	74 b8                	je     60 <main+0x60>
  pid = fork();
      a8:	e8 0d 0d 00 00       	call   dba <fork>
  if (pid == -1)
      ad:	83 f8 ff             	cmp    $0xffffffff,%eax
      b0:	75 c5                	jne    77 <main+0x77>
    panic("fork");
      b2:	83 ec 0c             	sub    $0xc,%esp
      b5:	68 aa 12 00 00       	push   $0x12aa
      ba:	e8 b1 02 00 00       	call   370 <panic>
      close(fd);
      bf:	83 ec 0c             	sub    $0xc,%esp
      c2:	50                   	push   %eax
      c3:	e8 22 0d 00 00       	call   dea <close>
      break;
      c8:	83 c4 10             	add    $0x10,%esp
      cb:	eb b3                	jmp    80 <main+0x80>
  exit();
      cd:	e8 f0 0c 00 00       	call   dc2 <exit>
      getsharem(0);
      d2:	83 ec 0c             	sub    $0xc,%esp
      d5:	6a 00                	push   $0x0
      d7:	e8 8e 0d 00 00       	call   e6a <getsharem>
      runexp(parseexp(buf));
      dc:	c7 04 24 60 18 00 00 	movl   $0x1860,(%esp)
      e3:	e8 18 0a 00 00       	call   b00 <parseexp>
      e8:	89 04 24             	mov    %eax,(%esp)
      eb:	e8 a0 02 00 00       	call   390 <runexp>
      buf[strlen(buf) - 1] = 0; // chop \n
      f0:	83 ec 0c             	sub    $0xc,%esp
      f3:	68 60 18 00 00       	push   $0x1860
      f8:	e8 f3 0a 00 00       	call   bf0 <strlen>
      if (chdir(buf + 3) < 0)
      fd:	c7 04 24 63 18 00 00 	movl   $0x1863,(%esp)
      buf[strlen(buf) - 1] = 0; // chop \n
     104:	c6 80 5f 18 00 00 00 	movb   $0x0,0x185f(%eax)
      if (chdir(buf + 3) < 0)
     10b:	e8 22 0d 00 00       	call   e32 <chdir>
     110:	83 c4 10             	add    $0x10,%esp
     113:	85 c0                	test   %eax,%eax
     115:	0f 89 65 ff ff ff    	jns    80 <main+0x80>
        printf(2, "cannot cd %s\n", buf + 3);
     11b:	50                   	push   %eax
     11c:	68 63 18 00 00       	push   $0x1863
     121:	68 d3 12 00 00       	push   $0x12d3
     126:	6a 02                	push   $0x2
     128:	e8 03 0e 00 00       	call   f30 <printf>
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
     197:	e8 04 0a 00 00       	call   ba0 <strcmp>
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
     235:	e8 36 09 00 00       	call   b70 <strcpy>
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
     26e:	e8 f7 0b 00 00       	call   e6a <getsharem>
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
     292:	e8 d9 08 00 00       	call   b70 <strcpy>
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
     2f9:	e8 72 08 00 00       	call   b70 <strcpy>
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
     32e:	68 88 12 00 00       	push   $0x1288
     333:	6a 02                	push   $0x2
     335:	e8 f6 0b 00 00       	call   f30 <printf>
  memset(buf, 0, nbuf);
     33a:	83 c4 0c             	add    $0xc,%esp
     33d:	56                   	push   %esi
     33e:	6a 00                	push   $0x0
     340:	53                   	push   %ebx
     341:	e8 da 08 00 00       	call   c20 <memset>
  gets(buf, nbuf);
     346:	58                   	pop    %eax
     347:	5a                   	pop    %edx
     348:	56                   	push   %esi
     349:	53                   	push   %ebx
     34a:	e8 31 09 00 00       	call   c80 <gets>
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
     379:	68 cf 12 00 00       	push   $0x12cf
     37e:	6a 02                	push   $0x2
     380:	e8 ab 0b 00 00       	call   f30 <printf>
  exit();
     385:	e8 38 0a 00 00       	call   dc2 <exit>
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
     3bf:	68 8b 12 00 00       	push   $0x128b
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
     3eb:	68 be 12 00 00       	push   $0x12be
     3f0:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     3f6:	e8 a5 07 00 00       	call   ba0 <strcmp>
     3fb:	83 c4 10             	add    $0x10,%esp
     3fe:	85 c0                	test   %eax,%eax
     400:	75 74                	jne    476 <runexp+0xe6>
     402:	8b 7d 08             	mov    0x8(%ebp),%edi
  pid = fork();
     405:	e8 b0 09 00 00       	call   dba <fork>
  if (pid == -1)
     40a:	83 f8 ff             	cmp    $0xffffffff,%eax
     40d:	0f 84 7e 03 00 00    	je     791 <runexp+0x401>
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
     42c:	e8 99 09 00 00       	call   dca <wait>
     431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  exit();
     438:	e8 85 09 00 00       	call   dc2 <exit>
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
     463:	0f 84 00 03 00 00    	je     769 <runexp+0x3d9>
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
     4a8:	e8 0d 09 00 00       	call   dba <fork>
  if (pid == -1)
     4ad:	83 f8 ff             	cmp    $0xffffffff,%eax
     4b0:	0f 84 db 02 00 00    	je     791 <runexp+0x401>
        if (fork1() == 0) {
     4b6:	85 c0                	test   %eax,%eax
     4b8:	75 43                	jne    4fd <runexp+0x16d>
          close(1);
     4ba:	83 ec 0c             	sub    $0xc,%esp
     4bd:	89 fb                	mov    %edi,%ebx
     4bf:	8b 7d 08             	mov    0x8(%ebp),%edi
     4c2:	6a 01                	push   $0x1
     4c4:	e8 21 09 00 00       	call   dea <close>
          getsharem(0);
     4c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     4d0:	e8 95 09 00 00       	call   e6a <getsharem>
          if (open(".etemp", O_WRONLY | O_CREATE) < 0) {
     4d5:	5e                   	pop    %esi
     4d6:	58                   	pop    %eax
     4d7:	68 01 02 00 00       	push   $0x201
     4dc:	68 af 12 00 00       	push   $0x12af
     4e1:	e8 1c 09 00 00       	call   e02 <open>
     4e6:	83 c4 10             	add    $0x10,%esp
     4e9:	85 c0                	test   %eax,%eax
     4eb:	0f 88 ca 02 00 00    	js     7bb <runexp+0x42b>
          runexp(lst->sexps[i]);
     4f1:	83 ec 0c             	sub    $0xc,%esp
     4f4:	ff 74 9f 08          	pushl  0x8(%edi,%ebx,4)
     4f8:	e8 93 fe ff ff       	call   390 <runexp>
        wait();
     4fd:	e8 c8 08 00 00       	call   dca <wait>
        close(2);
     502:	83 ec 0c             	sub    $0xc,%esp
     505:	6a 02                	push   $0x2
     507:	e8 de 08 00 00       	call   dea <close>
        if ((ffd = open(".etemp", O_RDONLY)) < 0) {
     50c:	58                   	pop    %eax
     50d:	5a                   	pop    %edx
     50e:	6a 00                	push   $0x0
     510:	68 af 12 00 00       	push   $0x12af
     515:	e8 e8 08 00 00       	call   e02 <open>
     51a:	83 c4 10             	add    $0x10,%esp
     51d:	85 c0                	test   %eax,%eax
     51f:	0f 88 83 02 00 00    	js     7a8 <runexp+0x418>
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
     53c:	e8 99 08 00 00       	call   dda <read>
        argv[i][n] = 0;
     541:	8b 0c be             	mov    (%esi,%edi,4),%ecx
     544:	c6 04 01 00          	movb   $0x0,(%ecx,%eax,1)
        close(2);
     548:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     54f:	e8 96 08 00 00       	call   dea <close>
        unlink(".etemp");
     554:	c7 04 24 af 12 00 00 	movl   $0x12af,(%esp)
     55b:	e8 b2 08 00 00       	call   e12 <unlink>
        open("console", O_RDWR);
     560:	5b                   	pop    %ebx
     561:	5e                   	pop    %esi
     562:	6a 02                	push   $0x2
     564:	68 b6 12 00 00       	push   $0x12b6
     569:	e8 94 08 00 00       	call   e02 <open>
     56e:	83 c4 10             	add    $0x10,%esp
     571:	e9 f8 fe ff ff       	jmp    46e <runexp+0xde>
        struct shared *sh = (struct shared *)getsharem(0);
     576:	83 ec 0c             	sub    $0xc,%esp
     579:	31 f6                	xor    %esi,%esi
     57b:	6a 00                	push   $0x0
     57d:	e8 e8 08 00 00       	call   e6a <getsharem>
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
     5ad:	e8 ee 05 00 00       	call   ba0 <strcmp>
     5b2:	83 c4 10             	add    $0x10,%esp
     5b5:	85 c0                	test   %eax,%eax
     5b7:	0f 84 ae 00 00 00    	je     66b <runexp+0x2db>
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
     5d6:	e8 df 07 00 00       	call   dba <fork>
  if (pid == -1)
     5db:	83 f8 ff             	cmp    $0xffffffff,%eax
     5de:	0f 84 ad 01 00 00    	je     791 <runexp+0x401>
        if (fork1() == 0) {
     5e4:	85 c0                	test   %eax,%eax
     5e6:	75 73                	jne    65b <runexp+0x2cb>
          if (argv[0] == 0)
     5e8:	83 bd 5c ff ff ff 00 	cmpl   $0x0,-0xa4(%ebp)
     5ef:	0f 84 43 fe ff ff    	je     438 <runexp+0xa8>
          if (flg == 1) {
     5f5:	83 eb 01             	sub    $0x1,%ebx
     5f8:	0f 84 78 01 00 00    	je     776 <runexp+0x3e6>
            getsharem(0);
     5fe:	83 ec 0c             	sub    $0xc,%esp
     601:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
     604:	6a 00                	push   $0x0
     606:	e8 5f 08 00 00       	call   e6a <getsharem>
     60b:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
     611:	83 c4 10             	add    $0x10,%esp
     614:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
     61a:	89 c6                	mov    %eax,%esi
     61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
              if (argv[j] == 0)
     620:	8b 06                	mov    (%esi),%eax
     622:	85 c0                	test   %eax,%eax
     624:	74 1f                	je     645 <runexp+0x2b5>
              if(argv[j]!=xargv[j])
     626:	39 d8                	cmp    %ebx,%eax
     628:	74 0e                	je     638 <runexp+0x2a8>
                strcpy(xargv[j], argv[j]);
     62a:	52                   	push   %edx
     62b:	52                   	push   %edx
     62c:	50                   	push   %eax
     62d:	53                   	push   %ebx
     62e:	e8 3d 05 00 00       	call   b70 <strcpy>
                argv[j] = xargv[j];
     633:	89 1e                	mov    %ebx,(%esi)
     635:	83 c4 10             	add    $0x10,%esp
            for (j = 0; j < MAXARGS; j++) {
     638:	8d 45 84             	lea    -0x7c(%ebp),%eax
     63b:	83 c6 04             	add    $0x4,%esi
     63e:	83 c3 0a             	add    $0xa,%ebx
     641:	39 f0                	cmp    %esi,%eax
     643:	75 db                	jne    620 <runexp+0x290>
            exec(argv[0], argv);
     645:	50                   	push   %eax
     646:	50                   	push   %eax
     647:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
     64d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     653:	e8 a2 07 00 00       	call   dfa <exec>
     658:	83 c4 10             	add    $0x10,%esp
        wait();
     65b:	e8 6a 07 00 00       	call   dca <wait>
     660:	8b 45 08             	mov    0x8(%ebp),%eax
     663:	8b 40 04             	mov    0x4(%eax),%eax
     666:	e9 1c fe ff ff       	jmp    487 <runexp+0xf7>
     66b:	89 c1                	mov    %eax,%ecx
            argv[sh->funcs[j].argc+1] = 0;
     66d:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
     673:	89 9d 48 ff ff ff    	mov    %ebx,-0xb8(%ebp)
     679:	6b c3 78             	imul   $0x78,%ebx,%eax
              strcpy(sh->xargv[k], argv[k]);
     67c:	89 bd 40 ff ff ff    	mov    %edi,-0xc0(%ebp)
            for (k = 0; k < MAXARGS; k++) {
     682:	31 db                	xor    %ebx,%ebx
              strcpy(sh->xargv[k], argv[k]);
     684:	89 8d 44 ff ff ff    	mov    %ecx,-0xbc(%ebp)
     68a:	81 c2 b4 04 00 00    	add    $0x4b4,%edx
            argv[sh->funcs[j].argc+1] = 0;
     690:	8b 84 02 c0 fb ff ff 	mov    -0x440(%edx,%eax,1),%eax
              strcpy(sh->xargv[k], argv[k]);
     697:	89 d7                	mov    %edx,%edi
            argv[sh->funcs[j].argc+1] = 0;
     699:	c7 84 85 60 ff ff ff 	movl   $0x0,-0xa0(%ebp,%eax,4)
     6a0:	00 00 00 00 
     6a4:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
     6aa:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
              strcpy(sh->xargv[k], argv[k]);
     6b0:	89 c6                	mov    %eax,%esi
              if (argv[k] == 0)
     6b2:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
     6b5:	85 c0                	test   %eax,%eax
     6b7:	74 19                	je     6d2 <runexp+0x342>
              strcpy(sh->xargv[k], argv[k]);
     6b9:	52                   	push   %edx
     6ba:	52                   	push   %edx
     6bb:	50                   	push   %eax
     6bc:	6b c3 0a             	imul   $0xa,%ebx,%eax
            for (k = 0; k < MAXARGS; k++) {
     6bf:	83 c3 01             	add    $0x1,%ebx
              strcpy(sh->xargv[k], argv[k]);
     6c2:	01 f8                	add    %edi,%eax
     6c4:	50                   	push   %eax
     6c5:	e8 a6 04 00 00       	call   b70 <strcpy>
            for (k = 0; k < MAXARGS; k++) {
     6ca:	83 c4 10             	add    $0x10,%esp
     6cd:	83 fb 0a             	cmp    $0xa,%ebx
     6d0:	75 e0                	jne    6b2 <runexp+0x322>
            for (k = 0; k < sh->funcs[j].argc; k++)
     6d2:	6b 85 48 ff ff ff 78 	imul   $0x78,-0xb8(%ebp),%eax
     6d9:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
     6df:	8b bd 54 ff ff ff    	mov    -0xac(%ebp),%edi
     6e5:	8b 8d 44 ff ff ff    	mov    -0xbc(%ebp),%ecx
     6eb:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
     6f1:	01 d0                	add    %edx,%eax
     6f3:	83 78 74 00          	cmpl   $0x0,0x74(%eax)
     6f7:	0f 8e a1 00 00 00    	jle    79e <runexp+0x40e>
     6fd:	81 c2 be 04 00 00    	add    $0x4be,%edx
              replaceAtom(sh->funcs[j].sexp, sh->funcs[j].argv[k], sh->xargv[k + 1]);
     703:	89 bd 44 ff ff ff    	mov    %edi,-0xbc(%ebp)
     709:	89 cf                	mov    %ecx,%edi
     70b:	89 d3                	mov    %edx,%ebx
     70d:	8d 96 50 fb ff ff    	lea    -0x4b0(%esi),%edx
     713:	89 c6                	mov    %eax,%esi
     715:	89 95 4c ff ff ff    	mov    %edx,-0xb4(%ebp)
     71b:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
     721:	52                   	push   %edx
     722:	83 c7 01             	add    $0x1,%edi
     725:	53                   	push   %ebx
     726:	01 d8                	add    %ebx,%eax
     728:	83 c3 0a             	add    $0xa,%ebx
     72b:	50                   	push   %eax
     72c:	ff 76 78             	pushl  0x78(%esi)
     72f:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
     735:	e8 06 fa ff ff       	call   140 <replaceAtom>
              strcpy(sh->funcs[j].argv[k],argv[k+1]);
     73a:	59                   	pop    %ecx
     73b:	58                   	pop    %eax
     73c:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
     742:	ff 34 b8             	pushl  (%eax,%edi,4)
     745:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
     74b:	50                   	push   %eax
     74c:	e8 1f 04 00 00       	call   b70 <strcpy>
            for (k = 0; k < sh->funcs[j].argc; k++)
     751:	83 c4 10             	add    $0x10,%esp
     754:	3b 7e 74             	cmp    0x74(%esi),%edi
     757:	7c c2                	jl     71b <runexp+0x38b>
     759:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
            flg = 1;
     75f:	bb 01 00 00 00       	mov    $0x1,%ebx
     764:	e9 6d fe ff ff       	jmp    5d6 <runexp+0x246>
        panic("syntax error");
     769:	83 ec 0c             	sub    $0xc,%esp
     76c:	68 9d 12 00 00       	push   $0x129d
     771:	e8 fa fb ff ff       	call   370 <panic>
            struct shared *sh = (struct shared *)getsharem(0);
     776:	83 ec 0c             	sub    $0xc,%esp
     779:	6a 00                	push   $0x0
     77b:	e8 ea 06 00 00       	call   e6a <getsharem>
            runexp(sh->funcs[j].sexp);
     780:	6b 95 48 ff ff ff 78 	imul   $0x78,-0xb8(%ebp),%edx
     787:	59                   	pop    %ecx
     788:	ff 74 10 78          	pushl  0x78(%eax,%edx,1)
     78c:	e8 ff fb ff ff       	call   390 <runexp>
    panic("fork");
     791:	83 ec 0c             	sub    $0xc,%esp
     794:	68 aa 12 00 00       	push   $0x12aa
     799:	e8 d2 fb ff ff       	call   370 <panic>
            flg = 1;
     79e:	bb 01 00 00 00       	mov    $0x1,%ebx
     7a3:	e9 2e fe ff ff       	jmp    5d6 <runexp+0x246>
          printf(1, "open console temp file failed\n");
     7a8:	57                   	push   %edi
     7a9:	57                   	push   %edi
     7aa:	68 e4 12 00 00       	push   $0x12e4
     7af:	6a 01                	push   $0x1
     7b1:	e8 7a 07 00 00       	call   f30 <printf>
          exit();
     7b6:	e8 07 06 00 00       	call   dc2 <exit>
            printf(2, "open console temp file failed\n");
     7bb:	51                   	push   %ecx
     7bc:	51                   	push   %ecx
     7bd:	68 e4 12 00 00       	push   $0x12e4
     7c2:	6a 02                	push   $0x2
     7c4:	e8 67 07 00 00       	call   f30 <printf>
            exit();
     7c9:	e8 f4 05 00 00       	call   dc2 <exit>
     7ce:	66 90                	xchg   %ax,%ax

000007d0 <fork1>:
int fork1(void) {
     7d0:	55                   	push   %ebp
     7d1:	89 e5                	mov    %esp,%ebp
     7d3:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     7d6:	e8 df 05 00 00       	call   dba <fork>
  if (pid == -1)
     7db:	83 f8 ff             	cmp    $0xffffffff,%eax
     7de:	74 02                	je     7e2 <fork1+0x12>

  return pid;
}
     7e0:	c9                   	leave  
     7e1:	c3                   	ret    
    panic("fork");
     7e2:	83 ec 0c             	sub    $0xc,%esp
     7e5:	68 aa 12 00 00       	push   $0x12aa
     7ea:	e8 81 fb ff ff       	call   370 <panic>
     7ef:	90                   	nop

000007f0 <atom>:

// PAGEBREAK!
// Constructors

struct sexp *atom(void) {
     7f0:	55                   	push   %ebp
     7f1:	89 e5                	mov    %esp,%ebp
     7f3:	53                   	push   %ebx
     7f4:	83 ec 10             	sub    $0x10,%esp
  struct atom *exp;

  exp = malloc(sizeof(*exp));
     7f7:	6a 0c                	push   $0xc
     7f9:	e8 92 09 00 00       	call   1190 <malloc>
  memset(exp, 0, sizeof(*exp));
     7fe:	83 c4 0c             	add    $0xc,%esp
  exp = malloc(sizeof(*exp));
     801:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     803:	6a 0c                	push   $0xc
     805:	6a 00                	push   $0x0
     807:	50                   	push   %eax
     808:	e8 13 04 00 00       	call   c20 <memset>
  return (struct sexp *)exp;
}
     80d:	89 d8                	mov    %ebx,%eax
     80f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     812:	c9                   	leave  
     813:	c3                   	ret    
     814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     81a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000820 <list>:

struct sexp *list(void) {
     820:	55                   	push   %ebp
     821:	89 e5                	mov    %esp,%ebp
     823:	53                   	push   %ebx
     824:	83 ec 10             	sub    $0x10,%esp
  struct list *exp;

  exp = malloc(sizeof(*exp));
     827:	6a 30                	push   $0x30
     829:	e8 62 09 00 00       	call   1190 <malloc>
  memset(exp, 0, sizeof(*exp));
     82e:	83 c4 0c             	add    $0xc,%esp
  exp = malloc(sizeof(*exp));
     831:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     833:	6a 30                	push   $0x30
     835:	6a 00                	push   $0x0
     837:	50                   	push   %eax
     838:	e8 e3 03 00 00       	call   c20 <memset>
  return (struct sexp *)exp;
}
     83d:	89 d8                	mov    %ebx,%eax
     83f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     842:	c9                   	leave  
     843:	c3                   	ret    
     844:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     84a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000850 <peek>:
// Parsing

char whitespace[] = " \t\r\n\v";
char esymbols[] = "()";

int peek(char **ps, char *es, char *toks) {
     850:	55                   	push   %ebp
     851:	89 e5                	mov    %esp,%ebp
     853:	57                   	push   %edi
     854:	56                   	push   %esi
     855:	53                   	push   %ebx
     856:	83 ec 0c             	sub    $0xc,%esp
     859:	8b 7d 08             	mov    0x8(%ebp),%edi
     85c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps; while (s < es && strchr(whitespace, *s))
     85f:	8b 1f                	mov    (%edi),%ebx
     861:	39 f3                	cmp    %esi,%ebx
     863:	72 12                	jb     877 <peek+0x27>
     865:	eb 28                	jmp    88f <peek+0x3f>
     867:	89 f6                	mov    %esi,%esi
     869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
     870:	83 c3 01             	add    $0x1,%ebx
  s = *ps; while (s < es && strchr(whitespace, *s))
     873:	39 de                	cmp    %ebx,%esi
     875:	74 18                	je     88f <peek+0x3f>
     877:	0f be 03             	movsbl (%ebx),%eax
     87a:	83 ec 08             	sub    $0x8,%esp
     87d:	50                   	push   %eax
     87e:	68 48 18 00 00       	push   $0x1848
     883:	e8 b8 03 00 00       	call   c40 <strchr>
     888:	83 c4 10             	add    $0x10,%esp
     88b:	85 c0                	test   %eax,%eax
     88d:	75 e1                	jne    870 <peek+0x20>
  *ps = s;
     88f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     891:	0f be 13             	movsbl (%ebx),%edx
     894:	31 c0                	xor    %eax,%eax
     896:	84 d2                	test   %dl,%dl
     898:	74 17                	je     8b1 <peek+0x61>
     89a:	83 ec 08             	sub    $0x8,%esp
     89d:	52                   	push   %edx
     89e:	ff 75 10             	pushl  0x10(%ebp)
     8a1:	e8 9a 03 00 00       	call   c40 <strchr>
     8a6:	83 c4 10             	add    $0x10,%esp
     8a9:	85 c0                	test   %eax,%eax
     8ab:	0f 95 c0             	setne  %al
     8ae:	0f b6 c0             	movzbl %al,%eax
}
     8b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8b4:	5b                   	pop    %ebx
     8b5:	5e                   	pop    %esi
     8b6:	5f                   	pop    %edi
     8b7:	5d                   	pop    %ebp
     8b8:	c3                   	ret    
     8b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008c0 <parseatom>:
  lst->length = i;

  return ret;
}

struct sexp *parseatom(char **ps, char *es) {
     8c0:	55                   	push   %ebp
     8c1:	89 e5                	mov    %esp,%ebp
     8c3:	57                   	push   %edi
     8c4:	56                   	push   %esi
     8c5:	53                   	push   %ebx
     8c6:	83 ec 0c             	sub    $0xc,%esp
     8c9:	8b 7d 08             	mov    0x8(%ebp),%edi
     8cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct atom *atm;
  struct sexp *ret;

  char *s = *ps;
     8cf:	8b 37                	mov    (%edi),%esi
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     8d1:	39 de                	cmp    %ebx,%esi
     8d3:	89 f0                	mov    %esi,%eax
     8d5:	72 2e                	jb     905 <parseatom+0x45>
     8d7:	eb 44                	jmp    91d <parseatom+0x5d>
     8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
         !strchr(esymbols, *(*ps))) // peek whitespace
     8e0:	8b 07                	mov    (%edi),%eax
     8e2:	83 ec 08             	sub    $0x8,%esp
     8e5:	0f be 00             	movsbl (%eax),%eax
     8e8:	50                   	push   %eax
     8e9:	68 44 18 00 00       	push   $0x1844
     8ee:	e8 4d 03 00 00       	call   c40 <strchr>
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     8f3:	83 c4 10             	add    $0x10,%esp
     8f6:	85 c0                	test   %eax,%eax
     8f8:	75 23                	jne    91d <parseatom+0x5d>
    (*ps)++;
     8fa:	8b 07                	mov    (%edi),%eax
     8fc:	83 c0 01             	add    $0x1,%eax
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     8ff:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
     901:	89 07                	mov    %eax,(%edi)
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     903:	73 18                	jae    91d <parseatom+0x5d>
     905:	0f be 00             	movsbl (%eax),%eax
     908:	83 ec 08             	sub    $0x8,%esp
     90b:	50                   	push   %eax
     90c:	68 48 18 00 00       	push   $0x1848
     911:	e8 2a 03 00 00       	call   c40 <strchr>
     916:	83 c4 10             	add    $0x10,%esp
     919:	85 c0                	test   %eax,%eax
     91b:	74 c3                	je     8e0 <parseatom+0x20>

  ret = atom();
     91d:	e8 ce fe ff ff       	call   7f0 <atom>
  atm = (struct atom *)ret;

  atm->type = ATOM;
     922:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  atm->symbol = s;
     928:	89 70 04             	mov    %esi,0x4(%eax)
  atm->esymbol = *ps;
     92b:	8b 17                	mov    (%edi),%edx
     92d:	89 50 08             	mov    %edx,0x8(%eax)

  return ret;
}
     930:	8d 65 f4             	lea    -0xc(%ebp),%esp
     933:	5b                   	pop    %ebx
     934:	5e                   	pop    %esi
     935:	5f                   	pop    %edi
     936:	5d                   	pop    %ebp
     937:	c3                   	ret    
     938:	90                   	nop
     939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000940 <parsesexp>:

struct sexp *parsesexp(char **ps, char *es) {
     940:	55                   	push   %ebp
     941:	89 e5                	mov    %esp,%ebp
     943:	56                   	push   %esi
     944:	53                   	push   %ebx
     945:	8b 75 08             	mov    0x8(%ebp),%esi
     948:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct sexp *ret = 0;

  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     94b:	8b 06                	mov    (%esi),%eax
     94d:	39 c3                	cmp    %eax,%ebx
     94f:	77 10                	ja     961 <parsesexp+0x21>
     951:	eb 28                	jmp    97b <parsesexp+0x3b>
     953:	90                   	nop
     954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    (*ps)++;
     958:	83 c0 01             	add    $0x1,%eax
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     95b:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
     95d:	89 06                	mov    %eax,(%esi)
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     95f:	73 1a                	jae    97b <parsesexp+0x3b>
     961:	0f be 00             	movsbl (%eax),%eax
     964:	83 ec 08             	sub    $0x8,%esp
     967:	50                   	push   %eax
     968:	68 48 18 00 00       	push   $0x1848
     96d:	e8 ce 02 00 00       	call   c40 <strchr>
     972:	83 c4 10             	add    $0x10,%esp
     975:	85 c0                	test   %eax,%eax
    (*ps)++;
     977:	8b 06                	mov    (%esi),%eax
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     979:	75 dd                	jne    958 <parsesexp+0x18>
  switch (*(*ps)) {
     97b:	0f b6 10             	movzbl (%eax),%edx
     97e:	80 fa 27             	cmp    $0x27,%dl
     981:	74 55                	je     9d8 <parsesexp+0x98>
     983:	80 fa 28             	cmp    $0x28,%dl
     986:	74 28                	je     9b0 <parsesexp+0x70>
     988:	84 d2                	test   %dl,%dl
     98a:	74 14                	je     9a0 <parsesexp+0x60>
    (*ps) += 2;
    ret = parselist(ps, es);
    (*ps)++;
    break;
  default:
    ret = parseatom(ps, es);
     98c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
     98f:	89 75 08             	mov    %esi,0x8(%ebp)
    break;
  }
  return ret;
}
     992:	8d 65 f8             	lea    -0x8(%ebp),%esp
     995:	5b                   	pop    %ebx
     996:	5e                   	pop    %esi
     997:	5d                   	pop    %ebp
    ret = parseatom(ps, es);
     998:	e9 23 ff ff ff       	jmp    8c0 <parseatom>
     99d:	8d 76 00             	lea    0x0(%esi),%esi
}
     9a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  struct sexp *ret = 0;
     9a3:	31 c0                	xor    %eax,%eax
}
     9a5:	5b                   	pop    %ebx
     9a6:	5e                   	pop    %esi
     9a7:	5d                   	pop    %ebp
     9a8:	c3                   	ret    
     9a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret = parselist(ps, es);
     9b0:	83 ec 08             	sub    $0x8,%esp
    (*ps)++;
     9b3:	83 c0 01             	add    $0x1,%eax
     9b6:	89 06                	mov    %eax,(%esi)
    ret = parselist(ps, es);
     9b8:	53                   	push   %ebx
     9b9:	56                   	push   %esi
     9ba:	e8 41 00 00 00       	call   a00 <parselist>
    ret->type = APPLY;
     9bf:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    break;
     9c5:	83 c4 10             	add    $0x10,%esp
    (*ps)++;
     9c8:	83 06 01             	addl   $0x1,(%esi)
}
     9cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
     9ce:	5b                   	pop    %ebx
     9cf:	5e                   	pop    %esi
     9d0:	5d                   	pop    %ebp
     9d1:	c3                   	ret    
     9d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ret = parselist(ps, es);
     9d8:	83 ec 08             	sub    $0x8,%esp
    (*ps) += 2;
     9db:	83 c0 02             	add    $0x2,%eax
     9de:	89 06                	mov    %eax,(%esi)
    ret = parselist(ps, es);
     9e0:	53                   	push   %ebx
     9e1:	56                   	push   %esi
     9e2:	e8 19 00 00 00       	call   a00 <parselist>
    (*ps)++;
     9e7:	83 06 01             	addl   $0x1,(%esi)
    break;
     9ea:	83 c4 10             	add    $0x10,%esp
}
     9ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
     9f0:	5b                   	pop    %ebx
     9f1:	5e                   	pop    %esi
     9f2:	5d                   	pop    %ebp
     9f3:	c3                   	ret    
     9f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     9fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000a00 <parselist>:
struct sexp *parselist(char **ps, char *es) {
     a00:	55                   	push   %ebp
     a01:	89 e5                	mov    %esp,%ebp
     a03:	57                   	push   %edi
     a04:	56                   	push   %esi
     a05:	53                   	push   %ebx
     a06:	83 ec 1c             	sub    $0x1c,%esp
     a09:	8b 75 08             	mov    0x8(%ebp),%esi
     a0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  ret = list();
     a0f:	e8 0c fe ff ff       	call   820 <list>
  lst->type = LIST;
     a14:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  ret = list();
     a1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *res = *ps;
     a1d:	8b 0e                	mov    (%esi),%ecx
  while (res < es) {
     a1f:	39 f9                	cmp    %edi,%ecx
     a21:	89 cb                	mov    %ecx,%ebx
     a23:	73 3b                	jae    a60 <parselist+0x60>
  int i = 1;
     a25:	ba 01 00 00 00       	mov    $0x1,%edx
     a2a:	eb 14                	jmp    a40 <parselist+0x40>
     a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (*res == ')') {
     a30:	3c 29                	cmp    $0x29,%al
     a32:	75 05                	jne    a39 <parselist+0x39>
      if (i == 0) {
     a34:	83 ea 01             	sub    $0x1,%edx
     a37:	74 27                	je     a60 <parselist+0x60>
    res++;
     a39:	83 c3 01             	add    $0x1,%ebx
  while (res < es) {
     a3c:	39 df                	cmp    %ebx,%edi
     a3e:	74 11                	je     a51 <parselist+0x51>
    if (*res == '(')
     a40:	0f b6 03             	movzbl (%ebx),%eax
     a43:	3c 28                	cmp    $0x28,%al
     a45:	75 e9                	jne    a30 <parselist+0x30>
    res++;
     a47:	83 c3 01             	add    $0x1,%ebx
      i++;
     a4a:	83 c2 01             	add    $0x1,%edx
  while (res < es) {
     a4d:	39 df                	cmp    %ebx,%edi
     a4f:	75 ef                	jne    a40 <parselist+0x40>
    panic("syntax error");
     a51:	83 ec 0c             	sub    $0xc,%esp
     a54:	68 9d 12 00 00       	push   $0x129d
     a59:	e8 12 f9 ff ff       	call   370 <panic>
     a5e:	66 90                	xchg   %ax,%ax
  if (res == es)
     a60:	39 df                	cmp    %ebx,%edi
     a62:	74 ed                	je     a51 <parselist+0x51>
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     a64:	31 ff                	xor    %edi,%edi
     a66:	eb 0a                	jmp    a72 <parselist+0x72>
     a68:	90                   	nop
     a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a70:	8b 0e                	mov    (%esi),%ecx
     a72:	39 d9                	cmp    %ebx,%ecx
     a74:	73 1c                	jae    a92 <parselist+0x92>
    lst->sexps[i] = parsesexp(ps, res);
     a76:	83 ec 08             	sub    $0x8,%esp
     a79:	53                   	push   %ebx
     a7a:	56                   	push   %esi
     a7b:	e8 c0 fe ff ff       	call   940 <parsesexp>
     a80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     a83:	83 c4 10             	add    $0x10,%esp
    lst->sexps[i] = parsesexp(ps, res);
     a86:	89 44 ba 08          	mov    %eax,0x8(%edx,%edi,4)
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     a8a:	83 c7 01             	add    $0x1,%edi
     a8d:	83 ff 0a             	cmp    $0xa,%edi
     a90:	75 de                	jne    a70 <parselist+0x70>
  lst->length = i;
     a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     a95:	89 78 04             	mov    %edi,0x4(%eax)
}
     a98:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a9b:	5b                   	pop    %ebx
     a9c:	5e                   	pop    %esi
     a9d:	5f                   	pop    %edi
     a9e:	5d                   	pop    %ebp
     a9f:	c3                   	ret    

00000aa0 <snulterminate>:
  }
  snulterminate(exp);
  return exp;
}

struct sexp *snulterminate(struct sexp *exp) {
     aa0:	55                   	push   %ebp
     aa1:	89 e5                	mov    %esp,%ebp
     aa3:	56                   	push   %esi
     aa4:	53                   	push   %ebx
     aa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;
  struct list *lst;
  struct atom *atm;

  if (exp == 0)
     aa8:	85 db                	test   %ebx,%ebx
     aaa:	74 2e                	je     ada <snulterminate+0x3a>
    return 0;

  switch (exp->type) {
     aac:	8b 03                	mov    (%ebx),%eax
     aae:	83 f8 01             	cmp    $0x1,%eax
     ab1:	74 35                	je     ae8 <snulterminate+0x48>
     ab3:	7c 25                	jl     ada <snulterminate+0x3a>
     ab5:	83 f8 03             	cmp    $0x3,%eax
     ab8:	7f 20                	jg     ada <snulterminate+0x3a>
    break;

  case APPLY:
  case LIST:
    lst = (struct list *)exp;
    for (i = 0; i < lst->length; i++)
     aba:	8b 43 04             	mov    0x4(%ebx),%eax
     abd:	31 f6                	xor    %esi,%esi
     abf:	85 c0                	test   %eax,%eax
     ac1:	7e 17                	jle    ada <snulterminate+0x3a>
      snulterminate(lst->sexps[i]);
     ac3:	83 ec 0c             	sub    $0xc,%esp
     ac6:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
    for (i = 0; i < lst->length; i++)
     aca:	83 c6 01             	add    $0x1,%esi
      snulterminate(lst->sexps[i]);
     acd:	e8 ce ff ff ff       	call   aa0 <snulterminate>
    for (i = 0; i < lst->length; i++)
     ad2:	83 c4 10             	add    $0x10,%esp
     ad5:	3b 73 04             	cmp    0x4(%ebx),%esi
     ad8:	7c e9                	jl     ac3 <snulterminate+0x23>
    break;
  }
  return exp;
}
     ada:	8d 65 f8             	lea    -0x8(%ebp),%esp
     add:	89 d8                	mov    %ebx,%eax
     adf:	5b                   	pop    %ebx
     ae0:	5e                   	pop    %esi
     ae1:	5d                   	pop    %ebp
     ae2:	c3                   	ret    
     ae3:	90                   	nop
     ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *atm->esymbol = 0;
     ae8:	8b 43 08             	mov    0x8(%ebx),%eax
     aeb:	c6 00 00             	movb   $0x0,(%eax)
}
     aee:	8d 65 f8             	lea    -0x8(%ebp),%esp
     af1:	89 d8                	mov    %ebx,%eax
     af3:	5b                   	pop    %ebx
     af4:	5e                   	pop    %esi
     af5:	5d                   	pop    %ebp
     af6:	c3                   	ret    
     af7:	89 f6                	mov    %esi,%esi
     af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b00 <parseexp>:
struct sexp *parseexp(char *s) {
     b00:	55                   	push   %ebp
     b01:	89 e5                	mov    %esp,%ebp
     b03:	56                   	push   %esi
     b04:	53                   	push   %ebx
  es = s + strlen(s);
     b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
     b08:	83 ec 0c             	sub    $0xc,%esp
     b0b:	53                   	push   %ebx
     b0c:	e8 df 00 00 00       	call   bf0 <strlen>
  exp = parsesexp(&s, es);
     b11:	59                   	pop    %ecx
  es = s + strlen(s);
     b12:	01 c3                	add    %eax,%ebx
  exp = parsesexp(&s, es);
     b14:	8d 45 08             	lea    0x8(%ebp),%eax
     b17:	5e                   	pop    %esi
     b18:	53                   	push   %ebx
     b19:	50                   	push   %eax
     b1a:	e8 21 fe ff ff       	call   940 <parsesexp>
     b1f:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     b21:	8d 45 08             	lea    0x8(%ebp),%eax
     b24:	83 c4 0c             	add    $0xc,%esp
     b27:	68 d2 12 00 00       	push   $0x12d2
     b2c:	53                   	push   %ebx
     b2d:	50                   	push   %eax
     b2e:	e8 1d fd ff ff       	call   850 <peek>
  if (s != es) {
     b33:	8b 45 08             	mov    0x8(%ebp),%eax
     b36:	83 c4 10             	add    $0x10,%esp
     b39:	39 d8                	cmp    %ebx,%eax
     b3b:	75 12                	jne    b4f <parseexp+0x4f>
  snulterminate(exp);
     b3d:	83 ec 0c             	sub    $0xc,%esp
     b40:	56                   	push   %esi
     b41:	e8 5a ff ff ff       	call   aa0 <snulterminate>
}
     b46:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b49:	89 f0                	mov    %esi,%eax
     b4b:	5b                   	pop    %ebx
     b4c:	5e                   	pop    %esi
     b4d:	5d                   	pop    %ebp
     b4e:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     b4f:	52                   	push   %edx
     b50:	50                   	push   %eax
     b51:	68 c4 12 00 00       	push   $0x12c4
     b56:	6a 02                	push   $0x2
     b58:	e8 d3 03 00 00       	call   f30 <printf>
    panic("syntax error");
     b5d:	c7 04 24 9d 12 00 00 	movl   $0x129d,(%esp)
     b64:	e8 07 f8 ff ff       	call   370 <panic>
     b69:	66 90                	xchg   %ax,%ax
     b6b:	66 90                	xchg   %ax,%ax
     b6d:	66 90                	xchg   %ax,%ax
     b6f:	90                   	nop

00000b70 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     b70:	55                   	push   %ebp
     b71:	89 e5                	mov    %esp,%ebp
     b73:	53                   	push   %ebx
     b74:	8b 45 08             	mov    0x8(%ebp),%eax
     b77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b7a:	89 c2                	mov    %eax,%edx
     b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     b80:	83 c1 01             	add    $0x1,%ecx
     b83:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     b87:	83 c2 01             	add    $0x1,%edx
     b8a:	84 db                	test   %bl,%bl
     b8c:	88 5a ff             	mov    %bl,-0x1(%edx)
     b8f:	75 ef                	jne    b80 <strcpy+0x10>
    ;
  return os;
}
     b91:	5b                   	pop    %ebx
     b92:	5d                   	pop    %ebp
     b93:	c3                   	ret    
     b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000ba0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ba0:	55                   	push   %ebp
     ba1:	89 e5                	mov    %esp,%ebp
     ba3:	53                   	push   %ebx
     ba4:	8b 55 08             	mov    0x8(%ebp),%edx
     ba7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     baa:	0f b6 02             	movzbl (%edx),%eax
     bad:	0f b6 19             	movzbl (%ecx),%ebx
     bb0:	84 c0                	test   %al,%al
     bb2:	75 1c                	jne    bd0 <strcmp+0x30>
     bb4:	eb 2a                	jmp    be0 <strcmp+0x40>
     bb6:	8d 76 00             	lea    0x0(%esi),%esi
     bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
     bc0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     bc3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
     bc6:	83 c1 01             	add    $0x1,%ecx
     bc9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
     bcc:	84 c0                	test   %al,%al
     bce:	74 10                	je     be0 <strcmp+0x40>
     bd0:	38 d8                	cmp    %bl,%al
     bd2:	74 ec                	je     bc0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     bd4:	29 d8                	sub    %ebx,%eax
}
     bd6:	5b                   	pop    %ebx
     bd7:	5d                   	pop    %ebp
     bd8:	c3                   	ret    
     bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     be0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     be2:	29 d8                	sub    %ebx,%eax
}
     be4:	5b                   	pop    %ebx
     be5:	5d                   	pop    %ebp
     be6:	c3                   	ret    
     be7:	89 f6                	mov    %esi,%esi
     be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000bf0 <strlen>:

uint
strlen(char *s)
{
     bf0:	55                   	push   %ebp
     bf1:	89 e5                	mov    %esp,%ebp
     bf3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     bf6:	80 39 00             	cmpb   $0x0,(%ecx)
     bf9:	74 15                	je     c10 <strlen+0x20>
     bfb:	31 d2                	xor    %edx,%edx
     bfd:	8d 76 00             	lea    0x0(%esi),%esi
     c00:	83 c2 01             	add    $0x1,%edx
     c03:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     c07:	89 d0                	mov    %edx,%eax
     c09:	75 f5                	jne    c00 <strlen+0x10>
    ;
  return n;
}
     c0b:	5d                   	pop    %ebp
     c0c:	c3                   	ret    
     c0d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
     c10:	31 c0                	xor    %eax,%eax
}
     c12:	5d                   	pop    %ebp
     c13:	c3                   	ret    
     c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000c20 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c20:	55                   	push   %ebp
     c21:	89 e5                	mov    %esp,%ebp
     c23:	57                   	push   %edi
     c24:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     c27:	8b 4d 10             	mov    0x10(%ebp),%ecx
     c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
     c2d:	89 d7                	mov    %edx,%edi
     c2f:	fc                   	cld    
     c30:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     c32:	89 d0                	mov    %edx,%eax
     c34:	5f                   	pop    %edi
     c35:	5d                   	pop    %ebp
     c36:	c3                   	ret    
     c37:	89 f6                	mov    %esi,%esi
     c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c40 <strchr>:

char*
strchr(const char *s, char c)
{
     c40:	55                   	push   %ebp
     c41:	89 e5                	mov    %esp,%ebp
     c43:	53                   	push   %ebx
     c44:	8b 45 08             	mov    0x8(%ebp),%eax
     c47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
     c4a:	0f b6 10             	movzbl (%eax),%edx
     c4d:	84 d2                	test   %dl,%dl
     c4f:	74 1d                	je     c6e <strchr+0x2e>
    if(*s == c)
     c51:	38 d3                	cmp    %dl,%bl
     c53:	89 d9                	mov    %ebx,%ecx
     c55:	75 0d                	jne    c64 <strchr+0x24>
     c57:	eb 17                	jmp    c70 <strchr+0x30>
     c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c60:	38 ca                	cmp    %cl,%dl
     c62:	74 0c                	je     c70 <strchr+0x30>
  for(; *s; s++)
     c64:	83 c0 01             	add    $0x1,%eax
     c67:	0f b6 10             	movzbl (%eax),%edx
     c6a:	84 d2                	test   %dl,%dl
     c6c:	75 f2                	jne    c60 <strchr+0x20>
      return (char*)s;
  return 0;
     c6e:	31 c0                	xor    %eax,%eax
}
     c70:	5b                   	pop    %ebx
     c71:	5d                   	pop    %ebp
     c72:	c3                   	ret    
     c73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c80 <gets>:

char*
gets(char *buf, int max)
{
     c80:	55                   	push   %ebp
     c81:	89 e5                	mov    %esp,%ebp
     c83:	57                   	push   %edi
     c84:	56                   	push   %esi
     c85:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c86:	31 f6                	xor    %esi,%esi
     c88:	89 f3                	mov    %esi,%ebx
{
     c8a:	83 ec 1c             	sub    $0x1c,%esp
     c8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     c90:	eb 2f                	jmp    cc1 <gets+0x41>
     c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     c98:	8d 45 e7             	lea    -0x19(%ebp),%eax
     c9b:	83 ec 04             	sub    $0x4,%esp
     c9e:	6a 01                	push   $0x1
     ca0:	50                   	push   %eax
     ca1:	6a 00                	push   $0x0
     ca3:	e8 32 01 00 00       	call   dda <read>
    if(cc < 1)
     ca8:	83 c4 10             	add    $0x10,%esp
     cab:	85 c0                	test   %eax,%eax
     cad:	7e 1c                	jle    ccb <gets+0x4b>
      break;
    buf[i++] = c;
     caf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     cb3:	83 c7 01             	add    $0x1,%edi
     cb6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     cb9:	3c 0a                	cmp    $0xa,%al
     cbb:	74 23                	je     ce0 <gets+0x60>
     cbd:	3c 0d                	cmp    $0xd,%al
     cbf:	74 1f                	je     ce0 <gets+0x60>
  for(i=0; i+1 < max; ){
     cc1:	83 c3 01             	add    $0x1,%ebx
     cc4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     cc7:	89 fe                	mov    %edi,%esi
     cc9:	7c cd                	jl     c98 <gets+0x18>
     ccb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     cd0:	c6 03 00             	movb   $0x0,(%ebx)
}
     cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cd6:	5b                   	pop    %ebx
     cd7:	5e                   	pop    %esi
     cd8:	5f                   	pop    %edi
     cd9:	5d                   	pop    %ebp
     cda:	c3                   	ret    
     cdb:	90                   	nop
     cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ce0:	8b 75 08             	mov    0x8(%ebp),%esi
     ce3:	8b 45 08             	mov    0x8(%ebp),%eax
     ce6:	01 de                	add    %ebx,%esi
     ce8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     cea:	c6 03 00             	movb   $0x0,(%ebx)
}
     ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cf0:	5b                   	pop    %ebx
     cf1:	5e                   	pop    %esi
     cf2:	5f                   	pop    %edi
     cf3:	5d                   	pop    %ebp
     cf4:	c3                   	ret    
     cf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d00 <stat>:

int
stat(char *n, struct stat *st)
{
     d00:	55                   	push   %ebp
     d01:	89 e5                	mov    %esp,%ebp
     d03:	56                   	push   %esi
     d04:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d05:	83 ec 08             	sub    $0x8,%esp
     d08:	6a 00                	push   $0x0
     d0a:	ff 75 08             	pushl  0x8(%ebp)
     d0d:	e8 f0 00 00 00       	call   e02 <open>
  if(fd < 0)
     d12:	83 c4 10             	add    $0x10,%esp
     d15:	85 c0                	test   %eax,%eax
     d17:	78 27                	js     d40 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     d19:	83 ec 08             	sub    $0x8,%esp
     d1c:	ff 75 0c             	pushl  0xc(%ebp)
     d1f:	89 c3                	mov    %eax,%ebx
     d21:	50                   	push   %eax
     d22:	e8 f3 00 00 00       	call   e1a <fstat>
  close(fd);
     d27:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     d2a:	89 c6                	mov    %eax,%esi
  close(fd);
     d2c:	e8 b9 00 00 00       	call   dea <close>
  return r;
     d31:	83 c4 10             	add    $0x10,%esp
}
     d34:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d37:	89 f0                	mov    %esi,%eax
     d39:	5b                   	pop    %ebx
     d3a:	5e                   	pop    %esi
     d3b:	5d                   	pop    %ebp
     d3c:	c3                   	ret    
     d3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     d40:	be ff ff ff ff       	mov    $0xffffffff,%esi
     d45:	eb ed                	jmp    d34 <stat+0x34>
     d47:	89 f6                	mov    %esi,%esi
     d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d50 <atoi>:

int
atoi(const char *s)
{
     d50:	55                   	push   %ebp
     d51:	89 e5                	mov    %esp,%ebp
     d53:	53                   	push   %ebx
     d54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d57:	0f be 11             	movsbl (%ecx),%edx
     d5a:	8d 42 d0             	lea    -0x30(%edx),%eax
     d5d:	3c 09                	cmp    $0x9,%al
  n = 0;
     d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
     d64:	77 1f                	ja     d85 <atoi+0x35>
     d66:	8d 76 00             	lea    0x0(%esi),%esi
     d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
     d70:	8d 04 80             	lea    (%eax,%eax,4),%eax
     d73:	83 c1 01             	add    $0x1,%ecx
     d76:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
     d7a:	0f be 11             	movsbl (%ecx),%edx
     d7d:	8d 5a d0             	lea    -0x30(%edx),%ebx
     d80:	80 fb 09             	cmp    $0x9,%bl
     d83:	76 eb                	jbe    d70 <atoi+0x20>
  return n;
}
     d85:	5b                   	pop    %ebx
     d86:	5d                   	pop    %ebp
     d87:	c3                   	ret    
     d88:	90                   	nop
     d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d90 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d90:	55                   	push   %ebp
     d91:	89 e5                	mov    %esp,%ebp
     d93:	56                   	push   %esi
     d94:	53                   	push   %ebx
     d95:	8b 5d 10             	mov    0x10(%ebp),%ebx
     d98:	8b 45 08             	mov    0x8(%ebp),%eax
     d9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d9e:	85 db                	test   %ebx,%ebx
     da0:	7e 14                	jle    db6 <memmove+0x26>
     da2:	31 d2                	xor    %edx,%edx
     da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
     da8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     dac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     daf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
     db2:	39 d3                	cmp    %edx,%ebx
     db4:	75 f2                	jne    da8 <memmove+0x18>
  return vdst;
}
     db6:	5b                   	pop    %ebx
     db7:	5e                   	pop    %esi
     db8:	5d                   	pop    %ebp
     db9:	c3                   	ret    

00000dba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     dba:	b8 01 00 00 00       	mov    $0x1,%eax
     dbf:	cd 40                	int    $0x40
     dc1:	c3                   	ret    

00000dc2 <exit>:
SYSCALL(exit)
     dc2:	b8 02 00 00 00       	mov    $0x2,%eax
     dc7:	cd 40                	int    $0x40
     dc9:	c3                   	ret    

00000dca <wait>:
SYSCALL(wait)
     dca:	b8 03 00 00 00       	mov    $0x3,%eax
     dcf:	cd 40                	int    $0x40
     dd1:	c3                   	ret    

00000dd2 <pipe>:
SYSCALL(pipe)
     dd2:	b8 04 00 00 00       	mov    $0x4,%eax
     dd7:	cd 40                	int    $0x40
     dd9:	c3                   	ret    

00000dda <read>:
SYSCALL(read)
     dda:	b8 05 00 00 00       	mov    $0x5,%eax
     ddf:	cd 40                	int    $0x40
     de1:	c3                   	ret    

00000de2 <write>:
SYSCALL(write)
     de2:	b8 10 00 00 00       	mov    $0x10,%eax
     de7:	cd 40                	int    $0x40
     de9:	c3                   	ret    

00000dea <close>:
SYSCALL(close)
     dea:	b8 15 00 00 00       	mov    $0x15,%eax
     def:	cd 40                	int    $0x40
     df1:	c3                   	ret    

00000df2 <kill>:
SYSCALL(kill)
     df2:	b8 06 00 00 00       	mov    $0x6,%eax
     df7:	cd 40                	int    $0x40
     df9:	c3                   	ret    

00000dfa <exec>:
SYSCALL(exec)
     dfa:	b8 07 00 00 00       	mov    $0x7,%eax
     dff:	cd 40                	int    $0x40
     e01:	c3                   	ret    

00000e02 <open>:
SYSCALL(open)
     e02:	b8 0f 00 00 00       	mov    $0xf,%eax
     e07:	cd 40                	int    $0x40
     e09:	c3                   	ret    

00000e0a <mknod>:
SYSCALL(mknod)
     e0a:	b8 11 00 00 00       	mov    $0x11,%eax
     e0f:	cd 40                	int    $0x40
     e11:	c3                   	ret    

00000e12 <unlink>:
SYSCALL(unlink)
     e12:	b8 12 00 00 00       	mov    $0x12,%eax
     e17:	cd 40                	int    $0x40
     e19:	c3                   	ret    

00000e1a <fstat>:
SYSCALL(fstat)
     e1a:	b8 08 00 00 00       	mov    $0x8,%eax
     e1f:	cd 40                	int    $0x40
     e21:	c3                   	ret    

00000e22 <link>:
SYSCALL(link)
     e22:	b8 13 00 00 00       	mov    $0x13,%eax
     e27:	cd 40                	int    $0x40
     e29:	c3                   	ret    

00000e2a <mkdir>:
SYSCALL(mkdir)
     e2a:	b8 14 00 00 00       	mov    $0x14,%eax
     e2f:	cd 40                	int    $0x40
     e31:	c3                   	ret    

00000e32 <chdir>:
SYSCALL(chdir)
     e32:	b8 09 00 00 00       	mov    $0x9,%eax
     e37:	cd 40                	int    $0x40
     e39:	c3                   	ret    

00000e3a <dup>:
SYSCALL(dup)
     e3a:	b8 0a 00 00 00       	mov    $0xa,%eax
     e3f:	cd 40                	int    $0x40
     e41:	c3                   	ret    

00000e42 <getpid>:
SYSCALL(getpid)
     e42:	b8 0b 00 00 00       	mov    $0xb,%eax
     e47:	cd 40                	int    $0x40
     e49:	c3                   	ret    

00000e4a <sbrk>:
SYSCALL(sbrk)
     e4a:	b8 0c 00 00 00       	mov    $0xc,%eax
     e4f:	cd 40                	int    $0x40
     e51:	c3                   	ret    

00000e52 <sleep>:
SYSCALL(sleep)
     e52:	b8 0d 00 00 00       	mov    $0xd,%eax
     e57:	cd 40                	int    $0x40
     e59:	c3                   	ret    

00000e5a <uptime>:
SYSCALL(uptime)
     e5a:	b8 0e 00 00 00       	mov    $0xe,%eax
     e5f:	cd 40                	int    $0x40
     e61:	c3                   	ret    

00000e62 <trace>:
SYSCALL(trace)
     e62:	b8 16 00 00 00       	mov    $0x16,%eax
     e67:	cd 40                	int    $0x40
     e69:	c3                   	ret    

00000e6a <getsharem>:
SYSCALL(getsharem)
     e6a:	b8 17 00 00 00       	mov    $0x17,%eax
     e6f:	cd 40                	int    $0x40
     e71:	c3                   	ret    

00000e72 <releasesharem>:
SYSCALL(releasesharem)
     e72:	b8 18 00 00 00       	mov    $0x18,%eax
     e77:	cd 40                	int    $0x40
     e79:	c3                   	ret    

00000e7a <split>:
SYSCALL(split)
     e7a:	b8 19 00 00 00       	mov    $0x19,%eax
     e7f:	cd 40                	int    $0x40
     e81:	c3                   	ret    
     e82:	66 90                	xchg   %ax,%ax
     e84:	66 90                	xchg   %ax,%ax
     e86:	66 90                	xchg   %ax,%ax
     e88:	66 90                	xchg   %ax,%ax
     e8a:	66 90                	xchg   %ax,%ax
     e8c:	66 90                	xchg   %ax,%ax
     e8e:	66 90                	xchg   %ax,%ax

00000e90 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     e90:	55                   	push   %ebp
     e91:	89 e5                	mov    %esp,%ebp
     e93:	57                   	push   %edi
     e94:	56                   	push   %esi
     e95:	53                   	push   %ebx
     e96:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e99:	85 d2                	test   %edx,%edx
{
     e9b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
     e9e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
     ea0:	79 76                	jns    f18 <printint+0x88>
     ea2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     ea6:	74 70                	je     f18 <printint+0x88>
    x = -xx;
     ea8:	f7 d8                	neg    %eax
    neg = 1;
     eaa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     eb1:	31 f6                	xor    %esi,%esi
     eb3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
     eb6:	eb 0a                	jmp    ec2 <printint+0x32>
     eb8:	90                   	nop
     eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
     ec0:	89 fe                	mov    %edi,%esi
     ec2:	31 d2                	xor    %edx,%edx
     ec4:	8d 7e 01             	lea    0x1(%esi),%edi
     ec7:	f7 f1                	div    %ecx
     ec9:	0f b6 92 0c 13 00 00 	movzbl 0x130c(%edx),%edx
  }while((x /= base) != 0);
     ed0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
     ed2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
     ed5:	75 e9                	jne    ec0 <printint+0x30>
  if(neg)
     ed7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     eda:	85 c0                	test   %eax,%eax
     edc:	74 08                	je     ee6 <printint+0x56>
    buf[i++] = '-';
     ede:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
     ee3:	8d 7e 02             	lea    0x2(%esi),%edi
     ee6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
     eea:	8b 7d c0             	mov    -0x40(%ebp),%edi
     eed:	8d 76 00             	lea    0x0(%esi),%esi
     ef0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
     ef3:	83 ec 04             	sub    $0x4,%esp
     ef6:	83 ee 01             	sub    $0x1,%esi
     ef9:	6a 01                	push   $0x1
     efb:	53                   	push   %ebx
     efc:	57                   	push   %edi
     efd:	88 45 d7             	mov    %al,-0x29(%ebp)
     f00:	e8 dd fe ff ff       	call   de2 <write>

  while(--i >= 0)
     f05:	83 c4 10             	add    $0x10,%esp
     f08:	39 de                	cmp    %ebx,%esi
     f0a:	75 e4                	jne    ef0 <printint+0x60>
    putc(fd, buf[i]);
}
     f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f0f:	5b                   	pop    %ebx
     f10:	5e                   	pop    %esi
     f11:	5f                   	pop    %edi
     f12:	5d                   	pop    %ebp
     f13:	c3                   	ret    
     f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     f18:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     f1f:	eb 90                	jmp    eb1 <printint+0x21>
     f21:	eb 0d                	jmp    f30 <printf>
     f23:	90                   	nop
     f24:	90                   	nop
     f25:	90                   	nop
     f26:	90                   	nop
     f27:	90                   	nop
     f28:	90                   	nop
     f29:	90                   	nop
     f2a:	90                   	nop
     f2b:	90                   	nop
     f2c:	90                   	nop
     f2d:	90                   	nop
     f2e:	90                   	nop
     f2f:	90                   	nop

00000f30 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     f30:	55                   	push   %ebp
     f31:	89 e5                	mov    %esp,%ebp
     f33:	57                   	push   %edi
     f34:	56                   	push   %esi
     f35:	53                   	push   %ebx
     f36:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     f39:	8b 75 0c             	mov    0xc(%ebp),%esi
     f3c:	0f b6 1e             	movzbl (%esi),%ebx
     f3f:	84 db                	test   %bl,%bl
     f41:	0f 84 b3 00 00 00    	je     ffa <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
     f47:	8d 45 10             	lea    0x10(%ebp),%eax
     f4a:	83 c6 01             	add    $0x1,%esi
  state = 0;
     f4d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
     f4f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     f52:	eb 2f                	jmp    f83 <printf+0x53>
     f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     f58:	83 f8 25             	cmp    $0x25,%eax
     f5b:	0f 84 a7 00 00 00    	je     1008 <printf+0xd8>
  write(fd, &c, 1);
     f61:	8d 45 e2             	lea    -0x1e(%ebp),%eax
     f64:	83 ec 04             	sub    $0x4,%esp
     f67:	88 5d e2             	mov    %bl,-0x1e(%ebp)
     f6a:	6a 01                	push   $0x1
     f6c:	50                   	push   %eax
     f6d:	ff 75 08             	pushl  0x8(%ebp)
     f70:	e8 6d fe ff ff       	call   de2 <write>
     f75:	83 c4 10             	add    $0x10,%esp
     f78:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
     f7b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
     f7f:	84 db                	test   %bl,%bl
     f81:	74 77                	je     ffa <printf+0xca>
    if(state == 0){
     f83:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
     f85:	0f be cb             	movsbl %bl,%ecx
     f88:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     f8b:	74 cb                	je     f58 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f8d:	83 ff 25             	cmp    $0x25,%edi
     f90:	75 e6                	jne    f78 <printf+0x48>
      if(c == 'd'){
     f92:	83 f8 64             	cmp    $0x64,%eax
     f95:	0f 84 05 01 00 00    	je     10a0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     f9b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     fa1:	83 f9 70             	cmp    $0x70,%ecx
     fa4:	74 72                	je     1018 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     fa6:	83 f8 73             	cmp    $0x73,%eax
     fa9:	0f 84 99 00 00 00    	je     1048 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     faf:	83 f8 63             	cmp    $0x63,%eax
     fb2:	0f 84 08 01 00 00    	je     10c0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     fb8:	83 f8 25             	cmp    $0x25,%eax
     fbb:	0f 84 ef 00 00 00    	je     10b0 <printf+0x180>
  write(fd, &c, 1);
     fc1:	8d 45 e7             	lea    -0x19(%ebp),%eax
     fc4:	83 ec 04             	sub    $0x4,%esp
     fc7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     fcb:	6a 01                	push   $0x1
     fcd:	50                   	push   %eax
     fce:	ff 75 08             	pushl  0x8(%ebp)
     fd1:	e8 0c fe ff ff       	call   de2 <write>
     fd6:	83 c4 0c             	add    $0xc,%esp
     fd9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     fdc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
     fdf:	6a 01                	push   $0x1
     fe1:	50                   	push   %eax
     fe2:	ff 75 08             	pushl  0x8(%ebp)
     fe5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     fe8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
     fea:	e8 f3 fd ff ff       	call   de2 <write>
  for(i = 0; fmt[i]; i++){
     fef:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
     ff3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     ff6:	84 db                	test   %bl,%bl
     ff8:	75 89                	jne    f83 <printf+0x53>
    }
  }
}
     ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ffd:	5b                   	pop    %ebx
     ffe:	5e                   	pop    %esi
     fff:	5f                   	pop    %edi
    1000:	5d                   	pop    %ebp
    1001:	c3                   	ret    
    1002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
    1008:	bf 25 00 00 00       	mov    $0x25,%edi
    100d:	e9 66 ff ff ff       	jmp    f78 <printf+0x48>
    1012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1018:	83 ec 0c             	sub    $0xc,%esp
    101b:	b9 10 00 00 00       	mov    $0x10,%ecx
    1020:	6a 00                	push   $0x0
    1022:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1025:	8b 45 08             	mov    0x8(%ebp),%eax
    1028:	8b 17                	mov    (%edi),%edx
    102a:	e8 61 fe ff ff       	call   e90 <printint>
        ap++;
    102f:	89 f8                	mov    %edi,%eax
    1031:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1034:	31 ff                	xor    %edi,%edi
        ap++;
    1036:	83 c0 04             	add    $0x4,%eax
    1039:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    103c:	e9 37 ff ff ff       	jmp    f78 <printf+0x48>
    1041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1048:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    104b:	8b 08                	mov    (%eax),%ecx
        ap++;
    104d:	83 c0 04             	add    $0x4,%eax
    1050:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    1053:	85 c9                	test   %ecx,%ecx
    1055:	0f 84 8e 00 00 00    	je     10e9 <printf+0x1b9>
        while(*s != 0){
    105b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
    105e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
    1060:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
    1062:	84 c0                	test   %al,%al
    1064:	0f 84 0e ff ff ff    	je     f78 <printf+0x48>
    106a:	89 75 d0             	mov    %esi,-0x30(%ebp)
    106d:	89 de                	mov    %ebx,%esi
    106f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1072:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1075:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1078:	83 ec 04             	sub    $0x4,%esp
          s++;
    107b:	83 c6 01             	add    $0x1,%esi
    107e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    1081:	6a 01                	push   $0x1
    1083:	57                   	push   %edi
    1084:	53                   	push   %ebx
    1085:	e8 58 fd ff ff       	call   de2 <write>
        while(*s != 0){
    108a:	0f b6 06             	movzbl (%esi),%eax
    108d:	83 c4 10             	add    $0x10,%esp
    1090:	84 c0                	test   %al,%al
    1092:	75 e4                	jne    1078 <printf+0x148>
    1094:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    1097:	31 ff                	xor    %edi,%edi
    1099:	e9 da fe ff ff       	jmp    f78 <printf+0x48>
    109e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    10a0:	83 ec 0c             	sub    $0xc,%esp
    10a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    10a8:	6a 01                	push   $0x1
    10aa:	e9 73 ff ff ff       	jmp    1022 <printf+0xf2>
    10af:	90                   	nop
  write(fd, &c, 1);
    10b0:	83 ec 04             	sub    $0x4,%esp
    10b3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    10b6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    10b9:	6a 01                	push   $0x1
    10bb:	e9 21 ff ff ff       	jmp    fe1 <printf+0xb1>
        putc(fd, *ap);
    10c0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    10c3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    10c6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    10c8:	6a 01                	push   $0x1
        ap++;
    10ca:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    10cd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    10d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    10d3:	50                   	push   %eax
    10d4:	ff 75 08             	pushl  0x8(%ebp)
    10d7:	e8 06 fd ff ff       	call   de2 <write>
        ap++;
    10dc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    10df:	83 c4 10             	add    $0x10,%esp
      state = 0;
    10e2:	31 ff                	xor    %edi,%edi
    10e4:	e9 8f fe ff ff       	jmp    f78 <printf+0x48>
          s = "(null)";
    10e9:	bb 04 13 00 00       	mov    $0x1304,%ebx
        while(*s != 0){
    10ee:	b8 28 00 00 00       	mov    $0x28,%eax
    10f3:	e9 72 ff ff ff       	jmp    106a <printf+0x13a>
    10f8:	66 90                	xchg   %ax,%ax
    10fa:	66 90                	xchg   %ax,%ax
    10fc:	66 90                	xchg   %ax,%ax
    10fe:	66 90                	xchg   %ax,%ax

00001100 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1100:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1101:	a1 c4 18 00 00       	mov    0x18c4,%eax
{
    1106:	89 e5                	mov    %esp,%ebp
    1108:	57                   	push   %edi
    1109:	56                   	push   %esi
    110a:	53                   	push   %ebx
    110b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    110e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    1111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1118:	39 c8                	cmp    %ecx,%eax
    111a:	8b 10                	mov    (%eax),%edx
    111c:	73 32                	jae    1150 <free+0x50>
    111e:	39 d1                	cmp    %edx,%ecx
    1120:	72 04                	jb     1126 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1122:	39 d0                	cmp    %edx,%eax
    1124:	72 32                	jb     1158 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1126:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1129:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    112c:	39 fa                	cmp    %edi,%edx
    112e:	74 30                	je     1160 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1130:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1133:	8b 50 04             	mov    0x4(%eax),%edx
    1136:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1139:	39 f1                	cmp    %esi,%ecx
    113b:	74 3a                	je     1177 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    113d:	89 08                	mov    %ecx,(%eax)
  freep = p;
    113f:	a3 c4 18 00 00       	mov    %eax,0x18c4
}
    1144:	5b                   	pop    %ebx
    1145:	5e                   	pop    %esi
    1146:	5f                   	pop    %edi
    1147:	5d                   	pop    %ebp
    1148:	c3                   	ret    
    1149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1150:	39 d0                	cmp    %edx,%eax
    1152:	72 04                	jb     1158 <free+0x58>
    1154:	39 d1                	cmp    %edx,%ecx
    1156:	72 ce                	jb     1126 <free+0x26>
{
    1158:	89 d0                	mov    %edx,%eax
    115a:	eb bc                	jmp    1118 <free+0x18>
    115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1160:	03 72 04             	add    0x4(%edx),%esi
    1163:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1166:	8b 10                	mov    (%eax),%edx
    1168:	8b 12                	mov    (%edx),%edx
    116a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    116d:	8b 50 04             	mov    0x4(%eax),%edx
    1170:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1173:	39 f1                	cmp    %esi,%ecx
    1175:	75 c6                	jne    113d <free+0x3d>
    p->s.size += bp->s.size;
    1177:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    117a:	a3 c4 18 00 00       	mov    %eax,0x18c4
    p->s.size += bp->s.size;
    117f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1182:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1185:	89 10                	mov    %edx,(%eax)
}
    1187:	5b                   	pop    %ebx
    1188:	5e                   	pop    %esi
    1189:	5f                   	pop    %edi
    118a:	5d                   	pop    %ebp
    118b:	c3                   	ret    
    118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001190 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1190:	55                   	push   %ebp
    1191:	89 e5                	mov    %esp,%ebp
    1193:	57                   	push   %edi
    1194:	56                   	push   %esi
    1195:	53                   	push   %ebx
    1196:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1199:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    119c:	8b 15 c4 18 00 00    	mov    0x18c4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11a2:	8d 78 07             	lea    0x7(%eax),%edi
    11a5:	c1 ef 03             	shr    $0x3,%edi
    11a8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    11ab:	85 d2                	test   %edx,%edx
    11ad:	0f 84 9d 00 00 00    	je     1250 <malloc+0xc0>
    11b3:	8b 02                	mov    (%edx),%eax
    11b5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    11b8:	39 cf                	cmp    %ecx,%edi
    11ba:	76 6c                	jbe    1228 <malloc+0x98>
    11bc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    11c2:	bb 00 10 00 00       	mov    $0x1000,%ebx
    11c7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    11ca:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    11d1:	eb 0e                	jmp    11e1 <malloc+0x51>
    11d3:	90                   	nop
    11d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11d8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    11da:	8b 48 04             	mov    0x4(%eax),%ecx
    11dd:	39 f9                	cmp    %edi,%ecx
    11df:	73 47                	jae    1228 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11e1:	39 05 c4 18 00 00    	cmp    %eax,0x18c4
    11e7:	89 c2                	mov    %eax,%edx
    11e9:	75 ed                	jne    11d8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    11eb:	83 ec 0c             	sub    $0xc,%esp
    11ee:	56                   	push   %esi
    11ef:	e8 56 fc ff ff       	call   e4a <sbrk>
  if(p == (char*)-1)
    11f4:	83 c4 10             	add    $0x10,%esp
    11f7:	83 f8 ff             	cmp    $0xffffffff,%eax
    11fa:	74 1c                	je     1218 <malloc+0x88>
  hp->s.size = nu;
    11fc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    11ff:	83 ec 0c             	sub    $0xc,%esp
    1202:	83 c0 08             	add    $0x8,%eax
    1205:	50                   	push   %eax
    1206:	e8 f5 fe ff ff       	call   1100 <free>
  return freep;
    120b:	8b 15 c4 18 00 00    	mov    0x18c4,%edx
      if((p = morecore(nunits)) == 0)
    1211:	83 c4 10             	add    $0x10,%esp
    1214:	85 d2                	test   %edx,%edx
    1216:	75 c0                	jne    11d8 <malloc+0x48>
        return 0;
  }
}
    1218:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    121b:	31 c0                	xor    %eax,%eax
}
    121d:	5b                   	pop    %ebx
    121e:	5e                   	pop    %esi
    121f:	5f                   	pop    %edi
    1220:	5d                   	pop    %ebp
    1221:	c3                   	ret    
    1222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1228:	39 cf                	cmp    %ecx,%edi
    122a:	74 54                	je     1280 <malloc+0xf0>
        p->s.size -= nunits;
    122c:	29 f9                	sub    %edi,%ecx
    122e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1231:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1234:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    1237:	89 15 c4 18 00 00    	mov    %edx,0x18c4
}
    123d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1240:	83 c0 08             	add    $0x8,%eax
}
    1243:	5b                   	pop    %ebx
    1244:	5e                   	pop    %esi
    1245:	5f                   	pop    %edi
    1246:	5d                   	pop    %ebp
    1247:	c3                   	ret    
    1248:	90                   	nop
    1249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    1250:	c7 05 c4 18 00 00 c8 	movl   $0x18c8,0x18c4
    1257:	18 00 00 
    125a:	c7 05 c8 18 00 00 c8 	movl   $0x18c8,0x18c8
    1261:	18 00 00 
    base.s.size = 0;
    1264:	b8 c8 18 00 00       	mov    $0x18c8,%eax
    1269:	c7 05 cc 18 00 00 00 	movl   $0x0,0x18cc
    1270:	00 00 00 
    1273:	e9 44 ff ff ff       	jmp    11bc <malloc+0x2c>
    1278:	90                   	nop
    1279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    1280:	8b 08                	mov    (%eax),%ecx
    1282:	89 0a                	mov    %ecx,(%edx)
    1284:	eb b1                	jmp    1237 <malloc+0xa7>
