
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
       e:	81 ec 64 02 00 00    	sub    $0x264,%esp
  static int nfuncs;
  int *nfunc=&nfuncs;
  struct func funcs[MAXFUNC];

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      14:	eb 0f                	jmp    25 <main+0x25>
      16:	8d 76 00             	lea    0x0(%esi),%esi
      19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(fd >= 3){
      20:	83 f8 02             	cmp    $0x2,%eax
      23:	7f 7a                	jg     9f <main+0x9f>
  while((fd = open("console", O_RDWR)) >= 0){
      25:	83 ec 08             	sub    $0x8,%esp
      28:	6a 02                	push   $0x2
      2a:	68 66 11 00 00       	push   $0x1166
      2f:	e8 3e 0c 00 00       	call   c72 <open>
      34:	83 c4 10             	add    $0x10,%esp
      37:	85 c0                	test   %eax,%eax
      39:	79 e5                	jns    20 <main+0x20>
      3b:	eb 23                	jmp    60 <main+0x60>
      3d:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      40:	80 3d 22 17 00 00 20 	cmpb   $0x20,0x1722
      47:	0f 84 99 00 00 00    	je     e6 <main+0xe6>
int
fork1(void)
{
  int pid;

  pid = fork();
      4d:	e8 d8 0b 00 00       	call   c2a <fork>
  if(pid == -1)
      52:	83 f8 ff             	cmp    $0xffffffff,%eax
      55:	74 3b                	je     92 <main+0x92>
    if(fork1() == 0){
      57:	85 c0                	test   %eax,%eax
      59:	74 57                	je     b2 <main+0xb2>
    wait();
      5b:	e8 da 0b 00 00       	call   c3a <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
      60:	83 ec 08             	sub    $0x8,%esp
      63:	6a 64                	push   $0x64
      65:	68 20 17 00 00       	push   $0x1720
      6a:	e8 e1 01 00 00       	call   250 <getcmd>
      6f:	83 c4 10             	add    $0x10,%esp
      72:	85 c0                	test   %eax,%eax
      74:	78 37                	js     ad <main+0xad>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      76:	80 3d 20 17 00 00 63 	cmpb   $0x63,0x1720
      7d:	75 ce                	jne    4d <main+0x4d>
      7f:	80 3d 21 17 00 00 64 	cmpb   $0x64,0x1721
      86:	74 b8                	je     40 <main+0x40>
  pid = fork();
      88:	e8 9d 0b 00 00       	call   c2a <fork>
  if(pid == -1)
      8d:	83 f8 ff             	cmp    $0xffffffff,%eax
      90:	75 c5                	jne    57 <main+0x57>
    panic("fork");
      92:	83 ec 0c             	sub    $0xc,%esp
      95:	68 39 11 00 00       	push   $0x1139
      9a:	e8 01 02 00 00       	call   2a0 <panic>
      close(fd);
      9f:	83 ec 0c             	sub    $0xc,%esp
      a2:	50                   	push   %eax
      a3:	e8 b2 0b 00 00       	call   c5a <close>
      break;
      a8:	83 c4 10             	add    $0x10,%esp
      ab:	eb b3                	jmp    60 <main+0x60>
  exit();
      ad:	e8 80 0b 00 00       	call   c32 <exit>
      printf(2, "nfunc: %d\n",*nfunc);
      b2:	50                   	push   %eax
      b3:	ff 35 84 17 00 00    	pushl  0x1784
      b9:	68 f5 10 00 00       	push   $0x10f5
      be:	6a 02                	push   $0x2
      c0:	e8 cb 0c 00 00       	call   d90 <printf>
      runexp(parseexp(buf),funcs,nfunc);
      c5:	c7 04 24 20 17 00 00 	movl   $0x1720,(%esp)
      cc:	e8 9f 08 00 00       	call   970 <parseexp>
      d1:	8d 95 a0 fd ff ff    	lea    -0x260(%ebp),%edx
      d7:	83 c4 0c             	add    $0xc,%esp
      da:	68 84 17 00 00       	push   $0x1784
      df:	52                   	push   %edx
      e0:	50                   	push   %eax
      e1:	e8 da 01 00 00       	call   2c0 <runexp>
      buf[strlen(buf)-1] = 0;  // chop \n
      e6:	83 ec 0c             	sub    $0xc,%esp
      e9:	68 20 17 00 00       	push   $0x1720
      ee:	e8 6d 09 00 00       	call   a60 <strlen>
      if(chdir(buf+3) < 0)
      f3:	c7 04 24 23 17 00 00 	movl   $0x1723,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
      fa:	c6 80 1f 17 00 00 00 	movb   $0x0,0x171f(%eax)
      if(chdir(buf+3) < 0)
     101:	e8 9c 0b 00 00       	call   ca2 <chdir>
     106:	83 c4 10             	add    $0x10,%esp
     109:	85 c0                	test   %eax,%eax
     10b:	0f 89 4f ff ff ff    	jns    60 <main+0x60>
        printf(2, "cannot cd %s\n", buf+3);
     111:	52                   	push   %edx
     112:	68 23 17 00 00       	push   $0x1723
     117:	68 b4 11 00 00       	push   $0x11b4
     11c:	6a 02                	push   $0x2
     11e:	e8 6d 0c 00 00       	call   d90 <printf>
     123:	83 c4 10             	add    $0x10,%esp
     126:	e9 35 ff ff ff       	jmp    60 <main+0x60>
     12b:	66 90                	xchg   %ax,%ax
     12d:	66 90                	xchg   %ax,%ax
     12f:	90                   	nop

00000130 <replaceAtom>:
{
     130:	55                   	push   %ebp
     131:	89 e5                	mov    %esp,%ebp
     133:	57                   	push   %edi
     134:	56                   	push   %esi
     135:	53                   	push   %ebx
     136:	83 ec 0c             	sub    $0xc,%esp
     139:	8b 5d 08             	mov    0x8(%ebp),%ebx
     13c:	8b 75 0c             	mov    0xc(%ebp),%esi
  switch(exp->type)
     13f:	8b 03                	mov    (%ebx),%eax
     141:	83 f8 01             	cmp    $0x1,%eax
     144:	74 3a                	je     180 <replaceAtom+0x50>
     146:	7c 29                	jl     171 <replaceAtom+0x41>
     148:	83 f8 03             	cmp    $0x3,%eax
     14b:	7f 24                	jg     171 <replaceAtom+0x41>
    for(i=0;i<lst->length;i++)
     14d:	8b 43 04             	mov    0x4(%ebx),%eax
     150:	31 ff                	xor    %edi,%edi
     152:	85 c0                	test   %eax,%eax
     154:	7e 1b                	jle    171 <replaceAtom+0x41>
      replaceAtom(lst->sexps[i], o, d);
     156:	83 ec 04             	sub    $0x4,%esp
     159:	ff 75 10             	pushl  0x10(%ebp)
     15c:	56                   	push   %esi
     15d:	ff 74 bb 08          	pushl  0x8(%ebx,%edi,4)
    for(i=0;i<lst->length;i++)
     161:	83 c7 01             	add    $0x1,%edi
      replaceAtom(lst->sexps[i], o, d);
     164:	e8 c7 ff ff ff       	call   130 <replaceAtom>
    for(i=0;i<lst->length;i++)
     169:	83 c4 10             	add    $0x10,%esp
     16c:	3b 7b 04             	cmp    0x4(%ebx),%edi
     16f:	7c e5                	jl     156 <replaceAtom+0x26>
}
     171:	8d 65 f4             	lea    -0xc(%ebp),%esp
     174:	5b                   	pop    %ebx
     175:	5e                   	pop    %esi
     176:	5f                   	pop    %edi
     177:	5d                   	pop    %ebp
     178:	c3                   	ret    
     179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(strcmp(atm->symbol,o)==0)
     180:	83 ec 08             	sub    $0x8,%esp
     183:	56                   	push   %esi
     184:	ff 73 04             	pushl  0x4(%ebx)
     187:	e8 84 08 00 00       	call   a10 <strcmp>
     18c:	83 c4 10             	add    $0x10,%esp
     18f:	85 c0                	test   %eax,%eax
     191:	75 de                	jne    171 <replaceAtom+0x41>
      atm->symbol=d;
     193:	8b 45 10             	mov    0x10(%ebp),%eax
     196:	89 43 04             	mov    %eax,0x4(%ebx)
}
     199:	8d 65 f4             	lea    -0xc(%ebp),%esp
     19c:	5b                   	pop    %ebx
     19d:	5e                   	pop    %esi
     19e:	5f                   	pop    %edi
     19f:	5d                   	pop    %ebp
     1a0:	c3                   	ret    
     1a1:	eb 0d                	jmp    1b0 <defunc>
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

000001b0 <defunc>:
{
     1b0:	55                   	push   %ebp
     1b1:	89 e5                	mov    %esp,%ebp
     1b3:	57                   	push   %edi
     1b4:	56                   	push   %esi
     1b5:	53                   	push   %ebx
     1b6:	83 ec 24             	sub    $0x24,%esp
     1b9:	8b 55 10             	mov    0x10(%ebp),%edx
     1bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "start defun\n");
     1bf:	68 e8 10 00 00       	push   $0x10e8
     1c4:	6a 02                	push   $0x2
{
     1c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  printf(2, "start defun\n");
     1c9:	e8 c2 0b 00 00       	call   d90 <printf>
  struct func *fn=funcs+*nfunc;
     1ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  printf(2, "nfunc: %d\n", *nfunc);
     1d1:	83 c4 0c             	add    $0xc,%esp
  struct list *argv=(struct list*)lst->sexps[2];
     1d4:	8b 7b 10             	mov    0x10(%ebx),%edi
  struct func *fn=funcs+*nfunc;
     1d7:	8b 02                	mov    (%edx),%eax
     1d9:	6b f0 3c             	imul   $0x3c,%eax,%esi
  (*nfunc)++;
     1dc:	83 c0 01             	add    $0x1,%eax
  struct func *fn=funcs+*nfunc;
     1df:	03 75 0c             	add    0xc(%ebp),%esi
  (*nfunc)++;
     1e2:	89 02                	mov    %eax,(%edx)
  printf(2, "nfunc: %d\n", *nfunc);
     1e4:	50                   	push   %eax
     1e5:	68 f5 10 00 00       	push   $0x10f5
     1ea:	6a 02                	push   $0x2
     1ec:	e8 9f 0b 00 00       	call   d90 <printf>
  strcpy(fn->name, ((struct atom*)lst->sexps[1])->symbol);
     1f1:	58                   	pop    %eax
     1f2:	8b 43 0c             	mov    0xc(%ebx),%eax
     1f5:	5a                   	pop    %edx
     1f6:	ff 70 04             	pushl  0x4(%eax)
     1f9:	56                   	push   %esi
     1fa:	e8 e1 07 00 00       	call   9e0 <strcpy>
  fn->argc=argv->length;
     1ff:	8b 57 04             	mov    0x4(%edi),%edx
  for(i=0;i<fn->argc;i++)
     202:	83 c4 10             	add    $0x10,%esp
  fn->argc=argv->length;
     205:	89 56 34             	mov    %edx,0x34(%esi)
  fn->sexp=lst->sexps[3];
     208:	8b 43 14             	mov    0x14(%ebx),%eax
  for(i=0;i<fn->argc;i++)
     20b:	85 d2                	test   %edx,%edx
  fn->sexp=lst->sexps[3];
     20d:	89 46 38             	mov    %eax,0x38(%esi)
  for(i=0;i<fn->argc;i++)
     210:	7e 30                	jle    242 <defunc+0x92>
     212:	31 db                	xor    %ebx,%ebx
     214:	eb 0d                	jmp    223 <defunc+0x73>
     216:	8d 76 00             	lea    0x0(%esi),%esi
     219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
     220:	8b 46 38             	mov    0x38(%esi),%eax
    replaceAtom(fn->sexp, ((struct atom*)argv->sexps[i])->symbol, fn->argv[i]);
     223:	83 ec 04             	sub    $0x4,%esp
     226:	ff 74 9e 0c          	pushl  0xc(%esi,%ebx,4)
     22a:	8b 54 9f 08          	mov    0x8(%edi,%ebx,4),%edx
  for(i=0;i<fn->argc;i++)
     22e:	83 c3 01             	add    $0x1,%ebx
    replaceAtom(fn->sexp, ((struct atom*)argv->sexps[i])->symbol, fn->argv[i]);
     231:	ff 72 04             	pushl  0x4(%edx)
     234:	50                   	push   %eax
     235:	e8 f6 fe ff ff       	call   130 <replaceAtom>
  for(i=0;i<fn->argc;i++)
     23a:	83 c4 10             	add    $0x10,%esp
     23d:	39 5e 34             	cmp    %ebx,0x34(%esi)
     240:	7f de                	jg     220 <defunc+0x70>
}
     242:	8d 65 f4             	lea    -0xc(%ebp),%esp
     245:	5b                   	pop    %ebx
     246:	5e                   	pop    %esi
     247:	5f                   	pop    %edi
     248:	5d                   	pop    %ebp
     249:	c3                   	ret    
     24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000250 <getcmd>:
{
     250:	55                   	push   %ebp
     251:	89 e5                	mov    %esp,%ebp
     253:	56                   	push   %esi
     254:	53                   	push   %ebx
     255:	8b 75 0c             	mov    0xc(%ebp),%esi
     258:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     25b:	83 ec 08             	sub    $0x8,%esp
     25e:	68 00 11 00 00       	push   $0x1100
     263:	6a 02                	push   $0x2
     265:	e8 26 0b 00 00       	call   d90 <printf>
  memset(buf, 0, nbuf);
     26a:	83 c4 0c             	add    $0xc,%esp
     26d:	56                   	push   %esi
     26e:	6a 00                	push   $0x0
     270:	53                   	push   %ebx
     271:	e8 1a 08 00 00       	call   a90 <memset>
  gets(buf, nbuf);
     276:	58                   	pop    %eax
     277:	5a                   	pop    %edx
     278:	56                   	push   %esi
     279:	53                   	push   %ebx
     27a:	e8 71 08 00 00       	call   af0 <gets>
  if(buf[0] == 0) // EOF
     27f:	83 c4 10             	add    $0x10,%esp
     282:	31 c0                	xor    %eax,%eax
     284:	80 3b 00             	cmpb   $0x0,(%ebx)
     287:	0f 94 c0             	sete   %al
}
     28a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(buf[0] == 0) // EOF
     28d:	f7 d8                	neg    %eax
}
     28f:	5b                   	pop    %ebx
     290:	5e                   	pop    %esi
     291:	5d                   	pop    %ebp
     292:	c3                   	ret    
     293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002a0 <panic>:
{
     2a0:	55                   	push   %ebp
     2a1:	89 e5                	mov    %esp,%ebp
     2a3:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     2a6:	ff 75 08             	pushl  0x8(%ebp)
     2a9:	68 76 11 00 00       	push   $0x1176
     2ae:	6a 02                	push   $0x2
     2b0:	e8 db 0a 00 00       	call   d90 <printf>
  exit();
     2b5:	e8 78 09 00 00       	call   c32 <exit>
     2ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002c0 <runexp>:
{
     2c0:	55                   	push   %ebp
     2c1:	89 e5                	mov    %esp,%ebp
     2c3:	57                   	push   %edi
     2c4:	56                   	push   %esi
     2c5:	53                   	push   %ebx
     2c6:	83 ec 4c             	sub    $0x4c,%esp
     2c9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(exp== 0)
     2cc:	85 f6                	test   %esi,%esi
     2ce:	0f 84 0c 01 00 00    	je     3e0 <runexp+0x120>
  switch(exp->type){
     2d4:	8b 06                	mov    (%esi),%eax
     2d6:	83 f8 02             	cmp    $0x2,%eax
     2d9:	74 25                	je     300 <runexp+0x40>
     2db:	83 f8 03             	cmp    $0x3,%eax
     2de:	74 3a                	je     31a <runexp+0x5a>
     2e0:	83 e8 01             	sub    $0x1,%eax
     2e3:	0f 84 f7 00 00 00    	je     3e0 <runexp+0x120>
    panic("runexp");
     2e9:	83 ec 0c             	sub    $0xc,%esp
     2ec:	68 03 11 00 00       	push   $0x1103
     2f1:	e8 aa ff ff ff       	call   2a0 <panic>
     2f6:	8d 76 00             	lea    0x0(%esi),%esi
     2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for(i=0;i<lst->length;i++)
     300:	8b 46 04             	mov    0x4(%esi),%eax
     303:	85 c0                	test   %eax,%eax
     305:	0f 8e d5 00 00 00    	jle    3e0 <runexp+0x120>
      runexp(lst->sexps[i],funcs,nfunc);
     30b:	50                   	push   %eax
     30c:	ff 75 10             	pushl  0x10(%ebp)
     30f:	ff 75 0c             	pushl  0xc(%ebp)
     312:	ff 76 08             	pushl  0x8(%esi)
     315:	e8 a6 ff ff ff       	call   2c0 <runexp>
    printf(2, "in 1\n");
     31a:	50                   	push   %eax
     31b:	50                   	push   %eax
     31c:	68 0a 11 00 00       	push   $0x110a
     321:	6a 02                	push   $0x2
     323:	e8 68 0a 00 00       	call   d90 <printf>
    argv[lst->length]=0;
     328:	8b 46 04             	mov    0x4(%esi),%eax
    for(i=0;i<lst->length;i++)
     32b:	83 c4 10             	add    $0x10,%esp
     32e:	85 c0                	test   %eax,%eax
    argv[lst->length]=0;
     330:	c7 44 85 c0 00 00 00 	movl   $0x0,-0x40(%ebp,%eax,4)
     337:	00 
    for(i=0;i<lst->length;i++)
     338:	0f 8e a2 00 00 00    	jle    3e0 <runexp+0x120>
  int i,bufs=0;
     33e:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
    for(i=0;i<lst->length;i++)
     345:	31 db                	xor    %ebx,%ebx
     347:	eb 1c                	jmp    365 <runexp+0xa5>
     349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(i==lst->length-1)
     350:	8b 46 04             	mov    0x4(%esi),%eax
     353:	8d 50 ff             	lea    -0x1(%eax),%edx
     356:	39 da                	cmp    %ebx,%edx
     358:	0f 84 b7 01 00 00    	je     515 <runexp+0x255>
    for(i=0;i<lst->length;i++)
     35e:	83 c3 01             	add    $0x1,%ebx
     361:	39 d8                	cmp    %ebx,%eax
     363:	7e 7b                	jle    3e0 <runexp+0x120>
      printf(2, "in 2, length:%d\n",lst->length);
     365:	83 ec 04             	sub    $0x4,%esp
     368:	50                   	push   %eax
     369:	68 10 11 00 00       	push   $0x1110
     36e:	6a 02                	push   $0x2
     370:	e8 1b 0a 00 00       	call   d90 <printf>
      if(lst->sexps[i]->type==ATOM)
     375:	8b 54 9e 08          	mov    0x8(%esi,%ebx,4),%edx
     379:	83 c4 10             	add    $0x10,%esp
     37c:	8b 02                	mov    (%edx),%eax
     37e:	83 f8 01             	cmp    $0x1,%eax
     381:	74 62                	je     3e5 <runexp+0x125>
      else if(lst->sexps[i]->type==LIST)
     383:	83 f8 02             	cmp    $0x2,%eax
     386:	0f 84 65 02 00 00    	je     5f1 <runexp+0x331>
      else if(lst->sexps[i]->type==APPLY)
     38c:	83 f8 03             	cmp    $0x3,%eax
     38f:	74 70                	je     401 <runexp+0x141>
      if((i==0)&&(strcmp(argv[0], "defun")==0))
     391:	85 db                	test   %ebx,%ebx
     393:	75 bb                	jne    350 <runexp+0x90>
     395:	8b 7d c0             	mov    -0x40(%ebp),%edi
     398:	83 ec 08             	sub    $0x8,%esp
     39b:	68 7a 11 00 00       	push   $0x117a
     3a0:	57                   	push   %edi
     3a1:	e8 6a 06 00 00       	call   a10 <strcmp>
     3a6:	83 c4 10             	add    $0x10,%esp
     3a9:	85 c0                	test   %eax,%eax
     3ab:	75 a3                	jne    350 <runexp+0x90>
  pid = fork();
     3ad:	e8 78 08 00 00       	call   c2a <fork>
  if(pid == -1)
     3b2:	83 f8 ff             	cmp    $0xffffffff,%eax
     3b5:	0f 84 43 02 00 00    	je     5fe <runexp+0x33e>
          if(fork1() == 0){
     3bb:	85 c0                	test   %eax,%eax
     3bd:	75 14                	jne    3d3 <runexp+0x113>
            if(argv[0] == 0)
     3bf:	85 ff                	test   %edi,%edi
     3c1:	74 1d                	je     3e0 <runexp+0x120>
            defunc(lst,funcs,nfunc);
     3c3:	53                   	push   %ebx
     3c4:	ff 75 10             	pushl  0x10(%ebp)
     3c7:	ff 75 0c             	pushl  0xc(%ebp)
     3ca:	56                   	push   %esi
     3cb:	e8 e0 fd ff ff       	call   1b0 <defunc>
     3d0:	83 c4 10             	add    $0x10,%esp
          wait();
     3d3:	e8 62 08 00 00       	call   c3a <wait>
     3d8:	90                   	nop
     3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  exit();
     3e0:	e8 4d 08 00 00       	call   c32 <exit>
        argv[i]=((struct atom*)lst->sexps[i])->symbol;
     3e5:	8b 42 04             	mov    0x4(%edx),%eax
     3e8:	89 44 9d c0          	mov    %eax,-0x40(%ebp,%ebx,4)
        printf(2, "in 3, length:%d\n",lst->length);
     3ec:	50                   	push   %eax
     3ed:	ff 76 04             	pushl  0x4(%esi)
     3f0:	68 21 11 00 00       	push   $0x1121
     3f5:	6a 02                	push   $0x2
     3f7:	e8 94 09 00 00       	call   d90 <printf>
     3fc:	83 c4 10             	add    $0x10,%esp
     3ff:	eb 90                	jmp    391 <runexp+0xd1>
  pid = fork();
     401:	e8 24 08 00 00       	call   c2a <fork>
  if(pid == -1)
     406:	83 f8 ff             	cmp    $0xffffffff,%eax
     409:	0f 84 ef 01 00 00    	je     5fe <runexp+0x33e>
        if(fork1() == 0){
     40f:	85 c0                	test   %eax,%eax
     411:	75 46                	jne    459 <runexp+0x199>
          close(1);
     413:	83 ec 0c             	sub    $0xc,%esp
     416:	6a 01                	push   $0x1
     418:	e8 3d 08 00 00       	call   c5a <close>
          if(open(".etemp", O_WRONLY|O_CREATE) < 0){
     41d:	5f                   	pop    %edi
     41e:	58                   	pop    %eax
     41f:	68 01 02 00 00       	push   $0x201
     424:	68 3e 11 00 00       	push   $0x113e
     429:	e8 44 08 00 00       	call   c72 <open>
     42e:	83 c4 10             	add    $0x10,%esp
     431:	85 c0                	test   %eax,%eax
     433:	0f 88 e5 01 00 00    	js     61e <runexp+0x35e>
          printf(2, "start\n");
     439:	51                   	push   %ecx
     43a:	51                   	push   %ecx
     43b:	68 45 11 00 00       	push   $0x1145
     440:	6a 02                	push   $0x2
     442:	e8 49 09 00 00       	call   d90 <printf>
          runexp(lst->sexps[i],funcs,nfunc);
     447:	83 c4 0c             	add    $0xc,%esp
     44a:	ff 75 10             	pushl  0x10(%ebp)
     44d:	ff 75 0c             	pushl  0xc(%ebp)
     450:	ff 74 9e 08          	pushl  0x8(%esi,%ebx,4)
     454:	e8 67 fe ff ff       	call   2c0 <runexp>
        wait();
     459:	e8 dc 07 00 00       	call   c3a <wait>
        printf(2, "end\n");
     45e:	57                   	push   %edi
     45f:	57                   	push   %edi
     460:	68 4c 11 00 00       	push   $0x114c
     465:	6a 02                	push   $0x2
     467:	e8 24 09 00 00       	call   d90 <printf>
        close(2);
     46c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     473:	e8 e2 07 00 00       	call   c5a <close>
        if((ffd=open(".etemp", O_RDONLY)) < 0){
     478:	58                   	pop    %eax
     479:	5a                   	pop    %edx
     47a:	6a 00                	push   $0x0
     47c:	68 3e 11 00 00       	push   $0x113e
     481:	e8 ec 07 00 00       	call   c72 <open>
     486:	83 c4 10             	add    $0x10,%esp
     489:	85 c0                	test   %eax,%eax
     48b:	0f 88 7a 01 00 00    	js     60b <runexp+0x34b>
        printf(1,"fd: %d\n",ffd);
     491:	57                   	push   %edi
     492:	50                   	push   %eax
     493:	68 51 11 00 00       	push   $0x1151
     498:	6a 01                	push   $0x1
     49a:	e8 f1 08 00 00       	call   d90 <printf>
        argv[i]=argvbuf+bufs;
     49f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
        bufs+=read(2,argvbuf+bufs,20);
     4a2:	83 c4 0c             	add    $0xc,%esp
     4a5:	6a 14                	push   $0x14
        argv[i]=argvbuf+bufs;
     4a7:	8d b8 a0 17 00 00    	lea    0x17a0(%eax),%edi
        bufs+=read(2,argvbuf+bufs,20);
     4ad:	57                   	push   %edi
     4ae:	6a 02                	push   $0x2
        argv[i]=argvbuf+bufs;
     4b0:	89 7c 9d c0          	mov    %edi,-0x40(%ebp,%ebx,4)
        bufs+=read(2,argvbuf+bufs,20);
     4b4:	e8 91 07 00 00       	call   c4a <read>
     4b9:	03 45 b4             	add    -0x4c(%ebp),%eax
        printf(1, "sizeof : %d\n",bufs);
     4bc:	83 c4 0c             	add    $0xc,%esp
        argvbuf[bufs++]=0;
     4bf:	8d 48 01             	lea    0x1(%eax),%ecx
     4c2:	c6 80 a0 17 00 00 00 	movb   $0x0,0x17a0(%eax)
        printf(1, "sizeof : %d\n",bufs);
     4c9:	51                   	push   %ecx
     4ca:	68 59 11 00 00       	push   $0x1159
     4cf:	6a 01                	push   $0x1
        argvbuf[bufs++]=0;
     4d1:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
        printf(1, "sizeof : %d\n",bufs);
     4d4:	e8 b7 08 00 00       	call   d90 <printf>
        close(2);
     4d9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     4e0:	e8 75 07 00 00       	call   c5a <close>
        unlink(".etemp");
     4e5:	c7 04 24 3e 11 00 00 	movl   $0x113e,(%esp)
     4ec:	e8 91 07 00 00       	call   c82 <unlink>
        open("console", O_RDWR);
     4f1:	58                   	pop    %eax
     4f2:	5a                   	pop    %edx
     4f3:	6a 02                	push   $0x2
     4f5:	68 66 11 00 00       	push   $0x1166
     4fa:	e8 73 07 00 00       	call   c72 <open>
        printf(2,"argv%d: %s\n",i,argv[i]);
     4ff:	57                   	push   %edi
     500:	53                   	push   %ebx
     501:	68 6e 11 00 00       	push   $0x116e
     506:	6a 02                	push   $0x2
     508:	e8 83 08 00 00       	call   d90 <printf>
     50d:	83 c4 20             	add    $0x20,%esp
     510:	e9 7c fe ff ff       	jmp    391 <runexp+0xd1>
        printf(2, "in 4, length:%d\n",lst->length);
     515:	51                   	push   %ecx
     516:	50                   	push   %eax
        for(j=0;j<MAXFUNC;j++)
     517:	31 ff                	xor    %edi,%edi
        printf(2, "in 4, length:%d\n",lst->length);
     519:	68 80 11 00 00       	push   $0x1180
     51e:	6a 02                	push   $0x2
     520:	e8 6b 08 00 00       	call   d90 <printf>
        printf(2, "exec %s\n",argv[0]);
     525:	8b 45 c0             	mov    -0x40(%ebp),%eax
     528:	83 c4 0c             	add    $0xc,%esp
     52b:	50                   	push   %eax
     52c:	68 91 11 00 00       	push   $0x1191
     531:	6a 02                	push   $0x2
     533:	89 45 b0             	mov    %eax,-0x50(%ebp)
     536:	e8 55 08 00 00       	call   d90 <printf>
        printf(2, "nfunc: %d\n",*nfunc);
     53b:	8b 4d 10             	mov    0x10(%ebp),%ecx
     53e:	83 c4 0c             	add    $0xc,%esp
     541:	ff 31                	pushl  (%ecx)
     543:	68 f5 10 00 00       	push   $0x10f5
     548:	6a 02                	push   $0x2
     54a:	e8 41 08 00 00       	call   d90 <printf>
     54f:	8b 55 0c             	mov    0xc(%ebp),%edx
        for(j=0;j<MAXFUNC;j++)
     552:	89 5d ac             	mov    %ebx,-0x54(%ebp)
     555:	83 c4 10             	add    $0x10,%esp
     558:	8b 5d b0             	mov    -0x50(%ebp),%ebx
     55b:	89 75 08             	mov    %esi,0x8(%ebp)
     55e:	89 d6                	mov    %edx,%esi
          if(strcmp(argv[0], funcs[j].name)==0)
     560:	83 ec 08             	sub    $0x8,%esp
     563:	56                   	push   %esi
     564:	53                   	push   %ebx
     565:	e8 a6 04 00 00       	call   a10 <strcmp>
     56a:	83 c4 10             	add    $0x10,%esp
     56d:	85 c0                	test   %eax,%eax
     56f:	74 4c                	je     5bd <runexp+0x2fd>
        for(j=0;j<MAXFUNC;j++)
     571:	83 c7 01             	add    $0x1,%edi
     574:	83 c6 3c             	add    $0x3c,%esi
     577:	83 ff 0a             	cmp    $0xa,%edi
     57a:	75 e4                	jne    560 <runexp+0x2a0>
     57c:	8b 5d ac             	mov    -0x54(%ebp),%ebx
     57f:	8b 75 08             	mov    0x8(%ebp),%esi
  pid = fork();
     582:	e8 a3 06 00 00       	call   c2a <fork>
  if(pid == -1)
     587:	83 f8 ff             	cmp    $0xffffffff,%eax
     58a:	74 72                	je     5fe <runexp+0x33e>
        if(fork1() == 0){
     58c:	85 c0                	test   %eax,%eax
     58e:	75 20                	jne    5b0 <runexp+0x2f0>
          if(argv[0] == 0)
     590:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
     594:	0f 84 46 fe ff ff    	je     3e0 <runexp+0x120>
            runexp(funcs[j].sexp,funcs,nfunc);
     59a:	6b ff 3c             	imul   $0x3c,%edi,%edi
     59d:	50                   	push   %eax
     59e:	8b 45 0c             	mov    0xc(%ebp),%eax
     5a1:	ff 75 10             	pushl  0x10(%ebp)
     5a4:	ff 75 0c             	pushl  0xc(%ebp)
     5a7:	ff 74 38 38          	pushl  0x38(%eax,%edi,1)
     5ab:	e8 10 fd ff ff       	call   2c0 <runexp>
        wait();
     5b0:	e8 85 06 00 00       	call   c3a <wait>
     5b5:	8b 46 04             	mov    0x4(%esi),%eax
     5b8:	e9 a1 fd ff ff       	jmp    35e <runexp+0x9e>
     5bd:	89 f2                	mov    %esi,%edx
     5bf:	8b 5d ac             	mov    -0x54(%ebp),%ebx
     5c2:	8b 75 08             	mov    0x8(%ebp),%esi
            for(k=0;k<funcs[j].argc;k++)
     5c5:	8b 4a 34             	mov    0x34(%edx),%ecx
     5c8:	85 c9                	test   %ecx,%ecx
     5ca:	7e 12                	jle    5de <runexp+0x31e>
              funcs[j].argv[k]=argv[k+1];
     5cc:	83 c0 01             	add    $0x1,%eax
     5cf:	8b 5c 85 c0          	mov    -0x40(%ebp,%eax,4),%ebx
            for(k=0;k<funcs[j].argc;k++)
     5d3:	39 c8                	cmp    %ecx,%eax
              funcs[j].argv[k]=argv[k+1];
     5d5:	89 5c 82 08          	mov    %ebx,0x8(%edx,%eax,4)
            for(k=0;k<funcs[j].argc;k++)
     5d9:	75 f1                	jne    5cc <runexp+0x30c>
     5db:	8b 5d ac             	mov    -0x54(%ebp),%ebx
            printf(2, "find func\n");
     5de:	52                   	push   %edx
     5df:	52                   	push   %edx
     5e0:	68 9a 11 00 00       	push   $0x119a
     5e5:	6a 02                	push   $0x2
     5e7:	e8 a4 07 00 00       	call   d90 <printf>
            break;
     5ec:	83 c4 10             	add    $0x10,%esp
     5ef:	eb 91                	jmp    582 <runexp+0x2c2>
        panic("syntax");
     5f1:	83 ec 0c             	sub    $0xc,%esp
     5f4:	68 32 11 00 00       	push   $0x1132
     5f9:	e8 a2 fc ff ff       	call   2a0 <panic>
    panic("fork");
     5fe:	83 ec 0c             	sub    $0xc,%esp
     601:	68 39 11 00 00       	push   $0x1139
     606:	e8 95 fc ff ff       	call   2a0 <panic>
          printf(1, "open console temp file failed\n");
     60b:	51                   	push   %ecx
     60c:	51                   	push   %ecx
     60d:	68 c4 11 00 00       	push   $0x11c4
     612:	6a 01                	push   $0x1
     614:	e8 77 07 00 00       	call   d90 <printf>
          exit();
     619:	e8 14 06 00 00       	call   c32 <exit>
            printf(2, "open console temp file failed\n");
     61e:	53                   	push   %ebx
     61f:	53                   	push   %ebx
     620:	68 c4 11 00 00       	push   $0x11c4
     625:	6a 02                	push   $0x2
     627:	e8 64 07 00 00       	call   d90 <printf>
            exit();
     62c:	e8 01 06 00 00       	call   c32 <exit>
     631:	eb 0d                	jmp    640 <fork1>
     633:	90                   	nop
     634:	90                   	nop
     635:	90                   	nop
     636:	90                   	nop
     637:	90                   	nop
     638:	90                   	nop
     639:	90                   	nop
     63a:	90                   	nop
     63b:	90                   	nop
     63c:	90                   	nop
     63d:	90                   	nop
     63e:	90                   	nop
     63f:	90                   	nop

00000640 <fork1>:
{
     640:	55                   	push   %ebp
     641:	89 e5                	mov    %esp,%ebp
     643:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     646:	e8 df 05 00 00       	call   c2a <fork>
  if(pid == -1)
     64b:	83 f8 ff             	cmp    $0xffffffff,%eax
     64e:	74 02                	je     652 <fork1+0x12>
  return pid;
}
     650:	c9                   	leave  
     651:	c3                   	ret    
    panic("fork");
     652:	83 ec 0c             	sub    $0xc,%esp
     655:	68 39 11 00 00       	push   $0x1139
     65a:	e8 41 fc ff ff       	call   2a0 <panic>
     65f:	90                   	nop

00000660 <atom>:
//PAGEBREAK!
// Constructors

struct sexp*
atom(void)
{
     660:	55                   	push   %ebp
     661:	89 e5                	mov    %esp,%ebp
     663:	53                   	push   %ebx
     664:	83 ec 10             	sub    $0x10,%esp
  struct atom *exp;

  exp= malloc(sizeof(*exp));
     667:	6a 0c                	push   $0xc
     669:	e8 82 09 00 00       	call   ff0 <malloc>
  memset(exp, 0, sizeof(*exp));
     66e:	83 c4 0c             	add    $0xc,%esp
  exp= malloc(sizeof(*exp));
     671:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     673:	6a 0c                	push   $0xc
     675:	6a 00                	push   $0x0
     677:	50                   	push   %eax
     678:	e8 13 04 00 00       	call   a90 <memset>
  return (struct sexp*)exp;
}
     67d:	89 d8                	mov    %ebx,%eax
     67f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     682:	c9                   	leave  
     683:	c3                   	ret    
     684:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     68a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000690 <list>:

struct sexp*
list(void)
{
     690:	55                   	push   %ebp
     691:	89 e5                	mov    %esp,%ebp
     693:	53                   	push   %ebx
     694:	83 ec 10             	sub    $0x10,%esp
  struct list *exp;

  exp= malloc(sizeof(*exp));
     697:	6a 30                	push   $0x30
     699:	e8 52 09 00 00       	call   ff0 <malloc>
  memset(exp, 0, sizeof(*exp));
     69e:	83 c4 0c             	add    $0xc,%esp
  exp= malloc(sizeof(*exp));
     6a1:	89 c3                	mov    %eax,%ebx
  memset(exp, 0, sizeof(*exp));
     6a3:	6a 30                	push   $0x30
     6a5:	6a 00                	push   $0x0
     6a7:	50                   	push   %eax
     6a8:	e8 e3 03 00 00       	call   a90 <memset>
  return (struct sexp*)exp;
}
     6ad:	89 d8                	mov    %ebx,%eax
     6af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     6b2:	c9                   	leave  
     6b3:	c3                   	ret    
     6b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     6ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000006c0 <peek>:
char whitespace[] = " \t\r\n\v";
char esymbols[] = "()";

int
peek(char **ps, char *es, char *toks)
{
     6c0:	55                   	push   %ebp
     6c1:	89 e5                	mov    %esp,%ebp
     6c3:	57                   	push   %edi
     6c4:	56                   	push   %esi
     6c5:	53                   	push   %ebx
     6c6:	83 ec 0c             	sub    $0xc,%esp
     6c9:	8b 7d 08             	mov    0x8(%ebp),%edi
     6cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     6cf:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     6d1:	39 f3                	cmp    %esi,%ebx
     6d3:	72 12                	jb     6e7 <peek+0x27>
     6d5:	eb 28                	jmp    6ff <peek+0x3f>
     6d7:	89 f6                	mov    %esi,%esi
     6d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
     6e0:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     6e3:	39 de                	cmp    %ebx,%esi
     6e5:	74 18                	je     6ff <peek+0x3f>
     6e7:	0f be 03             	movsbl (%ebx),%eax
     6ea:	83 ec 08             	sub    $0x8,%esp
     6ed:	50                   	push   %eax
     6ee:	68 fc 16 00 00       	push   $0x16fc
     6f3:	e8 b8 03 00 00       	call   ab0 <strchr>
     6f8:	83 c4 10             	add    $0x10,%esp
     6fb:	85 c0                	test   %eax,%eax
     6fd:	75 e1                	jne    6e0 <peek+0x20>
  *ps = s;
     6ff:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     701:	0f be 13             	movsbl (%ebx),%edx
     704:	31 c0                	xor    %eax,%eax
     706:	84 d2                	test   %dl,%dl
     708:	74 17                	je     721 <peek+0x61>
     70a:	83 ec 08             	sub    $0x8,%esp
     70d:	52                   	push   %edx
     70e:	ff 75 10             	pushl  0x10(%ebp)
     711:	e8 9a 03 00 00       	call   ab0 <strchr>
     716:	83 c4 10             	add    $0x10,%esp
     719:	85 c0                	test   %eax,%eax
     71b:	0f 95 c0             	setne  %al
     71e:	0f b6 c0             	movzbl %al,%eax
}
     721:	8d 65 f4             	lea    -0xc(%ebp),%esp
     724:	5b                   	pop    %ebx
     725:	5e                   	pop    %esi
     726:	5f                   	pop    %edi
     727:	5d                   	pop    %ebp
     728:	c3                   	ret    
     729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000730 <parseatom>:
  return ret;
}

struct sexp*
parseatom(char **ps, char *es)
{
     730:	55                   	push   %ebp
     731:	89 e5                	mov    %esp,%ebp
     733:	57                   	push   %edi
     734:	56                   	push   %esi
     735:	53                   	push   %ebx
     736:	83 ec 0c             	sub    $0xc,%esp
     739:	8b 7d 08             	mov    0x8(%ebp),%edi
     73c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct atom *atm;
  struct sexp *ret;

  char *s=*ps;
     73f:	8b 37                	mov    (%edi),%esi
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
     741:	39 de                	cmp    %ebx,%esi
     743:	89 f0                	mov    %esi,%eax
     745:	72 2e                	jb     775 <parseatom+0x45>
     747:	eb 44                	jmp    78d <parseatom+0x5d>
     749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     750:	8b 07                	mov    (%edi),%eax
     752:	83 ec 08             	sub    $0x8,%esp
     755:	0f be 00             	movsbl (%eax),%eax
     758:	50                   	push   %eax
     759:	68 f8 16 00 00       	push   $0x16f8
     75e:	e8 4d 03 00 00       	call   ab0 <strchr>
     763:	83 c4 10             	add    $0x10,%esp
     766:	85 c0                	test   %eax,%eax
     768:	75 23                	jne    78d <parseatom+0x5d>
    (*ps)++;
     76a:	8b 07                	mov    (%edi),%eax
     76c:	83 c0 01             	add    $0x1,%eax
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
     76f:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
     771:	89 07                	mov    %eax,(%edi)
  while((*ps) < es && !strchr(whitespace, *(*ps))&& !strchr(esymbols, *(*ps))) //peek whitespace
     773:	73 18                	jae    78d <parseatom+0x5d>
     775:	0f be 00             	movsbl (%eax),%eax
     778:	83 ec 08             	sub    $0x8,%esp
     77b:	50                   	push   %eax
     77c:	68 fc 16 00 00       	push   $0x16fc
     781:	e8 2a 03 00 00       	call   ab0 <strchr>
     786:	83 c4 10             	add    $0x10,%esp
     789:	85 c0                	test   %eax,%eax
     78b:	74 c3                	je     750 <parseatom+0x20>

  ret=atom();
     78d:	e8 ce fe ff ff       	call   660 <atom>
  atm=(struct atom*)ret;

  atm->type=ATOM;
     792:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  atm->symbol=s;
     798:	89 70 04             	mov    %esi,0x4(%eax)
  atm->esymbol=*ps;
     79b:	8b 17                	mov    (%edi),%edx
     79d:	89 50 08             	mov    %edx,0x8(%eax)

  return ret;
}
     7a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7a3:	5b                   	pop    %ebx
     7a4:	5e                   	pop    %esi
     7a5:	5f                   	pop    %edi
     7a6:	5d                   	pop    %ebp
     7a7:	c3                   	ret    
     7a8:	90                   	nop
     7a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000007b0 <parsesexp>:

struct sexp*
parsesexp(char **ps, char *es)
{
     7b0:	55                   	push   %ebp
     7b1:	89 e5                	mov    %esp,%ebp
     7b3:	56                   	push   %esi
     7b4:	53                   	push   %ebx
     7b5:	8b 75 08             	mov    0x8(%ebp),%esi
     7b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct sexp *ret=0;

  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
     7bb:	8b 06                	mov    (%esi),%eax
     7bd:	39 c3                	cmp    %eax,%ebx
     7bf:	77 10                	ja     7d1 <parsesexp+0x21>
     7c1:	eb 28                	jmp    7eb <parsesexp+0x3b>
     7c3:	90                   	nop
     7c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    (*ps)++;
     7c8:	83 c0 01             	add    $0x1,%eax
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
     7cb:	39 d8                	cmp    %ebx,%eax
    (*ps)++;
     7cd:	89 06                	mov    %eax,(%esi)
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
     7cf:	73 1a                	jae    7eb <parsesexp+0x3b>
     7d1:	0f be 00             	movsbl (%eax),%eax
     7d4:	83 ec 08             	sub    $0x8,%esp
     7d7:	50                   	push   %eax
     7d8:	68 fc 16 00 00       	push   $0x16fc
     7dd:	e8 ce 02 00 00       	call   ab0 <strchr>
     7e2:	83 c4 10             	add    $0x10,%esp
     7e5:	85 c0                	test   %eax,%eax
    (*ps)++;
     7e7:	8b 06                	mov    (%esi),%eax
  while((*ps) < es && strchr(whitespace, *(*ps))) //skip whitespace
     7e9:	75 dd                	jne    7c8 <parsesexp+0x18>
  switch(*(*ps)){
     7eb:	0f b6 10             	movzbl (%eax),%edx
     7ee:	80 fa 27             	cmp    $0x27,%dl
     7f1:	74 55                	je     848 <parsesexp+0x98>
     7f3:	80 fa 28             	cmp    $0x28,%dl
     7f6:	74 28                	je     820 <parsesexp+0x70>
     7f8:	84 d2                	test   %dl,%dl
     7fa:	74 14                	je     810 <parsesexp+0x60>
    (*ps)+=2;
    ret=parselist(ps, es);
    (*ps)++;
    break;
  default:
    ret=parseatom(ps, es);
     7fc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
     7ff:	89 75 08             	mov    %esi,0x8(%ebp)
    break;
  }
  return ret;
}
     802:	8d 65 f8             	lea    -0x8(%ebp),%esp
     805:	5b                   	pop    %ebx
     806:	5e                   	pop    %esi
     807:	5d                   	pop    %ebp
    ret=parseatom(ps, es);
     808:	e9 23 ff ff ff       	jmp    730 <parseatom>
     80d:	8d 76 00             	lea    0x0(%esi),%esi
}
     810:	8d 65 f8             	lea    -0x8(%ebp),%esp
  struct sexp *ret=0;
     813:	31 c0                	xor    %eax,%eax
}
     815:	5b                   	pop    %ebx
     816:	5e                   	pop    %esi
     817:	5d                   	pop    %ebp
     818:	c3                   	ret    
     819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ret=parselist(ps, es);
     820:	83 ec 08             	sub    $0x8,%esp
    (*ps)++;
     823:	83 c0 01             	add    $0x1,%eax
     826:	89 06                	mov    %eax,(%esi)
    ret=parselist(ps, es);
     828:	53                   	push   %ebx
     829:	56                   	push   %esi
     82a:	e8 41 00 00 00       	call   870 <parselist>
    ret->type=APPLY;
     82f:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    break;
     835:	83 c4 10             	add    $0x10,%esp
    (*ps)++;
     838:	83 06 01             	addl   $0x1,(%esi)
}
     83b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     83e:	5b                   	pop    %ebx
     83f:	5e                   	pop    %esi
     840:	5d                   	pop    %ebp
     841:	c3                   	ret    
     842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ret=parselist(ps, es);
     848:	83 ec 08             	sub    $0x8,%esp
    (*ps)+=2;
     84b:	83 c0 02             	add    $0x2,%eax
     84e:	89 06                	mov    %eax,(%esi)
    ret=parselist(ps, es);
     850:	53                   	push   %ebx
     851:	56                   	push   %esi
     852:	e8 19 00 00 00       	call   870 <parselist>
    (*ps)++;
     857:	83 06 01             	addl   $0x1,(%esi)
    break;
     85a:	83 c4 10             	add    $0x10,%esp
}
     85d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     860:	5b                   	pop    %ebx
     861:	5e                   	pop    %esi
     862:	5d                   	pop    %ebp
     863:	c3                   	ret    
     864:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     86a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000870 <parselist>:
{
     870:	55                   	push   %ebp
     871:	89 e5                	mov    %esp,%ebp
     873:	57                   	push   %edi
     874:	56                   	push   %esi
     875:	53                   	push   %ebx
     876:	83 ec 1c             	sub    $0x1c,%esp
     879:	8b 75 08             	mov    0x8(%ebp),%esi
     87c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  ret=list();
     87f:	e8 0c fe ff ff       	call   690 <list>
  lst->type=LIST;
     884:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  ret=list();
     88a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *res=*ps;
     88d:	8b 0e                	mov    (%esi),%ecx
  while(res<es)
     88f:	39 f9                	cmp    %edi,%ecx
     891:	89 cb                	mov    %ecx,%ebx
     893:	73 3b                	jae    8d0 <parselist+0x60>
  int i=1;
     895:	ba 01 00 00 00       	mov    $0x1,%edx
     89a:	eb 14                	jmp    8b0 <parselist+0x40>
     89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*res==')')
     8a0:	3c 29                	cmp    $0x29,%al
     8a2:	75 05                	jne    8a9 <parselist+0x39>
      if(i==0)
     8a4:	83 ea 01             	sub    $0x1,%edx
     8a7:	74 27                	je     8d0 <parselist+0x60>
    res++;
     8a9:	83 c3 01             	add    $0x1,%ebx
  while(res<es)
     8ac:	39 df                	cmp    %ebx,%edi
     8ae:	74 11                	je     8c1 <parselist+0x51>
    if(*res=='(')
     8b0:	0f b6 03             	movzbl (%ebx),%eax
     8b3:	3c 28                	cmp    $0x28,%al
     8b5:	75 e9                	jne    8a0 <parselist+0x30>
    res++;
     8b7:	83 c3 01             	add    $0x1,%ebx
      i++;
     8ba:	83 c2 01             	add    $0x1,%edx
  while(res<es)
     8bd:	39 df                	cmp    %ebx,%edi
     8bf:	75 ef                	jne    8b0 <parselist+0x40>
    panic("syntax");
     8c1:	83 ec 0c             	sub    $0xc,%esp
     8c4:	68 32 11 00 00       	push   $0x1132
     8c9:	e8 d2 f9 ff ff       	call   2a0 <panic>
     8ce:	66 90                	xchg   %ax,%ax
  if(res==es)
     8d0:	39 df                	cmp    %ebx,%edi
     8d2:	74 ed                	je     8c1 <parselist+0x51>
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
     8d4:	31 ff                	xor    %edi,%edi
     8d6:	eb 0a                	jmp    8e2 <parselist+0x72>
     8d8:	90                   	nop
     8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     8e0:	8b 0e                	mov    (%esi),%ecx
     8e2:	39 d9                	cmp    %ebx,%ecx
     8e4:	73 1c                	jae    902 <parselist+0x92>
    lst->sexps[i]=parsesexp(ps, res);
     8e6:	83 ec 08             	sub    $0x8,%esp
     8e9:	53                   	push   %ebx
     8ea:	56                   	push   %esi
     8eb:	e8 c0 fe ff ff       	call   7b0 <parsesexp>
     8f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
     8f3:	83 c4 10             	add    $0x10,%esp
    lst->sexps[i]=parsesexp(ps, res);
     8f6:	89 44 ba 08          	mov    %eax,0x8(%edx,%edi,4)
  for(i=0;i<MAXARGS&&(*ps)<res;i++)
     8fa:	83 c7 01             	add    $0x1,%edi
     8fd:	83 ff 0a             	cmp    $0xa,%edi
     900:	75 de                	jne    8e0 <parselist+0x70>
  lst->length=i;
     902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     905:	89 78 04             	mov    %edi,0x4(%eax)
}
     908:	8d 65 f4             	lea    -0xc(%ebp),%esp
     90b:	5b                   	pop    %ebx
     90c:	5e                   	pop    %esi
     90d:	5f                   	pop    %edi
     90e:	5d                   	pop    %ebp
     90f:	c3                   	ret    

00000910 <snulterminate>:
  return exp;
}

struct sexp*
snulterminate(struct sexp *exp)
{
     910:	55                   	push   %ebp
     911:	89 e5                	mov    %esp,%ebp
     913:	56                   	push   %esi
     914:	53                   	push   %ebx
     915:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;
  struct list *lst;
  struct atom *atm;

  if(exp== 0)
     918:	85 db                	test   %ebx,%ebx
     91a:	74 2e                	je     94a <snulterminate+0x3a>
    return 0;

  switch(exp->type){
     91c:	8b 03                	mov    (%ebx),%eax
     91e:	83 f8 01             	cmp    $0x1,%eax
     921:	74 35                	je     958 <snulterminate+0x48>
     923:	7c 25                	jl     94a <snulterminate+0x3a>
     925:	83 f8 03             	cmp    $0x3,%eax
     928:	7f 20                	jg     94a <snulterminate+0x3a>
    break;

  case APPLY:
  case LIST:
    lst = (struct list*)exp;
    for(i=0;i<lst->length;i++)
     92a:	8b 43 04             	mov    0x4(%ebx),%eax
     92d:	31 f6                	xor    %esi,%esi
     92f:	85 c0                	test   %eax,%eax
     931:	7e 17                	jle    94a <snulterminate+0x3a>
      snulterminate(lst->sexps[i]);
     933:	83 ec 0c             	sub    $0xc,%esp
     936:	ff 74 b3 08          	pushl  0x8(%ebx,%esi,4)
    for(i=0;i<lst->length;i++)
     93a:	83 c6 01             	add    $0x1,%esi
      snulterminate(lst->sexps[i]);
     93d:	e8 ce ff ff ff       	call   910 <snulterminate>
    for(i=0;i<lst->length;i++)
     942:	83 c4 10             	add    $0x10,%esp
     945:	3b 73 04             	cmp    0x4(%ebx),%esi
     948:	7c e9                	jl     933 <snulterminate+0x23>
    break;
  }
  return exp;
}
     94a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     94d:	89 d8                	mov    %ebx,%eax
     94f:	5b                   	pop    %ebx
     950:	5e                   	pop    %esi
     951:	5d                   	pop    %ebp
     952:	c3                   	ret    
     953:	90                   	nop
     954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *atm->esymbol = 0;
     958:	8b 43 08             	mov    0x8(%ebx),%eax
     95b:	c6 00 00             	movb   $0x0,(%eax)
}
     95e:	8d 65 f8             	lea    -0x8(%ebp),%esp
     961:	89 d8                	mov    %ebx,%eax
     963:	5b                   	pop    %ebx
     964:	5e                   	pop    %esi
     965:	5d                   	pop    %ebp
     966:	c3                   	ret    
     967:	89 f6                	mov    %esi,%esi
     969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000970 <parseexp>:
{
     970:	55                   	push   %ebp
     971:	89 e5                	mov    %esp,%ebp
     973:	56                   	push   %esi
     974:	53                   	push   %ebx
  es = s + strlen(s);
     975:	8b 5d 08             	mov    0x8(%ebp),%ebx
     978:	83 ec 0c             	sub    $0xc,%esp
     97b:	53                   	push   %ebx
     97c:	e8 df 00 00 00       	call   a60 <strlen>
  exp= parsesexp(&s, es);
     981:	59                   	pop    %ecx
  es = s + strlen(s);
     982:	01 c3                	add    %eax,%ebx
  exp= parsesexp(&s, es);
     984:	8d 45 08             	lea    0x8(%ebp),%eax
     987:	5e                   	pop    %esi
     988:	53                   	push   %ebx
     989:	50                   	push   %eax
     98a:	e8 21 fe ff ff       	call   7b0 <parsesexp>
     98f:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     991:	8d 45 08             	lea    0x8(%ebp),%eax
     994:	83 c4 0c             	add    $0xc,%esp
     997:	68 0f 11 00 00       	push   $0x110f
     99c:	53                   	push   %ebx
     99d:	50                   	push   %eax
     99e:	e8 1d fd ff ff       	call   6c0 <peek>
  if(s != es){
     9a3:	8b 45 08             	mov    0x8(%ebp),%eax
     9a6:	83 c4 10             	add    $0x10,%esp
     9a9:	39 d8                	cmp    %ebx,%eax
     9ab:	75 12                	jne    9bf <parseexp+0x4f>
  snulterminate(exp);
     9ad:	83 ec 0c             	sub    $0xc,%esp
     9b0:	56                   	push   %esi
     9b1:	e8 5a ff ff ff       	call   910 <snulterminate>
}
     9b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
     9b9:	89 f0                	mov    %esi,%eax
     9bb:	5b                   	pop    %ebx
     9bc:	5e                   	pop    %esi
     9bd:	5d                   	pop    %ebp
     9be:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     9bf:	52                   	push   %edx
     9c0:	50                   	push   %eax
     9c1:	68 a5 11 00 00       	push   $0x11a5
     9c6:	6a 02                	push   $0x2
     9c8:	e8 c3 03 00 00       	call   d90 <printf>
    panic("syntax");
     9cd:	c7 04 24 32 11 00 00 	movl   $0x1132,(%esp)
     9d4:	e8 c7 f8 ff ff       	call   2a0 <panic>
     9d9:	66 90                	xchg   %ax,%ax
     9db:	66 90                	xchg   %ax,%ax
     9dd:	66 90                	xchg   %ax,%ax
     9df:	90                   	nop

000009e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     9e0:	55                   	push   %ebp
     9e1:	89 e5                	mov    %esp,%ebp
     9e3:	53                   	push   %ebx
     9e4:	8b 45 08             	mov    0x8(%ebp),%eax
     9e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9ea:	89 c2                	mov    %eax,%edx
     9ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     9f0:	83 c1 01             	add    $0x1,%ecx
     9f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     9f7:	83 c2 01             	add    $0x1,%edx
     9fa:	84 db                	test   %bl,%bl
     9fc:	88 5a ff             	mov    %bl,-0x1(%edx)
     9ff:	75 ef                	jne    9f0 <strcpy+0x10>
    ;
  return os;
}
     a01:	5b                   	pop    %ebx
     a02:	5d                   	pop    %ebp
     a03:	c3                   	ret    
     a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000a10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     a10:	55                   	push   %ebp
     a11:	89 e5                	mov    %esp,%ebp
     a13:	53                   	push   %ebx
     a14:	8b 55 08             	mov    0x8(%ebp),%edx
     a17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     a1a:	0f b6 02             	movzbl (%edx),%eax
     a1d:	0f b6 19             	movzbl (%ecx),%ebx
     a20:	84 c0                	test   %al,%al
     a22:	75 1c                	jne    a40 <strcmp+0x30>
     a24:	eb 2a                	jmp    a50 <strcmp+0x40>
     a26:	8d 76 00             	lea    0x0(%esi),%esi
     a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
     a30:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     a33:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
     a36:	83 c1 01             	add    $0x1,%ecx
     a39:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
     a3c:	84 c0                	test   %al,%al
     a3e:	74 10                	je     a50 <strcmp+0x40>
     a40:	38 d8                	cmp    %bl,%al
     a42:	74 ec                	je     a30 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     a44:	29 d8                	sub    %ebx,%eax
}
     a46:	5b                   	pop    %ebx
     a47:	5d                   	pop    %ebp
     a48:	c3                   	ret    
     a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a50:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     a52:	29 d8                	sub    %ebx,%eax
}
     a54:	5b                   	pop    %ebx
     a55:	5d                   	pop    %ebp
     a56:	c3                   	ret    
     a57:	89 f6                	mov    %esi,%esi
     a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a60 <strlen>:

uint
strlen(char *s)
{
     a60:	55                   	push   %ebp
     a61:	89 e5                	mov    %esp,%ebp
     a63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     a66:	80 39 00             	cmpb   $0x0,(%ecx)
     a69:	74 15                	je     a80 <strlen+0x20>
     a6b:	31 d2                	xor    %edx,%edx
     a6d:	8d 76 00             	lea    0x0(%esi),%esi
     a70:	83 c2 01             	add    $0x1,%edx
     a73:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     a77:	89 d0                	mov    %edx,%eax
     a79:	75 f5                	jne    a70 <strlen+0x10>
    ;
  return n;
}
     a7b:	5d                   	pop    %ebp
     a7c:	c3                   	ret    
     a7d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
     a80:	31 c0                	xor    %eax,%eax
}
     a82:	5d                   	pop    %ebp
     a83:	c3                   	ret    
     a84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     a8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000a90 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a90:	55                   	push   %ebp
     a91:	89 e5                	mov    %esp,%ebp
     a93:	57                   	push   %edi
     a94:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     a97:	8b 4d 10             	mov    0x10(%ebp),%ecx
     a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
     a9d:	89 d7                	mov    %edx,%edi
     a9f:	fc                   	cld    
     aa0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     aa2:	89 d0                	mov    %edx,%eax
     aa4:	5f                   	pop    %edi
     aa5:	5d                   	pop    %ebp
     aa6:	c3                   	ret    
     aa7:	89 f6                	mov    %esi,%esi
     aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ab0 <strchr>:

char*
strchr(const char *s, char c)
{
     ab0:	55                   	push   %ebp
     ab1:	89 e5                	mov    %esp,%ebp
     ab3:	53                   	push   %ebx
     ab4:	8b 45 08             	mov    0x8(%ebp),%eax
     ab7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
     aba:	0f b6 10             	movzbl (%eax),%edx
     abd:	84 d2                	test   %dl,%dl
     abf:	74 1d                	je     ade <strchr+0x2e>
    if(*s == c)
     ac1:	38 d3                	cmp    %dl,%bl
     ac3:	89 d9                	mov    %ebx,%ecx
     ac5:	75 0d                	jne    ad4 <strchr+0x24>
     ac7:	eb 17                	jmp    ae0 <strchr+0x30>
     ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ad0:	38 ca                	cmp    %cl,%dl
     ad2:	74 0c                	je     ae0 <strchr+0x30>
  for(; *s; s++)
     ad4:	83 c0 01             	add    $0x1,%eax
     ad7:	0f b6 10             	movzbl (%eax),%edx
     ada:	84 d2                	test   %dl,%dl
     adc:	75 f2                	jne    ad0 <strchr+0x20>
      return (char*)s;
  return 0;
     ade:	31 c0                	xor    %eax,%eax
}
     ae0:	5b                   	pop    %ebx
     ae1:	5d                   	pop    %ebp
     ae2:	c3                   	ret    
     ae3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000af0 <gets>:

char*
gets(char *buf, int max)
{
     af0:	55                   	push   %ebp
     af1:	89 e5                	mov    %esp,%ebp
     af3:	57                   	push   %edi
     af4:	56                   	push   %esi
     af5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     af6:	31 f6                	xor    %esi,%esi
     af8:	89 f3                	mov    %esi,%ebx
{
     afa:	83 ec 1c             	sub    $0x1c,%esp
     afd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     b00:	eb 2f                	jmp    b31 <gets+0x41>
     b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     b08:	8d 45 e7             	lea    -0x19(%ebp),%eax
     b0b:	83 ec 04             	sub    $0x4,%esp
     b0e:	6a 01                	push   $0x1
     b10:	50                   	push   %eax
     b11:	6a 00                	push   $0x0
     b13:	e8 32 01 00 00       	call   c4a <read>
    if(cc < 1)
     b18:	83 c4 10             	add    $0x10,%esp
     b1b:	85 c0                	test   %eax,%eax
     b1d:	7e 1c                	jle    b3b <gets+0x4b>
      break;
    buf[i++] = c;
     b1f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     b23:	83 c7 01             	add    $0x1,%edi
     b26:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     b29:	3c 0a                	cmp    $0xa,%al
     b2b:	74 23                	je     b50 <gets+0x60>
     b2d:	3c 0d                	cmp    $0xd,%al
     b2f:	74 1f                	je     b50 <gets+0x60>
  for(i=0; i+1 < max; ){
     b31:	83 c3 01             	add    $0x1,%ebx
     b34:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     b37:	89 fe                	mov    %edi,%esi
     b39:	7c cd                	jl     b08 <gets+0x18>
     b3b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     b40:	c6 03 00             	movb   $0x0,(%ebx)
}
     b43:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b46:	5b                   	pop    %ebx
     b47:	5e                   	pop    %esi
     b48:	5f                   	pop    %edi
     b49:	5d                   	pop    %ebp
     b4a:	c3                   	ret    
     b4b:	90                   	nop
     b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     b50:	8b 75 08             	mov    0x8(%ebp),%esi
     b53:	8b 45 08             	mov    0x8(%ebp),%eax
     b56:	01 de                	add    %ebx,%esi
     b58:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     b5a:	c6 03 00             	movb   $0x0,(%ebx)
}
     b5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b60:	5b                   	pop    %ebx
     b61:	5e                   	pop    %esi
     b62:	5f                   	pop    %edi
     b63:	5d                   	pop    %ebp
     b64:	c3                   	ret    
     b65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b70 <stat>:

int
stat(char *n, struct stat *st)
{
     b70:	55                   	push   %ebp
     b71:	89 e5                	mov    %esp,%ebp
     b73:	56                   	push   %esi
     b74:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b75:	83 ec 08             	sub    $0x8,%esp
     b78:	6a 00                	push   $0x0
     b7a:	ff 75 08             	pushl  0x8(%ebp)
     b7d:	e8 f0 00 00 00       	call   c72 <open>
  if(fd < 0)
     b82:	83 c4 10             	add    $0x10,%esp
     b85:	85 c0                	test   %eax,%eax
     b87:	78 27                	js     bb0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     b89:	83 ec 08             	sub    $0x8,%esp
     b8c:	ff 75 0c             	pushl  0xc(%ebp)
     b8f:	89 c3                	mov    %eax,%ebx
     b91:	50                   	push   %eax
     b92:	e8 f3 00 00 00       	call   c8a <fstat>
  close(fd);
     b97:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     b9a:	89 c6                	mov    %eax,%esi
  close(fd);
     b9c:	e8 b9 00 00 00       	call   c5a <close>
  return r;
     ba1:	83 c4 10             	add    $0x10,%esp
}
     ba4:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ba7:	89 f0                	mov    %esi,%eax
     ba9:	5b                   	pop    %ebx
     baa:	5e                   	pop    %esi
     bab:	5d                   	pop    %ebp
     bac:	c3                   	ret    
     bad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     bb0:	be ff ff ff ff       	mov    $0xffffffff,%esi
     bb5:	eb ed                	jmp    ba4 <stat+0x34>
     bb7:	89 f6                	mov    %esi,%esi
     bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000bc0 <atoi>:

int
atoi(const char *s)
{
     bc0:	55                   	push   %ebp
     bc1:	89 e5                	mov    %esp,%ebp
     bc3:	53                   	push   %ebx
     bc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     bc7:	0f be 11             	movsbl (%ecx),%edx
     bca:	8d 42 d0             	lea    -0x30(%edx),%eax
     bcd:	3c 09                	cmp    $0x9,%al
  n = 0;
     bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
     bd4:	77 1f                	ja     bf5 <atoi+0x35>
     bd6:	8d 76 00             	lea    0x0(%esi),%esi
     bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
     be0:	8d 04 80             	lea    (%eax,%eax,4),%eax
     be3:	83 c1 01             	add    $0x1,%ecx
     be6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
     bea:	0f be 11             	movsbl (%ecx),%edx
     bed:	8d 5a d0             	lea    -0x30(%edx),%ebx
     bf0:	80 fb 09             	cmp    $0x9,%bl
     bf3:	76 eb                	jbe    be0 <atoi+0x20>
  return n;
}
     bf5:	5b                   	pop    %ebx
     bf6:	5d                   	pop    %ebp
     bf7:	c3                   	ret    
     bf8:	90                   	nop
     bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000c00 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     c00:	55                   	push   %ebp
     c01:	89 e5                	mov    %esp,%ebp
     c03:	56                   	push   %esi
     c04:	53                   	push   %ebx
     c05:	8b 5d 10             	mov    0x10(%ebp),%ebx
     c08:	8b 45 08             	mov    0x8(%ebp),%eax
     c0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     c0e:	85 db                	test   %ebx,%ebx
     c10:	7e 14                	jle    c26 <memmove+0x26>
     c12:	31 d2                	xor    %edx,%edx
     c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
     c18:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     c1c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     c1f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
     c22:	39 d3                	cmp    %edx,%ebx
     c24:	75 f2                	jne    c18 <memmove+0x18>
  return vdst;
}
     c26:	5b                   	pop    %ebx
     c27:	5e                   	pop    %esi
     c28:	5d                   	pop    %ebp
     c29:	c3                   	ret    

00000c2a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     c2a:	b8 01 00 00 00       	mov    $0x1,%eax
     c2f:	cd 40                	int    $0x40
     c31:	c3                   	ret    

00000c32 <exit>:
SYSCALL(exit)
     c32:	b8 02 00 00 00       	mov    $0x2,%eax
     c37:	cd 40                	int    $0x40
     c39:	c3                   	ret    

00000c3a <wait>:
SYSCALL(wait)
     c3a:	b8 03 00 00 00       	mov    $0x3,%eax
     c3f:	cd 40                	int    $0x40
     c41:	c3                   	ret    

00000c42 <pipe>:
SYSCALL(pipe)
     c42:	b8 04 00 00 00       	mov    $0x4,%eax
     c47:	cd 40                	int    $0x40
     c49:	c3                   	ret    

00000c4a <read>:
SYSCALL(read)
     c4a:	b8 05 00 00 00       	mov    $0x5,%eax
     c4f:	cd 40                	int    $0x40
     c51:	c3                   	ret    

00000c52 <write>:
SYSCALL(write)
     c52:	b8 10 00 00 00       	mov    $0x10,%eax
     c57:	cd 40                	int    $0x40
     c59:	c3                   	ret    

00000c5a <close>:
SYSCALL(close)
     c5a:	b8 15 00 00 00       	mov    $0x15,%eax
     c5f:	cd 40                	int    $0x40
     c61:	c3                   	ret    

00000c62 <kill>:
SYSCALL(kill)
     c62:	b8 06 00 00 00       	mov    $0x6,%eax
     c67:	cd 40                	int    $0x40
     c69:	c3                   	ret    

00000c6a <exec>:
SYSCALL(exec)
     c6a:	b8 07 00 00 00       	mov    $0x7,%eax
     c6f:	cd 40                	int    $0x40
     c71:	c3                   	ret    

00000c72 <open>:
SYSCALL(open)
     c72:	b8 0f 00 00 00       	mov    $0xf,%eax
     c77:	cd 40                	int    $0x40
     c79:	c3                   	ret    

00000c7a <mknod>:
SYSCALL(mknod)
     c7a:	b8 11 00 00 00       	mov    $0x11,%eax
     c7f:	cd 40                	int    $0x40
     c81:	c3                   	ret    

00000c82 <unlink>:
SYSCALL(unlink)
     c82:	b8 12 00 00 00       	mov    $0x12,%eax
     c87:	cd 40                	int    $0x40
     c89:	c3                   	ret    

00000c8a <fstat>:
SYSCALL(fstat)
     c8a:	b8 08 00 00 00       	mov    $0x8,%eax
     c8f:	cd 40                	int    $0x40
     c91:	c3                   	ret    

00000c92 <link>:
SYSCALL(link)
     c92:	b8 13 00 00 00       	mov    $0x13,%eax
     c97:	cd 40                	int    $0x40
     c99:	c3                   	ret    

00000c9a <mkdir>:
SYSCALL(mkdir)
     c9a:	b8 14 00 00 00       	mov    $0x14,%eax
     c9f:	cd 40                	int    $0x40
     ca1:	c3                   	ret    

00000ca2 <chdir>:
SYSCALL(chdir)
     ca2:	b8 09 00 00 00       	mov    $0x9,%eax
     ca7:	cd 40                	int    $0x40
     ca9:	c3                   	ret    

00000caa <dup>:
SYSCALL(dup)
     caa:	b8 0a 00 00 00       	mov    $0xa,%eax
     caf:	cd 40                	int    $0x40
     cb1:	c3                   	ret    

00000cb2 <getpid>:
SYSCALL(getpid)
     cb2:	b8 0b 00 00 00       	mov    $0xb,%eax
     cb7:	cd 40                	int    $0x40
     cb9:	c3                   	ret    

00000cba <sbrk>:
SYSCALL(sbrk)
     cba:	b8 0c 00 00 00       	mov    $0xc,%eax
     cbf:	cd 40                	int    $0x40
     cc1:	c3                   	ret    

00000cc2 <sleep>:
SYSCALL(sleep)
     cc2:	b8 0d 00 00 00       	mov    $0xd,%eax
     cc7:	cd 40                	int    $0x40
     cc9:	c3                   	ret    

00000cca <uptime>:
SYSCALL(uptime)
     cca:	b8 0e 00 00 00       	mov    $0xe,%eax
     ccf:	cd 40                	int    $0x40
     cd1:	c3                   	ret    

00000cd2 <trace>:
SYSCALL(trace)
     cd2:	b8 16 00 00 00       	mov    $0x16,%eax
     cd7:	cd 40                	int    $0x40
     cd9:	c3                   	ret    

00000cda <getsharem>:
SYSCALL(getsharem)
     cda:	b8 17 00 00 00       	mov    $0x17,%eax
     cdf:	cd 40                	int    $0x40
     ce1:	c3                   	ret    

00000ce2 <releasesharem>:
SYSCALL(releasesharem)
     ce2:	b8 18 00 00 00       	mov    $0x18,%eax
     ce7:	cd 40                	int    $0x40
     ce9:	c3                   	ret    
     cea:	66 90                	xchg   %ax,%ax
     cec:	66 90                	xchg   %ax,%ax
     cee:	66 90                	xchg   %ax,%ax

00000cf0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     cf0:	55                   	push   %ebp
     cf1:	89 e5                	mov    %esp,%ebp
     cf3:	57                   	push   %edi
     cf4:	56                   	push   %esi
     cf5:	53                   	push   %ebx
     cf6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cf9:	85 d2                	test   %edx,%edx
{
     cfb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
     cfe:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
     d00:	79 76                	jns    d78 <printint+0x88>
     d02:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     d06:	74 70                	je     d78 <printint+0x88>
    x = -xx;
     d08:	f7 d8                	neg    %eax
    neg = 1;
     d0a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     d11:	31 f6                	xor    %esi,%esi
     d13:	8d 5d d7             	lea    -0x29(%ebp),%ebx
     d16:	eb 0a                	jmp    d22 <printint+0x32>
     d18:	90                   	nop
     d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
     d20:	89 fe                	mov    %edi,%esi
     d22:	31 d2                	xor    %edx,%edx
     d24:	8d 7e 01             	lea    0x1(%esi),%edi
     d27:	f7 f1                	div    %ecx
     d29:	0f b6 92 ec 11 00 00 	movzbl 0x11ec(%edx),%edx
  }while((x /= base) != 0);
     d30:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
     d32:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
     d35:	75 e9                	jne    d20 <printint+0x30>
  if(neg)
     d37:	8b 45 c4             	mov    -0x3c(%ebp),%eax
     d3a:	85 c0                	test   %eax,%eax
     d3c:	74 08                	je     d46 <printint+0x56>
    buf[i++] = '-';
     d3e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
     d43:	8d 7e 02             	lea    0x2(%esi),%edi
     d46:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
     d4a:	8b 7d c0             	mov    -0x40(%ebp),%edi
     d4d:	8d 76 00             	lea    0x0(%esi),%esi
     d50:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
     d53:	83 ec 04             	sub    $0x4,%esp
     d56:	83 ee 01             	sub    $0x1,%esi
     d59:	6a 01                	push   $0x1
     d5b:	53                   	push   %ebx
     d5c:	57                   	push   %edi
     d5d:	88 45 d7             	mov    %al,-0x29(%ebp)
     d60:	e8 ed fe ff ff       	call   c52 <write>

  while(--i >= 0)
     d65:	83 c4 10             	add    $0x10,%esp
     d68:	39 de                	cmp    %ebx,%esi
     d6a:	75 e4                	jne    d50 <printint+0x60>
    putc(fd, buf[i]);
}
     d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d6f:	5b                   	pop    %ebx
     d70:	5e                   	pop    %esi
     d71:	5f                   	pop    %edi
     d72:	5d                   	pop    %ebp
     d73:	c3                   	ret    
     d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     d78:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     d7f:	eb 90                	jmp    d11 <printint+0x21>
     d81:	eb 0d                	jmp    d90 <printf>
     d83:	90                   	nop
     d84:	90                   	nop
     d85:	90                   	nop
     d86:	90                   	nop
     d87:	90                   	nop
     d88:	90                   	nop
     d89:	90                   	nop
     d8a:	90                   	nop
     d8b:	90                   	nop
     d8c:	90                   	nop
     d8d:	90                   	nop
     d8e:	90                   	nop
     d8f:	90                   	nop

00000d90 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     d90:	55                   	push   %ebp
     d91:	89 e5                	mov    %esp,%ebp
     d93:	57                   	push   %edi
     d94:	56                   	push   %esi
     d95:	53                   	push   %ebx
     d96:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     d99:	8b 75 0c             	mov    0xc(%ebp),%esi
     d9c:	0f b6 1e             	movzbl (%esi),%ebx
     d9f:	84 db                	test   %bl,%bl
     da1:	0f 84 b3 00 00 00    	je     e5a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
     da7:	8d 45 10             	lea    0x10(%ebp),%eax
     daa:	83 c6 01             	add    $0x1,%esi
  state = 0;
     dad:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
     daf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     db2:	eb 2f                	jmp    de3 <printf+0x53>
     db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
     db8:	83 f8 25             	cmp    $0x25,%eax
     dbb:	0f 84 a7 00 00 00    	je     e68 <printf+0xd8>
  write(fd, &c, 1);
     dc1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
     dc4:	83 ec 04             	sub    $0x4,%esp
     dc7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
     dca:	6a 01                	push   $0x1
     dcc:	50                   	push   %eax
     dcd:	ff 75 08             	pushl  0x8(%ebp)
     dd0:	e8 7d fe ff ff       	call   c52 <write>
     dd5:	83 c4 10             	add    $0x10,%esp
     dd8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
     ddb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
     ddf:	84 db                	test   %bl,%bl
     de1:	74 77                	je     e5a <printf+0xca>
    if(state == 0){
     de3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
     de5:	0f be cb             	movsbl %bl,%ecx
     de8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     deb:	74 cb                	je     db8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ded:	83 ff 25             	cmp    $0x25,%edi
     df0:	75 e6                	jne    dd8 <printf+0x48>
      if(c == 'd'){
     df2:	83 f8 64             	cmp    $0x64,%eax
     df5:	0f 84 05 01 00 00    	je     f00 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     dfb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     e01:	83 f9 70             	cmp    $0x70,%ecx
     e04:	74 72                	je     e78 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     e06:	83 f8 73             	cmp    $0x73,%eax
     e09:	0f 84 99 00 00 00    	je     ea8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     e0f:	83 f8 63             	cmp    $0x63,%eax
     e12:	0f 84 08 01 00 00    	je     f20 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     e18:	83 f8 25             	cmp    $0x25,%eax
     e1b:	0f 84 ef 00 00 00    	je     f10 <printf+0x180>
  write(fd, &c, 1);
     e21:	8d 45 e7             	lea    -0x19(%ebp),%eax
     e24:	83 ec 04             	sub    $0x4,%esp
     e27:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     e2b:	6a 01                	push   $0x1
     e2d:	50                   	push   %eax
     e2e:	ff 75 08             	pushl  0x8(%ebp)
     e31:	e8 1c fe ff ff       	call   c52 <write>
     e36:	83 c4 0c             	add    $0xc,%esp
     e39:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     e3c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
     e3f:	6a 01                	push   $0x1
     e41:	50                   	push   %eax
     e42:	ff 75 08             	pushl  0x8(%ebp)
     e45:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     e48:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
     e4a:	e8 03 fe ff ff       	call   c52 <write>
  for(i = 0; fmt[i]; i++){
     e4f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
     e53:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     e56:	84 db                	test   %bl,%bl
     e58:	75 89                	jne    de3 <printf+0x53>
    }
  }
}
     e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e5d:	5b                   	pop    %ebx
     e5e:	5e                   	pop    %esi
     e5f:	5f                   	pop    %edi
     e60:	5d                   	pop    %ebp
     e61:	c3                   	ret    
     e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
     e68:	bf 25 00 00 00       	mov    $0x25,%edi
     e6d:	e9 66 ff ff ff       	jmp    dd8 <printf+0x48>
     e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
     e78:	83 ec 0c             	sub    $0xc,%esp
     e7b:	b9 10 00 00 00       	mov    $0x10,%ecx
     e80:	6a 00                	push   $0x0
     e82:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     e85:	8b 45 08             	mov    0x8(%ebp),%eax
     e88:	8b 17                	mov    (%edi),%edx
     e8a:	e8 61 fe ff ff       	call   cf0 <printint>
        ap++;
     e8f:	89 f8                	mov    %edi,%eax
     e91:	83 c4 10             	add    $0x10,%esp
      state = 0;
     e94:	31 ff                	xor    %edi,%edi
        ap++;
     e96:	83 c0 04             	add    $0x4,%eax
     e99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     e9c:	e9 37 ff ff ff       	jmp    dd8 <printf+0x48>
     ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
     ea8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     eab:	8b 08                	mov    (%eax),%ecx
        ap++;
     ead:	83 c0 04             	add    $0x4,%eax
     eb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
     eb3:	85 c9                	test   %ecx,%ecx
     eb5:	0f 84 8e 00 00 00    	je     f49 <printf+0x1b9>
        while(*s != 0){
     ebb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
     ebe:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
     ec0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
     ec2:	84 c0                	test   %al,%al
     ec4:	0f 84 0e ff ff ff    	je     dd8 <printf+0x48>
     eca:	89 75 d0             	mov    %esi,-0x30(%ebp)
     ecd:	89 de                	mov    %ebx,%esi
     ecf:	8b 5d 08             	mov    0x8(%ebp),%ebx
     ed2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
     ed5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
     ed8:	83 ec 04             	sub    $0x4,%esp
          s++;
     edb:	83 c6 01             	add    $0x1,%esi
     ede:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
     ee1:	6a 01                	push   $0x1
     ee3:	57                   	push   %edi
     ee4:	53                   	push   %ebx
     ee5:	e8 68 fd ff ff       	call   c52 <write>
        while(*s != 0){
     eea:	0f b6 06             	movzbl (%esi),%eax
     eed:	83 c4 10             	add    $0x10,%esp
     ef0:	84 c0                	test   %al,%al
     ef2:	75 e4                	jne    ed8 <printf+0x148>
     ef4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
     ef7:	31 ff                	xor    %edi,%edi
     ef9:	e9 da fe ff ff       	jmp    dd8 <printf+0x48>
     efe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
     f00:	83 ec 0c             	sub    $0xc,%esp
     f03:	b9 0a 00 00 00       	mov    $0xa,%ecx
     f08:	6a 01                	push   $0x1
     f0a:	e9 73 ff ff ff       	jmp    e82 <printf+0xf2>
     f0f:	90                   	nop
  write(fd, &c, 1);
     f10:	83 ec 04             	sub    $0x4,%esp
     f13:	88 5d e5             	mov    %bl,-0x1b(%ebp)
     f16:	8d 45 e5             	lea    -0x1b(%ebp),%eax
     f19:	6a 01                	push   $0x1
     f1b:	e9 21 ff ff ff       	jmp    e41 <printf+0xb1>
        putc(fd, *ap);
     f20:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
     f23:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
     f26:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
     f28:	6a 01                	push   $0x1
        ap++;
     f2a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
     f2d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
     f30:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     f33:	50                   	push   %eax
     f34:	ff 75 08             	pushl  0x8(%ebp)
     f37:	e8 16 fd ff ff       	call   c52 <write>
        ap++;
     f3c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
     f3f:	83 c4 10             	add    $0x10,%esp
      state = 0;
     f42:	31 ff                	xor    %edi,%edi
     f44:	e9 8f fe ff ff       	jmp    dd8 <printf+0x48>
          s = "(null)";
     f49:	bb e4 11 00 00       	mov    $0x11e4,%ebx
        while(*s != 0){
     f4e:	b8 28 00 00 00       	mov    $0x28,%eax
     f53:	e9 72 ff ff ff       	jmp    eca <printf+0x13a>
     f58:	66 90                	xchg   %ax,%ax
     f5a:	66 90                	xchg   %ax,%ax
     f5c:	66 90                	xchg   %ax,%ax
     f5e:	66 90                	xchg   %ax,%ax

00000f60 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f60:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f61:	a1 04 18 00 00       	mov    0x1804,%eax
{
     f66:	89 e5                	mov    %esp,%ebp
     f68:	57                   	push   %edi
     f69:	56                   	push   %esi
     f6a:	53                   	push   %ebx
     f6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
     f6e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
     f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f78:	39 c8                	cmp    %ecx,%eax
     f7a:	8b 10                	mov    (%eax),%edx
     f7c:	73 32                	jae    fb0 <free+0x50>
     f7e:	39 d1                	cmp    %edx,%ecx
     f80:	72 04                	jb     f86 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f82:	39 d0                	cmp    %edx,%eax
     f84:	72 32                	jb     fb8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
     f86:	8b 73 fc             	mov    -0x4(%ebx),%esi
     f89:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     f8c:	39 fa                	cmp    %edi,%edx
     f8e:	74 30                	je     fc0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
     f90:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     f93:	8b 50 04             	mov    0x4(%eax),%edx
     f96:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     f99:	39 f1                	cmp    %esi,%ecx
     f9b:	74 3a                	je     fd7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
     f9d:	89 08                	mov    %ecx,(%eax)
  freep = p;
     f9f:	a3 04 18 00 00       	mov    %eax,0x1804
}
     fa4:	5b                   	pop    %ebx
     fa5:	5e                   	pop    %esi
     fa6:	5f                   	pop    %edi
     fa7:	5d                   	pop    %ebp
     fa8:	c3                   	ret    
     fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fb0:	39 d0                	cmp    %edx,%eax
     fb2:	72 04                	jb     fb8 <free+0x58>
     fb4:	39 d1                	cmp    %edx,%ecx
     fb6:	72 ce                	jb     f86 <free+0x26>
{
     fb8:	89 d0                	mov    %edx,%eax
     fba:	eb bc                	jmp    f78 <free+0x18>
     fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
     fc0:	03 72 04             	add    0x4(%edx),%esi
     fc3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     fc6:	8b 10                	mov    (%eax),%edx
     fc8:	8b 12                	mov    (%edx),%edx
     fca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     fcd:	8b 50 04             	mov    0x4(%eax),%edx
     fd0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     fd3:	39 f1                	cmp    %esi,%ecx
     fd5:	75 c6                	jne    f9d <free+0x3d>
    p->s.size += bp->s.size;
     fd7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
     fda:	a3 04 18 00 00       	mov    %eax,0x1804
    p->s.size += bp->s.size;
     fdf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     fe2:	8b 53 f8             	mov    -0x8(%ebx),%edx
     fe5:	89 10                	mov    %edx,(%eax)
}
     fe7:	5b                   	pop    %ebx
     fe8:	5e                   	pop    %esi
     fe9:	5f                   	pop    %edi
     fea:	5d                   	pop    %ebp
     feb:	c3                   	ret    
     fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000ff0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     ff0:	55                   	push   %ebp
     ff1:	89 e5                	mov    %esp,%ebp
     ff3:	57                   	push   %edi
     ff4:	56                   	push   %esi
     ff5:	53                   	push   %ebx
     ff6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
     ffc:	8b 15 04 18 00 00    	mov    0x1804,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1002:	8d 78 07             	lea    0x7(%eax),%edi
    1005:	c1 ef 03             	shr    $0x3,%edi
    1008:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    100b:	85 d2                	test   %edx,%edx
    100d:	0f 84 9d 00 00 00    	je     10b0 <malloc+0xc0>
    1013:	8b 02                	mov    (%edx),%eax
    1015:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1018:	39 cf                	cmp    %ecx,%edi
    101a:	76 6c                	jbe    1088 <malloc+0x98>
    101c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    1022:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1027:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    102a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    1031:	eb 0e                	jmp    1041 <malloc+0x51>
    1033:	90                   	nop
    1034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1038:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    103a:	8b 48 04             	mov    0x4(%eax),%ecx
    103d:	39 f9                	cmp    %edi,%ecx
    103f:	73 47                	jae    1088 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1041:	39 05 04 18 00 00    	cmp    %eax,0x1804
    1047:	89 c2                	mov    %eax,%edx
    1049:	75 ed                	jne    1038 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    104b:	83 ec 0c             	sub    $0xc,%esp
    104e:	56                   	push   %esi
    104f:	e8 66 fc ff ff       	call   cba <sbrk>
  if(p == (char*)-1)
    1054:	83 c4 10             	add    $0x10,%esp
    1057:	83 f8 ff             	cmp    $0xffffffff,%eax
    105a:	74 1c                	je     1078 <malloc+0x88>
  hp->s.size = nu;
    105c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    105f:	83 ec 0c             	sub    $0xc,%esp
    1062:	83 c0 08             	add    $0x8,%eax
    1065:	50                   	push   %eax
    1066:	e8 f5 fe ff ff       	call   f60 <free>
  return freep;
    106b:	8b 15 04 18 00 00    	mov    0x1804,%edx
      if((p = morecore(nunits)) == 0)
    1071:	83 c4 10             	add    $0x10,%esp
    1074:	85 d2                	test   %edx,%edx
    1076:	75 c0                	jne    1038 <malloc+0x48>
        return 0;
  }
}
    1078:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    107b:	31 c0                	xor    %eax,%eax
}
    107d:	5b                   	pop    %ebx
    107e:	5e                   	pop    %esi
    107f:	5f                   	pop    %edi
    1080:	5d                   	pop    %ebp
    1081:	c3                   	ret    
    1082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1088:	39 cf                	cmp    %ecx,%edi
    108a:	74 54                	je     10e0 <malloc+0xf0>
        p->s.size -= nunits;
    108c:	29 f9                	sub    %edi,%ecx
    108e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1091:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1094:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    1097:	89 15 04 18 00 00    	mov    %edx,0x1804
}
    109d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    10a0:	83 c0 08             	add    $0x8,%eax
}
    10a3:	5b                   	pop    %ebx
    10a4:	5e                   	pop    %esi
    10a5:	5f                   	pop    %edi
    10a6:	5d                   	pop    %ebp
    10a7:	c3                   	ret    
    10a8:	90                   	nop
    10a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    10b0:	c7 05 04 18 00 00 08 	movl   $0x1808,0x1804
    10b7:	18 00 00 
    10ba:	c7 05 08 18 00 00 08 	movl   $0x1808,0x1808
    10c1:	18 00 00 
    base.s.size = 0;
    10c4:	b8 08 18 00 00       	mov    $0x1808,%eax
    10c9:	c7 05 0c 18 00 00 00 	movl   $0x0,0x180c
    10d0:	00 00 00 
    10d3:	e9 44 ff ff ff       	jmp    101c <malloc+0x2c>
    10d8:	90                   	nop
    10d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    10e0:	8b 08                	mov    (%eax),%ecx
    10e2:	89 0a                	mov    %ecx,(%edx)
    10e4:	eb b1                	jmp    1097 <malloc+0xa7>
