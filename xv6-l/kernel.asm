
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
80100028:	bc 10 c6 10 80       	mov    $0x8010c610,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 30 10 80       	mov    $0x801030e0,%eax
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
80100044:	bb 54 c6 10 80       	mov    $0x8010c654,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 75 10 80       	push   $0x801075e0
80100051:	68 20 c6 10 80       	push   $0x8010c620
80100056:	e8 65 46 00 00       	call   801046c0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 6c 0d 11 80 1c 	movl   $0x80110d1c,0x80110d6c
80100062:	0d 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 70 0d 11 80 1c 	movl   $0x80110d1c,0x80110d70
8010006c:	0d 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 1c 0d 11 80       	mov    $0x80110d1c,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c 0d 11 80 	movl   $0x80110d1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 75 10 80       	push   $0x801075e7
80100097:	50                   	push   %eax
80100098:	e8 13 45 00 00       	call   801045b0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0d 11 80       	mov    0x80110d70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 70 0d 11 80    	mov    %ebx,0x80110d70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 1c 0d 11 80       	cmp    $0x80110d1c,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
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
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 c6 10 80       	push   $0x8010c620
801000e4:	e8 c7 46 00 00       	call   801047b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0d 11 80    	mov    0x80110d70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c 0d 11 80    	mov    0x80110d6c,%ebx
80100126:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 c6 10 80       	push   $0x8010c620
80100162:	e8 69 47 00 00       	call   801048d0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 44 00 00       	call   801045f0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 dd 21 00 00       	call   80102360 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ee 75 10 80       	push   $0x801075ee
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 dd 44 00 00       	call   80104690 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 97 21 00 00       	jmp    80102360 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 75 10 80       	push   $0x801075ff
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 9c 44 00 00       	call   80104690 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 4c 44 00 00       	call   80104650 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010020b:	e8 a0 45 00 00       	call   801047b0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 70 0d 11 80       	mov    0x80110d70,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 1c 0d 11 80 	movl   $0x80110d1c,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 70 0d 11 80       	mov    0x80110d70,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 70 0d 11 80    	mov    %ebx,0x80110d70
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 20 c6 10 80 	movl   $0x8010c620,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 6f 46 00 00       	jmp    801048d0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 76 10 80       	push   $0x80107606
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:

}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 1b 17 00 00       	call   801019a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 1f 45 00 00       	call   801047b0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 00 10 11 80    	mov    0x80111000,%edx
801002a7:	39 15 04 10 11 80    	cmp    %edx,0x80111004
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 00 10 11 80       	push   $0x80111000
801002c5:	e8 96 3f 00 00       	call   80104260 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 00 10 11 80    	mov    0x80111000,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 04 10 11 80    	cmp    0x80111004,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 60 37 00 00       	call   80103a40 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 dc 45 00 00       	call   801048d0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 c4 15 00 00       	call   801018c0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 00 10 11 80       	mov    %eax,0x80111000
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 80 0f 11 80 	movsbl -0x7feef080(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 7e 45 00 00       	call   801048d0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 66 15 00 00       	call   801018c0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 00 10 11 80    	mov    %edx,0x80111000
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
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
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 c2 25 00 00       	call   80102970 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 76 10 80       	push   $0x8010760d
801003b7:	e8 24 03 00 00       	call   801006e0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 1b 03 00 00       	call   801006e0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 8b 7f 10 80 	movl   $0x80107f8b,(%esp)
801003cc:	e8 0f 03 00 00       	call   801006e0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 43 00 00       	call   801046e0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 76 10 80       	push   $0x80107621
801003ed:	e8 ee 02 00 00       	call   801006e0 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 eb 00 00 00    	je     80100521 <consputc+0x111>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 91 5c 00 00       	call   801060d0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 5a 01 00 00    	je     801005d2 <consputc+0x1c2>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 1c 01 00 00    	je     801005a0 <consputc+0x190>
      crt[pos] = (c&0xff) | 0x0b00;  // black on white
80100484:	89 f0                	mov    %esi,%eax
    if(c>='0'&&c<='9'){
80100486:	8d 4e d0             	lea    -0x30(%esi),%ecx
      crt[pos] = (c&0xff) | 0x0b00;  // black on white
80100489:	0f b6 c0             	movzbl %al,%eax
8010048c:	80 cc 05             	or     $0x5,%ah
8010048f:	89 c2                	mov    %eax,%edx
80100491:	89 f0                	mov    %esi,%eax
80100493:	80 cc 0b             	or     $0xb,%ah
80100496:	83 f9 0a             	cmp    $0xa,%ecx
    if(pos%80>window.left[wdi]+window.width[wdi])
80100499:	b9 50 00 00 00       	mov    $0x50,%ecx
      crt[pos] = (c&0xff) | 0x0b00;  // black on white
8010049e:	0f 43 c2             	cmovae %edx,%eax
801004a1:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004a8:	80 
    pos++;
801004a9:	83 c3 01             	add    $0x1,%ebx
    if(pos%80>window.left[wdi]+window.width[wdi])
801004ac:	8b 3d 0c 10 11 80    	mov    0x8011100c,%edi
801004b2:	89 d8                	mov    %ebx,%eax
801004b4:	99                   	cltd   
801004b5:	f7 f9                	idiv   %ecx
801004b7:	8b 34 bd 38 90 10 80 	mov    -0x7fef6fc8(,%edi,4),%esi
801004be:	8b 04 bd 10 90 10 80 	mov    -0x7fef6ff0(,%edi,4),%eax
801004c5:	01 f0                	add    %esi,%eax
801004c7:	39 c2                	cmp    %eax,%edx
801004c9:	0f 8f c8 00 00 00    	jg     80100597 <consputc+0x187>
  if(pos < 0 || pos > 25*80)
801004cf:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004d5:	89 de                	mov    %ebx,%esi
801004d7:	0f 87 ad 00 00 00    	ja     8010058a <consputc+0x17a>
  if((pos/80) >= 24){  // Scroll up.
801004dd:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004e3:	7f 66                	jg     8010054b <consputc+0x13b>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004e5:	bf d4 03 00 00       	mov    $0x3d4,%edi
801004ea:	b8 0e 00 00 00       	mov    $0xe,%eax
801004ef:	89 fa                	mov    %edi,%edx
801004f1:	ee                   	out    %al,(%dx)
801004f2:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004f7:	89 d8                	mov    %ebx,%eax
801004f9:	c1 f8 08             	sar    $0x8,%eax
801004fc:	89 ca                	mov    %ecx,%edx
801004fe:	ee                   	out    %al,(%dx)
801004ff:	b8 0f 00 00 00       	mov    $0xf,%eax
80100504:	89 fa                	mov    %edi,%edx
80100506:	ee                   	out    %al,(%dx)
80100507:	89 d8                	mov    %ebx,%eax
80100509:	89 ca                	mov    %ecx,%edx
8010050b:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010050c:	b8 20 07 00 00       	mov    $0x720,%eax
80100511:	66 89 84 36 00 80 0b 	mov    %ax,-0x7ff48000(%esi,%esi,1)
80100518:	80 
}
80100519:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010051c:	5b                   	pop    %ebx
8010051d:	5e                   	pop    %esi
8010051e:	5f                   	pop    %edi
8010051f:	5d                   	pop    %ebp
80100520:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100521:	83 ec 0c             	sub    $0xc,%esp
80100524:	6a 08                	push   $0x8
80100526:	e8 a5 5b 00 00       	call   801060d0 <uartputc>
8010052b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100532:	e8 99 5b 00 00       	call   801060d0 <uartputc>
80100537:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010053e:	e8 8d 5b 00 00       	call   801060d0 <uartputc>
80100543:	83 c4 10             	add    $0x10,%esp
80100546:	e9 f7 fe ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010054b:	52                   	push   %edx
8010054c:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100551:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100554:	68 a0 80 0b 80       	push   $0x800b80a0
80100559:	68 00 80 0b 80       	push   $0x800b8000
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010055e:	89 de                	mov    %ebx,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100560:	e8 7b 44 00 00       	call   801049e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100565:	b8 80 07 00 00       	mov    $0x780,%eax
8010056a:	83 c4 0c             	add    $0xc,%esp
8010056d:	29 d8                	sub    %ebx,%eax
8010056f:	01 c0                	add    %eax,%eax
80100571:	50                   	push   %eax
80100572:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100575:	6a 00                	push   $0x0
80100577:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
8010057c:	50                   	push   %eax
8010057d:	e8 ae 43 00 00       	call   80104930 <memset>
80100582:	83 c4 10             	add    $0x10,%esp
80100585:	e9 5b ff ff ff       	jmp    801004e5 <consputc+0xd5>
    panic("pos under/overflow");
8010058a:	83 ec 0c             	sub    $0xc,%esp
8010058d:	68 25 76 10 80       	push   $0x80107625
80100592:	e8 f9 fd ff ff       	call   80100390 <panic>
      pos+=80-window.width[wdi];
80100597:	29 f1                	sub    %esi,%ecx
80100599:	01 cb                	add    %ecx,%ebx
8010059b:	e9 2f ff ff ff       	jmp    801004cf <consputc+0xbf>
    if(pos > 0) {
801005a0:	85 db                	test   %ebx,%ebx
801005a2:	74 50                	je     801005f4 <consputc+0x1e4>
      --pos;
801005a4:	83 eb 01             	sub    $0x1,%ebx
      if(pos%80<window.left[wdi])
801005a7:	b9 50 00 00 00       	mov    $0x50,%ecx
801005ac:	8b 35 0c 10 11 80    	mov    0x8011100c,%esi
801005b2:	89 d8                	mov    %ebx,%eax
801005b4:	99                   	cltd   
801005b5:	f7 f9                	idiv   %ecx
801005b7:	3b 14 b5 10 90 10 80 	cmp    -0x7fef6ff0(,%esi,4),%edx
801005be:	0f 8d 0b ff ff ff    	jge    801004cf <consputc+0xbf>
        pos-=80-window.width[wdi];
801005c4:	2b 0c b5 38 90 10 80 	sub    -0x7fef6fc8(,%esi,4),%ecx
801005cb:	29 cb                	sub    %ecx,%ebx
801005cd:	e9 fd fe ff ff       	jmp    801004cf <consputc+0xbf>
    pos += 80 - pos%80+ window.left[wdi];
801005d2:	89 d8                	mov    %ebx,%eax
801005d4:	b9 50 00 00 00       	mov    $0x50,%ecx
801005d9:	99                   	cltd   
801005da:	f7 f9                	idiv   %ecx
801005dc:	89 c8                	mov    %ecx,%eax
801005de:	29 d0                	sub    %edx,%eax
801005e0:	8b 15 0c 10 11 80    	mov    0x8011100c,%edx
801005e6:	03 04 95 10 90 10 80 	add    -0x7fef6ff0(,%edx,4),%eax
801005ed:	01 c3                	add    %eax,%ebx
801005ef:	e9 db fe ff ff       	jmp    801004cf <consputc+0xbf>
    if(pos > 0) {
801005f4:	31 f6                	xor    %esi,%esi
801005f6:	e9 ea fe ff ff       	jmp    801004e5 <consputc+0xd5>
801005fb:	90                   	nop
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	89 d3                	mov    %edx,%ebx
80100608:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010060b:	85 c9                	test   %ecx,%ecx
{
8010060d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100610:	74 04                	je     80100616 <printint+0x16>
80100612:	85 c0                	test   %eax,%eax
80100614:	78 5a                	js     80100670 <printint+0x70>
    x = xx;
80100616:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010061d:	31 c9                	xor    %ecx,%ecx
8010061f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100622:	eb 06                	jmp    8010062a <printint+0x2a>
80100624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
80100628:	89 f9                	mov    %edi,%ecx
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	8d 79 01             	lea    0x1(%ecx),%edi
8010062f:	f7 f3                	div    %ebx
80100631:	0f b6 92 60 76 10 80 	movzbl -0x7fef89a0(%edx),%edx
  }while((x /= base) != 0);
80100638:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
8010063a:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
8010063d:	75 e9                	jne    80100628 <printint+0x28>
  if(sign)
8010063f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100642:	85 c0                	test   %eax,%eax
80100644:	74 08                	je     8010064e <printint+0x4e>
    buf[i++] = '-';
80100646:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
8010064b:	8d 79 02             	lea    0x2(%ecx),%edi
8010064e:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
80100652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
80100658:	0f be 03             	movsbl (%ebx),%eax
8010065b:	83 eb 01             	sub    $0x1,%ebx
8010065e:	e8 ad fd ff ff       	call   80100410 <consputc>
  while(--i >= 0)
80100663:	39 f3                	cmp    %esi,%ebx
80100665:	75 f1                	jne    80100658 <printint+0x58>
}
80100667:	83 c4 2c             	add    $0x2c,%esp
8010066a:	5b                   	pop    %ebx
8010066b:	5e                   	pop    %esi
8010066c:	5f                   	pop    %edi
8010066d:	5d                   	pop    %ebp
8010066e:	c3                   	ret    
8010066f:	90                   	nop
    x = -xx;
80100670:	f7 d8                	neg    %eax
80100672:	eb a9                	jmp    8010061d <printint+0x1d>
80100674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010067a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100680 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 18             	sub    $0x18,%esp
80100689:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;


  iunlock(ip);
8010068c:	ff 75 08             	pushl  0x8(%ebp)
8010068f:	e8 0c 13 00 00       	call   801019a0 <iunlock>
  acquire(&cons.lock);
80100694:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010069b:	e8 10 41 00 00       	call   801047b0 <acquire>
  for(i = 0; i < n; i++)
801006a0:	83 c4 10             	add    $0x10,%esp
801006a3:	85 f6                	test   %esi,%esi
801006a5:	7e 18                	jle    801006bf <consolewrite+0x3f>
801006a7:	8b 7d 0c             	mov    0xc(%ebp),%edi
801006aa:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
801006ad:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
801006b0:	0f b6 07             	movzbl (%edi),%eax
801006b3:	83 c7 01             	add    $0x1,%edi
801006b6:	e8 55 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
801006bb:	39 fb                	cmp    %edi,%ebx
801006bd:	75 f1                	jne    801006b0 <consolewrite+0x30>
  release(&cons.lock);
801006bf:	83 ec 0c             	sub    $0xc,%esp
801006c2:	68 20 b5 10 80       	push   $0x8010b520
801006c7:	e8 04 42 00 00       	call   801048d0 <release>
  ilock(ip);
801006cc:	58                   	pop    %eax
801006cd:	ff 75 08             	pushl  0x8(%ebp)
801006d0:	e8 eb 11 00 00       	call   801018c0 <ilock>

  return n;
}
801006d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006d8:	89 f0                	mov    %esi,%eax
801006da:	5b                   	pop    %ebx
801006db:	5e                   	pop    %esi
801006dc:	5f                   	pop    %edi
801006dd:	5d                   	pop    %ebp
801006de:	c3                   	ret    
801006df:	90                   	nop

801006e0 <cprintf>:
{
801006e0:	55                   	push   %ebp
801006e1:	89 e5                	mov    %esp,%ebp
801006e3:	57                   	push   %edi
801006e4:	56                   	push   %esi
801006e5:	53                   	push   %ebx
801006e6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006e9:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
801006ee:	85 c0                	test   %eax,%eax
  locking = cons.locking;
801006f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
801006f3:	0f 85 6f 01 00 00    	jne    80100868 <cprintf+0x188>
  if (fmt == 0)
801006f9:	8b 45 08             	mov    0x8(%ebp),%eax
801006fc:	85 c0                	test   %eax,%eax
801006fe:	89 c7                	mov    %eax,%edi
80100700:	0f 84 77 01 00 00    	je     8010087d <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100709:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010070e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100711:	85 c0                	test   %eax,%eax
80100713:	75 56                	jne    8010076b <cprintf+0x8b>
80100715:	eb 79                	jmp    80100790 <cprintf+0xb0>
80100717:	89 f6                	mov    %esi,%esi
80100719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
80100720:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
80100723:	85 d2                	test   %edx,%edx
80100725:	74 69                	je     80100790 <cprintf+0xb0>
80100727:	83 c3 02             	add    $0x2,%ebx
    switch(c){
8010072a:	83 fa 70             	cmp    $0x70,%edx
8010072d:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
80100730:	0f 84 84 00 00 00    	je     801007ba <cprintf+0xda>
80100736:	7f 78                	jg     801007b0 <cprintf+0xd0>
80100738:	83 fa 25             	cmp    $0x25,%edx
8010073b:	0f 84 ff 00 00 00    	je     80100840 <cprintf+0x160>
80100741:	83 fa 64             	cmp    $0x64,%edx
80100744:	0f 85 8e 00 00 00    	jne    801007d8 <cprintf+0xf8>
      printint(*argp++, 10, 1);
8010074a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010074d:	ba 0a 00 00 00       	mov    $0xa,%edx
80100752:	8d 48 04             	lea    0x4(%eax),%ecx
80100755:	8b 00                	mov    (%eax),%eax
80100757:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010075a:	b9 01 00 00 00       	mov    $0x1,%ecx
8010075f:	e8 9c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100764:	0f b6 06             	movzbl (%esi),%eax
80100767:	85 c0                	test   %eax,%eax
80100769:	74 25                	je     80100790 <cprintf+0xb0>
8010076b:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
8010076e:	83 f8 25             	cmp    $0x25,%eax
80100771:	8d 34 17             	lea    (%edi,%edx,1),%esi
80100774:	74 aa                	je     80100720 <cprintf+0x40>
80100776:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
80100779:	e8 92 fc ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077e:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100781:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100784:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100786:	85 c0                	test   %eax,%eax
80100788:	75 e1                	jne    8010076b <cprintf+0x8b>
8010078a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100790:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100793:	85 c0                	test   %eax,%eax
80100795:	74 10                	je     801007a7 <cprintf+0xc7>
    release(&cons.lock);
80100797:	83 ec 0c             	sub    $0xc,%esp
8010079a:	68 20 b5 10 80       	push   $0x8010b520
8010079f:	e8 2c 41 00 00       	call   801048d0 <release>
801007a4:	83 c4 10             	add    $0x10,%esp
}
801007a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007aa:	5b                   	pop    %ebx
801007ab:	5e                   	pop    %esi
801007ac:	5f                   	pop    %edi
801007ad:	5d                   	pop    %ebp
801007ae:	c3                   	ret    
801007af:	90                   	nop
    switch(c){
801007b0:	83 fa 73             	cmp    $0x73,%edx
801007b3:	74 43                	je     801007f8 <cprintf+0x118>
801007b5:	83 fa 78             	cmp    $0x78,%edx
801007b8:	75 1e                	jne    801007d8 <cprintf+0xf8>
      printint(*argp++, 16, 0);
801007ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007bd:	ba 10 00 00 00       	mov    $0x10,%edx
801007c2:	8d 48 04             	lea    0x4(%eax),%ecx
801007c5:	8b 00                	mov    (%eax),%eax
801007c7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801007ca:	31 c9                	xor    %ecx,%ecx
801007cc:	e8 2f fe ff ff       	call   80100600 <printint>
      break;
801007d1:	eb 91                	jmp    80100764 <cprintf+0x84>
801007d3:	90                   	nop
801007d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
801007d8:	b8 25 00 00 00       	mov    $0x25,%eax
801007dd:	89 55 e0             	mov    %edx,-0x20(%ebp)
801007e0:	e8 2b fc ff ff       	call   80100410 <consputc>
      consputc(c);
801007e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801007e8:	89 d0                	mov    %edx,%eax
801007ea:	e8 21 fc ff ff       	call   80100410 <consputc>
      break;
801007ef:	e9 70 ff ff ff       	jmp    80100764 <cprintf+0x84>
801007f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
801007f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007fb:	8b 10                	mov    (%eax),%edx
801007fd:	8d 48 04             	lea    0x4(%eax),%ecx
80100800:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100803:	85 d2                	test   %edx,%edx
80100805:	74 49                	je     80100850 <cprintf+0x170>
      for(; *s; s++)
80100807:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010080a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010080d:	84 c0                	test   %al,%al
8010080f:	0f 84 4f ff ff ff    	je     80100764 <cprintf+0x84>
80100815:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100818:	89 d3                	mov    %edx,%ebx
8010081a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100820:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
80100823:	e8 e8 fb ff ff       	call   80100410 <consputc>
      for(; *s; s++)
80100828:	0f be 03             	movsbl (%ebx),%eax
8010082b:	84 c0                	test   %al,%al
8010082d:	75 f1                	jne    80100820 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
8010082f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100832:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100838:	e9 27 ff ff ff       	jmp    80100764 <cprintf+0x84>
8010083d:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
80100840:	b8 25 00 00 00       	mov    $0x25,%eax
80100845:	e8 c6 fb ff ff       	call   80100410 <consputc>
      break;
8010084a:	e9 15 ff ff ff       	jmp    80100764 <cprintf+0x84>
8010084f:	90                   	nop
        s = "(null)";
80100850:	ba 38 76 10 80       	mov    $0x80107638,%edx
      for(; *s; s++)
80100855:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100858:	b8 28 00 00 00       	mov    $0x28,%eax
8010085d:	89 d3                	mov    %edx,%ebx
8010085f:	eb bf                	jmp    80100820 <cprintf+0x140>
80100861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
80100868:	83 ec 0c             	sub    $0xc,%esp
8010086b:	68 20 b5 10 80       	push   $0x8010b520
80100870:	e8 3b 3f 00 00       	call   801047b0 <acquire>
80100875:	83 c4 10             	add    $0x10,%esp
80100878:	e9 7c fe ff ff       	jmp    801006f9 <cprintf+0x19>
    panic("null fmt");
8010087d:	83 ec 0c             	sub    $0xc,%esp
80100880:	68 3f 76 10 80       	push   $0x8010763f
80100885:	e8 06 fb ff ff       	call   80100390 <panic>
8010088a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100890 <consoleintr>:
{
80100890:	55                   	push   %ebp
80100891:	89 e5                	mov    %esp,%ebp
80100893:	57                   	push   %edi
80100894:	56                   	push   %esi
80100895:	53                   	push   %ebx
  int c, doprocdump = 0;
80100896:	31 f6                	xor    %esi,%esi
{
80100898:	83 ec 18             	sub    $0x18,%esp
8010089b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010089e:	68 20 b5 10 80       	push   $0x8010b520
801008a3:	e8 08 3f 00 00       	call   801047b0 <acquire>
  while((c = getc()) >= 0){
801008a8:	83 c4 10             	add    $0x10,%esp
801008ab:	90                   	nop
801008ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008b0:	ff d3                	call   *%ebx
801008b2:	85 c0                	test   %eax,%eax
801008b4:	89 c7                	mov    %eax,%edi
801008b6:	78 48                	js     80100900 <consoleintr+0x70>
    switch(c){
801008b8:	83 ff 10             	cmp    $0x10,%edi
801008bb:	0f 84 e7 00 00 00    	je     801009a8 <consoleintr+0x118>
801008c1:	7e 5d                	jle    80100920 <consoleintr+0x90>
801008c3:	83 ff 15             	cmp    $0x15,%edi
801008c6:	0f 84 ec 00 00 00    	je     801009b8 <consoleintr+0x128>
801008cc:	83 ff 7f             	cmp    $0x7f,%edi
801008cf:	75 54                	jne    80100925 <consoleintr+0x95>
      if(input.e != input.w){
801008d1:	a1 08 10 11 80       	mov    0x80111008,%eax
801008d6:	3b 05 04 10 11 80    	cmp    0x80111004,%eax
801008dc:	74 d2                	je     801008b0 <consoleintr+0x20>
        input.e--;
801008de:	83 e8 01             	sub    $0x1,%eax
801008e1:	a3 08 10 11 80       	mov    %eax,0x80111008
        consputc(BACKSPACE);
801008e6:	b8 00 01 00 00       	mov    $0x100,%eax
801008eb:	e8 20 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
801008f0:	ff d3                	call   *%ebx
801008f2:	85 c0                	test   %eax,%eax
801008f4:	89 c7                	mov    %eax,%edi
801008f6:	79 c0                	jns    801008b8 <consoleintr+0x28>
801008f8:	90                   	nop
801008f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100900:	83 ec 0c             	sub    $0xc,%esp
80100903:	68 20 b5 10 80       	push   $0x8010b520
80100908:	e8 c3 3f 00 00       	call   801048d0 <release>
  if(doprocdump) {
8010090d:	83 c4 10             	add    $0x10,%esp
80100910:	85 f6                	test   %esi,%esi
80100912:	0f 85 f8 00 00 00    	jne    80100a10 <consoleintr+0x180>
}
80100918:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010091b:	5b                   	pop    %ebx
8010091c:	5e                   	pop    %esi
8010091d:	5f                   	pop    %edi
8010091e:	5d                   	pop    %ebp
8010091f:	c3                   	ret    
    switch(c){
80100920:	83 ff 08             	cmp    $0x8,%edi
80100923:	74 ac                	je     801008d1 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100925:	85 ff                	test   %edi,%edi
80100927:	74 87                	je     801008b0 <consoleintr+0x20>
80100929:	a1 08 10 11 80       	mov    0x80111008,%eax
8010092e:	89 c2                	mov    %eax,%edx
80100930:	2b 15 00 10 11 80    	sub    0x80111000,%edx
80100936:	83 fa 7f             	cmp    $0x7f,%edx
80100939:	0f 87 71 ff ff ff    	ja     801008b0 <consoleintr+0x20>
8010093f:	8d 50 01             	lea    0x1(%eax),%edx
80100942:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100945:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100948:	89 15 08 10 11 80    	mov    %edx,0x80111008
        c = (c == '\r') ? '\n' : c;
8010094e:	0f 84 cc 00 00 00    	je     80100a20 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
80100954:	89 f9                	mov    %edi,%ecx
80100956:	88 88 80 0f 11 80    	mov    %cl,-0x7feef080(%eax)
        consputc(c);
8010095c:	89 f8                	mov    %edi,%eax
8010095e:	e8 ad fa ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100963:	83 ff 0a             	cmp    $0xa,%edi
80100966:	0f 84 c5 00 00 00    	je     80100a31 <consoleintr+0x1a1>
8010096c:	83 ff 04             	cmp    $0x4,%edi
8010096f:	0f 84 bc 00 00 00    	je     80100a31 <consoleintr+0x1a1>
80100975:	a1 00 10 11 80       	mov    0x80111000,%eax
8010097a:	83 e8 80             	sub    $0xffffff80,%eax
8010097d:	39 05 08 10 11 80    	cmp    %eax,0x80111008
80100983:	0f 85 27 ff ff ff    	jne    801008b0 <consoleintr+0x20>
          wakeup(&input.r);
80100989:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010098c:	a3 04 10 11 80       	mov    %eax,0x80111004
          wakeup(&input.r);
80100991:	68 00 10 11 80       	push   $0x80111000
80100996:	e8 95 3a 00 00       	call   80104430 <wakeup>
8010099b:	83 c4 10             	add    $0x10,%esp
8010099e:	e9 0d ff ff ff       	jmp    801008b0 <consoleintr+0x20>
801009a3:	90                   	nop
801009a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
801009a8:	be 01 00 00 00       	mov    $0x1,%esi
801009ad:	e9 fe fe ff ff       	jmp    801008b0 <consoleintr+0x20>
801009b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
801009b8:	a1 08 10 11 80       	mov    0x80111008,%eax
801009bd:	39 05 04 10 11 80    	cmp    %eax,0x80111004
801009c3:	75 2b                	jne    801009f0 <consoleintr+0x160>
801009c5:	e9 e6 fe ff ff       	jmp    801008b0 <consoleintr+0x20>
801009ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801009d0:	a3 08 10 11 80       	mov    %eax,0x80111008
        consputc(BACKSPACE);
801009d5:	b8 00 01 00 00       	mov    $0x100,%eax
801009da:	e8 31 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
801009df:	a1 08 10 11 80       	mov    0x80111008,%eax
801009e4:	3b 05 04 10 11 80    	cmp    0x80111004,%eax
801009ea:	0f 84 c0 fe ff ff    	je     801008b0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009f0:	83 e8 01             	sub    $0x1,%eax
801009f3:	89 c2                	mov    %eax,%edx
801009f5:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801009f8:	80 ba 80 0f 11 80 0a 	cmpb   $0xa,-0x7feef080(%edx)
801009ff:	75 cf                	jne    801009d0 <consoleintr+0x140>
80100a01:	e9 aa fe ff ff       	jmp    801008b0 <consoleintr+0x20>
80100a06:	8d 76 00             	lea    0x0(%esi),%esi
80100a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a13:	5b                   	pop    %ebx
80100a14:	5e                   	pop    %esi
80100a15:	5f                   	pop    %edi
80100a16:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a17:	e9 c4 3a 00 00       	jmp    801044e0 <procdump>
80100a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100a20:	c6 80 80 0f 11 80 0a 	movb   $0xa,-0x7feef080(%eax)
        consputc(c);
80100a27:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2c:	e8 df f9 ff ff       	call   80100410 <consputc>
80100a31:	a1 08 10 11 80       	mov    0x80111008,%eax
80100a36:	e9 4e ff ff ff       	jmp    80100989 <consoleintr+0xf9>
80100a3b:	90                   	nop
80100a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a40 <splitw>:
{
80100a40:	55                   	push   %ebp
80100a41:	89 e5                	mov    %esp,%ebp
80100a43:	57                   	push   %edi
80100a44:	56                   	push   %esi
80100a45:	53                   	push   %ebx
80100a46:	83 ec 1c             	sub    $0x1c,%esp
80100a49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc=myproc();
80100a4c:	e8 ef 2f 00 00       	call   80103a40 <myproc>
  int idx = curproc->wdidx;
80100a51:	8b b0 c0 00 00 00    	mov    0xc0(%eax),%esi
  switch(d)
80100a57:	83 fb ff             	cmp    $0xffffffff,%ebx
80100a5a:	74 14                	je     80100a70 <splitw+0x30>
80100a5c:	85 db                	test   %ebx,%ebx
80100a5e:	74 30                	je     80100a90 <splitw+0x50>
}
80100a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a63:	89 f0                	mov    %esi,%eax
80100a65:	5b                   	pop    %ebx
80100a66:	5e                   	pop    %esi
80100a67:	5f                   	pop    %edi
80100a68:	5d                   	pop    %ebp
80100a69:	c3                   	ret    
80100a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    curproc->wdidx=window.lastnew;
80100a70:	8b 15 00 90 10 80    	mov    0x80109000,%edx
80100a76:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	89 f0                	mov    %esi,%eax
80100a81:	5b                   	pop    %ebx
80100a82:	5e                   	pop    %esi
80100a83:	5f                   	pop    %edi
80100a84:	5d                   	pop    %ebp
80100a85:	c3                   	ret    
80100a86:	8d 76 00             	lea    0x0(%esi),%esi
80100a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    window.width[idx]/=2;
80100a90:	8d 56 0c             	lea    0xc(%esi),%edx
80100a93:	bb 0a 00 00 00       	mov    $0xa,%ebx
      new=(new+1)%MAXWINDOWS;
80100a98:	bf 67 66 66 66       	mov    $0x66666667,%edi
    window.width[idx]/=2;
80100a9d:	8b 0c 95 08 90 10 80 	mov    -0x7fef6ff8(,%edx,4),%ecx
80100aa4:	89 c8                	mov    %ecx,%eax
80100aa6:	c1 e8 1f             	shr    $0x1f,%eax
80100aa9:	01 c8                	add    %ecx,%eax
80100aab:	d1 f8                	sar    %eax
80100aad:	89 04 95 08 90 10 80 	mov    %eax,-0x7fef6ff8(,%edx,4)
80100ab4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int i,new=idx;
80100ab7:	89 f2                	mov    %esi,%edx
80100ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      new=(new+1)%MAXWINDOWS;
80100ac0:	8d 4a 01             	lea    0x1(%edx),%ecx
80100ac3:	89 c8                	mov    %ecx,%eax
80100ac5:	f7 ef                	imul   %edi
80100ac7:	89 c8                	mov    %ecx,%eax
80100ac9:	c1 f8 1f             	sar    $0x1f,%eax
80100acc:	c1 fa 02             	sar    $0x2,%edx
80100acf:	29 c2                	sub    %eax,%edx
80100ad1:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100ad4:	01 c0                	add    %eax,%eax
80100ad6:	29 c1                	sub    %eax,%ecx
      if(window.used[new]==0)
80100ad8:	80 b9 04 90 10 80 00 	cmpb   $0x0,-0x7fef6ffc(%ecx)
      new=(new+1)%MAXWINDOWS;
80100adf:	89 ca                	mov    %ecx,%edx
      if(window.used[new]==0)
80100ae1:	74 05                	je     80100ae8 <splitw+0xa8>
    for(i=0;i<MAXWINDOWS;i++)
80100ae3:	83 eb 01             	sub    $0x1,%ebx
80100ae6:	75 d8                	jne    80100ac0 <splitw+0x80>
    window.left[new]=window.left[idx]+window.width[idx];
80100ae8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80100aeb:	8b 04 b5 10 90 10 80 	mov    -0x7fef6ff0(,%esi,4),%eax
    cprintf("new left: %d\n", window.left[new]);
80100af2:	83 ec 08             	sub    $0x8,%esp
    window.top[new]=window.top[idx];
80100af5:	8b 0c b5 60 90 10 80 	mov    -0x7fef6fa0(,%esi,4),%ecx
    window.lastnew=new;
80100afc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    window.used[new]=1;
80100aff:	c6 82 04 90 10 80 01 	movb   $0x1,-0x7fef6ffc(%edx)
    window.lastnew=new;
80100b06:	89 15 00 90 10 80    	mov    %edx,0x80109000
    window.left[new]=window.left[idx]+window.width[idx];
80100b0c:	01 f8                	add    %edi,%eax
    window.width[new]=window.width[idx];
80100b0e:	89 3c 95 38 90 10 80 	mov    %edi,-0x7fef6fc8(,%edx,4)
    window.top[new]=window.top[idx];
80100b15:	89 0c 95 60 90 10 80 	mov    %ecx,-0x7fef6fa0(,%edx,4)
    window.height[new]=window.height[idx];
80100b1c:	8b 0c b5 88 90 10 80 	mov    -0x7fef6f78(,%esi,4),%ecx
    cprintf("new left: %d\n", window.left[new]);
80100b23:	50                   	push   %eax
80100b24:	68 48 76 10 80       	push   $0x80107648
    window.left[new]=window.left[idx]+window.width[idx];
80100b29:	89 04 95 10 90 10 80 	mov    %eax,-0x7fef6ff0(,%edx,4)
    window.height[new]=window.height[idx];
80100b30:	89 0c 95 88 90 10 80 	mov    %ecx,-0x7fef6f78(,%edx,4)
    cprintf("new left: %d\n", window.left[new]);
80100b37:	e8 a4 fb ff ff       	call   801006e0 <cprintf>
    break;
80100b3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100b3f:	83 c4 10             	add    $0x10,%esp
}
80100b42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b45:	5b                   	pop    %ebx
    break;
80100b46:	89 d6                	mov    %edx,%esi
}
80100b48:	89 f0                	mov    %esi,%eax
80100b4a:	5e                   	pop    %esi
80100b4b:	5f                   	pop    %edi
80100b4c:	5d                   	pop    %ebp
80100b4d:	c3                   	ret    
80100b4e:	66 90                	xchg   %ax,%ax

80100b50 <consoleinit>:

void
consoleinit(void)
{
80100b50:	55                   	push   %ebp
80100b51:	89 e5                	mov    %esp,%ebp
80100b53:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b56:	68 56 76 10 80       	push   $0x80107656
80100b5b:	68 20 b5 10 80       	push   $0x8010b520
80100b60:	e8 5b 3b 00 00       	call   801046c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100b65:	58                   	pop    %eax
80100b66:	5a                   	pop    %edx
80100b67:	6a 00                	push   $0x0
80100b69:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100b6b:	c7 05 6c 1b 11 80 80 	movl   $0x80100680,0x80111b6c
80100b72:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100b75:	c7 05 68 1b 11 80 70 	movl   $0x80100270,0x80111b68
80100b7c:	02 10 80 
  cons.locking = 1;
80100b7f:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100b86:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100b89:	e8 82 19 00 00       	call   80102510 <ioapicenable>
}
80100b8e:	83 c4 10             	add    $0x10,%esp
80100b91:	c9                   	leave  
80100b92:	c3                   	ret    
80100b93:	66 90                	xchg   %ax,%ax
80100b95:	66 90                	xchg   %ax,%ax
80100b97:	66 90                	xchg   %ax,%ax
80100b99:	66 90                	xchg   %ax,%ax
80100b9b:	66 90                	xchg   %ax,%ax
80100b9d:	66 90                	xchg   %ax,%ax
80100b9f:	90                   	nop

80100ba0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ba0:	55                   	push   %ebp
80100ba1:	89 e5                	mov    %esp,%ebp
80100ba3:	57                   	push   %edi
80100ba4:	56                   	push   %esi
80100ba5:	53                   	push   %ebx
80100ba6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bac:	e8 8f 2e 00 00       	call   80103a40 <myproc>
80100bb1:	89 c7                	mov    %eax,%edi

  begin_op();
80100bb3:	e8 28 22 00 00       	call   80102de0 <begin_op>

  if((ip = namei(path)) == 0){
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff 75 08             	pushl  0x8(%ebp)
80100bbe:	e8 5d 15 00 00       	call   80102120 <namei>
80100bc3:	83 c4 10             	add    $0x10,%esp
80100bc6:	85 c0                	test   %eax,%eax
80100bc8:	0f 84 d7 01 00 00    	je     80100da5 <exec+0x205>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100bce:	83 ec 0c             	sub    $0xc,%esp
80100bd1:	89 c3                	mov    %eax,%ebx
80100bd3:	50                   	push   %eax
80100bd4:	e8 e7 0c 00 00       	call   801018c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bd9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100bdf:	6a 34                	push   $0x34
80100be1:	6a 00                	push   $0x0
80100be3:	50                   	push   %eax
80100be4:	53                   	push   %ebx
80100be5:	e8 b6 0f 00 00       	call   80101ba0 <readi>
80100bea:	83 c4 20             	add    $0x20,%esp
80100bed:	83 f8 34             	cmp    $0x34,%eax
80100bf0:	74 1e                	je     80100c10 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir,curproc->nshared);
  if(ip){
    iunlockput(ip);
80100bf2:	83 ec 0c             	sub    $0xc,%esp
80100bf5:	53                   	push   %ebx
80100bf6:	e8 55 0f 00 00       	call   80101b50 <iunlockput>
    end_op();
80100bfb:	e8 50 22 00 00       	call   80102e50 <end_op>
80100c00:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c0b:	5b                   	pop    %ebx
80100c0c:	5e                   	pop    %esi
80100c0d:	5f                   	pop    %edi
80100c0e:	5d                   	pop    %ebp
80100c0f:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100c10:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c17:	45 4c 46 
80100c1a:	75 d6                	jne    80100bf2 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
80100c1c:	e8 1f 67 00 00       	call   80107340 <setupkvm>
80100c21:	85 c0                	test   %eax,%eax
80100c23:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100c29:	74 c7                	je     80100bf2 <exec+0x52>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c2b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100c31:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  sz = 0;
80100c37:	31 c0                	xor    %eax,%eax
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c39:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c40:	00 
80100c41:	0f 84 df 02 00 00    	je     80100f26 <exec+0x386>
80100c47:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100c4d:	31 f6                	xor    %esi,%esi
80100c4f:	89 c7                	mov    %eax,%edi
80100c51:	e9 92 00 00 00       	jmp    80100ce8 <exec+0x148>
80100c56:	8d 76 00             	lea    0x0(%esi),%esi
80100c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ph.type != ELF_PROG_LOAD)
80100c60:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c67:	75 71                	jne    80100cda <exec+0x13a>
    if(ph.memsz < ph.filesz)
80100c69:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c6f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100c75:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100c7b:	8b 92 88 00 00 00    	mov    0x88(%edx),%edx
80100c81:	0f 82 94 00 00 00    	jb     80100d1b <exec+0x17b>
80100c87:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100c8d:	0f 82 88 00 00 00    	jb     80100d1b <exec+0x17b>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz,curproc->nshared)) == 0)
80100c93:	52                   	push   %edx
80100c94:	50                   	push   %eax
80100c95:	57                   	push   %edi
80100c96:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c9c:	e8 8f 64 00 00       	call   80107130 <allocuvm>
80100ca1:	83 c4 10             	add    $0x10,%esp
80100ca4:	85 c0                	test   %eax,%eax
80100ca6:	89 c7                	mov    %eax,%edi
80100ca8:	74 65                	je     80100d0f <exec+0x16f>
    if(ph.vaddr % PGSIZE != 0)
80100caa:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100cb0:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100cb5:	75 58                	jne    80100d0f <exec+0x16f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cb7:	83 ec 0c             	sub    $0xc,%esp
80100cba:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100cc0:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100cc6:	53                   	push   %ebx
80100cc7:	50                   	push   %eax
80100cc8:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cce:	e8 ad 62 00 00       	call   80106f80 <loaduvm>
80100cd3:	83 c4 20             	add    $0x20,%esp
80100cd6:	85 c0                	test   %eax,%eax
80100cd8:	78 35                	js     80100d0f <exec+0x16f>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cda:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ce1:	83 c6 01             	add    $0x1,%esi
80100ce4:	39 f0                	cmp    %esi,%eax
80100ce6:	7e 4a                	jle    80100d32 <exec+0x192>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ce8:	89 f0                	mov    %esi,%eax
80100cea:	6a 20                	push   $0x20
80100cec:	c1 e0 05             	shl    $0x5,%eax
80100cef:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100cf5:	50                   	push   %eax
80100cf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100cfc:	50                   	push   %eax
80100cfd:	53                   	push   %ebx
80100cfe:	e8 9d 0e 00 00       	call   80101ba0 <readi>
80100d03:	83 c4 10             	add    $0x10,%esp
80100d06:	83 f8 20             	cmp    $0x20,%eax
80100d09:	0f 84 51 ff ff ff    	je     80100c60 <exec+0xc0>
80100d0f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d15:	8b 97 88 00 00 00    	mov    0x88(%edi),%edx
    freevm(pgdir,curproc->nshared);
80100d1b:	83 ec 08             	sub    $0x8,%esp
80100d1e:	52                   	push   %edx
80100d1f:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d25:	e8 86 65 00 00       	call   801072b0 <freevm>
80100d2a:	83 c4 10             	add    $0x10,%esp
80100d2d:	e9 c0 fe ff ff       	jmp    80100bf2 <exec+0x52>
80100d32:	89 f8                	mov    %edi,%eax
80100d34:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d3a:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d44:	8d b0 00 20 00 00    	lea    0x2000(%eax),%esi
  iunlockput(ip);
80100d4a:	83 ec 0c             	sub    $0xc,%esp
80100d4d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d53:	53                   	push   %ebx
80100d54:	e8 f7 0d 00 00       	call   80101b50 <iunlockput>
  end_op();
80100d59:	e8 f2 20 00 00       	call   80102e50 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE,curproc->nshared)) == 0)
80100d5e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d64:	ff b7 88 00 00 00    	pushl  0x88(%edi)
80100d6a:	56                   	push   %esi
80100d6b:	50                   	push   %eax
80100d6c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d72:	e8 b9 63 00 00       	call   80107130 <allocuvm>
80100d77:	83 c4 20             	add    $0x20,%esp
80100d7a:	85 c0                	test   %eax,%eax
80100d7c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d82:	75 40                	jne    80100dc4 <exec+0x224>
    freevm(pgdir,curproc->nshared);
80100d84:	83 ec 08             	sub    $0x8,%esp
80100d87:	ff b7 88 00 00 00    	pushl  0x88(%edi)
80100d8d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d93:	e8 18 65 00 00       	call   801072b0 <freevm>
80100d98:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100da0:	e9 63 fe ff ff       	jmp    80100c08 <exec+0x68>
    end_op();
80100da5:	e8 a6 20 00 00       	call   80102e50 <end_op>
    cprintf("exec: fail\n");
80100daa:	83 ec 0c             	sub    $0xc,%esp
80100dad:	68 71 76 10 80       	push   $0x80107671
80100db2:	e8 29 f9 ff ff       	call   801006e0 <cprintf>
    return -1;
80100db7:	83 c4 10             	add    $0x10,%esp
80100dba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dbf:	e9 44 fe ff ff       	jmp    80100c08 <exec+0x68>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dc4:	89 c3                	mov    %eax,%ebx
80100dc6:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100dcc:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100dcf:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dd1:	50                   	push   %eax
80100dd2:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100dd8:	e8 03 66 00 00       	call   801073e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100de0:	83 c4 10             	add    $0x10,%esp
80100de3:	8b 00                	mov    (%eax),%eax
80100de5:	85 c0                	test   %eax,%eax
80100de7:	0f 84 43 01 00 00    	je     80100f30 <exec+0x390>
80100ded:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100df3:	89 f7                	mov    %esi,%edi
80100df5:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100dfb:	eb 22                	jmp    80100e1f <exec+0x27f>
80100dfd:	8d 76 00             	lea    0x0(%esi),%esi
80100e00:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100e03:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100e0a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100e0d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100e13:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100e16:	85 c0                	test   %eax,%eax
80100e18:	74 44                	je     80100e5e <exec+0x2be>
    if(argc >= MAXARG)
80100e1a:	83 ff 20             	cmp    $0x20,%edi
80100e1d:	74 34                	je     80100e53 <exec+0x2b3>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e1f:	83 ec 0c             	sub    $0xc,%esp
80100e22:	50                   	push   %eax
80100e23:	e8 28 3d 00 00       	call   80104b50 <strlen>
80100e28:	f7 d0                	not    %eax
80100e2a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e2c:	58                   	pop    %eax
80100e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e30:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e33:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e36:	e8 15 3d 00 00       	call   80104b50 <strlen>
80100e3b:	83 c0 01             	add    $0x1,%eax
80100e3e:	50                   	push   %eax
80100e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e42:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e45:	53                   	push   %ebx
80100e46:	56                   	push   %esi
80100e47:	e8 e4 66 00 00       	call   80107530 <copyout>
80100e4c:	83 c4 20             	add    $0x20,%esp
80100e4f:	85 c0                	test   %eax,%eax
80100e51:	79 ad                	jns    80100e00 <exec+0x260>
80100e53:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100e59:	e9 26 ff ff ff       	jmp    80100d84 <exec+0x1e4>
80100e5e:	89 fe                	mov    %edi,%esi
80100e60:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e66:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100e6d:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100e6f:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100e76:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100e7a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e81:	ff ff ff 
  ustack[1] = argc;
80100e84:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e8a:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100e8c:	83 c0 0c             	add    $0xc,%eax
80100e8f:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e91:	50                   	push   %eax
80100e92:	52                   	push   %edx
80100e93:	53                   	push   %ebx
80100e94:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e9a:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ea0:	e8 8b 66 00 00       	call   80107530 <copyout>
80100ea5:	83 c4 10             	add    $0x10,%esp
80100ea8:	85 c0                	test   %eax,%eax
80100eaa:	0f 88 d4 fe ff ff    	js     80100d84 <exec+0x1e4>
  for(last=s=path; *s; s++)
80100eb0:	8b 45 08             	mov    0x8(%ebp),%eax
80100eb3:	0f b6 00             	movzbl (%eax),%eax
80100eb6:	84 c0                	test   %al,%al
80100eb8:	74 17                	je     80100ed1 <exec+0x331>
80100eba:	8b 55 08             	mov    0x8(%ebp),%edx
80100ebd:	89 d1                	mov    %edx,%ecx
80100ebf:	83 c1 01             	add    $0x1,%ecx
80100ec2:	3c 2f                	cmp    $0x2f,%al
80100ec4:	0f b6 01             	movzbl (%ecx),%eax
80100ec7:	0f 44 d1             	cmove  %ecx,%edx
80100eca:	84 c0                	test   %al,%al
80100ecc:	75 f1                	jne    80100ebf <exec+0x31f>
80100ece:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ed1:	50                   	push   %eax
80100ed2:	8d 47 6c             	lea    0x6c(%edi),%eax
80100ed5:	6a 10                	push   $0x10
80100ed7:	ff 75 08             	pushl  0x8(%ebp)
80100eda:	50                   	push   %eax
80100edb:	e8 30 3c 00 00       	call   80104b10 <safestrcpy>
  curproc->pgdir = pgdir;
80100ee0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100ee6:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
80100ee9:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100eec:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ef2:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100ef4:	8b 47 18             	mov    0x18(%edi),%eax
80100ef7:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100efd:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f00:	8b 47 18             	mov    0x18(%edi),%eax
80100f03:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100f06:	89 3c 24             	mov    %edi,(%esp)
80100f09:	e8 e2 5e 00 00       	call   80106df0 <switchuvm>
  freevm(oldpgdir,curproc->nshared);
80100f0e:	5a                   	pop    %edx
80100f0f:	59                   	pop    %ecx
80100f10:	ff b7 88 00 00 00    	pushl  0x88(%edi)
80100f16:	56                   	push   %esi
80100f17:	e8 94 63 00 00       	call   801072b0 <freevm>
  return 0;
80100f1c:	83 c4 10             	add    $0x10,%esp
80100f1f:	31 c0                	xor    %eax,%eax
80100f21:	e9 e2 fc ff ff       	jmp    80100c08 <exec+0x68>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f26:	be 00 20 00 00       	mov    $0x2000,%esi
80100f2b:	e9 1a fe ff ff       	jmp    80100d4a <exec+0x1aa>
  for(argc = 0; argv[argc]; argc++) {
80100f30:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100f36:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100f3c:	e9 25 ff ff ff       	jmp    80100e66 <exec+0x2c6>
80100f41:	66 90                	xchg   %ax,%ax
80100f43:	66 90                	xchg   %ax,%ax
80100f45:	66 90                	xchg   %ax,%ax
80100f47:	66 90                	xchg   %ax,%ax
80100f49:	66 90                	xchg   %ax,%ax
80100f4b:	66 90                	xchg   %ax,%ax
80100f4d:	66 90                	xchg   %ax,%ax
80100f4f:	90                   	nop

80100f50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f56:	68 7d 76 10 80       	push   $0x8010767d
80100f5b:	68 20 10 11 80       	push   $0x80111020
80100f60:	e8 5b 37 00 00       	call   801046c0 <initlock>
}
80100f65:	83 c4 10             	add    $0x10,%esp
80100f68:	c9                   	leave  
80100f69:	c3                   	ret    
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f74:	bb 54 10 11 80       	mov    $0x80111054,%ebx
{
80100f79:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f7c:	68 20 10 11 80       	push   $0x80111020
80100f81:	e8 2a 38 00 00       	call   801047b0 <acquire>
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	eb 10                	jmp    80100f9b <filealloc+0x2b>
80100f8b:	90                   	nop
80100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f90:	83 c3 1c             	add    $0x1c,%ebx
80100f93:	81 fb 44 1b 11 80    	cmp    $0x80111b44,%ebx
80100f99:	73 25                	jae    80100fc0 <filealloc+0x50>
    if(f->ref == 0){
80100f9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f9e:	85 c0                	test   %eax,%eax
80100fa0:	75 ee                	jne    80100f90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100fa2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100fa5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100fac:	68 20 10 11 80       	push   $0x80111020
80100fb1:	e8 1a 39 00 00       	call   801048d0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100fb6:	89 d8                	mov    %ebx,%eax
      return f;
80100fb8:	83 c4 10             	add    $0x10,%esp
}
80100fbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fbe:	c9                   	leave  
80100fbf:	c3                   	ret    
  release(&ftable.lock);
80100fc0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100fc3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100fc5:	68 20 10 11 80       	push   $0x80111020
80100fca:	e8 01 39 00 00       	call   801048d0 <release>
}
80100fcf:	89 d8                	mov    %ebx,%eax
  return 0;
80100fd1:	83 c4 10             	add    $0x10,%esp
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd7:	c9                   	leave  
80100fd8:	c3                   	ret    
80100fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
80100fe4:	83 ec 10             	sub    $0x10,%esp
80100fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fea:	68 20 10 11 80       	push   $0x80111020
80100fef:	e8 bc 37 00 00       	call   801047b0 <acquire>
  if(f->ref < 1)
80100ff4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ff7:	83 c4 10             	add    $0x10,%esp
80100ffa:	85 c0                	test   %eax,%eax
80100ffc:	7e 1a                	jle    80101018 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ffe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101001:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101004:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101007:	68 20 10 11 80       	push   $0x80111020
8010100c:	e8 bf 38 00 00       	call   801048d0 <release>
  return f;
}
80101011:	89 d8                	mov    %ebx,%eax
80101013:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101016:	c9                   	leave  
80101017:	c3                   	ret    
    panic("filedup");
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	68 84 76 10 80       	push   $0x80107684
80101020:	e8 6b f3 ff ff       	call   80100390 <panic>
80101025:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101030 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 28             	sub    $0x28,%esp
80101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010103c:	68 20 10 11 80       	push   $0x80111020
80101041:	e8 6a 37 00 00       	call   801047b0 <acquire>
  if(f->ref < 1)
80101046:	8b 43 04             	mov    0x4(%ebx),%eax
80101049:	83 c4 10             	add    $0x10,%esp
8010104c:	85 c0                	test   %eax,%eax
8010104e:	0f 8e 9b 00 00 00    	jle    801010ef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101054:	83 e8 01             	sub    $0x1,%eax
80101057:	85 c0                	test   %eax,%eax
80101059:	89 43 04             	mov    %eax,0x4(%ebx)
8010105c:	74 1a                	je     80101078 <fileclose+0x48>
    release(&ftable.lock);
8010105e:	c7 45 08 20 10 11 80 	movl   $0x80111020,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101065:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101068:	5b                   	pop    %ebx
80101069:	5e                   	pop    %esi
8010106a:	5f                   	pop    %edi
8010106b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010106c:	e9 5f 38 00 00       	jmp    801048d0 <release>
80101071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101078:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010107c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010107e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101081:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101084:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010108a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010108d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101090:	68 20 10 11 80       	push   $0x80111020
  ff = *f;
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101098:	e8 33 38 00 00       	call   801048d0 <release>
  if(ff.type == FD_PIPE)
8010109d:	83 c4 10             	add    $0x10,%esp
801010a0:	83 ff 01             	cmp    $0x1,%edi
801010a3:	74 13                	je     801010b8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
801010a5:	83 ff 03             	cmp    $0x3,%edi
801010a8:	74 26                	je     801010d0 <fileclose+0xa0>
}
801010aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010ad:	5b                   	pop    %ebx
801010ae:	5e                   	pop    %esi
801010af:	5f                   	pop    %edi
801010b0:	5d                   	pop    %ebp
801010b1:	c3                   	ret    
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
801010b8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010bc:	83 ec 08             	sub    $0x8,%esp
801010bf:	53                   	push   %ebx
801010c0:	56                   	push   %esi
801010c1:	e8 ca 24 00 00       	call   80103590 <pipeclose>
801010c6:	83 c4 10             	add    $0x10,%esp
801010c9:	eb df                	jmp    801010aa <fileclose+0x7a>
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
801010d0:	e8 0b 1d 00 00       	call   80102de0 <begin_op>
    iput(ff.ip);
801010d5:	83 ec 0c             	sub    $0xc,%esp
801010d8:	ff 75 e0             	pushl  -0x20(%ebp)
801010db:	e8 10 09 00 00       	call   801019f0 <iput>
    end_op();
801010e0:	83 c4 10             	add    $0x10,%esp
}
801010e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e6:	5b                   	pop    %ebx
801010e7:	5e                   	pop    %esi
801010e8:	5f                   	pop    %edi
801010e9:	5d                   	pop    %ebp
    end_op();
801010ea:	e9 61 1d 00 00       	jmp    80102e50 <end_op>
    panic("fileclose");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 8c 76 10 80       	push   $0x8010768c
801010f7:	e8 94 f2 ff ff       	call   80100390 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	53                   	push   %ebx
80101104:	83 ec 04             	sub    $0x4,%esp
80101107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010110a:	83 3b 03             	cmpl   $0x3,(%ebx)
8010110d:	75 31                	jne    80101140 <filestat+0x40>
    ilock(f->ip);
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	ff 73 10             	pushl  0x10(%ebx)
80101115:	e8 a6 07 00 00       	call   801018c0 <ilock>
    stati(f->ip, st);
8010111a:	58                   	pop    %eax
8010111b:	5a                   	pop    %edx
8010111c:	ff 75 0c             	pushl  0xc(%ebp)
8010111f:	ff 73 10             	pushl  0x10(%ebx)
80101122:	e8 49 0a 00 00       	call   80101b70 <stati>
    iunlock(f->ip);
80101127:	59                   	pop    %ecx
80101128:	ff 73 10             	pushl  0x10(%ebx)
8010112b:	e8 70 08 00 00       	call   801019a0 <iunlock>
    return 0;
80101130:	83 c4 10             	add    $0x10,%esp
80101133:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101138:	c9                   	leave  
80101139:	c3                   	ret    
8010113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101145:	eb ee                	jmp    80101135 <filestat+0x35>
80101147:	89 f6                	mov    %esi,%esi
80101149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101150 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	57                   	push   %edi
80101154:	56                   	push   %esi
80101155:	53                   	push   %ebx
80101156:	83 ec 0c             	sub    $0xc,%esp
80101159:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010115c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010115f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101162:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101166:	74 60                	je     801011c8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101168:	8b 03                	mov    (%ebx),%eax
8010116a:	83 f8 01             	cmp    $0x1,%eax
8010116d:	74 41                	je     801011b0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010116f:	83 f8 03             	cmp    $0x3,%eax
80101172:	75 5b                	jne    801011cf <fileread+0x7f>
    ilock(f->ip);
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	ff 73 10             	pushl  0x10(%ebx)
8010117a:	e8 41 07 00 00       	call   801018c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010117f:	57                   	push   %edi
80101180:	ff 73 18             	pushl  0x18(%ebx)
80101183:	56                   	push   %esi
80101184:	ff 73 10             	pushl  0x10(%ebx)
80101187:	e8 14 0a 00 00       	call   80101ba0 <readi>
8010118c:	83 c4 20             	add    $0x20,%esp
8010118f:	85 c0                	test   %eax,%eax
80101191:	89 c6                	mov    %eax,%esi
80101193:	7e 03                	jle    80101198 <fileread+0x48>
      f->off += r;
80101195:	01 43 18             	add    %eax,0x18(%ebx)
    iunlock(f->ip);
80101198:	83 ec 0c             	sub    $0xc,%esp
8010119b:	ff 73 10             	pushl  0x10(%ebx)
8010119e:	e8 fd 07 00 00       	call   801019a0 <iunlock>
    return r;
801011a3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801011a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a9:	89 f0                	mov    %esi,%eax
801011ab:	5b                   	pop    %ebx
801011ac:	5e                   	pop    %esi
801011ad:	5f                   	pop    %edi
801011ae:	5d                   	pop    %ebp
801011af:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801011b0:	8b 43 0c             	mov    0xc(%ebx),%eax
801011b3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b9:	5b                   	pop    %ebx
801011ba:	5e                   	pop    %esi
801011bb:	5f                   	pop    %edi
801011bc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801011bd:	e9 7e 25 00 00       	jmp    80103740 <piperead>
801011c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011cd:	eb d7                	jmp    801011a6 <fileread+0x56>
  panic("fileread");
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	68 96 76 10 80       	push   $0x80107696
801011d7:	e8 b4 f1 ff ff       	call   80100390 <panic>
801011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011e0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
801011e9:	8b 75 08             	mov    0x8(%ebp),%esi
801011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801011ef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801011f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011f6:	8b 45 10             	mov    0x10(%ebp),%eax
801011f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011fc:	0f 84 b2 00 00 00    	je     801012b4 <filewrite+0xd4>
    return -1;
  if(f->type == FD_PIPE)
80101202:	8b 06                	mov    (%esi),%eax
80101204:	83 f8 01             	cmp    $0x1,%eax
80101207:	0f 84 d3 00 00 00    	je     801012e0 <filewrite+0x100>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_MEMO){
8010120d:	83 f8 02             	cmp    $0x2,%eax
80101210:	0f 84 e2 00 00 00    	je     801012f8 <filewrite+0x118>
    safestrcpy(f->memo, addr, n);
    f->memo[n]=0;
    return n;
  }
  if(f->type == FD_INODE){
80101216:	83 f8 03             	cmp    $0x3,%eax
80101219:	0f 85 0c 01 00 00    	jne    8010132b <filewrite+0x14b>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010121f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101222:	31 ff                	xor    %edi,%edi
    while(i < n){
80101224:	85 c0                	test   %eax,%eax
80101226:	7f 33                	jg     8010125b <filewrite+0x7b>
80101228:	e9 9b 00 00 00       	jmp    801012c8 <filewrite+0xe8>
8010122d:	8d 76 00             	lea    0x0(%esi),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101230:	01 46 18             	add    %eax,0x18(%esi)
      iunlock(f->ip);
80101233:	83 ec 0c             	sub    $0xc,%esp
80101236:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101239:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010123c:	e8 5f 07 00 00       	call   801019a0 <iunlock>
      end_op();
80101241:	e8 0a 1c 00 00       	call   80102e50 <end_op>
80101246:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101249:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
8010124c:	39 c3                	cmp    %eax,%ebx
8010124e:	0f 85 ca 00 00 00    	jne    8010131e <filewrite+0x13e>
        panic("short filewrite");
      i += r;
80101254:	01 df                	add    %ebx,%edi
    while(i < n){
80101256:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101259:	7e 6d                	jle    801012c8 <filewrite+0xe8>
      int n1 = n - i;
8010125b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010125e:	b8 00 06 00 00       	mov    $0x600,%eax
80101263:	29 fb                	sub    %edi,%ebx
80101265:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
8010126b:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010126e:	e8 6d 1b 00 00       	call   80102de0 <begin_op>
      ilock(f->ip);
80101273:	83 ec 0c             	sub    $0xc,%esp
80101276:	ff 76 10             	pushl  0x10(%esi)
80101279:	e8 42 06 00 00       	call   801018c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010127e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101281:	53                   	push   %ebx
80101282:	ff 76 18             	pushl  0x18(%esi)
80101285:	01 f8                	add    %edi,%eax
80101287:	50                   	push   %eax
80101288:	ff 76 10             	pushl  0x10(%esi)
8010128b:	e8 10 0a 00 00       	call   80101ca0 <writei>
80101290:	83 c4 20             	add    $0x20,%esp
80101293:	85 c0                	test   %eax,%eax
80101295:	7f 99                	jg     80101230 <filewrite+0x50>
      iunlock(f->ip);
80101297:	83 ec 0c             	sub    $0xc,%esp
8010129a:	ff 76 10             	pushl  0x10(%esi)
8010129d:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012a0:	e8 fb 06 00 00       	call   801019a0 <iunlock>
      end_op();
801012a5:	e8 a6 1b 00 00       	call   80102e50 <end_op>
      if(r < 0)
801012aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801012ad:	83 c4 10             	add    $0x10,%esp
801012b0:	85 c0                	test   %eax,%eax
801012b2:	74 98                	je     8010124c <filewrite+0x6c>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801012b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801012b7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801012bc:	89 f8                	mov    %edi,%eax
801012be:	5b                   	pop    %ebx
801012bf:	5e                   	pop    %esi
801012c0:	5f                   	pop    %edi
801012c1:	5d                   	pop    %ebp
801012c2:	c3                   	ret    
801012c3:	90                   	nop
801012c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801012c8:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801012cb:	75 e7                	jne    801012b4 <filewrite+0xd4>
}
801012cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d0:	89 f8                	mov    %edi,%eax
801012d2:	5b                   	pop    %ebx
801012d3:	5e                   	pop    %esi
801012d4:	5f                   	pop    %edi
801012d5:	5d                   	pop    %ebp
801012d6:	c3                   	ret    
801012d7:	89 f6                	mov    %esi,%esi
801012d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return pipewrite(f->pipe, addr, n);
801012e0:	8b 46 0c             	mov    0xc(%esi),%eax
801012e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e9:	5b                   	pop    %ebx
801012ea:	5e                   	pop    %esi
801012eb:	5f                   	pop    %edi
801012ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012ed:	e9 3e 23 00 00       	jmp    80103630 <pipewrite>
801012f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    safestrcpy(f->memo, addr, n);
801012f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801012fb:	83 ec 04             	sub    $0x4,%esp
801012fe:	57                   	push   %edi
801012ff:	ff 75 dc             	pushl  -0x24(%ebp)
80101302:	ff 76 14             	pushl  0x14(%esi)
80101305:	e8 06 38 00 00       	call   80104b10 <safestrcpy>
    f->memo[n]=0;
8010130a:	8b 46 14             	mov    0x14(%esi),%eax
    return n;
8010130d:	83 c4 10             	add    $0x10,%esp
    f->memo[n]=0;
80101310:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
}
80101314:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101317:	89 f8                	mov    %edi,%eax
80101319:	5b                   	pop    %ebx
8010131a:	5e                   	pop    %esi
8010131b:	5f                   	pop    %edi
8010131c:	5d                   	pop    %ebp
8010131d:	c3                   	ret    
        panic("short filewrite");
8010131e:	83 ec 0c             	sub    $0xc,%esp
80101321:	68 9f 76 10 80       	push   $0x8010769f
80101326:	e8 65 f0 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010132b:	83 ec 0c             	sub    $0xc,%esp
8010132e:	68 a5 76 10 80       	push   $0x801076a5
80101333:	e8 58 f0 ff ff       	call   80100390 <panic>
80101338:	66 90                	xchg   %ax,%ax
8010133a:	66 90                	xchg   %ax,%ax
8010133c:	66 90                	xchg   %ax,%ax
8010133e:	66 90                	xchg   %ax,%ax

80101340 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	56                   	push   %esi
80101345:	53                   	push   %ebx
80101346:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101349:	8b 0d c0 1b 11 80    	mov    0x80111bc0,%ecx
{
8010134f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101352:	85 c9                	test   %ecx,%ecx
80101354:	0f 84 87 00 00 00    	je     801013e1 <balloc+0xa1>
8010135a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101361:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101364:	83 ec 08             	sub    $0x8,%esp
80101367:	89 f0                	mov    %esi,%eax
80101369:	c1 f8 0c             	sar    $0xc,%eax
8010136c:	03 05 d8 1b 11 80    	add    0x80111bd8,%eax
80101372:	50                   	push   %eax
80101373:	ff 75 d8             	pushl  -0x28(%ebp)
80101376:	e8 55 ed ff ff       	call   801000d0 <bread>
8010137b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010137e:	a1 c0 1b 11 80       	mov    0x80111bc0,%eax
80101383:	83 c4 10             	add    $0x10,%esp
80101386:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101389:	31 c0                	xor    %eax,%eax
8010138b:	eb 2f                	jmp    801013bc <balloc+0x7c>
8010138d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101390:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101392:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101395:	bb 01 00 00 00       	mov    $0x1,%ebx
8010139a:	83 e1 07             	and    $0x7,%ecx
8010139d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010139f:	89 c1                	mov    %eax,%ecx
801013a1:	c1 f9 03             	sar    $0x3,%ecx
801013a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013a9:	85 df                	test   %ebx,%edi
801013ab:	89 fa                	mov    %edi,%edx
801013ad:	74 41                	je     801013f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013af:	83 c0 01             	add    $0x1,%eax
801013b2:	83 c6 01             	add    $0x1,%esi
801013b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801013ba:	74 05                	je     801013c1 <balloc+0x81>
801013bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801013bf:	77 cf                	ja     80101390 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801013c1:	83 ec 0c             	sub    $0xc,%esp
801013c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801013c7:	e8 14 ee ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801013cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801013d3:	83 c4 10             	add    $0x10,%esp
801013d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013d9:	39 05 c0 1b 11 80    	cmp    %eax,0x80111bc0
801013df:	77 80                	ja     80101361 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801013e1:	83 ec 0c             	sub    $0xc,%esp
801013e4:	68 af 76 10 80       	push   $0x801076af
801013e9:	e8 a2 ef ff ff       	call   80100390 <panic>
801013ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801013f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801013f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801013f6:	09 da                	or     %ebx,%edx
801013f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801013fc:	57                   	push   %edi
801013fd:	e8 ae 1b 00 00       	call   80102fb0 <log_write>
        brelse(bp);
80101402:	89 3c 24             	mov    %edi,(%esp)
80101405:	e8 d6 ed ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010140a:	58                   	pop    %eax
8010140b:	5a                   	pop    %edx
8010140c:	56                   	push   %esi
8010140d:	ff 75 d8             	pushl  -0x28(%ebp)
80101410:	e8 bb ec ff ff       	call   801000d0 <bread>
80101415:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101417:	8d 40 5c             	lea    0x5c(%eax),%eax
8010141a:	83 c4 0c             	add    $0xc,%esp
8010141d:	68 00 02 00 00       	push   $0x200
80101422:	6a 00                	push   $0x0
80101424:	50                   	push   %eax
80101425:	e8 06 35 00 00       	call   80104930 <memset>
  log_write(bp);
8010142a:	89 1c 24             	mov    %ebx,(%esp)
8010142d:	e8 7e 1b 00 00       	call   80102fb0 <log_write>
  brelse(bp);
80101432:	89 1c 24             	mov    %ebx,(%esp)
80101435:	e8 a6 ed ff ff       	call   801001e0 <brelse>
}
8010143a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010143d:	89 f0                	mov    %esi,%eax
8010143f:	5b                   	pop    %ebx
80101440:	5e                   	pop    %esi
80101441:	5f                   	pop    %edi
80101442:	5d                   	pop    %ebp
80101443:	c3                   	ret    
80101444:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010144a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101450 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	53                   	push   %ebx
80101456:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101458:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010145a:	bb 14 1c 11 80       	mov    $0x80111c14,%ebx
{
8010145f:	83 ec 28             	sub    $0x28,%esp
80101462:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101465:	68 e0 1b 11 80       	push   $0x80111be0
8010146a:	e8 41 33 00 00       	call   801047b0 <acquire>
8010146f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101472:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101475:	eb 17                	jmp    8010148e <iget+0x3e>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101480:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101486:	81 fb 34 38 11 80    	cmp    $0x80113834,%ebx
8010148c:	73 22                	jae    801014b0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010148e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101491:	85 c9                	test   %ecx,%ecx
80101493:	7e 04                	jle    80101499 <iget+0x49>
80101495:	39 3b                	cmp    %edi,(%ebx)
80101497:	74 4f                	je     801014e8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101499:	85 f6                	test   %esi,%esi
8010149b:	75 e3                	jne    80101480 <iget+0x30>
8010149d:	85 c9                	test   %ecx,%ecx
8010149f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014a2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a8:	81 fb 34 38 11 80    	cmp    $0x80113834,%ebx
801014ae:	72 de                	jb     8010148e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801014b0:	85 f6                	test   %esi,%esi
801014b2:	74 5b                	je     8010150f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801014b4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801014b7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801014b9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801014bc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801014c3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801014ca:	68 e0 1b 11 80       	push   $0x80111be0
801014cf:	e8 fc 33 00 00       	call   801048d0 <release>

  return ip;
801014d4:	83 c4 10             	add    $0x10,%esp
}
801014d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014da:	89 f0                	mov    %esi,%eax
801014dc:	5b                   	pop    %ebx
801014dd:	5e                   	pop    %esi
801014de:	5f                   	pop    %edi
801014df:	5d                   	pop    %ebp
801014e0:	c3                   	ret    
801014e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014e8:	39 53 04             	cmp    %edx,0x4(%ebx)
801014eb:	75 ac                	jne    80101499 <iget+0x49>
      release(&icache.lock);
801014ed:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801014f0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801014f3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801014f5:	68 e0 1b 11 80       	push   $0x80111be0
      ip->ref++;
801014fa:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801014fd:	e8 ce 33 00 00       	call   801048d0 <release>
      return ip;
80101502:	83 c4 10             	add    $0x10,%esp
}
80101505:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101508:	89 f0                	mov    %esi,%eax
8010150a:	5b                   	pop    %ebx
8010150b:	5e                   	pop    %esi
8010150c:	5f                   	pop    %edi
8010150d:	5d                   	pop    %ebp
8010150e:	c3                   	ret    
    panic("iget: no inodes");
8010150f:	83 ec 0c             	sub    $0xc,%esp
80101512:	68 c5 76 10 80       	push   $0x801076c5
80101517:	e8 74 ee ff ff       	call   80100390 <panic>
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	89 c6                	mov    %eax,%esi
80101528:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010152b:	83 fa 0b             	cmp    $0xb,%edx
8010152e:	77 18                	ja     80101548 <bmap+0x28>
80101530:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101533:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101536:	85 db                	test   %ebx,%ebx
80101538:	74 76                	je     801015b0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010153a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010153d:	89 d8                	mov    %ebx,%eax
8010153f:	5b                   	pop    %ebx
80101540:	5e                   	pop    %esi
80101541:	5f                   	pop    %edi
80101542:	5d                   	pop    %ebp
80101543:	c3                   	ret    
80101544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101548:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010154b:	83 fb 7f             	cmp    $0x7f,%ebx
8010154e:	0f 87 90 00 00 00    	ja     801015e4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101554:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010155a:	8b 00                	mov    (%eax),%eax
8010155c:	85 d2                	test   %edx,%edx
8010155e:	74 70                	je     801015d0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101560:	83 ec 08             	sub    $0x8,%esp
80101563:	52                   	push   %edx
80101564:	50                   	push   %eax
80101565:	e8 66 eb ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010156a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010156e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101571:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101573:	8b 1a                	mov    (%edx),%ebx
80101575:	85 db                	test   %ebx,%ebx
80101577:	75 1d                	jne    80101596 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101579:	8b 06                	mov    (%esi),%eax
8010157b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010157e:	e8 bd fd ff ff       	call   80101340 <balloc>
80101583:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101586:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101589:	89 c3                	mov    %eax,%ebx
8010158b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010158d:	57                   	push   %edi
8010158e:	e8 1d 1a 00 00       	call   80102fb0 <log_write>
80101593:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101596:	83 ec 0c             	sub    $0xc,%esp
80101599:	57                   	push   %edi
8010159a:	e8 41 ec ff ff       	call   801001e0 <brelse>
8010159f:	83 c4 10             	add    $0x10,%esp
}
801015a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015a5:	89 d8                	mov    %ebx,%eax
801015a7:	5b                   	pop    %ebx
801015a8:	5e                   	pop    %esi
801015a9:	5f                   	pop    %edi
801015aa:	5d                   	pop    %ebp
801015ab:	c3                   	ret    
801015ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801015b0:	8b 00                	mov    (%eax),%eax
801015b2:	e8 89 fd ff ff       	call   80101340 <balloc>
801015b7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801015ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801015bd:	89 c3                	mov    %eax,%ebx
}
801015bf:	89 d8                	mov    %ebx,%eax
801015c1:	5b                   	pop    %ebx
801015c2:	5e                   	pop    %esi
801015c3:	5f                   	pop    %edi
801015c4:	5d                   	pop    %ebp
801015c5:	c3                   	ret    
801015c6:	8d 76 00             	lea    0x0(%esi),%esi
801015c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015d0:	e8 6b fd ff ff       	call   80101340 <balloc>
801015d5:	89 c2                	mov    %eax,%edx
801015d7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015dd:	8b 06                	mov    (%esi),%eax
801015df:	e9 7c ff ff ff       	jmp    80101560 <bmap+0x40>
  panic("bmap: out of range");
801015e4:	83 ec 0c             	sub    $0xc,%esp
801015e7:	68 d5 76 10 80       	push   $0x801076d5
801015ec:	e8 9f ed ff ff       	call   80100390 <panic>
801015f1:	eb 0d                	jmp    80101600 <readsb>
801015f3:	90                   	nop
801015f4:	90                   	nop
801015f5:	90                   	nop
801015f6:	90                   	nop
801015f7:	90                   	nop
801015f8:	90                   	nop
801015f9:	90                   	nop
801015fa:	90                   	nop
801015fb:	90                   	nop
801015fc:	90                   	nop
801015fd:	90                   	nop
801015fe:	90                   	nop
801015ff:	90                   	nop

80101600 <readsb>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101608:	83 ec 08             	sub    $0x8,%esp
8010160b:	6a 01                	push   $0x1
8010160d:	ff 75 08             	pushl  0x8(%ebp)
80101610:	e8 bb ea ff ff       	call   801000d0 <bread>
80101615:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101617:	8d 40 5c             	lea    0x5c(%eax),%eax
8010161a:	83 c4 0c             	add    $0xc,%esp
8010161d:	6a 1c                	push   $0x1c
8010161f:	50                   	push   %eax
80101620:	56                   	push   %esi
80101621:	e8 ba 33 00 00       	call   801049e0 <memmove>
  brelse(bp);
80101626:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101629:	83 c4 10             	add    $0x10,%esp
}
8010162c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010162f:	5b                   	pop    %ebx
80101630:	5e                   	pop    %esi
80101631:	5d                   	pop    %ebp
  brelse(bp);
80101632:	e9 a9 eb ff ff       	jmp    801001e0 <brelse>
80101637:	89 f6                	mov    %esi,%esi
80101639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101640 <bfree>:
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	56                   	push   %esi
80101644:	53                   	push   %ebx
80101645:	89 d3                	mov    %edx,%ebx
80101647:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101649:	83 ec 08             	sub    $0x8,%esp
8010164c:	68 c0 1b 11 80       	push   $0x80111bc0
80101651:	50                   	push   %eax
80101652:	e8 a9 ff ff ff       	call   80101600 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101657:	58                   	pop    %eax
80101658:	5a                   	pop    %edx
80101659:	89 da                	mov    %ebx,%edx
8010165b:	c1 ea 0c             	shr    $0xc,%edx
8010165e:	03 15 d8 1b 11 80    	add    0x80111bd8,%edx
80101664:	52                   	push   %edx
80101665:	56                   	push   %esi
80101666:	e8 65 ea ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010166b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010166d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101670:	ba 01 00 00 00       	mov    $0x1,%edx
80101675:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101678:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010167e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101681:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101683:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101688:	85 d1                	test   %edx,%ecx
8010168a:	74 25                	je     801016b1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010168c:	f7 d2                	not    %edx
8010168e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101690:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101693:	21 ca                	and    %ecx,%edx
80101695:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101699:	56                   	push   %esi
8010169a:	e8 11 19 00 00       	call   80102fb0 <log_write>
  brelse(bp);
8010169f:	89 34 24             	mov    %esi,(%esp)
801016a2:	e8 39 eb ff ff       	call   801001e0 <brelse>
}
801016a7:	83 c4 10             	add    $0x10,%esp
801016aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016ad:	5b                   	pop    %ebx
801016ae:	5e                   	pop    %esi
801016af:	5d                   	pop    %ebp
801016b0:	c3                   	ret    
    panic("freeing free block");
801016b1:	83 ec 0c             	sub    $0xc,%esp
801016b4:	68 e8 76 10 80       	push   $0x801076e8
801016b9:	e8 d2 ec ff ff       	call   80100390 <panic>
801016be:	66 90                	xchg   %ax,%ax

801016c0 <iinit>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	53                   	push   %ebx
801016c4:	bb 20 1c 11 80       	mov    $0x80111c20,%ebx
801016c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801016cc:	68 fb 76 10 80       	push   $0x801076fb
801016d1:	68 e0 1b 11 80       	push   $0x80111be0
801016d6:	e8 e5 2f 00 00       	call   801046c0 <initlock>
801016db:	83 c4 10             	add    $0x10,%esp
801016de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801016e0:	83 ec 08             	sub    $0x8,%esp
801016e3:	68 02 77 10 80       	push   $0x80107702
801016e8:	53                   	push   %ebx
801016e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016ef:	e8 bc 2e 00 00       	call   801045b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016f4:	83 c4 10             	add    $0x10,%esp
801016f7:	81 fb 40 38 11 80    	cmp    $0x80113840,%ebx
801016fd:	75 e1                	jne    801016e0 <iinit+0x20>
  readsb(dev, &sb);
801016ff:	83 ec 08             	sub    $0x8,%esp
80101702:	68 c0 1b 11 80       	push   $0x80111bc0
80101707:	ff 75 08             	pushl  0x8(%ebp)
8010170a:	e8 f1 fe ff ff       	call   80101600 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010170f:	ff 35 d8 1b 11 80    	pushl  0x80111bd8
80101715:	ff 35 d4 1b 11 80    	pushl  0x80111bd4
8010171b:	ff 35 d0 1b 11 80    	pushl  0x80111bd0
80101721:	ff 35 cc 1b 11 80    	pushl  0x80111bcc
80101727:	ff 35 c8 1b 11 80    	pushl  0x80111bc8
8010172d:	ff 35 c4 1b 11 80    	pushl  0x80111bc4
80101733:	ff 35 c0 1b 11 80    	pushl  0x80111bc0
80101739:	68 68 77 10 80       	push   $0x80107768
8010173e:	e8 9d ef ff ff       	call   801006e0 <cprintf>
}
80101743:	83 c4 30             	add    $0x30,%esp
80101746:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101749:	c9                   	leave  
8010174a:	c3                   	ret    
8010174b:	90                   	nop
8010174c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101750 <ialloc>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	57                   	push   %edi
80101754:	56                   	push   %esi
80101755:	53                   	push   %ebx
80101756:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101759:	83 3d c8 1b 11 80 01 	cmpl   $0x1,0x80111bc8
{
80101760:	8b 45 0c             	mov    0xc(%ebp),%eax
80101763:	8b 75 08             	mov    0x8(%ebp),%esi
80101766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101769:	0f 86 91 00 00 00    	jbe    80101800 <ialloc+0xb0>
8010176f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101774:	eb 21                	jmp    80101797 <ialloc+0x47>
80101776:	8d 76 00             	lea    0x0(%esi),%esi
80101779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101780:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101783:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101786:	57                   	push   %edi
80101787:	e8 54 ea ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010178c:	83 c4 10             	add    $0x10,%esp
8010178f:	39 1d c8 1b 11 80    	cmp    %ebx,0x80111bc8
80101795:	76 69                	jbe    80101800 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101797:	89 d8                	mov    %ebx,%eax
80101799:	83 ec 08             	sub    $0x8,%esp
8010179c:	c1 e8 03             	shr    $0x3,%eax
8010179f:	03 05 d4 1b 11 80    	add    0x80111bd4,%eax
801017a5:	50                   	push   %eax
801017a6:	56                   	push   %esi
801017a7:	e8 24 e9 ff ff       	call   801000d0 <bread>
801017ac:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801017ae:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801017b0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801017b3:	83 e0 07             	and    $0x7,%eax
801017b6:	c1 e0 06             	shl    $0x6,%eax
801017b9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017c1:	75 bd                	jne    80101780 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017c3:	83 ec 04             	sub    $0x4,%esp
801017c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017c9:	6a 40                	push   $0x40
801017cb:	6a 00                	push   $0x0
801017cd:	51                   	push   %ecx
801017ce:	e8 5d 31 00 00       	call   80104930 <memset>
      dip->type = type;
801017d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017dd:	89 3c 24             	mov    %edi,(%esp)
801017e0:	e8 cb 17 00 00       	call   80102fb0 <log_write>
      brelse(bp);
801017e5:	89 3c 24             	mov    %edi,(%esp)
801017e8:	e8 f3 e9 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801017ed:	83 c4 10             	add    $0x10,%esp
}
801017f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017f3:	89 da                	mov    %ebx,%edx
801017f5:	89 f0                	mov    %esi,%eax
}
801017f7:	5b                   	pop    %ebx
801017f8:	5e                   	pop    %esi
801017f9:	5f                   	pop    %edi
801017fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801017fb:	e9 50 fc ff ff       	jmp    80101450 <iget>
  panic("ialloc: no inodes");
80101800:	83 ec 0c             	sub    $0xc,%esp
80101803:	68 08 77 10 80       	push   $0x80107708
80101808:	e8 83 eb ff ff       	call   80100390 <panic>
8010180d:	8d 76 00             	lea    0x0(%esi),%esi

80101810 <iupdate>:
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	56                   	push   %esi
80101814:	53                   	push   %ebx
80101815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101818:	83 ec 08             	sub    $0x8,%esp
8010181b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010181e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101821:	c1 e8 03             	shr    $0x3,%eax
80101824:	03 05 d4 1b 11 80    	add    0x80111bd4,%eax
8010182a:	50                   	push   %eax
8010182b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010182e:	e8 9d e8 ff ff       	call   801000d0 <bread>
80101833:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101835:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101838:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010183f:	83 e0 07             	and    $0x7,%eax
80101842:	c1 e0 06             	shl    $0x6,%eax
80101845:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101849:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010184c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101850:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101853:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101857:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010185b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010185f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101863:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101867:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010186a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010186d:	6a 34                	push   $0x34
8010186f:	53                   	push   %ebx
80101870:	50                   	push   %eax
80101871:	e8 6a 31 00 00       	call   801049e0 <memmove>
  log_write(bp);
80101876:	89 34 24             	mov    %esi,(%esp)
80101879:	e8 32 17 00 00       	call   80102fb0 <log_write>
  brelse(bp);
8010187e:	89 75 08             	mov    %esi,0x8(%ebp)
80101881:	83 c4 10             	add    $0x10,%esp
}
80101884:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101887:	5b                   	pop    %ebx
80101888:	5e                   	pop    %esi
80101889:	5d                   	pop    %ebp
  brelse(bp);
8010188a:	e9 51 e9 ff ff       	jmp    801001e0 <brelse>
8010188f:	90                   	nop

80101890 <idup>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	53                   	push   %ebx
80101894:	83 ec 10             	sub    $0x10,%esp
80101897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010189a:	68 e0 1b 11 80       	push   $0x80111be0
8010189f:	e8 0c 2f 00 00       	call   801047b0 <acquire>
  ip->ref++;
801018a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018a8:	c7 04 24 e0 1b 11 80 	movl   $0x80111be0,(%esp)
801018af:	e8 1c 30 00 00       	call   801048d0 <release>
}
801018b4:	89 d8                	mov    %ebx,%eax
801018b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018b9:	c9                   	leave  
801018ba:	c3                   	ret    
801018bb:	90                   	nop
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018c0 <ilock>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	56                   	push   %esi
801018c4:	53                   	push   %ebx
801018c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801018c8:	85 db                	test   %ebx,%ebx
801018ca:	0f 84 b7 00 00 00    	je     80101987 <ilock+0xc7>
801018d0:	8b 53 08             	mov    0x8(%ebx),%edx
801018d3:	85 d2                	test   %edx,%edx
801018d5:	0f 8e ac 00 00 00    	jle    80101987 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018db:	8d 43 0c             	lea    0xc(%ebx),%eax
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	50                   	push   %eax
801018e2:	e8 09 2d 00 00       	call   801045f0 <acquiresleep>
  if(ip->valid == 0){
801018e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018ea:	83 c4 10             	add    $0x10,%esp
801018ed:	85 c0                	test   %eax,%eax
801018ef:	74 0f                	je     80101900 <ilock+0x40>
}
801018f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018f4:	5b                   	pop    %ebx
801018f5:	5e                   	pop    %esi
801018f6:	5d                   	pop    %ebp
801018f7:	c3                   	ret    
801018f8:	90                   	nop
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101900:	8b 43 04             	mov    0x4(%ebx),%eax
80101903:	83 ec 08             	sub    $0x8,%esp
80101906:	c1 e8 03             	shr    $0x3,%eax
80101909:	03 05 d4 1b 11 80    	add    0x80111bd4,%eax
8010190f:	50                   	push   %eax
80101910:	ff 33                	pushl  (%ebx)
80101912:	e8 b9 e7 ff ff       	call   801000d0 <bread>
80101917:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101919:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010191c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010191f:	83 e0 07             	and    $0x7,%eax
80101922:	c1 e0 06             	shl    $0x6,%eax
80101925:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101929:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010192c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010192f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101933:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101937:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010193b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010193f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101943:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101947:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010194b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010194e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101951:	6a 34                	push   $0x34
80101953:	50                   	push   %eax
80101954:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101957:	50                   	push   %eax
80101958:	e8 83 30 00 00       	call   801049e0 <memmove>
    brelse(bp);
8010195d:	89 34 24             	mov    %esi,(%esp)
80101960:	e8 7b e8 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101965:	83 c4 10             	add    $0x10,%esp
80101968:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010196d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101974:	0f 85 77 ff ff ff    	jne    801018f1 <ilock+0x31>
      panic("ilock: no type");
8010197a:	83 ec 0c             	sub    $0xc,%esp
8010197d:	68 20 77 10 80       	push   $0x80107720
80101982:	e8 09 ea ff ff       	call   80100390 <panic>
    panic("ilock");
80101987:	83 ec 0c             	sub    $0xc,%esp
8010198a:	68 1a 77 10 80       	push   $0x8010771a
8010198f:	e8 fc e9 ff ff       	call   80100390 <panic>
80101994:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010199a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801019a0 <iunlock>:
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	56                   	push   %esi
801019a4:	53                   	push   %ebx
801019a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801019a8:	85 db                	test   %ebx,%ebx
801019aa:	74 28                	je     801019d4 <iunlock+0x34>
801019ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801019af:	83 ec 0c             	sub    $0xc,%esp
801019b2:	56                   	push   %esi
801019b3:	e8 d8 2c 00 00       	call   80104690 <holdingsleep>
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	85 c0                	test   %eax,%eax
801019bd:	74 15                	je     801019d4 <iunlock+0x34>
801019bf:	8b 43 08             	mov    0x8(%ebx),%eax
801019c2:	85 c0                	test   %eax,%eax
801019c4:	7e 0e                	jle    801019d4 <iunlock+0x34>
  releasesleep(&ip->lock);
801019c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019cc:	5b                   	pop    %ebx
801019cd:	5e                   	pop    %esi
801019ce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801019cf:	e9 7c 2c 00 00       	jmp    80104650 <releasesleep>
    panic("iunlock");
801019d4:	83 ec 0c             	sub    $0xc,%esp
801019d7:	68 2f 77 10 80       	push   $0x8010772f
801019dc:	e8 af e9 ff ff       	call   80100390 <panic>
801019e1:	eb 0d                	jmp    801019f0 <iput>
801019e3:	90                   	nop
801019e4:	90                   	nop
801019e5:	90                   	nop
801019e6:	90                   	nop
801019e7:	90                   	nop
801019e8:	90                   	nop
801019e9:	90                   	nop
801019ea:	90                   	nop
801019eb:	90                   	nop
801019ec:	90                   	nop
801019ed:	90                   	nop
801019ee:	90                   	nop
801019ef:	90                   	nop

801019f0 <iput>:
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 28             	sub    $0x28,%esp
801019f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019fc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019ff:	57                   	push   %edi
80101a00:	e8 eb 2b 00 00       	call   801045f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a05:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101a08:	83 c4 10             	add    $0x10,%esp
80101a0b:	85 d2                	test   %edx,%edx
80101a0d:	74 07                	je     80101a16 <iput+0x26>
80101a0f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a14:	74 32                	je     80101a48 <iput+0x58>
  releasesleep(&ip->lock);
80101a16:	83 ec 0c             	sub    $0xc,%esp
80101a19:	57                   	push   %edi
80101a1a:	e8 31 2c 00 00       	call   80104650 <releasesleep>
  acquire(&icache.lock);
80101a1f:	c7 04 24 e0 1b 11 80 	movl   $0x80111be0,(%esp)
80101a26:	e8 85 2d 00 00       	call   801047b0 <acquire>
  ip->ref--;
80101a2b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a2f:	83 c4 10             	add    $0x10,%esp
80101a32:	c7 45 08 e0 1b 11 80 	movl   $0x80111be0,0x8(%ebp)
}
80101a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3c:	5b                   	pop    %ebx
80101a3d:	5e                   	pop    %esi
80101a3e:	5f                   	pop    %edi
80101a3f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a40:	e9 8b 2e 00 00       	jmp    801048d0 <release>
80101a45:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a48:	83 ec 0c             	sub    $0xc,%esp
80101a4b:	68 e0 1b 11 80       	push   $0x80111be0
80101a50:	e8 5b 2d 00 00       	call   801047b0 <acquire>
    int r = ip->ref;
80101a55:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a58:	c7 04 24 e0 1b 11 80 	movl   $0x80111be0,(%esp)
80101a5f:	e8 6c 2e 00 00       	call   801048d0 <release>
    if(r == 1){
80101a64:	83 c4 10             	add    $0x10,%esp
80101a67:	83 fe 01             	cmp    $0x1,%esi
80101a6a:	75 aa                	jne    80101a16 <iput+0x26>
80101a6c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a72:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a75:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a78:	89 cf                	mov    %ecx,%edi
80101a7a:	eb 0b                	jmp    80101a87 <iput+0x97>
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a80:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a83:	39 fe                	cmp    %edi,%esi
80101a85:	74 19                	je     80101aa0 <iput+0xb0>
    if(ip->addrs[i]){
80101a87:	8b 16                	mov    (%esi),%edx
80101a89:	85 d2                	test   %edx,%edx
80101a8b:	74 f3                	je     80101a80 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a8d:	8b 03                	mov    (%ebx),%eax
80101a8f:	e8 ac fb ff ff       	call   80101640 <bfree>
      ip->addrs[i] = 0;
80101a94:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a9a:	eb e4                	jmp    80101a80 <iput+0x90>
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101aa0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101aa6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101aa9:	85 c0                	test   %eax,%eax
80101aab:	75 33                	jne    80101ae0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101aad:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ab0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101ab7:	53                   	push   %ebx
80101ab8:	e8 53 fd ff ff       	call   80101810 <iupdate>
      ip->type = 0;
80101abd:	31 c0                	xor    %eax,%eax
80101abf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101ac3:	89 1c 24             	mov    %ebx,(%esp)
80101ac6:	e8 45 fd ff ff       	call   80101810 <iupdate>
      ip->valid = 0;
80101acb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ad2:	83 c4 10             	add    $0x10,%esp
80101ad5:	e9 3c ff ff ff       	jmp    80101a16 <iput+0x26>
80101ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ae0:	83 ec 08             	sub    $0x8,%esp
80101ae3:	50                   	push   %eax
80101ae4:	ff 33                	pushl  (%ebx)
80101ae6:	e8 e5 e5 ff ff       	call   801000d0 <bread>
80101aeb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101af1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101af7:	8d 70 5c             	lea    0x5c(%eax),%esi
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	89 cf                	mov    %ecx,%edi
80101aff:	eb 0e                	jmp    80101b0f <iput+0x11f>
80101b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b08:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101b0b:	39 fe                	cmp    %edi,%esi
80101b0d:	74 0f                	je     80101b1e <iput+0x12e>
      if(a[j])
80101b0f:	8b 16                	mov    (%esi),%edx
80101b11:	85 d2                	test   %edx,%edx
80101b13:	74 f3                	je     80101b08 <iput+0x118>
        bfree(ip->dev, a[j]);
80101b15:	8b 03                	mov    (%ebx),%eax
80101b17:	e8 24 fb ff ff       	call   80101640 <bfree>
80101b1c:	eb ea                	jmp    80101b08 <iput+0x118>
    brelse(bp);
80101b1e:	83 ec 0c             	sub    $0xc,%esp
80101b21:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b24:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b27:	e8 b4 e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b2c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b32:	8b 03                	mov    (%ebx),%eax
80101b34:	e8 07 fb ff ff       	call   80101640 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b39:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b40:	00 00 00 
80101b43:	83 c4 10             	add    $0x10,%esp
80101b46:	e9 62 ff ff ff       	jmp    80101aad <iput+0xbd>
80101b4b:	90                   	nop
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b50 <iunlockput>:
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	53                   	push   %ebx
80101b54:	83 ec 10             	sub    $0x10,%esp
80101b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101b5a:	53                   	push   %ebx
80101b5b:	e8 40 fe ff ff       	call   801019a0 <iunlock>
  iput(ip);
80101b60:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b63:	83 c4 10             	add    $0x10,%esp
}
80101b66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b69:	c9                   	leave  
  iput(ip);
80101b6a:	e9 81 fe ff ff       	jmp    801019f0 <iput>
80101b6f:	90                   	nop

80101b70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	8b 55 08             	mov    0x8(%ebp),%edx
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b79:	8b 0a                	mov    (%edx),%ecx
80101b7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b93:	8b 52 58             	mov    0x58(%edx),%edx
80101b96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b99:	5d                   	pop    %ebp
80101b9a:	c3                   	ret    
80101b9b:	90                   	nop
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ba0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101baf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bb7:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101bc0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 a7 00 00 00    	je     80101c70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	8b 40 58             	mov    0x58(%eax),%eax
80101bcf:	39 c6                	cmp    %eax,%esi
80101bd1:	0f 87 ba 00 00 00    	ja     80101c91 <readi+0xf1>
80101bd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101bda:	89 f9                	mov    %edi,%ecx
80101bdc:	01 f1                	add    %esi,%ecx
80101bde:	0f 82 ad 00 00 00    	jb     80101c91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101be4:	89 c2                	mov    %eax,%edx
80101be6:	29 f2                	sub    %esi,%edx
80101be8:	39 c8                	cmp    %ecx,%eax
80101bea:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bed:	31 ff                	xor    %edi,%edi
80101bef:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101bf1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bf4:	74 6c                	je     80101c62 <readi+0xc2>
80101bf6:	8d 76 00             	lea    0x0(%esi),%esi
80101bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 d8                	mov    %ebx,%eax
80101c0a:	e8 11 f9 ff ff       	call   80101520 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 33                	pushl  (%ebx)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c1d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1f:	89 f0                	mov    %esi,%eax
80101c21:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c26:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c2b:	83 c4 0c             	add    $0xc,%esp
80101c2e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c30:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101c34:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	29 fb                	sub    %edi,%ebx
80101c39:	39 d9                	cmp    %ebx,%ecx
80101c3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c3e:	53                   	push   %ebx
80101c3f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c40:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101c42:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c45:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c47:	e8 94 2d 00 00       	call   801049e0 <memmove>
    brelse(bp);
80101c4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c4f:	89 14 24             	mov    %edx,(%esp)
80101c52:	e8 89 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c5a:	83 c4 10             	add    $0x10,%esp
80101c5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c60:	77 9e                	ja     80101c00 <readi+0x60>
  }
  return n;
80101c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c68:	5b                   	pop    %ebx
80101c69:	5e                   	pop    %esi
80101c6a:	5f                   	pop    %edi
80101c6b:	5d                   	pop    %ebp
80101c6c:	c3                   	ret    
80101c6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 17                	ja     80101c91 <readi+0xf1>
80101c7a:	8b 04 c5 60 1b 11 80 	mov    -0x7feee4a0(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 0c                	je     80101c91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c8f:	ff e0                	jmp    *%eax
      return -1;
80101c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c96:	eb cd                	jmp    80101c65 <readi+0xc5>
80101c98:	90                   	nop
80101c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ca0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	83 ec 1c             	sub    $0x1c,%esp
80101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101caf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101cc0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101cc3:	0f 84 b7 00 00 00    	je     80101d80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101cc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ccc:	39 70 58             	cmp    %esi,0x58(%eax)
80101ccf:	0f 82 eb 00 00 00    	jb     80101dc0 <writei+0x120>
80101cd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cd8:	31 d2                	xor    %edx,%edx
80101cda:	89 f8                	mov    %edi,%eax
80101cdc:	01 f0                	add    %esi,%eax
80101cde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ce1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ce6:	0f 87 d4 00 00 00    	ja     80101dc0 <writei+0x120>
80101cec:	85 d2                	test   %edx,%edx
80101cee:	0f 85 cc 00 00 00    	jne    80101dc0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cf4:	85 ff                	test   %edi,%edi
80101cf6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cfd:	74 72                	je     80101d71 <writei+0xd1>
80101cff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d03:	89 f2                	mov    %esi,%edx
80101d05:	c1 ea 09             	shr    $0x9,%edx
80101d08:	89 f8                	mov    %edi,%eax
80101d0a:	e8 11 f8 ff ff       	call   80101520 <bmap>
80101d0f:	83 ec 08             	sub    $0x8,%esp
80101d12:	50                   	push   %eax
80101d13:	ff 37                	pushl  (%edi)
80101d15:	e8 b6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d1a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d1d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d20:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d22:	89 f0                	mov    %esi,%eax
80101d24:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d29:	83 c4 0c             	add    $0xc,%esp
80101d2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d37:	39 d9                	cmp    %ebx,%ecx
80101d39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d3c:	53                   	push   %ebx
80101d3d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d40:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d42:	50                   	push   %eax
80101d43:	e8 98 2c 00 00       	call   801049e0 <memmove>
    log_write(bp);
80101d48:	89 3c 24             	mov    %edi,(%esp)
80101d4b:	e8 60 12 00 00       	call   80102fb0 <log_write>
    brelse(bp);
80101d50:	89 3c 24             	mov    %edi,(%esp)
80101d53:	e8 88 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d5b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d5e:	83 c4 10             	add    $0x10,%esp
80101d61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d67:	77 97                	ja     80101d00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d6f:	77 37                	ja     80101da8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d77:	5b                   	pop    %ebx
80101d78:	5e                   	pop    %esi
80101d79:	5f                   	pop    %edi
80101d7a:	5d                   	pop    %ebp
80101d7b:	c3                   	ret    
80101d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d84:	66 83 f8 09          	cmp    $0x9,%ax
80101d88:	77 36                	ja     80101dc0 <writei+0x120>
80101d8a:	8b 04 c5 64 1b 11 80 	mov    -0x7feee49c(,%eax,8),%eax
80101d91:	85 c0                	test   %eax,%eax
80101d93:	74 2b                	je     80101dc0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101d95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d9b:	5b                   	pop    %ebx
80101d9c:	5e                   	pop    %esi
80101d9d:	5f                   	pop    %edi
80101d9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d9f:	ff e0                	jmp    *%eax
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101da8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101dab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101db1:	50                   	push   %eax
80101db2:	e8 59 fa ff ff       	call   80101810 <iupdate>
80101db7:	83 c4 10             	add    $0x10,%esp
80101dba:	eb b5                	jmp    80101d71 <writei+0xd1>
80101dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dc5:	eb ad                	jmp    80101d74 <writei+0xd4>
80101dc7:	89 f6                	mov    %esi,%esi
80101dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101dd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101dd6:	6a 0e                	push   $0xe
80101dd8:	ff 75 0c             	pushl  0xc(%ebp)
80101ddb:	ff 75 08             	pushl  0x8(%ebp)
80101dde:	e8 6d 2c 00 00       	call   80104a50 <strncmp>
}
80101de3:	c9                   	leave  
80101de4:	c3                   	ret    
80101de5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101df0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 1c             	sub    $0x1c,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e01:	0f 85 85 00 00 00    	jne    80101e8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e07:	8b 53 58             	mov    0x58(%ebx),%edx
80101e0a:	31 ff                	xor    %edi,%edi
80101e0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e0f:	85 d2                	test   %edx,%edx
80101e11:	74 3e                	je     80101e51 <dirlookup+0x61>
80101e13:	90                   	nop
80101e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e18:	6a 10                	push   $0x10
80101e1a:	57                   	push   %edi
80101e1b:	56                   	push   %esi
80101e1c:	53                   	push   %ebx
80101e1d:	e8 7e fd ff ff       	call   80101ba0 <readi>
80101e22:	83 c4 10             	add    $0x10,%esp
80101e25:	83 f8 10             	cmp    $0x10,%eax
80101e28:	75 55                	jne    80101e7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e2f:	74 18                	je     80101e49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e34:	83 ec 04             	sub    $0x4,%esp
80101e37:	6a 0e                	push   $0xe
80101e39:	50                   	push   %eax
80101e3a:	ff 75 0c             	pushl  0xc(%ebp)
80101e3d:	e8 0e 2c 00 00       	call   80104a50 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	85 c0                	test   %eax,%eax
80101e47:	74 17                	je     80101e60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e49:	83 c7 10             	add    $0x10,%edi
80101e4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e4f:	72 c7                	jb     80101e18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e54:	31 c0                	xor    %eax,%eax
}
80101e56:	5b                   	pop    %ebx
80101e57:	5e                   	pop    %esi
80101e58:	5f                   	pop    %edi
80101e59:	5d                   	pop    %ebp
80101e5a:	c3                   	ret    
80101e5b:	90                   	nop
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101e60:	8b 45 10             	mov    0x10(%ebp),%eax
80101e63:	85 c0                	test   %eax,%eax
80101e65:	74 05                	je     80101e6c <dirlookup+0x7c>
        *poff = off;
80101e67:	8b 45 10             	mov    0x10(%ebp),%eax
80101e6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e70:	8b 03                	mov    (%ebx),%eax
80101e72:	e8 d9 f5 ff ff       	call   80101450 <iget>
}
80101e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e7a:	5b                   	pop    %ebx
80101e7b:	5e                   	pop    %esi
80101e7c:	5f                   	pop    %edi
80101e7d:	5d                   	pop    %ebp
80101e7e:	c3                   	ret    
      panic("dirlookup read");
80101e7f:	83 ec 0c             	sub    $0xc,%esp
80101e82:	68 49 77 10 80       	push   $0x80107749
80101e87:	e8 04 e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101e8c:	83 ec 0c             	sub    $0xc,%esp
80101e8f:	68 37 77 10 80       	push   $0x80107737
80101e94:	e8 f7 e4 ff ff       	call   80100390 <panic>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ea0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	89 cf                	mov    %ecx,%edi
80101ea8:	89 c3                	mov    %eax,%ebx
80101eaa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ead:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101eb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101eb3:	0f 84 67 01 00 00    	je     80102020 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eb9:	e8 82 1b 00 00       	call   80103a40 <myproc>
  acquire(&icache.lock);
80101ebe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ec1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ec4:	68 e0 1b 11 80       	push   $0x80111be0
80101ec9:	e8 e2 28 00 00       	call   801047b0 <acquire>
  ip->ref++;
80101ece:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ed2:	c7 04 24 e0 1b 11 80 	movl   $0x80111be0,(%esp)
80101ed9:	e8 f2 29 00 00       	call   801048d0 <release>
80101ede:	83 c4 10             	add    $0x10,%esp
80101ee1:	eb 08                	jmp    80101eeb <namex+0x4b>
80101ee3:	90                   	nop
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ee8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eeb:	0f b6 03             	movzbl (%ebx),%eax
80101eee:	3c 2f                	cmp    $0x2f,%al
80101ef0:	74 f6                	je     80101ee8 <namex+0x48>
  if(*path == 0)
80101ef2:	84 c0                	test   %al,%al
80101ef4:	0f 84 ee 00 00 00    	je     80101fe8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101efa:	0f b6 03             	movzbl (%ebx),%eax
80101efd:	3c 2f                	cmp    $0x2f,%al
80101eff:	0f 84 b3 00 00 00    	je     80101fb8 <namex+0x118>
80101f05:	84 c0                	test   %al,%al
80101f07:	89 da                	mov    %ebx,%edx
80101f09:	75 09                	jne    80101f14 <namex+0x74>
80101f0b:	e9 a8 00 00 00       	jmp    80101fb8 <namex+0x118>
80101f10:	84 c0                	test   %al,%al
80101f12:	74 0a                	je     80101f1e <namex+0x7e>
    path++;
80101f14:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101f17:	0f b6 02             	movzbl (%edx),%eax
80101f1a:	3c 2f                	cmp    $0x2f,%al
80101f1c:	75 f2                	jne    80101f10 <namex+0x70>
80101f1e:	89 d1                	mov    %edx,%ecx
80101f20:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101f22:	83 f9 0d             	cmp    $0xd,%ecx
80101f25:	0f 8e 91 00 00 00    	jle    80101fbc <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101f2b:	83 ec 04             	sub    $0x4,%esp
80101f2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f31:	6a 0e                	push   $0xe
80101f33:	53                   	push   %ebx
80101f34:	57                   	push   %edi
80101f35:	e8 a6 2a 00 00       	call   801049e0 <memmove>
    path++;
80101f3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101f3d:	83 c4 10             	add    $0x10,%esp
    path++;
80101f40:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101f42:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101f45:	75 11                	jne    80101f58 <namex+0xb8>
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101f50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f56:	74 f8                	je     80101f50 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f58:	83 ec 0c             	sub    $0xc,%esp
80101f5b:	56                   	push   %esi
80101f5c:	e8 5f f9 ff ff       	call   801018c0 <ilock>
    if(ip->type != T_DIR){
80101f61:	83 c4 10             	add    $0x10,%esp
80101f64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f69:	0f 85 91 00 00 00    	jne    80102000 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f72:	85 d2                	test   %edx,%edx
80101f74:	74 09                	je     80101f7f <namex+0xdf>
80101f76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f79:	0f 84 b7 00 00 00    	je     80102036 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f7f:	83 ec 04             	sub    $0x4,%esp
80101f82:	6a 00                	push   $0x0
80101f84:	57                   	push   %edi
80101f85:	56                   	push   %esi
80101f86:	e8 65 fe ff ff       	call   80101df0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	74 6e                	je     80102000 <namex+0x160>
  iunlock(ip);
80101f92:	83 ec 0c             	sub    $0xc,%esp
80101f95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f98:	56                   	push   %esi
80101f99:	e8 02 fa ff ff       	call   801019a0 <iunlock>
  iput(ip);
80101f9e:	89 34 24             	mov    %esi,(%esp)
80101fa1:	e8 4a fa ff ff       	call   801019f0 <iput>
80101fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	89 c6                	mov    %eax,%esi
80101fae:	e9 38 ff ff ff       	jmp    80101eeb <namex+0x4b>
80101fb3:	90                   	nop
80101fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101fb8:	89 da                	mov    %ebx,%edx
80101fba:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101fbc:	83 ec 04             	sub    $0x4,%esp
80101fbf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101fc2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101fc5:	51                   	push   %ecx
80101fc6:	53                   	push   %ebx
80101fc7:	57                   	push   %edi
80101fc8:	e8 13 2a 00 00       	call   801049e0 <memmove>
    name[len] = 0;
80101fcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fd3:	83 c4 10             	add    $0x10,%esp
80101fd6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101fda:	89 d3                	mov    %edx,%ebx
80101fdc:	e9 61 ff ff ff       	jmp    80101f42 <namex+0xa2>
80101fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101fe8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101feb:	85 c0                	test   %eax,%eax
80101fed:	75 5d                	jne    8010204c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101fef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff2:	89 f0                	mov    %esi,%eax
80101ff4:	5b                   	pop    %ebx
80101ff5:	5e                   	pop    %esi
80101ff6:	5f                   	pop    %edi
80101ff7:	5d                   	pop    %ebp
80101ff8:	c3                   	ret    
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102000:	83 ec 0c             	sub    $0xc,%esp
80102003:	56                   	push   %esi
80102004:	e8 97 f9 ff ff       	call   801019a0 <iunlock>
  iput(ip);
80102009:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010200c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010200e:	e8 dd f9 ff ff       	call   801019f0 <iput>
      return 0;
80102013:	83 c4 10             	add    $0x10,%esp
}
80102016:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102019:	89 f0                	mov    %esi,%eax
8010201b:	5b                   	pop    %ebx
8010201c:	5e                   	pop    %esi
8010201d:	5f                   	pop    %edi
8010201e:	5d                   	pop    %ebp
8010201f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102020:	ba 01 00 00 00       	mov    $0x1,%edx
80102025:	b8 01 00 00 00       	mov    $0x1,%eax
8010202a:	e8 21 f4 ff ff       	call   80101450 <iget>
8010202f:	89 c6                	mov    %eax,%esi
80102031:	e9 b5 fe ff ff       	jmp    80101eeb <namex+0x4b>
      iunlock(ip);
80102036:	83 ec 0c             	sub    $0xc,%esp
80102039:	56                   	push   %esi
8010203a:	e8 61 f9 ff ff       	call   801019a0 <iunlock>
      return ip;
8010203f:	83 c4 10             	add    $0x10,%esp
}
80102042:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102045:	89 f0                	mov    %esi,%eax
80102047:	5b                   	pop    %ebx
80102048:	5e                   	pop    %esi
80102049:	5f                   	pop    %edi
8010204a:	5d                   	pop    %ebp
8010204b:	c3                   	ret    
    iput(ip);
8010204c:	83 ec 0c             	sub    $0xc,%esp
8010204f:	56                   	push   %esi
    return 0;
80102050:	31 f6                	xor    %esi,%esi
    iput(ip);
80102052:	e8 99 f9 ff ff       	call   801019f0 <iput>
    return 0;
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	eb 93                	jmp    80101fef <namex+0x14f>
8010205c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102060 <dirlink>:
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 20             	sub    $0x20,%esp
80102069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010206c:	6a 00                	push   $0x0
8010206e:	ff 75 0c             	pushl  0xc(%ebp)
80102071:	53                   	push   %ebx
80102072:	e8 79 fd ff ff       	call   80101df0 <dirlookup>
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	85 c0                	test   %eax,%eax
8010207c:	75 67                	jne    801020e5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010207e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102081:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102084:	85 ff                	test   %edi,%edi
80102086:	74 29                	je     801020b1 <dirlink+0x51>
80102088:	31 ff                	xor    %edi,%edi
8010208a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010208d:	eb 09                	jmp    80102098 <dirlink+0x38>
8010208f:	90                   	nop
80102090:	83 c7 10             	add    $0x10,%edi
80102093:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102096:	73 19                	jae    801020b1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102098:	6a 10                	push   $0x10
8010209a:	57                   	push   %edi
8010209b:	56                   	push   %esi
8010209c:	53                   	push   %ebx
8010209d:	e8 fe fa ff ff       	call   80101ba0 <readi>
801020a2:	83 c4 10             	add    $0x10,%esp
801020a5:	83 f8 10             	cmp    $0x10,%eax
801020a8:	75 4e                	jne    801020f8 <dirlink+0x98>
    if(de.inum == 0)
801020aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020af:	75 df                	jne    80102090 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801020b1:	8d 45 da             	lea    -0x26(%ebp),%eax
801020b4:	83 ec 04             	sub    $0x4,%esp
801020b7:	6a 0e                	push   $0xe
801020b9:	ff 75 0c             	pushl  0xc(%ebp)
801020bc:	50                   	push   %eax
801020bd:	e8 ee 29 00 00       	call   80104ab0 <strncpy>
  de.inum = inum;
801020c2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020c5:	6a 10                	push   $0x10
801020c7:	57                   	push   %edi
801020c8:	56                   	push   %esi
801020c9:	53                   	push   %ebx
  de.inum = inum;
801020ca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ce:	e8 cd fb ff ff       	call   80101ca0 <writei>
801020d3:	83 c4 20             	add    $0x20,%esp
801020d6:	83 f8 10             	cmp    $0x10,%eax
801020d9:	75 2a                	jne    80102105 <dirlink+0xa5>
  return 0;
801020db:	31 c0                	xor    %eax,%eax
}
801020dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e0:	5b                   	pop    %ebx
801020e1:	5e                   	pop    %esi
801020e2:	5f                   	pop    %edi
801020e3:	5d                   	pop    %ebp
801020e4:	c3                   	ret    
    iput(ip);
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	50                   	push   %eax
801020e9:	e8 02 f9 ff ff       	call   801019f0 <iput>
    return -1;
801020ee:	83 c4 10             	add    $0x10,%esp
801020f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020f6:	eb e5                	jmp    801020dd <dirlink+0x7d>
      panic("dirlink read");
801020f8:	83 ec 0c             	sub    $0xc,%esp
801020fb:	68 58 77 10 80       	push   $0x80107758
80102100:	e8 8b e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102105:	83 ec 0c             	sub    $0xc,%esp
80102108:	68 72 7d 10 80       	push   $0x80107d72
8010210d:	e8 7e e2 ff ff       	call   80100390 <panic>
80102112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102120 <namei>:

struct inode*
namei(char *path)
{
80102120:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102121:	31 d2                	xor    %edx,%edx
{
80102123:	89 e5                	mov    %esp,%ebp
80102125:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102128:	8b 45 08             	mov    0x8(%ebp),%eax
8010212b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010212e:	e8 6d fd ff ff       	call   80101ea0 <namex>
}
80102133:	c9                   	leave  
80102134:	c3                   	ret    
80102135:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102140 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102140:	55                   	push   %ebp
  return namex(path, 1, name);
80102141:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102146:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102148:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010214b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010214e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010214f:	e9 4c fd ff ff       	jmp    80101ea0 <namex>
80102154:	66 90                	xchg   %ax,%ax
80102156:	66 90                	xchg   %ax,%ax
80102158:	66 90                	xchg   %ax,%ax
8010215a:	66 90                	xchg   %ax,%ax
8010215c:	66 90                	xchg   %ax,%ax
8010215e:	66 90                	xchg   %ax,%ax

80102160 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102169:	85 c0                	test   %eax,%eax
8010216b:	0f 84 b4 00 00 00    	je     80102225 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102171:	8b 58 08             	mov    0x8(%eax),%ebx
80102174:	89 c6                	mov    %eax,%esi
80102176:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010217c:	0f 87 96 00 00 00    	ja     80102218 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102182:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102187:	89 f6                	mov    %esi,%esi
80102189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102190:	89 ca                	mov    %ecx,%edx
80102192:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102193:	83 e0 c0             	and    $0xffffffc0,%eax
80102196:	3c 40                	cmp    $0x40,%al
80102198:	75 f6                	jne    80102190 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010219a:	31 ff                	xor    %edi,%edi
8010219c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021a1:	89 f8                	mov    %edi,%eax
801021a3:	ee                   	out    %al,(%dx)
801021a4:	b8 01 00 00 00       	mov    $0x1,%eax
801021a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021ae:	ee                   	out    %al,(%dx)
801021af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021b4:	89 d8                	mov    %ebx,%eax
801021b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021b7:	89 d8                	mov    %ebx,%eax
801021b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021be:	c1 f8 08             	sar    $0x8,%eax
801021c1:	ee                   	out    %al,(%dx)
801021c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021c7:	89 f8                	mov    %edi,%eax
801021c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021ca:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801021ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021d3:	c1 e0 04             	shl    $0x4,%eax
801021d6:	83 e0 10             	and    $0x10,%eax
801021d9:	83 c8 e0             	or     $0xffffffe0,%eax
801021dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021dd:	f6 06 04             	testb  $0x4,(%esi)
801021e0:	75 16                	jne    801021f8 <idestart+0x98>
801021e2:	b8 20 00 00 00       	mov    $0x20,%eax
801021e7:	89 ca                	mov    %ecx,%edx
801021e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ed:	5b                   	pop    %ebx
801021ee:	5e                   	pop    %esi
801021ef:	5f                   	pop    %edi
801021f0:	5d                   	pop    %ebp
801021f1:	c3                   	ret    
801021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021f8:	b8 30 00 00 00       	mov    $0x30,%eax
801021fd:	89 ca                	mov    %ecx,%edx
801021ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102200:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102205:	83 c6 5c             	add    $0x5c,%esi
80102208:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010220d:	fc                   	cld    
8010220e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102210:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102213:	5b                   	pop    %ebx
80102214:	5e                   	pop    %esi
80102215:	5f                   	pop    %edi
80102216:	5d                   	pop    %ebp
80102217:	c3                   	ret    
    panic("incorrect blockno");
80102218:	83 ec 0c             	sub    $0xc,%esp
8010221b:	68 c4 77 10 80       	push   $0x801077c4
80102220:	e8 6b e1 ff ff       	call   80100390 <panic>
    panic("idestart");
80102225:	83 ec 0c             	sub    $0xc,%esp
80102228:	68 bb 77 10 80       	push   $0x801077bb
8010222d:	e8 5e e1 ff ff       	call   80100390 <panic>
80102232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102240 <ideinit>:
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102246:	68 d6 77 10 80       	push   $0x801077d6
8010224b:	68 80 b5 10 80       	push   $0x8010b580
80102250:	e8 6b 24 00 00       	call   801046c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102255:	58                   	pop    %eax
80102256:	a1 00 3f 11 80       	mov    0x80113f00,%eax
8010225b:	5a                   	pop    %edx
8010225c:	83 e8 01             	sub    $0x1,%eax
8010225f:	50                   	push   %eax
80102260:	6a 0e                	push   $0xe
80102262:	e8 a9 02 00 00       	call   80102510 <ioapicenable>
80102267:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010226a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	83 e0 c0             	and    $0xffffffc0,%eax
80102274:	3c 40                	cmp    $0x40,%al
80102276:	75 f8                	jne    80102270 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102278:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010227d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102282:	ee                   	out    %al,(%dx)
80102283:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102288:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010228d:	eb 06                	jmp    80102295 <ideinit+0x55>
8010228f:	90                   	nop
  for(i=0; i<1000; i++){
80102290:	83 e9 01             	sub    $0x1,%ecx
80102293:	74 0f                	je     801022a4 <ideinit+0x64>
80102295:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102296:	84 c0                	test   %al,%al
80102298:	74 f6                	je     80102290 <ideinit+0x50>
      havedisk1 = 1;
8010229a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801022a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022ae:	ee                   	out    %al,(%dx)
}
801022af:	c9                   	leave  
801022b0:	c3                   	ret    
801022b1:	eb 0d                	jmp    801022c0 <ideintr>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	57                   	push   %edi
801022c4:	56                   	push   %esi
801022c5:	53                   	push   %ebx
801022c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022c9:	68 80 b5 10 80       	push   $0x8010b580
801022ce:	e8 dd 24 00 00       	call   801047b0 <acquire>

  if((b = idequeue) == 0){
801022d3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801022d9:	83 c4 10             	add    $0x10,%esp
801022dc:	85 db                	test   %ebx,%ebx
801022de:	74 67                	je     80102347 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022e0:	8b 43 58             	mov    0x58(%ebx),%eax
801022e3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022e8:	8b 3b                	mov    (%ebx),%edi
801022ea:	f7 c7 04 00 00 00    	test   $0x4,%edi
801022f0:	75 31                	jne    80102323 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022f2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022f7:	89 f6                	mov    %esi,%esi
801022f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102300:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102301:	89 c6                	mov    %eax,%esi
80102303:	83 e6 c0             	and    $0xffffffc0,%esi
80102306:	89 f1                	mov    %esi,%ecx
80102308:	80 f9 40             	cmp    $0x40,%cl
8010230b:	75 f3                	jne    80102300 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010230d:	a8 21                	test   $0x21,%al
8010230f:	75 12                	jne    80102323 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102311:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102314:	b9 80 00 00 00       	mov    $0x80,%ecx
80102319:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010231e:	fc                   	cld    
8010231f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102321:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102323:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102326:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102329:	89 f9                	mov    %edi,%ecx
8010232b:	83 c9 02             	or     $0x2,%ecx
8010232e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102330:	53                   	push   %ebx
80102331:	e8 fa 20 00 00       	call   80104430 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102336:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010233b:	83 c4 10             	add    $0x10,%esp
8010233e:	85 c0                	test   %eax,%eax
80102340:	74 05                	je     80102347 <ideintr+0x87>
    idestart(idequeue);
80102342:	e8 19 fe ff ff       	call   80102160 <idestart>
    release(&idelock);
80102347:	83 ec 0c             	sub    $0xc,%esp
8010234a:	68 80 b5 10 80       	push   $0x8010b580
8010234f:	e8 7c 25 00 00       	call   801048d0 <release>

  release(&idelock);
}
80102354:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102357:	5b                   	pop    %ebx
80102358:	5e                   	pop    %esi
80102359:	5f                   	pop    %edi
8010235a:	5d                   	pop    %ebp
8010235b:	c3                   	ret    
8010235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102360 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	53                   	push   %ebx
80102364:	83 ec 10             	sub    $0x10,%esp
80102367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010236a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010236d:	50                   	push   %eax
8010236e:	e8 1d 23 00 00       	call   80104690 <holdingsleep>
80102373:	83 c4 10             	add    $0x10,%esp
80102376:	85 c0                	test   %eax,%eax
80102378:	0f 84 c6 00 00 00    	je     80102444 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 e0 06             	and    $0x6,%eax
80102383:	83 f8 02             	cmp    $0x2,%eax
80102386:	0f 84 ab 00 00 00    	je     80102437 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010238c:	8b 53 04             	mov    0x4(%ebx),%edx
8010238f:	85 d2                	test   %edx,%edx
80102391:	74 0d                	je     801023a0 <iderw+0x40>
80102393:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102398:	85 c0                	test   %eax,%eax
8010239a:	0f 84 b1 00 00 00    	je     80102451 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 80 b5 10 80       	push   $0x8010b580
801023a8:	e8 03 24 00 00       	call   801047b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023ad:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801023b3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801023b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023bd:	85 d2                	test   %edx,%edx
801023bf:	75 09                	jne    801023ca <iderw+0x6a>
801023c1:	eb 6d                	jmp    80102430 <iderw+0xd0>
801023c3:	90                   	nop
801023c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c8:	89 c2                	mov    %eax,%edx
801023ca:	8b 42 58             	mov    0x58(%edx),%eax
801023cd:	85 c0                	test   %eax,%eax
801023cf:	75 f7                	jne    801023c8 <iderw+0x68>
801023d1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023d4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023d6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801023dc:	74 42                	je     80102420 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 e0 06             	and    $0x6,%eax
801023e3:	83 f8 02             	cmp    $0x2,%eax
801023e6:	74 23                	je     8010240b <iderw+0xab>
801023e8:	90                   	nop
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801023f0:	83 ec 08             	sub    $0x8,%esp
801023f3:	68 80 b5 10 80       	push   $0x8010b580
801023f8:	53                   	push   %ebx
801023f9:	e8 62 1e 00 00       	call   80104260 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023fe:	8b 03                	mov    (%ebx),%eax
80102400:	83 c4 10             	add    $0x10,%esp
80102403:	83 e0 06             	and    $0x6,%eax
80102406:	83 f8 02             	cmp    $0x2,%eax
80102409:	75 e5                	jne    801023f0 <iderw+0x90>
  }


  release(&idelock);
8010240b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102412:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102415:	c9                   	leave  
  release(&idelock);
80102416:	e9 b5 24 00 00       	jmp    801048d0 <release>
8010241b:	90                   	nop
8010241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102420:	89 d8                	mov    %ebx,%eax
80102422:	e8 39 fd ff ff       	call   80102160 <idestart>
80102427:	eb b5                	jmp    801023de <iderw+0x7e>
80102429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102430:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102435:	eb 9d                	jmp    801023d4 <iderw+0x74>
    panic("iderw: nothing to do");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 f0 77 10 80       	push   $0x801077f0
8010243f:	e8 4c df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102444:	83 ec 0c             	sub    $0xc,%esp
80102447:	68 da 77 10 80       	push   $0x801077da
8010244c:	e8 3f df ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102451:	83 ec 0c             	sub    $0xc,%esp
80102454:	68 05 78 10 80       	push   $0x80107805
80102459:	e8 32 df ff ff       	call   80100390 <panic>
8010245e:	66 90                	xchg   %ax,%ax

80102460 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102460:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102461:	c7 05 34 38 11 80 00 	movl   $0xfec00000,0x80113834
80102468:	00 c0 fe 
{
8010246b:	89 e5                	mov    %esp,%ebp
8010246d:	56                   	push   %esi
8010246e:	53                   	push   %ebx
  ioapic->reg = reg;
8010246f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102476:	00 00 00 
  return ioapic->data;
80102479:	a1 34 38 11 80       	mov    0x80113834,%eax
8010247e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102481:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102487:	8b 0d 34 38 11 80    	mov    0x80113834,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010248d:	0f b6 15 60 39 11 80 	movzbl 0x80113960,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102494:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102497:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010249a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010249d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024a0:	39 c2                	cmp    %eax,%edx
801024a2:	74 16                	je     801024ba <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024a4:	83 ec 0c             	sub    $0xc,%esp
801024a7:	68 24 78 10 80       	push   $0x80107824
801024ac:	e8 2f e2 ff ff       	call   801006e0 <cprintf>
801024b1:	8b 0d 34 38 11 80    	mov    0x80113834,%ecx
801024b7:	83 c4 10             	add    $0x10,%esp
801024ba:	83 c3 21             	add    $0x21,%ebx
{
801024bd:	ba 10 00 00 00       	mov    $0x10,%edx
801024c2:	b8 20 00 00 00       	mov    $0x20,%eax
801024c7:	89 f6                	mov    %esi,%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801024d0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801024d2:	8b 0d 34 38 11 80    	mov    0x80113834,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024d8:	89 c6                	mov    %eax,%esi
801024da:	81 ce 00 00 01 00    	or     $0x10000,%esi
801024e0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024e3:	89 71 10             	mov    %esi,0x10(%ecx)
801024e6:	8d 72 01             	lea    0x1(%edx),%esi
801024e9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801024ec:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801024ee:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801024f0:	8b 0d 34 38 11 80    	mov    0x80113834,%ecx
801024f6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801024fd:	75 d1                	jne    801024d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102502:	5b                   	pop    %ebx
80102503:	5e                   	pop    %esi
80102504:	5d                   	pop    %ebp
80102505:	c3                   	ret    
80102506:	8d 76 00             	lea    0x0(%esi),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102510 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102510:	55                   	push   %ebp
  ioapic->reg = reg;
80102511:	8b 0d 34 38 11 80    	mov    0x80113834,%ecx
{
80102517:	89 e5                	mov    %esp,%ebp
80102519:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010251c:	8d 50 20             	lea    0x20(%eax),%edx
8010251f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102523:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102525:	8b 0d 34 38 11 80    	mov    0x80113834,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010252b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010252e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102531:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102534:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102536:	a1 34 38 11 80       	mov    0x80113834,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010253b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010253e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102541:	5d                   	pop    %ebp
80102542:	c3                   	ret    
80102543:	66 90                	xchg   %ax,%ax
80102545:	66 90                	xchg   %ax,%ax
80102547:	66 90                	xchg   %ax,%ax
80102549:	66 90                	xchg   %ax,%ax
8010254b:	66 90                	xchg   %ax,%ax
8010254d:	66 90                	xchg   %ax,%ax
8010254f:	90                   	nop

80102550 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	53                   	push   %ebx
80102554:	83 ec 04             	sub    $0x4,%esp
80102557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010255a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102560:	75 70                	jne    801025d2 <kfree+0x82>
80102562:	81 fb c8 78 11 80    	cmp    $0x801178c8,%ebx
80102568:	72 68                	jb     801025d2 <kfree+0x82>
8010256a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102570:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102575:	77 5b                	ja     801025d2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102577:	83 ec 04             	sub    $0x4,%esp
8010257a:	68 00 10 00 00       	push   $0x1000
8010257f:	6a 01                	push   $0x1
80102581:	53                   	push   %ebx
80102582:	e8 a9 23 00 00       	call   80104930 <memset>

  if(kmem.use_lock)
80102587:	8b 15 74 38 11 80    	mov    0x80113874,%edx
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	85 d2                	test   %edx,%edx
80102592:	75 2c                	jne    801025c0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102594:	a1 78 38 11 80       	mov    0x80113878,%eax
80102599:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010259b:	a1 74 38 11 80       	mov    0x80113874,%eax
  kmem.freelist = r;
801025a0:	89 1d 78 38 11 80    	mov    %ebx,0x80113878
  if(kmem.use_lock)
801025a6:	85 c0                	test   %eax,%eax
801025a8:	75 06                	jne    801025b0 <kfree+0x60>
    release(&kmem.lock);
}
801025aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025ad:	c9                   	leave  
801025ae:	c3                   	ret    
801025af:	90                   	nop
    release(&kmem.lock);
801025b0:	c7 45 08 40 38 11 80 	movl   $0x80113840,0x8(%ebp)
}
801025b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025ba:	c9                   	leave  
    release(&kmem.lock);
801025bb:	e9 10 23 00 00       	jmp    801048d0 <release>
    acquire(&kmem.lock);
801025c0:	83 ec 0c             	sub    $0xc,%esp
801025c3:	68 40 38 11 80       	push   $0x80113840
801025c8:	e8 e3 21 00 00       	call   801047b0 <acquire>
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	eb c2                	jmp    80102594 <kfree+0x44>
    panic("kfree");
801025d2:	83 ec 0c             	sub    $0xc,%esp
801025d5:	68 56 78 10 80       	push   $0x80107856
801025da:	e8 b1 dd ff ff       	call   80100390 <panic>
801025df:	90                   	nop

801025e0 <freerange>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <freerange+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010260e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 33 ff ff ff       	call   80102550 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 f3                	cmp    %esi,%ebx
80102622:	76 e4                	jbe    80102608 <freerange+0x28>
}
80102624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102627:	5b                   	pop    %ebx
80102628:	5e                   	pop    %esi
80102629:	5d                   	pop    %ebp
8010262a:	c3                   	ret    
8010262b:	90                   	nop
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kinit1>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
80102635:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102638:	83 ec 08             	sub    $0x8,%esp
8010263b:	68 5c 78 10 80       	push   $0x8010785c
80102640:	68 40 38 11 80       	push   $0x80113840
80102645:	e8 76 20 00 00       	call   801046c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102650:	c7 05 74 38 11 80 00 	movl   $0x0,0x80113874
80102657:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010265a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102660:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102666:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010266c:	39 de                	cmp    %ebx,%esi
8010266e:	72 1c                	jb     8010268c <kinit1+0x5c>
    kfree(p);
80102670:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102676:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102679:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010267f:	50                   	push   %eax
80102680:	e8 cb fe ff ff       	call   80102550 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102685:	83 c4 10             	add    $0x10,%esp
80102688:	39 de                	cmp    %ebx,%esi
8010268a:	73 e4                	jae    80102670 <kinit1+0x40>
}
8010268c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010268f:	5b                   	pop    %ebx
80102690:	5e                   	pop    %esi
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <kinit2>:
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	56                   	push   %esi
801026a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801026ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026bd:	39 de                	cmp    %ebx,%esi
801026bf:	72 23                	jb     801026e4 <kinit2+0x44>
801026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026d7:	50                   	push   %eax
801026d8:	e8 73 fe ff ff       	call   80102550 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026dd:	83 c4 10             	add    $0x10,%esp
801026e0:	39 de                	cmp    %ebx,%esi
801026e2:	73 e4                	jae    801026c8 <kinit2+0x28>
  kmem.use_lock = 1;
801026e4:	c7 05 74 38 11 80 01 	movl   $0x1,0x80113874
801026eb:	00 00 00 
}
801026ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026f1:	5b                   	pop    %ebx
801026f2:	5e                   	pop    %esi
801026f3:	5d                   	pop    %ebp
801026f4:	c3                   	ret    
801026f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102700 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102700:	a1 74 38 11 80       	mov    0x80113874,%eax
80102705:	85 c0                	test   %eax,%eax
80102707:	75 1f                	jne    80102728 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102709:	a1 78 38 11 80       	mov    0x80113878,%eax
  if(r)
8010270e:	85 c0                	test   %eax,%eax
80102710:	74 0e                	je     80102720 <kalloc+0x20>
    kmem.freelist = r->next;
80102712:	8b 10                	mov    (%eax),%edx
80102714:	89 15 78 38 11 80    	mov    %edx,0x80113878
8010271a:	c3                   	ret    
8010271b:	90                   	nop
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102720:	f3 c3                	repz ret 
80102722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102728:	55                   	push   %ebp
80102729:	89 e5                	mov    %esp,%ebp
8010272b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010272e:	68 40 38 11 80       	push   $0x80113840
80102733:	e8 78 20 00 00       	call   801047b0 <acquire>
  r = kmem.freelist;
80102738:	a1 78 38 11 80       	mov    0x80113878,%eax
  if(r)
8010273d:	83 c4 10             	add    $0x10,%esp
80102740:	8b 15 74 38 11 80    	mov    0x80113874,%edx
80102746:	85 c0                	test   %eax,%eax
80102748:	74 08                	je     80102752 <kalloc+0x52>
    kmem.freelist = r->next;
8010274a:	8b 08                	mov    (%eax),%ecx
8010274c:	89 0d 78 38 11 80    	mov    %ecx,0x80113878
  if(kmem.use_lock)
80102752:	85 d2                	test   %edx,%edx
80102754:	74 16                	je     8010276c <kalloc+0x6c>
    release(&kmem.lock);
80102756:	83 ec 0c             	sub    $0xc,%esp
80102759:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010275c:	68 40 38 11 80       	push   $0x80113840
80102761:	e8 6a 21 00 00       	call   801048d0 <release>
  return (char*)r;
80102766:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102769:	83 c4 10             	add    $0x10,%esp
}
8010276c:	c9                   	leave  
8010276d:	c3                   	ret    
8010276e:	66 90                	xchg   %ax,%ax

80102770 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102770:	ba 64 00 00 00       	mov    $0x64,%edx
80102775:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102776:	a8 01                	test   $0x1,%al
80102778:	0f 84 c2 00 00 00    	je     80102840 <kbdgetc+0xd0>
8010277e:	ba 60 00 00 00       	mov    $0x60,%edx
80102783:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102784:	0f b6 d0             	movzbl %al,%edx
80102787:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010278d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102793:	0f 84 7f 00 00 00    	je     80102818 <kbdgetc+0xa8>
{
80102799:	55                   	push   %ebp
8010279a:	89 e5                	mov    %esp,%ebp
8010279c:	53                   	push   %ebx
8010279d:	89 cb                	mov    %ecx,%ebx
8010279f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801027a2:	84 c0                	test   %al,%al
801027a4:	78 4a                	js     801027f0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027a6:	85 db                	test   %ebx,%ebx
801027a8:	74 09                	je     801027b3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027aa:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027ad:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801027b0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801027b3:	0f b6 82 a0 79 10 80 	movzbl -0x7fef8660(%edx),%eax
801027ba:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801027bc:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
801027c3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801027c5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801027c7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801027cd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027d0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801027d3:	8b 04 85 80 78 10 80 	mov    -0x7fef8780(,%eax,4),%eax
801027da:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801027de:	74 31                	je     80102811 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801027e0:	8d 50 9f             	lea    -0x61(%eax),%edx
801027e3:	83 fa 19             	cmp    $0x19,%edx
801027e6:	77 40                	ja     80102828 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027e8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027eb:	5b                   	pop    %ebx
801027ec:	5d                   	pop    %ebp
801027ed:	c3                   	ret    
801027ee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801027f0:	83 e0 7f             	and    $0x7f,%eax
801027f3:	85 db                	test   %ebx,%ebx
801027f5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801027f8:	0f b6 82 a0 79 10 80 	movzbl -0x7fef8660(%edx),%eax
801027ff:	83 c8 40             	or     $0x40,%eax
80102802:	0f b6 c0             	movzbl %al,%eax
80102805:	f7 d0                	not    %eax
80102807:	21 c1                	and    %eax,%ecx
    return 0;
80102809:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010280b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102811:	5b                   	pop    %ebx
80102812:	5d                   	pop    %ebp
80102813:	c3                   	ret    
80102814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102818:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010281b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010281d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102823:	c3                   	ret    
80102824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102828:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010282b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010282e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010282f:	83 f9 1a             	cmp    $0x1a,%ecx
80102832:	0f 42 c2             	cmovb  %edx,%eax
}
80102835:	5d                   	pop    %ebp
80102836:	c3                   	ret    
80102837:	89 f6                	mov    %esi,%esi
80102839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102845:	c3                   	ret    
80102846:	8d 76 00             	lea    0x0(%esi),%esi
80102849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102850 <kbdintr>:

void
kbdintr(void)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102856:	68 70 27 10 80       	push   $0x80102770
8010285b:	e8 30 e0 ff ff       	call   80100890 <consoleintr>
}
80102860:	83 c4 10             	add    $0x10,%esp
80102863:	c9                   	leave  
80102864:	c3                   	ret    
80102865:	66 90                	xchg   %ax,%ax
80102867:	66 90                	xchg   %ax,%ax
80102869:	66 90                	xchg   %ax,%ax
8010286b:	66 90                	xchg   %ax,%ax
8010286d:	66 90                	xchg   %ax,%ax
8010286f:	90                   	nop

80102870 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102870:	a1 7c 38 11 80       	mov    0x8011387c,%eax
{
80102875:	55                   	push   %ebp
80102876:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102878:	85 c0                	test   %eax,%eax
8010287a:	0f 84 c8 00 00 00    	je     80102948 <lapicinit+0xd8>
  lapic[index] = value;
80102880:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102887:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028ce:	8b 50 30             	mov    0x30(%eax),%edx
801028d1:	c1 ea 10             	shr    $0x10,%edx
801028d4:	80 fa 03             	cmp    $0x3,%dl
801028d7:	77 77                	ja     80102950 <lapicinit+0xe0>
  lapic[index] = value;
801028d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028fd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102900:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102907:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010290a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010290d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102914:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102917:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102921:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102924:	8b 50 20             	mov    0x20(%eax),%edx
80102927:	89 f6                	mov    %esi,%esi
80102929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102930:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102936:	80 e6 10             	and    $0x10,%dh
80102939:	75 f5                	jne    80102930 <lapicinit+0xc0>
  lapic[index] = value;
8010293b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102942:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102945:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102948:	5d                   	pop    %ebp
80102949:	c3                   	ret    
8010294a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102950:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102957:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 50 20             	mov    0x20(%eax),%edx
8010295d:	e9 77 ff ff ff       	jmp    801028d9 <lapicinit+0x69>
80102962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102970 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102970:	8b 15 7c 38 11 80    	mov    0x8011387c,%edx
{
80102976:	55                   	push   %ebp
80102977:	31 c0                	xor    %eax,%eax
80102979:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010297b:	85 d2                	test   %edx,%edx
8010297d:	74 06                	je     80102985 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010297f:	8b 42 20             	mov    0x20(%edx),%eax
80102982:	c1 e8 18             	shr    $0x18,%eax
}
80102985:	5d                   	pop    %ebp
80102986:	c3                   	ret    
80102987:	89 f6                	mov    %esi,%esi
80102989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102990 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102990:	a1 7c 38 11 80       	mov    0x8011387c,%eax
{
80102995:	55                   	push   %ebp
80102996:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102998:	85 c0                	test   %eax,%eax
8010299a:	74 0d                	je     801029a9 <lapiceoi+0x19>
  lapic[index] = value;
8010299c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029a9:	5d                   	pop    %ebp
801029aa:	c3                   	ret    
801029ab:	90                   	nop
801029ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
}
801029b3:	5d                   	pop    %ebp
801029b4:	c3                   	ret    
801029b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029c6:	ba 70 00 00 00       	mov    $0x70,%edx
801029cb:	89 e5                	mov    %esp,%ebp
801029cd:	53                   	push   %ebx
801029ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029d4:	ee                   	out    %al,(%dx)
801029d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029da:	ba 71 00 00 00       	mov    $0x71,%edx
801029df:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029e0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801029e2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029e5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029eb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029ed:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801029f0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801029f3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801029f5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029f8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029fe:	a1 7c 38 11 80       	mov    0x8011387c,%eax
80102a03:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a09:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a0c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a13:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a16:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a19:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a20:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a23:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a26:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a2c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a2f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a35:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a38:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a41:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a47:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a4a:	5b                   	pop    %ebx
80102a4b:	5d                   	pop    %ebp
80102a4c:	c3                   	ret    
80102a4d:	8d 76 00             	lea    0x0(%esi),%esi

80102a50 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102a50:	55                   	push   %ebp
80102a51:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a56:	ba 70 00 00 00       	mov    $0x70,%edx
80102a5b:	89 e5                	mov    %esp,%ebp
80102a5d:	57                   	push   %edi
80102a5e:	56                   	push   %esi
80102a5f:	53                   	push   %ebx
80102a60:	83 ec 4c             	sub    $0x4c,%esp
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	ba 71 00 00 00       	mov    $0x71,%edx
80102a69:	ec                   	in     (%dx),%al
80102a6a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a72:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a75:	8d 76 00             	lea    0x0(%esi),%esi
80102a78:	31 c0                	xor    %eax,%eax
80102a7a:	89 da                	mov    %ebx,%edx
80102a7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a82:	89 ca                	mov    %ecx,%edx
80102a84:	ec                   	in     (%dx),%al
80102a85:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a88:	89 da                	mov    %ebx,%edx
80102a8a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a90:	89 ca                	mov    %ecx,%edx
80102a92:	ec                   	in     (%dx),%al
80102a93:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a96:	89 da                	mov    %ebx,%edx
80102a98:	b8 04 00 00 00       	mov    $0x4,%eax
80102a9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9e:	89 ca                	mov    %ecx,%edx
80102aa0:	ec                   	in     (%dx),%al
80102aa1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa4:	89 da                	mov    %ebx,%edx
80102aa6:	b8 07 00 00 00       	mov    $0x7,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al
80102aaf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab2:	89 da                	mov    %ebx,%edx
80102ab4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ab9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aba:	89 ca                	mov    %ecx,%edx
80102abc:	ec                   	in     (%dx),%al
80102abd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abf:	89 da                	mov    %ebx,%edx
80102ac1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ac6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac7:	89 ca                	mov    %ecx,%edx
80102ac9:	ec                   	in     (%dx),%al
80102aca:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acc:	89 da                	mov    %ebx,%edx
80102ace:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ad3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad4:	89 ca                	mov    %ecx,%edx
80102ad6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ad7:	84 c0                	test   %al,%al
80102ad9:	78 9d                	js     80102a78 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102adb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102adf:	89 fa                	mov    %edi,%edx
80102ae1:	0f b6 fa             	movzbl %dl,%edi
80102ae4:	89 f2                	mov    %esi,%edx
80102ae6:	0f b6 f2             	movzbl %dl,%esi
80102ae9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aec:	89 da                	mov    %ebx,%edx
80102aee:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102af1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102af4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102af8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102afb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102aff:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b02:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b06:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b09:	31 c0                	xor    %eax,%eax
80102b0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0c:	89 ca                	mov    %ecx,%edx
80102b0e:	ec                   	in     (%dx),%al
80102b0f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b12:	89 da                	mov    %ebx,%edx
80102b14:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b17:	b8 02 00 00 00       	mov    $0x2,%eax
80102b1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1d:	89 ca                	mov    %ecx,%edx
80102b1f:	ec                   	in     (%dx),%al
80102b20:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b23:	89 da                	mov    %ebx,%edx
80102b25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b28:	b8 04 00 00 00       	mov    $0x4,%eax
80102b2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2e:	89 ca                	mov    %ecx,%edx
80102b30:	ec                   	in     (%dx),%al
80102b31:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b34:	89 da                	mov    %ebx,%edx
80102b36:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b39:	b8 07 00 00 00       	mov    $0x7,%eax
80102b3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3f:	89 ca                	mov    %ecx,%edx
80102b41:	ec                   	in     (%dx),%al
80102b42:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b45:	89 da                	mov    %ebx,%edx
80102b47:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b4a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b50:	89 ca                	mov    %ecx,%edx
80102b52:	ec                   	in     (%dx),%al
80102b53:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b56:	89 da                	mov    %ebx,%edx
80102b58:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b5b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b60:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b61:	89 ca                	mov    %ecx,%edx
80102b63:	ec                   	in     (%dx),%al
80102b64:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b67:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b6d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b70:	6a 18                	push   $0x18
80102b72:	50                   	push   %eax
80102b73:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b76:	50                   	push   %eax
80102b77:	e8 04 1e 00 00       	call   80104980 <memcmp>
80102b7c:	83 c4 10             	add    $0x10,%esp
80102b7f:	85 c0                	test   %eax,%eax
80102b81:	0f 85 f1 fe ff ff    	jne    80102a78 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b87:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b8b:	75 78                	jne    80102c05 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b90:	89 c2                	mov    %eax,%edx
80102b92:	83 e0 0f             	and    $0xf,%eax
80102b95:	c1 ea 04             	shr    $0x4,%edx
80102b98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b9e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ba1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba4:	89 c2                	mov    %eax,%edx
80102ba6:	83 e0 0f             	and    $0xf,%eax
80102ba9:	c1 ea 04             	shr    $0x4,%edx
80102bac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102baf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102bb5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bb8:	89 c2                	mov    %eax,%edx
80102bba:	83 e0 0f             	and    $0xf,%eax
80102bbd:	c1 ea 04             	shr    $0x4,%edx
80102bc0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bc3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bc6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bcc:	89 c2                	mov    %eax,%edx
80102bce:	83 e0 0f             	and    $0xf,%eax
80102bd1:	c1 ea 04             	shr    $0x4,%edx
80102bd4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bda:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bdd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102be0:	89 c2                	mov    %eax,%edx
80102be2:	83 e0 0f             	and    $0xf,%eax
80102be5:	c1 ea 04             	shr    $0x4,%edx
80102be8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102beb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bee:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bf1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bf4:	89 c2                	mov    %eax,%edx
80102bf6:	83 e0 0f             	and    $0xf,%eax
80102bf9:	c1 ea 04             	shr    $0x4,%edx
80102bfc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c02:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c05:	8b 75 08             	mov    0x8(%ebp),%esi
80102c08:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c0b:	89 06                	mov    %eax,(%esi)
80102c0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c10:	89 46 04             	mov    %eax,0x4(%esi)
80102c13:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c16:	89 46 08             	mov    %eax,0x8(%esi)
80102c19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c1c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c22:	89 46 10             	mov    %eax,0x10(%esi)
80102c25:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c28:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c2b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c35:	5b                   	pop    %ebx
80102c36:	5e                   	pop    %esi
80102c37:	5f                   	pop    %edi
80102c38:	5d                   	pop    %ebp
80102c39:	c3                   	ret    
80102c3a:	66 90                	xchg   %ax,%ax
80102c3c:	66 90                	xchg   %ax,%ax
80102c3e:	66 90                	xchg   %ax,%ax

80102c40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c40:	8b 0d c8 38 11 80    	mov    0x801138c8,%ecx
80102c46:	85 c9                	test   %ecx,%ecx
80102c48:	0f 8e 8a 00 00 00    	jle    80102cd8 <install_trans+0x98>
{
80102c4e:	55                   	push   %ebp
80102c4f:	89 e5                	mov    %esp,%ebp
80102c51:	57                   	push   %edi
80102c52:	56                   	push   %esi
80102c53:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102c54:	31 db                	xor    %ebx,%ebx
{
80102c56:	83 ec 0c             	sub    $0xc,%esp
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c60:	a1 b4 38 11 80       	mov    0x801138b4,%eax
80102c65:	83 ec 08             	sub    $0x8,%esp
80102c68:	01 d8                	add    %ebx,%eax
80102c6a:	83 c0 01             	add    $0x1,%eax
80102c6d:	50                   	push   %eax
80102c6e:	ff 35 c4 38 11 80    	pushl  0x801138c4
80102c74:	e8 57 d4 ff ff       	call   801000d0 <bread>
80102c79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c7b:	58                   	pop    %eax
80102c7c:	5a                   	pop    %edx
80102c7d:	ff 34 9d cc 38 11 80 	pushl  -0x7feec734(,%ebx,4)
80102c84:	ff 35 c4 38 11 80    	pushl  0x801138c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c8d:	e8 3e d4 ff ff       	call   801000d0 <bread>
80102c92:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c94:	8d 47 5c             	lea    0x5c(%edi),%eax
80102c97:	83 c4 0c             	add    $0xc,%esp
80102c9a:	68 00 02 00 00       	push   $0x200
80102c9f:	50                   	push   %eax
80102ca0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ca3:	50                   	push   %eax
80102ca4:	e8 37 1d 00 00       	call   801049e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ca9:	89 34 24             	mov    %esi,(%esp)
80102cac:	e8 ef d4 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102cb1:	89 3c 24             	mov    %edi,(%esp)
80102cb4:	e8 27 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102cb9:	89 34 24             	mov    %esi,(%esp)
80102cbc:	e8 1f d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cc1:	83 c4 10             	add    $0x10,%esp
80102cc4:	39 1d c8 38 11 80    	cmp    %ebx,0x801138c8
80102cca:	7f 94                	jg     80102c60 <install_trans+0x20>
  }
}
80102ccc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ccf:	5b                   	pop    %ebx
80102cd0:	5e                   	pop    %esi
80102cd1:	5f                   	pop    %edi
80102cd2:	5d                   	pop    %ebp
80102cd3:	c3                   	ret    
80102cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cd8:	f3 c3                	repz ret 
80102cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ce0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	56                   	push   %esi
80102ce4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ce5:	83 ec 08             	sub    $0x8,%esp
80102ce8:	ff 35 b4 38 11 80    	pushl  0x801138b4
80102cee:	ff 35 c4 38 11 80    	pushl  0x801138c4
80102cf4:	e8 d7 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102cf9:	8b 1d c8 38 11 80    	mov    0x801138c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102cff:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d02:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102d04:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102d06:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102d09:	7e 16                	jle    80102d21 <write_head+0x41>
80102d0b:	c1 e3 02             	shl    $0x2,%ebx
80102d0e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102d10:	8b 8a cc 38 11 80    	mov    -0x7feec734(%edx),%ecx
80102d16:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102d1a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102d1d:	39 da                	cmp    %ebx,%edx
80102d1f:	75 ef                	jne    80102d10 <write_head+0x30>
  }
  bwrite(buf);
80102d21:	83 ec 0c             	sub    $0xc,%esp
80102d24:	56                   	push   %esi
80102d25:	e8 76 d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102d2a:	89 34 24             	mov    %esi,(%esp)
80102d2d:	e8 ae d4 ff ff       	call   801001e0 <brelse>
}
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d38:	5b                   	pop    %ebx
80102d39:	5e                   	pop    %esi
80102d3a:	5d                   	pop    %ebp
80102d3b:	c3                   	ret    
80102d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d40 <initlog>:
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	53                   	push   %ebx
80102d44:	83 ec 2c             	sub    $0x2c,%esp
80102d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d4a:	68 a0 7a 10 80       	push   $0x80107aa0
80102d4f:	68 80 38 11 80       	push   $0x80113880
80102d54:	e8 67 19 00 00       	call   801046c0 <initlock>
  readsb(dev, &sb);
80102d59:	58                   	pop    %eax
80102d5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d5d:	5a                   	pop    %edx
80102d5e:	50                   	push   %eax
80102d5f:	53                   	push   %ebx
80102d60:	e8 9b e8 ff ff       	call   80101600 <readsb>
  log.size = sb.nlog;
80102d65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d6b:	59                   	pop    %ecx
  log.dev = dev;
80102d6c:	89 1d c4 38 11 80    	mov    %ebx,0x801138c4
  log.size = sb.nlog;
80102d72:	89 15 b8 38 11 80    	mov    %edx,0x801138b8
  log.start = sb.logstart;
80102d78:	a3 b4 38 11 80       	mov    %eax,0x801138b4
  struct buf *buf = bread(log.dev, log.start);
80102d7d:	5a                   	pop    %edx
80102d7e:	50                   	push   %eax
80102d7f:	53                   	push   %ebx
80102d80:	e8 4b d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102d85:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102d88:	83 c4 10             	add    $0x10,%esp
80102d8b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102d8d:	89 1d c8 38 11 80    	mov    %ebx,0x801138c8
  for (i = 0; i < log.lh.n; i++) {
80102d93:	7e 1c                	jle    80102db1 <initlog+0x71>
80102d95:	c1 e3 02             	shl    $0x2,%ebx
80102d98:	31 d2                	xor    %edx,%edx
80102d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102da0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102da4:	83 c2 04             	add    $0x4,%edx
80102da7:	89 8a c8 38 11 80    	mov    %ecx,-0x7feec738(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102dad:	39 d3                	cmp    %edx,%ebx
80102daf:	75 ef                	jne    80102da0 <initlog+0x60>
  brelse(buf);
80102db1:	83 ec 0c             	sub    $0xc,%esp
80102db4:	50                   	push   %eax
80102db5:	e8 26 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102dba:	e8 81 fe ff ff       	call   80102c40 <install_trans>
  log.lh.n = 0;
80102dbf:	c7 05 c8 38 11 80 00 	movl   $0x0,0x801138c8
80102dc6:	00 00 00 
  write_head(); // clear the log
80102dc9:	e8 12 ff ff ff       	call   80102ce0 <write_head>
}
80102dce:	83 c4 10             	add    $0x10,%esp
80102dd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dd4:	c9                   	leave  
80102dd5:	c3                   	ret    
80102dd6:	8d 76 00             	lea    0x0(%esi),%esi
80102dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102de0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102de6:	68 80 38 11 80       	push   $0x80113880
80102deb:	e8 c0 19 00 00       	call   801047b0 <acquire>
80102df0:	83 c4 10             	add    $0x10,%esp
80102df3:	eb 18                	jmp    80102e0d <begin_op+0x2d>
80102df5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102df8:	83 ec 08             	sub    $0x8,%esp
80102dfb:	68 80 38 11 80       	push   $0x80113880
80102e00:	68 80 38 11 80       	push   $0x80113880
80102e05:	e8 56 14 00 00       	call   80104260 <sleep>
80102e0a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e0d:	a1 c0 38 11 80       	mov    0x801138c0,%eax
80102e12:	85 c0                	test   %eax,%eax
80102e14:	75 e2                	jne    80102df8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e16:	a1 bc 38 11 80       	mov    0x801138bc,%eax
80102e1b:	8b 15 c8 38 11 80    	mov    0x801138c8,%edx
80102e21:	83 c0 01             	add    $0x1,%eax
80102e24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e2a:	83 fa 1e             	cmp    $0x1e,%edx
80102e2d:	7f c9                	jg     80102df8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e2f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e32:	a3 bc 38 11 80       	mov    %eax,0x801138bc
      release(&log.lock);
80102e37:	68 80 38 11 80       	push   $0x80113880
80102e3c:	e8 8f 1a 00 00       	call   801048d0 <release>
      break;
    }
  }
}
80102e41:	83 c4 10             	add    $0x10,%esp
80102e44:	c9                   	leave  
80102e45:	c3                   	ret    
80102e46:	8d 76 00             	lea    0x0(%esi),%esi
80102e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	57                   	push   %edi
80102e54:	56                   	push   %esi
80102e55:	53                   	push   %ebx
80102e56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e59:	68 80 38 11 80       	push   $0x80113880
80102e5e:	e8 4d 19 00 00       	call   801047b0 <acquire>
  log.outstanding -= 1;
80102e63:	a1 bc 38 11 80       	mov    0x801138bc,%eax
  if(log.committing)
80102e68:	8b 35 c0 38 11 80    	mov    0x801138c0,%esi
80102e6e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e71:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102e74:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102e76:	89 1d bc 38 11 80    	mov    %ebx,0x801138bc
  if(log.committing)
80102e7c:	0f 85 1a 01 00 00    	jne    80102f9c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102e82:	85 db                	test   %ebx,%ebx
80102e84:	0f 85 ee 00 00 00    	jne    80102f78 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e8a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102e8d:	c7 05 c0 38 11 80 01 	movl   $0x1,0x801138c0
80102e94:	00 00 00 
  release(&log.lock);
80102e97:	68 80 38 11 80       	push   $0x80113880
80102e9c:	e8 2f 1a 00 00       	call   801048d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ea1:	8b 0d c8 38 11 80    	mov    0x801138c8,%ecx
80102ea7:	83 c4 10             	add    $0x10,%esp
80102eaa:	85 c9                	test   %ecx,%ecx
80102eac:	0f 8e 85 00 00 00    	jle    80102f37 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102eb2:	a1 b4 38 11 80       	mov    0x801138b4,%eax
80102eb7:	83 ec 08             	sub    $0x8,%esp
80102eba:	01 d8                	add    %ebx,%eax
80102ebc:	83 c0 01             	add    $0x1,%eax
80102ebf:	50                   	push   %eax
80102ec0:	ff 35 c4 38 11 80    	pushl  0x801138c4
80102ec6:	e8 05 d2 ff ff       	call   801000d0 <bread>
80102ecb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ecd:	58                   	pop    %eax
80102ece:	5a                   	pop    %edx
80102ecf:	ff 34 9d cc 38 11 80 	pushl  -0x7feec734(,%ebx,4)
80102ed6:	ff 35 c4 38 11 80    	pushl  0x801138c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102edc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102edf:	e8 ec d1 ff ff       	call   801000d0 <bread>
80102ee4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ee6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ee9:	83 c4 0c             	add    $0xc,%esp
80102eec:	68 00 02 00 00       	push   $0x200
80102ef1:	50                   	push   %eax
80102ef2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ef5:	50                   	push   %eax
80102ef6:	e8 e5 1a 00 00       	call   801049e0 <memmove>
    bwrite(to);  // write the log
80102efb:	89 34 24             	mov    %esi,(%esp)
80102efe:	e8 9d d2 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102f03:	89 3c 24             	mov    %edi,(%esp)
80102f06:	e8 d5 d2 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102f0b:	89 34 24             	mov    %esi,(%esp)
80102f0e:	e8 cd d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f13:	83 c4 10             	add    $0x10,%esp
80102f16:	3b 1d c8 38 11 80    	cmp    0x801138c8,%ebx
80102f1c:	7c 94                	jl     80102eb2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f1e:	e8 bd fd ff ff       	call   80102ce0 <write_head>
    install_trans(); // Now install writes to home locations
80102f23:	e8 18 fd ff ff       	call   80102c40 <install_trans>
    log.lh.n = 0;
80102f28:	c7 05 c8 38 11 80 00 	movl   $0x0,0x801138c8
80102f2f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f32:	e8 a9 fd ff ff       	call   80102ce0 <write_head>
    acquire(&log.lock);
80102f37:	83 ec 0c             	sub    $0xc,%esp
80102f3a:	68 80 38 11 80       	push   $0x80113880
80102f3f:	e8 6c 18 00 00       	call   801047b0 <acquire>
    wakeup(&log);
80102f44:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
    log.committing = 0;
80102f4b:	c7 05 c0 38 11 80 00 	movl   $0x0,0x801138c0
80102f52:	00 00 00 
    wakeup(&log);
80102f55:	e8 d6 14 00 00       	call   80104430 <wakeup>
    release(&log.lock);
80102f5a:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80102f61:	e8 6a 19 00 00       	call   801048d0 <release>
80102f66:	83 c4 10             	add    $0x10,%esp
}
80102f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f6c:	5b                   	pop    %ebx
80102f6d:	5e                   	pop    %esi
80102f6e:	5f                   	pop    %edi
80102f6f:	5d                   	pop    %ebp
80102f70:	c3                   	ret    
80102f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102f78:	83 ec 0c             	sub    $0xc,%esp
80102f7b:	68 80 38 11 80       	push   $0x80113880
80102f80:	e8 ab 14 00 00       	call   80104430 <wakeup>
  release(&log.lock);
80102f85:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80102f8c:	e8 3f 19 00 00       	call   801048d0 <release>
80102f91:	83 c4 10             	add    $0x10,%esp
}
80102f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f97:	5b                   	pop    %ebx
80102f98:	5e                   	pop    %esi
80102f99:	5f                   	pop    %edi
80102f9a:	5d                   	pop    %ebp
80102f9b:	c3                   	ret    
    panic("log.committing");
80102f9c:	83 ec 0c             	sub    $0xc,%esp
80102f9f:	68 a4 7a 10 80       	push   $0x80107aa4
80102fa4:	e8 e7 d3 ff ff       	call   80100390 <panic>
80102fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fb7:	8b 15 c8 38 11 80    	mov    0x801138c8,%edx
{
80102fbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fc0:	83 fa 1d             	cmp    $0x1d,%edx
80102fc3:	0f 8f 9d 00 00 00    	jg     80103066 <log_write+0xb6>
80102fc9:	a1 b8 38 11 80       	mov    0x801138b8,%eax
80102fce:	83 e8 01             	sub    $0x1,%eax
80102fd1:	39 c2                	cmp    %eax,%edx
80102fd3:	0f 8d 8d 00 00 00    	jge    80103066 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fd9:	a1 bc 38 11 80       	mov    0x801138bc,%eax
80102fde:	85 c0                	test   %eax,%eax
80102fe0:	0f 8e 8d 00 00 00    	jle    80103073 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fe6:	83 ec 0c             	sub    $0xc,%esp
80102fe9:	68 80 38 11 80       	push   $0x80113880
80102fee:	e8 bd 17 00 00       	call   801047b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ff3:	8b 0d c8 38 11 80    	mov    0x801138c8,%ecx
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	83 f9 00             	cmp    $0x0,%ecx
80102fff:	7e 57                	jle    80103058 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103001:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103004:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103006:	3b 15 cc 38 11 80    	cmp    0x801138cc,%edx
8010300c:	75 0b                	jne    80103019 <log_write+0x69>
8010300e:	eb 38                	jmp    80103048 <log_write+0x98>
80103010:	39 14 85 cc 38 11 80 	cmp    %edx,-0x7feec734(,%eax,4)
80103017:	74 2f                	je     80103048 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103019:	83 c0 01             	add    $0x1,%eax
8010301c:	39 c1                	cmp    %eax,%ecx
8010301e:	75 f0                	jne    80103010 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103020:	89 14 85 cc 38 11 80 	mov    %edx,-0x7feec734(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103027:	83 c0 01             	add    $0x1,%eax
8010302a:	a3 c8 38 11 80       	mov    %eax,0x801138c8
  b->flags |= B_DIRTY; // prevent eviction
8010302f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103032:	c7 45 08 80 38 11 80 	movl   $0x80113880,0x8(%ebp)
}
80103039:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010303c:	c9                   	leave  
  release(&log.lock);
8010303d:	e9 8e 18 00 00       	jmp    801048d0 <release>
80103042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103048:	89 14 85 cc 38 11 80 	mov    %edx,-0x7feec734(,%eax,4)
8010304f:	eb de                	jmp    8010302f <log_write+0x7f>
80103051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103058:	8b 43 08             	mov    0x8(%ebx),%eax
8010305b:	a3 cc 38 11 80       	mov    %eax,0x801138cc
  if (i == log.lh.n)
80103060:	75 cd                	jne    8010302f <log_write+0x7f>
80103062:	31 c0                	xor    %eax,%eax
80103064:	eb c1                	jmp    80103027 <log_write+0x77>
    panic("too big a transaction");
80103066:	83 ec 0c             	sub    $0xc,%esp
80103069:	68 b3 7a 10 80       	push   $0x80107ab3
8010306e:	e8 1d d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103073:	83 ec 0c             	sub    $0xc,%esp
80103076:	68 c9 7a 10 80       	push   $0x80107ac9
8010307b:	e8 10 d3 ff ff       	call   80100390 <panic>

80103080 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	53                   	push   %ebx
80103084:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103087:	e8 94 09 00 00       	call   80103a20 <cpuid>
8010308c:	89 c3                	mov    %eax,%ebx
8010308e:	e8 8d 09 00 00       	call   80103a20 <cpuid>
80103093:	83 ec 04             	sub    $0x4,%esp
80103096:	53                   	push   %ebx
80103097:	50                   	push   %eax
80103098:	68 e4 7a 10 80       	push   $0x80107ae4
8010309d:	e8 3e d6 ff ff       	call   801006e0 <cprintf>
  idtinit();       // load idt register
801030a2:	e8 29 2c 00 00       	call   80105cd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030a7:	e8 f4 08 00 00       	call   801039a0 <mycpu>
801030ac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030ae:	b8 01 00 00 00       	mov    $0x1,%eax
801030b3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030ba:	e8 61 0e 00 00       	call   80103f20 <scheduler>
801030bf:	90                   	nop

801030c0 <mpenter>:
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030c6:	e8 05 3d 00 00       	call   80106dd0 <switchkvm>
  seginit();
801030cb:	e8 70 3c 00 00       	call   80106d40 <seginit>
  lapicinit();
801030d0:	e8 9b f7 ff ff       	call   80102870 <lapicinit>
  mpmain();
801030d5:	e8 a6 ff ff ff       	call   80103080 <mpmain>
801030da:	66 90                	xchg   %ax,%ax
801030dc:	66 90                	xchg   %ax,%ax
801030de:	66 90                	xchg   %ax,%ax

801030e0 <main>:
{
801030e0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030e4:	83 e4 f0             	and    $0xfffffff0,%esp
801030e7:	ff 71 fc             	pushl  -0x4(%ecx)
801030ea:	55                   	push   %ebp
801030eb:	89 e5                	mov    %esp,%ebp
801030ed:	53                   	push   %ebx
801030ee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030ef:	83 ec 08             	sub    $0x8,%esp
801030f2:	68 00 00 40 80       	push   $0x80400000
801030f7:	68 c8 78 11 80       	push   $0x801178c8
801030fc:	e8 2f f5 ff ff       	call   80102630 <kinit1>
  kvmalloc();      // kernel page table
80103101:	e8 ba 42 00 00       	call   801073c0 <kvmalloc>
  mpinit();        // detect other processors
80103106:	e8 75 01 00 00       	call   80103280 <mpinit>
  lapicinit();     // interrupt controller
8010310b:	e8 60 f7 ff ff       	call   80102870 <lapicinit>
  seginit();       // segment descriptors
80103110:	e8 2b 3c 00 00       	call   80106d40 <seginit>
  picinit();       // disable pic
80103115:	e8 46 03 00 00       	call   80103460 <picinit>
  ioapicinit();    // another interrupt controller
8010311a:	e8 41 f3 ff ff       	call   80102460 <ioapicinit>
  consoleinit();   // console hardware
8010311f:	e8 2c da ff ff       	call   80100b50 <consoleinit>
  uartinit();      // serial port
80103124:	e8 e7 2e 00 00       	call   80106010 <uartinit>
  pinit();         // process table
80103129:	e8 52 08 00 00       	call   80103980 <pinit>
  tvinit();        // trap vectors
8010312e:	e8 1d 2b 00 00       	call   80105c50 <tvinit>
  binit();         // buffer cache
80103133:	e8 08 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103138:	e8 13 de ff ff       	call   80100f50 <fileinit>
  ideinit();       // disk 
8010313d:	e8 fe f0 ff ff       	call   80102240 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103142:	83 c4 0c             	add    $0xc,%esp
80103145:	68 8a 00 00 00       	push   $0x8a
8010314a:	68 8c b4 10 80       	push   $0x8010b48c
8010314f:	68 00 70 00 80       	push   $0x80007000
80103154:	e8 87 18 00 00       	call   801049e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103159:	69 05 00 3f 11 80 b0 	imul   $0xb0,0x80113f00,%eax
80103160:	00 00 00 
80103163:	83 c4 10             	add    $0x10,%esp
80103166:	05 80 39 11 80       	add    $0x80113980,%eax
8010316b:	3d 80 39 11 80       	cmp    $0x80113980,%eax
80103170:	76 71                	jbe    801031e3 <main+0x103>
80103172:	bb 80 39 11 80       	mov    $0x80113980,%ebx
80103177:	89 f6                	mov    %esi,%esi
80103179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103180:	e8 1b 08 00 00       	call   801039a0 <mycpu>
80103185:	39 d8                	cmp    %ebx,%eax
80103187:	74 41                	je     801031ca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103189:	e8 72 f5 ff ff       	call   80102700 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010318e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103193:	c7 05 f8 6f 00 80 c0 	movl   $0x801030c0,0x80006ff8
8010319a:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010319d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801031a4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031a7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801031ac:	0f b6 03             	movzbl (%ebx),%eax
801031af:	83 ec 08             	sub    $0x8,%esp
801031b2:	68 00 70 00 00       	push   $0x7000
801031b7:	50                   	push   %eax
801031b8:	e8 03 f8 ff ff       	call   801029c0 <lapicstartap>
801031bd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031c6:	85 c0                	test   %eax,%eax
801031c8:	74 f6                	je     801031c0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801031ca:	69 05 00 3f 11 80 b0 	imul   $0xb0,0x80113f00,%eax
801031d1:	00 00 00 
801031d4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031da:	05 80 39 11 80       	add    $0x80113980,%eax
801031df:	39 c3                	cmp    %eax,%ebx
801031e1:	72 9d                	jb     80103180 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031e3:	83 ec 08             	sub    $0x8,%esp
801031e6:	68 00 00 00 8e       	push   $0x8e000000
801031eb:	68 00 00 40 80       	push   $0x80400000
801031f0:	e8 ab f4 ff ff       	call   801026a0 <kinit2>
  userinit();      // first user process
801031f5:	e8 66 09 00 00       	call   80103b60 <userinit>
  mpmain();        // finish this processor's setup
801031fa:	e8 81 fe ff ff       	call   80103080 <mpmain>
801031ff:	90                   	nop

80103200 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	57                   	push   %edi
80103204:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103205:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010320b:	53                   	push   %ebx
  e = addr+len;
8010320c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010320f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103212:	39 de                	cmp    %ebx,%esi
80103214:	72 10                	jb     80103226 <mpsearch1+0x26>
80103216:	eb 50                	jmp    80103268 <mpsearch1+0x68>
80103218:	90                   	nop
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103220:	39 fb                	cmp    %edi,%ebx
80103222:	89 fe                	mov    %edi,%esi
80103224:	76 42                	jbe    80103268 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103226:	83 ec 04             	sub    $0x4,%esp
80103229:	8d 7e 10             	lea    0x10(%esi),%edi
8010322c:	6a 04                	push   $0x4
8010322e:	68 f8 7a 10 80       	push   $0x80107af8
80103233:	56                   	push   %esi
80103234:	e8 47 17 00 00       	call   80104980 <memcmp>
80103239:	83 c4 10             	add    $0x10,%esp
8010323c:	85 c0                	test   %eax,%eax
8010323e:	75 e0                	jne    80103220 <mpsearch1+0x20>
80103240:	89 f1                	mov    %esi,%ecx
80103242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103248:	0f b6 11             	movzbl (%ecx),%edx
8010324b:	83 c1 01             	add    $0x1,%ecx
8010324e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103250:	39 f9                	cmp    %edi,%ecx
80103252:	75 f4                	jne    80103248 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103254:	84 c0                	test   %al,%al
80103256:	75 c8                	jne    80103220 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103258:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325b:	89 f0                	mov    %esi,%eax
8010325d:	5b                   	pop    %ebx
8010325e:	5e                   	pop    %esi
8010325f:	5f                   	pop    %edi
80103260:	5d                   	pop    %ebp
80103261:	c3                   	ret    
80103262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103268:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010326b:	31 f6                	xor    %esi,%esi
}
8010326d:	89 f0                	mov    %esi,%eax
8010326f:	5b                   	pop    %ebx
80103270:	5e                   	pop    %esi
80103271:	5f                   	pop    %edi
80103272:	5d                   	pop    %ebp
80103273:	c3                   	ret    
80103274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010327a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103280 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103289:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103290:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103297:	c1 e0 08             	shl    $0x8,%eax
8010329a:	09 d0                	or     %edx,%eax
8010329c:	c1 e0 04             	shl    $0x4,%eax
8010329f:	85 c0                	test   %eax,%eax
801032a1:	75 1b                	jne    801032be <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032b1:	c1 e0 08             	shl    $0x8,%eax
801032b4:	09 d0                	or     %edx,%eax
801032b6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032b9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032be:	ba 00 04 00 00       	mov    $0x400,%edx
801032c3:	e8 38 ff ff ff       	call   80103200 <mpsearch1>
801032c8:	85 c0                	test   %eax,%eax
801032ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801032cd:	0f 84 3d 01 00 00    	je     80103410 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032d6:	8b 58 04             	mov    0x4(%eax),%ebx
801032d9:	85 db                	test   %ebx,%ebx
801032db:	0f 84 4f 01 00 00    	je     80103430 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801032e7:	83 ec 04             	sub    $0x4,%esp
801032ea:	6a 04                	push   $0x4
801032ec:	68 15 7b 10 80       	push   $0x80107b15
801032f1:	56                   	push   %esi
801032f2:	e8 89 16 00 00       	call   80104980 <memcmp>
801032f7:	83 c4 10             	add    $0x10,%esp
801032fa:	85 c0                	test   %eax,%eax
801032fc:	0f 85 2e 01 00 00    	jne    80103430 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103302:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103309:	3c 01                	cmp    $0x1,%al
8010330b:	0f 95 c2             	setne  %dl
8010330e:	3c 04                	cmp    $0x4,%al
80103310:	0f 95 c0             	setne  %al
80103313:	20 c2                	and    %al,%dl
80103315:	0f 85 15 01 00 00    	jne    80103430 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010331b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103322:	66 85 ff             	test   %di,%di
80103325:	74 1a                	je     80103341 <mpinit+0xc1>
80103327:	89 f0                	mov    %esi,%eax
80103329:	01 f7                	add    %esi,%edi
  sum = 0;
8010332b:	31 d2                	xor    %edx,%edx
8010332d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103330:	0f b6 08             	movzbl (%eax),%ecx
80103333:	83 c0 01             	add    $0x1,%eax
80103336:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103338:	39 c7                	cmp    %eax,%edi
8010333a:	75 f4                	jne    80103330 <mpinit+0xb0>
8010333c:	84 d2                	test   %dl,%dl
8010333e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103341:	85 f6                	test   %esi,%esi
80103343:	0f 84 e7 00 00 00    	je     80103430 <mpinit+0x1b0>
80103349:	84 d2                	test   %dl,%dl
8010334b:	0f 85 df 00 00 00    	jne    80103430 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103351:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103357:	a3 7c 38 11 80       	mov    %eax,0x8011387c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010335c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103363:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103369:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010336e:	01 d6                	add    %edx,%esi
80103370:	39 c6                	cmp    %eax,%esi
80103372:	76 23                	jbe    80103397 <mpinit+0x117>
    switch(*p){
80103374:	0f b6 10             	movzbl (%eax),%edx
80103377:	80 fa 04             	cmp    $0x4,%dl
8010337a:	0f 87 ca 00 00 00    	ja     8010344a <mpinit+0x1ca>
80103380:	ff 24 95 3c 7b 10 80 	jmp    *-0x7fef84c4(,%edx,4)
80103387:	89 f6                	mov    %esi,%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103390:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103393:	39 c6                	cmp    %eax,%esi
80103395:	77 dd                	ja     80103374 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103397:	85 db                	test   %ebx,%ebx
80103399:	0f 84 9e 00 00 00    	je     8010343d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010339f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801033a6:	74 15                	je     801033bd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033a8:	b8 70 00 00 00       	mov    $0x70,%eax
801033ad:	ba 22 00 00 00       	mov    $0x22,%edx
801033b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033b3:	ba 23 00 00 00       	mov    $0x23,%edx
801033b8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033b9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033bc:	ee                   	out    %al,(%dx)
  }
}
801033bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033c0:	5b                   	pop    %ebx
801033c1:	5e                   	pop    %esi
801033c2:	5f                   	pop    %edi
801033c3:	5d                   	pop    %ebp
801033c4:	c3                   	ret    
801033c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801033c8:	8b 0d 00 3f 11 80    	mov    0x80113f00,%ecx
801033ce:	83 f9 07             	cmp    $0x7,%ecx
801033d1:	7f 19                	jg     801033ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801033d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801033dd:	83 c1 01             	add    $0x1,%ecx
801033e0:	89 0d 00 3f 11 80    	mov    %ecx,0x80113f00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033e6:	88 97 80 39 11 80    	mov    %dl,-0x7feec680(%edi)
      p += sizeof(struct mpproc);
801033ec:	83 c0 14             	add    $0x14,%eax
      continue;
801033ef:	e9 7c ff ff ff       	jmp    80103370 <mpinit+0xf0>
801033f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801033fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033ff:	88 15 60 39 11 80    	mov    %dl,0x80113960
      continue;
80103405:	e9 66 ff ff ff       	jmp    80103370 <mpinit+0xf0>
8010340a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103410:	ba 00 00 01 00       	mov    $0x10000,%edx
80103415:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010341a:	e8 e1 fd ff ff       	call   80103200 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010341f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103421:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103424:	0f 85 a9 fe ff ff    	jne    801032d3 <mpinit+0x53>
8010342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103430:	83 ec 0c             	sub    $0xc,%esp
80103433:	68 fd 7a 10 80       	push   $0x80107afd
80103438:	e8 53 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010343d:	83 ec 0c             	sub    $0xc,%esp
80103440:	68 1c 7b 10 80       	push   $0x80107b1c
80103445:	e8 46 cf ff ff       	call   80100390 <panic>
      ismp = 0;
8010344a:	31 db                	xor    %ebx,%ebx
8010344c:	e9 26 ff ff ff       	jmp    80103377 <mpinit+0xf7>
80103451:	66 90                	xchg   %ax,%ax
80103453:	66 90                	xchg   %ax,%ax
80103455:	66 90                	xchg   %ax,%ax
80103457:	66 90                	xchg   %ax,%ax
80103459:	66 90                	xchg   %ax,%ax
8010345b:	66 90                	xchg   %ax,%ax
8010345d:	66 90                	xchg   %ax,%ax
8010345f:	90                   	nop

80103460 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103460:	55                   	push   %ebp
80103461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103466:	ba 21 00 00 00       	mov    $0x21,%edx
8010346b:	89 e5                	mov    %esp,%ebp
8010346d:	ee                   	out    %al,(%dx)
8010346e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103473:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103474:	5d                   	pop    %ebp
80103475:	c3                   	ret    
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 0c             	sub    $0xc,%esp
80103489:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010348c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010348f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103495:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010349b:	e8 d0 da ff ff       	call   80100f70 <filealloc>
801034a0:	85 c0                	test   %eax,%eax
801034a2:	89 03                	mov    %eax,(%ebx)
801034a4:	74 22                	je     801034c8 <pipealloc+0x48>
801034a6:	e8 c5 da ff ff       	call   80100f70 <filealloc>
801034ab:	85 c0                	test   %eax,%eax
801034ad:	89 06                	mov    %eax,(%esi)
801034af:	74 3f                	je     801034f0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034b1:	e8 4a f2 ff ff       	call   80102700 <kalloc>
801034b6:	85 c0                	test   %eax,%eax
801034b8:	89 c7                	mov    %eax,%edi
801034ba:	75 54                	jne    80103510 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801034bc:	8b 03                	mov    (%ebx),%eax
801034be:	85 c0                	test   %eax,%eax
801034c0:	75 34                	jne    801034f6 <pipealloc+0x76>
801034c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801034c8:	8b 06                	mov    (%esi),%eax
801034ca:	85 c0                	test   %eax,%eax
801034cc:	74 0c                	je     801034da <pipealloc+0x5a>
    fileclose(*f1);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	50                   	push   %eax
801034d2:	e8 59 db ff ff       	call   80101030 <fileclose>
801034d7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801034da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034e2:	5b                   	pop    %ebx
801034e3:	5e                   	pop    %esi
801034e4:	5f                   	pop    %edi
801034e5:	5d                   	pop    %ebp
801034e6:	c3                   	ret    
801034e7:	89 f6                	mov    %esi,%esi
801034e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 e4                	je     801034da <pipealloc+0x5a>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 31 db ff ff       	call   80101030 <fileclose>
  if(*f1)
801034ff:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103501:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103504:	85 c0                	test   %eax,%eax
80103506:	75 c6                	jne    801034ce <pipealloc+0x4e>
80103508:	eb d0                	jmp    801034da <pipealloc+0x5a>
8010350a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103510:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103513:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010351a:	00 00 00 
  p->writeopen = 1;
8010351d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103524:	00 00 00 
  p->nwrite = 0;
80103527:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010352e:	00 00 00 
  p->nread = 0;
80103531:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103538:	00 00 00 
  initlock(&p->lock, "pipe");
8010353b:	68 50 7b 10 80       	push   $0x80107b50
80103540:	50                   	push   %eax
80103541:	e8 7a 11 00 00       	call   801046c0 <initlock>
  (*f0)->type = FD_PIPE;
80103546:	8b 03                	mov    (%ebx),%eax
  return 0;
80103548:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010354b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103551:	8b 03                	mov    (%ebx),%eax
80103553:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103557:	8b 03                	mov    (%ebx),%eax
80103559:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010355d:	8b 03                	mov    (%ebx),%eax
8010355f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103562:	8b 06                	mov    (%esi),%eax
80103564:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010356a:	8b 06                	mov    (%esi),%eax
8010356c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103570:	8b 06                	mov    (%esi),%eax
80103572:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103576:	8b 06                	mov    (%esi),%eax
80103578:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010357b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010357e:	31 c0                	xor    %eax,%eax
}
80103580:	5b                   	pop    %ebx
80103581:	5e                   	pop    %esi
80103582:	5f                   	pop    %edi
80103583:	5d                   	pop    %ebp
80103584:	c3                   	ret    
80103585:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103590 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	56                   	push   %esi
80103594:	53                   	push   %ebx
80103595:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103598:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010359b:	83 ec 0c             	sub    $0xc,%esp
8010359e:	53                   	push   %ebx
8010359f:	e8 0c 12 00 00       	call   801047b0 <acquire>
  if(writable){
801035a4:	83 c4 10             	add    $0x10,%esp
801035a7:	85 f6                	test   %esi,%esi
801035a9:	74 45                	je     801035f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801035ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035b1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801035b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035bb:	00 00 00 
    wakeup(&p->nread);
801035be:	50                   	push   %eax
801035bf:	e8 6c 0e 00 00       	call   80104430 <wakeup>
801035c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035cd:	85 d2                	test   %edx,%edx
801035cf:	75 0a                	jne    801035db <pipeclose+0x4b>
801035d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035d7:	85 c0                	test   %eax,%eax
801035d9:	74 35                	je     80103610 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e1:	5b                   	pop    %ebx
801035e2:	5e                   	pop    %esi
801035e3:	5d                   	pop    %ebp
    release(&p->lock);
801035e4:	e9 e7 12 00 00       	jmp    801048d0 <release>
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801035f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801035f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103600:	00 00 00 
    wakeup(&p->nwrite);
80103603:	50                   	push   %eax
80103604:	e8 27 0e 00 00       	call   80104430 <wakeup>
80103609:	83 c4 10             	add    $0x10,%esp
8010360c:	eb b9                	jmp    801035c7 <pipeclose+0x37>
8010360e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	53                   	push   %ebx
80103614:	e8 b7 12 00 00       	call   801048d0 <release>
    kfree((char*)p);
80103619:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010361c:	83 c4 10             	add    $0x10,%esp
}
8010361f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103622:	5b                   	pop    %ebx
80103623:	5e                   	pop    %esi
80103624:	5d                   	pop    %ebp
    kfree((char*)p);
80103625:	e9 26 ef ff ff       	jmp    80102550 <kfree>
8010362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103630 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 28             	sub    $0x28,%esp
80103639:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010363c:	53                   	push   %ebx
8010363d:	e8 6e 11 00 00       	call   801047b0 <acquire>
  for(i = 0; i < n; i++){
80103642:	8b 45 10             	mov    0x10(%ebp),%eax
80103645:	83 c4 10             	add    $0x10,%esp
80103648:	85 c0                	test   %eax,%eax
8010364a:	0f 8e c9 00 00 00    	jle    80103719 <pipewrite+0xe9>
80103650:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103653:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103659:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010365f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103662:	03 4d 10             	add    0x10(%ebp),%ecx
80103665:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103668:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010366e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103674:	39 d0                	cmp    %edx,%eax
80103676:	75 71                	jne    801036e9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103678:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010367e:	85 c0                	test   %eax,%eax
80103680:	74 4e                	je     801036d0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103682:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103688:	eb 3a                	jmp    801036c4 <pipewrite+0x94>
8010368a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	57                   	push   %edi
80103694:	e8 97 0d 00 00       	call   80104430 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103699:	5a                   	pop    %edx
8010369a:	59                   	pop    %ecx
8010369b:	53                   	push   %ebx
8010369c:	56                   	push   %esi
8010369d:	e8 be 0b 00 00       	call   80104260 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036ae:	83 c4 10             	add    $0x10,%esp
801036b1:	05 00 02 00 00       	add    $0x200,%eax
801036b6:	39 c2                	cmp    %eax,%edx
801036b8:	75 36                	jne    801036f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036c0:	85 c0                	test   %eax,%eax
801036c2:	74 0c                	je     801036d0 <pipewrite+0xa0>
801036c4:	e8 77 03 00 00       	call   80103a40 <myproc>
801036c9:	8b 40 24             	mov    0x24(%eax),%eax
801036cc:	85 c0                	test   %eax,%eax
801036ce:	74 c0                	je     80103690 <pipewrite+0x60>
        release(&p->lock);
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	53                   	push   %ebx
801036d4:	e8 f7 11 00 00       	call   801048d0 <release>
        return -1;
801036d9:	83 c4 10             	add    $0x10,%esp
801036dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036e4:	5b                   	pop    %ebx
801036e5:	5e                   	pop    %esi
801036e6:	5f                   	pop    %edi
801036e7:	5d                   	pop    %ebp
801036e8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036e9:	89 c2                	mov    %eax,%edx
801036eb:	90                   	nop
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036f3:	8d 42 01             	lea    0x1(%edx),%eax
801036f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103702:	83 c6 01             	add    $0x1,%esi
80103705:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103709:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010370c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010370f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103713:	0f 85 4f ff ff ff    	jne    80103668 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103719:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010371f:	83 ec 0c             	sub    $0xc,%esp
80103722:	50                   	push   %eax
80103723:	e8 08 0d 00 00       	call   80104430 <wakeup>
  release(&p->lock);
80103728:	89 1c 24             	mov    %ebx,(%esp)
8010372b:	e8 a0 11 00 00       	call   801048d0 <release>
  return n;
80103730:	83 c4 10             	add    $0x10,%esp
80103733:	8b 45 10             	mov    0x10(%ebp),%eax
80103736:	eb a9                	jmp    801036e1 <pipewrite+0xb1>
80103738:	90                   	nop
80103739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103740 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	57                   	push   %edi
80103744:	56                   	push   %esi
80103745:	53                   	push   %ebx
80103746:	83 ec 18             	sub    $0x18,%esp
80103749:	8b 75 08             	mov    0x8(%ebp),%esi
8010374c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010374f:	56                   	push   %esi
80103750:	e8 5b 10 00 00       	call   801047b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010375e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103764:	75 6a                	jne    801037d0 <piperead+0x90>
80103766:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010376c:	85 db                	test   %ebx,%ebx
8010376e:	0f 84 c4 00 00 00    	je     80103838 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103774:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010377a:	eb 2d                	jmp    801037a9 <piperead+0x69>
8010377c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103780:	83 ec 08             	sub    $0x8,%esp
80103783:	56                   	push   %esi
80103784:	53                   	push   %ebx
80103785:	e8 d6 0a 00 00       	call   80104260 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010378a:	83 c4 10             	add    $0x10,%esp
8010378d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103793:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103799:	75 35                	jne    801037d0 <piperead+0x90>
8010379b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801037a1:	85 d2                	test   %edx,%edx
801037a3:	0f 84 8f 00 00 00    	je     80103838 <piperead+0xf8>
    if(myproc()->killed){
801037a9:	e8 92 02 00 00       	call   80103a40 <myproc>
801037ae:	8b 48 24             	mov    0x24(%eax),%ecx
801037b1:	85 c9                	test   %ecx,%ecx
801037b3:	74 cb                	je     80103780 <piperead+0x40>
      release(&p->lock);
801037b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037bd:	56                   	push   %esi
801037be:	e8 0d 11 00 00       	call   801048d0 <release>
      return -1;
801037c3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801037c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c9:	89 d8                	mov    %ebx,%eax
801037cb:	5b                   	pop    %ebx
801037cc:	5e                   	pop    %esi
801037cd:	5f                   	pop    %edi
801037ce:	5d                   	pop    %ebp
801037cf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037d0:	8b 45 10             	mov    0x10(%ebp),%eax
801037d3:	85 c0                	test   %eax,%eax
801037d5:	7e 61                	jle    80103838 <piperead+0xf8>
    if(p->nread == p->nwrite)
801037d7:	31 db                	xor    %ebx,%ebx
801037d9:	eb 13                	jmp    801037ee <piperead+0xae>
801037db:	90                   	nop
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037ec:	74 1f                	je     8010380d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037ee:	8d 41 01             	lea    0x1(%ecx),%eax
801037f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801037f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801037fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103802:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103805:	83 c3 01             	add    $0x1,%ebx
80103808:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010380b:	75 d3                	jne    801037e0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010380d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103813:	83 ec 0c             	sub    $0xc,%esp
80103816:	50                   	push   %eax
80103817:	e8 14 0c 00 00       	call   80104430 <wakeup>
  release(&p->lock);
8010381c:	89 34 24             	mov    %esi,(%esp)
8010381f:	e8 ac 10 00 00       	call   801048d0 <release>
  return i;
80103824:	83 c4 10             	add    $0x10,%esp
}
80103827:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010382a:	89 d8                	mov    %ebx,%eax
8010382c:	5b                   	pop    %ebx
8010382d:	5e                   	pop    %esi
8010382e:	5f                   	pop    %edi
8010382f:	5d                   	pop    %ebp
80103830:	c3                   	ret    
80103831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103838:	31 db                	xor    %ebx,%ebx
8010383a:	eb d1                	jmp    8010380d <piperead+0xcd>
8010383c:	66 90                	xchg   %ax,%ax
8010383e:	66 90                	xchg   %ax,%ax

80103840 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103844:	bb 54 3f 11 80       	mov    $0x80113f54,%ebx
{
80103849:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010384c:	68 20 3f 11 80       	push   $0x80113f20
80103851:	e8 5a 0f 00 00       	call   801047b0 <acquire>
80103856:	83 c4 10             	add    $0x10,%esp
80103859:	eb 17                	jmp    80103872 <allocproc+0x32>
8010385b:	90                   	nop
8010385c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103860:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
80103866:	81 fb 54 70 11 80    	cmp    $0x80117054,%ebx
8010386c:	0f 83 8e 00 00 00    	jae    80103900 <allocproc+0xc0>
    if(p->state == UNUSED)
80103872:	8b 43 0c             	mov    0xc(%ebx),%eax
80103875:	85 c0                	test   %eax,%eax
80103877:	75 e7                	jne    80103860 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103879:	a1 04 b0 10 80       	mov    0x8010b004,%eax


  release(&ptable.lock);
8010387e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103881:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103888:	8d 50 01             	lea    0x1(%eax),%edx
8010388b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010388e:	68 20 3f 11 80       	push   $0x80113f20
  p->pid = nextpid++;
80103893:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103899:	e8 32 10 00 00       	call   801048d0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010389e:	e8 5d ee ff ff       	call   80102700 <kalloc>
801038a3:	83 c4 10             	add    $0x10,%esp
801038a6:	85 c0                	test   %eax,%eax
801038a8:	89 43 08             	mov    %eax,0x8(%ebx)
801038ab:	74 6c                	je     80103919 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038ad:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038b3:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038b6:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038bb:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038be:	c7 40 14 3f 5c 10 80 	movl   $0x80105c3f,0x14(%eax)
  p->context = (struct context*)sp;
801038c5:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038c8:	6a 14                	push   $0x14
801038ca:	6a 00                	push   $0x0
801038cc:	50                   	push   %eax
801038cd:	e8 5e 10 00 00       	call   80104930 <memset>
  p->context->eip = (uint)forkret;
801038d2:	8b 43 1c             	mov    0x1c(%ebx),%eax

  //brand new
  p->priority=NPROCQ-1;
  p->wdidx=0;

  return p;
801038d5:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038d8:	c7 40 10 30 39 10 80 	movl   $0x80103930,0x10(%eax)
  p->priority=NPROCQ-1;
801038df:	c7 83 80 00 00 00 02 	movl   $0x2,0x80(%ebx)
801038e6:	00 00 00 
  p->wdidx=0;
801038e9:	c7 83 c0 00 00 00 00 	movl   $0x0,0xc0(%ebx)
801038f0:	00 00 00 
}
801038f3:	89 d8                	mov    %ebx,%eax
801038f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038f8:	c9                   	leave  
801038f9:	c3                   	ret    
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103900:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103903:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103905:	68 20 3f 11 80       	push   $0x80113f20
8010390a:	e8 c1 0f 00 00       	call   801048d0 <release>
}
8010390f:	89 d8                	mov    %ebx,%eax
  return 0;
80103911:	83 c4 10             	add    $0x10,%esp
}
80103914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103917:	c9                   	leave  
80103918:	c3                   	ret    
    p->state = UNUSED;
80103919:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103920:	31 db                	xor    %ebx,%ebx
80103922:	eb cf                	jmp    801038f3 <allocproc+0xb3>
80103924:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010392a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103930 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103936:	68 20 3f 11 80       	push   $0x80113f20
8010393b:	e8 90 0f 00 00       	call   801048d0 <release>

  if (first) {
80103940:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103945:	83 c4 10             	add    $0x10,%esp
80103948:	85 c0                	test   %eax,%eax
8010394a:	75 04                	jne    80103950 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010394c:	c9                   	leave  
8010394d:	c3                   	ret    
8010394e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103950:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103953:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010395a:	00 00 00 
    iinit(ROOTDEV);
8010395d:	6a 01                	push   $0x1
8010395f:	e8 5c dd ff ff       	call   801016c0 <iinit>
    initlog(ROOTDEV);
80103964:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010396b:	e8 d0 f3 ff ff       	call   80102d40 <initlog>
80103970:	83 c4 10             	add    $0x10,%esp
}
80103973:	c9                   	leave  
80103974:	c3                   	ret    
80103975:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103980 <pinit>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103986:	68 55 7b 10 80       	push   $0x80107b55
8010398b:	68 20 3f 11 80       	push   $0x80113f20
80103990:	e8 2b 0d 00 00       	call   801046c0 <initlock>
}
80103995:	83 c4 10             	add    $0x10,%esp
80103998:	c9                   	leave  
80103999:	c3                   	ret    
8010399a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039a0 <mycpu>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	56                   	push   %esi
801039a4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039a5:	9c                   	pushf  
801039a6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039a7:	f6 c4 02             	test   $0x2,%ah
801039aa:	75 5e                	jne    80103a0a <mycpu+0x6a>
  apicid = lapicid();
801039ac:	e8 bf ef ff ff       	call   80102970 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039b1:	8b 35 00 3f 11 80    	mov    0x80113f00,%esi
801039b7:	85 f6                	test   %esi,%esi
801039b9:	7e 42                	jle    801039fd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801039bb:	0f b6 15 80 39 11 80 	movzbl 0x80113980,%edx
801039c2:	39 d0                	cmp    %edx,%eax
801039c4:	74 30                	je     801039f6 <mycpu+0x56>
801039c6:	b9 30 3a 11 80       	mov    $0x80113a30,%ecx
  for (i = 0; i < ncpu; ++i) {
801039cb:	31 d2                	xor    %edx,%edx
801039cd:	8d 76 00             	lea    0x0(%esi),%esi
801039d0:	83 c2 01             	add    $0x1,%edx
801039d3:	39 f2                	cmp    %esi,%edx
801039d5:	74 26                	je     801039fd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801039d7:	0f b6 19             	movzbl (%ecx),%ebx
801039da:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801039e0:	39 c3                	cmp    %eax,%ebx
801039e2:	75 ec                	jne    801039d0 <mycpu+0x30>
801039e4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801039ea:	05 80 39 11 80       	add    $0x80113980,%eax
}
801039ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039f2:	5b                   	pop    %ebx
801039f3:	5e                   	pop    %esi
801039f4:	5d                   	pop    %ebp
801039f5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801039f6:	b8 80 39 11 80       	mov    $0x80113980,%eax
      return &cpus[i];
801039fb:	eb f2                	jmp    801039ef <mycpu+0x4f>
  panic("unknown apicid\n");
801039fd:	83 ec 0c             	sub    $0xc,%esp
80103a00:	68 5c 7b 10 80       	push   $0x80107b5c
80103a05:	e8 86 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a0a:	83 ec 0c             	sub    $0xc,%esp
80103a0d:	68 38 7c 10 80       	push   $0x80107c38
80103a12:	e8 79 c9 ff ff       	call   80100390 <panic>
80103a17:	89 f6                	mov    %esi,%esi
80103a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a20 <cpuid>:
cpuid() {
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a26:	e8 75 ff ff ff       	call   801039a0 <mycpu>
80103a2b:	2d 80 39 11 80       	sub    $0x80113980,%eax
}
80103a30:	c9                   	leave  
  return mycpu()-cpus;
80103a31:	c1 f8 04             	sar    $0x4,%eax
80103a34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a3a:	c3                   	ret    
80103a3b:	90                   	nop
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a40 <myproc>:
myproc(void) {
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	53                   	push   %ebx
80103a44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a47:	e8 24 0d 00 00       	call   80104770 <pushcli>
  c = mycpu();
80103a4c:	e8 4f ff ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103a51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a57:	e8 14 0e 00 00       	call   80104870 <popcli>
}
80103a5c:	83 c4 04             	add    $0x4,%esp
80103a5f:	89 d8                	mov    %ebx,%eax
80103a61:	5b                   	pop    %ebx
80103a62:	5d                   	pop    %ebp
80103a63:	c3                   	ret    
80103a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a70 <qpush>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	53                   	push   %ebx
80103a74:	8b 45 08             	mov    0x8(%ebp),%eax
  if(ptable.count[np->priority]<=0)
80103a77:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103a7d:	8b 0c 95 6c 70 11 80 	mov    -0x7fee8f94(,%edx,4),%ecx
80103a84:	85 c9                	test   %ecx,%ecx
80103a86:	74 50                	je     80103ad8 <qpush+0x68>
    np->next=ptable.pqueue[np->priority].head;
80103a88:	81 c2 26 06 00 00    	add    $0x626,%edx
80103a8e:	8b 0c d5 24 3f 11 80 	mov    -0x7feec0dc(,%edx,8),%ecx
80103a95:	89 48 7c             	mov    %ecx,0x7c(%eax)
    ptable.pqueue[np->priority].last->next=np;
80103a98:	8b 14 d5 28 3f 11 80 	mov    -0x7feec0d8(,%edx,8),%edx
80103a9f:	89 42 7c             	mov    %eax,0x7c(%edx)
    ptable.pqueue[np->priority].last=np;
80103aa2:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103aa8:	89 04 d5 58 70 11 80 	mov    %eax,-0x7fee8fa8(,%edx,8)
  np->timepiece=(1<<(NPROCQ-np->priority-1));
80103aaf:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103ab5:	b9 02 00 00 00       	mov    $0x2,%ecx
80103aba:	bb 01 00 00 00       	mov    $0x1,%ebx
80103abf:	29 d1                	sub    %edx,%ecx
80103ac1:	d3 e3                	shl    %cl,%ebx
80103ac3:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
  ptable.count[np->priority]++;
80103ac9:	83 04 95 6c 70 11 80 	addl   $0x1,-0x7fee8f94(,%edx,4)
80103ad0:	01 
}
80103ad1:	5b                   	pop    %ebx
80103ad2:	5d                   	pop    %ebp
80103ad3:	c3                   	ret    
80103ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->next=np;
80103ad8:	89 40 7c             	mov    %eax,0x7c(%eax)
    ptable.pqueue[np->priority].head=np;
80103adb:	89 04 d5 54 70 11 80 	mov    %eax,-0x7fee8fac(,%edx,8)
    ptable.pqueue[np->priority].last=np;
80103ae2:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103ae8:	89 04 d5 58 70 11 80 	mov    %eax,-0x7fee8fa8(,%edx,8)
80103aef:	eb be                	jmp    80103aaf <qpush+0x3f>
80103af1:	eb 0d                	jmp    80103b00 <wakeup1>
80103af3:	90                   	nop
80103af4:	90                   	nop
80103af5:	90                   	nop
80103af6:	90                   	nop
80103af7:	90                   	nop
80103af8:	90                   	nop
80103af9:	90                   	nop
80103afa:	90                   	nop
80103afb:	90                   	nop
80103afc:	90                   	nop
80103afd:	90                   	nop
80103afe:	90                   	nop
80103aff:	90                   	nop

80103b00 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	89 c6                	mov    %eax,%esi
80103b06:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b07:	bb 54 3f 11 80       	mov    $0x80113f54,%ebx
80103b0c:	eb 10                	jmp    80103b1e <wakeup1+0x1e>
80103b0e:	66 90                	xchg   %ax,%ax
80103b10:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
80103b16:	81 fb 54 70 11 80    	cmp    $0x80117054,%ebx
80103b1c:	73 3b                	jae    80103b59 <wakeup1+0x59>
    if(p->state == SLEEPING && p->chan == chan)
80103b1e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103b22:	75 ec                	jne    80103b10 <wakeup1+0x10>
80103b24:	39 73 20             	cmp    %esi,0x20(%ebx)
80103b27:	75 e7                	jne    80103b10 <wakeup1+0x10>
    {
      p->state = RUNNABLE;

      //brand new
      if(p->priority<NPROCQ-1)
80103b29:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
      p->state = RUNNABLE;
80103b2f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      if(p->priority<NPROCQ-1)
80103b36:	83 f8 01             	cmp    $0x1,%eax
80103b39:	77 09                	ja     80103b44 <wakeup1+0x44>
        p->priority++;
80103b3b:	83 c0 01             	add    $0x1,%eax
80103b3e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
      qpush(p);
80103b44:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b45:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
      qpush(p);
80103b4b:	e8 20 ff ff ff       	call   80103a70 <qpush>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b50:	81 fb 54 70 11 80    	cmp    $0x80117054,%ebx
      qpush(p);
80103b56:	58                   	pop    %eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b57:	72 c5                	jb     80103b1e <wakeup1+0x1e>

    }
}
80103b59:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b5c:	5b                   	pop    %ebx
80103b5d:	5e                   	pop    %esi
80103b5e:	5d                   	pop    %ebp
80103b5f:	c3                   	ret    

80103b60 <userinit>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
80103b64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b67:	e8 d4 fc ff ff       	call   80103840 <allocproc>
80103b6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b6e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103b73:	e8 c8 37 00 00       	call   80107340 <setupkvm>
80103b78:	85 c0                	test   %eax,%eax
80103b7a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b7d:	0f 84 c5 00 00 00    	je     80103c48 <userinit+0xe8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b83:	83 ec 04             	sub    $0x4,%esp
80103b86:	68 2c 00 00 00       	push   $0x2c
80103b8b:	68 60 b4 10 80       	push   $0x8010b460
80103b90:	50                   	push   %eax
80103b91:	e8 6a 33 00 00       	call   80106f00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b9f:	6a 4c                	push   $0x4c
80103ba1:	6a 00                	push   $0x0
80103ba3:	ff 73 18             	pushl  0x18(%ebx)
80103ba6:	e8 85 0d 00 00       	call   80104930 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bab:	8b 43 18             	mov    0x18(%ebx),%eax
80103bae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bb3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bb8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bbf:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bcd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bd1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bdc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bdf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103be6:	8b 43 18             	mov    0x18(%ebx),%eax
80103be9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103bf0:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bfa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bfd:	6a 10                	push   $0x10
80103bff:	68 85 7b 10 80       	push   $0x80107b85
80103c04:	50                   	push   %eax
80103c05:	e8 06 0f 00 00       	call   80104b10 <safestrcpy>
  p->cwd = namei("/");
80103c0a:	c7 04 24 8e 7b 10 80 	movl   $0x80107b8e,(%esp)
80103c11:	e8 0a e5 ff ff       	call   80102120 <namei>
80103c16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c19:	c7 04 24 20 3f 11 80 	movl   $0x80113f20,(%esp)
80103c20:	e8 8b 0b 00 00       	call   801047b0 <acquire>
  p->state = RUNNABLE;
80103c25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  qpush(p);
80103c2c:	89 1c 24             	mov    %ebx,(%esp)
80103c2f:	e8 3c fe ff ff       	call   80103a70 <qpush>
  release(&ptable.lock);
80103c34:	c7 04 24 20 3f 11 80 	movl   $0x80113f20,(%esp)
80103c3b:	e8 90 0c 00 00       	call   801048d0 <release>
}
80103c40:	83 c4 10             	add    $0x10,%esp
80103c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c46:	c9                   	leave  
80103c47:	c3                   	ret    
    panic("userinit: out of memory?");
80103c48:	83 ec 0c             	sub    $0xc,%esp
80103c4b:	68 6c 7b 10 80       	push   $0x80107b6c
80103c50:	e8 3b c7 ff ff       	call   80100390 <panic>
80103c55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c60 <releaseshared>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	56                   	push   %esi
80103c64:	53                   	push   %ebx
80103c65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103c68:	e8 03 0b 00 00       	call   80104770 <pushcli>
  c = mycpu();
80103c6d:	e8 2e fd ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103c72:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c78:	e8 f3 0b 00 00       	call   80104870 <popcli>
  if(curproc->sharedrec[idx]!='s')
80103c7d:	80 bc 1e 8c 00 00 00 	cmpb   $0x73,0x8c(%esi,%ebx,1)
80103c84:	73 
80103c85:	74 09                	je     80103c90 <releaseshared+0x30>
}
80103c87:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c8a:	31 c0                	xor    %eax,%eax
80103c8c:	5b                   	pop    %ebx
80103c8d:	5e                   	pop    %esi
80103c8e:	5d                   	pop    %ebp
80103c8f:	c3                   	ret    
  desharevm(idx);
80103c90:	83 ec 0c             	sub    $0xc,%esp
  curproc->sharedrec[idx]=0;
80103c93:	c6 84 1e 8c 00 00 00 	movb   $0x0,0x8c(%esi,%ebx,1)
80103c9a:	00 
  desharevm(idx);
80103c9b:	53                   	push   %ebx
80103c9c:	e8 cf 35 00 00       	call   80107270 <desharevm>
  return 0;
80103ca1:	83 c4 10             	add    $0x10,%esp
}
80103ca4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ca7:	31 c0                	xor    %eax,%eax
80103ca9:	5b                   	pop    %ebx
80103caa:	5e                   	pop    %esi
80103cab:	5d                   	pop    %ebp
80103cac:	c3                   	ret    
80103cad:	8d 76 00             	lea    0x0(%esi),%esi

80103cb0 <getshared>:
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	57                   	push   %edi
80103cb4:	56                   	push   %esi
80103cb5:	53                   	push   %ebx
80103cb6:	83 ec 0c             	sub    $0xc,%esp
80103cb9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cbc:	e8 af 0a 00 00       	call   80104770 <pushcli>
  c = mycpu();
80103cc1:	e8 da fc ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103cc6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ccc:	e8 9f 0b 00 00       	call   80104870 <popcli>
  if(curproc->sharedrec[idx]=='s'){
80103cd1:	80 bc 33 8c 00 00 00 	cmpb   $0x73,0x8c(%ebx,%esi,1)
80103cd8:	73 
80103cd9:	74 55                	je     80103d30 <getshared+0x80>
  sharevm(curproc->pgdir, idx, curproc->nshared);
80103cdb:	83 ec 04             	sub    $0x4,%esp
80103cde:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80103ce4:	8d 3c b3             	lea    (%ebx,%esi,4),%edi
80103ce7:	56                   	push   %esi
80103ce8:	ff 73 04             	pushl  0x4(%ebx)
80103ceb:	e8 50 33 00 00       	call   80107040 <sharevm>
  curproc->nshared++;
80103cf0:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
  curproc->sharedvm[idx]=(char*)KERNBASE-(curproc->nshared)*PGSIZE;
80103cf6:	ba 00 00 00 80       	mov    $0x80000000,%edx
  curproc->nshared++;
80103cfb:	83 c0 01             	add    $0x1,%eax
80103cfe:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  curproc->sharedvm[idx]=(char*)KERNBASE-(curproc->nshared)*PGSIZE;
80103d04:	c1 e0 0c             	shl    $0xc,%eax
80103d07:	29 c2                	sub    %eax,%edx
80103d09:	89 97 98 00 00 00    	mov    %edx,0x98(%edi)
  curproc->sharedrec[idx]='s';
80103d0f:	c6 84 33 8c 00 00 00 	movb   $0x73,0x8c(%ebx,%esi,1)
80103d16:	73 
  switchuvm(curproc);
80103d17:	89 1c 24             	mov    %ebx,(%esp)
80103d1a:	e8 d1 30 00 00       	call   80106df0 <switchuvm>
  return curproc->sharedvm[idx];
80103d1f:	8b 87 98 00 00 00    	mov    0x98(%edi),%eax
80103d25:	83 c4 10             	add    $0x10,%esp
}
80103d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d2b:	5b                   	pop    %ebx
80103d2c:	5e                   	pop    %esi
80103d2d:	5f                   	pop    %edi
80103d2e:	5d                   	pop    %ebp
80103d2f:	c3                   	ret    
    return curproc->sharedvm[idx];
80103d30:	8b 84 b3 98 00 00 00 	mov    0x98(%ebx,%esi,4),%eax
}
80103d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d3a:	5b                   	pop    %ebx
80103d3b:	5e                   	pop    %esi
80103d3c:	5f                   	pop    %edi
80103d3d:	5d                   	pop    %ebp
80103d3e:	c3                   	ret    
80103d3f:	90                   	nop

80103d40 <growproc>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	56                   	push   %esi
80103d44:	53                   	push   %ebx
80103d45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d48:	e8 23 0a 00 00       	call   80104770 <pushcli>
  c = mycpu();
80103d4d:	e8 4e fc ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103d52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d58:	e8 13 0b 00 00       	call   80104870 <popcli>
  if(n > 0){
80103d5d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103d60:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d62:	7f 1c                	jg     80103d80 <growproc+0x40>
  } else if(n < 0){
80103d64:	75 3a                	jne    80103da0 <growproc+0x60>
  switchuvm(curproc);
80103d66:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d69:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d6b:	53                   	push   %ebx
80103d6c:	e8 7f 30 00 00       	call   80106df0 <switchuvm>
  return 0;
80103d71:	83 c4 10             	add    $0x10,%esp
80103d74:	31 c0                	xor    %eax,%eax
}
80103d76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d79:	5b                   	pop    %ebx
80103d7a:	5e                   	pop    %esi
80103d7b:	5d                   	pop    %ebp
80103d7c:	c3                   	ret    
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n,curproc->nshared)) == 0)
80103d80:	01 c6                	add    %eax,%esi
80103d82:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80103d88:	56                   	push   %esi
80103d89:	50                   	push   %eax
80103d8a:	ff 73 04             	pushl  0x4(%ebx)
80103d8d:	e8 9e 33 00 00       	call   80107130 <allocuvm>
80103d92:	83 c4 10             	add    $0x10,%esp
80103d95:	85 c0                	test   %eax,%eax
80103d97:	75 cd                	jne    80103d66 <growproc+0x26>
      return -1;
80103d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d9e:	eb d6                	jmp    80103d76 <growproc+0x36>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103da0:	83 ec 04             	sub    $0x4,%esp
80103da3:	01 c6                	add    %eax,%esi
80103da5:	56                   	push   %esi
80103da6:	50                   	push   %eax
80103da7:	ff 73 04             	pushl  0x4(%ebx)
80103daa:	e8 91 34 00 00       	call   80107240 <deallocuvm>
80103daf:	83 c4 10             	add    $0x10,%esp
80103db2:	85 c0                	test   %eax,%eax
80103db4:	75 b0                	jne    80103d66 <growproc+0x26>
80103db6:	eb e1                	jmp    80103d99 <growproc+0x59>
80103db8:	90                   	nop
80103db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103dc0 <fork>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	57                   	push   %edi
80103dc4:	56                   	push   %esi
80103dc5:	53                   	push   %ebx
80103dc6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103dc9:	e8 a2 09 00 00       	call   80104770 <pushcli>
  c = mycpu();
80103dce:	e8 cd fb ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103dd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dd9:	e8 92 0a 00 00       	call   80104870 <popcli>
  if((np = allocproc()) == 0){
80103dde:	e8 5d fa ff ff       	call   80103840 <allocproc>
80103de3:	85 c0                	test   %eax,%eax
80103de5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103de8:	0f 84 f7 00 00 00    	je     80103ee5 <fork+0x125>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dee:	83 ec 08             	sub    $0x8,%esp
80103df1:	ff 33                	pushl  (%ebx)
80103df3:	ff 73 04             	pushl  0x4(%ebx)
80103df6:	89 c7                	mov    %eax,%edi
80103df8:	e8 13 36 00 00       	call   80107410 <copyuvm>
80103dfd:	83 c4 10             	add    $0x10,%esp
80103e00:	85 c0                	test   %eax,%eax
80103e02:	89 47 04             	mov    %eax,0x4(%edi)
80103e05:	0f 84 e1 00 00 00    	je     80103eec <fork+0x12c>
  np->sz = curproc->sz;
80103e0b:	8b 03                	mov    (%ebx),%eax
80103e0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103e10:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103e15:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103e17:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103e1a:	8b 7a 18             	mov    0x18(%edx),%edi
80103e1d:	8b 73 18             	mov    0x18(%ebx),%esi
80103e20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e22:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e24:	8b 42 18             	mov    0x18(%edx),%eax
80103e27:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103e2e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80103e30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e34:	85 c0                	test   %eax,%eax
80103e36:	74 13                	je     80103e4b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e38:	83 ec 0c             	sub    $0xc,%esp
80103e3b:	50                   	push   %eax
80103e3c:	e8 9f d1 ff ff       	call   80100fe0 <filedup>
80103e41:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e44:	83 c4 10             	add    $0x10,%esp
80103e47:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e4b:	83 c6 01             	add    $0x1,%esi
80103e4e:	83 fe 10             	cmp    $0x10,%esi
80103e51:	75 dd                	jne    80103e30 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e53:	83 ec 0c             	sub    $0xc,%esp
80103e56:	ff 73 68             	pushl  0x68(%ebx)
80103e59:	e8 32 da ff ff       	call   80101890 <idup>
80103e5e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e61:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e64:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e67:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e6a:	6a 10                	push   $0x10
80103e6c:	50                   	push   %eax
80103e6d:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e70:	50                   	push   %eax
80103e71:	e8 9a 0c 00 00       	call   80104b10 <safestrcpy>
  pid = np->pid;
80103e76:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
80103e79:	c7 04 24 20 3f 11 80 	movl   $0x80113f20,(%esp)
80103e80:	e8 2b 09 00 00       	call   801047b0 <acquire>
  np->state = RUNNABLE;
80103e85:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  qpush(np);
80103e8c:	89 3c 24             	mov    %edi,(%esp)
80103e8f:	e8 dc fb ff ff       	call   80103a70 <qpush>
80103e94:	8d 87 8c 00 00 00    	lea    0x8c(%edi),%eax
80103e9a:	8d 97 96 00 00 00    	lea    0x96(%edi),%edx
80103ea0:	83 c4 10             	add    $0x10,%esp
80103ea3:	90                   	nop
80103ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->sharedrec[i]=0;
80103ea8:	c6 00 00             	movb   $0x0,(%eax)
80103eab:	83 c0 01             	add    $0x1,%eax
  for(i=0;i<MAXSHAREDPG;i++)
80103eae:	39 c2                	cmp    %eax,%edx
80103eb0:	75 f6                	jne    80103ea8 <fork+0xe8>
  np->nshared=0;
80103eb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  release(&ptable.lock);
80103eb5:	83 ec 0c             	sub    $0xc,%esp
  np->nshared=0;
80103eb8:	c7 82 88 00 00 00 00 	movl   $0x0,0x88(%edx)
80103ebf:	00 00 00 
  np->wdidx=curproc->wdidx;
80103ec2:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
80103ec8:	89 82 c0 00 00 00    	mov    %eax,0xc0(%edx)
  release(&ptable.lock);
80103ece:	68 20 3f 11 80       	push   $0x80113f20
80103ed3:	e8 f8 09 00 00       	call   801048d0 <release>
  return pid;
80103ed8:	83 c4 10             	add    $0x10,%esp
}
80103edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ede:	89 f0                	mov    %esi,%eax
80103ee0:	5b                   	pop    %ebx
80103ee1:	5e                   	pop    %esi
80103ee2:	5f                   	pop    %edi
80103ee3:	5d                   	pop    %ebp
80103ee4:	c3                   	ret    
    return -1;
80103ee5:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103eea:	eb ef                	jmp    80103edb <fork+0x11b>
    kfree(np->kstack);
80103eec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103eef:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103ef2:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103ef7:	ff 73 08             	pushl  0x8(%ebx)
80103efa:	e8 51 e6 ff ff       	call   80102550 <kfree>
    np->kstack = 0;
80103eff:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103f06:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f0d:	83 c4 10             	add    $0x10,%esp
80103f10:	eb c9                	jmp    80103edb <fork+0x11b>
80103f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f20 <scheduler>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103f29:	e8 72 fa ff ff       	call   801039a0 <mycpu>
  c->proc = 0;
80103f2e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f35:	00 00 00 
  struct cpu *c = mycpu();
80103f38:	89 c6                	mov    %eax,%esi
80103f3a:	8d 40 04             	lea    0x4(%eax),%eax
80103f3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103f40:	fb                   	sti    
    acquire(&ptable.lock);
80103f41:	83 ec 0c             	sub    $0xc,%esp
    int queue=NPROCQ-1;
80103f44:	bf 02 00 00 00       	mov    $0x2,%edi
    acquire(&ptable.lock);
80103f49:	68 20 3f 11 80       	push   $0x80113f20
80103f4e:	e8 5d 08 00 00       	call   801047b0 <acquire>
80103f53:	ba 20 3f 11 80       	mov    $0x80113f20,%edx
80103f58:	83 c4 10             	add    $0x10,%esp
80103f5b:	89 d1                	mov    %edx,%ecx
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103f5d:	8b 82 54 31 00 00    	mov    0x3154(%edx),%eax
80103f63:	85 c0                	test   %eax,%eax
80103f65:	74 35                	je     80103f9c <scheduler+0x7c>
80103f67:	8b 99 44 31 00 00    	mov    0x3144(%ecx),%ebx
80103f6d:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f71:	75 13                	jne    80103f86 <scheduler+0x66>
80103f73:	e9 b8 00 00 00       	jmp    80104030 <scheduler+0x110>
80103f78:	90                   	nop
80103f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f84:	74 3a                	je     80103fc0 <scheduler+0xa0>
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103f86:	8b 5b 7c             	mov    0x7c(%ebx),%ebx
        ptable.count[queue]--;
80103f89:	83 e8 01             	sub    $0x1,%eax
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103f8c:	85 c0                	test   %eax,%eax
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103f8e:	89 99 44 31 00 00    	mov    %ebx,0x3144(%ecx)
        ptable.count[queue]--;
80103f94:	89 82 54 31 00 00    	mov    %eax,0x3154(%edx)
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103f9a:	75 e4                	jne    80103f80 <scheduler+0x60>
    for(;queue>=0;queue--)
80103f9c:	83 ef 01             	sub    $0x1,%edi
80103f9f:	83 ea 04             	sub    $0x4,%edx
80103fa2:	83 e9 08             	sub    $0x8,%ecx
80103fa5:	83 ff ff             	cmp    $0xffffffff,%edi
80103fa8:	75 b3                	jne    80103f5d <scheduler+0x3d>
    release(&ptable.lock);
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	68 20 3f 11 80       	push   $0x80113f20
80103fb2:	e8 19 09 00 00       	call   801048d0 <release>
  for(;;){
80103fb7:	83 c4 10             	add    $0x10,%esp
80103fba:	eb 84                	jmp    80103f40 <scheduler+0x20>
80103fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fc0:	8d 97 26 06 00 00    	lea    0x626(%edi),%edx
80103fc6:	8b 1c d5 24 3f 11 80 	mov    -0x7feec0dc(,%edx,8),%ebx
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103fcd:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
        switchuvm(p);
80103fd0:	83 ec 0c             	sub    $0xc,%esp
        ptable.count[queue]--;
80103fd3:	83 e8 01             	sub    $0x1,%eax
80103fd6:	89 04 bd 6c 70 11 80 	mov    %eax,-0x7fee8f94(,%edi,4)
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103fdd:	89 0c d5 24 3f 11 80 	mov    %ecx,-0x7feec0dc(,%edx,8)
        c->proc = p;
80103fe4:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
        switchuvm(p);
80103fea:	53                   	push   %ebx
80103feb:	e8 00 2e 00 00       	call   80106df0 <switchuvm>
        p->state = RUNNING;
80103ff0:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        swtch(&(c->scheduler), p->context);
80103ff7:	58                   	pop    %eax
80103ff8:	5a                   	pop    %edx
80103ff9:	ff 73 1c             	pushl  0x1c(%ebx)
80103ffc:	ff 75 e4             	pushl  -0x1c(%ebp)
80103fff:	e8 67 0b 00 00       	call   80104b6b <swtch>
        switchkvm();
80104004:	e8 c7 2d 00 00       	call   80106dd0 <switchkvm>
        break;
80104009:	83 c4 10             	add    $0x10,%esp
        c->proc = 0;
8010400c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104013:	00 00 00 
    release(&ptable.lock);
80104016:	83 ec 0c             	sub    $0xc,%esp
80104019:	68 20 3f 11 80       	push   $0x80113f20
8010401e:	e8 ad 08 00 00       	call   801048d0 <release>
  for(;;){
80104023:	83 c4 10             	add    $0x10,%esp
80104026:	e9 15 ff ff ff       	jmp    80103f40 <scheduler+0x20>
8010402b:	90                   	nop
8010402c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104030:	8d 97 26 06 00 00    	lea    0x626(%edi),%edx
80104036:	eb 95                	jmp    80103fcd <scheduler+0xad>
80104038:	90                   	nop
80104039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104040 <sched>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
  pushcli();
80104045:	e8 26 07 00 00       	call   80104770 <pushcli>
  c = mycpu();
8010404a:	e8 51 f9 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
8010404f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104055:	e8 16 08 00 00       	call   80104870 <popcli>
  if(!holding(&ptable.lock))
8010405a:	83 ec 0c             	sub    $0xc,%esp
8010405d:	68 20 3f 11 80       	push   $0x80113f20
80104062:	e8 c9 06 00 00       	call   80104730 <holding>
80104067:	83 c4 10             	add    $0x10,%esp
8010406a:	85 c0                	test   %eax,%eax
8010406c:	74 4f                	je     801040bd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010406e:	e8 2d f9 ff ff       	call   801039a0 <mycpu>
80104073:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010407a:	75 68                	jne    801040e4 <sched+0xa4>
  if(p->state == RUNNING)
8010407c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104080:	74 55                	je     801040d7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104082:	9c                   	pushf  
80104083:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104084:	f6 c4 02             	test   $0x2,%ah
80104087:	75 41                	jne    801040ca <sched+0x8a>
  intena = mycpu()->intena;
80104089:	e8 12 f9 ff ff       	call   801039a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010408e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104091:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104097:	e8 04 f9 ff ff       	call   801039a0 <mycpu>
8010409c:	83 ec 08             	sub    $0x8,%esp
8010409f:	ff 70 04             	pushl  0x4(%eax)
801040a2:	53                   	push   %ebx
801040a3:	e8 c3 0a 00 00       	call   80104b6b <swtch>
  mycpu()->intena = intena;
801040a8:	e8 f3 f8 ff ff       	call   801039a0 <mycpu>
}
801040ad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801040b0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801040b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040b9:	5b                   	pop    %ebx
801040ba:	5e                   	pop    %esi
801040bb:	5d                   	pop    %ebp
801040bc:	c3                   	ret    
    panic("sched ptable.lock");
801040bd:	83 ec 0c             	sub    $0xc,%esp
801040c0:	68 90 7b 10 80       	push   $0x80107b90
801040c5:	e8 c6 c2 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801040ca:	83 ec 0c             	sub    $0xc,%esp
801040cd:	68 bc 7b 10 80       	push   $0x80107bbc
801040d2:	e8 b9 c2 ff ff       	call   80100390 <panic>
    panic("sched running");
801040d7:	83 ec 0c             	sub    $0xc,%esp
801040da:	68 ae 7b 10 80       	push   $0x80107bae
801040df:	e8 ac c2 ff ff       	call   80100390 <panic>
    panic("sched locks");
801040e4:	83 ec 0c             	sub    $0xc,%esp
801040e7:	68 a2 7b 10 80       	push   $0x80107ba2
801040ec:	e8 9f c2 ff ff       	call   80100390 <panic>
801040f1:	eb 0d                	jmp    80104100 <exit>
801040f3:	90                   	nop
801040f4:	90                   	nop
801040f5:	90                   	nop
801040f6:	90                   	nop
801040f7:	90                   	nop
801040f8:	90                   	nop
801040f9:	90                   	nop
801040fa:	90                   	nop
801040fb:	90                   	nop
801040fc:	90                   	nop
801040fd:	90                   	nop
801040fe:	90                   	nop
801040ff:	90                   	nop

80104100 <exit>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	57                   	push   %edi
80104104:	56                   	push   %esi
80104105:	53                   	push   %ebx
80104106:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104109:	e8 62 06 00 00       	call   80104770 <pushcli>
  c = mycpu();
8010410e:	e8 8d f8 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104113:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104119:	e8 52 07 00 00       	call   80104870 <popcli>
  if(curproc == initproc)
8010411e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104124:	8d 5e 28             	lea    0x28(%esi),%ebx
80104127:	8d 7e 68             	lea    0x68(%esi),%edi
8010412a:	0f 84 b1 00 00 00    	je     801041e1 <exit+0xe1>
    if(curproc->ofile[fd]){
80104130:	8b 03                	mov    (%ebx),%eax
80104132:	85 c0                	test   %eax,%eax
80104134:	74 12                	je     80104148 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	50                   	push   %eax
8010413a:	e8 f1 ce ff ff       	call   80101030 <fileclose>
      curproc->ofile[fd] = 0;
8010413f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104145:	83 c4 10             	add    $0x10,%esp
80104148:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010414b:	39 df                	cmp    %ebx,%edi
8010414d:	75 e1                	jne    80104130 <exit+0x30>
  begin_op();
8010414f:	e8 8c ec ff ff       	call   80102de0 <begin_op>
  iput(curproc->cwd);
80104154:	83 ec 0c             	sub    $0xc,%esp
80104157:	ff 76 68             	pushl  0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415a:	bb 54 3f 11 80       	mov    $0x80113f54,%ebx
  iput(curproc->cwd);
8010415f:	e8 8c d8 ff ff       	call   801019f0 <iput>
  end_op();
80104164:	e8 e7 ec ff ff       	call   80102e50 <end_op>
  curproc->cwd = 0;
80104169:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104170:	c7 04 24 20 3f 11 80 	movl   $0x80113f20,(%esp)
80104177:	e8 34 06 00 00       	call   801047b0 <acquire>
  wakeup1(curproc->parent);
8010417c:	8b 46 14             	mov    0x14(%esi),%eax
8010417f:	e8 7c f9 ff ff       	call   80103b00 <wakeup1>
80104184:	83 c4 10             	add    $0x10,%esp
80104187:	eb 15                	jmp    8010419e <exit+0x9e>
80104189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104190:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
80104196:	81 fb 54 70 11 80    	cmp    $0x80117054,%ebx
8010419c:	73 2a                	jae    801041c8 <exit+0xc8>
    if(p->parent == curproc){
8010419e:	39 73 14             	cmp    %esi,0x14(%ebx)
801041a1:	75 ed                	jne    80104190 <exit+0x90>
      if(p->state == ZOMBIE)
801041a3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
801041a7:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
801041ac:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801041af:	75 df                	jne    80104190 <exit+0x90>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b1:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
        wakeup1(initproc);
801041b7:	e8 44 f9 ff ff       	call   80103b00 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041bc:	81 fb 54 70 11 80    	cmp    $0x80117054,%ebx
801041c2:	72 da                	jb     8010419e <exit+0x9e>
801041c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
801041c8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801041cf:	e8 6c fe ff ff       	call   80104040 <sched>
  panic("zombie exit");
801041d4:	83 ec 0c             	sub    $0xc,%esp
801041d7:	68 dd 7b 10 80       	push   $0x80107bdd
801041dc:	e8 af c1 ff ff       	call   80100390 <panic>
    panic("init exiting");
801041e1:	83 ec 0c             	sub    $0xc,%esp
801041e4:	68 d0 7b 10 80       	push   $0x80107bd0
801041e9:	e8 a2 c1 ff ff       	call   80100390 <panic>
801041ee:	66 90                	xchg   %ax,%ax

801041f0 <yield>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	53                   	push   %ebx
801041f4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801041f7:	e8 74 05 00 00       	call   80104770 <pushcli>
  c = mycpu();
801041fc:	e8 9f f7 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104201:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104207:	e8 64 06 00 00       	call   80104870 <popcli>
  acquire(&ptable.lock);  //DOC: yieldlock
8010420c:	83 ec 0c             	sub    $0xc,%esp
8010420f:	68 20 3f 11 80       	push   $0x80113f20
80104214:	e8 97 05 00 00       	call   801047b0 <acquire>
  if(p->priority>0)
80104219:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010421f:	83 c4 10             	add    $0x10,%esp
  p->state = RUNNABLE;
80104222:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  if(p->priority>0)
80104229:	85 c0                	test   %eax,%eax
8010422b:	74 09                	je     80104236 <yield+0x46>
    p->priority--;
8010422d:	83 e8 01             	sub    $0x1,%eax
80104230:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  qpush(p);
80104236:	83 ec 0c             	sub    $0xc,%esp
80104239:	53                   	push   %ebx
8010423a:	e8 31 f8 ff ff       	call   80103a70 <qpush>
  sched();
8010423f:	e8 fc fd ff ff       	call   80104040 <sched>
  release(&ptable.lock);
80104244:	c7 04 24 20 3f 11 80 	movl   $0x80113f20,(%esp)
8010424b:	e8 80 06 00 00       	call   801048d0 <release>
}
80104250:	83 c4 10             	add    $0x10,%esp
80104253:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104256:	c9                   	leave  
80104257:	c3                   	ret    
80104258:	90                   	nop
80104259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104260 <sleep>:
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	57                   	push   %edi
80104264:	56                   	push   %esi
80104265:	53                   	push   %ebx
80104266:	83 ec 0c             	sub    $0xc,%esp
80104269:	8b 7d 08             	mov    0x8(%ebp),%edi
8010426c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010426f:	e8 fc 04 00 00       	call   80104770 <pushcli>
  c = mycpu();
80104274:	e8 27 f7 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104279:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010427f:	e8 ec 05 00 00       	call   80104870 <popcli>
  if(p == 0)
80104284:	85 db                	test   %ebx,%ebx
80104286:	0f 84 87 00 00 00    	je     80104313 <sleep+0xb3>
  if(lk == 0)
8010428c:	85 f6                	test   %esi,%esi
8010428e:	74 76                	je     80104306 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104290:	81 fe 20 3f 11 80    	cmp    $0x80113f20,%esi
80104296:	74 50                	je     801042e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	68 20 3f 11 80       	push   $0x80113f20
801042a0:	e8 0b 05 00 00       	call   801047b0 <acquire>
    release(lk);
801042a5:	89 34 24             	mov    %esi,(%esp)
801042a8:	e8 23 06 00 00       	call   801048d0 <release>
  p->chan = chan;
801042ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042b7:	e8 84 fd ff ff       	call   80104040 <sched>
  p->chan = 0;
801042bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042c3:	c7 04 24 20 3f 11 80 	movl   $0x80113f20,(%esp)
801042ca:	e8 01 06 00 00       	call   801048d0 <release>
    acquire(lk);
801042cf:	89 75 08             	mov    %esi,0x8(%ebp)
801042d2:	83 c4 10             	add    $0x10,%esp
}
801042d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042d8:	5b                   	pop    %ebx
801042d9:	5e                   	pop    %esi
801042da:	5f                   	pop    %edi
801042db:	5d                   	pop    %ebp
    acquire(lk);
801042dc:	e9 cf 04 00 00       	jmp    801047b0 <acquire>
801042e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042f2:	e8 49 fd ff ff       	call   80104040 <sched>
  p->chan = 0;
801042f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104301:	5b                   	pop    %ebx
80104302:	5e                   	pop    %esi
80104303:	5f                   	pop    %edi
80104304:	5d                   	pop    %ebp
80104305:	c3                   	ret    
    panic("sleep without lk");
80104306:	83 ec 0c             	sub    $0xc,%esp
80104309:	68 ef 7b 10 80       	push   $0x80107bef
8010430e:	e8 7d c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104313:	83 ec 0c             	sub    $0xc,%esp
80104316:	68 e9 7b 10 80       	push   $0x80107be9
8010431b:	e8 70 c0 ff ff       	call   80100390 <panic>

80104320 <wait>:
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	57                   	push   %edi
80104324:	56                   	push   %esi
80104325:	53                   	push   %ebx
80104326:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104329:	e8 42 04 00 00       	call   80104770 <pushcli>
  c = mycpu();
8010432e:	e8 6d f6 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104333:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104339:	e8 32 05 00 00       	call   80104870 <popcli>
  acquire(&ptable.lock);
8010433e:	83 ec 0c             	sub    $0xc,%esp
80104341:	68 20 3f 11 80       	push   $0x80113f20
80104346:	e8 65 04 00 00       	call   801047b0 <acquire>
8010434b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010434e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104350:	bb 54 3f 11 80       	mov    $0x80113f54,%ebx
80104355:	eb 17                	jmp    8010436e <wait+0x4e>
80104357:	89 f6                	mov    %esi,%esi
80104359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104360:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
80104366:	81 fb 54 70 11 80    	cmp    $0x80117054,%ebx
8010436c:	73 1e                	jae    8010438c <wait+0x6c>
      if(p->parent != curproc)
8010436e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104371:	75 ed                	jne    80104360 <wait+0x40>
      if(p->state == ZOMBIE){
80104373:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104377:	74 37                	je     801043b0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104379:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
      havekids = 1;
8010437f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104384:	81 fb 54 70 11 80    	cmp    $0x80117054,%ebx
8010438a:	72 e2                	jb     8010436e <wait+0x4e>
    if(!havekids || curproc->killed){
8010438c:	85 c0                	test   %eax,%eax
8010438e:	74 7e                	je     8010440e <wait+0xee>
80104390:	8b 46 24             	mov    0x24(%esi),%eax
80104393:	85 c0                	test   %eax,%eax
80104395:	75 77                	jne    8010440e <wait+0xee>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104397:	83 ec 08             	sub    $0x8,%esp
8010439a:	68 20 3f 11 80       	push   $0x80113f20
8010439f:	56                   	push   %esi
801043a0:	e8 bb fe ff ff       	call   80104260 <sleep>
    havekids = 0;
801043a5:	83 c4 10             	add    $0x10,%esp
801043a8:	eb a4                	jmp    8010434e <wait+0x2e>
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801043b0:	83 ec 0c             	sub    $0xc,%esp
801043b3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801043b6:	8b 7b 10             	mov    0x10(%ebx),%edi
        kfree(p->kstack);
801043b9:	e8 92 e1 ff ff       	call   80102550 <kfree>
        freevm(p->pgdir,curproc->nshared);
801043be:	5a                   	pop    %edx
801043bf:	59                   	pop    %ecx
        p->kstack = 0;
801043c0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir,curproc->nshared);
801043c7:	ff b6 88 00 00 00    	pushl  0x88(%esi)
801043cd:	ff 73 04             	pushl  0x4(%ebx)
801043d0:	e8 db 2e 00 00       	call   801072b0 <freevm>
        release(&ptable.lock);
801043d5:	c7 04 24 20 3f 11 80 	movl   $0x80113f20,(%esp)
        p->pid = 0;
801043dc:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801043e3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801043ea:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801043ee:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801043f5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801043fc:	e8 cf 04 00 00       	call   801048d0 <release>
        return pid;
80104401:	83 c4 10             	add    $0x10,%esp
}
80104404:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104407:	89 f8                	mov    %edi,%eax
80104409:	5b                   	pop    %ebx
8010440a:	5e                   	pop    %esi
8010440b:	5f                   	pop    %edi
8010440c:	5d                   	pop    %ebp
8010440d:	c3                   	ret    
      release(&ptable.lock);
8010440e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104411:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      release(&ptable.lock);
80104416:	68 20 3f 11 80       	push   $0x80113f20
8010441b:	e8 b0 04 00 00       	call   801048d0 <release>
      return -1;
80104420:	83 c4 10             	add    $0x10,%esp
80104423:	eb df                	jmp    80104404 <wait+0xe4>
80104425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104430 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	53                   	push   %ebx
80104434:	83 ec 10             	sub    $0x10,%esp
80104437:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010443a:	68 20 3f 11 80       	push   $0x80113f20
8010443f:	e8 6c 03 00 00       	call   801047b0 <acquire>
  wakeup1(chan);
80104444:	89 d8                	mov    %ebx,%eax
80104446:	e8 b5 f6 ff ff       	call   80103b00 <wakeup1>
  release(&ptable.lock);
8010444b:	83 c4 10             	add    $0x10,%esp
8010444e:	c7 45 08 20 3f 11 80 	movl   $0x80113f20,0x8(%ebp)
}
80104455:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104458:	c9                   	leave  
  release(&ptable.lock);
80104459:	e9 72 04 00 00       	jmp    801048d0 <release>
8010445e:	66 90                	xchg   %ax,%ax

80104460 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 10             	sub    $0x10,%esp
80104467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010446a:	68 20 3f 11 80       	push   $0x80113f20
8010446f:	e8 3c 03 00 00       	call   801047b0 <acquire>
80104474:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104477:	b8 54 3f 11 80       	mov    $0x80113f54,%eax
8010447c:	eb 0e                	jmp    8010448c <kill+0x2c>
8010447e:	66 90                	xchg   %ax,%ax
80104480:	05 c4 00 00 00       	add    $0xc4,%eax
80104485:	3d 54 70 11 80       	cmp    $0x80117054,%eax
8010448a:	73 34                	jae    801044c0 <kill+0x60>
    if(p->pid == pid){
8010448c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010448f:	75 ef                	jne    80104480 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104491:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104495:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010449c:	75 07                	jne    801044a5 <kill+0x45>
        p->state = RUNNABLE;
8010449e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044a5:	83 ec 0c             	sub    $0xc,%esp
801044a8:	68 20 3f 11 80       	push   $0x80113f20
801044ad:	e8 1e 04 00 00       	call   801048d0 <release>
      return 0;
801044b2:	83 c4 10             	add    $0x10,%esp
801044b5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801044b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044ba:	c9                   	leave  
801044bb:	c3                   	ret    
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801044c0:	83 ec 0c             	sub    $0xc,%esp
801044c3:	68 20 3f 11 80       	push   $0x80113f20
801044c8:	e8 03 04 00 00       	call   801048d0 <release>
  return -1;
801044cd:	83 c4 10             	add    $0x10,%esp
801044d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044d8:	c9                   	leave  
801044d9:	c3                   	ret    
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	56                   	push   %esi
801044e5:	53                   	push   %ebx
801044e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044e9:	bb 54 3f 11 80       	mov    $0x80113f54,%ebx
{
801044ee:	83 ec 3c             	sub    $0x3c,%esp
801044f1:	eb 27                	jmp    8010451a <procdump+0x3a>
801044f3:	90                   	nop
801044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	68 8b 7f 10 80       	push   $0x80107f8b
80104500:	e8 db c1 ff ff       	call   801006e0 <cprintf>
80104505:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104508:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
8010450e:	81 fb 54 70 11 80    	cmp    $0x80117054,%ebx
80104514:	0f 83 86 00 00 00    	jae    801045a0 <procdump+0xc0>
    if(p->state == UNUSED)
8010451a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010451d:	85 c0                	test   %eax,%eax
8010451f:	74 e7                	je     80104508 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104521:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104524:	ba 00 7c 10 80       	mov    $0x80107c00,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104529:	77 11                	ja     8010453c <procdump+0x5c>
8010452b:	8b 14 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%edx
      state = "???";
80104532:	b8 00 7c 10 80       	mov    $0x80107c00,%eax
80104537:	85 d2                	test   %edx,%edx
80104539:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010453c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010453f:	50                   	push   %eax
80104540:	52                   	push   %edx
80104541:	ff 73 10             	pushl  0x10(%ebx)
80104544:	68 04 7c 10 80       	push   $0x80107c04
80104549:	e8 92 c1 ff ff       	call   801006e0 <cprintf>
    if(p->state == SLEEPING){
8010454e:	83 c4 10             	add    $0x10,%esp
80104551:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104555:	75 a1                	jne    801044f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104557:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010455a:	83 ec 08             	sub    $0x8,%esp
8010455d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104560:	50                   	push   %eax
80104561:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104564:	8b 40 0c             	mov    0xc(%eax),%eax
80104567:	83 c0 08             	add    $0x8,%eax
8010456a:	50                   	push   %eax
8010456b:	e8 70 01 00 00       	call   801046e0 <getcallerpcs>
80104570:	83 c4 10             	add    $0x10,%esp
80104573:	90                   	nop
80104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104578:	8b 17                	mov    (%edi),%edx
8010457a:	85 d2                	test   %edx,%edx
8010457c:	0f 84 76 ff ff ff    	je     801044f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104582:	83 ec 08             	sub    $0x8,%esp
80104585:	83 c7 04             	add    $0x4,%edi
80104588:	52                   	push   %edx
80104589:	68 21 76 10 80       	push   $0x80107621
8010458e:	e8 4d c1 ff ff       	call   801006e0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104593:	83 c4 10             	add    $0x10,%esp
80104596:	39 fe                	cmp    %edi,%esi
80104598:	75 de                	jne    80104578 <procdump+0x98>
8010459a:	e9 59 ff ff ff       	jmp    801044f8 <procdump+0x18>
8010459f:	90                   	nop
  }
}
801045a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045a3:	5b                   	pop    %ebx
801045a4:	5e                   	pop    %esi
801045a5:	5f                   	pop    %edi
801045a6:	5d                   	pop    %ebp
801045a7:	c3                   	ret    
801045a8:	66 90                	xchg   %ax,%ax
801045aa:	66 90                	xchg   %ax,%ax
801045ac:	66 90                	xchg   %ax,%ax
801045ae:	66 90                	xchg   %ax,%ax

801045b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	53                   	push   %ebx
801045b4:	83 ec 0c             	sub    $0xc,%esp
801045b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045ba:	68 78 7c 10 80       	push   $0x80107c78
801045bf:	8d 43 04             	lea    0x4(%ebx),%eax
801045c2:	50                   	push   %eax
801045c3:	e8 f8 00 00 00       	call   801046c0 <initlock>
  lk->name = name;
801045c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045d1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045d4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045db:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e1:	c9                   	leave  
801045e2:	c3                   	ret    
801045e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	8d 73 04             	lea    0x4(%ebx),%esi
801045fe:	56                   	push   %esi
801045ff:	e8 ac 01 00 00       	call   801047b0 <acquire>
  while (lk->locked) {
80104604:	8b 13                	mov    (%ebx),%edx
80104606:	83 c4 10             	add    $0x10,%esp
80104609:	85 d2                	test   %edx,%edx
8010460b:	74 16                	je     80104623 <acquiresleep+0x33>
8010460d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104610:	83 ec 08             	sub    $0x8,%esp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
80104615:	e8 46 fc ff ff       	call   80104260 <sleep>
  while (lk->locked) {
8010461a:	8b 03                	mov    (%ebx),%eax
8010461c:	83 c4 10             	add    $0x10,%esp
8010461f:	85 c0                	test   %eax,%eax
80104621:	75 ed                	jne    80104610 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104623:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104629:	e8 12 f4 ff ff       	call   80103a40 <myproc>
8010462e:	8b 40 10             	mov    0x10(%eax),%eax
80104631:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104634:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104637:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010463a:	5b                   	pop    %ebx
8010463b:	5e                   	pop    %esi
8010463c:	5d                   	pop    %ebp
  release(&lk->lk);
8010463d:	e9 8e 02 00 00       	jmp    801048d0 <release>
80104642:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104650 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	8d 73 04             	lea    0x4(%ebx),%esi
8010465e:	56                   	push   %esi
8010465f:	e8 4c 01 00 00       	call   801047b0 <acquire>
  lk->locked = 0;
80104664:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010466a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104671:	89 1c 24             	mov    %ebx,(%esp)
80104674:	e8 b7 fd ff ff       	call   80104430 <wakeup>
  release(&lk->lk);
80104679:	89 75 08             	mov    %esi,0x8(%ebp)
8010467c:	83 c4 10             	add    $0x10,%esp
}
8010467f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104682:	5b                   	pop    %ebx
80104683:	5e                   	pop    %esi
80104684:	5d                   	pop    %ebp
  release(&lk->lk);
80104685:	e9 46 02 00 00       	jmp    801048d0 <release>
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104690 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104698:	83 ec 0c             	sub    $0xc,%esp
8010469b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010469e:	53                   	push   %ebx
8010469f:	e8 0c 01 00 00       	call   801047b0 <acquire>
  r = lk->locked;
801046a4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801046a6:	89 1c 24             	mov    %ebx,(%esp)
801046a9:	e8 22 02 00 00       	call   801048d0 <release>
  return r;
}
801046ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046b1:	89 f0                	mov    %esi,%eax
801046b3:	5b                   	pop    %ebx
801046b4:	5e                   	pop    %esi
801046b5:	5d                   	pop    %ebp
801046b6:	c3                   	ret    
801046b7:	66 90                	xchg   %ax,%ax
801046b9:	66 90                	xchg   %ax,%ax
801046bb:	66 90                	xchg   %ax,%ax
801046bd:	66 90                	xchg   %ax,%ax
801046bf:	90                   	nop

801046c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    
801046db:	90                   	nop
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046e1:	31 d2                	xor    %edx,%edx
{
801046e3:	89 e5                	mov    %esp,%ebp
801046e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046ec:	83 e8 08             	sub    $0x8,%eax
801046ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046fc:	77 1a                	ja     80104718 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046fe:	8b 58 04             	mov    0x4(%eax),%ebx
80104701:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104704:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104707:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104709:	83 fa 0a             	cmp    $0xa,%edx
8010470c:	75 e2                	jne    801046f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010470e:	5b                   	pop    %ebx
8010470f:	5d                   	pop    %ebp
80104710:	c3                   	ret    
80104711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104718:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010471b:	83 c1 28             	add    $0x28,%ecx
8010471e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104726:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104729:	39 c1                	cmp    %eax,%ecx
8010472b:	75 f3                	jne    80104720 <getcallerpcs+0x40>
}
8010472d:	5b                   	pop    %ebx
8010472e:	5d                   	pop    %ebp
8010472f:	c3                   	ret    

80104730 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 04             	sub    $0x4,%esp
80104737:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010473a:	8b 02                	mov    (%edx),%eax
8010473c:	85 c0                	test   %eax,%eax
8010473e:	75 10                	jne    80104750 <holding+0x20>
}
80104740:	83 c4 04             	add    $0x4,%esp
80104743:	31 c0                	xor    %eax,%eax
80104745:	5b                   	pop    %ebx
80104746:	5d                   	pop    %ebp
80104747:	c3                   	ret    
80104748:	90                   	nop
80104749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104750:	8b 5a 08             	mov    0x8(%edx),%ebx
80104753:	e8 48 f2 ff ff       	call   801039a0 <mycpu>
80104758:	39 c3                	cmp    %eax,%ebx
8010475a:	0f 94 c0             	sete   %al
}
8010475d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104760:	0f b6 c0             	movzbl %al,%eax
}
80104763:	5b                   	pop    %ebx
80104764:	5d                   	pop    %ebp
80104765:	c3                   	ret    
80104766:	8d 76 00             	lea    0x0(%esi),%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104770 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	83 ec 04             	sub    $0x4,%esp
80104777:	9c                   	pushf  
80104778:	5b                   	pop    %ebx
  asm volatile("cli");
80104779:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010477a:	e8 21 f2 ff ff       	call   801039a0 <mycpu>
8010477f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104785:	85 c0                	test   %eax,%eax
80104787:	75 11                	jne    8010479a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104789:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010478f:	e8 0c f2 ff ff       	call   801039a0 <mycpu>
80104794:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010479a:	e8 01 f2 ff ff       	call   801039a0 <mycpu>
8010479f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047a6:	83 c4 04             	add    $0x4,%esp
801047a9:	5b                   	pop    %ebx
801047aa:	5d                   	pop    %ebp
801047ab:	c3                   	ret    
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047b0 <acquire>:
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801047b5:	e8 b6 ff ff ff       	call   80104770 <pushcli>
  if(holding(lk))
801047ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801047bd:	8b 03                	mov    (%ebx),%eax
801047bf:	85 c0                	test   %eax,%eax
801047c1:	0f 85 81 00 00 00    	jne    80104848 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801047c7:	ba 01 00 00 00       	mov    $0x1,%edx
801047cc:	eb 05                	jmp    801047d3 <acquire+0x23>
801047ce:	66 90                	xchg   %ax,%ax
801047d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047d3:	89 d0                	mov    %edx,%eax
801047d5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801047d8:	85 c0                	test   %eax,%eax
801047da:	75 f4                	jne    801047d0 <acquire+0x20>
  __sync_synchronize();
801047dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047e4:	e8 b7 f1 ff ff       	call   801039a0 <mycpu>
  for(i = 0; i < 10; i++){
801047e9:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
801047eb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
801047ee:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801047f1:	89 e8                	mov    %ebp,%eax
801047f3:	90                   	nop
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047f8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047fe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104804:	77 1a                	ja     80104820 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104806:	8b 58 04             	mov    0x4(%eax),%ebx
80104809:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010480c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010480f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104811:	83 fa 0a             	cmp    $0xa,%edx
80104814:	75 e2                	jne    801047f8 <acquire+0x48>
}
80104816:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104819:	5b                   	pop    %ebx
8010481a:	5e                   	pop    %esi
8010481b:	5d                   	pop    %ebp
8010481c:	c3                   	ret    
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
80104820:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104823:	83 c1 28             	add    $0x28,%ecx
80104826:	8d 76 00             	lea    0x0(%esi),%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104830:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104836:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104839:	39 c8                	cmp    %ecx,%eax
8010483b:	75 f3                	jne    80104830 <acquire+0x80>
}
8010483d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104840:	5b                   	pop    %ebx
80104841:	5e                   	pop    %esi
80104842:	5d                   	pop    %ebp
80104843:	c3                   	ret    
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104848:	8b 73 08             	mov    0x8(%ebx),%esi
8010484b:	e8 50 f1 ff ff       	call   801039a0 <mycpu>
80104850:	39 c6                	cmp    %eax,%esi
80104852:	0f 85 6f ff ff ff    	jne    801047c7 <acquire+0x17>
    panic("acquire");
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	68 83 7c 10 80       	push   $0x80107c83
80104860:	e8 2b bb ff ff       	call   80100390 <panic>
80104865:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <popcli>:

void
popcli(void)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104876:	9c                   	pushf  
80104877:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104878:	f6 c4 02             	test   $0x2,%ah
8010487b:	75 35                	jne    801048b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010487d:	e8 1e f1 ff ff       	call   801039a0 <mycpu>
80104882:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104889:	78 34                	js     801048bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010488b:	e8 10 f1 ff ff       	call   801039a0 <mycpu>
80104890:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104896:	85 d2                	test   %edx,%edx
80104898:	74 06                	je     801048a0 <popcli+0x30>
    sti();
}
8010489a:	c9                   	leave  
8010489b:	c3                   	ret    
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048a0:	e8 fb f0 ff ff       	call   801039a0 <mycpu>
801048a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801048ab:	85 c0                	test   %eax,%eax
801048ad:	74 eb                	je     8010489a <popcli+0x2a>
  asm volatile("sti");
801048af:	fb                   	sti    
}
801048b0:	c9                   	leave  
801048b1:	c3                   	ret    
    panic("popcli - interruptible");
801048b2:	83 ec 0c             	sub    $0xc,%esp
801048b5:	68 8b 7c 10 80       	push   $0x80107c8b
801048ba:	e8 d1 ba ff ff       	call   80100390 <panic>
    panic("popcli");
801048bf:	83 ec 0c             	sub    $0xc,%esp
801048c2:	68 a2 7c 10 80       	push   $0x80107ca2
801048c7:	e8 c4 ba ff ff       	call   80100390 <panic>
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048d0 <release>:
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
801048d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801048d8:	8b 03                	mov    (%ebx),%eax
801048da:	85 c0                	test   %eax,%eax
801048dc:	74 0c                	je     801048ea <release+0x1a>
801048de:	8b 73 08             	mov    0x8(%ebx),%esi
801048e1:	e8 ba f0 ff ff       	call   801039a0 <mycpu>
801048e6:	39 c6                	cmp    %eax,%esi
801048e8:	74 16                	je     80104900 <release+0x30>
    panic("release");
801048ea:	83 ec 0c             	sub    $0xc,%esp
801048ed:	68 a9 7c 10 80       	push   $0x80107ca9
801048f2:	e8 99 ba ff ff       	call   80100390 <panic>
801048f7:	89 f6                	mov    %esi,%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104900:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104907:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010490e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104913:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104919:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010491c:	5b                   	pop    %ebx
8010491d:	5e                   	pop    %esi
8010491e:	5d                   	pop    %ebp
  popcli();
8010491f:	e9 4c ff ff ff       	jmp    80104870 <popcli>
80104924:	66 90                	xchg   %ax,%ax
80104926:	66 90                	xchg   %ax,%ax
80104928:	66 90                	xchg   %ax,%ax
8010492a:	66 90                	xchg   %ax,%ax
8010492c:	66 90                	xchg   %ax,%ax
8010492e:	66 90                	xchg   %ax,%ax

80104930 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	57                   	push   %edi
80104934:	53                   	push   %ebx
80104935:	8b 55 08             	mov    0x8(%ebp),%edx
80104938:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010493b:	f6 c2 03             	test   $0x3,%dl
8010493e:	75 05                	jne    80104945 <memset+0x15>
80104940:	f6 c1 03             	test   $0x3,%cl
80104943:	74 13                	je     80104958 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104945:	89 d7                	mov    %edx,%edi
80104947:	8b 45 0c             	mov    0xc(%ebp),%eax
8010494a:	fc                   	cld    
8010494b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010494d:	5b                   	pop    %ebx
8010494e:	89 d0                	mov    %edx,%eax
80104950:	5f                   	pop    %edi
80104951:	5d                   	pop    %ebp
80104952:	c3                   	ret    
80104953:	90                   	nop
80104954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104958:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010495c:	c1 e9 02             	shr    $0x2,%ecx
8010495f:	89 f8                	mov    %edi,%eax
80104961:	89 fb                	mov    %edi,%ebx
80104963:	c1 e0 18             	shl    $0x18,%eax
80104966:	c1 e3 10             	shl    $0x10,%ebx
80104969:	09 d8                	or     %ebx,%eax
8010496b:	09 f8                	or     %edi,%eax
8010496d:	c1 e7 08             	shl    $0x8,%edi
80104970:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104972:	89 d7                	mov    %edx,%edi
80104974:	fc                   	cld    
80104975:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104977:	5b                   	pop    %ebx
80104978:	89 d0                	mov    %edx,%eax
8010497a:	5f                   	pop    %edi
8010497b:	5d                   	pop    %ebp
8010497c:	c3                   	ret    
8010497d:	8d 76 00             	lea    0x0(%esi),%esi

80104980 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	56                   	push   %esi
80104985:	53                   	push   %ebx
80104986:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104989:	8b 75 08             	mov    0x8(%ebp),%esi
8010498c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010498f:	85 db                	test   %ebx,%ebx
80104991:	74 29                	je     801049bc <memcmp+0x3c>
    if(*s1 != *s2)
80104993:	0f b6 16             	movzbl (%esi),%edx
80104996:	0f b6 0f             	movzbl (%edi),%ecx
80104999:	38 d1                	cmp    %dl,%cl
8010499b:	75 2b                	jne    801049c8 <memcmp+0x48>
8010499d:	b8 01 00 00 00       	mov    $0x1,%eax
801049a2:	eb 14                	jmp    801049b8 <memcmp+0x38>
801049a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049a8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801049ac:	83 c0 01             	add    $0x1,%eax
801049af:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801049b4:	38 ca                	cmp    %cl,%dl
801049b6:	75 10                	jne    801049c8 <memcmp+0x48>
  while(n-- > 0){
801049b8:	39 d8                	cmp    %ebx,%eax
801049ba:	75 ec                	jne    801049a8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801049bc:	5b                   	pop    %ebx
  return 0;
801049bd:	31 c0                	xor    %eax,%eax
}
801049bf:	5e                   	pop    %esi
801049c0:	5f                   	pop    %edi
801049c1:	5d                   	pop    %ebp
801049c2:	c3                   	ret    
801049c3:	90                   	nop
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801049c8:	0f b6 c2             	movzbl %dl,%eax
}
801049cb:	5b                   	pop    %ebx
      return *s1 - *s2;
801049cc:	29 c8                	sub    %ecx,%eax
}
801049ce:	5e                   	pop    %esi
801049cf:	5f                   	pop    %edi
801049d0:	5d                   	pop    %ebp
801049d1:	c3                   	ret    
801049d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	8b 45 08             	mov    0x8(%ebp),%eax
801049e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801049eb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049ee:	39 c3                	cmp    %eax,%ebx
801049f0:	73 26                	jae    80104a18 <memmove+0x38>
801049f2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801049f5:	39 c8                	cmp    %ecx,%eax
801049f7:	73 1f                	jae    80104a18 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801049f9:	85 f6                	test   %esi,%esi
801049fb:	8d 56 ff             	lea    -0x1(%esi),%edx
801049fe:	74 0f                	je     80104a0f <memmove+0x2f>
      *--d = *--s;
80104a00:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a04:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104a07:	83 ea 01             	sub    $0x1,%edx
80104a0a:	83 fa ff             	cmp    $0xffffffff,%edx
80104a0d:	75 f1                	jne    80104a00 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a0f:	5b                   	pop    %ebx
80104a10:	5e                   	pop    %esi
80104a11:	5d                   	pop    %ebp
80104a12:	c3                   	ret    
80104a13:	90                   	nop
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104a18:	31 d2                	xor    %edx,%edx
80104a1a:	85 f6                	test   %esi,%esi
80104a1c:	74 f1                	je     80104a0f <memmove+0x2f>
80104a1e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104a20:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a24:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a27:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104a2a:	39 d6                	cmp    %edx,%esi
80104a2c:	75 f2                	jne    80104a20 <memmove+0x40>
}
80104a2e:	5b                   	pop    %ebx
80104a2f:	5e                   	pop    %esi
80104a30:	5d                   	pop    %ebp
80104a31:	c3                   	ret    
80104a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104a43:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104a44:	eb 9a                	jmp    801049e0 <memmove>
80104a46:	8d 76 00             	lea    0x0(%esi),%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a50 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	57                   	push   %edi
80104a54:	56                   	push   %esi
80104a55:	8b 7d 10             	mov    0x10(%ebp),%edi
80104a58:	53                   	push   %ebx
80104a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104a5f:	85 ff                	test   %edi,%edi
80104a61:	74 2f                	je     80104a92 <strncmp+0x42>
80104a63:	0f b6 01             	movzbl (%ecx),%eax
80104a66:	0f b6 1e             	movzbl (%esi),%ebx
80104a69:	84 c0                	test   %al,%al
80104a6b:	74 37                	je     80104aa4 <strncmp+0x54>
80104a6d:	38 c3                	cmp    %al,%bl
80104a6f:	75 33                	jne    80104aa4 <strncmp+0x54>
80104a71:	01 f7                	add    %esi,%edi
80104a73:	eb 13                	jmp    80104a88 <strncmp+0x38>
80104a75:	8d 76 00             	lea    0x0(%esi),%esi
80104a78:	0f b6 01             	movzbl (%ecx),%eax
80104a7b:	84 c0                	test   %al,%al
80104a7d:	74 21                	je     80104aa0 <strncmp+0x50>
80104a7f:	0f b6 1a             	movzbl (%edx),%ebx
80104a82:	89 d6                	mov    %edx,%esi
80104a84:	38 d8                	cmp    %bl,%al
80104a86:	75 1c                	jne    80104aa4 <strncmp+0x54>
    n--, p++, q++;
80104a88:	8d 56 01             	lea    0x1(%esi),%edx
80104a8b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a8e:	39 fa                	cmp    %edi,%edx
80104a90:	75 e6                	jne    80104a78 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104a92:	5b                   	pop    %ebx
    return 0;
80104a93:	31 c0                	xor    %eax,%eax
}
80104a95:	5e                   	pop    %esi
80104a96:	5f                   	pop    %edi
80104a97:	5d                   	pop    %ebp
80104a98:	c3                   	ret    
80104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aa0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104aa4:	29 d8                	sub    %ebx,%eax
}
80104aa6:	5b                   	pop    %ebx
80104aa7:	5e                   	pop    %esi
80104aa8:	5f                   	pop    %edi
80104aa9:	5d                   	pop    %ebp
80104aaa:	c3                   	ret    
80104aab:	90                   	nop
80104aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ab0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
80104ab5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ab8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104abb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104abe:	89 c2                	mov    %eax,%edx
80104ac0:	eb 19                	jmp    80104adb <strncpy+0x2b>
80104ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ac8:	83 c3 01             	add    $0x1,%ebx
80104acb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104acf:	83 c2 01             	add    $0x1,%edx
80104ad2:	84 c9                	test   %cl,%cl
80104ad4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ad7:	74 09                	je     80104ae2 <strncpy+0x32>
80104ad9:	89 f1                	mov    %esi,%ecx
80104adb:	85 c9                	test   %ecx,%ecx
80104add:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104ae0:	7f e6                	jg     80104ac8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ae2:	31 c9                	xor    %ecx,%ecx
80104ae4:	85 f6                	test   %esi,%esi
80104ae6:	7e 17                	jle    80104aff <strncpy+0x4f>
80104ae8:	90                   	nop
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104af0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104af4:	89 f3                	mov    %esi,%ebx
80104af6:	83 c1 01             	add    $0x1,%ecx
80104af9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104afb:	85 db                	test   %ebx,%ebx
80104afd:	7f f1                	jg     80104af0 <strncpy+0x40>
  return os;
}
80104aff:	5b                   	pop    %ebx
80104b00:	5e                   	pop    %esi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
80104b15:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b18:	8b 45 08             	mov    0x8(%ebp),%eax
80104b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104b1e:	85 c9                	test   %ecx,%ecx
80104b20:	7e 26                	jle    80104b48 <safestrcpy+0x38>
80104b22:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b26:	89 c1                	mov    %eax,%ecx
80104b28:	eb 17                	jmp    80104b41 <safestrcpy+0x31>
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b30:	83 c2 01             	add    $0x1,%edx
80104b33:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b37:	83 c1 01             	add    $0x1,%ecx
80104b3a:	84 db                	test   %bl,%bl
80104b3c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b3f:	74 04                	je     80104b45 <safestrcpy+0x35>
80104b41:	39 f2                	cmp    %esi,%edx
80104b43:	75 eb                	jne    80104b30 <safestrcpy+0x20>
    ;
  *s = 0;
80104b45:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b48:	5b                   	pop    %ebx
80104b49:	5e                   	pop    %esi
80104b4a:	5d                   	pop    %ebp
80104b4b:	c3                   	ret    
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b50 <strlen>:

int
strlen(const char *s)
{
80104b50:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b51:	31 c0                	xor    %eax,%eax
{
80104b53:	89 e5                	mov    %esp,%ebp
80104b55:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b58:	80 3a 00             	cmpb   $0x0,(%edx)
80104b5b:	74 0c                	je     80104b69 <strlen+0x19>
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi
80104b60:	83 c0 01             	add    $0x1,%eax
80104b63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b67:	75 f7                	jne    80104b60 <strlen+0x10>
    ;
  return n;
}
80104b69:	5d                   	pop    %ebp
80104b6a:	c3                   	ret    

80104b6b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b6b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b6f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104b73:	55                   	push   %ebp
  pushl %ebx
80104b74:	53                   	push   %ebx
  pushl %esi
80104b75:	56                   	push   %esi
  pushl %edi
80104b76:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b77:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b79:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104b7b:	5f                   	pop    %edi
  popl %esi
80104b7c:	5e                   	pop    %esi
  popl %ebx
80104b7d:	5b                   	pop    %ebx
  popl %ebp
80104b7e:	5d                   	pop    %ebp
  ret
80104b7f:	c3                   	ret    

80104b80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 04             	sub    $0x4,%esp
80104b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b8a:	e8 b1 ee ff ff       	call   80103a40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b8f:	8b 00                	mov    (%eax),%eax
80104b91:	39 d8                	cmp    %ebx,%eax
80104b93:	76 1b                	jbe    80104bb0 <fetchint+0x30>
80104b95:	8d 53 04             	lea    0x4(%ebx),%edx
80104b98:	39 d0                	cmp    %edx,%eax
80104b9a:	72 14                	jb     80104bb0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b9f:	8b 13                	mov    (%ebx),%edx
80104ba1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ba3:	31 c0                	xor    %eax,%eax
}
80104ba5:	83 c4 04             	add    $0x4,%esp
80104ba8:	5b                   	pop    %ebx
80104ba9:	5d                   	pop    %ebp
80104baa:	c3                   	ret    
80104bab:	90                   	nop
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bb5:	eb ee                	jmp    80104ba5 <fetchint+0x25>
80104bb7:	89 f6                	mov    %esi,%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 04             	sub    $0x4,%esp
80104bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bca:	e8 71 ee ff ff       	call   80103a40 <myproc>

  if(addr >= curproc->sz)
80104bcf:	39 18                	cmp    %ebx,(%eax)
80104bd1:	76 29                	jbe    80104bfc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104bd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104bd6:	89 da                	mov    %ebx,%edx
80104bd8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104bda:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104bdc:	39 c3                	cmp    %eax,%ebx
80104bde:	73 1c                	jae    80104bfc <fetchstr+0x3c>
    if(*s == 0)
80104be0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104be3:	75 10                	jne    80104bf5 <fetchstr+0x35>
80104be5:	eb 39                	jmp    80104c20 <fetchstr+0x60>
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bf0:	80 3a 00             	cmpb   $0x0,(%edx)
80104bf3:	74 1b                	je     80104c10 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104bf5:	83 c2 01             	add    $0x1,%edx
80104bf8:	39 d0                	cmp    %edx,%eax
80104bfa:	77 f4                	ja     80104bf0 <fetchstr+0x30>
    return -1;
80104bfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104c01:	83 c4 04             	add    $0x4,%esp
80104c04:	5b                   	pop    %ebx
80104c05:	5d                   	pop    %ebp
80104c06:	c3                   	ret    
80104c07:	89 f6                	mov    %esi,%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c10:	83 c4 04             	add    $0x4,%esp
80104c13:	89 d0                	mov    %edx,%eax
80104c15:	29 d8                	sub    %ebx,%eax
80104c17:	5b                   	pop    %ebx
80104c18:	5d                   	pop    %ebp
80104c19:	c3                   	ret    
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104c20:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c22:	eb dd                	jmp    80104c01 <fetchstr+0x41>
80104c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c35:	e8 06 ee ff ff       	call   80103a40 <myproc>
80104c3a:	8b 40 18             	mov    0x18(%eax),%eax
80104c3d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c40:	8b 40 44             	mov    0x44(%eax),%eax
80104c43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c46:	e8 f5 ed ff ff       	call   80103a40 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c4b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c4d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c50:	39 c6                	cmp    %eax,%esi
80104c52:	73 1c                	jae    80104c70 <argint+0x40>
80104c54:	8d 53 08             	lea    0x8(%ebx),%edx
80104c57:	39 d0                	cmp    %edx,%eax
80104c59:	72 15                	jb     80104c70 <argint+0x40>
  *ip = *(int*)(addr);
80104c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c5e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c61:	89 10                	mov    %edx,(%eax)
  return 0;
80104c63:	31 c0                	xor    %eax,%eax
}
80104c65:	5b                   	pop    %ebx
80104c66:	5e                   	pop    %esi
80104c67:	5d                   	pop    %ebp
80104c68:	c3                   	ret    
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c75:	eb ee                	jmp    80104c65 <argint+0x35>
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
80104c85:	83 ec 10             	sub    $0x10,%esp
80104c88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104c8b:	e8 b0 ed ff ff       	call   80103a40 <myproc>
80104c90:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104c92:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c95:	83 ec 08             	sub    $0x8,%esp
80104c98:	50                   	push   %eax
80104c99:	ff 75 08             	pushl  0x8(%ebp)
80104c9c:	e8 8f ff ff ff       	call   80104c30 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ca1:	83 c4 10             	add    $0x10,%esp
80104ca4:	85 c0                	test   %eax,%eax
80104ca6:	78 28                	js     80104cd0 <argptr+0x50>
80104ca8:	85 db                	test   %ebx,%ebx
80104caa:	78 24                	js     80104cd0 <argptr+0x50>
80104cac:	8b 16                	mov    (%esi),%edx
80104cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb1:	39 c2                	cmp    %eax,%edx
80104cb3:	76 1b                	jbe    80104cd0 <argptr+0x50>
80104cb5:	01 c3                	add    %eax,%ebx
80104cb7:	39 da                	cmp    %ebx,%edx
80104cb9:	72 15                	jb     80104cd0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cbe:	89 02                	mov    %eax,(%edx)
  return 0;
80104cc0:	31 c0                	xor    %eax,%eax
}
80104cc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cc5:	5b                   	pop    %ebx
80104cc6:	5e                   	pop    %esi
80104cc7:	5d                   	pop    %ebp
80104cc8:	c3                   	ret    
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd5:	eb eb                	jmp    80104cc2 <argptr+0x42>
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ce9:	50                   	push   %eax
80104cea:	ff 75 08             	pushl  0x8(%ebp)
80104ced:	e8 3e ff ff ff       	call   80104c30 <argint>
80104cf2:	83 c4 10             	add    $0x10,%esp
80104cf5:	85 c0                	test   %eax,%eax
80104cf7:	78 17                	js     80104d10 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104cf9:	83 ec 08             	sub    $0x8,%esp
80104cfc:	ff 75 0c             	pushl  0xc(%ebp)
80104cff:	ff 75 f4             	pushl  -0xc(%ebp)
80104d02:	e8 b9 fe ff ff       	call   80104bc0 <fetchstr>
80104d07:	83 c4 10             	add    $0x10,%esp
}
80104d0a:	c9                   	leave  
80104d0b:	c3                   	ret    
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d15:	c9                   	leave  
80104d16:	c3                   	ret    
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <syscall>:
[SYS_memo]  sys_memo,
};

void
syscall(void)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	53                   	push   %ebx
80104d24:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d27:	e8 14 ed ff ff       	call   80103a40 <myproc>
80104d2c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d2e:	8b 40 18             	mov    0x18(%eax),%eax
80104d31:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d34:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d37:	83 fa 19             	cmp    $0x19,%edx
80104d3a:	77 1c                	ja     80104d58 <syscall+0x38>
80104d3c:	8b 14 85 e0 7c 10 80 	mov    -0x7fef8320(,%eax,4),%edx
80104d43:	85 d2                	test   %edx,%edx
80104d45:	74 11                	je     80104d58 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104d47:	ff d2                	call   *%edx
80104d49:	8b 53 18             	mov    0x18(%ebx),%edx
80104d4c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d52:	c9                   	leave  
80104d53:	c3                   	ret    
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d58:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d59:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d5c:	50                   	push   %eax
80104d5d:	ff 73 10             	pushl  0x10(%ebx)
80104d60:	68 b1 7c 10 80       	push   $0x80107cb1
80104d65:	e8 76 b9 ff ff       	call   801006e0 <cprintf>
    curproc->tf->eax = -1;
80104d6a:	8b 43 18             	mov    0x18(%ebx),%eax
80104d6d:	83 c4 10             	add    $0x10,%esp
80104d70:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d7a:	c9                   	leave  
80104d7b:	c3                   	ret    
80104d7c:	66 90                	xchg   %ax,%ax
80104d7e:	66 90                	xchg   %ax,%ax

80104d80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
80104d85:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d86:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104d89:	83 ec 44             	sub    $0x44,%esp
80104d8c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104d8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d92:	56                   	push   %esi
80104d93:	50                   	push   %eax
{
80104d94:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104d97:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d9a:	e8 a1 d3 ff ff       	call   80102140 <nameiparent>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	0f 84 46 01 00 00    	je     80104ef0 <create+0x170>
    return 0;
  ilock(dp);
80104daa:	83 ec 0c             	sub    $0xc,%esp
80104dad:	89 c3                	mov    %eax,%ebx
80104daf:	50                   	push   %eax
80104db0:	e8 0b cb ff ff       	call   801018c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104db5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104db8:	83 c4 0c             	add    $0xc,%esp
80104dbb:	50                   	push   %eax
80104dbc:	56                   	push   %esi
80104dbd:	53                   	push   %ebx
80104dbe:	e8 2d d0 ff ff       	call   80101df0 <dirlookup>
80104dc3:	83 c4 10             	add    $0x10,%esp
80104dc6:	85 c0                	test   %eax,%eax
80104dc8:	89 c7                	mov    %eax,%edi
80104dca:	74 34                	je     80104e00 <create+0x80>
    iunlockput(dp);
80104dcc:	83 ec 0c             	sub    $0xc,%esp
80104dcf:	53                   	push   %ebx
80104dd0:	e8 7b cd ff ff       	call   80101b50 <iunlockput>
    ilock(ip);
80104dd5:	89 3c 24             	mov    %edi,(%esp)
80104dd8:	e8 e3 ca ff ff       	call   801018c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104de5:	0f 85 95 00 00 00    	jne    80104e80 <create+0x100>
80104deb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104df0:	0f 85 8a 00 00 00    	jne    80104e80 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104df9:	89 f8                	mov    %edi,%eax
80104dfb:	5b                   	pop    %ebx
80104dfc:	5e                   	pop    %esi
80104dfd:	5f                   	pop    %edi
80104dfe:	5d                   	pop    %ebp
80104dff:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104e00:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104e04:	83 ec 08             	sub    $0x8,%esp
80104e07:	50                   	push   %eax
80104e08:	ff 33                	pushl  (%ebx)
80104e0a:	e8 41 c9 ff ff       	call   80101750 <ialloc>
80104e0f:	83 c4 10             	add    $0x10,%esp
80104e12:	85 c0                	test   %eax,%eax
80104e14:	89 c7                	mov    %eax,%edi
80104e16:	0f 84 e8 00 00 00    	je     80104f04 <create+0x184>
  ilock(ip);
80104e1c:	83 ec 0c             	sub    $0xc,%esp
80104e1f:	50                   	push   %eax
80104e20:	e8 9b ca ff ff       	call   801018c0 <ilock>
  ip->major = major;
80104e25:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104e29:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104e2d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104e31:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104e35:	b8 01 00 00 00       	mov    $0x1,%eax
80104e3a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104e3e:	89 3c 24             	mov    %edi,(%esp)
80104e41:	e8 ca c9 ff ff       	call   80101810 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e46:	83 c4 10             	add    $0x10,%esp
80104e49:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104e4e:	74 50                	je     80104ea0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e50:	83 ec 04             	sub    $0x4,%esp
80104e53:	ff 77 04             	pushl  0x4(%edi)
80104e56:	56                   	push   %esi
80104e57:	53                   	push   %ebx
80104e58:	e8 03 d2 ff ff       	call   80102060 <dirlink>
80104e5d:	83 c4 10             	add    $0x10,%esp
80104e60:	85 c0                	test   %eax,%eax
80104e62:	0f 88 8f 00 00 00    	js     80104ef7 <create+0x177>
  iunlockput(dp);
80104e68:	83 ec 0c             	sub    $0xc,%esp
80104e6b:	53                   	push   %ebx
80104e6c:	e8 df cc ff ff       	call   80101b50 <iunlockput>
  return ip;
80104e71:	83 c4 10             	add    $0x10,%esp
}
80104e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e77:	89 f8                	mov    %edi,%eax
80104e79:	5b                   	pop    %ebx
80104e7a:	5e                   	pop    %esi
80104e7b:	5f                   	pop    %edi
80104e7c:	5d                   	pop    %ebp
80104e7d:	c3                   	ret    
80104e7e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104e80:	83 ec 0c             	sub    $0xc,%esp
80104e83:	57                   	push   %edi
    return 0;
80104e84:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104e86:	e8 c5 cc ff ff       	call   80101b50 <iunlockput>
    return 0;
80104e8b:	83 c4 10             	add    $0x10,%esp
}
80104e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e91:	89 f8                	mov    %edi,%eax
80104e93:	5b                   	pop    %ebx
80104e94:	5e                   	pop    %esi
80104e95:	5f                   	pop    %edi
80104e96:	5d                   	pop    %ebp
80104e97:	c3                   	ret    
80104e98:	90                   	nop
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104ea0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ea5:	83 ec 0c             	sub    $0xc,%esp
80104ea8:	53                   	push   %ebx
80104ea9:	e8 62 c9 ff ff       	call   80101810 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104eae:	83 c4 0c             	add    $0xc,%esp
80104eb1:	ff 77 04             	pushl  0x4(%edi)
80104eb4:	68 68 7d 10 80       	push   $0x80107d68
80104eb9:	57                   	push   %edi
80104eba:	e8 a1 d1 ff ff       	call   80102060 <dirlink>
80104ebf:	83 c4 10             	add    $0x10,%esp
80104ec2:	85 c0                	test   %eax,%eax
80104ec4:	78 1c                	js     80104ee2 <create+0x162>
80104ec6:	83 ec 04             	sub    $0x4,%esp
80104ec9:	ff 73 04             	pushl  0x4(%ebx)
80104ecc:	68 67 7d 10 80       	push   $0x80107d67
80104ed1:	57                   	push   %edi
80104ed2:	e8 89 d1 ff ff       	call   80102060 <dirlink>
80104ed7:	83 c4 10             	add    $0x10,%esp
80104eda:	85 c0                	test   %eax,%eax
80104edc:	0f 89 6e ff ff ff    	jns    80104e50 <create+0xd0>
      panic("create dots");
80104ee2:	83 ec 0c             	sub    $0xc,%esp
80104ee5:	68 5b 7d 10 80       	push   $0x80107d5b
80104eea:	e8 a1 b4 ff ff       	call   80100390 <panic>
80104eef:	90                   	nop
    return 0;
80104ef0:	31 ff                	xor    %edi,%edi
80104ef2:	e9 ff fe ff ff       	jmp    80104df6 <create+0x76>
    panic("create: dirlink");
80104ef7:	83 ec 0c             	sub    $0xc,%esp
80104efa:	68 6a 7d 10 80       	push   $0x80107d6a
80104eff:	e8 8c b4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104f04:	83 ec 0c             	sub    $0xc,%esp
80104f07:	68 4c 7d 10 80       	push   $0x80107d4c
80104f0c:	e8 7f b4 ff ff       	call   80100390 <panic>
80104f11:	eb 0d                	jmp    80104f20 <argfd.constprop.0>
80104f13:	90                   	nop
80104f14:	90                   	nop
80104f15:	90                   	nop
80104f16:	90                   	nop
80104f17:	90                   	nop
80104f18:	90                   	nop
80104f19:	90                   	nop
80104f1a:	90                   	nop
80104f1b:	90                   	nop
80104f1c:	90                   	nop
80104f1d:	90                   	nop
80104f1e:	90                   	nop
80104f1f:	90                   	nop

80104f20 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
80104f25:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104f27:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104f2a:	89 d6                	mov    %edx,%esi
80104f2c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2f:	50                   	push   %eax
80104f30:	6a 00                	push   $0x0
80104f32:	e8 f9 fc ff ff       	call   80104c30 <argint>
80104f37:	83 c4 10             	add    $0x10,%esp
80104f3a:	85 c0                	test   %eax,%eax
80104f3c:	78 2a                	js     80104f68 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f42:	77 24                	ja     80104f68 <argfd.constprop.0+0x48>
80104f44:	e8 f7 ea ff ff       	call   80103a40 <myproc>
80104f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f4c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104f50:	85 c0                	test   %eax,%eax
80104f52:	74 14                	je     80104f68 <argfd.constprop.0+0x48>
  if(pfd)
80104f54:	85 db                	test   %ebx,%ebx
80104f56:	74 02                	je     80104f5a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104f58:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104f5a:	89 06                	mov    %eax,(%esi)
  return 0;
80104f5c:	31 c0                	xor    %eax,%eax
}
80104f5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f61:	5b                   	pop    %ebx
80104f62:	5e                   	pop    %esi
80104f63:	5d                   	pop    %ebp
80104f64:	c3                   	ret    
80104f65:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f6d:	eb ef                	jmp    80104f5e <argfd.constprop.0+0x3e>
80104f6f:	90                   	nop

80104f70 <sys_dup>:
{
80104f70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104f71:	31 c0                	xor    %eax,%eax
{
80104f73:	89 e5                	mov    %esp,%ebp
80104f75:	56                   	push   %esi
80104f76:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104f77:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104f7a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104f7d:	e8 9e ff ff ff       	call   80104f20 <argfd.constprop.0>
80104f82:	85 c0                	test   %eax,%eax
80104f84:	78 42                	js     80104fc8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104f86:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f89:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104f8b:	e8 b0 ea ff ff       	call   80103a40 <myproc>
80104f90:	eb 0e                	jmp    80104fa0 <sys_dup+0x30>
80104f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f98:	83 c3 01             	add    $0x1,%ebx
80104f9b:	83 fb 10             	cmp    $0x10,%ebx
80104f9e:	74 28                	je     80104fc8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104fa0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fa4:	85 d2                	test   %edx,%edx
80104fa6:	75 f0                	jne    80104f98 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104fa8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104fac:	83 ec 0c             	sub    $0xc,%esp
80104faf:	ff 75 f4             	pushl  -0xc(%ebp)
80104fb2:	e8 29 c0 ff ff       	call   80100fe0 <filedup>
  return fd;
80104fb7:	83 c4 10             	add    $0x10,%esp
}
80104fba:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fbd:	89 d8                	mov    %ebx,%eax
80104fbf:	5b                   	pop    %ebx
80104fc0:	5e                   	pop    %esi
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret    
80104fc3:	90                   	nop
80104fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fcb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fd0:	89 d8                	mov    %ebx,%eax
80104fd2:	5b                   	pop    %ebx
80104fd3:	5e                   	pop    %esi
80104fd4:	5d                   	pop    %ebp
80104fd5:	c3                   	ret    
80104fd6:	8d 76 00             	lea    0x0(%esi),%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fe0 <sys_read>:
{
80104fe0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fe1:	31 c0                	xor    %eax,%eax
{
80104fe3:	89 e5                	mov    %esp,%ebp
80104fe5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fe8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104feb:	e8 30 ff ff ff       	call   80104f20 <argfd.constprop.0>
80104ff0:	85 c0                	test   %eax,%eax
80104ff2:	78 4c                	js     80105040 <sys_read+0x60>
80104ff4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ff7:	83 ec 08             	sub    $0x8,%esp
80104ffa:	50                   	push   %eax
80104ffb:	6a 02                	push   $0x2
80104ffd:	e8 2e fc ff ff       	call   80104c30 <argint>
80105002:	83 c4 10             	add    $0x10,%esp
80105005:	85 c0                	test   %eax,%eax
80105007:	78 37                	js     80105040 <sys_read+0x60>
80105009:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010500c:	83 ec 04             	sub    $0x4,%esp
8010500f:	ff 75 f0             	pushl  -0x10(%ebp)
80105012:	50                   	push   %eax
80105013:	6a 01                	push   $0x1
80105015:	e8 66 fc ff ff       	call   80104c80 <argptr>
8010501a:	83 c4 10             	add    $0x10,%esp
8010501d:	85 c0                	test   %eax,%eax
8010501f:	78 1f                	js     80105040 <sys_read+0x60>
  return fileread(f, p, n);
80105021:	83 ec 04             	sub    $0x4,%esp
80105024:	ff 75 f0             	pushl  -0x10(%ebp)
80105027:	ff 75 f4             	pushl  -0xc(%ebp)
8010502a:	ff 75 ec             	pushl  -0x14(%ebp)
8010502d:	e8 1e c1 ff ff       	call   80101150 <fileread>
80105032:	83 c4 10             	add    $0x10,%esp
}
80105035:	c9                   	leave  
80105036:	c3                   	ret    
80105037:	89 f6                	mov    %esi,%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105045:	c9                   	leave  
80105046:	c3                   	ret    
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <sys_write>:
{
80105050:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105051:	31 c0                	xor    %eax,%eax
{
80105053:	89 e5                	mov    %esp,%ebp
80105055:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105058:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010505b:	e8 c0 fe ff ff       	call   80104f20 <argfd.constprop.0>
80105060:	85 c0                	test   %eax,%eax
80105062:	78 4c                	js     801050b0 <sys_write+0x60>
80105064:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105067:	83 ec 08             	sub    $0x8,%esp
8010506a:	50                   	push   %eax
8010506b:	6a 02                	push   $0x2
8010506d:	e8 be fb ff ff       	call   80104c30 <argint>
80105072:	83 c4 10             	add    $0x10,%esp
80105075:	85 c0                	test   %eax,%eax
80105077:	78 37                	js     801050b0 <sys_write+0x60>
80105079:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010507c:	83 ec 04             	sub    $0x4,%esp
8010507f:	ff 75 f0             	pushl  -0x10(%ebp)
80105082:	50                   	push   %eax
80105083:	6a 01                	push   $0x1
80105085:	e8 f6 fb ff ff       	call   80104c80 <argptr>
8010508a:	83 c4 10             	add    $0x10,%esp
8010508d:	85 c0                	test   %eax,%eax
8010508f:	78 1f                	js     801050b0 <sys_write+0x60>
  return filewrite(f, p, n);
80105091:	83 ec 04             	sub    $0x4,%esp
80105094:	ff 75 f0             	pushl  -0x10(%ebp)
80105097:	ff 75 f4             	pushl  -0xc(%ebp)
8010509a:	ff 75 ec             	pushl  -0x14(%ebp)
8010509d:	e8 3e c1 ff ff       	call   801011e0 <filewrite>
801050a2:	83 c4 10             	add    $0x10,%esp
}
801050a5:	c9                   	leave  
801050a6:	c3                   	ret    
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050b5:	c9                   	leave  
801050b6:	c3                   	ret    
801050b7:	89 f6                	mov    %esi,%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050c0 <sys_close>:
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801050c6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801050c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050cc:	e8 4f fe ff ff       	call   80104f20 <argfd.constprop.0>
801050d1:	85 c0                	test   %eax,%eax
801050d3:	78 2b                	js     80105100 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801050d5:	e8 66 e9 ff ff       	call   80103a40 <myproc>
801050da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801050dd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050e0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801050e7:	00 
  fileclose(f);
801050e8:	ff 75 f4             	pushl  -0xc(%ebp)
801050eb:	e8 40 bf ff ff       	call   80101030 <fileclose>
  return 0;
801050f0:	83 c4 10             	add    $0x10,%esp
801050f3:	31 c0                	xor    %eax,%eax
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	89 f6                	mov    %esi,%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105105:	c9                   	leave  
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <sys_fstat>:
{
80105110:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105111:	31 c0                	xor    %eax,%eax
{
80105113:	89 e5                	mov    %esp,%ebp
80105115:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105118:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010511b:	e8 00 fe ff ff       	call   80104f20 <argfd.constprop.0>
80105120:	85 c0                	test   %eax,%eax
80105122:	78 2c                	js     80105150 <sys_fstat+0x40>
80105124:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105127:	83 ec 04             	sub    $0x4,%esp
8010512a:	6a 14                	push   $0x14
8010512c:	50                   	push   %eax
8010512d:	6a 01                	push   $0x1
8010512f:	e8 4c fb ff ff       	call   80104c80 <argptr>
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	85 c0                	test   %eax,%eax
80105139:	78 15                	js     80105150 <sys_fstat+0x40>
  return filestat(f, st);
8010513b:	83 ec 08             	sub    $0x8,%esp
8010513e:	ff 75 f4             	pushl  -0xc(%ebp)
80105141:	ff 75 f0             	pushl  -0x10(%ebp)
80105144:	e8 b7 bf ff ff       	call   80101100 <filestat>
80105149:	83 c4 10             	add    $0x10,%esp
}
8010514c:	c9                   	leave  
8010514d:	c3                   	ret    
8010514e:	66 90                	xchg   %ax,%ax
    return -1;
80105150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105155:	c9                   	leave  
80105156:	c3                   	ret    
80105157:	89 f6                	mov    %esi,%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105160 <sys_link>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
80105165:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105166:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105169:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010516c:	50                   	push   %eax
8010516d:	6a 00                	push   $0x0
8010516f:	e8 6c fb ff ff       	call   80104ce0 <argstr>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 88 fb 00 00 00    	js     8010527a <sys_link+0x11a>
8010517f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105182:	83 ec 08             	sub    $0x8,%esp
80105185:	50                   	push   %eax
80105186:	6a 01                	push   $0x1
80105188:	e8 53 fb ff ff       	call   80104ce0 <argstr>
8010518d:	83 c4 10             	add    $0x10,%esp
80105190:	85 c0                	test   %eax,%eax
80105192:	0f 88 e2 00 00 00    	js     8010527a <sys_link+0x11a>
  begin_op();
80105198:	e8 43 dc ff ff       	call   80102de0 <begin_op>
  if((ip = namei(old)) == 0){
8010519d:	83 ec 0c             	sub    $0xc,%esp
801051a0:	ff 75 d4             	pushl  -0x2c(%ebp)
801051a3:	e8 78 cf ff ff       	call   80102120 <namei>
801051a8:	83 c4 10             	add    $0x10,%esp
801051ab:	85 c0                	test   %eax,%eax
801051ad:	89 c3                	mov    %eax,%ebx
801051af:	0f 84 ea 00 00 00    	je     8010529f <sys_link+0x13f>
  ilock(ip);
801051b5:	83 ec 0c             	sub    $0xc,%esp
801051b8:	50                   	push   %eax
801051b9:	e8 02 c7 ff ff       	call   801018c0 <ilock>
  if(ip->type == T_DIR){
801051be:	83 c4 10             	add    $0x10,%esp
801051c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051c6:	0f 84 bb 00 00 00    	je     80105287 <sys_link+0x127>
  ip->nlink++;
801051cc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801051d1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801051d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051d7:	53                   	push   %ebx
801051d8:	e8 33 c6 ff ff       	call   80101810 <iupdate>
  iunlock(ip);
801051dd:	89 1c 24             	mov    %ebx,(%esp)
801051e0:	e8 bb c7 ff ff       	call   801019a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051e5:	58                   	pop    %eax
801051e6:	5a                   	pop    %edx
801051e7:	57                   	push   %edi
801051e8:	ff 75 d0             	pushl  -0x30(%ebp)
801051eb:	e8 50 cf ff ff       	call   80102140 <nameiparent>
801051f0:	83 c4 10             	add    $0x10,%esp
801051f3:	85 c0                	test   %eax,%eax
801051f5:	89 c6                	mov    %eax,%esi
801051f7:	74 5b                	je     80105254 <sys_link+0xf4>
  ilock(dp);
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	50                   	push   %eax
801051fd:	e8 be c6 ff ff       	call   801018c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105202:	83 c4 10             	add    $0x10,%esp
80105205:	8b 03                	mov    (%ebx),%eax
80105207:	39 06                	cmp    %eax,(%esi)
80105209:	75 3d                	jne    80105248 <sys_link+0xe8>
8010520b:	83 ec 04             	sub    $0x4,%esp
8010520e:	ff 73 04             	pushl  0x4(%ebx)
80105211:	57                   	push   %edi
80105212:	56                   	push   %esi
80105213:	e8 48 ce ff ff       	call   80102060 <dirlink>
80105218:	83 c4 10             	add    $0x10,%esp
8010521b:	85 c0                	test   %eax,%eax
8010521d:	78 29                	js     80105248 <sys_link+0xe8>
  iunlockput(dp);
8010521f:	83 ec 0c             	sub    $0xc,%esp
80105222:	56                   	push   %esi
80105223:	e8 28 c9 ff ff       	call   80101b50 <iunlockput>
  iput(ip);
80105228:	89 1c 24             	mov    %ebx,(%esp)
8010522b:	e8 c0 c7 ff ff       	call   801019f0 <iput>
  end_op();
80105230:	e8 1b dc ff ff       	call   80102e50 <end_op>
  return 0;
80105235:	83 c4 10             	add    $0x10,%esp
80105238:	31 c0                	xor    %eax,%eax
}
8010523a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010523d:	5b                   	pop    %ebx
8010523e:	5e                   	pop    %esi
8010523f:	5f                   	pop    %edi
80105240:	5d                   	pop    %ebp
80105241:	c3                   	ret    
80105242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105248:	83 ec 0c             	sub    $0xc,%esp
8010524b:	56                   	push   %esi
8010524c:	e8 ff c8 ff ff       	call   80101b50 <iunlockput>
    goto bad;
80105251:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	53                   	push   %ebx
80105258:	e8 63 c6 ff ff       	call   801018c0 <ilock>
  ip->nlink--;
8010525d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105262:	89 1c 24             	mov    %ebx,(%esp)
80105265:	e8 a6 c5 ff ff       	call   80101810 <iupdate>
  iunlockput(ip);
8010526a:	89 1c 24             	mov    %ebx,(%esp)
8010526d:	e8 de c8 ff ff       	call   80101b50 <iunlockput>
  end_op();
80105272:	e8 d9 db ff ff       	call   80102e50 <end_op>
  return -1;
80105277:	83 c4 10             	add    $0x10,%esp
}
8010527a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010527d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105282:	5b                   	pop    %ebx
80105283:	5e                   	pop    %esi
80105284:	5f                   	pop    %edi
80105285:	5d                   	pop    %ebp
80105286:	c3                   	ret    
    iunlockput(ip);
80105287:	83 ec 0c             	sub    $0xc,%esp
8010528a:	53                   	push   %ebx
8010528b:	e8 c0 c8 ff ff       	call   80101b50 <iunlockput>
    end_op();
80105290:	e8 bb db ff ff       	call   80102e50 <end_op>
    return -1;
80105295:	83 c4 10             	add    $0x10,%esp
80105298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010529d:	eb 9b                	jmp    8010523a <sys_link+0xda>
    end_op();
8010529f:	e8 ac db ff ff       	call   80102e50 <end_op>
    return -1;
801052a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a9:	eb 8f                	jmp    8010523a <sys_link+0xda>
801052ab:	90                   	nop
801052ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052b0 <sys_unlink>:
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
801052b5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801052b6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052b9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801052bc:	50                   	push   %eax
801052bd:	6a 00                	push   $0x0
801052bf:	e8 1c fa ff ff       	call   80104ce0 <argstr>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	0f 88 77 01 00 00    	js     80105446 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801052cf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801052d2:	e8 09 db ff ff       	call   80102de0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052d7:	83 ec 08             	sub    $0x8,%esp
801052da:	53                   	push   %ebx
801052db:	ff 75 c0             	pushl  -0x40(%ebp)
801052de:	e8 5d ce ff ff       	call   80102140 <nameiparent>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	89 c6                	mov    %eax,%esi
801052ea:	0f 84 60 01 00 00    	je     80105450 <sys_unlink+0x1a0>
  ilock(dp);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	50                   	push   %eax
801052f4:	e8 c7 c5 ff ff       	call   801018c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052f9:	58                   	pop    %eax
801052fa:	5a                   	pop    %edx
801052fb:	68 68 7d 10 80       	push   $0x80107d68
80105300:	53                   	push   %ebx
80105301:	e8 ca ca ff ff       	call   80101dd0 <namecmp>
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	85 c0                	test   %eax,%eax
8010530b:	0f 84 03 01 00 00    	je     80105414 <sys_unlink+0x164>
80105311:	83 ec 08             	sub    $0x8,%esp
80105314:	68 67 7d 10 80       	push   $0x80107d67
80105319:	53                   	push   %ebx
8010531a:	e8 b1 ca ff ff       	call   80101dd0 <namecmp>
8010531f:	83 c4 10             	add    $0x10,%esp
80105322:	85 c0                	test   %eax,%eax
80105324:	0f 84 ea 00 00 00    	je     80105414 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010532a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010532d:	83 ec 04             	sub    $0x4,%esp
80105330:	50                   	push   %eax
80105331:	53                   	push   %ebx
80105332:	56                   	push   %esi
80105333:	e8 b8 ca ff ff       	call   80101df0 <dirlookup>
80105338:	83 c4 10             	add    $0x10,%esp
8010533b:	85 c0                	test   %eax,%eax
8010533d:	89 c3                	mov    %eax,%ebx
8010533f:	0f 84 cf 00 00 00    	je     80105414 <sys_unlink+0x164>
  ilock(ip);
80105345:	83 ec 0c             	sub    $0xc,%esp
80105348:	50                   	push   %eax
80105349:	e8 72 c5 ff ff       	call   801018c0 <ilock>
  if(ip->nlink < 1)
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105356:	0f 8e 10 01 00 00    	jle    8010546c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010535c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105361:	74 6d                	je     801053d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105363:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105366:	83 ec 04             	sub    $0x4,%esp
80105369:	6a 10                	push   $0x10
8010536b:	6a 00                	push   $0x0
8010536d:	50                   	push   %eax
8010536e:	e8 bd f5 ff ff       	call   80104930 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105373:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105376:	6a 10                	push   $0x10
80105378:	ff 75 c4             	pushl  -0x3c(%ebp)
8010537b:	50                   	push   %eax
8010537c:	56                   	push   %esi
8010537d:	e8 1e c9 ff ff       	call   80101ca0 <writei>
80105382:	83 c4 20             	add    $0x20,%esp
80105385:	83 f8 10             	cmp    $0x10,%eax
80105388:	0f 85 eb 00 00 00    	jne    80105479 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010538e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105393:	0f 84 97 00 00 00    	je     80105430 <sys_unlink+0x180>
  iunlockput(dp);
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	56                   	push   %esi
8010539d:	e8 ae c7 ff ff       	call   80101b50 <iunlockput>
  ip->nlink--;
801053a2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053a7:	89 1c 24             	mov    %ebx,(%esp)
801053aa:	e8 61 c4 ff ff       	call   80101810 <iupdate>
  iunlockput(ip);
801053af:	89 1c 24             	mov    %ebx,(%esp)
801053b2:	e8 99 c7 ff ff       	call   80101b50 <iunlockput>
  end_op();
801053b7:	e8 94 da ff ff       	call   80102e50 <end_op>
  return 0;
801053bc:	83 c4 10             	add    $0x10,%esp
801053bf:	31 c0                	xor    %eax,%eax
}
801053c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053c4:	5b                   	pop    %ebx
801053c5:	5e                   	pop    %esi
801053c6:	5f                   	pop    %edi
801053c7:	5d                   	pop    %ebp
801053c8:	c3                   	ret    
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053d4:	76 8d                	jbe    80105363 <sys_unlink+0xb3>
801053d6:	bf 20 00 00 00       	mov    $0x20,%edi
801053db:	eb 0f                	jmp    801053ec <sys_unlink+0x13c>
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
801053e0:	83 c7 10             	add    $0x10,%edi
801053e3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801053e6:	0f 83 77 ff ff ff    	jae    80105363 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053ef:	6a 10                	push   $0x10
801053f1:	57                   	push   %edi
801053f2:	50                   	push   %eax
801053f3:	53                   	push   %ebx
801053f4:	e8 a7 c7 ff ff       	call   80101ba0 <readi>
801053f9:	83 c4 10             	add    $0x10,%esp
801053fc:	83 f8 10             	cmp    $0x10,%eax
801053ff:	75 5e                	jne    8010545f <sys_unlink+0x1af>
    if(de.inum != 0)
80105401:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105406:	74 d8                	je     801053e0 <sys_unlink+0x130>
    iunlockput(ip);
80105408:	83 ec 0c             	sub    $0xc,%esp
8010540b:	53                   	push   %ebx
8010540c:	e8 3f c7 ff ff       	call   80101b50 <iunlockput>
    goto bad;
80105411:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	56                   	push   %esi
80105418:	e8 33 c7 ff ff       	call   80101b50 <iunlockput>
  end_op();
8010541d:	e8 2e da ff ff       	call   80102e50 <end_op>
  return -1;
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542a:	eb 95                	jmp    801053c1 <sys_unlink+0x111>
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105430:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105435:	83 ec 0c             	sub    $0xc,%esp
80105438:	56                   	push   %esi
80105439:	e8 d2 c3 ff ff       	call   80101810 <iupdate>
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	e9 53 ff ff ff       	jmp    80105399 <sys_unlink+0xe9>
    return -1;
80105446:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544b:	e9 71 ff ff ff       	jmp    801053c1 <sys_unlink+0x111>
    end_op();
80105450:	e8 fb d9 ff ff       	call   80102e50 <end_op>
    return -1;
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545a:	e9 62 ff ff ff       	jmp    801053c1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010545f:	83 ec 0c             	sub    $0xc,%esp
80105462:	68 8c 7d 10 80       	push   $0x80107d8c
80105467:	e8 24 af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010546c:	83 ec 0c             	sub    $0xc,%esp
8010546f:	68 7a 7d 10 80       	push   $0x80107d7a
80105474:	e8 17 af ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105479:	83 ec 0c             	sub    $0xc,%esp
8010547c:	68 9e 7d 10 80       	push   $0x80107d9e
80105481:	e8 0a af ff ff       	call   80100390 <panic>
80105486:	8d 76 00             	lea    0x0(%esi),%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <sys_memo>:

int
sys_memo(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	83 ec 20             	sub    $0x20,%esp
  char *memo;
  struct file *f;

  if(argstr(0, &memo) < 0 )
80105496:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105499:	50                   	push   %eax
8010549a:	6a 00                	push   $0x0
8010549c:	e8 3f f8 ff ff       	call   80104ce0 <argstr>
801054a1:	83 c4 10             	add    $0x10,%esp
801054a4:	85 c0                	test   %eax,%eax
801054a6:	78 20                	js     801054c8 <sys_memo+0x38>
    return -1;

  if((f = filealloc()) == 0){
801054a8:	e8 c3 ba ff ff       	call   80100f70 <filealloc>
801054ad:	85 c0                	test   %eax,%eax
801054af:	74 17                	je     801054c8 <sys_memo+0x38>
    if(f)
      fileclose(f);
    return -1;
  }

  f->type = FD_MEMO;
801054b1:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->off = 0;
801054b7:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  return 0;
801054be:	31 c0                	xor    %eax,%eax
}
801054c0:	c9                   	leave  
801054c1:	c3                   	ret    
801054c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801054c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054cd:	c9                   	leave  
801054ce:	c3                   	ret    
801054cf:	90                   	nop

801054d0 <sys_open>:

int
sys_open(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	57                   	push   %edi
801054d4:	56                   	push   %esi
801054d5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054dc:	50                   	push   %eax
801054dd:	6a 00                	push   $0x0
801054df:	e8 fc f7 ff ff       	call   80104ce0 <argstr>
801054e4:	83 c4 10             	add    $0x10,%esp
801054e7:	85 c0                	test   %eax,%eax
801054e9:	0f 88 1d 01 00 00    	js     8010560c <sys_open+0x13c>
801054ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054f2:	83 ec 08             	sub    $0x8,%esp
801054f5:	50                   	push   %eax
801054f6:	6a 01                	push   $0x1
801054f8:	e8 33 f7 ff ff       	call   80104c30 <argint>
801054fd:	83 c4 10             	add    $0x10,%esp
80105500:	85 c0                	test   %eax,%eax
80105502:	0f 88 04 01 00 00    	js     8010560c <sys_open+0x13c>
    return -1;

  begin_op();
80105508:	e8 d3 d8 ff ff       	call   80102de0 <begin_op>

  if(omode & O_CREATE){
8010550d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105511:	0f 85 a9 00 00 00    	jne    801055c0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105517:	83 ec 0c             	sub    $0xc,%esp
8010551a:	ff 75 e0             	pushl  -0x20(%ebp)
8010551d:	e8 fe cb ff ff       	call   80102120 <namei>
80105522:	83 c4 10             	add    $0x10,%esp
80105525:	85 c0                	test   %eax,%eax
80105527:	89 c6                	mov    %eax,%esi
80105529:	0f 84 b2 00 00 00    	je     801055e1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010552f:	83 ec 0c             	sub    $0xc,%esp
80105532:	50                   	push   %eax
80105533:	e8 88 c3 ff ff       	call   801018c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105538:	83 c4 10             	add    $0x10,%esp
8010553b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105540:	0f 84 aa 00 00 00    	je     801055f0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105546:	e8 25 ba ff ff       	call   80100f70 <filealloc>
8010554b:	85 c0                	test   %eax,%eax
8010554d:	89 c7                	mov    %eax,%edi
8010554f:	0f 84 a6 00 00 00    	je     801055fb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105555:	e8 e6 e4 ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010555a:	31 db                	xor    %ebx,%ebx
8010555c:	eb 0e                	jmp    8010556c <sys_open+0x9c>
8010555e:	66 90                	xchg   %ax,%ax
80105560:	83 c3 01             	add    $0x1,%ebx
80105563:	83 fb 10             	cmp    $0x10,%ebx
80105566:	0f 84 ac 00 00 00    	je     80105618 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010556c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105570:	85 d2                	test   %edx,%edx
80105572:	75 ec                	jne    80105560 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105574:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105577:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010557b:	56                   	push   %esi
8010557c:	e8 1f c4 ff ff       	call   801019a0 <iunlock>
  end_op();
80105581:	e8 ca d8 ff ff       	call   80102e50 <end_op>

  f->type = FD_INODE;
80105586:	c7 07 03 00 00 00    	movl   $0x3,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010558c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010558f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105592:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105595:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
  f->readable = !(omode & O_WRONLY);
8010559c:	89 d0                	mov    %edx,%eax
8010559e:	f7 d0                	not    %eax
801055a0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055a3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055a6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055a9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055b0:	89 d8                	mov    %ebx,%eax
801055b2:	5b                   	pop    %ebx
801055b3:	5e                   	pop    %esi
801055b4:	5f                   	pop    %edi
801055b5:	5d                   	pop    %ebp
801055b6:	c3                   	ret    
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055c6:	31 c9                	xor    %ecx,%ecx
801055c8:	6a 00                	push   $0x0
801055ca:	ba 02 00 00 00       	mov    $0x2,%edx
801055cf:	e8 ac f7 ff ff       	call   80104d80 <create>
    if(ip == 0){
801055d4:	83 c4 10             	add    $0x10,%esp
801055d7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801055d9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055db:	0f 85 65 ff ff ff    	jne    80105546 <sys_open+0x76>
      end_op();
801055e1:	e8 6a d8 ff ff       	call   80102e50 <end_op>
      return -1;
801055e6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055eb:	eb c0                	jmp    801055ad <sys_open+0xdd>
801055ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801055f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055f3:	85 c9                	test   %ecx,%ecx
801055f5:	0f 84 4b ff ff ff    	je     80105546 <sys_open+0x76>
    iunlockput(ip);
801055fb:	83 ec 0c             	sub    $0xc,%esp
801055fe:	56                   	push   %esi
801055ff:	e8 4c c5 ff ff       	call   80101b50 <iunlockput>
    end_op();
80105604:	e8 47 d8 ff ff       	call   80102e50 <end_op>
    return -1;
80105609:	83 c4 10             	add    $0x10,%esp
8010560c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105611:	eb 9a                	jmp    801055ad <sys_open+0xdd>
80105613:	90                   	nop
80105614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	57                   	push   %edi
8010561c:	e8 0f ba ff ff       	call   80101030 <fileclose>
80105621:	83 c4 10             	add    $0x10,%esp
80105624:	eb d5                	jmp    801055fb <sys_open+0x12b>
80105626:	8d 76 00             	lea    0x0(%esi),%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <sys_mkdir>:

int
sys_mkdir(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105636:	e8 a5 d7 ff ff       	call   80102de0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010563b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010563e:	83 ec 08             	sub    $0x8,%esp
80105641:	50                   	push   %eax
80105642:	6a 00                	push   $0x0
80105644:	e8 97 f6 ff ff       	call   80104ce0 <argstr>
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	85 c0                	test   %eax,%eax
8010564e:	78 30                	js     80105680 <sys_mkdir+0x50>
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105656:	31 c9                	xor    %ecx,%ecx
80105658:	6a 00                	push   $0x0
8010565a:	ba 01 00 00 00       	mov    $0x1,%edx
8010565f:	e8 1c f7 ff ff       	call   80104d80 <create>
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	85 c0                	test   %eax,%eax
80105669:	74 15                	je     80105680 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010566b:	83 ec 0c             	sub    $0xc,%esp
8010566e:	50                   	push   %eax
8010566f:	e8 dc c4 ff ff       	call   80101b50 <iunlockput>
  end_op();
80105674:	e8 d7 d7 ff ff       	call   80102e50 <end_op>
  return 0;
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	31 c0                	xor    %eax,%eax
}
8010567e:	c9                   	leave  
8010567f:	c3                   	ret    
    end_op();
80105680:	e8 cb d7 ff ff       	call   80102e50 <end_op>
    return -1;
80105685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010568a:	c9                   	leave  
8010568b:	c3                   	ret    
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105690 <sys_mknod>:

int
sys_mknod(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105696:	e8 45 d7 ff ff       	call   80102de0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010569b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010569e:	83 ec 08             	sub    $0x8,%esp
801056a1:	50                   	push   %eax
801056a2:	6a 00                	push   $0x0
801056a4:	e8 37 f6 ff ff       	call   80104ce0 <argstr>
801056a9:	83 c4 10             	add    $0x10,%esp
801056ac:	85 c0                	test   %eax,%eax
801056ae:	78 60                	js     80105710 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b3:	83 ec 08             	sub    $0x8,%esp
801056b6:	50                   	push   %eax
801056b7:	6a 01                	push   $0x1
801056b9:	e8 72 f5 ff ff       	call   80104c30 <argint>
  if((argstr(0, &path)) < 0 ||
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	85 c0                	test   %eax,%eax
801056c3:	78 4b                	js     80105710 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c8:	83 ec 08             	sub    $0x8,%esp
801056cb:	50                   	push   %eax
801056cc:	6a 02                	push   $0x2
801056ce:	e8 5d f5 ff ff       	call   80104c30 <argint>
     argint(1, &major) < 0 ||
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	78 36                	js     80105710 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801056de:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801056e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801056e5:	ba 03 00 00 00       	mov    $0x3,%edx
801056ea:	50                   	push   %eax
801056eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056ee:	e8 8d f6 ff ff       	call   80104d80 <create>
801056f3:	83 c4 10             	add    $0x10,%esp
801056f6:	85 c0                	test   %eax,%eax
801056f8:	74 16                	je     80105710 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056fa:	83 ec 0c             	sub    $0xc,%esp
801056fd:	50                   	push   %eax
801056fe:	e8 4d c4 ff ff       	call   80101b50 <iunlockput>
  end_op();
80105703:	e8 48 d7 ff ff       	call   80102e50 <end_op>
  return 0;
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	31 c0                	xor    %eax,%eax
}
8010570d:	c9                   	leave  
8010570e:	c3                   	ret    
8010570f:	90                   	nop
    end_op();
80105710:	e8 3b d7 ff ff       	call   80102e50 <end_op>
    return -1;
80105715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010571a:	c9                   	leave  
8010571b:	c3                   	ret    
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_chdir>:

int
sys_chdir(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	56                   	push   %esi
80105724:	53                   	push   %ebx
80105725:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105728:	e8 13 e3 ff ff       	call   80103a40 <myproc>
8010572d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010572f:	e8 ac d6 ff ff       	call   80102de0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105734:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105737:	83 ec 08             	sub    $0x8,%esp
8010573a:	50                   	push   %eax
8010573b:	6a 00                	push   $0x0
8010573d:	e8 9e f5 ff ff       	call   80104ce0 <argstr>
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	85 c0                	test   %eax,%eax
80105747:	78 77                	js     801057c0 <sys_chdir+0xa0>
80105749:	83 ec 0c             	sub    $0xc,%esp
8010574c:	ff 75 f4             	pushl  -0xc(%ebp)
8010574f:	e8 cc c9 ff ff       	call   80102120 <namei>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	85 c0                	test   %eax,%eax
80105759:	89 c3                	mov    %eax,%ebx
8010575b:	74 63                	je     801057c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010575d:	83 ec 0c             	sub    $0xc,%esp
80105760:	50                   	push   %eax
80105761:	e8 5a c1 ff ff       	call   801018c0 <ilock>
  if(ip->type != T_DIR){
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010576e:	75 30                	jne    801057a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105770:	83 ec 0c             	sub    $0xc,%esp
80105773:	53                   	push   %ebx
80105774:	e8 27 c2 ff ff       	call   801019a0 <iunlock>
  iput(curproc->cwd);
80105779:	58                   	pop    %eax
8010577a:	ff 76 68             	pushl  0x68(%esi)
8010577d:	e8 6e c2 ff ff       	call   801019f0 <iput>
  end_op();
80105782:	e8 c9 d6 ff ff       	call   80102e50 <end_op>
  curproc->cwd = ip;
80105787:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	31 c0                	xor    %eax,%eax
}
8010578f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105792:	5b                   	pop    %ebx
80105793:	5e                   	pop    %esi
80105794:	5d                   	pop    %ebp
80105795:	c3                   	ret    
80105796:	8d 76 00             	lea    0x0(%esi),%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	53                   	push   %ebx
801057a4:	e8 a7 c3 ff ff       	call   80101b50 <iunlockput>
    end_op();
801057a9:	e8 a2 d6 ff ff       	call   80102e50 <end_op>
    return -1;
801057ae:	83 c4 10             	add    $0x10,%esp
801057b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b6:	eb d7                	jmp    8010578f <sys_chdir+0x6f>
801057b8:	90                   	nop
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801057c0:	e8 8b d6 ff ff       	call   80102e50 <end_op>
    return -1;
801057c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ca:	eb c3                	jmp    8010578f <sys_chdir+0x6f>
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_exec>:

int
sys_exec(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
801057d5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057d6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057e2:	50                   	push   %eax
801057e3:	6a 00                	push   $0x0
801057e5:	e8 f6 f4 ff ff       	call   80104ce0 <argstr>
801057ea:	83 c4 10             	add    $0x10,%esp
801057ed:	85 c0                	test   %eax,%eax
801057ef:	0f 88 87 00 00 00    	js     8010587c <sys_exec+0xac>
801057f5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057fb:	83 ec 08             	sub    $0x8,%esp
801057fe:	50                   	push   %eax
801057ff:	6a 01                	push   $0x1
80105801:	e8 2a f4 ff ff       	call   80104c30 <argint>
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	85 c0                	test   %eax,%eax
8010580b:	78 6f                	js     8010587c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010580d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105813:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105816:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105818:	68 80 00 00 00       	push   $0x80
8010581d:	6a 00                	push   $0x0
8010581f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105825:	50                   	push   %eax
80105826:	e8 05 f1 ff ff       	call   80104930 <memset>
8010582b:	83 c4 10             	add    $0x10,%esp
8010582e:	eb 2c                	jmp    8010585c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105830:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105836:	85 c0                	test   %eax,%eax
80105838:	74 56                	je     80105890 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010583a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105840:	83 ec 08             	sub    $0x8,%esp
80105843:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105846:	52                   	push   %edx
80105847:	50                   	push   %eax
80105848:	e8 73 f3 ff ff       	call   80104bc0 <fetchstr>
8010584d:	83 c4 10             	add    $0x10,%esp
80105850:	85 c0                	test   %eax,%eax
80105852:	78 28                	js     8010587c <sys_exec+0xac>
  for(i=0;; i++){
80105854:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105857:	83 fb 20             	cmp    $0x20,%ebx
8010585a:	74 20                	je     8010587c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010585c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105862:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105869:	83 ec 08             	sub    $0x8,%esp
8010586c:	57                   	push   %edi
8010586d:	01 f0                	add    %esi,%eax
8010586f:	50                   	push   %eax
80105870:	e8 0b f3 ff ff       	call   80104b80 <fetchint>
80105875:	83 c4 10             	add    $0x10,%esp
80105878:	85 c0                	test   %eax,%eax
8010587a:	79 b4                	jns    80105830 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010587c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010587f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105884:	5b                   	pop    %ebx
80105885:	5e                   	pop    %esi
80105886:	5f                   	pop    %edi
80105887:	5d                   	pop    %ebp
80105888:	c3                   	ret    
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105890:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105896:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105899:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058a0:	00 00 00 00 
  return exec(path, argv);
801058a4:	50                   	push   %eax
801058a5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801058ab:	e8 f0 b2 ff ff       	call   80100ba0 <exec>
801058b0:	83 c4 10             	add    $0x10,%esp
}
801058b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058b6:	5b                   	pop    %ebx
801058b7:	5e                   	pop    %esi
801058b8:	5f                   	pop    %edi
801058b9:	5d                   	pop    %ebp
801058ba:	c3                   	ret    
801058bb:	90                   	nop
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_pipe>:

int
sys_pipe(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	57                   	push   %edi
801058c4:	56                   	push   %esi
801058c5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058cc:	6a 08                	push   $0x8
801058ce:	50                   	push   %eax
801058cf:	6a 00                	push   $0x0
801058d1:	e8 aa f3 ff ff       	call   80104c80 <argptr>
801058d6:	83 c4 10             	add    $0x10,%esp
801058d9:	85 c0                	test   %eax,%eax
801058db:	0f 88 ae 00 00 00    	js     8010598f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058e4:	83 ec 08             	sub    $0x8,%esp
801058e7:	50                   	push   %eax
801058e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058eb:	50                   	push   %eax
801058ec:	e8 8f db ff ff       	call   80103480 <pipealloc>
801058f1:	83 c4 10             	add    $0x10,%esp
801058f4:	85 c0                	test   %eax,%eax
801058f6:	0f 88 93 00 00 00    	js     8010598f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058ff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105901:	e8 3a e1 ff ff       	call   80103a40 <myproc>
80105906:	eb 10                	jmp    80105918 <sys_pipe+0x58>
80105908:	90                   	nop
80105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105910:	83 c3 01             	add    $0x1,%ebx
80105913:	83 fb 10             	cmp    $0x10,%ebx
80105916:	74 60                	je     80105978 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105918:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010591c:	85 f6                	test   %esi,%esi
8010591e:	75 f0                	jne    80105910 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105920:	8d 73 08             	lea    0x8(%ebx),%esi
80105923:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105927:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010592a:	e8 11 e1 ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010592f:	31 d2                	xor    %edx,%edx
80105931:	eb 0d                	jmp    80105940 <sys_pipe+0x80>
80105933:	90                   	nop
80105934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105938:	83 c2 01             	add    $0x1,%edx
8010593b:	83 fa 10             	cmp    $0x10,%edx
8010593e:	74 28                	je     80105968 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105940:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105944:	85 c9                	test   %ecx,%ecx
80105946:	75 f0                	jne    80105938 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105948:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010594c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010594f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105951:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105954:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105957:	31 c0                	xor    %eax,%eax
}
80105959:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010595c:	5b                   	pop    %ebx
8010595d:	5e                   	pop    %esi
8010595e:	5f                   	pop    %edi
8010595f:	5d                   	pop    %ebp
80105960:	c3                   	ret    
80105961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105968:	e8 d3 e0 ff ff       	call   80103a40 <myproc>
8010596d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105974:	00 
80105975:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105978:	83 ec 0c             	sub    $0xc,%esp
8010597b:	ff 75 e0             	pushl  -0x20(%ebp)
8010597e:	e8 ad b6 ff ff       	call   80101030 <fileclose>
    fileclose(wf);
80105983:	58                   	pop    %eax
80105984:	ff 75 e4             	pushl  -0x1c(%ebp)
80105987:	e8 a4 b6 ff ff       	call   80101030 <fileclose>
    return -1;
8010598c:	83 c4 10             	add    $0x10,%esp
8010598f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105994:	eb c3                	jmp    80105959 <sys_pipe+0x99>
80105996:	66 90                	xchg   %ax,%ax
80105998:	66 90                	xchg   %ax,%ax
8010599a:	66 90                	xchg   %ax,%ax
8010599c:	66 90                	xchg   %ax,%ax
8010599e:	66 90                	xchg   %ax,%ax

801059a0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801059a3:	5d                   	pop    %ebp
  return fork();
801059a4:	e9 17 e4 ff ff       	jmp    80103dc0 <fork>
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_exit>:

int
sys_exit(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059b6:	e8 45 e7 ff ff       	call   80104100 <exit>
  return 0;  // not reached
}
801059bb:	31 c0                	xor    %eax,%eax
801059bd:	c9                   	leave  
801059be:	c3                   	ret    
801059bf:	90                   	nop

801059c0 <sys_wait>:

int
sys_wait(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801059c3:	5d                   	pop    %ebp
  return wait();
801059c4:	e9 57 e9 ff ff       	jmp    80104320 <wait>
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_kill>:

int
sys_kill(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d9:	50                   	push   %eax
801059da:	6a 00                	push   $0x0
801059dc:	e8 4f f2 ff ff       	call   80104c30 <argint>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	85 c0                	test   %eax,%eax
801059e6:	78 18                	js     80105a00 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059e8:	83 ec 0c             	sub    $0xc,%esp
801059eb:	ff 75 f4             	pushl  -0xc(%ebp)
801059ee:	e8 6d ea ff ff       	call   80104460 <kill>
801059f3:	83 c4 10             	add    $0x10,%esp
}
801059f6:	c9                   	leave  
801059f7:	c3                   	ret    
801059f8:	90                   	nop
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a05:	c9                   	leave  
80105a06:	c3                   	ret    
80105a07:	89 f6                	mov    %esi,%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a10 <sys_getpid>:

int
sys_getpid(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a16:	e8 25 e0 ff ff       	call   80103a40 <myproc>
80105a1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a1e:	c9                   	leave  
80105a1f:	c3                   	ret    

80105a20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a2a:	50                   	push   %eax
80105a2b:	6a 00                	push   $0x0
80105a2d:	e8 fe f1 ff ff       	call   80104c30 <argint>
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	85 c0                	test   %eax,%eax
80105a37:	78 27                	js     80105a60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a39:	e8 02 e0 ff ff       	call   80103a40 <myproc>
  if(growproc(n) < 0)
80105a3e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a43:	ff 75 f4             	pushl  -0xc(%ebp)
80105a46:	e8 f5 e2 ff ff       	call   80103d40 <growproc>
80105a4b:	83 c4 10             	add    $0x10,%esp
80105a4e:	85 c0                	test   %eax,%eax
80105a50:	78 0e                	js     80105a60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a52:	89 d8                	mov    %ebx,%eax
80105a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a57:	c9                   	leave  
80105a58:	c3                   	ret    
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a65:	eb eb                	jmp    80105a52 <sys_sbrk+0x32>
80105a67:	89 f6                	mov    %esi,%esi
80105a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a70 <sys_sleep>:

int
sys_sleep(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a7a:	50                   	push   %eax
80105a7b:	6a 00                	push   $0x0
80105a7d:	e8 ae f1 ff ff       	call   80104c30 <argint>
80105a82:	83 c4 10             	add    $0x10,%esp
80105a85:	85 c0                	test   %eax,%eax
80105a87:	0f 88 8a 00 00 00    	js     80105b17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	68 80 70 11 80       	push   $0x80117080
80105a95:	e8 16 ed ff ff       	call   801047b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a9d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105aa0:	8b 1d c0 78 11 80    	mov    0x801178c0,%ebx
  while(ticks - ticks0 < n){
80105aa6:	85 d2                	test   %edx,%edx
80105aa8:	75 27                	jne    80105ad1 <sys_sleep+0x61>
80105aaa:	eb 54                	jmp    80105b00 <sys_sleep+0x90>
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ab0:	83 ec 08             	sub    $0x8,%esp
80105ab3:	68 80 70 11 80       	push   $0x80117080
80105ab8:	68 c0 78 11 80       	push   $0x801178c0
80105abd:	e8 9e e7 ff ff       	call   80104260 <sleep>
  while(ticks - ticks0 < n){
80105ac2:	a1 c0 78 11 80       	mov    0x801178c0,%eax
80105ac7:	83 c4 10             	add    $0x10,%esp
80105aca:	29 d8                	sub    %ebx,%eax
80105acc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105acf:	73 2f                	jae    80105b00 <sys_sleep+0x90>
    if(myproc()->killed){
80105ad1:	e8 6a df ff ff       	call   80103a40 <myproc>
80105ad6:	8b 40 24             	mov    0x24(%eax),%eax
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	74 d3                	je     80105ab0 <sys_sleep+0x40>
      release(&tickslock);
80105add:	83 ec 0c             	sub    $0xc,%esp
80105ae0:	68 80 70 11 80       	push   $0x80117080
80105ae5:	e8 e6 ed ff ff       	call   801048d0 <release>
      return -1;
80105aea:	83 c4 10             	add    $0x10,%esp
80105aed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105af2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	68 80 70 11 80       	push   $0x80117080
80105b08:	e8 c3 ed ff ff       	call   801048d0 <release>
  return 0;
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	31 c0                	xor    %eax,%eax
}
80105b12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b15:	c9                   	leave  
80105b16:	c3                   	ret    
    return -1;
80105b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1c:	eb f4                	jmp    80105b12 <sys_sleep+0xa2>
80105b1e:	66 90                	xchg   %ax,%ax

80105b20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
80105b24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b27:	68 80 70 11 80       	push   $0x80117080
80105b2c:	e8 7f ec ff ff       	call   801047b0 <acquire>
  xticks = ticks;
80105b31:	8b 1d c0 78 11 80    	mov    0x801178c0,%ebx
  release(&tickslock);
80105b37:	c7 04 24 80 70 11 80 	movl   $0x80117080,(%esp)
80105b3e:	e8 8d ed ff ff       	call   801048d0 <release>
  return xticks;
}
80105b43:	89 d8                	mov    %ebx,%eax
80105b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b48:	c9                   	leave  
80105b49:	c3                   	ret    
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b50 <sys_trace>:

int
sys_trace(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 08             	sub    $0x8,%esp
  return myproc()->timepiece;
80105b56:	e8 e5 de ff ff       	call   80103a40 <myproc>
80105b5b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80105b61:	c9                   	leave  
80105b62:	c3                   	ret    
80105b63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b70 <sys_releasesharem>:

int
sys_releasesharem(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 20             	sub    $0x20,%esp
  int idx;
  if(argint(0,&idx)<0)
80105b76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b79:	50                   	push   %eax
80105b7a:	6a 00                	push   $0x0
80105b7c:	e8 af f0 ff ff       	call   80104c30 <argint>
80105b81:	83 c4 10             	add    $0x10,%esp
80105b84:	85 c0                	test   %eax,%eax
80105b86:	78 18                	js     80105ba0 <sys_releasesharem+0x30>
    return -1;
  releaseshared(idx);
80105b88:	83 ec 0c             	sub    $0xc,%esp
80105b8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b8e:	e8 cd e0 ff ff       	call   80103c60 <releaseshared>
  return 0;
80105b93:	83 c4 10             	add    $0x10,%esp
80105b96:	31 c0                	xor    %eax,%eax
}
80105b98:	c9                   	leave  
80105b99:	c3                   	ret    
80105b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba5:	c9                   	leave  
80105ba6:	c3                   	ret    
80105ba7:	89 f6                	mov    %esi,%esi
80105ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bb0 <sys_getsharem>:

int
sys_getsharem(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	83 ec 20             	sub    $0x20,%esp
  int idx;
  if(argint(0,&idx)<0)
80105bb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bb9:	50                   	push   %eax
80105bba:	6a 00                	push   $0x0
80105bbc:	e8 6f f0 ff ff       	call   80104c30 <argint>
80105bc1:	83 c4 10             	add    $0x10,%esp
80105bc4:	85 c0                	test   %eax,%eax
80105bc6:	78 18                	js     80105be0 <sys_getsharem+0x30>
    return -1;
  return (int)getshared(idx);
80105bc8:	83 ec 0c             	sub    $0xc,%esp
80105bcb:	ff 75 f4             	pushl  -0xc(%ebp)
80105bce:	e8 dd e0 ff ff       	call   80103cb0 <getshared>
80105bd3:	83 c4 10             	add    $0x10,%esp
}
80105bd6:	c9                   	leave  
80105bd7:	c3                   	ret    
80105bd8:	90                   	nop
80105bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be5:	c9                   	leave  
80105be6:	c3                   	ret    
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bf0 <sys_split>:

int
sys_split(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 20             	sub    $0x20,%esp
  int d;
  if(argint(0,&d)<0)
80105bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bf9:	50                   	push   %eax
80105bfa:	6a 00                	push   $0x0
80105bfc:	e8 2f f0 ff ff       	call   80104c30 <argint>
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	85 c0                	test   %eax,%eax
80105c06:	78 18                	js     80105c20 <sys_split+0x30>
    return -1;
  return (int)splitw(d);
80105c08:	83 ec 0c             	sub    $0xc,%esp
80105c0b:	ff 75 f4             	pushl  -0xc(%ebp)
80105c0e:	e8 2d ae ff ff       	call   80100a40 <splitw>
80105c13:	83 c4 10             	add    $0x10,%esp
}
80105c16:	c9                   	leave  
80105c17:	c3                   	ret    
80105c18:	90                   	nop
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c25:	c9                   	leave  
80105c26:	c3                   	ret    

80105c27 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c27:	1e                   	push   %ds
  pushl %es
80105c28:	06                   	push   %es
  pushl %fs
80105c29:	0f a0                	push   %fs
  pushl %gs
80105c2b:	0f a8                	push   %gs
  pushal
80105c2d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c2e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c32:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c34:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c36:	54                   	push   %esp
  call trap
80105c37:	e8 c4 00 00 00       	call   80105d00 <trap>
  addl $4, %esp
80105c3c:	83 c4 04             	add    $0x4,%esp

80105c3f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c3f:	61                   	popa   
  popl %gs
80105c40:	0f a9                	pop    %gs
  popl %fs
80105c42:	0f a1                	pop    %fs
  popl %es
80105c44:	07                   	pop    %es
  popl %ds
80105c45:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c46:	83 c4 08             	add    $0x8,%esp
  iret
80105c49:	cf                   	iret   
80105c4a:	66 90                	xchg   %ax,%ax
80105c4c:	66 90                	xchg   %ax,%ax
80105c4e:	66 90                	xchg   %ax,%ax

80105c50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c50:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c51:	31 c0                	xor    %eax,%eax
{
80105c53:	89 e5                	mov    %esp,%ebp
80105c55:	83 ec 08             	sub    $0x8,%esp
80105c58:	90                   	nop
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c60:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105c67:	c7 04 c5 c2 70 11 80 	movl   $0x8e000008,-0x7fee8f3e(,%eax,8)
80105c6e:	08 00 00 8e 
80105c72:	66 89 14 c5 c0 70 11 	mov    %dx,-0x7fee8f40(,%eax,8)
80105c79:	80 
80105c7a:	c1 ea 10             	shr    $0x10,%edx
80105c7d:	66 89 14 c5 c6 70 11 	mov    %dx,-0x7fee8f3a(,%eax,8)
80105c84:	80 
  for(i = 0; i < 256; i++)
80105c85:	83 c0 01             	add    $0x1,%eax
80105c88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c8d:	75 d1                	jne    80105c60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c8f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105c94:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c97:	c7 05 c2 72 11 80 08 	movl   $0xef000008,0x801172c2
80105c9e:	00 00 ef 
  initlock(&tickslock, "time");
80105ca1:	68 ad 7d 10 80       	push   $0x80107dad
80105ca6:	68 80 70 11 80       	push   $0x80117080
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cab:	66 a3 c0 72 11 80    	mov    %ax,0x801172c0
80105cb1:	c1 e8 10             	shr    $0x10,%eax
80105cb4:	66 a3 c6 72 11 80    	mov    %ax,0x801172c6
  initlock(&tickslock, "time");
80105cba:	e8 01 ea ff ff       	call   801046c0 <initlock>
}
80105cbf:	83 c4 10             	add    $0x10,%esp
80105cc2:	c9                   	leave  
80105cc3:	c3                   	ret    
80105cc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105cd0 <idtinit>:

void
idtinit(void)
{
80105cd0:	55                   	push   %ebp
  pd[0] = size-1;
80105cd1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105cd6:	89 e5                	mov    %esp,%ebp
80105cd8:	83 ec 10             	sub    $0x10,%esp
80105cdb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cdf:	b8 c0 70 11 80       	mov    $0x801170c0,%eax
80105ce4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ce8:	c1 e8 10             	shr    $0x10,%eax
80105ceb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105cef:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105cf2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105cf5:	c9                   	leave  
80105cf6:	c3                   	ret    
80105cf7:	89 f6                	mov    %esi,%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	57                   	push   %edi
80105d04:	56                   	push   %esi
80105d05:	53                   	push   %ebx
80105d06:	83 ec 1c             	sub    $0x1c,%esp
80105d09:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105d0c:	8b 47 30             	mov    0x30(%edi),%eax
80105d0f:	83 f8 40             	cmp    $0x40,%eax
80105d12:	0f 84 f0 00 00 00    	je     80105e08 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d18:	83 e8 20             	sub    $0x20,%eax
80105d1b:	83 f8 1f             	cmp    $0x1f,%eax
80105d1e:	77 10                	ja     80105d30 <trap+0x30>
80105d20:	ff 24 85 54 7e 10 80 	jmp    *-0x7fef81ac(,%eax,4)
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d30:	e8 0b dd ff ff       	call   80103a40 <myproc>
80105d35:	85 c0                	test   %eax,%eax
80105d37:	8b 5f 38             	mov    0x38(%edi),%ebx
80105d3a:	0f 84 24 02 00 00    	je     80105f64 <trap+0x264>
80105d40:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105d44:	0f 84 1a 02 00 00    	je     80105f64 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d4a:	0f 20 d1             	mov    %cr2,%ecx
80105d4d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d50:	e8 cb dc ff ff       	call   80103a20 <cpuid>
80105d55:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d58:	8b 47 34             	mov    0x34(%edi),%eax
80105d5b:	8b 77 30             	mov    0x30(%edi),%esi
80105d5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105d61:	e8 da dc ff ff       	call   80103a40 <myproc>
80105d66:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d69:	e8 d2 dc ff ff       	call   80103a40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d6e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d71:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d74:	51                   	push   %ecx
80105d75:	53                   	push   %ebx
80105d76:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105d77:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d7a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d7d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d7e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d81:	52                   	push   %edx
80105d82:	ff 70 10             	pushl  0x10(%eax)
80105d85:	68 10 7e 10 80       	push   $0x80107e10
80105d8a:	e8 51 a9 ff ff       	call   801006e0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105d8f:	83 c4 20             	add    $0x20,%esp
80105d92:	e8 a9 dc ff ff       	call   80103a40 <myproc>
80105d97:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d9e:	e8 9d dc ff ff       	call   80103a40 <myproc>
80105da3:	85 c0                	test   %eax,%eax
80105da5:	74 1d                	je     80105dc4 <trap+0xc4>
80105da7:	e8 94 dc ff ff       	call   80103a40 <myproc>
80105dac:	8b 50 24             	mov    0x24(%eax),%edx
80105daf:	85 d2                	test   %edx,%edx
80105db1:	74 11                	je     80105dc4 <trap+0xc4>
80105db3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105db7:	83 e0 03             	and    $0x3,%eax
80105dba:	66 83 f8 03          	cmp    $0x3,%ax
80105dbe:	0f 84 5c 01 00 00    	je     80105f20 <trap+0x220>
    exit();

  //brand new
  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105dc4:	e8 77 dc ff ff       	call   80103a40 <myproc>
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	74 0b                	je     80105dd8 <trap+0xd8>
80105dcd:	e8 6e dc ff ff       	call   80103a40 <myproc>
80105dd2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105dd6:	74 68                	je     80105e40 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER && (--myproc()->timepiece)<=0)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd8:	e8 63 dc ff ff       	call   80103a40 <myproc>
80105ddd:	85 c0                	test   %eax,%eax
80105ddf:	74 19                	je     80105dfa <trap+0xfa>
80105de1:	e8 5a dc ff ff       	call   80103a40 <myproc>
80105de6:	8b 40 24             	mov    0x24(%eax),%eax
80105de9:	85 c0                	test   %eax,%eax
80105deb:	74 0d                	je     80105dfa <trap+0xfa>
80105ded:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105df1:	83 e0 03             	and    $0x3,%eax
80105df4:	66 83 f8 03          	cmp    $0x3,%ax
80105df8:	74 37                	je     80105e31 <trap+0x131>
    exit();
}
80105dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dfd:	5b                   	pop    %ebx
80105dfe:	5e                   	pop    %esi
80105dff:	5f                   	pop    %edi
80105e00:	5d                   	pop    %ebp
80105e01:	c3                   	ret    
80105e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105e08:	e8 33 dc ff ff       	call   80103a40 <myproc>
80105e0d:	8b 58 24             	mov    0x24(%eax),%ebx
80105e10:	85 db                	test   %ebx,%ebx
80105e12:	0f 85 f8 00 00 00    	jne    80105f10 <trap+0x210>
    myproc()->tf = tf;
80105e18:	e8 23 dc ff ff       	call   80103a40 <myproc>
80105e1d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105e20:	e8 fb ee ff ff       	call   80104d20 <syscall>
    if(myproc()->killed)
80105e25:	e8 16 dc ff ff       	call   80103a40 <myproc>
80105e2a:	8b 48 24             	mov    0x24(%eax),%ecx
80105e2d:	85 c9                	test   %ecx,%ecx
80105e2f:	74 c9                	je     80105dfa <trap+0xfa>
}
80105e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e34:	5b                   	pop    %ebx
80105e35:	5e                   	pop    %esi
80105e36:	5f                   	pop    %edi
80105e37:	5d                   	pop    %ebp
      exit();
80105e38:	e9 c3 e2 ff ff       	jmp    80104100 <exit>
80105e3d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105e40:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105e44:	75 92                	jne    80105dd8 <trap+0xd8>
     tf->trapno == T_IRQ0+IRQ_TIMER && (--myproc()->timepiece)<=0)
80105e46:	e8 f5 db ff ff       	call   80103a40 <myproc>
80105e4b:	83 a8 84 00 00 00 01 	subl   $0x1,0x84(%eax)
80105e52:	75 84                	jne    80105dd8 <trap+0xd8>
    yield();
80105e54:	e8 97 e3 ff ff       	call   801041f0 <yield>
80105e59:	e9 7a ff ff ff       	jmp    80105dd8 <trap+0xd8>
80105e5e:	66 90                	xchg   %ax,%ax
    if(cpuid() == 0){
80105e60:	e8 bb db ff ff       	call   80103a20 <cpuid>
80105e65:	85 c0                	test   %eax,%eax
80105e67:	0f 84 c3 00 00 00    	je     80105f30 <trap+0x230>
    lapiceoi();
80105e6d:	e8 1e cb ff ff       	call   80102990 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e72:	e8 c9 db ff ff       	call   80103a40 <myproc>
80105e77:	85 c0                	test   %eax,%eax
80105e79:	0f 85 28 ff ff ff    	jne    80105da7 <trap+0xa7>
80105e7f:	e9 40 ff ff ff       	jmp    80105dc4 <trap+0xc4>
80105e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e88:	e8 c3 c9 ff ff       	call   80102850 <kbdintr>
    lapiceoi();
80105e8d:	e8 fe ca ff ff       	call   80102990 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e92:	e8 a9 db ff ff       	call   80103a40 <myproc>
80105e97:	85 c0                	test   %eax,%eax
80105e99:	0f 85 08 ff ff ff    	jne    80105da7 <trap+0xa7>
80105e9f:	e9 20 ff ff ff       	jmp    80105dc4 <trap+0xc4>
80105ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ea8:	e8 53 02 00 00       	call   80106100 <uartintr>
    lapiceoi();
80105ead:	e8 de ca ff ff       	call   80102990 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eb2:	e8 89 db ff ff       	call   80103a40 <myproc>
80105eb7:	85 c0                	test   %eax,%eax
80105eb9:	0f 85 e8 fe ff ff    	jne    80105da7 <trap+0xa7>
80105ebf:	e9 00 ff ff ff       	jmp    80105dc4 <trap+0xc4>
80105ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ec8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105ecc:	8b 77 38             	mov    0x38(%edi),%esi
80105ecf:	e8 4c db ff ff       	call   80103a20 <cpuid>
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
80105ed6:	50                   	push   %eax
80105ed7:	68 b8 7d 10 80       	push   $0x80107db8
80105edc:	e8 ff a7 ff ff       	call   801006e0 <cprintf>
    lapiceoi();
80105ee1:	e8 aa ca ff ff       	call   80102990 <lapiceoi>
    break;
80105ee6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ee9:	e8 52 db ff ff       	call   80103a40 <myproc>
80105eee:	85 c0                	test   %eax,%eax
80105ef0:	0f 85 b1 fe ff ff    	jne    80105da7 <trap+0xa7>
80105ef6:	e9 c9 fe ff ff       	jmp    80105dc4 <trap+0xc4>
80105efb:	90                   	nop
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105f00:	e8 bb c3 ff ff       	call   801022c0 <ideintr>
80105f05:	e9 63 ff ff ff       	jmp    80105e6d <trap+0x16d>
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f10:	e8 eb e1 ff ff       	call   80104100 <exit>
80105f15:	e9 fe fe ff ff       	jmp    80105e18 <trap+0x118>
80105f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105f20:	e8 db e1 ff ff       	call   80104100 <exit>
80105f25:	e9 9a fe ff ff       	jmp    80105dc4 <trap+0xc4>
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f30:	83 ec 0c             	sub    $0xc,%esp
80105f33:	68 80 70 11 80       	push   $0x80117080
80105f38:	e8 73 e8 ff ff       	call   801047b0 <acquire>
      wakeup(&ticks);
80105f3d:	c7 04 24 c0 78 11 80 	movl   $0x801178c0,(%esp)
      ticks++;
80105f44:	83 05 c0 78 11 80 01 	addl   $0x1,0x801178c0
      wakeup(&ticks);
80105f4b:	e8 e0 e4 ff ff       	call   80104430 <wakeup>
      release(&tickslock);
80105f50:	c7 04 24 80 70 11 80 	movl   $0x80117080,(%esp)
80105f57:	e8 74 e9 ff ff       	call   801048d0 <release>
80105f5c:	83 c4 10             	add    $0x10,%esp
80105f5f:	e9 09 ff ff ff       	jmp    80105e6d <trap+0x16d>
80105f64:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f67:	e8 b4 da ff ff       	call   80103a20 <cpuid>
80105f6c:	83 ec 0c             	sub    $0xc,%esp
80105f6f:	56                   	push   %esi
80105f70:	53                   	push   %ebx
80105f71:	50                   	push   %eax
80105f72:	ff 77 30             	pushl  0x30(%edi)
80105f75:	68 dc 7d 10 80       	push   $0x80107ddc
80105f7a:	e8 61 a7 ff ff       	call   801006e0 <cprintf>
      panic("trap");
80105f7f:	83 c4 14             	add    $0x14,%esp
80105f82:	68 b2 7d 10 80       	push   $0x80107db2
80105f87:	e8 04 a4 ff ff       	call   80100390 <panic>
80105f8c:	66 90                	xchg   %ax,%ax
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f90:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80105f95:	55                   	push   %ebp
80105f96:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f98:	85 c0                	test   %eax,%eax
80105f9a:	74 1c                	je     80105fb8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fa1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fa2:	a8 01                	test   $0x1,%al
80105fa4:	74 12                	je     80105fb8 <uartgetc+0x28>
80105fa6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fac:	0f b6 c0             	movzbl %al,%eax
}
80105faf:	5d                   	pop    %ebp
80105fb0:	c3                   	ret    
80105fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fbd:	5d                   	pop    %ebp
80105fbe:	c3                   	ret    
80105fbf:	90                   	nop

80105fc0 <uartputc.part.0>:
uartputc(int c)
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	57                   	push   %edi
80105fc4:	56                   	push   %esi
80105fc5:	53                   	push   %ebx
80105fc6:	89 c7                	mov    %eax,%edi
80105fc8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fcd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105fd2:	83 ec 0c             	sub    $0xc,%esp
80105fd5:	eb 1b                	jmp    80105ff2 <uartputc.part.0+0x32>
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	6a 0a                	push   $0xa
80105fe5:	e8 c6 c9 ff ff       	call   801029b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fea:	83 c4 10             	add    $0x10,%esp
80105fed:	83 eb 01             	sub    $0x1,%ebx
80105ff0:	74 07                	je     80105ff9 <uartputc.part.0+0x39>
80105ff2:	89 f2                	mov    %esi,%edx
80105ff4:	ec                   	in     (%dx),%al
80105ff5:	a8 20                	test   $0x20,%al
80105ff7:	74 e7                	je     80105fe0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ff9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ffe:	89 f8                	mov    %edi,%eax
80106000:	ee                   	out    %al,(%dx)
}
80106001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106004:	5b                   	pop    %ebx
80106005:	5e                   	pop    %esi
80106006:	5f                   	pop    %edi
80106007:	5d                   	pop    %ebp
80106008:	c3                   	ret    
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106010 <uartinit>:
{
80106010:	55                   	push   %ebp
80106011:	31 c9                	xor    %ecx,%ecx
80106013:	89 c8                	mov    %ecx,%eax
80106015:	89 e5                	mov    %esp,%ebp
80106017:	57                   	push   %edi
80106018:	56                   	push   %esi
80106019:	53                   	push   %ebx
8010601a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010601f:	89 da                	mov    %ebx,%edx
80106021:	83 ec 0c             	sub    $0xc,%esp
80106024:	ee                   	out    %al,(%dx)
80106025:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010602a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010602f:	89 fa                	mov    %edi,%edx
80106031:	ee                   	out    %al,(%dx)
80106032:	b8 0c 00 00 00       	mov    $0xc,%eax
80106037:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010603c:	ee                   	out    %al,(%dx)
8010603d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106042:	89 c8                	mov    %ecx,%eax
80106044:	89 f2                	mov    %esi,%edx
80106046:	ee                   	out    %al,(%dx)
80106047:	b8 03 00 00 00       	mov    $0x3,%eax
8010604c:	89 fa                	mov    %edi,%edx
8010604e:	ee                   	out    %al,(%dx)
8010604f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106054:	89 c8                	mov    %ecx,%eax
80106056:	ee                   	out    %al,(%dx)
80106057:	b8 01 00 00 00       	mov    $0x1,%eax
8010605c:	89 f2                	mov    %esi,%edx
8010605e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010605f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106064:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106065:	3c ff                	cmp    $0xff,%al
80106067:	74 5a                	je     801060c3 <uartinit+0xb3>
  uart = 1;
80106069:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106070:	00 00 00 
80106073:	89 da                	mov    %ebx,%edx
80106075:	ec                   	in     (%dx),%al
80106076:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010607b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010607c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010607f:	bb d4 7e 10 80       	mov    $0x80107ed4,%ebx
  ioapicenable(IRQ_COM1, 0);
80106084:	6a 00                	push   $0x0
80106086:	6a 04                	push   $0x4
80106088:	e8 83 c4 ff ff       	call   80102510 <ioapicenable>
8010608d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106090:	b8 78 00 00 00       	mov    $0x78,%eax
80106095:	eb 13                	jmp    801060aa <uartinit+0x9a>
80106097:	89 f6                	mov    %esi,%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060a0:	83 c3 01             	add    $0x1,%ebx
801060a3:	0f be 03             	movsbl (%ebx),%eax
801060a6:	84 c0                	test   %al,%al
801060a8:	74 19                	je     801060c3 <uartinit+0xb3>
  if(!uart)
801060aa:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801060b0:	85 d2                	test   %edx,%edx
801060b2:	74 ec                	je     801060a0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801060b4:	83 c3 01             	add    $0x1,%ebx
801060b7:	e8 04 ff ff ff       	call   80105fc0 <uartputc.part.0>
801060bc:	0f be 03             	movsbl (%ebx),%eax
801060bf:	84 c0                	test   %al,%al
801060c1:	75 e7                	jne    801060aa <uartinit+0x9a>
}
801060c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060c6:	5b                   	pop    %ebx
801060c7:	5e                   	pop    %esi
801060c8:	5f                   	pop    %edi
801060c9:	5d                   	pop    %ebp
801060ca:	c3                   	ret    
801060cb:	90                   	nop
801060cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060d0 <uartputc>:
  if(!uart)
801060d0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801060d6:	55                   	push   %ebp
801060d7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060d9:	85 d2                	test   %edx,%edx
{
801060db:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801060de:	74 10                	je     801060f0 <uartputc+0x20>
}
801060e0:	5d                   	pop    %ebp
801060e1:	e9 da fe ff ff       	jmp    80105fc0 <uartputc.part.0>
801060e6:	8d 76 00             	lea    0x0(%esi),%esi
801060e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060f0:	5d                   	pop    %ebp
801060f1:	c3                   	ret    
801060f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106100 <uartintr>:

void
uartintr(void)
{
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106106:	68 90 5f 10 80       	push   $0x80105f90
8010610b:	e8 80 a7 ff ff       	call   80100890 <consoleintr>
}
80106110:	83 c4 10             	add    $0x10,%esp
80106113:	c9                   	leave  
80106114:	c3                   	ret    

80106115 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $0
80106117:	6a 00                	push   $0x0
  jmp alltraps
80106119:	e9 09 fb ff ff       	jmp    80105c27 <alltraps>

8010611e <vector1>:
.globl vector1
vector1:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $1
80106120:	6a 01                	push   $0x1
  jmp alltraps
80106122:	e9 00 fb ff ff       	jmp    80105c27 <alltraps>

80106127 <vector2>:
.globl vector2
vector2:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $2
80106129:	6a 02                	push   $0x2
  jmp alltraps
8010612b:	e9 f7 fa ff ff       	jmp    80105c27 <alltraps>

80106130 <vector3>:
.globl vector3
vector3:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $3
80106132:	6a 03                	push   $0x3
  jmp alltraps
80106134:	e9 ee fa ff ff       	jmp    80105c27 <alltraps>

80106139 <vector4>:
.globl vector4
vector4:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $4
8010613b:	6a 04                	push   $0x4
  jmp alltraps
8010613d:	e9 e5 fa ff ff       	jmp    80105c27 <alltraps>

80106142 <vector5>:
.globl vector5
vector5:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $5
80106144:	6a 05                	push   $0x5
  jmp alltraps
80106146:	e9 dc fa ff ff       	jmp    80105c27 <alltraps>

8010614b <vector6>:
.globl vector6
vector6:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $6
8010614d:	6a 06                	push   $0x6
  jmp alltraps
8010614f:	e9 d3 fa ff ff       	jmp    80105c27 <alltraps>

80106154 <vector7>:
.globl vector7
vector7:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $7
80106156:	6a 07                	push   $0x7
  jmp alltraps
80106158:	e9 ca fa ff ff       	jmp    80105c27 <alltraps>

8010615d <vector8>:
.globl vector8
vector8:
  pushl $8
8010615d:	6a 08                	push   $0x8
  jmp alltraps
8010615f:	e9 c3 fa ff ff       	jmp    80105c27 <alltraps>

80106164 <vector9>:
.globl vector9
vector9:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $9
80106166:	6a 09                	push   $0x9
  jmp alltraps
80106168:	e9 ba fa ff ff       	jmp    80105c27 <alltraps>

8010616d <vector10>:
.globl vector10
vector10:
  pushl $10
8010616d:	6a 0a                	push   $0xa
  jmp alltraps
8010616f:	e9 b3 fa ff ff       	jmp    80105c27 <alltraps>

80106174 <vector11>:
.globl vector11
vector11:
  pushl $11
80106174:	6a 0b                	push   $0xb
  jmp alltraps
80106176:	e9 ac fa ff ff       	jmp    80105c27 <alltraps>

8010617b <vector12>:
.globl vector12
vector12:
  pushl $12
8010617b:	6a 0c                	push   $0xc
  jmp alltraps
8010617d:	e9 a5 fa ff ff       	jmp    80105c27 <alltraps>

80106182 <vector13>:
.globl vector13
vector13:
  pushl $13
80106182:	6a 0d                	push   $0xd
  jmp alltraps
80106184:	e9 9e fa ff ff       	jmp    80105c27 <alltraps>

80106189 <vector14>:
.globl vector14
vector14:
  pushl $14
80106189:	6a 0e                	push   $0xe
  jmp alltraps
8010618b:	e9 97 fa ff ff       	jmp    80105c27 <alltraps>

80106190 <vector15>:
.globl vector15
vector15:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $15
80106192:	6a 0f                	push   $0xf
  jmp alltraps
80106194:	e9 8e fa ff ff       	jmp    80105c27 <alltraps>

80106199 <vector16>:
.globl vector16
vector16:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $16
8010619b:	6a 10                	push   $0x10
  jmp alltraps
8010619d:	e9 85 fa ff ff       	jmp    80105c27 <alltraps>

801061a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061a2:	6a 11                	push   $0x11
  jmp alltraps
801061a4:	e9 7e fa ff ff       	jmp    80105c27 <alltraps>

801061a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $18
801061ab:	6a 12                	push   $0x12
  jmp alltraps
801061ad:	e9 75 fa ff ff       	jmp    80105c27 <alltraps>

801061b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $19
801061b4:	6a 13                	push   $0x13
  jmp alltraps
801061b6:	e9 6c fa ff ff       	jmp    80105c27 <alltraps>

801061bb <vector20>:
.globl vector20
vector20:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $20
801061bd:	6a 14                	push   $0x14
  jmp alltraps
801061bf:	e9 63 fa ff ff       	jmp    80105c27 <alltraps>

801061c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $21
801061c6:	6a 15                	push   $0x15
  jmp alltraps
801061c8:	e9 5a fa ff ff       	jmp    80105c27 <alltraps>

801061cd <vector22>:
.globl vector22
vector22:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $22
801061cf:	6a 16                	push   $0x16
  jmp alltraps
801061d1:	e9 51 fa ff ff       	jmp    80105c27 <alltraps>

801061d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $23
801061d8:	6a 17                	push   $0x17
  jmp alltraps
801061da:	e9 48 fa ff ff       	jmp    80105c27 <alltraps>

801061df <vector24>:
.globl vector24
vector24:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $24
801061e1:	6a 18                	push   $0x18
  jmp alltraps
801061e3:	e9 3f fa ff ff       	jmp    80105c27 <alltraps>

801061e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $25
801061ea:	6a 19                	push   $0x19
  jmp alltraps
801061ec:	e9 36 fa ff ff       	jmp    80105c27 <alltraps>

801061f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $26
801061f3:	6a 1a                	push   $0x1a
  jmp alltraps
801061f5:	e9 2d fa ff ff       	jmp    80105c27 <alltraps>

801061fa <vector27>:
.globl vector27
vector27:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $27
801061fc:	6a 1b                	push   $0x1b
  jmp alltraps
801061fe:	e9 24 fa ff ff       	jmp    80105c27 <alltraps>

80106203 <vector28>:
.globl vector28
vector28:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $28
80106205:	6a 1c                	push   $0x1c
  jmp alltraps
80106207:	e9 1b fa ff ff       	jmp    80105c27 <alltraps>

8010620c <vector29>:
.globl vector29
vector29:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $29
8010620e:	6a 1d                	push   $0x1d
  jmp alltraps
80106210:	e9 12 fa ff ff       	jmp    80105c27 <alltraps>

80106215 <vector30>:
.globl vector30
vector30:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $30
80106217:	6a 1e                	push   $0x1e
  jmp alltraps
80106219:	e9 09 fa ff ff       	jmp    80105c27 <alltraps>

8010621e <vector31>:
.globl vector31
vector31:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $31
80106220:	6a 1f                	push   $0x1f
  jmp alltraps
80106222:	e9 00 fa ff ff       	jmp    80105c27 <alltraps>

80106227 <vector32>:
.globl vector32
vector32:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $32
80106229:	6a 20                	push   $0x20
  jmp alltraps
8010622b:	e9 f7 f9 ff ff       	jmp    80105c27 <alltraps>

80106230 <vector33>:
.globl vector33
vector33:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $33
80106232:	6a 21                	push   $0x21
  jmp alltraps
80106234:	e9 ee f9 ff ff       	jmp    80105c27 <alltraps>

80106239 <vector34>:
.globl vector34
vector34:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $34
8010623b:	6a 22                	push   $0x22
  jmp alltraps
8010623d:	e9 e5 f9 ff ff       	jmp    80105c27 <alltraps>

80106242 <vector35>:
.globl vector35
vector35:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $35
80106244:	6a 23                	push   $0x23
  jmp alltraps
80106246:	e9 dc f9 ff ff       	jmp    80105c27 <alltraps>

8010624b <vector36>:
.globl vector36
vector36:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $36
8010624d:	6a 24                	push   $0x24
  jmp alltraps
8010624f:	e9 d3 f9 ff ff       	jmp    80105c27 <alltraps>

80106254 <vector37>:
.globl vector37
vector37:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $37
80106256:	6a 25                	push   $0x25
  jmp alltraps
80106258:	e9 ca f9 ff ff       	jmp    80105c27 <alltraps>

8010625d <vector38>:
.globl vector38
vector38:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $38
8010625f:	6a 26                	push   $0x26
  jmp alltraps
80106261:	e9 c1 f9 ff ff       	jmp    80105c27 <alltraps>

80106266 <vector39>:
.globl vector39
vector39:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $39
80106268:	6a 27                	push   $0x27
  jmp alltraps
8010626a:	e9 b8 f9 ff ff       	jmp    80105c27 <alltraps>

8010626f <vector40>:
.globl vector40
vector40:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $40
80106271:	6a 28                	push   $0x28
  jmp alltraps
80106273:	e9 af f9 ff ff       	jmp    80105c27 <alltraps>

80106278 <vector41>:
.globl vector41
vector41:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $41
8010627a:	6a 29                	push   $0x29
  jmp alltraps
8010627c:	e9 a6 f9 ff ff       	jmp    80105c27 <alltraps>

80106281 <vector42>:
.globl vector42
vector42:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $42
80106283:	6a 2a                	push   $0x2a
  jmp alltraps
80106285:	e9 9d f9 ff ff       	jmp    80105c27 <alltraps>

8010628a <vector43>:
.globl vector43
vector43:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $43
8010628c:	6a 2b                	push   $0x2b
  jmp alltraps
8010628e:	e9 94 f9 ff ff       	jmp    80105c27 <alltraps>

80106293 <vector44>:
.globl vector44
vector44:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $44
80106295:	6a 2c                	push   $0x2c
  jmp alltraps
80106297:	e9 8b f9 ff ff       	jmp    80105c27 <alltraps>

8010629c <vector45>:
.globl vector45
vector45:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $45
8010629e:	6a 2d                	push   $0x2d
  jmp alltraps
801062a0:	e9 82 f9 ff ff       	jmp    80105c27 <alltraps>

801062a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $46
801062a7:	6a 2e                	push   $0x2e
  jmp alltraps
801062a9:	e9 79 f9 ff ff       	jmp    80105c27 <alltraps>

801062ae <vector47>:
.globl vector47
vector47:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $47
801062b0:	6a 2f                	push   $0x2f
  jmp alltraps
801062b2:	e9 70 f9 ff ff       	jmp    80105c27 <alltraps>

801062b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $48
801062b9:	6a 30                	push   $0x30
  jmp alltraps
801062bb:	e9 67 f9 ff ff       	jmp    80105c27 <alltraps>

801062c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $49
801062c2:	6a 31                	push   $0x31
  jmp alltraps
801062c4:	e9 5e f9 ff ff       	jmp    80105c27 <alltraps>

801062c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $50
801062cb:	6a 32                	push   $0x32
  jmp alltraps
801062cd:	e9 55 f9 ff ff       	jmp    80105c27 <alltraps>

801062d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $51
801062d4:	6a 33                	push   $0x33
  jmp alltraps
801062d6:	e9 4c f9 ff ff       	jmp    80105c27 <alltraps>

801062db <vector52>:
.globl vector52
vector52:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $52
801062dd:	6a 34                	push   $0x34
  jmp alltraps
801062df:	e9 43 f9 ff ff       	jmp    80105c27 <alltraps>

801062e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $53
801062e6:	6a 35                	push   $0x35
  jmp alltraps
801062e8:	e9 3a f9 ff ff       	jmp    80105c27 <alltraps>

801062ed <vector54>:
.globl vector54
vector54:
  pushl $0
801062ed:	6a 00                	push   $0x0
  pushl $54
801062ef:	6a 36                	push   $0x36
  jmp alltraps
801062f1:	e9 31 f9 ff ff       	jmp    80105c27 <alltraps>

801062f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $55
801062f8:	6a 37                	push   $0x37
  jmp alltraps
801062fa:	e9 28 f9 ff ff       	jmp    80105c27 <alltraps>

801062ff <vector56>:
.globl vector56
vector56:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $56
80106301:	6a 38                	push   $0x38
  jmp alltraps
80106303:	e9 1f f9 ff ff       	jmp    80105c27 <alltraps>

80106308 <vector57>:
.globl vector57
vector57:
  pushl $0
80106308:	6a 00                	push   $0x0
  pushl $57
8010630a:	6a 39                	push   $0x39
  jmp alltraps
8010630c:	e9 16 f9 ff ff       	jmp    80105c27 <alltraps>

80106311 <vector58>:
.globl vector58
vector58:
  pushl $0
80106311:	6a 00                	push   $0x0
  pushl $58
80106313:	6a 3a                	push   $0x3a
  jmp alltraps
80106315:	e9 0d f9 ff ff       	jmp    80105c27 <alltraps>

8010631a <vector59>:
.globl vector59
vector59:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $59
8010631c:	6a 3b                	push   $0x3b
  jmp alltraps
8010631e:	e9 04 f9 ff ff       	jmp    80105c27 <alltraps>

80106323 <vector60>:
.globl vector60
vector60:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $60
80106325:	6a 3c                	push   $0x3c
  jmp alltraps
80106327:	e9 fb f8 ff ff       	jmp    80105c27 <alltraps>

8010632c <vector61>:
.globl vector61
vector61:
  pushl $0
8010632c:	6a 00                	push   $0x0
  pushl $61
8010632e:	6a 3d                	push   $0x3d
  jmp alltraps
80106330:	e9 f2 f8 ff ff       	jmp    80105c27 <alltraps>

80106335 <vector62>:
.globl vector62
vector62:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $62
80106337:	6a 3e                	push   $0x3e
  jmp alltraps
80106339:	e9 e9 f8 ff ff       	jmp    80105c27 <alltraps>

8010633e <vector63>:
.globl vector63
vector63:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $63
80106340:	6a 3f                	push   $0x3f
  jmp alltraps
80106342:	e9 e0 f8 ff ff       	jmp    80105c27 <alltraps>

80106347 <vector64>:
.globl vector64
vector64:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $64
80106349:	6a 40                	push   $0x40
  jmp alltraps
8010634b:	e9 d7 f8 ff ff       	jmp    80105c27 <alltraps>

80106350 <vector65>:
.globl vector65
vector65:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $65
80106352:	6a 41                	push   $0x41
  jmp alltraps
80106354:	e9 ce f8 ff ff       	jmp    80105c27 <alltraps>

80106359 <vector66>:
.globl vector66
vector66:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $66
8010635b:	6a 42                	push   $0x42
  jmp alltraps
8010635d:	e9 c5 f8 ff ff       	jmp    80105c27 <alltraps>

80106362 <vector67>:
.globl vector67
vector67:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $67
80106364:	6a 43                	push   $0x43
  jmp alltraps
80106366:	e9 bc f8 ff ff       	jmp    80105c27 <alltraps>

8010636b <vector68>:
.globl vector68
vector68:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $68
8010636d:	6a 44                	push   $0x44
  jmp alltraps
8010636f:	e9 b3 f8 ff ff       	jmp    80105c27 <alltraps>

80106374 <vector69>:
.globl vector69
vector69:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $69
80106376:	6a 45                	push   $0x45
  jmp alltraps
80106378:	e9 aa f8 ff ff       	jmp    80105c27 <alltraps>

8010637d <vector70>:
.globl vector70
vector70:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $70
8010637f:	6a 46                	push   $0x46
  jmp alltraps
80106381:	e9 a1 f8 ff ff       	jmp    80105c27 <alltraps>

80106386 <vector71>:
.globl vector71
vector71:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $71
80106388:	6a 47                	push   $0x47
  jmp alltraps
8010638a:	e9 98 f8 ff ff       	jmp    80105c27 <alltraps>

8010638f <vector72>:
.globl vector72
vector72:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $72
80106391:	6a 48                	push   $0x48
  jmp alltraps
80106393:	e9 8f f8 ff ff       	jmp    80105c27 <alltraps>

80106398 <vector73>:
.globl vector73
vector73:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $73
8010639a:	6a 49                	push   $0x49
  jmp alltraps
8010639c:	e9 86 f8 ff ff       	jmp    80105c27 <alltraps>

801063a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $74
801063a3:	6a 4a                	push   $0x4a
  jmp alltraps
801063a5:	e9 7d f8 ff ff       	jmp    80105c27 <alltraps>

801063aa <vector75>:
.globl vector75
vector75:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $75
801063ac:	6a 4b                	push   $0x4b
  jmp alltraps
801063ae:	e9 74 f8 ff ff       	jmp    80105c27 <alltraps>

801063b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $76
801063b5:	6a 4c                	push   $0x4c
  jmp alltraps
801063b7:	e9 6b f8 ff ff       	jmp    80105c27 <alltraps>

801063bc <vector77>:
.globl vector77
vector77:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $77
801063be:	6a 4d                	push   $0x4d
  jmp alltraps
801063c0:	e9 62 f8 ff ff       	jmp    80105c27 <alltraps>

801063c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $78
801063c7:	6a 4e                	push   $0x4e
  jmp alltraps
801063c9:	e9 59 f8 ff ff       	jmp    80105c27 <alltraps>

801063ce <vector79>:
.globl vector79
vector79:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $79
801063d0:	6a 4f                	push   $0x4f
  jmp alltraps
801063d2:	e9 50 f8 ff ff       	jmp    80105c27 <alltraps>

801063d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $80
801063d9:	6a 50                	push   $0x50
  jmp alltraps
801063db:	e9 47 f8 ff ff       	jmp    80105c27 <alltraps>

801063e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $81
801063e2:	6a 51                	push   $0x51
  jmp alltraps
801063e4:	e9 3e f8 ff ff       	jmp    80105c27 <alltraps>

801063e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $82
801063eb:	6a 52                	push   $0x52
  jmp alltraps
801063ed:	e9 35 f8 ff ff       	jmp    80105c27 <alltraps>

801063f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $83
801063f4:	6a 53                	push   $0x53
  jmp alltraps
801063f6:	e9 2c f8 ff ff       	jmp    80105c27 <alltraps>

801063fb <vector84>:
.globl vector84
vector84:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $84
801063fd:	6a 54                	push   $0x54
  jmp alltraps
801063ff:	e9 23 f8 ff ff       	jmp    80105c27 <alltraps>

80106404 <vector85>:
.globl vector85
vector85:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $85
80106406:	6a 55                	push   $0x55
  jmp alltraps
80106408:	e9 1a f8 ff ff       	jmp    80105c27 <alltraps>

8010640d <vector86>:
.globl vector86
vector86:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $86
8010640f:	6a 56                	push   $0x56
  jmp alltraps
80106411:	e9 11 f8 ff ff       	jmp    80105c27 <alltraps>

80106416 <vector87>:
.globl vector87
vector87:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $87
80106418:	6a 57                	push   $0x57
  jmp alltraps
8010641a:	e9 08 f8 ff ff       	jmp    80105c27 <alltraps>

8010641f <vector88>:
.globl vector88
vector88:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $88
80106421:	6a 58                	push   $0x58
  jmp alltraps
80106423:	e9 ff f7 ff ff       	jmp    80105c27 <alltraps>

80106428 <vector89>:
.globl vector89
vector89:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $89
8010642a:	6a 59                	push   $0x59
  jmp alltraps
8010642c:	e9 f6 f7 ff ff       	jmp    80105c27 <alltraps>

80106431 <vector90>:
.globl vector90
vector90:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $90
80106433:	6a 5a                	push   $0x5a
  jmp alltraps
80106435:	e9 ed f7 ff ff       	jmp    80105c27 <alltraps>

8010643a <vector91>:
.globl vector91
vector91:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $91
8010643c:	6a 5b                	push   $0x5b
  jmp alltraps
8010643e:	e9 e4 f7 ff ff       	jmp    80105c27 <alltraps>

80106443 <vector92>:
.globl vector92
vector92:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $92
80106445:	6a 5c                	push   $0x5c
  jmp alltraps
80106447:	e9 db f7 ff ff       	jmp    80105c27 <alltraps>

8010644c <vector93>:
.globl vector93
vector93:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $93
8010644e:	6a 5d                	push   $0x5d
  jmp alltraps
80106450:	e9 d2 f7 ff ff       	jmp    80105c27 <alltraps>

80106455 <vector94>:
.globl vector94
vector94:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $94
80106457:	6a 5e                	push   $0x5e
  jmp alltraps
80106459:	e9 c9 f7 ff ff       	jmp    80105c27 <alltraps>

8010645e <vector95>:
.globl vector95
vector95:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $95
80106460:	6a 5f                	push   $0x5f
  jmp alltraps
80106462:	e9 c0 f7 ff ff       	jmp    80105c27 <alltraps>

80106467 <vector96>:
.globl vector96
vector96:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $96
80106469:	6a 60                	push   $0x60
  jmp alltraps
8010646b:	e9 b7 f7 ff ff       	jmp    80105c27 <alltraps>

80106470 <vector97>:
.globl vector97
vector97:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $97
80106472:	6a 61                	push   $0x61
  jmp alltraps
80106474:	e9 ae f7 ff ff       	jmp    80105c27 <alltraps>

80106479 <vector98>:
.globl vector98
vector98:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $98
8010647b:	6a 62                	push   $0x62
  jmp alltraps
8010647d:	e9 a5 f7 ff ff       	jmp    80105c27 <alltraps>

80106482 <vector99>:
.globl vector99
vector99:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $99
80106484:	6a 63                	push   $0x63
  jmp alltraps
80106486:	e9 9c f7 ff ff       	jmp    80105c27 <alltraps>

8010648b <vector100>:
.globl vector100
vector100:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $100
8010648d:	6a 64                	push   $0x64
  jmp alltraps
8010648f:	e9 93 f7 ff ff       	jmp    80105c27 <alltraps>

80106494 <vector101>:
.globl vector101
vector101:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $101
80106496:	6a 65                	push   $0x65
  jmp alltraps
80106498:	e9 8a f7 ff ff       	jmp    80105c27 <alltraps>

8010649d <vector102>:
.globl vector102
vector102:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $102
8010649f:	6a 66                	push   $0x66
  jmp alltraps
801064a1:	e9 81 f7 ff ff       	jmp    80105c27 <alltraps>

801064a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $103
801064a8:	6a 67                	push   $0x67
  jmp alltraps
801064aa:	e9 78 f7 ff ff       	jmp    80105c27 <alltraps>

801064af <vector104>:
.globl vector104
vector104:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $104
801064b1:	6a 68                	push   $0x68
  jmp alltraps
801064b3:	e9 6f f7 ff ff       	jmp    80105c27 <alltraps>

801064b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $105
801064ba:	6a 69                	push   $0x69
  jmp alltraps
801064bc:	e9 66 f7 ff ff       	jmp    80105c27 <alltraps>

801064c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $106
801064c3:	6a 6a                	push   $0x6a
  jmp alltraps
801064c5:	e9 5d f7 ff ff       	jmp    80105c27 <alltraps>

801064ca <vector107>:
.globl vector107
vector107:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $107
801064cc:	6a 6b                	push   $0x6b
  jmp alltraps
801064ce:	e9 54 f7 ff ff       	jmp    80105c27 <alltraps>

801064d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $108
801064d5:	6a 6c                	push   $0x6c
  jmp alltraps
801064d7:	e9 4b f7 ff ff       	jmp    80105c27 <alltraps>

801064dc <vector109>:
.globl vector109
vector109:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $109
801064de:	6a 6d                	push   $0x6d
  jmp alltraps
801064e0:	e9 42 f7 ff ff       	jmp    80105c27 <alltraps>

801064e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $110
801064e7:	6a 6e                	push   $0x6e
  jmp alltraps
801064e9:	e9 39 f7 ff ff       	jmp    80105c27 <alltraps>

801064ee <vector111>:
.globl vector111
vector111:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $111
801064f0:	6a 6f                	push   $0x6f
  jmp alltraps
801064f2:	e9 30 f7 ff ff       	jmp    80105c27 <alltraps>

801064f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $112
801064f9:	6a 70                	push   $0x70
  jmp alltraps
801064fb:	e9 27 f7 ff ff       	jmp    80105c27 <alltraps>

80106500 <vector113>:
.globl vector113
vector113:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $113
80106502:	6a 71                	push   $0x71
  jmp alltraps
80106504:	e9 1e f7 ff ff       	jmp    80105c27 <alltraps>

80106509 <vector114>:
.globl vector114
vector114:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $114
8010650b:	6a 72                	push   $0x72
  jmp alltraps
8010650d:	e9 15 f7 ff ff       	jmp    80105c27 <alltraps>

80106512 <vector115>:
.globl vector115
vector115:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $115
80106514:	6a 73                	push   $0x73
  jmp alltraps
80106516:	e9 0c f7 ff ff       	jmp    80105c27 <alltraps>

8010651b <vector116>:
.globl vector116
vector116:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $116
8010651d:	6a 74                	push   $0x74
  jmp alltraps
8010651f:	e9 03 f7 ff ff       	jmp    80105c27 <alltraps>

80106524 <vector117>:
.globl vector117
vector117:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $117
80106526:	6a 75                	push   $0x75
  jmp alltraps
80106528:	e9 fa f6 ff ff       	jmp    80105c27 <alltraps>

8010652d <vector118>:
.globl vector118
vector118:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $118
8010652f:	6a 76                	push   $0x76
  jmp alltraps
80106531:	e9 f1 f6 ff ff       	jmp    80105c27 <alltraps>

80106536 <vector119>:
.globl vector119
vector119:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $119
80106538:	6a 77                	push   $0x77
  jmp alltraps
8010653a:	e9 e8 f6 ff ff       	jmp    80105c27 <alltraps>

8010653f <vector120>:
.globl vector120
vector120:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $120
80106541:	6a 78                	push   $0x78
  jmp alltraps
80106543:	e9 df f6 ff ff       	jmp    80105c27 <alltraps>

80106548 <vector121>:
.globl vector121
vector121:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $121
8010654a:	6a 79                	push   $0x79
  jmp alltraps
8010654c:	e9 d6 f6 ff ff       	jmp    80105c27 <alltraps>

80106551 <vector122>:
.globl vector122
vector122:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $122
80106553:	6a 7a                	push   $0x7a
  jmp alltraps
80106555:	e9 cd f6 ff ff       	jmp    80105c27 <alltraps>

8010655a <vector123>:
.globl vector123
vector123:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $123
8010655c:	6a 7b                	push   $0x7b
  jmp alltraps
8010655e:	e9 c4 f6 ff ff       	jmp    80105c27 <alltraps>

80106563 <vector124>:
.globl vector124
vector124:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $124
80106565:	6a 7c                	push   $0x7c
  jmp alltraps
80106567:	e9 bb f6 ff ff       	jmp    80105c27 <alltraps>

8010656c <vector125>:
.globl vector125
vector125:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $125
8010656e:	6a 7d                	push   $0x7d
  jmp alltraps
80106570:	e9 b2 f6 ff ff       	jmp    80105c27 <alltraps>

80106575 <vector126>:
.globl vector126
vector126:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $126
80106577:	6a 7e                	push   $0x7e
  jmp alltraps
80106579:	e9 a9 f6 ff ff       	jmp    80105c27 <alltraps>

8010657e <vector127>:
.globl vector127
vector127:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $127
80106580:	6a 7f                	push   $0x7f
  jmp alltraps
80106582:	e9 a0 f6 ff ff       	jmp    80105c27 <alltraps>

80106587 <vector128>:
.globl vector128
vector128:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $128
80106589:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010658e:	e9 94 f6 ff ff       	jmp    80105c27 <alltraps>

80106593 <vector129>:
.globl vector129
vector129:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $129
80106595:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010659a:	e9 88 f6 ff ff       	jmp    80105c27 <alltraps>

8010659f <vector130>:
.globl vector130
vector130:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $130
801065a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065a6:	e9 7c f6 ff ff       	jmp    80105c27 <alltraps>

801065ab <vector131>:
.globl vector131
vector131:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $131
801065ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065b2:	e9 70 f6 ff ff       	jmp    80105c27 <alltraps>

801065b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $132
801065b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065be:	e9 64 f6 ff ff       	jmp    80105c27 <alltraps>

801065c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $133
801065c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065ca:	e9 58 f6 ff ff       	jmp    80105c27 <alltraps>

801065cf <vector134>:
.globl vector134
vector134:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $134
801065d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065d6:	e9 4c f6 ff ff       	jmp    80105c27 <alltraps>

801065db <vector135>:
.globl vector135
vector135:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $135
801065dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065e2:	e9 40 f6 ff ff       	jmp    80105c27 <alltraps>

801065e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $136
801065e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065ee:	e9 34 f6 ff ff       	jmp    80105c27 <alltraps>

801065f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $137
801065f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065fa:	e9 28 f6 ff ff       	jmp    80105c27 <alltraps>

801065ff <vector138>:
.globl vector138
vector138:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $138
80106601:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106606:	e9 1c f6 ff ff       	jmp    80105c27 <alltraps>

8010660b <vector139>:
.globl vector139
vector139:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $139
8010660d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106612:	e9 10 f6 ff ff       	jmp    80105c27 <alltraps>

80106617 <vector140>:
.globl vector140
vector140:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $140
80106619:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010661e:	e9 04 f6 ff ff       	jmp    80105c27 <alltraps>

80106623 <vector141>:
.globl vector141
vector141:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $141
80106625:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010662a:	e9 f8 f5 ff ff       	jmp    80105c27 <alltraps>

8010662f <vector142>:
.globl vector142
vector142:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $142
80106631:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106636:	e9 ec f5 ff ff       	jmp    80105c27 <alltraps>

8010663b <vector143>:
.globl vector143
vector143:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $143
8010663d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106642:	e9 e0 f5 ff ff       	jmp    80105c27 <alltraps>

80106647 <vector144>:
.globl vector144
vector144:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $144
80106649:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010664e:	e9 d4 f5 ff ff       	jmp    80105c27 <alltraps>

80106653 <vector145>:
.globl vector145
vector145:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $145
80106655:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010665a:	e9 c8 f5 ff ff       	jmp    80105c27 <alltraps>

8010665f <vector146>:
.globl vector146
vector146:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $146
80106661:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106666:	e9 bc f5 ff ff       	jmp    80105c27 <alltraps>

8010666b <vector147>:
.globl vector147
vector147:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $147
8010666d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106672:	e9 b0 f5 ff ff       	jmp    80105c27 <alltraps>

80106677 <vector148>:
.globl vector148
vector148:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $148
80106679:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010667e:	e9 a4 f5 ff ff       	jmp    80105c27 <alltraps>

80106683 <vector149>:
.globl vector149
vector149:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $149
80106685:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010668a:	e9 98 f5 ff ff       	jmp    80105c27 <alltraps>

8010668f <vector150>:
.globl vector150
vector150:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $150
80106691:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106696:	e9 8c f5 ff ff       	jmp    80105c27 <alltraps>

8010669b <vector151>:
.globl vector151
vector151:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $151
8010669d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066a2:	e9 80 f5 ff ff       	jmp    80105c27 <alltraps>

801066a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $152
801066a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066ae:	e9 74 f5 ff ff       	jmp    80105c27 <alltraps>

801066b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $153
801066b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066ba:	e9 68 f5 ff ff       	jmp    80105c27 <alltraps>

801066bf <vector154>:
.globl vector154
vector154:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $154
801066c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066c6:	e9 5c f5 ff ff       	jmp    80105c27 <alltraps>

801066cb <vector155>:
.globl vector155
vector155:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $155
801066cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066d2:	e9 50 f5 ff ff       	jmp    80105c27 <alltraps>

801066d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $156
801066d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066de:	e9 44 f5 ff ff       	jmp    80105c27 <alltraps>

801066e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $157
801066e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066ea:	e9 38 f5 ff ff       	jmp    80105c27 <alltraps>

801066ef <vector158>:
.globl vector158
vector158:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $158
801066f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066f6:	e9 2c f5 ff ff       	jmp    80105c27 <alltraps>

801066fb <vector159>:
.globl vector159
vector159:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $159
801066fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106702:	e9 20 f5 ff ff       	jmp    80105c27 <alltraps>

80106707 <vector160>:
.globl vector160
vector160:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $160
80106709:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010670e:	e9 14 f5 ff ff       	jmp    80105c27 <alltraps>

80106713 <vector161>:
.globl vector161
vector161:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $161
80106715:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010671a:	e9 08 f5 ff ff       	jmp    80105c27 <alltraps>

8010671f <vector162>:
.globl vector162
vector162:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $162
80106721:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106726:	e9 fc f4 ff ff       	jmp    80105c27 <alltraps>

8010672b <vector163>:
.globl vector163
vector163:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $163
8010672d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106732:	e9 f0 f4 ff ff       	jmp    80105c27 <alltraps>

80106737 <vector164>:
.globl vector164
vector164:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $164
80106739:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010673e:	e9 e4 f4 ff ff       	jmp    80105c27 <alltraps>

80106743 <vector165>:
.globl vector165
vector165:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $165
80106745:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010674a:	e9 d8 f4 ff ff       	jmp    80105c27 <alltraps>

8010674f <vector166>:
.globl vector166
vector166:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $166
80106751:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106756:	e9 cc f4 ff ff       	jmp    80105c27 <alltraps>

8010675b <vector167>:
.globl vector167
vector167:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $167
8010675d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106762:	e9 c0 f4 ff ff       	jmp    80105c27 <alltraps>

80106767 <vector168>:
.globl vector168
vector168:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $168
80106769:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010676e:	e9 b4 f4 ff ff       	jmp    80105c27 <alltraps>

80106773 <vector169>:
.globl vector169
vector169:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $169
80106775:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010677a:	e9 a8 f4 ff ff       	jmp    80105c27 <alltraps>

8010677f <vector170>:
.globl vector170
vector170:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $170
80106781:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106786:	e9 9c f4 ff ff       	jmp    80105c27 <alltraps>

8010678b <vector171>:
.globl vector171
vector171:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $171
8010678d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106792:	e9 90 f4 ff ff       	jmp    80105c27 <alltraps>

80106797 <vector172>:
.globl vector172
vector172:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $172
80106799:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010679e:	e9 84 f4 ff ff       	jmp    80105c27 <alltraps>

801067a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $173
801067a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067aa:	e9 78 f4 ff ff       	jmp    80105c27 <alltraps>

801067af <vector174>:
.globl vector174
vector174:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $174
801067b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067b6:	e9 6c f4 ff ff       	jmp    80105c27 <alltraps>

801067bb <vector175>:
.globl vector175
vector175:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $175
801067bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067c2:	e9 60 f4 ff ff       	jmp    80105c27 <alltraps>

801067c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $176
801067c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067ce:	e9 54 f4 ff ff       	jmp    80105c27 <alltraps>

801067d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $177
801067d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067da:	e9 48 f4 ff ff       	jmp    80105c27 <alltraps>

801067df <vector178>:
.globl vector178
vector178:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $178
801067e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067e6:	e9 3c f4 ff ff       	jmp    80105c27 <alltraps>

801067eb <vector179>:
.globl vector179
vector179:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $179
801067ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067f2:	e9 30 f4 ff ff       	jmp    80105c27 <alltraps>

801067f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $180
801067f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067fe:	e9 24 f4 ff ff       	jmp    80105c27 <alltraps>

80106803 <vector181>:
.globl vector181
vector181:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $181
80106805:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010680a:	e9 18 f4 ff ff       	jmp    80105c27 <alltraps>

8010680f <vector182>:
.globl vector182
vector182:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $182
80106811:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106816:	e9 0c f4 ff ff       	jmp    80105c27 <alltraps>

8010681b <vector183>:
.globl vector183
vector183:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $183
8010681d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106822:	e9 00 f4 ff ff       	jmp    80105c27 <alltraps>

80106827 <vector184>:
.globl vector184
vector184:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $184
80106829:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010682e:	e9 f4 f3 ff ff       	jmp    80105c27 <alltraps>

80106833 <vector185>:
.globl vector185
vector185:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $185
80106835:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010683a:	e9 e8 f3 ff ff       	jmp    80105c27 <alltraps>

8010683f <vector186>:
.globl vector186
vector186:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $186
80106841:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106846:	e9 dc f3 ff ff       	jmp    80105c27 <alltraps>

8010684b <vector187>:
.globl vector187
vector187:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $187
8010684d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106852:	e9 d0 f3 ff ff       	jmp    80105c27 <alltraps>

80106857 <vector188>:
.globl vector188
vector188:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $188
80106859:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010685e:	e9 c4 f3 ff ff       	jmp    80105c27 <alltraps>

80106863 <vector189>:
.globl vector189
vector189:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $189
80106865:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010686a:	e9 b8 f3 ff ff       	jmp    80105c27 <alltraps>

8010686f <vector190>:
.globl vector190
vector190:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $190
80106871:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106876:	e9 ac f3 ff ff       	jmp    80105c27 <alltraps>

8010687b <vector191>:
.globl vector191
vector191:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $191
8010687d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106882:	e9 a0 f3 ff ff       	jmp    80105c27 <alltraps>

80106887 <vector192>:
.globl vector192
vector192:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $192
80106889:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010688e:	e9 94 f3 ff ff       	jmp    80105c27 <alltraps>

80106893 <vector193>:
.globl vector193
vector193:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $193
80106895:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010689a:	e9 88 f3 ff ff       	jmp    80105c27 <alltraps>

8010689f <vector194>:
.globl vector194
vector194:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $194
801068a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068a6:	e9 7c f3 ff ff       	jmp    80105c27 <alltraps>

801068ab <vector195>:
.globl vector195
vector195:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $195
801068ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068b2:	e9 70 f3 ff ff       	jmp    80105c27 <alltraps>

801068b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $196
801068b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068be:	e9 64 f3 ff ff       	jmp    80105c27 <alltraps>

801068c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $197
801068c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068ca:	e9 58 f3 ff ff       	jmp    80105c27 <alltraps>

801068cf <vector198>:
.globl vector198
vector198:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $198
801068d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068d6:	e9 4c f3 ff ff       	jmp    80105c27 <alltraps>

801068db <vector199>:
.globl vector199
vector199:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $199
801068dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068e2:	e9 40 f3 ff ff       	jmp    80105c27 <alltraps>

801068e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $200
801068e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068ee:	e9 34 f3 ff ff       	jmp    80105c27 <alltraps>

801068f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $201
801068f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068fa:	e9 28 f3 ff ff       	jmp    80105c27 <alltraps>

801068ff <vector202>:
.globl vector202
vector202:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $202
80106901:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106906:	e9 1c f3 ff ff       	jmp    80105c27 <alltraps>

8010690b <vector203>:
.globl vector203
vector203:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $203
8010690d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106912:	e9 10 f3 ff ff       	jmp    80105c27 <alltraps>

80106917 <vector204>:
.globl vector204
vector204:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $204
80106919:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010691e:	e9 04 f3 ff ff       	jmp    80105c27 <alltraps>

80106923 <vector205>:
.globl vector205
vector205:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $205
80106925:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010692a:	e9 f8 f2 ff ff       	jmp    80105c27 <alltraps>

8010692f <vector206>:
.globl vector206
vector206:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $206
80106931:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106936:	e9 ec f2 ff ff       	jmp    80105c27 <alltraps>

8010693b <vector207>:
.globl vector207
vector207:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $207
8010693d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106942:	e9 e0 f2 ff ff       	jmp    80105c27 <alltraps>

80106947 <vector208>:
.globl vector208
vector208:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $208
80106949:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010694e:	e9 d4 f2 ff ff       	jmp    80105c27 <alltraps>

80106953 <vector209>:
.globl vector209
vector209:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $209
80106955:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010695a:	e9 c8 f2 ff ff       	jmp    80105c27 <alltraps>

8010695f <vector210>:
.globl vector210
vector210:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $210
80106961:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106966:	e9 bc f2 ff ff       	jmp    80105c27 <alltraps>

8010696b <vector211>:
.globl vector211
vector211:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $211
8010696d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106972:	e9 b0 f2 ff ff       	jmp    80105c27 <alltraps>

80106977 <vector212>:
.globl vector212
vector212:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $212
80106979:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010697e:	e9 a4 f2 ff ff       	jmp    80105c27 <alltraps>

80106983 <vector213>:
.globl vector213
vector213:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $213
80106985:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010698a:	e9 98 f2 ff ff       	jmp    80105c27 <alltraps>

8010698f <vector214>:
.globl vector214
vector214:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $214
80106991:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106996:	e9 8c f2 ff ff       	jmp    80105c27 <alltraps>

8010699b <vector215>:
.globl vector215
vector215:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $215
8010699d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069a2:	e9 80 f2 ff ff       	jmp    80105c27 <alltraps>

801069a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $216
801069a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069ae:	e9 74 f2 ff ff       	jmp    80105c27 <alltraps>

801069b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $217
801069b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069ba:	e9 68 f2 ff ff       	jmp    80105c27 <alltraps>

801069bf <vector218>:
.globl vector218
vector218:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $218
801069c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069c6:	e9 5c f2 ff ff       	jmp    80105c27 <alltraps>

801069cb <vector219>:
.globl vector219
vector219:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $219
801069cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069d2:	e9 50 f2 ff ff       	jmp    80105c27 <alltraps>

801069d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $220
801069d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069de:	e9 44 f2 ff ff       	jmp    80105c27 <alltraps>

801069e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $221
801069e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069ea:	e9 38 f2 ff ff       	jmp    80105c27 <alltraps>

801069ef <vector222>:
.globl vector222
vector222:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $222
801069f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069f6:	e9 2c f2 ff ff       	jmp    80105c27 <alltraps>

801069fb <vector223>:
.globl vector223
vector223:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $223
801069fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a02:	e9 20 f2 ff ff       	jmp    80105c27 <alltraps>

80106a07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $224
80106a09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a0e:	e9 14 f2 ff ff       	jmp    80105c27 <alltraps>

80106a13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $225
80106a15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a1a:	e9 08 f2 ff ff       	jmp    80105c27 <alltraps>

80106a1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $226
80106a21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a26:	e9 fc f1 ff ff       	jmp    80105c27 <alltraps>

80106a2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $227
80106a2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a32:	e9 f0 f1 ff ff       	jmp    80105c27 <alltraps>

80106a37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $228
80106a39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a3e:	e9 e4 f1 ff ff       	jmp    80105c27 <alltraps>

80106a43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $229
80106a45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a4a:	e9 d8 f1 ff ff       	jmp    80105c27 <alltraps>

80106a4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $230
80106a51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a56:	e9 cc f1 ff ff       	jmp    80105c27 <alltraps>

80106a5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $231
80106a5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a62:	e9 c0 f1 ff ff       	jmp    80105c27 <alltraps>

80106a67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $232
80106a69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a6e:	e9 b4 f1 ff ff       	jmp    80105c27 <alltraps>

80106a73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $233
80106a75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a7a:	e9 a8 f1 ff ff       	jmp    80105c27 <alltraps>

80106a7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $234
80106a81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a86:	e9 9c f1 ff ff       	jmp    80105c27 <alltraps>

80106a8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $235
80106a8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a92:	e9 90 f1 ff ff       	jmp    80105c27 <alltraps>

80106a97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $236
80106a99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a9e:	e9 84 f1 ff ff       	jmp    80105c27 <alltraps>

80106aa3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $237
80106aa5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106aaa:	e9 78 f1 ff ff       	jmp    80105c27 <alltraps>

80106aaf <vector238>:
.globl vector238
vector238:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $238
80106ab1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ab6:	e9 6c f1 ff ff       	jmp    80105c27 <alltraps>

80106abb <vector239>:
.globl vector239
vector239:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $239
80106abd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ac2:	e9 60 f1 ff ff       	jmp    80105c27 <alltraps>

80106ac7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $240
80106ac9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ace:	e9 54 f1 ff ff       	jmp    80105c27 <alltraps>

80106ad3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $241
80106ad5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106ada:	e9 48 f1 ff ff       	jmp    80105c27 <alltraps>

80106adf <vector242>:
.globl vector242
vector242:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $242
80106ae1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ae6:	e9 3c f1 ff ff       	jmp    80105c27 <alltraps>

80106aeb <vector243>:
.globl vector243
vector243:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $243
80106aed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106af2:	e9 30 f1 ff ff       	jmp    80105c27 <alltraps>

80106af7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $244
80106af9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106afe:	e9 24 f1 ff ff       	jmp    80105c27 <alltraps>

80106b03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $245
80106b05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b0a:	e9 18 f1 ff ff       	jmp    80105c27 <alltraps>

80106b0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $246
80106b11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b16:	e9 0c f1 ff ff       	jmp    80105c27 <alltraps>

80106b1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $247
80106b1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b22:	e9 00 f1 ff ff       	jmp    80105c27 <alltraps>

80106b27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $248
80106b29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b2e:	e9 f4 f0 ff ff       	jmp    80105c27 <alltraps>

80106b33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $249
80106b35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b3a:	e9 e8 f0 ff ff       	jmp    80105c27 <alltraps>

80106b3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $250
80106b41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b46:	e9 dc f0 ff ff       	jmp    80105c27 <alltraps>

80106b4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $251
80106b4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b52:	e9 d0 f0 ff ff       	jmp    80105c27 <alltraps>

80106b57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $252
80106b59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b5e:	e9 c4 f0 ff ff       	jmp    80105c27 <alltraps>

80106b63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $253
80106b65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b6a:	e9 b8 f0 ff ff       	jmp    80105c27 <alltraps>

80106b6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $254
80106b71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b76:	e9 ac f0 ff ff       	jmp    80105c27 <alltraps>

80106b7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $255
80106b7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b82:	e9 a0 f0 ff ff       	jmp    80105c27 <alltraps>
80106b87:	66 90                	xchg   %ax,%ax
80106b89:	66 90                	xchg   %ax,%ax
80106b8b:	66 90                	xchg   %ax,%ax
80106b8d:	66 90                	xchg   %ax,%ax
80106b8f:	90                   	nop

80106b90 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106b96:	89 d3                	mov    %edx,%ebx
{
80106b98:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106b9a:	c1 eb 16             	shr    $0x16,%ebx
80106b9d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ba0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ba3:	8b 06                	mov    (%esi),%eax
80106ba5:	a8 01                	test   $0x1,%al
80106ba7:	74 27                	je     80106bd0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ba9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106bb4:	c1 ef 0a             	shr    $0xa,%edi
}
80106bb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106bba:	89 fa                	mov    %edi,%edx
80106bbc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bc2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106bc5:	5b                   	pop    %ebx
80106bc6:	5e                   	pop    %esi
80106bc7:	5f                   	pop    %edi
80106bc8:	5d                   	pop    %ebp
80106bc9:	c3                   	ret    
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106bd0:	85 c9                	test   %ecx,%ecx
80106bd2:	74 2c                	je     80106c00 <walkpgdir+0x70>
80106bd4:	e8 27 bb ff ff       	call   80102700 <kalloc>
80106bd9:	85 c0                	test   %eax,%eax
80106bdb:	89 c3                	mov    %eax,%ebx
80106bdd:	74 21                	je     80106c00 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106bdf:	83 ec 04             	sub    $0x4,%esp
80106be2:	68 00 10 00 00       	push   $0x1000
80106be7:	6a 00                	push   $0x0
80106be9:	50                   	push   %eax
80106bea:	e8 41 dd ff ff       	call   80104930 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bf5:	83 c4 10             	add    $0x10,%esp
80106bf8:	83 c8 07             	or     $0x7,%eax
80106bfb:	89 06                	mov    %eax,(%esi)
80106bfd:	eb b5                	jmp    80106bb4 <walkpgdir+0x24>
80106bff:	90                   	nop
}
80106c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c03:	31 c0                	xor    %eax,%eax
}
80106c05:	5b                   	pop    %ebx
80106c06:	5e                   	pop    %esi
80106c07:	5f                   	pop    %edi
80106c08:	5d                   	pop    %ebp
80106c09:	c3                   	ret    
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c10 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
80106c15:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c16:	89 d3                	mov    %edx,%ebx
80106c18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c1e:	83 ec 1c             	sub    $0x1c,%esp
80106c21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c24:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c28:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c33:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c36:	29 df                	sub    %ebx,%edi
80106c38:	83 c8 01             	or     $0x1,%eax
80106c3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c3e:	eb 15                	jmp    80106c55 <mappages+0x45>
    if(*pte & PTE_P)
80106c40:	f6 00 01             	testb  $0x1,(%eax)
80106c43:	75 45                	jne    80106c8a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106c45:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106c48:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106c4b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c4d:	74 31                	je     80106c80 <mappages+0x70>
      break;
    a += PGSIZE;
80106c4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c58:	b9 01 00 00 00       	mov    $0x1,%ecx
80106c5d:	89 da                	mov    %ebx,%edx
80106c5f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106c62:	e8 29 ff ff ff       	call   80106b90 <walkpgdir>
80106c67:	85 c0                	test   %eax,%eax
80106c69:	75 d5                	jne    80106c40 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c73:	5b                   	pop    %ebx
80106c74:	5e                   	pop    %esi
80106c75:	5f                   	pop    %edi
80106c76:	5d                   	pop    %ebp
80106c77:	c3                   	ret    
80106c78:	90                   	nop
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c83:	31 c0                	xor    %eax,%eax
}
80106c85:	5b                   	pop    %ebx
80106c86:	5e                   	pop    %esi
80106c87:	5f                   	pop    %edi
80106c88:	5d                   	pop    %ebp
80106c89:	c3                   	ret    
      panic("remap");
80106c8a:	83 ec 0c             	sub    $0xc,%esp
80106c8d:	68 dc 7e 10 80       	push   $0x80107edc
80106c92:	e8 f9 96 ff ff       	call   80100390 <panic>
80106c97:	89 f6                	mov    %esi,%esi
80106c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ca0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ca6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cac:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106cae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cb4:	83 ec 1c             	sub    $0x1c,%esp
80106cb7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106cba:	39 d3                	cmp    %edx,%ebx
80106cbc:	73 66                	jae    80106d24 <deallocuvm.part.0+0x84>
80106cbe:	89 d6                	mov    %edx,%esi
80106cc0:	eb 3d                	jmp    80106cff <deallocuvm.part.0+0x5f>
80106cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106cc8:	8b 10                	mov    (%eax),%edx
80106cca:	f6 c2 01             	test   $0x1,%dl
80106ccd:	74 26                	je     80106cf5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106ccf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106cd5:	74 58                	je     80106d2f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106cd7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106cda:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106ce3:	52                   	push   %edx
80106ce4:	e8 67 b8 ff ff       	call   80102550 <kfree>
      *pte = 0;
80106ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cec:	83 c4 10             	add    $0x10,%esp
80106cef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106cf5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cfb:	39 f3                	cmp    %esi,%ebx
80106cfd:	73 25                	jae    80106d24 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106cff:	31 c9                	xor    %ecx,%ecx
80106d01:	89 da                	mov    %ebx,%edx
80106d03:	89 f8                	mov    %edi,%eax
80106d05:	e8 86 fe ff ff       	call   80106b90 <walkpgdir>
    if(!pte)
80106d0a:	85 c0                	test   %eax,%eax
80106d0c:	75 ba                	jne    80106cc8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d0e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106d14:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d20:	39 f3                	cmp    %esi,%ebx
80106d22:	72 db                	jb     80106cff <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d2a:	5b                   	pop    %ebx
80106d2b:	5e                   	pop    %esi
80106d2c:	5f                   	pop    %edi
80106d2d:	5d                   	pop    %ebp
80106d2e:	c3                   	ret    
        panic("kfree");
80106d2f:	83 ec 0c             	sub    $0xc,%esp
80106d32:	68 56 78 10 80       	push   $0x80107856
80106d37:	e8 54 96 ff ff       	call   80100390 <panic>
80106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d40 <seginit>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d46:	e8 d5 cc ff ff       	call   80103a20 <cpuid>
80106d4b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106d51:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d5a:	c7 80 f8 39 11 80 ff 	movl   $0xffff,-0x7feec608(%eax)
80106d61:	ff 00 00 
80106d64:	c7 80 fc 39 11 80 00 	movl   $0xcf9a00,-0x7feec604(%eax)
80106d6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d6e:	c7 80 00 3a 11 80 ff 	movl   $0xffff,-0x7feec600(%eax)
80106d75:	ff 00 00 
80106d78:	c7 80 04 3a 11 80 00 	movl   $0xcf9200,-0x7feec5fc(%eax)
80106d7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d82:	c7 80 08 3a 11 80 ff 	movl   $0xffff,-0x7feec5f8(%eax)
80106d89:	ff 00 00 
80106d8c:	c7 80 0c 3a 11 80 00 	movl   $0xcffa00,-0x7feec5f4(%eax)
80106d93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d96:	c7 80 10 3a 11 80 ff 	movl   $0xffff,-0x7feec5f0(%eax)
80106d9d:	ff 00 00 
80106da0:	c7 80 14 3a 11 80 00 	movl   $0xcff200,-0x7feec5ec(%eax)
80106da7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106daa:	05 f0 39 11 80       	add    $0x801139f0,%eax
  pd[1] = (uint)p;
80106daf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106db3:	c1 e8 10             	shr    $0x10,%eax
80106db6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106dbd:	0f 01 10             	lgdtl  (%eax)
}
80106dc0:	c9                   	leave  
80106dc1:	c3                   	ret    
80106dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dd0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd0:	a1 c4 78 11 80       	mov    0x801178c4,%eax
{
80106dd5:	55                   	push   %ebp
80106dd6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ddd:	0f 22 d8             	mov    %eax,%cr3
}
80106de0:	5d                   	pop    %ebp
80106de1:	c3                   	ret    
80106de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106df0 <switchuvm>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 1c             	sub    $0x1c,%esp
80106df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106dfc:	85 db                	test   %ebx,%ebx
80106dfe:	0f 84 cb 00 00 00    	je     80106ecf <switchuvm+0xdf>
  if(p->kstack == 0)
80106e04:	8b 43 08             	mov    0x8(%ebx),%eax
80106e07:	85 c0                	test   %eax,%eax
80106e09:	0f 84 da 00 00 00    	je     80106ee9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106e0f:	8b 43 04             	mov    0x4(%ebx),%eax
80106e12:	85 c0                	test   %eax,%eax
80106e14:	0f 84 c2 00 00 00    	je     80106edc <switchuvm+0xec>
  pushcli();
80106e1a:	e8 51 d9 ff ff       	call   80104770 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e1f:	e8 7c cb ff ff       	call   801039a0 <mycpu>
80106e24:	89 c6                	mov    %eax,%esi
80106e26:	e8 75 cb ff ff       	call   801039a0 <mycpu>
80106e2b:	89 c7                	mov    %eax,%edi
80106e2d:	e8 6e cb ff ff       	call   801039a0 <mycpu>
80106e32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e35:	83 c7 08             	add    $0x8,%edi
80106e38:	e8 63 cb ff ff       	call   801039a0 <mycpu>
80106e3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e40:	83 c0 08             	add    $0x8,%eax
80106e43:	ba 67 00 00 00       	mov    $0x67,%edx
80106e48:	c1 e8 18             	shr    $0x18,%eax
80106e4b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106e52:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106e59:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e5f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e64:	83 c1 08             	add    $0x8,%ecx
80106e67:	c1 e9 10             	shr    $0x10,%ecx
80106e6a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106e70:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e75:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e7c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106e81:	e8 1a cb ff ff       	call   801039a0 <mycpu>
80106e86:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e8d:	e8 0e cb ff ff       	call   801039a0 <mycpu>
80106e92:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e96:	8b 73 08             	mov    0x8(%ebx),%esi
80106e99:	e8 02 cb ff ff       	call   801039a0 <mycpu>
80106e9e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ea4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ea7:	e8 f4 ca ff ff       	call   801039a0 <mycpu>
80106eac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106eb0:	b8 28 00 00 00       	mov    $0x28,%eax
80106eb5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106eb8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ebb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ec0:	0f 22 d8             	mov    %eax,%cr3
}
80106ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ec6:	5b                   	pop    %ebx
80106ec7:	5e                   	pop    %esi
80106ec8:	5f                   	pop    %edi
80106ec9:	5d                   	pop    %ebp
  popcli();
80106eca:	e9 a1 d9 ff ff       	jmp    80104870 <popcli>
    panic("switchuvm: no process");
80106ecf:	83 ec 0c             	sub    $0xc,%esp
80106ed2:	68 e2 7e 10 80       	push   $0x80107ee2
80106ed7:	e8 b4 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106edc:	83 ec 0c             	sub    $0xc,%esp
80106edf:	68 0d 7f 10 80       	push   $0x80107f0d
80106ee4:	e8 a7 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106ee9:	83 ec 0c             	sub    $0xc,%esp
80106eec:	68 f8 7e 10 80       	push   $0x80107ef8
80106ef1:	e8 9a 94 ff ff       	call   80100390 <panic>
80106ef6:	8d 76 00             	lea    0x0(%esi),%esi
80106ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f00 <inituvm>:
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 1c             	sub    $0x1c,%esp
80106f09:	8b 75 10             	mov    0x10(%ebp),%esi
80106f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f0f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106f12:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106f18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f1b:	77 49                	ja     80106f66 <inituvm+0x66>
  mem = kalloc();
80106f1d:	e8 de b7 ff ff       	call   80102700 <kalloc>
  memset(mem, 0, PGSIZE);
80106f22:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106f25:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f27:	68 00 10 00 00       	push   $0x1000
80106f2c:	6a 00                	push   $0x0
80106f2e:	50                   	push   %eax
80106f2f:	e8 fc d9 ff ff       	call   80104930 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f34:	58                   	pop    %eax
80106f35:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f3b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f40:	5a                   	pop    %edx
80106f41:	6a 06                	push   $0x6
80106f43:	50                   	push   %eax
80106f44:	31 d2                	xor    %edx,%edx
80106f46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f49:	e8 c2 fc ff ff       	call   80106c10 <mappages>
  memmove(mem, init, sz);
80106f4e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f51:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f54:	83 c4 10             	add    $0x10,%esp
80106f57:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f5d:	5b                   	pop    %ebx
80106f5e:	5e                   	pop    %esi
80106f5f:	5f                   	pop    %edi
80106f60:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f61:	e9 7a da ff ff       	jmp    801049e0 <memmove>
    panic("inituvm: more than a page");
80106f66:	83 ec 0c             	sub    $0xc,%esp
80106f69:	68 21 7f 10 80       	push   $0x80107f21
80106f6e:	e8 1d 94 ff ff       	call   80100390 <panic>
80106f73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f80 <loaduvm>:
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
80106f86:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106f89:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106f90:	0f 85 91 00 00 00    	jne    80107027 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106f96:	8b 75 18             	mov    0x18(%ebp),%esi
80106f99:	31 db                	xor    %ebx,%ebx
80106f9b:	85 f6                	test   %esi,%esi
80106f9d:	75 1a                	jne    80106fb9 <loaduvm+0x39>
80106f9f:	eb 6f                	jmp    80107010 <loaduvm+0x90>
80106fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106fb4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106fb7:	76 57                	jbe    80107010 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80106fbf:	31 c9                	xor    %ecx,%ecx
80106fc1:	01 da                	add    %ebx,%edx
80106fc3:	e8 c8 fb ff ff       	call   80106b90 <walkpgdir>
80106fc8:	85 c0                	test   %eax,%eax
80106fca:	74 4e                	je     8010701a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106fcc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106fd1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106fd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106fdb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fe1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fe4:	01 d9                	add    %ebx,%ecx
80106fe6:	05 00 00 00 80       	add    $0x80000000,%eax
80106feb:	57                   	push   %edi
80106fec:	51                   	push   %ecx
80106fed:	50                   	push   %eax
80106fee:	ff 75 10             	pushl  0x10(%ebp)
80106ff1:	e8 aa ab ff ff       	call   80101ba0 <readi>
80106ff6:	83 c4 10             	add    $0x10,%esp
80106ff9:	39 f8                	cmp    %edi,%eax
80106ffb:	74 ab                	je     80106fa8 <loaduvm+0x28>
}
80106ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107005:	5b                   	pop    %ebx
80107006:	5e                   	pop    %esi
80107007:	5f                   	pop    %edi
80107008:	5d                   	pop    %ebp
80107009:	c3                   	ret    
8010700a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107010:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107013:	31 c0                	xor    %eax,%eax
}
80107015:	5b                   	pop    %ebx
80107016:	5e                   	pop    %esi
80107017:	5f                   	pop    %edi
80107018:	5d                   	pop    %ebp
80107019:	c3                   	ret    
      panic("loaduvm: address should exist");
8010701a:	83 ec 0c             	sub    $0xc,%esp
8010701d:	68 3b 7f 10 80       	push   $0x80107f3b
80107022:	e8 69 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107027:	83 ec 0c             	sub    $0xc,%esp
8010702a:	68 dc 7f 10 80       	push   $0x80107fdc
8010702f:	e8 5c 93 ff ff       	call   80100390 <panic>
80107034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010703a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107040 <sharevm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 1c             	sub    $0x1c,%esp
80107049:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010704c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010704f:	8b 55 10             	mov    0x10(%ebp),%edx
  if(sharedmemo.recs[idx]>0){
80107052:	8d 59 08             	lea    0x8(%ecx),%ebx
80107055:	8b 04 9d c8 b5 10 80 	mov    -0x7fef4a38(,%ebx,4),%eax
8010705c:	85 c0                	test   %eax,%eax
8010705e:	74 48                	je     801070a8 <sharevm+0x68>
    mem=sharedmemo.shared[idx];
80107060:	8b 34 8d c0 b5 10 80 	mov    -0x7fef4a40(,%ecx,4),%esi
  if(mappages(pgdir, (char*)(KERNBASE-(nshared+1)*PGSIZE), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107067:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010706d:	83 ec 08             	sub    $0x8,%esp
80107070:	f7 da                	neg    %edx
80107072:	6a 06                	push   $0x6
80107074:	c1 e2 0c             	shl    $0xc,%edx
80107077:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010707c:	50                   	push   %eax
8010707d:	81 c2 00 f0 ff 7f    	add    $0x7ffff000,%edx
80107083:	89 f8                	mov    %edi,%eax
80107085:	e8 86 fb ff ff       	call   80106c10 <mappages>
8010708a:	83 c4 10             	add    $0x10,%esp
8010708d:	85 c0                	test   %eax,%eax
8010708f:	78 5f                	js     801070f0 <sharevm+0xb0>
  sharedmemo.recs[idx]++;
80107091:	83 04 9d c8 b5 10 80 	addl   $0x1,-0x7fef4a38(,%ebx,4)
80107098:	01 
}
80107099:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709c:	5b                   	pop    %ebx
8010709d:	5e                   	pop    %esi
8010709e:	5f                   	pop    %edi
8010709f:	5d                   	pop    %ebp
801070a0:	c3                   	ret    
801070a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070a8:	89 55 e0             	mov    %edx,-0x20(%ebp)
801070ab:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    mem = kalloc();
801070ae:	e8 4d b6 ff ff       	call   80102700 <kalloc>
    if(mem == 0){
801070b3:	85 c0                	test   %eax,%eax
    mem = kalloc();
801070b5:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801070b7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
801070bd:	74 51                	je     80107110 <sharevm+0xd0>
    memset(mem, 0, PGSIZE);
801070bf:	83 ec 04             	sub    $0x4,%esp
801070c2:	89 55 e0             	mov    %edx,-0x20(%ebp)
801070c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801070c8:	68 00 10 00 00       	push   $0x1000
801070cd:	6a 00                	push   $0x0
801070cf:	50                   	push   %eax
801070d0:	e8 5b d8 ff ff       	call   80104930 <memset>
    sharedmemo.shared[idx]=mem;
801070d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070d8:	83 c4 10             	add    $0x10,%esp
801070db:	8b 55 e0             	mov    -0x20(%ebp),%edx
801070de:	89 34 8d c0 b5 10 80 	mov    %esi,-0x7fef4a40(,%ecx,4)
801070e5:	eb 80                	jmp    80107067 <sharevm+0x27>
801070e7:	89 f6                	mov    %esi,%esi
801070e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("allocuvm out of memory (2)\n");
801070f0:	83 ec 0c             	sub    $0xc,%esp
801070f3:	68 71 7f 10 80       	push   $0x80107f71
801070f8:	e8 e3 95 ff ff       	call   801006e0 <cprintf>
    kfree(mem);
801070fd:	89 75 08             	mov    %esi,0x8(%ebp)
80107100:	83 c4 10             	add    $0x10,%esp
}
80107103:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107106:	5b                   	pop    %ebx
80107107:	5e                   	pop    %esi
80107108:	5f                   	pop    %edi
80107109:	5d                   	pop    %ebp
    kfree(mem);
8010710a:	e9 41 b4 ff ff       	jmp    80102550 <kfree>
8010710f:	90                   	nop
      cprintf("allocuvm out of memory\n");
80107110:	c7 45 08 59 7f 10 80 	movl   $0x80107f59,0x8(%ebp)
}
80107117:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010711a:	5b                   	pop    %ebx
8010711b:	5e                   	pop    %esi
8010711c:	5f                   	pop    %edi
8010711d:	5d                   	pop    %ebp
      cprintf("allocuvm out of memory\n");
8010711e:	e9 bd 95 ff ff       	jmp    801006e0 <cprintf>
80107123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107130 <allocuvm>:
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	53                   	push   %ebx
80107136:	83 ec 0c             	sub    $0xc,%esp
  if(newsz >= KERNBASE-nshared*PGSIZE)
80107139:	8b 45 14             	mov    0x14(%ebp),%eax
{
8010713c:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE-nshared*PGSIZE)
8010713f:	f7 d8                	neg    %eax
80107141:	c1 e0 0c             	shl    $0xc,%eax
80107144:	05 00 00 00 80       	add    $0x80000000,%eax
80107149:	39 f8                	cmp    %edi,%eax
8010714b:	0f 86 7f 00 00 00    	jbe    801071d0 <allocuvm+0xa0>
  if(newsz < oldsz)
80107151:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107154:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107157:	72 79                	jb     801071d2 <allocuvm+0xa2>
  a = PGROUNDUP(oldsz);
80107159:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010715f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107165:	39 df                	cmp    %ebx,%edi
80107167:	77 42                	ja     801071ab <allocuvm+0x7b>
80107169:	eb 75                	jmp    801071e0 <allocuvm+0xb0>
8010716b:	90                   	nop
8010716c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107170:	83 ec 04             	sub    $0x4,%esp
80107173:	68 00 10 00 00       	push   $0x1000
80107178:	6a 00                	push   $0x0
8010717a:	50                   	push   %eax
8010717b:	e8 b0 d7 ff ff       	call   80104930 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107180:	58                   	pop    %eax
80107181:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107187:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010718c:	5a                   	pop    %edx
8010718d:	6a 06                	push   $0x6
8010718f:	50                   	push   %eax
80107190:	89 da                	mov    %ebx,%edx
80107192:	8b 45 08             	mov    0x8(%ebp),%eax
80107195:	e8 76 fa ff ff       	call   80106c10 <mappages>
8010719a:	83 c4 10             	add    $0x10,%esp
8010719d:	85 c0                	test   %eax,%eax
8010719f:	78 4f                	js     801071f0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801071a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071a7:	39 df                	cmp    %ebx,%edi
801071a9:	76 35                	jbe    801071e0 <allocuvm+0xb0>
    mem = kalloc();
801071ab:	e8 50 b5 ff ff       	call   80102700 <kalloc>
    if(mem == 0){
801071b0:	85 c0                	test   %eax,%eax
    mem = kalloc();
801071b2:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801071b4:	75 ba                	jne    80107170 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071b6:	83 ec 0c             	sub    $0xc,%esp
801071b9:	68 59 7f 10 80       	push   $0x80107f59
801071be:	e8 1d 95 ff ff       	call   801006e0 <cprintf>
  if(newsz >= oldsz)
801071c3:	83 c4 10             	add    $0x10,%esp
801071c6:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801071c9:	77 5d                	ja     80107228 <allocuvm+0xf8>
801071cb:	90                   	nop
801071cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
801071d0:	31 c0                	xor    %eax,%eax
}
801071d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071d5:	5b                   	pop    %ebx
801071d6:	5e                   	pop    %esi
801071d7:	5f                   	pop    %edi
801071d8:	5d                   	pop    %ebp
801071d9:	c3                   	ret    
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return newsz;
801071e3:	89 f8                	mov    %edi,%eax
}
801071e5:	5b                   	pop    %ebx
801071e6:	5e                   	pop    %esi
801071e7:	5f                   	pop    %edi
801071e8:	5d                   	pop    %ebp
801071e9:	c3                   	ret    
801071ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801071f0:	83 ec 0c             	sub    $0xc,%esp
801071f3:	68 71 7f 10 80       	push   $0x80107f71
801071f8:	e8 e3 94 ff ff       	call   801006e0 <cprintf>
  if(newsz >= oldsz)
801071fd:	83 c4 10             	add    $0x10,%esp
80107200:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107203:	76 0d                	jbe    80107212 <allocuvm+0xe2>
80107205:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107208:	8b 45 08             	mov    0x8(%ebp),%eax
8010720b:	89 fa                	mov    %edi,%edx
8010720d:	e8 8e fa ff ff       	call   80106ca0 <deallocuvm.part.0>
      kfree(mem);
80107212:	83 ec 0c             	sub    $0xc,%esp
80107215:	56                   	push   %esi
80107216:	e8 35 b3 ff ff       	call   80102550 <kfree>
      return 0;
8010721b:	83 c4 10             	add    $0x10,%esp
8010721e:	31 c0                	xor    %eax,%eax
80107220:	eb b0                	jmp    801071d2 <allocuvm+0xa2>
80107222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107228:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010722b:	8b 45 08             	mov    0x8(%ebp),%eax
8010722e:	89 fa                	mov    %edi,%edx
80107230:	e8 6b fa ff ff       	call   80106ca0 <deallocuvm.part.0>
      return 0;
80107235:	31 c0                	xor    %eax,%eax
80107237:	eb 99                	jmp    801071d2 <allocuvm+0xa2>
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107240 <deallocuvm>:
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	8b 55 0c             	mov    0xc(%ebp),%edx
80107246:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107249:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010724c:	39 d1                	cmp    %edx,%ecx
8010724e:	73 10                	jae    80107260 <deallocuvm+0x20>
}
80107250:	5d                   	pop    %ebp
80107251:	e9 4a fa ff ff       	jmp    80106ca0 <deallocuvm.part.0>
80107256:	8d 76 00             	lea    0x0(%esi),%esi
80107259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107260:	89 d0                	mov    %edx,%eax
80107262:	5d                   	pop    %ebp
80107263:	c3                   	ret    
80107264:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010726a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107270 <desharevm>:

void
desharevm(int idx)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(sharedmemo.recs[idx]<=0)
80107276:	8d 51 08             	lea    0x8(%ecx),%edx
80107279:	8b 04 95 c8 b5 10 80 	mov    -0x7fef4a38(,%edx,4),%eax
80107280:	85 c0                	test   %eax,%eax
80107282:	74 0e                	je     80107292 <desharevm+0x22>
    return;

  sharedmemo.recs[idx]--;
80107284:	83 e8 01             	sub    $0x1,%eax
  if(sharedmemo.recs[idx]<=0){
80107287:	85 c0                	test   %eax,%eax
  sharedmemo.recs[idx]--;
80107289:	89 04 95 c8 b5 10 80 	mov    %eax,-0x7fef4a38(,%edx,4)
  if(sharedmemo.recs[idx]<=0){
80107290:	74 06                	je     80107298 <desharevm+0x28>
    kfree(sharedmemo.shared[idx]);
  }
}
80107292:	5d                   	pop    %ebp
80107293:	c3                   	ret    
80107294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(sharedmemo.shared[idx]);
80107298:	8b 04 8d c0 b5 10 80 	mov    -0x7fef4a40(,%ecx,4),%eax
8010729f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801072a2:	5d                   	pop    %ebp
    kfree(sharedmemo.shared[idx]);
801072a3:	e9 a8 b2 ff ff       	jmp    80102550 <kfree>
801072a8:	90                   	nop
801072a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir,uint nshared)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	53                   	push   %ebx
801072b6:	83 ec 0c             	sub    $0xc,%esp
801072b9:	8b 75 08             	mov    0x8(%ebp),%esi
801072bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  uint i;

  if(pgdir == 0)
801072bf:	85 f6                	test   %esi,%esi
801072c1:	74 61                	je     80107324 <freevm+0x74>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE-nshared*PGSIZE, 0);
801072c3:	f7 d8                	neg    %eax
801072c5:	c1 e0 0c             	shl    $0xc,%eax
  if(newsz >= oldsz)
801072c8:	05 00 00 00 80       	add    $0x80000000,%eax
801072cd:	89 c2                	mov    %eax,%edx
801072cf:	75 48                	jne    80107319 <freevm+0x69>
801072d1:	89 f3                	mov    %esi,%ebx
801072d3:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072d9:	eb 0c                	jmp    801072e7 <freevm+0x37>
801072db:	90                   	nop
801072dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072e0:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
801072e3:	39 fb                	cmp    %edi,%ebx
801072e5:	74 23                	je     8010730a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072e7:	8b 03                	mov    (%ebx),%eax
801072e9:	a8 01                	test   $0x1,%al
801072eb:	74 f3                	je     801072e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072f2:	83 ec 0c             	sub    $0xc,%esp
801072f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072fd:	50                   	push   %eax
801072fe:	e8 4d b2 ff ff       	call   80102550 <kfree>
80107303:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107306:	39 fb                	cmp    %edi,%ebx
80107308:	75 dd                	jne    801072e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010730a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010730d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107310:	5b                   	pop    %ebx
80107311:	5e                   	pop    %esi
80107312:	5f                   	pop    %edi
80107313:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107314:	e9 37 b2 ff ff       	jmp    80102550 <kfree>
80107319:	31 c9                	xor    %ecx,%ecx
8010731b:	89 f0                	mov    %esi,%eax
8010731d:	e8 7e f9 ff ff       	call   80106ca0 <deallocuvm.part.0>
80107322:	eb ad                	jmp    801072d1 <freevm+0x21>
    panic("freevm: no pgdir");
80107324:	83 ec 0c             	sub    $0xc,%esp
80107327:	68 8d 7f 10 80       	push   $0x80107f8d
8010732c:	e8 5f 90 ff ff       	call   80100390 <panic>
80107331:	eb 0d                	jmp    80107340 <setupkvm>
80107333:	90                   	nop
80107334:	90                   	nop
80107335:	90                   	nop
80107336:	90                   	nop
80107337:	90                   	nop
80107338:	90                   	nop
80107339:	90                   	nop
8010733a:	90                   	nop
8010733b:	90                   	nop
8010733c:	90                   	nop
8010733d:	90                   	nop
8010733e:	90                   	nop
8010733f:	90                   	nop

80107340 <setupkvm>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	56                   	push   %esi
80107344:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107345:	e8 b6 b3 ff ff       	call   80102700 <kalloc>
8010734a:	85 c0                	test   %eax,%eax
8010734c:	89 c6                	mov    %eax,%esi
8010734e:	74 42                	je     80107392 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107350:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107353:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107358:	68 00 10 00 00       	push   $0x1000
8010735d:	6a 00                	push   $0x0
8010735f:	50                   	push   %eax
80107360:	e8 cb d5 ff ff       	call   80104930 <memset>
80107365:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107368:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010736b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010736e:	83 ec 08             	sub    $0x8,%esp
80107371:	8b 13                	mov    (%ebx),%edx
80107373:	ff 73 0c             	pushl  0xc(%ebx)
80107376:	50                   	push   %eax
80107377:	29 c1                	sub    %eax,%ecx
80107379:	89 f0                	mov    %esi,%eax
8010737b:	e8 90 f8 ff ff       	call   80106c10 <mappages>
80107380:	83 c4 10             	add    $0x10,%esp
80107383:	85 c0                	test   %eax,%eax
80107385:	78 19                	js     801073a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107387:	83 c3 10             	add    $0x10,%ebx
8010738a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107390:	75 d6                	jne    80107368 <setupkvm+0x28>
}
80107392:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107395:	89 f0                	mov    %esi,%eax
80107397:	5b                   	pop    %ebx
80107398:	5e                   	pop    %esi
80107399:	5d                   	pop    %ebp
8010739a:	c3                   	ret    
8010739b:	90                   	nop
8010739c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir,0);
801073a0:	83 ec 08             	sub    $0x8,%esp
801073a3:	6a 00                	push   $0x0
801073a5:	56                   	push   %esi
      return 0;
801073a6:	31 f6                	xor    %esi,%esi
      freevm(pgdir,0);
801073a8:	e8 03 ff ff ff       	call   801072b0 <freevm>
      return 0;
801073ad:	83 c4 10             	add    $0x10,%esp
}
801073b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073b3:	89 f0                	mov    %esi,%eax
801073b5:	5b                   	pop    %ebx
801073b6:	5e                   	pop    %esi
801073b7:	5d                   	pop    %ebp
801073b8:	c3                   	ret    
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073c0 <kvmalloc>:
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801073c6:	e8 75 ff ff ff       	call   80107340 <setupkvm>
801073cb:	a3 c4 78 11 80       	mov    %eax,0x801178c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073d0:	05 00 00 00 80       	add    $0x80000000,%eax
801073d5:	0f 22 d8             	mov    %eax,%cr3
}
801073d8:	c9                   	leave  
801073d9:	c3                   	ret    
801073da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801073e1:	31 c9                	xor    %ecx,%ecx
{
801073e3:	89 e5                	mov    %esp,%ebp
801073e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801073e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801073eb:	8b 45 08             	mov    0x8(%ebp),%eax
801073ee:	e8 9d f7 ff ff       	call   80106b90 <walkpgdir>
  if(pte == 0)
801073f3:	85 c0                	test   %eax,%eax
801073f5:	74 05                	je     801073fc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801073f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073fa:	c9                   	leave  
801073fb:	c3                   	ret    
    panic("clearpteu");
801073fc:	83 ec 0c             	sub    $0xc,%esp
801073ff:	68 9e 7f 10 80       	push   $0x80107f9e
80107404:	e8 87 8f ff ff       	call   80100390 <panic>
80107409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107410 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
80107415:	53                   	push   %ebx
80107416:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107419:	e8 22 ff ff ff       	call   80107340 <setupkvm>
8010741e:	85 c0                	test   %eax,%eax
80107420:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107423:	0f 84 a2 00 00 00    	je     801074cb <copyuvm+0xbb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107429:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010742c:	85 c9                	test   %ecx,%ecx
8010742e:	0f 84 97 00 00 00    	je     801074cb <copyuvm+0xbb>
80107434:	31 f6                	xor    %esi,%esi
80107436:	eb 4e                	jmp    80107486 <copyuvm+0x76>
80107438:	90                   	nop
80107439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107440:	83 ec 04             	sub    $0x4,%esp
80107443:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010744c:	68 00 10 00 00       	push   $0x1000
80107451:	57                   	push   %edi
80107452:	50                   	push   %eax
80107453:	e8 88 d5 ff ff       	call   801049e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107458:	58                   	pop    %eax
80107459:	5a                   	pop    %edx
8010745a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010745d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107460:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107465:	53                   	push   %ebx
80107466:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010746c:	52                   	push   %edx
8010746d:	89 f2                	mov    %esi,%edx
8010746f:	e8 9c f7 ff ff       	call   80106c10 <mappages>
80107474:	83 c4 10             	add    $0x10,%esp
80107477:	85 c0                	test   %eax,%eax
80107479:	78 39                	js     801074b4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010747b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107481:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107484:	76 45                	jbe    801074cb <copyuvm+0xbb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107486:	8b 45 08             	mov    0x8(%ebp),%eax
80107489:	31 c9                	xor    %ecx,%ecx
8010748b:	89 f2                	mov    %esi,%edx
8010748d:	e8 fe f6 ff ff       	call   80106b90 <walkpgdir>
80107492:	85 c0                	test   %eax,%eax
80107494:	74 40                	je     801074d6 <copyuvm+0xc6>
    if(!(*pte & PTE_P))
80107496:	8b 18                	mov    (%eax),%ebx
80107498:	f6 c3 01             	test   $0x1,%bl
8010749b:	74 46                	je     801074e3 <copyuvm+0xd3>
    pa = PTE_ADDR(*pte);
8010749d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010749f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801074a5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801074ab:	e8 50 b2 ff ff       	call   80102700 <kalloc>
801074b0:	85 c0                	test   %eax,%eax
801074b2:	75 8c                	jne    80107440 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d,0);
801074b4:	83 ec 08             	sub    $0x8,%esp
801074b7:	6a 00                	push   $0x0
801074b9:	ff 75 e0             	pushl  -0x20(%ebp)
801074bc:	e8 ef fd ff ff       	call   801072b0 <freevm>
  return 0;
801074c1:	83 c4 10             	add    $0x10,%esp
801074c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801074cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074d1:	5b                   	pop    %ebx
801074d2:	5e                   	pop    %esi
801074d3:	5f                   	pop    %edi
801074d4:	5d                   	pop    %ebp
801074d5:	c3                   	ret    
      panic("copyuvm: pte should exist");
801074d6:	83 ec 0c             	sub    $0xc,%esp
801074d9:	68 a8 7f 10 80       	push   $0x80107fa8
801074de:	e8 ad 8e ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
801074e3:	83 ec 0c             	sub    $0xc,%esp
801074e6:	68 c2 7f 10 80       	push   $0x80107fc2
801074eb:	e8 a0 8e ff ff       	call   80100390 <panic>

801074f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801074f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801074f1:	31 c9                	xor    %ecx,%ecx
{
801074f3:	89 e5                	mov    %esp,%ebp
801074f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801074f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801074fb:	8b 45 08             	mov    0x8(%ebp),%eax
801074fe:	e8 8d f6 ff ff       	call   80106b90 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107503:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107505:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107506:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107508:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010750d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107510:	05 00 00 00 80       	add    $0x80000000,%eax
80107515:	83 fa 05             	cmp    $0x5,%edx
80107518:	ba 00 00 00 00       	mov    $0x0,%edx
8010751d:	0f 45 c2             	cmovne %edx,%eax
}
80107520:	c3                   	ret    
80107521:	eb 0d                	jmp    80107530 <copyout>
80107523:	90                   	nop
80107524:	90                   	nop
80107525:	90                   	nop
80107526:	90                   	nop
80107527:	90                   	nop
80107528:	90                   	nop
80107529:	90                   	nop
8010752a:	90                   	nop
8010752b:	90                   	nop
8010752c:	90                   	nop
8010752d:	90                   	nop
8010752e:	90                   	nop
8010752f:	90                   	nop

80107530 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	57                   	push   %edi
80107534:	56                   	push   %esi
80107535:	53                   	push   %ebx
80107536:	83 ec 1c             	sub    $0x1c,%esp
80107539:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010753c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010753f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107542:	85 db                	test   %ebx,%ebx
80107544:	75 40                	jne    80107586 <copyout+0x56>
80107546:	eb 70                	jmp    801075b8 <copyout+0x88>
80107548:	90                   	nop
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107550:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107553:	89 f1                	mov    %esi,%ecx
80107555:	29 d1                	sub    %edx,%ecx
80107557:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010755d:	39 d9                	cmp    %ebx,%ecx
8010755f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107562:	29 f2                	sub    %esi,%edx
80107564:	83 ec 04             	sub    $0x4,%esp
80107567:	01 d0                	add    %edx,%eax
80107569:	51                   	push   %ecx
8010756a:	57                   	push   %edi
8010756b:	50                   	push   %eax
8010756c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010756f:	e8 6c d4 ff ff       	call   801049e0 <memmove>
    len -= n;
    buf += n;
80107574:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107577:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010757a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107580:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107582:	29 cb                	sub    %ecx,%ebx
80107584:	74 32                	je     801075b8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107586:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107588:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010758b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010758e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107594:	56                   	push   %esi
80107595:	ff 75 08             	pushl  0x8(%ebp)
80107598:	e8 53 ff ff ff       	call   801074f0 <uva2ka>
    if(pa0 == 0)
8010759d:	83 c4 10             	add    $0x10,%esp
801075a0:	85 c0                	test   %eax,%eax
801075a2:	75 ac                	jne    80107550 <copyout+0x20>
  }
  return 0;
}
801075a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075ac:	5b                   	pop    %ebx
801075ad:	5e                   	pop    %esi
801075ae:	5f                   	pop    %edi
801075af:	5d                   	pop    %ebp
801075b0:	c3                   	ret    
801075b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075bb:	31 c0                	xor    %eax,%eax
}
801075bd:	5b                   	pop    %ebx
801075be:	5e                   	pop    %esi
801075bf:	5f                   	pop    %edi
801075c0:	5d                   	pop    %ebp
801075c1:	c3                   	ret    
