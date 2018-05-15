
_scsh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  if (buf[0] == 0) // EOF
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
      13:	e8 22 0e 00 00       	call   e3a <getsharem>
  sh->nfunc = 0;
  sh->top = (char *)sh + sizeof(struct shared);
      18:	8d 90 b8 04 00 00    	lea    0x4b8(%eax),%edx
  sh->nfunc = 0;
      1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  // Ensure that three file descriptors are open.
  while ((fd = open("console", O_RDWR)) >= 0) {
      24:	83 c4 10             	add    $0x10,%esp
  sh->top = (char *)sh + sizeof(struct shared);
      27:	89 90 b4 04 00 00    	mov    %edx,0x4b4(%eax)
  while ((fd = open("console", O_RDWR)) >= 0) {
      2d:	eb 06                	jmp    35 <main+0x35>
      2f:	90                   	nop
    if (fd >= 3) {
      30:	83 f8 02             	cmp    $0x2,%eax
      33:	7f 7a                	jg     af <main+0xaf>
  while ((fd = open("console", O_RDWR)) >= 0) {
      35:	83 ec 08             	sub    $0x8,%esp
      38:	6a 02                	push   $0x2
      3a:	68 70 12 00 00       	push   $0x1270
      3f:	e8 8e 0d 00 00       	call   dd2 <open>
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
      50:	80 3d 62 18 00 00 20 	cmpb   $0x20,0x1862
      57:	0f 84 94 00 00 00    	je     f1 <main+0xf1>
}

int fork1(void) {
  int pid;

  pid = fork();
      5d:	e8 28 0d 00 00       	call   d8a <fork>
  if (pid == -1)
      62:	83 f8 ff             	cmp    $0xffffffff,%eax
      65:	74 3b                	je     a2 <main+0xa2>
    if (fork1() == 0) {
      67:	85 c0                	test   %eax,%eax
      69:	74 57                	je     c2 <main+0xc2>
    wait();
      6b:	e8 2a 0d 00 00       	call   d9a <wait>
  while (getcmd(buf, sizeof(buf)) >= 0) {
      70:	83 ec 08             	sub    $0x8,%esp
      73:	6a 64                	push   $0x64
      75:	68 60 18 00 00       	push   $0x1860
      7a:	e8 a1 02 00 00       	call   320 <getcmd>
      7f:	83 c4 10             	add    $0x10,%esp
      82:	85 c0                	test   %eax,%eax
      84:	78 37                	js     bd <main+0xbd>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      86:	80 3d 60 18 00 00 63 	cmpb   $0x63,0x1860
      8d:	75 ce                	jne    5d <main+0x5d>
      8f:	80 3d 61 18 00 00 64 	cmpb   $0x64,0x1861
      96:	74 b8                	je     50 <main+0x50>
  pid = fork();
      98:	e8 ed 0c 00 00       	call   d8a <fork>
  if (pid == -1)
      9d:	83 f8 ff             	cmp    $0xffffffff,%eax
      a0:	75 c5                	jne    67 <main+0x67>
    panic("fork");
      a2:	83 ec 0c             	sub    $0xc,%esp
      a5:	68 64 12 00 00       	push   $0x1264
      aa:	e8 c1 02 00 00       	call   370 <panic>
      close(fd);
      af:	83 ec 0c             	sub    $0xc,%esp
      b2:	50                   	push   %eax
      b3:	e8 02 0d 00 00       	call   dba <close>
      break;
      b8:	83 c4 10             	add    $0x10,%esp
      bb:	eb b3                	jmp    70 <main+0x70>
  exit();
      bd:	e8 d0 0c 00 00       	call   d92 <exit>
      struct shared *sh = (struct shared *)getsharem(0);
      c2:	83 ec 0c             	sub    $0xc,%esp
      c5:	6a 00                	push   $0x0
      c7:	e8 6e 0d 00 00       	call   e3a <getsharem>
      printf(2, "nfunc: %d\n", sh->nfunc);
      cc:	83 c4 0c             	add    $0xc,%esp
      cf:	ff 30                	pushl  (%eax)
      d1:	68 ca 12 00 00       	push   $0x12ca
      d6:	6a 02                	push   $0x2
      d8:	e8 13 0e 00 00       	call   ef0 <printf>
      runexp(parseexp(buf));
      dd:	c7 04 24 60 18 00 00 	movl   $0x1860,(%esp)
      e4:	e8 e7 09 00 00       	call   ad0 <parseexp>
      e9:	89 04 24             	mov    %eax,(%esp)
      ec:	e8 9f 02 00 00       	call   390 <runexp>
      buf[strlen(buf) - 1] = 0; // chop \n
      f1:	83 ec 0c             	sub    $0xc,%esp
      f4:	68 60 18 00 00       	push   $0x1860
      f9:	e8 c2 0a 00 00       	call   bc0 <strlen>
      if (chdir(buf + 3) < 0)
      fe:	c7 04 24 63 18 00 00 	movl   $0x1863,(%esp)
      buf[strlen(buf) - 1] = 0; // chop \n
     105:	c6 80 5f 18 00 00 00 	movb   $0x0,0x185f(%eax)
      if (chdir(buf + 3) < 0)
     10c:	e8 f1 0c 00 00       	call   e02 <chdir>
     111:	83 c4 10             	add    $0x10,%esp
     114:	85 c0                	test   %eax,%eax
     116:	0f 89 54 ff ff ff    	jns    70 <main+0x70>
        printf(2, "cannot cd %s\n", buf + 3);
     11c:	50                   	push   %eax
     11d:	68 63 18 00 00       	push   $0x1863
     122:	68 bc 12 00 00       	push   $0x12bc
     127:	6a 02                	push   $0x2
     129:	e8 c2 0d 00 00       	call   ef0 <printf>
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
     197:	e8 d4 09 00 00       	call   b70 <strcmp>
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
     235:	e8 06 09 00 00       	call   b40 <strcpy>
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
     26e:	e8 c7 0b 00 00       	call   e3a <getsharem>
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
     292:	e8 a9 08 00 00       	call   b40 <strcpy>
  fn->argc = argv->length;
     297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     29a:	8b 4f 04             	mov    0x4(%edi),%ecx
     29d:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
  storeexp((struct sexp **)&sh->top, lst->sexps[3]);
     2a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  fn->argc = argv->length;
     2a3:	89 48 74             	mov    %ecx,0x74(%eax)
  struct sexp *st = (struct sexp *)sh->top;
     2a6:	8b 8a b4 04 00 00    	mov    0x4b4(%edx),%ecx
  fn->argc = argv->length;
     2ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  storeexp((struct sexp **)&sh->top, lst->sexps[3]);
     2af:	58                   	pop    %eax
  struct sexp *st = (struct sexp *)sh->top;
     2b0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  storeexp((struct sexp **)&sh->top, lst->sexps[3]);
     2b3:	59                   	pop    %ecx
     2b4:	ff 76 14             	pushl  0x14(%esi)
     2b7:	8d b2 b4 04 00 00    	lea    0x4b4(%edx),%esi
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
     2f9:	e8 42 08 00 00       	call   b40 <strcpy>
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
     32e:	68 48 12 00 00       	push   $0x1248
     333:	6a 02                	push   $0x2
     335:	e8 b6 0b 00 00       	call   ef0 <printf>
  memset(buf, 0, nbuf);
     33a:	83 c4 0c             	add    $0xc,%esp
     33d:	56                   	push   %esi
     33e:	6a 00                	push   $0x0
     340:	53                   	push   %ebx
     341:	e8 aa 08 00 00       	call   bf0 <memset>
  gets(buf, nbuf);
     346:	58                   	pop    %eax
     347:	5a                   	pop    %edx
     348:	56                   	push   %esi
     349:	53                   	push   %ebx
     34a:	e8 01 09 00 00       	call   c50 <gets>
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
     379:	68 92 12 00 00       	push   $0x1292
     37e:	6a 02                	push   $0x2
     380:	e8 6b 0b 00 00       	call   ef0 <printf>
  exit();
     385:	e8 08 0a 00 00       	call   d92 <exit>
     38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000390 <runexp>:
void runexp(struct sexp *exp) {
     390:	55                   	push   %ebp
     391:	89 e5                	mov    %esp,%ebp
     393:	57                   	push   %edi
     394:	56                   	push   %esi
     395:	53                   	push   %ebx
     396:	81 ec ac 00 00 00    	sub    $0xac,%esp
     39c:	8b 75 08             	mov    0x8(%ebp),%esi
  if (exp == 0)
     39f:	85 f6                	test   %esi,%esi
     3a1:	0f 84 89 00 00 00    	je     430 <runexp+0xa0>
  switch (exp->type) {
     3a7:	8b 06                	mov    (%esi),%eax
     3a9:	83 f8 02             	cmp    $0x2,%eax
     3ac:	74 22                	je     3d0 <runexp+0x40>
     3ae:	83 f8 03             	cmp    $0x3,%eax
     3b1:	0f 84 7e 00 00 00    	je     435 <runexp+0xa5>
     3b7:	83 e8 01             	sub    $0x1,%eax
     3ba:	74 74                	je     430 <runexp+0xa0>
    panic("runexp type error");
     3bc:	83 ec 0c             	sub    $0xc,%esp
     3bf:	68 4b 12 00 00       	push   $0x124b
     3c4:	e8 a7 ff ff ff       	call   370 <panic>
     3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < lst->length; i++)
     3d0:	8b 46 04             	mov    0x4(%esi),%eax
     3d3:	85 c0                	test   %eax,%eax
     3d5:	7e 59                	jle    430 <runexp+0xa0>
      runexp(lst->sexps[i]);
     3d7:	83 ec 0c             	sub    $0xc,%esp
     3da:	ff 76 08             	pushl  0x8(%esi)
     3dd:	e8 ae ff ff ff       	call   390 <runexp>
     3e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if ((i == 0) && (strcmp(argv[0], "defun") == 0)) {
     3e8:	83 ec 08             	sub    $0x8,%esp
     3eb:	68 78 12 00 00       	push   $0x1278
     3f0:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     3f6:	e8 75 07 00 00       	call   b70 <strcmp>
     3fb:	83 c4 10             	add    $0x10,%esp
     3fe:	85 c0                	test   %eax,%eax
     400:	75 6c                	jne    46e <runexp+0xde>
  pid = fork();
     402:	e8 83 09 00 00       	call   d8a <fork>
  if (pid == -1)
     407:	83 f8 ff             	cmp    $0xffffffff,%eax
     40a:	0f 84 5b 03 00 00    	je     76b <runexp+0x3db>
        if (fork1() == 0) {
     410:	85 c0                	test   %eax,%eax
     412:	75 15                	jne    429 <runexp+0x99>
          if (argv[0] == 0)
     414:	83 bd 5c ff ff ff 00 	cmpl   $0x0,-0xa4(%ebp)
     41b:	74 13                	je     430 <runexp+0xa0>
          defunc(lst);
     41d:	83 ec 0c             	sub    $0xc,%esp
     420:	56                   	push   %esi
     421:	e8 3a fe ff ff       	call   260 <defunc>
     426:	83 c4 10             	add    $0x10,%esp
        wait();
     429:	e8 6c 09 00 00       	call   d9a <wait>
     42e:	66 90                	xchg   %ax,%ax
  exit();
     430:	e8 5d 09 00 00       	call   d92 <exit>
    argv[lst->length] = 0;
     435:	8b 46 04             	mov    0x4(%esi),%eax
    for (i = 0; i < lst->length; i++) {
     438:	85 c0                	test   %eax,%eax
    argv[lst->length] = 0;
     43a:	c7 84 85 5c ff ff ff 	movl   $0x0,-0xa4(%ebp,%eax,4)
     441:	00 00 00 00 
    for (i = 0; i < lst->length; i++) {
     445:	7e e9                	jle    430 <runexp+0xa0>
  int i, bufs = 0;
     447:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
     44e:	00 00 00 
    for (i = 0; i < lst->length; i++) {
     451:	31 db                	xor    %ebx,%ebx
     453:	eb 2e                	jmp    483 <runexp+0xf3>
     455:	8d 76 00             	lea    0x0(%esi),%esi
      else if (lst->sexps[i]->type == LIST)
     458:	83 f8 02             	cmp    $0x2,%eax
     45b:	0f 84 ca 02 00 00    	je     72b <runexp+0x39b>
      else if (lst->sexps[i]->type == APPLY) {
     461:	83 f8 03             	cmp    $0x3,%eax
     464:	74 34                	je     49a <runexp+0x10a>
      if ((i == 0) && (strcmp(argv[0], "defun") == 0)) {
     466:	85 db                	test   %ebx,%ebx
     468:	0f 84 7a ff ff ff    	je     3e8 <runexp+0x58>
      if (i == lst->length - 1) {
     46e:	8b 46 04             	mov    0x4(%esi),%eax
     471:	8d 50 ff             	lea    -0x1(%eax),%edx
     474:	39 da                	cmp    %ebx,%edx
     476:	0f 84 e8 00 00 00    	je     564 <runexp+0x1d4>
    for (i = 0; i < lst->length; i++) {
     47c:	83 c3 01             	add    $0x1,%ebx
     47f:	39 c3                	cmp    %eax,%ebx
     481:	7d ad                	jge    430 <runexp+0xa0>
      if (lst->sexps[i]->type == ATOM)
     483:	8b 54 9e 08          	mov    0x8(%esi,%ebx,4),%edx
     487:	8b 02                	mov    (%edx),%eax
     489:	83 f8 01             	cmp    $0x1,%eax
     48c:	75 ca                	jne    458 <runexp+0xc8>
        argv[i] = ((struct atom *)lst->sexps[i])->symbol;
     48e:	8b 42 04             	mov    0x4(%edx),%eax
     491:	89 84 9d 5c ff ff ff 	mov    %eax,-0xa4(%ebp,%ebx,4)
     498:	eb cc                	jmp    466 <runexp+0xd6>
  pid = fork();
     49a:	e8 eb 08 00 00       	call   d8a <fork>
  if (pid == -1)
     49f:	83 f8 ff             	cmp    $0xffffffff,%eax
     4a2:	0f 84 c3 02 00 00    	je     76b <runexp+0x3db>
        if (fork1() == 0) {
     4a8:	85 c0                	test   %eax,%eax
     4aa:	75 32                	jne    4de <runexp+0x14e>
          close(1);
     4ac:	83 ec 0c             	sub    $0xc,%esp
     4af:	6a 01                	push   $0x1
     4b1:	e8 04 09 00 00       	call   dba <close>
          if (open(".etemp", O_WRONLY | O_CREATE) < 0) {
     4b6:	5f                   	pop    %edi
     4b7:	58                   	pop    %eax
     4b8:	68 01 02 00 00       	push   $0x201
     4bd:	68 69 12 00 00       	push   $0x1269
     4c2:	e8 0b 09 00 00       	call   dd2 <open>
     4c7:	83 c4 10             	add    $0x10,%esp
     4ca:	85 c0                	test   %eax,%eax
     4cc:	0f 88 b9 02 00 00    	js     78b <runexp+0x3fb>
          runexp(lst->sexps[i]);
     4d2:	83 ec 0c             	sub    $0xc,%esp
     4d5:	ff 74 9e 08          	pushl  0x8(%esi,%ebx,4)
     4d9:	e8 b2 fe ff ff       	call   390 <runexp>
        wait();
     4de:	e8 b7 08 00 00       	call   d9a <wait>
        close(2);
     4e3:	83 ec 0c             	sub    $0xc,%esp
     4e6:	6a 02                	push   $0x2
     4e8:	e8 cd 08 00 00       	call   dba <close>
        if ((ffd = open(".etemp", O_RDONLY)) < 0) {
     4ed:	58                   	pop    %eax
     4ee:	5a                   	pop    %edx
     4ef:	6a 00                	push   $0x0
     4f1:	68 69 12 00 00       	push   $0x1269
     4f6:	e8 d7 08 00 00       	call   dd2 <open>
     4fb:	83 c4 10             	add    $0x10,%esp
     4fe:	85 c0                	test   %eax,%eax
     500:	0f 88 72 02 00 00    	js     778 <runexp+0x3e8>
        argv[i] = argvbuf + bufs;
     506:	8b bd 50 ff ff ff    	mov    -0xb0(%ebp),%edi
        bufs += read(2, argvbuf + bufs, 20);
     50c:	52                   	push   %edx
     50d:	6a 14                	push   $0x14
        argv[i] = argvbuf + bufs;
     50f:	8d 87 e0 18 00 00    	lea    0x18e0(%edi),%eax
        bufs += read(2, argvbuf + bufs, 20);
     515:	50                   	push   %eax
     516:	6a 02                	push   $0x2
        argv[i] = argvbuf + bufs;
     518:	89 84 9d 5c ff ff ff 	mov    %eax,-0xa4(%ebp,%ebx,4)
        bufs += read(2, argvbuf + bufs, 20);
     51f:	e8 86 08 00 00       	call   daa <read>
     524:	01 f8                	add    %edi,%eax
        close(2);
     526:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
        argvbuf[bufs++] = 0;
     52d:	8d 48 01             	lea    0x1(%eax),%ecx
     530:	c6 80 e0 18 00 00 00 	movb   $0x0,0x18e0(%eax)
     537:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
        close(2);
     53d:	e8 78 08 00 00       	call   dba <close>
        unlink(".etemp");
     542:	c7 04 24 69 12 00 00 	movl   $0x1269,(%esp)
     549:	e8 94 08 00 00       	call   de2 <unlink>
        open("console", O_RDWR);
     54e:	59                   	pop    %ecx
     54f:	5f                   	pop    %edi
     550:	6a 02                	push   $0x2
     552:	68 70 12 00 00       	push   $0x1270
     557:	e8 76 08 00 00       	call   dd2 <open>
     55c:	83 c4 10             	add    $0x10,%esp
     55f:	e9 02 ff ff ff       	jmp    466 <runexp+0xd6>
        printf(2, "exec %s\n", argv[0]);
     564:	50                   	push   %eax
     565:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
        struct shared *sh = (struct shared *)getsharem(0);
     56b:	31 ff                	xor    %edi,%edi
        printf(2, "exec %s\n", argv[0]);
     56d:	68 7e 12 00 00       	push   $0x127e
     572:	6a 02                	push   $0x2
     574:	e8 77 09 00 00       	call   ef0 <printf>
        struct shared *sh = (struct shared *)getsharem(0);
     579:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     580:	e8 b5 08 00 00       	call   e3a <getsharem>
     585:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
     58b:	83 c0 04             	add    $0x4,%eax
     58e:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
     594:	89 75 08             	mov    %esi,0x8(%ebp)
     597:	83 c4 10             	add    $0x10,%esp
     59a:	89 fb                	mov    %edi,%ebx
     59c:	89 c6                	mov    %eax,%esi
     59e:	66 90                	xchg   %ax,%ax
          if (strcmp(argv[0], sh->funcs[j].name) == 0) {
     5a0:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
     5a3:	83 ec 08             	sub    $0x8,%esp
     5a6:	50                   	push   %eax
     5a7:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     5ad:	e8 be 05 00 00       	call   b70 <strcmp>
     5b2:	83 c4 10             	add    $0x10,%esp
     5b5:	85 c0                	test   %eax,%eax
     5b7:	0f 84 e6 00 00 00    	je     6a3 <runexp+0x313>
        for (j = 0; j < MAXFUNC; j++) {
     5bd:	83 c7 01             	add    $0x1,%edi
     5c0:	83 c3 78             	add    $0x78,%ebx
     5c3:	83 ff 0a             	cmp    $0xa,%edi
     5c6:	75 d8                	jne    5a0 <runexp+0x210>
     5c8:	8b 9d 54 ff ff ff    	mov    -0xac(%ebp),%ebx
     5ce:	8b 75 08             	mov    0x8(%ebp),%esi
     5d1:	89 bd 48 ff ff ff    	mov    %edi,-0xb8(%ebp)
        int j, k, flg = 0;
     5d7:	31 ff                	xor    %edi,%edi
  pid = fork();
     5d9:	e8 ac 07 00 00       	call   d8a <fork>
  if (pid == -1)
     5de:	83 f8 ff             	cmp    $0xffffffff,%eax
     5e1:	0f 84 84 01 00 00    	je     76b <runexp+0x3db>
        if (fork1() == 0) {
     5e7:	85 c0                	test   %eax,%eax
     5e9:	0f 85 a7 00 00 00    	jne    696 <runexp+0x306>
          if (argv[0] == 0)
     5ef:	83 bd 5c ff ff ff 00 	cmpl   $0x0,-0xa4(%ebp)
     5f6:	0f 84 34 fe ff ff    	je     430 <runexp+0xa0>
          if (flg == 1) {
     5fc:	83 ef 01             	sub    $0x1,%edi
     5ff:	0f 84 33 01 00 00    	je     738 <runexp+0x3a8>
            getsharem(0);
     605:	83 ec 0c             	sub    $0xc,%esp
     608:	8d 7d 84             	lea    -0x7c(%ebp),%edi
     60b:	6a 00                	push   $0x0
     60d:	e8 28 08 00 00       	call   e3a <getsharem>
            printf(2, "argv: %s\n", argv[1]);
     612:	83 c4 0c             	add    $0xc,%esp
     615:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
     61b:	68 96 12 00 00       	push   $0x1296
     620:	6a 02                	push   $0x2
     622:	e8 c9 08 00 00       	call   ef0 <printf>
            printf(2, "coming~: %s\n", argv[0]);
     627:	83 c4 0c             	add    $0xc,%esp
     62a:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     630:	68 a0 12 00 00       	push   $0x12a0
     635:	6a 02                	push   $0x2
     637:	e8 b4 08 00 00       	call   ef0 <printf>
     63c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
     642:	89 9d 4c ff ff ff    	mov    %ebx,-0xb4(%ebp)
     648:	83 c4 10             	add    $0x10,%esp
     64b:	89 fb                	mov    %edi,%ebx
     64d:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
     653:	89 c7                	mov    %eax,%edi
     655:	8d 76 00             	lea    0x0(%esi),%esi
              if (argv[j] == 0)
     658:	8b 07                	mov    (%edi),%eax
     65a:	85 c0                	test   %eax,%eax
     65c:	74 1c                	je     67a <runexp+0x2ea>
              strcpy(xargv[j], argv[j]);
     65e:	52                   	push   %edx
     65f:	52                   	push   %edx
     660:	83 c7 04             	add    $0x4,%edi
     663:	50                   	push   %eax
     664:	53                   	push   %ebx
     665:	e8 d6 04 00 00       	call   b40 <strcpy>
            for (j = 0; j < MAXARGS; j++) {
     66a:	8d 45 84             	lea    -0x7c(%ebp),%eax
              argv[j] = xargv[j];
     66d:	89 5f fc             	mov    %ebx,-0x4(%edi)
            for (j = 0; j < MAXARGS; j++) {
     670:	83 c4 10             	add    $0x10,%esp
     673:	83 c3 0a             	add    $0xa,%ebx
     676:	39 f8                	cmp    %edi,%eax
     678:	75 de                	jne    658 <runexp+0x2c8>
            exec(argv[0], argv);
     67a:	50                   	push   %eax
     67b:	50                   	push   %eax
     67c:	ff b5 54 ff ff ff    	pushl  -0xac(%ebp)
     682:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     688:	8b 9d 4c ff ff ff    	mov    -0xb4(%ebp),%ebx
     68e:	e8 37 07 00 00       	call   dca <exec>
     693:	83 c4 10             	add    $0x10,%esp
        wait();
     696:	e8 ff 06 00 00       	call   d9a <wait>
     69b:	8b 46 04             	mov    0x4(%esi),%eax
     69e:	e9 d9 fd ff ff       	jmp    47c <runexp+0xec>
     6a3:	89 f9                	mov    %edi,%ecx
     6a5:	89 bd 48 ff ff ff    	mov    %edi,-0xb8(%ebp)
     6ab:	8b 75 08             	mov    0x8(%ebp),%esi
            for (k = 0; k < sh->funcs[j].argc; k++)
     6ae:	6b c9 78             	imul   $0x78,%ecx,%ecx
     6b1:	03 8d 4c ff ff ff    	add    -0xb4(%ebp),%ecx
     6b7:	89 df                	mov    %ebx,%edi
     6b9:	8b 9d 54 ff ff ff    	mov    -0xac(%ebp),%ebx
     6bf:	89 ca                	mov    %ecx,%edx
     6c1:	8b 49 74             	mov    0x74(%ecx),%ecx
     6c4:	85 c9                	test   %ecx,%ecx
     6c6:	7e 4e                	jle    716 <runexp+0x386>
     6c8:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
              replaceAtom(sh->funcs[j].sexp, sh->funcs[j].argv[k], argv[k + 1]);
     6ce:	89 9d 4c ff ff ff    	mov    %ebx,-0xb4(%ebp)
     6d4:	89 c3                	mov    %eax,%ebx
     6d6:	8d 7c 39 0e          	lea    0xe(%ecx,%edi,1),%edi
     6da:	8d 8d 5c ff ff ff    	lea    -0xa4(%ebp),%ecx
     6e0:	89 fe                	mov    %edi,%esi
     6e2:	89 8d 54 ff ff ff    	mov    %ecx,-0xac(%ebp)
     6e8:	89 d7                	mov    %edx,%edi
     6ea:	50                   	push   %eax
     6eb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
     6f1:	83 c3 01             	add    $0x1,%ebx
     6f4:	ff 34 98             	pushl  (%eax,%ebx,4)
     6f7:	56                   	push   %esi
     6f8:	83 c6 0a             	add    $0xa,%esi
     6fb:	ff 77 78             	pushl  0x78(%edi)
     6fe:	e8 3d fa ff ff       	call   140 <replaceAtom>
            for (k = 0; k < sh->funcs[j].argc; k++)
     703:	8b 4f 74             	mov    0x74(%edi),%ecx
     706:	83 c4 10             	add    $0x10,%esp
     709:	39 cb                	cmp    %ecx,%ebx
     70b:	7c dd                	jl     6ea <runexp+0x35a>
     70d:	8b 9d 4c ff ff ff    	mov    -0xb4(%ebp),%ebx
     713:	8b 75 08             	mov    0x8(%ebp),%esi
            argv[sh->funcs[j].argc] = 0;
     716:	c7 84 8d 5c ff ff ff 	movl   $0x0,-0xa4(%ebp,%ecx,4)
     71d:	00 00 00 00 
            flg = 1;
     721:	bf 01 00 00 00       	mov    $0x1,%edi
            break;
     726:	e9 ae fe ff ff       	jmp    5d9 <runexp+0x249>
        panic("syntax");
     72b:	83 ec 0c             	sub    $0xc,%esp
     72e:	68 5d 12 00 00       	push   $0x125d
     733:	e8 38 fc ff ff       	call   370 <panic>
     738:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
            struct shared *sh = (struct shared *)getsharem(0);
     73e:	83 ec 0c             	sub    $0xc,%esp
     741:	6a 00                	push   $0x0
            printf(2, "exec func: %s\n", sh->funcs[j].name);
     743:	6b df 78             	imul   $0x78,%edi,%ebx
            struct shared *sh = (struct shared *)getsharem(0);
     746:	e8 ef 06 00 00       	call   e3a <getsharem>
     74b:	89 c6                	mov    %eax,%esi
            printf(2, "exec func: %s\n", sh->funcs[j].name);
     74d:	83 c4 0c             	add    $0xc,%esp
     750:	8d 44 18 04          	lea    0x4(%eax,%ebx,1),%eax
     754:	50                   	push   %eax
     755:	68 87 12 00 00       	push   $0x1287
     75a:	6a 02                	push   $0x2
     75c:	e8 8f 07 00 00       	call   ef0 <printf>
            runexp(sh->funcs[j].sexp);
     761:	59                   	pop    %ecx
     762:	ff 74 1e 78          	pushl  0x78(%esi,%ebx,1)
     766:	e8 25 fc ff ff       	call   390 <runexp>
    panic("fork");
     76b:	83 ec 0c             	sub    $0xc,%esp
     76e:	68 64 12 00 00       	push   $0x1264
     773:	e8 f8 fb ff ff       	call   370 <panic>
          printf(1, "open console temp file failed\n");
     778:	50                   	push   %eax
     779:	50                   	push   %eax
     77a:	68 d8 12 00 00       	push   $0x12d8
     77f:	6a 01                	push   $0x1
     781:	e8 6a 07 00 00       	call   ef0 <printf>
          exit();
     786:	e8 07 06 00 00       	call   d92 <exit>
            printf(2, "open console temp file failed\n");
     78b:	51                   	push   %ecx
     78c:	51                   	push   %ecx
     78d:	68 d8 12 00 00       	push   $0x12d8
     792:	6a 02                	push   $0x2
     794:	e8 57 07 00 00       	call   ef0 <printf>
            exit();
     799:	e8 f4 05 00 00       	call   d92 <exit>
     79e:	66 90                	xchg   %ax,%ax

000007a0 <fork1>:
int fork1(void) {
     7a0:	55                   	push   %ebp
     7a1:	89 e5                	mov    %esp,%ebp
     7a3:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     7a6:	e8 df 05 00 00       	call   d8a <fork>
  if (pid == -1)
     7ab:	83 f8 ff             	cmp    $0xffffffff,%eax
     7ae:	74 02                	je     7b2 <fork1+0x12>
  return pid;
}
     7b0:	c9                   	leave  
     7b1:	c3                   	ret    
    panic("fork");
     7b2:	83 ec 0c             	sub    $0xc,%esp
     7b5:	68 64 12 00 00       	push   $0x1264
     7ba:	e8 b1 fb ff ff       	call   370 <panic>
     7bf:	90                   	nop

000007c0 <atom>:

// PAGEBREAK!
// Constructors

struct sexp *atom(void) {
     7c0:	55                   	push   %ebp
     7c1:	89 e5                	mov    %esp,%ebp
     7c3:	53                   	push   %ebx
     7c4:	83 ec 10             	sub    $0x10,%esp
  struct atom *exp;

  exp = malloc(sizeof(*exp));
     7c7:	6a 0c                	push   $0xc
     7c9:	e8 82 09 00 00       	call   1150 <malloc>
  memset(exp, 0, sizeof(*exp));
     7ce:	83 c4 0c             	add    $0xc,%esp
  exp = malloc(sizeof(*exp));
     7d1:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     7d3:	6a 0c                	push   $0xc
     7d5:	6a 00                	push   $0x0
     7d7:	50                   	push   %eax
     7d8:	e8 13 04 00 00       	call   bf0 <memset>
  return (struct sexp *)exp;
}
     7dd:	89 d8                	mov    %ebx,%eax
     7df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7e2:	c9                   	leave  
     7e3:	c3                   	ret    
     7e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     7ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000007f0 <list>:

struct sexp *list(void) {
     7f0:	55                   	push   %ebp
     7f1:	89 e5                	mov    %esp,%ebp
     7f3:	53                   	push   %ebx
     7f4:	83 ec 10             	sub    $0x10,%esp
  struct list *exp;

  exp = malloc(sizeof(*exp));
     7f7:	6a 30                	push   $0x30
     7f9:	e8 52 09 00 00       	call   1150 <malloc>
  memset(exp, 0, sizeof(*exp));
     7fe:	83 c4 0c             	add    $0xc,%esp
  exp = malloc(sizeof(*exp));
     801:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     803:	6a 30                	push   $0x30
     805:	6a 00                	push   $0x0
     807:	50                   	push   %eax
     808:	e8 e3 03 00 00       	call   bf0 <memset>
  return (struct sexp *)exp;
}
     80d:	89 d8                	mov    %ebx,%eax
     80f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     812:	c9                   	leave  
     813:	c3                   	ret    
     814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     81a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000820 <peek>:
// Parsing

char whitespace[] = " \t\r\n\v";
char esymbols[] = "()";

int peek(char **ps, char *es, char *toks) {
     820:	55                   	push   %ebp
     821:	89 e5                	mov    %esp,%ebp
     823:	57                   	push   %edi
     824:	56                   	push   %esi
     825:	53                   	push   %ebx
     826:	83 ec 0c             	sub    $0xc,%esp
     829:	8b 7d 08             	mov    0x8(%ebp),%edi
     82c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     82f:	8b 1f                	mov    (%edi),%ebx
  while (s < es && strchr(whitespace, *s))
     831:	39 f3                	cmp    %esi,%ebx
     833:	72 12                	jb     847 <peek+0x27>
     835:	eb 28                	jmp    85f <peek+0x3f>
     837:	89 f6                	mov    %esi,%esi
     839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
     840:	83 c3 01             	add    $0x1,%ebx
  while (s < es && strchr(whitespace, *s))
     843:	39 de                	cmp    %ebx,%esi
     845:	74 18                	je     85f <peek+0x3f>
     847:	0f be 03             	movsbl (%ebx),%eax
     84a:	83 ec 08             	sub    $0x8,%esp
     84d:	50                   	push   %eax
     84e:	68 3c 18 00 00       	push   $0x183c
     853:	e8 b8 03 00 00       	call   c10 <strchr>
     858:	83 c4 10             	add    $0x10,%esp
     85b:	85 c0                	test   %eax,%eax
     85d:	75 e1                	jne    840 <peek+0x20>
  *ps = s;
     85f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     861:	0f be 13             	movsbl (%ebx),%edx
     864:	31 c0                	xor    %eax,%eax
     866:	84 d2                	test   %dl,%dl
     868:	74 17                	je     881 <peek+0x61>
     86a:	83 ec 08             	sub    $0x8,%esp
     86d:	52                   	push   %edx
     86e:	ff 75 10             	pushl  0x10(%ebp)
     871:	e8 9a 03 00 00       	call   c10 <strchr>
     876:	83 c4 10             	add    $0x10,%esp
     879:	85 c0                	test   %eax,%eax
     87b:	0f 95 c0             	setne  %al
     87e:	0f b6 c0             	movzbl %al,%eax
}
     881:	8d 65 f4             	lea    -0xc(%ebp),%esp
     884:	5b                   	pop    %ebx
     885:	5e                   	pop    %esi
     886:	5f                   	pop    %edi
     887:	5d                   	pop    %ebp
     888:	c3                   	ret    
     889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000890 <parseatom>:
  lst->length = i;

  return ret;
}

struct sexp *parseatom(char **ps, char *es) {
     890:	55                   	push   %ebp
     891:	89 e5                	mov    %esp,%ebp
     893:	57                   	push   %edi
     894:	56                   	push   %esi
     895:	53                   	push   %ebx
     896:	83 ec 0c             	sub    $0xc,%esp
     899:	8b 7d 08             	mov    0x8(%ebp),%edi
     89c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct atom *atm;
  struct sexp *ret;

  char *s = *ps;
     89f:	8b 37                	mov    (%edi),%esi
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     8a1:	39 de                	cmp    %ebx,%esi
     8a3:	89 f0                	mov    %esi,%eax
     8a5:	72 2e                	jb     8d5 <parseatom+0x45>
     8a7:	eb 44                	jmp    8ed <parseatom+0x5d>
     8a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
         !strchr(esymbols, *(*ps))) // peek whitespace
     8b0:	8b 07                	mov    (%edi),%eax
     8b2:	83 ec 08             	sub    $0x8,%esp
     8b5:	0f be 00             	movsbl (%eax),%eax
     8b8:	50                   	push   %eax
     8b9:	68 38 18 00 00       	push   $0x1838
     8be:	e8 4d 03 00 00       	call   c10 <strchr>
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     8c3:	83 c4 10             	add    $0x10,%esp
     8c6:	85 c0                	test   %eax,%eax
     8c8:	75 23                	jne    8ed <parseatom+0x5d>
    (*ps)++;
     8ca:	8b 07                	mov    (%edi),%eax
     8cc:	83 c0 01             	add    $0x1,%eax
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     8cf:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
     8d1:	89 07                	mov    %eax,(%edi)
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     8d3:	73 18                	jae    8ed <parseatom+0x5d>
     8d5:	0f be 00             	movsbl (%eax),%eax
     8d8:	83 ec 08             	sub    $0x8,%esp
     8db:	50                   	push   %eax
     8dc:	68 3c 18 00 00       	push   $0x183c
     8e1:	e8 2a 03 00 00       	call   c10 <strchr>
     8e6:	83 c4 10             	add    $0x10,%esp
     8e9:	85 c0                	test   %eax,%eax
     8eb:	74 c3                	je     8b0 <parseatom+0x20>

  ret = atom();
     8ed:	e8 ce fe ff ff       	call   7c0 <atom>
  atm = (struct atom *)ret;

  atm->type = ATOM;
     8f2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  atm->symbol = s;
     8f8:	89 70 04             	mov    %esi,0x4(%eax)
  atm->esymbol = *ps;
     8fb:	8b 17                	mov    (%edi),%edx
     8fd:	89 50 08             	mov    %edx,0x8(%eax)

  return ret;
}
     900:	8d 65 f4             	lea    -0xc(%ebp),%esp
     903:	5b                   	pop    %ebx
     904:	5e                   	pop    %esi
     905:	5f                   	pop    %edi
     906:	5d                   	pop    %ebp
     907:	c3                   	ret    
     908:	90                   	nop
     909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000910 <parsesexp>:

struct sexp *parsesexp(char **ps, char *es) {
     910:	55                   	push   %ebp
     911:	89 e5                	mov    %esp,%ebp
     913:	56                   	push   %esi
     914:	53                   	push   %ebx
     915:	8b 75 08             	mov    0x8(%ebp),%esi
     918:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct sexp *ret = 0;

  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     91b:	8b 06                	mov    (%esi),%eax
     91d:	39 c3                	cmp    %eax,%ebx
     91f:	77 10                	ja     931 <parsesexp+0x21>
     921:	eb 28                	jmp    94b <parsesexp+0x3b>
     923:	90                   	nop
     924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    (*ps)++;
     928:	83 c0 01             	add    $0x1,%eax
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     92b:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
     92d:	89 06                	mov    %eax,(%esi)
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     92f:	73 1a                	jae    94b <parsesexp+0x3b>
     931:	0f be 00             	movsbl (%eax),%eax
     934:	83 ec 08             	sub    $0x8,%esp
     937:	50                   	push   %eax
     938:	68 3c 18 00 00       	push   $0x183c
     93d:	e8 ce 02 00 00       	call   c10 <strchr>
     942:	83 c4 10             	add    $0x10,%esp
     945:	85 c0                	test   %eax,%eax
    (*ps)++;
     947:	8b 06                	mov    (%esi),%eax
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     949:	75 dd                	jne    928 <parsesexp+0x18>
  switch (*(*ps)) {
     94b:	0f b6 10             	movzbl (%eax),%edx
     94e:	80 fa 27             	cmp    $0x27,%dl
     951:	74 55                	je     9a8 <parsesexp+0x98>
     953:	80 fa 28             	cmp    $0x28,%dl
     956:	74 28                	je     980 <parsesexp+0x70>
     958:	84 d2                	test   %dl,%dl
     95a:	74 14                	je     970 <parsesexp+0x60>
    (*ps) += 2;
    ret = parselist(ps, es);
    (*ps)++;
    break;
  default:
    ret = parseatom(ps, es);
     95c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
     95f:	89 75 08             	mov    %esi,0x8(%ebp)
    break;
  }
  return ret;
}
     962:	8d 65 f8             	lea    -0x8(%ebp),%esp
     965:	5b                   	pop    %ebx
     966:	5e                   	pop    %esi
     967:	5d                   	pop    %ebp
    ret = parseatom(ps, es);
     968:	e9 23 ff ff ff       	jmp    890 <parseatom>
     96d:	8d 76 00             	lea    0x0(%esi),%esi
}
     970:	8d 65 f8             	lea    -0x8(%ebp),%esp
  struct sexp *ret = 0;
     973:	31 c0                	xor    %eax,%eax
}
     975:	5b                   	pop    %ebx
     976:	5e                   	pop    %esi
     977:	5d                   	pop    %ebp
     978:	c3                   	ret    
     979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret = parselist(ps, es);
     980:	83 ec 08             	sub    $0x8,%esp
    (*ps)++;
     983:	83 c0 01             	add    $0x1,%eax
     986:	89 06                	mov    %eax,(%esi)
    ret = parselist(ps, es);
     988:	53                   	push   %ebx
     989:	56                   	push   %esi
     98a:	e8 41 00 00 00       	call   9d0 <parselist>
    ret->type = APPLY;
     98f:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    break;
     995:	83 c4 10             	add    $0x10,%esp
    (*ps)++;
     998:	83 06 01             	addl   $0x1,(%esi)
}
     99b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     99e:	5b                   	pop    %ebx
     99f:	5e                   	pop    %esi
     9a0:	5d                   	pop    %ebp
     9a1:	c3                   	ret    
     9a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ret = parselist(ps, es);
     9a8:	83 ec 08             	sub    $0x8,%esp
    (*ps) += 2;
     9ab:	83 c0 02             	add    $0x2,%eax
     9ae:	89 06                	mov    %eax,(%esi)
    ret = parselist(ps, es);
     9b0:	53                   	push   %ebx
     9b1:	56                   	push   %esi
     9b2:	e8 19 00 00 00       	call   9d0 <parselist>
    (*ps)++;
     9b7:	83 06 01             	addl   $0x1,(%esi)
    break;
     9ba:	83 c4 10             	add    $0x10,%esp
}
     9bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
     9c0:	5b                   	pop    %ebx
     9c1:	5e                   	pop    %esi
     9c2:	5d                   	pop    %ebp
     9c3:	c3                   	ret    
     9c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     9ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000009d0 <parselist>:
struct sexp *parselist(char **ps, char *es) {
     9d0:	55                   	push   %ebp
     9d1:	89 e5                	mov    %esp,%ebp
     9d3:	57                   	push   %edi
     9d4:	56                   	push   %esi
     9d5:	53                   	push   %ebx
     9d6:	83 ec 1c             	sub    $0x1c,%esp
     9d9:	8b 75 08             	mov    0x8(%ebp),%esi
     9dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  ret = list();
     9df:	e8 0c fe ff ff       	call   7f0 <list>
  lst->type = LIST;
     9e4:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  ret = list();
     9ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *res = *ps;
     9ed:	8b 0e                	mov    (%esi),%ecx
  while (res < es) {
     9ef:	39 f9                	cmp    %edi,%ecx
     9f1:	89 cb                	mov    %ecx,%ebx
     9f3:	73 3b                	jae    a30 <parselist+0x60>
  int i = 1;
     9f5:	ba 01 00 00 00       	mov    $0x1,%edx
     9fa:	eb 14                	jmp    a10 <parselist+0x40>
     9fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (*res == ')') {
     a00:	3c 29                	cmp    $0x29,%al
     a02:	75 05                	jne    a09 <parselist+0x39>
      if (i == 0) {
     a04:	83 ea 01             	sub    $0x1,%edx
     a07:	74 27                	je     a30 <parselist+0x60>
    res++;
     a09:	83 c3 01             	add    $0x1,%ebx
  while (res < es) {
     a0c:	39 df                	cmp    %ebx,%edi
     a0e:	74 11                	je     a21 <parselist+0x51>
    if (*res == '(')
     a10:	0f b6 03             	movzbl (%ebx),%eax
     a13:	3c 28                	cmp    $0x28,%al
     a15:	75 e9                	jne    a00 <parselist+0x30>
    res++;
     a17:	83 c3 01             	add    $0x1,%ebx
      i++;
     a1a:	83 c2 01             	add    $0x1,%edx
  while (res < es) {
     a1d:	39 df                	cmp    %ebx,%edi
     a1f:	75 ef                	jne    a10 <parselist+0x40>
    panic("syntax");
     a21:	83 ec 0c             	sub    $0xc,%esp
     a24:	68 5d 12 00 00       	push   $0x125d
     a29:	e8 42 f9 ff ff       	call   370 <panic>
     a2e:	66 90                	xchg   %ax,%ax
  if (res == es)
     a30:	39 df                	cmp    %ebx,%edi
     a32:	74 ed                	je     a21 <parselist+0x51>
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     a34:	31 ff                	xor    %edi,%edi
     a36:	eb 0a                	jmp    a42 <parselist+0x72>
     a38:	90                   	nop
     a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a40:	8b 0e                	mov    (%esi),%ecx
     a42:	39 d9                	cmp    %ebx,%ecx
     a44:	73 1c                	jae    a62 <parselist+0x92>
    lst->sexps[i] = parsesexp(ps, res);
     a46:	83 ec 08             	sub    $0x8,%esp
     a49:	53                   	push   %ebx
     a4a:	56                   	push   %esi
     a4b:	e8 c0 fe ff ff       	call   910 <parsesexp>
     a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     a53:	83 c4 10             	add    $0x10,%esp
    lst->sexps[i] = parsesexp(ps, res);
     a56:	89 44 ba 08          	mov    %eax,0x8(%edx,%edi,4)
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     a5a:	83 c7 01             	add    $0x1,%edi
     a5d:	83 ff 0a             	cmp    $0xa,%edi
     a60:	75 de                	jne    a40 <parselist+0x70>
  lst->length = i;
     a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     a65:	89 78 04             	mov    %edi,0x4(%eax)
}
     a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a6b:	5b                   	pop    %ebx
     a6c:	5e                   	pop    %esi
     a6d:	5f                   	pop    %edi
     a6e:	5d                   	pop    %ebp
     a6f:	c3                   	ret    

00000a70 <snulterminate>:
  }
  snulterminate(exp);
  return exp;
}

struct sexp *snulterminate(struct sexp *exp) {
     a70:	55                   	push   %ebp
     a71:	89 e5                	mov    %esp,%ebp
     a73:	56                   	push   %esi
     a74:	53                   	push   %ebx
     a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;
  struct list *lst;
  struct atom *atm;

  if (exp == 0)
     a78:	85 db                	test   %ebx,%ebx
     a7a:	74 2e                	je     aaa <snulterminate+0x3a>
    return 0;

  switch (exp->type) {
     a7c:	8b 03                	mov    (%ebx),%eax
     a7e:	83 f8 01             	cmp    $0x1,%eax
     a81:	74 35                	je     ab8 <snulterminate+0x48>
     a83:	7c 25                	jl     aaa <snulterminate+0x3a>
     a85:	83 f8 03             	cmp    $0x3,%eax
     a88:	7f 20                	jg     aaa <snulterminate+0x3a>
    break;

  case APPLY:
  case LIST:
    lst = (struct list *)exp;
    for (i = 0; i < lst->length; i++)
     a8a:	8b 43 04             	mov    0x4(%ebx),%eax
     a8d:	31 f6                	xor    %esi,%esi
     a8f:	85 c0                	test   %eax,%eax
     a91:	7e 17                	jle    aaa <snulterminate+0x3a>
      snulterminate(lst->sexps[i]);
     a93:	83 ec 0c             	sub    $0xc,%esp
     a96:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
    for (i = 0; i < lst->length; i++)
     a9a:	83 c6 01             	add    $0x1,%esi
      snulterminate(lst->sexps[i]);
     a9d:	e8 ce ff ff ff       	call   a70 <snulterminate>
    for (i = 0; i < lst->length; i++)
     aa2:	83 c4 10             	add    $0x10,%esp
     aa5:	3b 73 04             	cmp    0x4(%ebx),%esi
     aa8:	7c e9                	jl     a93 <snulterminate+0x23>
    break;
  }
  return exp;
}
     aaa:	8d 65 f8             	lea    -0x8(%ebp),%esp
     aad:	89 d8                	mov    %ebx,%eax
     aaf:	5b                   	pop    %ebx
     ab0:	5e                   	pop    %esi
     ab1:	5d                   	pop    %ebp
     ab2:	c3                   	ret    
     ab3:	90                   	nop
     ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *atm->esymbol = 0;
     ab8:	8b 43 08             	mov    0x8(%ebx),%eax
     abb:	c6 00 00             	movb   $0x0,(%eax)
}
     abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ac1:	89 d8                	mov    %ebx,%eax
     ac3:	5b                   	pop    %ebx
     ac4:	5e                   	pop    %esi
     ac5:	5d                   	pop    %ebp
     ac6:	c3                   	ret    
     ac7:	89 f6                	mov    %esi,%esi
     ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ad0 <parseexp>:
struct sexp *parseexp(char *s) {
     ad0:	55                   	push   %ebp
     ad1:	89 e5                	mov    %esp,%ebp
     ad3:	56                   	push   %esi
     ad4:	53                   	push   %ebx
  es = s + strlen(s);
     ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
     ad8:	83 ec 0c             	sub    $0xc,%esp
     adb:	53                   	push   %ebx
     adc:	e8 df 00 00 00       	call   bc0 <strlen>
  exp = parsesexp(&s, es);
     ae1:	59                   	pop    %ecx
  es = s + strlen(s);
     ae2:	01 c3                	add    %eax,%ebx
  exp = parsesexp(&s, es);
     ae4:	8d 45 08             	lea    0x8(%ebp),%eax
     ae7:	5e                   	pop    %esi
     ae8:	53                   	push   %ebx
     ae9:	50                   	push   %eax
     aea:	e8 21 fe ff ff       	call   910 <parsesexp>
     aef:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     af1:	8d 45 08             	lea    0x8(%ebp),%eax
     af4:	83 c4 0c             	add    $0xc,%esp
     af7:	68 d4 12 00 00       	push   $0x12d4
     afc:	53                   	push   %ebx
     afd:	50                   	push   %eax
     afe:	e8 1d fd ff ff       	call   820 <peek>
  if (s != es) {
     b03:	8b 45 08             	mov    0x8(%ebp),%eax
     b06:	83 c4 10             	add    $0x10,%esp
     b09:	39 d8                	cmp    %ebx,%eax
     b0b:	75 12                	jne    b1f <parseexp+0x4f>
  snulterminate(exp);
     b0d:	83 ec 0c             	sub    $0xc,%esp
     b10:	56                   	push   %esi
     b11:	e8 5a ff ff ff       	call   a70 <snulterminate>
}
     b16:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b19:	89 f0                	mov    %esi,%eax
     b1b:	5b                   	pop    %ebx
     b1c:	5e                   	pop    %esi
     b1d:	5d                   	pop    %ebp
     b1e:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     b1f:	52                   	push   %edx
     b20:	50                   	push   %eax
     b21:	68 ad 12 00 00       	push   $0x12ad
     b26:	6a 02                	push   $0x2
     b28:	e8 c3 03 00 00       	call   ef0 <printf>
    panic("syntax");
     b2d:	c7 04 24 5d 12 00 00 	movl   $0x125d,(%esp)
     b34:	e8 37 f8 ff ff       	call   370 <panic>
     b39:	66 90                	xchg   %ax,%ax
     b3b:	66 90                	xchg   %ax,%ax
     b3d:	66 90                	xchg   %ax,%ax
     b3f:	90                   	nop

00000b40 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     b40:	55                   	push   %ebp
     b41:	89 e5                	mov    %esp,%ebp
     b43:	53                   	push   %ebx
     b44:	8b 45 08             	mov    0x8(%ebp),%eax
     b47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b4a:	89 c2                	mov    %eax,%edx
     b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     b50:	83 c1 01             	add    $0x1,%ecx
     b53:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     b57:	83 c2 01             	add    $0x1,%edx
     b5a:	84 db                	test   %bl,%bl
     b5c:	88 5a ff             	mov    %bl,-0x1(%edx)
     b5f:	75 ef                	jne    b50 <strcpy+0x10>
    ;
  return os;
}
     b61:	5b                   	pop    %ebx
     b62:	5d                   	pop    %ebp
     b63:	c3                   	ret    
     b64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     b6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000b70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b70:	55                   	push   %ebp
     b71:	89 e5                	mov    %esp,%ebp
     b73:	53                   	push   %ebx
     b74:	8b 55 08             	mov    0x8(%ebp),%edx
     b77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     b7a:	0f b6 02             	movzbl (%edx),%eax
     b7d:	0f b6 19             	movzbl (%ecx),%ebx
     b80:	84 c0                	test   %al,%al
     b82:	75 1c                	jne    ba0 <strcmp+0x30>
     b84:	eb 2a                	jmp    bb0 <strcmp+0x40>
     b86:	8d 76 00             	lea    0x0(%esi),%esi
     b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
     b90:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     b93:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
     b96:	83 c1 01             	add    $0x1,%ecx
     b99:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
     b9c:	84 c0                	test   %al,%al
     b9e:	74 10                	je     bb0 <strcmp+0x40>
     ba0:	38 d8                	cmp    %bl,%al
     ba2:	74 ec                	je     b90 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     ba4:	29 d8                	sub    %ebx,%eax
}
     ba6:	5b                   	pop    %ebx
     ba7:	5d                   	pop    %ebp
     ba8:	c3                   	ret    
     ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bb0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     bb2:	29 d8                	sub    %ebx,%eax
}
     bb4:	5b                   	pop    %ebx
     bb5:	5d                   	pop    %ebp
     bb6:	c3                   	ret    
     bb7:	89 f6                	mov    %esi,%esi
     bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000bc0 <strlen>:

uint
strlen(char *s)
{
     bc0:	55                   	push   %ebp
     bc1:	89 e5                	mov    %esp,%ebp
     bc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     bc6:	80 39 00             	cmpb   $0x0,(%ecx)
     bc9:	74 15                	je     be0 <strlen+0x20>
     bcb:	31 d2                	xor    %edx,%edx
     bcd:	8d 76 00             	lea    0x0(%esi),%esi
     bd0:	83 c2 01             	add    $0x1,%edx
     bd3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     bd7:	89 d0                	mov    %edx,%eax
     bd9:	75 f5                	jne    bd0 <strlen+0x10>
    ;
  return n;
}
     bdb:	5d                   	pop    %ebp
     bdc:	c3                   	ret    
     bdd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
     be0:	31 c0                	xor    %eax,%eax
}
     be2:	5d                   	pop    %ebp
     be3:	c3                   	ret    
     be4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     bea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000bf0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     bf0:	55                   	push   %ebp
     bf1:	89 e5                	mov    %esp,%ebp
     bf3:	57                   	push   %edi
     bf4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     bf7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
     bfd:	89 d7                	mov    %edx,%edi
     bff:	fc                   	cld    
     c00:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     c02:	89 d0                	mov    %edx,%eax
     c04:	5f                   	pop    %edi
     c05:	5d                   	pop    %ebp
     c06:	c3                   	ret    
     c07:	89 f6                	mov    %esi,%esi
     c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c10 <strchr>:

char*
strchr(const char *s, char c)
{
     c10:	55                   	push   %ebp
     c11:	89 e5                	mov    %esp,%ebp
     c13:	53                   	push   %ebx
     c14:	8b 45 08             	mov    0x8(%ebp),%eax
     c17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
     c1a:	0f b6 10             	movzbl (%eax),%edx
     c1d:	84 d2                	test   %dl,%dl
     c1f:	74 1d                	je     c3e <strchr+0x2e>
    if(*s == c)
     c21:	38 d3                	cmp    %dl,%bl
     c23:	89 d9                	mov    %ebx,%ecx
     c25:	75 0d                	jne    c34 <strchr+0x24>
     c27:	eb 17                	jmp    c40 <strchr+0x30>
     c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c30:	38 ca                	cmp    %cl,%dl
     c32:	74 0c                	je     c40 <strchr+0x30>
  for(; *s; s++)
     c34:	83 c0 01             	add    $0x1,%eax
     c37:	0f b6 10             	movzbl (%eax),%edx
     c3a:	84 d2                	test   %dl,%dl
     c3c:	75 f2                	jne    c30 <strchr+0x20>
      return (char*)s;
  return 0;
     c3e:	31 c0                	xor    %eax,%eax
}
     c40:	5b                   	pop    %ebx
     c41:	5d                   	pop    %ebp
     c42:	c3                   	ret    
     c43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c50 <gets>:

char*
gets(char *buf, int max)
{
     c50:	55                   	push   %ebp
     c51:	89 e5                	mov    %esp,%ebp
     c53:	57                   	push   %edi
     c54:	56                   	push   %esi
     c55:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c56:	31 f6                	xor    %esi,%esi
     c58:	89 f3                	mov    %esi,%ebx
{
     c5a:	83 ec 1c             	sub    $0x1c,%esp
     c5d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     c60:	eb 2f                	jmp    c91 <gets+0x41>
     c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     c68:	8d 45 e7             	lea    -0x19(%ebp),%eax
     c6b:	83 ec 04             	sub    $0x4,%esp
     c6e:	6a 01                	push   $0x1
     c70:	50                   	push   %eax
     c71:	6a 00                	push   $0x0
     c73:	e8 32 01 00 00       	call   daa <read>
    if(cc < 1)
     c78:	83 c4 10             	add    $0x10,%esp
     c7b:	85 c0                	test   %eax,%eax
     c7d:	7e 1c                	jle    c9b <gets+0x4b>
      break;
    buf[i++] = c;
     c7f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     c83:	83 c7 01             	add    $0x1,%edi
     c86:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     c89:	3c 0a                	cmp    $0xa,%al
     c8b:	74 23                	je     cb0 <gets+0x60>
     c8d:	3c 0d                	cmp    $0xd,%al
     c8f:	74 1f                	je     cb0 <gets+0x60>
  for(i=0; i+1 < max; ){
     c91:	83 c3 01             	add    $0x1,%ebx
     c94:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     c97:	89 fe                	mov    %edi,%esi
     c99:	7c cd                	jl     c68 <gets+0x18>
     c9b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     ca0:	c6 03 00             	movb   $0x0,(%ebx)
}
     ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ca6:	5b                   	pop    %ebx
     ca7:	5e                   	pop    %esi
     ca8:	5f                   	pop    %edi
     ca9:	5d                   	pop    %ebp
     caa:	c3                   	ret    
     cab:	90                   	nop
     cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     cb0:	8b 75 08             	mov    0x8(%ebp),%esi
     cb3:	8b 45 08             	mov    0x8(%ebp),%eax
     cb6:	01 de                	add    %ebx,%esi
     cb8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     cba:	c6 03 00             	movb   $0x0,(%ebx)
}
     cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cc0:	5b                   	pop    %ebx
     cc1:	5e                   	pop    %esi
     cc2:	5f                   	pop    %edi
     cc3:	5d                   	pop    %ebp
     cc4:	c3                   	ret    
     cc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000cd0 <stat>:

int
stat(char *n, struct stat *st)
{
     cd0:	55                   	push   %ebp
     cd1:	89 e5                	mov    %esp,%ebp
     cd3:	56                   	push   %esi
     cd4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cd5:	83 ec 08             	sub    $0x8,%esp
     cd8:	6a 00                	push   $0x0
     cda:	ff 75 08             	pushl  0x8(%ebp)
     cdd:	e8 f0 00 00 00       	call   dd2 <open>
  if(fd < 0)
     ce2:	83 c4 10             	add    $0x10,%esp
     ce5:	85 c0                	test   %eax,%eax
     ce7:	78 27                	js     d10 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     ce9:	83 ec 08             	sub    $0x8,%esp
     cec:	ff 75 0c             	pushl  0xc(%ebp)
     cef:	89 c3                	mov    %eax,%ebx
     cf1:	50                   	push   %eax
     cf2:	e8 f3 00 00 00       	call   dea <fstat>
  close(fd);
     cf7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     cfa:	89 c6                	mov    %eax,%esi
  close(fd);
     cfc:	e8 b9 00 00 00       	call   dba <close>
  return r;
     d01:	83 c4 10             	add    $0x10,%esp
}
     d04:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d07:	89 f0                	mov    %esi,%eax
     d09:	5b                   	pop    %ebx
     d0a:	5e                   	pop    %esi
     d0b:	5d                   	pop    %ebp
     d0c:	c3                   	ret    
     d0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     d10:	be ff ff ff ff       	mov    $0xffffffff,%esi
     d15:	eb ed                	jmp    d04 <stat+0x34>
     d17:	89 f6                	mov    %esi,%esi
     d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d20 <atoi>:

int
atoi(const char *s)
{
     d20:	55                   	push   %ebp
     d21:	89 e5                	mov    %esp,%ebp
     d23:	53                   	push   %ebx
     d24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d27:	0f be 11             	movsbl (%ecx),%edx
     d2a:	8d 42 d0             	lea    -0x30(%edx),%eax
     d2d:	3c 09                	cmp    $0x9,%al
  n = 0;
     d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
     d34:	77 1f                	ja     d55 <atoi+0x35>
     d36:	8d 76 00             	lea    0x0(%esi),%esi
     d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
     d40:	8d 04 80             	lea    (%eax,%eax,4),%eax
     d43:	83 c1 01             	add    $0x1,%ecx
     d46:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
     d4a:	0f be 11             	movsbl (%ecx),%edx
     d4d:	8d 5a d0             	lea    -0x30(%edx),%ebx
     d50:	80 fb 09             	cmp    $0x9,%bl
     d53:	76 eb                	jbe    d40 <atoi+0x20>
  return n;
}
     d55:	5b                   	pop    %ebx
     d56:	5d                   	pop    %ebp
     d57:	c3                   	ret    
     d58:	90                   	nop
     d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d60 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d60:	55                   	push   %ebp
     d61:	89 e5                	mov    %esp,%ebp
     d63:	56                   	push   %esi
     d64:	53                   	push   %ebx
     d65:	8b 5d 10             	mov    0x10(%ebp),%ebx
     d68:	8b 45 08             	mov    0x8(%ebp),%eax
     d6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d6e:	85 db                	test   %ebx,%ebx
     d70:	7e 14                	jle    d86 <memmove+0x26>
     d72:	31 d2                	xor    %edx,%edx
     d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
     d78:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     d7c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     d7f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
     d82:	39 d3                	cmp    %edx,%ebx
     d84:	75 f2                	jne    d78 <memmove+0x18>
  return vdst;
}
     d86:	5b                   	pop    %ebx
     d87:	5e                   	pop    %esi
     d88:	5d                   	pop    %ebp
     d89:	c3                   	ret    

00000d8a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d8a:	b8 01 00 00 00       	mov    $0x1,%eax
     d8f:	cd 40                	int    $0x40
     d91:	c3                   	ret    

00000d92 <exit>:
SYSCALL(exit)
     d92:	b8 02 00 00 00       	mov    $0x2,%eax
     d97:	cd 40                	int    $0x40
     d99:	c3                   	ret    

00000d9a <wait>:
SYSCALL(wait)
     d9a:	b8 03 00 00 00       	mov    $0x3,%eax
     d9f:	cd 40                	int    $0x40
     da1:	c3                   	ret    

00000da2 <pipe>:
SYSCALL(pipe)
     da2:	b8 04 00 00 00       	mov    $0x4,%eax
     da7:	cd 40                	int    $0x40
     da9:	c3                   	ret    

00000daa <read>:
SYSCALL(read)
     daa:	b8 05 00 00 00       	mov    $0x5,%eax
     daf:	cd 40                	int    $0x40
     db1:	c3                   	ret    

00000db2 <write>:
SYSCALL(write)
     db2:	b8 10 00 00 00       	mov    $0x10,%eax
     db7:	cd 40                	int    $0x40
     db9:	c3                   	ret    

00000dba <close>:
SYSCALL(close)
     dba:	b8 15 00 00 00       	mov    $0x15,%eax
     dbf:	cd 40                	int    $0x40
     dc1:	c3                   	ret    

00000dc2 <kill>:
SYSCALL(kill)
     dc2:	b8 06 00 00 00       	mov    $0x6,%eax
     dc7:	cd 40                	int    $0x40
     dc9:	c3                   	ret    

00000dca <exec>:
SYSCALL(exec)
     dca:	b8 07 00 00 00       	mov    $0x7,%eax
     dcf:	cd 40                	int    $0x40
     dd1:	c3                   	ret    

00000dd2 <open>:
SYSCALL(open)
     dd2:	b8 0f 00 00 00       	mov    $0xf,%eax
     dd7:	cd 40                	int    $0x40
     dd9:	c3                   	ret    

00000dda <mknod>:
SYSCALL(mknod)
     dda:	b8 11 00 00 00       	mov    $0x11,%eax
     ddf:	cd 40                	int    $0x40
     de1:	c3                   	ret    

00000de2 <unlink>:
SYSCALL(unlink)
     de2:	b8 12 00 00 00       	mov    $0x12,%eax
     de7:	cd 40                	int    $0x40
     de9:	c3                   	ret    

00000dea <fstat>:
SYSCALL(fstat)
     dea:	b8 08 00 00 00       	mov    $0x8,%eax
     def:	cd 40                	int    $0x40
     df1:	c3                   	ret    

00000df2 <link>:
SYSCALL(link)
     df2:	b8 13 00 00 00       	mov    $0x13,%eax
     df7:	cd 40                	int    $0x40
     df9:	c3                   	ret    

00000dfa <mkdir>:
SYSCALL(mkdir)
     dfa:	b8 14 00 00 00       	mov    $0x14,%eax
     dff:	cd 40                	int    $0x40
     e01:	c3                   	ret    

00000e02 <chdir>:
SYSCALL(chdir)
     e02:	b8 09 00 00 00       	mov    $0x9,%eax
     e07:	cd 40                	int    $0x40
     e09:	c3                   	ret    

00000e0a <dup>:
SYSCALL(dup)
     e0a:	b8 0a 00 00 00       	mov    $0xa,%eax
     e0f:	cd 40                	int    $0x40
     e11:	c3                   	ret    

00000e12 <getpid>:
SYSCALL(getpid)
     e12:	b8 0b 00 00 00       	mov    $0xb,%eax
     e17:	cd 40                	int    $0x40
     e19:	c3                   	ret    

00000e1a <sbrk>:
SYSCALL(sbrk)
     e1a:	b8 0c 00 00 00       	mov    $0xc,%eax
     e1f:	cd 40                	int    $0x40
     e21:	c3                   	ret    

00000e22 <sleep>:
SYSCALL(sleep)
     e22:	b8 0d 00 00 00       	mov    $0xd,%eax
     e27:	cd 40                	int    $0x40
     e29:	c3                   	ret    

00000e2a <uptime>:
SYSCALL(uptime)
     e2a:	b8 0e 00 00 00       	mov    $0xe,%eax
     e2f:	cd 40                	int    $0x40
     e31:	c3                   	ret    

00000e32 <trace>:
SYSCALL(trace)
     e32:	b8 16 00 00 00       	mov    $0x16,%eax
     e37:	cd 40                	int    $0x40
     e39:	c3                   	ret    

00000e3a <getsharem>:
SYSCALL(getsharem)
     e3a:	b8 17 00 00 00       	mov    $0x17,%eax
     e3f:	cd 40                	int    $0x40
     e41:	c3                   	ret    

00000e42 <releasesharem>:
SYSCALL(releasesharem)
     e42:	b8 18 00 00 00       	mov    $0x18,%eax
     e47:	cd 40                	int    $0x40
     e49:	c3                   	ret    
     e4a:	66 90                	xchg   %ax,%ax
     e4c:	66 90                	xchg   %ax,%ax
     e4e:	66 90                	xchg   %ax,%ax

00000e50 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     e50:	55                   	push   %ebp
     e51:	89 e5                	mov    %esp,%ebp
     e53:	57                   	push   %edi
     e54:	56                   	push   %esi
     e55:	53                   	push   %ebx
     e56:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e59:	85 d2                	test   %edx,%edx
{
     e5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
     e5e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
     e60:	79 76                	jns    ed8 <printint+0x88>
     e62:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     e66:	74 70                	je     ed8 <printint+0x88>
    x = -xx;
     e68:	f7 d8                	neg    %eax
    neg = 1;
     e6a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     e71:	31 f6                	xor    %esi,%esi
     e73:	8d 5d d7             	lea    -0x29(%ebp),%ebx
     e76:	eb 0a                	jmp    e82 <printint+0x32>
     e78:	90                   	nop
     e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
     e80:	89 fe                	mov    %edi,%esi
     e82:	31 d2                	xor    %edx,%edx
     e84:	8d 7e 01             	lea    0x1(%esi),%edi
     e87:	f7 f1                	div    %ecx
     e89:	0f b6 92 00 13 00 00 	movzbl 0x1300(%edx),%edx
  }while((x /= base) != 0);
     e90:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
     e92:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
     e95:	75 e9                	jne    e80 <printint+0x30>
  if(neg)
     e97:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     e9a:	85 c0                	test   %eax,%eax
     e9c:	74 08                	je     ea6 <printint+0x56>
    buf[i++] = '-';
     e9e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
     ea3:	8d 7e 02             	lea    0x2(%esi),%edi
     ea6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
     eaa:	8b 7d c0             	mov    -0x40(%ebp),%edi
     ead:	8d 76 00             	lea    0x0(%esi),%esi
     eb0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
     eb3:	83 ec 04             	sub    $0x4,%esp
     eb6:	83 ee 01             	sub    $0x1,%esi
     eb9:	6a 01                	push   $0x1
     ebb:	53                   	push   %ebx
     ebc:	57                   	push   %edi
     ebd:	88 45 d7             	mov    %al,-0x29(%ebp)
     ec0:	e8 ed fe ff ff       	call   db2 <write>

  while(--i >= 0)
     ec5:	83 c4 10             	add    $0x10,%esp
     ec8:	39 de                	cmp    %ebx,%esi
     eca:	75 e4                	jne    eb0 <printint+0x60>
    putc(fd, buf[i]);
}
     ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ecf:	5b                   	pop    %ebx
     ed0:	5e                   	pop    %esi
     ed1:	5f                   	pop    %edi
     ed2:	5d                   	pop    %ebp
     ed3:	c3                   	ret    
     ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     ed8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     edf:	eb 90                	jmp    e71 <printint+0x21>
     ee1:	eb 0d                	jmp    ef0 <printf>
     ee3:	90                   	nop
     ee4:	90                   	nop
     ee5:	90                   	nop
     ee6:	90                   	nop
     ee7:	90                   	nop
     ee8:	90                   	nop
     ee9:	90                   	nop
     eea:	90                   	nop
     eeb:	90                   	nop
     eec:	90                   	nop
     eed:	90                   	nop
     eee:	90                   	nop
     eef:	90                   	nop

00000ef0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     ef0:	55                   	push   %ebp
     ef1:	89 e5                	mov    %esp,%ebp
     ef3:	57                   	push   %edi
     ef4:	56                   	push   %esi
     ef5:	53                   	push   %ebx
     ef6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     ef9:	8b 75 0c             	mov    0xc(%ebp),%esi
     efc:	0f b6 1e             	movzbl (%esi),%ebx
     eff:	84 db                	test   %bl,%bl
     f01:	0f 84 b3 00 00 00    	je     fba <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
     f07:	8d 45 10             	lea    0x10(%ebp),%eax
     f0a:	83 c6 01             	add    $0x1,%esi
  state = 0;
     f0d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
     f0f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     f12:	eb 2f                	jmp    f43 <printf+0x53>
     f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     f18:	83 f8 25             	cmp    $0x25,%eax
     f1b:	0f 84 a7 00 00 00    	je     fc8 <printf+0xd8>
  write(fd, &c, 1);
     f21:	8d 45 e2             	lea    -0x1e(%ebp),%eax
     f24:	83 ec 04             	sub    $0x4,%esp
     f27:	88 5d e2             	mov    %bl,-0x1e(%ebp)
     f2a:	6a 01                	push   $0x1
     f2c:	50                   	push   %eax
     f2d:	ff 75 08             	pushl  0x8(%ebp)
     f30:	e8 7d fe ff ff       	call   db2 <write>
     f35:	83 c4 10             	add    $0x10,%esp
     f38:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
     f3b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
     f3f:	84 db                	test   %bl,%bl
     f41:	74 77                	je     fba <printf+0xca>
    if(state == 0){
     f43:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
     f45:	0f be cb             	movsbl %bl,%ecx
     f48:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     f4b:	74 cb                	je     f18 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f4d:	83 ff 25             	cmp    $0x25,%edi
     f50:	75 e6                	jne    f38 <printf+0x48>
      if(c == 'd'){
     f52:	83 f8 64             	cmp    $0x64,%eax
     f55:	0f 84 05 01 00 00    	je     1060 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     f5b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     f61:	83 f9 70             	cmp    $0x70,%ecx
     f64:	74 72                	je     fd8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     f66:	83 f8 73             	cmp    $0x73,%eax
     f69:	0f 84 99 00 00 00    	je     1008 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f6f:	83 f8 63             	cmp    $0x63,%eax
     f72:	0f 84 08 01 00 00    	je     1080 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     f78:	83 f8 25             	cmp    $0x25,%eax
     f7b:	0f 84 ef 00 00 00    	je     1070 <printf+0x180>
  write(fd, &c, 1);
     f81:	8d 45 e7             	lea    -0x19(%ebp),%eax
     f84:	83 ec 04             	sub    $0x4,%esp
     f87:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     f8b:	6a 01                	push   $0x1
     f8d:	50                   	push   %eax
     f8e:	ff 75 08             	pushl  0x8(%ebp)
     f91:	e8 1c fe ff ff       	call   db2 <write>
     f96:	83 c4 0c             	add    $0xc,%esp
     f99:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     f9c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
     f9f:	6a 01                	push   $0x1
     fa1:	50                   	push   %eax
     fa2:	ff 75 08             	pushl  0x8(%ebp)
     fa5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     fa8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
     faa:	e8 03 fe ff ff       	call   db2 <write>
  for(i = 0; fmt[i]; i++){
     faf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
     fb3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     fb6:	84 db                	test   %bl,%bl
     fb8:	75 89                	jne    f43 <printf+0x53>
    }
  }
}
     fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fbd:	5b                   	pop    %ebx
     fbe:	5e                   	pop    %esi
     fbf:	5f                   	pop    %edi
     fc0:	5d                   	pop    %ebp
     fc1:	c3                   	ret    
     fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
     fc8:	bf 25 00 00 00       	mov    $0x25,%edi
     fcd:	e9 66 ff ff ff       	jmp    f38 <printf+0x48>
     fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
     fd8:	83 ec 0c             	sub    $0xc,%esp
     fdb:	b9 10 00 00 00       	mov    $0x10,%ecx
     fe0:	6a 00                	push   $0x0
     fe2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     fe5:	8b 45 08             	mov    0x8(%ebp),%eax
     fe8:	8b 17                	mov    (%edi),%edx
     fea:	e8 61 fe ff ff       	call   e50 <printint>
        ap++;
     fef:	89 f8                	mov    %edi,%eax
     ff1:	83 c4 10             	add    $0x10,%esp
      state = 0;
     ff4:	31 ff                	xor    %edi,%edi
        ap++;
     ff6:	83 c0 04             	add    $0x4,%eax
     ff9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     ffc:	e9 37 ff ff ff       	jmp    f38 <printf+0x48>
    1001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1008:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    100b:	8b 08                	mov    (%eax),%ecx
        ap++;
    100d:	83 c0 04             	add    $0x4,%eax
    1010:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    1013:	85 c9                	test   %ecx,%ecx
    1015:	0f 84 8e 00 00 00    	je     10a9 <printf+0x1b9>
        while(*s != 0){
    101b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
    101e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
    1020:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
    1022:	84 c0                	test   %al,%al
    1024:	0f 84 0e ff ff ff    	je     f38 <printf+0x48>
    102a:	89 75 d0             	mov    %esi,-0x30(%ebp)
    102d:	89 de                	mov    %ebx,%esi
    102f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1032:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1035:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1038:	83 ec 04             	sub    $0x4,%esp
          s++;
    103b:	83 c6 01             	add    $0x1,%esi
    103e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    1041:	6a 01                	push   $0x1
    1043:	57                   	push   %edi
    1044:	53                   	push   %ebx
    1045:	e8 68 fd ff ff       	call   db2 <write>
        while(*s != 0){
    104a:	0f b6 06             	movzbl (%esi),%eax
    104d:	83 c4 10             	add    $0x10,%esp
    1050:	84 c0                	test   %al,%al
    1052:	75 e4                	jne    1038 <printf+0x148>
    1054:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    1057:	31 ff                	xor    %edi,%edi
    1059:	e9 da fe ff ff       	jmp    f38 <printf+0x48>
    105e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    1060:	83 ec 0c             	sub    $0xc,%esp
    1063:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1068:	6a 01                	push   $0x1
    106a:	e9 73 ff ff ff       	jmp    fe2 <printf+0xf2>
    106f:	90                   	nop
  write(fd, &c, 1);
    1070:	83 ec 04             	sub    $0x4,%esp
    1073:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    1076:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1079:	6a 01                	push   $0x1
    107b:	e9 21 ff ff ff       	jmp    fa1 <printf+0xb1>
        putc(fd, *ap);
    1080:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    1083:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1086:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    1088:	6a 01                	push   $0x1
        ap++;
    108a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    108d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    1090:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1093:	50                   	push   %eax
    1094:	ff 75 08             	pushl  0x8(%ebp)
    1097:	e8 16 fd ff ff       	call   db2 <write>
        ap++;
    109c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    109f:	83 c4 10             	add    $0x10,%esp
      state = 0;
    10a2:	31 ff                	xor    %edi,%edi
    10a4:	e9 8f fe ff ff       	jmp    f38 <printf+0x48>
          s = "(null)";
    10a9:	bb f8 12 00 00       	mov    $0x12f8,%ebx
        while(*s != 0){
    10ae:	b8 28 00 00 00       	mov    $0x28,%eax
    10b3:	e9 72 ff ff ff       	jmp    102a <printf+0x13a>
    10b8:	66 90                	xchg   %ax,%ax
    10ba:	66 90                	xchg   %ax,%ax
    10bc:	66 90                	xchg   %ax,%ax
    10be:	66 90                	xchg   %ax,%ax

000010c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10c1:	a1 44 19 00 00       	mov    0x1944,%eax
{
    10c6:	89 e5                	mov    %esp,%ebp
    10c8:	57                   	push   %edi
    10c9:	56                   	push   %esi
    10ca:	53                   	push   %ebx
    10cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    10ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    10d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10d8:	39 c8                	cmp    %ecx,%eax
    10da:	8b 10                	mov    (%eax),%edx
    10dc:	73 32                	jae    1110 <free+0x50>
    10de:	39 d1                	cmp    %edx,%ecx
    10e0:	72 04                	jb     10e6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10e2:	39 d0                	cmp    %edx,%eax
    10e4:	72 32                	jb     1118 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    10e6:	8b 73 fc             	mov    -0x4(%ebx),%esi
    10e9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    10ec:	39 fa                	cmp    %edi,%edx
    10ee:	74 30                	je     1120 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    10f0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    10f3:	8b 50 04             	mov    0x4(%eax),%edx
    10f6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    10f9:	39 f1                	cmp    %esi,%ecx
    10fb:	74 3a                	je     1137 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    10fd:	89 08                	mov    %ecx,(%eax)
  freep = p;
    10ff:	a3 44 19 00 00       	mov    %eax,0x1944
}
    1104:	5b                   	pop    %ebx
    1105:	5e                   	pop    %esi
    1106:	5f                   	pop    %edi
    1107:	5d                   	pop    %ebp
    1108:	c3                   	ret    
    1109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1110:	39 d0                	cmp    %edx,%eax
    1112:	72 04                	jb     1118 <free+0x58>
    1114:	39 d1                	cmp    %edx,%ecx
    1116:	72 ce                	jb     10e6 <free+0x26>
{
    1118:	89 d0                	mov    %edx,%eax
    111a:	eb bc                	jmp    10d8 <free+0x18>
    111c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1120:	03 72 04             	add    0x4(%edx),%esi
    1123:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1126:	8b 10                	mov    (%eax),%edx
    1128:	8b 12                	mov    (%edx),%edx
    112a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    112d:	8b 50 04             	mov    0x4(%eax),%edx
    1130:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1133:	39 f1                	cmp    %esi,%ecx
    1135:	75 c6                	jne    10fd <free+0x3d>
    p->s.size += bp->s.size;
    1137:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    113a:	a3 44 19 00 00       	mov    %eax,0x1944
    p->s.size += bp->s.size;
    113f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1142:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1145:	89 10                	mov    %edx,(%eax)
}
    1147:	5b                   	pop    %ebx
    1148:	5e                   	pop    %esi
    1149:	5f                   	pop    %edi
    114a:	5d                   	pop    %ebp
    114b:	c3                   	ret    
    114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001150 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1150:	55                   	push   %ebp
    1151:	89 e5                	mov    %esp,%ebp
    1153:	57                   	push   %edi
    1154:	56                   	push   %esi
    1155:	53                   	push   %ebx
    1156:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1159:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    115c:	8b 15 44 19 00 00    	mov    0x1944,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1162:	8d 78 07             	lea    0x7(%eax),%edi
    1165:	c1 ef 03             	shr    $0x3,%edi
    1168:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    116b:	85 d2                	test   %edx,%edx
    116d:	0f 84 9d 00 00 00    	je     1210 <malloc+0xc0>
    1173:	8b 02                	mov    (%edx),%eax
    1175:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1178:	39 cf                	cmp    %ecx,%edi
    117a:	76 6c                	jbe    11e8 <malloc+0x98>
    117c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    1182:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1187:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    118a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    1191:	eb 0e                	jmp    11a1 <malloc+0x51>
    1193:	90                   	nop
    1194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1198:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    119a:	8b 48 04             	mov    0x4(%eax),%ecx
    119d:	39 f9                	cmp    %edi,%ecx
    119f:	73 47                	jae    11e8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11a1:	39 05 44 19 00 00    	cmp    %eax,0x1944
    11a7:	89 c2                	mov    %eax,%edx
    11a9:	75 ed                	jne    1198 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    11ab:	83 ec 0c             	sub    $0xc,%esp
    11ae:	56                   	push   %esi
    11af:	e8 66 fc ff ff       	call   e1a <sbrk>
  if(p == (char*)-1)
    11b4:	83 c4 10             	add    $0x10,%esp
    11b7:	83 f8 ff             	cmp    $0xffffffff,%eax
    11ba:	74 1c                	je     11d8 <malloc+0x88>
  hp->s.size = nu;
    11bc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    11bf:	83 ec 0c             	sub    $0xc,%esp
    11c2:	83 c0 08             	add    $0x8,%eax
    11c5:	50                   	push   %eax
    11c6:	e8 f5 fe ff ff       	call   10c0 <free>
  return freep;
    11cb:	8b 15 44 19 00 00    	mov    0x1944,%edx
      if((p = morecore(nunits)) == 0)
    11d1:	83 c4 10             	add    $0x10,%esp
    11d4:	85 d2                	test   %edx,%edx
    11d6:	75 c0                	jne    1198 <malloc+0x48>
        return 0;
  }
}
    11d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    11db:	31 c0                	xor    %eax,%eax
}
    11dd:	5b                   	pop    %ebx
    11de:	5e                   	pop    %esi
    11df:	5f                   	pop    %edi
    11e0:	5d                   	pop    %ebp
    11e1:	c3                   	ret    
    11e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    11e8:	39 cf                	cmp    %ecx,%edi
    11ea:	74 54                	je     1240 <malloc+0xf0>
        p->s.size -= nunits;
    11ec:	29 f9                	sub    %edi,%ecx
    11ee:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    11f1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    11f4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    11f7:	89 15 44 19 00 00    	mov    %edx,0x1944
}
    11fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1200:	83 c0 08             	add    $0x8,%eax
}
    1203:	5b                   	pop    %ebx
    1204:	5e                   	pop    %esi
    1205:	5f                   	pop    %edi
    1206:	5d                   	pop    %ebp
    1207:	c3                   	ret    
    1208:	90                   	nop
    1209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    1210:	c7 05 44 19 00 00 48 	movl   $0x1948,0x1944
    1217:	19 00 00 
    121a:	c7 05 48 19 00 00 48 	movl   $0x1948,0x1948
    1221:	19 00 00 
    base.s.size = 0;
    1224:	b8 48 19 00 00       	mov    $0x1948,%eax
    1229:	c7 05 4c 19 00 00 00 	movl   $0x0,0x194c
    1230:	00 00 00 
    1233:	e9 44 ff ff ff       	jmp    117c <malloc+0x2c>
    1238:	90                   	nop
    1239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    1240:	8b 08                	mov    (%eax),%ecx
    1242:	89 0a                	mov    %ecx,(%edx)
    1244:	eb b1                	jmp    11f7 <malloc+0xa7>
