
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
  struct shared *sh = (struct shared *)getsharem(1);
      11:	6a 01                	push   $0x1
      13:	e8 41 12 00 00       	call   1259 <getsharem>
  sh->nfunc = 0;
  sh->top = (char *)sh + sizeof(struct shared);

  // Ensure that three file descriptors are open.
  while ((fd = open("console", O_RDWR)) >= 0) {
      18:	83 c4 10             	add    $0x10,%esp
  sh->top = (char *)sh + sizeof(struct shared);
      1b:	8d 90 cc 09 00 00    	lea    0x9cc(%eax),%edx
  sh->nfunc = 0;
      21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  sh->top = (char *)sh + sizeof(struct shared);
      27:	89 90 c8 09 00 00    	mov    %edx,0x9c8(%eax)
  while ((fd = open("console", O_RDWR)) >= 0) {
      2d:	eb 0a                	jmp    39 <main+0x39>
      2f:	90                   	nop
    if (fd >= 3) {
      30:	83 f8 02             	cmp    $0x2,%eax
      33:	0f 8f b7 00 00 00    	jg     f0 <main+0xf0>
  while ((fd = open("console", O_RDWR)) >= 0) {
      39:	83 ec 08             	sub    $0x8,%esp
      3c:	6a 02                	push   $0x2
      3e:	68 ef 16 00 00       	push   $0x16ef
      43:	e8 a9 11 00 00       	call   11f1 <open>
      48:	83 c4 10             	add    $0x10,%esp
      4b:	85 c0                	test   %eax,%eax
      4d:	79 e1                	jns    30 <main+0x30>
      4f:	eb 32                	jmp    83 <main+0x83>
      51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  // Read and run input commands.
  while (getcmd(buf, sizeof(buf)) >= 0) {
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      58:	80 3d 02 1d 00 00 20 	cmpb   $0x20,0x1d02
      5f:	74 51                	je     b2 <main+0xb2>
      61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

int fork1(void) {
  int pid;

  pid = fork();
      68:	e8 3c 11 00 00       	call   11a9 <fork>
  if (pid == -1)
      6d:	83 f8 ff             	cmp    $0xffffffff,%eax
      70:	0f 84 a6 00 00 00    	je     11c <main+0x11c>
    if (fork1() == 0) {
      76:	85 c0                	test   %eax,%eax
      78:	0f 84 80 00 00 00    	je     fe <main+0xfe>
    wait();
      7e:	e8 36 11 00 00       	call   11b9 <wait>
  while (getcmd(buf, sizeof(buf)) >= 0) {
      83:	83 ec 08             	sub    $0x8,%esp
      86:	6a 64                	push   $0x64
      88:	68 00 1d 00 00       	push   $0x1d00
      8d:	e8 ce 02 00 00       	call   360 <getcmd>
      92:	83 c4 10             	add    $0x10,%esp
      95:	85 c0                	test   %eax,%eax
      97:	78 14                	js     ad <main+0xad>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      99:	80 3d 00 1d 00 00 63 	cmpb   $0x63,0x1d00
      a0:	75 c6                	jne    68 <main+0x68>
      a2:	80 3d 01 1d 00 00 64 	cmpb   $0x64,0x1d01
      a9:	75 bd                	jne    68 <main+0x68>
      ab:	eb ab                	jmp    58 <main+0x58>
  exit();
      ad:	e8 ff 10 00 00       	call   11b1 <exit>
      buf[strlen(buf) - 1] = 0; // chop \n
      b2:	83 ec 0c             	sub    $0xc,%esp
      b5:	68 00 1d 00 00       	push   $0x1d00
      ba:	e8 21 0f 00 00       	call   fe0 <strlen>
      if (chdir(buf + 3) < 0)
      bf:	c7 04 24 03 1d 00 00 	movl   $0x1d03,(%esp)
      buf[strlen(buf) - 1] = 0; // chop \n
      c6:	c6 80 ff 1c 00 00 00 	movb   $0x0,0x1cff(%eax)
      if (chdir(buf + 3) < 0)
      cd:	e8 4f 11 00 00       	call   1221 <chdir>
      d2:	83 c4 10             	add    $0x10,%esp
      d5:	85 c0                	test   %eax,%eax
      d7:	79 aa                	jns    83 <main+0x83>
        printf(2, "cannot cd %s\n", buf + 3);
      d9:	50                   	push   %eax
      da:	68 03 1d 00 00       	push   $0x1d03
      df:	68 44 17 00 00       	push   $0x1744
      e4:	6a 02                	push   $0x2
      e6:	e8 75 12 00 00       	call   1360 <printf>
      eb:	83 c4 10             	add    $0x10,%esp
      ee:	eb 93                	jmp    83 <main+0x83>
      close(fd);
      f0:	83 ec 0c             	sub    $0xc,%esp
      f3:	50                   	push   %eax
      f4:	e8 e0 10 00 00       	call   11d9 <close>
      break;
      f9:	83 c4 10             	add    $0x10,%esp
      fc:	eb 85                	jmp    83 <main+0x83>
      getsharem(1);
      fe:	83 ec 0c             	sub    $0xc,%esp
     101:	6a 01                	push   $0x1
     103:	e8 51 11 00 00       	call   1259 <getsharem>
      runexp(parseexp(buf));
     108:	c7 04 24 00 1d 00 00 	movl   $0x1d00,(%esp)
     10f:	e8 dc 0d 00 00       	call   ef0 <parseexp>
     114:	89 04 24             	mov    %eax,(%esp)
     117:	e8 b4 02 00 00       	call   3d0 <runexp>
    panic("fork");
     11c:	83 ec 0c             	sub    $0xc,%esp
     11f:	68 ea 16 00 00       	push   $0x16ea
     124:	e8 87 02 00 00       	call   3b0 <panic>
     129:	66 90                	xchg   %ax,%ax
     12b:	66 90                	xchg   %ax,%ax
     12d:	66 90                	xchg   %ax,%ax
     12f:	90                   	nop

00000130 <replaceAtom>:
void replaceAtom(struct sexp *exp, char *o, char *d) {
     130:	55                   	push   %ebp
     131:	89 e5                	mov    %esp,%ebp
     133:	57                   	push   %edi
     134:	56                   	push   %esi
     135:	53                   	push   %ebx
     136:	83 ec 0c             	sub    $0xc,%esp
     139:	8b 5d 08             	mov    0x8(%ebp),%ebx
     13c:	8b 75 0c             	mov    0xc(%ebp),%esi
  switch (exp->type) {
     13f:	8b 03                	mov    (%ebx),%eax
     141:	83 f8 01             	cmp    $0x1,%eax
     144:	74 3a                	je     180 <replaceAtom+0x50>
     146:	85 c0                	test   %eax,%eax
     148:	7e 29                	jle    173 <replaceAtom+0x43>
     14a:	83 f8 03             	cmp    $0x3,%eax
     14d:	7f 24                	jg     173 <replaceAtom+0x43>
    for (i = 0; i < lst->length; i++) {
     14f:	8b 43 04             	mov    0x4(%ebx),%eax
     152:	31 ff                	xor    %edi,%edi
     154:	85 c0                	test   %eax,%eax
     156:	7e 1b                	jle    173 <replaceAtom+0x43>
      replaceAtom(lst->sexps[i], o, d);
     158:	83 ec 04             	sub    $0x4,%esp
     15b:	ff 75 10             	pushl  0x10(%ebp)
     15e:	56                   	push   %esi
     15f:	ff 74 bb 08          	pushl  0x8(%ebx,%edi,4)
    for (i = 0; i < lst->length; i++) {
     163:	83 c7 01             	add    $0x1,%edi
      replaceAtom(lst->sexps[i], o, d);
     166:	e8 c5 ff ff ff       	call   130 <replaceAtom>
    for (i = 0; i < lst->length; i++) {
     16b:	83 c4 10             	add    $0x10,%esp
     16e:	3b 7b 04             	cmp    0x4(%ebx),%edi
     171:	7c e5                	jl     158 <replaceAtom+0x28>
}
     173:	8d 65 f4             	lea    -0xc(%ebp),%esp
     176:	5b                   	pop    %ebx
     177:	5e                   	pop    %esi
     178:	5f                   	pop    %edi
     179:	5d                   	pop    %ebp
     17a:	c3                   	ret    
     17b:	90                   	nop
     17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (strcmp(atm->symbol, o) == 0)
     180:	83 ec 08             	sub    $0x8,%esp
     183:	56                   	push   %esi
     184:	ff 73 04             	pushl  0x4(%ebx)
     187:	e8 04 0e 00 00       	call   f90 <strcmp>
     18c:	83 c4 10             	add    $0x10,%esp
     18f:	85 c0                	test   %eax,%eax
     191:	75 e0                	jne    173 <replaceAtom+0x43>
      atm->symbol = d;
     193:	8b 45 10             	mov    0x10(%ebp),%eax
     196:	89 43 04             	mov    %eax,0x4(%ebx)
}
     199:	8d 65 f4             	lea    -0xc(%ebp),%esp
     19c:	5b                   	pop    %ebx
     19d:	5e                   	pop    %esi
     19e:	5f                   	pop    %edi
     19f:	5d                   	pop    %ebp
     1a0:	c3                   	ret    
     1a1:	eb 0d                	jmp    1b0 <storeexp>
     1a3:	90                   	nop
     1a4:	90                   	nop
     1a5:	90                   	nop
     1a6:	90                   	nop
     1a7:	90                   	nop
     1a8:	90                   	nop
     1a9:	90                   	nop
     1aa:	90                   	nop
     1ab:	90                   	nop
     1ac:	90                   	nop
     1ad:	90                   	nop
     1ae:	90                   	nop
     1af:	90                   	nop

000001b0 <storeexp>:
void storeexp(struct sexp **st, struct sexp *exp) {
     1b0:	55                   	push   %ebp
     1b1:	89 e5                	mov    %esp,%ebp
     1b3:	57                   	push   %edi
     1b4:	56                   	push   %esi
     1b5:	53                   	push   %ebx
     1b6:	83 ec 0c             	sub    $0xc,%esp
     1b9:	8b 75 0c             	mov    0xc(%ebp),%esi
     1bc:	8b 55 08             	mov    0x8(%ebp),%edx
  switch (exp->type) {
     1bf:	8b 06                	mov    (%esi),%eax
     1c1:	83 f8 01             	cmp    $0x1,%eax
     1c4:	74 52                	je     218 <storeexp+0x68>
     1c6:	85 c0                	test   %eax,%eax
     1c8:	0f 8e 7c 00 00 00    	jle    24a <storeexp+0x9a>
     1ce:	83 f8 03             	cmp    $0x3,%eax
     1d1:	7f 77                	jg     24a <storeexp+0x9a>
    lst0 = (struct list *)*st;
     1d3:	8b 3a                	mov    (%edx),%edi
    for (i = 0; i < lst->length; i++) {
     1d5:	31 db                	xor    %ebx,%ebx
    lst0->type = lst->type;
     1d7:	89 07                	mov    %eax,(%edi)
    lst0->length = lst->length;
     1d9:	8b 46 04             	mov    0x4(%esi),%eax
     1dc:	89 47 04             	mov    %eax,0x4(%edi)
    *st += sizeof(struct list);
     1df:	8b 02                	mov    (%edx),%eax
     1e1:	05 c0 00 00 00       	add    $0xc0,%eax
     1e6:	89 02                	mov    %eax,(%edx)
    for (i = 0; i < lst->length; i++) {
     1e8:	8b 4e 04             	mov    0x4(%esi),%ecx
     1eb:	85 c9                	test   %ecx,%ecx
     1ed:	7e 5b                	jle    24a <storeexp+0x9a>
      storeexp(st, lst->sexps[i]);
     1ef:	83 ec 08             	sub    $0x8,%esp
      lst0->sexps[i] = *st;
     1f2:	89 44 9f 08          	mov    %eax,0x8(%edi,%ebx,4)
      storeexp(st, lst->sexps[i]);
     1f6:	ff 74 9e 08          	pushl  0x8(%esi,%ebx,4)
    for (i = 0; i < lst->length; i++) {
     1fa:	83 c3 01             	add    $0x1,%ebx
      storeexp(st, lst->sexps[i]);
     1fd:	52                   	push   %edx
     1fe:	89 55 08             	mov    %edx,0x8(%ebp)
     201:	e8 aa ff ff ff       	call   1b0 <storeexp>
    for (i = 0; i < lst->length; i++) {
     206:	83 c4 10             	add    $0x10,%esp
     209:	39 5e 04             	cmp    %ebx,0x4(%esi)
     20c:	7e 3c                	jle    24a <storeexp+0x9a>
     20e:	8b 55 08             	mov    0x8(%ebp),%edx
     211:	8b 02                	mov    (%edx),%eax
     213:	eb da                	jmp    1ef <storeexp+0x3f>
     215:	8d 76 00             	lea    0x0(%esi),%esi
    atm0 = (struct atom *)*st;
     218:	8b 1a                	mov    (%edx),%ebx
    strcpy((char *)atm0 + sizeof(struct atom), atm->symbol);
     21a:	83 ec 08             	sub    $0x8,%esp
    atm0 = (struct atom *)*st;
     21d:	89 55 08             	mov    %edx,0x8(%ebp)
    strcpy((char *)atm0 + sizeof(struct atom), atm->symbol);
     220:	8d 7b 0c             	lea    0xc(%ebx),%edi
    atm0->type = ATOM;
     223:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    strcpy((char *)atm0 + sizeof(struct atom), atm->symbol);
     229:	ff 76 04             	pushl  0x4(%esi)
     22c:	57                   	push   %edi
     22d:	e8 2e 0d 00 00       	call   f60 <strcpy>
    *st += sizeof(struct atom) + (atm->esymbol - atm->symbol);
     232:	8b 55 08             	mov    0x8(%ebp),%edx
    atm0->symbol = (char *)atm0 + sizeof(struct atom);
     235:	89 7b 04             	mov    %edi,0x4(%ebx)
    *st += sizeof(struct atom) + (atm->esymbol - atm->symbol);
     238:	83 c4 10             	add    $0x10,%esp
     23b:	8b 46 08             	mov    0x8(%esi),%eax
     23e:	2b 46 04             	sub    0x4(%esi),%eax
     241:	8d 04 85 30 00 00 00 	lea    0x30(,%eax,4),%eax
     248:	01 02                	add    %eax,(%edx)
}
     24a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     24d:	5b                   	pop    %ebx
     24e:	5e                   	pop    %esi
     24f:	5f                   	pop    %edi
     250:	5d                   	pop    %ebp
     251:	c3                   	ret    
     252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <defunc>:
void defunc(struct list *lst) {
     260:	55                   	push   %ebp
     261:	89 e5                	mov    %esp,%ebp
     263:	57                   	push   %edi
     264:	56                   	push   %esi
     265:	53                   	push   %ebx
     266:	83 ec 28             	sub    $0x28,%esp
     269:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct shared *sh = (struct shared *)getsharem(1);
     26c:	6a 01                	push   $0x1
     26e:	e8 e6 0f 00 00       	call   1259 <getsharem>
  struct list *argv = (struct list *)lst->sexps[2];
     273:	8b 77 10             	mov    0x10(%edi),%esi
  struct func *fn = &sh->funcs[sh->nfunc];
     276:	8b 10                	mov    (%eax),%edx
  struct shared *sh = (struct shared *)getsharem(1);
     278:	89 c3                	mov    %eax,%ebx
  sh->nfunc++;
     27a:	8d 42 01             	lea    0x1(%edx),%eax
     27d:	6b d2 78             	imul   $0x78,%edx,%edx
     280:	89 03                	mov    %eax,(%ebx)
  strcpy(fn->name, ((struct atom *)lst->sexps[1])->symbol);
     282:	58                   	pop    %eax
     283:	8b 47 0c             	mov    0xc(%edi),%eax
     286:	59                   	pop    %ecx
     287:	ff 70 04             	pushl  0x4(%eax)
     28a:	8d 44 13 04          	lea    0x4(%ebx,%edx,1),%eax
     28e:	50                   	push   %eax
     28f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
     292:	e8 c9 0c 00 00       	call   f60 <strcpy>
  fn->argc = argv->length;
     297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     29a:	8b 4e 04             	mov    0x4(%esi),%ecx
     29d:	8d 04 13             	lea    (%ebx,%edx,1),%eax
     2a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
     2a3:	89 48 74             	mov    %ecx,0x74(%eax)
  struct sexp *st = (struct sexp *)sh->top;
     2a6:	8b 8b c8 09 00 00    	mov    0x9c8(%ebx),%ecx
  fn->argc = argv->length;
     2ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  storeexp((struct sexp **)&sh->top, lst->sexps[3]);
     2af:	58                   	pop    %eax
     2b0:	5a                   	pop    %edx
     2b1:	ff 77 14             	pushl  0x14(%edi)
     2b4:	8d bb c8 09 00 00    	lea    0x9c8(%ebx),%edi
     2ba:	57                   	push   %edi
  struct sexp *st = (struct sexp *)sh->top;
     2bb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  storeexp((struct sexp **)&sh->top, lst->sexps[3]);
     2be:	e8 ed fe ff ff       	call   1b0 <storeexp>
  fn->sexp = st;
     2c3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     2c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  for (i = 0; i < fn->argc; i++)
     2c9:	83 c4 10             	add    $0x10,%esp
     2cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  fn->sexp = st;
     2cf:	89 48 78             	mov    %ecx,0x78(%eax)
  for (i = 0; i < fn->argc; i++)
     2d2:	8b 48 74             	mov    0x74(%eax),%ecx
     2d5:	8d 7c 13 0e          	lea    0xe(%ebx,%edx,1),%edi
     2d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     2dc:	85 c9                	test   %ecx,%ecx
     2de:	7e 29                	jle    309 <defunc+0xa9>
     2e0:	31 db                	xor    %ebx,%ebx
     2e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    strcpy(fn->argv[i], ((struct atom *)argv->sexps[i])->symbol);
     2e8:	8b 44 9e 08          	mov    0x8(%esi,%ebx,4),%eax
     2ec:	83 ec 08             	sub    $0x8,%esp
  for (i = 0; i < fn->argc; i++)
     2ef:	83 c3 01             	add    $0x1,%ebx
    strcpy(fn->argv[i], ((struct atom *)argv->sexps[i])->symbol);
     2f2:	ff 70 04             	pushl  0x4(%eax)
     2f5:	57                   	push   %edi
     2f6:	83 c7 0a             	add    $0xa,%edi
     2f9:	e8 62 0c 00 00       	call   f60 <strcpy>
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
     311:	eb 0d                	jmp    320 <fromint>
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

00000320 <fromint>:
{
     320:	55                   	push   %ebp
     321:	89 e5                	mov    %esp,%ebp
     323:	53                   	push   %ebx
     324:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(i=0;i<n;i++)
     327:	85 db                	test   %ebx,%ebx
     329:	74 25                	je     350 <fromint+0x30>
     32b:	8b 55 08             	mov    0x8(%ebp),%edx
  int s=0,i;
     32e:	31 c0                	xor    %eax,%eax
     330:	01 d3                	add    %edx,%ebx
     332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s*=10;
     338:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
    s+=v[i]-'0';
     33b:	0f be 02             	movsbl (%edx),%eax
     33e:	83 c2 01             	add    $0x1,%edx
     341:	8d 44 48 d0          	lea    -0x30(%eax,%ecx,2),%eax
  for(i=0;i<n;i++)
     345:	39 d3                	cmp    %edx,%ebx
     347:	75 ef                	jne    338 <fromint+0x18>
}
     349:	5b                   	pop    %ebx
     34a:	5d                   	pop    %ebp
     34b:	c3                   	ret    
     34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int s=0,i;
     350:	31 c0                	xor    %eax,%eax
}
     352:	5b                   	pop    %ebx
     353:	5d                   	pop    %ebp
     354:	c3                   	ret    
     355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000360 <getcmd>:
int getcmd(char *buf, int nbuf) {
     360:	55                   	push   %ebp
     361:	89 e5                	mov    %esp,%ebp
     363:	56                   	push   %esi
     364:	53                   	push   %ebx
     365:	8b 75 0c             	mov    0xc(%ebp),%esi
     368:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "> ");
     36b:	83 ec 08             	sub    $0x8,%esp
     36e:	68 c8 16 00 00       	push   $0x16c8
     373:	6a 02                	push   $0x2
     375:	e8 e6 0f 00 00       	call   1360 <printf>
  memset(buf, 0, nbuf);
     37a:	83 c4 0c             	add    $0xc,%esp
     37d:	56                   	push   %esi
     37e:	6a 00                	push   $0x0
     380:	53                   	push   %ebx
     381:	e8 8a 0c 00 00       	call   1010 <memset>
  gets(buf, nbuf);
     386:	58                   	pop    %eax
     387:	5a                   	pop    %edx
     388:	56                   	push   %esi
     389:	53                   	push   %ebx
     38a:	e8 e1 0c 00 00       	call   1070 <gets>
  if (buf[0] == 0) // EOF
     38f:	83 c4 10             	add    $0x10,%esp
     392:	31 c0                	xor    %eax,%eax
     394:	80 3b 00             	cmpb   $0x0,(%ebx)
     397:	0f 94 c0             	sete   %al
}
     39a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     39d:	5b                   	pop    %ebx
  if (buf[0] == 0) // EOF
     39e:	f7 d8                	neg    %eax
}
     3a0:	5e                   	pop    %esi
     3a1:	5d                   	pop    %ebp
     3a2:	c3                   	ret    
     3a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <panic>:
void panic(char *s) {
     3b0:	55                   	push   %ebp
     3b1:	89 e5                	mov    %esp,%ebp
     3b3:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     3b6:	ff 75 08             	pushl  0x8(%ebp)
     3b9:	68 40 17 00 00       	push   $0x1740
     3be:	6a 02                	push   $0x2
     3c0:	e8 9b 0f 00 00       	call   1360 <printf>
  exit();
     3c5:	e8 e7 0d 00 00       	call   11b1 <exit>
     3ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003d0 <runexp>:
void runexp(struct sexp *exp) {
     3d0:	55                   	push   %ebp
     3d1:	89 e5                	mov    %esp,%ebp
     3d3:	57                   	push   %edi
     3d4:	56                   	push   %esi
     3d5:	53                   	push   %ebx
     3d6:	81 ec cc 00 00 00    	sub    $0xcc,%esp
     3dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if (exp == 0)
     3df:	85 ff                	test   %edi,%edi
     3e1:	0f 84 c9 01 00 00    	je     5b0 <runexp+0x1e0>
  switch (exp->type) {
     3e7:	8b 07                	mov    (%edi),%eax
     3e9:	83 f8 02             	cmp    $0x2,%eax
     3ec:	74 22                	je     410 <runexp+0x40>
     3ee:	83 f8 03             	cmp    $0x3,%eax
     3f1:	0f 84 be 01 00 00    	je     5b5 <runexp+0x1e5>
     3f7:	83 f8 01             	cmp    $0x1,%eax
     3fa:	0f 84 b0 01 00 00    	je     5b0 <runexp+0x1e0>
    panic("runexp type error");
     400:	83 ec 0c             	sub    $0xc,%esp
     403:	68 cb 16 00 00       	push   $0x16cb
     408:	e8 a3 ff ff ff       	call   3b0 <panic>
     40d:	8d 76 00             	lea    0x0(%esi),%esi
    for (i = 0; i < lst->length; i++)
     410:	8b 5f 04             	mov    0x4(%edi),%ebx
     413:	85 db                	test   %ebx,%ebx
     415:	0f 8e 95 01 00 00    	jle    5b0 <runexp+0x1e0>
      runexp(lst->sexps[i]);
     41b:	83 ec 0c             	sub    $0xc,%esp
     41e:	ff 77 08             	pushl  0x8(%edi)
     421:	e8 aa ff ff ff       	call   3d0 <runexp>
     426:	8d 76 00             	lea    0x0(%esi),%esi
     429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if ((i == 0) && (strcmp(argv[0], "defun") == 0)) {
     430:	83 ec 08             	sub    $0x8,%esp
     433:	68 f7 16 00 00       	push   $0x16f7
     438:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     43e:	e8 4d 0b 00 00       	call   f90 <strcmp>
     443:	83 c4 10             	add    $0x10,%esp
     446:	85 c0                	test   %eax,%eax
     448:	0f 84 4d 04 00 00    	je     89b <runexp+0x4cb>
      if ((i == 0) && (strcmp(argv[0], "if") == 0)) {
     44e:	83 ec 08             	sub    $0x8,%esp
     451:	68 32 17 00 00       	push   $0x1732
     456:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     45c:	e8 2f 0b 00 00       	call   f90 <strcmp>
     461:	83 c4 10             	add    $0x10,%esp
     464:	85 c0                	test   %eax,%eax
     466:	0f 84 67 04 00 00    	je     8d3 <runexp+0x503>
      if ((i == 0) && (strcmp(argv[0], "equal") == 0)) {
     46c:	83 ec 08             	sub    $0x8,%esp
     46f:	68 2c 17 00 00       	push   $0x172c
     474:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     47a:	e8 11 0b 00 00       	call   f90 <strcmp>
     47f:	83 c4 10             	add    $0x10,%esp
     482:	85 c0                	test   %eax,%eax
     484:	0f 84 cd 04 00 00    	je     957 <runexp+0x587>
      if ((i == 0) && (strcmp(argv[0], "minus") == 0)) {
     48a:	83 ec 08             	sub    $0x8,%esp
     48d:	68 26 17 00 00       	push   $0x1726
     492:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     498:	e8 f3 0a 00 00       	call   f90 <strcmp>
     49d:	83 c4 10             	add    $0x10,%esp
     4a0:	85 c0                	test   %eax,%eax
     4a2:	0f 84 0a 05 00 00    	je     9b2 <runexp+0x5e2>
      if ((i == 0) && (strcmp(argv[0], "repeat") == 0)) {
     4a8:	83 ec 08             	sub    $0x8,%esp
     4ab:	68 1f 17 00 00       	push   $0x171f
     4b0:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     4b6:	e8 d5 0a 00 00       	call   f90 <strcmp>
     4bb:	83 c4 10             	add    $0x10,%esp
     4be:	85 c0                	test   %eax,%eax
     4c0:	0f 84 43 05 00 00    	je     a09 <runexp+0x639>
      if ((i == 0) && (strcmp(argv[0], "pend") == 0)) {
     4c6:	83 ec 08             	sub    $0x8,%esp
     4c9:	68 1a 17 00 00       	push   $0x171a
     4ce:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     4d4:	e8 b7 0a 00 00       	call   f90 <strcmp>
     4d9:	83 c4 10             	add    $0x10,%esp
     4dc:	85 c0                	test   %eax,%eax
     4de:	0f 84 30 04 00 00    	je     914 <runexp+0x544>
      if ((i == 0) && (strcmp(argv[0], "con") == 0)) {
     4e4:	83 ec 08             	sub    $0x8,%esp
     4e7:	68 16 17 00 00       	push   $0x1716
     4ec:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     4f2:	e8 99 0a 00 00       	call   f90 <strcmp>
     4f7:	83 c4 10             	add    $0x10,%esp
     4fa:	85 c0                	test   %eax,%eax
     4fc:	0f 84 51 05 00 00    	je     a53 <runexp+0x683>
      if ((i == 0) && (strcmp(argv[0], "clk") == 0)) {
     502:	83 ec 08             	sub    $0x8,%esp
     505:	68 12 17 00 00       	push   $0x1712
     50a:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     510:	e8 7b 0a 00 00       	call   f90 <strcmp>
     515:	83 c4 10             	add    $0x10,%esp
     518:	85 c0                	test   %eax,%eax
     51a:	0f 84 68 05 00 00    	je     a88 <runexp+0x6b8>
      if ((i == 0) && (strcmp(argv[0], "pipe") == 0)) {
     520:	83 ec 08             	sub    $0x8,%esp
     523:	68 0d 17 00 00       	push   $0x170d
     528:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     52e:	e8 5d 0a 00 00       	call   f90 <strcmp>
     533:	83 c4 10             	add    $0x10,%esp
     536:	85 c0                	test   %eax,%eax
     538:	0f 85 a8 00 00 00    	jne    5e6 <runexp+0x216>
        if(pipe(p) < 0)
     53e:	83 ec 0c             	sub    $0xc,%esp
     541:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
     547:	8b 7d 08             	mov    0x8(%ebp),%edi
     54a:	50                   	push   %eax
     54b:	e8 71 0c 00 00       	call   11c1 <pipe>
     550:	83 c4 10             	add    $0x10,%esp
     553:	85 c0                	test   %eax,%eax
     555:	0f 88 94 05 00 00    	js     aef <runexp+0x71f>
  pid = fork();
     55b:	e8 49 0c 00 00       	call   11a9 <fork>
  if (pid == -1)
     560:	83 f8 ff             	cmp    $0xffffffff,%eax
     563:	0f 84 2f 06 00 00    	je     b98 <runexp+0x7c8>
        if(fork1() == 0){
     569:	85 c0                	test   %eax,%eax
     56b:	0f 84 e4 05 00 00    	je     b55 <runexp+0x785>
  pid = fork();
     571:	e8 33 0c 00 00       	call   11a9 <fork>
  if (pid == -1)
     576:	83 f8 ff             	cmp    $0xffffffff,%eax
     579:	0f 84 19 06 00 00    	je     b98 <runexp+0x7c8>
        if(fork1() == 0){
     57f:	85 c0                	test   %eax,%eax
     581:	0f 84 8b 05 00 00    	je     b12 <runexp+0x742>
        close(p[0]);
     587:	83 ec 0c             	sub    $0xc,%esp
     58a:	ff b5 54 ff ff ff    	pushl  -0xac(%ebp)
     590:	e8 44 0c 00 00       	call   11d9 <close>
        close(p[1]);
     595:	5b                   	pop    %ebx
     596:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
     59c:	e8 38 0c 00 00       	call   11d9 <close>
        wait();
     5a1:	e8 13 0c 00 00       	call   11b9 <wait>
        wait();
     5a6:	e8 0e 0c 00 00       	call   11b9 <wait>
        break;
     5ab:	83 c4 10             	add    $0x10,%esp
     5ae:	66 90                	xchg   %ax,%ax
  exit();
     5b0:	e8 fc 0b 00 00       	call   11b1 <exit>
    argv[lst->length] = 0;
     5b5:	8b 47 04             	mov    0x4(%edi),%eax
     5b8:	c7 84 85 5c ff ff ff 	movl   $0x0,-0xa4(%ebp,%eax,4)
     5bf:	00 00 00 00 
    for (i = 0; i < lst->length; i++) {
     5c3:	85 c0                	test   %eax,%eax
     5c5:	7e e9                	jle    5b0 <runexp+0x1e0>
     5c7:	31 f6                	xor    %esi,%esi
     5c9:	89 7d 08             	mov    %edi,0x8(%ebp)
     5cc:	eb 30                	jmp    5fe <runexp+0x22e>
     5ce:	66 90                	xchg   %ax,%ax
      else if (lst->sexps[i]->type == LIST)
     5d0:	83 f8 02             	cmp    $0x2,%eax
     5d3:	0f 84 b5 02 00 00    	je     88e <runexp+0x4be>
      else if (lst->sexps[i]->type == APPLY) {
     5d9:	83 f8 03             	cmp    $0x3,%eax
     5dc:	74 3a                	je     618 <runexp+0x248>
      if ((i == 0) && (strcmp(argv[0], "defun") == 0)) {
     5de:	85 f6                	test   %esi,%esi
     5e0:	0f 84 4a fe ff ff    	je     430 <runexp+0x60>
      if (i == lst->length - 1) {
     5e6:	8b 45 08             	mov    0x8(%ebp),%eax
     5e9:	8b 40 04             	mov    0x4(%eax),%eax
     5ec:	8d 50 ff             	lea    -0x1(%eax),%edx
     5ef:	39 f2                	cmp    %esi,%edx
     5f1:	0f 84 85 00 00 00    	je     67c <runexp+0x2ac>
    for (i = 0; i < lst->length; i++) {
     5f7:	83 c6 01             	add    $0x1,%esi
     5fa:	39 f0                	cmp    %esi,%eax
     5fc:	7e b2                	jle    5b0 <runexp+0x1e0>
      if (lst->sexps[i]->type == ATOM)
     5fe:	8b 45 08             	mov    0x8(%ebp),%eax
     601:	8b 54 b0 08          	mov    0x8(%eax,%esi,4),%edx
     605:	8b 02                	mov    (%edx),%eax
     607:	83 f8 01             	cmp    $0x1,%eax
     60a:	75 c4                	jne    5d0 <runexp+0x200>
        argv[i] = ((struct atom *)lst->sexps[i])->symbol;
     60c:	8b 42 04             	mov    0x4(%edx),%eax
     60f:	89 84 b5 5c ff ff ff 	mov    %eax,-0xa4(%ebp,%esi,4)
     616:	eb c6                	jmp    5de <runexp+0x20e>
        close(1);
     618:	83 ec 0c             	sub    $0xc,%esp
     61b:	6a 01                	push   $0x1
     61d:	e8 b7 0b 00 00       	call   11d9 <close>
        memo();
     622:	e8 4a 0c 00 00       	call   1271 <memo>
  pid = fork();
     627:	e8 7d 0b 00 00       	call   11a9 <fork>
  if (pid == -1)
     62c:	83 c4 10             	add    $0x10,%esp
     62f:	83 f8 ff             	cmp    $0xffffffff,%eax
     632:	0f 84 60 05 00 00    	je     b98 <runexp+0x7c8>
        if (fork1() == 0) {
     638:	85 c0                	test   %eax,%eax
     63a:	0f 84 98 04 00 00    	je     ad8 <runexp+0x708>
        wait();
     640:	e8 74 0b 00 00       	call   11b9 <wait>
        close(1);
     645:	83 ec 0c             	sub    $0xc,%esp
     648:	6b de 0a             	imul   $0xa,%esi,%ebx
     64b:	6a 01                	push   $0x1
     64d:	e8 87 0b 00 00       	call   11d9 <close>
        open("console", O_RDWR);
     652:	58                   	pop    %eax
     653:	5a                   	pop    %edx
     654:	6a 02                	push   $0x2
     656:	68 ef 16 00 00       	push   $0x16ef
     65b:	e8 91 0b 00 00       	call   11f1 <open>
        getmemo(xargv[i]);
     660:	8d 45 84             	lea    -0x7c(%ebp),%eax
     663:	01 c3                	add    %eax,%ebx
     665:	89 1c 24             	mov    %ebx,(%esp)
     668:	e8 0c 0c 00 00       	call   1279 <getmemo>
        argv[i] = xargv[i];
     66d:	89 9c b5 5c ff ff ff 	mov    %ebx,-0xa4(%ebp,%esi,4)
     674:	83 c4 10             	add    $0x10,%esp
     677:	e9 62 ff ff ff       	jmp    5de <runexp+0x20e>
        struct shared *sh = (struct shared *)getsharem(1);
     67c:	83 ec 0c             	sub    $0xc,%esp
     67f:	6a 01                	push   $0x1
     681:	e8 d3 0b 00 00       	call   1259 <getsharem>
     686:	31 d2                	xor    %edx,%edx
        for (j = 0; j < MAXFUNC; j++) {
     688:	31 c9                	xor    %ecx,%ecx
     68a:	89 b5 44 ff ff ff    	mov    %esi,-0xbc(%ebp)
        struct shared *sh = (struct shared *)getsharem(1);
     690:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
     696:	83 c4 10             	add    $0x10,%esp
     699:	8d 78 04             	lea    0x4(%eax),%edi
     69c:	89 d3                	mov    %edx,%ebx
     69e:	89 ce                	mov    %ecx,%esi
     6a0:	eb 15                	jmp    6b7 <runexp+0x2e7>
     6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        for (j = 0; j < MAXFUNC; j++) {
     6a8:	83 c6 01             	add    $0x1,%esi
     6ab:	83 c3 78             	add    $0x78,%ebx
     6ae:	83 fe 14             	cmp    $0x14,%esi
     6b1:	0f 84 a9 01 00 00    	je     860 <runexp+0x490>
          if (strcmp(argv[0], sh->funcs[j].name) == 0) {
     6b7:	83 ec 08             	sub    $0x8,%esp
     6ba:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
     6bd:	50                   	push   %eax
     6be:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     6c4:	e8 c7 08 00 00       	call   f90 <strcmp>
     6c9:	83 c4 10             	add    $0x10,%esp
     6cc:	85 c0                	test   %eax,%eax
     6ce:	75 d8                	jne    6a8 <runexp+0x2d8>
     6d0:	89 da                	mov    %ebx,%edx
     6d2:	89 c3                	mov    %eax,%ebx
     6d4:	89 f0                	mov    %esi,%eax
            argv[sh->funcs[j].argc+1] = 0;
     6d6:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
     6dc:	6b c0 78             	imul   $0x78,%eax,%eax
     6df:	89 b5 3c ff ff ff    	mov    %esi,-0xc4(%ebp)
     6e5:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
            for (k = 0; k < MAXARGS; k++) {
     6eb:	31 ff                	xor    %edi,%edi
     6ed:	89 95 34 ff ff ff    	mov    %edx,-0xcc(%ebp)
     6f3:	81 c1 64 09 00 00    	add    $0x964,%ecx
     6f9:	89 9d 38 ff ff ff    	mov    %ebx,-0xc8(%ebp)
     6ff:	89 fb                	mov    %edi,%ebx
            argv[sh->funcs[j].argc+1] = 0;
     701:	8b 84 01 10 f7 ff ff 	mov    -0x8f0(%ecx,%eax,1),%eax
     708:	89 b5 30 ff ff ff    	mov    %esi,-0xd0(%ebp)
     70e:	89 ce                	mov    %ecx,%esi
     710:	c7 84 85 60 ff ff ff 	movl   $0x0,-0xa0(%ebp,%eax,4)
     717:	00 00 00 00 
            for (k = 0; k < MAXARGS; k++) {
     71b:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
     721:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
     727:	89 c7                	mov    %eax,%edi
              if (argv[k] == 0)
     729:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
     72c:	85 c0                	test   %eax,%eax
     72e:	74 17                	je     747 <runexp+0x377>
              strcpy(sh->xargv[k], argv[k]);
     730:	51                   	push   %ecx
            for (k = 0; k < MAXARGS; k++) {
     731:	83 c3 01             	add    $0x1,%ebx
              strcpy(sh->xargv[k], argv[k]);
     734:	51                   	push   %ecx
     735:	50                   	push   %eax
     736:	56                   	push   %esi
     737:	83 c6 0a             	add    $0xa,%esi
     73a:	e8 21 08 00 00       	call   f60 <strcpy>
            for (k = 0; k < MAXARGS; k++) {
     73f:	83 c4 10             	add    $0x10,%esp
     742:	83 fb 0a             	cmp    $0xa,%ebx
     745:	75 e2                	jne    729 <runexp+0x359>
            for (k = 0; k < sh->funcs[j].argc; k++)
     747:	6b 8d 3c ff ff ff 78 	imul   $0x78,-0xc4(%ebp),%ecx
     74e:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
     754:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
     75a:	8b 9d 38 ff ff ff    	mov    -0xc8(%ebp),%ebx
     760:	8b b5 30 ff ff ff    	mov    -0xd0(%ebp),%esi
     766:	01 c1                	add    %eax,%ecx
     768:	8d 7c 10 0e          	lea    0xe(%eax,%edx,1),%edi
     76c:	83 79 74 00          	cmpl   $0x0,0x74(%ecx)
     770:	7e 58                	jle    7ca <runexp+0x3fa>
              replaceAtom(sh->funcs[j].sexp, sh->funcs[j].argv[k], sh->xargv[k + 1]);
     772:	b8 60 09 00 00       	mov    $0x960,%eax
     777:	89 b5 38 ff ff ff    	mov    %esi,-0xc8(%ebp)
     77d:	89 fe                	mov    %edi,%esi
     77f:	89 cf                	mov    %ecx,%edi
     781:	29 d0                	sub    %edx,%eax
     783:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
     789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     790:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
     796:	83 ec 04             	sub    $0x4,%esp
     799:	83 c3 01             	add    $0x1,%ebx
     79c:	01 f0                	add    %esi,%eax
     79e:	50                   	push   %eax
     79f:	56                   	push   %esi
     7a0:	ff 77 78             	pushl  0x78(%edi)
     7a3:	e8 88 f9 ff ff       	call   130 <replaceAtom>
              strcpy(sh->funcs[j].argv[k],argv[k+1]);
     7a8:	58                   	pop    %eax
     7a9:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
     7af:	5a                   	pop    %edx
     7b0:	ff 34 98             	pushl  (%eax,%ebx,4)
     7b3:	56                   	push   %esi
     7b4:	83 c6 0a             	add    $0xa,%esi
     7b7:	e8 a4 07 00 00       	call   f60 <strcpy>
            for (k = 0; k < sh->funcs[j].argc; k++)
     7bc:	83 c4 10             	add    $0x10,%esp
     7bf:	3b 5f 74             	cmp    0x74(%edi),%ebx
     7c2:	7c cc                	jl     790 <runexp+0x3c0>
     7c4:	8b b5 38 ff ff ff    	mov    -0xc8(%ebp),%esi
            flg = 1;
     7ca:	bb 01 00 00 00       	mov    $0x1,%ebx
  pid = fork();
     7cf:	e8 d5 09 00 00       	call   11a9 <fork>
  if (pid == -1)
     7d4:	83 f8 ff             	cmp    $0xffffffff,%eax
     7d7:	0f 84 bb 03 00 00    	je     b98 <runexp+0x7c8>
        if (fork1() == 0) {
     7dd:	85 c0                	test   %eax,%eax
     7df:	75 6f                	jne    850 <runexp+0x480>
          getsharem(1);
     7e1:	83 ec 0c             	sub    $0xc,%esp
     7e4:	6a 01                	push   $0x1
     7e6:	e8 6e 0a 00 00       	call   1259 <getsharem>
          if (argv[0] == 0)
     7eb:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
     7f1:	83 c4 10             	add    $0x10,%esp
     7f4:	85 c0                	test   %eax,%eax
     7f6:	0f 84 b4 fd ff ff    	je     5b0 <runexp+0x1e0>
          if (flg == 1) {
     7fc:	83 eb 01             	sub    $0x1,%ebx
     7ff:	74 72                	je     873 <runexp+0x4a3>
     801:	8d 8d 5c ff ff ff    	lea    -0xa4(%ebp),%ecx
     807:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
     80a:	89 8d 44 ff ff ff    	mov    %ecx,-0xbc(%ebp)
     810:	89 cf                	mov    %ecx,%edi
     812:	eb 0d                	jmp    821 <runexp+0x451>
              if (argv[j] == 0)
     814:	8b 47 04             	mov    0x4(%edi),%eax
     817:	83 c3 0a             	add    $0xa,%ebx
     81a:	83 c7 04             	add    $0x4,%edi
     81d:	85 c0                	test   %eax,%eax
     81f:	74 19                	je     83a <runexp+0x46a>
              if(argv[j]!=xargv[j])
     821:	39 c3                	cmp    %eax,%ebx
     823:	74 0e                	je     833 <runexp+0x463>
                strcpy(xargv[j], argv[j]);
     825:	52                   	push   %edx
     826:	52                   	push   %edx
     827:	50                   	push   %eax
     828:	53                   	push   %ebx
     829:	e8 32 07 00 00       	call   f60 <strcpy>
                argv[j] = xargv[j];
     82e:	89 1f                	mov    %ebx,(%edi)
     830:	83 c4 10             	add    $0x10,%esp
            for (j = 0; j < MAXARGS; j++) {
     833:	8d 45 de             	lea    -0x22(%ebp),%eax
     836:	39 d8                	cmp    %ebx,%eax
     838:	75 da                	jne    814 <runexp+0x444>
            exec(argv[0], argv);
     83a:	50                   	push   %eax
     83b:	50                   	push   %eax
     83c:	ff b5 44 ff ff ff    	pushl  -0xbc(%ebp)
     842:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
     848:	e8 9c 09 00 00       	call   11e9 <exec>
     84d:	83 c4 10             	add    $0x10,%esp
        wait();
     850:	e8 64 09 00 00       	call   11b9 <wait>
     855:	8b 45 08             	mov    0x8(%ebp),%eax
     858:	8b 40 04             	mov    0x4(%eax),%eax
     85b:	e9 97 fd ff ff       	jmp    5f7 <runexp+0x227>
     860:	89 b5 3c ff ff ff    	mov    %esi,-0xc4(%ebp)
        int j, k, flg = 0;
     866:	31 db                	xor    %ebx,%ebx
     868:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
     86e:	e9 5c ff ff ff       	jmp    7cf <runexp+0x3ff>
            struct shared *sh = (struct shared *)getsharem(1);
     873:	83 ec 0c             	sub    $0xc,%esp
     876:	6a 01                	push   $0x1
     878:	e8 dc 09 00 00       	call   1259 <getsharem>
            runexp(sh->funcs[j].sexp);
     87d:	6b 95 3c ff ff ff 78 	imul   $0x78,-0xc4(%ebp),%edx
     884:	59                   	pop    %ecx
     885:	ff 74 10 78          	pushl  0x78(%eax,%edx,1)
     889:	e8 42 fb ff ff       	call   3d0 <runexp>
        panic("syntax error");
     88e:	83 ec 0c             	sub    $0xc,%esp
     891:	68 dd 16 00 00       	push   $0x16dd
     896:	e8 15 fb ff ff       	call   3b0 <panic>
     89b:	8b 7d 08             	mov    0x8(%ebp),%edi
  pid = fork();
     89e:	e8 06 09 00 00       	call   11a9 <fork>
  if (pid == -1)
     8a3:	83 f8 ff             	cmp    $0xffffffff,%eax
     8a6:	0f 84 ec 02 00 00    	je     b98 <runexp+0x7c8>
        if (fork1() == 0) {
     8ac:	85 c0                	test   %eax,%eax
     8ae:	75 19                	jne    8c9 <runexp+0x4f9>
          if (argv[0] == 0)
     8b0:	83 bd 5c ff ff ff 00 	cmpl   $0x0,-0xa4(%ebp)
     8b7:	0f 84 f3 fc ff ff    	je     5b0 <runexp+0x1e0>
          defunc(lst);
     8bd:	83 ec 0c             	sub    $0xc,%esp
     8c0:	57                   	push   %edi
     8c1:	e8 9a f9 ff ff       	call   260 <defunc>
     8c6:	83 c4 10             	add    $0x10,%esp
        wait();
     8c9:	e8 eb 08 00 00       	call   11b9 <wait>
        break;
     8ce:	e9 dd fc ff ff       	jmp    5b0 <runexp+0x1e0>
     8d3:	8b 7d 08             	mov    0x8(%ebp),%edi
        if(strcmp(t->symbol, ":true")==0)
     8d6:	50                   	push   %eax
     8d7:	50                   	push   %eax
     8d8:	68 fd 16 00 00       	push   $0x16fd
     8dd:	8b 47 0c             	mov    0xc(%edi),%eax
     8e0:	ff 70 04             	pushl  0x4(%eax)
     8e3:	e8 a8 06 00 00       	call   f90 <strcmp>
     8e8:	83 c4 10             	add    $0x10,%esp
     8eb:	85 c0                	test   %eax,%eax
     8ed:	74 43                	je     932 <runexp+0x562>
  pid = fork();
     8ef:	e8 b5 08 00 00       	call   11a9 <fork>
  if (pid == -1)
     8f4:	83 f8 ff             	cmp    $0xffffffff,%eax
     8f7:	0f 84 9b 02 00 00    	je     b98 <runexp+0x7c8>
          if(fork1()==0)
     8fd:	85 c0                	test   %eax,%eax
     8ff:	75 c8                	jne    8c9 <runexp+0x4f9>
            getsharem(1);
     901:	83 ec 0c             	sub    $0xc,%esp
     904:	6a 01                	push   $0x1
     906:	e8 4e 09 00 00       	call   1259 <getsharem>
            runexp(lst->sexps[3]);
     90b:	58                   	pop    %eax
     90c:	ff 77 14             	pushl  0x14(%edi)
     90f:	e8 bc fa ff ff       	call   3d0 <runexp>
     914:	8b 7d 08             	mov    0x8(%ebp),%edi
  pid = fork();
     917:	e8 8d 08 00 00       	call   11a9 <fork>
  if (pid == -1)
     91c:	83 f8 ff             	cmp    $0xffffffff,%eax
     91f:	0f 84 73 02 00 00    	je     b98 <runexp+0x7c8>
        if(fork1()==0)
     925:	85 c0                	test   %eax,%eax
     927:	0f 84 98 01 00 00    	je     ac5 <runexp+0x6f5>
        wait();
     92d:	e8 87 08 00 00       	call   11b9 <wait>
  pid = fork();
     932:	e8 72 08 00 00       	call   11a9 <fork>
  if (pid == -1)
     937:	83 f8 ff             	cmp    $0xffffffff,%eax
     93a:	0f 84 58 02 00 00    	je     b98 <runexp+0x7c8>
        if(fork1()==0)
     940:	85 c0                	test   %eax,%eax
     942:	75 85                	jne    8c9 <runexp+0x4f9>
          getsharem(1);
     944:	83 ec 0c             	sub    $0xc,%esp
     947:	6a 01                	push   $0x1
     949:	e8 0b 09 00 00       	call   1259 <getsharem>
          runexp(lst->sexps[2]);
     94e:	5b                   	pop    %ebx
     94f:	ff 77 10             	pushl  0x10(%edi)
     952:	e8 79 fa ff ff       	call   3d0 <runexp>
     957:	8b 7d 08             	mov    0x8(%ebp),%edi
        struct atom* t=(struct atom*)lst->sexps[1];
     95a:	8b 4f 0c             	mov    0xc(%edi),%ecx
        struct atom* r=(struct atom*)lst->sexps[2];
     95d:	8b 77 10             	mov    0x10(%edi),%esi
        int m=fromint(t->symbol,t->esymbol-t->symbol);
     960:	8b 51 04             	mov    0x4(%ecx),%edx
  for(i=0;i<n;i++)
     963:	8b 79 08             	mov    0x8(%ecx),%edi
  int s=0,i;
     966:	31 c9                	xor    %ecx,%ecx
     968:	eb 0d                	jmp    977 <runexp+0x5a7>
    s*=10;
     96a:	6b c9 0a             	imul   $0xa,%ecx,%ecx
    s+=v[i]-'0';
     96d:	0f be 1a             	movsbl (%edx),%ebx
     970:	83 c2 01             	add    $0x1,%edx
     973:	8d 4c 19 d0          	lea    -0x30(%ecx,%ebx,1),%ecx
  for(i=0;i<n;i++)
     977:	39 fa                	cmp    %edi,%edx
     979:	75 ef                	jne    96a <runexp+0x59a>
        int n=fromint(r->symbol,r->esymbol-r->symbol);
     97b:	8b 56 04             	mov    0x4(%esi),%edx
     97e:	8b 76 08             	mov    0x8(%esi),%esi
     981:	eb 0d                	jmp    990 <runexp+0x5c0>
    s*=10;
     983:	6b c0 0a             	imul   $0xa,%eax,%eax
    s+=v[i]-'0';
     986:	0f be 1a             	movsbl (%edx),%ebx
     989:	83 c2 01             	add    $0x1,%edx
     98c:	8d 44 18 d0          	lea    -0x30(%eax,%ebx,1),%eax
  for(i=0;i<n;i++)
     990:	39 f2                	cmp    %esi,%edx
     992:	75 ef                	jne    983 <runexp+0x5b3>
        if(m-n==0)
     994:	39 c8                	cmp    %ecx,%eax
     996:	0f 84 60 01 00 00    	je     afc <runexp+0x72c>
          printf(2, ":false");
     99c:	57                   	push   %edi
     99d:	57                   	push   %edi
     99e:	68 03 17 00 00       	push   $0x1703
     9a3:	6a 02                	push   $0x2
     9a5:	e8 b6 09 00 00       	call   1360 <printf>
     9aa:	83 c4 10             	add    $0x10,%esp
     9ad:	e9 fe fb ff ff       	jmp    5b0 <runexp+0x1e0>
     9b2:	8b 7d 08             	mov    0x8(%ebp),%edi
        struct atom* t=(struct atom*)lst->sexps[1];
     9b5:	8b 57 0c             	mov    0xc(%edi),%edx
        struct atom* r=(struct atom*)lst->sexps[2];
     9b8:	8b 77 10             	mov    0x10(%edi),%esi
        int m=fromint(t->symbol,t->esymbol-t->symbol);
     9bb:	8b 4a 04             	mov    0x4(%edx),%ecx
  for(i=0;i<n;i++)
     9be:	8b 7a 08             	mov    0x8(%edx),%edi
  int s=0,i;
     9c1:	31 d2                	xor    %edx,%edx
     9c3:	eb 0d                	jmp    9d2 <runexp+0x602>
    s*=10;
     9c5:	6b d2 0a             	imul   $0xa,%edx,%edx
    s+=v[i]-'0';
     9c8:	0f be 19             	movsbl (%ecx),%ebx
     9cb:	83 c1 01             	add    $0x1,%ecx
     9ce:	8d 54 1a d0          	lea    -0x30(%edx,%ebx,1),%edx
  for(i=0;i<n;i++)
     9d2:	39 cf                	cmp    %ecx,%edi
     9d4:	75 ef                	jne    9c5 <runexp+0x5f5>
        int n=fromint(r->symbol,r->esymbol-r->symbol);
     9d6:	8b 4e 04             	mov    0x4(%esi),%ecx
     9d9:	8b 76 08             	mov    0x8(%esi),%esi
     9dc:	eb 0d                	jmp    9eb <runexp+0x61b>
    s*=10;
     9de:	6b c0 0a             	imul   $0xa,%eax,%eax
    s+=v[i]-'0';
     9e1:	0f be 19             	movsbl (%ecx),%ebx
     9e4:	83 c1 01             	add    $0x1,%ecx
     9e7:	8d 44 18 d0          	lea    -0x30(%eax,%ebx,1),%eax
  for(i=0;i<n;i++)
     9eb:	39 f1                	cmp    %esi,%ecx
     9ed:	75 ef                	jne    9de <runexp+0x60e>
        printf(1,"%d", m-n);
     9ef:	56                   	push   %esi
     9f0:	29 c2                	sub    %eax,%edx
     9f2:	89 d0                	mov    %edx,%eax
        printf(1, "%d", tm);
     9f4:	50                   	push   %eax
     9f5:	68 0a 17 00 00       	push   $0x170a
     9fa:	6a 01                	push   $0x1
     9fc:	e8 5f 09 00 00       	call   1360 <printf>
        break;
     a01:	83 c4 10             	add    $0x10,%esp
     a04:	e9 a7 fb ff ff       	jmp    5b0 <runexp+0x1e0>
     a09:	8b 7d 08             	mov    0x8(%ebp),%edi
        struct atom* t=(struct atom*)lst->sexps[1];
     a0c:	8b 4f 0c             	mov    0xc(%edi),%ecx
        int n=fromint(t->symbol,t->esymbol-t->symbol);
     a0f:	8b 51 04             	mov    0x4(%ecx),%edx
  for(i=0;i<n;i++)
     a12:	8b 59 08             	mov    0x8(%ecx),%ebx
     a15:	eb 0d                	jmp    a24 <runexp+0x654>
    s*=10;
     a17:	6b c0 0a             	imul   $0xa,%eax,%eax
    s+=v[i]-'0';
     a1a:	0f be 0a             	movsbl (%edx),%ecx
     a1d:	83 c2 01             	add    $0x1,%edx
     a20:	8d 44 08 d0          	lea    -0x30(%eax,%ecx,1),%eax
  for(i=0;i<n;i++)
     a24:	39 d3                	cmp    %edx,%ebx
     a26:	75 ef                	jne    a17 <runexp+0x647>
     a28:	89 c3                	mov    %eax,%ebx
     a2a:	eb 1e                	jmp    a4a <runexp+0x67a>
  pid = fork();
     a2c:	e8 78 07 00 00       	call   11a9 <fork>
  if (pid == -1)
     a31:	83 f8 ff             	cmp    $0xffffffff,%eax
     a34:	0f 84 5e 01 00 00    	je     b98 <runexp+0x7c8>

  return pid;
     a3a:	83 eb 01             	sub    $0x1,%ebx
          if (fork1() == 0) {
     a3d:	85 c0                	test   %eax,%eax
     a3f:	0f 84 ff fe ff ff    	je     944 <runexp+0x574>
          wait();
     a45:	e8 6f 07 00 00       	call   11b9 <wait>
        while(n-->0)
     a4a:	85 db                	test   %ebx,%ebx
     a4c:	7f de                	jg     a2c <runexp+0x65c>
     a4e:	e9 5d fb ff ff       	jmp    5b0 <runexp+0x1e0>
     a53:	8b 7d 08             	mov    0x8(%ebp),%edi
  pid = fork();
     a56:	e8 4e 07 00 00       	call   11a9 <fork>
  if (pid == -1)
     a5b:	83 f8 ff             	cmp    $0xffffffff,%eax
     a5e:	0f 84 34 01 00 00    	je     b98 <runexp+0x7c8>
        if(fork1()==0)
     a64:	85 c0                	test   %eax,%eax
     a66:	74 5d                	je     ac5 <runexp+0x6f5>
  pid = fork();
     a68:	e8 3c 07 00 00       	call   11a9 <fork>
  if (pid == -1)
     a6d:	83 f8 ff             	cmp    $0xffffffff,%eax
     a70:	0f 84 22 01 00 00    	je     b98 <runexp+0x7c8>
        if(fork1()==0)
     a76:	85 c0                	test   %eax,%eax
     a78:	0f 84 c6 fe ff ff    	je     944 <runexp+0x574>
        wait();
     a7e:	e8 36 07 00 00       	call   11b9 <wait>
     a83:	e9 41 fe ff ff       	jmp    8c9 <runexp+0x4f9>
        int tm=att(1);
     a88:	83 ec 0c             	sub    $0xc,%esp
     a8b:	8b 7d 08             	mov    0x8(%ebp),%edi
     a8e:	6a 01                	push   $0x1
     a90:	e8 f4 07 00 00       	call   1289 <att>
     a95:	89 c3                	mov    %eax,%ebx
  pid = fork();
     a97:	e8 0d 07 00 00       	call   11a9 <fork>
  if (pid == -1)
     a9c:	83 c4 10             	add    $0x10,%esp
     a9f:	83 f8 ff             	cmp    $0xffffffff,%eax
     aa2:	0f 84 f0 00 00 00    	je     b98 <runexp+0x7c8>
        if(fork1()==0)
     aa8:	85 c0                	test   %eax,%eax
     aaa:	74 19                	je     ac5 <runexp+0x6f5>
        wait();
     aac:	e8 08 07 00 00       	call   11b9 <wait>
        tm=att(0)-tm;
     ab1:	83 ec 0c             	sub    $0xc,%esp
     ab4:	6a 00                	push   $0x0
     ab6:	e8 ce 07 00 00       	call   1289 <att>
        printf(1, "%d", tm);
     abb:	83 c4 0c             	add    $0xc,%esp
        tm=att(0)-tm;
     abe:	29 d8                	sub    %ebx,%eax
     ac0:	e9 2f ff ff ff       	jmp    9f4 <runexp+0x624>
          getsharem(1);
     ac5:	83 ec 0c             	sub    $0xc,%esp
     ac8:	6a 01                	push   $0x1
     aca:	e8 8a 07 00 00       	call   1259 <getsharem>
          runexp(lst->sexps[1]);
     acf:	59                   	pop    %ecx
     ad0:	ff 77 0c             	pushl  0xc(%edi)
     ad3:	e8 f8 f8 ff ff       	call   3d0 <runexp>
          getsharem(1);
     ad8:	83 ec 0c             	sub    $0xc,%esp
     adb:	8b 7d 08             	mov    0x8(%ebp),%edi
     ade:	6a 01                	push   $0x1
     ae0:	e8 74 07 00 00       	call   1259 <getsharem>
          runexp(lst->sexps[i]);
     ae5:	59                   	pop    %ecx
     ae6:	ff 74 b7 08          	pushl  0x8(%edi,%esi,4)
     aea:	e8 e1 f8 ff ff       	call   3d0 <runexp>
          panic("pipe");
     aef:	83 ec 0c             	sub    $0xc,%esp
     af2:	68 0d 17 00 00       	push   $0x170d
     af7:	e8 b4 f8 ff ff       	call   3b0 <panic>
          printf(2, ":true");
     afc:	50                   	push   %eax
     afd:	50                   	push   %eax
     afe:	68 fd 16 00 00       	push   $0x16fd
     b03:	6a 02                	push   $0x2
     b05:	e8 56 08 00 00       	call   1360 <printf>
     b0a:	83 c4 10             	add    $0x10,%esp
     b0d:	e9 9e fa ff ff       	jmp    5b0 <runexp+0x1e0>
          close(0);
     b12:	83 ec 0c             	sub    $0xc,%esp
     b15:	6a 00                	push   $0x0
     b17:	e8 bd 06 00 00       	call   11d9 <close>
          dup(p[0]);
     b1c:	5e                   	pop    %esi
     b1d:	ff b5 54 ff ff ff    	pushl  -0xac(%ebp)
     b23:	e8 01 07 00 00       	call   1229 <dup>
          close(p[0]);
     b28:	58                   	pop    %eax
     b29:	ff b5 54 ff ff ff    	pushl  -0xac(%ebp)
     b2f:	e8 a5 06 00 00       	call   11d9 <close>
          close(p[1]);
     b34:	58                   	pop    %eax
     b35:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
     b3b:	e8 99 06 00 00       	call   11d9 <close>
          getsharem(1);
     b40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b47:	e8 0d 07 00 00       	call   1259 <getsharem>
          runexp(lst->sexps[1]);
     b4c:	58                   	pop    %eax
     b4d:	ff 77 0c             	pushl  0xc(%edi)
     b50:	e8 7b f8 ff ff       	call   3d0 <runexp>
          close(1);
     b55:	83 ec 0c             	sub    $0xc,%esp
     b58:	6a 01                	push   $0x1
     b5a:	e8 7a 06 00 00       	call   11d9 <close>
          dup(p[1]);
     b5f:	58                   	pop    %eax
     b60:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
     b66:	e8 be 06 00 00       	call   1229 <dup>
          close(p[0]);
     b6b:	58                   	pop    %eax
     b6c:	ff b5 54 ff ff ff    	pushl  -0xac(%ebp)
     b72:	e8 62 06 00 00       	call   11d9 <close>
          close(p[1]);
     b77:	58                   	pop    %eax
     b78:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
     b7e:	e8 56 06 00 00       	call   11d9 <close>
          getsharem(1);
     b83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b8a:	e8 ca 06 00 00       	call   1259 <getsharem>
          runexp(lst->sexps[2]);
     b8f:	5a                   	pop    %edx
     b90:	ff 77 10             	pushl  0x10(%edi)
     b93:	e8 38 f8 ff ff       	call   3d0 <runexp>
    panic("fork");
     b98:	83 ec 0c             	sub    $0xc,%esp
     b9b:	68 ea 16 00 00       	push   $0x16ea
     ba0:	e8 0b f8 ff ff       	call   3b0 <panic>
     ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000bb0 <fork1>:
int fork1(void) {
     bb0:	55                   	push   %ebp
     bb1:	89 e5                	mov    %esp,%ebp
     bb3:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     bb6:	e8 ee 05 00 00       	call   11a9 <fork>
  if (pid == -1)
     bbb:	83 f8 ff             	cmp    $0xffffffff,%eax
     bbe:	74 02                	je     bc2 <fork1+0x12>
}
     bc0:	c9                   	leave  
     bc1:	c3                   	ret    
    panic("fork");
     bc2:	83 ec 0c             	sub    $0xc,%esp
     bc5:	68 ea 16 00 00       	push   $0x16ea
     bca:	e8 e1 f7 ff ff       	call   3b0 <panic>
     bcf:	90                   	nop

00000bd0 <atom>:

// PAGEBREAK!
// Constructors

struct sexp *atom(void) {
     bd0:	55                   	push   %ebp
     bd1:	89 e5                	mov    %esp,%ebp
     bd3:	53                   	push   %ebx
     bd4:	83 ec 10             	sub    $0x10,%esp
  struct atom *exp;

  exp = malloc(sizeof(*exp));
     bd7:	6a 0c                	push   $0xc
     bd9:	e8 e2 09 00 00       	call   15c0 <malloc>
  memset(exp, 0, sizeof(*exp));
     bde:	83 c4 0c             	add    $0xc,%esp
     be1:	6a 0c                	push   $0xc
  exp = malloc(sizeof(*exp));
     be3:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     be5:	6a 00                	push   $0x0
     be7:	50                   	push   %eax
     be8:	e8 23 04 00 00       	call   1010 <memset>

  return (struct sexp *)exp;
}
     bed:	89 d8                	mov    %ebx,%eax
     bef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     bf2:	c9                   	leave  
     bf3:	c3                   	ret    
     bf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     bfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000c00 <list>:

struct sexp *list(void) {
     c00:	55                   	push   %ebp
     c01:	89 e5                	mov    %esp,%ebp
     c03:	53                   	push   %ebx
     c04:	83 ec 10             	sub    $0x10,%esp
  struct list *exp;

  exp = malloc(sizeof(*exp));
     c07:	6a 30                	push   $0x30
     c09:	e8 b2 09 00 00       	call   15c0 <malloc>
  memset(exp, 0, sizeof(*exp));
     c0e:	83 c4 0c             	add    $0xc,%esp
     c11:	6a 30                	push   $0x30
  exp = malloc(sizeof(*exp));
     c13:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     c15:	6a 00                	push   $0x0
     c17:	50                   	push   %eax
     c18:	e8 f3 03 00 00       	call   1010 <memset>
  return (struct sexp *)exp;
}
     c1d:	89 d8                	mov    %ebx,%eax
     c1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c22:	c9                   	leave  
     c23:	c3                   	ret    
     c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000c30 <peek>:
// Parsing

char whitespace[] = " \t\r\n\v";
char esymbols[] = "()";

int peek(char **ps, char *es, char *toks) {
     c30:	55                   	push   %ebp
     c31:	89 e5                	mov    %esp,%ebp
     c33:	57                   	push   %edi
     c34:	56                   	push   %esi
     c35:	53                   	push   %ebx
     c36:	83 ec 0c             	sub    $0xc,%esp
     c39:	8b 7d 08             	mov    0x8(%ebp),%edi
     c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps; while (s < es && strchr(whitespace, *s))
     c3f:	8b 1f                	mov    (%edi),%ebx
     c41:	39 f3                	cmp    %esi,%ebx
     c43:	72 12                	jb     c57 <peek+0x27>
     c45:	eb 28                	jmp    c6f <peek+0x3f>
     c47:	89 f6                	mov    %esi,%esi
     c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
     c50:	83 c3 01             	add    $0x1,%ebx
  s = *ps; while (s < es && strchr(whitespace, *s))
     c53:	39 de                	cmp    %ebx,%esi
     c55:	74 18                	je     c6f <peek+0x3f>
     c57:	0f be 03             	movsbl (%ebx),%eax
     c5a:	83 ec 08             	sub    $0x8,%esp
     c5d:	50                   	push   %eax
     c5e:	68 e0 1c 00 00       	push   $0x1ce0
     c63:	e8 c8 03 00 00       	call   1030 <strchr>
     c68:	83 c4 10             	add    $0x10,%esp
     c6b:	85 c0                	test   %eax,%eax
     c6d:	75 e1                	jne    c50 <peek+0x20>
  *ps = s;
     c6f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     c71:	0f be 13             	movsbl (%ebx),%edx
     c74:	31 c0                	xor    %eax,%eax
     c76:	84 d2                	test   %dl,%dl
     c78:	75 0e                	jne    c88 <peek+0x58>
}
     c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c7d:	5b                   	pop    %ebx
     c7e:	5e                   	pop    %esi
     c7f:	5f                   	pop    %edi
     c80:	5d                   	pop    %ebp
     c81:	c3                   	ret    
     c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return *s && strchr(toks, *s);
     c88:	83 ec 08             	sub    $0x8,%esp
     c8b:	52                   	push   %edx
     c8c:	ff 75 10             	pushl  0x10(%ebp)
     c8f:	e8 9c 03 00 00       	call   1030 <strchr>
     c94:	83 c4 10             	add    $0x10,%esp
     c97:	85 c0                	test   %eax,%eax
     c99:	0f 95 c0             	setne  %al
}
     c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c9f:	5b                   	pop    %ebx
  return *s && strchr(toks, *s);
     ca0:	0f b6 c0             	movzbl %al,%eax
}
     ca3:	5e                   	pop    %esi
     ca4:	5f                   	pop    %edi
     ca5:	5d                   	pop    %ebp
     ca6:	c3                   	ret    
     ca7:	89 f6                	mov    %esi,%esi
     ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000cb0 <parseatom>:
  lst->length = i;

  return ret;
}

struct sexp *parseatom(char **ps, char *es) {
     cb0:	55                   	push   %ebp
     cb1:	89 e5                	mov    %esp,%ebp
     cb3:	57                   	push   %edi
     cb4:	56                   	push   %esi
     cb5:	53                   	push   %ebx
     cb6:	83 ec 0c             	sub    $0xc,%esp
     cb9:	8b 7d 08             	mov    0x8(%ebp),%edi
     cbc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct atom *atm;
  struct sexp *ret;

  char *s = *ps;
     cbf:	8b 37                	mov    (%edi),%esi
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     cc1:	89 f0                	mov    %esi,%eax
     cc3:	39 de                	cmp    %ebx,%esi
     cc5:	72 2e                	jb     cf5 <parseatom+0x45>
     cc7:	eb 44                	jmp    d0d <parseatom+0x5d>
     cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
         !strchr(esymbols, *(*ps))) // peek whitespace
     cd0:	8b 07                	mov    (%edi),%eax
     cd2:	83 ec 08             	sub    $0x8,%esp
     cd5:	0f be 00             	movsbl (%eax),%eax
     cd8:	50                   	push   %eax
     cd9:	68 dc 1c 00 00       	push   $0x1cdc
     cde:	e8 4d 03 00 00       	call   1030 <strchr>
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     ce3:	83 c4 10             	add    $0x10,%esp
     ce6:	85 c0                	test   %eax,%eax
     ce8:	75 23                	jne    d0d <parseatom+0x5d>
    (*ps)++;
     cea:	8b 07                	mov    (%edi),%eax
     cec:	83 c0 01             	add    $0x1,%eax
     cef:	89 07                	mov    %eax,(%edi)
  while ((*ps) < es && !strchr(whitespace, *(*ps)) &&
     cf1:	39 d8                	cmp    %ebx,%eax
     cf3:	73 18                	jae    d0d <parseatom+0x5d>
     cf5:	0f be 00             	movsbl (%eax),%eax
     cf8:	83 ec 08             	sub    $0x8,%esp
     cfb:	50                   	push   %eax
     cfc:	68 e0 1c 00 00       	push   $0x1ce0
     d01:	e8 2a 03 00 00       	call   1030 <strchr>
     d06:	83 c4 10             	add    $0x10,%esp
     d09:	85 c0                	test   %eax,%eax
     d0b:	74 c3                	je     cd0 <parseatom+0x20>

  ret = atom();
     d0d:	e8 be fe ff ff       	call   bd0 <atom>
  atm = (struct atom *)ret;

  atm->type = ATOM;
     d12:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  atm->symbol = s;
     d18:	89 70 04             	mov    %esi,0x4(%eax)
  atm->esymbol = *ps;
     d1b:	8b 17                	mov    (%edi),%edx
     d1d:	89 50 08             	mov    %edx,0x8(%eax)

  return ret;
}
     d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d23:	5b                   	pop    %ebx
     d24:	5e                   	pop    %esi
     d25:	5f                   	pop    %edi
     d26:	5d                   	pop    %ebp
     d27:	c3                   	ret    
     d28:	90                   	nop
     d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d30 <parsesexp>:

struct sexp *parsesexp(char **ps, char *es) {
     d30:	55                   	push   %ebp
     d31:	89 e5                	mov    %esp,%ebp
     d33:	56                   	push   %esi
     d34:	8b 75 08             	mov    0x8(%ebp),%esi
     d37:	53                   	push   %ebx
     d38:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct sexp *ret = 0;

  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     d3b:	8b 06                	mov    (%esi),%eax
     d3d:	39 c3                	cmp    %eax,%ebx
     d3f:	77 10                	ja     d51 <parsesexp+0x21>
     d41:	eb 28                	jmp    d6b <parsesexp+0x3b>
     d43:	90                   	nop
     d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    (*ps)++;
     d48:	83 c0 01             	add    $0x1,%eax
     d4b:	89 06                	mov    %eax,(%esi)
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     d4d:	39 d8                	cmp    %ebx,%eax
     d4f:	73 1a                	jae    d6b <parsesexp+0x3b>
     d51:	0f be 00             	movsbl (%eax),%eax
     d54:	83 ec 08             	sub    $0x8,%esp
     d57:	50                   	push   %eax
     d58:	68 e0 1c 00 00       	push   $0x1ce0
     d5d:	e8 ce 02 00 00       	call   1030 <strchr>
     d62:	83 c4 10             	add    $0x10,%esp
     d65:	85 c0                	test   %eax,%eax
    (*ps)++;
     d67:	8b 06                	mov    (%esi),%eax
  while ((*ps) < es && strchr(whitespace, *(*ps))) // skip whitespace
     d69:	75 dd                	jne    d48 <parsesexp+0x18>
  switch (*(*ps)) {
     d6b:	0f b6 10             	movzbl (%eax),%edx
     d6e:	80 fa 27             	cmp    $0x27,%dl
     d71:	74 55                	je     dc8 <parsesexp+0x98>
     d73:	80 fa 28             	cmp    $0x28,%dl
     d76:	74 28                	je     da0 <parsesexp+0x70>
     d78:	84 d2                	test   %dl,%dl
     d7a:	74 14                	je     d90 <parsesexp+0x60>
    (*ps) += 2;
    ret = parselist(ps, es);
    (*ps)++;
    break;
  default:
    ret = parseatom(ps, es);
     d7c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
     d7f:	89 75 08             	mov    %esi,0x8(%ebp)
    break;
  }
  return ret;
}
     d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d85:	5b                   	pop    %ebx
     d86:	5e                   	pop    %esi
     d87:	5d                   	pop    %ebp
    ret = parseatom(ps, es);
     d88:	e9 23 ff ff ff       	jmp    cb0 <parseatom>
     d8d:	8d 76 00             	lea    0x0(%esi),%esi
}
     d90:	8d 65 f8             	lea    -0x8(%ebp),%esp
  struct sexp *ret = 0;
     d93:	31 c0                	xor    %eax,%eax
}
     d95:	5b                   	pop    %ebx
     d96:	5e                   	pop    %esi
     d97:	5d                   	pop    %ebp
     d98:	c3                   	ret    
     d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret = parselist(ps, es);
     da0:	83 ec 08             	sub    $0x8,%esp
    (*ps)++;
     da3:	83 c0 01             	add    $0x1,%eax
     da6:	89 06                	mov    %eax,(%esi)
    ret = parselist(ps, es);
     da8:	53                   	push   %ebx
     da9:	56                   	push   %esi
     daa:	e8 41 00 00 00       	call   df0 <parselist>
    break;
     daf:	83 c4 10             	add    $0x10,%esp
    ret->type = APPLY;
     db2:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    (*ps)++;
     db8:	83 06 01             	addl   $0x1,(%esi)
}
     dbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
     dbe:	5b                   	pop    %ebx
     dbf:	5e                   	pop    %esi
     dc0:	5d                   	pop    %ebp
     dc1:	c3                   	ret    
     dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ret = parselist(ps, es);
     dc8:	83 ec 08             	sub    $0x8,%esp
    (*ps) += 2;
     dcb:	83 c0 02             	add    $0x2,%eax
     dce:	89 06                	mov    %eax,(%esi)
    ret = parselist(ps, es);
     dd0:	53                   	push   %ebx
     dd1:	56                   	push   %esi
     dd2:	e8 19 00 00 00       	call   df0 <parselist>
    (*ps)++;
     dd7:	83 06 01             	addl   $0x1,(%esi)
    break;
     dda:	83 c4 10             	add    $0x10,%esp
}
     ddd:	8d 65 f8             	lea    -0x8(%ebp),%esp
     de0:	5b                   	pop    %ebx
     de1:	5e                   	pop    %esi
     de2:	5d                   	pop    %ebp
     de3:	c3                   	ret    
     de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000df0 <parselist>:
struct sexp *parselist(char **ps, char *es) {
     df0:	55                   	push   %ebp
     df1:	89 e5                	mov    %esp,%ebp
     df3:	57                   	push   %edi
     df4:	56                   	push   %esi
     df5:	53                   	push   %ebx
     df6:	83 ec 1c             	sub    $0x1c,%esp
     df9:	8b 75 08             	mov    0x8(%ebp),%esi
     dfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  ret = list();
     dff:	e8 fc fd ff ff       	call   c00 <list>
  lst->type = LIST;
     e04:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  char *res = *ps;
     e0a:	8b 0e                	mov    (%esi),%ecx
  ret = list();
     e0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  while (res < es) {
     e0f:	89 cb                	mov    %ecx,%ebx
     e11:	39 f9                	cmp    %edi,%ecx
     e13:	73 3b                	jae    e50 <parselist+0x60>
  int i = 1;
     e15:	ba 01 00 00 00       	mov    $0x1,%edx
     e1a:	eb 14                	jmp    e30 <parselist+0x40>
     e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (*res == ')') {
     e20:	3c 29                	cmp    $0x29,%al
     e22:	75 05                	jne    e29 <parselist+0x39>
      if (i == 0) {
     e24:	83 ea 01             	sub    $0x1,%edx
     e27:	74 27                	je     e50 <parselist+0x60>
    res++;
     e29:	83 c3 01             	add    $0x1,%ebx
  while (res < es) {
     e2c:	39 df                	cmp    %ebx,%edi
     e2e:	74 11                	je     e41 <parselist+0x51>
    if (*res == '(')
     e30:	0f b6 03             	movzbl (%ebx),%eax
     e33:	3c 28                	cmp    $0x28,%al
     e35:	75 e9                	jne    e20 <parselist+0x30>
    res++;
     e37:	83 c3 01             	add    $0x1,%ebx
      i++;
     e3a:	83 c2 01             	add    $0x1,%edx
  while (res < es) {
     e3d:	39 df                	cmp    %ebx,%edi
     e3f:	75 ef                	jne    e30 <parselist+0x40>
    panic("syntax error");
     e41:	83 ec 0c             	sub    $0xc,%esp
     e44:	68 dd 16 00 00       	push   $0x16dd
     e49:	e8 62 f5 ff ff       	call   3b0 <panic>
     e4e:	66 90                	xchg   %ax,%ax
  if (res == es)
     e50:	39 df                	cmp    %ebx,%edi
     e52:	74 ed                	je     e41 <parselist+0x51>
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     e54:	31 ff                	xor    %edi,%edi
     e56:	eb 0a                	jmp    e62 <parselist+0x72>
     e58:	90                   	nop
     e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e60:	8b 0e                	mov    (%esi),%ecx
     e62:	39 d9                	cmp    %ebx,%ecx
     e64:	73 1c                	jae    e82 <parselist+0x92>
    lst->sexps[i] = parsesexp(ps, res);}
     e66:	83 ec 08             	sub    $0x8,%esp
     e69:	53                   	push   %ebx
     e6a:	56                   	push   %esi
     e6b:	e8 c0 fe ff ff       	call   d30 <parsesexp>
     e70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     e73:	83 c4 10             	add    $0x10,%esp
    lst->sexps[i] = parsesexp(ps, res);}
     e76:	89 44 ba 08          	mov    %eax,0x8(%edx,%edi,4)
  for (i = 0; i < MAXARGS && (*ps) < res; i++) {
     e7a:	83 c7 01             	add    $0x1,%edi
     e7d:	83 ff 0a             	cmp    $0xa,%edi
     e80:	75 de                	jne    e60 <parselist+0x70>
  lst->length = i;
     e82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     e85:	89 78 04             	mov    %edi,0x4(%eax)
}
     e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e8b:	5b                   	pop    %ebx
     e8c:	5e                   	pop    %esi
     e8d:	5f                   	pop    %edi
     e8e:	5d                   	pop    %ebp
     e8f:	c3                   	ret    

00000e90 <snulterminate>:
  }
  snulterminate(exp);
  return exp;
}

struct sexp *snulterminate(struct sexp *exp) {
     e90:	55                   	push   %ebp
     e91:	89 e5                	mov    %esp,%ebp
     e93:	56                   	push   %esi
     e94:	53                   	push   %ebx
     e95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;
  struct list *lst;
  struct atom *atm;

  if (exp == 0)
     e98:	85 db                	test   %ebx,%ebx
     e9a:	74 30                	je     ecc <snulterminate+0x3c>
    return 0;

  switch (exp->type) {
     e9c:	8b 03                	mov    (%ebx),%eax
     e9e:	83 f8 01             	cmp    $0x1,%eax
     ea1:	74 35                	je     ed8 <snulterminate+0x48>
     ea3:	85 c0                	test   %eax,%eax
     ea5:	7e 25                	jle    ecc <snulterminate+0x3c>
     ea7:	83 f8 03             	cmp    $0x3,%eax
     eaa:	7f 20                	jg     ecc <snulterminate+0x3c>
    break;

  case APPLY:
  case LIST:
    lst = (struct list *)exp;
    for (i = 0; i < lst->length; i++)
     eac:	8b 43 04             	mov    0x4(%ebx),%eax
     eaf:	31 f6                	xor    %esi,%esi
     eb1:	85 c0                	test   %eax,%eax
     eb3:	7e 17                	jle    ecc <snulterminate+0x3c>
      snulterminate(lst->sexps[i]);
     eb5:	83 ec 0c             	sub    $0xc,%esp
     eb8:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
    for (i = 0; i < lst->length; i++)
     ebc:	83 c6 01             	add    $0x1,%esi
      snulterminate(lst->sexps[i]);
     ebf:	e8 cc ff ff ff       	call   e90 <snulterminate>
    for (i = 0; i < lst->length; i++)
     ec4:	83 c4 10             	add    $0x10,%esp
     ec7:	3b 73 04             	cmp    0x4(%ebx),%esi
     eca:	7c e9                	jl     eb5 <snulterminate+0x25>
    break;
  }
  return exp;
}
     ecc:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ecf:	89 d8                	mov    %ebx,%eax
     ed1:	5b                   	pop    %ebx
     ed2:	5e                   	pop    %esi
     ed3:	5d                   	pop    %ebp
     ed4:	c3                   	ret    
     ed5:	8d 76 00             	lea    0x0(%esi),%esi
    *atm->esymbol = 0;
     ed8:	8b 43 08             	mov    0x8(%ebx),%eax
     edb:	c6 00 00             	movb   $0x0,(%eax)
}
     ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ee1:	89 d8                	mov    %ebx,%eax
     ee3:	5b                   	pop    %ebx
     ee4:	5e                   	pop    %esi
     ee5:	5d                   	pop    %ebp
     ee6:	c3                   	ret    
     ee7:	89 f6                	mov    %esi,%esi
     ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ef0 <parseexp>:
struct sexp *parseexp(char *s) {
     ef0:	55                   	push   %ebp
     ef1:	89 e5                	mov    %esp,%ebp
     ef3:	56                   	push   %esi
     ef4:	53                   	push   %ebx
  es = s + strlen(s);
     ef5:	8b 5d 08             	mov    0x8(%ebp),%ebx
     ef8:	83 ec 0c             	sub    $0xc,%esp
     efb:	53                   	push   %ebx
     efc:	e8 df 00 00 00       	call   fe0 <strlen>
  exp = parsesexp(&s, es);
     f01:	59                   	pop    %ecx
     f02:	5e                   	pop    %esi
  es = s + strlen(s);
     f03:	01 c3                	add    %eax,%ebx
  exp = parsesexp(&s, es);
     f05:	8d 45 08             	lea    0x8(%ebp),%eax
     f08:	53                   	push   %ebx
     f09:	50                   	push   %eax
     f0a:	e8 21 fe ff ff       	call   d30 <parsesexp>
  peek(&s, es, "");
     f0f:	83 c4 0c             	add    $0xc,%esp
  exp = parsesexp(&s, es);
     f12:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     f14:	8d 45 08             	lea    0x8(%ebp),%eax
     f17:	68 43 17 00 00       	push   $0x1743
     f1c:	53                   	push   %ebx
     f1d:	50                   	push   %eax
     f1e:	e8 0d fd ff ff       	call   c30 <peek>
  if (s != es) {
     f23:	8b 45 08             	mov    0x8(%ebp),%eax
     f26:	83 c4 10             	add    $0x10,%esp
     f29:	39 d8                	cmp    %ebx,%eax
     f2b:	75 12                	jne    f3f <parseexp+0x4f>
  snulterminate(exp);
     f2d:	83 ec 0c             	sub    $0xc,%esp
     f30:	56                   	push   %esi
     f31:	e8 5a ff ff ff       	call   e90 <snulterminate>
}
     f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
     f39:	89 f0                	mov    %esi,%eax
     f3b:	5b                   	pop    %ebx
     f3c:	5e                   	pop    %esi
     f3d:	5d                   	pop    %ebp
     f3e:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     f3f:	52                   	push   %edx
     f40:	50                   	push   %eax
     f41:	68 35 17 00 00       	push   $0x1735
     f46:	6a 02                	push   $0x2
     f48:	e8 13 04 00 00       	call   1360 <printf>
    panic("syntax error");
     f4d:	c7 04 24 dd 16 00 00 	movl   $0x16dd,(%esp)
     f54:	e8 57 f4 ff ff       	call   3b0 <panic>
     f59:	66 90                	xchg   %ax,%ax
     f5b:	66 90                	xchg   %ax,%ax
     f5d:	66 90                	xchg   %ax,%ax
     f5f:	90                   	nop

00000f60 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     f60:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     f61:	31 d2                	xor    %edx,%edx
{
     f63:	89 e5                	mov    %esp,%ebp
     f65:	53                   	push   %ebx
     f66:	8b 45 08             	mov    0x8(%ebp),%eax
     f69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     f70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
     f74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     f77:	83 c2 01             	add    $0x1,%edx
     f7a:	84 c9                	test   %cl,%cl
     f7c:	75 f2                	jne    f70 <strcpy+0x10>
    ;
  return os;
}
     f7e:	5b                   	pop    %ebx
     f7f:	5d                   	pop    %ebp
     f80:	c3                   	ret    
     f81:	eb 0d                	jmp    f90 <strcmp>
     f83:	90                   	nop
     f84:	90                   	nop
     f85:	90                   	nop
     f86:	90                   	nop
     f87:	90                   	nop
     f88:	90                   	nop
     f89:	90                   	nop
     f8a:	90                   	nop
     f8b:	90                   	nop
     f8c:	90                   	nop
     f8d:	90                   	nop
     f8e:	90                   	nop
     f8f:	90                   	nop

00000f90 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     f90:	55                   	push   %ebp
     f91:	89 e5                	mov    %esp,%ebp
     f93:	56                   	push   %esi
     f94:	53                   	push   %ebx
     f95:	8b 5d 08             	mov    0x8(%ebp),%ebx
     f98:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
     f9b:	0f b6 13             	movzbl (%ebx),%edx
     f9e:	0f b6 0e             	movzbl (%esi),%ecx
     fa1:	84 d2                	test   %dl,%dl
     fa3:	74 1e                	je     fc3 <strcmp+0x33>
     fa5:	b8 01 00 00 00       	mov    $0x1,%eax
     faa:	38 ca                	cmp    %cl,%dl
     fac:	74 09                	je     fb7 <strcmp+0x27>
     fae:	eb 20                	jmp    fd0 <strcmp+0x40>
     fb0:	83 c0 01             	add    $0x1,%eax
     fb3:	38 ca                	cmp    %cl,%dl
     fb5:	75 19                	jne    fd0 <strcmp+0x40>
     fb7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     fbb:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
     fbf:	84 d2                	test   %dl,%dl
     fc1:	75 ed                	jne    fb0 <strcmp+0x20>
     fc3:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     fc5:	5b                   	pop    %ebx
     fc6:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
     fc7:	29 c8                	sub    %ecx,%eax
}
     fc9:	5d                   	pop    %ebp
     fca:	c3                   	ret    
     fcb:	90                   	nop
     fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     fd0:	0f b6 c2             	movzbl %dl,%eax
     fd3:	5b                   	pop    %ebx
     fd4:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
     fd5:	29 c8                	sub    %ecx,%eax
}
     fd7:	5d                   	pop    %ebp
     fd8:	c3                   	ret    
     fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000fe0 <strlen>:

uint
strlen(char *s)
{
     fe0:	55                   	push   %ebp
     fe1:	89 e5                	mov    %esp,%ebp
     fe3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     fe6:	80 39 00             	cmpb   $0x0,(%ecx)
     fe9:	74 15                	je     1000 <strlen+0x20>
     feb:	31 d2                	xor    %edx,%edx
     fed:	8d 76 00             	lea    0x0(%esi),%esi
     ff0:	83 c2 01             	add    $0x1,%edx
     ff3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     ff7:	89 d0                	mov    %edx,%eax
     ff9:	75 f5                	jne    ff0 <strlen+0x10>
    ;
  return n;
}
     ffb:	5d                   	pop    %ebp
     ffc:	c3                   	ret    
     ffd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
    1000:	31 c0                	xor    %eax,%eax
}
    1002:	5d                   	pop    %ebp
    1003:	c3                   	ret    
    1004:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    100a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001010 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1010:	55                   	push   %ebp
    1011:	89 e5                	mov    %esp,%ebp
    1013:	57                   	push   %edi
    1014:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1017:	8b 4d 10             	mov    0x10(%ebp),%ecx
    101a:	8b 45 0c             	mov    0xc(%ebp),%eax
    101d:	89 d7                	mov    %edx,%edi
    101f:	fc                   	cld    
    1020:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1022:	89 d0                	mov    %edx,%eax
    1024:	5f                   	pop    %edi
    1025:	5d                   	pop    %ebp
    1026:	c3                   	ret    
    1027:	89 f6                	mov    %esi,%esi
    1029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001030 <strchr>:

char*
strchr(const char *s, char c)
{
    1030:	55                   	push   %ebp
    1031:	89 e5                	mov    %esp,%ebp
    1033:	53                   	push   %ebx
    1034:	8b 45 08             	mov    0x8(%ebp),%eax
    1037:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
    103a:	0f b6 18             	movzbl (%eax),%ebx
    103d:	84 db                	test   %bl,%bl
    103f:	74 1d                	je     105e <strchr+0x2e>
    1041:	89 d1                	mov    %edx,%ecx
    if(*s == c)
    1043:	38 d3                	cmp    %dl,%bl
    1045:	75 0d                	jne    1054 <strchr+0x24>
    1047:	eb 17                	jmp    1060 <strchr+0x30>
    1049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1050:	38 ca                	cmp    %cl,%dl
    1052:	74 0c                	je     1060 <strchr+0x30>
  for(; *s; s++)
    1054:	83 c0 01             	add    $0x1,%eax
    1057:	0f b6 10             	movzbl (%eax),%edx
    105a:	84 d2                	test   %dl,%dl
    105c:	75 f2                	jne    1050 <strchr+0x20>
      return (char*)s;
  return 0;
    105e:	31 c0                	xor    %eax,%eax
}
    1060:	5b                   	pop    %ebx
    1061:	5d                   	pop    %ebp
    1062:	c3                   	ret    
    1063:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001070 <gets>:

char*
gets(char *buf, int max)
{
    1070:	55                   	push   %ebp
    1071:	89 e5                	mov    %esp,%ebp
    1073:	57                   	push   %edi
    1074:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1075:	31 f6                	xor    %esi,%esi
{
    1077:	53                   	push   %ebx
    1078:	89 f3                	mov    %esi,%ebx
    107a:	83 ec 1c             	sub    $0x1c,%esp
    107d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    1080:	eb 2f                	jmp    10b1 <gets+0x41>
    1082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    1088:	83 ec 04             	sub    $0x4,%esp
    108b:	8d 45 e7             	lea    -0x19(%ebp),%eax
    108e:	6a 01                	push   $0x1
    1090:	50                   	push   %eax
    1091:	6a 00                	push   $0x0
    1093:	e8 31 01 00 00       	call   11c9 <read>
    if(cc < 1)
    1098:	83 c4 10             	add    $0x10,%esp
    109b:	85 c0                	test   %eax,%eax
    109d:	7e 1c                	jle    10bb <gets+0x4b>
      break;
    buf[i++] = c;
    109f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    10a3:	83 c7 01             	add    $0x1,%edi
    10a6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    10a9:	3c 0a                	cmp    $0xa,%al
    10ab:	74 23                	je     10d0 <gets+0x60>
    10ad:	3c 0d                	cmp    $0xd,%al
    10af:	74 1f                	je     10d0 <gets+0x60>
  for(i=0; i+1 < max; ){
    10b1:	83 c3 01             	add    $0x1,%ebx
    10b4:	89 fe                	mov    %edi,%esi
    10b6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    10b9:	7c cd                	jl     1088 <gets+0x18>
    10bb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    10bd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    10c0:	c6 03 00             	movb   $0x0,(%ebx)
}
    10c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10c6:	5b                   	pop    %ebx
    10c7:	5e                   	pop    %esi
    10c8:	5f                   	pop    %edi
    10c9:	5d                   	pop    %ebp
    10ca:	c3                   	ret    
    10cb:	90                   	nop
    10cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10d0:	8b 75 08             	mov    0x8(%ebp),%esi
    10d3:	8b 45 08             	mov    0x8(%ebp),%eax
    10d6:	01 de                	add    %ebx,%esi
    10d8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    10da:	c6 03 00             	movb   $0x0,(%ebx)
}
    10dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10e0:	5b                   	pop    %ebx
    10e1:	5e                   	pop    %esi
    10e2:	5f                   	pop    %edi
    10e3:	5d                   	pop    %ebp
    10e4:	c3                   	ret    
    10e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000010f0 <stat>:

int
stat(char *n, struct stat *st)
{
    10f0:	55                   	push   %ebp
    10f1:	89 e5                	mov    %esp,%ebp
    10f3:	56                   	push   %esi
    10f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    10f5:	83 ec 08             	sub    $0x8,%esp
    10f8:	6a 00                	push   $0x0
    10fa:	ff 75 08             	pushl  0x8(%ebp)
    10fd:	e8 ef 00 00 00       	call   11f1 <open>
  if(fd < 0)
    1102:	83 c4 10             	add    $0x10,%esp
    1105:	85 c0                	test   %eax,%eax
    1107:	78 27                	js     1130 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    1109:	83 ec 08             	sub    $0x8,%esp
    110c:	ff 75 0c             	pushl  0xc(%ebp)
    110f:	89 c3                	mov    %eax,%ebx
    1111:	50                   	push   %eax
    1112:	e8 f2 00 00 00       	call   1209 <fstat>
  close(fd);
    1117:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    111a:	89 c6                	mov    %eax,%esi
  close(fd);
    111c:	e8 b8 00 00 00       	call   11d9 <close>
  return r;
    1121:	83 c4 10             	add    $0x10,%esp
}
    1124:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1127:	89 f0                	mov    %esi,%eax
    1129:	5b                   	pop    %ebx
    112a:	5e                   	pop    %esi
    112b:	5d                   	pop    %ebp
    112c:	c3                   	ret    
    112d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    1130:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1135:	eb ed                	jmp    1124 <stat+0x34>
    1137:	89 f6                	mov    %esi,%esi
    1139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001140 <atoi>:

int
atoi(const char *s)
{
    1140:	55                   	push   %ebp
    1141:	89 e5                	mov    %esp,%ebp
    1143:	53                   	push   %ebx
    1144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1147:	0f be 11             	movsbl (%ecx),%edx
    114a:	8d 42 d0             	lea    -0x30(%edx),%eax
    114d:	3c 09                	cmp    $0x9,%al
  n = 0;
    114f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1154:	77 1f                	ja     1175 <atoi+0x35>
    1156:	8d 76 00             	lea    0x0(%esi),%esi
    1159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
    1160:	83 c1 01             	add    $0x1,%ecx
    1163:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1166:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    116a:	0f be 11             	movsbl (%ecx),%edx
    116d:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1170:	80 fb 09             	cmp    $0x9,%bl
    1173:	76 eb                	jbe    1160 <atoi+0x20>
  return n;
}
    1175:	5b                   	pop    %ebx
    1176:	5d                   	pop    %ebp
    1177:	c3                   	ret    
    1178:	90                   	nop
    1179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001180 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1180:	55                   	push   %ebp
    1181:	89 e5                	mov    %esp,%ebp
    1183:	57                   	push   %edi
    1184:	8b 55 10             	mov    0x10(%ebp),%edx
    1187:	8b 45 08             	mov    0x8(%ebp),%eax
    118a:	56                   	push   %esi
    118b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    118e:	85 d2                	test   %edx,%edx
    1190:	7e 13                	jle    11a5 <memmove+0x25>
    1192:	01 c2                	add    %eax,%edx
  dst = vdst;
    1194:	89 c7                	mov    %eax,%edi
    1196:	8d 76 00             	lea    0x0(%esi),%esi
    1199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    *dst++ = *src++;
    11a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    11a1:	39 fa                	cmp    %edi,%edx
    11a3:	75 fb                	jne    11a0 <memmove+0x20>
  return vdst;
}
    11a5:	5e                   	pop    %esi
    11a6:	5f                   	pop    %edi
    11a7:	5d                   	pop    %ebp
    11a8:	c3                   	ret    

000011a9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    11a9:	b8 01 00 00 00       	mov    $0x1,%eax
    11ae:	cd 40                	int    $0x40
    11b0:	c3                   	ret    

000011b1 <exit>:
SYSCALL(exit)
    11b1:	b8 02 00 00 00       	mov    $0x2,%eax
    11b6:	cd 40                	int    $0x40
    11b8:	c3                   	ret    

000011b9 <wait>:
SYSCALL(wait)
    11b9:	b8 03 00 00 00       	mov    $0x3,%eax
    11be:	cd 40                	int    $0x40
    11c0:	c3                   	ret    

000011c1 <pipe>:
SYSCALL(pipe)
    11c1:	b8 04 00 00 00       	mov    $0x4,%eax
    11c6:	cd 40                	int    $0x40
    11c8:	c3                   	ret    

000011c9 <read>:
SYSCALL(read)
    11c9:	b8 05 00 00 00       	mov    $0x5,%eax
    11ce:	cd 40                	int    $0x40
    11d0:	c3                   	ret    

000011d1 <write>:
SYSCALL(write)
    11d1:	b8 10 00 00 00       	mov    $0x10,%eax
    11d6:	cd 40                	int    $0x40
    11d8:	c3                   	ret    

000011d9 <close>:
SYSCALL(close)
    11d9:	b8 15 00 00 00       	mov    $0x15,%eax
    11de:	cd 40                	int    $0x40
    11e0:	c3                   	ret    

000011e1 <kill>:
SYSCALL(kill)
    11e1:	b8 06 00 00 00       	mov    $0x6,%eax
    11e6:	cd 40                	int    $0x40
    11e8:	c3                   	ret    

000011e9 <exec>:
SYSCALL(exec)
    11e9:	b8 07 00 00 00       	mov    $0x7,%eax
    11ee:	cd 40                	int    $0x40
    11f0:	c3                   	ret    

000011f1 <open>:
SYSCALL(open)
    11f1:	b8 0f 00 00 00       	mov    $0xf,%eax
    11f6:	cd 40                	int    $0x40
    11f8:	c3                   	ret    

000011f9 <mknod>:
SYSCALL(mknod)
    11f9:	b8 11 00 00 00       	mov    $0x11,%eax
    11fe:	cd 40                	int    $0x40
    1200:	c3                   	ret    

00001201 <unlink>:
SYSCALL(unlink)
    1201:	b8 12 00 00 00       	mov    $0x12,%eax
    1206:	cd 40                	int    $0x40
    1208:	c3                   	ret    

00001209 <fstat>:
SYSCALL(fstat)
    1209:	b8 08 00 00 00       	mov    $0x8,%eax
    120e:	cd 40                	int    $0x40
    1210:	c3                   	ret    

00001211 <link>:
SYSCALL(link)
    1211:	b8 13 00 00 00       	mov    $0x13,%eax
    1216:	cd 40                	int    $0x40
    1218:	c3                   	ret    

00001219 <mkdir>:
SYSCALL(mkdir)
    1219:	b8 14 00 00 00       	mov    $0x14,%eax
    121e:	cd 40                	int    $0x40
    1220:	c3                   	ret    

00001221 <chdir>:
SYSCALL(chdir)
    1221:	b8 09 00 00 00       	mov    $0x9,%eax
    1226:	cd 40                	int    $0x40
    1228:	c3                   	ret    

00001229 <dup>:
SYSCALL(dup)
    1229:	b8 0a 00 00 00       	mov    $0xa,%eax
    122e:	cd 40                	int    $0x40
    1230:	c3                   	ret    

00001231 <getpid>:
SYSCALL(getpid)
    1231:	b8 0b 00 00 00       	mov    $0xb,%eax
    1236:	cd 40                	int    $0x40
    1238:	c3                   	ret    

00001239 <sbrk>:
SYSCALL(sbrk)
    1239:	b8 0c 00 00 00       	mov    $0xc,%eax
    123e:	cd 40                	int    $0x40
    1240:	c3                   	ret    

00001241 <sleep>:
SYSCALL(sleep)
    1241:	b8 0d 00 00 00       	mov    $0xd,%eax
    1246:	cd 40                	int    $0x40
    1248:	c3                   	ret    

00001249 <uptime>:
SYSCALL(uptime)
    1249:	b8 0e 00 00 00       	mov    $0xe,%eax
    124e:	cd 40                	int    $0x40
    1250:	c3                   	ret    

00001251 <trace>:
SYSCALL(trace)
    1251:	b8 16 00 00 00       	mov    $0x16,%eax
    1256:	cd 40                	int    $0x40
    1258:	c3                   	ret    

00001259 <getsharem>:
SYSCALL(getsharem)
    1259:	b8 17 00 00 00       	mov    $0x17,%eax
    125e:	cd 40                	int    $0x40
    1260:	c3                   	ret    

00001261 <releasesharem>:
SYSCALL(releasesharem)
    1261:	b8 18 00 00 00       	mov    $0x18,%eax
    1266:	cd 40                	int    $0x40
    1268:	c3                   	ret    

00001269 <split>:
SYSCALL(split)
    1269:	b8 19 00 00 00       	mov    $0x19,%eax
    126e:	cd 40                	int    $0x40
    1270:	c3                   	ret    

00001271 <memo>:
SYSCALL(memo)
    1271:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1276:	cd 40                	int    $0x40
    1278:	c3                   	ret    

00001279 <getmemo>:
SYSCALL(getmemo)
    1279:	b8 1b 00 00 00       	mov    $0x1b,%eax
    127e:	cd 40                	int    $0x40
    1280:	c3                   	ret    

00001281 <setmemo>:
SYSCALL(setmemo)
    1281:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1286:	cd 40                	int    $0x40
    1288:	c3                   	ret    

00001289 <att>:
SYSCALL(att)
    1289:	b8 1d 00 00 00       	mov    $0x1d,%eax
    128e:	cd 40                	int    $0x40
    1290:	c3                   	ret    
    1291:	66 90                	xchg   %ax,%ax
    1293:	66 90                	xchg   %ax,%ax
    1295:	66 90                	xchg   %ax,%ax
    1297:	66 90                	xchg   %ax,%ax
    1299:	66 90                	xchg   %ax,%ax
    129b:	66 90                	xchg   %ax,%ax
    129d:	66 90                	xchg   %ax,%ax
    129f:	90                   	nop

000012a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    12a0:	55                   	push   %ebp
    12a1:	89 e5                	mov    %esp,%ebp
    12a3:	57                   	push   %edi
    12a4:	56                   	push   %esi
    12a5:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    12a6:	89 d3                	mov    %edx,%ebx
{
    12a8:	83 ec 3c             	sub    $0x3c,%esp
    12ab:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
    12ae:	85 d2                	test   %edx,%edx
    12b0:	0f 89 92 00 00 00    	jns    1348 <printint+0xa8>
    12b6:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    12ba:	0f 84 88 00 00 00    	je     1348 <printint+0xa8>
    neg = 1;
    12c0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
    12c7:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
    12c9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    12d0:	8d 75 d7             	lea    -0x29(%ebp),%esi
    12d3:	eb 08                	jmp    12dd <printint+0x3d>
    12d5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    12d8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
    12db:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
    12dd:	89 d8                	mov    %ebx,%eax
    12df:	31 d2                	xor    %edx,%edx
    12e1:	8b 7d c4             	mov    -0x3c(%ebp),%edi
    12e4:	f7 f1                	div    %ecx
    12e6:	83 c7 01             	add    $0x1,%edi
    12e9:	0f b6 92 5c 17 00 00 	movzbl 0x175c(%edx),%edx
    12f0:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
    12f3:	39 d9                	cmp    %ebx,%ecx
    12f5:	76 e1                	jbe    12d8 <printint+0x38>
  if(neg)
    12f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
    12fa:	85 c0                	test   %eax,%eax
    12fc:	74 0d                	je     130b <printint+0x6b>
    buf[i++] = '-';
    12fe:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    1303:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
    1308:	89 7d c4             	mov    %edi,-0x3c(%ebp)
    130b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    130e:	8b 7d bc             	mov    -0x44(%ebp),%edi
    1311:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    1315:	eb 0f                	jmp    1326 <printint+0x86>
    1317:	89 f6                	mov    %esi,%esi
    1319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    1320:	0f b6 13             	movzbl (%ebx),%edx
    1323:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1326:	83 ec 04             	sub    $0x4,%esp
    1329:	88 55 d7             	mov    %dl,-0x29(%ebp)
    132c:	6a 01                	push   $0x1
    132e:	56                   	push   %esi
    132f:	57                   	push   %edi
    1330:	e8 9c fe ff ff       	call   11d1 <write>

  while(--i >= 0)
    1335:	83 c4 10             	add    $0x10,%esp
    1338:	39 de                	cmp    %ebx,%esi
    133a:	75 e4                	jne    1320 <printint+0x80>
    putc(fd, buf[i]);
}
    133c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    133f:	5b                   	pop    %ebx
    1340:	5e                   	pop    %esi
    1341:	5f                   	pop    %edi
    1342:	5d                   	pop    %ebp
    1343:	c3                   	ret    
    1344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1348:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
    134f:	e9 75 ff ff ff       	jmp    12c9 <printint+0x29>
    1354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    135a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001360 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1360:	55                   	push   %ebp
    1361:	89 e5                	mov    %esp,%ebp
    1363:	57                   	push   %edi
    1364:	56                   	push   %esi
    1365:	53                   	push   %ebx
    1366:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1369:	8b 75 0c             	mov    0xc(%ebp),%esi
    136c:	0f b6 1e             	movzbl (%esi),%ebx
    136f:	84 db                	test   %bl,%bl
    1371:	0f 84 b9 00 00 00    	je     1430 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
    1377:	8d 45 10             	lea    0x10(%ebp),%eax
    137a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    137d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    1380:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    1382:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1385:	eb 38                	jmp    13bf <printf+0x5f>
    1387:	89 f6                	mov    %esi,%esi
    1389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    1390:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1393:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1398:	83 f8 25             	cmp    $0x25,%eax
    139b:	74 17                	je     13b4 <printf+0x54>
  write(fd, &c, 1);
    139d:	83 ec 04             	sub    $0x4,%esp
    13a0:	88 5d e7             	mov    %bl,-0x19(%ebp)
    13a3:	6a 01                	push   $0x1
    13a5:	57                   	push   %edi
    13a6:	ff 75 08             	pushl  0x8(%ebp)
    13a9:	e8 23 fe ff ff       	call   11d1 <write>
    13ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    13b1:	83 c4 10             	add    $0x10,%esp
    13b4:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    13b7:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    13bb:	84 db                	test   %bl,%bl
    13bd:	74 71                	je     1430 <printf+0xd0>
    c = fmt[i] & 0xff;
    13bf:	0f be cb             	movsbl %bl,%ecx
    13c2:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    13c5:	85 d2                	test   %edx,%edx
    13c7:	74 c7                	je     1390 <printf+0x30>
      }
    } else if(state == '%'){
    13c9:	83 fa 25             	cmp    $0x25,%edx
    13cc:	75 e6                	jne    13b4 <printf+0x54>
      if(c == 'd'){
    13ce:	83 f8 64             	cmp    $0x64,%eax
    13d1:	0f 84 99 00 00 00    	je     1470 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    13d7:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    13dd:	83 f9 70             	cmp    $0x70,%ecx
    13e0:	74 5e                	je     1440 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    13e2:	83 f8 73             	cmp    $0x73,%eax
    13e5:	0f 84 d5 00 00 00    	je     14c0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    13eb:	83 f8 63             	cmp    $0x63,%eax
    13ee:	0f 84 8c 00 00 00    	je     1480 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    13f4:	83 f8 25             	cmp    $0x25,%eax
    13f7:	0f 84 b3 00 00 00    	je     14b0 <printf+0x150>
  write(fd, &c, 1);
    13fd:	83 ec 04             	sub    $0x4,%esp
    1400:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    1404:	6a 01                	push   $0x1
    1406:	57                   	push   %edi
    1407:	ff 75 08             	pushl  0x8(%ebp)
    140a:	e8 c2 fd ff ff       	call   11d1 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    140f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1412:	83 c4 0c             	add    $0xc,%esp
    1415:	6a 01                	push   $0x1
    1417:	83 c6 01             	add    $0x1,%esi
    141a:	57                   	push   %edi
    141b:	ff 75 08             	pushl  0x8(%ebp)
    141e:	e8 ae fd ff ff       	call   11d1 <write>
  for(i = 0; fmt[i]; i++){
    1423:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    1427:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    142a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    142c:	84 db                	test   %bl,%bl
    142e:	75 8f                	jne    13bf <printf+0x5f>
    }
  }
}
    1430:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1433:	5b                   	pop    %ebx
    1434:	5e                   	pop    %esi
    1435:	5f                   	pop    %edi
    1436:	5d                   	pop    %ebp
    1437:	c3                   	ret    
    1438:	90                   	nop
    1439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 16, 0);
    1440:	83 ec 0c             	sub    $0xc,%esp
    1443:	b9 10 00 00 00       	mov    $0x10,%ecx
    1448:	6a 00                	push   $0x0
    144a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    144d:	8b 45 08             	mov    0x8(%ebp),%eax
    1450:	8b 13                	mov    (%ebx),%edx
    1452:	e8 49 fe ff ff       	call   12a0 <printint>
        ap++;
    1457:	89 d8                	mov    %ebx,%eax
    1459:	83 c4 10             	add    $0x10,%esp
      state = 0;
    145c:	31 d2                	xor    %edx,%edx
        ap++;
    145e:	83 c0 04             	add    $0x4,%eax
    1461:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1464:	e9 4b ff ff ff       	jmp    13b4 <printf+0x54>
    1469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1470:	83 ec 0c             	sub    $0xc,%esp
    1473:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1478:	6a 01                	push   $0x1
    147a:	eb ce                	jmp    144a <printf+0xea>
    147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1480:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1483:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1486:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1488:	6a 01                	push   $0x1
        ap++;
    148a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    148d:	57                   	push   %edi
    148e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1491:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1494:	e8 38 fd ff ff       	call   11d1 <write>
        ap++;
    1499:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    149c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    149f:	31 d2                	xor    %edx,%edx
    14a1:	e9 0e ff ff ff       	jmp    13b4 <printf+0x54>
    14a6:	8d 76 00             	lea    0x0(%esi),%esi
    14a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        putc(fd, c);
    14b0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    14b3:	83 ec 04             	sub    $0x4,%esp
    14b6:	e9 5a ff ff ff       	jmp    1415 <printf+0xb5>
    14bb:	90                   	nop
    14bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    14c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
    14c3:	8b 18                	mov    (%eax),%ebx
        ap++;
    14c5:	83 c0 04             	add    $0x4,%eax
    14c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    14cb:	85 db                	test   %ebx,%ebx
    14cd:	74 17                	je     14e6 <printf+0x186>
        while(*s != 0){
    14cf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    14d2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    14d4:	84 c0                	test   %al,%al
    14d6:	0f 84 d8 fe ff ff    	je     13b4 <printf+0x54>
    14dc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    14df:	89 de                	mov    %ebx,%esi
    14e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    14e4:	eb 1a                	jmp    1500 <printf+0x1a0>
          s = "(null)";
    14e6:	bb 52 17 00 00       	mov    $0x1752,%ebx
        while(*s != 0){
    14eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    14ee:	b8 28 00 00 00       	mov    $0x28,%eax
    14f3:	89 de                	mov    %ebx,%esi
    14f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    14f8:	90                   	nop
    14f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
    1500:	83 ec 04             	sub    $0x4,%esp
          s++;
    1503:	83 c6 01             	add    $0x1,%esi
    1506:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1509:	6a 01                	push   $0x1
    150b:	57                   	push   %edi
    150c:	53                   	push   %ebx
    150d:	e8 bf fc ff ff       	call   11d1 <write>
        while(*s != 0){
    1512:	0f b6 06             	movzbl (%esi),%eax
    1515:	83 c4 10             	add    $0x10,%esp
    1518:	84 c0                	test   %al,%al
    151a:	75 e4                	jne    1500 <printf+0x1a0>
    151c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    151f:	31 d2                	xor    %edx,%edx
    1521:	e9 8e fe ff ff       	jmp    13b4 <printf+0x54>
    1526:	66 90                	xchg   %ax,%ax
    1528:	66 90                	xchg   %ax,%ax
    152a:	66 90                	xchg   %ax,%ax
    152c:	66 90                	xchg   %ax,%ax
    152e:	66 90                	xchg   %ax,%ax

00001530 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1530:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1531:	a1 64 1d 00 00       	mov    0x1d64,%eax
{
    1536:	89 e5                	mov    %esp,%ebp
    1538:	57                   	push   %edi
    1539:	56                   	push   %esi
    153a:	53                   	push   %ebx
    153b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    153e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    1540:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1543:	39 c8                	cmp    %ecx,%eax
    1545:	73 19                	jae    1560 <free+0x30>
    1547:	89 f6                	mov    %esi,%esi
    1549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    1550:	39 d1                	cmp    %edx,%ecx
    1552:	72 14                	jb     1568 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1554:	39 d0                	cmp    %edx,%eax
    1556:	73 10                	jae    1568 <free+0x38>
{
    1558:	89 d0                	mov    %edx,%eax
    155a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    155c:	39 c8                	cmp    %ecx,%eax
    155e:	72 f0                	jb     1550 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1560:	39 d0                	cmp    %edx,%eax
    1562:	72 f4                	jb     1558 <free+0x28>
    1564:	39 d1                	cmp    %edx,%ecx
    1566:	73 f0                	jae    1558 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1568:	8b 73 fc             	mov    -0x4(%ebx),%esi
    156b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    156e:	39 fa                	cmp    %edi,%edx
    1570:	74 1e                	je     1590 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1572:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1575:	8b 50 04             	mov    0x4(%eax),%edx
    1578:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    157b:	39 f1                	cmp    %esi,%ecx
    157d:	74 28                	je     15a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    157f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1581:	5b                   	pop    %ebx
  freep = p;
    1582:	a3 64 1d 00 00       	mov    %eax,0x1d64
}
    1587:	5e                   	pop    %esi
    1588:	5f                   	pop    %edi
    1589:	5d                   	pop    %ebp
    158a:	c3                   	ret    
    158b:	90                   	nop
    158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1590:	03 72 04             	add    0x4(%edx),%esi
    1593:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1596:	8b 10                	mov    (%eax),%edx
    1598:	8b 12                	mov    (%edx),%edx
    159a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    159d:	8b 50 04             	mov    0x4(%eax),%edx
    15a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    15a3:	39 f1                	cmp    %esi,%ecx
    15a5:	75 d8                	jne    157f <free+0x4f>
    p->s.size += bp->s.size;
    15a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    15aa:	a3 64 1d 00 00       	mov    %eax,0x1d64
    p->s.size += bp->s.size;
    15af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    15b2:	8b 53 f8             	mov    -0x8(%ebx),%edx
    15b5:	89 10                	mov    %edx,(%eax)
}
    15b7:	5b                   	pop    %ebx
    15b8:	5e                   	pop    %esi
    15b9:	5f                   	pop    %edi
    15ba:	5d                   	pop    %ebp
    15bb:	c3                   	ret    
    15bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000015c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    15c0:	55                   	push   %ebp
    15c1:	89 e5                	mov    %esp,%ebp
    15c3:	57                   	push   %edi
    15c4:	56                   	push   %esi
    15c5:	53                   	push   %ebx
    15c6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    15cc:	8b 3d 64 1d 00 00    	mov    0x1d64,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15d2:	8d 70 07             	lea    0x7(%eax),%esi
    15d5:	c1 ee 03             	shr    $0x3,%esi
    15d8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    15db:	85 ff                	test   %edi,%edi
    15dd:	0f 84 ad 00 00 00    	je     1690 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15e3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    15e5:	8b 4a 04             	mov    0x4(%edx),%ecx
    15e8:	39 ce                	cmp    %ecx,%esi
    15ea:	76 72                	jbe    165e <malloc+0x9e>
    15ec:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    15f2:	bb 00 10 00 00       	mov    $0x1000,%ebx
    15f7:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    15fa:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    1601:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1604:	eb 1b                	jmp    1621 <malloc+0x61>
    1606:	8d 76 00             	lea    0x0(%esi),%esi
    1609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1610:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1612:	8b 48 04             	mov    0x4(%eax),%ecx
    1615:	39 f1                	cmp    %esi,%ecx
    1617:	73 4f                	jae    1668 <malloc+0xa8>
    1619:	8b 3d 64 1d 00 00    	mov    0x1d64,%edi
    161f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1621:	39 d7                	cmp    %edx,%edi
    1623:	75 eb                	jne    1610 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    1625:	83 ec 0c             	sub    $0xc,%esp
    1628:	ff 75 e4             	pushl  -0x1c(%ebp)
    162b:	e8 09 fc ff ff       	call   1239 <sbrk>
  if(p == (char*)-1)
    1630:	83 c4 10             	add    $0x10,%esp
    1633:	83 f8 ff             	cmp    $0xffffffff,%eax
    1636:	74 1c                	je     1654 <malloc+0x94>
  hp->s.size = nu;
    1638:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    163b:	83 ec 0c             	sub    $0xc,%esp
    163e:	83 c0 08             	add    $0x8,%eax
    1641:	50                   	push   %eax
    1642:	e8 e9 fe ff ff       	call   1530 <free>
  return freep;
    1647:	8b 15 64 1d 00 00    	mov    0x1d64,%edx
      if((p = morecore(nunits)) == 0)
    164d:	83 c4 10             	add    $0x10,%esp
    1650:	85 d2                	test   %edx,%edx
    1652:	75 bc                	jne    1610 <malloc+0x50>
        return 0;
  }
}
    1654:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1657:	31 c0                	xor    %eax,%eax
}
    1659:	5b                   	pop    %ebx
    165a:	5e                   	pop    %esi
    165b:	5f                   	pop    %edi
    165c:	5d                   	pop    %ebp
    165d:	c3                   	ret    
    if(p->s.size >= nunits){
    165e:	89 d0                	mov    %edx,%eax
    1660:	89 fa                	mov    %edi,%edx
    1662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1668:	39 ce                	cmp    %ecx,%esi
    166a:	74 54                	je     16c0 <malloc+0x100>
        p->s.size -= nunits;
    166c:	29 f1                	sub    %esi,%ecx
    166e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1671:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1674:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    1677:	89 15 64 1d 00 00    	mov    %edx,0x1d64
}
    167d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1680:	83 c0 08             	add    $0x8,%eax
}
    1683:	5b                   	pop    %ebx
    1684:	5e                   	pop    %esi
    1685:	5f                   	pop    %edi
    1686:	5d                   	pop    %ebp
    1687:	c3                   	ret    
    1688:	90                   	nop
    1689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    1690:	c7 05 64 1d 00 00 68 	movl   $0x1d68,0x1d64
    1697:	1d 00 00 
    base.s.size = 0;
    169a:	bf 68 1d 00 00       	mov    $0x1d68,%edi
    base.s.ptr = freep = prevp = &base;
    169f:	c7 05 68 1d 00 00 68 	movl   $0x1d68,0x1d68
    16a6:	1d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16a9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    16ab:	c7 05 6c 1d 00 00 00 	movl   $0x0,0x1d6c
    16b2:	00 00 00 
    if(p->s.size >= nunits){
    16b5:	e9 32 ff ff ff       	jmp    15ec <malloc+0x2c>
    16ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    16c0:	8b 08                	mov    (%eax),%ecx
    16c2:	89 0a                	mov    %ecx,(%edx)
    16c4:	eb b1                	jmp    1677 <malloc+0xb7>
