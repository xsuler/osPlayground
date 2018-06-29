
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 30 c6 10 80       	mov    $0x8010c630,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 34 10 80       	mov    $0x801034e0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 74 c6 10 80       	mov    $0x8010c674,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 7b 10 80       	push   $0x80107b80
80100051:	68 40 c6 10 80       	push   $0x8010c640
80100056:	e8 e5 4a 00 00       	call   80104b40 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	ba 3c 0d 11 80       	mov    $0x80110d3c,%edx
  bcache.head.prev = &bcache.head;
80100063:	c7 05 8c 0d 11 80 3c 	movl   $0x80110d3c,0x80110d8c
8010006a:	0d 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 90 0d 11 80 3c 	movl   $0x80110d3c,0x80110d90
80100074:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	83 ec 08             	sub    $0x8,%esp
80100085:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 7b 10 80       	push   $0x80107b87
80100097:	50                   	push   %eax
80100098:	e8 93 49 00 00       	call   80104a30 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 90 0d 11 80       	mov    0x80110d90,%eax
801000a2:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a4:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 90 0d 11 80    	mov    %ebx,0x80110d90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 3c 0d 11 80       	cmp    $0x80110d3c,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000df:	68 40 c6 10 80       	push   $0x8010c640
801000e4:	e8 57 4b 00 00       	call   80104c40 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 90 0d 11 80    	mov    0x80110d90,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 8c 0d 11 80    	mov    0x80110d8c,%ebx
80100126:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 40 c6 10 80       	push   $0x8010c640
80100162:	e8 f9 4b 00 00       	call   80104d60 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 48 00 00       	call   80104a70 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 9f 25 00 00       	call   80102730 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 8e 7b 10 80       	push   $0x80107b8e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 4d 49 00 00       	call   80104b10 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 57 25 00 00       	jmp    80102730 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 9f 7b 10 80       	push   $0x80107b9f
801001e1:	e8 aa 01 00 00       	call   80100390 <panic>
801001e6:	8d 76 00             	lea    0x0(%esi),%esi
801001e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 49 00 00       	call   80104b10 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 bc 48 00 00       	call   80104ad0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010021b:	e8 20 4a 00 00       	call   80104c40 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 90 0d 11 80       	mov    0x80110d90,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 90 0d 11 80       	mov    0x80110d90,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 90 0d 11 80    	mov    %ebx,0x80110d90
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 40 c6 10 80 	movl   $0x8010c640,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 ef 4a 00 00       	jmp    80104d60 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 a6 7b 10 80       	push   $0x80107ba6
80100279:	e8 12 01 00 00       	call   80100390 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100289:	ff 75 08             	pushl  0x8(%ebp)
{
8010028c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010028f:	e8 9c 1a 00 00       	call   80101d30 <iunlock>
  target = n;
  acquire(&cons.lock);
80100294:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010029b:	e8 a0 49 00 00       	call   80104c40 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	31 c0                	xor    %eax,%eax
    *dst++ = c;
801002a8:	01 f7                	add    %esi,%edi
  while(n > 0){
801002aa:	85 f6                	test   %esi,%esi
801002ac:	0f 8e a0 00 00 00    	jle    80100352 <consoleread+0xd2>
801002b2:	89 f3                	mov    %esi,%ebx
    while(input.r == input.w){
801002b4:	8b 15 60 10 11 80    	mov    0x80111060,%edx
801002ba:	39 15 64 10 11 80    	cmp    %edx,0x80111064
801002c0:	74 29                	je     801002eb <consoleread+0x6b>
801002c2:	eb 5c                	jmp    80100320 <consoleread+0xa0>
801002c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 40 b5 10 80       	push   $0x8010b540
801002d0:	68 60 10 11 80       	push   $0x80111060
801002d5:	e8 26 44 00 00       	call   80104700 <sleep>
    while(input.r == input.w){
801002da:	8b 15 60 10 11 80    	mov    0x80111060,%edx
801002e0:	83 c4 10             	add    $0x10,%esp
801002e3:	3b 15 64 10 11 80    	cmp    0x80111064,%edx
801002e9:	75 35                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002eb:	e8 90 3b 00 00       	call   80103e80 <myproc>
801002f0:	8b 48 24             	mov    0x24(%eax),%ecx
801002f3:	85 c9                	test   %ecx,%ecx
801002f5:	74 d1                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f7:	83 ec 0c             	sub    $0xc,%esp
801002fa:	68 40 b5 10 80       	push   $0x8010b540
801002ff:	e8 5c 4a 00 00       	call   80104d60 <release>
        ilock(ip);
80100304:	5a                   	pop    %edx
80100305:	ff 75 08             	pushl  0x8(%ebp)
80100308:	e8 43 19 00 00       	call   80101c50 <ilock>
        return -1;
8010030d:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100310:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100318:	5b                   	pop    %ebx
80100319:	5e                   	pop    %esi
8010031a:	5f                   	pop    %edi
8010031b:	5d                   	pop    %ebp
8010031c:	c3                   	ret    
8010031d:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 42 01             	lea    0x1(%edx),%eax
80100323:	a3 60 10 11 80       	mov    %eax,0x80111060
80100328:	89 d0                	mov    %edx,%eax
8010032a:	83 e0 7f             	and    $0x7f,%eax
8010032d:	0f be 80 e0 0f 11 80 	movsbl -0x7feef020(%eax),%eax
    if(c == C('D')){  // EOF
80100334:	83 f8 04             	cmp    $0x4,%eax
80100337:	74 46                	je     8010037f <consoleread+0xff>
    *dst++ = c;
80100339:	89 da                	mov    %ebx,%edx
    --n;
8010033b:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010033e:	f7 da                	neg    %edx
80100340:	88 04 17             	mov    %al,(%edi,%edx,1)
    if(c == '\n')
80100343:	83 f8 0a             	cmp    $0xa,%eax
80100346:	74 31                	je     80100379 <consoleread+0xf9>
  while(n > 0){
80100348:	85 db                	test   %ebx,%ebx
8010034a:	0f 85 64 ff ff ff    	jne    801002b4 <consoleread+0x34>
80100350:	89 f0                	mov    %esi,%eax
  release(&cons.lock);
80100352:	83 ec 0c             	sub    $0xc,%esp
80100355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100358:	68 40 b5 10 80       	push   $0x8010b540
8010035d:	e8 fe 49 00 00       	call   80104d60 <release>
  ilock(ip);
80100362:	58                   	pop    %eax
80100363:	ff 75 08             	pushl  0x8(%ebp)
80100366:	e8 e5 18 00 00       	call   80101c50 <ilock>
  return target - n;
8010036b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010036e:	83 c4 10             	add    $0x10,%esp
}
80100371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100374:	5b                   	pop    %ebx
80100375:	5e                   	pop    %esi
80100376:	5f                   	pop    %edi
80100377:	5d                   	pop    %ebp
80100378:	c3                   	ret    
80100379:	89 f0                	mov    %esi,%eax
8010037b:	29 d8                	sub    %ebx,%eax
8010037d:	eb d3                	jmp    80100352 <consoleread+0xd2>
      if(n < target){
8010037f:	89 f0                	mov    %esi,%eax
80100381:	29 d8                	sub    %ebx,%eax
80100383:	39 f3                	cmp    %esi,%ebx
80100385:	73 cb                	jae    80100352 <consoleread+0xd2>
        input.r--;
80100387:	89 15 60 10 11 80    	mov    %edx,0x80111060
8010038d:	eb c3                	jmp    80100352 <consoleread+0xd2>
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 74 b5 10 80 00 	movl   $0x0,0x8010b574
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 b2 29 00 00       	call   80102d60 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 7b 10 80       	push   $0x80107bad
801003b7:	e8 e4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 db 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 39 85 10 80 	movl   $0x80108539,(%esp)
801003cc:	e8 cf 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	8d 45 08             	lea    0x8(%ebp),%eax
801003d4:	5a                   	pop    %edx
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 83 47 00 00       	call   80104b60 <getcallerpcs>
  for(i=0; i<10; i++)
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 7b 10 80       	push   $0x80107bc1
801003ed:	e8 ae 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 78 b5 10 80 01 	movl   $0x1,0x8010b578
80100400:	00 00 00 
    ;
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
80100416:	85 d2                	test   %edx,%edx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
      ;
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	89 c6                	mov    %eax,%esi
80100427:	53                   	push   %ebx
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(mycpu()->consflag)
8010042b:	e8 b0 39 00 00       	call   80103de0 <mycpu>
80100430:	80 b8 b4 00 00 00 00 	cmpb   $0x0,0xb4(%eax)
80100437:	0f 85 db 00 00 00    	jne    80100518 <consputc+0x108>
  if(c == BACKSPACE){
8010043d:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100443:	74 0e                	je     80100453 <consputc+0x43>
    uartputc(c);
80100445:	83 ec 0c             	sub    $0xc,%esp
80100448:	56                   	push   %esi
80100449:	e8 52 62 00 00       	call   801066a0 <uartputc>
8010044e:	83 c4 10             	add    $0x10,%esp
80100451:	eb 25                	jmp    80100478 <consputc+0x68>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100453:	83 ec 0c             	sub    $0xc,%esp
80100456:	6a 08                	push   $0x8
80100458:	e8 43 62 00 00       	call   801066a0 <uartputc>
8010045d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100464:	e8 37 62 00 00       	call   801066a0 <uartputc>
80100469:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100470:	e8 2b 62 00 00       	call   801066a0 <uartputc>
80100475:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100478:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010047d:	b8 0e 00 00 00       	mov    $0xe,%eax
80100482:	89 da                	mov    %ebx,%edx
80100484:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100485:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010048a:	89 ca                	mov    %ecx,%edx
8010048c:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010048d:	0f b6 f8             	movzbl %al,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100490:	89 da                	mov    %ebx,%edx
80100492:	b8 0f 00 00 00       	mov    $0xf,%eax
80100497:	c1 e7 08             	shl    $0x8,%edi
8010049a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010049b:	89 ca                	mov    %ecx,%edx
8010049d:	ec                   	in     (%dx),%al
8010049e:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
801004a1:	09 fb                	or     %edi,%ebx
  if(c == '\n')
801004a3:	83 fe 0a             	cmp    $0xa,%esi
801004a6:	0f 84 b8 00 00 00    	je     80100564 <consputc+0x154>
  else if(c == BACKSPACE){
801004ac:	81 fe 00 01 00 00    	cmp    $0x100,%esi
801004b2:	0f 84 c8 00 00 00    	je     80100580 <consputc+0x170>
    crt[pos] = (c&0xff) | 0x0b00;  // black on white
801004b8:	89 f0                	mov    %esi,%eax
801004ba:	0f b6 c0             	movzbl %al,%eax
801004bd:	80 cc 0b             	or     $0xb,%ah
801004c0:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004c7:	80 
    pos++;
801004c8:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 24*80)
801004cb:	81 fb 80 07 00 00    	cmp    $0x780,%ebx
801004d1:	0f 87 b5 00 00 00    	ja     8010058c <consputc+0x17c>
  if((pos/80) >= 23){  // Scroll up.
801004d7:	81 fb 2f 07 00 00    	cmp    $0x72f,%ebx
801004dd:	77 41                	ja     80100520 <consputc+0x110>
801004df:	0f b6 f7             	movzbl %bh,%esi
801004e2:	89 d9                	mov    %ebx,%ecx
801004e4:	8d 9c 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004eb:	bf d4 03 00 00       	mov    $0x3d4,%edi
801004f0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004f5:	89 fa                	mov    %edi,%edx
801004f7:	ee                   	out    %al,(%dx)
801004f8:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004fd:	89 f0                	mov    %esi,%eax
801004ff:	ee                   	out    %al,(%dx)
80100500:	b8 0f 00 00 00       	mov    $0xf,%eax
80100505:	89 fa                	mov    %edi,%edx
80100507:	ee                   	out    %al,(%dx)
80100508:	ba d5 03 00 00       	mov    $0x3d5,%edx
8010050d:	89 c8                	mov    %ecx,%eax
8010050f:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100510:	b8 20 07 00 00       	mov    $0x720,%eax
80100515:	66 89 03             	mov    %ax,(%ebx)
}
80100518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010051b:	5b                   	pop    %ebx
8010051c:	5e                   	pop    %esi
8010051d:	5f                   	pop    %edi
8010051e:	5d                   	pop    %ebp
8010051f:	c3                   	ret    
    memmove(crt, crt+80, sizeof(crt[0])*22*80);
80100520:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100523:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memmove(crt, crt+80, sizeof(crt[0])*22*80);
80100526:	68 c0 0d 00 00       	push   $0xdc0
    memset(crt+pos, 0, sizeof(crt[0])*(23*80 - pos));
8010052b:	8d 9c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*22*80);
80100532:	68 a0 80 0b 80       	push   $0x800b80a0
80100537:	68 00 80 0b 80       	push   $0x800b8000
8010053c:	e8 0f 49 00 00       	call   80104e50 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(23*80 - pos));
80100541:	89 f8                	mov    %edi,%eax
80100543:	83 c4 0c             	add    $0xc,%esp
80100546:	f7 d8                	neg    %eax
80100548:	8d 84 00 60 0e 00 00 	lea    0xe60(%eax,%eax,1),%eax
8010054f:	50                   	push   %eax
80100550:	6a 00                	push   $0x0
80100552:	53                   	push   %ebx
80100553:	e8 58 48 00 00       	call   80104db0 <memset>
80100558:	89 f8                	mov    %edi,%eax
8010055a:	89 f9                	mov    %edi,%ecx
8010055c:	83 c4 10             	add    $0x10,%esp
8010055f:	0f b6 f4             	movzbl %ah,%esi
80100562:	eb 87                	jmp    801004eb <consputc+0xdb>
    pos += 80 - pos%80;
80100564:	89 d8                	mov    %ebx,%eax
80100566:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010056b:	f7 e2                	mul    %edx
8010056d:	89 d0                	mov    %edx,%eax
8010056f:	c1 e8 06             	shr    $0x6,%eax
80100572:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
80100575:	c1 e3 04             	shl    $0x4,%ebx
80100578:	83 c3 50             	add    $0x50,%ebx
8010057b:	e9 4b ff ff ff       	jmp    801004cb <consputc+0xbb>
    if(pos > 0)
80100580:	85 db                	test   %ebx,%ebx
80100582:	74 1c                	je     801005a0 <consputc+0x190>
      --pos;
80100584:	83 eb 01             	sub    $0x1,%ebx
80100587:	e9 3f ff ff ff       	jmp    801004cb <consputc+0xbb>
    panic("pos under/overflow");
8010058c:	83 ec 0c             	sub    $0xc,%esp
8010058f:	68 c5 7b 10 80       	push   $0x80107bc5
80100594:	e8 f7 fd ff ff       	call   80100390 <panic>
80100599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0)
801005a0:	bb 00 80 0b 80       	mov    $0x800b8000,%ebx
801005a5:	31 c9                	xor    %ecx,%ecx
801005a7:	31 f6                	xor    %esi,%esi
801005a9:	e9 3d ff ff ff       	jmp    801004eb <consputc+0xdb>
801005ae:	66 90                	xchg   %ax,%ax

801005b0 <printint>:
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	89 d3                	mov    %edx,%ebx
801005b8:	83 ec 2c             	sub    $0x2c,%esp
801005bb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005be:	85 c9                	test   %ecx,%ecx
801005c0:	74 04                	je     801005c6 <printint+0x16>
801005c2:	85 c0                	test   %eax,%eax
801005c4:	78 6a                	js     80100630 <printint+0x80>
    x = xx;
801005c6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
801005cd:	89 c1                	mov    %eax,%ecx
  i = 0;
801005cf:	31 f6                	xor    %esi,%esi
801005d1:	eb 09                	jmp    801005dc <printint+0x2c>
801005d3:	90                   	nop
801005d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }while((x /= base) != 0);
801005d8:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
801005da:	89 fe                	mov    %edi,%esi
801005dc:	89 c8                	mov    %ecx,%eax
801005de:	31 d2                	xor    %edx,%edx
801005e0:	8d 7e 01             	lea    0x1(%esi),%edi
801005e3:	f7 f3                	div    %ebx
801005e5:	0f b6 92 18 7c 10 80 	movzbl -0x7fef83e8(%edx),%edx
801005ec:	88 54 3d d7          	mov    %dl,-0x29(%ebp,%edi,1)
  }while((x /= base) != 0);
801005f0:	39 d9                	cmp    %ebx,%ecx
801005f2:	73 e4                	jae    801005d8 <printint+0x28>
  if(sign)
801005f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005f7:	85 c0                	test   %eax,%eax
801005f9:	74 0c                	je     80100607 <printint+0x57>
    buf[i++] = '-';
801005fb:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
80100600:	89 fe                	mov    %edi,%esi
    buf[i++] = '-';
80100602:	ba 2d 00 00 00       	mov    $0x2d,%edx
80100607:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010060b:	0f be c2             	movsbl %dl,%eax
8010060e:	eb 06                	jmp    80100616 <printint+0x66>
80100610:	0f be 03             	movsbl (%ebx),%eax
80100613:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
80100616:	e8 f5 fd ff ff       	call   80100410 <consputc>
  while(--i >= 0)
8010061b:	8d 45 d7             	lea    -0x29(%ebp),%eax
8010061e:	39 c3                	cmp    %eax,%ebx
80100620:	75 ee                	jne    80100610 <printint+0x60>
}
80100622:	83 c4 2c             	add    $0x2c,%esp
80100625:	5b                   	pop    %ebx
80100626:	5e                   	pop    %esi
80100627:	5f                   	pop    %edi
80100628:	5d                   	pop    %ebp
80100629:	c3                   	ret    
8010062a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = -xx;
80100630:	f7 d8                	neg    %eax
80100632:	89 c1                	mov    %eax,%ecx
80100634:	eb 99                	jmp    801005cf <printint+0x1f>
80100636:	8d 76 00             	lea    0x0(%esi),%esi
80100639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	55                   	push   %ebp
80100641:	89 e5                	mov    %esp,%ebp
80100643:	57                   	push   %edi
80100644:	56                   	push   %esi
80100645:	53                   	push   %ebx
80100646:	83 ec 18             	sub    $0x18,%esp
  int i;


  iunlock(ip);
80100649:	ff 75 08             	pushl  0x8(%ebp)
{
8010064c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010064f:	e8 dc 16 00 00       	call   80101d30 <iunlock>
  acquire(&cons.lock);
80100654:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010065b:	e8 e0 45 00 00       	call   80104c40 <acquire>
  for(i = 0; i < n; i++)
80100660:	83 c4 10             	add    $0x10,%esp
80100663:	85 f6                	test   %esi,%esi
80100665:	7e 18                	jle    8010067f <consolewrite+0x3f>
80100667:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010066d:	8d 76 00             	lea    0x0(%esi),%esi
  {
    consputc(buf[i] & 0xff);
80100670:	0f b6 07             	movzbl (%edi),%eax
80100673:	83 c7 01             	add    $0x1,%edi
80100676:	e8 95 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010067b:	39 fb                	cmp    %edi,%ebx
8010067d:	75 f1                	jne    80100670 <consolewrite+0x30>
  }
  release(&cons.lock);
8010067f:	83 ec 0c             	sub    $0xc,%esp
80100682:	68 40 b5 10 80       	push   $0x8010b540
80100687:	e8 d4 46 00 00       	call   80104d60 <release>
  ilock(ip);
8010068c:	58                   	pop    %eax
8010068d:	ff 75 08             	pushl  0x8(%ebp)
80100690:	e8 bb 15 00 00       	call   80101c50 <ilock>

  return n;
}
80100695:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100698:	89 f0                	mov    %esi,%eax
8010069a:	5b                   	pop    %ebx
8010069b:	5e                   	pop    %esi
8010069c:	5f                   	pop    %edi
8010069d:	5d                   	pop    %ebp
8010069e:	c3                   	ret    
8010069f:	90                   	nop

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 74 b5 10 80       	mov    0x8010b574,%eax
801006ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 67 01 00 00    	jne    80100820 <cprintf+0x180>
  if (fmt == 0)
801006b9:	8b 45 08             	mov    0x8(%ebp),%eax
801006bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006bf:	85 c0                	test   %eax,%eax
801006c1:	0f 84 89 01 00 00    	je     80100850 <cprintf+0x1b0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c7:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006ca:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006cd:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
801006cf:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	85 c0                	test   %eax,%eax
801006d4:	75 58                	jne    8010072e <cprintf+0x8e>
801006d6:	eb 78                	jmp    80100750 <cprintf+0xb0>
801006d8:	90                   	nop
801006d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[++i] & 0xff;
801006e0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006e3:	85 d2                	test   %edx,%edx
801006e5:	74 69                	je     80100750 <cprintf+0xb0>
    switch(c){
801006e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006ea:	83 c3 02             	add    $0x2,%ebx
801006ed:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801006f0:	83 fa 70             	cmp    $0x70,%edx
801006f3:	0f 84 df 00 00 00    	je     801007d8 <cprintf+0x138>
801006f9:	7f 6d                	jg     80100768 <cprintf+0xc8>
801006fb:	83 fa 25             	cmp    $0x25,%edx
801006fe:	0f 84 f4 00 00 00    	je     801007f8 <cprintf+0x158>
80100704:	83 fa 64             	cmp    $0x64,%edx
80100707:	0f 85 a8 00 00 00    	jne    801007b5 <cprintf+0x115>
      printint(*argp++, 10, 1);
8010070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100710:	b9 01 00 00 00       	mov    $0x1,%ecx
80100715:	ba 0a 00 00 00       	mov    $0xa,%edx
8010071a:	8d 78 04             	lea    0x4(%eax),%edi
8010071d:	8b 00                	mov    (%eax),%eax
8010071f:	e8 8c fe ff ff       	call   801005b0 <printint>
80100724:	89 7d e0             	mov    %edi,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100727:	0f b6 06             	movzbl (%esi),%eax
8010072a:	85 c0                	test   %eax,%eax
8010072c:	74 22                	je     80100750 <cprintf+0xb0>
    if(c != '%'){
8010072e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80100731:	8d 7b 01             	lea    0x1(%ebx),%edi
80100734:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80100737:	83 f8 25             	cmp    $0x25,%eax
8010073a:	74 a4                	je     801006e0 <cprintf+0x40>
      consputc(c);
8010073c:	e8 cf fc ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100741:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100744:	89 fb                	mov    %edi,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100746:	85 c0                	test   %eax,%eax
80100748:	75 e4                	jne    8010072e <cprintf+0x8e>
8010074a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100750:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100753:	85 c0                	test   %eax,%eax
80100755:	0f 85 dd 00 00 00    	jne    80100838 <cprintf+0x198>
}
8010075b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010075e:	5b                   	pop    %ebx
8010075f:	5e                   	pop    %esi
80100760:	5f                   	pop    %edi
80100761:	5d                   	pop    %ebp
80100762:	c3                   	ret    
80100763:	90                   	nop
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100768:	83 fa 73             	cmp    $0x73,%edx
8010076b:	75 43                	jne    801007b0 <cprintf+0x110>
      if((s = (char*)*argp++) == 0)
8010076d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100770:	8b 10                	mov    (%eax),%edx
80100772:	8d 48 04             	lea    0x4(%eax),%ecx
80100775:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80100778:	85 d2                	test   %edx,%edx
8010077a:	0f 84 90 00 00 00    	je     80100810 <cprintf+0x170>
      for(; *s; s++)
80100780:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
80100783:	89 d7                	mov    %edx,%edi
80100785:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      for(; *s; s++)
80100788:	84 c0                	test   %al,%al
8010078a:	74 9b                	je     80100727 <cprintf+0x87>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        consputc(*s);
80100790:	e8 7b fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
80100795:	83 c7 01             	add    $0x1,%edi
80100798:	0f be 07             	movsbl (%edi),%eax
8010079b:	84 c0                	test   %al,%al
8010079d:	75 f1                	jne    80100790 <cprintf+0xf0>
      if((s = (char*)*argp++) == 0)
8010079f:	8b 45 dc             	mov    -0x24(%ebp),%eax
801007a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007a5:	e9 7d ff ff ff       	jmp    80100727 <cprintf+0x87>
801007aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007b0:	83 fa 78             	cmp    $0x78,%edx
801007b3:	74 23                	je     801007d8 <cprintf+0x138>
      consputc('%');
801007b5:	b8 25 00 00 00       	mov    $0x25,%eax
801007ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
801007bd:	e8 4e fc ff ff       	call   80100410 <consputc>
      consputc(c);
801007c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801007c5:	89 d0                	mov    %edx,%eax
801007c7:	e8 44 fc ff ff       	call   80100410 <consputc>
      break;
801007cc:	e9 56 ff ff ff       	jmp    80100727 <cprintf+0x87>
801007d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007db:	31 c9                	xor    %ecx,%ecx
801007dd:	ba 10 00 00 00       	mov    $0x10,%edx
801007e2:	8d 78 04             	lea    0x4(%eax),%edi
801007e5:	8b 00                	mov    (%eax),%eax
801007e7:	e8 c4 fd ff ff       	call   801005b0 <printint>
801007ec:	89 7d e0             	mov    %edi,-0x20(%ebp)
      break;
801007ef:	e9 33 ff ff ff       	jmp    80100727 <cprintf+0x87>
801007f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
801007f8:	b8 25 00 00 00       	mov    $0x25,%eax
801007fd:	e8 0e fc ff ff       	call   80100410 <consputc>
      break;
80100802:	e9 20 ff ff ff       	jmp    80100727 <cprintf+0x87>
80100807:	89 f6                	mov    %esi,%esi
80100809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        s = "(null)";
80100810:	bf d8 7b 10 80       	mov    $0x80107bd8,%edi
      for(; *s; s++)
80100815:	b8 28 00 00 00       	mov    $0x28,%eax
8010081a:	e9 71 ff ff ff       	jmp    80100790 <cprintf+0xf0>
8010081f:	90                   	nop
    acquire(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 40 b5 10 80       	push   $0x8010b540
80100828:	e8 13 44 00 00       	call   80104c40 <acquire>
8010082d:	83 c4 10             	add    $0x10,%esp
80100830:	e9 84 fe ff ff       	jmp    801006b9 <cprintf+0x19>
80100835:	8d 76 00             	lea    0x0(%esi),%esi
    release(&cons.lock);
80100838:	83 ec 0c             	sub    $0xc,%esp
8010083b:	68 40 b5 10 80       	push   $0x8010b540
80100840:	e8 1b 45 00 00       	call   80104d60 <release>
80100845:	83 c4 10             	add    $0x10,%esp
}
80100848:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010084b:	5b                   	pop    %ebx
8010084c:	5e                   	pop    %esi
8010084d:	5f                   	pop    %edi
8010084e:	5d                   	pop    %ebp
8010084f:	c3                   	ret    
    panic("null fmt");
80100850:	83 ec 0c             	sub    $0xc,%esp
80100853:	68 df 7b 10 80       	push   $0x80107bdf
80100858:	e8 33 fb ff ff       	call   80100390 <panic>
8010085d:	8d 76 00             	lea    0x0(%esi),%esi

80100860 <show>:
{
80100860:	55                   	push   %ebp
80100861:	89 e5                	mov    %esp,%ebp
80100863:	57                   	push   %edi
80100864:	8b 4d 10             	mov    0x10(%ebp),%ecx
80100867:	8b 7d 08             	mov    0x8(%ebp),%edi
8010086a:	56                   	push   %esi
8010086b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010086e:	53                   	push   %ebx
8010086f:	0f b7 5d 14          	movzwl 0x14(%ebp),%ebx
  for(i=0;i<n;i++)
80100873:	85 c9                	test   %ecx,%ecx
80100875:	7e 1b                	jle    80100892 <show+0x32>
80100877:	31 c0                	xor    %eax,%eax
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    crt[i]= str[i] | cl;
80100880:	66 0f be 14 06       	movsbw (%esi,%eax,1),%dx
80100885:	09 da                	or     %ebx,%edx
80100887:	66 89 14 47          	mov    %dx,(%edi,%eax,2)
  for(i=0;i<n;i++)
8010088b:	83 c0 01             	add    $0x1,%eax
8010088e:	39 c1                	cmp    %eax,%ecx
80100890:	75 ee                	jne    80100880 <show+0x20>
}
80100892:	5b                   	pop    %ebx
80100893:	5e                   	pop    %esi
80100894:	5f                   	pop    %edi
80100895:	5d                   	pop    %ebp
80100896:	c3                   	ret    
80100897:	89 f6                	mov    %esi,%esi
80100899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801008a0 <tostring>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
801008a4:	56                   	push   %esi
801008a5:	53                   	push   %ebx
801008a6:	83 ec 04             	sub    $0x4,%esp
801008a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(t>0)
801008ac:	85 db                	test   %ebx,%ebx
801008ae:	7e 70                	jle    80100920 <tostring+0x80>
801008b0:	89 de                	mov    %ebx,%esi
  int s=0,t=n,res;
801008b2:	31 c9                	xor    %ecx,%ecx
801008b4:	eb 0e                	jmp    801008c4 <tostring+0x24>
801008b6:	8d 76 00             	lea    0x0(%esi),%esi
801008b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    t/=10;
801008c0:	89 d6                	mov    %edx,%esi
    s++;
801008c2:	89 f9                	mov    %edi,%ecx
    t/=10;
801008c4:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
    s++;
801008c9:	8d 79 01             	lea    0x1(%ecx),%edi
    t/=10;
801008cc:	f7 e6                	mul    %esi
801008ce:	c1 ea 03             	shr    $0x3,%edx
  while(t>0)
801008d1:	83 fe 09             	cmp    $0x9,%esi
801008d4:	7f ea                	jg     801008c0 <tostring+0x20>
  str[s]=0;
801008d6:	8b 45 08             	mov    0x8(%ebp),%eax
    str[--s]=n%10+'0';
801008d9:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801008de:	89 7d f0             	mov    %edi,-0x10(%ebp)
  str[s]=0;
801008e1:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
  while(n>0)
801008e5:	01 c1                	add    %eax,%ecx
801008e7:	eb 09                	jmp    801008f2 <tostring+0x52>
801008e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
801008f0:	89 d3                	mov    %edx,%ebx
    str[--s]=n%10+'0';
801008f2:	89 d8                	mov    %ebx,%eax
801008f4:	89 df                	mov    %ebx,%edi
801008f6:	83 e9 01             	sub    $0x1,%ecx
801008f9:	f7 e6                	mul    %esi
801008fb:	c1 ea 03             	shr    $0x3,%edx
801008fe:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100901:	01 c0                	add    %eax,%eax
80100903:	29 c7                	sub    %eax,%edi
80100905:	89 f8                	mov    %edi,%eax
80100907:	83 c0 30             	add    $0x30,%eax
8010090a:	88 41 01             	mov    %al,0x1(%ecx)
  while(n>0)
8010090d:	83 fb 09             	cmp    $0x9,%ebx
80100910:	7f de                	jg     801008f0 <tostring+0x50>
80100912:	8b 7d f0             	mov    -0x10(%ebp),%edi
}
80100915:	83 c4 04             	add    $0x4,%esp
80100918:	5b                   	pop    %ebx
80100919:	5e                   	pop    %esi
8010091a:	89 f8                	mov    %edi,%eax
8010091c:	5f                   	pop    %edi
8010091d:	5d                   	pop    %ebp
8010091e:	c3                   	ret    
8010091f:	90                   	nop
  str[s]=0;
80100920:	8b 45 08             	mov    0x8(%ebp),%eax
  int s=0,t=n,res;
80100923:	31 ff                	xor    %edi,%edi
  str[s]=0;
80100925:	c6 00 00             	movb   $0x0,(%eax)
}
80100928:	83 c4 04             	add    $0x4,%esp
8010092b:	89 f8                	mov    %edi,%eax
8010092d:	5b                   	pop    %ebx
8010092e:	5e                   	pop    %esi
8010092f:	5f                   	pop    %edi
80100930:	5d                   	pop    %ebp
80100931:	c3                   	ret    
80100932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100940 <title>:
{
80100940:	55                   	push   %ebp
80100941:	b8 60 8e 0b 80       	mov    $0x800b8e60,%eax
80100946:	89 e5                	mov    %esp,%ebp
80100948:	57                   	push   %edi
80100949:	56                   	push   %esi
8010094a:	53                   	push   %ebx
8010094b:	83 ec 3c             	sub    $0x3c,%esp
8010094e:	66 90                	xchg   %ax,%ax
   crt[pos] = '-' | 0x0f00;
80100950:	bb 2d 0f 00 00       	mov    $0xf2d,%ebx
80100955:	83 c0 02             	add    $0x2,%eax
80100958:	66 89 58 fe          	mov    %bx,-0x2(%eax)
  for(;pos<24*80;pos++)
8010095c:	3d 00 8f 0b 80       	cmp    $0x800b8f00,%eax
80100961:	75 ed                	jne    80100950 <title+0x10>
  asm volatile("cli");
80100963:	fa                   	cli    
  struct proc* cur=myproc();
80100964:	e8 17 35 00 00       	call   80103e80 <myproc>
80100969:	bb e9 7b 10 80       	mov    $0x80107be9,%ebx
8010096e:	89 c6                	mov    %eax,%esi
  struct cpu* cpu=mycpu();
80100970:	e8 6b 34 00 00       	call   80103de0 <mycpu>
80100975:	b9 06 8f 0b 80       	mov    $0x800b8f06,%ecx
8010097a:	ba 77 00 00 00       	mov    $0x77,%edx
8010097f:	eb 0e                	jmp    8010098f <title+0x4f>
80100981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100988:	66 0f be 13          	movsbw (%ebx),%dx
8010098c:	83 c3 01             	add    $0x1,%ebx
    crt[i]= str[i] | cl;
8010098f:	80 ce 0f             	or     $0xf,%dh
80100992:	83 c1 02             	add    $0x2,%ecx
80100995:	66 89 51 fe          	mov    %dx,-0x2(%ecx)
  for(i=0;i<n;i++)
80100999:	81 f9 16 8f 0b 80    	cmp    $0x800b8f16,%ecx
8010099f:	75 e7                	jne    80100988 <title+0x48>
  crt[24*80+11]= (curidx+'0') | 0x0b00;
801009a1:	0f b7 3d 20 b5 10 80 	movzwl 0x8010b520,%edi
801009a8:	bb f2 7b 10 80       	mov    $0x80107bf2,%ebx
801009ad:	b9 1c 8f 0b 80       	mov    $0x800b8f1c,%ecx
801009b2:	8d 57 30             	lea    0x30(%edi),%edx
801009b5:	80 ce 0b             	or     $0xb,%dh
801009b8:	66 89 15 16 8f 0b 80 	mov    %dx,0x800b8f16
801009bf:	ba 70 00 00 00       	mov    $0x70,%edx
801009c4:	eb 11                	jmp    801009d7 <title+0x97>
801009c6:	8d 76 00             	lea    0x0(%esi),%esi
801009c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801009d0:	66 0f be 13          	movsbw (%ebx),%dx
801009d4:	83 c3 01             	add    $0x1,%ebx
    crt[i]= str[i] | cl;
801009d7:	80 ce 0f             	or     $0xf,%dh
801009da:	83 c1 02             	add    $0x2,%ecx
801009dd:	66 89 51 fe          	mov    %dx,-0x2(%ecx)
  for(i=0;i<n;i++)
801009e1:	81 f9 3a 8f 0b 80    	cmp    $0x800b8f3a,%ecx
801009e7:	75 e7                	jne    801009d0 <title+0x90>
  crt[24*80+29]= (cur->priority+'0') | 0x0b00;
801009e9:	0f b7 be 80 00 00 00 	movzwl 0x80(%esi),%edi
    crt[i]= str[i] | cl;
801009f0:	b9 63 0f 00 00       	mov    $0xf63,%ecx
801009f5:	bb 70 0f 00 00       	mov    $0xf70,%ebx
801009fa:	66 89 0d 40 8f 0b 80 	mov    %cx,0x800b8f40
80100a01:	b9 20 0f 00 00       	mov    $0xf20,%ecx
  crt[24*80+29]= (cur->priority+'0') | 0x0b00;
80100a06:	8d 57 30             	lea    0x30(%edi),%edx
    crt[i]= str[i] | cl;
80100a09:	bf 75 0f 00 00       	mov    $0xf75,%edi
80100a0e:	66 89 1d 42 8f 0b 80 	mov    %bx,0x800b8f42
  crt[24*80+29]= (cur->priority+'0') | 0x0b00;
80100a15:	80 ce 0b             	or     $0xb,%dh
    crt[i]= str[i] | cl;
80100a18:	66 89 3d 44 8f 0b 80 	mov    %di,0x800b8f44
  crt[24*80+29]= (cur->priority+'0') | 0x0b00;
80100a1f:	66 89 15 3a 8f 0b 80 	mov    %dx,0x800b8f3a
    crt[i]= str[i] | cl;
80100a26:	ba 3a 0f 00 00       	mov    $0xf3a,%edx
80100a2b:	66 89 15 46 8f 0b 80 	mov    %dx,0x800b8f46
80100a32:	66 89 0d 48 8f 0b 80 	mov    %cx,0x800b8f48
  crt[24*80+37]=(cpu->apicid+'0')| 0x0b00;
80100a39:	0f b6 00             	movzbl (%eax),%eax
80100a3c:	83 c0 30             	add    $0x30,%eax
80100a3f:	80 cc 0b             	or     $0xb,%ah
80100a42:	66 a3 4a 8f 0b 80    	mov    %ax,0x800b8f4a
  int n=tostring(buf, cur->sz);
80100a48:	8b 0e                	mov    (%esi),%ecx
  while(t>0)
80100a4a:	85 c9                	test   %ecx,%ecx
80100a4c:	0f 8e dd 00 00 00    	jle    80100b2f <title+0x1ef>
80100a52:	89 cb                	mov    %ecx,%ebx
  int s=0,t=n,res;
80100a54:	31 f6                	xor    %esi,%esi
80100a56:	eb 0c                	jmp    80100a64 <title+0x124>
80100a58:	90                   	nop
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    s++;
80100a60:	89 fe                	mov    %edi,%esi
    t/=10;
80100a62:	89 d3                	mov    %edx,%ebx
80100a64:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
    s++;
80100a69:	8d 7e 01             	lea    0x1(%esi),%edi
    t/=10;
80100a6c:	f7 e3                	mul    %ebx
80100a6e:	c1 ea 03             	shr    $0x3,%edx
  while(t>0)
80100a71:	83 fb 09             	cmp    $0x9,%ebx
80100a74:	7f ea                	jg     80100a60 <title+0x120>
  str[s]=0;
80100a76:	c6 44 3d d4 00       	movb   $0x0,-0x2c(%ebp,%edi,1)
  while(n>0)
80100a7b:	8d 5c 35 d4          	lea    -0x2c(%ebp,%esi,1),%ebx
80100a7f:	89 75 c4             	mov    %esi,-0x3c(%ebp)
80100a82:	eb 06                	jmp    80100a8a <title+0x14a>
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
80100a88:	89 d1                	mov    %edx,%ecx
    str[--s]=n%10+'0';
80100a8a:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80100a8f:	89 ce                	mov    %ecx,%esi
80100a91:	83 eb 01             	sub    $0x1,%ebx
80100a94:	f7 e1                	mul    %ecx
80100a96:	c1 ea 03             	shr    $0x3,%edx
80100a99:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100a9c:	01 c0                	add    %eax,%eax
80100a9e:	29 c6                	sub    %eax,%esi
80100aa0:	89 f0                	mov    %esi,%eax
80100aa2:	83 c0 30             	add    $0x30,%eax
80100aa5:	88 43 01             	mov    %al,0x1(%ebx)
  while(n>0)
80100aa8:	83 f9 09             	cmp    $0x9,%ecx
80100aab:	7f db                	jg     80100a88 <title+0x148>
80100aad:	8b 75 c4             	mov    -0x3c(%ebp),%esi
80100ab0:	8d 9c 36 68 0f 00 00 	lea    0xf68(%esi,%esi,1),%ebx
80100ab7:	8d b3 00 80 0b 80    	lea    -0x7ff48000(%ebx),%esi
80100abd:	81 eb fe 7f f4 7f    	sub    $0x7ff47ffe,%ebx
80100ac3:	b9 02 7c 10 80       	mov    $0x80107c02,%ecx
  int s=0,t=n,res;
80100ac8:	b8 50 8f 0b 80       	mov    $0x800b8f50,%eax
80100acd:	ba 75 00 00 00       	mov    $0x75,%edx
80100ad2:	eb 0b                	jmp    80100adf <title+0x19f>
80100ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ad8:	66 0f be 11          	movsbw (%ecx),%dx
80100adc:	83 c1 01             	add    $0x1,%ecx
    crt[i]= str[i] | cl;
80100adf:	80 ce 0f             	or     $0xf,%dh
80100ae2:	83 c0 02             	add    $0x2,%eax
80100ae5:	66 89 50 fe          	mov    %dx,-0x2(%eax)
  for(i=0;i<n;i++)
80100ae9:	3d 66 8f 0b 80       	cmp    $0x800b8f66,%eax
80100aee:	75 e8                	jne    80100ad8 <title+0x198>
80100af0:	8d 55 d4             	lea    -0x2c(%ebp),%edx
80100af3:	8d 8c 3f 66 8f 0b 80 	lea    -0x7ff4709a(%edi,%edi,1),%ecx
80100afa:	85 ff                	test   %edi,%edi
80100afc:	74 19                	je     80100b17 <title+0x1d7>
80100afe:	66 90                	xchg   %ax,%ax
    crt[i]= str[i] | cl;
80100b00:	66 0f be 3a          	movsbw (%edx),%di
80100b04:	83 c0 02             	add    $0x2,%eax
80100b07:	83 c2 01             	add    $0x1,%edx
80100b0a:	66 81 cf 00 0b       	or     $0xb00,%di
80100b0f:	66 89 78 fe          	mov    %di,-0x2(%eax)
  for(i=0;i<n;i++)
80100b13:	39 c8                	cmp    %ecx,%eax
80100b15:	75 e9                	jne    80100b00 <title+0x1c0>
  crt[24*80+51+n]=' '| 0x0b00;
80100b17:	b8 20 0b 00 00       	mov    $0xb20,%eax
  crt[24*80+51+n+1]='B'| 0x0f00;
80100b1c:	ba 42 0f 00 00       	mov    $0xf42,%edx
  crt[24*80+51+n]=' '| 0x0b00;
80100b21:	66 89 06             	mov    %ax,(%esi)
  crt[24*80+51+n+1]='B'| 0x0f00;
80100b24:	66 89 13             	mov    %dx,(%ebx)
}
80100b27:	83 c4 3c             	add    $0x3c,%esp
80100b2a:	5b                   	pop    %ebx
80100b2b:	5e                   	pop    %esi
80100b2c:	5f                   	pop    %edi
80100b2d:	5d                   	pop    %ebp
80100b2e:	c3                   	ret    
  str[s]=0;
80100b2f:	c6 45 d4 00          	movb   $0x0,-0x2c(%ebp)
80100b33:	bb 68 8f 0b 80       	mov    $0x800b8f68,%ebx
80100b38:	be 66 8f 0b 80       	mov    $0x800b8f66,%esi
  int s=0,t=n,res;
80100b3d:	31 ff                	xor    %edi,%edi
80100b3f:	eb 82                	jmp    80100ac3 <title+0x183>
80100b41:	eb 0d                	jmp    80100b50 <crtcpy>
80100b43:	90                   	nop
80100b44:	90                   	nop
80100b45:	90                   	nop
80100b46:	90                   	nop
80100b47:	90                   	nop
80100b48:	90                   	nop
80100b49:	90                   	nop
80100b4a:	90                   	nop
80100b4b:	90                   	nop
80100b4c:	90                   	nop
80100b4d:	90                   	nop
80100b4e:	90                   	nop
80100b4f:	90                   	nop

80100b50 <crtcpy>:
{
80100b50:	55                   	push   %ebp
  for(i=0;i<80*23;i++)
80100b51:	31 c0                	xor    %eax,%eax
{
80100b53:	89 e5                	mov    %esp,%ebp
80100b55:	53                   	push   %ebx
80100b56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    tg[i]=ss[i];
80100b60:	0f b7 14 41          	movzwl (%ecx,%eax,2),%edx
80100b64:	66 89 14 43          	mov    %dx,(%ebx,%eax,2)
  for(i=0;i<80*23;i++)
80100b68:	83 c0 01             	add    $0x1,%eax
80100b6b:	3d 30 07 00 00       	cmp    $0x730,%eax
80100b70:	75 ee                	jne    80100b60 <crtcpy+0x10>
}
80100b72:	5b                   	pop    %ebx
80100b73:	5d                   	pop    %ebp
80100b74:	c3                   	ret    
80100b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100b80 <splitw>:
{
80100b80:	55                   	push   %ebp
80100b81:	89 e5                	mov    %esp,%ebp
80100b83:	57                   	push   %edi
80100b84:	56                   	push   %esi
80100b85:	53                   	push   %ebx
80100b86:	83 ec 1c             	sub    $0x1c,%esp
80100b89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  cgaflag=1;
80100b8c:	c7 05 24 b5 10 80 01 	movl   $0x1,0x8010b524
80100b93:	00 00 00 
  if(n==-1)
80100b96:	83 f9 ff             	cmp    $0xffffffff,%ecx
80100b99:	0f 84 f1 00 00 00    	je     80100c90 <splitw+0x110>
  if(n>=0)
80100b9f:	85 c9                	test   %ecx,%ecx
80100ba1:	0f 88 df 00 00 00    	js     80100c86 <splitw+0x106>
    if(crtflags[n]>0)
80100ba7:	80 b9 c8 0f 11 80 00 	cmpb   $0x0,-0x7feef038(%ecx)
80100bae:	0f 8e d2 00 00 00    	jle    80100c86 <splitw+0x106>
      crtcpy(crtbufs[curidx],phycrt);
80100bb4:	8b 35 20 b5 10 80    	mov    0x8010b520,%esi
80100bba:	b8 00 80 0b 80       	mov    $0x800b8000,%eax
80100bbf:	69 de 60 0e 00 00    	imul   $0xe60,%esi,%ebx
80100bc5:	81 c3 80 10 11 80    	add    $0x80111080,%ebx
  int i;
80100bcb:	90                   	nop
80100bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    tg[i]=ss[i];
80100bd0:	0f b7 10             	movzwl (%eax),%edx
80100bd3:	66 89 94 03 00 80 f4 	mov    %dx,0x7ff48000(%ebx,%eax,1)
80100bda:	7f 
80100bdb:	83 c0 02             	add    $0x2,%eax
  for(i=0;i<80*23;i++)
80100bde:	3d 60 8e 0b 80       	cmp    $0x800b8e60,%eax
80100be3:	75 eb                	jne    80100bd0 <splitw+0x50>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100be5:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100bea:	b8 0e 00 00 00       	mov    $0xe,%eax
80100bef:	89 fa                	mov    %edi,%edx
80100bf1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100bf2:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100bf7:	89 da                	mov    %ebx,%edx
80100bf9:	ec                   	in     (%dx),%al
      pos = inb(CRTPORT+1) << 8;
80100bfa:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100bfd:	89 fa                	mov    %edi,%edx
80100bff:	c1 e0 08             	shl    $0x8,%eax
80100c02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100c05:	b8 0f 00 00 00       	mov    $0xf,%eax
80100c0a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c0b:	89 da                	mov    %ebx,%edx
80100c0d:	ec                   	in     (%dx),%al
      curidx=n;
80100c0e:	89 0d 20 b5 10 80    	mov    %ecx,0x8010b520
      crtcpy(phycrt,crtbufs[curidx]);
80100c14:	69 c9 60 0e 00 00    	imul   $0xe60,%ecx,%ecx
      pos |= inb(CRTPORT+1);
80100c1a:	0f b6 c0             	movzbl %al,%eax
80100c1d:	0b 45 e4             	or     -0x1c(%ebp),%eax
80100c20:	89 04 b5 a0 0f 11 80 	mov    %eax,-0x7feef060(,%esi,4)
      crtcpy(phycrt,crtbufs[curidx]);
80100c27:	b8 00 80 0b 80       	mov    $0x800b8000,%eax
80100c2c:	81 c1 80 10 11 80    	add    $0x80111080,%ecx
80100c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    tg[i]=ss[i];
80100c38:	0f b7 94 01 00 80 f4 	movzwl 0x7ff48000(%ecx,%eax,1),%edx
80100c3f:	7f 
80100c40:	83 c0 02             	add    $0x2,%eax
80100c43:	66 89 50 fe          	mov    %dx,-0x2(%eax)
  for(i=0;i<80*23;i++)
80100c47:	3d 60 8e 0b 80       	cmp    $0x800b8e60,%eax
80100c4c:	75 ea                	jne    80100c38 <splitw+0xb8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c4e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100c53:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c58:	89 f2                	mov    %esi,%edx
80100c5a:	ee                   	out    %al,(%dx)
      outb(CRTPORT+1, poss[curidx]>>8);
80100c5b:	a1 20 b5 10 80       	mov    0x8010b520,%eax
80100c60:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100c65:	89 da                	mov    %ebx,%edx
80100c67:	8b 0c 85 a0 0f 11 80 	mov    -0x7feef060(,%eax,4),%ecx
80100c6e:	89 c8                	mov    %ecx,%eax
80100c70:	c1 e8 08             	shr    $0x8,%eax
80100c73:	ee                   	out    %al,(%dx)
80100c74:	b8 0f 00 00 00       	mov    $0xf,%eax
80100c79:	89 f2                	mov    %esi,%edx
80100c7b:	ee                   	out    %al,(%dx)
80100c7c:	89 c8                	mov    %ecx,%eax
80100c7e:	89 da                	mov    %ebx,%edx
80100c80:	ee                   	out    %al,(%dx)
      title();
80100c81:	e8 ba fc ff ff       	call   80100940 <title>
}
80100c86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c89:	31 c0                	xor    %eax,%eax
80100c8b:	5b                   	pop    %ebx
80100c8c:	5e                   	pop    %esi
80100c8d:	5f                   	pop    %edi
80100c8e:	5d                   	pop    %ebp
80100c8f:	c3                   	ret    
    for(i=0;i<MAXWINDOWS;i++)
80100c90:	31 db                	xor    %ebx,%ebx
      if(crtflags[i]==0)
80100c92:	80 bb c8 0f 11 80 00 	cmpb   $0x0,-0x7feef038(%ebx)
80100c99:	74 16                	je     80100cb1 <splitw+0x131>
80100c9b:	90                   	nop
80100c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(i=0;i<MAXWINDOWS;i++)
80100ca0:	83 c3 01             	add    $0x1,%ebx
80100ca3:	83 fb 0a             	cmp    $0xa,%ebx
80100ca6:	74 de                	je     80100c86 <splitw+0x106>
      if(crtflags[i]==0)
80100ca8:	80 bb c8 0f 11 80 00 	cmpb   $0x0,-0x7feef038(%ebx)
80100caf:	75 ef                	jne    80100ca0 <splitw+0x120>
        myproc()->widx=i;
80100cb1:	e8 ca 31 00 00       	call   80103e80 <myproc>
        crtcpy(crtbufs[curidx],phycrt);
80100cb6:	8b 0d 20 b5 10 80    	mov    0x8010b520,%ecx
        myproc()->widx=i;
80100cbc:	89 98 94 00 00 00    	mov    %ebx,0x94(%eax)
        crtcpy(crtbufs[curidx],phycrt);
80100cc2:	b8 00 80 0b 80       	mov    $0x800b8000,%eax
80100cc7:	69 f1 60 0e 00 00    	imul   $0xe60,%ecx,%esi
80100ccd:	81 c6 80 10 11 80    	add    $0x80111080,%esi
  int i;
80100cd3:	90                   	nop
80100cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    tg[i]=ss[i];
80100cd8:	0f b7 10             	movzwl (%eax),%edx
80100cdb:	66 89 94 06 00 80 f4 	mov    %dx,0x7ff48000(%esi,%eax,1)
80100ce2:	7f 
80100ce3:	83 c0 02             	add    $0x2,%eax
  for(i=0;i<80*23;i++)
80100ce6:	3d 60 8e 0b 80       	cmp    $0x800b8e60,%eax
80100ceb:	75 eb                	jne    80100cd8 <splitw+0x158>
80100ced:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100cf2:	b8 0e 00 00 00       	mov    $0xe,%eax
80100cf7:	89 fa                	mov    %edi,%edx
80100cf9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cfa:	be d5 03 00 00       	mov    $0x3d5,%esi
80100cff:	89 f2                	mov    %esi,%edx
80100d01:	ec                   	in     (%dx),%al
        pos = inb(CRTPORT+1) << 8;
80100d02:	0f b6 c0             	movzbl %al,%eax
80100d05:	89 c2                	mov    %eax,%edx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d07:	b8 0f 00 00 00       	mov    $0xf,%eax
80100d0c:	c1 e2 08             	shl    $0x8,%edx
80100d0f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100d12:	89 fa                	mov    %edi,%edx
80100d14:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100d15:	89 f2                	mov    %esi,%edx
80100d17:	ec                   	in     (%dx),%al
        memset(phycrt, 0, sizeof(phycrt[0])*(23*80));
80100d18:	83 ec 04             	sub    $0x4,%esp
        pos |= inb(CRTPORT+1);
80100d1b:	0f b6 c0             	movzbl %al,%eax
80100d1e:	0b 45 e4             	or     -0x1c(%ebp),%eax
        curidx=i;
80100d21:	89 1d 20 b5 10 80    	mov    %ebx,0x8010b520
        memset(phycrt, 0, sizeof(phycrt[0])*(23*80));
80100d27:	68 60 0e 00 00       	push   $0xe60
80100d2c:	6a 00                	push   $0x0
80100d2e:	68 00 80 0b 80       	push   $0x800b8000
        pos |= inb(CRTPORT+1);
80100d33:	89 04 8d a0 0f 11 80 	mov    %eax,-0x7feef060(,%ecx,4)
        memset(phycrt, 0, sizeof(phycrt[0])*(23*80));
80100d3a:	e8 71 40 00 00       	call   80104db0 <memset>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100d3f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100d44:	89 fa                	mov    %edi,%edx
80100d46:	ee                   	out    %al,(%dx)
80100d47:	31 c9                	xor    %ecx,%ecx
80100d49:	89 f2                	mov    %esi,%edx
80100d4b:	89 c8                	mov    %ecx,%eax
80100d4d:	ee                   	out    %al,(%dx)
80100d4e:	b8 0f 00 00 00       	mov    $0xf,%eax
80100d53:	89 fa                	mov    %edi,%edx
80100d55:	ee                   	out    %al,(%dx)
80100d56:	89 c8                	mov    %ecx,%eax
80100d58:	89 f2                	mov    %esi,%edx
80100d5a:	ee                   	out    %al,(%dx)
        crtflags[i]=1;
80100d5b:	c6 83 c8 0f 11 80 01 	movb   $0x1,-0x7feef038(%ebx)
        title();
80100d62:	e8 d9 fb ff ff       	call   80100940 <title>
        break;
80100d67:	83 c4 10             	add    $0x10,%esp
}
80100d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d6d:	31 c0                	xor    %eax,%eax
80100d6f:	5b                   	pop    %ebx
80100d70:	5e                   	pop    %esi
80100d71:	5f                   	pop    %edi
80100d72:	5d                   	pop    %ebp
80100d73:	c3                   	ret    
80100d74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100d80 <consoleintr>:
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	57                   	push   %edi
80100d84:	56                   	push   %esi
  int c, doprocdump = 0;
80100d85:	31 f6                	xor    %esi,%esi
{
80100d87:	53                   	push   %ebx
80100d88:	83 ec 18             	sub    $0x18,%esp
80100d8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100d8e:	68 40 b5 10 80       	push   $0x8010b540
80100d93:	e8 a8 3e 00 00       	call   80104c40 <acquire>
  while((c = getc()) >= 0){
80100d98:	83 c4 10             	add    $0x10,%esp
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100da0:	ff d3                	call   *%ebx
80100da2:	89 c7                	mov    %eax,%edi
80100da4:	85 c0                	test   %eax,%eax
80100da6:	78 60                	js     80100e08 <consoleintr+0x88>
    switch(c){
80100da8:	83 ff 10             	cmp    $0x10,%edi
80100dab:	0f 84 47 01 00 00    	je     80100ef8 <consoleintr+0x178>
80100db1:	7e 7d                	jle    80100e30 <consoleintr+0xb0>
80100db3:	83 ff 15             	cmp    $0x15,%edi
80100db6:	0f 85 04 01 00 00    	jne    80100ec0 <consoleintr+0x140>
      while(input.e != input.w &&
80100dbc:	a1 68 10 11 80       	mov    0x80111068,%eax
80100dc1:	39 05 64 10 11 80    	cmp    %eax,0x80111064
80100dc7:	74 d7                	je     80100da0 <consoleintr+0x20>
80100dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100dd0:	83 e8 01             	sub    $0x1,%eax
80100dd3:	89 c2                	mov    %eax,%edx
80100dd5:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100dd8:	80 ba e0 0f 11 80 0a 	cmpb   $0xa,-0x7feef020(%edx)
80100ddf:	74 bf                	je     80100da0 <consoleintr+0x20>
        input.e--;
80100de1:	a3 68 10 11 80       	mov    %eax,0x80111068
        consputc(BACKSPACE);
80100de6:	b8 00 01 00 00       	mov    $0x100,%eax
80100deb:	e8 20 f6 ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
80100df0:	a1 68 10 11 80       	mov    0x80111068,%eax
80100df5:	3b 05 64 10 11 80    	cmp    0x80111064,%eax
80100dfb:	75 d3                	jne    80100dd0 <consoleintr+0x50>
  while((c = getc()) >= 0){
80100dfd:	ff d3                	call   *%ebx
80100dff:	89 c7                	mov    %eax,%edi
80100e01:	85 c0                	test   %eax,%eax
80100e03:	79 a3                	jns    80100da8 <consoleintr+0x28>
80100e05:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100e08:	83 ec 0c             	sub    $0xc,%esp
80100e0b:	68 40 b5 10 80       	push   $0x8010b540
80100e10:	e8 4b 3f 00 00       	call   80104d60 <release>
  if(doprocdump) {
80100e15:	83 c4 10             	add    $0x10,%esp
80100e18:	85 f6                	test   %esi,%esi
80100e1a:	0f 85 e8 00 00 00    	jne    80100f08 <consoleintr+0x188>
}
80100e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e23:	5b                   	pop    %ebx
80100e24:	5e                   	pop    %esi
80100e25:	5f                   	pop    %edi
80100e26:	5d                   	pop    %ebp
80100e27:	c3                   	ret    
80100e28:	90                   	nop
80100e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e30:	83 ff 08             	cmp    $0x8,%edi
80100e33:	0f 84 90 00 00 00    	je     80100ec9 <consoleintr+0x149>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100e39:	85 ff                	test   %edi,%edi
80100e3b:	0f 84 5f ff ff ff    	je     80100da0 <consoleintr+0x20>
80100e41:	a1 68 10 11 80       	mov    0x80111068,%eax
80100e46:	89 c2                	mov    %eax,%edx
80100e48:	2b 15 60 10 11 80    	sub    0x80111060,%edx
80100e4e:	83 fa 7f             	cmp    $0x7f,%edx
80100e51:	0f 87 49 ff ff ff    	ja     80100da0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
80100e57:	8d 50 01             	lea    0x1(%eax),%edx
80100e5a:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100e5d:	89 15 68 10 11 80    	mov    %edx,0x80111068
        c = (c == '\r') ? '\n' : c;
80100e63:	83 ff 0d             	cmp    $0xd,%edi
80100e66:	0f 84 a8 00 00 00    	je     80100f14 <consoleintr+0x194>
        input.buf[input.e++ % INPUT_BUF] = c;
80100e6c:	89 f9                	mov    %edi,%ecx
80100e6e:	88 88 e0 0f 11 80    	mov    %cl,-0x7feef020(%eax)
        consputc(c);
80100e74:	89 f8                	mov    %edi,%eax
80100e76:	e8 95 f5 ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100e7b:	83 ff 0a             	cmp    $0xa,%edi
80100e7e:	0f 84 a1 00 00 00    	je     80100f25 <consoleintr+0x1a5>
80100e84:	83 ff 04             	cmp    $0x4,%edi
80100e87:	0f 84 98 00 00 00    	je     80100f25 <consoleintr+0x1a5>
80100e8d:	a1 60 10 11 80       	mov    0x80111060,%eax
80100e92:	83 e8 80             	sub    $0xffffff80,%eax
80100e95:	39 05 68 10 11 80    	cmp    %eax,0x80111068
80100e9b:	0f 85 ff fe ff ff    	jne    80100da0 <consoleintr+0x20>
          wakeup(&input.r);
80100ea1:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100ea4:	a3 64 10 11 80       	mov    %eax,0x80111064
          wakeup(&input.r);
80100ea9:	68 60 10 11 80       	push   $0x80111060
80100eae:	e8 0d 3a 00 00       	call   801048c0 <wakeup>
80100eb3:	83 c4 10             	add    $0x10,%esp
80100eb6:	e9 e5 fe ff ff       	jmp    80100da0 <consoleintr+0x20>
80100ebb:	90                   	nop
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ec0:	83 ff 7f             	cmp    $0x7f,%edi
80100ec3:	0f 85 70 ff ff ff    	jne    80100e39 <consoleintr+0xb9>
      if(input.e != input.w){
80100ec9:	a1 68 10 11 80       	mov    0x80111068,%eax
80100ece:	3b 05 64 10 11 80    	cmp    0x80111064,%eax
80100ed4:	0f 84 c6 fe ff ff    	je     80100da0 <consoleintr+0x20>
        input.e--;
80100eda:	83 e8 01             	sub    $0x1,%eax
80100edd:	a3 68 10 11 80       	mov    %eax,0x80111068
        consputc(BACKSPACE);
80100ee2:	b8 00 01 00 00       	mov    $0x100,%eax
80100ee7:	e8 24 f5 ff ff       	call   80100410 <consputc>
80100eec:	e9 af fe ff ff       	jmp    80100da0 <consoleintr+0x20>
80100ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100ef8:	be 01 00 00 00       	mov    $0x1,%esi
80100efd:	e9 9e fe ff ff       	jmp    80100da0 <consoleintr+0x20>
80100f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f0b:	5b                   	pop    %ebx
80100f0c:	5e                   	pop    %esi
80100f0d:	5f                   	pop    %edi
80100f0e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100f0f:	e9 5c 3a 00 00       	jmp    80104970 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100f14:	c6 80 e0 0f 11 80 0a 	movb   $0xa,-0x7feef020(%eax)
        consputc(c);
80100f1b:	b8 0a 00 00 00       	mov    $0xa,%eax
80100f20:	e8 eb f4 ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100f25:	a1 68 10 11 80       	mov    0x80111068,%eax
80100f2a:	e9 72 ff ff ff       	jmp    80100ea1 <consoleintr+0x121>
80100f2f:	90                   	nop

80100f30 <consoleinit>:

void
consoleinit(void)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100f36:	68 0d 7c 10 80       	push   $0x80107c0d
80100f3b:	68 40 b5 10 80       	push   $0x8010b540
80100f40:	e8 fb 3b 00 00       	call   80104b40 <initlock>
  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;
  crtflags[0]=1;

  ioapicenable(IRQ_KBD, 0);
80100f45:	58                   	pop    %eax
80100f46:	5a                   	pop    %edx
80100f47:	6a 00                	push   $0x0
80100f49:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f4b:	c7 05 ec a9 11 80 40 	movl   $0x80100640,0x8011a9ec
80100f52:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100f55:	c7 05 e8 a9 11 80 80 	movl   $0x80100280,0x8011a9e8
80100f5c:	02 10 80 
  cons.locking = 1;
80100f5f:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
80100f66:	00 00 00 
  crtflags[0]=1;
80100f69:	c6 05 c8 0f 11 80 01 	movb   $0x1,0x80110fc8
  ioapicenable(IRQ_KBD, 0);
80100f70:	e8 6b 19 00 00       	call   801028e0 <ioapicenable>
}
80100f75:	83 c4 10             	add    $0x10,%esp
80100f78:	c9                   	leave  
80100f79:	c3                   	ret    
80100f7a:	66 90                	xchg   %ax,%ax
80100f7c:	66 90                	xchg   %ax,%ax
80100f7e:	66 90                	xchg   %ax,%ax

80100f80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100f8c:	e8 ef 2e 00 00       	call   80103e80 <myproc>
80100f91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100f97:	e8 34 22 00 00       	call   801031d0 <begin_op>

  if((ip = namei(path)) == 0){
80100f9c:	83 ec 0c             	sub    $0xc,%esp
80100f9f:	ff 75 08             	pushl  0x8(%ebp)
80100fa2:	e8 49 15 00 00       	call   801024f0 <namei>
80100fa7:	83 c4 10             	add    $0x10,%esp
80100faa:	85 c0                	test   %eax,%eax
80100fac:	0f 84 02 03 00 00    	je     801012b4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100fb2:	83 ec 0c             	sub    $0xc,%esp
80100fb5:	89 c3                	mov    %eax,%ebx
80100fb7:	50                   	push   %eax
80100fb8:	e8 93 0c 00 00       	call   80101c50 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100fbd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100fc3:	6a 34                	push   $0x34
80100fc5:	6a 00                	push   $0x0
80100fc7:	50                   	push   %eax
80100fc8:	53                   	push   %ebx
80100fc9:	e8 62 0f 00 00       	call   80101f30 <readi>
80100fce:	83 c4 20             	add    $0x20,%esp
80100fd1:	83 f8 34             	cmp    $0x34,%eax
80100fd4:	74 22                	je     80100ff8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100fd6:	83 ec 0c             	sub    $0xc,%esp
80100fd9:	53                   	push   %ebx
80100fda:	e8 01 0f 00 00       	call   80101ee0 <iunlockput>
    end_op();
80100fdf:	e8 5c 22 00 00       	call   80103240 <end_op>
80100fe4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fef:	5b                   	pop    %ebx
80100ff0:	5e                   	pop    %esi
80100ff1:	5f                   	pop    %edi
80100ff2:	5d                   	pop    %ebp
80100ff3:	c3                   	ret    
80100ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100ff8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100fff:	45 4c 46 
80101002:	75 d2                	jne    80100fd6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80101004:	e8 f7 68 00 00       	call   80107900 <setupkvm>
80101009:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010100f:	85 c0                	test   %eax,%eax
80101011:	74 c3                	je     80100fd6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101013:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
8010101a:	00 
8010101b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101021:	0f 84 ac 02 00 00    	je     801012d3 <exec+0x353>
  sz = 0;
80101027:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
8010102e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101031:	31 ff                	xor    %edi,%edi
80101033:	e9 8e 00 00 00       	jmp    801010c6 <exec+0x146>
80101038:	90                   	nop
80101039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80101040:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101047:	75 6c                	jne    801010b5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101049:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010104f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101055:	0f 82 87 00 00 00    	jb     801010e2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
8010105b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101061:	72 7f                	jb     801010e2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101063:	83 ec 04             	sub    $0x4,%esp
80101066:	50                   	push   %eax
80101067:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
8010106d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101073:	e8 78 66 00 00       	call   801076f0 <allocuvm>
80101078:	83 c4 10             	add    $0x10,%esp
8010107b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101081:	85 c0                	test   %eax,%eax
80101083:	74 5d                	je     801010e2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101085:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010108b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101090:	75 50                	jne    801010e2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101092:	83 ec 0c             	sub    $0xc,%esp
80101095:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010109b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
801010a1:	53                   	push   %ebx
801010a2:	50                   	push   %eax
801010a3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801010a9:	e8 a2 64 00 00       	call   80107550 <loaduvm>
801010ae:	83 c4 20             	add    $0x20,%esp
801010b1:	85 c0                	test   %eax,%eax
801010b3:	78 2d                	js     801010e2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010b5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801010bc:	83 c7 01             	add    $0x1,%edi
801010bf:	83 c6 20             	add    $0x20,%esi
801010c2:	39 f8                	cmp    %edi,%eax
801010c4:	7e 3a                	jle    80101100 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801010c6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801010cc:	6a 20                	push   $0x20
801010ce:	56                   	push   %esi
801010cf:	50                   	push   %eax
801010d0:	53                   	push   %ebx
801010d1:	e8 5a 0e 00 00       	call   80101f30 <readi>
801010d6:	83 c4 10             	add    $0x10,%esp
801010d9:	83 f8 20             	cmp    $0x20,%eax
801010dc:	0f 84 5e ff ff ff    	je     80101040 <exec+0xc0>
    freevm(pgdir);
801010e2:	83 ec 0c             	sub    $0xc,%esp
801010e5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801010eb:	e8 90 67 00 00       	call   80107880 <freevm>
  if(ip){
801010f0:	83 c4 10             	add    $0x10,%esp
801010f3:	e9 de fe ff ff       	jmp    80100fd6 <exec+0x56>
801010f8:	90                   	nop
801010f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101100:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101106:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010110c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80101112:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101118:	83 ec 0c             	sub    $0xc,%esp
8010111b:	53                   	push   %ebx
8010111c:	e8 bf 0d 00 00       	call   80101ee0 <iunlockput>
  end_op();
80101121:	e8 1a 21 00 00       	call   80103240 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101126:	83 c4 0c             	add    $0xc,%esp
80101129:	56                   	push   %esi
8010112a:	57                   	push   %edi
8010112b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101131:	57                   	push   %edi
80101132:	e8 b9 65 00 00       	call   801076f0 <allocuvm>
80101137:	83 c4 10             	add    $0x10,%esp
8010113a:	89 c6                	mov    %eax,%esi
8010113c:	85 c0                	test   %eax,%eax
8010113e:	0f 84 94 00 00 00    	je     801011d8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101144:	83 ec 08             	sub    $0x8,%esp
80101147:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010114d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010114f:	50                   	push   %eax
80101150:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101151:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101153:	e8 48 68 00 00       	call   801079a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101158:	8b 45 0c             	mov    0xc(%ebp),%eax
8010115b:	83 c4 10             	add    $0x10,%esp
8010115e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101164:	8b 00                	mov    (%eax),%eax
80101166:	85 c0                	test   %eax,%eax
80101168:	0f 84 8b 00 00 00    	je     801011f9 <exec+0x279>
8010116e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101174:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010117a:	eb 23                	jmp    8010119f <exec+0x21f>
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101180:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101183:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010118a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010118d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101193:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101196:	85 c0                	test   %eax,%eax
80101198:	74 59                	je     801011f3 <exec+0x273>
    if(argc >= MAXARG)
8010119a:	83 ff 20             	cmp    $0x20,%edi
8010119d:	74 39                	je     801011d8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	50                   	push   %eax
801011a3:	e8 18 3e 00 00       	call   80104fc0 <strlen>
801011a8:	f7 d0                	not    %eax
801011aa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011ac:	58                   	pop    %eax
801011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801011b0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011b3:	ff 34 b8             	pushl  (%eax,%edi,4)
801011b6:	e8 05 3e 00 00       	call   80104fc0 <strlen>
801011bb:	83 c0 01             	add    $0x1,%eax
801011be:	50                   	push   %eax
801011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801011c2:	ff 34 b8             	pushl  (%eax,%edi,4)
801011c5:	53                   	push   %ebx
801011c6:	56                   	push   %esi
801011c7:	e8 24 69 00 00       	call   80107af0 <copyout>
801011cc:	83 c4 20             	add    $0x20,%esp
801011cf:	85 c0                	test   %eax,%eax
801011d1:	79 ad                	jns    80101180 <exec+0x200>
801011d3:	90                   	nop
801011d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
801011d8:	83 ec 0c             	sub    $0xc,%esp
801011db:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801011e1:	e8 9a 66 00 00       	call   80107880 <freevm>
801011e6:	83 c4 10             	add    $0x10,%esp
  return -1;
801011e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ee:	e9 f9 fd ff ff       	jmp    80100fec <exec+0x6c>
801011f3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011f9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101200:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101202:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101209:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010120d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010120f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101212:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101218:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010121a:	50                   	push   %eax
8010121b:	52                   	push   %edx
8010121c:	53                   	push   %ebx
8010121d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101223:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010122a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010122d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101233:	e8 b8 68 00 00       	call   80107af0 <copyout>
80101238:	83 c4 10             	add    $0x10,%esp
8010123b:	85 c0                	test   %eax,%eax
8010123d:	78 99                	js     801011d8 <exec+0x258>
  for(last=s=path; *s; s++)
8010123f:	8b 45 08             	mov    0x8(%ebp),%eax
80101242:	8b 55 08             	mov    0x8(%ebp),%edx
80101245:	0f b6 00             	movzbl (%eax),%eax
80101248:	84 c0                	test   %al,%al
8010124a:	74 13                	je     8010125f <exec+0x2df>
8010124c:	89 d1                	mov    %edx,%ecx
8010124e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80101250:	83 c1 01             	add    $0x1,%ecx
80101253:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101255:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80101258:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010125b:	84 c0                	test   %al,%al
8010125d:	75 f1                	jne    80101250 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010125f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101265:	83 ec 04             	sub    $0x4,%esp
80101268:	6a 10                	push   $0x10
8010126a:	89 f8                	mov    %edi,%eax
8010126c:	52                   	push   %edx
8010126d:	83 c0 6c             	add    $0x6c,%eax
80101270:	50                   	push   %eax
80101271:	e8 0a 3d 00 00       	call   80104f80 <safestrcpy>
  curproc->pgdir = pgdir;
80101276:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010127c:	89 f8                	mov    %edi,%eax
8010127e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101281:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101283:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101286:	89 c1                	mov    %eax,%ecx
80101288:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010128e:	8b 40 18             	mov    0x18(%eax),%eax
80101291:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101294:	8b 41 18             	mov    0x18(%ecx),%eax
80101297:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010129a:	89 0c 24             	mov    %ecx,(%esp)
8010129d:	e8 1e 61 00 00       	call   801073c0 <switchuvm>
  freevm(oldpgdir);
801012a2:	89 3c 24             	mov    %edi,(%esp)
801012a5:	e8 d6 65 00 00       	call   80107880 <freevm>
  return 0;
801012aa:	83 c4 10             	add    $0x10,%esp
801012ad:	31 c0                	xor    %eax,%eax
801012af:	e9 38 fd ff ff       	jmp    80100fec <exec+0x6c>
    end_op();
801012b4:	e8 87 1f 00 00       	call   80103240 <end_op>
    cprintf("exec: fail\n");
801012b9:	83 ec 0c             	sub    $0xc,%esp
801012bc:	68 29 7c 10 80       	push   $0x80107c29
801012c1:	e8 da f3 ff ff       	call   801006a0 <cprintf>
    return -1;
801012c6:	83 c4 10             	add    $0x10,%esp
801012c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012ce:	e9 19 fd ff ff       	jmp    80100fec <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801012d3:	31 ff                	xor    %edi,%edi
801012d5:	be 00 20 00 00       	mov    $0x2000,%esi
801012da:	e9 39 fe ff ff       	jmp    80101118 <exec+0x198>
801012df:	90                   	nop

801012e0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801012e6:	68 35 7c 10 80       	push   $0x80107c35
801012eb:	68 40 a0 11 80       	push   $0x8011a040
801012f0:	e8 4b 38 00 00       	call   80104b40 <initlock>
}
801012f5:	83 c4 10             	add    $0x10,%esp
801012f8:	c9                   	leave  
801012f9:	c3                   	ret    
801012fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101300 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101304:	bb 74 a0 11 80       	mov    $0x8011a074,%ebx
{
80101309:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010130c:	68 40 a0 11 80       	push   $0x8011a040
80101311:	e8 2a 39 00 00       	call   80104c40 <acquire>
80101316:	83 c4 10             	add    $0x10,%esp
80101319:	eb 10                	jmp    8010132b <filealloc+0x2b>
8010131b:	90                   	nop
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101320:	83 c3 18             	add    $0x18,%ebx
80101323:	81 fb d4 a9 11 80    	cmp    $0x8011a9d4,%ebx
80101329:	74 25                	je     80101350 <filealloc+0x50>
    if(f->ref == 0){
8010132b:	8b 43 04             	mov    0x4(%ebx),%eax
8010132e:	85 c0                	test   %eax,%eax
80101330:	75 ee                	jne    80101320 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101332:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101335:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010133c:	68 40 a0 11 80       	push   $0x8011a040
80101341:	e8 1a 3a 00 00       	call   80104d60 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101346:	89 d8                	mov    %ebx,%eax
      return f;
80101348:	83 c4 10             	add    $0x10,%esp
}
8010134b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010134e:	c9                   	leave  
8010134f:	c3                   	ret    
  release(&ftable.lock);
80101350:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101353:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101355:	68 40 a0 11 80       	push   $0x8011a040
8010135a:	e8 01 3a 00 00       	call   80104d60 <release>
}
8010135f:	89 d8                	mov    %ebx,%eax
  return 0;
80101361:	83 c4 10             	add    $0x10,%esp
}
80101364:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101367:	c9                   	leave  
80101368:	c3                   	ret    
80101369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101370 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	53                   	push   %ebx
80101374:	83 ec 10             	sub    $0x10,%esp
80101377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010137a:	68 40 a0 11 80       	push   $0x8011a040
8010137f:	e8 bc 38 00 00       	call   80104c40 <acquire>
  if(f->ref < 1)
80101384:	8b 43 04             	mov    0x4(%ebx),%eax
80101387:	83 c4 10             	add    $0x10,%esp
8010138a:	85 c0                	test   %eax,%eax
8010138c:	7e 1a                	jle    801013a8 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010138e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101391:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101394:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101397:	68 40 a0 11 80       	push   $0x8011a040
8010139c:	e8 bf 39 00 00       	call   80104d60 <release>
  return f;
}
801013a1:	89 d8                	mov    %ebx,%eax
801013a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013a6:	c9                   	leave  
801013a7:	c3                   	ret    
    panic("filedup");
801013a8:	83 ec 0c             	sub    $0xc,%esp
801013ab:	68 3c 7c 10 80       	push   $0x80107c3c
801013b0:	e8 db ef ff ff       	call   80100390 <panic>
801013b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013c0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	57                   	push   %edi
801013c4:	56                   	push   %esi
801013c5:	53                   	push   %ebx
801013c6:	83 ec 28             	sub    $0x28,%esp
801013c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801013cc:	68 40 a0 11 80       	push   $0x8011a040
801013d1:	e8 6a 38 00 00       	call   80104c40 <acquire>
  if(f->ref < 1)
801013d6:	8b 43 04             	mov    0x4(%ebx),%eax
801013d9:	83 c4 10             	add    $0x10,%esp
801013dc:	85 c0                	test   %eax,%eax
801013de:	0f 8e a3 00 00 00    	jle    80101487 <fileclose+0xc7>
    panic("fileclose");
  if(--f->ref > 0){
801013e4:	83 e8 01             	sub    $0x1,%eax
801013e7:	89 43 04             	mov    %eax,0x4(%ebx)
801013ea:	75 44                	jne    80101430 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }

  ff = *f;
801013ec:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801013f0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801013f3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801013f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801013fb:	8b 73 0c             	mov    0xc(%ebx),%esi
801013fe:	88 45 e7             	mov    %al,-0x19(%ebp)
80101401:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101404:	68 40 a0 11 80       	push   $0x8011a040
  ff = *f;
80101409:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010140c:	e8 4f 39 00 00       	call   80104d60 <release>

  if(ff.type == FD_PIPE)
80101411:	83 c4 10             	add    $0x10,%esp
80101414:	83 ff 01             	cmp    $0x1,%edi
80101417:	74 2f                	je     80101448 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101419:	83 ff 03             	cmp    $0x3,%edi
8010141c:	74 4a                	je     80101468 <fileclose+0xa8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010141e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101421:	5b                   	pop    %ebx
80101422:	5e                   	pop    %esi
80101423:	5f                   	pop    %edi
80101424:	5d                   	pop    %ebp
80101425:	c3                   	ret    
80101426:	8d 76 00             	lea    0x0(%esi),%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&ftable.lock);
80101430:	c7 45 08 40 a0 11 80 	movl   $0x8011a040,0x8(%ebp)
}
80101437:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010143a:	5b                   	pop    %ebx
8010143b:	5e                   	pop    %esi
8010143c:	5f                   	pop    %edi
8010143d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010143e:	e9 1d 39 00 00       	jmp    80104d60 <release>
80101443:	90                   	nop
80101444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pipeclose(ff.pipe, ff.writable);
80101448:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010144c:	83 ec 08             	sub    $0x8,%esp
8010144f:	53                   	push   %ebx
80101450:	56                   	push   %esi
80101451:	e8 7a 25 00 00       	call   801039d0 <pipeclose>
80101456:	83 c4 10             	add    $0x10,%esp
}
80101459:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010145c:	5b                   	pop    %ebx
8010145d:	5e                   	pop    %esi
8010145e:	5f                   	pop    %edi
8010145f:	5d                   	pop    %ebp
80101460:	c3                   	ret    
80101461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101468:	e8 63 1d 00 00       	call   801031d0 <begin_op>
    iput(ff.ip);
8010146d:	83 ec 0c             	sub    $0xc,%esp
80101470:	ff 75 e0             	pushl  -0x20(%ebp)
80101473:	e8 08 09 00 00       	call   80101d80 <iput>
    end_op();
80101478:	83 c4 10             	add    $0x10,%esp
}
8010147b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010147e:	5b                   	pop    %ebx
8010147f:	5e                   	pop    %esi
80101480:	5f                   	pop    %edi
80101481:	5d                   	pop    %ebp
    end_op();
80101482:	e9 b9 1d 00 00       	jmp    80103240 <end_op>
    panic("fileclose");
80101487:	83 ec 0c             	sub    $0xc,%esp
8010148a:	68 44 7c 10 80       	push   $0x80107c44
8010148f:	e8 fc ee ff ff       	call   80100390 <panic>
80101494:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010149a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801014a0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	53                   	push   %ebx
801014a4:	83 ec 04             	sub    $0x4,%esp
801014a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801014aa:	83 3b 03             	cmpl   $0x3,(%ebx)
801014ad:	75 31                	jne    801014e0 <filestat+0x40>
    ilock(f->ip);
801014af:	83 ec 0c             	sub    $0xc,%esp
801014b2:	ff 73 10             	pushl  0x10(%ebx)
801014b5:	e8 96 07 00 00       	call   80101c50 <ilock>
    stati(f->ip, st);
801014ba:	58                   	pop    %eax
801014bb:	5a                   	pop    %edx
801014bc:	ff 75 0c             	pushl  0xc(%ebp)
801014bf:	ff 73 10             	pushl  0x10(%ebx)
801014c2:	e8 39 0a 00 00       	call   80101f00 <stati>
    iunlock(f->ip);
801014c7:	59                   	pop    %ecx
801014c8:	ff 73 10             	pushl  0x10(%ebx)
801014cb:	e8 60 08 00 00       	call   80101d30 <iunlock>
    return 0;
801014d0:	83 c4 10             	add    $0x10,%esp
801014d3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801014d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014d8:	c9                   	leave  
801014d9:	c3                   	ret    
801014da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
801014e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801014e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014e8:	c9                   	leave  
801014e9:	c3                   	ret    
801014ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014f0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	53                   	push   %ebx
801014f6:	83 ec 0c             	sub    $0xc,%esp
801014f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801014fc:	8b 75 0c             	mov    0xc(%ebp),%esi
801014ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101502:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101506:	74 60                	je     80101568 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101508:	8b 03                	mov    (%ebx),%eax
8010150a:	83 f8 01             	cmp    $0x1,%eax
8010150d:	74 41                	je     80101550 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010150f:	83 f8 03             	cmp    $0x3,%eax
80101512:	75 5b                	jne    8010156f <fileread+0x7f>
    ilock(f->ip);
80101514:	83 ec 0c             	sub    $0xc,%esp
80101517:	ff 73 10             	pushl  0x10(%ebx)
8010151a:	e8 31 07 00 00       	call   80101c50 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010151f:	57                   	push   %edi
80101520:	ff 73 14             	pushl  0x14(%ebx)
80101523:	56                   	push   %esi
80101524:	ff 73 10             	pushl  0x10(%ebx)
80101527:	e8 04 0a 00 00       	call   80101f30 <readi>
8010152c:	83 c4 20             	add    $0x20,%esp
8010152f:	89 c6                	mov    %eax,%esi
80101531:	85 c0                	test   %eax,%eax
80101533:	7e 03                	jle    80101538 <fileread+0x48>
      f->off += r;
80101535:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101538:	83 ec 0c             	sub    $0xc,%esp
8010153b:	ff 73 10             	pushl  0x10(%ebx)
8010153e:	e8 ed 07 00 00       	call   80101d30 <iunlock>
    return r;
80101543:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101546:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101549:	89 f0                	mov    %esi,%eax
8010154b:	5b                   	pop    %ebx
8010154c:	5e                   	pop    %esi
8010154d:	5f                   	pop    %edi
8010154e:	5d                   	pop    %ebp
8010154f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101550:	8b 43 0c             	mov    0xc(%ebx),%eax
80101553:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101556:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101559:	5b                   	pop    %ebx
8010155a:	5e                   	pop    %esi
8010155b:	5f                   	pop    %edi
8010155c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010155d:	e9 1e 26 00 00       	jmp    80103b80 <piperead>
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101568:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010156d:	eb d7                	jmp    80101546 <fileread+0x56>
  panic("fileread");
8010156f:	83 ec 0c             	sub    $0xc,%esp
80101572:	68 4e 7c 10 80       	push   $0x80107c4e
80101577:	e8 14 ee ff ff       	call   80100390 <panic>
8010157c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101580 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	57                   	push   %edi
80101584:	56                   	push   %esi
80101585:	53                   	push   %ebx
80101586:	83 ec 1c             	sub    $0x1c,%esp
80101589:	8b 45 0c             	mov    0xc(%ebp),%eax
8010158c:	8b 75 08             	mov    0x8(%ebp),%esi
8010158f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101592:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101595:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101599:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010159c:	0f 84 c3 00 00 00    	je     80101665 <filewrite+0xe5>
    return -1;
  if(f->type == FD_PIPE)
801015a2:	8b 06                	mov    (%esi),%eax
801015a4:	83 f8 01             	cmp    $0x1,%eax
801015a7:	0f 84 cb 00 00 00    	je     80101678 <filewrite+0xf8>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_MEMO){
801015ad:	83 f8 02             	cmp    $0x2,%eax
801015b0:	0f 84 d4 00 00 00    	je     8010168a <filewrite+0x10a>
    memowrite(addr,n);
    return n;
  }
  if(f->type == FD_INODE){
801015b6:	83 f8 03             	cmp    $0x3,%eax
801015b9:	0f 85 e7 00 00 00    	jne    801016a6 <filewrite+0x126>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801015bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801015c2:	31 ff                	xor    %edi,%edi
    while(i < n){
801015c4:	85 c0                	test   %eax,%eax
801015c6:	7f 2f                	jg     801015f7 <filewrite+0x77>
801015c8:	e9 93 00 00 00       	jmp    80101660 <filewrite+0xe0>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801015d0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801015d3:	83 ec 0c             	sub    $0xc,%esp
801015d6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801015d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801015dc:	e8 4f 07 00 00       	call   80101d30 <iunlock>
      end_op();
801015e1:	e8 5a 1c 00 00       	call   80103240 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801015e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801015e9:	83 c4 10             	add    $0x10,%esp
801015ec:	39 c3                	cmp    %eax,%ebx
801015ee:	75 60                	jne    80101650 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
801015f0:	01 df                	add    %ebx,%edi
    while(i < n){
801015f2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801015f5:	7e 69                	jle    80101660 <filewrite+0xe0>
      int n1 = n - i;
801015f7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801015fa:	b8 00 06 00 00       	mov    $0x600,%eax
801015ff:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101601:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101607:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010160a:	e8 c1 1b 00 00       	call   801031d0 <begin_op>
      ilock(f->ip);
8010160f:	83 ec 0c             	sub    $0xc,%esp
80101612:	ff 76 10             	pushl  0x10(%esi)
80101615:	e8 36 06 00 00       	call   80101c50 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010161a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010161d:	53                   	push   %ebx
8010161e:	ff 76 14             	pushl  0x14(%esi)
80101621:	01 f8                	add    %edi,%eax
80101623:	50                   	push   %eax
80101624:	ff 76 10             	pushl  0x10(%esi)
80101627:	e8 04 0a 00 00       	call   80102030 <writei>
8010162c:	83 c4 20             	add    $0x20,%esp
8010162f:	85 c0                	test   %eax,%eax
80101631:	7f 9d                	jg     801015d0 <filewrite+0x50>
      iunlock(f->ip);
80101633:	83 ec 0c             	sub    $0xc,%esp
80101636:	ff 76 10             	pushl  0x10(%esi)
80101639:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010163c:	e8 ef 06 00 00       	call   80101d30 <iunlock>
      end_op();
80101641:	e8 fa 1b 00 00       	call   80103240 <end_op>
      if(r < 0)
80101646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101649:	83 c4 10             	add    $0x10,%esp
8010164c:	85 c0                	test   %eax,%eax
8010164e:	75 15                	jne    80101665 <filewrite+0xe5>
        panic("short filewrite");
80101650:	83 ec 0c             	sub    $0xc,%esp
80101653:	68 57 7c 10 80       	push   $0x80107c57
80101658:	e8 33 ed ff ff       	call   80100390 <panic>
8010165d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101660:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101663:	74 05                	je     8010166a <filewrite+0xea>
    return -1;
80101665:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  }
  panic("filewrite");
}
8010166a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010166d:	89 f8                	mov    %edi,%eax
8010166f:	5b                   	pop    %ebx
80101670:	5e                   	pop    %esi
80101671:	5f                   	pop    %edi
80101672:	5d                   	pop    %ebp
80101673:	c3                   	ret    
80101674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return pipewrite(f->pipe, addr, n);
80101678:	8b 46 0c             	mov    0xc(%esi),%eax
8010167b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010167e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101681:	5b                   	pop    %ebx
80101682:	5e                   	pop    %esi
80101683:	5f                   	pop    %edi
80101684:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101685:	e9 e6 23 00 00       	jmp    80103a70 <pipewrite>
    memowrite(addr,n);
8010168a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010168d:	83 ec 08             	sub    $0x8,%esp
80101690:	57                   	push   %edi
80101691:	ff 75 dc             	pushl  -0x24(%ebp)
80101694:	e8 e7 21 00 00       	call   80103880 <memowrite>
    return n;
80101699:	83 c4 10             	add    $0x10,%esp
}
8010169c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010169f:	89 f8                	mov    %edi,%eax
801016a1:	5b                   	pop    %ebx
801016a2:	5e                   	pop    %esi
801016a3:	5f                   	pop    %edi
801016a4:	5d                   	pop    %ebp
801016a5:	c3                   	ret    
  panic("filewrite");
801016a6:	83 ec 0c             	sub    $0xc,%esp
801016a9:	68 5d 7c 10 80       	push   $0x80107c5d
801016ae:	e8 dd ec ff ff       	call   80100390 <panic>
801016b3:	66 90                	xchg   %ax,%ax
801016b5:	66 90                	xchg   %ax,%ax
801016b7:	66 90                	xchg   %ax,%ax
801016b9:	66 90                	xchg   %ax,%ax
801016bb:	66 90                	xchg   %ax,%ax
801016bd:	66 90                	xchg   %ax,%ax
801016bf:	90                   	nop

801016c0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	57                   	push   %edi
801016c4:	56                   	push   %esi
801016c5:	53                   	push   %ebx
801016c6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801016c9:	8b 0d 40 aa 11 80    	mov    0x8011aa40,%ecx
{
801016cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801016d2:	85 c9                	test   %ecx,%ecx
801016d4:	0f 84 87 00 00 00    	je     80101761 <balloc+0xa1>
801016da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801016e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801016e4:	83 ec 08             	sub    $0x8,%esp
801016e7:	89 f0                	mov    %esi,%eax
801016e9:	c1 f8 0c             	sar    $0xc,%eax
801016ec:	03 05 58 aa 11 80    	add    0x8011aa58,%eax
801016f2:	50                   	push   %eax
801016f3:	ff 75 d8             	pushl  -0x28(%ebp)
801016f6:	e8 d5 e9 ff ff       	call   801000d0 <bread>
801016fb:	83 c4 10             	add    $0x10,%esp
801016fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101701:	a1 40 aa 11 80       	mov    0x8011aa40,%eax
80101706:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101709:	31 c0                	xor    %eax,%eax
8010170b:	eb 2f                	jmp    8010173c <balloc+0x7c>
8010170d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101710:	89 c1                	mov    %eax,%ecx
80101712:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101717:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010171a:	83 e1 07             	and    $0x7,%ecx
8010171d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010171f:	89 c1                	mov    %eax,%ecx
80101721:	c1 f9 03             	sar    $0x3,%ecx
80101724:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101729:	89 fa                	mov    %edi,%edx
8010172b:	85 df                	test   %ebx,%edi
8010172d:	74 41                	je     80101770 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010172f:	83 c0 01             	add    $0x1,%eax
80101732:	83 c6 01             	add    $0x1,%esi
80101735:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010173a:	74 05                	je     80101741 <balloc+0x81>
8010173c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010173f:	77 cf                	ja     80101710 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101741:	83 ec 0c             	sub    $0xc,%esp
80101744:	ff 75 e4             	pushl  -0x1c(%ebp)
80101747:	e8 a4 ea ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010174c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101753:	83 c4 10             	add    $0x10,%esp
80101756:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101759:	39 05 40 aa 11 80    	cmp    %eax,0x8011aa40
8010175f:	77 80                	ja     801016e1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101761:	83 ec 0c             	sub    $0xc,%esp
80101764:	68 67 7c 10 80       	push   $0x80107c67
80101769:	e8 22 ec ff ff       	call   80100390 <panic>
8010176e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101770:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101773:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101776:	09 da                	or     %ebx,%edx
80101778:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010177c:	57                   	push   %edi
8010177d:	e8 2e 1c 00 00       	call   801033b0 <log_write>
        brelse(bp);
80101782:	89 3c 24             	mov    %edi,(%esp)
80101785:	e8 66 ea ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010178a:	58                   	pop    %eax
8010178b:	5a                   	pop    %edx
8010178c:	56                   	push   %esi
8010178d:	ff 75 d8             	pushl  -0x28(%ebp)
80101790:	e8 3b e9 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101795:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101798:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010179a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010179d:	68 00 02 00 00       	push   $0x200
801017a2:	6a 00                	push   $0x0
801017a4:	50                   	push   %eax
801017a5:	e8 06 36 00 00       	call   80104db0 <memset>
  log_write(bp);
801017aa:	89 1c 24             	mov    %ebx,(%esp)
801017ad:	e8 fe 1b 00 00       	call   801033b0 <log_write>
  brelse(bp);
801017b2:	89 1c 24             	mov    %ebx,(%esp)
801017b5:	e8 36 ea ff ff       	call   801001f0 <brelse>
}
801017ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017bd:	89 f0                	mov    %esi,%eax
801017bf:	5b                   	pop    %ebx
801017c0:	5e                   	pop    %esi
801017c1:	5f                   	pop    %edi
801017c2:	5d                   	pop    %ebp
801017c3:	c3                   	ret    
801017c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	89 c7                	mov    %eax,%edi
801017d6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801017d7:	31 f6                	xor    %esi,%esi
{
801017d9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017da:	bb 94 aa 11 80       	mov    $0x8011aa94,%ebx
{
801017df:	83 ec 28             	sub    $0x28,%esp
801017e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801017e5:	68 60 aa 11 80       	push   $0x8011aa60
801017ea:	e8 51 34 00 00       	call   80104c40 <acquire>
801017ef:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801017f5:	eb 1b                	jmp    80101812 <iget+0x42>
801017f7:	89 f6                	mov    %esi,%esi
801017f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101800:	39 3b                	cmp    %edi,(%ebx)
80101802:	74 6c                	je     80101870 <iget+0xa0>
80101804:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010180a:	81 fb b4 c6 11 80    	cmp    $0x8011c6b4,%ebx
80101810:	73 26                	jae    80101838 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101812:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101815:	85 c9                	test   %ecx,%ecx
80101817:	7f e7                	jg     80101800 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101819:	85 f6                	test   %esi,%esi
8010181b:	75 e7                	jne    80101804 <iget+0x34>
8010181d:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80101823:	85 c9                	test   %ecx,%ecx
80101825:	75 70                	jne    80101897 <iget+0xc7>
80101827:	89 de                	mov    %ebx,%esi
80101829:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010182b:	81 fb b4 c6 11 80    	cmp    $0x8011c6b4,%ebx
80101831:	72 df                	jb     80101812 <iget+0x42>
80101833:	90                   	nop
80101834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101838:	85 f6                	test   %esi,%esi
8010183a:	74 74                	je     801018b0 <iget+0xe0>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010183c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010183f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101841:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101844:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010184b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101852:	68 60 aa 11 80       	push   $0x8011aa60
80101857:	e8 04 35 00 00       	call   80104d60 <release>

  return ip;
8010185c:	83 c4 10             	add    $0x10,%esp
}
8010185f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101862:	89 f0                	mov    %esi,%eax
80101864:	5b                   	pop    %ebx
80101865:	5e                   	pop    %esi
80101866:	5f                   	pop    %edi
80101867:	5d                   	pop    %ebp
80101868:	c3                   	ret    
80101869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101870:	39 53 04             	cmp    %edx,0x4(%ebx)
80101873:	75 8f                	jne    80101804 <iget+0x34>
      release(&icache.lock);
80101875:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101878:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010187b:	89 de                	mov    %ebx,%esi
      ip->ref++;
8010187d:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101880:	68 60 aa 11 80       	push   $0x8011aa60
80101885:	e8 d6 34 00 00       	call   80104d60 <release>
      return ip;
8010188a:	83 c4 10             	add    $0x10,%esp
}
8010188d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101890:	89 f0                	mov    %esi,%eax
80101892:	5b                   	pop    %ebx
80101893:	5e                   	pop    %esi
80101894:	5f                   	pop    %edi
80101895:	5d                   	pop    %ebp
80101896:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101897:	3d b4 c6 11 80       	cmp    $0x8011c6b4,%eax
8010189c:	73 12                	jae    801018b0 <iget+0xe0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010189e:	8b 48 08             	mov    0x8(%eax),%ecx
801018a1:	89 c3                	mov    %eax,%ebx
801018a3:	85 c9                	test   %ecx,%ecx
801018a5:	0f 8f 55 ff ff ff    	jg     80101800 <iget+0x30>
801018ab:	e9 6d ff ff ff       	jmp    8010181d <iget+0x4d>
    panic("iget: no inodes");
801018b0:	83 ec 0c             	sub    $0xc,%esp
801018b3:	68 7d 7c 10 80       	push   $0x80107c7d
801018b8:	e8 d3 ea ff ff       	call   80100390 <panic>
801018bd:	8d 76 00             	lea    0x0(%esi),%esi

801018c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	57                   	push   %edi
801018c4:	56                   	push   %esi
801018c5:	89 c6                	mov    %eax,%esi
801018c7:	53                   	push   %ebx
801018c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801018cb:	83 fa 0b             	cmp    $0xb,%edx
801018ce:	0f 86 84 00 00 00    	jbe    80101958 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801018d4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801018d7:	83 fb 7f             	cmp    $0x7f,%ebx
801018da:	0f 87 98 00 00 00    	ja     80101978 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801018e0:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801018e6:	8b 00                	mov    (%eax),%eax
801018e8:	85 d2                	test   %edx,%edx
801018ea:	74 54                	je     80101940 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801018ec:	83 ec 08             	sub    $0x8,%esp
801018ef:	52                   	push   %edx
801018f0:	50                   	push   %eax
801018f1:	e8 da e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801018f6:	83 c4 10             	add    $0x10,%esp
801018f9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801018fd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801018ff:	8b 1a                	mov    (%edx),%ebx
80101901:	85 db                	test   %ebx,%ebx
80101903:	74 1b                	je     80101920 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101905:	83 ec 0c             	sub    $0xc,%esp
80101908:	57                   	push   %edi
80101909:	e8 e2 e8 ff ff       	call   801001f0 <brelse>
    return addr;
8010190e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101911:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101914:	89 d8                	mov    %ebx,%eax
80101916:	5b                   	pop    %ebx
80101917:	5e                   	pop    %esi
80101918:	5f                   	pop    %edi
80101919:	5d                   	pop    %ebp
8010191a:	c3                   	ret    
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a[bn] = addr = balloc(ip->dev);
80101920:	8b 06                	mov    (%esi),%eax
80101922:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101925:	e8 96 fd ff ff       	call   801016c0 <balloc>
8010192a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010192d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101930:	89 c3                	mov    %eax,%ebx
80101932:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101934:	57                   	push   %edi
80101935:	e8 76 1a 00 00       	call   801033b0 <log_write>
8010193a:	83 c4 10             	add    $0x10,%esp
8010193d:	eb c6                	jmp    80101905 <bmap+0x45>
8010193f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101940:	e8 7b fd ff ff       	call   801016c0 <balloc>
80101945:	89 c2                	mov    %eax,%edx
80101947:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010194d:	8b 06                	mov    (%esi),%eax
8010194f:	eb 9b                	jmp    801018ec <bmap+0x2c>
80101951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101958:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010195b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010195e:	85 db                	test   %ebx,%ebx
80101960:	75 af                	jne    80101911 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101962:	8b 00                	mov    (%eax),%eax
80101964:	e8 57 fd ff ff       	call   801016c0 <balloc>
80101969:	89 47 5c             	mov    %eax,0x5c(%edi)
8010196c:	89 c3                	mov    %eax,%ebx
}
8010196e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101971:	89 d8                	mov    %ebx,%eax
80101973:	5b                   	pop    %ebx
80101974:	5e                   	pop    %esi
80101975:	5f                   	pop    %edi
80101976:	5d                   	pop    %ebp
80101977:	c3                   	ret    
  panic("bmap: out of range");
80101978:	83 ec 0c             	sub    $0xc,%esp
8010197b:	68 8d 7c 10 80       	push   $0x80107c8d
80101980:	e8 0b ea ff ff       	call   80100390 <panic>
80101985:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101990 <readsb>:
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	56                   	push   %esi
80101994:	53                   	push   %ebx
80101995:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	6a 01                	push   $0x1
8010199d:	ff 75 08             	pushl  0x8(%ebp)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801019a5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801019a8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801019aa:	8d 40 5c             	lea    0x5c(%eax),%eax
801019ad:	6a 1c                	push   $0x1c
801019af:	50                   	push   %eax
801019b0:	56                   	push   %esi
801019b1:	e8 9a 34 00 00       	call   80104e50 <memmove>
  brelse(bp);
801019b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019b9:	83 c4 10             	add    $0x10,%esp
}
801019bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019bf:	5b                   	pop    %ebx
801019c0:	5e                   	pop    %esi
801019c1:	5d                   	pop    %ebp
  brelse(bp);
801019c2:	e9 29 e8 ff ff       	jmp    801001f0 <brelse>
801019c7:	89 f6                	mov    %esi,%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801019d0 <bfree>:
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	56                   	push   %esi
801019d4:	89 c6                	mov    %eax,%esi
801019d6:	53                   	push   %ebx
801019d7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801019d9:	83 ec 08             	sub    $0x8,%esp
801019dc:	68 40 aa 11 80       	push   $0x8011aa40
801019e1:	50                   	push   %eax
801019e2:	e8 a9 ff ff ff       	call   80101990 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801019e7:	58                   	pop    %eax
801019e8:	5a                   	pop    %edx
801019e9:	89 da                	mov    %ebx,%edx
801019eb:	c1 ea 0c             	shr    $0xc,%edx
801019ee:	03 15 58 aa 11 80    	add    0x8011aa58,%edx
801019f4:	52                   	push   %edx
801019f5:	56                   	push   %esi
801019f6:	e8 d5 e6 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801019fb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801019fd:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101a00:	ba 01 00 00 00       	mov    $0x1,%edx
80101a05:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101a08:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101a0e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101a11:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101a13:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101a18:	85 d1                	test   %edx,%ecx
80101a1a:	74 25                	je     80101a41 <bfree+0x71>
  bp->data[bi/8] &= ~m;
80101a1c:	f7 d2                	not    %edx
80101a1e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101a20:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101a23:	21 ca                	and    %ecx,%edx
80101a25:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101a29:	56                   	push   %esi
80101a2a:	e8 81 19 00 00       	call   801033b0 <log_write>
  brelse(bp);
80101a2f:	89 34 24             	mov    %esi,(%esp)
80101a32:	e8 b9 e7 ff ff       	call   801001f0 <brelse>
}
80101a37:	83 c4 10             	add    $0x10,%esp
80101a3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a3d:	5b                   	pop    %ebx
80101a3e:	5e                   	pop    %esi
80101a3f:	5d                   	pop    %ebp
80101a40:	c3                   	ret    
    panic("freeing free block");
80101a41:	83 ec 0c             	sub    $0xc,%esp
80101a44:	68 a0 7c 10 80       	push   $0x80107ca0
80101a49:	e8 42 e9 ff ff       	call   80100390 <panic>
80101a4e:	66 90                	xchg   %ax,%ax

80101a50 <iinit>:
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	53                   	push   %ebx
80101a54:	bb a0 aa 11 80       	mov    $0x8011aaa0,%ebx
80101a59:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101a5c:	68 b3 7c 10 80       	push   $0x80107cb3
80101a61:	68 60 aa 11 80       	push   $0x8011aa60
80101a66:	e8 d5 30 00 00       	call   80104b40 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a6b:	83 c4 10             	add    $0x10,%esp
80101a6e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101a70:	83 ec 08             	sub    $0x8,%esp
80101a73:	68 ba 7c 10 80       	push   $0x80107cba
80101a78:	53                   	push   %ebx
80101a79:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101a7f:	e8 ac 2f 00 00       	call   80104a30 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101a84:	83 c4 10             	add    $0x10,%esp
80101a87:	81 fb c0 c6 11 80    	cmp    $0x8011c6c0,%ebx
80101a8d:	75 e1                	jne    80101a70 <iinit+0x20>
  readsb(dev, &sb);
80101a8f:	83 ec 08             	sub    $0x8,%esp
80101a92:	68 40 aa 11 80       	push   $0x8011aa40
80101a97:	ff 75 08             	pushl  0x8(%ebp)
80101a9a:	e8 f1 fe ff ff       	call   80101990 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101a9f:	ff 35 58 aa 11 80    	pushl  0x8011aa58
80101aa5:	ff 35 54 aa 11 80    	pushl  0x8011aa54
80101aab:	ff 35 50 aa 11 80    	pushl  0x8011aa50
80101ab1:	ff 35 4c aa 11 80    	pushl  0x8011aa4c
80101ab7:	ff 35 48 aa 11 80    	pushl  0x8011aa48
80101abd:	ff 35 44 aa 11 80    	pushl  0x8011aa44
80101ac3:	ff 35 40 aa 11 80    	pushl  0x8011aa40
80101ac9:	68 20 7d 10 80       	push   $0x80107d20
80101ace:	e8 cd eb ff ff       	call   801006a0 <cprintf>
}
80101ad3:	83 c4 30             	add    $0x30,%esp
80101ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ad9:	c9                   	leave  
80101ada:	c3                   	ret    
80101adb:	90                   	nop
80101adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ae0 <ialloc>:
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 1c             	sub    $0x1c,%esp
80101ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101aec:	83 3d 48 aa 11 80 01 	cmpl   $0x1,0x8011aa48
{
80101af3:	8b 75 08             	mov    0x8(%ebp),%esi
80101af6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101af9:	0f 86 91 00 00 00    	jbe    80101b90 <ialloc+0xb0>
80101aff:	bb 01 00 00 00       	mov    $0x1,%ebx
80101b04:	eb 21                	jmp    80101b27 <ialloc+0x47>
80101b06:	8d 76 00             	lea    0x0(%esi),%esi
80101b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101b10:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101b13:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101b16:	57                   	push   %edi
80101b17:	e8 d4 e6 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101b1c:	83 c4 10             	add    $0x10,%esp
80101b1f:	3b 1d 48 aa 11 80    	cmp    0x8011aa48,%ebx
80101b25:	73 69                	jae    80101b90 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101b27:	89 d8                	mov    %ebx,%eax
80101b29:	83 ec 08             	sub    $0x8,%esp
80101b2c:	c1 e8 03             	shr    $0x3,%eax
80101b2f:	03 05 54 aa 11 80    	add    0x8011aa54,%eax
80101b35:	50                   	push   %eax
80101b36:	56                   	push   %esi
80101b37:	e8 94 e5 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101b3c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101b3f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101b41:	89 d8                	mov    %ebx,%eax
80101b43:	83 e0 07             	and    $0x7,%eax
80101b46:	c1 e0 06             	shl    $0x6,%eax
80101b49:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101b4d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101b51:	75 bd                	jne    80101b10 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101b53:	83 ec 04             	sub    $0x4,%esp
80101b56:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101b59:	6a 40                	push   $0x40
80101b5b:	6a 00                	push   $0x0
80101b5d:	51                   	push   %ecx
80101b5e:	e8 4d 32 00 00       	call   80104db0 <memset>
      dip->type = type;
80101b63:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101b67:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b6a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101b6d:	89 3c 24             	mov    %edi,(%esp)
80101b70:	e8 3b 18 00 00       	call   801033b0 <log_write>
      brelse(bp);
80101b75:	89 3c 24             	mov    %edi,(%esp)
80101b78:	e8 73 e6 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101b7d:	83 c4 10             	add    $0x10,%esp
}
80101b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101b83:	89 da                	mov    %ebx,%edx
80101b85:	89 f0                	mov    %esi,%eax
}
80101b87:	5b                   	pop    %ebx
80101b88:	5e                   	pop    %esi
80101b89:	5f                   	pop    %edi
80101b8a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101b8b:	e9 40 fc ff ff       	jmp    801017d0 <iget>
  panic("ialloc: no inodes");
80101b90:	83 ec 0c             	sub    $0xc,%esp
80101b93:	68 c0 7c 10 80       	push   $0x80107cc0
80101b98:	e8 f3 e7 ff ff       	call   80100390 <panic>
80101b9d:	8d 76 00             	lea    0x0(%esi),%esi

80101ba0 <iupdate>:
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	56                   	push   %esi
80101ba4:	53                   	push   %ebx
80101ba5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ba8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bab:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bae:	83 ec 08             	sub    $0x8,%esp
80101bb1:	c1 e8 03             	shr    $0x3,%eax
80101bb4:	03 05 54 aa 11 80    	add    0x8011aa54,%eax
80101bba:	50                   	push   %eax
80101bbb:	ff 73 a4             	pushl  -0x5c(%ebx)
80101bbe:	e8 0d e5 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101bc3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bc7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bca:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101bcc:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101bcf:	83 e0 07             	and    $0x7,%eax
80101bd2:	c1 e0 06             	shl    $0x6,%eax
80101bd5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101bd9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101bdc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101be0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101be3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101be7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101beb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101bef:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101bf3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101bf7:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101bfa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bfd:	6a 34                	push   $0x34
80101bff:	53                   	push   %ebx
80101c00:	50                   	push   %eax
80101c01:	e8 4a 32 00 00       	call   80104e50 <memmove>
  log_write(bp);
80101c06:	89 34 24             	mov    %esi,(%esp)
80101c09:	e8 a2 17 00 00       	call   801033b0 <log_write>
  brelse(bp);
80101c0e:	89 75 08             	mov    %esi,0x8(%ebp)
80101c11:	83 c4 10             	add    $0x10,%esp
}
80101c14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c17:	5b                   	pop    %ebx
80101c18:	5e                   	pop    %esi
80101c19:	5d                   	pop    %ebp
  brelse(bp);
80101c1a:	e9 d1 e5 ff ff       	jmp    801001f0 <brelse>
80101c1f:	90                   	nop

80101c20 <idup>:
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	53                   	push   %ebx
80101c24:	83 ec 10             	sub    $0x10,%esp
80101c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101c2a:	68 60 aa 11 80       	push   $0x8011aa60
80101c2f:	e8 0c 30 00 00       	call   80104c40 <acquire>
  ip->ref++;
80101c34:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c38:	c7 04 24 60 aa 11 80 	movl   $0x8011aa60,(%esp)
80101c3f:	e8 1c 31 00 00       	call   80104d60 <release>
}
80101c44:	89 d8                	mov    %ebx,%eax
80101c46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c49:	c9                   	leave  
80101c4a:	c3                   	ret    
80101c4b:	90                   	nop
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c50 <ilock>:
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	56                   	push   %esi
80101c54:	53                   	push   %ebx
80101c55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101c58:	85 db                	test   %ebx,%ebx
80101c5a:	0f 84 b7 00 00 00    	je     80101d17 <ilock+0xc7>
80101c60:	8b 53 08             	mov    0x8(%ebx),%edx
80101c63:	85 d2                	test   %edx,%edx
80101c65:	0f 8e ac 00 00 00    	jle    80101d17 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
80101c6e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101c71:	50                   	push   %eax
80101c72:	e8 f9 2d 00 00       	call   80104a70 <acquiresleep>
  if(ip->valid == 0){
80101c77:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101c7a:	83 c4 10             	add    $0x10,%esp
80101c7d:	85 c0                	test   %eax,%eax
80101c7f:	74 0f                	je     80101c90 <ilock+0x40>
}
80101c81:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c84:	5b                   	pop    %ebx
80101c85:	5e                   	pop    %esi
80101c86:	5d                   	pop    %ebp
80101c87:	c3                   	ret    
80101c88:	90                   	nop
80101c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c90:	8b 43 04             	mov    0x4(%ebx),%eax
80101c93:	83 ec 08             	sub    $0x8,%esp
80101c96:	c1 e8 03             	shr    $0x3,%eax
80101c99:	03 05 54 aa 11 80    	add    0x8011aa54,%eax
80101c9f:	50                   	push   %eax
80101ca0:	ff 33                	pushl  (%ebx)
80101ca2:	e8 29 e4 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ca7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101caa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101cac:	8b 43 04             	mov    0x4(%ebx),%eax
80101caf:	83 e0 07             	and    $0x7,%eax
80101cb2:	c1 e0 06             	shl    $0x6,%eax
80101cb5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101cb9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cbc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101cbf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101cc3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101cc7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101ccb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101ccf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101cd3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101cd7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101cdb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101cde:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ce1:	6a 34                	push   $0x34
80101ce3:	50                   	push   %eax
80101ce4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101ce7:	50                   	push   %eax
80101ce8:	e8 63 31 00 00       	call   80104e50 <memmove>
    brelse(bp);
80101ced:	89 34 24             	mov    %esi,(%esp)
80101cf0:	e8 fb e4 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101cf5:	83 c4 10             	add    $0x10,%esp
80101cf8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101cfd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101d04:	0f 85 77 ff ff ff    	jne    80101c81 <ilock+0x31>
      panic("ilock: no type");
80101d0a:	83 ec 0c             	sub    $0xc,%esp
80101d0d:	68 d8 7c 10 80       	push   $0x80107cd8
80101d12:	e8 79 e6 ff ff       	call   80100390 <panic>
    panic("ilock");
80101d17:	83 ec 0c             	sub    $0xc,%esp
80101d1a:	68 d2 7c 10 80       	push   $0x80107cd2
80101d1f:	e8 6c e6 ff ff       	call   80100390 <panic>
80101d24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101d30 <iunlock>:
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	56                   	push   %esi
80101d34:	53                   	push   %ebx
80101d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d38:	85 db                	test   %ebx,%ebx
80101d3a:	74 28                	je     80101d64 <iunlock+0x34>
80101d3c:	83 ec 0c             	sub    $0xc,%esp
80101d3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d42:	56                   	push   %esi
80101d43:	e8 c8 2d 00 00       	call   80104b10 <holdingsleep>
80101d48:	83 c4 10             	add    $0x10,%esp
80101d4b:	85 c0                	test   %eax,%eax
80101d4d:	74 15                	je     80101d64 <iunlock+0x34>
80101d4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101d52:	85 c0                	test   %eax,%eax
80101d54:	7e 0e                	jle    80101d64 <iunlock+0x34>
  releasesleep(&ip->lock);
80101d56:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101d59:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d5c:	5b                   	pop    %ebx
80101d5d:	5e                   	pop    %esi
80101d5e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101d5f:	e9 6c 2d 00 00       	jmp    80104ad0 <releasesleep>
    panic("iunlock");
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 e7 7c 10 80       	push   $0x80107ce7
80101d6c:	e8 1f e6 ff ff       	call   80100390 <panic>
80101d71:	eb 0d                	jmp    80101d80 <iput>
80101d73:	90                   	nop
80101d74:	90                   	nop
80101d75:	90                   	nop
80101d76:	90                   	nop
80101d77:	90                   	nop
80101d78:	90                   	nop
80101d79:	90                   	nop
80101d7a:	90                   	nop
80101d7b:	90                   	nop
80101d7c:	90                   	nop
80101d7d:	90                   	nop
80101d7e:	90                   	nop
80101d7f:	90                   	nop

80101d80 <iput>:
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	83 ec 28             	sub    $0x28,%esp
80101d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101d8c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101d8f:	57                   	push   %edi
80101d90:	e8 db 2c 00 00       	call   80104a70 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101d95:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101d98:	83 c4 10             	add    $0x10,%esp
80101d9b:	85 d2                	test   %edx,%edx
80101d9d:	74 07                	je     80101da6 <iput+0x26>
80101d9f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101da4:	74 32                	je     80101dd8 <iput+0x58>
  releasesleep(&ip->lock);
80101da6:	83 ec 0c             	sub    $0xc,%esp
80101da9:	57                   	push   %edi
80101daa:	e8 21 2d 00 00       	call   80104ad0 <releasesleep>
  acquire(&icache.lock);
80101daf:	c7 04 24 60 aa 11 80 	movl   $0x8011aa60,(%esp)
80101db6:	e8 85 2e 00 00       	call   80104c40 <acquire>
  ip->ref--;
80101dbb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101dbf:	83 c4 10             	add    $0x10,%esp
80101dc2:	c7 45 08 60 aa 11 80 	movl   $0x8011aa60,0x8(%ebp)
}
80101dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dcc:	5b                   	pop    %ebx
80101dcd:	5e                   	pop    %esi
80101dce:	5f                   	pop    %edi
80101dcf:	5d                   	pop    %ebp
  release(&icache.lock);
80101dd0:	e9 8b 2f 00 00       	jmp    80104d60 <release>
80101dd5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	68 60 aa 11 80       	push   $0x8011aa60
80101de0:	e8 5b 2e 00 00       	call   80104c40 <acquire>
    int r = ip->ref;
80101de5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101de8:	c7 04 24 60 aa 11 80 	movl   $0x8011aa60,(%esp)
80101def:	e8 6c 2f 00 00       	call   80104d60 <release>
    if(r == 1){
80101df4:	83 c4 10             	add    $0x10,%esp
80101df7:	83 fe 01             	cmp    $0x1,%esi
80101dfa:	75 aa                	jne    80101da6 <iput+0x26>
80101dfc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101e02:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101e05:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101e08:	89 cf                	mov    %ecx,%edi
80101e0a:	eb 0b                	jmp    80101e17 <iput+0x97>
80101e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e10:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e13:	39 fe                	cmp    %edi,%esi
80101e15:	74 19                	je     80101e30 <iput+0xb0>
    if(ip->addrs[i]){
80101e17:	8b 16                	mov    (%esi),%edx
80101e19:	85 d2                	test   %edx,%edx
80101e1b:	74 f3                	je     80101e10 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101e1d:	8b 03                	mov    (%ebx),%eax
80101e1f:	e8 ac fb ff ff       	call   801019d0 <bfree>
      ip->addrs[i] = 0;
80101e24:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101e2a:	eb e4                	jmp    80101e10 <iput+0x90>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101e30:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101e36:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101e39:	85 c0                	test   %eax,%eax
80101e3b:	75 33                	jne    80101e70 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101e3d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101e40:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101e47:	53                   	push   %ebx
80101e48:	e8 53 fd ff ff       	call   80101ba0 <iupdate>
      ip->type = 0;
80101e4d:	31 c0                	xor    %eax,%eax
80101e4f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101e53:	89 1c 24             	mov    %ebx,(%esp)
80101e56:	e8 45 fd ff ff       	call   80101ba0 <iupdate>
      ip->valid = 0;
80101e5b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	e9 3c ff ff ff       	jmp    80101da6 <iput+0x26>
80101e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e70:	83 ec 08             	sub    $0x8,%esp
80101e73:	50                   	push   %eax
80101e74:	ff 33                	pushl  (%ebx)
80101e76:	e8 55 e2 ff ff       	call   801000d0 <bread>
80101e7b:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e7e:	83 c4 10             	add    $0x10,%esp
80101e81:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101e87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e8a:	8d 70 5c             	lea    0x5c(%eax),%esi
80101e8d:	89 cf                	mov    %ecx,%edi
80101e8f:	eb 0e                	jmp    80101e9f <iput+0x11f>
80101e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e98:	83 c6 04             	add    $0x4,%esi
80101e9b:	39 f7                	cmp    %esi,%edi
80101e9d:	74 11                	je     80101eb0 <iput+0x130>
      if(a[j])
80101e9f:	8b 16                	mov    (%esi),%edx
80101ea1:	85 d2                	test   %edx,%edx
80101ea3:	74 f3                	je     80101e98 <iput+0x118>
        bfree(ip->dev, a[j]);
80101ea5:	8b 03                	mov    (%ebx),%eax
80101ea7:	e8 24 fb ff ff       	call   801019d0 <bfree>
80101eac:	eb ea                	jmp    80101e98 <iput+0x118>
80101eae:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101eb0:	83 ec 0c             	sub    $0xc,%esp
80101eb3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eb6:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101eb9:	e8 32 e3 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ebe:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101ec4:	8b 03                	mov    (%ebx),%eax
80101ec6:	e8 05 fb ff ff       	call   801019d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101ecb:	83 c4 10             	add    $0x10,%esp
80101ece:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ed5:	00 00 00 
80101ed8:	e9 60 ff ff ff       	jmp    80101e3d <iput+0xbd>
80101edd:	8d 76 00             	lea    0x0(%esi),%esi

80101ee0 <iunlockput>:
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	53                   	push   %ebx
80101ee4:	83 ec 10             	sub    $0x10,%esp
80101ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101eea:	53                   	push   %ebx
80101eeb:	e8 40 fe ff ff       	call   80101d30 <iunlock>
  iput(ip);
80101ef0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ef3:	83 c4 10             	add    $0x10,%esp
}
80101ef6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ef9:	c9                   	leave  
  iput(ip);
80101efa:	e9 81 fe ff ff       	jmp    80101d80 <iput>
80101eff:	90                   	nop

80101f00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	8b 55 08             	mov    0x8(%ebp),%edx
80101f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f09:	8b 0a                	mov    (%edx),%ecx
80101f0b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f0e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f11:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f14:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f18:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f1b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101f1f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101f23:	8b 52 58             	mov    0x58(%edx),%edx
80101f26:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f29:	5d                   	pop    %ebp
80101f2a:	c3                   	ret    
80101f2b:	90                   	nop
80101f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f30 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 1c             	sub    $0x1c,%esp
80101f39:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101f3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f47:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101f4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101f50:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101f53:	0f 84 a7 00 00 00    	je     80102000 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101f59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f5c:	8b 40 58             	mov    0x58(%eax),%eax
80101f5f:	39 c6                	cmp    %eax,%esi
80101f61:	0f 87 ba 00 00 00    	ja     80102021 <readi+0xf1>
80101f67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101f6a:	89 f9                	mov    %edi,%ecx
80101f6c:	01 f1                	add    %esi,%ecx
80101f6e:	0f 82 ad 00 00 00    	jb     80102021 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101f74:	89 c2                	mov    %eax,%edx
80101f76:	29 f2                	sub    %esi,%edx
80101f78:	39 c8                	cmp    %ecx,%eax
80101f7a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f7d:	31 ff                	xor    %edi,%edi
    n = ip->size - off;
80101f7f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f82:	85 d2                	test   %edx,%edx
80101f84:	74 6c                	je     80101ff2 <readi+0xc2>
80101f86:	8d 76 00             	lea    0x0(%esi),%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f90:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101f93:	89 f2                	mov    %esi,%edx
80101f95:	c1 ea 09             	shr    $0x9,%edx
80101f98:	89 d8                	mov    %ebx,%eax
80101f9a:	e8 21 f9 ff ff       	call   801018c0 <bmap>
80101f9f:	83 ec 08             	sub    $0x8,%esp
80101fa2:	50                   	push   %eax
80101fa3:	ff 33                	pushl  (%ebx)
80101fa5:	e8 26 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101faa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101fad:	b9 00 02 00 00       	mov    $0x200,%ecx
80101fb2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fb5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101fb7:	89 f0                	mov    %esi,%eax
80101fb9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fbe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101fc0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101fc5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc9:	39 d9                	cmp    %ebx,%ecx
80101fcb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101fce:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fcf:	01 df                	add    %ebx,%edi
80101fd1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101fd3:	50                   	push   %eax
80101fd4:	ff 75 e0             	pushl  -0x20(%ebp)
80101fd7:	e8 74 2e 00 00       	call   80104e50 <memmove>
    brelse(bp);
80101fdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fdf:	89 14 24             	mov    %edx,(%esp)
80101fe2:	e8 09 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fe7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101fea:	83 c4 10             	add    $0x10,%esp
80101fed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ff0:	77 9e                	ja     80101f90 <readi+0x60>
  }
  return n;
80101ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
80101ffd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102000:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102004:	66 83 f8 09          	cmp    $0x9,%ax
80102008:	77 17                	ja     80102021 <readi+0xf1>
8010200a:	8b 04 c5 e0 a9 11 80 	mov    -0x7fee5620(,%eax,8),%eax
80102011:	85 c0                	test   %eax,%eax
80102013:	74 0c                	je     80102021 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102015:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010201b:	5b                   	pop    %ebx
8010201c:	5e                   	pop    %esi
8010201d:	5f                   	pop    %edi
8010201e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010201f:	ff e0                	jmp    *%eax
      return -1;
80102021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102026:	eb cd                	jmp    80101ff5 <readi+0xc5>
80102028:	90                   	nop
80102029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102030 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 1c             	sub    $0x1c,%esp
80102039:	8b 45 08             	mov    0x8(%ebp),%eax
8010203c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010203f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102042:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102047:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010204a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010204d:	8b 75 10             	mov    0x10(%ebp),%esi
80102050:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80102053:	0f 84 b7 00 00 00    	je     80102110 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102059:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010205c:	39 70 58             	cmp    %esi,0x58(%eax)
8010205f:	0f 82 e7 00 00 00    	jb     8010214c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102065:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102068:	89 f8                	mov    %edi,%eax
8010206a:	01 f0                	add    %esi,%eax
8010206c:	0f 82 da 00 00 00    	jb     8010214c <writei+0x11c>
80102072:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102077:	0f 87 cf 00 00 00    	ja     8010214c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010207d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102084:	85 ff                	test   %edi,%edi
80102086:	74 79                	je     80102101 <writei+0xd1>
80102088:	90                   	nop
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102090:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102093:	89 f2                	mov    %esi,%edx
80102095:	c1 ea 09             	shr    $0x9,%edx
80102098:	89 f8                	mov    %edi,%eax
8010209a:	e8 21 f8 ff ff       	call   801018c0 <bmap>
8010209f:	83 ec 08             	sub    $0x8,%esp
801020a2:	50                   	push   %eax
801020a3:	ff 37                	pushl  (%edi)
801020a5:	e8 26 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801020aa:	b9 00 02 00 00       	mov    $0x200,%ecx
801020af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801020b2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020b5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801020b7:	89 f0                	mov    %esi,%eax
801020b9:	83 c4 0c             	add    $0xc,%esp
801020bc:	25 ff 01 00 00       	and    $0x1ff,%eax
801020c1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801020c3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801020c7:	39 d9                	cmp    %ebx,%ecx
801020c9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801020cc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020cd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
801020cf:	ff 75 dc             	pushl  -0x24(%ebp)
801020d2:	50                   	push   %eax
801020d3:	e8 78 2d 00 00       	call   80104e50 <memmove>
    log_write(bp);
801020d8:	89 3c 24             	mov    %edi,(%esp)
801020db:	e8 d0 12 00 00       	call   801033b0 <log_write>
    brelse(bp);
801020e0:	89 3c 24             	mov    %edi,(%esp)
801020e3:	e8 08 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020e8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801020eb:	83 c4 10             	add    $0x10,%esp
801020ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801020f1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801020f4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801020f7:	77 97                	ja     80102090 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
801020f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801020fc:	3b 70 58             	cmp    0x58(%eax),%esi
801020ff:	77 37                	ja     80102138 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102101:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102104:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102107:	5b                   	pop    %ebx
80102108:	5e                   	pop    %esi
80102109:	5f                   	pop    %edi
8010210a:	5d                   	pop    %ebp
8010210b:	c3                   	ret    
8010210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102110:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102114:	66 83 f8 09          	cmp    $0x9,%ax
80102118:	77 32                	ja     8010214c <writei+0x11c>
8010211a:	8b 04 c5 e4 a9 11 80 	mov    -0x7fee561c(,%eax,8),%eax
80102121:	85 c0                	test   %eax,%eax
80102123:	74 27                	je     8010214c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102125:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102128:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010212b:	5b                   	pop    %ebx
8010212c:	5e                   	pop    %esi
8010212d:	5f                   	pop    %edi
8010212e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010212f:	ff e0                	jmp    *%eax
80102131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102138:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010213b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010213e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102141:	50                   	push   %eax
80102142:	e8 59 fa ff ff       	call   80101ba0 <iupdate>
80102147:	83 c4 10             	add    $0x10,%esp
8010214a:	eb b5                	jmp    80102101 <writei+0xd1>
      return -1;
8010214c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102151:	eb b1                	jmp    80102104 <writei+0xd4>
80102153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102160 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102166:	6a 0e                	push   $0xe
80102168:	ff 75 0c             	pushl  0xc(%ebp)
8010216b:	ff 75 08             	pushl  0x8(%ebp)
8010216e:	e8 4d 2d 00 00       	call   80104ec0 <strncmp>
}
80102173:	c9                   	leave  
80102174:	c3                   	ret    
80102175:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102180 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102180:	55                   	push   %ebp
80102181:	89 e5                	mov    %esp,%ebp
80102183:	57                   	push   %edi
80102184:	56                   	push   %esi
80102185:	53                   	push   %ebx
80102186:	83 ec 1c             	sub    $0x1c,%esp
80102189:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010218c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102191:	0f 85 85 00 00 00    	jne    8010221c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102197:	8b 53 58             	mov    0x58(%ebx),%edx
8010219a:	31 ff                	xor    %edi,%edi
8010219c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010219f:	85 d2                	test   %edx,%edx
801021a1:	74 3e                	je     801021e1 <dirlookup+0x61>
801021a3:	90                   	nop
801021a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021a8:	6a 10                	push   $0x10
801021aa:	57                   	push   %edi
801021ab:	56                   	push   %esi
801021ac:	53                   	push   %ebx
801021ad:	e8 7e fd ff ff       	call   80101f30 <readi>
801021b2:	83 c4 10             	add    $0x10,%esp
801021b5:	83 f8 10             	cmp    $0x10,%eax
801021b8:	75 55                	jne    8010220f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801021ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021bf:	74 18                	je     801021d9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
801021c1:	83 ec 04             	sub    $0x4,%esp
801021c4:	8d 45 da             	lea    -0x26(%ebp),%eax
801021c7:	6a 0e                	push   $0xe
801021c9:	50                   	push   %eax
801021ca:	ff 75 0c             	pushl  0xc(%ebp)
801021cd:	e8 ee 2c 00 00       	call   80104ec0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801021d2:	83 c4 10             	add    $0x10,%esp
801021d5:	85 c0                	test   %eax,%eax
801021d7:	74 17                	je     801021f0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021d9:	83 c7 10             	add    $0x10,%edi
801021dc:	3b 7b 58             	cmp    0x58(%ebx),%edi
801021df:	72 c7                	jb     801021a8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801021e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801021e4:	31 c0                	xor    %eax,%eax
}
801021e6:	5b                   	pop    %ebx
801021e7:	5e                   	pop    %esi
801021e8:	5f                   	pop    %edi
801021e9:	5d                   	pop    %ebp
801021ea:	c3                   	ret    
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
801021f0:	8b 45 10             	mov    0x10(%ebp),%eax
801021f3:	85 c0                	test   %eax,%eax
801021f5:	74 05                	je     801021fc <dirlookup+0x7c>
        *poff = off;
801021f7:	8b 45 10             	mov    0x10(%ebp),%eax
801021fa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801021fc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102200:	8b 03                	mov    (%ebx),%eax
80102202:	e8 c9 f5 ff ff       	call   801017d0 <iget>
}
80102207:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010220a:	5b                   	pop    %ebx
8010220b:	5e                   	pop    %esi
8010220c:	5f                   	pop    %edi
8010220d:	5d                   	pop    %ebp
8010220e:	c3                   	ret    
      panic("dirlookup read");
8010220f:	83 ec 0c             	sub    $0xc,%esp
80102212:	68 01 7d 10 80       	push   $0x80107d01
80102217:	e8 74 e1 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
8010221c:	83 ec 0c             	sub    $0xc,%esp
8010221f:	68 ef 7c 10 80       	push   $0x80107cef
80102224:	e8 67 e1 ff ff       	call   80100390 <panic>
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102230 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	89 c3                	mov    %eax,%ebx
80102238:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010223b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010223e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102241:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102244:	0f 84 86 01 00 00    	je     801023d0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010224a:	e8 31 1c 00 00       	call   80103e80 <myproc>
  acquire(&icache.lock);
8010224f:	83 ec 0c             	sub    $0xc,%esp
80102252:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102254:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102257:	68 60 aa 11 80       	push   $0x8011aa60
8010225c:	e8 df 29 00 00       	call   80104c40 <acquire>
  ip->ref++;
80102261:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102265:	c7 04 24 60 aa 11 80 	movl   $0x8011aa60,(%esp)
8010226c:	e8 ef 2a 00 00       	call   80104d60 <release>
80102271:	83 c4 10             	add    $0x10,%esp
80102274:	eb 0d                	jmp    80102283 <namex+0x53>
80102276:	8d 76 00             	lea    0x0(%esi),%esi
80102279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102280:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102283:	0f b6 07             	movzbl (%edi),%eax
80102286:	3c 2f                	cmp    $0x2f,%al
80102288:	74 f6                	je     80102280 <namex+0x50>
  if(*path == 0)
8010228a:	84 c0                	test   %al,%al
8010228c:	0f 84 ee 00 00 00    	je     80102380 <namex+0x150>
  while(*path != '/' && *path != 0)
80102292:	0f b6 07             	movzbl (%edi),%eax
80102295:	3c 2f                	cmp    $0x2f,%al
80102297:	0f 84 fb 00 00 00    	je     80102398 <namex+0x168>
8010229d:	89 fb                	mov    %edi,%ebx
8010229f:	84 c0                	test   %al,%al
801022a1:	0f 84 f1 00 00 00    	je     80102398 <namex+0x168>
801022a7:	89 f6                	mov    %esi,%esi
801022a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
801022b0:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
801022b3:	0f b6 03             	movzbl (%ebx),%eax
801022b6:	3c 2f                	cmp    $0x2f,%al
801022b8:	74 04                	je     801022be <namex+0x8e>
801022ba:	84 c0                	test   %al,%al
801022bc:	75 f2                	jne    801022b0 <namex+0x80>
  len = path - s;
801022be:	89 d8                	mov    %ebx,%eax
801022c0:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
801022c2:	83 f8 0d             	cmp    $0xd,%eax
801022c5:	0f 8e 85 00 00 00    	jle    80102350 <namex+0x120>
    memmove(name, s, DIRSIZ);
801022cb:	83 ec 04             	sub    $0x4,%esp
801022ce:	6a 0e                	push   $0xe
801022d0:	57                   	push   %edi
    path++;
801022d1:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
801022d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801022d6:	e8 75 2b 00 00       	call   80104e50 <memmove>
801022db:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801022de:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801022e1:	75 0d                	jne    801022f0 <namex+0xc0>
801022e3:	90                   	nop
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801022e8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801022eb:	80 3f 2f             	cmpb   $0x2f,(%edi)
801022ee:	74 f8                	je     801022e8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801022f0:	83 ec 0c             	sub    $0xc,%esp
801022f3:	56                   	push   %esi
801022f4:	e8 57 f9 ff ff       	call   80101c50 <ilock>
    if(ip->type != T_DIR){
801022f9:	83 c4 10             	add    $0x10,%esp
801022fc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102301:	0f 85 a1 00 00 00    	jne    801023a8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102307:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010230a:	85 d2                	test   %edx,%edx
8010230c:	74 09                	je     80102317 <namex+0xe7>
8010230e:	80 3f 00             	cmpb   $0x0,(%edi)
80102311:	0f 84 d9 00 00 00    	je     801023f0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102317:	83 ec 04             	sub    $0x4,%esp
8010231a:	6a 00                	push   $0x0
8010231c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010231f:	56                   	push   %esi
80102320:	e8 5b fe ff ff       	call   80102180 <dirlookup>
80102325:	83 c4 10             	add    $0x10,%esp
80102328:	89 c3                	mov    %eax,%ebx
8010232a:	85 c0                	test   %eax,%eax
8010232c:	74 7a                	je     801023a8 <namex+0x178>
  iunlock(ip);
8010232e:	83 ec 0c             	sub    $0xc,%esp
80102331:	56                   	push   %esi
80102332:	e8 f9 f9 ff ff       	call   80101d30 <iunlock>
  iput(ip);
80102337:	89 34 24             	mov    %esi,(%esp)
8010233a:	89 de                	mov    %ebx,%esi
8010233c:	e8 3f fa ff ff       	call   80101d80 <iput>
  while(*path == '/')
80102341:	83 c4 10             	add    $0x10,%esp
80102344:	e9 3a ff ff ff       	jmp    80102283 <namex+0x53>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102350:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102353:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102356:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102359:	83 ec 04             	sub    $0x4,%esp
8010235c:	50                   	push   %eax
8010235d:	57                   	push   %edi
    name[len] = 0;
8010235e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102360:	ff 75 e4             	pushl  -0x1c(%ebp)
80102363:	e8 e8 2a 00 00       	call   80104e50 <memmove>
    name[len] = 0;
80102368:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010236b:	83 c4 10             	add    $0x10,%esp
8010236e:	c6 00 00             	movb   $0x0,(%eax)
80102371:	e9 68 ff ff ff       	jmp    801022de <namex+0xae>
80102376:	8d 76 00             	lea    0x0(%esi),%esi
80102379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102380:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102383:	85 c0                	test   %eax,%eax
80102385:	0f 85 85 00 00 00    	jne    80102410 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010238b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010238e:	89 f0                	mov    %esi,%eax
80102390:	5b                   	pop    %ebx
80102391:	5e                   	pop    %esi
80102392:	5f                   	pop    %edi
80102393:	5d                   	pop    %ebp
80102394:	c3                   	ret    
80102395:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102398:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010239b:	89 fb                	mov    %edi,%ebx
8010239d:	89 45 dc             	mov    %eax,-0x24(%ebp)
801023a0:	31 c0                	xor    %eax,%eax
801023a2:	eb b5                	jmp    80102359 <namex+0x129>
801023a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801023a8:	83 ec 0c             	sub    $0xc,%esp
801023ab:	56                   	push   %esi
801023ac:	e8 7f f9 ff ff       	call   80101d30 <iunlock>
  iput(ip);
801023b1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801023b4:	31 f6                	xor    %esi,%esi
  iput(ip);
801023b6:	e8 c5 f9 ff ff       	call   80101d80 <iput>
      return 0;
801023bb:	83 c4 10             	add    $0x10,%esp
}
801023be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023c1:	89 f0                	mov    %esi,%eax
801023c3:	5b                   	pop    %ebx
801023c4:	5e                   	pop    %esi
801023c5:	5f                   	pop    %edi
801023c6:	5d                   	pop    %ebp
801023c7:	c3                   	ret    
801023c8:	90                   	nop
801023c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip = iget(ROOTDEV, ROOTINO);
801023d0:	ba 01 00 00 00       	mov    $0x1,%edx
801023d5:	b8 01 00 00 00       	mov    $0x1,%eax
801023da:	89 df                	mov    %ebx,%edi
801023dc:	e8 ef f3 ff ff       	call   801017d0 <iget>
801023e1:	89 c6                	mov    %eax,%esi
801023e3:	e9 9b fe ff ff       	jmp    80102283 <namex+0x53>
801023e8:	90                   	nop
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      iunlock(ip);
801023f0:	83 ec 0c             	sub    $0xc,%esp
801023f3:	56                   	push   %esi
801023f4:	e8 37 f9 ff ff       	call   80101d30 <iunlock>
      return ip;
801023f9:	83 c4 10             	add    $0x10,%esp
}
801023fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023ff:	89 f0                	mov    %esi,%eax
80102401:	5b                   	pop    %ebx
80102402:	5e                   	pop    %esi
80102403:	5f                   	pop    %edi
80102404:	5d                   	pop    %ebp
80102405:	c3                   	ret    
80102406:	8d 76 00             	lea    0x0(%esi),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iput(ip);
80102410:	83 ec 0c             	sub    $0xc,%esp
80102413:	56                   	push   %esi
    return 0;
80102414:	31 f6                	xor    %esi,%esi
    iput(ip);
80102416:	e8 65 f9 ff ff       	call   80101d80 <iput>
    return 0;
8010241b:	83 c4 10             	add    $0x10,%esp
8010241e:	e9 68 ff ff ff       	jmp    8010238b <namex+0x15b>
80102423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <dirlink>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	57                   	push   %edi
80102434:	56                   	push   %esi
80102435:	53                   	push   %ebx
80102436:	83 ec 20             	sub    $0x20,%esp
80102439:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010243c:	6a 00                	push   $0x0
8010243e:	ff 75 0c             	pushl  0xc(%ebp)
80102441:	53                   	push   %ebx
80102442:	e8 39 fd ff ff       	call   80102180 <dirlookup>
80102447:	83 c4 10             	add    $0x10,%esp
8010244a:	85 c0                	test   %eax,%eax
8010244c:	75 67                	jne    801024b5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010244e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102451:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102454:	85 ff                	test   %edi,%edi
80102456:	74 29                	je     80102481 <dirlink+0x51>
80102458:	31 ff                	xor    %edi,%edi
8010245a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010245d:	eb 09                	jmp    80102468 <dirlink+0x38>
8010245f:	90                   	nop
80102460:	83 c7 10             	add    $0x10,%edi
80102463:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102466:	73 19                	jae    80102481 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102468:	6a 10                	push   $0x10
8010246a:	57                   	push   %edi
8010246b:	56                   	push   %esi
8010246c:	53                   	push   %ebx
8010246d:	e8 be fa ff ff       	call   80101f30 <readi>
80102472:	83 c4 10             	add    $0x10,%esp
80102475:	83 f8 10             	cmp    $0x10,%eax
80102478:	75 4e                	jne    801024c8 <dirlink+0x98>
    if(de.inum == 0)
8010247a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010247f:	75 df                	jne    80102460 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102481:	83 ec 04             	sub    $0x4,%esp
80102484:	8d 45 da             	lea    -0x26(%ebp),%eax
80102487:	6a 0e                	push   $0xe
80102489:	ff 75 0c             	pushl  0xc(%ebp)
8010248c:	50                   	push   %eax
8010248d:	e8 8e 2a 00 00       	call   80104f20 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102492:	6a 10                	push   $0x10
  de.inum = inum;
80102494:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102497:	57                   	push   %edi
80102498:	56                   	push   %esi
80102499:	53                   	push   %ebx
  de.inum = inum;
8010249a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010249e:	e8 8d fb ff ff       	call   80102030 <writei>
801024a3:	83 c4 20             	add    $0x20,%esp
801024a6:	83 f8 10             	cmp    $0x10,%eax
801024a9:	75 2a                	jne    801024d5 <dirlink+0xa5>
  return 0;
801024ab:	31 c0                	xor    %eax,%eax
}
801024ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024b0:	5b                   	pop    %ebx
801024b1:	5e                   	pop    %esi
801024b2:	5f                   	pop    %edi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
    iput(ip);
801024b5:	83 ec 0c             	sub    $0xc,%esp
801024b8:	50                   	push   %eax
801024b9:	e8 c2 f8 ff ff       	call   80101d80 <iput>
    return -1;
801024be:	83 c4 10             	add    $0x10,%esp
801024c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024c6:	eb e5                	jmp    801024ad <dirlink+0x7d>
      panic("dirlink read");
801024c8:	83 ec 0c             	sub    $0xc,%esp
801024cb:	68 10 7d 10 80       	push   $0x80107d10
801024d0:	e8 bb de ff ff       	call   80100390 <panic>
    panic("dirlink");
801024d5:	83 ec 0c             	sub    $0xc,%esp
801024d8:	68 1e 83 10 80       	push   $0x8010831e
801024dd:	e8 ae de ff ff       	call   80100390 <panic>
801024e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <namei>:

struct inode*
namei(char *path)
{
801024f0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024f1:	31 d2                	xor    %edx,%edx
{
801024f3:	89 e5                	mov    %esp,%ebp
801024f5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801024f8:	8b 45 08             	mov    0x8(%ebp),%eax
801024fb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801024fe:	e8 2d fd ff ff       	call   80102230 <namex>
}
80102503:	c9                   	leave  
80102504:	c3                   	ret    
80102505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102510 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102510:	55                   	push   %ebp
  return namex(path, 1, name);
80102511:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102516:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102518:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010251b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010251e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010251f:	e9 0c fd ff ff       	jmp    80102230 <namex>
80102524:	66 90                	xchg   %ax,%ax
80102526:	66 90                	xchg   %ax,%ax
80102528:	66 90                	xchg   %ax,%ax
8010252a:	66 90                	xchg   %ax,%ax
8010252c:	66 90                	xchg   %ax,%ax
8010252e:	66 90                	xchg   %ax,%ax

80102530 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	57                   	push   %edi
80102534:	56                   	push   %esi
80102535:	53                   	push   %ebx
80102536:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102539:	85 c0                	test   %eax,%eax
8010253b:	0f 84 b4 00 00 00    	je     801025f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102541:	8b 70 08             	mov    0x8(%eax),%esi
80102544:	89 c3                	mov    %eax,%ebx
80102546:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010254c:	0f 87 96 00 00 00    	ja     801025e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102552:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102557:	89 f6                	mov    %esi,%esi
80102559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102560:	89 ca                	mov    %ecx,%edx
80102562:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102563:	83 e0 c0             	and    $0xffffffc0,%eax
80102566:	3c 40                	cmp    $0x40,%al
80102568:	75 f6                	jne    80102560 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010256a:	31 ff                	xor    %edi,%edi
8010256c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102571:	89 f8                	mov    %edi,%eax
80102573:	ee                   	out    %al,(%dx)
80102574:	b8 01 00 00 00       	mov    $0x1,%eax
80102579:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010257e:	ee                   	out    %al,(%dx)
8010257f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102584:	89 f0                	mov    %esi,%eax
80102586:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102587:	89 f0                	mov    %esi,%eax
80102589:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010258e:	c1 f8 08             	sar    $0x8,%eax
80102591:	ee                   	out    %al,(%dx)
80102592:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102597:	89 f8                	mov    %edi,%eax
80102599:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010259a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010259e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025a3:	c1 e0 04             	shl    $0x4,%eax
801025a6:	83 e0 10             	and    $0x10,%eax
801025a9:	83 c8 e0             	or     $0xffffffe0,%eax
801025ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801025ad:	f6 03 04             	testb  $0x4,(%ebx)
801025b0:	75 16                	jne    801025c8 <idestart+0x98>
801025b2:	b8 20 00 00 00       	mov    $0x20,%eax
801025b7:	89 ca                	mov    %ecx,%edx
801025b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801025ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025bd:	5b                   	pop    %ebx
801025be:	5e                   	pop    %esi
801025bf:	5f                   	pop    %edi
801025c0:	5d                   	pop    %ebp
801025c1:	c3                   	ret    
801025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025c8:	b8 30 00 00 00       	mov    $0x30,%eax
801025cd:	89 ca                	mov    %ecx,%edx
801025cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801025d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801025d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801025d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025dd:	fc                   	cld    
801025de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801025e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025e3:	5b                   	pop    %ebx
801025e4:	5e                   	pop    %esi
801025e5:	5f                   	pop    %edi
801025e6:	5d                   	pop    %ebp
801025e7:	c3                   	ret    
    panic("incorrect blockno");
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	68 7c 7d 10 80       	push   $0x80107d7c
801025f0:	e8 9b dd ff ff       	call   80100390 <panic>
    panic("idestart");
801025f5:	83 ec 0c             	sub    $0xc,%esp
801025f8:	68 73 7d 10 80       	push   $0x80107d73
801025fd:	e8 8e dd ff ff       	call   80100390 <panic>
80102602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <ideinit>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102616:	68 8e 7d 10 80       	push   $0x80107d8e
8010261b:	68 a0 b5 10 80       	push   $0x8010b5a0
80102620:	e8 1b 25 00 00       	call   80104b40 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102625:	58                   	pop    %eax
80102626:	a1 c0 cd 11 80       	mov    0x8011cdc0,%eax
8010262b:	5a                   	pop    %edx
8010262c:	83 e8 01             	sub    $0x1,%eax
8010262f:	50                   	push   %eax
80102630:	6a 0e                	push   $0xe
80102632:	e8 a9 02 00 00       	call   801028e0 <ioapicenable>
80102637:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010263a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010263f:	90                   	nop
80102640:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102641:	83 e0 c0             	and    $0xffffffc0,%eax
80102644:	3c 40                	cmp    $0x40,%al
80102646:	75 f8                	jne    80102640 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102648:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010264d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102652:	ee                   	out    %al,(%dx)
80102653:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102658:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010265d:	eb 06                	jmp    80102665 <ideinit+0x55>
8010265f:	90                   	nop
  for(i=0; i<1000; i++){
80102660:	83 e9 01             	sub    $0x1,%ecx
80102663:	74 0f                	je     80102674 <ideinit+0x64>
80102665:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102666:	84 c0                	test   %al,%al
80102668:	74 f6                	je     80102660 <ideinit+0x50>
      havedisk1 = 1;
8010266a:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
80102671:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102674:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102679:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010267e:	ee                   	out    %al,(%dx)
}
8010267f:	c9                   	leave  
80102680:	c3                   	ret    
80102681:	eb 0d                	jmp    80102690 <ideintr>
80102683:	90                   	nop
80102684:	90                   	nop
80102685:	90                   	nop
80102686:	90                   	nop
80102687:	90                   	nop
80102688:	90                   	nop
80102689:	90                   	nop
8010268a:	90                   	nop
8010268b:	90                   	nop
8010268c:	90                   	nop
8010268d:	90                   	nop
8010268e:	90                   	nop
8010268f:	90                   	nop

80102690 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	57                   	push   %edi
80102694:	56                   	push   %esi
80102695:	53                   	push   %ebx
80102696:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102699:	68 a0 b5 10 80       	push   $0x8010b5a0
8010269e:	e8 9d 25 00 00       	call   80104c40 <acquire>

  if((b = idequeue) == 0){
801026a3:	8b 1d 84 b5 10 80    	mov    0x8010b584,%ebx
801026a9:	83 c4 10             	add    $0x10,%esp
801026ac:	85 db                	test   %ebx,%ebx
801026ae:	74 63                	je     80102713 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801026b0:	8b 43 58             	mov    0x58(%ebx),%eax
801026b3:	a3 84 b5 10 80       	mov    %eax,0x8010b584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801026b8:	8b 33                	mov    (%ebx),%esi
801026ba:	f7 c6 04 00 00 00    	test   $0x4,%esi
801026c0:	75 2f                	jne    801026f1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026c7:	89 f6                	mov    %esi,%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801026d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026d1:	89 c1                	mov    %eax,%ecx
801026d3:	83 e1 c0             	and    $0xffffffc0,%ecx
801026d6:	80 f9 40             	cmp    $0x40,%cl
801026d9:	75 f5                	jne    801026d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026db:	a8 21                	test   $0x21,%al
801026dd:	75 12                	jne    801026f1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801026df:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801026e2:	b9 80 00 00 00       	mov    $0x80,%ecx
801026e7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801026ec:	fc                   	cld    
801026ed:	f3 6d                	rep insl (%dx),%es:(%edi)
801026ef:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801026f1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801026f4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801026f7:	83 ce 02             	or     $0x2,%esi
801026fa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801026fc:	53                   	push   %ebx
801026fd:	e8 be 21 00 00       	call   801048c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102702:	a1 84 b5 10 80       	mov    0x8010b584,%eax
80102707:	83 c4 10             	add    $0x10,%esp
8010270a:	85 c0                	test   %eax,%eax
8010270c:	74 05                	je     80102713 <ideintr+0x83>
    idestart(idequeue);
8010270e:	e8 1d fe ff ff       	call   80102530 <idestart>
    release(&idelock);
80102713:	83 ec 0c             	sub    $0xc,%esp
80102716:	68 a0 b5 10 80       	push   $0x8010b5a0
8010271b:	e8 40 26 00 00       	call   80104d60 <release>

  release(&idelock);
}
80102720:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102723:	5b                   	pop    %ebx
80102724:	5e                   	pop    %esi
80102725:	5f                   	pop    %edi
80102726:	5d                   	pop    %ebp
80102727:	c3                   	ret    
80102728:	90                   	nop
80102729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102730 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	53                   	push   %ebx
80102734:	83 ec 10             	sub    $0x10,%esp
80102737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010273a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010273d:	50                   	push   %eax
8010273e:	e8 cd 23 00 00       	call   80104b10 <holdingsleep>
80102743:	83 c4 10             	add    $0x10,%esp
80102746:	85 c0                	test   %eax,%eax
80102748:	0f 84 d3 00 00 00    	je     80102821 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010274e:	8b 03                	mov    (%ebx),%eax
80102750:	83 e0 06             	and    $0x6,%eax
80102753:	83 f8 02             	cmp    $0x2,%eax
80102756:	0f 84 b8 00 00 00    	je     80102814 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010275c:	8b 53 04             	mov    0x4(%ebx),%edx
8010275f:	85 d2                	test   %edx,%edx
80102761:	74 0d                	je     80102770 <iderw+0x40>
80102763:	a1 80 b5 10 80       	mov    0x8010b580,%eax
80102768:	85 c0                	test   %eax,%eax
8010276a:	0f 84 97 00 00 00    	je     80102807 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102770:	83 ec 0c             	sub    $0xc,%esp
80102773:	68 a0 b5 10 80       	push   $0x8010b5a0
80102778:	e8 c3 24 00 00       	call   80104c40 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010277d:	8b 15 84 b5 10 80    	mov    0x8010b584,%edx
  b->qnext = 0;
80102783:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010278a:	83 c4 10             	add    $0x10,%esp
8010278d:	85 d2                	test   %edx,%edx
8010278f:	75 09                	jne    8010279a <iderw+0x6a>
80102791:	eb 6d                	jmp    80102800 <iderw+0xd0>
80102793:	90                   	nop
80102794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102798:	89 c2                	mov    %eax,%edx
8010279a:	8b 42 58             	mov    0x58(%edx),%eax
8010279d:	85 c0                	test   %eax,%eax
8010279f:	75 f7                	jne    80102798 <iderw+0x68>
801027a1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801027a4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801027a6:	39 1d 84 b5 10 80    	cmp    %ebx,0x8010b584
801027ac:	74 42                	je     801027f0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027ae:	8b 03                	mov    (%ebx),%eax
801027b0:	83 e0 06             	and    $0x6,%eax
801027b3:	83 f8 02             	cmp    $0x2,%eax
801027b6:	74 23                	je     801027db <iderw+0xab>
801027b8:	90                   	nop
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801027c0:	83 ec 08             	sub    $0x8,%esp
801027c3:	68 a0 b5 10 80       	push   $0x8010b5a0
801027c8:	53                   	push   %ebx
801027c9:	e8 32 1f 00 00       	call   80104700 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027ce:	8b 03                	mov    (%ebx),%eax
801027d0:	83 c4 10             	add    $0x10,%esp
801027d3:	83 e0 06             	and    $0x6,%eax
801027d6:	83 f8 02             	cmp    $0x2,%eax
801027d9:	75 e5                	jne    801027c0 <iderw+0x90>
  }


  release(&idelock);
801027db:	c7 45 08 a0 b5 10 80 	movl   $0x8010b5a0,0x8(%ebp)
}
801027e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027e5:	c9                   	leave  
  release(&idelock);
801027e6:	e9 75 25 00 00       	jmp    80104d60 <release>
801027eb:	90                   	nop
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801027f0:	89 d8                	mov    %ebx,%eax
801027f2:	e8 39 fd ff ff       	call   80102530 <idestart>
801027f7:	eb b5                	jmp    801027ae <iderw+0x7e>
801027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102800:	ba 84 b5 10 80       	mov    $0x8010b584,%edx
80102805:	eb 9d                	jmp    801027a4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102807:	83 ec 0c             	sub    $0xc,%esp
8010280a:	68 bd 7d 10 80       	push   $0x80107dbd
8010280f:	e8 7c db ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102814:	83 ec 0c             	sub    $0xc,%esp
80102817:	68 a8 7d 10 80       	push   $0x80107da8
8010281c:	e8 6f db ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102821:	83 ec 0c             	sub    $0xc,%esp
80102824:	68 92 7d 10 80       	push   $0x80107d92
80102829:	e8 62 db ff ff       	call   80100390 <panic>
8010282e:	66 90                	xchg   %ax,%ax

80102830 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102830:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102831:	c7 05 b4 c6 11 80 00 	movl   $0xfec00000,0x8011c6b4
80102838:	00 c0 fe 
{
8010283b:	89 e5                	mov    %esp,%ebp
8010283d:	56                   	push   %esi
8010283e:	53                   	push   %ebx
  ioapic->reg = reg;
8010283f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102846:	00 00 00 
  return ioapic->data;
80102849:	8b 15 b4 c6 11 80    	mov    0x8011c6b4,%edx
8010284f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102852:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102858:	8b 0d b4 c6 11 80    	mov    0x8011c6b4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010285e:	0f b6 15 e0 c7 11 80 	movzbl 0x8011c7e0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102865:	c1 ee 10             	shr    $0x10,%esi
80102868:	89 f0                	mov    %esi,%eax
8010286a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010286d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102870:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102873:	39 c2                	cmp    %eax,%edx
80102875:	74 16                	je     8010288d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102877:	83 ec 0c             	sub    $0xc,%esp
8010287a:	68 dc 7d 10 80       	push   $0x80107ddc
8010287f:	e8 1c de ff ff       	call   801006a0 <cprintf>
80102884:	8b 0d b4 c6 11 80    	mov    0x8011c6b4,%ecx
8010288a:	83 c4 10             	add    $0x10,%esp
8010288d:	83 c6 21             	add    $0x21,%esi
{
80102890:	ba 10 00 00 00       	mov    $0x10,%edx
80102895:	b8 20 00 00 00       	mov    $0x20,%eax
8010289a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801028a0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028a2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801028a4:	8b 0d b4 c6 11 80    	mov    0x8011c6b4,%ecx
801028aa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028ad:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801028b3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801028b6:	8d 5a 01             	lea    0x1(%edx),%ebx
801028b9:	83 c2 02             	add    $0x2,%edx
801028bc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801028be:	8b 0d b4 c6 11 80    	mov    0x8011c6b4,%ecx
801028c4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801028cb:	39 f0                	cmp    %esi,%eax
801028cd:	75 d1                	jne    801028a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801028cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028d2:	5b                   	pop    %ebx
801028d3:	5e                   	pop    %esi
801028d4:	5d                   	pop    %ebp
801028d5:	c3                   	ret    
801028d6:	8d 76 00             	lea    0x0(%esi),%esi
801028d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801028e0:	55                   	push   %ebp
  ioapic->reg = reg;
801028e1:	8b 0d b4 c6 11 80    	mov    0x8011c6b4,%ecx
{
801028e7:	89 e5                	mov    %esp,%ebp
801028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801028ec:	8d 50 20             	lea    0x20(%eax),%edx
801028ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801028f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801028f5:	8b 0d b4 c6 11 80    	mov    0x8011c6b4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801028fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801028fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102901:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102904:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102906:	a1 b4 c6 11 80       	mov    0x8011c6b4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010290b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010290e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102911:	5d                   	pop    %ebp
80102912:	c3                   	ret    
80102913:	66 90                	xchg   %ax,%ax
80102915:	66 90                	xchg   %ax,%ax
80102917:	66 90                	xchg   %ax,%ax
80102919:	66 90                	xchg   %ax,%ax
8010291b:	66 90                	xchg   %ax,%ax
8010291d:	66 90                	xchg   %ax,%ax
8010291f:	90                   	nop

80102920 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102920:	55                   	push   %ebp
80102921:	89 e5                	mov    %esp,%ebp
80102923:	53                   	push   %ebx
80102924:	83 ec 04             	sub    $0x4,%esp
80102927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010292a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102930:	75 76                	jne    801029a8 <kfree+0x88>
80102932:	81 fb 88 fc 11 80    	cmp    $0x8011fc88,%ebx
80102938:	72 6e                	jb     801029a8 <kfree+0x88>
8010293a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102940:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102945:	77 61                	ja     801029a8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102947:	83 ec 04             	sub    $0x4,%esp
8010294a:	68 00 10 00 00       	push   $0x1000
8010294f:	6a 01                	push   $0x1
80102951:	53                   	push   %ebx
80102952:	e8 59 24 00 00       	call   80104db0 <memset>

  if(kmem.use_lock)
80102957:	8b 15 f4 c6 11 80    	mov    0x8011c6f4,%edx
8010295d:	83 c4 10             	add    $0x10,%esp
80102960:	85 d2                	test   %edx,%edx
80102962:	75 1c                	jne    80102980 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102964:	a1 f8 c6 11 80       	mov    0x8011c6f8,%eax
80102969:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010296b:	a1 f4 c6 11 80       	mov    0x8011c6f4,%eax
  kmem.freelist = r;
80102970:	89 1d f8 c6 11 80    	mov    %ebx,0x8011c6f8
  if(kmem.use_lock)
80102976:	85 c0                	test   %eax,%eax
80102978:	75 1e                	jne    80102998 <kfree+0x78>
    release(&kmem.lock);
}
8010297a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010297d:	c9                   	leave  
8010297e:	c3                   	ret    
8010297f:	90                   	nop
    acquire(&kmem.lock);
80102980:	83 ec 0c             	sub    $0xc,%esp
80102983:	68 c0 c6 11 80       	push   $0x8011c6c0
80102988:	e8 b3 22 00 00       	call   80104c40 <acquire>
8010298d:	83 c4 10             	add    $0x10,%esp
80102990:	eb d2                	jmp    80102964 <kfree+0x44>
80102992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102998:	c7 45 08 c0 c6 11 80 	movl   $0x8011c6c0,0x8(%ebp)
}
8010299f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029a2:	c9                   	leave  
    release(&kmem.lock);
801029a3:	e9 b8 23 00 00       	jmp    80104d60 <release>
    panic("kfree");
801029a8:	83 ec 0c             	sub    $0xc,%esp
801029ab:	68 0e 7e 10 80       	push   $0x80107e0e
801029b0:	e8 db d9 ff ff       	call   80100390 <panic>
801029b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029c0 <freerange>:
{
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
801029c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801029c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801029c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801029ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801029cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029dd:	39 de                	cmp    %ebx,%esi
801029df:	72 23                	jb     80102a04 <freerange+0x44>
801029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801029e8:	83 ec 0c             	sub    $0xc,%esp
801029eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801029f7:	50                   	push   %eax
801029f8:	e8 23 ff ff ff       	call   80102920 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029fd:	83 c4 10             	add    $0x10,%esp
80102a00:	39 f3                	cmp    %esi,%ebx
80102a02:	76 e4                	jbe    801029e8 <freerange+0x28>
}
80102a04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a07:	5b                   	pop    %ebx
80102a08:	5e                   	pop    %esi
80102a09:	5d                   	pop    %ebp
80102a0a:	c3                   	ret    
80102a0b:	90                   	nop
80102a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a10 <kinit1>:
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	56                   	push   %esi
80102a14:	53                   	push   %ebx
80102a15:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a18:	83 ec 08             	sub    $0x8,%esp
80102a1b:	68 14 7e 10 80       	push   $0x80107e14
80102a20:	68 c0 c6 11 80       	push   $0x8011c6c0
80102a25:	e8 16 21 00 00       	call   80104b40 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a2d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a30:	c7 05 f4 c6 11 80 00 	movl   $0x0,0x8011c6f4
80102a37:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102a3a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a40:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a46:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a4c:	39 de                	cmp    %ebx,%esi
80102a4e:	72 1c                	jb     80102a6c <kinit1+0x5c>
    kfree(p);
80102a50:	83 ec 0c             	sub    $0xc,%esp
80102a53:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a59:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a5f:	50                   	push   %eax
80102a60:	e8 bb fe ff ff       	call   80102920 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a65:	83 c4 10             	add    $0x10,%esp
80102a68:	39 de                	cmp    %ebx,%esi
80102a6a:	73 e4                	jae    80102a50 <kinit1+0x40>
}
80102a6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a6f:	5b                   	pop    %ebx
80102a70:	5e                   	pop    %esi
80102a71:	5d                   	pop    %ebp
80102a72:	c3                   	ret    
80102a73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a80 <kinit2>:
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a84:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a87:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a8a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a8b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a91:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a97:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a9d:	39 de                	cmp    %ebx,%esi
80102a9f:	72 23                	jb     80102ac4 <kinit2+0x44>
80102aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102aa8:	83 ec 0c             	sub    $0xc,%esp
80102aab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ab1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ab7:	50                   	push   %eax
80102ab8:	e8 63 fe ff ff       	call   80102920 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102abd:	83 c4 10             	add    $0x10,%esp
80102ac0:	39 de                	cmp    %ebx,%esi
80102ac2:	73 e4                	jae    80102aa8 <kinit2+0x28>
  kmem.use_lock = 1;
80102ac4:	c7 05 f4 c6 11 80 01 	movl   $0x1,0x8011c6f4
80102acb:	00 00 00 
}
80102ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ad1:	5b                   	pop    %ebx
80102ad2:	5e                   	pop    %esi
80102ad3:	5d                   	pop    %ebp
80102ad4:	c3                   	ret    
80102ad5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	53                   	push   %ebx
80102ae4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102ae7:	a1 f4 c6 11 80       	mov    0x8011c6f4,%eax
80102aec:	85 c0                	test   %eax,%eax
80102aee:	75 20                	jne    80102b10 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102af0:	8b 1d f8 c6 11 80    	mov    0x8011c6f8,%ebx
  if(r)
80102af6:	85 db                	test   %ebx,%ebx
80102af8:	74 07                	je     80102b01 <kalloc+0x21>
    kmem.freelist = r->next;
80102afa:	8b 03                	mov    (%ebx),%eax
80102afc:	a3 f8 c6 11 80       	mov    %eax,0x8011c6f8
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102b01:	89 d8                	mov    %ebx,%eax
80102b03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b06:	c9                   	leave  
80102b07:	c3                   	ret    
80102b08:	90                   	nop
80102b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102b10:	83 ec 0c             	sub    $0xc,%esp
80102b13:	68 c0 c6 11 80       	push   $0x8011c6c0
80102b18:	e8 23 21 00 00       	call   80104c40 <acquire>
  r = kmem.freelist;
80102b1d:	8b 1d f8 c6 11 80    	mov    0x8011c6f8,%ebx
  if(r)
80102b23:	83 c4 10             	add    $0x10,%esp
80102b26:	a1 f4 c6 11 80       	mov    0x8011c6f4,%eax
80102b2b:	85 db                	test   %ebx,%ebx
80102b2d:	74 08                	je     80102b37 <kalloc+0x57>
    kmem.freelist = r->next;
80102b2f:	8b 13                	mov    (%ebx),%edx
80102b31:	89 15 f8 c6 11 80    	mov    %edx,0x8011c6f8
  if(kmem.use_lock)
80102b37:	85 c0                	test   %eax,%eax
80102b39:	74 c6                	je     80102b01 <kalloc+0x21>
    release(&kmem.lock);
80102b3b:	83 ec 0c             	sub    $0xc,%esp
80102b3e:	68 c0 c6 11 80       	push   $0x8011c6c0
80102b43:	e8 18 22 00 00       	call   80104d60 <release>
}
80102b48:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
80102b4a:	83 c4 10             	add    $0x10,%esp
}
80102b4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b50:	c9                   	leave  
80102b51:	c3                   	ret    
80102b52:	66 90                	xchg   %ax,%ax
80102b54:	66 90                	xchg   %ax,%ax
80102b56:	66 90                	xchg   %ax,%ax
80102b58:	66 90                	xchg   %ax,%ax
80102b5a:	66 90                	xchg   %ax,%ax
80102b5c:	66 90                	xchg   %ax,%ax
80102b5e:	66 90                	xchg   %ax,%ax

80102b60 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b60:	ba 64 00 00 00       	mov    $0x64,%edx
80102b65:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b66:	a8 01                	test   $0x1,%al
80102b68:	0f 84 c2 00 00 00    	je     80102c30 <kbdgetc+0xd0>
{
80102b6e:	55                   	push   %ebp
80102b6f:	ba 60 00 00 00       	mov    $0x60,%edx
80102b74:	89 e5                	mov    %esp,%ebp
80102b76:	53                   	push   %ebx
80102b77:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102b78:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102b7b:	8b 1d d4 b5 10 80    	mov    0x8010b5d4,%ebx
80102b81:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102b87:	74 57                	je     80102be0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102b89:	89 d9                	mov    %ebx,%ecx
80102b8b:	83 e1 40             	and    $0x40,%ecx
80102b8e:	84 c0                	test   %al,%al
80102b90:	78 5e                	js     80102bf0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102b92:	85 c9                	test   %ecx,%ecx
80102b94:	74 09                	je     80102b9f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102b96:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102b99:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102b9c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102b9f:	0f b6 8a 40 7f 10 80 	movzbl -0x7fef80c0(%edx),%ecx
  shift ^= togglecode[data];
80102ba6:	0f b6 82 40 7e 10 80 	movzbl -0x7fef81c0(%edx),%eax
  shift |= shiftcode[data];
80102bad:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102baf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bb1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102bb3:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102bb9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102bbc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bbf:	8b 04 85 20 7e 10 80 	mov    -0x7fef81e0(,%eax,4),%eax
80102bc6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102bca:	74 0b                	je     80102bd7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102bcc:	8d 50 9f             	lea    -0x61(%eax),%edx
80102bcf:	83 fa 19             	cmp    $0x19,%edx
80102bd2:	77 44                	ja     80102c18 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102bd4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102bd7:	5b                   	pop    %ebx
80102bd8:	5d                   	pop    %ebp
80102bd9:	c3                   	ret    
80102bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102be0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102be3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102be5:	89 1d d4 b5 10 80    	mov    %ebx,0x8010b5d4
}
80102beb:	5b                   	pop    %ebx
80102bec:	5d                   	pop    %ebp
80102bed:	c3                   	ret    
80102bee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102bf0:	83 e0 7f             	and    $0x7f,%eax
80102bf3:	85 c9                	test   %ecx,%ecx
80102bf5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102bf8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102bfa:	0f b6 8a 40 7f 10 80 	movzbl -0x7fef80c0(%edx),%ecx
80102c01:	83 c9 40             	or     $0x40,%ecx
80102c04:	0f b6 c9             	movzbl %cl,%ecx
80102c07:	f7 d1                	not    %ecx
80102c09:	21 d9                	and    %ebx,%ecx
}
80102c0b:	5b                   	pop    %ebx
80102c0c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102c0d:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
}
80102c13:	c3                   	ret    
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102c18:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c1b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c1e:	5b                   	pop    %ebx
80102c1f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102c20:	83 f9 1a             	cmp    $0x1a,%ecx
80102c23:	0f 42 c2             	cmovb  %edx,%eax
}
80102c26:	c3                   	ret    
80102c27:	89 f6                	mov    %esi,%esi
80102c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c35:	c3                   	ret    
80102c36:	8d 76 00             	lea    0x0(%esi),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <kbdintr>:

void
kbdintr(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c46:	68 60 2b 10 80       	push   $0x80102b60
80102c4b:	e8 30 e1 ff ff       	call   80100d80 <consoleintr>
}
80102c50:	83 c4 10             	add    $0x10,%esp
80102c53:	c9                   	leave  
80102c54:	c3                   	ret    
80102c55:	66 90                	xchg   %ax,%ax
80102c57:	66 90                	xchg   %ax,%ax
80102c59:	66 90                	xchg   %ax,%ax
80102c5b:	66 90                	xchg   %ax,%ax
80102c5d:	66 90                	xchg   %ax,%ax
80102c5f:	90                   	nop

80102c60 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102c60:	a1 fc c6 11 80       	mov    0x8011c6fc,%eax
80102c65:	85 c0                	test   %eax,%eax
80102c67:	0f 84 cb 00 00 00    	je     80102d38 <lapicinit+0xd8>
  lapic[index] = value;
80102c6d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102c74:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c77:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c7a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102c81:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c84:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c87:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102c8e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102c91:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c94:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102c9b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102c9e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ca1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102ca8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cae:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102cb5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102cbb:	8b 50 30             	mov    0x30(%eax),%edx
80102cbe:	c1 ea 10             	shr    $0x10,%edx
80102cc1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102cc7:	75 77                	jne    80102d40 <lapicinit+0xe0>
  lapic[index] = value;
80102cc9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102cd0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cd6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cdd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ce3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ced:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cf7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cfa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cfd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d0a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d11:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d14:	8b 50 20             	mov    0x20(%eax),%edx
80102d17:	89 f6                	mov    %esi,%esi
80102d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d20:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d26:	80 e6 10             	and    $0x10,%dh
80102d29:	75 f5                	jne    80102d20 <lapicinit+0xc0>
  lapic[index] = value;
80102d2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d32:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d35:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d38:	c3                   	ret    
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102d40:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d47:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d4a:	8b 50 20             	mov    0x20(%eax),%edx
80102d4d:	e9 77 ff ff ff       	jmp    80102cc9 <lapicinit+0x69>
80102d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d60 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102d60:	a1 fc c6 11 80       	mov    0x8011c6fc,%eax
80102d65:	85 c0                	test   %eax,%eax
80102d67:	74 07                	je     80102d70 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102d69:	8b 40 20             	mov    0x20(%eax),%eax
80102d6c:	c1 e8 18             	shr    $0x18,%eax
80102d6f:	c3                   	ret    
    return 0;
80102d70:	31 c0                	xor    %eax,%eax
}
80102d72:	c3                   	ret    
80102d73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d80 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102d80:	a1 fc c6 11 80       	mov    0x8011c6fc,%eax
80102d85:	85 c0                	test   %eax,%eax
80102d87:	74 0d                	je     80102d96 <lapiceoi+0x16>
  lapic[index] = value;
80102d89:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d90:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d93:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102d96:	c3                   	ret    
80102d97:	89 f6                	mov    %esi,%esi
80102d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102da0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102da0:	c3                   	ret    
80102da1:	eb 0d                	jmp    80102db0 <lapicstartap>
80102da3:	90                   	nop
80102da4:	90                   	nop
80102da5:	90                   	nop
80102da6:	90                   	nop
80102da7:	90                   	nop
80102da8:	90                   	nop
80102da9:	90                   	nop
80102daa:	90                   	nop
80102dab:	90                   	nop
80102dac:	90                   	nop
80102dad:	90                   	nop
80102dae:	90                   	nop
80102daf:	90                   	nop

80102db0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102db0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102db6:	ba 70 00 00 00       	mov    $0x70,%edx
80102dbb:	89 e5                	mov    %esp,%ebp
80102dbd:	53                   	push   %ebx
80102dbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102dc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102dc4:	ee                   	out    %al,(%dx)
80102dc5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102dca:	ba 71 00 00 00       	mov    $0x71,%edx
80102dcf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102dd0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102dd2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102dd5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102ddb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ddd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102de0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102de2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102de5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102de8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102dee:	a1 fc c6 11 80       	mov    0x8011c6fc,%eax
80102df3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102df9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102dfc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e03:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e06:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e10:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e13:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e1c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e25:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102e37:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102e38:	8b 40 20             	mov    0x20(%eax),%eax
}
80102e3b:	5d                   	pop    %ebp
80102e3c:	c3                   	ret    
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi

80102e40 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102e40:	55                   	push   %ebp
80102e41:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e46:	ba 70 00 00 00       	mov    $0x70,%edx
80102e4b:	89 e5                	mov    %esp,%ebp
80102e4d:	57                   	push   %edi
80102e4e:	56                   	push   %esi
80102e4f:	53                   	push   %ebx
80102e50:	83 ec 4c             	sub    $0x4c,%esp
80102e53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e54:	ba 71 00 00 00       	mov    $0x71,%edx
80102e59:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102e5a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e5d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e62:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e65:	8d 76 00             	lea    0x0(%esi),%esi
80102e68:	31 c0                	xor    %eax,%eax
80102e6a:	89 da                	mov    %ebx,%edx
80102e6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e6d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102e72:	89 ca                	mov    %ecx,%edx
80102e74:	ec                   	in     (%dx),%al
80102e75:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e78:	89 da                	mov    %ebx,%edx
80102e7a:	b8 02 00 00 00       	mov    $0x2,%eax
80102e7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e80:	89 ca                	mov    %ecx,%edx
80102e82:	ec                   	in     (%dx),%al
80102e83:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e86:	89 da                	mov    %ebx,%edx
80102e88:	b8 04 00 00 00       	mov    $0x4,%eax
80102e8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e8e:	89 ca                	mov    %ecx,%edx
80102e90:	ec                   	in     (%dx),%al
80102e91:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e94:	89 da                	mov    %ebx,%edx
80102e96:	b8 07 00 00 00       	mov    $0x7,%eax
80102e9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e9c:	89 ca                	mov    %ecx,%edx
80102e9e:	ec                   	in     (%dx),%al
80102e9f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ea2:	89 da                	mov    %ebx,%edx
80102ea4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ea9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eaa:	89 ca                	mov    %ecx,%edx
80102eac:	ec                   	in     (%dx),%al
80102ead:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eaf:	89 da                	mov    %ebx,%edx
80102eb1:	b8 09 00 00 00       	mov    $0x9,%eax
80102eb6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eb7:	89 ca                	mov    %ecx,%edx
80102eb9:	ec                   	in     (%dx),%al
80102eba:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ebc:	89 da                	mov    %ebx,%edx
80102ebe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ec3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec4:	89 ca                	mov    %ecx,%edx
80102ec6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ec7:	84 c0                	test   %al,%al
80102ec9:	78 9d                	js     80102e68 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102ecb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ecf:	89 fa                	mov    %edi,%edx
80102ed1:	0f b6 fa             	movzbl %dl,%edi
80102ed4:	89 f2                	mov    %esi,%edx
80102ed6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ed9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102edd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ee0:	89 da                	mov    %ebx,%edx
80102ee2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102ee5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ee8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102eec:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102eef:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ef2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ef6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ef9:	31 c0                	xor    %eax,%eax
80102efb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102efc:	89 ca                	mov    %ecx,%edx
80102efe:	ec                   	in     (%dx),%al
80102eff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f02:	89 da                	mov    %ebx,%edx
80102f04:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f07:	b8 02 00 00 00       	mov    $0x2,%eax
80102f0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f0d:	89 ca                	mov    %ecx,%edx
80102f0f:	ec                   	in     (%dx),%al
80102f10:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f13:	89 da                	mov    %ebx,%edx
80102f15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f18:	b8 04 00 00 00       	mov    $0x4,%eax
80102f1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f1e:	89 ca                	mov    %ecx,%edx
80102f20:	ec                   	in     (%dx),%al
80102f21:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f24:	89 da                	mov    %ebx,%edx
80102f26:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f29:	b8 07 00 00 00       	mov    $0x7,%eax
80102f2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f2f:	89 ca                	mov    %ecx,%edx
80102f31:	ec                   	in     (%dx),%al
80102f32:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f35:	89 da                	mov    %ebx,%edx
80102f37:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f3a:	b8 08 00 00 00       	mov    $0x8,%eax
80102f3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f40:	89 ca                	mov    %ecx,%edx
80102f42:	ec                   	in     (%dx),%al
80102f43:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f46:	89 da                	mov    %ebx,%edx
80102f48:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f4b:	b8 09 00 00 00       	mov    $0x9,%eax
80102f50:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f51:	89 ca                	mov    %ecx,%edx
80102f53:	ec                   	in     (%dx),%al
80102f54:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f57:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f5d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f60:	6a 18                	push   $0x18
80102f62:	50                   	push   %eax
80102f63:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f66:	50                   	push   %eax
80102f67:	e8 94 1e 00 00       	call   80104e00 <memcmp>
80102f6c:	83 c4 10             	add    $0x10,%esp
80102f6f:	85 c0                	test   %eax,%eax
80102f71:	0f 85 f1 fe ff ff    	jne    80102e68 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102f77:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102f7b:	75 78                	jne    80102ff5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102f7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f80:	89 c2                	mov    %eax,%edx
80102f82:	83 e0 0f             	and    $0xf,%eax
80102f85:	c1 ea 04             	shr    $0x4,%edx
80102f88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102f91:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f94:	89 c2                	mov    %eax,%edx
80102f96:	83 e0 0f             	and    $0xf,%eax
80102f99:	c1 ea 04             	shr    $0x4,%edx
80102f9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fa2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102fa5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fa8:	89 c2                	mov    %eax,%edx
80102faa:	83 e0 0f             	and    $0xf,%eax
80102fad:	c1 ea 04             	shr    $0x4,%edx
80102fb0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fb3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102fb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102fbc:	89 c2                	mov    %eax,%edx
80102fbe:	83 e0 0f             	and    $0xf,%eax
80102fc1:	c1 ea 04             	shr    $0x4,%edx
80102fc4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fc7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102fcd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102fd0:	89 c2                	mov    %eax,%edx
80102fd2:	83 e0 0f             	and    $0xf,%eax
80102fd5:	c1 ea 04             	shr    $0x4,%edx
80102fd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fdb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fde:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102fe1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102fe4:	89 c2                	mov    %eax,%edx
80102fe6:	83 e0 0f             	and    $0xf,%eax
80102fe9:	c1 ea 04             	shr    $0x4,%edx
80102fec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ff2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ff5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ff8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ffb:	89 06                	mov    %eax,(%esi)
80102ffd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103000:	89 46 04             	mov    %eax,0x4(%esi)
80103003:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103006:	89 46 08             	mov    %eax,0x8(%esi)
80103009:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010300c:	89 46 0c             	mov    %eax,0xc(%esi)
8010300f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103012:	89 46 10             	mov    %eax,0x10(%esi)
80103015:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103018:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010301b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103022:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103025:	5b                   	pop    %ebx
80103026:	5e                   	pop    %esi
80103027:	5f                   	pop    %edi
80103028:	5d                   	pop    %ebp
80103029:	c3                   	ret    
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103030:	8b 0d 48 c7 11 80    	mov    0x8011c748,%ecx
80103036:	85 c9                	test   %ecx,%ecx
80103038:	0f 8e 8a 00 00 00    	jle    801030c8 <install_trans+0x98>
{
8010303e:	55                   	push   %ebp
8010303f:	89 e5                	mov    %esp,%ebp
80103041:	57                   	push   %edi
80103042:	56                   	push   %esi
80103043:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103044:	31 db                	xor    %ebx,%ebx
{
80103046:	83 ec 0c             	sub    $0xc,%esp
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103050:	a1 34 c7 11 80       	mov    0x8011c734,%eax
80103055:	83 ec 08             	sub    $0x8,%esp
80103058:	01 d8                	add    %ebx,%eax
8010305a:	83 c0 01             	add    $0x1,%eax
8010305d:	50                   	push   %eax
8010305e:	ff 35 44 c7 11 80    	pushl  0x8011c744
80103064:	e8 67 d0 ff ff       	call   801000d0 <bread>
80103069:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010306b:	58                   	pop    %eax
8010306c:	5a                   	pop    %edx
8010306d:	ff 34 9d 4c c7 11 80 	pushl  -0x7fee38b4(,%ebx,4)
80103074:	ff 35 44 c7 11 80    	pushl  0x8011c744
  for (tail = 0; tail < log.lh.n; tail++) {
8010307a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010307d:	e8 4e d0 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103082:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103085:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103087:	8d 47 5c             	lea    0x5c(%edi),%eax
8010308a:	68 00 02 00 00       	push   $0x200
8010308f:	50                   	push   %eax
80103090:	8d 46 5c             	lea    0x5c(%esi),%eax
80103093:	50                   	push   %eax
80103094:	e8 b7 1d 00 00       	call   80104e50 <memmove>
    bwrite(dbuf);  // write dst to disk
80103099:	89 34 24             	mov    %esi,(%esp)
8010309c:	e8 0f d1 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801030a1:	89 3c 24             	mov    %edi,(%esp)
801030a4:	e8 47 d1 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801030a9:	89 34 24             	mov    %esi,(%esp)
801030ac:	e8 3f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	39 1d 48 c7 11 80    	cmp    %ebx,0x8011c748
801030ba:	7f 94                	jg     80103050 <install_trans+0x20>
  }
}
801030bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bf:	5b                   	pop    %ebx
801030c0:	5e                   	pop    %esi
801030c1:	5f                   	pop    %edi
801030c2:	5d                   	pop    %ebp
801030c3:	c3                   	ret    
801030c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030c8:	c3                   	ret    
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801030d0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	53                   	push   %ebx
801030d4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801030d7:	ff 35 34 c7 11 80    	pushl  0x8011c734
801030dd:	ff 35 44 c7 11 80    	pushl  0x8011c744
801030e3:	e8 e8 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801030e8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801030eb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801030ed:	a1 48 c7 11 80       	mov    0x8011c748,%eax
801030f2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801030f5:	85 c0                	test   %eax,%eax
801030f7:	7e 19                	jle    80103112 <write_head+0x42>
801030f9:	31 d2                	xor    %edx,%edx
801030fb:	90                   	nop
801030fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80103100:	8b 0c 95 4c c7 11 80 	mov    -0x7fee38b4(,%edx,4),%ecx
80103107:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010310b:	83 c2 01             	add    $0x1,%edx
8010310e:	39 d0                	cmp    %edx,%eax
80103110:	75 ee                	jne    80103100 <write_head+0x30>
  }
  bwrite(buf);
80103112:	83 ec 0c             	sub    $0xc,%esp
80103115:	53                   	push   %ebx
80103116:	e8 95 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010311b:	89 1c 24             	mov    %ebx,(%esp)
8010311e:	e8 cd d0 ff ff       	call   801001f0 <brelse>
}
80103123:	83 c4 10             	add    $0x10,%esp
80103126:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103129:	c9                   	leave  
8010312a:	c3                   	ret    
8010312b:	90                   	nop
8010312c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103130 <initlog>:
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	53                   	push   %ebx
80103134:	83 ec 2c             	sub    $0x2c,%esp
80103137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010313a:	68 40 80 10 80       	push   $0x80108040
8010313f:	68 00 c7 11 80       	push   $0x8011c700
80103144:	e8 f7 19 00 00       	call   80104b40 <initlock>
  readsb(dev, &sb);
80103149:	58                   	pop    %eax
8010314a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010314d:	5a                   	pop    %edx
8010314e:	50                   	push   %eax
8010314f:	53                   	push   %ebx
80103150:	e8 3b e8 ff ff       	call   80101990 <readsb>
  log.start = sb.logstart;
80103155:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103158:	59                   	pop    %ecx
  log.dev = dev;
80103159:	89 1d 44 c7 11 80    	mov    %ebx,0x8011c744
  log.size = sb.nlog;
8010315f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103162:	a3 34 c7 11 80       	mov    %eax,0x8011c734
  log.size = sb.nlog;
80103167:	89 15 38 c7 11 80    	mov    %edx,0x8011c738
  struct buf *buf = bread(log.dev, log.start);
8010316d:	5a                   	pop    %edx
8010316e:	50                   	push   %eax
8010316f:	53                   	push   %ebx
80103170:	e8 5b cf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103175:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103178:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010317b:	89 0d 48 c7 11 80    	mov    %ecx,0x8011c748
  for (i = 0; i < log.lh.n; i++) {
80103181:	85 c9                	test   %ecx,%ecx
80103183:	7e 1d                	jle    801031a2 <initlog+0x72>
80103185:	31 d2                	xor    %edx,%edx
80103187:	89 f6                	mov    %esi,%esi
80103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.lh.block[i] = lh->block[i];
80103190:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103194:	89 1c 95 4c c7 11 80 	mov    %ebx,-0x7fee38b4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010319b:	83 c2 01             	add    $0x1,%edx
8010319e:	39 d1                	cmp    %edx,%ecx
801031a0:	75 ee                	jne    80103190 <initlog+0x60>
  brelse(buf);
801031a2:	83 ec 0c             	sub    $0xc,%esp
801031a5:	50                   	push   %eax
801031a6:	e8 45 d0 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031ab:	e8 80 fe ff ff       	call   80103030 <install_trans>
  log.lh.n = 0;
801031b0:	c7 05 48 c7 11 80 00 	movl   $0x0,0x8011c748
801031b7:	00 00 00 
  write_head(); // clear the log
801031ba:	e8 11 ff ff ff       	call   801030d0 <write_head>
}
801031bf:	83 c4 10             	add    $0x10,%esp
801031c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031c5:	c9                   	leave  
801031c6:	c3                   	ret    
801031c7:	89 f6                	mov    %esi,%esi
801031c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801031d0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801031d6:	68 00 c7 11 80       	push   $0x8011c700
801031db:	e8 60 1a 00 00       	call   80104c40 <acquire>
801031e0:	83 c4 10             	add    $0x10,%esp
801031e3:	eb 18                	jmp    801031fd <begin_op+0x2d>
801031e5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801031e8:	83 ec 08             	sub    $0x8,%esp
801031eb:	68 00 c7 11 80       	push   $0x8011c700
801031f0:	68 00 c7 11 80       	push   $0x8011c700
801031f5:	e8 06 15 00 00       	call   80104700 <sleep>
801031fa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801031fd:	a1 40 c7 11 80       	mov    0x8011c740,%eax
80103202:	85 c0                	test   %eax,%eax
80103204:	75 e2                	jne    801031e8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103206:	a1 3c c7 11 80       	mov    0x8011c73c,%eax
8010320b:	8b 15 48 c7 11 80    	mov    0x8011c748,%edx
80103211:	83 c0 01             	add    $0x1,%eax
80103214:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103217:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010321a:	83 fa 1e             	cmp    $0x1e,%edx
8010321d:	7f c9                	jg     801031e8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010321f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103222:	a3 3c c7 11 80       	mov    %eax,0x8011c73c
      release(&log.lock);
80103227:	68 00 c7 11 80       	push   $0x8011c700
8010322c:	e8 2f 1b 00 00       	call   80104d60 <release>
      break;
    }
  }
}
80103231:	83 c4 10             	add    $0x10,%esp
80103234:	c9                   	leave  
80103235:	c3                   	ret    
80103236:	8d 76 00             	lea    0x0(%esi),%esi
80103239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103240 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103249:	68 00 c7 11 80       	push   $0x8011c700
8010324e:	e8 ed 19 00 00       	call   80104c40 <acquire>
  log.outstanding -= 1;
80103253:	a1 3c c7 11 80       	mov    0x8011c73c,%eax
  if(log.committing)
80103258:	8b 35 40 c7 11 80    	mov    0x8011c740,%esi
8010325e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103261:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103264:	89 1d 3c c7 11 80    	mov    %ebx,0x8011c73c
  if(log.committing)
8010326a:	85 f6                	test   %esi,%esi
8010326c:	0f 85 22 01 00 00    	jne    80103394 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103272:	85 db                	test   %ebx,%ebx
80103274:	0f 85 f6 00 00 00    	jne    80103370 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010327a:	c7 05 40 c7 11 80 01 	movl   $0x1,0x8011c740
80103281:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103284:	83 ec 0c             	sub    $0xc,%esp
80103287:	68 00 c7 11 80       	push   $0x8011c700
8010328c:	e8 cf 1a 00 00       	call   80104d60 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103291:	8b 0d 48 c7 11 80    	mov    0x8011c748,%ecx
80103297:	83 c4 10             	add    $0x10,%esp
8010329a:	85 c9                	test   %ecx,%ecx
8010329c:	7f 42                	jg     801032e0 <end_op+0xa0>
    acquire(&log.lock);
8010329e:	83 ec 0c             	sub    $0xc,%esp
801032a1:	68 00 c7 11 80       	push   $0x8011c700
801032a6:	e8 95 19 00 00       	call   80104c40 <acquire>
    wakeup(&log);
801032ab:	c7 04 24 00 c7 11 80 	movl   $0x8011c700,(%esp)
    log.committing = 0;
801032b2:	c7 05 40 c7 11 80 00 	movl   $0x0,0x8011c740
801032b9:	00 00 00 
    wakeup(&log);
801032bc:	e8 ff 15 00 00       	call   801048c0 <wakeup>
    release(&log.lock);
801032c1:	c7 04 24 00 c7 11 80 	movl   $0x8011c700,(%esp)
801032c8:	e8 93 1a 00 00       	call   80104d60 <release>
801032cd:	83 c4 10             	add    $0x10,%esp
}
801032d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032d3:	5b                   	pop    %ebx
801032d4:	5e                   	pop    %esi
801032d5:	5f                   	pop    %edi
801032d6:	5d                   	pop    %ebp
801032d7:	c3                   	ret    
801032d8:	90                   	nop
801032d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801032e0:	a1 34 c7 11 80       	mov    0x8011c734,%eax
801032e5:	83 ec 08             	sub    $0x8,%esp
801032e8:	01 d8                	add    %ebx,%eax
801032ea:	83 c0 01             	add    $0x1,%eax
801032ed:	50                   	push   %eax
801032ee:	ff 35 44 c7 11 80    	pushl  0x8011c744
801032f4:	e8 d7 cd ff ff       	call   801000d0 <bread>
801032f9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801032fb:	58                   	pop    %eax
801032fc:	5a                   	pop    %edx
801032fd:	ff 34 9d 4c c7 11 80 	pushl  -0x7fee38b4(,%ebx,4)
80103304:	ff 35 44 c7 11 80    	pushl  0x8011c744
  for (tail = 0; tail < log.lh.n; tail++) {
8010330a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010330d:	e8 be cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103312:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103315:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103317:	8d 40 5c             	lea    0x5c(%eax),%eax
8010331a:	68 00 02 00 00       	push   $0x200
8010331f:	50                   	push   %eax
80103320:	8d 46 5c             	lea    0x5c(%esi),%eax
80103323:	50                   	push   %eax
80103324:	e8 27 1b 00 00       	call   80104e50 <memmove>
    bwrite(to);  // write the log
80103329:	89 34 24             	mov    %esi,(%esp)
8010332c:	e8 7f ce ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103331:	89 3c 24             	mov    %edi,(%esp)
80103334:	e8 b7 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
80103339:	89 34 24             	mov    %esi,(%esp)
8010333c:	e8 af ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103341:	83 c4 10             	add    $0x10,%esp
80103344:	3b 1d 48 c7 11 80    	cmp    0x8011c748,%ebx
8010334a:	7c 94                	jl     801032e0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010334c:	e8 7f fd ff ff       	call   801030d0 <write_head>
    install_trans(); // Now install writes to home locations
80103351:	e8 da fc ff ff       	call   80103030 <install_trans>
    log.lh.n = 0;
80103356:	c7 05 48 c7 11 80 00 	movl   $0x0,0x8011c748
8010335d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103360:	e8 6b fd ff ff       	call   801030d0 <write_head>
80103365:	e9 34 ff ff ff       	jmp    8010329e <end_op+0x5e>
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103370:	83 ec 0c             	sub    $0xc,%esp
80103373:	68 00 c7 11 80       	push   $0x8011c700
80103378:	e8 43 15 00 00       	call   801048c0 <wakeup>
  release(&log.lock);
8010337d:	c7 04 24 00 c7 11 80 	movl   $0x8011c700,(%esp)
80103384:	e8 d7 19 00 00       	call   80104d60 <release>
80103389:	83 c4 10             	add    $0x10,%esp
}
8010338c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010338f:	5b                   	pop    %ebx
80103390:	5e                   	pop    %esi
80103391:	5f                   	pop    %edi
80103392:	5d                   	pop    %ebp
80103393:	c3                   	ret    
    panic("log.committing");
80103394:	83 ec 0c             	sub    $0xc,%esp
80103397:	68 44 80 10 80       	push   $0x80108044
8010339c:	e8 ef cf ff ff       	call   80100390 <panic>
801033a1:	eb 0d                	jmp    801033b0 <log_write>
801033a3:	90                   	nop
801033a4:	90                   	nop
801033a5:	90                   	nop
801033a6:	90                   	nop
801033a7:	90                   	nop
801033a8:	90                   	nop
801033a9:	90                   	nop
801033aa:	90                   	nop
801033ab:	90                   	nop
801033ac:	90                   	nop
801033ad:	90                   	nop
801033ae:	90                   	nop
801033af:	90                   	nop

801033b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	53                   	push   %ebx
801033b4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033b7:	8b 15 48 c7 11 80    	mov    0x8011c748,%edx
{
801033bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033c0:	83 fa 1d             	cmp    $0x1d,%edx
801033c3:	0f 8f 94 00 00 00    	jg     8010345d <log_write+0xad>
801033c9:	a1 38 c7 11 80       	mov    0x8011c738,%eax
801033ce:	83 e8 01             	sub    $0x1,%eax
801033d1:	39 c2                	cmp    %eax,%edx
801033d3:	0f 8d 84 00 00 00    	jge    8010345d <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
801033d9:	a1 3c c7 11 80       	mov    0x8011c73c,%eax
801033de:	85 c0                	test   %eax,%eax
801033e0:	0f 8e 84 00 00 00    	jle    8010346a <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
801033e6:	83 ec 0c             	sub    $0xc,%esp
801033e9:	68 00 c7 11 80       	push   $0x8011c700
801033ee:	e8 4d 18 00 00       	call   80104c40 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801033f3:	8b 15 48 c7 11 80    	mov    0x8011c748,%edx
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	85 d2                	test   %edx,%edx
801033fe:	7e 51                	jle    80103451 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103400:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103403:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103405:	3b 0d 4c c7 11 80    	cmp    0x8011c74c,%ecx
8010340b:	75 0c                	jne    80103419 <log_write+0x69>
8010340d:	eb 39                	jmp    80103448 <log_write+0x98>
8010340f:	90                   	nop
80103410:	39 0c 85 4c c7 11 80 	cmp    %ecx,-0x7fee38b4(,%eax,4)
80103417:	74 2f                	je     80103448 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103419:	83 c0 01             	add    $0x1,%eax
8010341c:	39 c2                	cmp    %eax,%edx
8010341e:	75 f0                	jne    80103410 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103420:	89 0c 95 4c c7 11 80 	mov    %ecx,-0x7fee38b4(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103427:	83 c2 01             	add    $0x1,%edx
8010342a:	89 15 48 c7 11 80    	mov    %edx,0x8011c748
  b->flags |= B_DIRTY; // prevent eviction
80103430:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80103433:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103436:	c7 45 08 00 c7 11 80 	movl   $0x8011c700,0x8(%ebp)
}
8010343d:	c9                   	leave  
  release(&log.lock);
8010343e:	e9 1d 19 00 00       	jmp    80104d60 <release>
80103443:	90                   	nop
80103444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80103448:	89 0c 85 4c c7 11 80 	mov    %ecx,-0x7fee38b4(,%eax,4)
  if (i == log.lh.n)
8010344f:	eb df                	jmp    80103430 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80103451:	8b 43 08             	mov    0x8(%ebx),%eax
80103454:	a3 4c c7 11 80       	mov    %eax,0x8011c74c
  if (i == log.lh.n)
80103459:	75 d5                	jne    80103430 <log_write+0x80>
8010345b:	eb ca                	jmp    80103427 <log_write+0x77>
    panic("too big a transaction");
8010345d:	83 ec 0c             	sub    $0xc,%esp
80103460:	68 53 80 10 80       	push   $0x80108053
80103465:	e8 26 cf ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010346a:	83 ec 0c             	sub    $0xc,%esp
8010346d:	68 69 80 10 80       	push   $0x80108069
80103472:	e8 19 cf ff ff       	call   80100390 <panic>
80103477:	66 90                	xchg   %ax,%ax
80103479:	66 90                	xchg   %ax,%ax
8010347b:	66 90                	xchg   %ax,%ax
8010347d:	66 90                	xchg   %ax,%ax
8010347f:	90                   	nop

80103480 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	53                   	push   %ebx
80103484:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103487:	e8 d4 09 00 00       	call   80103e60 <cpuid>
8010348c:	89 c3                	mov    %eax,%ebx
8010348e:	e8 cd 09 00 00       	call   80103e60 <cpuid>
80103493:	83 ec 04             	sub    $0x4,%esp
80103496:	53                   	push   %ebx
80103497:	50                   	push   %eax
80103498:	68 84 80 10 80       	push   $0x80108084
8010349d:	e8 fe d1 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801034a2:	e8 c9 2d 00 00       	call   80106270 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034a7:	e8 34 09 00 00       	call   80103de0 <mycpu>
801034ac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034ae:	b8 01 00 00 00       	mov    $0x1,%eax
801034b3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034ba:	e8 11 0f 00 00       	call   801043d0 <scheduler>
801034bf:	90                   	nop

801034c0 <mpenter>:
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801034c6:	e8 e5 3e 00 00       	call   801073b0 <switchkvm>
  seginit();
801034cb:	e8 50 3e 00 00       	call   80107320 <seginit>
  lapicinit();
801034d0:	e8 8b f7 ff ff       	call   80102c60 <lapicinit>
  mpmain();
801034d5:	e8 a6 ff ff ff       	call   80103480 <mpmain>
801034da:	66 90                	xchg   %ax,%ax
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <main>:
{
801034e0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801034e4:	83 e4 f0             	and    $0xfffffff0,%esp
801034e7:	ff 71 fc             	pushl  -0x4(%ecx)
801034ea:	55                   	push   %ebp
801034eb:	89 e5                	mov    %esp,%ebp
801034ed:	53                   	push   %ebx
801034ee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034ef:	83 ec 08             	sub    $0x8,%esp
801034f2:	68 00 00 40 80       	push   $0x80400000
801034f7:	68 88 fc 11 80       	push   $0x8011fc88
801034fc:	e8 0f f5 ff ff       	call   80102a10 <kinit1>
  kvmalloc();      // kernel page table
80103501:	e8 7a 44 00 00       	call   80107980 <kvmalloc>
  mpinit();        // detect other processors
80103506:	e8 85 01 00 00       	call   80103690 <mpinit>
  lapicinit();     // interrupt controller
8010350b:	e8 50 f7 ff ff       	call   80102c60 <lapicinit>
  seginit();       // segment descriptors
80103510:	e8 0b 3e 00 00       	call   80107320 <seginit>
  picinit();       // disable pic
80103515:	e8 46 03 00 00       	call   80103860 <picinit>
  ioapicinit();    // another interrupt controller
8010351a:	e8 11 f3 ff ff       	call   80102830 <ioapicinit>
  consoleinit();   // console hardware
8010351f:	e8 0c da ff ff       	call   80100f30 <consoleinit>
  uartinit();      // serial port
80103524:	e8 b7 30 00 00       	call   801065e0 <uartinit>
  pinit();         // process table
80103529:	e8 92 08 00 00       	call   80103dc0 <pinit>
  tvinit();        // trap vectors
8010352e:	e8 bd 2c 00 00       	call   801061f0 <tvinit>
  binit();         // buffer cache
80103533:	e8 08 cb ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103538:	e8 a3 dd ff ff       	call   801012e0 <fileinit>
  ideinit();       // disk 
8010353d:	e8 ce f0 ff ff       	call   80102610 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103542:	83 c4 0c             	add    $0xc,%esp
80103545:	68 8a 00 00 00       	push   $0x8a
8010354a:	68 8c b4 10 80       	push   $0x8010b48c
8010354f:	68 00 70 00 80       	push   $0x80007000
80103554:	e8 f7 18 00 00       	call   80104e50 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103559:	83 c4 10             	add    $0x10,%esp
8010355c:	69 05 c0 cd 11 80 b8 	imul   $0xb8,0x8011cdc0,%eax
80103563:	00 00 00 
80103566:	05 00 c8 11 80       	add    $0x8011c800,%eax
8010356b:	3d 00 c8 11 80       	cmp    $0x8011c800,%eax
80103570:	76 7e                	jbe    801035f0 <main+0x110>
80103572:	bb 00 c8 11 80       	mov    $0x8011c800,%ebx
80103577:	eb 20                	jmp    80103599 <main+0xb9>
80103579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103580:	69 05 c0 cd 11 80 b8 	imul   $0xb8,0x8011cdc0,%eax
80103587:	00 00 00 
8010358a:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
80103590:	05 00 c8 11 80       	add    $0x8011c800,%eax
80103595:	39 c3                	cmp    %eax,%ebx
80103597:	73 57                	jae    801035f0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103599:	e8 42 08 00 00       	call   80103de0 <mycpu>
8010359e:	39 d8                	cmp    %ebx,%eax
801035a0:	74 de                	je     80103580 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801035a2:	e8 39 f5 ff ff       	call   80102ae0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801035a7:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
801035aa:	c7 05 f8 6f 00 80 c0 	movl   $0x801034c0,0x80006ff8
801035b1:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801035b4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801035bb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801035be:	05 00 10 00 00       	add    $0x1000,%eax
801035c3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801035c8:	0f b6 03             	movzbl (%ebx),%eax
801035cb:	68 00 70 00 00       	push   $0x7000
801035d0:	50                   	push   %eax
801035d1:	e8 da f7 ff ff       	call   80102db0 <lapicstartap>
801035d6:	83 c4 10             	add    $0x10,%esp
801035d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801035e6:	85 c0                	test   %eax,%eax
801035e8:	74 f6                	je     801035e0 <main+0x100>
801035ea:	eb 94                	jmp    80103580 <main+0xa0>
801035ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801035f0:	83 ec 08             	sub    $0x8,%esp
801035f3:	68 00 00 00 8e       	push   $0x8e000000
801035f8:	68 00 00 40 80       	push   $0x80400000
801035fd:	e8 7e f4 ff ff       	call   80102a80 <kinit2>
  userinit();      // first user process
80103602:	e8 a9 09 00 00       	call   80103fb0 <userinit>
  mpmain();        // finish this processor's setup
80103607:	e8 74 fe ff ff       	call   80103480 <mpmain>
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103615:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010361b:	53                   	push   %ebx
  e = addr+len;
8010361c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010361f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103622:	39 de                	cmp    %ebx,%esi
80103624:	72 10                	jb     80103636 <mpsearch1+0x26>
80103626:	eb 50                	jmp    80103678 <mpsearch1+0x68>
80103628:	90                   	nop
80103629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103630:	89 fe                	mov    %edi,%esi
80103632:	39 fb                	cmp    %edi,%ebx
80103634:	76 42                	jbe    80103678 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103636:	83 ec 04             	sub    $0x4,%esp
80103639:	8d 7e 10             	lea    0x10(%esi),%edi
8010363c:	6a 04                	push   $0x4
8010363e:	68 98 80 10 80       	push   $0x80108098
80103643:	56                   	push   %esi
80103644:	e8 b7 17 00 00       	call   80104e00 <memcmp>
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	85 c0                	test   %eax,%eax
8010364e:	75 e0                	jne    80103630 <mpsearch1+0x20>
80103650:	89 f1                	mov    %esi,%ecx
80103652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103658:	0f b6 11             	movzbl (%ecx),%edx
8010365b:	83 c1 01             	add    $0x1,%ecx
8010365e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103660:	39 f9                	cmp    %edi,%ecx
80103662:	75 f4                	jne    80103658 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103664:	84 c0                	test   %al,%al
80103666:	75 c8                	jne    80103630 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103668:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010366b:	89 f0                	mov    %esi,%eax
8010366d:	5b                   	pop    %ebx
8010366e:	5e                   	pop    %esi
8010366f:	5f                   	pop    %edi
80103670:	5d                   	pop    %ebp
80103671:	c3                   	ret    
80103672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103678:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010367b:	31 f6                	xor    %esi,%esi
}
8010367d:	5b                   	pop    %ebx
8010367e:	89 f0                	mov    %esi,%eax
80103680:	5e                   	pop    %esi
80103681:	5f                   	pop    %edi
80103682:	5d                   	pop    %ebp
80103683:	c3                   	ret    
80103684:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010368a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103690 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
80103695:	53                   	push   %ebx
80103696:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103699:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801036a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801036a7:	c1 e0 08             	shl    $0x8,%eax
801036aa:	09 d0                	or     %edx,%eax
801036ac:	c1 e0 04             	shl    $0x4,%eax
801036af:	75 1b                	jne    801036cc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036b1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801036b8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801036bf:	c1 e0 08             	shl    $0x8,%eax
801036c2:	09 d0                	or     %edx,%eax
801036c4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801036c7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801036cc:	ba 00 04 00 00       	mov    $0x400,%edx
801036d1:	e8 3a ff ff ff       	call   80103610 <mpsearch1>
801036d6:	89 c7                	mov    %eax,%edi
801036d8:	85 c0                	test   %eax,%eax
801036da:	0f 84 c0 00 00 00    	je     801037a0 <mpinit+0x110>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036e0:	8b 5f 04             	mov    0x4(%edi),%ebx
801036e3:	85 db                	test   %ebx,%ebx
801036e5:	0f 84 d5 00 00 00    	je     801037c0 <mpinit+0x130>
  if(memcmp(conf, "PCMP", 4) != 0)
801036eb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801036ee:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801036f4:	6a 04                	push   $0x4
801036f6:	68 b5 80 10 80       	push   $0x801080b5
801036fb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801036fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801036ff:	e8 fc 16 00 00       	call   80104e00 <memcmp>
80103704:	83 c4 10             	add    $0x10,%esp
80103707:	85 c0                	test   %eax,%eax
80103709:	0f 85 b1 00 00 00    	jne    801037c0 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
8010370f:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103716:	3c 01                	cmp    $0x1,%al
80103718:	0f 95 c2             	setne  %dl
8010371b:	3c 04                	cmp    $0x4,%al
8010371d:	0f 95 c0             	setne  %al
80103720:	20 c2                	and    %al,%dl
80103722:	0f 85 98 00 00 00    	jne    801037c0 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
80103728:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
8010372f:	66 85 c9             	test   %cx,%cx
80103732:	74 21                	je     80103755 <mpinit+0xc5>
80103734:	89 d8                	mov    %ebx,%eax
80103736:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  sum = 0;
80103739:	31 d2                	xor    %edx,%edx
8010373b:	90                   	nop
8010373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103740:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103747:	83 c0 01             	add    $0x1,%eax
8010374a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010374c:	39 c6                	cmp    %eax,%esi
8010374e:	75 f0                	jne    80103740 <mpinit+0xb0>
80103750:	84 d2                	test   %dl,%dl
80103752:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103755:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103758:	85 c9                	test   %ecx,%ecx
8010375a:	74 64                	je     801037c0 <mpinit+0x130>
8010375c:	84 d2                	test   %dl,%dl
8010375e:	75 60                	jne    801037c0 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103760:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103766:	a3 fc c6 11 80       	mov    %eax,0x8011c6fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010376b:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103772:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103778:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010377d:	01 d1                	add    %edx,%ecx
8010377f:	89 ce                	mov    %ecx,%esi
80103781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103788:	39 c6                	cmp    %eax,%esi
8010378a:	76 4b                	jbe    801037d7 <mpinit+0x147>
    switch(*p){
8010378c:	0f b6 10             	movzbl (%eax),%edx
8010378f:	80 fa 04             	cmp    $0x4,%dl
80103792:	0f 87 bf 00 00 00    	ja     80103857 <mpinit+0x1c7>
80103798:	ff 24 95 dc 80 10 80 	jmp    *-0x7fef7f24(,%edx,4)
8010379f:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
801037a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801037a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801037aa:	e8 61 fe ff ff       	call   80103610 <mpsearch1>
801037af:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037b1:	85 c0                	test   %eax,%eax
801037b3:	0f 85 27 ff ff ff    	jne    801036e0 <mpinit+0x50>
801037b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	68 9d 80 10 80       	push   $0x8010809d
801037c8:	e8 c3 cb ff ff       	call   80100390 <panic>
801037cd:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801037d0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037d3:	39 c6                	cmp    %eax,%esi
801037d5:	77 b5                	ja     8010378c <mpinit+0xfc>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801037d7:	85 db                	test   %ebx,%ebx
801037d9:	74 6f                	je     8010384a <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801037db:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801037df:	74 15                	je     801037f6 <mpinit+0x166>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037e1:	b8 70 00 00 00       	mov    $0x70,%eax
801037e6:	ba 22 00 00 00       	mov    $0x22,%edx
801037eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037ec:	ba 23 00 00 00       	mov    $0x23,%edx
801037f1:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037f2:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037f5:	ee                   	out    %al,(%dx)
  }
}
801037f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f9:	5b                   	pop    %ebx
801037fa:	5e                   	pop    %esi
801037fb:	5f                   	pop    %edi
801037fc:	5d                   	pop    %ebp
801037fd:	c3                   	ret    
801037fe:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103800:	8b 15 c0 cd 11 80    	mov    0x8011cdc0,%edx
80103806:	83 fa 07             	cmp    $0x7,%edx
80103809:	7f 1f                	jg     8010382a <mpinit+0x19a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010380b:	69 ca b8 00 00 00    	imul   $0xb8,%edx,%ecx
80103811:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103814:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103818:	88 91 00 c8 11 80    	mov    %dl,-0x7fee3800(%ecx)
        ncpu++;
8010381e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103821:	83 c2 01             	add    $0x1,%edx
80103824:	89 15 c0 cd 11 80    	mov    %edx,0x8011cdc0
      p += sizeof(struct mpproc);
8010382a:	83 c0 14             	add    $0x14,%eax
      continue;
8010382d:	e9 56 ff ff ff       	jmp    80103788 <mpinit+0xf8>
80103832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103838:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010383c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010383f:	88 15 e0 c7 11 80    	mov    %dl,0x8011c7e0
      continue;
80103845:	e9 3e ff ff ff       	jmp    80103788 <mpinit+0xf8>
    panic("Didn't find a suitable machine");
8010384a:	83 ec 0c             	sub    $0xc,%esp
8010384d:	68 bc 80 10 80       	push   $0x801080bc
80103852:	e8 39 cb ff ff       	call   80100390 <panic>
      ismp = 0;
80103857:	31 db                	xor    %ebx,%ebx
80103859:	e9 31 ff ff ff       	jmp    8010378f <mpinit+0xff>
8010385e:	66 90                	xchg   %ax,%ax

80103860 <picinit>:
80103860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103865:	ba 21 00 00 00       	mov    $0x21,%edx
8010386a:	ee                   	out    %al,(%dx)
8010386b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103870:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103871:	c3                   	ret    
80103872:	66 90                	xchg   %ax,%ax
80103874:	66 90                	xchg   %ax,%ax
80103876:	66 90                	xchg   %ax,%ax
80103878:	66 90                	xchg   %ax,%ax
8010387a:	66 90                	xchg   %ax,%ax
8010387c:	66 90                	xchg   %ax,%ax
8010387e:	66 90                	xchg   %ax,%ax

80103880 <memowrite>:
  int writeopen;  // write fd is still open
};

int
memowrite(char* addr, int n)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	56                   	push   %esi
80103884:	53                   	push   %ebx
80103885:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct memo* ch=(struct memo*)getshared(2);
80103888:	83 ec 0c             	sub    $0xc,%esp
8010388b:	6a 02                	push   $0x2
8010388d:	e8 6e 08 00 00       	call   80104100 <getshared>
80103892:	89 c3                	mov    %eax,%ebx
  acquire(&ch->lock);
80103894:	89 04 24             	mov    %eax,(%esp)
80103897:	e8 a4 13 00 00       	call   80104c40 <acquire>
  strncpy(ch->memo+ch->lmemo, addr, n);
8010389c:	83 c4 0c             	add    $0xc,%esp
8010389f:	56                   	push   %esi
801038a0:	ff 75 08             	pushl  0x8(%ebp)
801038a3:	8b 43 34             	mov    0x34(%ebx),%eax
801038a6:	8d 44 03 38          	lea    0x38(%ebx,%eax,1),%eax
801038aa:	50                   	push   %eax
801038ab:	e8 70 16 00 00       	call   80104f20 <strncpy>
  ch->lmemo+=n;
801038b0:	03 73 34             	add    0x34(%ebx),%esi
801038b3:	89 73 34             	mov    %esi,0x34(%ebx)
  ch->memo[ch->lmemo]=0;
801038b6:	c6 44 33 38 00       	movb   $0x0,0x38(%ebx,%esi,1)
  release(&ch->lock);
801038bb:	89 1c 24             	mov    %ebx,(%esp)
801038be:	e8 9d 14 00 00       	call   80104d60 <release>
  return 0;
}
801038c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c6:	31 c0                	xor    %eax,%eax
801038c8:	5b                   	pop    %ebx
801038c9:	5e                   	pop    %esi
801038ca:	5d                   	pop    %ebp
801038cb:	c3                   	ret    
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038d0 <pipealloc>:

int
pipealloc(struct file **f0, struct file **f1)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	53                   	push   %ebx
801038d6:	83 ec 0c             	sub    $0xc,%esp
801038d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801038df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801038e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801038eb:	e8 10 da ff ff       	call   80101300 <filealloc>
801038f0:	89 03                	mov    %eax,(%ebx)
801038f2:	85 c0                	test   %eax,%eax
801038f4:	0f 84 a8 00 00 00    	je     801039a2 <pipealloc+0xd2>
801038fa:	e8 01 da ff ff       	call   80101300 <filealloc>
801038ff:	89 06                	mov    %eax,(%esi)
80103901:	85 c0                	test   %eax,%eax
80103903:	0f 84 87 00 00 00    	je     80103990 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103909:	e8 d2 f1 ff ff       	call   80102ae0 <kalloc>
8010390e:	89 c7                	mov    %eax,%edi
80103910:	85 c0                	test   %eax,%eax
80103912:	0f 84 b0 00 00 00    	je     801039c8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103918:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010391f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103922:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103925:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010392c:	00 00 00 
  p->nwrite = 0;
8010392f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103936:	00 00 00 
  p->nread = 0;
80103939:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103940:	00 00 00 
  initlock(&p->lock, "pipe");
80103943:	68 f0 80 10 80       	push   $0x801080f0
80103948:	50                   	push   %eax
80103949:	e8 f2 11 00 00       	call   80104b40 <initlock>
  (*f0)->type = FD_PIPE;
8010394e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103950:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103953:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103959:	8b 03                	mov    (%ebx),%eax
8010395b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010395f:	8b 03                	mov    (%ebx),%eax
80103961:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103965:	8b 03                	mov    (%ebx),%eax
80103967:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010396a:	8b 06                	mov    (%esi),%eax
8010396c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103972:	8b 06                	mov    (%esi),%eax
80103974:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103978:	8b 06                	mov    (%esi),%eax
8010397a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010397e:	8b 06                	mov    (%esi),%eax
80103980:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103983:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103986:	31 c0                	xor    %eax,%eax
}
80103988:	5b                   	pop    %ebx
80103989:	5e                   	pop    %esi
8010398a:	5f                   	pop    %edi
8010398b:	5d                   	pop    %ebp
8010398c:	c3                   	ret    
8010398d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103990:	8b 03                	mov    (%ebx),%eax
80103992:	85 c0                	test   %eax,%eax
80103994:	74 1e                	je     801039b4 <pipealloc+0xe4>
    fileclose(*f0);
80103996:	83 ec 0c             	sub    $0xc,%esp
80103999:	50                   	push   %eax
8010399a:	e8 21 da ff ff       	call   801013c0 <fileclose>
8010399f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801039a2:	8b 06                	mov    (%esi),%eax
801039a4:	85 c0                	test   %eax,%eax
801039a6:	74 0c                	je     801039b4 <pipealloc+0xe4>
    fileclose(*f1);
801039a8:	83 ec 0c             	sub    $0xc,%esp
801039ab:	50                   	push   %eax
801039ac:	e8 0f da ff ff       	call   801013c0 <fileclose>
801039b1:	83 c4 10             	add    $0x10,%esp
}
801039b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801039b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801039bc:	5b                   	pop    %ebx
801039bd:	5e                   	pop    %esi
801039be:	5f                   	pop    %edi
801039bf:	5d                   	pop    %ebp
801039c0:	c3                   	ret    
801039c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801039c8:	8b 03                	mov    (%ebx),%eax
801039ca:	85 c0                	test   %eax,%eax
801039cc:	75 c8                	jne    80103996 <pipealloc+0xc6>
801039ce:	eb d2                	jmp    801039a2 <pipealloc+0xd2>

801039d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	56                   	push   %esi
801039d4:	53                   	push   %ebx
801039d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801039db:	83 ec 0c             	sub    $0xc,%esp
801039de:	53                   	push   %ebx
801039df:	e8 5c 12 00 00       	call   80104c40 <acquire>
  if(writable){
801039e4:	83 c4 10             	add    $0x10,%esp
801039e7:	85 f6                	test   %esi,%esi
801039e9:	74 65                	je     80103a50 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801039eb:	83 ec 0c             	sub    $0xc,%esp
801039ee:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801039f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801039fb:	00 00 00 
    wakeup(&p->nread);
801039fe:	50                   	push   %eax
801039ff:	e8 bc 0e 00 00       	call   801048c0 <wakeup>
80103a04:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103a07:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a0d:	85 d2                	test   %edx,%edx
80103a0f:	75 0a                	jne    80103a1b <pipeclose+0x4b>
80103a11:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a17:	85 c0                	test   %eax,%eax
80103a19:	74 15                	je     80103a30 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103a1b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a21:	5b                   	pop    %ebx
80103a22:	5e                   	pop    %esi
80103a23:	5d                   	pop    %ebp
    release(&p->lock);
80103a24:	e9 37 13 00 00       	jmp    80104d60 <release>
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	53                   	push   %ebx
80103a34:	e8 27 13 00 00       	call   80104d60 <release>
    kfree((char*)p);
80103a39:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103a3c:	83 c4 10             	add    $0x10,%esp
}
80103a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a42:	5b                   	pop    %ebx
80103a43:	5e                   	pop    %esi
80103a44:	5d                   	pop    %ebp
    kfree((char*)p);
80103a45:	e9 d6 ee ff ff       	jmp    80102920 <kfree>
80103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103a59:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a60:	00 00 00 
    wakeup(&p->nwrite);
80103a63:	50                   	push   %eax
80103a64:	e8 57 0e 00 00       	call   801048c0 <wakeup>
80103a69:	83 c4 10             	add    $0x10,%esp
80103a6c:	eb 99                	jmp    80103a07 <pipeclose+0x37>
80103a6e:	66 90                	xchg   %ax,%ax

80103a70 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	57                   	push   %edi
80103a74:	56                   	push   %esi
80103a75:	53                   	push   %ebx
80103a76:	83 ec 28             	sub    $0x28,%esp
80103a79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103a7c:	53                   	push   %ebx
80103a7d:	e8 be 11 00 00       	call   80104c40 <acquire>
  for(i = 0; i < n; i++){
80103a82:	8b 45 10             	mov    0x10(%ebp),%eax
80103a85:	83 c4 10             	add    $0x10,%esp
80103a88:	85 c0                	test   %eax,%eax
80103a8a:	0f 8e c8 00 00 00    	jle    80103b58 <pipewrite+0xe8>
80103a90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103a93:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103a99:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103a9f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103aa2:	03 4d 10             	add    0x10(%ebp),%ecx
80103aa5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103aa8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103aae:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103ab4:	39 d0                	cmp    %edx,%eax
80103ab6:	75 71                	jne    80103b29 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103ab8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103abe:	85 c0                	test   %eax,%eax
80103ac0:	74 4e                	je     80103b10 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ac2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103ac8:	eb 3a                	jmp    80103b04 <pipewrite+0x94>
80103aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103ad0:	83 ec 0c             	sub    $0xc,%esp
80103ad3:	57                   	push   %edi
80103ad4:	e8 e7 0d 00 00       	call   801048c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ad9:	5a                   	pop    %edx
80103ada:	59                   	pop    %ecx
80103adb:	53                   	push   %ebx
80103adc:	56                   	push   %esi
80103add:	e8 1e 0c 00 00       	call   80104700 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ae2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103ae8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103aee:	83 c4 10             	add    $0x10,%esp
80103af1:	05 00 02 00 00       	add    $0x200,%eax
80103af6:	39 c2                	cmp    %eax,%edx
80103af8:	75 36                	jne    80103b30 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103afa:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b00:	85 c0                	test   %eax,%eax
80103b02:	74 0c                	je     80103b10 <pipewrite+0xa0>
80103b04:	e8 77 03 00 00       	call   80103e80 <myproc>
80103b09:	8b 40 24             	mov    0x24(%eax),%eax
80103b0c:	85 c0                	test   %eax,%eax
80103b0e:	74 c0                	je     80103ad0 <pipewrite+0x60>
        release(&p->lock);
80103b10:	83 ec 0c             	sub    $0xc,%esp
80103b13:	53                   	push   %ebx
80103b14:	e8 47 12 00 00       	call   80104d60 <release>
        return -1;
80103b19:	83 c4 10             	add    $0x10,%esp
80103b1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b24:	5b                   	pop    %ebx
80103b25:	5e                   	pop    %esi
80103b26:	5f                   	pop    %edi
80103b27:	5d                   	pop    %ebp
80103b28:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b29:	89 c2                	mov    %eax,%edx
80103b2b:	90                   	nop
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b30:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103b33:	8d 42 01             	lea    0x1(%edx),%eax
80103b36:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103b3c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103b42:	0f b6 0e             	movzbl (%esi),%ecx
80103b45:	83 c6 01             	add    $0x1,%esi
80103b48:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103b4b:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b4f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103b52:	0f 85 50 ff ff ff    	jne    80103aa8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b58:	83 ec 0c             	sub    $0xc,%esp
80103b5b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b61:	50                   	push   %eax
80103b62:	e8 59 0d 00 00       	call   801048c0 <wakeup>
  release(&p->lock);
80103b67:	89 1c 24             	mov    %ebx,(%esp)
80103b6a:	e8 f1 11 00 00       	call   80104d60 <release>
  return n;
80103b6f:	83 c4 10             	add    $0x10,%esp
80103b72:	8b 45 10             	mov    0x10(%ebp),%eax
80103b75:	eb aa                	jmp    80103b21 <pipewrite+0xb1>
80103b77:	89 f6                	mov    %esi,%esi
80103b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b80 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	57                   	push   %edi
80103b84:	56                   	push   %esi
80103b85:	53                   	push   %ebx
80103b86:	83 ec 18             	sub    $0x18,%esp
80103b89:	8b 75 08             	mov    0x8(%ebp),%esi
80103b8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b8f:	56                   	push   %esi
80103b90:	e8 ab 10 00 00       	call   80104c40 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103b9e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103ba4:	75 6a                	jne    80103c10 <piperead+0x90>
80103ba6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103bac:	85 db                	test   %ebx,%ebx
80103bae:	0f 84 c4 00 00 00    	je     80103c78 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103bb4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103bba:	eb 2d                	jmp    80103be9 <piperead+0x69>
80103bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bc0:	83 ec 08             	sub    $0x8,%esp
80103bc3:	56                   	push   %esi
80103bc4:	53                   	push   %ebx
80103bc5:	e8 36 0b 00 00       	call   80104700 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bca:	83 c4 10             	add    $0x10,%esp
80103bcd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103bd3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103bd9:	75 35                	jne    80103c10 <piperead+0x90>
80103bdb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103be1:	85 d2                	test   %edx,%edx
80103be3:	0f 84 8f 00 00 00    	je     80103c78 <piperead+0xf8>
    if(myproc()->killed){
80103be9:	e8 92 02 00 00       	call   80103e80 <myproc>
80103bee:	8b 48 24             	mov    0x24(%eax),%ecx
80103bf1:	85 c9                	test   %ecx,%ecx
80103bf3:	74 cb                	je     80103bc0 <piperead+0x40>
      release(&p->lock);
80103bf5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103bf8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103bfd:	56                   	push   %esi
80103bfe:	e8 5d 11 00 00       	call   80104d60 <release>
      return -1;
80103c03:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103c06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c09:	89 d8                	mov    %ebx,%eax
80103c0b:	5b                   	pop    %ebx
80103c0c:	5e                   	pop    %esi
80103c0d:	5f                   	pop    %edi
80103c0e:	5d                   	pop    %ebp
80103c0f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c10:	8b 45 10             	mov    0x10(%ebp),%eax
80103c13:	85 c0                	test   %eax,%eax
80103c15:	7e 61                	jle    80103c78 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103c17:	31 db                	xor    %ebx,%ebx
80103c19:	eb 13                	jmp    80103c2e <piperead+0xae>
80103c1b:	90                   	nop
80103c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c20:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103c26:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103c2c:	74 1f                	je     80103c4d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103c2e:	8d 41 01             	lea    0x1(%ecx),%eax
80103c31:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103c37:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103c3d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103c42:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c45:	83 c3 01             	add    $0x1,%ebx
80103c48:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c4b:	75 d3                	jne    80103c20 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c4d:	83 ec 0c             	sub    $0xc,%esp
80103c50:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c56:	50                   	push   %eax
80103c57:	e8 64 0c 00 00       	call   801048c0 <wakeup>
  release(&p->lock);
80103c5c:	89 34 24             	mov    %esi,(%esp)
80103c5f:	e8 fc 10 00 00       	call   80104d60 <release>
  return i;
80103c64:	83 c4 10             	add    $0x10,%esp
}
80103c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c6a:	89 d8                	mov    %ebx,%eax
80103c6c:	5b                   	pop    %ebx
80103c6d:	5e                   	pop    %esi
80103c6e:	5f                   	pop    %edi
80103c6f:	5d                   	pop    %ebp
80103c70:	c3                   	ret    
80103c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
80103c78:	31 db                	xor    %ebx,%ebx
80103c7a:	eb d1                	jmp    80103c4d <piperead+0xcd>
80103c7c:	66 90                	xchg   %ax,%ax
80103c7e:	66 90                	xchg   %ax,%ax

80103c80 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c84:	bb 14 ce 11 80       	mov    $0x8011ce14,%ebx
{
80103c89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c8c:	68 e0 cd 11 80       	push   $0x8011cde0
80103c91:	e8 aa 0f 00 00       	call   80104c40 <acquire>
80103c96:	83 c4 10             	add    $0x10,%esp
80103c99:	eb 17                	jmp    80103cb2 <allocproc+0x32>
80103c9b:	90                   	nop
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ca0:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103ca6:	81 fb 14 f4 11 80    	cmp    $0x8011f414,%ebx
80103cac:	0f 84 8e 00 00 00    	je     80103d40 <allocproc+0xc0>
    if(p->state == UNUSED)
80103cb2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103cb5:	85 c0                	test   %eax,%eax
80103cb7:	75 e7                	jne    80103ca0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103cb9:	a1 04 b0 10 80       	mov    0x8010b004,%eax


  release(&ptable.lock);
80103cbe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103cc1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103cc8:	89 43 10             	mov    %eax,0x10(%ebx)
80103ccb:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103cce:	68 e0 cd 11 80       	push   $0x8011cde0
  p->pid = nextpid++;
80103cd3:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103cd9:	e8 82 10 00 00       	call   80104d60 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103cde:	e8 fd ed ff ff       	call   80102ae0 <kalloc>
80103ce3:	83 c4 10             	add    $0x10,%esp
80103ce6:	89 43 08             	mov    %eax,0x8(%ebx)
80103ce9:	85 c0                	test   %eax,%eax
80103ceb:	74 6c                	je     80103d59 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ced:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103cf3:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cf6:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103cfb:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103cfe:	c7 40 14 e2 61 10 80 	movl   $0x801061e2,0x14(%eax)
  p->context = (struct context*)sp;
80103d05:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103d08:	6a 14                	push   $0x14
80103d0a:	6a 00                	push   $0x0
80103d0c:	50                   	push   %eax
80103d0d:	e8 9e 10 00 00       	call   80104db0 <memset>
  p->context->eip = (uint)forkret;
80103d12:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103d15:	c7 40 10 70 3d 10 80 	movl   $0x80103d70,0x10(%eax)

  //brand new
  p->priority=NPROCQ-1;
80103d1c:	c7 83 80 00 00 00 02 	movl   $0x2,0x80(%ebx)
80103d23:	00 00 00 
  p->widx=0;
80103d26:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103d2d:	00 00 00 
  asm volatile("cli");
80103d30:	fa                   	cli    
  cli();

  return p;
}
80103d31:	89 d8                	mov    %ebx,%eax
  return p;
80103d33:	83 c4 10             	add    $0x10,%esp
}
80103d36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d39:	c9                   	leave  
80103d3a:	c3                   	ret    
80103d3b:	90                   	nop
80103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103d40:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d43:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d45:	68 e0 cd 11 80       	push   $0x8011cde0
80103d4a:	e8 11 10 00 00       	call   80104d60 <release>
}
80103d4f:	89 d8                	mov    %ebx,%eax
  return 0;
80103d51:	83 c4 10             	add    $0x10,%esp
}
80103d54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d57:	c9                   	leave  
80103d58:	c3                   	ret    
    p->state = UNUSED;
80103d59:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103d60:	31 db                	xor    %ebx,%ebx
}
80103d62:	89 d8                	mov    %ebx,%eax
80103d64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d67:	c9                   	leave  
80103d68:	c3                   	ret    
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d70 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103d76:	68 e0 cd 11 80       	push   $0x8011cde0
80103d7b:	e8 e0 0f 00 00       	call   80104d60 <release>

  if (first) {
80103d80:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103d85:	83 c4 10             	add    $0x10,%esp
80103d88:	85 c0                	test   %eax,%eax
80103d8a:	75 04                	jne    80103d90 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103d8c:	c9                   	leave  
80103d8d:	c3                   	ret    
80103d8e:	66 90                	xchg   %ax,%ax
    first = 0;
80103d90:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103d97:	00 00 00 
    iinit(ROOTDEV);
80103d9a:	83 ec 0c             	sub    $0xc,%esp
80103d9d:	6a 01                	push   $0x1
80103d9f:	e8 ac dc ff ff       	call   80101a50 <iinit>
    initlog(ROOTDEV);
80103da4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103dab:	e8 80 f3 ff ff       	call   80103130 <initlog>
80103db0:	83 c4 10             	add    $0x10,%esp
}
80103db3:	c9                   	leave  
80103db4:	c3                   	ret    
80103db5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dc0 <pinit>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103dc6:	68 f5 80 10 80       	push   $0x801080f5
80103dcb:	68 e0 cd 11 80       	push   $0x8011cde0
80103dd0:	e8 6b 0d 00 00       	call   80104b40 <initlock>
}
80103dd5:	83 c4 10             	add    $0x10,%esp
80103dd8:	c9                   	leave  
80103dd9:	c3                   	ret    
80103dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103de0 <mycpu>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	56                   	push   %esi
80103de4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103de5:	9c                   	pushf  
80103de6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103de7:	f6 c4 02             	test   $0x2,%ah
80103dea:	75 5d                	jne    80103e49 <mycpu+0x69>
  apicid = lapicid();
80103dec:	e8 6f ef ff ff       	call   80102d60 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103df1:	8b 35 c0 cd 11 80    	mov    0x8011cdc0,%esi
80103df7:	85 f6                	test   %esi,%esi
80103df9:	7e 41                	jle    80103e3c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
80103dfb:	0f b6 15 00 c8 11 80 	movzbl 0x8011c800,%edx
80103e02:	39 d0                	cmp    %edx,%eax
80103e04:	74 2f                	je     80103e35 <mycpu+0x55>
  for (i = 0; i < ncpu; ++i) {
80103e06:	31 d2                	xor    %edx,%edx
80103e08:	90                   	nop
80103e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e10:	83 c2 01             	add    $0x1,%edx
80103e13:	39 f2                	cmp    %esi,%edx
80103e15:	74 25                	je     80103e3c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
80103e17:	69 ca b8 00 00 00    	imul   $0xb8,%edx,%ecx
80103e1d:	0f b6 99 00 c8 11 80 	movzbl -0x7fee3800(%ecx),%ebx
80103e24:	39 c3                	cmp    %eax,%ebx
80103e26:	75 e8                	jne    80103e10 <mycpu+0x30>
80103e28:	8d 81 00 c8 11 80    	lea    -0x7fee3800(%ecx),%eax
}
80103e2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e31:	5b                   	pop    %ebx
80103e32:	5e                   	pop    %esi
80103e33:	5d                   	pop    %ebp
80103e34:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103e35:	b8 00 c8 11 80       	mov    $0x8011c800,%eax
      return &cpus[i];
80103e3a:	eb f2                	jmp    80103e2e <mycpu+0x4e>
  panic("unknown apicid\n");
80103e3c:	83 ec 0c             	sub    $0xc,%esp
80103e3f:	68 fc 80 10 80       	push   $0x801080fc
80103e44:	e8 47 c5 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e49:	83 ec 0c             	sub    $0xc,%esp
80103e4c:	68 d8 81 10 80       	push   $0x801081d8
80103e51:	e8 3a c5 ff ff       	call   80100390 <panic>
80103e56:	8d 76 00             	lea    0x0(%esi),%esi
80103e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e60 <cpuid>:
cpuid() {
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e66:	e8 75 ff ff ff       	call   80103de0 <mycpu>
}
80103e6b:	c9                   	leave  
  return mycpu()-cpus;
80103e6c:	2d 00 c8 11 80       	sub    $0x8011c800,%eax
80103e71:	c1 f8 03             	sar    $0x3,%eax
80103e74:	69 c0 a7 37 bd e9    	imul   $0xe9bd37a7,%eax,%eax
}
80103e7a:	c3                   	ret    
80103e7b:	90                   	nop
80103e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e80 <myproc>:
myproc(void) {
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	53                   	push   %ebx
80103e84:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e87:	e8 64 0d 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
80103e8c:	e8 4f ff ff ff       	call   80103de0 <mycpu>
  p = c->proc;
80103e91:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e97:	e8 64 0e 00 00       	call   80104d00 <popcli>
}
80103e9c:	83 c4 04             	add    $0x4,%esp
80103e9f:	89 d8                	mov    %ebx,%eax
80103ea1:	5b                   	pop    %ebx
80103ea2:	5d                   	pop    %ebp
80103ea3:	c3                   	ret    
80103ea4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103eaa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103eb0 <qpush>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  if(ptable.count[np->priority]<=0)
80103eb7:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103ebd:	8b 0c 95 2c f4 11 80 	mov    -0x7fee0bd4(,%edx,4),%ecx
80103ec4:	85 c9                	test   %ecx,%ecx
80103ec6:	75 40                	jne    80103f08 <qpush+0x58>
    np->next=np;
80103ec8:	89 40 7c             	mov    %eax,0x7c(%eax)
    ptable.pqueue[np->priority].head=np;
80103ecb:	89 04 d5 14 f4 11 80 	mov    %eax,-0x7fee0bec(,%edx,8)
    ptable.pqueue[np->priority].last=np;
80103ed2:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103ed8:	89 04 d5 18 f4 11 80 	mov    %eax,-0x7fee0be8(,%edx,8)
  np->timepiece=(1<<(NPROCQ-np->priority-1));
80103edf:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103ee5:	b9 02 00 00 00       	mov    $0x2,%ecx
80103eea:	bb 01 00 00 00       	mov    $0x1,%ebx
80103eef:	29 d1                	sub    %edx,%ecx
80103ef1:	d3 e3                	shl    %cl,%ebx
80103ef3:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
}
80103ef9:	5b                   	pop    %ebx
  ptable.count[np->priority]++;
80103efa:	83 04 95 2c f4 11 80 	addl   $0x1,-0x7fee0bd4(,%edx,4)
80103f01:	01 
}
80103f02:	5d                   	pop    %ebp
80103f03:	c3                   	ret    
80103f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->next=ptable.pqueue[np->priority].head;
80103f08:	81 c2 c6 04 00 00    	add    $0x4c6,%edx
80103f0e:	8b 0c d5 e4 cd 11 80 	mov    -0x7fee321c(,%edx,8),%ecx
80103f15:	89 48 7c             	mov    %ecx,0x7c(%eax)
    ptable.pqueue[np->priority].last->next=np;
80103f18:	8b 14 d5 e8 cd 11 80 	mov    -0x7fee3218(,%edx,8),%edx
80103f1f:	89 42 7c             	mov    %eax,0x7c(%edx)
    ptable.pqueue[np->priority].last=np;
80103f22:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103f28:	89 04 d5 18 f4 11 80 	mov    %eax,-0x7fee0be8(,%edx,8)
80103f2f:	eb ae                	jmp    80103edf <qpush+0x2f>
80103f31:	eb 0d                	jmp    80103f40 <wakeup1>
80103f33:	90                   	nop
80103f34:	90                   	nop
80103f35:	90                   	nop
80103f36:	90                   	nop
80103f37:	90                   	nop
80103f38:	90                   	nop
80103f39:	90                   	nop
80103f3a:	90                   	nop
80103f3b:	90                   	nop
80103f3c:	90                   	nop
80103f3d:	90                   	nop
80103f3e:	90                   	nop
80103f3f:	90                   	nop

80103f40 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	56                   	push   %esi
80103f44:	89 c6                	mov    %eax,%esi
80103f46:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f47:	bb 14 ce 11 80       	mov    $0x8011ce14,%ebx
80103f4c:	eb 10                	jmp    80103f5e <wakeup1+0x1e>
80103f4e:	66 90                	xchg   %ax,%ax
80103f50:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103f56:	81 fb 14 f4 11 80    	cmp    $0x8011f414,%ebx
80103f5c:	74 40                	je     80103f9e <wakeup1+0x5e>
    if(p->state == SLEEPING && p->chan == chan)
80103f5e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103f62:	75 ec                	jne    80103f50 <wakeup1+0x10>
80103f64:	39 73 20             	cmp    %esi,0x20(%ebx)
80103f67:	75 e7                	jne    80103f50 <wakeup1+0x10>
    {
      p->state = RUNNABLE;

      //brand new
      if(p->priority<NPROCQ-1)
80103f69:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
      p->state = RUNNABLE;
80103f6f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      if(p->priority<NPROCQ-1)
80103f76:	83 f8 01             	cmp    $0x1,%eax
80103f79:	77 09                	ja     80103f84 <wakeup1+0x44>
        p->priority++;
80103f7b:	83 c0 01             	add    $0x1,%eax
80103f7e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
      qpush(p);
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f88:	81 c3 98 00 00 00    	add    $0x98,%ebx
      qpush(p);
80103f8e:	e8 1d ff ff ff       	call   80103eb0 <qpush>
80103f93:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f96:	81 fb 14 f4 11 80    	cmp    $0x8011f414,%ebx
80103f9c:	75 c0                	jne    80103f5e <wakeup1+0x1e>

    }
}
80103f9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fa1:	5b                   	pop    %ebx
80103fa2:	5e                   	pop    %esi
80103fa3:	5d                   	pop    %ebp
80103fa4:	c3                   	ret    
80103fa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fb0 <userinit>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	53                   	push   %ebx
80103fb4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103fb7:	e8 c4 fc ff ff       	call   80103c80 <allocproc>
80103fbc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103fbe:	a3 d8 b5 10 80       	mov    %eax,0x8010b5d8
  if((p->pgdir = setupkvm()) == 0)
80103fc3:	e8 38 39 00 00       	call   80107900 <setupkvm>
80103fc8:	89 43 04             	mov    %eax,0x4(%ebx)
80103fcb:	85 c0                	test   %eax,%eax
80103fcd:	0f 84 c5 00 00 00    	je     80104098 <userinit+0xe8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103fd3:	83 ec 04             	sub    $0x4,%esp
80103fd6:	68 2c 00 00 00       	push   $0x2c
80103fdb:	68 60 b4 10 80       	push   $0x8010b460
80103fe0:	50                   	push   %eax
80103fe1:	e8 ea 34 00 00       	call   801074d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103fe6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103fe9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103fef:	6a 4c                	push   $0x4c
80103ff1:	6a 00                	push   $0x0
80103ff3:	ff 73 18             	pushl  0x18(%ebx)
80103ff6:	e8 b5 0d 00 00       	call   80104db0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ffb:	8b 43 18             	mov    0x18(%ebx),%eax
80103ffe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104003:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104006:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010400b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010400f:	8b 43 18             	mov    0x18(%ebx),%eax
80104012:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104016:	8b 43 18             	mov    0x18(%ebx),%eax
80104019:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010401d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104021:	8b 43 18             	mov    0x18(%ebx),%eax
80104024:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104028:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010402c:	8b 43 18             	mov    0x18(%ebx),%eax
8010402f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104036:	8b 43 18             	mov    0x18(%ebx),%eax
80104039:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104040:	8b 43 18             	mov    0x18(%ebx),%eax
80104043:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010404a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010404d:	6a 10                	push   $0x10
8010404f:	68 25 81 10 80       	push   $0x80108125
80104054:	50                   	push   %eax
80104055:	e8 26 0f 00 00       	call   80104f80 <safestrcpy>
  p->cwd = namei("/");
8010405a:	c7 04 24 2e 81 10 80 	movl   $0x8010812e,(%esp)
80104061:	e8 8a e4 ff ff       	call   801024f0 <namei>
80104066:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104069:	c7 04 24 e0 cd 11 80 	movl   $0x8011cde0,(%esp)
80104070:	e8 cb 0b 00 00       	call   80104c40 <acquire>
  p->state = RUNNABLE;
80104075:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  qpush(p);
8010407c:	89 1c 24             	mov    %ebx,(%esp)
8010407f:	e8 2c fe ff ff       	call   80103eb0 <qpush>
  release(&ptable.lock);
80104084:	c7 04 24 e0 cd 11 80 	movl   $0x8011cde0,(%esp)
8010408b:	e8 d0 0c 00 00       	call   80104d60 <release>
}
80104090:	83 c4 10             	add    $0x10,%esp
80104093:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104096:	c9                   	leave  
80104097:	c3                   	ret    
    panic("userinit: out of memory?");
80104098:	83 ec 0c             	sub    $0xc,%esp
8010409b:	68 0c 81 10 80       	push   $0x8010810c
801040a0:	e8 eb c2 ff ff       	call   80100390 <panic>
801040a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040b0 <releaseshared>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	56                   	push   %esi
801040b4:	53                   	push   %ebx
801040b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801040b8:	e8 33 0b 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
801040bd:	e8 1e fd ff ff       	call   80103de0 <mycpu>
  p = c->proc;
801040c2:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040c8:	e8 33 0c 00 00       	call   80104d00 <popcli>
  if(curproc->sharedrec[idx]!='s')
801040cd:	80 bc 1e 88 00 00 00 	cmpb   $0x73,0x88(%esi,%ebx,1)
801040d4:	73 
801040d5:	74 09                	je     801040e0 <releaseshared+0x30>
}
801040d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040da:	31 c0                	xor    %eax,%eax
801040dc:	5b                   	pop    %ebx
801040dd:	5e                   	pop    %esi
801040de:	5d                   	pop    %ebp
801040df:	c3                   	ret    
  desharevm(idx);
801040e0:	83 ec 0c             	sub    $0xc,%esp
  curproc->sharedrec[idx]=0;
801040e3:	c6 84 1e 88 00 00 00 	movb   $0x0,0x88(%esi,%ebx,1)
801040ea:	00 
  desharevm(idx);
801040eb:	53                   	push   %ebx
801040ec:	e8 4f 37 00 00       	call   80107840 <desharevm>
  return 0;
801040f1:	83 c4 10             	add    $0x10,%esp
}
801040f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040f7:	31 c0                	xor    %eax,%eax
801040f9:	5b                   	pop    %ebx
801040fa:	5e                   	pop    %esi
801040fb:	5d                   	pop    %ebp
801040fc:	c3                   	ret    
801040fd:	8d 76 00             	lea    0x0(%esi),%esi

80104100 <getshared>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	57                   	push   %edi
80104104:	56                   	push   %esi
80104105:	be 00 00 00 80       	mov    $0x80000000,%esi
8010410a:	53                   	push   %ebx
8010410b:	83 ec 0c             	sub    $0xc,%esp
8010410e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104111:	e8 da 0a 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
80104116:	e8 c5 fc ff ff       	call   80103de0 <mycpu>
  p = c->proc;
8010411b:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104121:	e8 da 0b 00 00       	call   80104d00 <popcli>
  if(curproc->sharedrec[idx]=='s'){
80104126:	8d 43 01             	lea    0x1(%ebx),%eax
80104129:	c1 e0 0c             	shl    $0xc,%eax
8010412c:	29 c6                	sub    %eax,%esi
8010412e:	80 bc 1f 88 00 00 00 	cmpb   $0x73,0x88(%edi,%ebx,1)
80104135:	73 
80104136:	74 1f                	je     80104157 <getshared+0x57>
  sharevm(curproc->pgdir, idx);
80104138:	83 ec 08             	sub    $0x8,%esp
8010413b:	53                   	push   %ebx
8010413c:	ff 77 04             	pushl  0x4(%edi)
8010413f:	e8 cc 34 00 00       	call   80107610 <sharevm>
  curproc->sharedrec[idx]='s';
80104144:	c6 84 1f 88 00 00 00 	movb   $0x73,0x88(%edi,%ebx,1)
8010414b:	73 
  switchuvm(curproc);
8010414c:	89 3c 24             	mov    %edi,(%esp)
8010414f:	e8 6c 32 00 00       	call   801073c0 <switchuvm>
  return (char*)KERNBASE-(idx+1)*PGSIZE;
80104154:	83 c4 10             	add    $0x10,%esp
}
80104157:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010415a:	89 f0                	mov    %esi,%eax
8010415c:	5b                   	pop    %ebx
8010415d:	5e                   	pop    %esi
8010415e:	5f                   	pop    %edi
8010415f:	5d                   	pop    %ebp
80104160:	c3                   	ret    
80104161:	eb 0d                	jmp    80104170 <growproc>
80104163:	90                   	nop
80104164:	90                   	nop
80104165:	90                   	nop
80104166:	90                   	nop
80104167:	90                   	nop
80104168:	90                   	nop
80104169:	90                   	nop
8010416a:	90                   	nop
8010416b:	90                   	nop
8010416c:	90                   	nop
8010416d:	90                   	nop
8010416e:	90                   	nop
8010416f:	90                   	nop

80104170 <growproc>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
80104175:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104178:	e8 73 0a 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
8010417d:	e8 5e fc ff ff       	call   80103de0 <mycpu>
  p = c->proc;
80104182:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104188:	e8 73 0b 00 00       	call   80104d00 <popcli>
  sz = curproc->sz;
8010418d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010418f:	85 f6                	test   %esi,%esi
80104191:	7f 1d                	jg     801041b0 <growproc+0x40>
  } else if(n < 0){
80104193:	75 3b                	jne    801041d0 <growproc+0x60>
  switchuvm(curproc);
80104195:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104198:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010419a:	53                   	push   %ebx
8010419b:	e8 20 32 00 00       	call   801073c0 <switchuvm>
  return 0;
801041a0:	83 c4 10             	add    $0x10,%esp
801041a3:	31 c0                	xor    %eax,%eax
}
801041a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041a8:	5b                   	pop    %ebx
801041a9:	5e                   	pop    %esi
801041aa:	5d                   	pop    %ebp
801041ab:	c3                   	ret    
801041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041b0:	83 ec 04             	sub    $0x4,%esp
801041b3:	01 c6                	add    %eax,%esi
801041b5:	56                   	push   %esi
801041b6:	50                   	push   %eax
801041b7:	ff 73 04             	pushl  0x4(%ebx)
801041ba:	e8 31 35 00 00       	call   801076f0 <allocuvm>
801041bf:	83 c4 10             	add    $0x10,%esp
801041c2:	85 c0                	test   %eax,%eax
801041c4:	75 cf                	jne    80104195 <growproc+0x25>
      return -1;
801041c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041cb:	eb d8                	jmp    801041a5 <growproc+0x35>
801041cd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041d0:	83 ec 04             	sub    $0x4,%esp
801041d3:	01 c6                	add    %eax,%esi
801041d5:	56                   	push   %esi
801041d6:	50                   	push   %eax
801041d7:	ff 73 04             	pushl  0x4(%ebx)
801041da:	e8 31 36 00 00       	call   80107810 <deallocuvm>
801041df:	83 c4 10             	add    $0x10,%esp
801041e2:	85 c0                	test   %eax,%eax
801041e4:	75 af                	jne    80104195 <growproc+0x25>
801041e6:	eb de                	jmp    801041c6 <growproc+0x56>
801041e8:	90                   	nop
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <fork>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	56                   	push   %esi
801041f5:	53                   	push   %ebx
801041f6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801041f9:	e8 f2 09 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
801041fe:	e8 dd fb ff ff       	call   80103de0 <mycpu>
  p = c->proc;
80104203:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104209:	e8 f2 0a 00 00       	call   80104d00 <popcli>
  if((np = allocproc()) == 0){
8010420e:	e8 6d fa ff ff       	call   80103c80 <allocproc>
80104213:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104216:	85 c0                	test   %eax,%eax
80104218:	0f 84 df 00 00 00    	je     801042fd <fork+0x10d>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010421e:	83 ec 08             	sub    $0x8,%esp
80104221:	ff 33                	pushl  (%ebx)
80104223:	89 c7                	mov    %eax,%edi
80104225:	ff 73 04             	pushl  0x4(%ebx)
80104228:	e8 a3 37 00 00       	call   801079d0 <copyuvm>
8010422d:	83 c4 10             	add    $0x10,%esp
80104230:	89 47 04             	mov    %eax,0x4(%edi)
80104233:	85 c0                	test   %eax,%eax
80104235:	0f 84 c9 00 00 00    	je     80104304 <fork+0x114>
  np->sz = curproc->sz;
8010423b:	8b 03                	mov    (%ebx),%eax
8010423d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80104240:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80104245:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80104247:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
8010424a:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
8010424d:	8b 73 18             	mov    0x18(%ebx),%esi
80104250:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104252:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104254:	8b 42 18             	mov    0x18(%edx),%eax
80104257:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010425e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80104260:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104264:	85 c0                	test   %eax,%eax
80104266:	74 13                	je     8010427b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	50                   	push   %eax
8010426c:	e8 ff d0 ff ff       	call   80101370 <filedup>
80104271:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104274:	83 c4 10             	add    $0x10,%esp
80104277:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010427b:	83 c6 01             	add    $0x1,%esi
8010427e:	83 fe 10             	cmp    $0x10,%esi
80104281:	75 dd                	jne    80104260 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104283:	83 ec 0c             	sub    $0xc,%esp
80104286:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104289:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010428c:	e8 8f d9 ff ff       	call   80101c20 <idup>
80104291:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104294:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104297:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010429a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010429d:	6a 10                	push   $0x10
8010429f:	53                   	push   %ebx
801042a0:	50                   	push   %eax
801042a1:	e8 da 0c 00 00       	call   80104f80 <safestrcpy>
  pid = np->pid;
801042a6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801042a9:	c7 04 24 e0 cd 11 80 	movl   $0x8011cde0,(%esp)
801042b0:	e8 8b 09 00 00       	call   80104c40 <acquire>
  np->state = RUNNABLE;
801042b5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  qpush(np);
801042bc:	89 3c 24             	mov    %edi,(%esp)
801042bf:	e8 ec fb ff ff       	call   80103eb0 <qpush>
  for(i=1;i<MAXSHAREDPG;i++)
801042c4:	8d 87 89 00 00 00    	lea    0x89(%edi),%eax
801042ca:	8d 97 92 00 00 00    	lea    0x92(%edi),%edx
801042d0:	83 c4 10             	add    $0x10,%esp
801042d3:	90                   	nop
801042d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->sharedrec[i]=0;
801042d8:	c6 00 00             	movb   $0x0,(%eax)
801042db:	83 c0 01             	add    $0x1,%eax
  for(i=1;i<MAXSHAREDPG;i++)
801042de:	39 c2                	cmp    %eax,%edx
801042e0:	75 f6                	jne    801042d8 <fork+0xe8>
  asm volatile("cli");
801042e2:	fa                   	cli    
  release(&ptable.lock);
801042e3:	83 ec 0c             	sub    $0xc,%esp
801042e6:	68 e0 cd 11 80       	push   $0x8011cde0
801042eb:	e8 70 0a 00 00       	call   80104d60 <release>
  return pid;
801042f0:	83 c4 10             	add    $0x10,%esp
}
801042f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f6:	89 d8                	mov    %ebx,%eax
801042f8:	5b                   	pop    %ebx
801042f9:	5e                   	pop    %esi
801042fa:	5f                   	pop    %edi
801042fb:	5d                   	pop    %ebp
801042fc:	c3                   	ret    
    return -1;
801042fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104302:	eb ef                	jmp    801042f3 <fork+0x103>
    kfree(np->kstack);
80104304:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104307:	83 ec 0c             	sub    $0xc,%esp
8010430a:	ff 73 08             	pushl  0x8(%ebx)
8010430d:	e8 0e e6 ff ff       	call   80102920 <kfree>
    np->kstack = 0;
80104312:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104319:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010431c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104323:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104328:	eb c9                	jmp    801042f3 <fork+0x103>
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <schedulerR>:
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	53                   	push   %ebx
80104336:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104339:	e8 a2 fa ff ff       	call   80103de0 <mycpu>
  c->proc = 0;
8010433e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104345:	00 00 00 
  struct cpu *c = mycpu();
80104348:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010434a:	8d 78 04             	lea    0x4(%eax),%edi
8010434d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104350:	fb                   	sti    
    acquire(&ptable.lock);
80104351:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104354:	bb 14 ce 11 80       	mov    $0x8011ce14,%ebx
    acquire(&ptable.lock);
80104359:	68 e0 cd 11 80       	push   $0x8011cde0
8010435e:	e8 dd 08 00 00       	call   80104c40 <acquire>
80104363:	83 c4 10             	add    $0x10,%esp
80104366:	8d 76 00             	lea    0x0(%esi),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104370:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104374:	75 33                	jne    801043a9 <schedulerR+0x79>
      switchuvm(p);
80104376:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104379:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010437f:	53                   	push   %ebx
80104380:	e8 3b 30 00 00       	call   801073c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104385:	58                   	pop    %eax
80104386:	5a                   	pop    %edx
80104387:	ff 73 1c             	pushl  0x1c(%ebx)
8010438a:	57                   	push   %edi
      p->state = RUNNING;
8010438b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104392:	e8 44 0c 00 00       	call   80104fdb <swtch>
      switchkvm();
80104397:	e8 14 30 00 00       	call   801073b0 <switchkvm>
      c->proc = 0;
8010439c:	83 c4 10             	add    $0x10,%esp
8010439f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801043a6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a9:	81 c3 98 00 00 00    	add    $0x98,%ebx
801043af:	81 fb 14 f4 11 80    	cmp    $0x8011f414,%ebx
801043b5:	75 b9                	jne    80104370 <schedulerR+0x40>
    release(&ptable.lock);
801043b7:	83 ec 0c             	sub    $0xc,%esp
801043ba:	68 e0 cd 11 80       	push   $0x8011cde0
801043bf:	e8 9c 09 00 00       	call   80104d60 <release>
    sti();
801043c4:	83 c4 10             	add    $0x10,%esp
801043c7:	eb 87                	jmp    80104350 <schedulerR+0x20>
801043c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043d0 <scheduler>:
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	57                   	push   %edi
801043d4:	56                   	push   %esi
801043d5:	53                   	push   %ebx
801043d6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801043d9:	e8 02 fa ff ff       	call   80103de0 <mycpu>
  c->proc = 0;
801043de:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801043e5:	00 00 00 
  struct cpu *c = mycpu();
801043e8:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
801043ea:	8d 70 04             	lea    0x4(%eax),%esi
801043ed:	8d 76 00             	lea    0x0(%esi),%esi
801043f0:	fb                   	sti    
    acquire(&ptable.lock);
801043f1:	83 ec 0c             	sub    $0xc,%esp
801043f4:	68 e0 cd 11 80       	push   $0x8011cde0
801043f9:	e8 42 08 00 00       	call   80104c40 <acquire>
801043fe:	83 c4 10             	add    $0x10,%esp
    int queue=NPROCQ-1;
80104401:	ba 02 00 00 00       	mov    $0x2,%edx
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80104406:	8b 04 95 2c f4 11 80 	mov    -0x7fee0bd4(,%edx,4),%eax
8010440d:	85 c0                	test   %eax,%eax
8010440f:	74 33                	je     80104444 <scheduler+0x74>
80104411:	8b 3c d5 14 f4 11 80 	mov    -0x7fee0bec(,%edx,8),%edi
80104418:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
8010441c:	75 10                	jne    8010442e <scheduler+0x5e>
8010441e:	e9 ac 00 00 00       	jmp    801044cf <scheduler+0xff>
80104423:	90                   	nop
80104424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104428:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
8010442c:	74 32                	je     80104460 <scheduler+0x90>
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
8010442e:	8b 7f 7c             	mov    0x7c(%edi),%edi
        ptable.count[queue]--;
80104431:	83 e8 01             	sub    $0x1,%eax
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80104434:	89 3c d5 14 f4 11 80 	mov    %edi,-0x7fee0bec(,%edx,8)
        ptable.count[queue]--;
8010443b:	89 04 95 2c f4 11 80 	mov    %eax,-0x7fee0bd4(,%edx,4)
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80104442:	75 e4                	jne    80104428 <scheduler+0x58>
    for(;queue>=0;queue--)
80104444:	83 ea 01             	sub    $0x1,%edx
80104447:	83 fa ff             	cmp    $0xffffffff,%edx
8010444a:	75 ba                	jne    80104406 <scheduler+0x36>
    release(&ptable.lock);
8010444c:	83 ec 0c             	sub    $0xc,%esp
8010444f:	68 e0 cd 11 80       	push   $0x8011cde0
80104454:	e8 07 09 00 00       	call   80104d60 <release>
  for(;;){
80104459:	83 c4 10             	add    $0x10,%esp
8010445c:	eb 92                	jmp    801043f0 <scheduler+0x20>
8010445e:	66 90                	xchg   %ax,%ax
80104460:	8d 8a c6 04 00 00    	lea    0x4c6(%edx),%ecx
80104466:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104469:	8b 3c cd e4 cd 11 80 	mov    -0x7fee321c(,%ecx,8),%edi
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80104470:	8b 47 7c             	mov    0x7c(%edi),%eax
        switchuvm(p);
80104473:	83 ec 0c             	sub    $0xc,%esp
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80104476:	89 04 cd e4 cd 11 80 	mov    %eax,-0x7fee321c(,%ecx,8)
        ptable.count[queue]--;
8010447d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104480:	83 e8 01             	sub    $0x1,%eax
80104483:	89 04 95 2c f4 11 80 	mov    %eax,-0x7fee0bd4(,%edx,4)
        c->proc = p;
8010448a:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(p);
80104490:	57                   	push   %edi
80104491:	e8 2a 2f 00 00       	call   801073c0 <switchuvm>
        p->state = RUNNING;
80104496:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&(c->scheduler), p->context);
8010449d:	58                   	pop    %eax
8010449e:	5a                   	pop    %edx
8010449f:	ff 77 1c             	pushl  0x1c(%edi)
801044a2:	56                   	push   %esi
801044a3:	e8 33 0b 00 00       	call   80104fdb <swtch>
        switchkvm();
801044a8:	e8 03 2f 00 00       	call   801073b0 <switchkvm>
        break;
801044ad:	83 c4 10             	add    $0x10,%esp
        c->proc = 0;
801044b0:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801044b7:	00 00 00 
    release(&ptable.lock);
801044ba:	83 ec 0c             	sub    $0xc,%esp
801044bd:	68 e0 cd 11 80       	push   $0x8011cde0
801044c2:	e8 99 08 00 00       	call   80104d60 <release>
  for(;;){
801044c7:	83 c4 10             	add    $0x10,%esp
801044ca:	e9 21 ff ff ff       	jmp    801043f0 <scheduler+0x20>
801044cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801044d2:	8d 8a c6 04 00 00    	lea    0x4c6(%edx),%ecx
801044d8:	eb 96                	jmp    80104470 <scheduler+0xa0>
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <sched>:
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	56                   	push   %esi
801044e4:	53                   	push   %ebx
  pushcli();
801044e5:	e8 06 07 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
801044ea:	e8 f1 f8 ff ff       	call   80103de0 <mycpu>
  p = c->proc;
801044ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044f5:	e8 06 08 00 00       	call   80104d00 <popcli>
  if(!holding(&ptable.lock))
801044fa:	83 ec 0c             	sub    $0xc,%esp
801044fd:	68 e0 cd 11 80       	push   $0x8011cde0
80104502:	e8 a9 06 00 00       	call   80104bb0 <holding>
80104507:	83 c4 10             	add    $0x10,%esp
8010450a:	85 c0                	test   %eax,%eax
8010450c:	74 4f                	je     8010455d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010450e:	e8 cd f8 ff ff       	call   80103de0 <mycpu>
80104513:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010451a:	75 68                	jne    80104584 <sched+0xa4>
  if(p->state == RUNNING)
8010451c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104520:	74 55                	je     80104577 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104522:	9c                   	pushf  
80104523:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104524:	f6 c4 02             	test   $0x2,%ah
80104527:	75 41                	jne    8010456a <sched+0x8a>
  intena = mycpu()->intena;
80104529:	e8 b2 f8 ff ff       	call   80103de0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010452e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104531:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104537:	e8 a4 f8 ff ff       	call   80103de0 <mycpu>
8010453c:	83 ec 08             	sub    $0x8,%esp
8010453f:	ff 70 04             	pushl  0x4(%eax)
80104542:	53                   	push   %ebx
80104543:	e8 93 0a 00 00       	call   80104fdb <swtch>
  mycpu()->intena = intena;
80104548:	e8 93 f8 ff ff       	call   80103de0 <mycpu>
}
8010454d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104550:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104556:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104559:	5b                   	pop    %ebx
8010455a:	5e                   	pop    %esi
8010455b:	5d                   	pop    %ebp
8010455c:	c3                   	ret    
    panic("sched ptable.lock");
8010455d:	83 ec 0c             	sub    $0xc,%esp
80104560:	68 30 81 10 80       	push   $0x80108130
80104565:	e8 26 be ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	68 5c 81 10 80       	push   $0x8010815c
80104572:	e8 19 be ff ff       	call   80100390 <panic>
    panic("sched running");
80104577:	83 ec 0c             	sub    $0xc,%esp
8010457a:	68 4e 81 10 80       	push   $0x8010814e
8010457f:	e8 0c be ff ff       	call   80100390 <panic>
    panic("sched locks");
80104584:	83 ec 0c             	sub    $0xc,%esp
80104587:	68 42 81 10 80       	push   $0x80108142
8010458c:	e8 ff bd ff ff       	call   80100390 <panic>
80104591:	eb 0d                	jmp    801045a0 <exit>
80104593:	90                   	nop
80104594:	90                   	nop
80104595:	90                   	nop
80104596:	90                   	nop
80104597:	90                   	nop
80104598:	90                   	nop
80104599:	90                   	nop
8010459a:	90                   	nop
8010459b:	90                   	nop
8010459c:	90                   	nop
8010459d:	90                   	nop
8010459e:	90                   	nop
8010459f:	90                   	nop

801045a0 <exit>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
801045a5:	53                   	push   %ebx
801045a6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801045a9:	e8 42 06 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
801045ae:	e8 2d f8 ff ff       	call   80103de0 <mycpu>
  p = c->proc;
801045b3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045b9:	e8 42 07 00 00       	call   80104d00 <popcli>
  if(curproc == initproc)
801045be:	8d 5e 28             	lea    0x28(%esi),%ebx
801045c1:	8d 7e 68             	lea    0x68(%esi),%edi
801045c4:	39 35 d8 b5 10 80    	cmp    %esi,0x8010b5d8
801045ca:	0f 84 b1 00 00 00    	je     80104681 <exit+0xe1>
    if(curproc->ofile[fd]){
801045d0:	8b 03                	mov    (%ebx),%eax
801045d2:	85 c0                	test   %eax,%eax
801045d4:	74 12                	je     801045e8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801045d6:	83 ec 0c             	sub    $0xc,%esp
801045d9:	50                   	push   %eax
801045da:	e8 e1 cd ff ff       	call   801013c0 <fileclose>
      curproc->ofile[fd] = 0;
801045df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801045e5:	83 c4 10             	add    $0x10,%esp
801045e8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
801045eb:	39 fb                	cmp    %edi,%ebx
801045ed:	75 e1                	jne    801045d0 <exit+0x30>
  begin_op();
801045ef:	e8 dc eb ff ff       	call   801031d0 <begin_op>
  iput(curproc->cwd);
801045f4:	83 ec 0c             	sub    $0xc,%esp
801045f7:	ff 76 68             	pushl  0x68(%esi)
801045fa:	e8 81 d7 ff ff       	call   80101d80 <iput>
  end_op();
801045ff:	e8 3c ec ff ff       	call   80103240 <end_op>
  curproc->cwd = 0;
80104604:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  asm volatile("cli");
8010460b:	fa                   	cli    
  acquire(&ptable.lock);
8010460c:	c7 04 24 e0 cd 11 80 	movl   $0x8011cde0,(%esp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104613:	bb 14 ce 11 80       	mov    $0x8011ce14,%ebx
  acquire(&ptable.lock);
80104618:	e8 23 06 00 00       	call   80104c40 <acquire>
  wakeup1(curproc->parent);
8010461d:	8b 46 14             	mov    0x14(%esi),%eax
80104620:	e8 1b f9 ff ff       	call   80103f40 <wakeup1>
80104625:	83 c4 10             	add    $0x10,%esp
80104628:	eb 14                	jmp    8010463e <exit+0x9e>
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104630:	81 c3 98 00 00 00    	add    $0x98,%ebx
80104636:	81 fb 14 f4 11 80    	cmp    $0x8011f414,%ebx
8010463c:	74 2a                	je     80104668 <exit+0xc8>
    if(p->parent == curproc){
8010463e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104641:	75 ed                	jne    80104630 <exit+0x90>
      p->parent = initproc;
80104643:	a1 d8 b5 10 80       	mov    0x8010b5d8,%eax
      if(p->state == ZOMBIE)
80104648:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
8010464c:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
8010464f:	75 df                	jne    80104630 <exit+0x90>
        wakeup1(initproc);
80104651:	e8 ea f8 ff ff       	call   80103f40 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104656:	81 c3 98 00 00 00    	add    $0x98,%ebx
8010465c:	81 fb 14 f4 11 80    	cmp    $0x8011f414,%ebx
80104662:	75 da                	jne    8010463e <exit+0x9e>
80104664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
80104668:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010466f:	e8 6c fe ff ff       	call   801044e0 <sched>
  panic("zombie exit");
80104674:	83 ec 0c             	sub    $0xc,%esp
80104677:	68 7d 81 10 80       	push   $0x8010817d
8010467c:	e8 0f bd ff ff       	call   80100390 <panic>
    panic("init exiting");
80104681:	83 ec 0c             	sub    $0xc,%esp
80104684:	68 70 81 10 80       	push   $0x80108170
80104689:	e8 02 bd ff ff       	call   80100390 <panic>
8010468e:	66 90                	xchg   %ax,%ax

80104690 <yield>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	53                   	push   %ebx
80104694:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104697:	e8 54 05 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
8010469c:	e8 3f f7 ff ff       	call   80103de0 <mycpu>
  p = c->proc;
801046a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046a7:	e8 54 06 00 00       	call   80104d00 <popcli>
  acquire(&ptable.lock);  //DOC: yieldlock
801046ac:	83 ec 0c             	sub    $0xc,%esp
801046af:	68 e0 cd 11 80       	push   $0x8011cde0
801046b4:	e8 87 05 00 00       	call   80104c40 <acquire>
  if(p->priority>0)
801046b9:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  p->state = RUNNABLE;
801046bf:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  if(p->priority>0)
801046c6:	83 c4 10             	add    $0x10,%esp
801046c9:	85 c0                	test   %eax,%eax
801046cb:	74 09                	je     801046d6 <yield+0x46>
    p->priority--;
801046cd:	83 e8 01             	sub    $0x1,%eax
801046d0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  qpush(p);
801046d6:	83 ec 0c             	sub    $0xc,%esp
801046d9:	53                   	push   %ebx
801046da:	e8 d1 f7 ff ff       	call   80103eb0 <qpush>
  sched();
801046df:	e8 fc fd ff ff       	call   801044e0 <sched>
  release(&ptable.lock);
801046e4:	c7 04 24 e0 cd 11 80 	movl   $0x8011cde0,(%esp)
801046eb:	e8 70 06 00 00       	call   80104d60 <release>
}
801046f0:	83 c4 10             	add    $0x10,%esp
801046f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f6:	c9                   	leave  
801046f7:	c3                   	ret    
801046f8:	90                   	nop
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104700 <sleep>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	56                   	push   %esi
80104705:	53                   	push   %ebx
80104706:	83 ec 0c             	sub    $0xc,%esp
80104709:	8b 7d 08             	mov    0x8(%ebp),%edi
8010470c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010470f:	e8 dc 04 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
80104714:	e8 c7 f6 ff ff       	call   80103de0 <mycpu>
  p = c->proc;
80104719:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010471f:	e8 dc 05 00 00       	call   80104d00 <popcli>
  if(p == 0)
80104724:	85 db                	test   %ebx,%ebx
80104726:	0f 84 87 00 00 00    	je     801047b3 <sleep+0xb3>
  if(lk == 0)
8010472c:	85 f6                	test   %esi,%esi
8010472e:	74 76                	je     801047a6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104730:	81 fe e0 cd 11 80    	cmp    $0x8011cde0,%esi
80104736:	74 50                	je     80104788 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	68 e0 cd 11 80       	push   $0x8011cde0
80104740:	e8 fb 04 00 00       	call   80104c40 <acquire>
    release(lk);
80104745:	89 34 24             	mov    %esi,(%esp)
80104748:	e8 13 06 00 00       	call   80104d60 <release>
  p->chan = chan;
8010474d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104750:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104757:	e8 84 fd ff ff       	call   801044e0 <sched>
  p->chan = 0;
8010475c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104763:	c7 04 24 e0 cd 11 80 	movl   $0x8011cde0,(%esp)
8010476a:	e8 f1 05 00 00       	call   80104d60 <release>
    acquire(lk);
8010476f:	89 75 08             	mov    %esi,0x8(%ebp)
80104772:	83 c4 10             	add    $0x10,%esp
}
80104775:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104778:	5b                   	pop    %ebx
80104779:	5e                   	pop    %esi
8010477a:	5f                   	pop    %edi
8010477b:	5d                   	pop    %ebp
    acquire(lk);
8010477c:	e9 bf 04 00 00       	jmp    80104c40 <acquire>
80104781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104788:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010478b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104792:	e8 49 fd ff ff       	call   801044e0 <sched>
  p->chan = 0;
80104797:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010479e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047a1:	5b                   	pop    %ebx
801047a2:	5e                   	pop    %esi
801047a3:	5f                   	pop    %edi
801047a4:	5d                   	pop    %ebp
801047a5:	c3                   	ret    
    panic("sleep without lk");
801047a6:	83 ec 0c             	sub    $0xc,%esp
801047a9:	68 8f 81 10 80       	push   $0x8010818f
801047ae:	e8 dd bb ff ff       	call   80100390 <panic>
    panic("sleep");
801047b3:	83 ec 0c             	sub    $0xc,%esp
801047b6:	68 89 81 10 80       	push   $0x80108189
801047bb:	e8 d0 bb ff ff       	call   80100390 <panic>

801047c0 <wait>:
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
  pushcli();
801047c5:	e8 26 04 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
801047ca:	e8 11 f6 ff ff       	call   80103de0 <mycpu>
  p = c->proc;
801047cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801047d5:	e8 26 05 00 00       	call   80104d00 <popcli>
  acquire(&ptable.lock);
801047da:	83 ec 0c             	sub    $0xc,%esp
801047dd:	68 e0 cd 11 80       	push   $0x8011cde0
801047e2:	e8 59 04 00 00       	call   80104c40 <acquire>
801047e7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801047ea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047ec:	bb 14 ce 11 80       	mov    $0x8011ce14,%ebx
801047f1:	eb 13                	jmp    80104806 <wait+0x46>
801047f3:	90                   	nop
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f8:	81 c3 98 00 00 00    	add    $0x98,%ebx
801047fe:	81 fb 14 f4 11 80    	cmp    $0x8011f414,%ebx
80104804:	74 1e                	je     80104824 <wait+0x64>
      if(p->parent != curproc)
80104806:	39 73 14             	cmp    %esi,0x14(%ebx)
80104809:	75 ed                	jne    801047f8 <wait+0x38>
      if(p->state == ZOMBIE){
8010480b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010480f:	74 37                	je     80104848 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104811:	81 c3 98 00 00 00    	add    $0x98,%ebx
      havekids = 1;
80104817:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010481c:	81 fb 14 f4 11 80    	cmp    $0x8011f414,%ebx
80104822:	75 e2                	jne    80104806 <wait+0x46>
    if(!havekids || curproc->killed){
80104824:	85 c0                	test   %eax,%eax
80104826:	74 76                	je     8010489e <wait+0xde>
80104828:	8b 46 24             	mov    0x24(%esi),%eax
8010482b:	85 c0                	test   %eax,%eax
8010482d:	75 6f                	jne    8010489e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010482f:	83 ec 08             	sub    $0x8,%esp
80104832:	68 e0 cd 11 80       	push   $0x8011cde0
80104837:	56                   	push   %esi
80104838:	e8 c3 fe ff ff       	call   80104700 <sleep>
    havekids = 0;
8010483d:	83 c4 10             	add    $0x10,%esp
80104840:	eb a8                	jmp    801047ea <wait+0x2a>
80104842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104848:	83 ec 0c             	sub    $0xc,%esp
8010484b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010484e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104851:	e8 ca e0 ff ff       	call   80102920 <kfree>
        freevm(p->pgdir);
80104856:	5a                   	pop    %edx
80104857:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010485a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104861:	e8 1a 30 00 00       	call   80107880 <freevm>
        release(&ptable.lock);
80104866:	c7 04 24 e0 cd 11 80 	movl   $0x8011cde0,(%esp)
        p->pid = 0;
8010486d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104874:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010487b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010487f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104886:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010488d:	e8 ce 04 00 00       	call   80104d60 <release>
        return pid;
80104892:	83 c4 10             	add    $0x10,%esp
}
80104895:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104898:	89 f0                	mov    %esi,%eax
8010489a:	5b                   	pop    %ebx
8010489b:	5e                   	pop    %esi
8010489c:	5d                   	pop    %ebp
8010489d:	c3                   	ret    
      release(&ptable.lock);
8010489e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801048a1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801048a6:	68 e0 cd 11 80       	push   $0x8011cde0
801048ab:	e8 b0 04 00 00       	call   80104d60 <release>
      return -1;
801048b0:	83 c4 10             	add    $0x10,%esp
801048b3:	eb e0                	jmp    80104895 <wait+0xd5>
801048b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048c0 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	83 ec 10             	sub    $0x10,%esp
801048c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801048ca:	68 e0 cd 11 80       	push   $0x8011cde0
801048cf:	e8 6c 03 00 00       	call   80104c40 <acquire>
  wakeup1(chan);
801048d4:	89 d8                	mov    %ebx,%eax
801048d6:	e8 65 f6 ff ff       	call   80103f40 <wakeup1>
  release(&ptable.lock);
801048db:	83 c4 10             	add    $0x10,%esp
801048de:	c7 45 08 e0 cd 11 80 	movl   $0x8011cde0,0x8(%ebp)
}
801048e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e8:	c9                   	leave  
  release(&ptable.lock);
801048e9:	e9 72 04 00 00       	jmp    80104d60 <release>
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 10             	sub    $0x10,%esp
801048f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801048fa:	68 e0 cd 11 80       	push   $0x8011cde0
801048ff:	e8 3c 03 00 00       	call   80104c40 <acquire>
80104904:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104907:	b8 14 ce 11 80       	mov    $0x8011ce14,%eax
8010490c:	eb 0e                	jmp    8010491c <kill+0x2c>
8010490e:	66 90                	xchg   %ax,%ax
80104910:	05 98 00 00 00       	add    $0x98,%eax
80104915:	3d 14 f4 11 80       	cmp    $0x8011f414,%eax
8010491a:	74 34                	je     80104950 <kill+0x60>
    if(p->pid == pid){
8010491c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010491f:	75 ef                	jne    80104910 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104921:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104925:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010492c:	75 07                	jne    80104935 <kill+0x45>
        p->state = RUNNABLE;
8010492e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104935:	83 ec 0c             	sub    $0xc,%esp
80104938:	68 e0 cd 11 80       	push   $0x8011cde0
8010493d:	e8 1e 04 00 00       	call   80104d60 <release>
      return 0;
80104942:	83 c4 10             	add    $0x10,%esp
80104945:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104947:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010494a:	c9                   	leave  
8010494b:	c3                   	ret    
8010494c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104950:	83 ec 0c             	sub    $0xc,%esp
80104953:	68 e0 cd 11 80       	push   $0x8011cde0
80104958:	e8 03 04 00 00       	call   80104d60 <release>
  return -1;
8010495d:	83 c4 10             	add    $0x10,%esp
80104960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104965:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104968:	c9                   	leave  
80104969:	c3                   	ret    
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	56                   	push   %esi
80104975:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104978:	53                   	push   %ebx
80104979:	bb 80 ce 11 80       	mov    $0x8011ce80,%ebx
8010497e:	83 ec 3c             	sub    $0x3c,%esp
80104981:	eb 27                	jmp    801049aa <procdump+0x3a>
80104983:	90                   	nop
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104988:	83 ec 0c             	sub    $0xc,%esp
8010498b:	68 39 85 10 80       	push   $0x80108539
80104990:	e8 0b bd ff ff       	call   801006a0 <cprintf>
80104995:	83 c4 10             	add    $0x10,%esp
80104998:	81 c3 98 00 00 00    	add    $0x98,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010499e:	81 fb 80 f4 11 80    	cmp    $0x8011f480,%ebx
801049a4:	0f 84 7e 00 00 00    	je     80104a28 <procdump+0xb8>
    if(p->state == UNUSED)
801049aa:	8b 43 a0             	mov    -0x60(%ebx),%eax
801049ad:	85 c0                	test   %eax,%eax
801049af:	74 e7                	je     80104998 <procdump+0x28>
      state = "???";
801049b1:	ba a0 81 10 80       	mov    $0x801081a0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801049b6:	83 f8 05             	cmp    $0x5,%eax
801049b9:	77 11                	ja     801049cc <procdump+0x5c>
801049bb:	8b 14 85 00 82 10 80 	mov    -0x7fef7e00(,%eax,4),%edx
      state = "???";
801049c2:	b8 a0 81 10 80       	mov    $0x801081a0,%eax
801049c7:	85 d2                	test   %edx,%edx
801049c9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801049cc:	53                   	push   %ebx
801049cd:	52                   	push   %edx
801049ce:	ff 73 a4             	pushl  -0x5c(%ebx)
801049d1:	68 a4 81 10 80       	push   $0x801081a4
801049d6:	e8 c5 bc ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801049db:	83 c4 10             	add    $0x10,%esp
801049de:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801049e2:	75 a4                	jne    80104988 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801049e4:	83 ec 08             	sub    $0x8,%esp
801049e7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801049ea:	8d 7d c0             	lea    -0x40(%ebp),%edi
801049ed:	50                   	push   %eax
801049ee:	8b 43 b0             	mov    -0x50(%ebx),%eax
801049f1:	8b 40 0c             	mov    0xc(%eax),%eax
801049f4:	83 c0 08             	add    $0x8,%eax
801049f7:	50                   	push   %eax
801049f8:	e8 63 01 00 00       	call   80104b60 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801049fd:	83 c4 10             	add    $0x10,%esp
80104a00:	8b 17                	mov    (%edi),%edx
80104a02:	85 d2                	test   %edx,%edx
80104a04:	74 82                	je     80104988 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104a06:	83 ec 08             	sub    $0x8,%esp
80104a09:	83 c7 04             	add    $0x4,%edi
80104a0c:	52                   	push   %edx
80104a0d:	68 c1 7b 10 80       	push   $0x80107bc1
80104a12:	e8 89 bc ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a17:	83 c4 10             	add    $0x10,%esp
80104a1a:	39 fe                	cmp    %edi,%esi
80104a1c:	75 e2                	jne    80104a00 <procdump+0x90>
80104a1e:	e9 65 ff ff ff       	jmp    80104988 <procdump+0x18>
80104a23:	90                   	nop
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a2b:	5b                   	pop    %ebx
80104a2c:	5e                   	pop    %esi
80104a2d:	5f                   	pop    %edi
80104a2e:	5d                   	pop    %ebp
80104a2f:	c3                   	ret    

80104a30 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 0c             	sub    $0xc,%esp
80104a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a3a:	68 18 82 10 80       	push   $0x80108218
80104a3f:	8d 43 04             	lea    0x4(%ebx),%eax
80104a42:	50                   	push   %eax
80104a43:	e8 f8 00 00 00       	call   80104b40 <initlock>
  lk->name = name;
80104a48:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104a4b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104a51:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104a54:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104a5b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104a5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a61:	c9                   	leave  
80104a62:	c3                   	ret    
80104a63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a78:	8d 73 04             	lea    0x4(%ebx),%esi
80104a7b:	83 ec 0c             	sub    $0xc,%esp
80104a7e:	56                   	push   %esi
80104a7f:	e8 bc 01 00 00       	call   80104c40 <acquire>
  while (lk->locked) {
80104a84:	8b 13                	mov    (%ebx),%edx
80104a86:	83 c4 10             	add    $0x10,%esp
80104a89:	85 d2                	test   %edx,%edx
80104a8b:	74 16                	je     80104aa3 <acquiresleep+0x33>
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104a90:	83 ec 08             	sub    $0x8,%esp
80104a93:	56                   	push   %esi
80104a94:	53                   	push   %ebx
80104a95:	e8 66 fc ff ff       	call   80104700 <sleep>
  while (lk->locked) {
80104a9a:	8b 03                	mov    (%ebx),%eax
80104a9c:	83 c4 10             	add    $0x10,%esp
80104a9f:	85 c0                	test   %eax,%eax
80104aa1:	75 ed                	jne    80104a90 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104aa3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104aa9:	e8 d2 f3 ff ff       	call   80103e80 <myproc>
80104aae:	8b 40 10             	mov    0x10(%eax),%eax
80104ab1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ab4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ab7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aba:	5b                   	pop    %ebx
80104abb:	5e                   	pop    %esi
80104abc:	5d                   	pop    %ebp
  release(&lk->lk);
80104abd:	e9 9e 02 00 00       	jmp    80104d60 <release>
80104ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ad8:	8d 73 04             	lea    0x4(%ebx),%esi
80104adb:	83 ec 0c             	sub    $0xc,%esp
80104ade:	56                   	push   %esi
80104adf:	e8 5c 01 00 00       	call   80104c40 <acquire>
  lk->locked = 0;
80104ae4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104aea:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104af1:	89 1c 24             	mov    %ebx,(%esp)
80104af4:	e8 c7 fd ff ff       	call   801048c0 <wakeup>
  release(&lk->lk);
80104af9:	89 75 08             	mov    %esi,0x8(%ebp)
80104afc:	83 c4 10             	add    $0x10,%esp
}
80104aff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b02:	5b                   	pop    %ebx
80104b03:	5e                   	pop    %esi
80104b04:	5d                   	pop    %ebp
  release(&lk->lk);
80104b05:	e9 56 02 00 00       	jmp    80104d60 <release>
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
80104b15:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104b18:	8d 5e 04             	lea    0x4(%esi),%ebx
80104b1b:	83 ec 0c             	sub    $0xc,%esp
80104b1e:	53                   	push   %ebx
80104b1f:	e8 1c 01 00 00       	call   80104c40 <acquire>
  r = lk->locked;
80104b24:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104b26:	89 1c 24             	mov    %ebx,(%esp)
80104b29:	e8 32 02 00 00       	call   80104d60 <release>
  return r;
}
80104b2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b31:	89 f0                	mov    %esi,%eax
80104b33:	5b                   	pop    %ebx
80104b34:	5e                   	pop    %esi
80104b35:	5d                   	pop    %ebp
80104b36:	c3                   	ret    
80104b37:	66 90                	xchg   %ax,%ax
80104b39:	66 90                	xchg   %ax,%ax
80104b3b:	66 90                	xchg   %ax,%ax
80104b3d:	66 90                	xchg   %ax,%ax
80104b3f:	90                   	nop

80104b40 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104b4f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104b52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b59:	5d                   	pop    %ebp
80104b5a:	c3                   	ret    
80104b5b:	90                   	nop
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b60 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b60:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b61:	31 d2                	xor    %edx,%edx
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104b66:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104b69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104b6c:	83 e8 08             	sub    $0x8,%eax
80104b6f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b70:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b76:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b7c:	77 1a                	ja     80104b98 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b7e:	8b 58 04             	mov    0x4(%eax),%ebx
80104b81:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b84:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b87:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b89:	83 fa 0a             	cmp    $0xa,%edx
80104b8c:	75 e2                	jne    80104b70 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b8e:	5b                   	pop    %ebx
80104b8f:	5d                   	pop    %ebp
80104b90:	c3                   	ret    
80104b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b98:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b9b:	8d 51 28             	lea    0x28(%ecx),%edx
80104b9e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ba6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ba9:	39 c2                	cmp    %eax,%edx
80104bab:	75 f3                	jne    80104ba0 <getcallerpcs+0x40>
}
80104bad:	5b                   	pop    %ebx
80104bae:	5d                   	pop    %ebp
80104baf:	c3                   	ret    

80104bb0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 04             	sub    $0x4,%esp
80104bb7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
80104bba:	8b 02                	mov    (%edx),%eax
80104bbc:	85 c0                	test   %eax,%eax
80104bbe:	75 10                	jne    80104bd0 <holding+0x20>
}
80104bc0:	83 c4 04             	add    $0x4,%esp
80104bc3:	31 c0                	xor    %eax,%eax
80104bc5:	5b                   	pop    %ebx
80104bc6:	5d                   	pop    %ebp
80104bc7:	c3                   	ret    
80104bc8:	90                   	nop
80104bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104bd0:	8b 5a 08             	mov    0x8(%edx),%ebx
80104bd3:	e8 08 f2 ff ff       	call   80103de0 <mycpu>
80104bd8:	39 c3                	cmp    %eax,%ebx
80104bda:	0f 94 c0             	sete   %al
}
80104bdd:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104be0:	0f b6 c0             	movzbl %al,%eax
}
80104be3:	5b                   	pop    %ebx
80104be4:	5d                   	pop    %ebp
80104be5:	c3                   	ret    
80104be6:	8d 76 00             	lea    0x0(%esi),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bf7:	9c                   	pushf  
80104bf8:	5b                   	pop    %ebx
  asm volatile("cli");
80104bf9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104bfa:	e8 e1 f1 ff ff       	call   80103de0 <mycpu>
80104bff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c05:	85 c0                	test   %eax,%eax
80104c07:	74 17                	je     80104c20 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104c09:	e8 d2 f1 ff ff       	call   80103de0 <mycpu>
80104c0e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c15:	83 c4 04             	add    $0x4,%esp
80104c18:	5b                   	pop    %ebx
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    
80104c1b:	90                   	nop
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    mycpu()->intena = eflags & FL_IF;
80104c20:	e8 bb f1 ff ff       	call   80103de0 <mycpu>
80104c25:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c2b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104c31:	eb d6                	jmp    80104c09 <pushcli+0x19>
80104c33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c40 <acquire>:
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104c45:	e8 a6 ff ff ff       	call   80104bf0 <pushcli>
  if(holding(lk))
80104c4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104c4d:	8b 03                	mov    (%ebx),%eax
80104c4f:	85 c0                	test   %eax,%eax
80104c51:	0f 85 81 00 00 00    	jne    80104cd8 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104c57:	ba 01 00 00 00       	mov    $0x1,%edx
80104c5c:	eb 05                	jmp    80104c63 <acquire+0x23>
80104c5e:	66 90                	xchg   %ax,%ax
80104c60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c63:	89 d0                	mov    %edx,%eax
80104c65:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104c68:	85 c0                	test   %eax,%eax
80104c6a:	75 f4                	jne    80104c60 <acquire+0x20>
  __sync_synchronize();
80104c6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c74:	e8 67 f1 ff ff       	call   80103de0 <mycpu>
  ebp = (uint*)v - 2;
80104c79:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104c7b:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104c7e:	31 c0                	xor    %eax,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c80:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
80104c86:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104c8c:	77 22                	ja     80104cb0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104c8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80104c91:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
80104c95:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104c98:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104c9a:	83 f8 0a             	cmp    $0xa,%eax
80104c9d:	75 e1                	jne    80104c80 <acquire+0x40>
}
80104c9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ca2:	5b                   	pop    %ebx
80104ca3:	5e                   	pop    %esi
80104ca4:	5d                   	pop    %ebp
80104ca5:	c3                   	ret    
80104ca6:	8d 76 00             	lea    0x0(%esi),%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104cb0:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
80104cb4:	83 c3 34             	add    $0x34,%ebx
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104cc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104cc6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104cc9:	39 c3                	cmp    %eax,%ebx
80104ccb:	75 f3                	jne    80104cc0 <acquire+0x80>
}
80104ccd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cd0:	5b                   	pop    %ebx
80104cd1:	5e                   	pop    %esi
80104cd2:	5d                   	pop    %ebp
80104cd3:	c3                   	ret    
80104cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104cd8:	8b 73 08             	mov    0x8(%ebx),%esi
80104cdb:	e8 00 f1 ff ff       	call   80103de0 <mycpu>
80104ce0:	39 c6                	cmp    %eax,%esi
80104ce2:	0f 85 6f ff ff ff    	jne    80104c57 <acquire+0x17>
    panic("acquire");
80104ce8:	83 ec 0c             	sub    $0xc,%esp
80104ceb:	68 23 82 10 80       	push   $0x80108223
80104cf0:	e8 9b b6 ff ff       	call   80100390 <panic>
80104cf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d00 <popcli>:

void
popcli(void)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d06:	9c                   	pushf  
80104d07:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d08:	f6 c4 02             	test   $0x2,%ah
80104d0b:	75 35                	jne    80104d42 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d0d:	e8 ce f0 ff ff       	call   80103de0 <mycpu>
80104d12:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d19:	78 34                	js     80104d4f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d1b:	e8 c0 f0 ff ff       	call   80103de0 <mycpu>
80104d20:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d26:	85 d2                	test   %edx,%edx
80104d28:	74 06                	je     80104d30 <popcli+0x30>
    sti();
}
80104d2a:	c9                   	leave  
80104d2b:	c3                   	ret    
80104d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d30:	e8 ab f0 ff ff       	call   80103de0 <mycpu>
80104d35:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d3b:	85 c0                	test   %eax,%eax
80104d3d:	74 eb                	je     80104d2a <popcli+0x2a>
  asm volatile("sti");
80104d3f:	fb                   	sti    
}
80104d40:	c9                   	leave  
80104d41:	c3                   	ret    
    panic("popcli - interruptible");
80104d42:	83 ec 0c             	sub    $0xc,%esp
80104d45:	68 2b 82 10 80       	push   $0x8010822b
80104d4a:	e8 41 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104d4f:	83 ec 0c             	sub    $0xc,%esp
80104d52:	68 42 82 10 80       	push   $0x80108242
80104d57:	e8 34 b6 ff ff       	call   80100390 <panic>
80104d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d60 <release>:
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	53                   	push   %ebx
80104d65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104d68:	8b 03                	mov    (%ebx),%eax
80104d6a:	85 c0                	test   %eax,%eax
80104d6c:	75 12                	jne    80104d80 <release+0x20>
    panic("release");
80104d6e:	83 ec 0c             	sub    $0xc,%esp
80104d71:	68 49 82 10 80       	push   $0x80108249
80104d76:	e8 15 b6 ff ff       	call   80100390 <panic>
80104d7b:	90                   	nop
80104d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104d80:	8b 73 08             	mov    0x8(%ebx),%esi
80104d83:	e8 58 f0 ff ff       	call   80103de0 <mycpu>
80104d88:	39 c6                	cmp    %eax,%esi
80104d8a:	75 e2                	jne    80104d6e <release+0xe>
  lk->pcs[0] = 0;
80104d8c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d93:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d9a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d9f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104da5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104da8:	5b                   	pop    %ebx
80104da9:	5e                   	pop    %esi
80104daa:	5d                   	pop    %ebp
  popcli();
80104dab:	e9 50 ff ff ff       	jmp    80104d00 <popcli>

80104db0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	57                   	push   %edi
80104db4:	8b 55 08             	mov    0x8(%ebp),%edx
80104db7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104dba:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
80104dbb:	89 d0                	mov    %edx,%eax
80104dbd:	09 c8                	or     %ecx,%eax
80104dbf:	a8 03                	test   $0x3,%al
80104dc1:	75 2d                	jne    80104df0 <memset+0x40>
    c &= 0xFF;
80104dc3:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104dc7:	c1 e9 02             	shr    $0x2,%ecx
80104dca:	89 f8                	mov    %edi,%eax
80104dcc:	89 fb                	mov    %edi,%ebx
80104dce:	c1 e0 18             	shl    $0x18,%eax
80104dd1:	c1 e3 10             	shl    $0x10,%ebx
80104dd4:	09 d8                	or     %ebx,%eax
80104dd6:	09 f8                	or     %edi,%eax
80104dd8:	c1 e7 08             	shl    $0x8,%edi
80104ddb:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ddd:	89 d7                	mov    %edx,%edi
80104ddf:	fc                   	cld    
80104de0:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104de2:	5b                   	pop    %ebx
80104de3:	89 d0                	mov    %edx,%eax
80104de5:	5f                   	pop    %edi
80104de6:	5d                   	pop    %ebp
80104de7:	c3                   	ret    
80104de8:	90                   	nop
80104de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104df0:	89 d7                	mov    %edx,%edi
80104df2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104df5:	fc                   	cld    
80104df6:	f3 aa                	rep stos %al,%es:(%edi)
80104df8:	5b                   	pop    %ebx
80104df9:	89 d0                	mov    %edx,%eax
80104dfb:	5f                   	pop    %edi
80104dfc:	5d                   	pop    %ebp
80104dfd:	c3                   	ret    
80104dfe:	66 90                	xchg   %ax,%ax

80104e00 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	8b 75 10             	mov    0x10(%ebp),%esi
80104e07:	8b 45 08             	mov    0x8(%ebp),%eax
80104e0a:	53                   	push   %ebx
80104e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e0e:	85 f6                	test   %esi,%esi
80104e10:	74 22                	je     80104e34 <memcmp+0x34>
    if(*s1 != *s2)
80104e12:	0f b6 08             	movzbl (%eax),%ecx
80104e15:	0f b6 1a             	movzbl (%edx),%ebx
80104e18:	01 c6                	add    %eax,%esi
80104e1a:	38 cb                	cmp    %cl,%bl
80104e1c:	74 0c                	je     80104e2a <memcmp+0x2a>
80104e1e:	eb 20                	jmp    80104e40 <memcmp+0x40>
80104e20:	0f b6 08             	movzbl (%eax),%ecx
80104e23:	0f b6 1a             	movzbl (%edx),%ebx
80104e26:	38 d9                	cmp    %bl,%cl
80104e28:	75 16                	jne    80104e40 <memcmp+0x40>
      return *s1 - *s2;
    s1++, s2++;
80104e2a:	83 c0 01             	add    $0x1,%eax
80104e2d:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104e30:	39 c6                	cmp    %eax,%esi
80104e32:	75 ec                	jne    80104e20 <memcmp+0x20>
  }

  return 0;
}
80104e34:	5b                   	pop    %ebx
  return 0;
80104e35:	31 c0                	xor    %eax,%eax
}
80104e37:	5e                   	pop    %esi
80104e38:	5d                   	pop    %ebp
80104e39:	c3                   	ret    
80104e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return *s1 - *s2;
80104e40:	0f b6 c1             	movzbl %cl,%eax
80104e43:	29 d8                	sub    %ebx,%eax
}
80104e45:	5b                   	pop    %ebx
80104e46:	5e                   	pop    %esi
80104e47:	5d                   	pop    %ebp
80104e48:	c3                   	ret    
80104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e50 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	57                   	push   %edi
80104e54:	8b 45 08             	mov    0x8(%ebp),%eax
80104e57:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e5a:	56                   	push   %esi
80104e5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e5e:	39 c6                	cmp    %eax,%esi
80104e60:	73 26                	jae    80104e88 <memmove+0x38>
80104e62:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104e65:	39 f8                	cmp    %edi,%eax
80104e67:	73 1f                	jae    80104e88 <memmove+0x38>
80104e69:	8d 51 ff             	lea    -0x1(%ecx),%edx
    s += n;
    d += n;
    while(n-- > 0)
80104e6c:	85 c9                	test   %ecx,%ecx
80104e6e:	74 0f                	je     80104e7f <memmove+0x2f>
      *--d = *--s;
80104e70:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104e74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104e77:	83 ea 01             	sub    $0x1,%edx
80104e7a:	83 fa ff             	cmp    $0xffffffff,%edx
80104e7d:	75 f1                	jne    80104e70 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e7f:	5e                   	pop    %esi
80104e80:	5f                   	pop    %edi
80104e81:	5d                   	pop    %ebp
80104e82:	c3                   	ret    
80104e83:	90                   	nop
80104e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e88:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
    while(n-- > 0)
80104e8b:	89 c7                	mov    %eax,%edi
80104e8d:	85 c9                	test   %ecx,%ecx
80104e8f:	74 ee                	je     80104e7f <memmove+0x2f>
80104e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104e98:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104e99:	39 d6                	cmp    %edx,%esi
80104e9b:	75 fb                	jne    80104e98 <memmove+0x48>
}
80104e9d:	5e                   	pop    %esi
80104e9e:	5f                   	pop    %edi
80104e9f:	5d                   	pop    %ebp
80104ea0:	c3                   	ret    
80104ea1:	eb 0d                	jmp    80104eb0 <memcpy>
80104ea3:	90                   	nop
80104ea4:	90                   	nop
80104ea5:	90                   	nop
80104ea6:	90                   	nop
80104ea7:	90                   	nop
80104ea8:	90                   	nop
80104ea9:	90                   	nop
80104eaa:	90                   	nop
80104eab:	90                   	nop
80104eac:	90                   	nop
80104ead:	90                   	nop
80104eae:	90                   	nop
80104eaf:	90                   	nop

80104eb0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104eb0:	eb 9e                	jmp    80104e50 <memmove>
80104eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	8b 7d 10             	mov    0x10(%ebp),%edi
80104ec7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104eca:	56                   	push   %esi
80104ecb:	8b 75 0c             	mov    0xc(%ebp),%esi
80104ece:	53                   	push   %ebx
  while(n > 0 && *p && *p == *q)
80104ecf:	85 ff                	test   %edi,%edi
80104ed1:	74 2f                	je     80104f02 <strncmp+0x42>
80104ed3:	0f b6 11             	movzbl (%ecx),%edx
80104ed6:	0f b6 1e             	movzbl (%esi),%ebx
80104ed9:	84 d2                	test   %dl,%dl
80104edb:	74 37                	je     80104f14 <strncmp+0x54>
80104edd:	38 da                	cmp    %bl,%dl
80104edf:	75 33                	jne    80104f14 <strncmp+0x54>
80104ee1:	01 f7                	add    %esi,%edi
80104ee3:	eb 13                	jmp    80104ef8 <strncmp+0x38>
80104ee5:	8d 76 00             	lea    0x0(%esi),%esi
80104ee8:	0f b6 11             	movzbl (%ecx),%edx
80104eeb:	84 d2                	test   %dl,%dl
80104eed:	74 21                	je     80104f10 <strncmp+0x50>
80104eef:	0f b6 18             	movzbl (%eax),%ebx
80104ef2:	89 c6                	mov    %eax,%esi
80104ef4:	38 da                	cmp    %bl,%dl
80104ef6:	75 1c                	jne    80104f14 <strncmp+0x54>
    n--, p++, q++;
80104ef8:	8d 46 01             	lea    0x1(%esi),%eax
80104efb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104efe:	39 f8                	cmp    %edi,%eax
80104f00:	75 e6                	jne    80104ee8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104f02:	5b                   	pop    %ebx
    return 0;
80104f03:	31 c0                	xor    %eax,%eax
}
80104f05:	5e                   	pop    %esi
80104f06:	5f                   	pop    %edi
80104f07:	5d                   	pop    %ebp
80104f08:	c3                   	ret    
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f10:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104f14:	0f b6 c2             	movzbl %dl,%eax
80104f17:	29 d8                	sub    %ebx,%eax
}
80104f19:	5b                   	pop    %ebx
80104f1a:	5e                   	pop    %esi
80104f1b:	5f                   	pop    %edi
80104f1c:	5d                   	pop    %ebp
80104f1d:	c3                   	ret    
80104f1e:	66 90                	xchg   %ax,%ax

80104f20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f27:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
80104f2a:	56                   	push   %esi
80104f2b:	53                   	push   %ebx
80104f2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f2f:	eb 1a                	jmp    80104f4b <strncpy+0x2b>
80104f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f38:	83 c2 01             	add    $0x1,%edx
80104f3b:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
80104f3f:	83 c1 01             	add    $0x1,%ecx
80104f42:	88 41 ff             	mov    %al,-0x1(%ecx)
80104f45:	84 c0                	test   %al,%al
80104f47:	74 09                	je     80104f52 <strncpy+0x32>
80104f49:	89 fb                	mov    %edi,%ebx
80104f4b:	8d 7b ff             	lea    -0x1(%ebx),%edi
80104f4e:	85 db                	test   %ebx,%ebx
80104f50:	7f e6                	jg     80104f38 <strncpy+0x18>
    ;
  while(n-- > 0)
80104f52:	89 ce                	mov    %ecx,%esi
80104f54:	85 ff                	test   %edi,%edi
80104f56:	7e 1b                	jle    80104f73 <strncpy+0x53>
80104f58:	90                   	nop
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104f60:	83 c6 01             	add    $0x1,%esi
80104f63:	c6 46 ff 00          	movb   $0x0,-0x1(%esi)
80104f67:	89 f2                	mov    %esi,%edx
80104f69:	f7 d2                	not    %edx
80104f6b:	01 ca                	add    %ecx,%edx
80104f6d:	01 da                	add    %ebx,%edx
  while(n-- > 0)
80104f6f:	85 d2                	test   %edx,%edx
80104f71:	7f ed                	jg     80104f60 <strncpy+0x40>
  return os;
}
80104f73:	5b                   	pop    %ebx
80104f74:	8b 45 08             	mov    0x8(%ebp),%eax
80104f77:	5e                   	pop    %esi
80104f78:	5f                   	pop    %edi
80104f79:	5d                   	pop    %ebp
80104f7a:	c3                   	ret    
80104f7b:	90                   	nop
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f87:	8b 45 08             	mov    0x8(%ebp),%eax
80104f8a:	53                   	push   %ebx
80104f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104f8e:	85 c9                	test   %ecx,%ecx
80104f90:	7e 26                	jle    80104fb8 <safestrcpy+0x38>
80104f92:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104f96:	89 c1                	mov    %eax,%ecx
80104f98:	eb 17                	jmp    80104fb1 <safestrcpy+0x31>
80104f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104fa0:	83 c2 01             	add    $0x1,%edx
80104fa3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104fa7:	83 c1 01             	add    $0x1,%ecx
80104faa:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104fad:	84 db                	test   %bl,%bl
80104faf:	74 04                	je     80104fb5 <safestrcpy+0x35>
80104fb1:	39 f2                	cmp    %esi,%edx
80104fb3:	75 eb                	jne    80104fa0 <safestrcpy+0x20>
    ;
  *s = 0;
80104fb5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104fb8:	5b                   	pop    %ebx
80104fb9:	5e                   	pop    %esi
80104fba:	5d                   	pop    %ebp
80104fbb:	c3                   	ret    
80104fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fc0 <strlen>:

int
strlen(const char *s)
{
80104fc0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104fc1:	31 c0                	xor    %eax,%eax
{
80104fc3:	89 e5                	mov    %esp,%ebp
80104fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104fc8:	80 3a 00             	cmpb   $0x0,(%edx)
80104fcb:	74 0c                	je     80104fd9 <strlen+0x19>
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi
80104fd0:	83 c0 01             	add    $0x1,%eax
80104fd3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104fd7:	75 f7                	jne    80104fd0 <strlen+0x10>
    ;
  return n;
}
80104fd9:	5d                   	pop    %ebp
80104fda:	c3                   	ret    

80104fdb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104fdb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104fdf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104fe3:	55                   	push   %ebp
  pushl %ebx
80104fe4:	53                   	push   %ebx
  pushl %esi
80104fe5:	56                   	push   %esi
  pushl %edi
80104fe6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104fe7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104fe9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104feb:	5f                   	pop    %edi
  popl %esi
80104fec:	5e                   	pop    %esi
  popl %ebx
80104fed:	5b                   	pop    %ebx
  popl %ebp
80104fee:	5d                   	pop    %ebp
  ret
80104fef:	c3                   	ret    

80104ff0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	53                   	push   %ebx
80104ff4:	83 ec 04             	sub    $0x4,%esp
80104ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104ffa:	e8 81 ee ff ff       	call   80103e80 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fff:	8b 00                	mov    (%eax),%eax
80105001:	39 d8                	cmp    %ebx,%eax
80105003:	76 1b                	jbe    80105020 <fetchint+0x30>
80105005:	8d 53 04             	lea    0x4(%ebx),%edx
80105008:	39 d0                	cmp    %edx,%eax
8010500a:	72 14                	jb     80105020 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010500c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010500f:	8b 13                	mov    (%ebx),%edx
80105011:	89 10                	mov    %edx,(%eax)
  return 0;
80105013:	31 c0                	xor    %eax,%eax
}
80105015:	83 c4 04             	add    $0x4,%esp
80105018:	5b                   	pop    %ebx
80105019:	5d                   	pop    %ebp
8010501a:	c3                   	ret    
8010501b:	90                   	nop
8010501c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105025:	eb ee                	jmp    80105015 <fetchint+0x25>
80105027:	89 f6                	mov    %esi,%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	53                   	push   %ebx
80105034:	83 ec 04             	sub    $0x4,%esp
80105037:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010503a:	e8 41 ee ff ff       	call   80103e80 <myproc>

  if(addr >= curproc->sz)
8010503f:	39 18                	cmp    %ebx,(%eax)
80105041:	76 29                	jbe    8010506c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105043:	8b 55 0c             	mov    0xc(%ebp),%edx
80105046:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105048:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010504a:	39 d3                	cmp    %edx,%ebx
8010504c:	73 1e                	jae    8010506c <fetchstr+0x3c>
    if(*s == 0)
8010504e:	80 3b 00             	cmpb   $0x0,(%ebx)
80105051:	74 35                	je     80105088 <fetchstr+0x58>
80105053:	89 d8                	mov    %ebx,%eax
80105055:	eb 0e                	jmp    80105065 <fetchstr+0x35>
80105057:	89 f6                	mov    %esi,%esi
80105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105060:	80 38 00             	cmpb   $0x0,(%eax)
80105063:	74 1b                	je     80105080 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105065:	83 c0 01             	add    $0x1,%eax
80105068:	39 c2                	cmp    %eax,%edx
8010506a:	77 f4                	ja     80105060 <fetchstr+0x30>
    return -1;
8010506c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105071:	83 c4 04             	add    $0x4,%esp
80105074:	5b                   	pop    %ebx
80105075:	5d                   	pop    %ebp
80105076:	c3                   	ret    
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105080:	83 c4 04             	add    $0x4,%esp
80105083:	29 d8                	sub    %ebx,%eax
80105085:	5b                   	pop    %ebx
80105086:	5d                   	pop    %ebp
80105087:	c3                   	ret    
    if(*s == 0)
80105088:	31 c0                	xor    %eax,%eax
      return s - *pp;
8010508a:	eb e5                	jmp    80105071 <fetchstr+0x41>
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105090 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105095:	e8 e6 ed ff ff       	call   80103e80 <myproc>
8010509a:	8b 55 08             	mov    0x8(%ebp),%edx
8010509d:	8b 40 18             	mov    0x18(%eax),%eax
801050a0:	8b 40 44             	mov    0x44(%eax),%eax
801050a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050a6:	e8 d5 ed ff ff       	call   80103e80 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050ab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050ae:	8b 00                	mov    (%eax),%eax
801050b0:	39 c6                	cmp    %eax,%esi
801050b2:	73 1c                	jae    801050d0 <argint+0x40>
801050b4:	8d 53 08             	lea    0x8(%ebx),%edx
801050b7:	39 d0                	cmp    %edx,%eax
801050b9:	72 15                	jb     801050d0 <argint+0x40>
  *ip = *(int*)(addr);
801050bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801050be:	8b 53 04             	mov    0x4(%ebx),%edx
801050c1:	89 10                	mov    %edx,(%eax)
  return 0;
801050c3:	31 c0                	xor    %eax,%eax
}
801050c5:	5b                   	pop    %ebx
801050c6:	5e                   	pop    %esi
801050c7:	5d                   	pop    %ebp
801050c8:	c3                   	ret    
801050c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050d5:	eb ee                	jmp    801050c5 <argint+0x35>
801050d7:	89 f6                	mov    %esi,%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
801050e5:	83 ec 10             	sub    $0x10,%esp
801050e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801050eb:	e8 90 ed ff ff       	call   80103e80 <myproc>
 
  if(argint(n, &i) < 0)
801050f0:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801050f3:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801050f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050f8:	50                   	push   %eax
801050f9:	ff 75 08             	pushl  0x8(%ebp)
801050fc:	e8 8f ff ff ff       	call   80105090 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105101:	83 c4 10             	add    $0x10,%esp
80105104:	85 c0                	test   %eax,%eax
80105106:	78 28                	js     80105130 <argptr+0x50>
80105108:	85 db                	test   %ebx,%ebx
8010510a:	78 24                	js     80105130 <argptr+0x50>
8010510c:	8b 16                	mov    (%esi),%edx
8010510e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105111:	39 c2                	cmp    %eax,%edx
80105113:	76 1b                	jbe    80105130 <argptr+0x50>
80105115:	01 c3                	add    %eax,%ebx
80105117:	39 da                	cmp    %ebx,%edx
80105119:	72 15                	jb     80105130 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010511b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010511e:	89 02                	mov    %eax,(%edx)
  return 0;
80105120:	31 c0                	xor    %eax,%eax
}
80105122:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105125:	5b                   	pop    %ebx
80105126:	5e                   	pop    %esi
80105127:	5d                   	pop    %ebp
80105128:	c3                   	ret    
80105129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105135:	eb eb                	jmp    80105122 <argptr+0x42>
80105137:	89 f6                	mov    %esi,%esi
80105139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105140 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105146:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105149:	50                   	push   %eax
8010514a:	ff 75 08             	pushl  0x8(%ebp)
8010514d:	e8 3e ff ff ff       	call   80105090 <argint>
80105152:	83 c4 10             	add    $0x10,%esp
80105155:	85 c0                	test   %eax,%eax
80105157:	78 17                	js     80105170 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105159:	83 ec 08             	sub    $0x8,%esp
8010515c:	ff 75 0c             	pushl  0xc(%ebp)
8010515f:	ff 75 f4             	pushl  -0xc(%ebp)
80105162:	e8 c9 fe ff ff       	call   80105030 <fetchstr>
80105167:	83 c4 10             	add    $0x10,%esp
}
8010516a:	c9                   	leave  
8010516b:	c3                   	ret    
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105170:	c9                   	leave  
    return -1;
80105171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105176:	c3                   	ret    
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <syscall>:
[SYS_att]  sys_att,
};

void
syscall(void)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	53                   	push   %ebx
80105184:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105187:	e8 f4 ec ff ff       	call   80103e80 <myproc>
8010518c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010518e:	8b 40 18             	mov    0x18(%eax),%eax
80105191:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105194:	8d 50 ff             	lea    -0x1(%eax),%edx
80105197:	83 fa 1c             	cmp    $0x1c,%edx
8010519a:	77 1c                	ja     801051b8 <syscall+0x38>
8010519c:	8b 14 85 80 82 10 80 	mov    -0x7fef7d80(,%eax,4),%edx
801051a3:	85 d2                	test   %edx,%edx
801051a5:	74 11                	je     801051b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801051a7:	ff d2                	call   *%edx
801051a9:	8b 53 18             	mov    0x18(%ebx),%edx
801051ac:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801051af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051b2:	c9                   	leave  
801051b3:	c3                   	ret    
801051b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801051b8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801051b9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801051bc:	50                   	push   %eax
801051bd:	ff 73 10             	pushl  0x10(%ebx)
801051c0:	68 51 82 10 80       	push   $0x80108251
801051c5:	e8 d6 b4 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
801051ca:	8b 43 18             	mov    0x18(%ebx),%eax
801051cd:	83 c4 10             	add    $0x10,%esp
801051d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801051d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051da:	c9                   	leave  
801051db:	c3                   	ret    
801051dc:	66 90                	xchg   %ax,%ax
801051de:	66 90                	xchg   %ax,%ax

801051e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	57                   	push   %edi
801051e4:	56                   	push   %esi
801051e5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051e6:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
801051e9:	83 ec 44             	sub    $0x44,%esp
801051ec:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801051ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801051f2:	53                   	push   %ebx
801051f3:	50                   	push   %eax
{
801051f4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801051f7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801051fa:	e8 11 d3 ff ff       	call   80102510 <nameiparent>
801051ff:	83 c4 10             	add    $0x10,%esp
80105202:	85 c0                	test   %eax,%eax
80105204:	0f 84 46 01 00 00    	je     80105350 <create+0x170>
    return 0;
  ilock(dp);
8010520a:	83 ec 0c             	sub    $0xc,%esp
8010520d:	89 c6                	mov    %eax,%esi
8010520f:	50                   	push   %eax
80105210:	e8 3b ca ff ff       	call   80101c50 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105215:	83 c4 0c             	add    $0xc,%esp
80105218:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010521b:	50                   	push   %eax
8010521c:	53                   	push   %ebx
8010521d:	56                   	push   %esi
8010521e:	e8 5d cf ff ff       	call   80102180 <dirlookup>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	89 c7                	mov    %eax,%edi
80105228:	85 c0                	test   %eax,%eax
8010522a:	74 54                	je     80105280 <create+0xa0>
    iunlockput(dp);
8010522c:	83 ec 0c             	sub    $0xc,%esp
8010522f:	56                   	push   %esi
80105230:	e8 ab cc ff ff       	call   80101ee0 <iunlockput>
    ilock(ip);
80105235:	89 3c 24             	mov    %edi,(%esp)
80105238:	e8 13 ca ff ff       	call   80101c50 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105245:	75 19                	jne    80105260 <create+0x80>
80105247:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010524c:	75 12                	jne    80105260 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010524e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105251:	89 f8                	mov    %edi,%eax
80105253:	5b                   	pop    %ebx
80105254:	5e                   	pop    %esi
80105255:	5f                   	pop    %edi
80105256:	5d                   	pop    %ebp
80105257:	c3                   	ret    
80105258:	90                   	nop
80105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105260:	83 ec 0c             	sub    $0xc,%esp
80105263:	57                   	push   %edi
    return 0;
80105264:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105266:	e8 75 cc ff ff       	call   80101ee0 <iunlockput>
    return 0;
8010526b:	83 c4 10             	add    $0x10,%esp
}
8010526e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105271:	89 f8                	mov    %edi,%eax
80105273:	5b                   	pop    %ebx
80105274:	5e                   	pop    %esi
80105275:	5f                   	pop    %edi
80105276:	5d                   	pop    %ebp
80105277:	c3                   	ret    
80105278:	90                   	nop
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80105280:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105284:	83 ec 08             	sub    $0x8,%esp
80105287:	50                   	push   %eax
80105288:	ff 36                	pushl  (%esi)
8010528a:	e8 51 c8 ff ff       	call   80101ae0 <ialloc>
8010528f:	83 c4 10             	add    $0x10,%esp
80105292:	89 c7                	mov    %eax,%edi
80105294:	85 c0                	test   %eax,%eax
80105296:	0f 84 cd 00 00 00    	je     80105369 <create+0x189>
  ilock(ip);
8010529c:	83 ec 0c             	sub    $0xc,%esp
8010529f:	50                   	push   %eax
801052a0:	e8 ab c9 ff ff       	call   80101c50 <ilock>
  ip->major = major;
801052a5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801052a9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801052ad:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801052b1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801052b5:	b8 01 00 00 00       	mov    $0x1,%eax
801052ba:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801052be:	89 3c 24             	mov    %edi,(%esp)
801052c1:	e8 da c8 ff ff       	call   80101ba0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801052c6:	83 c4 10             	add    $0x10,%esp
801052c9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801052ce:	74 30                	je     80105300 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801052d0:	83 ec 04             	sub    $0x4,%esp
801052d3:	ff 77 04             	pushl  0x4(%edi)
801052d6:	53                   	push   %ebx
801052d7:	56                   	push   %esi
801052d8:	e8 53 d1 ff ff       	call   80102430 <dirlink>
801052dd:	83 c4 10             	add    $0x10,%esp
801052e0:	85 c0                	test   %eax,%eax
801052e2:	78 78                	js     8010535c <create+0x17c>
  iunlockput(dp);
801052e4:	83 ec 0c             	sub    $0xc,%esp
801052e7:	56                   	push   %esi
801052e8:	e8 f3 cb ff ff       	call   80101ee0 <iunlockput>
  return ip;
801052ed:	83 c4 10             	add    $0x10,%esp
}
801052f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052f3:	89 f8                	mov    %edi,%eax
801052f5:	5b                   	pop    %ebx
801052f6:	5e                   	pop    %esi
801052f7:	5f                   	pop    %edi
801052f8:	5d                   	pop    %ebp
801052f9:	c3                   	ret    
801052fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105300:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105303:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105308:	56                   	push   %esi
80105309:	e8 92 c8 ff ff       	call   80101ba0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010530e:	83 c4 0c             	add    $0xc,%esp
80105311:	ff 77 04             	pushl  0x4(%edi)
80105314:	68 14 83 10 80       	push   $0x80108314
80105319:	57                   	push   %edi
8010531a:	e8 11 d1 ff ff       	call   80102430 <dirlink>
8010531f:	83 c4 10             	add    $0x10,%esp
80105322:	85 c0                	test   %eax,%eax
80105324:	78 18                	js     8010533e <create+0x15e>
80105326:	83 ec 04             	sub    $0x4,%esp
80105329:	ff 76 04             	pushl  0x4(%esi)
8010532c:	68 13 83 10 80       	push   $0x80108313
80105331:	57                   	push   %edi
80105332:	e8 f9 d0 ff ff       	call   80102430 <dirlink>
80105337:	83 c4 10             	add    $0x10,%esp
8010533a:	85 c0                	test   %eax,%eax
8010533c:	79 92                	jns    801052d0 <create+0xf0>
      panic("create dots");
8010533e:	83 ec 0c             	sub    $0xc,%esp
80105341:	68 07 83 10 80       	push   $0x80108307
80105346:	e8 45 b0 ff ff       	call   80100390 <panic>
8010534b:	90                   	nop
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80105350:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105353:	31 ff                	xor    %edi,%edi
}
80105355:	5b                   	pop    %ebx
80105356:	89 f8                	mov    %edi,%eax
80105358:	5e                   	pop    %esi
80105359:	5f                   	pop    %edi
8010535a:	5d                   	pop    %ebp
8010535b:	c3                   	ret    
    panic("create: dirlink");
8010535c:	83 ec 0c             	sub    $0xc,%esp
8010535f:	68 16 83 10 80       	push   $0x80108316
80105364:	e8 27 b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105369:	83 ec 0c             	sub    $0xc,%esp
8010536c:	68 f8 82 10 80       	push   $0x801082f8
80105371:	e8 1a b0 ff ff       	call   80100390 <panic>
80105376:	8d 76 00             	lea    0x0(%esi),%esi
80105379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105380 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	56                   	push   %esi
80105384:	89 d6                	mov    %edx,%esi
80105386:	53                   	push   %ebx
80105387:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105389:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010538c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010538f:	50                   	push   %eax
80105390:	6a 00                	push   $0x0
80105392:	e8 f9 fc ff ff       	call   80105090 <argint>
80105397:	83 c4 10             	add    $0x10,%esp
8010539a:	85 c0                	test   %eax,%eax
8010539c:	78 2a                	js     801053c8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010539e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053a2:	77 24                	ja     801053c8 <argfd.constprop.0+0x48>
801053a4:	e8 d7 ea ff ff       	call   80103e80 <myproc>
801053a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801053b0:	85 c0                	test   %eax,%eax
801053b2:	74 14                	je     801053c8 <argfd.constprop.0+0x48>
  if(pfd)
801053b4:	85 db                	test   %ebx,%ebx
801053b6:	74 02                	je     801053ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801053b8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801053ba:	89 06                	mov    %eax,(%esi)
  return 0;
801053bc:	31 c0                	xor    %eax,%eax
}
801053be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053c1:	5b                   	pop    %ebx
801053c2:	5e                   	pop    %esi
801053c3:	5d                   	pop    %ebp
801053c4:	c3                   	ret    
801053c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053cd:	eb ef                	jmp    801053be <argfd.constprop.0+0x3e>
801053cf:	90                   	nop

801053d0 <sys_dup>:
{
801053d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801053d1:	31 c0                	xor    %eax,%eax
{
801053d3:	89 e5                	mov    %esp,%ebp
801053d5:	56                   	push   %esi
801053d6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801053d7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801053da:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801053dd:	e8 9e ff ff ff       	call   80105380 <argfd.constprop.0>
801053e2:	85 c0                	test   %eax,%eax
801053e4:	78 1a                	js     80105400 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
801053e6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801053e9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801053eb:	e8 90 ea ff ff       	call   80103e80 <myproc>
    if(curproc->ofile[fd] == 0){
801053f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053f4:	85 d2                	test   %edx,%edx
801053f6:	74 18                	je     80105410 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
801053f8:	83 c3 01             	add    $0x1,%ebx
801053fb:	83 fb 10             	cmp    $0x10,%ebx
801053fe:	75 f0                	jne    801053f0 <sys_dup+0x20>
}
80105400:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105403:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105408:	89 d8                	mov    %ebx,%eax
8010540a:	5b                   	pop    %ebx
8010540b:	5e                   	pop    %esi
8010540c:	5d                   	pop    %ebp
8010540d:	c3                   	ret    
8010540e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105410:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	ff 75 f4             	pushl  -0xc(%ebp)
8010541a:	e8 51 bf ff ff       	call   80101370 <filedup>
  return fd;
8010541f:	83 c4 10             	add    $0x10,%esp
}
80105422:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105425:	89 d8                	mov    %ebx,%eax
80105427:	5b                   	pop    %ebx
80105428:	5e                   	pop    %esi
80105429:	5d                   	pop    %ebp
8010542a:	c3                   	ret    
8010542b:	90                   	nop
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105430 <sys_read>:
{
80105430:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105431:	31 c0                	xor    %eax,%eax
{
80105433:	89 e5                	mov    %esp,%ebp
80105435:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105438:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010543b:	e8 40 ff ff ff       	call   80105380 <argfd.constprop.0>
80105440:	85 c0                	test   %eax,%eax
80105442:	78 4c                	js     80105490 <sys_read+0x60>
80105444:	83 ec 08             	sub    $0x8,%esp
80105447:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010544a:	50                   	push   %eax
8010544b:	6a 02                	push   $0x2
8010544d:	e8 3e fc ff ff       	call   80105090 <argint>
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	85 c0                	test   %eax,%eax
80105457:	78 37                	js     80105490 <sys_read+0x60>
80105459:	83 ec 04             	sub    $0x4,%esp
8010545c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010545f:	ff 75 f0             	pushl  -0x10(%ebp)
80105462:	50                   	push   %eax
80105463:	6a 01                	push   $0x1
80105465:	e8 76 fc ff ff       	call   801050e0 <argptr>
8010546a:	83 c4 10             	add    $0x10,%esp
8010546d:	85 c0                	test   %eax,%eax
8010546f:	78 1f                	js     80105490 <sys_read+0x60>
  return fileread(f, p, n);
80105471:	83 ec 04             	sub    $0x4,%esp
80105474:	ff 75 f0             	pushl  -0x10(%ebp)
80105477:	ff 75 f4             	pushl  -0xc(%ebp)
8010547a:	ff 75 ec             	pushl  -0x14(%ebp)
8010547d:	e8 6e c0 ff ff       	call   801014f0 <fileread>
80105482:	83 c4 10             	add    $0x10,%esp
}
80105485:	c9                   	leave  
80105486:	c3                   	ret    
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105490:	c9                   	leave  
    return -1;
80105491:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105496:	c3                   	ret    
80105497:	89 f6                	mov    %esi,%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054a0 <sys_write>:
{
801054a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054a1:	31 c0                	xor    %eax,%eax
{
801054a3:	89 e5                	mov    %esp,%ebp
801054a5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054a8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801054ab:	e8 d0 fe ff ff       	call   80105380 <argfd.constprop.0>
801054b0:	85 c0                	test   %eax,%eax
801054b2:	78 4c                	js     80105500 <sys_write+0x60>
801054b4:	83 ec 08             	sub    $0x8,%esp
801054b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054ba:	50                   	push   %eax
801054bb:	6a 02                	push   $0x2
801054bd:	e8 ce fb ff ff       	call   80105090 <argint>
801054c2:	83 c4 10             	add    $0x10,%esp
801054c5:	85 c0                	test   %eax,%eax
801054c7:	78 37                	js     80105500 <sys_write+0x60>
801054c9:	83 ec 04             	sub    $0x4,%esp
801054cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054cf:	ff 75 f0             	pushl  -0x10(%ebp)
801054d2:	50                   	push   %eax
801054d3:	6a 01                	push   $0x1
801054d5:	e8 06 fc ff ff       	call   801050e0 <argptr>
801054da:	83 c4 10             	add    $0x10,%esp
801054dd:	85 c0                	test   %eax,%eax
801054df:	78 1f                	js     80105500 <sys_write+0x60>
  return filewrite(f, p, n);
801054e1:	83 ec 04             	sub    $0x4,%esp
801054e4:	ff 75 f0             	pushl  -0x10(%ebp)
801054e7:	ff 75 f4             	pushl  -0xc(%ebp)
801054ea:	ff 75 ec             	pushl  -0x14(%ebp)
801054ed:	e8 8e c0 ff ff       	call   80101580 <filewrite>
801054f2:	83 c4 10             	add    $0x10,%esp
}
801054f5:	c9                   	leave  
801054f6:	c3                   	ret    
801054f7:	89 f6                	mov    %esi,%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105500:	c9                   	leave  
    return -1;
80105501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105506:	c3                   	ret    
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105510 <sys_close>:
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105516:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105519:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010551c:	e8 5f fe ff ff       	call   80105380 <argfd.constprop.0>
80105521:	85 c0                	test   %eax,%eax
80105523:	78 2b                	js     80105550 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105525:	e8 56 e9 ff ff       	call   80103e80 <myproc>
8010552a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010552d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105530:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105537:	00 
  fileclose(f);
80105538:	ff 75 f4             	pushl  -0xc(%ebp)
8010553b:	e8 80 be ff ff       	call   801013c0 <fileclose>
  return 0;
80105540:	83 c4 10             	add    $0x10,%esp
80105543:	31 c0                	xor    %eax,%eax
}
80105545:	c9                   	leave  
80105546:	c3                   	ret    
80105547:	89 f6                	mov    %esi,%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105550:	c9                   	leave  
    return -1;
80105551:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <sys_fstat>:
{
80105560:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105561:	31 c0                	xor    %eax,%eax
{
80105563:	89 e5                	mov    %esp,%ebp
80105565:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105568:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010556b:	e8 10 fe ff ff       	call   80105380 <argfd.constprop.0>
80105570:	85 c0                	test   %eax,%eax
80105572:	78 2c                	js     801055a0 <sys_fstat+0x40>
80105574:	83 ec 04             	sub    $0x4,%esp
80105577:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557a:	6a 14                	push   $0x14
8010557c:	50                   	push   %eax
8010557d:	6a 01                	push   $0x1
8010557f:	e8 5c fb ff ff       	call   801050e0 <argptr>
80105584:	83 c4 10             	add    $0x10,%esp
80105587:	85 c0                	test   %eax,%eax
80105589:	78 15                	js     801055a0 <sys_fstat+0x40>
  return filestat(f, st);
8010558b:	83 ec 08             	sub    $0x8,%esp
8010558e:	ff 75 f4             	pushl  -0xc(%ebp)
80105591:	ff 75 f0             	pushl  -0x10(%ebp)
80105594:	e8 07 bf ff ff       	call   801014a0 <filestat>
80105599:	83 c4 10             	add    $0x10,%esp
}
8010559c:	c9                   	leave  
8010559d:	c3                   	ret    
8010559e:	66 90                	xchg   %ax,%ax
801055a0:	c9                   	leave  
    return -1;
801055a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055a6:	c3                   	ret    
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <sys_link>:
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801055b8:	53                   	push   %ebx
801055b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055bc:	50                   	push   %eax
801055bd:	6a 00                	push   $0x0
801055bf:	e8 7c fb ff ff       	call   80105140 <argstr>
801055c4:	83 c4 10             	add    $0x10,%esp
801055c7:	85 c0                	test   %eax,%eax
801055c9:	0f 88 fb 00 00 00    	js     801056ca <sys_link+0x11a>
801055cf:	83 ec 08             	sub    $0x8,%esp
801055d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055d5:	50                   	push   %eax
801055d6:	6a 01                	push   $0x1
801055d8:	e8 63 fb ff ff       	call   80105140 <argstr>
801055dd:	83 c4 10             	add    $0x10,%esp
801055e0:	85 c0                	test   %eax,%eax
801055e2:	0f 88 e2 00 00 00    	js     801056ca <sys_link+0x11a>
  begin_op();
801055e8:	e8 e3 db ff ff       	call   801031d0 <begin_op>
  if((ip = namei(old)) == 0){
801055ed:	83 ec 0c             	sub    $0xc,%esp
801055f0:	ff 75 d4             	pushl  -0x2c(%ebp)
801055f3:	e8 f8 ce ff ff       	call   801024f0 <namei>
801055f8:	83 c4 10             	add    $0x10,%esp
801055fb:	89 c3                	mov    %eax,%ebx
801055fd:	85 c0                	test   %eax,%eax
801055ff:	0f 84 e4 00 00 00    	je     801056e9 <sys_link+0x139>
  ilock(ip);
80105605:	83 ec 0c             	sub    $0xc,%esp
80105608:	50                   	push   %eax
80105609:	e8 42 c6 ff ff       	call   80101c50 <ilock>
  if(ip->type == T_DIR){
8010560e:	83 c4 10             	add    $0x10,%esp
80105611:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105616:	0f 84 b5 00 00 00    	je     801056d1 <sys_link+0x121>
  iupdate(ip);
8010561c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010561f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105624:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105627:	53                   	push   %ebx
80105628:	e8 73 c5 ff ff       	call   80101ba0 <iupdate>
  iunlock(ip);
8010562d:	89 1c 24             	mov    %ebx,(%esp)
80105630:	e8 fb c6 ff ff       	call   80101d30 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105635:	58                   	pop    %eax
80105636:	5a                   	pop    %edx
80105637:	57                   	push   %edi
80105638:	ff 75 d0             	pushl  -0x30(%ebp)
8010563b:	e8 d0 ce ff ff       	call   80102510 <nameiparent>
80105640:	83 c4 10             	add    $0x10,%esp
80105643:	89 c6                	mov    %eax,%esi
80105645:	85 c0                	test   %eax,%eax
80105647:	74 5b                	je     801056a4 <sys_link+0xf4>
  ilock(dp);
80105649:	83 ec 0c             	sub    $0xc,%esp
8010564c:	50                   	push   %eax
8010564d:	e8 fe c5 ff ff       	call   80101c50 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	8b 03                	mov    (%ebx),%eax
80105657:	39 06                	cmp    %eax,(%esi)
80105659:	75 3d                	jne    80105698 <sys_link+0xe8>
8010565b:	83 ec 04             	sub    $0x4,%esp
8010565e:	ff 73 04             	pushl  0x4(%ebx)
80105661:	57                   	push   %edi
80105662:	56                   	push   %esi
80105663:	e8 c8 cd ff ff       	call   80102430 <dirlink>
80105668:	83 c4 10             	add    $0x10,%esp
8010566b:	85 c0                	test   %eax,%eax
8010566d:	78 29                	js     80105698 <sys_link+0xe8>
  iunlockput(dp);
8010566f:	83 ec 0c             	sub    $0xc,%esp
80105672:	56                   	push   %esi
80105673:	e8 68 c8 ff ff       	call   80101ee0 <iunlockput>
  iput(ip);
80105678:	89 1c 24             	mov    %ebx,(%esp)
8010567b:	e8 00 c7 ff ff       	call   80101d80 <iput>
  end_op();
80105680:	e8 bb db ff ff       	call   80103240 <end_op>
  return 0;
80105685:	83 c4 10             	add    $0x10,%esp
80105688:	31 c0                	xor    %eax,%eax
}
8010568a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010568d:	5b                   	pop    %ebx
8010568e:	5e                   	pop    %esi
8010568f:	5f                   	pop    %edi
80105690:	5d                   	pop    %ebp
80105691:	c3                   	ret    
80105692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105698:	83 ec 0c             	sub    $0xc,%esp
8010569b:	56                   	push   %esi
8010569c:	e8 3f c8 ff ff       	call   80101ee0 <iunlockput>
    goto bad;
801056a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801056a4:	83 ec 0c             	sub    $0xc,%esp
801056a7:	53                   	push   %ebx
801056a8:	e8 a3 c5 ff ff       	call   80101c50 <ilock>
  ip->nlink--;
801056ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056b2:	89 1c 24             	mov    %ebx,(%esp)
801056b5:	e8 e6 c4 ff ff       	call   80101ba0 <iupdate>
  iunlockput(ip);
801056ba:	89 1c 24             	mov    %ebx,(%esp)
801056bd:	e8 1e c8 ff ff       	call   80101ee0 <iunlockput>
  end_op();
801056c2:	e8 79 db ff ff       	call   80103240 <end_op>
  return -1;
801056c7:	83 c4 10             	add    $0x10,%esp
801056ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056cf:	eb b9                	jmp    8010568a <sys_link+0xda>
    iunlockput(ip);
801056d1:	83 ec 0c             	sub    $0xc,%esp
801056d4:	53                   	push   %ebx
801056d5:	e8 06 c8 ff ff       	call   80101ee0 <iunlockput>
    end_op();
801056da:	e8 61 db ff ff       	call   80103240 <end_op>
    return -1;
801056df:	83 c4 10             	add    $0x10,%esp
801056e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e7:	eb a1                	jmp    8010568a <sys_link+0xda>
    end_op();
801056e9:	e8 52 db ff ff       	call   80103240 <end_op>
    return -1;
801056ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f3:	eb 95                	jmp    8010568a <sys_link+0xda>
801056f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <sys_unlink>:
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105705:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105708:	53                   	push   %ebx
80105709:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010570c:	50                   	push   %eax
8010570d:	6a 00                	push   $0x0
8010570f:	e8 2c fa ff ff       	call   80105140 <argstr>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	0f 88 91 01 00 00    	js     801058b0 <sys_unlink+0x1b0>
  begin_op();
8010571f:	e8 ac da ff ff       	call   801031d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105724:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105727:	83 ec 08             	sub    $0x8,%esp
8010572a:	53                   	push   %ebx
8010572b:	ff 75 c0             	pushl  -0x40(%ebp)
8010572e:	e8 dd cd ff ff       	call   80102510 <nameiparent>
80105733:	83 c4 10             	add    $0x10,%esp
80105736:	89 c6                	mov    %eax,%esi
80105738:	85 c0                	test   %eax,%eax
8010573a:	0f 84 7a 01 00 00    	je     801058ba <sys_unlink+0x1ba>
  ilock(dp);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	50                   	push   %eax
80105744:	e8 07 c5 ff ff       	call   80101c50 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105749:	58                   	pop    %eax
8010574a:	5a                   	pop    %edx
8010574b:	68 14 83 10 80       	push   $0x80108314
80105750:	53                   	push   %ebx
80105751:	e8 0a ca ff ff       	call   80102160 <namecmp>
80105756:	83 c4 10             	add    $0x10,%esp
80105759:	85 c0                	test   %eax,%eax
8010575b:	0f 84 0f 01 00 00    	je     80105870 <sys_unlink+0x170>
80105761:	83 ec 08             	sub    $0x8,%esp
80105764:	68 13 83 10 80       	push   $0x80108313
80105769:	53                   	push   %ebx
8010576a:	e8 f1 c9 ff ff       	call   80102160 <namecmp>
8010576f:	83 c4 10             	add    $0x10,%esp
80105772:	85 c0                	test   %eax,%eax
80105774:	0f 84 f6 00 00 00    	je     80105870 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010577a:	83 ec 04             	sub    $0x4,%esp
8010577d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105780:	50                   	push   %eax
80105781:	53                   	push   %ebx
80105782:	56                   	push   %esi
80105783:	e8 f8 c9 ff ff       	call   80102180 <dirlookup>
80105788:	83 c4 10             	add    $0x10,%esp
8010578b:	89 c3                	mov    %eax,%ebx
8010578d:	85 c0                	test   %eax,%eax
8010578f:	0f 84 db 00 00 00    	je     80105870 <sys_unlink+0x170>
  ilock(ip);
80105795:	83 ec 0c             	sub    $0xc,%esp
80105798:	50                   	push   %eax
80105799:	e8 b2 c4 ff ff       	call   80101c50 <ilock>
  if(ip->nlink < 1)
8010579e:	83 c4 10             	add    $0x10,%esp
801057a1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801057a6:	0f 8e 37 01 00 00    	jle    801058e3 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801057ac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057b1:	8d 7d d8             	lea    -0x28(%ebp),%edi
801057b4:	74 6a                	je     80105820 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801057b6:	83 ec 04             	sub    $0x4,%esp
801057b9:	6a 10                	push   $0x10
801057bb:	6a 00                	push   $0x0
801057bd:	57                   	push   %edi
801057be:	e8 ed f5 ff ff       	call   80104db0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057c3:	6a 10                	push   $0x10
801057c5:	ff 75 c4             	pushl  -0x3c(%ebp)
801057c8:	57                   	push   %edi
801057c9:	56                   	push   %esi
801057ca:	e8 61 c8 ff ff       	call   80102030 <writei>
801057cf:	83 c4 20             	add    $0x20,%esp
801057d2:	83 f8 10             	cmp    $0x10,%eax
801057d5:	0f 85 fb 00 00 00    	jne    801058d6 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
801057db:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057e0:	0f 84 aa 00 00 00    	je     80105890 <sys_unlink+0x190>
  iunlockput(dp);
801057e6:	83 ec 0c             	sub    $0xc,%esp
801057e9:	56                   	push   %esi
801057ea:	e8 f1 c6 ff ff       	call   80101ee0 <iunlockput>
  ip->nlink--;
801057ef:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057f4:	89 1c 24             	mov    %ebx,(%esp)
801057f7:	e8 a4 c3 ff ff       	call   80101ba0 <iupdate>
  iunlockput(ip);
801057fc:	89 1c 24             	mov    %ebx,(%esp)
801057ff:	e8 dc c6 ff ff       	call   80101ee0 <iunlockput>
  end_op();
80105804:	e8 37 da ff ff       	call   80103240 <end_op>
  return 0;
80105809:	83 c4 10             	add    $0x10,%esp
8010580c:	31 c0                	xor    %eax,%eax
}
8010580e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105811:	5b                   	pop    %ebx
80105812:	5e                   	pop    %esi
80105813:	5f                   	pop    %edi
80105814:	5d                   	pop    %ebp
80105815:	c3                   	ret    
80105816:	8d 76 00             	lea    0x0(%esi),%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105820:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105824:	76 90                	jbe    801057b6 <sys_unlink+0xb6>
80105826:	ba 20 00 00 00       	mov    $0x20,%edx
8010582b:	eb 0f                	jmp    8010583c <sys_unlink+0x13c>
8010582d:	8d 76 00             	lea    0x0(%esi),%esi
80105830:	83 c2 10             	add    $0x10,%edx
80105833:	39 53 58             	cmp    %edx,0x58(%ebx)
80105836:	0f 86 7a ff ff ff    	jbe    801057b6 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010583c:	6a 10                	push   $0x10
8010583e:	52                   	push   %edx
8010583f:	57                   	push   %edi
80105840:	53                   	push   %ebx
80105841:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105844:	e8 e7 c6 ff ff       	call   80101f30 <readi>
80105849:	83 c4 10             	add    $0x10,%esp
8010584c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010584f:	83 f8 10             	cmp    $0x10,%eax
80105852:	75 75                	jne    801058c9 <sys_unlink+0x1c9>
    if(de.inum != 0)
80105854:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105859:	74 d5                	je     80105830 <sys_unlink+0x130>
    iunlockput(ip);
8010585b:	83 ec 0c             	sub    $0xc,%esp
8010585e:	53                   	push   %ebx
8010585f:	e8 7c c6 ff ff       	call   80101ee0 <iunlockput>
    goto bad;
80105864:	83 c4 10             	add    $0x10,%esp
80105867:	89 f6                	mov    %esi,%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  iunlockput(dp);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	56                   	push   %esi
80105874:	e8 67 c6 ff ff       	call   80101ee0 <iunlockput>
  end_op();
80105879:	e8 c2 d9 ff ff       	call   80103240 <end_op>
  return -1;
8010587e:	83 c4 10             	add    $0x10,%esp
80105881:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105886:	eb 86                	jmp    8010580e <sys_unlink+0x10e>
80105888:	90                   	nop
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(dp);
80105890:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105893:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105898:	56                   	push   %esi
80105899:	e8 02 c3 ff ff       	call   80101ba0 <iupdate>
8010589e:	83 c4 10             	add    $0x10,%esp
801058a1:	e9 40 ff ff ff       	jmp    801057e6 <sys_unlink+0xe6>
801058a6:	8d 76 00             	lea    0x0(%esi),%esi
801058a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b5:	e9 54 ff ff ff       	jmp    8010580e <sys_unlink+0x10e>
    end_op();
801058ba:	e8 81 d9 ff ff       	call   80103240 <end_op>
    return -1;
801058bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c4:	e9 45 ff ff ff       	jmp    8010580e <sys_unlink+0x10e>
      panic("isdirempty: readi");
801058c9:	83 ec 0c             	sub    $0xc,%esp
801058cc:	68 38 83 10 80       	push   $0x80108338
801058d1:	e8 ba aa ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801058d6:	83 ec 0c             	sub    $0xc,%esp
801058d9:	68 4a 83 10 80       	push   $0x8010834a
801058de:	e8 ad aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801058e3:	83 ec 0c             	sub    $0xc,%esp
801058e6:	68 26 83 10 80       	push   $0x80108326
801058eb:	e8 a0 aa ff ff       	call   80100390 <panic>

801058f0 <sys_setmemo>:

int
sys_setmemo(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	56                   	push   %esi
801058f4:	53                   	push   %ebx
  int i;
  struct proc* cur=myproc();
  for(i=1;i<MAXSHAREDPG;i++)
801058f5:	bb 01 00 00 00       	mov    $0x1,%ebx
  struct proc* cur=myproc();
801058fa:	e8 81 e5 ff ff       	call   80103e80 <myproc>
801058ff:	89 c6                	mov    %eax,%esi
  for(i=1;i<MAXSHAREDPG;i++)
80105901:	eb 0d                	jmp    80105910 <sys_setmemo+0x20>
80105903:	90                   	nop
80105904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105908:	83 c3 01             	add    $0x1,%ebx
8010590b:	83 fb 0a             	cmp    $0xa,%ebx
8010590e:	74 1e                	je     8010592e <sys_setmemo+0x3e>
  {
    if(cur->sharedrec[i]!=0)
80105910:	80 bc 1e 88 00 00 00 	cmpb   $0x0,0x88(%esi,%ebx,1)
80105917:	00 
80105918:	74 ee                	je     80105908 <sys_setmemo+0x18>
    {
      getshared(i);
8010591a:	83 ec 0c             	sub    $0xc,%esp
8010591d:	53                   	push   %ebx
  for(i=1;i<MAXSHAREDPG;i++)
8010591e:	83 c3 01             	add    $0x1,%ebx
      getshared(i);
80105921:	e8 da e7 ff ff       	call   80104100 <getshared>
80105926:	83 c4 10             	add    $0x10,%esp
  for(i=1;i<MAXSHAREDPG;i++)
80105929:	83 fb 0a             	cmp    $0xa,%ebx
8010592c:	75 e2                	jne    80105910 <sys_setmemo+0x20>
    }
  }
  return 0;
}
8010592e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105931:	31 c0                	xor    %eax,%eax
80105933:	5b                   	pop    %ebx
80105934:	5e                   	pop    %esi
80105935:	5d                   	pop    %ebp
80105936:	c3                   	ret    
80105937:	89 f6                	mov    %esi,%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105940 <sys_getmemo>:

int
sys_getmemo(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	56                   	push   %esi
80105944:	53                   	push   %ebx
  char *path;
  int n;
  if(argstr(0, &path) < 0)
80105945:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105948:	83 ec 18             	sub    $0x18,%esp
  if(argstr(0, &path) < 0)
8010594b:	50                   	push   %eax
8010594c:	6a 00                	push   $0x0
8010594e:	e8 ed f7 ff ff       	call   80105140 <argstr>
80105953:	83 c4 10             	add    $0x10,%esp
80105956:	85 c0                	test   %eax,%eax
80105958:	78 46                	js     801059a0 <sys_getmemo+0x60>
    return -1;
  struct memo* ch=(struct memo*)getshared(2);
8010595a:	83 ec 0c             	sub    $0xc,%esp
8010595d:	6a 02                	push   $0x2
8010595f:	e8 9c e7 ff ff       	call   80104100 <getshared>
80105964:	89 c3                	mov    %eax,%ebx
  acquire(&ch->lock);
80105966:	89 04 24             	mov    %eax,(%esp)
80105969:	e8 d2 f2 ff ff       	call   80104c40 <acquire>
  strncpy(path, ch->memo, ch->lmemo);
8010596e:	83 c4 0c             	add    $0xc,%esp
80105971:	8d 43 38             	lea    0x38(%ebx),%eax
80105974:	ff 73 34             	pushl  0x34(%ebx)
80105977:	50                   	push   %eax
80105978:	ff 75 f4             	pushl  -0xc(%ebp)
8010597b:	e8 a0 f5 ff ff       	call   80104f20 <strncpy>
  n=ch->lmemo;
80105980:	8b 73 34             	mov    0x34(%ebx),%esi
  release(&ch->lock);
80105983:	89 1c 24             	mov    %ebx,(%esp)
80105986:	e8 d5 f3 ff ff       	call   80104d60 <release>
  path[n]=0;
8010598b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  return n;
8010598e:	83 c4 10             	add    $0x10,%esp
  path[n]=0;
80105991:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
80105995:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105998:	89 f0                	mov    %esi,%eax
8010599a:	5b                   	pop    %ebx
8010599b:	5e                   	pop    %esi
8010599c:	5d                   	pop    %ebp
8010599d:	c3                   	ret    
8010599e:	66 90                	xchg   %ax,%ax
    return -1;
801059a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801059a5:	eb ee                	jmp    80105995 <sys_getmemo+0x55>
801059a7:	89 f6                	mov    %esi,%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059b0 <sys_memo>:

int
sys_memo(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	56                   	push   %esi
801059b4:	53                   	push   %ebx
  struct file *f;
  int fd;

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801059b5:	e8 46 b9 ff ff       	call   80101300 <filealloc>
801059ba:	85 c0                	test   %eax,%eax
801059bc:	74 2e                	je     801059ec <sys_memo+0x3c>
801059be:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
801059c0:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801059c2:	e8 b9 e4 ff ff       	call   80103e80 <myproc>
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[fd] == 0){
801059d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801059d4:	85 d2                	test   %edx,%edx
801059d6:	74 20                	je     801059f8 <sys_memo+0x48>
  for(fd = 0; fd < NOFILE; fd++){
801059d8:	83 c3 01             	add    $0x1,%ebx
801059db:	83 fb 10             	cmp    $0x10,%ebx
801059de:	75 f0                	jne    801059d0 <sys_memo+0x20>
    if(f)
      fileclose(f);
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	56                   	push   %esi
801059e4:	e8 d7 b9 ff ff       	call   801013c0 <fileclose>
801059e9:	83 c4 10             	add    $0x10,%esp
    return -1;
801059ec:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059f1:	eb 52                	jmp    80105a45 <sys_memo+0x95>
801059f3:	90                   	nop
801059f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  f->type = FD_MEMO;
  f->off = 0;
  f->readable = 1;
  f->writable = 1;
  struct memo* ch=(struct memo*)getshared(2);
801059f8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801059fb:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  f->readable = 1;
801059ff:	b8 01 01 00 00       	mov    $0x101,%eax
  f->type = FD_MEMO;
80105a04:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->off = 0;
80105a0a:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = 1;
80105a11:	66 89 46 08          	mov    %ax,0x8(%esi)
  struct memo* ch=(struct memo*)getshared(2);
80105a15:	6a 02                	push   $0x2
80105a17:	e8 e4 e6 ff ff       	call   80104100 <getshared>
  initlock(&ch->lock,"memo");
80105a1c:	5a                   	pop    %edx
80105a1d:	59                   	pop    %ecx
80105a1e:	68 59 83 10 80       	push   $0x80108359
80105a23:	50                   	push   %eax
  struct memo* ch=(struct memo*)getshared(2);
80105a24:	89 c6                	mov    %eax,%esi
  initlock(&ch->lock,"memo");
80105a26:	e8 15 f1 ff ff       	call   80104b40 <initlock>
  acquire(&ch->lock);
80105a2b:	89 34 24             	mov    %esi,(%esp)
80105a2e:	e8 0d f2 ff ff       	call   80104c40 <acquire>
  ch->lmemo=0;
80105a33:	c7 46 34 00 00 00 00 	movl   $0x0,0x34(%esi)
  release(&ch->lock);
80105a3a:	89 34 24             	mov    %esi,(%esp)
80105a3d:	e8 1e f3 ff ff       	call   80104d60 <release>
  return fd;
80105a42:	83 c4 10             	add    $0x10,%esp
}
80105a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a48:	89 d8                	mov    %ebx,%eax
80105a4a:	5b                   	pop    %ebx
80105a4b:	5e                   	pop    %esi
80105a4c:	5d                   	pop    %ebp
80105a4d:	c3                   	ret    
80105a4e:	66 90                	xchg   %ax,%ax

80105a50 <sys_open>:

int
sys_open(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	57                   	push   %edi
80105a54:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a55:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a58:	53                   	push   %ebx
80105a59:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a5c:	50                   	push   %eax
80105a5d:	6a 00                	push   $0x0
80105a5f:	e8 dc f6 ff ff       	call   80105140 <argstr>
80105a64:	83 c4 10             	add    $0x10,%esp
80105a67:	85 c0                	test   %eax,%eax
80105a69:	0f 88 8e 00 00 00    	js     80105afd <sys_open+0xad>
80105a6f:	83 ec 08             	sub    $0x8,%esp
80105a72:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a75:	50                   	push   %eax
80105a76:	6a 01                	push   $0x1
80105a78:	e8 13 f6 ff ff       	call   80105090 <argint>
80105a7d:	83 c4 10             	add    $0x10,%esp
80105a80:	85 c0                	test   %eax,%eax
80105a82:	78 79                	js     80105afd <sys_open+0xad>
    return -1;

  begin_op();
80105a84:	e8 47 d7 ff ff       	call   801031d0 <begin_op>

  if(omode & O_CREATE){
80105a89:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a8d:	75 79                	jne    80105b08 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a8f:	83 ec 0c             	sub    $0xc,%esp
80105a92:	ff 75 e0             	pushl  -0x20(%ebp)
80105a95:	e8 56 ca ff ff       	call   801024f0 <namei>
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	89 c6                	mov    %eax,%esi
80105a9f:	85 c0                	test   %eax,%eax
80105aa1:	0f 84 7e 00 00 00    	je     80105b25 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105aa7:	83 ec 0c             	sub    $0xc,%esp
80105aaa:	50                   	push   %eax
80105aab:	e8 a0 c1 ff ff       	call   80101c50 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ab0:	83 c4 10             	add    $0x10,%esp
80105ab3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ab8:	0f 84 c2 00 00 00    	je     80105b80 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105abe:	e8 3d b8 ff ff       	call   80101300 <filealloc>
80105ac3:	89 c7                	mov    %eax,%edi
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	74 23                	je     80105aec <sys_open+0x9c>
  struct proc *curproc = myproc();
80105ac9:	e8 b2 e3 ff ff       	call   80103e80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ace:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105ad0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ad4:	85 d2                	test   %edx,%edx
80105ad6:	74 60                	je     80105b38 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105ad8:	83 c3 01             	add    $0x1,%ebx
80105adb:	83 fb 10             	cmp    $0x10,%ebx
80105ade:	75 f0                	jne    80105ad0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	57                   	push   %edi
80105ae4:	e8 d7 b8 ff ff       	call   801013c0 <fileclose>
80105ae9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105aec:	83 ec 0c             	sub    $0xc,%esp
80105aef:	56                   	push   %esi
80105af0:	e8 eb c3 ff ff       	call   80101ee0 <iunlockput>
    end_op();
80105af5:	e8 46 d7 ff ff       	call   80103240 <end_op>
    return -1;
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b02:	eb 6d                	jmp    80105b71 <sys_open+0x121>
80105b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105b08:	83 ec 0c             	sub    $0xc,%esp
80105b0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b0e:	31 c9                	xor    %ecx,%ecx
80105b10:	ba 02 00 00 00       	mov    $0x2,%edx
80105b15:	6a 00                	push   $0x0
80105b17:	e8 c4 f6 ff ff       	call   801051e0 <create>
    if(ip == 0){
80105b1c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105b1f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b21:	85 c0                	test   %eax,%eax
80105b23:	75 99                	jne    80105abe <sys_open+0x6e>
      end_op();
80105b25:	e8 16 d7 ff ff       	call   80103240 <end_op>
      return -1;
80105b2a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b2f:	eb 40                	jmp    80105b71 <sys_open+0x121>
80105b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b38:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b3b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b3f:	56                   	push   %esi
80105b40:	e8 eb c1 ff ff       	call   80101d30 <iunlock>
  end_op();
80105b45:	e8 f6 d6 ff ff       	call   80103240 <end_op>

  f->type = FD_INODE;
80105b4a:	c7 07 03 00 00 00    	movl   $0x3,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b53:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b56:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b59:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b5b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b62:	f7 d0                	not    %eax
80105b64:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b67:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b6a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b6d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b74:	89 d8                	mov    %ebx,%eax
80105b76:	5b                   	pop    %ebx
80105b77:	5e                   	pop    %esi
80105b78:	5f                   	pop    %edi
80105b79:	5d                   	pop    %ebp
80105b7a:	c3                   	ret    
80105b7b:	90                   	nop
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b80:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b83:	85 c9                	test   %ecx,%ecx
80105b85:	0f 84 33 ff ff ff    	je     80105abe <sys_open+0x6e>
80105b8b:	e9 5c ff ff ff       	jmp    80105aec <sys_open+0x9c>

80105b90 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b96:	e8 35 d6 ff ff       	call   801031d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b9b:	83 ec 08             	sub    $0x8,%esp
80105b9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ba1:	50                   	push   %eax
80105ba2:	6a 00                	push   $0x0
80105ba4:	e8 97 f5 ff ff       	call   80105140 <argstr>
80105ba9:	83 c4 10             	add    $0x10,%esp
80105bac:	85 c0                	test   %eax,%eax
80105bae:	78 30                	js     80105be0 <sys_mkdir+0x50>
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb6:	31 c9                	xor    %ecx,%ecx
80105bb8:	ba 01 00 00 00       	mov    $0x1,%edx
80105bbd:	6a 00                	push   $0x0
80105bbf:	e8 1c f6 ff ff       	call   801051e0 <create>
80105bc4:	83 c4 10             	add    $0x10,%esp
80105bc7:	85 c0                	test   %eax,%eax
80105bc9:	74 15                	je     80105be0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bcb:	83 ec 0c             	sub    $0xc,%esp
80105bce:	50                   	push   %eax
80105bcf:	e8 0c c3 ff ff       	call   80101ee0 <iunlockput>
  end_op();
80105bd4:	e8 67 d6 ff ff       	call   80103240 <end_op>
  return 0;
80105bd9:	83 c4 10             	add    $0x10,%esp
80105bdc:	31 c0                	xor    %eax,%eax
}
80105bde:	c9                   	leave  
80105bdf:	c3                   	ret    
    end_op();
80105be0:	e8 5b d6 ff ff       	call   80103240 <end_op>
    return -1;
80105be5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bea:	c9                   	leave  
80105beb:	c3                   	ret    
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_mknod>:

int
sys_mknod(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105bf6:	e8 d5 d5 ff ff       	call   801031d0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105bfb:	83 ec 08             	sub    $0x8,%esp
80105bfe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c01:	50                   	push   %eax
80105c02:	6a 00                	push   $0x0
80105c04:	e8 37 f5 ff ff       	call   80105140 <argstr>
80105c09:	83 c4 10             	add    $0x10,%esp
80105c0c:	85 c0                	test   %eax,%eax
80105c0e:	78 60                	js     80105c70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105c10:	83 ec 08             	sub    $0x8,%esp
80105c13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c16:	50                   	push   %eax
80105c17:	6a 01                	push   $0x1
80105c19:	e8 72 f4 ff ff       	call   80105090 <argint>
  if((argstr(0, &path)) < 0 ||
80105c1e:	83 c4 10             	add    $0x10,%esp
80105c21:	85 c0                	test   %eax,%eax
80105c23:	78 4b                	js     80105c70 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c25:	83 ec 08             	sub    $0x8,%esp
80105c28:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c2b:	50                   	push   %eax
80105c2c:	6a 02                	push   $0x2
80105c2e:	e8 5d f4 ff ff       	call   80105090 <argint>
     argint(1, &major) < 0 ||
80105c33:	83 c4 10             	add    $0x10,%esp
80105c36:	85 c0                	test   %eax,%eax
80105c38:	78 36                	js     80105c70 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c3a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c3e:	83 ec 0c             	sub    $0xc,%esp
80105c41:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c45:	ba 03 00 00 00       	mov    $0x3,%edx
80105c4a:	50                   	push   %eax
80105c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c4e:	e8 8d f5 ff ff       	call   801051e0 <create>
     argint(2, &minor) < 0 ||
80105c53:	83 c4 10             	add    $0x10,%esp
80105c56:	85 c0                	test   %eax,%eax
80105c58:	74 16                	je     80105c70 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c5a:	83 ec 0c             	sub    $0xc,%esp
80105c5d:	50                   	push   %eax
80105c5e:	e8 7d c2 ff ff       	call   80101ee0 <iunlockput>
  end_op();
80105c63:	e8 d8 d5 ff ff       	call   80103240 <end_op>
  return 0;
80105c68:	83 c4 10             	add    $0x10,%esp
80105c6b:	31 c0                	xor    %eax,%eax
}
80105c6d:	c9                   	leave  
80105c6e:	c3                   	ret    
80105c6f:	90                   	nop
    end_op();
80105c70:	e8 cb d5 ff ff       	call   80103240 <end_op>
    return -1;
80105c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c7a:	c9                   	leave  
80105c7b:	c3                   	ret    
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_chdir>:

int
sys_chdir(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	56                   	push   %esi
80105c84:	53                   	push   %ebx
80105c85:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c88:	e8 f3 e1 ff ff       	call   80103e80 <myproc>
80105c8d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c8f:	e8 3c d5 ff ff       	call   801031d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c94:	83 ec 08             	sub    $0x8,%esp
80105c97:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c9a:	50                   	push   %eax
80105c9b:	6a 00                	push   $0x0
80105c9d:	e8 9e f4 ff ff       	call   80105140 <argstr>
80105ca2:	83 c4 10             	add    $0x10,%esp
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	78 77                	js     80105d20 <sys_chdir+0xa0>
80105ca9:	83 ec 0c             	sub    $0xc,%esp
80105cac:	ff 75 f4             	pushl  -0xc(%ebp)
80105caf:	e8 3c c8 ff ff       	call   801024f0 <namei>
80105cb4:	83 c4 10             	add    $0x10,%esp
80105cb7:	89 c3                	mov    %eax,%ebx
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	74 63                	je     80105d20 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	50                   	push   %eax
80105cc1:	e8 8a bf ff ff       	call   80101c50 <ilock>
  if(ip->type != T_DIR){
80105cc6:	83 c4 10             	add    $0x10,%esp
80105cc9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cce:	75 30                	jne    80105d00 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	53                   	push   %ebx
80105cd4:	e8 57 c0 ff ff       	call   80101d30 <iunlock>
  iput(curproc->cwd);
80105cd9:	58                   	pop    %eax
80105cda:	ff 76 68             	pushl  0x68(%esi)
80105cdd:	e8 9e c0 ff ff       	call   80101d80 <iput>
  end_op();
80105ce2:	e8 59 d5 ff ff       	call   80103240 <end_op>
  curproc->cwd = ip;
80105ce7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	31 c0                	xor    %eax,%eax
}
80105cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cf2:	5b                   	pop    %ebx
80105cf3:	5e                   	pop    %esi
80105cf4:	5d                   	pop    %ebp
80105cf5:	c3                   	ret    
80105cf6:	8d 76 00             	lea    0x0(%esi),%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105d00:	83 ec 0c             	sub    $0xc,%esp
80105d03:	53                   	push   %ebx
80105d04:	e8 d7 c1 ff ff       	call   80101ee0 <iunlockput>
    end_op();
80105d09:	e8 32 d5 ff ff       	call   80103240 <end_op>
    return -1;
80105d0e:	83 c4 10             	add    $0x10,%esp
80105d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d16:	eb d7                	jmp    80105cef <sys_chdir+0x6f>
80105d18:	90                   	nop
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105d20:	e8 1b d5 ff ff       	call   80103240 <end_op>
    return -1;
80105d25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2a:	eb c3                	jmp    80105cef <sys_chdir+0x6f>
80105d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d30 <sys_exec>:

int
sys_exec(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	57                   	push   %edi
80105d34:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d35:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d3b:	53                   	push   %ebx
80105d3c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d42:	50                   	push   %eax
80105d43:	6a 00                	push   $0x0
80105d45:	e8 f6 f3 ff ff       	call   80105140 <argstr>
80105d4a:	83 c4 10             	add    $0x10,%esp
80105d4d:	85 c0                	test   %eax,%eax
80105d4f:	0f 88 87 00 00 00    	js     80105ddc <sys_exec+0xac>
80105d55:	83 ec 08             	sub    $0x8,%esp
80105d58:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d5e:	50                   	push   %eax
80105d5f:	6a 01                	push   $0x1
80105d61:	e8 2a f3 ff ff       	call   80105090 <argint>
80105d66:	83 c4 10             	add    $0x10,%esp
80105d69:	85 c0                	test   %eax,%eax
80105d6b:	78 6f                	js     80105ddc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d6d:	83 ec 04             	sub    $0x4,%esp
80105d70:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105d76:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d78:	68 80 00 00 00       	push   $0x80
80105d7d:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105d83:	6a 00                	push   $0x0
80105d85:	50                   	push   %eax
80105d86:	e8 25 f0 ff ff       	call   80104db0 <memset>
80105d8b:	83 c4 10             	add    $0x10,%esp
80105d8e:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d90:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d96:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105d9d:	83 ec 08             	sub    $0x8,%esp
80105da0:	57                   	push   %edi
80105da1:	01 f0                	add    %esi,%eax
80105da3:	50                   	push   %eax
80105da4:	e8 47 f2 ff ff       	call   80104ff0 <fetchint>
80105da9:	83 c4 10             	add    $0x10,%esp
80105dac:	85 c0                	test   %eax,%eax
80105dae:	78 2c                	js     80105ddc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105db0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105db6:	85 c0                	test   %eax,%eax
80105db8:	74 36                	je     80105df0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105dba:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105dc0:	83 ec 08             	sub    $0x8,%esp
80105dc3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105dc6:	52                   	push   %edx
80105dc7:	50                   	push   %eax
80105dc8:	e8 63 f2 ff ff       	call   80105030 <fetchstr>
80105dcd:	83 c4 10             	add    $0x10,%esp
80105dd0:	85 c0                	test   %eax,%eax
80105dd2:	78 08                	js     80105ddc <sys_exec+0xac>
  for(i=0;; i++){
80105dd4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105dd7:	83 fb 20             	cmp    $0x20,%ebx
80105dda:	75 b4                	jne    80105d90 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105ddf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105de4:	5b                   	pop    %ebx
80105de5:	5e                   	pop    %esi
80105de6:	5f                   	pop    %edi
80105de7:	5d                   	pop    %ebp
80105de8:	c3                   	ret    
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105df0:	83 ec 08             	sub    $0x8,%esp
80105df3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105df9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e00:	00 00 00 00 
  return exec(path, argv);
80105e04:	50                   	push   %eax
80105e05:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e0b:	e8 70 b1 ff ff       	call   80100f80 <exec>
80105e10:	83 c4 10             	add    $0x10,%esp
}
80105e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e16:	5b                   	pop    %ebx
80105e17:	5e                   	pop    %esi
80105e18:	5f                   	pop    %edi
80105e19:	5d                   	pop    %ebp
80105e1a:	c3                   	ret    
80105e1b:	90                   	nop
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e20 <sys_pipe>:

int
sys_pipe(void)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	57                   	push   %edi
80105e24:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e25:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e28:	53                   	push   %ebx
80105e29:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e2c:	6a 08                	push   $0x8
80105e2e:	50                   	push   %eax
80105e2f:	6a 00                	push   $0x0
80105e31:	e8 aa f2 ff ff       	call   801050e0 <argptr>
80105e36:	83 c4 10             	add    $0x10,%esp
80105e39:	85 c0                	test   %eax,%eax
80105e3b:	78 4a                	js     80105e87 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e3d:	83 ec 08             	sub    $0x8,%esp
80105e40:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e43:	50                   	push   %eax
80105e44:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e47:	50                   	push   %eax
80105e48:	e8 83 da ff ff       	call   801038d0 <pipealloc>
80105e4d:	83 c4 10             	add    $0x10,%esp
80105e50:	85 c0                	test   %eax,%eax
80105e52:	78 33                	js     80105e87 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e54:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e57:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e59:	e8 22 e0 ff ff       	call   80103e80 <myproc>
80105e5e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105e60:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e64:	85 f6                	test   %esi,%esi
80105e66:	74 28                	je     80105e90 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105e68:	83 c3 01             	add    $0x1,%ebx
80105e6b:	83 fb 10             	cmp    $0x10,%ebx
80105e6e:	75 f0                	jne    80105e60 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e70:	83 ec 0c             	sub    $0xc,%esp
80105e73:	ff 75 e0             	pushl  -0x20(%ebp)
80105e76:	e8 45 b5 ff ff       	call   801013c0 <fileclose>
    fileclose(wf);
80105e7b:	58                   	pop    %eax
80105e7c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e7f:	e8 3c b5 ff ff       	call   801013c0 <fileclose>
    return -1;
80105e84:	83 c4 10             	add    $0x10,%esp
80105e87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e8c:	eb 53                	jmp    80105ee1 <sys_pipe+0xc1>
80105e8e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e90:	8d 73 08             	lea    0x8(%ebx),%esi
80105e93:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e9a:	e8 e1 df ff ff       	call   80103e80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e9f:	31 d2                	xor    %edx,%edx
80105ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ea8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105eac:	85 c9                	test   %ecx,%ecx
80105eae:	74 20                	je     80105ed0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105eb0:	83 c2 01             	add    $0x1,%edx
80105eb3:	83 fa 10             	cmp    $0x10,%edx
80105eb6:	75 f0                	jne    80105ea8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105eb8:	e8 c3 df ff ff       	call   80103e80 <myproc>
80105ebd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ec4:	00 
80105ec5:	eb a9                	jmp    80105e70 <sys_pipe+0x50>
80105ec7:	89 f6                	mov    %esi,%esi
80105ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      curproc->ofile[fd] = f;
80105ed0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105ed4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ed7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ed9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105edc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105edf:	31 c0                	xor    %eax,%eax
}
80105ee1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ee4:	5b                   	pop    %ebx
80105ee5:	5e                   	pop    %esi
80105ee6:	5f                   	pop    %edi
80105ee7:	5d                   	pop    %ebp
80105ee8:	c3                   	ret    
80105ee9:	66 90                	xchg   %ax,%ax
80105eeb:	66 90                	xchg   %ax,%ax
80105eed:	66 90                	xchg   %ax,%ax
80105eef:	90                   	nop

80105ef0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105ef0:	e9 fb e2 ff ff       	jmp    801041f0 <fork>
80105ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f00 <sys_exit>:
}

int
sys_exit(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f06:	e8 95 e6 ff ff       	call   801045a0 <exit>
  return 0;  // not reached
}
80105f0b:	31 c0                	xor    %eax,%eax
80105f0d:	c9                   	leave  
80105f0e:	c3                   	ret    
80105f0f:	90                   	nop

80105f10 <sys_split>:

int
sys_split(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 20             	sub    $0x20,%esp
  int op;

  if(argint(0, &op) < 0)
80105f16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f19:	50                   	push   %eax
80105f1a:	6a 00                	push   $0x0
80105f1c:	e8 6f f1 ff ff       	call   80105090 <argint>
80105f21:	83 c4 10             	add    $0x10,%esp
80105f24:	85 c0                	test   %eax,%eax
80105f26:	78 18                	js     80105f40 <sys_split+0x30>
    return -1;
  splitw(op);
80105f28:	83 ec 0c             	sub    $0xc,%esp
80105f2b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f2e:	e8 4d ac ff ff       	call   80100b80 <splitw>
  return  0;
80105f33:	83 c4 10             	add    $0x10,%esp
80105f36:	31 c0                	xor    %eax,%eax
}
80105f38:	c9                   	leave  
80105f39:	c3                   	ret    
80105f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f40:	c9                   	leave  
    return -1;
80105f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f46:	c3                   	ret    
80105f47:	89 f6                	mov    %esi,%esi
80105f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f50 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105f50:	e9 6b e8 ff ff       	jmp    801047c0 <wait>
80105f55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f60 <sys_kill>:
}

int
sys_kill(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f69:	50                   	push   %eax
80105f6a:	6a 00                	push   $0x0
80105f6c:	e8 1f f1 ff ff       	call   80105090 <argint>
80105f71:	83 c4 10             	add    $0x10,%esp
80105f74:	85 c0                	test   %eax,%eax
80105f76:	78 18                	js     80105f90 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f78:	83 ec 0c             	sub    $0xc,%esp
80105f7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f7e:	e8 6d e9 ff ff       	call   801048f0 <kill>
80105f83:	83 c4 10             	add    $0x10,%esp
}
80105f86:	c9                   	leave  
80105f87:	c3                   	ret    
80105f88:	90                   	nop
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f90:	c9                   	leave  
    return -1;
80105f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f96:	c3                   	ret    
80105f97:	89 f6                	mov    %esi,%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fa0 <sys_getpid>:

int
sys_getpid(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fa6:	e8 d5 de ff ff       	call   80103e80 <myproc>
80105fab:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fae:	c9                   	leave  
80105faf:	c3                   	ret    

80105fb0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fb7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105fba:	50                   	push   %eax
80105fbb:	6a 00                	push   $0x0
80105fbd:	e8 ce f0 ff ff       	call   80105090 <argint>
80105fc2:	83 c4 10             	add    $0x10,%esp
80105fc5:	85 c0                	test   %eax,%eax
80105fc7:	78 27                	js     80105ff0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105fc9:	e8 b2 de ff ff       	call   80103e80 <myproc>
  if(growproc(n) < 0)
80105fce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105fd1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105fd3:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd6:	e8 95 e1 ff ff       	call   80104170 <growproc>
80105fdb:	83 c4 10             	add    $0x10,%esp
80105fde:	85 c0                	test   %eax,%eax
80105fe0:	78 0e                	js     80105ff0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105fe2:	89 d8                	mov    %ebx,%eax
80105fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fe7:	c9                   	leave  
80105fe8:	c3                   	ret    
80105fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ff0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ff5:	eb eb                	jmp    80105fe2 <sys_sbrk+0x32>
80105ff7:	89 f6                	mov    %esi,%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106000 <sys_sleep>:

int
sys_sleep(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106004:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106007:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010600a:	50                   	push   %eax
8010600b:	6a 00                	push   $0x0
8010600d:	e8 7e f0 ff ff       	call   80105090 <argint>
80106012:	83 c4 10             	add    $0x10,%esp
80106015:	85 c0                	test   %eax,%eax
80106017:	0f 88 8a 00 00 00    	js     801060a7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010601d:	83 ec 0c             	sub    $0xc,%esp
80106020:	68 40 f4 11 80       	push   $0x8011f440
80106025:	e8 16 ec ff ff       	call   80104c40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010602a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010602d:	8b 1d 80 fc 11 80    	mov    0x8011fc80,%ebx
  while(ticks - ticks0 < n){
80106033:	83 c4 10             	add    $0x10,%esp
80106036:	85 d2                	test   %edx,%edx
80106038:	75 27                	jne    80106061 <sys_sleep+0x61>
8010603a:	eb 54                	jmp    80106090 <sys_sleep+0x90>
8010603c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106040:	83 ec 08             	sub    $0x8,%esp
80106043:	68 40 f4 11 80       	push   $0x8011f440
80106048:	68 80 fc 11 80       	push   $0x8011fc80
8010604d:	e8 ae e6 ff ff       	call   80104700 <sleep>
  while(ticks - ticks0 < n){
80106052:	a1 80 fc 11 80       	mov    0x8011fc80,%eax
80106057:	83 c4 10             	add    $0x10,%esp
8010605a:	29 d8                	sub    %ebx,%eax
8010605c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010605f:	73 2f                	jae    80106090 <sys_sleep+0x90>
    if(myproc()->killed){
80106061:	e8 1a de ff ff       	call   80103e80 <myproc>
80106066:	8b 40 24             	mov    0x24(%eax),%eax
80106069:	85 c0                	test   %eax,%eax
8010606b:	74 d3                	je     80106040 <sys_sleep+0x40>
      release(&tickslock);
8010606d:	83 ec 0c             	sub    $0xc,%esp
80106070:	68 40 f4 11 80       	push   $0x8011f440
80106075:	e8 e6 ec ff ff       	call   80104d60 <release>
      return -1;
8010607a:	83 c4 10             	add    $0x10,%esp
8010607d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106082:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106085:	c9                   	leave  
80106086:	c3                   	ret    
80106087:	89 f6                	mov    %esi,%esi
80106089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	68 40 f4 11 80       	push   $0x8011f440
80106098:	e8 c3 ec ff ff       	call   80104d60 <release>
  return 0;
8010609d:	83 c4 10             	add    $0x10,%esp
801060a0:	31 c0                	xor    %eax,%eax
}
801060a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060a5:	c9                   	leave  
801060a6:	c3                   	ret    
    return -1;
801060a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ac:	eb f4                	jmp    801060a2 <sys_sleep+0xa2>
801060ae:	66 90                	xchg   %ax,%ax

801060b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	53                   	push   %ebx
801060b4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060b7:	68 40 f4 11 80       	push   $0x8011f440
801060bc:	e8 7f eb ff ff       	call   80104c40 <acquire>
  xticks = ticks;
801060c1:	8b 1d 80 fc 11 80    	mov    0x8011fc80,%ebx
  release(&tickslock);
801060c7:	c7 04 24 40 f4 11 80 	movl   $0x8011f440,(%esp)
801060ce:	e8 8d ec ff ff       	call   80104d60 <release>
  return xticks;
}
801060d3:	89 d8                	mov    %ebx,%eax
801060d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060d8:	c9                   	leave  
801060d9:	c3                   	ret    
801060da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060e0 <sys_trace>:

int
sys_trace(void)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->timepiece;
801060e6:	e8 95 dd ff ff       	call   80103e80 <myproc>
801060eb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
801060f1:	c9                   	leave  
801060f2:	c3                   	ret    
801060f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801060f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106100 <sys_releasesharem>:

int
sys_releasesharem(void)
{
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	83 ec 20             	sub    $0x20,%esp
  int idx;
  if(argint(0,&idx)<0)
80106106:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106109:	50                   	push   %eax
8010610a:	6a 00                	push   $0x0
8010610c:	e8 7f ef ff ff       	call   80105090 <argint>
80106111:	83 c4 10             	add    $0x10,%esp
80106114:	85 c0                	test   %eax,%eax
80106116:	78 18                	js     80106130 <sys_releasesharem+0x30>
    return -1;
  releaseshared(idx);
80106118:	83 ec 0c             	sub    $0xc,%esp
8010611b:	ff 75 f4             	pushl  -0xc(%ebp)
8010611e:	e8 8d df ff ff       	call   801040b0 <releaseshared>
  return 0;
80106123:	83 c4 10             	add    $0x10,%esp
80106126:	31 c0                	xor    %eax,%eax
}
80106128:	c9                   	leave  
80106129:	c3                   	ret    
8010612a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106130:	c9                   	leave  
    return -1;
80106131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106136:	c3                   	ret    
80106137:	89 f6                	mov    %esi,%esi
80106139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106140 <sys_getsharem>:

int
sys_getsharem(void)
{
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	83 ec 20             	sub    $0x20,%esp
  int idx;
  if(argint(0,&idx)<0)
80106146:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106149:	50                   	push   %eax
8010614a:	6a 00                	push   $0x0
8010614c:	e8 3f ef ff ff       	call   80105090 <argint>
80106151:	83 c4 10             	add    $0x10,%esp
80106154:	85 c0                	test   %eax,%eax
80106156:	78 2a                	js     80106182 <sys_getsharem+0x42>
    return -1;
  if(idx==1)
80106158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010615b:	83 f8 01             	cmp    $0x1,%eax
8010615e:	74 10                	je     80106170 <sys_getsharem+0x30>
    getshared(0);
  return (int)getshared(idx);
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	50                   	push   %eax
80106164:	e8 97 df ff ff       	call   80104100 <getshared>
80106169:	83 c4 10             	add    $0x10,%esp
}
8010616c:	c9                   	leave  
8010616d:	c3                   	ret    
8010616e:	66 90                	xchg   %ax,%ax
    getshared(0);
80106170:	83 ec 0c             	sub    $0xc,%esp
80106173:	6a 00                	push   $0x0
80106175:	e8 86 df ff ff       	call   80104100 <getshared>
8010617a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010617d:	83 c4 10             	add    $0x10,%esp
80106180:	eb de                	jmp    80106160 <sys_getsharem+0x20>
}
80106182:	c9                   	leave  
    return -1;
80106183:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106188:	c3                   	ret    
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106190 <sys_att>:

int
sys_att(void)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	83 ec 20             	sub    $0x20,%esp
  int cmd;
  if(argint(0,&cmd)<0)
80106196:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106199:	50                   	push   %eax
8010619a:	6a 00                	push   $0x0
8010619c:	e8 ef ee ff ff       	call   80105090 <argint>
801061a1:	83 c4 10             	add    $0x10,%esp
801061a4:	85 c0                	test   %eax,%eax
801061a6:	78 1b                	js     801061c3 <sys_att+0x33>
  asm volatile("cli");
801061a8:	fa                   	cli    
    return -1;
  cli();
  cpus[0].consflag=cmd;
801061a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ac:	a2 b4 c8 11 80       	mov    %al,0x8011c8b4
  cpus[1].consflag=cmd;
801061b1:	a2 6c c9 11 80       	mov    %al,0x8011c96c
  return cpus[0].rtime+cpus[1].rtime;
801061b6:	a1 68 c9 11 80       	mov    0x8011c968,%eax
801061bb:	03 05 b0 c8 11 80    	add    0x8011c8b0,%eax
}
801061c1:	c9                   	leave  
801061c2:	c3                   	ret    
801061c3:	c9                   	leave  
    return -1;
801061c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061c9:	c3                   	ret    

801061ca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801061ca:	1e                   	push   %ds
  pushl %es
801061cb:	06                   	push   %es
  pushl %fs
801061cc:	0f a0                	push   %fs
  pushl %gs
801061ce:	0f a8                	push   %gs
  pushal
801061d0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801061d1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801061d5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801061d7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801061d9:	54                   	push   %esp
  call trap
801061da:	e8 c1 00 00 00       	call   801062a0 <trap>
  addl $4, %esp
801061df:	83 c4 04             	add    $0x4,%esp

801061e2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801061e2:	61                   	popa   
  popl %gs
801061e3:	0f a9                	pop    %gs
  popl %fs
801061e5:	0f a1                	pop    %fs
  popl %es
801061e7:	07                   	pop    %es
  popl %ds
801061e8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801061e9:	83 c4 08             	add    $0x8,%esp
  iret
801061ec:	cf                   	iret   
801061ed:	66 90                	xchg   %ax,%ax
801061ef:	90                   	nop

801061f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801061f0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801061f1:	31 c0                	xor    %eax,%eax
{
801061f3:	89 e5                	mov    %esp,%ebp
801061f5:	83 ec 08             	sub    $0x8,%esp
801061f8:	90                   	nop
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106200:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106207:	c7 04 c5 82 f4 11 80 	movl   $0x8e000008,-0x7fee0b7e(,%eax,8)
8010620e:	08 00 00 8e 
80106212:	66 89 14 c5 80 f4 11 	mov    %dx,-0x7fee0b80(,%eax,8)
80106219:	80 
8010621a:	c1 ea 10             	shr    $0x10,%edx
8010621d:	66 89 14 c5 86 f4 11 	mov    %dx,-0x7fee0b7a(,%eax,8)
80106224:	80 
  for(i = 0; i < 256; i++)
80106225:	83 c0 01             	add    $0x1,%eax
80106228:	3d 00 01 00 00       	cmp    $0x100,%eax
8010622d:	75 d1                	jne    80106200 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010622f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106232:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106237:	c7 05 82 f6 11 80 08 	movl   $0xef000008,0x8011f682
8010623e:	00 00 ef 
  initlock(&tickslock, "time");
80106241:	68 5e 83 10 80       	push   $0x8010835e
80106246:	68 40 f4 11 80       	push   $0x8011f440
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010624b:	66 a3 80 f6 11 80    	mov    %ax,0x8011f680
80106251:	c1 e8 10             	shr    $0x10,%eax
80106254:	66 a3 86 f6 11 80    	mov    %ax,0x8011f686
  initlock(&tickslock, "time");
8010625a:	e8 e1 e8 ff ff       	call   80104b40 <initlock>
}
8010625f:	83 c4 10             	add    $0x10,%esp
80106262:	c9                   	leave  
80106263:	c3                   	ret    
80106264:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010626a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106270 <idtinit>:

void
idtinit(void)
{
80106270:	55                   	push   %ebp
  pd[0] = size-1;
80106271:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106276:	89 e5                	mov    %esp,%ebp
80106278:	83 ec 10             	sub    $0x10,%esp
8010627b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010627f:	b8 80 f4 11 80       	mov    $0x8011f480,%eax
80106284:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106288:	c1 e8 10             	shr    $0x10,%eax
8010628b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010628f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106292:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106295:	c9                   	leave  
80106296:	c3                   	ret    
80106297:	89 f6                	mov    %esi,%esi
80106299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	57                   	push   %edi
801062a4:	56                   	push   %esi
801062a5:	53                   	push   %ebx
801062a6:	83 ec 1c             	sub    $0x1c,%esp
801062a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801062ac:	8b 47 30             	mov    0x30(%edi),%eax
801062af:	83 f8 40             	cmp    $0x40,%eax
801062b2:	0f 84 c8 01 00 00    	je     80106480 <trap+0x1e0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801062b8:	83 e8 20             	sub    $0x20,%eax
801062bb:	83 f8 1f             	cmp    $0x1f,%eax
801062be:	77 10                	ja     801062d0 <trap+0x30>
801062c0:	ff 24 85 04 84 10 80 	jmp    *-0x7fef7bfc(,%eax,4)
801062c7:	89 f6                	mov    %esi,%esi
801062c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801062d0:	e8 ab db ff ff       	call   80103e80 <myproc>
801062d5:	8b 5f 38             	mov    0x38(%edi),%ebx
801062d8:	85 c0                	test   %eax,%eax
801062da:	0f 84 4a 02 00 00    	je     8010652a <trap+0x28a>
801062e0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801062e4:	0f 84 40 02 00 00    	je     8010652a <trap+0x28a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062ea:	0f 20 d1             	mov    %cr2,%ecx
801062ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062f0:	e8 6b db ff ff       	call   80103e60 <cpuid>
801062f5:	8b 77 30             	mov    0x30(%edi),%esi
801062f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801062fb:	8b 47 34             	mov    0x34(%edi),%eax
801062fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106301:	e8 7a db ff ff       	call   80103e80 <myproc>
80106306:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106309:	e8 72 db ff ff       	call   80103e80 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010630e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106311:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106314:	51                   	push   %ecx
80106315:	53                   	push   %ebx
80106316:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106317:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010631a:	ff 75 e4             	pushl  -0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
8010631d:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106320:	56                   	push   %esi
80106321:	52                   	push   %edx
80106322:	ff 70 10             	pushl  0x10(%eax)
80106325:	68 c0 83 10 80       	push   $0x801083c0
8010632a:	e8 71 a3 ff ff       	call   801006a0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010632f:	83 c4 20             	add    $0x20,%esp
80106332:	e8 49 db ff ff       	call   80103e80 <myproc>
80106337:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010633e:	e8 3d db ff ff       	call   80103e80 <myproc>
80106343:	85 c0                	test   %eax,%eax
80106345:	74 1d                	je     80106364 <trap+0xc4>
80106347:	e8 34 db ff ff       	call   80103e80 <myproc>
8010634c:	8b 50 24             	mov    0x24(%eax),%edx
8010634f:	85 d2                	test   %edx,%edx
80106351:	74 11                	je     80106364 <trap+0xc4>
80106353:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106357:	83 e0 03             	and    $0x3,%eax
8010635a:	66 83 f8 03          	cmp    $0x3,%ax
8010635e:	0f 84 74 01 00 00    	je     801064d8 <trap+0x238>
    exit();

  //brand new
  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(tf->trapno == T_IRQ0+IRQ_TIMER)
80106364:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106368:	0f 84 52 01 00 00    	je     801064c0 <trap+0x220>
  {
    mycpu()->rtime++;
  }
  if(myproc() && myproc()->state == RUNNING &&
8010636e:	e8 0d db ff ff       	call   80103e80 <myproc>
80106373:	85 c0                	test   %eax,%eax
80106375:	74 0b                	je     80106382 <trap+0xe2>
80106377:	e8 04 db ff ff       	call   80103e80 <myproc>
8010637c:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106380:	74 2e                	je     801063b0 <trap+0x110>
    yield();
    title();
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106382:	e8 f9 da ff ff       	call   80103e80 <myproc>
80106387:	85 c0                	test   %eax,%eax
80106389:	74 1d                	je     801063a8 <trap+0x108>
8010638b:	e8 f0 da ff ff       	call   80103e80 <myproc>
80106390:	8b 40 24             	mov    0x24(%eax),%eax
80106393:	85 c0                	test   %eax,%eax
80106395:	74 11                	je     801063a8 <trap+0x108>
80106397:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
8010639b:	83 e0 03             	and    $0x3,%eax
8010639e:	66 83 f8 03          	cmp    $0x3,%ax
801063a2:	0f 84 05 01 00 00    	je     801064ad <trap+0x20d>
    exit();
}
801063a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063ab:	5b                   	pop    %ebx
801063ac:	5e                   	pop    %esi
801063ad:	5f                   	pop    %edi
801063ae:	5d                   	pop    %ebp
801063af:	c3                   	ret    
  if(myproc() && myproc()->state == RUNNING &&
801063b0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801063b4:	75 cc                	jne    80106382 <trap+0xe2>
     tf->trapno == T_IRQ0+IRQ_TIMER && (--myproc()->timepiece)<=0)
801063b6:	e8 c5 da ff ff       	call   80103e80 <myproc>
801063bb:	83 a8 84 00 00 00 01 	subl   $0x1,0x84(%eax)
801063c2:	75 be                	jne    80106382 <trap+0xe2>
    yield();
801063c4:	e8 c7 e2 ff ff       	call   80104690 <yield>
    title();
801063c9:	e8 72 a5 ff ff       	call   80100940 <title>
801063ce:	eb b2                	jmp    80106382 <trap+0xe2>
    if(cpuid() == 0){
801063d0:	e8 8b da ff ff       	call   80103e60 <cpuid>
801063d5:	85 c0                	test   %eax,%eax
801063d7:	0f 84 0b 01 00 00    	je     801064e8 <trap+0x248>
    lapiceoi();
801063dd:	e8 9e c9 ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063e2:	e8 99 da ff ff       	call   80103e80 <myproc>
801063e7:	85 c0                	test   %eax,%eax
801063e9:	0f 85 58 ff ff ff    	jne    80106347 <trap+0xa7>
801063ef:	e9 70 ff ff ff       	jmp    80106364 <trap+0xc4>
801063f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801063f8:	e8 43 c8 ff ff       	call   80102c40 <kbdintr>
    lapiceoi();
801063fd:	e8 7e c9 ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106402:	e8 79 da ff ff       	call   80103e80 <myproc>
80106407:	85 c0                	test   %eax,%eax
80106409:	0f 85 38 ff ff ff    	jne    80106347 <trap+0xa7>
8010640f:	e9 50 ff ff ff       	jmp    80106364 <trap+0xc4>
80106414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106418:	e8 b3 02 00 00       	call   801066d0 <uartintr>
    lapiceoi();
8010641d:	e8 5e c9 ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106422:	e8 59 da ff ff       	call   80103e80 <myproc>
80106427:	85 c0                	test   %eax,%eax
80106429:	0f 85 18 ff ff ff    	jne    80106347 <trap+0xa7>
8010642f:	e9 30 ff ff ff       	jmp    80106364 <trap+0xc4>
80106434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106438:	8b 77 38             	mov    0x38(%edi),%esi
8010643b:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010643f:	e8 1c da ff ff       	call   80103e60 <cpuid>
80106444:	56                   	push   %esi
80106445:	53                   	push   %ebx
80106446:	50                   	push   %eax
80106447:	68 68 83 10 80       	push   $0x80108368
8010644c:	e8 4f a2 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106451:	e8 2a c9 ff ff       	call   80102d80 <lapiceoi>
    break;
80106456:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106459:	e8 22 da ff ff       	call   80103e80 <myproc>
8010645e:	85 c0                	test   %eax,%eax
80106460:	0f 85 e1 fe ff ff    	jne    80106347 <trap+0xa7>
80106466:	e9 f9 fe ff ff       	jmp    80106364 <trap+0xc4>
8010646b:	90                   	nop
8010646c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106470:	e8 1b c2 ff ff       	call   80102690 <ideintr>
80106475:	e9 63 ff ff ff       	jmp    801063dd <trap+0x13d>
8010647a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106480:	e8 fb d9 ff ff       	call   80103e80 <myproc>
80106485:	8b 58 24             	mov    0x24(%eax),%ebx
80106488:	85 db                	test   %ebx,%ebx
8010648a:	0f 85 90 00 00 00    	jne    80106520 <trap+0x280>
    myproc()->tf = tf;
80106490:	e8 eb d9 ff ff       	call   80103e80 <myproc>
80106495:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106498:	e8 e3 ec ff ff       	call   80105180 <syscall>
    if(myproc()->killed)
8010649d:	e8 de d9 ff ff       	call   80103e80 <myproc>
801064a2:	8b 48 24             	mov    0x24(%eax),%ecx
801064a5:	85 c9                	test   %ecx,%ecx
801064a7:	0f 84 fb fe ff ff    	je     801063a8 <trap+0x108>
}
801064ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064b0:	5b                   	pop    %ebx
801064b1:	5e                   	pop    %esi
801064b2:	5f                   	pop    %edi
801064b3:	5d                   	pop    %ebp
      exit();
801064b4:	e9 e7 e0 ff ff       	jmp    801045a0 <exit>
801064b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    mycpu()->rtime++;
801064c0:	e8 1b d9 ff ff       	call   80103de0 <mycpu>
801064c5:	83 80 b0 00 00 00 01 	addl   $0x1,0xb0(%eax)
801064cc:	e9 9d fe ff ff       	jmp    8010636e <trap+0xce>
801064d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801064d8:	e8 c3 e0 ff ff       	call   801045a0 <exit>
801064dd:	e9 82 fe ff ff       	jmp    80106364 <trap+0xc4>
801064e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801064e8:	83 ec 0c             	sub    $0xc,%esp
801064eb:	68 40 f4 11 80       	push   $0x8011f440
801064f0:	e8 4b e7 ff ff       	call   80104c40 <acquire>
      wakeup(&ticks);
801064f5:	c7 04 24 80 fc 11 80 	movl   $0x8011fc80,(%esp)
      ticks++;
801064fc:	83 05 80 fc 11 80 01 	addl   $0x1,0x8011fc80
      wakeup(&ticks);
80106503:	e8 b8 e3 ff ff       	call   801048c0 <wakeup>
      release(&tickslock);
80106508:	c7 04 24 40 f4 11 80 	movl   $0x8011f440,(%esp)
8010650f:	e8 4c e8 ff ff       	call   80104d60 <release>
80106514:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106517:	e9 c1 fe ff ff       	jmp    801063dd <trap+0x13d>
8010651c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80106520:	e8 7b e0 ff ff       	call   801045a0 <exit>
80106525:	e9 66 ff ff ff       	jmp    80106490 <trap+0x1f0>
8010652a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010652d:	e8 2e d9 ff ff       	call   80103e60 <cpuid>
80106532:	83 ec 0c             	sub    $0xc,%esp
80106535:	56                   	push   %esi
80106536:	53                   	push   %ebx
80106537:	50                   	push   %eax
80106538:	ff 77 30             	pushl  0x30(%edi)
8010653b:	68 8c 83 10 80       	push   $0x8010838c
80106540:	e8 5b a1 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106545:	83 c4 14             	add    $0x14,%esp
80106548:	68 63 83 10 80       	push   $0x80108363
8010654d:	e8 3e 9e ff ff       	call   80100390 <panic>
80106552:	66 90                	xchg   %ax,%ax
80106554:	66 90                	xchg   %ax,%ax
80106556:	66 90                	xchg   %ax,%ax
80106558:	66 90                	xchg   %ax,%ax
8010655a:	66 90                	xchg   %ax,%ax
8010655c:	66 90                	xchg   %ax,%ax
8010655e:	66 90                	xchg   %ax,%ax

80106560 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106560:	a1 dc b5 10 80       	mov    0x8010b5dc,%eax
80106565:	85 c0                	test   %eax,%eax
80106567:	74 17                	je     80106580 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106569:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010656e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010656f:	a8 01                	test   $0x1,%al
80106571:	74 0d                	je     80106580 <uartgetc+0x20>
80106573:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106578:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106579:	0f b6 c0             	movzbl %al,%eax
8010657c:	c3                   	ret    
8010657d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106585:	c3                   	ret    
80106586:	8d 76 00             	lea    0x0(%esi),%esi
80106589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106590 <uartputc.part.0>:
uartputc(int c)
80106590:	55                   	push   %ebp
80106591:	89 e5                	mov    %esp,%ebp
80106593:	57                   	push   %edi
80106594:	89 c7                	mov    %eax,%edi
80106596:	56                   	push   %esi
80106597:	be fd 03 00 00       	mov    $0x3fd,%esi
8010659c:	53                   	push   %ebx
8010659d:	bb 80 00 00 00       	mov    $0x80,%ebx
801065a2:	83 ec 0c             	sub    $0xc,%esp
801065a5:	eb 1b                	jmp    801065c2 <uartputc.part.0+0x32>
801065a7:	89 f6                	mov    %esi,%esi
801065a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801065b0:	83 ec 0c             	sub    $0xc,%esp
801065b3:	6a 0a                	push   $0xa
801065b5:	e8 e6 c7 ff ff       	call   80102da0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065ba:	83 c4 10             	add    $0x10,%esp
801065bd:	83 eb 01             	sub    $0x1,%ebx
801065c0:	74 07                	je     801065c9 <uartputc.part.0+0x39>
801065c2:	89 f2                	mov    %esi,%edx
801065c4:	ec                   	in     (%dx),%al
801065c5:	a8 20                	test   $0x20,%al
801065c7:	74 e7                	je     801065b0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065c9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065ce:	89 f8                	mov    %edi,%eax
801065d0:	ee                   	out    %al,(%dx)
}
801065d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065d4:	5b                   	pop    %ebx
801065d5:	5e                   	pop    %esi
801065d6:	5f                   	pop    %edi
801065d7:	5d                   	pop    %ebp
801065d8:	c3                   	ret    
801065d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065e0 <uartinit>:
{
801065e0:	55                   	push   %ebp
801065e1:	31 c9                	xor    %ecx,%ecx
801065e3:	89 c8                	mov    %ecx,%eax
801065e5:	89 e5                	mov    %esp,%ebp
801065e7:	57                   	push   %edi
801065e8:	56                   	push   %esi
801065e9:	53                   	push   %ebx
801065ea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801065ef:	89 da                	mov    %ebx,%edx
801065f1:	83 ec 0c             	sub    $0xc,%esp
801065f4:	ee                   	out    %al,(%dx)
801065f5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801065fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801065ff:	89 fa                	mov    %edi,%edx
80106601:	ee                   	out    %al,(%dx)
80106602:	b8 0c 00 00 00       	mov    $0xc,%eax
80106607:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010660c:	ee                   	out    %al,(%dx)
8010660d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106612:	89 c8                	mov    %ecx,%eax
80106614:	89 f2                	mov    %esi,%edx
80106616:	ee                   	out    %al,(%dx)
80106617:	b8 03 00 00 00       	mov    $0x3,%eax
8010661c:	89 fa                	mov    %edi,%edx
8010661e:	ee                   	out    %al,(%dx)
8010661f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106624:	89 c8                	mov    %ecx,%eax
80106626:	ee                   	out    %al,(%dx)
80106627:	b8 01 00 00 00       	mov    $0x1,%eax
8010662c:	89 f2                	mov    %esi,%edx
8010662e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010662f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106634:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106635:	3c ff                	cmp    $0xff,%al
80106637:	74 56                	je     8010668f <uartinit+0xaf>
  uart = 1;
80106639:	c7 05 dc b5 10 80 01 	movl   $0x1,0x8010b5dc
80106640:	00 00 00 
80106643:	89 da                	mov    %ebx,%edx
80106645:	ec                   	in     (%dx),%al
80106646:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010664b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010664c:	83 ec 08             	sub    $0x8,%esp
8010664f:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106654:	bb 84 84 10 80       	mov    $0x80108484,%ebx
  ioapicenable(IRQ_COM1, 0);
80106659:	6a 00                	push   $0x0
8010665b:	6a 04                	push   $0x4
8010665d:	e8 7e c2 ff ff       	call   801028e0 <ioapicenable>
80106662:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106665:	b8 78 00 00 00       	mov    $0x78,%eax
8010666a:	eb 08                	jmp    80106674 <uartinit+0x94>
8010666c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106670:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106674:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
8010667a:	85 d2                	test   %edx,%edx
8010667c:	74 08                	je     80106686 <uartinit+0xa6>
    uartputc(*p);
8010667e:	0f be c0             	movsbl %al,%eax
80106681:	e8 0a ff ff ff       	call   80106590 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106686:	89 f0                	mov    %esi,%eax
80106688:	83 c3 01             	add    $0x1,%ebx
8010668b:	84 c0                	test   %al,%al
8010668d:	75 e1                	jne    80106670 <uartinit+0x90>
}
8010668f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106692:	5b                   	pop    %ebx
80106693:	5e                   	pop    %esi
80106694:	5f                   	pop    %edi
80106695:	5d                   	pop    %ebp
80106696:	c3                   	ret    
80106697:	89 f6                	mov    %esi,%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066a0 <uartputc>:
{
801066a0:	55                   	push   %ebp
  if(!uart)
801066a1:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
{
801066a7:	89 e5                	mov    %esp,%ebp
801066a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801066ac:	85 d2                	test   %edx,%edx
801066ae:	74 10                	je     801066c0 <uartputc+0x20>
}
801066b0:	5d                   	pop    %ebp
801066b1:	e9 da fe ff ff       	jmp    80106590 <uartputc.part.0>
801066b6:	8d 76 00             	lea    0x0(%esi),%esi
801066b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801066c0:	5d                   	pop    %ebp
801066c1:	c3                   	ret    
801066c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066d0 <uartintr>:

void
uartintr(void)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801066d6:	68 60 65 10 80       	push   $0x80106560
801066db:	e8 a0 a6 ff ff       	call   80100d80 <consoleintr>
}
801066e0:	83 c4 10             	add    $0x10,%esp
801066e3:	c9                   	leave  
801066e4:	c3                   	ret    

801066e5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $0
801066e7:	6a 00                	push   $0x0
  jmp alltraps
801066e9:	e9 dc fa ff ff       	jmp    801061ca <alltraps>

801066ee <vector1>:
.globl vector1
vector1:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $1
801066f0:	6a 01                	push   $0x1
  jmp alltraps
801066f2:	e9 d3 fa ff ff       	jmp    801061ca <alltraps>

801066f7 <vector2>:
.globl vector2
vector2:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $2
801066f9:	6a 02                	push   $0x2
  jmp alltraps
801066fb:	e9 ca fa ff ff       	jmp    801061ca <alltraps>

80106700 <vector3>:
.globl vector3
vector3:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $3
80106702:	6a 03                	push   $0x3
  jmp alltraps
80106704:	e9 c1 fa ff ff       	jmp    801061ca <alltraps>

80106709 <vector4>:
.globl vector4
vector4:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $4
8010670b:	6a 04                	push   $0x4
  jmp alltraps
8010670d:	e9 b8 fa ff ff       	jmp    801061ca <alltraps>

80106712 <vector5>:
.globl vector5
vector5:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $5
80106714:	6a 05                	push   $0x5
  jmp alltraps
80106716:	e9 af fa ff ff       	jmp    801061ca <alltraps>

8010671b <vector6>:
.globl vector6
vector6:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $6
8010671d:	6a 06                	push   $0x6
  jmp alltraps
8010671f:	e9 a6 fa ff ff       	jmp    801061ca <alltraps>

80106724 <vector7>:
.globl vector7
vector7:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $7
80106726:	6a 07                	push   $0x7
  jmp alltraps
80106728:	e9 9d fa ff ff       	jmp    801061ca <alltraps>

8010672d <vector8>:
.globl vector8
vector8:
  pushl $8
8010672d:	6a 08                	push   $0x8
  jmp alltraps
8010672f:	e9 96 fa ff ff       	jmp    801061ca <alltraps>

80106734 <vector9>:
.globl vector9
vector9:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $9
80106736:	6a 09                	push   $0x9
  jmp alltraps
80106738:	e9 8d fa ff ff       	jmp    801061ca <alltraps>

8010673d <vector10>:
.globl vector10
vector10:
  pushl $10
8010673d:	6a 0a                	push   $0xa
  jmp alltraps
8010673f:	e9 86 fa ff ff       	jmp    801061ca <alltraps>

80106744 <vector11>:
.globl vector11
vector11:
  pushl $11
80106744:	6a 0b                	push   $0xb
  jmp alltraps
80106746:	e9 7f fa ff ff       	jmp    801061ca <alltraps>

8010674b <vector12>:
.globl vector12
vector12:
  pushl $12
8010674b:	6a 0c                	push   $0xc
  jmp alltraps
8010674d:	e9 78 fa ff ff       	jmp    801061ca <alltraps>

80106752 <vector13>:
.globl vector13
vector13:
  pushl $13
80106752:	6a 0d                	push   $0xd
  jmp alltraps
80106754:	e9 71 fa ff ff       	jmp    801061ca <alltraps>

80106759 <vector14>:
.globl vector14
vector14:
  pushl $14
80106759:	6a 0e                	push   $0xe
  jmp alltraps
8010675b:	e9 6a fa ff ff       	jmp    801061ca <alltraps>

80106760 <vector15>:
.globl vector15
vector15:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $15
80106762:	6a 0f                	push   $0xf
  jmp alltraps
80106764:	e9 61 fa ff ff       	jmp    801061ca <alltraps>

80106769 <vector16>:
.globl vector16
vector16:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $16
8010676b:	6a 10                	push   $0x10
  jmp alltraps
8010676d:	e9 58 fa ff ff       	jmp    801061ca <alltraps>

80106772 <vector17>:
.globl vector17
vector17:
  pushl $17
80106772:	6a 11                	push   $0x11
  jmp alltraps
80106774:	e9 51 fa ff ff       	jmp    801061ca <alltraps>

80106779 <vector18>:
.globl vector18
vector18:
  pushl $0
80106779:	6a 00                	push   $0x0
  pushl $18
8010677b:	6a 12                	push   $0x12
  jmp alltraps
8010677d:	e9 48 fa ff ff       	jmp    801061ca <alltraps>

80106782 <vector19>:
.globl vector19
vector19:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $19
80106784:	6a 13                	push   $0x13
  jmp alltraps
80106786:	e9 3f fa ff ff       	jmp    801061ca <alltraps>

8010678b <vector20>:
.globl vector20
vector20:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $20
8010678d:	6a 14                	push   $0x14
  jmp alltraps
8010678f:	e9 36 fa ff ff       	jmp    801061ca <alltraps>

80106794 <vector21>:
.globl vector21
vector21:
  pushl $0
80106794:	6a 00                	push   $0x0
  pushl $21
80106796:	6a 15                	push   $0x15
  jmp alltraps
80106798:	e9 2d fa ff ff       	jmp    801061ca <alltraps>

8010679d <vector22>:
.globl vector22
vector22:
  pushl $0
8010679d:	6a 00                	push   $0x0
  pushl $22
8010679f:	6a 16                	push   $0x16
  jmp alltraps
801067a1:	e9 24 fa ff ff       	jmp    801061ca <alltraps>

801067a6 <vector23>:
.globl vector23
vector23:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $23
801067a8:	6a 17                	push   $0x17
  jmp alltraps
801067aa:	e9 1b fa ff ff       	jmp    801061ca <alltraps>

801067af <vector24>:
.globl vector24
vector24:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $24
801067b1:	6a 18                	push   $0x18
  jmp alltraps
801067b3:	e9 12 fa ff ff       	jmp    801061ca <alltraps>

801067b8 <vector25>:
.globl vector25
vector25:
  pushl $0
801067b8:	6a 00                	push   $0x0
  pushl $25
801067ba:	6a 19                	push   $0x19
  jmp alltraps
801067bc:	e9 09 fa ff ff       	jmp    801061ca <alltraps>

801067c1 <vector26>:
.globl vector26
vector26:
  pushl $0
801067c1:	6a 00                	push   $0x0
  pushl $26
801067c3:	6a 1a                	push   $0x1a
  jmp alltraps
801067c5:	e9 00 fa ff ff       	jmp    801061ca <alltraps>

801067ca <vector27>:
.globl vector27
vector27:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $27
801067cc:	6a 1b                	push   $0x1b
  jmp alltraps
801067ce:	e9 f7 f9 ff ff       	jmp    801061ca <alltraps>

801067d3 <vector28>:
.globl vector28
vector28:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $28
801067d5:	6a 1c                	push   $0x1c
  jmp alltraps
801067d7:	e9 ee f9 ff ff       	jmp    801061ca <alltraps>

801067dc <vector29>:
.globl vector29
vector29:
  pushl $0
801067dc:	6a 00                	push   $0x0
  pushl $29
801067de:	6a 1d                	push   $0x1d
  jmp alltraps
801067e0:	e9 e5 f9 ff ff       	jmp    801061ca <alltraps>

801067e5 <vector30>:
.globl vector30
vector30:
  pushl $0
801067e5:	6a 00                	push   $0x0
  pushl $30
801067e7:	6a 1e                	push   $0x1e
  jmp alltraps
801067e9:	e9 dc f9 ff ff       	jmp    801061ca <alltraps>

801067ee <vector31>:
.globl vector31
vector31:
  pushl $0
801067ee:	6a 00                	push   $0x0
  pushl $31
801067f0:	6a 1f                	push   $0x1f
  jmp alltraps
801067f2:	e9 d3 f9 ff ff       	jmp    801061ca <alltraps>

801067f7 <vector32>:
.globl vector32
vector32:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $32
801067f9:	6a 20                	push   $0x20
  jmp alltraps
801067fb:	e9 ca f9 ff ff       	jmp    801061ca <alltraps>

80106800 <vector33>:
.globl vector33
vector33:
  pushl $0
80106800:	6a 00                	push   $0x0
  pushl $33
80106802:	6a 21                	push   $0x21
  jmp alltraps
80106804:	e9 c1 f9 ff ff       	jmp    801061ca <alltraps>

80106809 <vector34>:
.globl vector34
vector34:
  pushl $0
80106809:	6a 00                	push   $0x0
  pushl $34
8010680b:	6a 22                	push   $0x22
  jmp alltraps
8010680d:	e9 b8 f9 ff ff       	jmp    801061ca <alltraps>

80106812 <vector35>:
.globl vector35
vector35:
  pushl $0
80106812:	6a 00                	push   $0x0
  pushl $35
80106814:	6a 23                	push   $0x23
  jmp alltraps
80106816:	e9 af f9 ff ff       	jmp    801061ca <alltraps>

8010681b <vector36>:
.globl vector36
vector36:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $36
8010681d:	6a 24                	push   $0x24
  jmp alltraps
8010681f:	e9 a6 f9 ff ff       	jmp    801061ca <alltraps>

80106824 <vector37>:
.globl vector37
vector37:
  pushl $0
80106824:	6a 00                	push   $0x0
  pushl $37
80106826:	6a 25                	push   $0x25
  jmp alltraps
80106828:	e9 9d f9 ff ff       	jmp    801061ca <alltraps>

8010682d <vector38>:
.globl vector38
vector38:
  pushl $0
8010682d:	6a 00                	push   $0x0
  pushl $38
8010682f:	6a 26                	push   $0x26
  jmp alltraps
80106831:	e9 94 f9 ff ff       	jmp    801061ca <alltraps>

80106836 <vector39>:
.globl vector39
vector39:
  pushl $0
80106836:	6a 00                	push   $0x0
  pushl $39
80106838:	6a 27                	push   $0x27
  jmp alltraps
8010683a:	e9 8b f9 ff ff       	jmp    801061ca <alltraps>

8010683f <vector40>:
.globl vector40
vector40:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $40
80106841:	6a 28                	push   $0x28
  jmp alltraps
80106843:	e9 82 f9 ff ff       	jmp    801061ca <alltraps>

80106848 <vector41>:
.globl vector41
vector41:
  pushl $0
80106848:	6a 00                	push   $0x0
  pushl $41
8010684a:	6a 29                	push   $0x29
  jmp alltraps
8010684c:	e9 79 f9 ff ff       	jmp    801061ca <alltraps>

80106851 <vector42>:
.globl vector42
vector42:
  pushl $0
80106851:	6a 00                	push   $0x0
  pushl $42
80106853:	6a 2a                	push   $0x2a
  jmp alltraps
80106855:	e9 70 f9 ff ff       	jmp    801061ca <alltraps>

8010685a <vector43>:
.globl vector43
vector43:
  pushl $0
8010685a:	6a 00                	push   $0x0
  pushl $43
8010685c:	6a 2b                	push   $0x2b
  jmp alltraps
8010685e:	e9 67 f9 ff ff       	jmp    801061ca <alltraps>

80106863 <vector44>:
.globl vector44
vector44:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $44
80106865:	6a 2c                	push   $0x2c
  jmp alltraps
80106867:	e9 5e f9 ff ff       	jmp    801061ca <alltraps>

8010686c <vector45>:
.globl vector45
vector45:
  pushl $0
8010686c:	6a 00                	push   $0x0
  pushl $45
8010686e:	6a 2d                	push   $0x2d
  jmp alltraps
80106870:	e9 55 f9 ff ff       	jmp    801061ca <alltraps>

80106875 <vector46>:
.globl vector46
vector46:
  pushl $0
80106875:	6a 00                	push   $0x0
  pushl $46
80106877:	6a 2e                	push   $0x2e
  jmp alltraps
80106879:	e9 4c f9 ff ff       	jmp    801061ca <alltraps>

8010687e <vector47>:
.globl vector47
vector47:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $47
80106880:	6a 2f                	push   $0x2f
  jmp alltraps
80106882:	e9 43 f9 ff ff       	jmp    801061ca <alltraps>

80106887 <vector48>:
.globl vector48
vector48:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $48
80106889:	6a 30                	push   $0x30
  jmp alltraps
8010688b:	e9 3a f9 ff ff       	jmp    801061ca <alltraps>

80106890 <vector49>:
.globl vector49
vector49:
  pushl $0
80106890:	6a 00                	push   $0x0
  pushl $49
80106892:	6a 31                	push   $0x31
  jmp alltraps
80106894:	e9 31 f9 ff ff       	jmp    801061ca <alltraps>

80106899 <vector50>:
.globl vector50
vector50:
  pushl $0
80106899:	6a 00                	push   $0x0
  pushl $50
8010689b:	6a 32                	push   $0x32
  jmp alltraps
8010689d:	e9 28 f9 ff ff       	jmp    801061ca <alltraps>

801068a2 <vector51>:
.globl vector51
vector51:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $51
801068a4:	6a 33                	push   $0x33
  jmp alltraps
801068a6:	e9 1f f9 ff ff       	jmp    801061ca <alltraps>

801068ab <vector52>:
.globl vector52
vector52:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $52
801068ad:	6a 34                	push   $0x34
  jmp alltraps
801068af:	e9 16 f9 ff ff       	jmp    801061ca <alltraps>

801068b4 <vector53>:
.globl vector53
vector53:
  pushl $0
801068b4:	6a 00                	push   $0x0
  pushl $53
801068b6:	6a 35                	push   $0x35
  jmp alltraps
801068b8:	e9 0d f9 ff ff       	jmp    801061ca <alltraps>

801068bd <vector54>:
.globl vector54
vector54:
  pushl $0
801068bd:	6a 00                	push   $0x0
  pushl $54
801068bf:	6a 36                	push   $0x36
  jmp alltraps
801068c1:	e9 04 f9 ff ff       	jmp    801061ca <alltraps>

801068c6 <vector55>:
.globl vector55
vector55:
  pushl $0
801068c6:	6a 00                	push   $0x0
  pushl $55
801068c8:	6a 37                	push   $0x37
  jmp alltraps
801068ca:	e9 fb f8 ff ff       	jmp    801061ca <alltraps>

801068cf <vector56>:
.globl vector56
vector56:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $56
801068d1:	6a 38                	push   $0x38
  jmp alltraps
801068d3:	e9 f2 f8 ff ff       	jmp    801061ca <alltraps>

801068d8 <vector57>:
.globl vector57
vector57:
  pushl $0
801068d8:	6a 00                	push   $0x0
  pushl $57
801068da:	6a 39                	push   $0x39
  jmp alltraps
801068dc:	e9 e9 f8 ff ff       	jmp    801061ca <alltraps>

801068e1 <vector58>:
.globl vector58
vector58:
  pushl $0
801068e1:	6a 00                	push   $0x0
  pushl $58
801068e3:	6a 3a                	push   $0x3a
  jmp alltraps
801068e5:	e9 e0 f8 ff ff       	jmp    801061ca <alltraps>

801068ea <vector59>:
.globl vector59
vector59:
  pushl $0
801068ea:	6a 00                	push   $0x0
  pushl $59
801068ec:	6a 3b                	push   $0x3b
  jmp alltraps
801068ee:	e9 d7 f8 ff ff       	jmp    801061ca <alltraps>

801068f3 <vector60>:
.globl vector60
vector60:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $60
801068f5:	6a 3c                	push   $0x3c
  jmp alltraps
801068f7:	e9 ce f8 ff ff       	jmp    801061ca <alltraps>

801068fc <vector61>:
.globl vector61
vector61:
  pushl $0
801068fc:	6a 00                	push   $0x0
  pushl $61
801068fe:	6a 3d                	push   $0x3d
  jmp alltraps
80106900:	e9 c5 f8 ff ff       	jmp    801061ca <alltraps>

80106905 <vector62>:
.globl vector62
vector62:
  pushl $0
80106905:	6a 00                	push   $0x0
  pushl $62
80106907:	6a 3e                	push   $0x3e
  jmp alltraps
80106909:	e9 bc f8 ff ff       	jmp    801061ca <alltraps>

8010690e <vector63>:
.globl vector63
vector63:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $63
80106910:	6a 3f                	push   $0x3f
  jmp alltraps
80106912:	e9 b3 f8 ff ff       	jmp    801061ca <alltraps>

80106917 <vector64>:
.globl vector64
vector64:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $64
80106919:	6a 40                	push   $0x40
  jmp alltraps
8010691b:	e9 aa f8 ff ff       	jmp    801061ca <alltraps>

80106920 <vector65>:
.globl vector65
vector65:
  pushl $0
80106920:	6a 00                	push   $0x0
  pushl $65
80106922:	6a 41                	push   $0x41
  jmp alltraps
80106924:	e9 a1 f8 ff ff       	jmp    801061ca <alltraps>

80106929 <vector66>:
.globl vector66
vector66:
  pushl $0
80106929:	6a 00                	push   $0x0
  pushl $66
8010692b:	6a 42                	push   $0x42
  jmp alltraps
8010692d:	e9 98 f8 ff ff       	jmp    801061ca <alltraps>

80106932 <vector67>:
.globl vector67
vector67:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $67
80106934:	6a 43                	push   $0x43
  jmp alltraps
80106936:	e9 8f f8 ff ff       	jmp    801061ca <alltraps>

8010693b <vector68>:
.globl vector68
vector68:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $68
8010693d:	6a 44                	push   $0x44
  jmp alltraps
8010693f:	e9 86 f8 ff ff       	jmp    801061ca <alltraps>

80106944 <vector69>:
.globl vector69
vector69:
  pushl $0
80106944:	6a 00                	push   $0x0
  pushl $69
80106946:	6a 45                	push   $0x45
  jmp alltraps
80106948:	e9 7d f8 ff ff       	jmp    801061ca <alltraps>

8010694d <vector70>:
.globl vector70
vector70:
  pushl $0
8010694d:	6a 00                	push   $0x0
  pushl $70
8010694f:	6a 46                	push   $0x46
  jmp alltraps
80106951:	e9 74 f8 ff ff       	jmp    801061ca <alltraps>

80106956 <vector71>:
.globl vector71
vector71:
  pushl $0
80106956:	6a 00                	push   $0x0
  pushl $71
80106958:	6a 47                	push   $0x47
  jmp alltraps
8010695a:	e9 6b f8 ff ff       	jmp    801061ca <alltraps>

8010695f <vector72>:
.globl vector72
vector72:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $72
80106961:	6a 48                	push   $0x48
  jmp alltraps
80106963:	e9 62 f8 ff ff       	jmp    801061ca <alltraps>

80106968 <vector73>:
.globl vector73
vector73:
  pushl $0
80106968:	6a 00                	push   $0x0
  pushl $73
8010696a:	6a 49                	push   $0x49
  jmp alltraps
8010696c:	e9 59 f8 ff ff       	jmp    801061ca <alltraps>

80106971 <vector74>:
.globl vector74
vector74:
  pushl $0
80106971:	6a 00                	push   $0x0
  pushl $74
80106973:	6a 4a                	push   $0x4a
  jmp alltraps
80106975:	e9 50 f8 ff ff       	jmp    801061ca <alltraps>

8010697a <vector75>:
.globl vector75
vector75:
  pushl $0
8010697a:	6a 00                	push   $0x0
  pushl $75
8010697c:	6a 4b                	push   $0x4b
  jmp alltraps
8010697e:	e9 47 f8 ff ff       	jmp    801061ca <alltraps>

80106983 <vector76>:
.globl vector76
vector76:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $76
80106985:	6a 4c                	push   $0x4c
  jmp alltraps
80106987:	e9 3e f8 ff ff       	jmp    801061ca <alltraps>

8010698c <vector77>:
.globl vector77
vector77:
  pushl $0
8010698c:	6a 00                	push   $0x0
  pushl $77
8010698e:	6a 4d                	push   $0x4d
  jmp alltraps
80106990:	e9 35 f8 ff ff       	jmp    801061ca <alltraps>

80106995 <vector78>:
.globl vector78
vector78:
  pushl $0
80106995:	6a 00                	push   $0x0
  pushl $78
80106997:	6a 4e                	push   $0x4e
  jmp alltraps
80106999:	e9 2c f8 ff ff       	jmp    801061ca <alltraps>

8010699e <vector79>:
.globl vector79
vector79:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $79
801069a0:	6a 4f                	push   $0x4f
  jmp alltraps
801069a2:	e9 23 f8 ff ff       	jmp    801061ca <alltraps>

801069a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $80
801069a9:	6a 50                	push   $0x50
  jmp alltraps
801069ab:	e9 1a f8 ff ff       	jmp    801061ca <alltraps>

801069b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801069b0:	6a 00                	push   $0x0
  pushl $81
801069b2:	6a 51                	push   $0x51
  jmp alltraps
801069b4:	e9 11 f8 ff ff       	jmp    801061ca <alltraps>

801069b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $82
801069bb:	6a 52                	push   $0x52
  jmp alltraps
801069bd:	e9 08 f8 ff ff       	jmp    801061ca <alltraps>

801069c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $83
801069c4:	6a 53                	push   $0x53
  jmp alltraps
801069c6:	e9 ff f7 ff ff       	jmp    801061ca <alltraps>

801069cb <vector84>:
.globl vector84
vector84:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $84
801069cd:	6a 54                	push   $0x54
  jmp alltraps
801069cf:	e9 f6 f7 ff ff       	jmp    801061ca <alltraps>

801069d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801069d4:	6a 00                	push   $0x0
  pushl $85
801069d6:	6a 55                	push   $0x55
  jmp alltraps
801069d8:	e9 ed f7 ff ff       	jmp    801061ca <alltraps>

801069dd <vector86>:
.globl vector86
vector86:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $86
801069df:	6a 56                	push   $0x56
  jmp alltraps
801069e1:	e9 e4 f7 ff ff       	jmp    801061ca <alltraps>

801069e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $87
801069e8:	6a 57                	push   $0x57
  jmp alltraps
801069ea:	e9 db f7 ff ff       	jmp    801061ca <alltraps>

801069ef <vector88>:
.globl vector88
vector88:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $88
801069f1:	6a 58                	push   $0x58
  jmp alltraps
801069f3:	e9 d2 f7 ff ff       	jmp    801061ca <alltraps>

801069f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801069f8:	6a 00                	push   $0x0
  pushl $89
801069fa:	6a 59                	push   $0x59
  jmp alltraps
801069fc:	e9 c9 f7 ff ff       	jmp    801061ca <alltraps>

80106a01 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a01:	6a 00                	push   $0x0
  pushl $90
80106a03:	6a 5a                	push   $0x5a
  jmp alltraps
80106a05:	e9 c0 f7 ff ff       	jmp    801061ca <alltraps>

80106a0a <vector91>:
.globl vector91
vector91:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $91
80106a0c:	6a 5b                	push   $0x5b
  jmp alltraps
80106a0e:	e9 b7 f7 ff ff       	jmp    801061ca <alltraps>

80106a13 <vector92>:
.globl vector92
vector92:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $92
80106a15:	6a 5c                	push   $0x5c
  jmp alltraps
80106a17:	e9 ae f7 ff ff       	jmp    801061ca <alltraps>

80106a1c <vector93>:
.globl vector93
vector93:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $93
80106a1e:	6a 5d                	push   $0x5d
  jmp alltraps
80106a20:	e9 a5 f7 ff ff       	jmp    801061ca <alltraps>

80106a25 <vector94>:
.globl vector94
vector94:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $94
80106a27:	6a 5e                	push   $0x5e
  jmp alltraps
80106a29:	e9 9c f7 ff ff       	jmp    801061ca <alltraps>

80106a2e <vector95>:
.globl vector95
vector95:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $95
80106a30:	6a 5f                	push   $0x5f
  jmp alltraps
80106a32:	e9 93 f7 ff ff       	jmp    801061ca <alltraps>

80106a37 <vector96>:
.globl vector96
vector96:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $96
80106a39:	6a 60                	push   $0x60
  jmp alltraps
80106a3b:	e9 8a f7 ff ff       	jmp    801061ca <alltraps>

80106a40 <vector97>:
.globl vector97
vector97:
  pushl $0
80106a40:	6a 00                	push   $0x0
  pushl $97
80106a42:	6a 61                	push   $0x61
  jmp alltraps
80106a44:	e9 81 f7 ff ff       	jmp    801061ca <alltraps>

80106a49 <vector98>:
.globl vector98
vector98:
  pushl $0
80106a49:	6a 00                	push   $0x0
  pushl $98
80106a4b:	6a 62                	push   $0x62
  jmp alltraps
80106a4d:	e9 78 f7 ff ff       	jmp    801061ca <alltraps>

80106a52 <vector99>:
.globl vector99
vector99:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $99
80106a54:	6a 63                	push   $0x63
  jmp alltraps
80106a56:	e9 6f f7 ff ff       	jmp    801061ca <alltraps>

80106a5b <vector100>:
.globl vector100
vector100:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $100
80106a5d:	6a 64                	push   $0x64
  jmp alltraps
80106a5f:	e9 66 f7 ff ff       	jmp    801061ca <alltraps>

80106a64 <vector101>:
.globl vector101
vector101:
  pushl $0
80106a64:	6a 00                	push   $0x0
  pushl $101
80106a66:	6a 65                	push   $0x65
  jmp alltraps
80106a68:	e9 5d f7 ff ff       	jmp    801061ca <alltraps>

80106a6d <vector102>:
.globl vector102
vector102:
  pushl $0
80106a6d:	6a 00                	push   $0x0
  pushl $102
80106a6f:	6a 66                	push   $0x66
  jmp alltraps
80106a71:	e9 54 f7 ff ff       	jmp    801061ca <alltraps>

80106a76 <vector103>:
.globl vector103
vector103:
  pushl $0
80106a76:	6a 00                	push   $0x0
  pushl $103
80106a78:	6a 67                	push   $0x67
  jmp alltraps
80106a7a:	e9 4b f7 ff ff       	jmp    801061ca <alltraps>

80106a7f <vector104>:
.globl vector104
vector104:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $104
80106a81:	6a 68                	push   $0x68
  jmp alltraps
80106a83:	e9 42 f7 ff ff       	jmp    801061ca <alltraps>

80106a88 <vector105>:
.globl vector105
vector105:
  pushl $0
80106a88:	6a 00                	push   $0x0
  pushl $105
80106a8a:	6a 69                	push   $0x69
  jmp alltraps
80106a8c:	e9 39 f7 ff ff       	jmp    801061ca <alltraps>

80106a91 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a91:	6a 00                	push   $0x0
  pushl $106
80106a93:	6a 6a                	push   $0x6a
  jmp alltraps
80106a95:	e9 30 f7 ff ff       	jmp    801061ca <alltraps>

80106a9a <vector107>:
.globl vector107
vector107:
  pushl $0
80106a9a:	6a 00                	push   $0x0
  pushl $107
80106a9c:	6a 6b                	push   $0x6b
  jmp alltraps
80106a9e:	e9 27 f7 ff ff       	jmp    801061ca <alltraps>

80106aa3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $108
80106aa5:	6a 6c                	push   $0x6c
  jmp alltraps
80106aa7:	e9 1e f7 ff ff       	jmp    801061ca <alltraps>

80106aac <vector109>:
.globl vector109
vector109:
  pushl $0
80106aac:	6a 00                	push   $0x0
  pushl $109
80106aae:	6a 6d                	push   $0x6d
  jmp alltraps
80106ab0:	e9 15 f7 ff ff       	jmp    801061ca <alltraps>

80106ab5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106ab5:	6a 00                	push   $0x0
  pushl $110
80106ab7:	6a 6e                	push   $0x6e
  jmp alltraps
80106ab9:	e9 0c f7 ff ff       	jmp    801061ca <alltraps>

80106abe <vector111>:
.globl vector111
vector111:
  pushl $0
80106abe:	6a 00                	push   $0x0
  pushl $111
80106ac0:	6a 6f                	push   $0x6f
  jmp alltraps
80106ac2:	e9 03 f7 ff ff       	jmp    801061ca <alltraps>

80106ac7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $112
80106ac9:	6a 70                	push   $0x70
  jmp alltraps
80106acb:	e9 fa f6 ff ff       	jmp    801061ca <alltraps>

80106ad0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106ad0:	6a 00                	push   $0x0
  pushl $113
80106ad2:	6a 71                	push   $0x71
  jmp alltraps
80106ad4:	e9 f1 f6 ff ff       	jmp    801061ca <alltraps>

80106ad9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106ad9:	6a 00                	push   $0x0
  pushl $114
80106adb:	6a 72                	push   $0x72
  jmp alltraps
80106add:	e9 e8 f6 ff ff       	jmp    801061ca <alltraps>

80106ae2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $115
80106ae4:	6a 73                	push   $0x73
  jmp alltraps
80106ae6:	e9 df f6 ff ff       	jmp    801061ca <alltraps>

80106aeb <vector116>:
.globl vector116
vector116:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $116
80106aed:	6a 74                	push   $0x74
  jmp alltraps
80106aef:	e9 d6 f6 ff ff       	jmp    801061ca <alltraps>

80106af4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106af4:	6a 00                	push   $0x0
  pushl $117
80106af6:	6a 75                	push   $0x75
  jmp alltraps
80106af8:	e9 cd f6 ff ff       	jmp    801061ca <alltraps>

80106afd <vector118>:
.globl vector118
vector118:
  pushl $0
80106afd:	6a 00                	push   $0x0
  pushl $118
80106aff:	6a 76                	push   $0x76
  jmp alltraps
80106b01:	e9 c4 f6 ff ff       	jmp    801061ca <alltraps>

80106b06 <vector119>:
.globl vector119
vector119:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $119
80106b08:	6a 77                	push   $0x77
  jmp alltraps
80106b0a:	e9 bb f6 ff ff       	jmp    801061ca <alltraps>

80106b0f <vector120>:
.globl vector120
vector120:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $120
80106b11:	6a 78                	push   $0x78
  jmp alltraps
80106b13:	e9 b2 f6 ff ff       	jmp    801061ca <alltraps>

80106b18 <vector121>:
.globl vector121
vector121:
  pushl $0
80106b18:	6a 00                	push   $0x0
  pushl $121
80106b1a:	6a 79                	push   $0x79
  jmp alltraps
80106b1c:	e9 a9 f6 ff ff       	jmp    801061ca <alltraps>

80106b21 <vector122>:
.globl vector122
vector122:
  pushl $0
80106b21:	6a 00                	push   $0x0
  pushl $122
80106b23:	6a 7a                	push   $0x7a
  jmp alltraps
80106b25:	e9 a0 f6 ff ff       	jmp    801061ca <alltraps>

80106b2a <vector123>:
.globl vector123
vector123:
  pushl $0
80106b2a:	6a 00                	push   $0x0
  pushl $123
80106b2c:	6a 7b                	push   $0x7b
  jmp alltraps
80106b2e:	e9 97 f6 ff ff       	jmp    801061ca <alltraps>

80106b33 <vector124>:
.globl vector124
vector124:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $124
80106b35:	6a 7c                	push   $0x7c
  jmp alltraps
80106b37:	e9 8e f6 ff ff       	jmp    801061ca <alltraps>

80106b3c <vector125>:
.globl vector125
vector125:
  pushl $0
80106b3c:	6a 00                	push   $0x0
  pushl $125
80106b3e:	6a 7d                	push   $0x7d
  jmp alltraps
80106b40:	e9 85 f6 ff ff       	jmp    801061ca <alltraps>

80106b45 <vector126>:
.globl vector126
vector126:
  pushl $0
80106b45:	6a 00                	push   $0x0
  pushl $126
80106b47:	6a 7e                	push   $0x7e
  jmp alltraps
80106b49:	e9 7c f6 ff ff       	jmp    801061ca <alltraps>

80106b4e <vector127>:
.globl vector127
vector127:
  pushl $0
80106b4e:	6a 00                	push   $0x0
  pushl $127
80106b50:	6a 7f                	push   $0x7f
  jmp alltraps
80106b52:	e9 73 f6 ff ff       	jmp    801061ca <alltraps>

80106b57 <vector128>:
.globl vector128
vector128:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $128
80106b59:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106b5e:	e9 67 f6 ff ff       	jmp    801061ca <alltraps>

80106b63 <vector129>:
.globl vector129
vector129:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $129
80106b65:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106b6a:	e9 5b f6 ff ff       	jmp    801061ca <alltraps>

80106b6f <vector130>:
.globl vector130
vector130:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $130
80106b71:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b76:	e9 4f f6 ff ff       	jmp    801061ca <alltraps>

80106b7b <vector131>:
.globl vector131
vector131:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $131
80106b7d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b82:	e9 43 f6 ff ff       	jmp    801061ca <alltraps>

80106b87 <vector132>:
.globl vector132
vector132:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $132
80106b89:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b8e:	e9 37 f6 ff ff       	jmp    801061ca <alltraps>

80106b93 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $133
80106b95:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b9a:	e9 2b f6 ff ff       	jmp    801061ca <alltraps>

80106b9f <vector134>:
.globl vector134
vector134:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $134
80106ba1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ba6:	e9 1f f6 ff ff       	jmp    801061ca <alltraps>

80106bab <vector135>:
.globl vector135
vector135:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $135
80106bad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106bb2:	e9 13 f6 ff ff       	jmp    801061ca <alltraps>

80106bb7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $136
80106bb9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106bbe:	e9 07 f6 ff ff       	jmp    801061ca <alltraps>

80106bc3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $137
80106bc5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106bca:	e9 fb f5 ff ff       	jmp    801061ca <alltraps>

80106bcf <vector138>:
.globl vector138
vector138:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $138
80106bd1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106bd6:	e9 ef f5 ff ff       	jmp    801061ca <alltraps>

80106bdb <vector139>:
.globl vector139
vector139:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $139
80106bdd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106be2:	e9 e3 f5 ff ff       	jmp    801061ca <alltraps>

80106be7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $140
80106be9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106bee:	e9 d7 f5 ff ff       	jmp    801061ca <alltraps>

80106bf3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $141
80106bf5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106bfa:	e9 cb f5 ff ff       	jmp    801061ca <alltraps>

80106bff <vector142>:
.globl vector142
vector142:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $142
80106c01:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c06:	e9 bf f5 ff ff       	jmp    801061ca <alltraps>

80106c0b <vector143>:
.globl vector143
vector143:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $143
80106c0d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106c12:	e9 b3 f5 ff ff       	jmp    801061ca <alltraps>

80106c17 <vector144>:
.globl vector144
vector144:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $144
80106c19:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106c1e:	e9 a7 f5 ff ff       	jmp    801061ca <alltraps>

80106c23 <vector145>:
.globl vector145
vector145:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $145
80106c25:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106c2a:	e9 9b f5 ff ff       	jmp    801061ca <alltraps>

80106c2f <vector146>:
.globl vector146
vector146:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $146
80106c31:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106c36:	e9 8f f5 ff ff       	jmp    801061ca <alltraps>

80106c3b <vector147>:
.globl vector147
vector147:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $147
80106c3d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106c42:	e9 83 f5 ff ff       	jmp    801061ca <alltraps>

80106c47 <vector148>:
.globl vector148
vector148:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $148
80106c49:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106c4e:	e9 77 f5 ff ff       	jmp    801061ca <alltraps>

80106c53 <vector149>:
.globl vector149
vector149:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $149
80106c55:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106c5a:	e9 6b f5 ff ff       	jmp    801061ca <alltraps>

80106c5f <vector150>:
.globl vector150
vector150:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $150
80106c61:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106c66:	e9 5f f5 ff ff       	jmp    801061ca <alltraps>

80106c6b <vector151>:
.globl vector151
vector151:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $151
80106c6d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c72:	e9 53 f5 ff ff       	jmp    801061ca <alltraps>

80106c77 <vector152>:
.globl vector152
vector152:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $152
80106c79:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c7e:	e9 47 f5 ff ff       	jmp    801061ca <alltraps>

80106c83 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $153
80106c85:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c8a:	e9 3b f5 ff ff       	jmp    801061ca <alltraps>

80106c8f <vector154>:
.globl vector154
vector154:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $154
80106c91:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c96:	e9 2f f5 ff ff       	jmp    801061ca <alltraps>

80106c9b <vector155>:
.globl vector155
vector155:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $155
80106c9d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ca2:	e9 23 f5 ff ff       	jmp    801061ca <alltraps>

80106ca7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $156
80106ca9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106cae:	e9 17 f5 ff ff       	jmp    801061ca <alltraps>

80106cb3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $157
80106cb5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106cba:	e9 0b f5 ff ff       	jmp    801061ca <alltraps>

80106cbf <vector158>:
.globl vector158
vector158:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $158
80106cc1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106cc6:	e9 ff f4 ff ff       	jmp    801061ca <alltraps>

80106ccb <vector159>:
.globl vector159
vector159:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $159
80106ccd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106cd2:	e9 f3 f4 ff ff       	jmp    801061ca <alltraps>

80106cd7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $160
80106cd9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106cde:	e9 e7 f4 ff ff       	jmp    801061ca <alltraps>

80106ce3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $161
80106ce5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106cea:	e9 db f4 ff ff       	jmp    801061ca <alltraps>

80106cef <vector162>:
.globl vector162
vector162:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $162
80106cf1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106cf6:	e9 cf f4 ff ff       	jmp    801061ca <alltraps>

80106cfb <vector163>:
.globl vector163
vector163:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $163
80106cfd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d02:	e9 c3 f4 ff ff       	jmp    801061ca <alltraps>

80106d07 <vector164>:
.globl vector164
vector164:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $164
80106d09:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106d0e:	e9 b7 f4 ff ff       	jmp    801061ca <alltraps>

80106d13 <vector165>:
.globl vector165
vector165:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $165
80106d15:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106d1a:	e9 ab f4 ff ff       	jmp    801061ca <alltraps>

80106d1f <vector166>:
.globl vector166
vector166:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $166
80106d21:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106d26:	e9 9f f4 ff ff       	jmp    801061ca <alltraps>

80106d2b <vector167>:
.globl vector167
vector167:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $167
80106d2d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106d32:	e9 93 f4 ff ff       	jmp    801061ca <alltraps>

80106d37 <vector168>:
.globl vector168
vector168:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $168
80106d39:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106d3e:	e9 87 f4 ff ff       	jmp    801061ca <alltraps>

80106d43 <vector169>:
.globl vector169
vector169:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $169
80106d45:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106d4a:	e9 7b f4 ff ff       	jmp    801061ca <alltraps>

80106d4f <vector170>:
.globl vector170
vector170:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $170
80106d51:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106d56:	e9 6f f4 ff ff       	jmp    801061ca <alltraps>

80106d5b <vector171>:
.globl vector171
vector171:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $171
80106d5d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106d62:	e9 63 f4 ff ff       	jmp    801061ca <alltraps>

80106d67 <vector172>:
.globl vector172
vector172:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $172
80106d69:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106d6e:	e9 57 f4 ff ff       	jmp    801061ca <alltraps>

80106d73 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $173
80106d75:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d7a:	e9 4b f4 ff ff       	jmp    801061ca <alltraps>

80106d7f <vector174>:
.globl vector174
vector174:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $174
80106d81:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d86:	e9 3f f4 ff ff       	jmp    801061ca <alltraps>

80106d8b <vector175>:
.globl vector175
vector175:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $175
80106d8d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d92:	e9 33 f4 ff ff       	jmp    801061ca <alltraps>

80106d97 <vector176>:
.globl vector176
vector176:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $176
80106d99:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d9e:	e9 27 f4 ff ff       	jmp    801061ca <alltraps>

80106da3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $177
80106da5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106daa:	e9 1b f4 ff ff       	jmp    801061ca <alltraps>

80106daf <vector178>:
.globl vector178
vector178:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $178
80106db1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106db6:	e9 0f f4 ff ff       	jmp    801061ca <alltraps>

80106dbb <vector179>:
.globl vector179
vector179:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $179
80106dbd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106dc2:	e9 03 f4 ff ff       	jmp    801061ca <alltraps>

80106dc7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $180
80106dc9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106dce:	e9 f7 f3 ff ff       	jmp    801061ca <alltraps>

80106dd3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $181
80106dd5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106dda:	e9 eb f3 ff ff       	jmp    801061ca <alltraps>

80106ddf <vector182>:
.globl vector182
vector182:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $182
80106de1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106de6:	e9 df f3 ff ff       	jmp    801061ca <alltraps>

80106deb <vector183>:
.globl vector183
vector183:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $183
80106ded:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106df2:	e9 d3 f3 ff ff       	jmp    801061ca <alltraps>

80106df7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $184
80106df9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106dfe:	e9 c7 f3 ff ff       	jmp    801061ca <alltraps>

80106e03 <vector185>:
.globl vector185
vector185:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $185
80106e05:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106e0a:	e9 bb f3 ff ff       	jmp    801061ca <alltraps>

80106e0f <vector186>:
.globl vector186
vector186:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $186
80106e11:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106e16:	e9 af f3 ff ff       	jmp    801061ca <alltraps>

80106e1b <vector187>:
.globl vector187
vector187:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $187
80106e1d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106e22:	e9 a3 f3 ff ff       	jmp    801061ca <alltraps>

80106e27 <vector188>:
.globl vector188
vector188:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $188
80106e29:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106e2e:	e9 97 f3 ff ff       	jmp    801061ca <alltraps>

80106e33 <vector189>:
.globl vector189
vector189:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $189
80106e35:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106e3a:	e9 8b f3 ff ff       	jmp    801061ca <alltraps>

80106e3f <vector190>:
.globl vector190
vector190:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $190
80106e41:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106e46:	e9 7f f3 ff ff       	jmp    801061ca <alltraps>

80106e4b <vector191>:
.globl vector191
vector191:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $191
80106e4d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106e52:	e9 73 f3 ff ff       	jmp    801061ca <alltraps>

80106e57 <vector192>:
.globl vector192
vector192:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $192
80106e59:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106e5e:	e9 67 f3 ff ff       	jmp    801061ca <alltraps>

80106e63 <vector193>:
.globl vector193
vector193:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $193
80106e65:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106e6a:	e9 5b f3 ff ff       	jmp    801061ca <alltraps>

80106e6f <vector194>:
.globl vector194
vector194:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $194
80106e71:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e76:	e9 4f f3 ff ff       	jmp    801061ca <alltraps>

80106e7b <vector195>:
.globl vector195
vector195:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $195
80106e7d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e82:	e9 43 f3 ff ff       	jmp    801061ca <alltraps>

80106e87 <vector196>:
.globl vector196
vector196:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $196
80106e89:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e8e:	e9 37 f3 ff ff       	jmp    801061ca <alltraps>

80106e93 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $197
80106e95:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e9a:	e9 2b f3 ff ff       	jmp    801061ca <alltraps>

80106e9f <vector198>:
.globl vector198
vector198:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $198
80106ea1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106ea6:	e9 1f f3 ff ff       	jmp    801061ca <alltraps>

80106eab <vector199>:
.globl vector199
vector199:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $199
80106ead:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106eb2:	e9 13 f3 ff ff       	jmp    801061ca <alltraps>

80106eb7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $200
80106eb9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106ebe:	e9 07 f3 ff ff       	jmp    801061ca <alltraps>

80106ec3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $201
80106ec5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106eca:	e9 fb f2 ff ff       	jmp    801061ca <alltraps>

80106ecf <vector202>:
.globl vector202
vector202:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $202
80106ed1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106ed6:	e9 ef f2 ff ff       	jmp    801061ca <alltraps>

80106edb <vector203>:
.globl vector203
vector203:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $203
80106edd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106ee2:	e9 e3 f2 ff ff       	jmp    801061ca <alltraps>

80106ee7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $204
80106ee9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106eee:	e9 d7 f2 ff ff       	jmp    801061ca <alltraps>

80106ef3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $205
80106ef5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106efa:	e9 cb f2 ff ff       	jmp    801061ca <alltraps>

80106eff <vector206>:
.globl vector206
vector206:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $206
80106f01:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f06:	e9 bf f2 ff ff       	jmp    801061ca <alltraps>

80106f0b <vector207>:
.globl vector207
vector207:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $207
80106f0d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106f12:	e9 b3 f2 ff ff       	jmp    801061ca <alltraps>

80106f17 <vector208>:
.globl vector208
vector208:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $208
80106f19:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106f1e:	e9 a7 f2 ff ff       	jmp    801061ca <alltraps>

80106f23 <vector209>:
.globl vector209
vector209:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $209
80106f25:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106f2a:	e9 9b f2 ff ff       	jmp    801061ca <alltraps>

80106f2f <vector210>:
.globl vector210
vector210:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $210
80106f31:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106f36:	e9 8f f2 ff ff       	jmp    801061ca <alltraps>

80106f3b <vector211>:
.globl vector211
vector211:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $211
80106f3d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106f42:	e9 83 f2 ff ff       	jmp    801061ca <alltraps>

80106f47 <vector212>:
.globl vector212
vector212:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $212
80106f49:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106f4e:	e9 77 f2 ff ff       	jmp    801061ca <alltraps>

80106f53 <vector213>:
.globl vector213
vector213:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $213
80106f55:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106f5a:	e9 6b f2 ff ff       	jmp    801061ca <alltraps>

80106f5f <vector214>:
.globl vector214
vector214:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $214
80106f61:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106f66:	e9 5f f2 ff ff       	jmp    801061ca <alltraps>

80106f6b <vector215>:
.globl vector215
vector215:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $215
80106f6d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f72:	e9 53 f2 ff ff       	jmp    801061ca <alltraps>

80106f77 <vector216>:
.globl vector216
vector216:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $216
80106f79:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f7e:	e9 47 f2 ff ff       	jmp    801061ca <alltraps>

80106f83 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $217
80106f85:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f8a:	e9 3b f2 ff ff       	jmp    801061ca <alltraps>

80106f8f <vector218>:
.globl vector218
vector218:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $218
80106f91:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f96:	e9 2f f2 ff ff       	jmp    801061ca <alltraps>

80106f9b <vector219>:
.globl vector219
vector219:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $219
80106f9d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106fa2:	e9 23 f2 ff ff       	jmp    801061ca <alltraps>

80106fa7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $220
80106fa9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106fae:	e9 17 f2 ff ff       	jmp    801061ca <alltraps>

80106fb3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $221
80106fb5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106fba:	e9 0b f2 ff ff       	jmp    801061ca <alltraps>

80106fbf <vector222>:
.globl vector222
vector222:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $222
80106fc1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106fc6:	e9 ff f1 ff ff       	jmp    801061ca <alltraps>

80106fcb <vector223>:
.globl vector223
vector223:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $223
80106fcd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106fd2:	e9 f3 f1 ff ff       	jmp    801061ca <alltraps>

80106fd7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $224
80106fd9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106fde:	e9 e7 f1 ff ff       	jmp    801061ca <alltraps>

80106fe3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $225
80106fe5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106fea:	e9 db f1 ff ff       	jmp    801061ca <alltraps>

80106fef <vector226>:
.globl vector226
vector226:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $226
80106ff1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ff6:	e9 cf f1 ff ff       	jmp    801061ca <alltraps>

80106ffb <vector227>:
.globl vector227
vector227:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $227
80106ffd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107002:	e9 c3 f1 ff ff       	jmp    801061ca <alltraps>

80107007 <vector228>:
.globl vector228
vector228:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $228
80107009:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010700e:	e9 b7 f1 ff ff       	jmp    801061ca <alltraps>

80107013 <vector229>:
.globl vector229
vector229:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $229
80107015:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010701a:	e9 ab f1 ff ff       	jmp    801061ca <alltraps>

8010701f <vector230>:
.globl vector230
vector230:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $230
80107021:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107026:	e9 9f f1 ff ff       	jmp    801061ca <alltraps>

8010702b <vector231>:
.globl vector231
vector231:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $231
8010702d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107032:	e9 93 f1 ff ff       	jmp    801061ca <alltraps>

80107037 <vector232>:
.globl vector232
vector232:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $232
80107039:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010703e:	e9 87 f1 ff ff       	jmp    801061ca <alltraps>

80107043 <vector233>:
.globl vector233
vector233:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $233
80107045:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010704a:	e9 7b f1 ff ff       	jmp    801061ca <alltraps>

8010704f <vector234>:
.globl vector234
vector234:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $234
80107051:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107056:	e9 6f f1 ff ff       	jmp    801061ca <alltraps>

8010705b <vector235>:
.globl vector235
vector235:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $235
8010705d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107062:	e9 63 f1 ff ff       	jmp    801061ca <alltraps>

80107067 <vector236>:
.globl vector236
vector236:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $236
80107069:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010706e:	e9 57 f1 ff ff       	jmp    801061ca <alltraps>

80107073 <vector237>:
.globl vector237
vector237:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $237
80107075:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010707a:	e9 4b f1 ff ff       	jmp    801061ca <alltraps>

8010707f <vector238>:
.globl vector238
vector238:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $238
80107081:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107086:	e9 3f f1 ff ff       	jmp    801061ca <alltraps>

8010708b <vector239>:
.globl vector239
vector239:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $239
8010708d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107092:	e9 33 f1 ff ff       	jmp    801061ca <alltraps>

80107097 <vector240>:
.globl vector240
vector240:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $240
80107099:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010709e:	e9 27 f1 ff ff       	jmp    801061ca <alltraps>

801070a3 <vector241>:
.globl vector241
vector241:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $241
801070a5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801070aa:	e9 1b f1 ff ff       	jmp    801061ca <alltraps>

801070af <vector242>:
.globl vector242
vector242:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $242
801070b1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801070b6:	e9 0f f1 ff ff       	jmp    801061ca <alltraps>

801070bb <vector243>:
.globl vector243
vector243:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $243
801070bd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801070c2:	e9 03 f1 ff ff       	jmp    801061ca <alltraps>

801070c7 <vector244>:
.globl vector244
vector244:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $244
801070c9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801070ce:	e9 f7 f0 ff ff       	jmp    801061ca <alltraps>

801070d3 <vector245>:
.globl vector245
vector245:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $245
801070d5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801070da:	e9 eb f0 ff ff       	jmp    801061ca <alltraps>

801070df <vector246>:
.globl vector246
vector246:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $246
801070e1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801070e6:	e9 df f0 ff ff       	jmp    801061ca <alltraps>

801070eb <vector247>:
.globl vector247
vector247:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $247
801070ed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801070f2:	e9 d3 f0 ff ff       	jmp    801061ca <alltraps>

801070f7 <vector248>:
.globl vector248
vector248:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $248
801070f9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801070fe:	e9 c7 f0 ff ff       	jmp    801061ca <alltraps>

80107103 <vector249>:
.globl vector249
vector249:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $249
80107105:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010710a:	e9 bb f0 ff ff       	jmp    801061ca <alltraps>

8010710f <vector250>:
.globl vector250
vector250:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $250
80107111:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107116:	e9 af f0 ff ff       	jmp    801061ca <alltraps>

8010711b <vector251>:
.globl vector251
vector251:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $251
8010711d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107122:	e9 a3 f0 ff ff       	jmp    801061ca <alltraps>

80107127 <vector252>:
.globl vector252
vector252:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $252
80107129:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010712e:	e9 97 f0 ff ff       	jmp    801061ca <alltraps>

80107133 <vector253>:
.globl vector253
vector253:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $253
80107135:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010713a:	e9 8b f0 ff ff       	jmp    801061ca <alltraps>

8010713f <vector254>:
.globl vector254
vector254:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $254
80107141:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107146:	e9 7f f0 ff ff       	jmp    801061ca <alltraps>

8010714b <vector255>:
.globl vector255
vector255:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $255
8010714d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107152:	e9 73 f0 ff ff       	jmp    801061ca <alltraps>
80107157:	66 90                	xchg   %ax,%ax
80107159:	66 90                	xchg   %ax,%ax
8010715b:	66 90                	xchg   %ax,%ax
8010715d:	66 90                	xchg   %ax,%ax
8010715f:	90                   	nop

80107160 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107167:	c1 ea 16             	shr    $0x16,%edx
{
8010716a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010716b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010716e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107171:	8b 07                	mov    (%edi),%eax
80107173:	a8 01                	test   $0x1,%al
80107175:	74 29                	je     801071a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107177:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010717c:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107182:	c1 ee 0a             	shr    $0xa,%esi
}
80107185:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107188:	89 f2                	mov    %esi,%edx
8010718a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107190:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107193:	5b                   	pop    %ebx
80107194:	5e                   	pop    %esi
80107195:	5f                   	pop    %edi
80107196:	5d                   	pop    %ebp
80107197:	c3                   	ret    
80107198:	90                   	nop
80107199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801071a0:	85 c9                	test   %ecx,%ecx
801071a2:	74 2c                	je     801071d0 <walkpgdir+0x70>
801071a4:	e8 37 b9 ff ff       	call   80102ae0 <kalloc>
801071a9:	89 c3                	mov    %eax,%ebx
801071ab:	85 c0                	test   %eax,%eax
801071ad:	74 21                	je     801071d0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801071af:	83 ec 04             	sub    $0x4,%esp
801071b2:	68 00 10 00 00       	push   $0x1000
801071b7:	6a 00                	push   $0x0
801071b9:	50                   	push   %eax
801071ba:	e8 f1 db ff ff       	call   80104db0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801071bf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071c5:	83 c4 10             	add    $0x10,%esp
801071c8:	83 c8 07             	or     $0x7,%eax
801071cb:	89 07                	mov    %eax,(%edi)
801071cd:	eb b3                	jmp    80107182 <walkpgdir+0x22>
801071cf:	90                   	nop
}
801071d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801071d3:	31 c0                	xor    %eax,%eax
}
801071d5:	5b                   	pop    %ebx
801071d6:	5e                   	pop    %esi
801071d7:	5f                   	pop    %edi
801071d8:	5d                   	pop    %ebp
801071d9:	c3                   	ret    
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	57                   	push   %edi
801071e4:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801071e5:	89 d6                	mov    %edx,%esi
{
801071e7:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801071e8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801071ee:	83 ec 1c             	sub    $0x1c,%esp
801071f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071f4:	8b 7d 08             	mov    0x8(%ebp),%edi
801071f7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801071fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107200:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107203:	29 f7                	sub    %esi,%edi
80107205:	eb 21                	jmp    80107228 <mappages+0x48>
80107207:	89 f6                	mov    %esi,%esi
80107209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107210:	f6 00 01             	testb  $0x1,(%eax)
80107213:	75 45                	jne    8010725a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107215:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107218:	83 cb 01             	or     $0x1,%ebx
8010721b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010721d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107220:	74 2e                	je     80107250 <mappages+0x70>
      break;
    a += PGSIZE;
80107222:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107228:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010722b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107230:	89 f2                	mov    %esi,%edx
80107232:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80107235:	e8 26 ff ff ff       	call   80107160 <walkpgdir>
8010723a:	85 c0                	test   %eax,%eax
8010723c:	75 d2                	jne    80107210 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010723e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107246:	5b                   	pop    %ebx
80107247:	5e                   	pop    %esi
80107248:	5f                   	pop    %edi
80107249:	5d                   	pop    %ebp
8010724a:	c3                   	ret    
8010724b:	90                   	nop
8010724c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107253:	31 c0                	xor    %eax,%eax
}
80107255:	5b                   	pop    %ebx
80107256:	5e                   	pop    %esi
80107257:	5f                   	pop    %edi
80107258:	5d                   	pop    %ebp
80107259:	c3                   	ret    
      panic("remap");
8010725a:	83 ec 0c             	sub    $0xc,%esp
8010725d:	68 8c 84 10 80       	push   $0x8010848c
80107262:	e8 29 91 ff ff       	call   80100390 <panic>
80107267:	89 f6                	mov    %esi,%esi
80107269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107270 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	89 c7                	mov    %eax,%edi
80107276:	56                   	push   %esi
80107277:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107278:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010727e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107284:	83 ec 1c             	sub    $0x1c,%esp
80107287:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010728a:	39 d3                	cmp    %edx,%ebx
8010728c:	73 5a                	jae    801072e8 <deallocuvm.part.0+0x78>
8010728e:	89 d6                	mov    %edx,%esi
80107290:	eb 10                	jmp    801072a2 <deallocuvm.part.0+0x32>
80107292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107298:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010729e:	39 de                	cmp    %ebx,%esi
801072a0:	76 46                	jbe    801072e8 <deallocuvm.part.0+0x78>
    pte = walkpgdir(pgdir, (char*)a, 0);
801072a2:	31 c9                	xor    %ecx,%ecx
801072a4:	89 da                	mov    %ebx,%edx
801072a6:	89 f8                	mov    %edi,%eax
801072a8:	e8 b3 fe ff ff       	call   80107160 <walkpgdir>
    if(!pte)
801072ad:	85 c0                	test   %eax,%eax
801072af:	74 47                	je     801072f8 <deallocuvm.part.0+0x88>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801072b1:	8b 10                	mov    (%eax),%edx
801072b3:	f6 c2 01             	test   $0x1,%dl
801072b6:	74 e0                	je     80107298 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801072b8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801072be:	74 46                	je     80107306 <deallocuvm.part.0+0x96>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801072c0:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801072c3:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801072c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801072cc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072d2:	52                   	push   %edx
801072d3:	e8 48 b6 ff ff       	call   80102920 <kfree>
      *pte = 0;
801072d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072db:	83 c4 10             	add    $0x10,%esp
801072de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801072e4:	39 de                	cmp    %ebx,%esi
801072e6:	77 ba                	ja     801072a2 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
801072e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ee:	5b                   	pop    %ebx
801072ef:	5e                   	pop    %esi
801072f0:	5f                   	pop    %edi
801072f1:	5d                   	pop    %ebp
801072f2:	c3                   	ret    
801072f3:	90                   	nop
801072f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801072f8:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801072fe:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80107304:	eb 98                	jmp    8010729e <deallocuvm.part.0+0x2e>
        panic("kfree");
80107306:	83 ec 0c             	sub    $0xc,%esp
80107309:	68 0e 7e 10 80       	push   $0x80107e0e
8010730e:	e8 7d 90 ff ff       	call   80100390 <panic>
80107313:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107320 <seginit>:
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107326:	e8 35 cb ff ff       	call   80103e60 <cpuid>
  pd[0] = size-1;
8010732b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107330:	69 c0 b8 00 00 00    	imul   $0xb8,%eax,%eax
80107336:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010733a:	c7 80 78 c8 11 80 ff 	movl   $0xffff,-0x7fee3788(%eax)
80107341:	ff 00 00 
80107344:	c7 80 7c c8 11 80 00 	movl   $0xcf9a00,-0x7fee3784(%eax)
8010734b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010734e:	c7 80 80 c8 11 80 ff 	movl   $0xffff,-0x7fee3780(%eax)
80107355:	ff 00 00 
80107358:	c7 80 84 c8 11 80 00 	movl   $0xcf9200,-0x7fee377c(%eax)
8010735f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107362:	c7 80 88 c8 11 80 ff 	movl   $0xffff,-0x7fee3778(%eax)
80107369:	ff 00 00 
8010736c:	c7 80 8c c8 11 80 00 	movl   $0xcffa00,-0x7fee3774(%eax)
80107373:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107376:	c7 80 90 c8 11 80 ff 	movl   $0xffff,-0x7fee3770(%eax)
8010737d:	ff 00 00 
80107380:	c7 80 94 c8 11 80 00 	movl   $0xcff200,-0x7fee376c(%eax)
80107387:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010738a:	05 70 c8 11 80       	add    $0x8011c870,%eax
  pd[1] = (uint)p;
8010738f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107393:	c1 e8 10             	shr    $0x10,%eax
80107396:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010739a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010739d:	0f 01 10             	lgdtl  (%eax)
}
801073a0:	c9                   	leave  
801073a1:	c3                   	ret    
801073a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073b0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073b0:	a1 84 fc 11 80       	mov    0x8011fc84,%eax
801073b5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073ba:	0f 22 d8             	mov    %eax,%cr3
}
801073bd:	c3                   	ret    
801073be:	66 90                	xchg   %ax,%ax

801073c0 <switchuvm>:
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
801073c6:	83 ec 1c             	sub    $0x1c,%esp
801073c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801073cc:	85 db                	test   %ebx,%ebx
801073ce:	0f 84 cb 00 00 00    	je     8010749f <switchuvm+0xdf>
  if(p->kstack == 0)
801073d4:	8b 43 08             	mov    0x8(%ebx),%eax
801073d7:	85 c0                	test   %eax,%eax
801073d9:	0f 84 da 00 00 00    	je     801074b9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801073df:	8b 43 04             	mov    0x4(%ebx),%eax
801073e2:	85 c0                	test   %eax,%eax
801073e4:	0f 84 c2 00 00 00    	je     801074ac <switchuvm+0xec>
  pushcli();
801073ea:	e8 01 d8 ff ff       	call   80104bf0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801073ef:	e8 ec c9 ff ff       	call   80103de0 <mycpu>
801073f4:	89 c6                	mov    %eax,%esi
801073f6:	e8 e5 c9 ff ff       	call   80103de0 <mycpu>
801073fb:	89 c7                	mov    %eax,%edi
801073fd:	e8 de c9 ff ff       	call   80103de0 <mycpu>
80107402:	83 c7 08             	add    $0x8,%edi
80107405:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107408:	e8 d3 c9 ff ff       	call   80103de0 <mycpu>
8010740d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107410:	ba 67 00 00 00       	mov    $0x67,%edx
80107415:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
8010741c:	83 c0 08             	add    $0x8,%eax
8010741f:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107426:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010742b:	83 c1 08             	add    $0x8,%ecx
8010742e:	c1 e8 18             	shr    $0x18,%eax
80107431:	c1 e9 10             	shr    $0x10,%ecx
80107434:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
8010743a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107440:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107445:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010744c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107451:	e8 8a c9 ff ff       	call   80103de0 <mycpu>
80107456:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010745d:	e8 7e c9 ff ff       	call   80103de0 <mycpu>
80107462:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107466:	8b 73 08             	mov    0x8(%ebx),%esi
80107469:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010746f:	e8 6c c9 ff ff       	call   80103de0 <mycpu>
80107474:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107477:	e8 64 c9 ff ff       	call   80103de0 <mycpu>
8010747c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107480:	b8 28 00 00 00       	mov    $0x28,%eax
80107485:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107488:	8b 43 04             	mov    0x4(%ebx),%eax
8010748b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107490:	0f 22 d8             	mov    %eax,%cr3
}
80107493:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107496:	5b                   	pop    %ebx
80107497:	5e                   	pop    %esi
80107498:	5f                   	pop    %edi
80107499:	5d                   	pop    %ebp
  popcli();
8010749a:	e9 61 d8 ff ff       	jmp    80104d00 <popcli>
    panic("switchuvm: no process");
8010749f:	83 ec 0c             	sub    $0xc,%esp
801074a2:	68 92 84 10 80       	push   $0x80108492
801074a7:	e8 e4 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801074ac:	83 ec 0c             	sub    $0xc,%esp
801074af:	68 bd 84 10 80       	push   $0x801084bd
801074b4:	e8 d7 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801074b9:	83 ec 0c             	sub    $0xc,%esp
801074bc:	68 a8 84 10 80       	push   $0x801084a8
801074c1:	e8 ca 8e ff ff       	call   80100390 <panic>
801074c6:	8d 76 00             	lea    0x0(%esi),%esi
801074c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074d0 <inituvm>:
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	57                   	push   %edi
801074d4:	56                   	push   %esi
801074d5:	53                   	push   %ebx
801074d6:	83 ec 1c             	sub    $0x1c,%esp
801074d9:	8b 45 08             	mov    0x8(%ebp),%eax
801074dc:	8b 75 10             	mov    0x10(%ebp),%esi
801074df:	8b 7d 0c             	mov    0xc(%ebp),%edi
801074e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801074e5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801074eb:	77 49                	ja     80107536 <inituvm+0x66>
  mem = kalloc();
801074ed:	e8 ee b5 ff ff       	call   80102ae0 <kalloc>
  memset(mem, 0, PGSIZE);
801074f2:	83 ec 04             	sub    $0x4,%esp
801074f5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801074fa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801074fc:	6a 00                	push   $0x0
801074fe:	50                   	push   %eax
801074ff:	e8 ac d8 ff ff       	call   80104db0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107504:	58                   	pop    %eax
80107505:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010750b:	5a                   	pop    %edx
8010750c:	6a 06                	push   $0x6
8010750e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107513:	31 d2                	xor    %edx,%edx
80107515:	50                   	push   %eax
80107516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107519:	e8 c2 fc ff ff       	call   801071e0 <mappages>
  memmove(mem, init, sz);
8010751e:	89 75 10             	mov    %esi,0x10(%ebp)
80107521:	83 c4 10             	add    $0x10,%esp
80107524:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107527:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010752a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010752d:	5b                   	pop    %ebx
8010752e:	5e                   	pop    %esi
8010752f:	5f                   	pop    %edi
80107530:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107531:	e9 1a d9 ff ff       	jmp    80104e50 <memmove>
    panic("inituvm: more than a page");
80107536:	83 ec 0c             	sub    $0xc,%esp
80107539:	68 d1 84 10 80       	push   $0x801084d1
8010753e:	e8 4d 8e ff ff       	call   80100390 <panic>
80107543:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107550 <loaduvm>:
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	57                   	push   %edi
80107554:	56                   	push   %esi
80107555:	53                   	push   %ebx
80107556:	83 ec 1c             	sub    $0x1c,%esp
80107559:	8b 45 0c             	mov    0xc(%ebp),%eax
8010755c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010755f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107564:	0f 85 8d 00 00 00    	jne    801075f7 <loaduvm+0xa7>
8010756a:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
8010756c:	89 f3                	mov    %esi,%ebx
8010756e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107571:	8b 45 14             	mov    0x14(%ebp),%eax
80107574:	01 f0                	add    %esi,%eax
80107576:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107579:	85 f6                	test   %esi,%esi
8010757b:	75 11                	jne    8010758e <loaduvm+0x3e>
8010757d:	eb 61                	jmp    801075e0 <loaduvm+0x90>
8010757f:	90                   	nop
80107580:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107586:	89 f0                	mov    %esi,%eax
80107588:	29 d8                	sub    %ebx,%eax
8010758a:	39 c6                	cmp    %eax,%esi
8010758c:	76 52                	jbe    801075e0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010758e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107591:	8b 45 08             	mov    0x8(%ebp),%eax
80107594:	31 c9                	xor    %ecx,%ecx
80107596:	29 da                	sub    %ebx,%edx
80107598:	e8 c3 fb ff ff       	call   80107160 <walkpgdir>
8010759d:	85 c0                	test   %eax,%eax
8010759f:	74 49                	je     801075ea <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801075a1:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801075a6:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801075ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801075b0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801075b6:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075b9:	29 d9                	sub    %ebx,%ecx
801075bb:	05 00 00 00 80       	add    $0x80000000,%eax
801075c0:	57                   	push   %edi
801075c1:	51                   	push   %ecx
801075c2:	50                   	push   %eax
801075c3:	ff 75 10             	pushl  0x10(%ebp)
801075c6:	e8 65 a9 ff ff       	call   80101f30 <readi>
801075cb:	83 c4 10             	add    $0x10,%esp
801075ce:	39 f8                	cmp    %edi,%eax
801075d0:	74 ae                	je     80107580 <loaduvm+0x30>
}
801075d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075da:	5b                   	pop    %ebx
801075db:	5e                   	pop    %esi
801075dc:	5f                   	pop    %edi
801075dd:	5d                   	pop    %ebp
801075de:	c3                   	ret    
801075df:	90                   	nop
801075e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075e3:	31 c0                	xor    %eax,%eax
}
801075e5:	5b                   	pop    %ebx
801075e6:	5e                   	pop    %esi
801075e7:	5f                   	pop    %edi
801075e8:	5d                   	pop    %ebp
801075e9:	c3                   	ret    
      panic("loaduvm: address should exist");
801075ea:	83 ec 0c             	sub    $0xc,%esp
801075ed:	68 eb 84 10 80       	push   $0x801084eb
801075f2:	e8 99 8d ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801075f7:	83 ec 0c             	sub    $0xc,%esp
801075fa:	68 c0 85 10 80       	push   $0x801085c0
801075ff:	e8 8c 8d ff ff       	call   80100390 <panic>
80107604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010760a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107610 <sharevm>:
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	57                   	push   %edi
80107614:	56                   	push   %esi
80107615:	53                   	push   %ebx
80107616:	83 ec 1c             	sub    $0x1c,%esp
80107619:	8b 55 0c             	mov    0xc(%ebp),%edx
8010761c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(sharedmemo.recs[idx]>0){
8010761f:	8d 5a 08             	lea    0x8(%edx),%ebx
80107622:	8b 04 9d e8 b5 10 80 	mov    -0x7fef4a18(,%ebx,4),%eax
80107629:	85 c0                	test   %eax,%eax
8010762b:	74 43                	je     80107670 <sharevm+0x60>
    mem=sharedmemo.shared[idx];
8010762d:	8b 34 95 e0 b5 10 80 	mov    -0x7fef4a20(,%edx,4),%esi
  if(mappages(pgdir, (char*)(KERNBASE-(idx+1)*PGSIZE), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107634:	8d 42 01             	lea    0x1(%edx),%eax
80107637:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010763c:	83 ec 08             	sub    $0x8,%esp
8010763f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107644:	c1 e0 0c             	shl    $0xc,%eax
80107647:	6a 06                	push   $0x6
80107649:	29 c2                	sub    %eax,%edx
8010764b:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107651:	50                   	push   %eax
80107652:	89 f8                	mov    %edi,%eax
80107654:	e8 87 fb ff ff       	call   801071e0 <mappages>
80107659:	83 c4 10             	add    $0x10,%esp
8010765c:	85 c0                	test   %eax,%eax
8010765e:	78 48                	js     801076a8 <sharevm+0x98>
  sharedmemo.recs[idx]++;
80107660:	83 04 9d e8 b5 10 80 	addl   $0x1,-0x7fef4a18(,%ebx,4)
80107667:	01 
}
80107668:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010766b:	5b                   	pop    %ebx
8010766c:	5e                   	pop    %esi
8010766d:	5f                   	pop    %edi
8010766e:	5d                   	pop    %ebp
8010766f:	c3                   	ret    
80107670:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    mem = kalloc();
80107673:	e8 68 b4 ff ff       	call   80102ae0 <kalloc>
    if(mem == 0){
80107678:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010767b:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010767d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010767f:	74 4f                	je     801076d0 <sharevm+0xc0>
    memset(mem, 0, PGSIZE);
80107681:	83 ec 04             	sub    $0x4,%esp
80107684:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107687:	68 00 10 00 00       	push   $0x1000
8010768c:	6a 00                	push   $0x0
8010768e:	50                   	push   %eax
8010768f:	e8 1c d7 ff ff       	call   80104db0 <memset>
    sharedmemo.shared[idx]=mem;
80107694:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107697:	83 c4 10             	add    $0x10,%esp
8010769a:	89 34 95 e0 b5 10 80 	mov    %esi,-0x7fef4a20(,%edx,4)
801076a1:	eb 91                	jmp    80107634 <sharevm+0x24>
801076a3:	90                   	nop
801076a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("sharevm out of memory (2)\n");
801076a8:	83 ec 0c             	sub    $0xc,%esp
801076ab:	68 20 85 10 80       	push   $0x80108520
801076b0:	e8 eb 8f ff ff       	call   801006a0 <cprintf>
    kfree(mem);
801076b5:	89 75 08             	mov    %esi,0x8(%ebp)
801076b8:	83 c4 10             	add    $0x10,%esp
}
801076bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076be:	5b                   	pop    %ebx
801076bf:	5e                   	pop    %esi
801076c0:	5f                   	pop    %edi
801076c1:	5d                   	pop    %ebp
    kfree(mem);
801076c2:	e9 59 b2 ff ff       	jmp    80102920 <kfree>
801076c7:	89 f6                	mov    %esi,%esi
801076c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      cprintf("sharevm out of memory\n");
801076d0:	c7 45 08 09 85 10 80 	movl   $0x80108509,0x8(%ebp)
}
801076d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076da:	5b                   	pop    %ebx
801076db:	5e                   	pop    %esi
801076dc:	5f                   	pop    %edi
801076dd:	5d                   	pop    %ebp
      cprintf("sharevm out of memory\n");
801076de:	e9 bd 8f ff ff       	jmp    801006a0 <cprintf>
801076e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076f0 <allocuvm>:
{
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	57                   	push   %edi
801076f4:	56                   	push   %esi
801076f5:	53                   	push   %ebx
801076f6:	83 ec 0c             	sub    $0xc,%esp
  if(newsz >= KERNBASE-MAXSHAREDPG*PGSIZE)
801076f9:	81 7d 10 ff 5f ff 7f 	cmpl   $0x7fff5fff,0x10(%ebp)
80107700:	0f 87 aa 00 00 00    	ja     801077b0 <allocuvm+0xc0>
  if(newsz < oldsz)
80107706:	8b 45 0c             	mov    0xc(%ebp),%eax
80107709:	39 45 10             	cmp    %eax,0x10(%ebp)
8010770c:	0f 82 a0 00 00 00    	jb     801077b2 <allocuvm+0xc2>
  a = PGROUNDUP(oldsz);
80107712:	8b 45 0c             	mov    0xc(%ebp),%eax
80107715:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010771b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107721:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107724:	0f 86 96 00 00 00    	jbe    801077c0 <allocuvm+0xd0>
8010772a:	8b 45 10             	mov    0x10(%ebp),%eax
8010772d:	83 e8 01             	sub    $0x1,%eax
80107730:	29 d8                	sub    %ebx,%eax
80107732:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107737:	8d bc 03 00 10 00 00 	lea    0x1000(%ebx,%eax,1),%edi
8010773e:	eb 3b                	jmp    8010777b <allocuvm+0x8b>
    memset(mem, 0, PGSIZE);
80107740:	83 ec 04             	sub    $0x4,%esp
80107743:	68 00 10 00 00       	push   $0x1000
80107748:	6a 00                	push   $0x0
8010774a:	50                   	push   %eax
8010774b:	e8 60 d6 ff ff       	call   80104db0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107750:	58                   	pop    %eax
80107751:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107757:	5a                   	pop    %edx
80107758:	6a 06                	push   $0x6
8010775a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010775f:	89 da                	mov    %ebx,%edx
80107761:	50                   	push   %eax
80107762:	8b 45 08             	mov    0x8(%ebp),%eax
80107765:	e8 76 fa ff ff       	call   801071e0 <mappages>
8010776a:	83 c4 10             	add    $0x10,%esp
8010776d:	85 c0                	test   %eax,%eax
8010776f:	78 5f                	js     801077d0 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80107771:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107777:	39 fb                	cmp    %edi,%ebx
80107779:	74 45                	je     801077c0 <allocuvm+0xd0>
    mem = kalloc();
8010777b:	e8 60 b3 ff ff       	call   80102ae0 <kalloc>
80107780:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107782:	85 c0                	test   %eax,%eax
80107784:	75 ba                	jne    80107740 <allocuvm+0x50>
      cprintf("allocuvm out of memory\n");
80107786:	83 ec 0c             	sub    $0xc,%esp
80107789:	68 3b 85 10 80       	push   $0x8010853b
8010778e:	e8 0d 8f ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107793:	83 c4 10             	add    $0x10,%esp
80107796:	8b 45 0c             	mov    0xc(%ebp),%eax
80107799:	39 45 10             	cmp    %eax,0x10(%ebp)
8010779c:	74 12                	je     801077b0 <allocuvm+0xc0>
8010779e:	89 c1                	mov    %eax,%ecx
801077a0:	8b 55 10             	mov    0x10(%ebp),%edx
801077a3:	8b 45 08             	mov    0x8(%ebp),%eax
801077a6:	e8 c5 fa ff ff       	call   80107270 <deallocuvm.part.0>
801077ab:	90                   	nop
801077ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
801077b0:	31 c0                	xor    %eax,%eax
}
801077b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077b5:	5b                   	pop    %ebx
801077b6:	5e                   	pop    %esi
801077b7:	5f                   	pop    %edi
801077b8:	5d                   	pop    %ebp
801077b9:	c3                   	ret    
801077ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return newsz;
801077c0:	8b 45 10             	mov    0x10(%ebp),%eax
}
801077c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077c6:	5b                   	pop    %ebx
801077c7:	5e                   	pop    %esi
801077c8:	5f                   	pop    %edi
801077c9:	5d                   	pop    %ebp
801077ca:	c3                   	ret    
801077cb:	90                   	nop
801077cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
801077d0:	83 ec 0c             	sub    $0xc,%esp
801077d3:	68 53 85 10 80       	push   $0x80108553
801077d8:	e8 c3 8e ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801077dd:	83 c4 10             	add    $0x10,%esp
801077e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801077e3:	39 45 10             	cmp    %eax,0x10(%ebp)
801077e6:	74 0d                	je     801077f5 <allocuvm+0x105>
801077e8:	89 c1                	mov    %eax,%ecx
801077ea:	8b 55 10             	mov    0x10(%ebp),%edx
801077ed:	8b 45 08             	mov    0x8(%ebp),%eax
801077f0:	e8 7b fa ff ff       	call   80107270 <deallocuvm.part.0>
      kfree(mem);
801077f5:	83 ec 0c             	sub    $0xc,%esp
801077f8:	56                   	push   %esi
801077f9:	e8 22 b1 ff ff       	call   80102920 <kfree>
      return 0;
801077fe:	83 c4 10             	add    $0x10,%esp
}
80107801:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107804:	31 c0                	xor    %eax,%eax
}
80107806:	5b                   	pop    %ebx
80107807:	5e                   	pop    %esi
80107808:	5f                   	pop    %edi
80107809:	5d                   	pop    %ebp
8010780a:	c3                   	ret    
8010780b:	90                   	nop
8010780c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107810 <deallocuvm>:
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	8b 55 0c             	mov    0xc(%ebp),%edx
80107816:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107819:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010781c:	39 d1                	cmp    %edx,%ecx
8010781e:	73 10                	jae    80107830 <deallocuvm+0x20>
}
80107820:	5d                   	pop    %ebp
80107821:	e9 4a fa ff ff       	jmp    80107270 <deallocuvm.part.0>
80107826:	8d 76 00             	lea    0x0(%esi),%esi
80107829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107830:	89 d0                	mov    %edx,%eax
80107832:	5d                   	pop    %ebp
80107833:	c3                   	ret    
80107834:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010783a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107840 <desharevm>:

void
desharevm(int idx)
{
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(sharedmemo.recs[idx]<=0)
80107846:	8d 51 08             	lea    0x8(%ecx),%edx
80107849:	8b 04 95 e8 b5 10 80 	mov    -0x7fef4a18(,%edx,4),%eax
80107850:	85 c0                	test   %eax,%eax
80107852:	74 0c                	je     80107860 <desharevm+0x20>
    return;

  sharedmemo.recs[idx]--;
80107854:	83 e8 01             	sub    $0x1,%eax
80107857:	89 04 95 e8 b5 10 80 	mov    %eax,-0x7fef4a18(,%edx,4)
  if(sharedmemo.recs[idx]<=0){
8010785e:	74 08                	je     80107868 <desharevm+0x28>
    kfree(sharedmemo.shared[idx]);
  }
}
80107860:	5d                   	pop    %ebp
80107861:	c3                   	ret    
80107862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kfree(sharedmemo.shared[idx]);
80107868:	8b 04 8d e0 b5 10 80 	mov    -0x7fef4a20(,%ecx,4),%eax
8010786f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80107872:	5d                   	pop    %ebp
    kfree(sharedmemo.shared[idx]);
80107873:	e9 a8 b0 ff ff       	jmp    80102920 <kfree>
80107878:	90                   	nop
80107879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107880 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
80107886:	83 ec 0c             	sub    $0xc,%esp
80107889:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010788c:	85 f6                	test   %esi,%esi
8010788e:	74 59                	je     801078e9 <freevm+0x69>
  if(newsz >= oldsz)
80107890:	31 c9                	xor    %ecx,%ecx
80107892:	ba 00 60 ff 7f       	mov    $0x7fff6000,%edx
80107897:	89 f0                	mov    %esi,%eax
80107899:	89 f3                	mov    %esi,%ebx
8010789b:	e8 d0 f9 ff ff       	call   80107270 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE-MAXSHAREDPG*PGSIZE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801078a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801078a6:	eb 0f                	jmp    801078b7 <freevm+0x37>
801078a8:	90                   	nop
801078a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078b0:	83 c3 04             	add    $0x4,%ebx
801078b3:	39 df                	cmp    %ebx,%edi
801078b5:	74 23                	je     801078da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801078b7:	8b 03                	mov    (%ebx),%eax
801078b9:	a8 01                	test   $0x1,%al
801078bb:	74 f3                	je     801078b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801078c2:	83 ec 0c             	sub    $0xc,%esp
801078c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801078cd:	50                   	push   %eax
801078ce:	e8 4d b0 ff ff       	call   80102920 <kfree>
801078d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801078d6:	39 df                	cmp    %ebx,%edi
801078d8:	75 dd                	jne    801078b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801078da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801078dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078e0:	5b                   	pop    %ebx
801078e1:	5e                   	pop    %esi
801078e2:	5f                   	pop    %edi
801078e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801078e4:	e9 37 b0 ff ff       	jmp    80102920 <kfree>
    panic("freevm: no pgdir");
801078e9:	83 ec 0c             	sub    $0xc,%esp
801078ec:	68 6f 85 10 80       	push   $0x8010856f
801078f1:	e8 9a 8a ff ff       	call   80100390 <panic>
801078f6:	8d 76 00             	lea    0x0(%esi),%esi
801078f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107900 <setupkvm>:
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	56                   	push   %esi
80107904:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107905:	e8 d6 b1 ff ff       	call   80102ae0 <kalloc>
8010790a:	89 c6                	mov    %eax,%esi
8010790c:	85 c0                	test   %eax,%eax
8010790e:	74 42                	je     80107952 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107910:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107913:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107918:	68 00 10 00 00       	push   $0x1000
8010791d:	6a 00                	push   $0x0
8010791f:	50                   	push   %eax
80107920:	e8 8b d4 ff ff       	call   80104db0 <memset>
80107925:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107928:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010792b:	83 ec 08             	sub    $0x8,%esp
8010792e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107931:	ff 73 0c             	pushl  0xc(%ebx)
80107934:	8b 13                	mov    (%ebx),%edx
80107936:	50                   	push   %eax
80107937:	29 c1                	sub    %eax,%ecx
80107939:	89 f0                	mov    %esi,%eax
8010793b:	e8 a0 f8 ff ff       	call   801071e0 <mappages>
80107940:	83 c4 10             	add    $0x10,%esp
80107943:	85 c0                	test   %eax,%eax
80107945:	78 19                	js     80107960 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107947:	83 c3 10             	add    $0x10,%ebx
8010794a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107950:	75 d6                	jne    80107928 <setupkvm+0x28>
}
80107952:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107955:	89 f0                	mov    %esi,%eax
80107957:	5b                   	pop    %ebx
80107958:	5e                   	pop    %esi
80107959:	5d                   	pop    %ebp
8010795a:	c3                   	ret    
8010795b:	90                   	nop
8010795c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107960:	83 ec 0c             	sub    $0xc,%esp
80107963:	56                   	push   %esi
      return 0;
80107964:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107966:	e8 15 ff ff ff       	call   80107880 <freevm>
      return 0;
8010796b:	83 c4 10             	add    $0x10,%esp
}
8010796e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107971:	89 f0                	mov    %esi,%eax
80107973:	5b                   	pop    %ebx
80107974:	5e                   	pop    %esi
80107975:	5d                   	pop    %ebp
80107976:	c3                   	ret    
80107977:	89 f6                	mov    %esi,%esi
80107979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107980 <kvmalloc>:
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107986:	e8 75 ff ff ff       	call   80107900 <setupkvm>
8010798b:	a3 84 fc 11 80       	mov    %eax,0x8011fc84
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107990:	05 00 00 00 80       	add    $0x80000000,%eax
80107995:	0f 22 d8             	mov    %eax,%cr3
}
80107998:	c9                   	leave  
80107999:	c3                   	ret    
8010799a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801079a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801079a1:	31 c9                	xor    %ecx,%ecx
{
801079a3:	89 e5                	mov    %esp,%ebp
801079a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801079a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801079ab:	8b 45 08             	mov    0x8(%ebp),%eax
801079ae:	e8 ad f7 ff ff       	call   80107160 <walkpgdir>
  if(pte == 0)
801079b3:	85 c0                	test   %eax,%eax
801079b5:	74 05                	je     801079bc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801079b7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801079ba:	c9                   	leave  
801079bb:	c3                   	ret    
    panic("clearpteu");
801079bc:	83 ec 0c             	sub    $0xc,%esp
801079bf:	68 80 85 10 80       	push   $0x80108580
801079c4:	e8 c7 89 ff ff       	call   80100390 <panic>
801079c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801079d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	57                   	push   %edi
801079d4:	56                   	push   %esi
801079d5:	53                   	push   %ebx
801079d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801079d9:	e8 22 ff ff ff       	call   80107900 <setupkvm>
801079de:	89 45 e0             	mov    %eax,-0x20(%ebp)
801079e1:	85 c0                	test   %eax,%eax
801079e3:	0f 84 a0 00 00 00    	je     80107a89 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801079e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801079ec:	85 c9                	test   %ecx,%ecx
801079ee:	0f 84 95 00 00 00    	je     80107a89 <copyuvm+0xb9>
801079f4:	31 f6                	xor    %esi,%esi
801079f6:	eb 4e                	jmp    80107a46 <copyuvm+0x76>
801079f8:	90                   	nop
801079f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a00:	83 ec 04             	sub    $0x4,%esp
80107a03:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a0c:	68 00 10 00 00       	push   $0x1000
80107a11:	57                   	push   %edi
80107a12:	50                   	push   %eax
80107a13:	e8 38 d4 ff ff       	call   80104e50 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107a18:	58                   	pop    %eax
80107a19:	5a                   	pop    %edx
80107a1a:	53                   	push   %ebx
80107a1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a21:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a26:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107a2c:	52                   	push   %edx
80107a2d:	89 f2                	mov    %esi,%edx
80107a2f:	e8 ac f7 ff ff       	call   801071e0 <mappages>
80107a34:	83 c4 10             	add    $0x10,%esp
80107a37:	85 c0                	test   %eax,%eax
80107a39:	78 39                	js     80107a74 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80107a3b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a41:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a44:	76 43                	jbe    80107a89 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a46:	8b 45 08             	mov    0x8(%ebp),%eax
80107a49:	31 c9                	xor    %ecx,%ecx
80107a4b:	89 f2                	mov    %esi,%edx
80107a4d:	e8 0e f7 ff ff       	call   80107160 <walkpgdir>
80107a52:	85 c0                	test   %eax,%eax
80107a54:	74 3e                	je     80107a94 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107a56:	8b 18                	mov    (%eax),%ebx
80107a58:	f6 c3 01             	test   $0x1,%bl
80107a5b:	74 44                	je     80107aa1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80107a5d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80107a5f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107a65:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107a6b:	e8 70 b0 ff ff       	call   80102ae0 <kalloc>
80107a70:	85 c0                	test   %eax,%eax
80107a72:	75 8c                	jne    80107a00 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107a74:	83 ec 0c             	sub    $0xc,%esp
80107a77:	ff 75 e0             	pushl  -0x20(%ebp)
80107a7a:	e8 01 fe ff ff       	call   80107880 <freevm>
  return 0;
80107a7f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a86:	83 c4 10             	add    $0x10,%esp
}
80107a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a8f:	5b                   	pop    %ebx
80107a90:	5e                   	pop    %esi
80107a91:	5f                   	pop    %edi
80107a92:	5d                   	pop    %ebp
80107a93:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107a94:	83 ec 0c             	sub    $0xc,%esp
80107a97:	68 8a 85 10 80       	push   $0x8010858a
80107a9c:	e8 ef 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107aa1:	83 ec 0c             	sub    $0xc,%esp
80107aa4:	68 a4 85 10 80       	push   $0x801085a4
80107aa9:	e8 e2 88 ff ff       	call   80100390 <panic>
80107aae:	66 90                	xchg   %ax,%ax

80107ab0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107ab0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107ab1:	31 c9                	xor    %ecx,%ecx
{
80107ab3:	89 e5                	mov    %esp,%ebp
80107ab5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107abb:	8b 45 08             	mov    0x8(%ebp),%eax
80107abe:	e8 9d f6 ff ff       	call   80107160 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107ac3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107ac5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107ac6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ac8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107acd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ad0:	05 00 00 00 80       	add    $0x80000000,%eax
80107ad5:	83 fa 05             	cmp    $0x5,%edx
80107ad8:	ba 00 00 00 00       	mov    $0x0,%edx
80107add:	0f 45 c2             	cmovne %edx,%eax
}
80107ae0:	c3                   	ret    
80107ae1:	eb 0d                	jmp    80107af0 <copyout>
80107ae3:	90                   	nop
80107ae4:	90                   	nop
80107ae5:	90                   	nop
80107ae6:	90                   	nop
80107ae7:	90                   	nop
80107ae8:	90                   	nop
80107ae9:	90                   	nop
80107aea:	90                   	nop
80107aeb:	90                   	nop
80107aec:	90                   	nop
80107aed:	90                   	nop
80107aee:	90                   	nop
80107aef:	90                   	nop

80107af0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	57                   	push   %edi
80107af4:	56                   	push   %esi
80107af5:	53                   	push   %ebx
80107af6:	83 ec 0c             	sub    $0xc,%esp
80107af9:	8b 75 14             	mov    0x14(%ebp),%esi
80107afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107aff:	85 f6                	test   %esi,%esi
80107b01:	75 38                	jne    80107b3b <copyout+0x4b>
80107b03:	eb 6b                	jmp    80107b70 <copyout+0x80>
80107b05:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107b08:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b0b:	89 fb                	mov    %edi,%ebx
80107b0d:	29 d3                	sub    %edx,%ebx
80107b0f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107b15:	39 f3                	cmp    %esi,%ebx
80107b17:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b1a:	29 fa                	sub    %edi,%edx
80107b1c:	83 ec 04             	sub    $0x4,%esp
80107b1f:	01 c2                	add    %eax,%edx
80107b21:	53                   	push   %ebx
80107b22:	ff 75 10             	pushl  0x10(%ebp)
80107b25:	52                   	push   %edx
80107b26:	e8 25 d3 ff ff       	call   80104e50 <memmove>
    len -= n;
    buf += n;
80107b2b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b2e:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107b34:	83 c4 10             	add    $0x10,%esp
80107b37:	29 de                	sub    %ebx,%esi
80107b39:	74 35                	je     80107b70 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107b3b:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b3d:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107b40:	89 55 0c             	mov    %edx,0xc(%ebp)
80107b43:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b49:	57                   	push   %edi
80107b4a:	ff 75 08             	pushl  0x8(%ebp)
80107b4d:	e8 5e ff ff ff       	call   80107ab0 <uva2ka>
    if(pa0 == 0)
80107b52:	83 c4 10             	add    $0x10,%esp
80107b55:	85 c0                	test   %eax,%eax
80107b57:	75 af                	jne    80107b08 <copyout+0x18>
  }
  return 0;
}
80107b59:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b61:	5b                   	pop    %ebx
80107b62:	5e                   	pop    %esi
80107b63:	5f                   	pop    %edi
80107b64:	5d                   	pop    %ebp
80107b65:	c3                   	ret    
80107b66:	8d 76 00             	lea    0x0(%esi),%esi
80107b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b73:	31 c0                	xor    %eax,%eax
}
80107b75:	5b                   	pop    %ebx
80107b76:	5e                   	pop    %esi
80107b77:	5f                   	pop    %edi
80107b78:	5d                   	pop    %ebp
80107b79:	c3                   	ret    
