
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc 10 b6 10 80       	mov    $0x8010b610,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 30 10 80       	mov    $0x801030a0,%eax
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
80100044:	bb 54 b6 10 80       	mov    $0x8010b654,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 75 10 80       	push   $0x80107560
80100051:	68 20 b6 10 80       	push   $0x8010b620
80100056:	e8 25 46 00 00       	call   80104680 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 6c fd 10 80 1c 	movl   $0x8010fd1c,0x8010fd6c
80100062:	fd 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 70 fd 10 80 1c 	movl   $0x8010fd1c,0x8010fd70
8010006c:	fd 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 1c fd 10 80       	mov    $0x8010fd1c,%edx
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
8010008b:	c7 43 50 1c fd 10 80 	movl   $0x8010fd1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 75 10 80       	push   $0x80107567
80100097:	50                   	push   %eax
80100098:	e8 d3 44 00 00       	call   80104570 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fd 10 80       	mov    0x8010fd70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 70 fd 10 80    	mov    %ebx,0x8010fd70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 1c fd 10 80       	cmp    $0x8010fd1c,%eax
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
801000df:	68 20 b6 10 80       	push   $0x8010b620
801000e4:	e8 87 46 00 00       	call   80104770 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fd 10 80    	mov    0x8010fd70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
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
80100120:	8b 1d 6c fd 10 80    	mov    0x8010fd6c,%ebx
80100126:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
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
8010015d:	68 20 b6 10 80       	push   $0x8010b620
80100162:	e8 29 47 00 00       	call   80104890 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 44 00 00       	call   801045b0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 21 00 00       	call   80102320 <iderw>
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
80100193:	68 6e 75 10 80       	push   $0x8010756e
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
801001ae:	e8 9d 44 00 00       	call   80104650 <holdingsleep>
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
801001c4:	e9 57 21 00 00       	jmp    80102320 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 75 10 80       	push   $0x8010757f
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
801001ef:	e8 5c 44 00 00       	call   80104650 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 44 00 00       	call   80104610 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010020b:	e8 60 45 00 00       	call   80104770 <acquire>
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
80100232:	a1 70 fd 10 80       	mov    0x8010fd70,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 1c fd 10 80 	movl   $0x8010fd1c,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 70 fd 10 80       	mov    0x8010fd70,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 70 fd 10 80    	mov    %ebx,0x8010fd70
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 20 b6 10 80 	movl   $0x8010b620,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 2f 46 00 00       	jmp    80104890 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 75 10 80       	push   $0x80107586
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
80100280:	e8 db 16 00 00       	call   80101960 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 df 44 00 00       	call   80104770 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 00 00 11 80    	mov    0x80110000,%edx
801002a7:	39 15 04 00 11 80    	cmp    %edx,0x80110004
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
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 00 00 11 80       	push   $0x80110000
801002c5:	e8 56 3f 00 00       	call   80104220 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 00 00 11 80    	mov    0x80110000,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 04 00 11 80    	cmp    0x80110004,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 20 37 00 00       	call   80103a00 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 9c 45 00 00       	call   80104890 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 15 00 00       	call   80101880 <ilock>
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
80100313:	a3 00 00 11 80       	mov    %eax,0x80110000
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 80 ff 10 80 	movsbl -0x7fef0080(%eax),%eax
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
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 3e 45 00 00       	call   80104890 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 15 00 00       	call   80101880 <ilock>
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
80100372:	89 15 00 00 11 80    	mov    %edx,0x80110000
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
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 25 00 00       	call   80102930 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 75 10 80       	push   $0x8010758d
801003b7:	e8 24 03 00 00       	call   801006e0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 1b 03 00 00       	call   801006e0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 07 7f 10 80 	movl   $0x80107f07,(%esp)
801003cc:	e8 0f 03 00 00       	call   801006e0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 c3 42 00 00       	call   801046a0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 75 10 80       	push   $0x801075a1
801003ed:	e8 ee 02 00 00       	call   801006e0 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
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
8010043a:	e8 11 5c 00 00       	call   80106050 <uartputc>
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
801004ac:	8b 3d 0c 00 11 80    	mov    0x8011000c,%edi
801004b2:	89 d8                	mov    %ebx,%eax
801004b4:	99                   	cltd   
801004b5:	f7 f9                	idiv   %ecx
801004b7:	8b 34 bd 38 80 10 80 	mov    -0x7fef7fc8(,%edi,4),%esi
801004be:	8b 04 bd 10 80 10 80 	mov    -0x7fef7ff0(,%edi,4),%eax
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
80100526:	e8 25 5b 00 00       	call   80106050 <uartputc>
8010052b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100532:	e8 19 5b 00 00       	call   80106050 <uartputc>
80100537:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010053e:	e8 0d 5b 00 00       	call   80106050 <uartputc>
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
80100560:	e8 3b 44 00 00       	call   801049a0 <memmove>
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
8010057d:	e8 6e 43 00 00       	call   801048f0 <memset>
80100582:	83 c4 10             	add    $0x10,%esp
80100585:	e9 5b ff ff ff       	jmp    801004e5 <consputc+0xd5>
    panic("pos under/overflow");
8010058a:	83 ec 0c             	sub    $0xc,%esp
8010058d:	68 a5 75 10 80       	push   $0x801075a5
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
801005ac:	8b 35 0c 00 11 80    	mov    0x8011000c,%esi
801005b2:	89 d8                	mov    %ebx,%eax
801005b4:	99                   	cltd   
801005b5:	f7 f9                	idiv   %ecx
801005b7:	3b 14 b5 10 80 10 80 	cmp    -0x7fef7ff0(,%esi,4),%edx
801005be:	0f 8d 0b ff ff ff    	jge    801004cf <consputc+0xbf>
        pos-=80-window.width[wdi];
801005c4:	2b 0c b5 38 80 10 80 	sub    -0x7fef7fc8(,%esi,4),%ecx
801005cb:	29 cb                	sub    %ecx,%ebx
801005cd:	e9 fd fe ff ff       	jmp    801004cf <consputc+0xbf>
    pos += 80 - pos%80+ window.left[wdi];
801005d2:	89 d8                	mov    %ebx,%eax
801005d4:	b9 50 00 00 00       	mov    $0x50,%ecx
801005d9:	99                   	cltd   
801005da:	f7 f9                	idiv   %ecx
801005dc:	89 c8                	mov    %ecx,%eax
801005de:	29 d0                	sub    %edx,%eax
801005e0:	8b 15 0c 00 11 80    	mov    0x8011000c,%edx
801005e6:	03 04 95 10 80 10 80 	add    -0x7fef7ff0(,%edx,4),%eax
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
80100631:	0f b6 92 e0 75 10 80 	movzbl -0x7fef8a20(%edx),%edx
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
8010068f:	e8 cc 12 00 00       	call   80101960 <iunlock>
  acquire(&cons.lock);
80100694:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010069b:	e8 d0 40 00 00       	call   80104770 <acquire>
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
801006c2:	68 20 a5 10 80       	push   $0x8010a520
801006c7:	e8 c4 41 00 00       	call   80104890 <release>
  ilock(ip);
801006cc:	58                   	pop    %eax
801006cd:	ff 75 08             	pushl  0x8(%ebp)
801006d0:	e8 ab 11 00 00       	call   80101880 <ilock>

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
801006e9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
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
8010079a:	68 20 a5 10 80       	push   $0x8010a520
8010079f:	e8 ec 40 00 00       	call   80104890 <release>
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
80100850:	ba b8 75 10 80       	mov    $0x801075b8,%edx
      for(; *s; s++)
80100855:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100858:	b8 28 00 00 00       	mov    $0x28,%eax
8010085d:	89 d3                	mov    %edx,%ebx
8010085f:	eb bf                	jmp    80100820 <cprintf+0x140>
80100861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
80100868:	83 ec 0c             	sub    $0xc,%esp
8010086b:	68 20 a5 10 80       	push   $0x8010a520
80100870:	e8 fb 3e 00 00       	call   80104770 <acquire>
80100875:	83 c4 10             	add    $0x10,%esp
80100878:	e9 7c fe ff ff       	jmp    801006f9 <cprintf+0x19>
    panic("null fmt");
8010087d:	83 ec 0c             	sub    $0xc,%esp
80100880:	68 bf 75 10 80       	push   $0x801075bf
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
8010089e:	68 20 a5 10 80       	push   $0x8010a520
801008a3:	e8 c8 3e 00 00       	call   80104770 <acquire>
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
801008d1:	a1 08 00 11 80       	mov    0x80110008,%eax
801008d6:	3b 05 04 00 11 80    	cmp    0x80110004,%eax
801008dc:	74 d2                	je     801008b0 <consoleintr+0x20>
        input.e--;
801008de:	83 e8 01             	sub    $0x1,%eax
801008e1:	a3 08 00 11 80       	mov    %eax,0x80110008
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
80100903:	68 20 a5 10 80       	push   $0x8010a520
80100908:	e8 83 3f 00 00       	call   80104890 <release>
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
80100929:	a1 08 00 11 80       	mov    0x80110008,%eax
8010092e:	89 c2                	mov    %eax,%edx
80100930:	2b 15 00 00 11 80    	sub    0x80110000,%edx
80100936:	83 fa 7f             	cmp    $0x7f,%edx
80100939:	0f 87 71 ff ff ff    	ja     801008b0 <consoleintr+0x20>
8010093f:	8d 50 01             	lea    0x1(%eax),%edx
80100942:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100945:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100948:	89 15 08 00 11 80    	mov    %edx,0x80110008
        c = (c == '\r') ? '\n' : c;
8010094e:	0f 84 cc 00 00 00    	je     80100a20 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
80100954:	89 f9                	mov    %edi,%ecx
80100956:	88 88 80 ff 10 80    	mov    %cl,-0x7fef0080(%eax)
        consputc(c);
8010095c:	89 f8                	mov    %edi,%eax
8010095e:	e8 ad fa ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100963:	83 ff 0a             	cmp    $0xa,%edi
80100966:	0f 84 c5 00 00 00    	je     80100a31 <consoleintr+0x1a1>
8010096c:	83 ff 04             	cmp    $0x4,%edi
8010096f:	0f 84 bc 00 00 00    	je     80100a31 <consoleintr+0x1a1>
80100975:	a1 00 00 11 80       	mov    0x80110000,%eax
8010097a:	83 e8 80             	sub    $0xffffff80,%eax
8010097d:	39 05 08 00 11 80    	cmp    %eax,0x80110008
80100983:	0f 85 27 ff ff ff    	jne    801008b0 <consoleintr+0x20>
          wakeup(&input.r);
80100989:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010098c:	a3 04 00 11 80       	mov    %eax,0x80110004
          wakeup(&input.r);
80100991:	68 00 00 11 80       	push   $0x80110000
80100996:	e8 55 3a 00 00       	call   801043f0 <wakeup>
8010099b:	83 c4 10             	add    $0x10,%esp
8010099e:	e9 0d ff ff ff       	jmp    801008b0 <consoleintr+0x20>
801009a3:	90                   	nop
801009a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
801009a8:	be 01 00 00 00       	mov    $0x1,%esi
801009ad:	e9 fe fe ff ff       	jmp    801008b0 <consoleintr+0x20>
801009b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
801009b8:	a1 08 00 11 80       	mov    0x80110008,%eax
801009bd:	39 05 04 00 11 80    	cmp    %eax,0x80110004
801009c3:	75 2b                	jne    801009f0 <consoleintr+0x160>
801009c5:	e9 e6 fe ff ff       	jmp    801008b0 <consoleintr+0x20>
801009ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801009d0:	a3 08 00 11 80       	mov    %eax,0x80110008
        consputc(BACKSPACE);
801009d5:	b8 00 01 00 00       	mov    $0x100,%eax
801009da:	e8 31 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
801009df:	a1 08 00 11 80       	mov    0x80110008,%eax
801009e4:	3b 05 04 00 11 80    	cmp    0x80110004,%eax
801009ea:	0f 84 c0 fe ff ff    	je     801008b0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009f0:	83 e8 01             	sub    $0x1,%eax
801009f3:	89 c2                	mov    %eax,%edx
801009f5:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801009f8:	80 ba 80 ff 10 80 0a 	cmpb   $0xa,-0x7fef0080(%edx)
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
80100a17:	e9 84 3a 00 00       	jmp    801044a0 <procdump>
80100a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100a20:	c6 80 80 ff 10 80 0a 	movb   $0xa,-0x7fef0080(%eax)
        consputc(c);
80100a27:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2c:	e8 df f9 ff ff       	call   80100410 <consputc>
80100a31:	a1 08 00 11 80       	mov    0x80110008,%eax
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
80100a4c:	e8 af 2f 00 00       	call   80103a00 <myproc>
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
80100a70:	8b 15 00 80 10 80    	mov    0x80108000,%edx
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
80100a9d:	8b 0c 95 08 80 10 80 	mov    -0x7fef7ff8(,%edx,4),%ecx
80100aa4:	89 c8                	mov    %ecx,%eax
80100aa6:	c1 e8 1f             	shr    $0x1f,%eax
80100aa9:	01 c8                	add    %ecx,%eax
80100aab:	d1 f8                	sar    %eax
80100aad:	89 04 95 08 80 10 80 	mov    %eax,-0x7fef7ff8(,%edx,4)
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
80100ad8:	80 b9 04 80 10 80 00 	cmpb   $0x0,-0x7fef7ffc(%ecx)
      new=(new+1)%MAXWINDOWS;
80100adf:	89 ca                	mov    %ecx,%edx
      if(window.used[new]==0)
80100ae1:	74 05                	je     80100ae8 <splitw+0xa8>
    for(i=0;i<MAXWINDOWS;i++)
80100ae3:	83 eb 01             	sub    $0x1,%ebx
80100ae6:	75 d8                	jne    80100ac0 <splitw+0x80>
    window.left[new]=window.left[idx]+window.width[idx];
80100ae8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80100aeb:	8b 04 b5 10 80 10 80 	mov    -0x7fef7ff0(,%esi,4),%eax
    cprintf("new left: %d\n", window.left[new]);
80100af2:	83 ec 08             	sub    $0x8,%esp
    window.top[new]=window.top[idx];
80100af5:	8b 0c b5 60 80 10 80 	mov    -0x7fef7fa0(,%esi,4),%ecx
    window.lastnew=new;
80100afc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    window.used[new]=1;
80100aff:	c6 82 04 80 10 80 01 	movb   $0x1,-0x7fef7ffc(%edx)
    window.lastnew=new;
80100b06:	89 15 00 80 10 80    	mov    %edx,0x80108000
    window.left[new]=window.left[idx]+window.width[idx];
80100b0c:	01 f8                	add    %edi,%eax
    window.width[new]=window.width[idx];
80100b0e:	89 3c 95 38 80 10 80 	mov    %edi,-0x7fef7fc8(,%edx,4)
    window.top[new]=window.top[idx];
80100b15:	89 0c 95 60 80 10 80 	mov    %ecx,-0x7fef7fa0(,%edx,4)
    window.height[new]=window.height[idx];
80100b1c:	8b 0c b5 88 80 10 80 	mov    -0x7fef7f78(,%esi,4),%ecx
    cprintf("new left: %d\n", window.left[new]);
80100b23:	50                   	push   %eax
80100b24:	68 c8 75 10 80       	push   $0x801075c8
    window.left[new]=window.left[idx]+window.width[idx];
80100b29:	89 04 95 10 80 10 80 	mov    %eax,-0x7fef7ff0(,%edx,4)
    window.height[new]=window.height[idx];
80100b30:	89 0c 95 88 80 10 80 	mov    %ecx,-0x7fef7f78(,%edx,4)
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
80100b56:	68 d6 75 10 80       	push   $0x801075d6
80100b5b:	68 20 a5 10 80       	push   $0x8010a520
80100b60:	e8 1b 3b 00 00       	call   80104680 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100b65:	58                   	pop    %eax
80100b66:	5a                   	pop    %edx
80100b67:	6a 00                	push   $0x0
80100b69:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100b6b:	c7 05 cc 09 11 80 80 	movl   $0x80100680,0x801109cc
80100b72:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100b75:	c7 05 c8 09 11 80 70 	movl   $0x80100270,0x801109c8
80100b7c:	02 10 80 
  cons.locking = 1;
80100b7f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100b86:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100b89:	e8 42 19 00 00       	call   801024d0 <ioapicenable>
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
80100bac:	e8 4f 2e 00 00       	call   80103a00 <myproc>
80100bb1:	89 c7                	mov    %eax,%edi

  begin_op();
80100bb3:	e8 e8 21 00 00       	call   80102da0 <begin_op>

  if((ip = namei(path)) == 0){
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff 75 08             	pushl  0x8(%ebp)
80100bbe:	e8 1d 15 00 00       	call   801020e0 <namei>
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
80100bd4:	e8 a7 0c 00 00       	call   80101880 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100bd9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100bdf:	6a 34                	push   $0x34
80100be1:	6a 00                	push   $0x0
80100be3:	50                   	push   %eax
80100be4:	53                   	push   %ebx
80100be5:	e8 76 0f 00 00       	call   80101b60 <readi>
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
80100bf6:	e8 15 0f 00 00       	call   80101b10 <iunlockput>
    end_op();
80100bfb:	e8 10 22 00 00       	call   80102e10 <end_op>
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
80100c1c:	e8 9f 66 00 00       	call   801072c0 <setupkvm>
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
80100c9c:	e8 0f 64 00 00       	call   801070b0 <allocuvm>
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
80100cce:	e8 2d 62 00 00       	call   80106f00 <loaduvm>
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
80100cfe:	e8 5d 0e 00 00       	call   80101b60 <readi>
80100d03:	83 c4 10             	add    $0x10,%esp
80100d06:	83 f8 20             	cmp    $0x20,%eax
80100d09:	0f 84 51 ff ff ff    	je     80100c60 <exec+0xc0>
80100d0f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d15:	8b 97 88 00 00 00    	mov    0x88(%edi),%edx
    freevm(pgdir,curproc->nshared);
80100d1b:	83 ec 08             	sub    $0x8,%esp
80100d1e:	52                   	push   %edx
80100d1f:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d25:	e8 06 65 00 00       	call   80107230 <freevm>
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
80100d54:	e8 b7 0d 00 00       	call   80101b10 <iunlockput>
  end_op();
80100d59:	e8 b2 20 00 00       	call   80102e10 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE,curproc->nshared)) == 0)
80100d5e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d64:	ff b7 88 00 00 00    	pushl  0x88(%edi)
80100d6a:	56                   	push   %esi
80100d6b:	50                   	push   %eax
80100d6c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d72:	e8 39 63 00 00       	call   801070b0 <allocuvm>
80100d77:	83 c4 20             	add    $0x20,%esp
80100d7a:	85 c0                	test   %eax,%eax
80100d7c:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d82:	75 40                	jne    80100dc4 <exec+0x224>
    freevm(pgdir,curproc->nshared);
80100d84:	83 ec 08             	sub    $0x8,%esp
80100d87:	ff b7 88 00 00 00    	pushl  0x88(%edi)
80100d8d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d93:	e8 98 64 00 00       	call   80107230 <freevm>
80100d98:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100da0:	e9 63 fe ff ff       	jmp    80100c08 <exec+0x68>
    end_op();
80100da5:	e8 66 20 00 00       	call   80102e10 <end_op>
    cprintf("exec: fail\n");
80100daa:	83 ec 0c             	sub    $0xc,%esp
80100dad:	68 f1 75 10 80       	push   $0x801075f1
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
80100dd8:	e8 83 65 00 00       	call   80107360 <clearpteu>
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
80100e23:	e8 e8 3c 00 00       	call   80104b10 <strlen>
80100e28:	f7 d0                	not    %eax
80100e2a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e2c:	58                   	pop    %eax
80100e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e30:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e33:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e36:	e8 d5 3c 00 00       	call   80104b10 <strlen>
80100e3b:	83 c0 01             	add    $0x1,%eax
80100e3e:	50                   	push   %eax
80100e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e42:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e45:	53                   	push   %ebx
80100e46:	56                   	push   %esi
80100e47:	e8 64 66 00 00       	call   801074b0 <copyout>
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
80100ea0:	e8 0b 66 00 00       	call   801074b0 <copyout>
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
80100edb:	e8 f0 3b 00 00       	call   80104ad0 <safestrcpy>
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
80100f09:	e8 62 5e 00 00       	call   80106d70 <switchuvm>
  freevm(oldpgdir,curproc->nshared);
80100f0e:	5a                   	pop    %edx
80100f0f:	59                   	pop    %ecx
80100f10:	ff b7 88 00 00 00    	pushl  0x88(%edi)
80100f16:	56                   	push   %esi
80100f17:	e8 14 63 00 00       	call   80107230 <freevm>
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
80100f56:	68 fd 75 10 80       	push   $0x801075fd
80100f5b:	68 20 00 11 80       	push   $0x80110020
80100f60:	e8 1b 37 00 00       	call   80104680 <initlock>
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
80100f74:	bb 54 00 11 80       	mov    $0x80110054,%ebx
{
80100f79:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f7c:	68 20 00 11 80       	push   $0x80110020
80100f81:	e8 ea 37 00 00       	call   80104770 <acquire>
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	eb 10                	jmp    80100f9b <filealloc+0x2b>
80100f8b:	90                   	nop
80100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f90:	83 c3 18             	add    $0x18,%ebx
80100f93:	81 fb b4 09 11 80    	cmp    $0x801109b4,%ebx
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
80100fac:	68 20 00 11 80       	push   $0x80110020
80100fb1:	e8 da 38 00 00       	call   80104890 <release>
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
80100fc5:	68 20 00 11 80       	push   $0x80110020
80100fca:	e8 c1 38 00 00       	call   80104890 <release>
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
80100fea:	68 20 00 11 80       	push   $0x80110020
80100fef:	e8 7c 37 00 00       	call   80104770 <acquire>
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
80101007:	68 20 00 11 80       	push   $0x80110020
8010100c:	e8 7f 38 00 00       	call   80104890 <release>
  return f;
}
80101011:	89 d8                	mov    %ebx,%eax
80101013:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101016:	c9                   	leave  
80101017:	c3                   	ret    
    panic("filedup");
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	68 04 76 10 80       	push   $0x80107604
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
8010103c:	68 20 00 11 80       	push   $0x80110020
80101041:	e8 2a 37 00 00       	call   80104770 <acquire>
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
8010105e:	c7 45 08 20 00 11 80 	movl   $0x80110020,0x8(%ebp)
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
8010106c:	e9 1f 38 00 00       	jmp    80104890 <release>
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
80101090:	68 20 00 11 80       	push   $0x80110020
  ff = *f;
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101098:	e8 f3 37 00 00       	call   80104890 <release>
  if(ff.type == FD_PIPE)
8010109d:	83 c4 10             	add    $0x10,%esp
801010a0:	83 ff 01             	cmp    $0x1,%edi
801010a3:	74 13                	je     801010b8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
801010a5:	83 ff 02             	cmp    $0x2,%edi
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
801010c1:	e8 8a 24 00 00       	call   80103550 <pipeclose>
801010c6:	83 c4 10             	add    $0x10,%esp
801010c9:	eb df                	jmp    801010aa <fileclose+0x7a>
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
801010d0:	e8 cb 1c 00 00       	call   80102da0 <begin_op>
    iput(ff.ip);
801010d5:	83 ec 0c             	sub    $0xc,%esp
801010d8:	ff 75 e0             	pushl  -0x20(%ebp)
801010db:	e8 d0 08 00 00       	call   801019b0 <iput>
    end_op();
801010e0:	83 c4 10             	add    $0x10,%esp
}
801010e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e6:	5b                   	pop    %ebx
801010e7:	5e                   	pop    %esi
801010e8:	5f                   	pop    %edi
801010e9:	5d                   	pop    %ebp
    end_op();
801010ea:	e9 21 1d 00 00       	jmp    80102e10 <end_op>
    panic("fileclose");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 0c 76 10 80       	push   $0x8010760c
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
8010110a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010110d:	75 31                	jne    80101140 <filestat+0x40>
    ilock(f->ip);
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	ff 73 10             	pushl  0x10(%ebx)
80101115:	e8 66 07 00 00       	call   80101880 <ilock>
    stati(f->ip, st);
8010111a:	58                   	pop    %eax
8010111b:	5a                   	pop    %edx
8010111c:	ff 75 0c             	pushl  0xc(%ebp)
8010111f:	ff 73 10             	pushl  0x10(%ebx)
80101122:	e8 09 0a 00 00       	call   80101b30 <stati>
    iunlock(f->ip);
80101127:	59                   	pop    %ecx
80101128:	ff 73 10             	pushl  0x10(%ebx)
8010112b:	e8 30 08 00 00       	call   80101960 <iunlock>
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
8010116f:	83 f8 02             	cmp    $0x2,%eax
80101172:	75 5b                	jne    801011cf <fileread+0x7f>
    ilock(f->ip);
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	ff 73 10             	pushl  0x10(%ebx)
8010117a:	e8 01 07 00 00       	call   80101880 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010117f:	57                   	push   %edi
80101180:	ff 73 14             	pushl  0x14(%ebx)
80101183:	56                   	push   %esi
80101184:	ff 73 10             	pushl  0x10(%ebx)
80101187:	e8 d4 09 00 00       	call   80101b60 <readi>
8010118c:	83 c4 20             	add    $0x20,%esp
8010118f:	85 c0                	test   %eax,%eax
80101191:	89 c6                	mov    %eax,%esi
80101193:	7e 03                	jle    80101198 <fileread+0x48>
      f->off += r;
80101195:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101198:	83 ec 0c             	sub    $0xc,%esp
8010119b:	ff 73 10             	pushl  0x10(%ebx)
8010119e:	e8 bd 07 00 00       	call   80101960 <iunlock>
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
801011bd:	e9 3e 25 00 00       	jmp    80103700 <piperead>
801011c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011cd:	eb d7                	jmp    801011a6 <fileread+0x56>
  panic("fileread");
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	68 16 76 10 80       	push   $0x80107616
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
801011fc:	0f 84 aa 00 00 00    	je     801012ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101202:	8b 06                	mov    (%esi),%eax
80101204:	83 f8 01             	cmp    $0x1,%eax
80101207:	0f 84 c3 00 00 00    	je     801012d0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010120d:	83 f8 02             	cmp    $0x2,%eax
80101210:	0f 85 d9 00 00 00    	jne    801012ef <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101219:	31 ff                	xor    %edi,%edi
    while(i < n){
8010121b:	85 c0                	test   %eax,%eax
8010121d:	7f 34                	jg     80101253 <filewrite+0x73>
8010121f:	e9 9c 00 00 00       	jmp    801012c0 <filewrite+0xe0>
80101224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101228:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010122b:	83 ec 0c             	sub    $0xc,%esp
8010122e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101231:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101234:	e8 27 07 00 00       	call   80101960 <iunlock>
      end_op();
80101239:	e8 d2 1b 00 00       	call   80102e10 <end_op>
8010123e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101241:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101244:	39 c3                	cmp    %eax,%ebx
80101246:	0f 85 96 00 00 00    	jne    801012e2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010124c:	01 df                	add    %ebx,%edi
    while(i < n){
8010124e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101251:	7e 6d                	jle    801012c0 <filewrite+0xe0>
      int n1 = n - i;
80101253:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101256:	b8 00 06 00 00       	mov    $0x600,%eax
8010125b:	29 fb                	sub    %edi,%ebx
8010125d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101263:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101266:	e8 35 1b 00 00       	call   80102da0 <begin_op>
      ilock(f->ip);
8010126b:	83 ec 0c             	sub    $0xc,%esp
8010126e:	ff 76 10             	pushl  0x10(%esi)
80101271:	e8 0a 06 00 00       	call   80101880 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101276:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101279:	53                   	push   %ebx
8010127a:	ff 76 14             	pushl  0x14(%esi)
8010127d:	01 f8                	add    %edi,%eax
8010127f:	50                   	push   %eax
80101280:	ff 76 10             	pushl  0x10(%esi)
80101283:	e8 d8 09 00 00       	call   80101c60 <writei>
80101288:	83 c4 20             	add    $0x20,%esp
8010128b:	85 c0                	test   %eax,%eax
8010128d:	7f 99                	jg     80101228 <filewrite+0x48>
      iunlock(f->ip);
8010128f:	83 ec 0c             	sub    $0xc,%esp
80101292:	ff 76 10             	pushl  0x10(%esi)
80101295:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101298:	e8 c3 06 00 00       	call   80101960 <iunlock>
      end_op();
8010129d:	e8 6e 1b 00 00       	call   80102e10 <end_op>
      if(r < 0)
801012a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801012a5:	83 c4 10             	add    $0x10,%esp
801012a8:	85 c0                	test   %eax,%eax
801012aa:	74 98                	je     80101244 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801012ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801012af:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801012b4:	89 f8                	mov    %edi,%eax
801012b6:	5b                   	pop    %ebx
801012b7:	5e                   	pop    %esi
801012b8:	5f                   	pop    %edi
801012b9:	5d                   	pop    %ebp
801012ba:	c3                   	ret    
801012bb:	90                   	nop
801012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801012c0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801012c3:	75 e7                	jne    801012ac <filewrite+0xcc>
}
801012c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c8:	89 f8                	mov    %edi,%eax
801012ca:	5b                   	pop    %ebx
801012cb:	5e                   	pop    %esi
801012cc:	5f                   	pop    %edi
801012cd:	5d                   	pop    %ebp
801012ce:	c3                   	ret    
801012cf:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801012d0:	8b 46 0c             	mov    0xc(%esi),%eax
801012d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d9:	5b                   	pop    %ebx
801012da:	5e                   	pop    %esi
801012db:	5f                   	pop    %edi
801012dc:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012dd:	e9 0e 23 00 00       	jmp    801035f0 <pipewrite>
        panic("short filewrite");
801012e2:	83 ec 0c             	sub    $0xc,%esp
801012e5:	68 1f 76 10 80       	push   $0x8010761f
801012ea:	e8 a1 f0 ff ff       	call   80100390 <panic>
  panic("filewrite");
801012ef:	83 ec 0c             	sub    $0xc,%esp
801012f2:	68 25 76 10 80       	push   $0x80107625
801012f7:	e8 94 f0 ff ff       	call   80100390 <panic>
801012fc:	66 90                	xchg   %ax,%ax
801012fe:	66 90                	xchg   %ax,%ax

80101300 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	57                   	push   %edi
80101304:	56                   	push   %esi
80101305:	53                   	push   %ebx
80101306:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101309:	8b 0d 20 0a 11 80    	mov    0x80110a20,%ecx
{
8010130f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101312:	85 c9                	test   %ecx,%ecx
80101314:	0f 84 87 00 00 00    	je     801013a1 <balloc+0xa1>
8010131a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101321:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101324:	83 ec 08             	sub    $0x8,%esp
80101327:	89 f0                	mov    %esi,%eax
80101329:	c1 f8 0c             	sar    $0xc,%eax
8010132c:	03 05 38 0a 11 80    	add    0x80110a38,%eax
80101332:	50                   	push   %eax
80101333:	ff 75 d8             	pushl  -0x28(%ebp)
80101336:	e8 95 ed ff ff       	call   801000d0 <bread>
8010133b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010133e:	a1 20 0a 11 80       	mov    0x80110a20,%eax
80101343:	83 c4 10             	add    $0x10,%esp
80101346:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101349:	31 c0                	xor    %eax,%eax
8010134b:	eb 2f                	jmp    8010137c <balloc+0x7c>
8010134d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101350:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101352:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101355:	bb 01 00 00 00       	mov    $0x1,%ebx
8010135a:	83 e1 07             	and    $0x7,%ecx
8010135d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010135f:	89 c1                	mov    %eax,%ecx
80101361:	c1 f9 03             	sar    $0x3,%ecx
80101364:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101369:	85 df                	test   %ebx,%edi
8010136b:	89 fa                	mov    %edi,%edx
8010136d:	74 41                	je     801013b0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010136f:	83 c0 01             	add    $0x1,%eax
80101372:	83 c6 01             	add    $0x1,%esi
80101375:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010137a:	74 05                	je     80101381 <balloc+0x81>
8010137c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010137f:	77 cf                	ja     80101350 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101381:	83 ec 0c             	sub    $0xc,%esp
80101384:	ff 75 e4             	pushl  -0x1c(%ebp)
80101387:	e8 54 ee ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010138c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101393:	83 c4 10             	add    $0x10,%esp
80101396:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101399:	39 05 20 0a 11 80    	cmp    %eax,0x80110a20
8010139f:	77 80                	ja     80101321 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801013a1:	83 ec 0c             	sub    $0xc,%esp
801013a4:	68 2f 76 10 80       	push   $0x8010762f
801013a9:	e8 e2 ef ff ff       	call   80100390 <panic>
801013ae:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801013b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801013b3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801013b6:	09 da                	or     %ebx,%edx
801013b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801013bc:	57                   	push   %edi
801013bd:	e8 ae 1b 00 00       	call   80102f70 <log_write>
        brelse(bp);
801013c2:	89 3c 24             	mov    %edi,(%esp)
801013c5:	e8 16 ee ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801013ca:	58                   	pop    %eax
801013cb:	5a                   	pop    %edx
801013cc:	56                   	push   %esi
801013cd:	ff 75 d8             	pushl  -0x28(%ebp)
801013d0:	e8 fb ec ff ff       	call   801000d0 <bread>
801013d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801013d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013da:	83 c4 0c             	add    $0xc,%esp
801013dd:	68 00 02 00 00       	push   $0x200
801013e2:	6a 00                	push   $0x0
801013e4:	50                   	push   %eax
801013e5:	e8 06 35 00 00       	call   801048f0 <memset>
  log_write(bp);
801013ea:	89 1c 24             	mov    %ebx,(%esp)
801013ed:	e8 7e 1b 00 00       	call   80102f70 <log_write>
  brelse(bp);
801013f2:	89 1c 24             	mov    %ebx,(%esp)
801013f5:	e8 e6 ed ff ff       	call   801001e0 <brelse>
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013fd:	89 f0                	mov    %esi,%eax
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5f                   	pop    %edi
80101402:	5d                   	pop    %ebp
80101403:	c3                   	ret    
80101404:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010140a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101410 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	56                   	push   %esi
80101415:	53                   	push   %ebx
80101416:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101418:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010141a:	bb 74 0a 11 80       	mov    $0x80110a74,%ebx
{
8010141f:	83 ec 28             	sub    $0x28,%esp
80101422:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101425:	68 40 0a 11 80       	push   $0x80110a40
8010142a:	e8 41 33 00 00       	call   80104770 <acquire>
8010142f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101432:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101435:	eb 17                	jmp    8010144e <iget+0x3e>
80101437:	89 f6                	mov    %esi,%esi
80101439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101440:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101446:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
8010144c:	73 22                	jae    80101470 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010144e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101451:	85 c9                	test   %ecx,%ecx
80101453:	7e 04                	jle    80101459 <iget+0x49>
80101455:	39 3b                	cmp    %edi,(%ebx)
80101457:	74 4f                	je     801014a8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101459:	85 f6                	test   %esi,%esi
8010145b:	75 e3                	jne    80101440 <iget+0x30>
8010145d:	85 c9                	test   %ecx,%ecx
8010145f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101462:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101468:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
8010146e:	72 de                	jb     8010144e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101470:	85 f6                	test   %esi,%esi
80101472:	74 5b                	je     801014cf <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101474:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101477:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101479:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010147c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101483:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010148a:	68 40 0a 11 80       	push   $0x80110a40
8010148f:	e8 fc 33 00 00       	call   80104890 <release>

  return ip;
80101494:	83 c4 10             	add    $0x10,%esp
}
80101497:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010149a:	89 f0                	mov    %esi,%eax
8010149c:	5b                   	pop    %ebx
8010149d:	5e                   	pop    %esi
8010149e:	5f                   	pop    %edi
8010149f:	5d                   	pop    %ebp
801014a0:	c3                   	ret    
801014a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014a8:	39 53 04             	cmp    %edx,0x4(%ebx)
801014ab:	75 ac                	jne    80101459 <iget+0x49>
      release(&icache.lock);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801014b0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801014b3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801014b5:	68 40 0a 11 80       	push   $0x80110a40
      ip->ref++;
801014ba:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801014bd:	e8 ce 33 00 00       	call   80104890 <release>
      return ip;
801014c2:	83 c4 10             	add    $0x10,%esp
}
801014c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c8:	89 f0                	mov    %esi,%eax
801014ca:	5b                   	pop    %ebx
801014cb:	5e                   	pop    %esi
801014cc:	5f                   	pop    %edi
801014cd:	5d                   	pop    %ebp
801014ce:	c3                   	ret    
    panic("iget: no inodes");
801014cf:	83 ec 0c             	sub    $0xc,%esp
801014d2:	68 45 76 10 80       	push   $0x80107645
801014d7:	e8 b4 ee ff ff       	call   80100390 <panic>
801014dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	53                   	push   %ebx
801014e6:	89 c6                	mov    %eax,%esi
801014e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014eb:	83 fa 0b             	cmp    $0xb,%edx
801014ee:	77 18                	ja     80101508 <bmap+0x28>
801014f0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801014f3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014f6:	85 db                	test   %ebx,%ebx
801014f8:	74 76                	je     80101570 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801014fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014fd:	89 d8                	mov    %ebx,%eax
801014ff:	5b                   	pop    %ebx
80101500:	5e                   	pop    %esi
80101501:	5f                   	pop    %edi
80101502:	5d                   	pop    %ebp
80101503:	c3                   	ret    
80101504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101508:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010150b:	83 fb 7f             	cmp    $0x7f,%ebx
8010150e:	0f 87 90 00 00 00    	ja     801015a4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101514:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010151a:	8b 00                	mov    (%eax),%eax
8010151c:	85 d2                	test   %edx,%edx
8010151e:	74 70                	je     80101590 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101520:	83 ec 08             	sub    $0x8,%esp
80101523:	52                   	push   %edx
80101524:	50                   	push   %eax
80101525:	e8 a6 eb ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010152a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010152e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101531:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101533:	8b 1a                	mov    (%edx),%ebx
80101535:	85 db                	test   %ebx,%ebx
80101537:	75 1d                	jne    80101556 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101539:	8b 06                	mov    (%esi),%eax
8010153b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010153e:	e8 bd fd ff ff       	call   80101300 <balloc>
80101543:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101546:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101549:	89 c3                	mov    %eax,%ebx
8010154b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010154d:	57                   	push   %edi
8010154e:	e8 1d 1a 00 00       	call   80102f70 <log_write>
80101553:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101556:	83 ec 0c             	sub    $0xc,%esp
80101559:	57                   	push   %edi
8010155a:	e8 81 ec ff ff       	call   801001e0 <brelse>
8010155f:	83 c4 10             	add    $0x10,%esp
}
80101562:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101565:	89 d8                	mov    %ebx,%eax
80101567:	5b                   	pop    %ebx
80101568:	5e                   	pop    %esi
80101569:	5f                   	pop    %edi
8010156a:	5d                   	pop    %ebp
8010156b:	c3                   	ret    
8010156c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101570:	8b 00                	mov    (%eax),%eax
80101572:	e8 89 fd ff ff       	call   80101300 <balloc>
80101577:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010157a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010157d:	89 c3                	mov    %eax,%ebx
}
8010157f:	89 d8                	mov    %ebx,%eax
80101581:	5b                   	pop    %ebx
80101582:	5e                   	pop    %esi
80101583:	5f                   	pop    %edi
80101584:	5d                   	pop    %ebp
80101585:	c3                   	ret    
80101586:	8d 76 00             	lea    0x0(%esi),%esi
80101589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101590:	e8 6b fd ff ff       	call   80101300 <balloc>
80101595:	89 c2                	mov    %eax,%edx
80101597:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010159d:	8b 06                	mov    (%esi),%eax
8010159f:	e9 7c ff ff ff       	jmp    80101520 <bmap+0x40>
  panic("bmap: out of range");
801015a4:	83 ec 0c             	sub    $0xc,%esp
801015a7:	68 55 76 10 80       	push   $0x80107655
801015ac:	e8 df ed ff ff       	call   80100390 <panic>
801015b1:	eb 0d                	jmp    801015c0 <readsb>
801015b3:	90                   	nop
801015b4:	90                   	nop
801015b5:	90                   	nop
801015b6:	90                   	nop
801015b7:	90                   	nop
801015b8:	90                   	nop
801015b9:	90                   	nop
801015ba:	90                   	nop
801015bb:	90                   	nop
801015bc:	90                   	nop
801015bd:	90                   	nop
801015be:	90                   	nop
801015bf:	90                   	nop

801015c0 <readsb>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	6a 01                	push   $0x1
801015cd:	ff 75 08             	pushl  0x8(%ebp)
801015d0:	e8 fb ea ff ff       	call   801000d0 <bread>
801015d5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801015da:	83 c4 0c             	add    $0xc,%esp
801015dd:	6a 1c                	push   $0x1c
801015df:	50                   	push   %eax
801015e0:	56                   	push   %esi
801015e1:	e8 ba 33 00 00       	call   801049a0 <memmove>
  brelse(bp);
801015e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015e9:	83 c4 10             	add    $0x10,%esp
}
801015ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015ef:	5b                   	pop    %ebx
801015f0:	5e                   	pop    %esi
801015f1:	5d                   	pop    %ebp
  brelse(bp);
801015f2:	e9 e9 eb ff ff       	jmp    801001e0 <brelse>
801015f7:	89 f6                	mov    %esi,%esi
801015f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101600 <bfree>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	89 d3                	mov    %edx,%ebx
80101607:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101609:	83 ec 08             	sub    $0x8,%esp
8010160c:	68 20 0a 11 80       	push   $0x80110a20
80101611:	50                   	push   %eax
80101612:	e8 a9 ff ff ff       	call   801015c0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101617:	58                   	pop    %eax
80101618:	5a                   	pop    %edx
80101619:	89 da                	mov    %ebx,%edx
8010161b:	c1 ea 0c             	shr    $0xc,%edx
8010161e:	03 15 38 0a 11 80    	add    0x80110a38,%edx
80101624:	52                   	push   %edx
80101625:	56                   	push   %esi
80101626:	e8 a5 ea ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010162b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010162d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101630:	ba 01 00 00 00       	mov    $0x1,%edx
80101635:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101638:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010163e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101641:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101643:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101648:	85 d1                	test   %edx,%ecx
8010164a:	74 25                	je     80101671 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010164c:	f7 d2                	not    %edx
8010164e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101650:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101653:	21 ca                	and    %ecx,%edx
80101655:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101659:	56                   	push   %esi
8010165a:	e8 11 19 00 00       	call   80102f70 <log_write>
  brelse(bp);
8010165f:	89 34 24             	mov    %esi,(%esp)
80101662:	e8 79 eb ff ff       	call   801001e0 <brelse>
}
80101667:	83 c4 10             	add    $0x10,%esp
8010166a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010166d:	5b                   	pop    %ebx
8010166e:	5e                   	pop    %esi
8010166f:	5d                   	pop    %ebp
80101670:	c3                   	ret    
    panic("freeing free block");
80101671:	83 ec 0c             	sub    $0xc,%esp
80101674:	68 68 76 10 80       	push   $0x80107668
80101679:	e8 12 ed ff ff       	call   80100390 <panic>
8010167e:	66 90                	xchg   %ax,%ax

80101680 <iinit>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	bb 80 0a 11 80       	mov    $0x80110a80,%ebx
80101689:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010168c:	68 7b 76 10 80       	push   $0x8010767b
80101691:	68 40 0a 11 80       	push   $0x80110a40
80101696:	e8 e5 2f 00 00       	call   80104680 <initlock>
8010169b:	83 c4 10             	add    $0x10,%esp
8010169e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801016a0:	83 ec 08             	sub    $0x8,%esp
801016a3:	68 82 76 10 80       	push   $0x80107682
801016a8:	53                   	push   %ebx
801016a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016af:	e8 bc 2e 00 00       	call   80104570 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016b4:	83 c4 10             	add    $0x10,%esp
801016b7:	81 fb a0 26 11 80    	cmp    $0x801126a0,%ebx
801016bd:	75 e1                	jne    801016a0 <iinit+0x20>
  readsb(dev, &sb);
801016bf:	83 ec 08             	sub    $0x8,%esp
801016c2:	68 20 0a 11 80       	push   $0x80110a20
801016c7:	ff 75 08             	pushl  0x8(%ebp)
801016ca:	e8 f1 fe ff ff       	call   801015c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016cf:	ff 35 38 0a 11 80    	pushl  0x80110a38
801016d5:	ff 35 34 0a 11 80    	pushl  0x80110a34
801016db:	ff 35 30 0a 11 80    	pushl  0x80110a30
801016e1:	ff 35 2c 0a 11 80    	pushl  0x80110a2c
801016e7:	ff 35 28 0a 11 80    	pushl  0x80110a28
801016ed:	ff 35 24 0a 11 80    	pushl  0x80110a24
801016f3:	ff 35 20 0a 11 80    	pushl  0x80110a20
801016f9:	68 e8 76 10 80       	push   $0x801076e8
801016fe:	e8 dd ef ff ff       	call   801006e0 <cprintf>
}
80101703:	83 c4 30             	add    $0x30,%esp
80101706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101709:	c9                   	leave  
8010170a:	c3                   	ret    
8010170b:	90                   	nop
8010170c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101710 <ialloc>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	57                   	push   %edi
80101714:	56                   	push   %esi
80101715:	53                   	push   %ebx
80101716:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101719:	83 3d 28 0a 11 80 01 	cmpl   $0x1,0x80110a28
{
80101720:	8b 45 0c             	mov    0xc(%ebp),%eax
80101723:	8b 75 08             	mov    0x8(%ebp),%esi
80101726:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101729:	0f 86 91 00 00 00    	jbe    801017c0 <ialloc+0xb0>
8010172f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101734:	eb 21                	jmp    80101757 <ialloc+0x47>
80101736:	8d 76 00             	lea    0x0(%esi),%esi
80101739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101740:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101743:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101746:	57                   	push   %edi
80101747:	e8 94 ea ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010174c:	83 c4 10             	add    $0x10,%esp
8010174f:	39 1d 28 0a 11 80    	cmp    %ebx,0x80110a28
80101755:	76 69                	jbe    801017c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101757:	89 d8                	mov    %ebx,%eax
80101759:	83 ec 08             	sub    $0x8,%esp
8010175c:	c1 e8 03             	shr    $0x3,%eax
8010175f:	03 05 34 0a 11 80    	add    0x80110a34,%eax
80101765:	50                   	push   %eax
80101766:	56                   	push   %esi
80101767:	e8 64 e9 ff ff       	call   801000d0 <bread>
8010176c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010176e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101770:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101773:	83 e0 07             	and    $0x7,%eax
80101776:	c1 e0 06             	shl    $0x6,%eax
80101779:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010177d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101781:	75 bd                	jne    80101740 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101783:	83 ec 04             	sub    $0x4,%esp
80101786:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101789:	6a 40                	push   $0x40
8010178b:	6a 00                	push   $0x0
8010178d:	51                   	push   %ecx
8010178e:	e8 5d 31 00 00       	call   801048f0 <memset>
      dip->type = type;
80101793:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101797:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010179a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010179d:	89 3c 24             	mov    %edi,(%esp)
801017a0:	e8 cb 17 00 00       	call   80102f70 <log_write>
      brelse(bp);
801017a5:	89 3c 24             	mov    %edi,(%esp)
801017a8:	e8 33 ea ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801017ad:	83 c4 10             	add    $0x10,%esp
}
801017b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017b3:	89 da                	mov    %ebx,%edx
801017b5:	89 f0                	mov    %esi,%eax
}
801017b7:	5b                   	pop    %ebx
801017b8:	5e                   	pop    %esi
801017b9:	5f                   	pop    %edi
801017ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801017bb:	e9 50 fc ff ff       	jmp    80101410 <iget>
  panic("ialloc: no inodes");
801017c0:	83 ec 0c             	sub    $0xc,%esp
801017c3:	68 88 76 10 80       	push   $0x80107688
801017c8:	e8 c3 eb ff ff       	call   80100390 <panic>
801017cd:	8d 76 00             	lea    0x0(%esi),%esi

801017d0 <iupdate>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	56                   	push   %esi
801017d4:	53                   	push   %ebx
801017d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017d8:	83 ec 08             	sub    $0x8,%esp
801017db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e1:	c1 e8 03             	shr    $0x3,%eax
801017e4:	03 05 34 0a 11 80    	add    0x80110a34,%eax
801017ea:	50                   	push   %eax
801017eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801017ee:	e8 dd e8 ff ff       	call   801000d0 <bread>
801017f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801017f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101809:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010180c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101810:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101813:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101817:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010181b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010181f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101823:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101827:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010182a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010182d:	6a 34                	push   $0x34
8010182f:	53                   	push   %ebx
80101830:	50                   	push   %eax
80101831:	e8 6a 31 00 00       	call   801049a0 <memmove>
  log_write(bp);
80101836:	89 34 24             	mov    %esi,(%esp)
80101839:	e8 32 17 00 00       	call   80102f70 <log_write>
  brelse(bp);
8010183e:	89 75 08             	mov    %esi,0x8(%ebp)
80101841:	83 c4 10             	add    $0x10,%esp
}
80101844:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101847:	5b                   	pop    %ebx
80101848:	5e                   	pop    %esi
80101849:	5d                   	pop    %ebp
  brelse(bp);
8010184a:	e9 91 e9 ff ff       	jmp    801001e0 <brelse>
8010184f:	90                   	nop

80101850 <idup>:
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	53                   	push   %ebx
80101854:	83 ec 10             	sub    $0x10,%esp
80101857:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010185a:	68 40 0a 11 80       	push   $0x80110a40
8010185f:	e8 0c 2f 00 00       	call   80104770 <acquire>
  ip->ref++;
80101864:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101868:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
8010186f:	e8 1c 30 00 00       	call   80104890 <release>
}
80101874:	89 d8                	mov    %ebx,%eax
80101876:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101879:	c9                   	leave  
8010187a:	c3                   	ret    
8010187b:	90                   	nop
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101880 <ilock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	0f 84 b7 00 00 00    	je     80101947 <ilock+0xc7>
80101890:	8b 53 08             	mov    0x8(%ebx),%edx
80101893:	85 d2                	test   %edx,%edx
80101895:	0f 8e ac 00 00 00    	jle    80101947 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010189b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010189e:	83 ec 0c             	sub    $0xc,%esp
801018a1:	50                   	push   %eax
801018a2:	e8 09 2d 00 00       	call   801045b0 <acquiresleep>
  if(ip->valid == 0){
801018a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018aa:	83 c4 10             	add    $0x10,%esp
801018ad:	85 c0                	test   %eax,%eax
801018af:	74 0f                	je     801018c0 <ilock+0x40>
}
801018b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018b4:	5b                   	pop    %ebx
801018b5:	5e                   	pop    %esi
801018b6:	5d                   	pop    %ebp
801018b7:	c3                   	ret    
801018b8:	90                   	nop
801018b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018c0:	8b 43 04             	mov    0x4(%ebx),%eax
801018c3:	83 ec 08             	sub    $0x8,%esp
801018c6:	c1 e8 03             	shr    $0x3,%eax
801018c9:	03 05 34 0a 11 80    	add    0x80110a34,%eax
801018cf:	50                   	push   %eax
801018d0:	ff 33                	pushl  (%ebx)
801018d2:	e8 f9 e7 ff ff       	call   801000d0 <bread>
801018d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018df:	83 e0 07             	and    $0x7,%eax
801018e2:	c1 e0 06             	shl    $0x6,%eax
801018e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801018e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801018f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801018f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801018fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801018ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101903:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101907:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010190b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010190e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101911:	6a 34                	push   $0x34
80101913:	50                   	push   %eax
80101914:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101917:	50                   	push   %eax
80101918:	e8 83 30 00 00       	call   801049a0 <memmove>
    brelse(bp);
8010191d:	89 34 24             	mov    %esi,(%esp)
80101920:	e8 bb e8 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101925:	83 c4 10             	add    $0x10,%esp
80101928:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010192d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101934:	0f 85 77 ff ff ff    	jne    801018b1 <ilock+0x31>
      panic("ilock: no type");
8010193a:	83 ec 0c             	sub    $0xc,%esp
8010193d:	68 a0 76 10 80       	push   $0x801076a0
80101942:	e8 49 ea ff ff       	call   80100390 <panic>
    panic("ilock");
80101947:	83 ec 0c             	sub    $0xc,%esp
8010194a:	68 9a 76 10 80       	push   $0x8010769a
8010194f:	e8 3c ea ff ff       	call   80100390 <panic>
80101954:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010195a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101960 <iunlock>:
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	56                   	push   %esi
80101964:	53                   	push   %ebx
80101965:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101968:	85 db                	test   %ebx,%ebx
8010196a:	74 28                	je     80101994 <iunlock+0x34>
8010196c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010196f:	83 ec 0c             	sub    $0xc,%esp
80101972:	56                   	push   %esi
80101973:	e8 d8 2c 00 00       	call   80104650 <holdingsleep>
80101978:	83 c4 10             	add    $0x10,%esp
8010197b:	85 c0                	test   %eax,%eax
8010197d:	74 15                	je     80101994 <iunlock+0x34>
8010197f:	8b 43 08             	mov    0x8(%ebx),%eax
80101982:	85 c0                	test   %eax,%eax
80101984:	7e 0e                	jle    80101994 <iunlock+0x34>
  releasesleep(&ip->lock);
80101986:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101989:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010198c:	5b                   	pop    %ebx
8010198d:	5e                   	pop    %esi
8010198e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010198f:	e9 7c 2c 00 00       	jmp    80104610 <releasesleep>
    panic("iunlock");
80101994:	83 ec 0c             	sub    $0xc,%esp
80101997:	68 af 76 10 80       	push   $0x801076af
8010199c:	e8 ef e9 ff ff       	call   80100390 <panic>
801019a1:	eb 0d                	jmp    801019b0 <iput>
801019a3:	90                   	nop
801019a4:	90                   	nop
801019a5:	90                   	nop
801019a6:	90                   	nop
801019a7:	90                   	nop
801019a8:	90                   	nop
801019a9:	90                   	nop
801019aa:	90                   	nop
801019ab:	90                   	nop
801019ac:	90                   	nop
801019ad:	90                   	nop
801019ae:	90                   	nop
801019af:	90                   	nop

801019b0 <iput>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	57                   	push   %edi
801019b4:	56                   	push   %esi
801019b5:	53                   	push   %ebx
801019b6:	83 ec 28             	sub    $0x28,%esp
801019b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019bf:	57                   	push   %edi
801019c0:	e8 eb 2b 00 00       	call   801045b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019c8:	83 c4 10             	add    $0x10,%esp
801019cb:	85 d2                	test   %edx,%edx
801019cd:	74 07                	je     801019d6 <iput+0x26>
801019cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019d4:	74 32                	je     80101a08 <iput+0x58>
  releasesleep(&ip->lock);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	57                   	push   %edi
801019da:	e8 31 2c 00 00       	call   80104610 <releasesleep>
  acquire(&icache.lock);
801019df:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
801019e6:	e8 85 2d 00 00       	call   80104770 <acquire>
  ip->ref--;
801019eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019ef:	83 c4 10             	add    $0x10,%esp
801019f2:	c7 45 08 40 0a 11 80 	movl   $0x80110a40,0x8(%ebp)
}
801019f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019fc:	5b                   	pop    %ebx
801019fd:	5e                   	pop    %esi
801019fe:	5f                   	pop    %edi
801019ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101a00:	e9 8b 2e 00 00       	jmp    80104890 <release>
80101a05:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a08:	83 ec 0c             	sub    $0xc,%esp
80101a0b:	68 40 0a 11 80       	push   $0x80110a40
80101a10:	e8 5b 2d 00 00       	call   80104770 <acquire>
    int r = ip->ref;
80101a15:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a18:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
80101a1f:	e8 6c 2e 00 00       	call   80104890 <release>
    if(r == 1){
80101a24:	83 c4 10             	add    $0x10,%esp
80101a27:	83 fe 01             	cmp    $0x1,%esi
80101a2a:	75 aa                	jne    801019d6 <iput+0x26>
80101a2c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a32:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a35:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a38:	89 cf                	mov    %ecx,%edi
80101a3a:	eb 0b                	jmp    80101a47 <iput+0x97>
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a40:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a43:	39 fe                	cmp    %edi,%esi
80101a45:	74 19                	je     80101a60 <iput+0xb0>
    if(ip->addrs[i]){
80101a47:	8b 16                	mov    (%esi),%edx
80101a49:	85 d2                	test   %edx,%edx
80101a4b:	74 f3                	je     80101a40 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a4d:	8b 03                	mov    (%ebx),%eax
80101a4f:	e8 ac fb ff ff       	call   80101600 <bfree>
      ip->addrs[i] = 0;
80101a54:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a5a:	eb e4                	jmp    80101a40 <iput+0x90>
80101a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a60:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a66:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a69:	85 c0                	test   %eax,%eax
80101a6b:	75 33                	jne    80101aa0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a6d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a70:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a77:	53                   	push   %ebx
80101a78:	e8 53 fd ff ff       	call   801017d0 <iupdate>
      ip->type = 0;
80101a7d:	31 c0                	xor    %eax,%eax
80101a7f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a83:	89 1c 24             	mov    %ebx,(%esp)
80101a86:	e8 45 fd ff ff       	call   801017d0 <iupdate>
      ip->valid = 0;
80101a8b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a92:	83 c4 10             	add    $0x10,%esp
80101a95:	e9 3c ff ff ff       	jmp    801019d6 <iput+0x26>
80101a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101aa0:	83 ec 08             	sub    $0x8,%esp
80101aa3:	50                   	push   %eax
80101aa4:	ff 33                	pushl  (%ebx)
80101aa6:	e8 25 e6 ff ff       	call   801000d0 <bread>
80101aab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ab1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101ab7:	8d 70 5c             	lea    0x5c(%eax),%esi
80101aba:	83 c4 10             	add    $0x10,%esp
80101abd:	89 cf                	mov    %ecx,%edi
80101abf:	eb 0e                	jmp    80101acf <iput+0x11f>
80101ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ac8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101acb:	39 fe                	cmp    %edi,%esi
80101acd:	74 0f                	je     80101ade <iput+0x12e>
      if(a[j])
80101acf:	8b 16                	mov    (%esi),%edx
80101ad1:	85 d2                	test   %edx,%edx
80101ad3:	74 f3                	je     80101ac8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101ad5:	8b 03                	mov    (%ebx),%eax
80101ad7:	e8 24 fb ff ff       	call   80101600 <bfree>
80101adc:	eb ea                	jmp    80101ac8 <iput+0x118>
    brelse(bp);
80101ade:	83 ec 0c             	sub    $0xc,%esp
80101ae1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ae4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ae7:	e8 f4 e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101aec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101af2:	8b 03                	mov    (%ebx),%eax
80101af4:	e8 07 fb ff ff       	call   80101600 <bfree>
    ip->addrs[NDIRECT] = 0;
80101af9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b00:	00 00 00 
80101b03:	83 c4 10             	add    $0x10,%esp
80101b06:	e9 62 ff ff ff       	jmp    80101a6d <iput+0xbd>
80101b0b:	90                   	nop
80101b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b10 <iunlockput>:
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	53                   	push   %ebx
80101b14:	83 ec 10             	sub    $0x10,%esp
80101b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101b1a:	53                   	push   %ebx
80101b1b:	e8 40 fe ff ff       	call   80101960 <iunlock>
  iput(ip);
80101b20:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b23:	83 c4 10             	add    $0x10,%esp
}
80101b26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b29:	c9                   	leave  
  iput(ip);
80101b2a:	e9 81 fe ff ff       	jmp    801019b0 <iput>
80101b2f:	90                   	nop

80101b30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	8b 55 08             	mov    0x8(%ebp),%edx
80101b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b39:	8b 0a                	mov    (%edx),%ecx
80101b3b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b3e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b41:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b44:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b48:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b4b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b4f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b53:	8b 52 58             	mov    0x58(%edx),%edx
80101b56:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b59:	5d                   	pop    %ebp
80101b5a:	c3                   	ret    
80101b5b:	90                   	nop
80101b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	57                   	push   %edi
80101b64:	56                   	push   %esi
80101b65:	53                   	push   %ebx
80101b66:	83 ec 1c             	sub    $0x1c,%esp
80101b69:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b77:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101b7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b80:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b83:	0f 84 a7 00 00 00    	je     80101c30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b8c:	8b 40 58             	mov    0x58(%eax),%eax
80101b8f:	39 c6                	cmp    %eax,%esi
80101b91:	0f 87 ba 00 00 00    	ja     80101c51 <readi+0xf1>
80101b97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b9a:	89 f9                	mov    %edi,%ecx
80101b9c:	01 f1                	add    %esi,%ecx
80101b9e:	0f 82 ad 00 00 00    	jb     80101c51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101ba4:	89 c2                	mov    %eax,%edx
80101ba6:	29 f2                	sub    %esi,%edx
80101ba8:	39 c8                	cmp    %ecx,%eax
80101baa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bad:	31 ff                	xor    %edi,%edi
80101baf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101bb1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb4:	74 6c                	je     80101c22 <readi+0xc2>
80101bb6:	8d 76 00             	lea    0x0(%esi),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 d8                	mov    %ebx,%eax
80101bca:	e8 11 f9 ff ff       	call   801014e0 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 33                	pushl  (%ebx)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bdd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101bdf:	89 f0                	mov    %esi,%eax
80101be1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101be6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101beb:	83 c4 0c             	add    $0xc,%esp
80101bee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101bf0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101bf4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	29 fb                	sub    %edi,%ebx
80101bf9:	39 d9                	cmp    %ebx,%ecx
80101bfb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bfe:	53                   	push   %ebx
80101bff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101c02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c07:	e8 94 2d 00 00       	call   801049a0 <memmove>
    brelse(bp);
80101c0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c0f:	89 14 24             	mov    %edx,(%esp)
80101c12:	e8 c9 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c1a:	83 c4 10             	add    $0x10,%esp
80101c1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c20:	77 9e                	ja     80101bc0 <readi+0x60>
  }
  return n;
80101c22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c28:	5b                   	pop    %ebx
80101c29:	5e                   	pop    %esi
80101c2a:	5f                   	pop    %edi
80101c2b:	5d                   	pop    %ebp
80101c2c:	c3                   	ret    
80101c2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c34:	66 83 f8 09          	cmp    $0x9,%ax
80101c38:	77 17                	ja     80101c51 <readi+0xf1>
80101c3a:	8b 04 c5 c0 09 11 80 	mov    -0x7feef640(,%eax,8),%eax
80101c41:	85 c0                	test   %eax,%eax
80101c43:	74 0c                	je     80101c51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4b:	5b                   	pop    %ebx
80101c4c:	5e                   	pop    %esi
80101c4d:	5f                   	pop    %edi
80101c4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c4f:	ff e0                	jmp    *%eax
      return -1;
80101c51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c56:	eb cd                	jmp    80101c25 <readi+0xc5>
80101c58:	90                   	nop
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	83 ec 1c             	sub    $0x1c,%esp
80101c69:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c83:	0f 84 b7 00 00 00    	je     80101d40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101c8f:	0f 82 eb 00 00 00    	jb     80101d80 <writei+0x120>
80101c95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c98:	31 d2                	xor    %edx,%edx
80101c9a:	89 f8                	mov    %edi,%eax
80101c9c:	01 f0                	add    %esi,%eax
80101c9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ca1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ca6:	0f 87 d4 00 00 00    	ja     80101d80 <writei+0x120>
80101cac:	85 d2                	test   %edx,%edx
80101cae:	0f 85 cc 00 00 00    	jne    80101d80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cb4:	85 ff                	test   %edi,%edi
80101cb6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cbd:	74 72                	je     80101d31 <writei+0xd1>
80101cbf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101cc3:	89 f2                	mov    %esi,%edx
80101cc5:	c1 ea 09             	shr    $0x9,%edx
80101cc8:	89 f8                	mov    %edi,%eax
80101cca:	e8 11 f8 ff ff       	call   801014e0 <bmap>
80101ccf:	83 ec 08             	sub    $0x8,%esp
80101cd2:	50                   	push   %eax
80101cd3:	ff 37                	pushl  (%edi)
80101cd5:	e8 f6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cda:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cdd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ce0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ce2:	89 f0                	mov    %esi,%eax
80101ce4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ce9:	83 c4 0c             	add    $0xc,%esp
80101cec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101cf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101cf7:	39 d9                	cmp    %ebx,%ecx
80101cf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cfc:	53                   	push   %ebx
80101cfd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d02:	50                   	push   %eax
80101d03:	e8 98 2c 00 00       	call   801049a0 <memmove>
    log_write(bp);
80101d08:	89 3c 24             	mov    %edi,(%esp)
80101d0b:	e8 60 12 00 00       	call   80102f70 <log_write>
    brelse(bp);
80101d10:	89 3c 24             	mov    %edi,(%esp)
80101d13:	e8 c8 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d1e:	83 c4 10             	add    $0x10,%esp
80101d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d27:	77 97                	ja     80101cc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d2f:	77 37                	ja     80101d68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d37:	5b                   	pop    %ebx
80101d38:	5e                   	pop    %esi
80101d39:	5f                   	pop    %edi
80101d3a:	5d                   	pop    %ebp
80101d3b:	c3                   	ret    
80101d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d44:	66 83 f8 09          	cmp    $0x9,%ax
80101d48:	77 36                	ja     80101d80 <writei+0x120>
80101d4a:	8b 04 c5 c4 09 11 80 	mov    -0x7feef63c(,%eax,8),%eax
80101d51:	85 c0                	test   %eax,%eax
80101d53:	74 2b                	je     80101d80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101d55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d5b:	5b                   	pop    %ebx
80101d5c:	5e                   	pop    %esi
80101d5d:	5f                   	pop    %edi
80101d5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d5f:	ff e0                	jmp    *%eax
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d71:	50                   	push   %eax
80101d72:	e8 59 fa ff ff       	call   801017d0 <iupdate>
80101d77:	83 c4 10             	add    $0x10,%esp
80101d7a:	eb b5                	jmp    80101d31 <writei+0xd1>
80101d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d85:	eb ad                	jmp    80101d34 <writei+0xd4>
80101d87:	89 f6                	mov    %esi,%esi
80101d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d96:	6a 0e                	push   $0xe
80101d98:	ff 75 0c             	pushl  0xc(%ebp)
80101d9b:	ff 75 08             	pushl  0x8(%ebp)
80101d9e:	e8 6d 2c 00 00       	call   80104a10 <strncmp>
}
80101da3:	c9                   	leave  
80101da4:	c3                   	ret    
80101da5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101db0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	83 ec 1c             	sub    $0x1c,%esp
80101db9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101dc1:	0f 85 85 00 00 00    	jne    80101e4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101dc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101dca:	31 ff                	xor    %edi,%edi
80101dcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dcf:	85 d2                	test   %edx,%edx
80101dd1:	74 3e                	je     80101e11 <dirlookup+0x61>
80101dd3:	90                   	nop
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101dd8:	6a 10                	push   $0x10
80101dda:	57                   	push   %edi
80101ddb:	56                   	push   %esi
80101ddc:	53                   	push   %ebx
80101ddd:	e8 7e fd ff ff       	call   80101b60 <readi>
80101de2:	83 c4 10             	add    $0x10,%esp
80101de5:	83 f8 10             	cmp    $0x10,%eax
80101de8:	75 55                	jne    80101e3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101dea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101def:	74 18                	je     80101e09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101df1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101df4:	83 ec 04             	sub    $0x4,%esp
80101df7:	6a 0e                	push   $0xe
80101df9:	50                   	push   %eax
80101dfa:	ff 75 0c             	pushl  0xc(%ebp)
80101dfd:	e8 0e 2c 00 00       	call   80104a10 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e02:	83 c4 10             	add    $0x10,%esp
80101e05:	85 c0                	test   %eax,%eax
80101e07:	74 17                	je     80101e20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e09:	83 c7 10             	add    $0x10,%edi
80101e0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e0f:	72 c7                	jb     80101dd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e14:	31 c0                	xor    %eax,%eax
}
80101e16:	5b                   	pop    %ebx
80101e17:	5e                   	pop    %esi
80101e18:	5f                   	pop    %edi
80101e19:	5d                   	pop    %ebp
80101e1a:	c3                   	ret    
80101e1b:	90                   	nop
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101e20:	8b 45 10             	mov    0x10(%ebp),%eax
80101e23:	85 c0                	test   %eax,%eax
80101e25:	74 05                	je     80101e2c <dirlookup+0x7c>
        *poff = off;
80101e27:	8b 45 10             	mov    0x10(%ebp),%eax
80101e2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e30:	8b 03                	mov    (%ebx),%eax
80101e32:	e8 d9 f5 ff ff       	call   80101410 <iget>
}
80101e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e3a:	5b                   	pop    %ebx
80101e3b:	5e                   	pop    %esi
80101e3c:	5f                   	pop    %edi
80101e3d:	5d                   	pop    %ebp
80101e3e:	c3                   	ret    
      panic("dirlookup read");
80101e3f:	83 ec 0c             	sub    $0xc,%esp
80101e42:	68 c9 76 10 80       	push   $0x801076c9
80101e47:	e8 44 e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101e4c:	83 ec 0c             	sub    $0xc,%esp
80101e4f:	68 b7 76 10 80       	push   $0x801076b7
80101e54:	e8 37 e5 ff ff       	call   80100390 <panic>
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	57                   	push   %edi
80101e64:	56                   	push   %esi
80101e65:	53                   	push   %ebx
80101e66:	89 cf                	mov    %ecx,%edi
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101e73:	0f 84 67 01 00 00    	je     80101fe0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e79:	e8 82 1b 00 00       	call   80103a00 <myproc>
  acquire(&icache.lock);
80101e7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e81:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e84:	68 40 0a 11 80       	push   $0x80110a40
80101e89:	e8 e2 28 00 00       	call   80104770 <acquire>
  ip->ref++;
80101e8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e92:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
80101e99:	e8 f2 29 00 00       	call   80104890 <release>
80101e9e:	83 c4 10             	add    $0x10,%esp
80101ea1:	eb 08                	jmp    80101eab <namex+0x4b>
80101ea3:	90                   	nop
80101ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ea8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eab:	0f b6 03             	movzbl (%ebx),%eax
80101eae:	3c 2f                	cmp    $0x2f,%al
80101eb0:	74 f6                	je     80101ea8 <namex+0x48>
  if(*path == 0)
80101eb2:	84 c0                	test   %al,%al
80101eb4:	0f 84 ee 00 00 00    	je     80101fa8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101eba:	0f b6 03             	movzbl (%ebx),%eax
80101ebd:	3c 2f                	cmp    $0x2f,%al
80101ebf:	0f 84 b3 00 00 00    	je     80101f78 <namex+0x118>
80101ec5:	84 c0                	test   %al,%al
80101ec7:	89 da                	mov    %ebx,%edx
80101ec9:	75 09                	jne    80101ed4 <namex+0x74>
80101ecb:	e9 a8 00 00 00       	jmp    80101f78 <namex+0x118>
80101ed0:	84 c0                	test   %al,%al
80101ed2:	74 0a                	je     80101ede <namex+0x7e>
    path++;
80101ed4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ed7:	0f b6 02             	movzbl (%edx),%eax
80101eda:	3c 2f                	cmp    $0x2f,%al
80101edc:	75 f2                	jne    80101ed0 <namex+0x70>
80101ede:	89 d1                	mov    %edx,%ecx
80101ee0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101ee2:	83 f9 0d             	cmp    $0xd,%ecx
80101ee5:	0f 8e 91 00 00 00    	jle    80101f7c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101eeb:	83 ec 04             	sub    $0x4,%esp
80101eee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ef1:	6a 0e                	push   $0xe
80101ef3:	53                   	push   %ebx
80101ef4:	57                   	push   %edi
80101ef5:	e8 a6 2a 00 00       	call   801049a0 <memmove>
    path++;
80101efa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101efd:	83 c4 10             	add    $0x10,%esp
    path++;
80101f00:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101f02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101f05:	75 11                	jne    80101f18 <namex+0xb8>
80101f07:	89 f6                	mov    %esi,%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101f10:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f16:	74 f8                	je     80101f10 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f18:	83 ec 0c             	sub    $0xc,%esp
80101f1b:	56                   	push   %esi
80101f1c:	e8 5f f9 ff ff       	call   80101880 <ilock>
    if(ip->type != T_DIR){
80101f21:	83 c4 10             	add    $0x10,%esp
80101f24:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f29:	0f 85 91 00 00 00    	jne    80101fc0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f32:	85 d2                	test   %edx,%edx
80101f34:	74 09                	je     80101f3f <namex+0xdf>
80101f36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f39:	0f 84 b7 00 00 00    	je     80101ff6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f3f:	83 ec 04             	sub    $0x4,%esp
80101f42:	6a 00                	push   $0x0
80101f44:	57                   	push   %edi
80101f45:	56                   	push   %esi
80101f46:	e8 65 fe ff ff       	call   80101db0 <dirlookup>
80101f4b:	83 c4 10             	add    $0x10,%esp
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	74 6e                	je     80101fc0 <namex+0x160>
  iunlock(ip);
80101f52:	83 ec 0c             	sub    $0xc,%esp
80101f55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f58:	56                   	push   %esi
80101f59:	e8 02 fa ff ff       	call   80101960 <iunlock>
  iput(ip);
80101f5e:	89 34 24             	mov    %esi,(%esp)
80101f61:	e8 4a fa ff ff       	call   801019b0 <iput>
80101f66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f69:	83 c4 10             	add    $0x10,%esp
80101f6c:	89 c6                	mov    %eax,%esi
80101f6e:	e9 38 ff ff ff       	jmp    80101eab <namex+0x4b>
80101f73:	90                   	nop
80101f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101f78:	89 da                	mov    %ebx,%edx
80101f7a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101f7c:	83 ec 04             	sub    $0x4,%esp
80101f7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101f85:	51                   	push   %ecx
80101f86:	53                   	push   %ebx
80101f87:	57                   	push   %edi
80101f88:	e8 13 2a 00 00       	call   801049a0 <memmove>
    name[len] = 0;
80101f8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f93:	83 c4 10             	add    $0x10,%esp
80101f96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101f9a:	89 d3                	mov    %edx,%ebx
80101f9c:	e9 61 ff ff ff       	jmp    80101f02 <namex+0xa2>
80101fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101fab:	85 c0                	test   %eax,%eax
80101fad:	75 5d                	jne    8010200c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
80101fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101fc0:	83 ec 0c             	sub    $0xc,%esp
80101fc3:	56                   	push   %esi
80101fc4:	e8 97 f9 ff ff       	call   80101960 <iunlock>
  iput(ip);
80101fc9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fcc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fce:	e8 dd f9 ff ff       	call   801019b0 <iput>
      return 0;
80101fd3:	83 c4 10             	add    $0x10,%esp
}
80101fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd9:	89 f0                	mov    %esi,%eax
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5f                   	pop    %edi
80101fde:	5d                   	pop    %ebp
80101fdf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101fe0:	ba 01 00 00 00       	mov    $0x1,%edx
80101fe5:	b8 01 00 00 00       	mov    $0x1,%eax
80101fea:	e8 21 f4 ff ff       	call   80101410 <iget>
80101fef:	89 c6                	mov    %eax,%esi
80101ff1:	e9 b5 fe ff ff       	jmp    80101eab <namex+0x4b>
      iunlock(ip);
80101ff6:	83 ec 0c             	sub    $0xc,%esp
80101ff9:	56                   	push   %esi
80101ffa:	e8 61 f9 ff ff       	call   80101960 <iunlock>
      return ip;
80101fff:	83 c4 10             	add    $0x10,%esp
}
80102002:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102005:	89 f0                	mov    %esi,%eax
80102007:	5b                   	pop    %ebx
80102008:	5e                   	pop    %esi
80102009:	5f                   	pop    %edi
8010200a:	5d                   	pop    %ebp
8010200b:	c3                   	ret    
    iput(ip);
8010200c:	83 ec 0c             	sub    $0xc,%esp
8010200f:	56                   	push   %esi
    return 0;
80102010:	31 f6                	xor    %esi,%esi
    iput(ip);
80102012:	e8 99 f9 ff ff       	call   801019b0 <iput>
    return 0;
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	eb 93                	jmp    80101faf <namex+0x14f>
8010201c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102020 <dirlink>:
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	57                   	push   %edi
80102024:	56                   	push   %esi
80102025:	53                   	push   %ebx
80102026:	83 ec 20             	sub    $0x20,%esp
80102029:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010202c:	6a 00                	push   $0x0
8010202e:	ff 75 0c             	pushl  0xc(%ebp)
80102031:	53                   	push   %ebx
80102032:	e8 79 fd ff ff       	call   80101db0 <dirlookup>
80102037:	83 c4 10             	add    $0x10,%esp
8010203a:	85 c0                	test   %eax,%eax
8010203c:	75 67                	jne    801020a5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010203e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102041:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102044:	85 ff                	test   %edi,%edi
80102046:	74 29                	je     80102071 <dirlink+0x51>
80102048:	31 ff                	xor    %edi,%edi
8010204a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010204d:	eb 09                	jmp    80102058 <dirlink+0x38>
8010204f:	90                   	nop
80102050:	83 c7 10             	add    $0x10,%edi
80102053:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102056:	73 19                	jae    80102071 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102058:	6a 10                	push   $0x10
8010205a:	57                   	push   %edi
8010205b:	56                   	push   %esi
8010205c:	53                   	push   %ebx
8010205d:	e8 fe fa ff ff       	call   80101b60 <readi>
80102062:	83 c4 10             	add    $0x10,%esp
80102065:	83 f8 10             	cmp    $0x10,%eax
80102068:	75 4e                	jne    801020b8 <dirlink+0x98>
    if(de.inum == 0)
8010206a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010206f:	75 df                	jne    80102050 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102071:	8d 45 da             	lea    -0x26(%ebp),%eax
80102074:	83 ec 04             	sub    $0x4,%esp
80102077:	6a 0e                	push   $0xe
80102079:	ff 75 0c             	pushl  0xc(%ebp)
8010207c:	50                   	push   %eax
8010207d:	e8 ee 29 00 00       	call   80104a70 <strncpy>
  de.inum = inum;
80102082:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102085:	6a 10                	push   $0x10
80102087:	57                   	push   %edi
80102088:	56                   	push   %esi
80102089:	53                   	push   %ebx
  de.inum = inum;
8010208a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010208e:	e8 cd fb ff ff       	call   80101c60 <writei>
80102093:	83 c4 20             	add    $0x20,%esp
80102096:	83 f8 10             	cmp    $0x10,%eax
80102099:	75 2a                	jne    801020c5 <dirlink+0xa5>
  return 0;
8010209b:	31 c0                	xor    %eax,%eax
}
8010209d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a0:	5b                   	pop    %ebx
801020a1:	5e                   	pop    %esi
801020a2:	5f                   	pop    %edi
801020a3:	5d                   	pop    %ebp
801020a4:	c3                   	ret    
    iput(ip);
801020a5:	83 ec 0c             	sub    $0xc,%esp
801020a8:	50                   	push   %eax
801020a9:	e8 02 f9 ff ff       	call   801019b0 <iput>
    return -1;
801020ae:	83 c4 10             	add    $0x10,%esp
801020b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020b6:	eb e5                	jmp    8010209d <dirlink+0x7d>
      panic("dirlink read");
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	68 d8 76 10 80       	push   $0x801076d8
801020c0:	e8 cb e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	68 ee 7c 10 80       	push   $0x80107cee
801020cd:	e8 be e2 ff ff       	call   80100390 <panic>
801020d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020e0 <namei>:

struct inode*
namei(char *path)
{
801020e0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020e1:	31 d2                	xor    %edx,%edx
{
801020e3:	89 e5                	mov    %esp,%ebp
801020e5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020e8:	8b 45 08             	mov    0x8(%ebp),%eax
801020eb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ee:	e8 6d fd ff ff       	call   80101e60 <namex>
}
801020f3:	c9                   	leave  
801020f4:	c3                   	ret    
801020f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102100 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102100:	55                   	push   %ebp
  return namex(path, 1, name);
80102101:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102106:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102108:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010210b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010210e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010210f:	e9 4c fd ff ff       	jmp    80101e60 <namex>
80102114:	66 90                	xchg   %ax,%ax
80102116:	66 90                	xchg   %ax,%ax
80102118:	66 90                	xchg   %ax,%ax
8010211a:	66 90                	xchg   %ax,%ax
8010211c:	66 90                	xchg   %ax,%ax
8010211e:	66 90                	xchg   %ax,%ax

80102120 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	57                   	push   %edi
80102124:	56                   	push   %esi
80102125:	53                   	push   %ebx
80102126:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102129:	85 c0                	test   %eax,%eax
8010212b:	0f 84 b4 00 00 00    	je     801021e5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102131:	8b 58 08             	mov    0x8(%eax),%ebx
80102134:	89 c6                	mov    %eax,%esi
80102136:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010213c:	0f 87 96 00 00 00    	ja     801021d8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102142:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102147:	89 f6                	mov    %esi,%esi
80102149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102150:	89 ca                	mov    %ecx,%edx
80102152:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102153:	83 e0 c0             	and    $0xffffffc0,%eax
80102156:	3c 40                	cmp    $0x40,%al
80102158:	75 f6                	jne    80102150 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010215a:	31 ff                	xor    %edi,%edi
8010215c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102161:	89 f8                	mov    %edi,%eax
80102163:	ee                   	out    %al,(%dx)
80102164:	b8 01 00 00 00       	mov    $0x1,%eax
80102169:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010216e:	ee                   	out    %al,(%dx)
8010216f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102174:	89 d8                	mov    %ebx,%eax
80102176:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102177:	89 d8                	mov    %ebx,%eax
80102179:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010217e:	c1 f8 08             	sar    $0x8,%eax
80102181:	ee                   	out    %al,(%dx)
80102182:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102187:	89 f8                	mov    %edi,%eax
80102189:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010218a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010218e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102193:	c1 e0 04             	shl    $0x4,%eax
80102196:	83 e0 10             	and    $0x10,%eax
80102199:	83 c8 e0             	or     $0xffffffe0,%eax
8010219c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010219d:	f6 06 04             	testb  $0x4,(%esi)
801021a0:	75 16                	jne    801021b8 <idestart+0x98>
801021a2:	b8 20 00 00 00       	mov    $0x20,%eax
801021a7:	89 ca                	mov    %ecx,%edx
801021a9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ad:	5b                   	pop    %ebx
801021ae:	5e                   	pop    %esi
801021af:	5f                   	pop    %edi
801021b0:	5d                   	pop    %ebp
801021b1:	c3                   	ret    
801021b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021b8:	b8 30 00 00 00       	mov    $0x30,%eax
801021bd:	89 ca                	mov    %ecx,%edx
801021bf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021c0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021c5:	83 c6 5c             	add    $0x5c,%esi
801021c8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021cd:	fc                   	cld    
801021ce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021d3:	5b                   	pop    %ebx
801021d4:	5e                   	pop    %esi
801021d5:	5f                   	pop    %edi
801021d6:	5d                   	pop    %ebp
801021d7:	c3                   	ret    
    panic("incorrect blockno");
801021d8:	83 ec 0c             	sub    $0xc,%esp
801021db:	68 44 77 10 80       	push   $0x80107744
801021e0:	e8 ab e1 ff ff       	call   80100390 <panic>
    panic("idestart");
801021e5:	83 ec 0c             	sub    $0xc,%esp
801021e8:	68 3b 77 10 80       	push   $0x8010773b
801021ed:	e8 9e e1 ff ff       	call   80100390 <panic>
801021f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102200 <ideinit>:
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102206:	68 56 77 10 80       	push   $0x80107756
8010220b:	68 80 a5 10 80       	push   $0x8010a580
80102210:	e8 6b 24 00 00       	call   80104680 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102215:	58                   	pop    %eax
80102216:	a1 60 2d 11 80       	mov    0x80112d60,%eax
8010221b:	5a                   	pop    %edx
8010221c:	83 e8 01             	sub    $0x1,%eax
8010221f:	50                   	push   %eax
80102220:	6a 0e                	push   $0xe
80102222:	e8 a9 02 00 00       	call   801024d0 <ioapicenable>
80102227:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010222a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222f:	90                   	nop
80102230:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102231:	83 e0 c0             	and    $0xffffffc0,%eax
80102234:	3c 40                	cmp    $0x40,%al
80102236:	75 f8                	jne    80102230 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102238:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010223d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102242:	ee                   	out    %al,(%dx)
80102243:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102248:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010224d:	eb 06                	jmp    80102255 <ideinit+0x55>
8010224f:	90                   	nop
  for(i=0; i<1000; i++){
80102250:	83 e9 01             	sub    $0x1,%ecx
80102253:	74 0f                	je     80102264 <ideinit+0x64>
80102255:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102256:	84 c0                	test   %al,%al
80102258:	74 f6                	je     80102250 <ideinit+0x50>
      havedisk1 = 1;
8010225a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102261:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102264:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102269:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010226e:	ee                   	out    %al,(%dx)
}
8010226f:	c9                   	leave  
80102270:	c3                   	ret    
80102271:	eb 0d                	jmp    80102280 <ideintr>
80102273:	90                   	nop
80102274:	90                   	nop
80102275:	90                   	nop
80102276:	90                   	nop
80102277:	90                   	nop
80102278:	90                   	nop
80102279:	90                   	nop
8010227a:	90                   	nop
8010227b:	90                   	nop
8010227c:	90                   	nop
8010227d:	90                   	nop
8010227e:	90                   	nop
8010227f:	90                   	nop

80102280 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	57                   	push   %edi
80102284:	56                   	push   %esi
80102285:	53                   	push   %ebx
80102286:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102289:	68 80 a5 10 80       	push   $0x8010a580
8010228e:	e8 dd 24 00 00       	call   80104770 <acquire>

  if((b = idequeue) == 0){
80102293:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102299:	83 c4 10             	add    $0x10,%esp
8010229c:	85 db                	test   %ebx,%ebx
8010229e:	74 67                	je     80102307 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022a0:	8b 43 58             	mov    0x58(%ebx),%eax
801022a3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022a8:	8b 3b                	mov    (%ebx),%edi
801022aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801022b0:	75 31                	jne    801022e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022b7:	89 f6                	mov    %esi,%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801022c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c1:	89 c6                	mov    %eax,%esi
801022c3:	83 e6 c0             	and    $0xffffffc0,%esi
801022c6:	89 f1                	mov    %esi,%ecx
801022c8:	80 f9 40             	cmp    $0x40,%cl
801022cb:	75 f3                	jne    801022c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022cd:	a8 21                	test   $0x21,%al
801022cf:	75 12                	jne    801022e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801022d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801022d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022de:	fc                   	cld    
801022df:	f3 6d                	rep insl (%dx),%es:(%edi)
801022e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801022e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022e9:	89 f9                	mov    %edi,%ecx
801022eb:	83 c9 02             	or     $0x2,%ecx
801022ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801022f0:	53                   	push   %ebx
801022f1:	e8 fa 20 00 00       	call   801043f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022f6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801022fb:	83 c4 10             	add    $0x10,%esp
801022fe:	85 c0                	test   %eax,%eax
80102300:	74 05                	je     80102307 <ideintr+0x87>
    idestart(idequeue);
80102302:	e8 19 fe ff ff       	call   80102120 <idestart>
    release(&idelock);
80102307:	83 ec 0c             	sub    $0xc,%esp
8010230a:	68 80 a5 10 80       	push   $0x8010a580
8010230f:	e8 7c 25 00 00       	call   80104890 <release>

  release(&idelock);
}
80102314:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102317:	5b                   	pop    %ebx
80102318:	5e                   	pop    %esi
80102319:	5f                   	pop    %edi
8010231a:	5d                   	pop    %ebp
8010231b:	c3                   	ret    
8010231c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102320 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 10             	sub    $0x10,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010232a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010232d:	50                   	push   %eax
8010232e:	e8 1d 23 00 00       	call   80104650 <holdingsleep>
80102333:	83 c4 10             	add    $0x10,%esp
80102336:	85 c0                	test   %eax,%eax
80102338:	0f 84 c6 00 00 00    	je     80102404 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010233e:	8b 03                	mov    (%ebx),%eax
80102340:	83 e0 06             	and    $0x6,%eax
80102343:	83 f8 02             	cmp    $0x2,%eax
80102346:	0f 84 ab 00 00 00    	je     801023f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010234c:	8b 53 04             	mov    0x4(%ebx),%edx
8010234f:	85 d2                	test   %edx,%edx
80102351:	74 0d                	je     80102360 <iderw+0x40>
80102353:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102358:	85 c0                	test   %eax,%eax
8010235a:	0f 84 b1 00 00 00    	je     80102411 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102360:	83 ec 0c             	sub    $0xc,%esp
80102363:	68 80 a5 10 80       	push   $0x8010a580
80102368:	e8 03 24 00 00       	call   80104770 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010236d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102373:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102376:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010237d:	85 d2                	test   %edx,%edx
8010237f:	75 09                	jne    8010238a <iderw+0x6a>
80102381:	eb 6d                	jmp    801023f0 <iderw+0xd0>
80102383:	90                   	nop
80102384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102388:	89 c2                	mov    %eax,%edx
8010238a:	8b 42 58             	mov    0x58(%edx),%eax
8010238d:	85 c0                	test   %eax,%eax
8010238f:	75 f7                	jne    80102388 <iderw+0x68>
80102391:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102394:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102396:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010239c:	74 42                	je     801023e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010239e:	8b 03                	mov    (%ebx),%eax
801023a0:	83 e0 06             	and    $0x6,%eax
801023a3:	83 f8 02             	cmp    $0x2,%eax
801023a6:	74 23                	je     801023cb <iderw+0xab>
801023a8:	90                   	nop
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801023b0:	83 ec 08             	sub    $0x8,%esp
801023b3:	68 80 a5 10 80       	push   $0x8010a580
801023b8:	53                   	push   %ebx
801023b9:	e8 62 1e 00 00       	call   80104220 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023be:	8b 03                	mov    (%ebx),%eax
801023c0:	83 c4 10             	add    $0x10,%esp
801023c3:	83 e0 06             	and    $0x6,%eax
801023c6:	83 f8 02             	cmp    $0x2,%eax
801023c9:	75 e5                	jne    801023b0 <iderw+0x90>
  }


  release(&idelock);
801023cb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801023d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023d5:	c9                   	leave  
  release(&idelock);
801023d6:	e9 b5 24 00 00       	jmp    80104890 <release>
801023db:	90                   	nop
801023dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801023e0:	89 d8                	mov    %ebx,%eax
801023e2:	e8 39 fd ff ff       	call   80102120 <idestart>
801023e7:	eb b5                	jmp    8010239e <iderw+0x7e>
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023f0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801023f5:	eb 9d                	jmp    80102394 <iderw+0x74>
    panic("iderw: nothing to do");
801023f7:	83 ec 0c             	sub    $0xc,%esp
801023fa:	68 70 77 10 80       	push   $0x80107770
801023ff:	e8 8c df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102404:	83 ec 0c             	sub    $0xc,%esp
80102407:	68 5a 77 10 80       	push   $0x8010775a
8010240c:	e8 7f df ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102411:	83 ec 0c             	sub    $0xc,%esp
80102414:	68 85 77 10 80       	push   $0x80107785
80102419:	e8 72 df ff ff       	call   80100390 <panic>
8010241e:	66 90                	xchg   %ax,%ax

80102420 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102420:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102421:	c7 05 94 26 11 80 00 	movl   $0xfec00000,0x80112694
80102428:	00 c0 fe 
{
8010242b:	89 e5                	mov    %esp,%ebp
8010242d:	56                   	push   %esi
8010242e:	53                   	push   %ebx
  ioapic->reg = reg;
8010242f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102436:	00 00 00 
  return ioapic->data;
80102439:	a1 94 26 11 80       	mov    0x80112694,%eax
8010243e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102447:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010244d:	0f b6 15 c0 27 11 80 	movzbl 0x801127c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102454:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102457:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010245a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010245d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102460:	39 c2                	cmp    %eax,%edx
80102462:	74 16                	je     8010247a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102464:	83 ec 0c             	sub    $0xc,%esp
80102467:	68 a4 77 10 80       	push   $0x801077a4
8010246c:	e8 6f e2 ff ff       	call   801006e0 <cprintf>
80102471:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
80102477:	83 c4 10             	add    $0x10,%esp
8010247a:	83 c3 21             	add    $0x21,%ebx
{
8010247d:	ba 10 00 00 00       	mov    $0x10,%edx
80102482:	b8 20 00 00 00       	mov    $0x20,%eax
80102487:	89 f6                	mov    %esi,%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102490:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102492:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102498:	89 c6                	mov    %eax,%esi
8010249a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801024a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024a3:	89 71 10             	mov    %esi,0x10(%ecx)
801024a6:	8d 72 01             	lea    0x1(%edx),%esi
801024a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801024ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801024ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801024b0:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
801024b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801024bd:	75 d1                	jne    80102490 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c2:	5b                   	pop    %ebx
801024c3:	5e                   	pop    %esi
801024c4:	5d                   	pop    %ebp
801024c5:	c3                   	ret    
801024c6:	8d 76 00             	lea    0x0(%esi),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024d0:	55                   	push   %ebp
  ioapic->reg = reg;
801024d1:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
{
801024d7:	89 e5                	mov    %esp,%ebp
801024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024dc:	8d 50 20             	lea    0x20(%eax),%edx
801024df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024e5:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024f6:	a1 94 26 11 80       	mov    0x80112694,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102501:	5d                   	pop    %ebp
80102502:	c3                   	ret    
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	53                   	push   %ebx
80102514:	83 ec 04             	sub    $0x4,%esp
80102517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010251a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102520:	75 70                	jne    80102592 <kfree+0x82>
80102522:	81 fb 28 67 11 80    	cmp    $0x80116728,%ebx
80102528:	72 68                	jb     80102592 <kfree+0x82>
8010252a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102530:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102535:	77 5b                	ja     80102592 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102537:	83 ec 04             	sub    $0x4,%esp
8010253a:	68 00 10 00 00       	push   $0x1000
8010253f:	6a 01                	push   $0x1
80102541:	53                   	push   %ebx
80102542:	e8 a9 23 00 00       	call   801048f0 <memset>

  if(kmem.use_lock)
80102547:	8b 15 d4 26 11 80    	mov    0x801126d4,%edx
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	85 d2                	test   %edx,%edx
80102552:	75 2c                	jne    80102580 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102554:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102559:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010255b:	a1 d4 26 11 80       	mov    0x801126d4,%eax
  kmem.freelist = r;
80102560:	89 1d d8 26 11 80    	mov    %ebx,0x801126d8
  if(kmem.use_lock)
80102566:	85 c0                	test   %eax,%eax
80102568:	75 06                	jne    80102570 <kfree+0x60>
    release(&kmem.lock);
}
8010256a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010256d:	c9                   	leave  
8010256e:	c3                   	ret    
8010256f:	90                   	nop
    release(&kmem.lock);
80102570:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102577:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010257a:	c9                   	leave  
    release(&kmem.lock);
8010257b:	e9 10 23 00 00       	jmp    80104890 <release>
    acquire(&kmem.lock);
80102580:	83 ec 0c             	sub    $0xc,%esp
80102583:	68 a0 26 11 80       	push   $0x801126a0
80102588:	e8 e3 21 00 00       	call   80104770 <acquire>
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	eb c2                	jmp    80102554 <kfree+0x44>
    panic("kfree");
80102592:	83 ec 0c             	sub    $0xc,%esp
80102595:	68 d6 77 10 80       	push   $0x801077d6
8010259a:	e8 f1 dd ff ff       	call   80100390 <panic>
8010259f:	90                   	nop

801025a0 <freerange>:
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	56                   	push   %esi
801025a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025bd:	39 de                	cmp    %ebx,%esi
801025bf:	72 23                	jb     801025e4 <freerange+0x44>
801025c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025d7:	50                   	push   %eax
801025d8:	e8 33 ff ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025dd:	83 c4 10             	add    $0x10,%esp
801025e0:	39 f3                	cmp    %esi,%ebx
801025e2:	76 e4                	jbe    801025c8 <freerange+0x28>
}
801025e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e7:	5b                   	pop    %ebx
801025e8:	5e                   	pop    %esi
801025e9:	5d                   	pop    %ebp
801025ea:	c3                   	ret    
801025eb:	90                   	nop
801025ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025f0 <kinit1>:
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
801025f4:	53                   	push   %ebx
801025f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025f8:	83 ec 08             	sub    $0x8,%esp
801025fb:	68 dc 77 10 80       	push   $0x801077dc
80102600:	68 a0 26 11 80       	push   $0x801126a0
80102605:	e8 76 20 00 00       	call   80104680 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010260a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102610:	c7 05 d4 26 11 80 00 	movl   $0x0,0x801126d4
80102617:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010261a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102620:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102626:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262c:	39 de                	cmp    %ebx,%esi
8010262e:	72 1c                	jb     8010264c <kinit1+0x5c>
    kfree(p);
80102630:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102636:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102639:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010263f:	50                   	push   %eax
80102640:	e8 cb fe ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102645:	83 c4 10             	add    $0x10,%esp
80102648:	39 de                	cmp    %ebx,%esi
8010264a:	73 e4                	jae    80102630 <kinit1+0x40>
}
8010264c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010264f:	5b                   	pop    %ebx
80102650:	5e                   	pop    %esi
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret    
80102653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <kinit2>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
80102664:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102665:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102668:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010266b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102671:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102677:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267d:	39 de                	cmp    %ebx,%esi
8010267f:	72 23                	jb     801026a4 <kinit2+0x44>
80102681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102688:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010268e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102691:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102697:	50                   	push   %eax
80102698:	e8 73 fe ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	39 de                	cmp    %ebx,%esi
801026a2:	73 e4                	jae    80102688 <kinit2+0x28>
  kmem.use_lock = 1;
801026a4:	c7 05 d4 26 11 80 01 	movl   $0x1,0x801126d4
801026ab:	00 00 00 
}
801026ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026b1:	5b                   	pop    %ebx
801026b2:	5e                   	pop    %esi
801026b3:	5d                   	pop    %ebp
801026b4:	c3                   	ret    
801026b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026c0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801026c5:	85 c0                	test   %eax,%eax
801026c7:	75 1f                	jne    801026e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026c9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
  if(r)
801026ce:	85 c0                	test   %eax,%eax
801026d0:	74 0e                	je     801026e0 <kalloc+0x20>
    kmem.freelist = r->next;
801026d2:	8b 10                	mov    (%eax),%edx
801026d4:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
801026da:	c3                   	ret    
801026db:	90                   	nop
801026dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026e0:	f3 c3                	repz ret 
801026e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801026e8:	55                   	push   %ebp
801026e9:	89 e5                	mov    %esp,%ebp
801026eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ee:	68 a0 26 11 80       	push   $0x801126a0
801026f3:	e8 78 20 00 00       	call   80104770 <acquire>
  r = kmem.freelist;
801026f8:	a1 d8 26 11 80       	mov    0x801126d8,%eax
  if(r)
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	8b 15 d4 26 11 80    	mov    0x801126d4,%edx
80102706:	85 c0                	test   %eax,%eax
80102708:	74 08                	je     80102712 <kalloc+0x52>
    kmem.freelist = r->next;
8010270a:	8b 08                	mov    (%eax),%ecx
8010270c:	89 0d d8 26 11 80    	mov    %ecx,0x801126d8
  if(kmem.use_lock)
80102712:	85 d2                	test   %edx,%edx
80102714:	74 16                	je     8010272c <kalloc+0x6c>
    release(&kmem.lock);
80102716:	83 ec 0c             	sub    $0xc,%esp
80102719:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010271c:	68 a0 26 11 80       	push   $0x801126a0
80102721:	e8 6a 21 00 00       	call   80104890 <release>
  return (char*)r;
80102726:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102729:	83 c4 10             	add    $0x10,%esp
}
8010272c:	c9                   	leave  
8010272d:	c3                   	ret    
8010272e:	66 90                	xchg   %ax,%ax

80102730 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102730:	ba 64 00 00 00       	mov    $0x64,%edx
80102735:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102736:	a8 01                	test   $0x1,%al
80102738:	0f 84 c2 00 00 00    	je     80102800 <kbdgetc+0xd0>
8010273e:	ba 60 00 00 00       	mov    $0x60,%edx
80102743:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102744:	0f b6 d0             	movzbl %al,%edx
80102747:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010274d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102753:	0f 84 7f 00 00 00    	je     801027d8 <kbdgetc+0xa8>
{
80102759:	55                   	push   %ebp
8010275a:	89 e5                	mov    %esp,%ebp
8010275c:	53                   	push   %ebx
8010275d:	89 cb                	mov    %ecx,%ebx
8010275f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102762:	84 c0                	test   %al,%al
80102764:	78 4a                	js     801027b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102766:	85 db                	test   %ebx,%ebx
80102768:	74 09                	je     80102773 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010276a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010276d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102770:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102773:	0f b6 82 20 79 10 80 	movzbl -0x7fef86e0(%edx),%eax
8010277a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010277c:	0f b6 82 20 78 10 80 	movzbl -0x7fef87e0(%edx),%eax
80102783:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102785:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102787:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010278d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102790:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102793:	8b 04 85 00 78 10 80 	mov    -0x7fef8800(,%eax,4),%eax
8010279a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010279e:	74 31                	je     801027d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801027a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801027a3:	83 fa 19             	cmp    $0x19,%edx
801027a6:	77 40                	ja     801027e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027ab:	5b                   	pop    %ebx
801027ac:	5d                   	pop    %ebp
801027ad:	c3                   	ret    
801027ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801027b0:	83 e0 7f             	and    $0x7f,%eax
801027b3:	85 db                	test   %ebx,%ebx
801027b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801027b8:	0f b6 82 20 79 10 80 	movzbl -0x7fef86e0(%edx),%eax
801027bf:	83 c8 40             	or     $0x40,%eax
801027c2:	0f b6 c0             	movzbl %al,%eax
801027c5:	f7 d0                	not    %eax
801027c7:	21 c1                	and    %eax,%ecx
    return 0;
801027c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801027cb:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801027d1:	5b                   	pop    %ebx
801027d2:	5d                   	pop    %ebp
801027d3:	c3                   	ret    
801027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801027d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801027db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027dd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
801027e3:	c3                   	ret    
801027e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801027e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801027ef:	83 f9 1a             	cmp    $0x1a,%ecx
801027f2:	0f 42 c2             	cmovb  %edx,%eax
}
801027f5:	5d                   	pop    %ebp
801027f6:	c3                   	ret    
801027f7:	89 f6                	mov    %esi,%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102805:	c3                   	ret    
80102806:	8d 76 00             	lea    0x0(%esi),%esi
80102809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102810 <kbdintr>:

void
kbdintr(void)
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102816:	68 30 27 10 80       	push   $0x80102730
8010281b:	e8 70 e0 ff ff       	call   80100890 <consoleintr>
}
80102820:	83 c4 10             	add    $0x10,%esp
80102823:	c9                   	leave  
80102824:	c3                   	ret    
80102825:	66 90                	xchg   %ax,%ax
80102827:	66 90                	xchg   %ax,%ax
80102829:	66 90                	xchg   %ax,%ax
8010282b:	66 90                	xchg   %ax,%ax
8010282d:	66 90                	xchg   %ax,%ax
8010282f:	90                   	nop

80102830 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102830:	a1 dc 26 11 80       	mov    0x801126dc,%eax
{
80102835:	55                   	push   %ebp
80102836:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102838:	85 c0                	test   %eax,%eax
8010283a:	0f 84 c8 00 00 00    	je     80102908 <lapicinit+0xd8>
  lapic[index] = value;
80102840:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102847:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102854:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102857:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102861:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102864:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102867:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010286e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102871:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102874:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010287b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010287e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102881:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102888:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010288e:	8b 50 30             	mov    0x30(%eax),%edx
80102891:	c1 ea 10             	shr    $0x10,%edx
80102894:	80 fa 03             	cmp    $0x3,%dl
80102897:	77 77                	ja     80102910 <lapicinit+0xe0>
  lapic[index] = value;
80102899:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028e4:	8b 50 20             	mov    0x20(%eax),%edx
801028e7:	89 f6                	mov    %esi,%esi
801028e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028f6:	80 e6 10             	and    $0x10,%dh
801028f9:	75 f5                	jne    801028f0 <lapicinit+0xc0>
  lapic[index] = value;
801028fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102902:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102905:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102908:	5d                   	pop    %ebp
80102909:	c3                   	ret    
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102910:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102917:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010291a:	8b 50 20             	mov    0x20(%eax),%edx
8010291d:	e9 77 ff ff ff       	jmp    80102899 <lapicinit+0x69>
80102922:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102930 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102930:	8b 15 dc 26 11 80    	mov    0x801126dc,%edx
{
80102936:	55                   	push   %ebp
80102937:	31 c0                	xor    %eax,%eax
80102939:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010293b:	85 d2                	test   %edx,%edx
8010293d:	74 06                	je     80102945 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010293f:	8b 42 20             	mov    0x20(%edx),%eax
80102942:	c1 e8 18             	shr    $0x18,%eax
}
80102945:	5d                   	pop    %ebp
80102946:	c3                   	ret    
80102947:	89 f6                	mov    %esi,%esi
80102949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102950 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102950:	a1 dc 26 11 80       	mov    0x801126dc,%eax
{
80102955:	55                   	push   %ebp
80102956:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102958:	85 c0                	test   %eax,%eax
8010295a:	74 0d                	je     80102969 <lapiceoi+0x19>
  lapic[index] = value;
8010295c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102963:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102966:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102969:	5d                   	pop    %ebp
8010296a:	c3                   	ret    
8010296b:	90                   	nop
8010296c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102970 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
}
80102973:	5d                   	pop    %ebp
80102974:	c3                   	ret    
80102975:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102980 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102980:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102981:	b8 0f 00 00 00       	mov    $0xf,%eax
80102986:	ba 70 00 00 00       	mov    $0x70,%edx
8010298b:	89 e5                	mov    %esp,%ebp
8010298d:	53                   	push   %ebx
8010298e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102991:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102994:	ee                   	out    %al,(%dx)
80102995:	b8 0a 00 00 00       	mov    $0xa,%eax
8010299a:	ba 71 00 00 00       	mov    $0x71,%edx
8010299f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029a0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801029a2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029ab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029ad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801029b0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801029b3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801029b5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029be:	a1 dc 26 11 80       	mov    0x801126dc,%eax
801029c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029d3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029e0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a01:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a07:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a0a:	5b                   	pop    %ebx
80102a0b:	5d                   	pop    %ebp
80102a0c:	c3                   	ret    
80102a0d:	8d 76 00             	lea    0x0(%esi),%esi

80102a10 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102a10:	55                   	push   %ebp
80102a11:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a16:	ba 70 00 00 00       	mov    $0x70,%edx
80102a1b:	89 e5                	mov    %esp,%ebp
80102a1d:	57                   	push   %edi
80102a1e:	56                   	push   %esi
80102a1f:	53                   	push   %ebx
80102a20:	83 ec 4c             	sub    $0x4c,%esp
80102a23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a24:	ba 71 00 00 00       	mov    $0x71,%edx
80102a29:	ec                   	in     (%dx),%al
80102a2a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a32:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a35:	8d 76 00             	lea    0x0(%esi),%esi
80102a38:	31 c0                	xor    %eax,%eax
80102a3a:	89 da                	mov    %ebx,%edx
80102a3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a42:	89 ca                	mov    %ecx,%edx
80102a44:	ec                   	in     (%dx),%al
80102a45:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 da                	mov    %ebx,%edx
80102a4a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a50:	89 ca                	mov    %ecx,%edx
80102a52:	ec                   	in     (%dx),%al
80102a53:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a56:	89 da                	mov    %ebx,%edx
80102a58:	b8 04 00 00 00       	mov    $0x4,%eax
80102a5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5e:	89 ca                	mov    %ecx,%edx
80102a60:	ec                   	in     (%dx),%al
80102a61:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a64:	89 da                	mov    %ebx,%edx
80102a66:	b8 07 00 00 00       	mov    $0x7,%eax
80102a6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6c:	89 ca                	mov    %ecx,%edx
80102a6e:	ec                   	in     (%dx),%al
80102a6f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a72:	89 da                	mov    %ebx,%edx
80102a74:	b8 08 00 00 00       	mov    $0x8,%eax
80102a79:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7a:	89 ca                	mov    %ecx,%edx
80102a7c:	ec                   	in     (%dx),%al
80102a7d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7f:	89 da                	mov    %ebx,%edx
80102a81:	b8 09 00 00 00       	mov    $0x9,%eax
80102a86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a87:	89 ca                	mov    %ecx,%edx
80102a89:	ec                   	in     (%dx),%al
80102a8a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8c:	89 da                	mov    %ebx,%edx
80102a8e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a94:	89 ca                	mov    %ecx,%edx
80102a96:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a97:	84 c0                	test   %al,%al
80102a99:	78 9d                	js     80102a38 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a9b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a9f:	89 fa                	mov    %edi,%edx
80102aa1:	0f b6 fa             	movzbl %dl,%edi
80102aa4:	89 f2                	mov    %esi,%edx
80102aa6:	0f b6 f2             	movzbl %dl,%esi
80102aa9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aac:	89 da                	mov    %ebx,%edx
80102aae:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102ab1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ab4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ab8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102abb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102abf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ac2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ac6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ac9:	31 c0                	xor    %eax,%eax
80102acb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acc:	89 ca                	mov    %ecx,%edx
80102ace:	ec                   	in     (%dx),%al
80102acf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad2:	89 da                	mov    %ebx,%edx
80102ad4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ad7:	b8 02 00 00 00       	mov    $0x2,%eax
80102adc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102add:	89 ca                	mov    %ecx,%edx
80102adf:	ec                   	in     (%dx),%al
80102ae0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae3:	89 da                	mov    %ebx,%edx
80102ae5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ae8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aee:	89 ca                	mov    %ecx,%edx
80102af0:	ec                   	in     (%dx),%al
80102af1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af4:	89 da                	mov    %ebx,%edx
80102af6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102af9:	b8 07 00 00 00       	mov    $0x7,%eax
80102afe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aff:	89 ca                	mov    %ecx,%edx
80102b01:	ec                   	in     (%dx),%al
80102b02:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b05:	89 da                	mov    %ebx,%edx
80102b07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b0a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b10:	89 ca                	mov    %ecx,%edx
80102b12:	ec                   	in     (%dx),%al
80102b13:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b16:	89 da                	mov    %ebx,%edx
80102b18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b1b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b20:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b21:	89 ca                	mov    %ecx,%edx
80102b23:	ec                   	in     (%dx),%al
80102b24:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b27:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b2d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b30:	6a 18                	push   $0x18
80102b32:	50                   	push   %eax
80102b33:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b36:	50                   	push   %eax
80102b37:	e8 04 1e 00 00       	call   80104940 <memcmp>
80102b3c:	83 c4 10             	add    $0x10,%esp
80102b3f:	85 c0                	test   %eax,%eax
80102b41:	0f 85 f1 fe ff ff    	jne    80102a38 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b47:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b4b:	75 78                	jne    80102bc5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b50:	89 c2                	mov    %eax,%edx
80102b52:	83 e0 0f             	and    $0xf,%eax
80102b55:	c1 ea 04             	shr    $0x4,%edx
80102b58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b61:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b64:	89 c2                	mov    %eax,%edx
80102b66:	83 e0 0f             	and    $0xf,%eax
80102b69:	c1 ea 04             	shr    $0x4,%edx
80102b6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b72:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b75:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b78:	89 c2                	mov    %eax,%edx
80102b7a:	83 e0 0f             	and    $0xf,%eax
80102b7d:	c1 ea 04             	shr    $0x4,%edx
80102b80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b86:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b8c:	89 c2                	mov    %eax,%edx
80102b8e:	83 e0 0f             	and    $0xf,%eax
80102b91:	c1 ea 04             	shr    $0x4,%edx
80102b94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba0:	89 c2                	mov    %eax,%edx
80102ba2:	83 e0 0f             	and    $0xf,%eax
80102ba5:	c1 ea 04             	shr    $0x4,%edx
80102ba8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bb1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb4:	89 c2                	mov    %eax,%edx
80102bb6:	83 e0 0f             	and    $0xf,%eax
80102bb9:	c1 ea 04             	shr    $0x4,%edx
80102bbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bc2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bc5:	8b 75 08             	mov    0x8(%ebp),%esi
80102bc8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bcb:	89 06                	mov    %eax,(%esi)
80102bcd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bd0:	89 46 04             	mov    %eax,0x4(%esi)
80102bd3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bd6:	89 46 08             	mov    %eax,0x8(%esi)
80102bd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bdc:	89 46 0c             	mov    %eax,0xc(%esi)
80102bdf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102be2:	89 46 10             	mov    %eax,0x10(%esi)
80102be5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102be8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102beb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bf5:	5b                   	pop    %ebx
80102bf6:	5e                   	pop    %esi
80102bf7:	5f                   	pop    %edi
80102bf8:	5d                   	pop    %ebp
80102bf9:	c3                   	ret    
80102bfa:	66 90                	xchg   %ax,%ax
80102bfc:	66 90                	xchg   %ax,%ax
80102bfe:	66 90                	xchg   %ax,%ax

80102c00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c00:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
80102c06:	85 c9                	test   %ecx,%ecx
80102c08:	0f 8e 8a 00 00 00    	jle    80102c98 <install_trans+0x98>
{
80102c0e:	55                   	push   %ebp
80102c0f:	89 e5                	mov    %esp,%ebp
80102c11:	57                   	push   %edi
80102c12:	56                   	push   %esi
80102c13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102c14:	31 db                	xor    %ebx,%ebx
{
80102c16:	83 ec 0c             	sub    $0xc,%esp
80102c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c20:	a1 14 27 11 80       	mov    0x80112714,%eax
80102c25:	83 ec 08             	sub    $0x8,%esp
80102c28:	01 d8                	add    %ebx,%eax
80102c2a:	83 c0 01             	add    $0x1,%eax
80102c2d:	50                   	push   %eax
80102c2e:	ff 35 24 27 11 80    	pushl  0x80112724
80102c34:	e8 97 d4 ff ff       	call   801000d0 <bread>
80102c39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c3b:	58                   	pop    %eax
80102c3c:	5a                   	pop    %edx
80102c3d:	ff 34 9d 2c 27 11 80 	pushl  -0x7feed8d4(,%ebx,4)
80102c44:	ff 35 24 27 11 80    	pushl  0x80112724
  for (tail = 0; tail < log.lh.n; tail++) {
80102c4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c4d:	e8 7e d4 ff ff       	call   801000d0 <bread>
80102c52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102c57:	83 c4 0c             	add    $0xc,%esp
80102c5a:	68 00 02 00 00       	push   $0x200
80102c5f:	50                   	push   %eax
80102c60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c63:	50                   	push   %eax
80102c64:	e8 37 1d 00 00       	call   801049a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c69:	89 34 24             	mov    %esi,(%esp)
80102c6c:	e8 2f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c71:	89 3c 24             	mov    %edi,(%esp)
80102c74:	e8 67 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c79:	89 34 24             	mov    %esi,(%esp)
80102c7c:	e8 5f d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c81:	83 c4 10             	add    $0x10,%esp
80102c84:	39 1d 28 27 11 80    	cmp    %ebx,0x80112728
80102c8a:	7f 94                	jg     80102c20 <install_trans+0x20>
  }
}
80102c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c8f:	5b                   	pop    %ebx
80102c90:	5e                   	pop    %esi
80102c91:	5f                   	pop    %edi
80102c92:	5d                   	pop    %ebp
80102c93:	c3                   	ret    
80102c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c98:	f3 c3                	repz ret 
80102c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ca0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	56                   	push   %esi
80102ca4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ca5:	83 ec 08             	sub    $0x8,%esp
80102ca8:	ff 35 14 27 11 80    	pushl  0x80112714
80102cae:	ff 35 24 27 11 80    	pushl  0x80112724
80102cb4:	e8 17 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102cb9:	8b 1d 28 27 11 80    	mov    0x80112728,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102cbf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cc2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102cc4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102cc6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102cc9:	7e 16                	jle    80102ce1 <write_head+0x41>
80102ccb:	c1 e3 02             	shl    $0x2,%ebx
80102cce:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102cd0:	8b 8a 2c 27 11 80    	mov    -0x7feed8d4(%edx),%ecx
80102cd6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102cda:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102cdd:	39 da                	cmp    %ebx,%edx
80102cdf:	75 ef                	jne    80102cd0 <write_head+0x30>
  }
  bwrite(buf);
80102ce1:	83 ec 0c             	sub    $0xc,%esp
80102ce4:	56                   	push   %esi
80102ce5:	e8 b6 d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102cea:	89 34 24             	mov    %esi,(%esp)
80102ced:	e8 ee d4 ff ff       	call   801001e0 <brelse>
}
80102cf2:	83 c4 10             	add    $0x10,%esp
80102cf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102cf8:	5b                   	pop    %ebx
80102cf9:	5e                   	pop    %esi
80102cfa:	5d                   	pop    %ebp
80102cfb:	c3                   	ret    
80102cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d00 <initlog>:
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	53                   	push   %ebx
80102d04:	83 ec 2c             	sub    $0x2c,%esp
80102d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d0a:	68 20 7a 10 80       	push   $0x80107a20
80102d0f:	68 e0 26 11 80       	push   $0x801126e0
80102d14:	e8 67 19 00 00       	call   80104680 <initlock>
  readsb(dev, &sb);
80102d19:	58                   	pop    %eax
80102d1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d1d:	5a                   	pop    %edx
80102d1e:	50                   	push   %eax
80102d1f:	53                   	push   %ebx
80102d20:	e8 9b e8 ff ff       	call   801015c0 <readsb>
  log.size = sb.nlog;
80102d25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d2b:	59                   	pop    %ecx
  log.dev = dev;
80102d2c:	89 1d 24 27 11 80    	mov    %ebx,0x80112724
  log.size = sb.nlog;
80102d32:	89 15 18 27 11 80    	mov    %edx,0x80112718
  log.start = sb.logstart;
80102d38:	a3 14 27 11 80       	mov    %eax,0x80112714
  struct buf *buf = bread(log.dev, log.start);
80102d3d:	5a                   	pop    %edx
80102d3e:	50                   	push   %eax
80102d3f:	53                   	push   %ebx
80102d40:	e8 8b d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102d45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102d48:	83 c4 10             	add    $0x10,%esp
80102d4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102d4d:	89 1d 28 27 11 80    	mov    %ebx,0x80112728
  for (i = 0; i < log.lh.n; i++) {
80102d53:	7e 1c                	jle    80102d71 <initlog+0x71>
80102d55:	c1 e3 02             	shl    $0x2,%ebx
80102d58:	31 d2                	xor    %edx,%edx
80102d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102d60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d64:	83 c2 04             	add    $0x4,%edx
80102d67:	89 8a 28 27 11 80    	mov    %ecx,-0x7feed8d8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102d6d:	39 d3                	cmp    %edx,%ebx
80102d6f:	75 ef                	jne    80102d60 <initlog+0x60>
  brelse(buf);
80102d71:	83 ec 0c             	sub    $0xc,%esp
80102d74:	50                   	push   %eax
80102d75:	e8 66 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d7a:	e8 81 fe ff ff       	call   80102c00 <install_trans>
  log.lh.n = 0;
80102d7f:	c7 05 28 27 11 80 00 	movl   $0x0,0x80112728
80102d86:	00 00 00 
  write_head(); // clear the log
80102d89:	e8 12 ff ff ff       	call   80102ca0 <write_head>
}
80102d8e:	83 c4 10             	add    $0x10,%esp
80102d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d94:	c9                   	leave  
80102d95:	c3                   	ret    
80102d96:	8d 76 00             	lea    0x0(%esi),%esi
80102d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102da0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102da6:	68 e0 26 11 80       	push   $0x801126e0
80102dab:	e8 c0 19 00 00       	call   80104770 <acquire>
80102db0:	83 c4 10             	add    $0x10,%esp
80102db3:	eb 18                	jmp    80102dcd <begin_op+0x2d>
80102db5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102db8:	83 ec 08             	sub    $0x8,%esp
80102dbb:	68 e0 26 11 80       	push   $0x801126e0
80102dc0:	68 e0 26 11 80       	push   $0x801126e0
80102dc5:	e8 56 14 00 00       	call   80104220 <sleep>
80102dca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dcd:	a1 20 27 11 80       	mov    0x80112720,%eax
80102dd2:	85 c0                	test   %eax,%eax
80102dd4:	75 e2                	jne    80102db8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dd6:	a1 1c 27 11 80       	mov    0x8011271c,%eax
80102ddb:	8b 15 28 27 11 80    	mov    0x80112728,%edx
80102de1:	83 c0 01             	add    $0x1,%eax
80102de4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102de7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dea:	83 fa 1e             	cmp    $0x1e,%edx
80102ded:	7f c9                	jg     80102db8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102def:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102df2:	a3 1c 27 11 80       	mov    %eax,0x8011271c
      release(&log.lock);
80102df7:	68 e0 26 11 80       	push   $0x801126e0
80102dfc:	e8 8f 1a 00 00       	call   80104890 <release>
      break;
    }
  }
}
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	c9                   	leave  
80102e05:	c3                   	ret    
80102e06:	8d 76 00             	lea    0x0(%esi),%esi
80102e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	57                   	push   %edi
80102e14:	56                   	push   %esi
80102e15:	53                   	push   %ebx
80102e16:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e19:	68 e0 26 11 80       	push   $0x801126e0
80102e1e:	e8 4d 19 00 00       	call   80104770 <acquire>
  log.outstanding -= 1;
80102e23:	a1 1c 27 11 80       	mov    0x8011271c,%eax
  if(log.committing)
80102e28:	8b 35 20 27 11 80    	mov    0x80112720,%esi
80102e2e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102e34:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102e36:	89 1d 1c 27 11 80    	mov    %ebx,0x8011271c
  if(log.committing)
80102e3c:	0f 85 1a 01 00 00    	jne    80102f5c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102e42:	85 db                	test   %ebx,%ebx
80102e44:	0f 85 ee 00 00 00    	jne    80102f38 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e4a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102e4d:	c7 05 20 27 11 80 01 	movl   $0x1,0x80112720
80102e54:	00 00 00 
  release(&log.lock);
80102e57:	68 e0 26 11 80       	push   $0x801126e0
80102e5c:	e8 2f 1a 00 00       	call   80104890 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e61:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
80102e67:	83 c4 10             	add    $0x10,%esp
80102e6a:	85 c9                	test   %ecx,%ecx
80102e6c:	0f 8e 85 00 00 00    	jle    80102ef7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e72:	a1 14 27 11 80       	mov    0x80112714,%eax
80102e77:	83 ec 08             	sub    $0x8,%esp
80102e7a:	01 d8                	add    %ebx,%eax
80102e7c:	83 c0 01             	add    $0x1,%eax
80102e7f:	50                   	push   %eax
80102e80:	ff 35 24 27 11 80    	pushl  0x80112724
80102e86:	e8 45 d2 ff ff       	call   801000d0 <bread>
80102e8b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8d:	58                   	pop    %eax
80102e8e:	5a                   	pop    %edx
80102e8f:	ff 34 9d 2c 27 11 80 	pushl  -0x7feed8d4(,%ebx,4)
80102e96:	ff 35 24 27 11 80    	pushl  0x80112724
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9f:	e8 2c d2 ff ff       	call   801000d0 <bread>
80102ea4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ea9:	83 c4 0c             	add    $0xc,%esp
80102eac:	68 00 02 00 00       	push   $0x200
80102eb1:	50                   	push   %eax
80102eb2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb5:	50                   	push   %eax
80102eb6:	e8 e5 1a 00 00       	call   801049a0 <memmove>
    bwrite(to);  // write the log
80102ebb:	89 34 24             	mov    %esi,(%esp)
80102ebe:	e8 dd d2 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ec3:	89 3c 24             	mov    %edi,(%esp)
80102ec6:	e8 15 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ecb:	89 34 24             	mov    %esi,(%esp)
80102ece:	e8 0d d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed3:	83 c4 10             	add    $0x10,%esp
80102ed6:	3b 1d 28 27 11 80    	cmp    0x80112728,%ebx
80102edc:	7c 94                	jl     80102e72 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ede:	e8 bd fd ff ff       	call   80102ca0 <write_head>
    install_trans(); // Now install writes to home locations
80102ee3:	e8 18 fd ff ff       	call   80102c00 <install_trans>
    log.lh.n = 0;
80102ee8:	c7 05 28 27 11 80 00 	movl   $0x0,0x80112728
80102eef:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef2:	e8 a9 fd ff ff       	call   80102ca0 <write_head>
    acquire(&log.lock);
80102ef7:	83 ec 0c             	sub    $0xc,%esp
80102efa:	68 e0 26 11 80       	push   $0x801126e0
80102eff:	e8 6c 18 00 00       	call   80104770 <acquire>
    wakeup(&log);
80102f04:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
    log.committing = 0;
80102f0b:	c7 05 20 27 11 80 00 	movl   $0x0,0x80112720
80102f12:	00 00 00 
    wakeup(&log);
80102f15:	e8 d6 14 00 00       	call   801043f0 <wakeup>
    release(&log.lock);
80102f1a:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
80102f21:	e8 6a 19 00 00       	call   80104890 <release>
80102f26:	83 c4 10             	add    $0x10,%esp
}
80102f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f2c:	5b                   	pop    %ebx
80102f2d:	5e                   	pop    %esi
80102f2e:	5f                   	pop    %edi
80102f2f:	5d                   	pop    %ebp
80102f30:	c3                   	ret    
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102f38:	83 ec 0c             	sub    $0xc,%esp
80102f3b:	68 e0 26 11 80       	push   $0x801126e0
80102f40:	e8 ab 14 00 00       	call   801043f0 <wakeup>
  release(&log.lock);
80102f45:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
80102f4c:	e8 3f 19 00 00       	call   80104890 <release>
80102f51:	83 c4 10             	add    $0x10,%esp
}
80102f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f57:	5b                   	pop    %ebx
80102f58:	5e                   	pop    %esi
80102f59:	5f                   	pop    %edi
80102f5a:	5d                   	pop    %ebp
80102f5b:	c3                   	ret    
    panic("log.committing");
80102f5c:	83 ec 0c             	sub    $0xc,%esp
80102f5f:	68 24 7a 10 80       	push   $0x80107a24
80102f64:	e8 27 d4 ff ff       	call   80100390 <panic>
80102f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	53                   	push   %ebx
80102f74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f77:	8b 15 28 27 11 80    	mov    0x80112728,%edx
{
80102f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f80:	83 fa 1d             	cmp    $0x1d,%edx
80102f83:	0f 8f 9d 00 00 00    	jg     80103026 <log_write+0xb6>
80102f89:	a1 18 27 11 80       	mov    0x80112718,%eax
80102f8e:	83 e8 01             	sub    $0x1,%eax
80102f91:	39 c2                	cmp    %eax,%edx
80102f93:	0f 8d 8d 00 00 00    	jge    80103026 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f99:	a1 1c 27 11 80       	mov    0x8011271c,%eax
80102f9e:	85 c0                	test   %eax,%eax
80102fa0:	0f 8e 8d 00 00 00    	jle    80103033 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fa6:	83 ec 0c             	sub    $0xc,%esp
80102fa9:	68 e0 26 11 80       	push   $0x801126e0
80102fae:	e8 bd 17 00 00       	call   80104770 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fb3:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
80102fb9:	83 c4 10             	add    $0x10,%esp
80102fbc:	83 f9 00             	cmp    $0x0,%ecx
80102fbf:	7e 57                	jle    80103018 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102fc4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc6:	3b 15 2c 27 11 80    	cmp    0x8011272c,%edx
80102fcc:	75 0b                	jne    80102fd9 <log_write+0x69>
80102fce:	eb 38                	jmp    80103008 <log_write+0x98>
80102fd0:	39 14 85 2c 27 11 80 	cmp    %edx,-0x7feed8d4(,%eax,4)
80102fd7:	74 2f                	je     80103008 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102fd9:	83 c0 01             	add    $0x1,%eax
80102fdc:	39 c1                	cmp    %eax,%ecx
80102fde:	75 f0                	jne    80102fd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fe0:	89 14 85 2c 27 11 80 	mov    %edx,-0x7feed8d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102fe7:	83 c0 01             	add    $0x1,%eax
80102fea:	a3 28 27 11 80       	mov    %eax,0x80112728
  b->flags |= B_DIRTY; // prevent eviction
80102fef:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102ff2:	c7 45 08 e0 26 11 80 	movl   $0x801126e0,0x8(%ebp)
}
80102ff9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ffc:	c9                   	leave  
  release(&log.lock);
80102ffd:	e9 8e 18 00 00       	jmp    80104890 <release>
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103008:	89 14 85 2c 27 11 80 	mov    %edx,-0x7feed8d4(,%eax,4)
8010300f:	eb de                	jmp    80102fef <log_write+0x7f>
80103011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103018:	8b 43 08             	mov    0x8(%ebx),%eax
8010301b:	a3 2c 27 11 80       	mov    %eax,0x8011272c
  if (i == log.lh.n)
80103020:	75 cd                	jne    80102fef <log_write+0x7f>
80103022:	31 c0                	xor    %eax,%eax
80103024:	eb c1                	jmp    80102fe7 <log_write+0x77>
    panic("too big a transaction");
80103026:	83 ec 0c             	sub    $0xc,%esp
80103029:	68 33 7a 10 80       	push   $0x80107a33
8010302e:	e8 5d d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103033:	83 ec 0c             	sub    $0xc,%esp
80103036:	68 49 7a 10 80       	push   $0x80107a49
8010303b:	e8 50 d3 ff ff       	call   80100390 <panic>

80103040 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	53                   	push   %ebx
80103044:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103047:	e8 94 09 00 00       	call   801039e0 <cpuid>
8010304c:	89 c3                	mov    %eax,%ebx
8010304e:	e8 8d 09 00 00       	call   801039e0 <cpuid>
80103053:	83 ec 04             	sub    $0x4,%esp
80103056:	53                   	push   %ebx
80103057:	50                   	push   %eax
80103058:	68 64 7a 10 80       	push   $0x80107a64
8010305d:	e8 7e d6 ff ff       	call   801006e0 <cprintf>
  idtinit();       // load idt register
80103062:	e8 e9 2b 00 00       	call   80105c50 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103067:	e8 f4 08 00 00       	call   80103960 <mycpu>
8010306c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010306e:	b8 01 00 00 00       	mov    $0x1,%eax
80103073:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010307a:	e8 61 0e 00 00       	call   80103ee0 <scheduler>
8010307f:	90                   	nop

80103080 <mpenter>:
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103086:	e8 c5 3c 00 00       	call   80106d50 <switchkvm>
  seginit();
8010308b:	e8 30 3c 00 00       	call   80106cc0 <seginit>
  lapicinit();
80103090:	e8 9b f7 ff ff       	call   80102830 <lapicinit>
  mpmain();
80103095:	e8 a6 ff ff ff       	call   80103040 <mpmain>
8010309a:	66 90                	xchg   %ax,%ax
8010309c:	66 90                	xchg   %ax,%ax
8010309e:	66 90                	xchg   %ax,%ax

801030a0 <main>:
{
801030a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030a4:	83 e4 f0             	and    $0xfffffff0,%esp
801030a7:	ff 71 fc             	pushl  -0x4(%ecx)
801030aa:	55                   	push   %ebp
801030ab:	89 e5                	mov    %esp,%ebp
801030ad:	53                   	push   %ebx
801030ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030af:	83 ec 08             	sub    $0x8,%esp
801030b2:	68 00 00 40 80       	push   $0x80400000
801030b7:	68 28 67 11 80       	push   $0x80116728
801030bc:	e8 2f f5 ff ff       	call   801025f0 <kinit1>
  kvmalloc();      // kernel page table
801030c1:	e8 7a 42 00 00       	call   80107340 <kvmalloc>
  mpinit();        // detect other processors
801030c6:	e8 75 01 00 00       	call   80103240 <mpinit>
  lapicinit();     // interrupt controller
801030cb:	e8 60 f7 ff ff       	call   80102830 <lapicinit>
  seginit();       // segment descriptors
801030d0:	e8 eb 3b 00 00       	call   80106cc0 <seginit>
  picinit();       // disable pic
801030d5:	e8 46 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030da:	e8 41 f3 ff ff       	call   80102420 <ioapicinit>
  consoleinit();   // console hardware
801030df:	e8 6c da ff ff       	call   80100b50 <consoleinit>
  uartinit();      // serial port
801030e4:	e8 a7 2e 00 00       	call   80105f90 <uartinit>
  pinit();         // process table
801030e9:	e8 52 08 00 00       	call   80103940 <pinit>
  tvinit();        // trap vectors
801030ee:	e8 dd 2a 00 00       	call   80105bd0 <tvinit>
  binit();         // buffer cache
801030f3:	e8 48 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030f8:	e8 53 de ff ff       	call   80100f50 <fileinit>
  ideinit();       // disk 
801030fd:	e8 fe f0 ff ff       	call   80102200 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103102:	83 c4 0c             	add    $0xc,%esp
80103105:	68 8a 00 00 00       	push   $0x8a
8010310a:	68 8c a4 10 80       	push   $0x8010a48c
8010310f:	68 00 70 00 80       	push   $0x80007000
80103114:	e8 87 18 00 00       	call   801049a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103119:	69 05 60 2d 11 80 b0 	imul   $0xb0,0x80112d60,%eax
80103120:	00 00 00 
80103123:	83 c4 10             	add    $0x10,%esp
80103126:	05 e0 27 11 80       	add    $0x801127e0,%eax
8010312b:	3d e0 27 11 80       	cmp    $0x801127e0,%eax
80103130:	76 71                	jbe    801031a3 <main+0x103>
80103132:	bb e0 27 11 80       	mov    $0x801127e0,%ebx
80103137:	89 f6                	mov    %esi,%esi
80103139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103140:	e8 1b 08 00 00       	call   80103960 <mycpu>
80103145:	39 d8                	cmp    %ebx,%eax
80103147:	74 41                	je     8010318a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103149:	e8 72 f5 ff ff       	call   801026c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010314e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103153:	c7 05 f8 6f 00 80 80 	movl   $0x80103080,0x80006ff8
8010315a:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010315d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103164:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103167:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010316c:	0f b6 03             	movzbl (%ebx),%eax
8010316f:	83 ec 08             	sub    $0x8,%esp
80103172:	68 00 70 00 00       	push   $0x7000
80103177:	50                   	push   %eax
80103178:	e8 03 f8 ff ff       	call   80102980 <lapicstartap>
8010317d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103180:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103186:	85 c0                	test   %eax,%eax
80103188:	74 f6                	je     80103180 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010318a:	69 05 60 2d 11 80 b0 	imul   $0xb0,0x80112d60,%eax
80103191:	00 00 00 
80103194:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010319a:	05 e0 27 11 80       	add    $0x801127e0,%eax
8010319f:	39 c3                	cmp    %eax,%ebx
801031a1:	72 9d                	jb     80103140 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031a3:	83 ec 08             	sub    $0x8,%esp
801031a6:	68 00 00 00 8e       	push   $0x8e000000
801031ab:	68 00 00 40 80       	push   $0x80400000
801031b0:	e8 ab f4 ff ff       	call   80102660 <kinit2>
  userinit();      // first user process
801031b5:	e8 66 09 00 00       	call   80103b20 <userinit>
  mpmain();        // finish this processor's setup
801031ba:	e8 81 fe ff ff       	call   80103040 <mpmain>
801031bf:	90                   	nop

801031c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	57                   	push   %edi
801031c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031cb:	53                   	push   %ebx
  e = addr+len;
801031cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031d2:	39 de                	cmp    %ebx,%esi
801031d4:	72 10                	jb     801031e6 <mpsearch1+0x26>
801031d6:	eb 50                	jmp    80103228 <mpsearch1+0x68>
801031d8:	90                   	nop
801031d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031e0:	39 fb                	cmp    %edi,%ebx
801031e2:	89 fe                	mov    %edi,%esi
801031e4:	76 42                	jbe    80103228 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e6:	83 ec 04             	sub    $0x4,%esp
801031e9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ec:	6a 04                	push   $0x4
801031ee:	68 78 7a 10 80       	push   $0x80107a78
801031f3:	56                   	push   %esi
801031f4:	e8 47 17 00 00       	call   80104940 <memcmp>
801031f9:	83 c4 10             	add    $0x10,%esp
801031fc:	85 c0                	test   %eax,%eax
801031fe:	75 e0                	jne    801031e0 <mpsearch1+0x20>
80103200:	89 f1                	mov    %esi,%ecx
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103208:	0f b6 11             	movzbl (%ecx),%edx
8010320b:	83 c1 01             	add    $0x1,%ecx
8010320e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103210:	39 f9                	cmp    %edi,%ecx
80103212:	75 f4                	jne    80103208 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103214:	84 c0                	test   %al,%al
80103216:	75 c8                	jne    801031e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010321b:	89 f0                	mov    %esi,%eax
8010321d:	5b                   	pop    %ebx
8010321e:	5e                   	pop    %esi
8010321f:	5f                   	pop    %edi
80103220:	5d                   	pop    %ebp
80103221:	c3                   	ret    
80103222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010322b:	31 f6                	xor    %esi,%esi
}
8010322d:	89 f0                	mov    %esi,%eax
8010322f:	5b                   	pop    %ebx
80103230:	5e                   	pop    %esi
80103231:	5f                   	pop    %edi
80103232:	5d                   	pop    %ebp
80103233:	c3                   	ret    
80103234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010323a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103240 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103249:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103250:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103257:	c1 e0 08             	shl    $0x8,%eax
8010325a:	09 d0                	or     %edx,%eax
8010325c:	c1 e0 04             	shl    $0x4,%eax
8010325f:	85 c0                	test   %eax,%eax
80103261:	75 1b                	jne    8010327e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103263:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010326a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103271:	c1 e0 08             	shl    $0x8,%eax
80103274:	09 d0                	or     %edx,%eax
80103276:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103279:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010327e:	ba 00 04 00 00       	mov    $0x400,%edx
80103283:	e8 38 ff ff ff       	call   801031c0 <mpsearch1>
80103288:	85 c0                	test   %eax,%eax
8010328a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010328d:	0f 84 3d 01 00 00    	je     801033d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103296:	8b 58 04             	mov    0x4(%eax),%ebx
80103299:	85 db                	test   %ebx,%ebx
8010329b:	0f 84 4f 01 00 00    	je     801033f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801032a7:	83 ec 04             	sub    $0x4,%esp
801032aa:	6a 04                	push   $0x4
801032ac:	68 95 7a 10 80       	push   $0x80107a95
801032b1:	56                   	push   %esi
801032b2:	e8 89 16 00 00       	call   80104940 <memcmp>
801032b7:	83 c4 10             	add    $0x10,%esp
801032ba:	85 c0                	test   %eax,%eax
801032bc:	0f 85 2e 01 00 00    	jne    801033f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801032c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032c9:	3c 01                	cmp    $0x1,%al
801032cb:	0f 95 c2             	setne  %dl
801032ce:	3c 04                	cmp    $0x4,%al
801032d0:	0f 95 c0             	setne  %al
801032d3:	20 c2                	and    %al,%dl
801032d5:	0f 85 15 01 00 00    	jne    801033f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801032db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801032e2:	66 85 ff             	test   %di,%di
801032e5:	74 1a                	je     80103301 <mpinit+0xc1>
801032e7:	89 f0                	mov    %esi,%eax
801032e9:	01 f7                	add    %esi,%edi
  sum = 0;
801032eb:	31 d2                	xor    %edx,%edx
801032ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032f0:	0f b6 08             	movzbl (%eax),%ecx
801032f3:	83 c0 01             	add    $0x1,%eax
801032f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032f8:	39 c7                	cmp    %eax,%edi
801032fa:	75 f4                	jne    801032f0 <mpinit+0xb0>
801032fc:	84 d2                	test   %dl,%dl
801032fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103301:	85 f6                	test   %esi,%esi
80103303:	0f 84 e7 00 00 00    	je     801033f0 <mpinit+0x1b0>
80103309:	84 d2                	test   %dl,%dl
8010330b:	0f 85 df 00 00 00    	jne    801033f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103311:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103317:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010331c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103323:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103329:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010332e:	01 d6                	add    %edx,%esi
80103330:	39 c6                	cmp    %eax,%esi
80103332:	76 23                	jbe    80103357 <mpinit+0x117>
    switch(*p){
80103334:	0f b6 10             	movzbl (%eax),%edx
80103337:	80 fa 04             	cmp    $0x4,%dl
8010333a:	0f 87 ca 00 00 00    	ja     8010340a <mpinit+0x1ca>
80103340:	ff 24 95 bc 7a 10 80 	jmp    *-0x7fef8544(,%edx,4)
80103347:	89 f6                	mov    %esi,%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103350:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103353:	39 c6                	cmp    %eax,%esi
80103355:	77 dd                	ja     80103334 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103357:	85 db                	test   %ebx,%ebx
80103359:	0f 84 9e 00 00 00    	je     801033fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010335f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103362:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103366:	74 15                	je     8010337d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103368:	b8 70 00 00 00       	mov    $0x70,%eax
8010336d:	ba 22 00 00 00       	mov    $0x22,%edx
80103372:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103373:	ba 23 00 00 00       	mov    $0x23,%edx
80103378:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103379:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010337c:	ee                   	out    %al,(%dx)
  }
}
8010337d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103380:	5b                   	pop    %ebx
80103381:	5e                   	pop    %esi
80103382:	5f                   	pop    %edi
80103383:	5d                   	pop    %ebp
80103384:	c3                   	ret    
80103385:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103388:	8b 0d 60 2d 11 80    	mov    0x80112d60,%ecx
8010338e:	83 f9 07             	cmp    $0x7,%ecx
80103391:	7f 19                	jg     801033ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103393:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103397:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010339d:	83 c1 01             	add    $0x1,%ecx
801033a0:	89 0d 60 2d 11 80    	mov    %ecx,0x80112d60
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033a6:	88 97 e0 27 11 80    	mov    %dl,-0x7feed820(%edi)
      p += sizeof(struct mpproc);
801033ac:	83 c0 14             	add    $0x14,%eax
      continue;
801033af:	e9 7c ff ff ff       	jmp    80103330 <mpinit+0xf0>
801033b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801033bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033bf:	88 15 c0 27 11 80    	mov    %dl,0x801127c0
      continue;
801033c5:	e9 66 ff ff ff       	jmp    80103330 <mpinit+0xf0>
801033ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801033d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033da:	e8 e1 fd ff ff       	call   801031c0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801033e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033e4:	0f 85 a9 fe ff ff    	jne    80103293 <mpinit+0x53>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033f0:	83 ec 0c             	sub    $0xc,%esp
801033f3:	68 7d 7a 10 80       	push   $0x80107a7d
801033f8:	e8 93 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033fd:	83 ec 0c             	sub    $0xc,%esp
80103400:	68 9c 7a 10 80       	push   $0x80107a9c
80103405:	e8 86 cf ff ff       	call   80100390 <panic>
      ismp = 0;
8010340a:	31 db                	xor    %ebx,%ebx
8010340c:	e9 26 ff ff ff       	jmp    80103337 <mpinit+0xf7>
80103411:	66 90                	xchg   %ax,%ax
80103413:	66 90                	xchg   %ax,%ax
80103415:	66 90                	xchg   %ax,%ax
80103417:	66 90                	xchg   %ax,%ax
80103419:	66 90                	xchg   %ax,%ax
8010341b:	66 90                	xchg   %ax,%ax
8010341d:	66 90                	xchg   %ax,%ax
8010341f:	90                   	nop

80103420 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103420:	55                   	push   %ebp
80103421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103426:	ba 21 00 00 00       	mov    $0x21,%edx
8010342b:	89 e5                	mov    %esp,%ebp
8010342d:	ee                   	out    %al,(%dx)
8010342e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103433:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103434:	5d                   	pop    %ebp
80103435:	c3                   	ret    
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010344c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103455:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 10 db ff ff       	call   80100f70 <filealloc>
80103460:	85 c0                	test   %eax,%eax
80103462:	89 03                	mov    %eax,(%ebx)
80103464:	74 22                	je     80103488 <pipealloc+0x48>
80103466:	e8 05 db ff ff       	call   80100f70 <filealloc>
8010346b:	85 c0                	test   %eax,%eax
8010346d:	89 06                	mov    %eax,(%esi)
8010346f:	74 3f                	je     801034b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103471:	e8 4a f2 ff ff       	call   801026c0 <kalloc>
80103476:	85 c0                	test   %eax,%eax
80103478:	89 c7                	mov    %eax,%edi
8010347a:	75 54                	jne    801034d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010347c:	8b 03                	mov    (%ebx),%eax
8010347e:	85 c0                	test   %eax,%eax
80103480:	75 34                	jne    801034b6 <pipealloc+0x76>
80103482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103488:	8b 06                	mov    (%esi),%eax
8010348a:	85 c0                	test   %eax,%eax
8010348c:	74 0c                	je     8010349a <pipealloc+0x5a>
    fileclose(*f1);
8010348e:	83 ec 0c             	sub    $0xc,%esp
80103491:	50                   	push   %eax
80103492:	e8 99 db ff ff       	call   80101030 <fileclose>
80103497:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010349a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010349d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034a2:	5b                   	pop    %ebx
801034a3:	5e                   	pop    %esi
801034a4:	5f                   	pop    %edi
801034a5:	5d                   	pop    %ebp
801034a6:	c3                   	ret    
801034a7:	89 f6                	mov    %esi,%esi
801034a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801034b0:	8b 03                	mov    (%ebx),%eax
801034b2:	85 c0                	test   %eax,%eax
801034b4:	74 e4                	je     8010349a <pipealloc+0x5a>
    fileclose(*f0);
801034b6:	83 ec 0c             	sub    $0xc,%esp
801034b9:	50                   	push   %eax
801034ba:	e8 71 db ff ff       	call   80101030 <fileclose>
  if(*f1)
801034bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801034c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034c4:	85 c0                	test   %eax,%eax
801034c6:	75 c6                	jne    8010348e <pipealloc+0x4e>
801034c8:	eb d0                	jmp    8010349a <pipealloc+0x5a>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801034d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801034d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034da:	00 00 00 
  p->writeopen = 1;
801034dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034e4:	00 00 00 
  p->nwrite = 0;
801034e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034ee:	00 00 00 
  p->nread = 0;
801034f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034f8:	00 00 00 
  initlock(&p->lock, "pipe");
801034fb:	68 d0 7a 10 80       	push   $0x80107ad0
80103500:	50                   	push   %eax
80103501:	e8 7a 11 00 00       	call   80104680 <initlock>
  (*f0)->type = FD_PIPE;
80103506:	8b 03                	mov    (%ebx),%eax
  return 0;
80103508:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010350b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103511:	8b 03                	mov    (%ebx),%eax
80103513:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103517:	8b 03                	mov    (%ebx),%eax
80103519:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010351d:	8b 03                	mov    (%ebx),%eax
8010351f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103522:	8b 06                	mov    (%esi),%eax
80103524:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010352a:	8b 06                	mov    (%esi),%eax
8010352c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103530:	8b 06                	mov    (%esi),%eax
80103532:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103536:	8b 06                	mov    (%esi),%eax
80103538:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010353b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010353e:	31 c0                	xor    %eax,%eax
}
80103540:	5b                   	pop    %ebx
80103541:	5e                   	pop    %esi
80103542:	5f                   	pop    %edi
80103543:	5d                   	pop    %ebp
80103544:	c3                   	ret    
80103545:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103550 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103558:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	53                   	push   %ebx
8010355f:	e8 0c 12 00 00       	call   80104770 <acquire>
  if(writable){
80103564:	83 c4 10             	add    $0x10,%esp
80103567:	85 f6                	test   %esi,%esi
80103569:	74 45                	je     801035b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010356b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103571:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103574:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010357b:	00 00 00 
    wakeup(&p->nread);
8010357e:	50                   	push   %eax
8010357f:	e8 6c 0e 00 00       	call   801043f0 <wakeup>
80103584:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103587:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010358d:	85 d2                	test   %edx,%edx
8010358f:	75 0a                	jne    8010359b <pipeclose+0x4b>
80103591:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103597:	85 c0                	test   %eax,%eax
80103599:	74 35                	je     801035d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010359b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010359e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a1:	5b                   	pop    %ebx
801035a2:	5e                   	pop    %esi
801035a3:	5d                   	pop    %ebp
    release(&p->lock);
801035a4:	e9 e7 12 00 00       	jmp    80104890 <release>
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801035b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 27 0e 00 00       	call   801043f0 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb b9                	jmp    80103587 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	53                   	push   %ebx
801035d4:	e8 b7 12 00 00       	call   80104890 <release>
    kfree((char*)p);
801035d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035dc:	83 c4 10             	add    $0x10,%esp
}
801035df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e2:	5b                   	pop    %ebx
801035e3:	5e                   	pop    %esi
801035e4:	5d                   	pop    %ebp
    kfree((char*)p);
801035e5:	e9 26 ef ff ff       	jmp    80102510 <kfree>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 28             	sub    $0x28,%esp
801035f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035fc:	53                   	push   %ebx
801035fd:	e8 6e 11 00 00       	call   80104770 <acquire>
  for(i = 0; i < n; i++){
80103602:	8b 45 10             	mov    0x10(%ebp),%eax
80103605:	83 c4 10             	add    $0x10,%esp
80103608:	85 c0                	test   %eax,%eax
8010360a:	0f 8e c9 00 00 00    	jle    801036d9 <pipewrite+0xe9>
80103610:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103613:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103619:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010361f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103622:	03 4d 10             	add    0x10(%ebp),%ecx
80103625:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103628:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010362e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103634:	39 d0                	cmp    %edx,%eax
80103636:	75 71                	jne    801036a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103638:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010363e:	85 c0                	test   %eax,%eax
80103640:	74 4e                	je     80103690 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103642:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103648:	eb 3a                	jmp    80103684 <pipewrite+0x94>
8010364a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	57                   	push   %edi
80103654:	e8 97 0d 00 00       	call   801043f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103659:	5a                   	pop    %edx
8010365a:	59                   	pop    %ecx
8010365b:	53                   	push   %ebx
8010365c:	56                   	push   %esi
8010365d:	e8 be 0b 00 00       	call   80104220 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103662:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103668:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010366e:	83 c4 10             	add    $0x10,%esp
80103671:	05 00 02 00 00       	add    $0x200,%eax
80103676:	39 c2                	cmp    %eax,%edx
80103678:	75 36                	jne    801036b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010367a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103680:	85 c0                	test   %eax,%eax
80103682:	74 0c                	je     80103690 <pipewrite+0xa0>
80103684:	e8 77 03 00 00       	call   80103a00 <myproc>
80103689:	8b 40 24             	mov    0x24(%eax),%eax
8010368c:	85 c0                	test   %eax,%eax
8010368e:	74 c0                	je     80103650 <pipewrite+0x60>
        release(&p->lock);
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	53                   	push   %ebx
80103694:	e8 f7 11 00 00       	call   80104890 <release>
        return -1;
80103699:	83 c4 10             	add    $0x10,%esp
8010369c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036a4:	5b                   	pop    %ebx
801036a5:	5e                   	pop    %esi
801036a6:	5f                   	pop    %edi
801036a7:	5d                   	pop    %ebp
801036a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a9:	89 c2                	mov    %eax,%edx
801036ab:	90                   	nop
801036ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036b3:	8d 42 01             	lea    0x1(%edx),%eax
801036b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036c2:	83 c6 01             	add    $0x1,%esi
801036c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801036c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036d3:	0f 85 4f ff ff ff    	jne    80103628 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036df:	83 ec 0c             	sub    $0xc,%esp
801036e2:	50                   	push   %eax
801036e3:	e8 08 0d 00 00       	call   801043f0 <wakeup>
  release(&p->lock);
801036e8:	89 1c 24             	mov    %ebx,(%esp)
801036eb:	e8 a0 11 00 00       	call   80104890 <release>
  return n;
801036f0:	83 c4 10             	add    $0x10,%esp
801036f3:	8b 45 10             	mov    0x10(%ebp),%eax
801036f6:	eb a9                	jmp    801036a1 <pipewrite+0xb1>
801036f8:	90                   	nop
801036f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103700 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	57                   	push   %edi
80103704:	56                   	push   %esi
80103705:	53                   	push   %ebx
80103706:	83 ec 18             	sub    $0x18,%esp
80103709:	8b 75 08             	mov    0x8(%ebp),%esi
8010370c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010370f:	56                   	push   %esi
80103710:	e8 5b 10 00 00       	call   80104770 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010371e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103724:	75 6a                	jne    80103790 <piperead+0x90>
80103726:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010372c:	85 db                	test   %ebx,%ebx
8010372e:	0f 84 c4 00 00 00    	je     801037f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103734:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010373a:	eb 2d                	jmp    80103769 <piperead+0x69>
8010373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103740:	83 ec 08             	sub    $0x8,%esp
80103743:	56                   	push   %esi
80103744:	53                   	push   %ebx
80103745:	e8 d6 0a 00 00       	call   80104220 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010374a:	83 c4 10             	add    $0x10,%esp
8010374d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103753:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103759:	75 35                	jne    80103790 <piperead+0x90>
8010375b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103761:	85 d2                	test   %edx,%edx
80103763:	0f 84 8f 00 00 00    	je     801037f8 <piperead+0xf8>
    if(myproc()->killed){
80103769:	e8 92 02 00 00       	call   80103a00 <myproc>
8010376e:	8b 48 24             	mov    0x24(%eax),%ecx
80103771:	85 c9                	test   %ecx,%ecx
80103773:	74 cb                	je     80103740 <piperead+0x40>
      release(&p->lock);
80103775:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103778:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010377d:	56                   	push   %esi
8010377e:	e8 0d 11 00 00       	call   80104890 <release>
      return -1;
80103783:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103790:	8b 45 10             	mov    0x10(%ebp),%eax
80103793:	85 c0                	test   %eax,%eax
80103795:	7e 61                	jle    801037f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103797:	31 db                	xor    %ebx,%ebx
80103799:	eb 13                	jmp    801037ae <piperead+0xae>
8010379b:	90                   	nop
8010379c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037ac:	74 1f                	je     801037cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037ae:	8d 41 01             	lea    0x1(%ecx),%eax
801037b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801037b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801037bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801037c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037c5:	83 c3 01             	add    $0x1,%ebx
801037c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037cb:	75 d3                	jne    801037a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037d3:	83 ec 0c             	sub    $0xc,%esp
801037d6:	50                   	push   %eax
801037d7:	e8 14 0c 00 00       	call   801043f0 <wakeup>
  release(&p->lock);
801037dc:	89 34 24             	mov    %esi,(%esp)
801037df:	e8 ac 10 00 00       	call   80104890 <release>
  return i;
801037e4:	83 c4 10             	add    $0x10,%esp
}
801037e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037ea:	89 d8                	mov    %ebx,%eax
801037ec:	5b                   	pop    %ebx
801037ed:	5e                   	pop    %esi
801037ee:	5f                   	pop    %edi
801037ef:	5d                   	pop    %ebp
801037f0:	c3                   	ret    
801037f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037f8:	31 db                	xor    %ebx,%ebx
801037fa:	eb d1                	jmp    801037cd <piperead+0xcd>
801037fc:	66 90                	xchg   %ax,%ax
801037fe:	66 90                	xchg   %ax,%ax

80103800 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103804:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
{
80103809:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010380c:	68 80 2d 11 80       	push   $0x80112d80
80103811:	e8 5a 0f 00 00       	call   80104770 <acquire>
80103816:	83 c4 10             	add    $0x10,%esp
80103819:	eb 17                	jmp    80103832 <allocproc+0x32>
8010381b:	90                   	nop
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103820:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
80103826:	81 fb b4 5e 11 80    	cmp    $0x80115eb4,%ebx
8010382c:	0f 83 8e 00 00 00    	jae    801038c0 <allocproc+0xc0>
    if(p->state == UNUSED)
80103832:	8b 43 0c             	mov    0xc(%ebx),%eax
80103835:	85 c0                	test   %eax,%eax
80103837:	75 e7                	jne    80103820 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103839:	a1 04 a0 10 80       	mov    0x8010a004,%eax


  release(&ptable.lock);
8010383e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103841:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103848:	8d 50 01             	lea    0x1(%eax),%edx
8010384b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010384e:	68 80 2d 11 80       	push   $0x80112d80
  p->pid = nextpid++;
80103853:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103859:	e8 32 10 00 00       	call   80104890 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010385e:	e8 5d ee ff ff       	call   801026c0 <kalloc>
80103863:	83 c4 10             	add    $0x10,%esp
80103866:	85 c0                	test   %eax,%eax
80103868:	89 43 08             	mov    %eax,0x8(%ebx)
8010386b:	74 6c                	je     801038d9 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010386d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103873:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103876:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010387b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010387e:	c7 40 14 bf 5b 10 80 	movl   $0x80105bbf,0x14(%eax)
  p->context = (struct context*)sp;
80103885:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103888:	6a 14                	push   $0x14
8010388a:	6a 00                	push   $0x0
8010388c:	50                   	push   %eax
8010388d:	e8 5e 10 00 00       	call   801048f0 <memset>
  p->context->eip = (uint)forkret;
80103892:	8b 43 1c             	mov    0x1c(%ebx),%eax

  //brand new
  p->priority=NPROCQ-1;
  p->wdidx=0;

  return p;
80103895:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103898:	c7 40 10 f0 38 10 80 	movl   $0x801038f0,0x10(%eax)
  p->priority=NPROCQ-1;
8010389f:	c7 83 80 00 00 00 02 	movl   $0x2,0x80(%ebx)
801038a6:	00 00 00 
  p->wdidx=0;
801038a9:	c7 83 c0 00 00 00 00 	movl   $0x0,0xc0(%ebx)
801038b0:	00 00 00 
}
801038b3:	89 d8                	mov    %ebx,%eax
801038b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b8:	c9                   	leave  
801038b9:	c3                   	ret    
801038ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801038c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038c3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038c5:	68 80 2d 11 80       	push   $0x80112d80
801038ca:	e8 c1 0f 00 00       	call   80104890 <release>
}
801038cf:	89 d8                	mov    %ebx,%eax
  return 0;
801038d1:	83 c4 10             	add    $0x10,%esp
}
801038d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d7:	c9                   	leave  
801038d8:	c3                   	ret    
    p->state = UNUSED;
801038d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038e0:	31 db                	xor    %ebx,%ebx
801038e2:	eb cf                	jmp    801038b3 <allocproc+0xb3>
801038e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038f6:	68 80 2d 11 80       	push   $0x80112d80
801038fb:	e8 90 0f 00 00       	call   80104890 <release>

  if (first) {
80103900:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	85 c0                	test   %eax,%eax
8010390a:	75 04                	jne    80103910 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010390c:	c9                   	leave  
8010390d:	c3                   	ret    
8010390e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103910:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103913:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010391a:	00 00 00 
    iinit(ROOTDEV);
8010391d:	6a 01                	push   $0x1
8010391f:	e8 5c dd ff ff       	call   80101680 <iinit>
    initlog(ROOTDEV);
80103924:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010392b:	e8 d0 f3 ff ff       	call   80102d00 <initlog>
80103930:	83 c4 10             	add    $0x10,%esp
}
80103933:	c9                   	leave  
80103934:	c3                   	ret    
80103935:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103940 <pinit>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103946:	68 d5 7a 10 80       	push   $0x80107ad5
8010394b:	68 80 2d 11 80       	push   $0x80112d80
80103950:	e8 2b 0d 00 00       	call   80104680 <initlock>
}
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	c9                   	leave  
80103959:	c3                   	ret    
8010395a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103960 <mycpu>:
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	56                   	push   %esi
80103964:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103965:	9c                   	pushf  
80103966:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103967:	f6 c4 02             	test   $0x2,%ah
8010396a:	75 5e                	jne    801039ca <mycpu+0x6a>
  apicid = lapicid();
8010396c:	e8 bf ef ff ff       	call   80102930 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103971:	8b 35 60 2d 11 80    	mov    0x80112d60,%esi
80103977:	85 f6                	test   %esi,%esi
80103979:	7e 42                	jle    801039bd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010397b:	0f b6 15 e0 27 11 80 	movzbl 0x801127e0,%edx
80103982:	39 d0                	cmp    %edx,%eax
80103984:	74 30                	je     801039b6 <mycpu+0x56>
80103986:	b9 90 28 11 80       	mov    $0x80112890,%ecx
  for (i = 0; i < ncpu; ++i) {
8010398b:	31 d2                	xor    %edx,%edx
8010398d:	8d 76 00             	lea    0x0(%esi),%esi
80103990:	83 c2 01             	add    $0x1,%edx
80103993:	39 f2                	cmp    %esi,%edx
80103995:	74 26                	je     801039bd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103997:	0f b6 19             	movzbl (%ecx),%ebx
8010399a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801039a0:	39 c3                	cmp    %eax,%ebx
801039a2:	75 ec                	jne    80103990 <mycpu+0x30>
801039a4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801039aa:	05 e0 27 11 80       	add    $0x801127e0,%eax
}
801039af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039b2:	5b                   	pop    %ebx
801039b3:	5e                   	pop    %esi
801039b4:	5d                   	pop    %ebp
801039b5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801039b6:	b8 e0 27 11 80       	mov    $0x801127e0,%eax
      return &cpus[i];
801039bb:	eb f2                	jmp    801039af <mycpu+0x4f>
  panic("unknown apicid\n");
801039bd:	83 ec 0c             	sub    $0xc,%esp
801039c0:	68 dc 7a 10 80       	push   $0x80107adc
801039c5:	e8 c6 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801039ca:	83 ec 0c             	sub    $0xc,%esp
801039cd:	68 b8 7b 10 80       	push   $0x80107bb8
801039d2:	e8 b9 c9 ff ff       	call   80100390 <panic>
801039d7:	89 f6                	mov    %esi,%esi
801039d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039e0 <cpuid>:
cpuid() {
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039e6:	e8 75 ff ff ff       	call   80103960 <mycpu>
801039eb:	2d e0 27 11 80       	sub    $0x801127e0,%eax
}
801039f0:	c9                   	leave  
  return mycpu()-cpus;
801039f1:	c1 f8 04             	sar    $0x4,%eax
801039f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039fa:	c3                   	ret    
801039fb:	90                   	nop
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a00 <myproc>:
myproc(void) {
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	53                   	push   %ebx
80103a04:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a07:	e8 24 0d 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103a0c:	e8 4f ff ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103a11:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a17:	e8 14 0e 00 00       	call   80104830 <popcli>
}
80103a1c:	83 c4 04             	add    $0x4,%esp
80103a1f:	89 d8                	mov    %ebx,%eax
80103a21:	5b                   	pop    %ebx
80103a22:	5d                   	pop    %ebp
80103a23:	c3                   	ret    
80103a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a30 <qpush>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	53                   	push   %ebx
80103a34:	8b 45 08             	mov    0x8(%ebp),%eax
  if(ptable.count[np->priority]<=0)
80103a37:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103a3d:	8b 0c 95 cc 5e 11 80 	mov    -0x7feea134(,%edx,4),%ecx
80103a44:	85 c9                	test   %ecx,%ecx
80103a46:	74 50                	je     80103a98 <qpush+0x68>
    np->next=ptable.pqueue[np->priority].head;
80103a48:	81 c2 26 06 00 00    	add    $0x626,%edx
80103a4e:	8b 0c d5 84 2d 11 80 	mov    -0x7feed27c(,%edx,8),%ecx
80103a55:	89 48 7c             	mov    %ecx,0x7c(%eax)
    ptable.pqueue[np->priority].last->next=np;
80103a58:	8b 14 d5 88 2d 11 80 	mov    -0x7feed278(,%edx,8),%edx
80103a5f:	89 42 7c             	mov    %eax,0x7c(%edx)
    ptable.pqueue[np->priority].last=np;
80103a62:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103a68:	89 04 d5 b8 5e 11 80 	mov    %eax,-0x7feea148(,%edx,8)
  np->timepiece=(1<<(NPROCQ-np->priority-1));
80103a6f:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103a75:	b9 02 00 00 00       	mov    $0x2,%ecx
80103a7a:	bb 01 00 00 00       	mov    $0x1,%ebx
80103a7f:	29 d1                	sub    %edx,%ecx
80103a81:	d3 e3                	shl    %cl,%ebx
80103a83:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
  ptable.count[np->priority]++;
80103a89:	83 04 95 cc 5e 11 80 	addl   $0x1,-0x7feea134(,%edx,4)
80103a90:	01 
}
80103a91:	5b                   	pop    %ebx
80103a92:	5d                   	pop    %ebp
80103a93:	c3                   	ret    
80103a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->next=np;
80103a98:	89 40 7c             	mov    %eax,0x7c(%eax)
    ptable.pqueue[np->priority].head=np;
80103a9b:	89 04 d5 b4 5e 11 80 	mov    %eax,-0x7feea14c(,%edx,8)
    ptable.pqueue[np->priority].last=np;
80103aa2:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103aa8:	89 04 d5 b8 5e 11 80 	mov    %eax,-0x7feea148(,%edx,8)
80103aaf:	eb be                	jmp    80103a6f <qpush+0x3f>
80103ab1:	eb 0d                	jmp    80103ac0 <wakeup1>
80103ab3:	90                   	nop
80103ab4:	90                   	nop
80103ab5:	90                   	nop
80103ab6:	90                   	nop
80103ab7:	90                   	nop
80103ab8:	90                   	nop
80103ab9:	90                   	nop
80103aba:	90                   	nop
80103abb:	90                   	nop
80103abc:	90                   	nop
80103abd:	90                   	nop
80103abe:	90                   	nop
80103abf:	90                   	nop

80103ac0 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	89 c6                	mov    %eax,%esi
80103ac6:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ac7:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
80103acc:	eb 10                	jmp    80103ade <wakeup1+0x1e>
80103ace:	66 90                	xchg   %ax,%ax
80103ad0:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
80103ad6:	81 fb b4 5e 11 80    	cmp    $0x80115eb4,%ebx
80103adc:	73 3b                	jae    80103b19 <wakeup1+0x59>
    if(p->state == SLEEPING && p->chan == chan)
80103ade:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103ae2:	75 ec                	jne    80103ad0 <wakeup1+0x10>
80103ae4:	39 73 20             	cmp    %esi,0x20(%ebx)
80103ae7:	75 e7                	jne    80103ad0 <wakeup1+0x10>
    {
      p->state = RUNNABLE;

      //brand new
      if(p->priority<NPROCQ-1)
80103ae9:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
      p->state = RUNNABLE;
80103aef:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      if(p->priority<NPROCQ-1)
80103af6:	83 f8 01             	cmp    $0x1,%eax
80103af9:	77 09                	ja     80103b04 <wakeup1+0x44>
        p->priority++;
80103afb:	83 c0 01             	add    $0x1,%eax
80103afe:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
      qpush(p);
80103b04:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b05:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
      qpush(p);
80103b0b:	e8 20 ff ff ff       	call   80103a30 <qpush>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b10:	81 fb b4 5e 11 80    	cmp    $0x80115eb4,%ebx
      qpush(p);
80103b16:	58                   	pop    %eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b17:	72 c5                	jb     80103ade <wakeup1+0x1e>

    }
}
80103b19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b1c:	5b                   	pop    %ebx
80103b1d:	5e                   	pop    %esi
80103b1e:	5d                   	pop    %ebp
80103b1f:	c3                   	ret    

80103b20 <userinit>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	53                   	push   %ebx
80103b24:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b27:	e8 d4 fc ff ff       	call   80103800 <allocproc>
80103b2c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b2e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103b33:	e8 88 37 00 00       	call   801072c0 <setupkvm>
80103b38:	85 c0                	test   %eax,%eax
80103b3a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b3d:	0f 84 c5 00 00 00    	je     80103c08 <userinit+0xe8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b43:	83 ec 04             	sub    $0x4,%esp
80103b46:	68 2c 00 00 00       	push   $0x2c
80103b4b:	68 60 a4 10 80       	push   $0x8010a460
80103b50:	50                   	push   %eax
80103b51:	e8 2a 33 00 00       	call   80106e80 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b56:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b59:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b5f:	6a 4c                	push   $0x4c
80103b61:	6a 00                	push   $0x0
80103b63:	ff 73 18             	pushl  0x18(%ebx)
80103b66:	e8 85 0d 00 00       	call   801048f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b6b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b6e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b73:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b78:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b7b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b7f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b82:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b86:	8b 43 18             	mov    0x18(%ebx),%eax
80103b89:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b8d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b91:	8b 43 18             	mov    0x18(%ebx),%eax
80103b94:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b98:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b9c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b9f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ba6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ba9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103bb0:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bba:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bbd:	6a 10                	push   $0x10
80103bbf:	68 05 7b 10 80       	push   $0x80107b05
80103bc4:	50                   	push   %eax
80103bc5:	e8 06 0f 00 00       	call   80104ad0 <safestrcpy>
  p->cwd = namei("/");
80103bca:	c7 04 24 0e 7b 10 80 	movl   $0x80107b0e,(%esp)
80103bd1:	e8 0a e5 ff ff       	call   801020e0 <namei>
80103bd6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bd9:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103be0:	e8 8b 0b 00 00       	call   80104770 <acquire>
  p->state = RUNNABLE;
80103be5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  qpush(p);
80103bec:	89 1c 24             	mov    %ebx,(%esp)
80103bef:	e8 3c fe ff ff       	call   80103a30 <qpush>
  release(&ptable.lock);
80103bf4:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103bfb:	e8 90 0c 00 00       	call   80104890 <release>
}
80103c00:	83 c4 10             	add    $0x10,%esp
80103c03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c06:	c9                   	leave  
80103c07:	c3                   	ret    
    panic("userinit: out of memory?");
80103c08:	83 ec 0c             	sub    $0xc,%esp
80103c0b:	68 ec 7a 10 80       	push   $0x80107aec
80103c10:	e8 7b c7 ff ff       	call   80100390 <panic>
80103c15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c20 <releaseshared>:
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	56                   	push   %esi
80103c24:	53                   	push   %ebx
80103c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103c28:	e8 03 0b 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103c2d:	e8 2e fd ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103c32:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c38:	e8 f3 0b 00 00       	call   80104830 <popcli>
  if(curproc->sharedrec[idx]!='s')
80103c3d:	80 bc 1e 8c 00 00 00 	cmpb   $0x73,0x8c(%esi,%ebx,1)
80103c44:	73 
80103c45:	74 09                	je     80103c50 <releaseshared+0x30>
}
80103c47:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c4a:	31 c0                	xor    %eax,%eax
80103c4c:	5b                   	pop    %ebx
80103c4d:	5e                   	pop    %esi
80103c4e:	5d                   	pop    %ebp
80103c4f:	c3                   	ret    
  desharevm(idx);
80103c50:	83 ec 0c             	sub    $0xc,%esp
  curproc->sharedrec[idx]=0;
80103c53:	c6 84 1e 8c 00 00 00 	movb   $0x0,0x8c(%esi,%ebx,1)
80103c5a:	00 
  desharevm(idx);
80103c5b:	53                   	push   %ebx
80103c5c:	e8 8f 35 00 00       	call   801071f0 <desharevm>
  return 0;
80103c61:	83 c4 10             	add    $0x10,%esp
}
80103c64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c67:	31 c0                	xor    %eax,%eax
80103c69:	5b                   	pop    %ebx
80103c6a:	5e                   	pop    %esi
80103c6b:	5d                   	pop    %ebp
80103c6c:	c3                   	ret    
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi

80103c70 <getshared>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	57                   	push   %edi
80103c74:	56                   	push   %esi
80103c75:	53                   	push   %ebx
80103c76:	83 ec 0c             	sub    $0xc,%esp
80103c79:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c7c:	e8 af 0a 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103c81:	e8 da fc ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103c86:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c8c:	e8 9f 0b 00 00       	call   80104830 <popcli>
  if(curproc->sharedrec[idx]=='s'){
80103c91:	80 bc 33 8c 00 00 00 	cmpb   $0x73,0x8c(%ebx,%esi,1)
80103c98:	73 
80103c99:	74 55                	je     80103cf0 <getshared+0x80>
  sharevm(curproc->pgdir, idx, curproc->nshared);
80103c9b:	83 ec 04             	sub    $0x4,%esp
80103c9e:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80103ca4:	8d 3c b3             	lea    (%ebx,%esi,4),%edi
80103ca7:	56                   	push   %esi
80103ca8:	ff 73 04             	pushl  0x4(%ebx)
80103cab:	e8 10 33 00 00       	call   80106fc0 <sharevm>
  curproc->nshared++;
80103cb0:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
  curproc->sharedvm[idx]=(char*)KERNBASE-(curproc->nshared)*PGSIZE;
80103cb6:	ba 00 00 00 80       	mov    $0x80000000,%edx
  curproc->nshared++;
80103cbb:	83 c0 01             	add    $0x1,%eax
80103cbe:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  curproc->sharedvm[idx]=(char*)KERNBASE-(curproc->nshared)*PGSIZE;
80103cc4:	c1 e0 0c             	shl    $0xc,%eax
80103cc7:	29 c2                	sub    %eax,%edx
80103cc9:	89 97 98 00 00 00    	mov    %edx,0x98(%edi)
  curproc->sharedrec[idx]='s';
80103ccf:	c6 84 33 8c 00 00 00 	movb   $0x73,0x8c(%ebx,%esi,1)
80103cd6:	73 
  switchuvm(curproc);
80103cd7:	89 1c 24             	mov    %ebx,(%esp)
80103cda:	e8 91 30 00 00       	call   80106d70 <switchuvm>
  return curproc->sharedvm[idx];
80103cdf:	8b 87 98 00 00 00    	mov    0x98(%edi),%eax
80103ce5:	83 c4 10             	add    $0x10,%esp
}
80103ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ceb:	5b                   	pop    %ebx
80103cec:	5e                   	pop    %esi
80103ced:	5f                   	pop    %edi
80103cee:	5d                   	pop    %ebp
80103cef:	c3                   	ret    
    return curproc->sharedvm[idx];
80103cf0:	8b 84 b3 98 00 00 00 	mov    0x98(%ebx,%esi,4),%eax
}
80103cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cfa:	5b                   	pop    %ebx
80103cfb:	5e                   	pop    %esi
80103cfc:	5f                   	pop    %edi
80103cfd:	5d                   	pop    %ebp
80103cfe:	c3                   	ret    
80103cff:	90                   	nop

80103d00 <growproc>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
80103d05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d08:	e8 23 0a 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103d0d:	e8 4e fc ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103d12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d18:	e8 13 0b 00 00       	call   80104830 <popcli>
  if(n > 0){
80103d1d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103d20:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d22:	7f 1c                	jg     80103d40 <growproc+0x40>
  } else if(n < 0){
80103d24:	75 3a                	jne    80103d60 <growproc+0x60>
  switchuvm(curproc);
80103d26:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d29:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d2b:	53                   	push   %ebx
80103d2c:	e8 3f 30 00 00       	call   80106d70 <switchuvm>
  return 0;
80103d31:	83 c4 10             	add    $0x10,%esp
80103d34:	31 c0                	xor    %eax,%eax
}
80103d36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d39:	5b                   	pop    %ebx
80103d3a:	5e                   	pop    %esi
80103d3b:	5d                   	pop    %ebp
80103d3c:	c3                   	ret    
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n,curproc->nshared)) == 0)
80103d40:	01 c6                	add    %eax,%esi
80103d42:	ff b3 88 00 00 00    	pushl  0x88(%ebx)
80103d48:	56                   	push   %esi
80103d49:	50                   	push   %eax
80103d4a:	ff 73 04             	pushl  0x4(%ebx)
80103d4d:	e8 5e 33 00 00       	call   801070b0 <allocuvm>
80103d52:	83 c4 10             	add    $0x10,%esp
80103d55:	85 c0                	test   %eax,%eax
80103d57:	75 cd                	jne    80103d26 <growproc+0x26>
      return -1;
80103d59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d5e:	eb d6                	jmp    80103d36 <growproc+0x36>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d60:	83 ec 04             	sub    $0x4,%esp
80103d63:	01 c6                	add    %eax,%esi
80103d65:	56                   	push   %esi
80103d66:	50                   	push   %eax
80103d67:	ff 73 04             	pushl  0x4(%ebx)
80103d6a:	e8 51 34 00 00       	call   801071c0 <deallocuvm>
80103d6f:	83 c4 10             	add    $0x10,%esp
80103d72:	85 c0                	test   %eax,%eax
80103d74:	75 b0                	jne    80103d26 <growproc+0x26>
80103d76:	eb e1                	jmp    80103d59 <growproc+0x59>
80103d78:	90                   	nop
80103d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d80 <fork>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d89:	e8 a2 09 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103d8e:	e8 cd fb ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103d93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d99:	e8 92 0a 00 00       	call   80104830 <popcli>
  if((np = allocproc()) == 0){
80103d9e:	e8 5d fa ff ff       	call   80103800 <allocproc>
80103da3:	85 c0                	test   %eax,%eax
80103da5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103da8:	0f 84 f7 00 00 00    	je     80103ea5 <fork+0x125>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dae:	83 ec 08             	sub    $0x8,%esp
80103db1:	ff 33                	pushl  (%ebx)
80103db3:	ff 73 04             	pushl  0x4(%ebx)
80103db6:	89 c7                	mov    %eax,%edi
80103db8:	e8 d3 35 00 00       	call   80107390 <copyuvm>
80103dbd:	83 c4 10             	add    $0x10,%esp
80103dc0:	85 c0                	test   %eax,%eax
80103dc2:	89 47 04             	mov    %eax,0x4(%edi)
80103dc5:	0f 84 e1 00 00 00    	je     80103eac <fork+0x12c>
  np->sz = curproc->sz;
80103dcb:	8b 03                	mov    (%ebx),%eax
80103dcd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103dd0:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103dd5:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103dd7:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103dda:	8b 7a 18             	mov    0x18(%edx),%edi
80103ddd:	8b 73 18             	mov    0x18(%ebx),%esi
80103de0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103de2:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103de4:	8b 42 18             	mov    0x18(%edx),%eax
80103de7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103dee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80103df0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103df4:	85 c0                	test   %eax,%eax
80103df6:	74 13                	je     80103e0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103df8:	83 ec 0c             	sub    $0xc,%esp
80103dfb:	50                   	push   %eax
80103dfc:	e8 df d1 ff ff       	call   80100fe0 <filedup>
80103e01:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e04:	83 c4 10             	add    $0x10,%esp
80103e07:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e0b:	83 c6 01             	add    $0x1,%esi
80103e0e:	83 fe 10             	cmp    $0x10,%esi
80103e11:	75 dd                	jne    80103df0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e13:	83 ec 0c             	sub    $0xc,%esp
80103e16:	ff 73 68             	pushl  0x68(%ebx)
80103e19:	e8 32 da ff ff       	call   80101850 <idup>
80103e1e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e21:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e24:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e27:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e2a:	6a 10                	push   $0x10
80103e2c:	50                   	push   %eax
80103e2d:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e30:	50                   	push   %eax
80103e31:	e8 9a 0c 00 00       	call   80104ad0 <safestrcpy>
  pid = np->pid;
80103e36:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
80103e39:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103e40:	e8 2b 09 00 00       	call   80104770 <acquire>
  np->state = RUNNABLE;
80103e45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  qpush(np);
80103e4c:	89 3c 24             	mov    %edi,(%esp)
80103e4f:	e8 dc fb ff ff       	call   80103a30 <qpush>
80103e54:	8d 87 8c 00 00 00    	lea    0x8c(%edi),%eax
80103e5a:	8d 97 96 00 00 00    	lea    0x96(%edi),%edx
80103e60:	83 c4 10             	add    $0x10,%esp
80103e63:	90                   	nop
80103e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->sharedrec[i]=0;
80103e68:	c6 00 00             	movb   $0x0,(%eax)
80103e6b:	83 c0 01             	add    $0x1,%eax
  for(i=0;i<MAXSHAREDPG;i++)
80103e6e:	39 c2                	cmp    %eax,%edx
80103e70:	75 f6                	jne    80103e68 <fork+0xe8>
  np->nshared=0;
80103e72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  release(&ptable.lock);
80103e75:	83 ec 0c             	sub    $0xc,%esp
  np->nshared=0;
80103e78:	c7 82 88 00 00 00 00 	movl   $0x0,0x88(%edx)
80103e7f:	00 00 00 
  np->wdidx=curproc->wdidx;
80103e82:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
80103e88:	89 82 c0 00 00 00    	mov    %eax,0xc0(%edx)
  release(&ptable.lock);
80103e8e:	68 80 2d 11 80       	push   $0x80112d80
80103e93:	e8 f8 09 00 00       	call   80104890 <release>
  return pid;
80103e98:	83 c4 10             	add    $0x10,%esp
}
80103e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e9e:	89 f0                	mov    %esi,%eax
80103ea0:	5b                   	pop    %ebx
80103ea1:	5e                   	pop    %esi
80103ea2:	5f                   	pop    %edi
80103ea3:	5d                   	pop    %ebp
80103ea4:	c3                   	ret    
    return -1;
80103ea5:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103eaa:	eb ef                	jmp    80103e9b <fork+0x11b>
    kfree(np->kstack);
80103eac:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103eaf:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103eb2:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103eb7:	ff 73 08             	pushl  0x8(%ebx)
80103eba:	e8 51 e6 ff ff       	call   80102510 <kfree>
    np->kstack = 0;
80103ebf:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103ec6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ecd:	83 c4 10             	add    $0x10,%esp
80103ed0:	eb c9                	jmp    80103e9b <fork+0x11b>
80103ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ee0 <scheduler>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103ee9:	e8 72 fa ff ff       	call   80103960 <mycpu>
  c->proc = 0;
80103eee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ef5:	00 00 00 
  struct cpu *c = mycpu();
80103ef8:	89 c6                	mov    %eax,%esi
80103efa:	8d 40 04             	lea    0x4(%eax),%eax
80103efd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103f00:	fb                   	sti    
    acquire(&ptable.lock);
80103f01:	83 ec 0c             	sub    $0xc,%esp
    int queue=NPROCQ-1;
80103f04:	bf 02 00 00 00       	mov    $0x2,%edi
    acquire(&ptable.lock);
80103f09:	68 80 2d 11 80       	push   $0x80112d80
80103f0e:	e8 5d 08 00 00       	call   80104770 <acquire>
80103f13:	ba 80 2d 11 80       	mov    $0x80112d80,%edx
80103f18:	83 c4 10             	add    $0x10,%esp
80103f1b:	89 d1                	mov    %edx,%ecx
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103f1d:	8b 82 54 31 00 00    	mov    0x3154(%edx),%eax
80103f23:	85 c0                	test   %eax,%eax
80103f25:	74 35                	je     80103f5c <scheduler+0x7c>
80103f27:	8b 99 44 31 00 00    	mov    0x3144(%ecx),%ebx
80103f2d:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f31:	75 13                	jne    80103f46 <scheduler+0x66>
80103f33:	e9 b8 00 00 00       	jmp    80103ff0 <scheduler+0x110>
80103f38:	90                   	nop
80103f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f40:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f44:	74 3a                	je     80103f80 <scheduler+0xa0>
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103f46:	8b 5b 7c             	mov    0x7c(%ebx),%ebx
        ptable.count[queue]--;
80103f49:	83 e8 01             	sub    $0x1,%eax
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103f4c:	85 c0                	test   %eax,%eax
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103f4e:	89 99 44 31 00 00    	mov    %ebx,0x3144(%ecx)
        ptable.count[queue]--;
80103f54:	89 82 54 31 00 00    	mov    %eax,0x3154(%edx)
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80103f5a:	75 e4                	jne    80103f40 <scheduler+0x60>
    for(;queue>=0;queue--)
80103f5c:	83 ef 01             	sub    $0x1,%edi
80103f5f:	83 ea 04             	sub    $0x4,%edx
80103f62:	83 e9 08             	sub    $0x8,%ecx
80103f65:	83 ff ff             	cmp    $0xffffffff,%edi
80103f68:	75 b3                	jne    80103f1d <scheduler+0x3d>
    release(&ptable.lock);
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	68 80 2d 11 80       	push   $0x80112d80
80103f72:	e8 19 09 00 00       	call   80104890 <release>
  for(;;){
80103f77:	83 c4 10             	add    $0x10,%esp
80103f7a:	eb 84                	jmp    80103f00 <scheduler+0x20>
80103f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f80:	8d 97 26 06 00 00    	lea    0x626(%edi),%edx
80103f86:	8b 1c d5 84 2d 11 80 	mov    -0x7feed27c(,%edx,8),%ebx
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103f8d:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
        switchuvm(p);
80103f90:	83 ec 0c             	sub    $0xc,%esp
        ptable.count[queue]--;
80103f93:	83 e8 01             	sub    $0x1,%eax
80103f96:	89 04 bd cc 5e 11 80 	mov    %eax,-0x7feea134(,%edi,4)
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80103f9d:	89 0c d5 84 2d 11 80 	mov    %ecx,-0x7feed27c(,%edx,8)
        c->proc = p;
80103fa4:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
        switchuvm(p);
80103faa:	53                   	push   %ebx
80103fab:	e8 c0 2d 00 00       	call   80106d70 <switchuvm>
        p->state = RUNNING;
80103fb0:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        swtch(&(c->scheduler), p->context);
80103fb7:	58                   	pop    %eax
80103fb8:	5a                   	pop    %edx
80103fb9:	ff 73 1c             	pushl  0x1c(%ebx)
80103fbc:	ff 75 e4             	pushl  -0x1c(%ebp)
80103fbf:	e8 67 0b 00 00       	call   80104b2b <swtch>
        switchkvm();
80103fc4:	e8 87 2d 00 00       	call   80106d50 <switchkvm>
        break;
80103fc9:	83 c4 10             	add    $0x10,%esp
        c->proc = 0;
80103fcc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103fd3:	00 00 00 
    release(&ptable.lock);
80103fd6:	83 ec 0c             	sub    $0xc,%esp
80103fd9:	68 80 2d 11 80       	push   $0x80112d80
80103fde:	e8 ad 08 00 00       	call   80104890 <release>
  for(;;){
80103fe3:	83 c4 10             	add    $0x10,%esp
80103fe6:	e9 15 ff ff ff       	jmp    80103f00 <scheduler+0x20>
80103feb:	90                   	nop
80103fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff0:	8d 97 26 06 00 00    	lea    0x626(%edi),%edx
80103ff6:	eb 95                	jmp    80103f8d <scheduler+0xad>
80103ff8:	90                   	nop
80103ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104000 <sched>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
  pushcli();
80104005:	e8 26 07 00 00       	call   80104730 <pushcli>
  c = mycpu();
8010400a:	e8 51 f9 ff ff       	call   80103960 <mycpu>
  p = c->proc;
8010400f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104015:	e8 16 08 00 00       	call   80104830 <popcli>
  if(!holding(&ptable.lock))
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 80 2d 11 80       	push   $0x80112d80
80104022:	e8 c9 06 00 00       	call   801046f0 <holding>
80104027:	83 c4 10             	add    $0x10,%esp
8010402a:	85 c0                	test   %eax,%eax
8010402c:	74 4f                	je     8010407d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010402e:	e8 2d f9 ff ff       	call   80103960 <mycpu>
80104033:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010403a:	75 68                	jne    801040a4 <sched+0xa4>
  if(p->state == RUNNING)
8010403c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104040:	74 55                	je     80104097 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104042:	9c                   	pushf  
80104043:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104044:	f6 c4 02             	test   $0x2,%ah
80104047:	75 41                	jne    8010408a <sched+0x8a>
  intena = mycpu()->intena;
80104049:	e8 12 f9 ff ff       	call   80103960 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010404e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104051:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104057:	e8 04 f9 ff ff       	call   80103960 <mycpu>
8010405c:	83 ec 08             	sub    $0x8,%esp
8010405f:	ff 70 04             	pushl  0x4(%eax)
80104062:	53                   	push   %ebx
80104063:	e8 c3 0a 00 00       	call   80104b2b <swtch>
  mycpu()->intena = intena;
80104068:	e8 f3 f8 ff ff       	call   80103960 <mycpu>
}
8010406d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104070:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104076:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104079:	5b                   	pop    %ebx
8010407a:	5e                   	pop    %esi
8010407b:	5d                   	pop    %ebp
8010407c:	c3                   	ret    
    panic("sched ptable.lock");
8010407d:	83 ec 0c             	sub    $0xc,%esp
80104080:	68 10 7b 10 80       	push   $0x80107b10
80104085:	e8 06 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010408a:	83 ec 0c             	sub    $0xc,%esp
8010408d:	68 3c 7b 10 80       	push   $0x80107b3c
80104092:	e8 f9 c2 ff ff       	call   80100390 <panic>
    panic("sched running");
80104097:	83 ec 0c             	sub    $0xc,%esp
8010409a:	68 2e 7b 10 80       	push   $0x80107b2e
8010409f:	e8 ec c2 ff ff       	call   80100390 <panic>
    panic("sched locks");
801040a4:	83 ec 0c             	sub    $0xc,%esp
801040a7:	68 22 7b 10 80       	push   $0x80107b22
801040ac:	e8 df c2 ff ff       	call   80100390 <panic>
801040b1:	eb 0d                	jmp    801040c0 <exit>
801040b3:	90                   	nop
801040b4:	90                   	nop
801040b5:	90                   	nop
801040b6:	90                   	nop
801040b7:	90                   	nop
801040b8:	90                   	nop
801040b9:	90                   	nop
801040ba:	90                   	nop
801040bb:	90                   	nop
801040bc:	90                   	nop
801040bd:	90                   	nop
801040be:	90                   	nop
801040bf:	90                   	nop

801040c0 <exit>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	56                   	push   %esi
801040c5:	53                   	push   %ebx
801040c6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801040c9:	e8 62 06 00 00       	call   80104730 <pushcli>
  c = mycpu();
801040ce:	e8 8d f8 ff ff       	call   80103960 <mycpu>
  p = c->proc;
801040d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040d9:	e8 52 07 00 00       	call   80104830 <popcli>
  if(curproc == initproc)
801040de:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
801040e4:	8d 5e 28             	lea    0x28(%esi),%ebx
801040e7:	8d 7e 68             	lea    0x68(%esi),%edi
801040ea:	0f 84 b1 00 00 00    	je     801041a1 <exit+0xe1>
    if(curproc->ofile[fd]){
801040f0:	8b 03                	mov    (%ebx),%eax
801040f2:	85 c0                	test   %eax,%eax
801040f4:	74 12                	je     80104108 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	50                   	push   %eax
801040fa:	e8 31 cf ff ff       	call   80101030 <fileclose>
      curproc->ofile[fd] = 0;
801040ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104105:	83 c4 10             	add    $0x10,%esp
80104108:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010410b:	39 df                	cmp    %ebx,%edi
8010410d:	75 e1                	jne    801040f0 <exit+0x30>
  begin_op();
8010410f:	e8 8c ec ff ff       	call   80102da0 <begin_op>
  iput(curproc->cwd);
80104114:	83 ec 0c             	sub    $0xc,%esp
80104117:	ff 76 68             	pushl  0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411a:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
  iput(curproc->cwd);
8010411f:	e8 8c d8 ff ff       	call   801019b0 <iput>
  end_op();
80104124:	e8 e7 ec ff ff       	call   80102e10 <end_op>
  curproc->cwd = 0;
80104129:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104130:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80104137:	e8 34 06 00 00       	call   80104770 <acquire>
  wakeup1(curproc->parent);
8010413c:	8b 46 14             	mov    0x14(%esi),%eax
8010413f:	e8 7c f9 ff ff       	call   80103ac0 <wakeup1>
80104144:	83 c4 10             	add    $0x10,%esp
80104147:	eb 15                	jmp    8010415e <exit+0x9e>
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104150:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
80104156:	81 fb b4 5e 11 80    	cmp    $0x80115eb4,%ebx
8010415c:	73 2a                	jae    80104188 <exit+0xc8>
    if(p->parent == curproc){
8010415e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104161:	75 ed                	jne    80104150 <exit+0x90>
      if(p->state == ZOMBIE)
80104163:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
80104167:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
8010416c:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
8010416f:	75 df                	jne    80104150 <exit+0x90>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104171:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
        wakeup1(initproc);
80104177:	e8 44 f9 ff ff       	call   80103ac0 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010417c:	81 fb b4 5e 11 80    	cmp    $0x80115eb4,%ebx
80104182:	72 da                	jb     8010415e <exit+0x9e>
80104184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
80104188:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010418f:	e8 6c fe ff ff       	call   80104000 <sched>
  panic("zombie exit");
80104194:	83 ec 0c             	sub    $0xc,%esp
80104197:	68 5d 7b 10 80       	push   $0x80107b5d
8010419c:	e8 ef c1 ff ff       	call   80100390 <panic>
    panic("init exiting");
801041a1:	83 ec 0c             	sub    $0xc,%esp
801041a4:	68 50 7b 10 80       	push   $0x80107b50
801041a9:	e8 e2 c1 ff ff       	call   80100390 <panic>
801041ae:	66 90                	xchg   %ax,%ax

801041b0 <yield>:
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
801041b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801041b7:	e8 74 05 00 00       	call   80104730 <pushcli>
  c = mycpu();
801041bc:	e8 9f f7 ff ff       	call   80103960 <mycpu>
  p = c->proc;
801041c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041c7:	e8 64 06 00 00       	call   80104830 <popcli>
  acquire(&ptable.lock);  //DOC: yieldlock
801041cc:	83 ec 0c             	sub    $0xc,%esp
801041cf:	68 80 2d 11 80       	push   $0x80112d80
801041d4:	e8 97 05 00 00       	call   80104770 <acquire>
  if(p->priority>0)
801041d9:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801041df:	83 c4 10             	add    $0x10,%esp
  p->state = RUNNABLE;
801041e2:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  if(p->priority>0)
801041e9:	85 c0                	test   %eax,%eax
801041eb:	74 09                	je     801041f6 <yield+0x46>
    p->priority--;
801041ed:	83 e8 01             	sub    $0x1,%eax
801041f0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  qpush(p);
801041f6:	83 ec 0c             	sub    $0xc,%esp
801041f9:	53                   	push   %ebx
801041fa:	e8 31 f8 ff ff       	call   80103a30 <qpush>
  sched();
801041ff:	e8 fc fd ff ff       	call   80104000 <sched>
  release(&ptable.lock);
80104204:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
8010420b:	e8 80 06 00 00       	call   80104890 <release>
}
80104210:	83 c4 10             	add    $0x10,%esp
80104213:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104216:	c9                   	leave  
80104217:	c3                   	ret    
80104218:	90                   	nop
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104220 <sleep>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	57                   	push   %edi
80104224:	56                   	push   %esi
80104225:	53                   	push   %ebx
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	8b 7d 08             	mov    0x8(%ebp),%edi
8010422c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010422f:	e8 fc 04 00 00       	call   80104730 <pushcli>
  c = mycpu();
80104234:	e8 27 f7 ff ff       	call   80103960 <mycpu>
  p = c->proc;
80104239:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010423f:	e8 ec 05 00 00       	call   80104830 <popcli>
  if(p == 0)
80104244:	85 db                	test   %ebx,%ebx
80104246:	0f 84 87 00 00 00    	je     801042d3 <sleep+0xb3>
  if(lk == 0)
8010424c:	85 f6                	test   %esi,%esi
8010424e:	74 76                	je     801042c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104250:	81 fe 80 2d 11 80    	cmp    $0x80112d80,%esi
80104256:	74 50                	je     801042a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	68 80 2d 11 80       	push   $0x80112d80
80104260:	e8 0b 05 00 00       	call   80104770 <acquire>
    release(lk);
80104265:	89 34 24             	mov    %esi,(%esp)
80104268:	e8 23 06 00 00       	call   80104890 <release>
  p->chan = chan;
8010426d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104270:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104277:	e8 84 fd ff ff       	call   80104000 <sched>
  p->chan = 0;
8010427c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104283:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
8010428a:	e8 01 06 00 00       	call   80104890 <release>
    acquire(lk);
8010428f:	89 75 08             	mov    %esi,0x8(%ebp)
80104292:	83 c4 10             	add    $0x10,%esp
}
80104295:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104298:	5b                   	pop    %ebx
80104299:	5e                   	pop    %esi
8010429a:	5f                   	pop    %edi
8010429b:	5d                   	pop    %ebp
    acquire(lk);
8010429c:	e9 cf 04 00 00       	jmp    80104770 <acquire>
801042a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042b2:	e8 49 fd ff ff       	call   80104000 <sched>
  p->chan = 0;
801042b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042c1:	5b                   	pop    %ebx
801042c2:	5e                   	pop    %esi
801042c3:	5f                   	pop    %edi
801042c4:	5d                   	pop    %ebp
801042c5:	c3                   	ret    
    panic("sleep without lk");
801042c6:	83 ec 0c             	sub    $0xc,%esp
801042c9:	68 6f 7b 10 80       	push   $0x80107b6f
801042ce:	e8 bd c0 ff ff       	call   80100390 <panic>
    panic("sleep");
801042d3:	83 ec 0c             	sub    $0xc,%esp
801042d6:	68 69 7b 10 80       	push   $0x80107b69
801042db:	e8 b0 c0 ff ff       	call   80100390 <panic>

801042e0 <wait>:
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	57                   	push   %edi
801042e4:	56                   	push   %esi
801042e5:	53                   	push   %ebx
801042e6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801042e9:	e8 42 04 00 00       	call   80104730 <pushcli>
  c = mycpu();
801042ee:	e8 6d f6 ff ff       	call   80103960 <mycpu>
  p = c->proc;
801042f3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042f9:	e8 32 05 00 00       	call   80104830 <popcli>
  acquire(&ptable.lock);
801042fe:	83 ec 0c             	sub    $0xc,%esp
80104301:	68 80 2d 11 80       	push   $0x80112d80
80104306:	e8 65 04 00 00       	call   80104770 <acquire>
8010430b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010430e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104310:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
80104315:	eb 17                	jmp    8010432e <wait+0x4e>
80104317:	89 f6                	mov    %esi,%esi
80104319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104320:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
80104326:	81 fb b4 5e 11 80    	cmp    $0x80115eb4,%ebx
8010432c:	73 1e                	jae    8010434c <wait+0x6c>
      if(p->parent != curproc)
8010432e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104331:	75 ed                	jne    80104320 <wait+0x40>
      if(p->state == ZOMBIE){
80104333:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104337:	74 37                	je     80104370 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104339:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
      havekids = 1;
8010433f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104344:	81 fb b4 5e 11 80    	cmp    $0x80115eb4,%ebx
8010434a:	72 e2                	jb     8010432e <wait+0x4e>
    if(!havekids || curproc->killed){
8010434c:	85 c0                	test   %eax,%eax
8010434e:	74 7e                	je     801043ce <wait+0xee>
80104350:	8b 46 24             	mov    0x24(%esi),%eax
80104353:	85 c0                	test   %eax,%eax
80104355:	75 77                	jne    801043ce <wait+0xee>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104357:	83 ec 08             	sub    $0x8,%esp
8010435a:	68 80 2d 11 80       	push   $0x80112d80
8010435f:	56                   	push   %esi
80104360:	e8 bb fe ff ff       	call   80104220 <sleep>
    havekids = 0;
80104365:	83 c4 10             	add    $0x10,%esp
80104368:	eb a4                	jmp    8010430e <wait+0x2e>
8010436a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104370:	83 ec 0c             	sub    $0xc,%esp
80104373:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104376:	8b 7b 10             	mov    0x10(%ebx),%edi
        kfree(p->kstack);
80104379:	e8 92 e1 ff ff       	call   80102510 <kfree>
        freevm(p->pgdir,curproc->nshared);
8010437e:	5a                   	pop    %edx
8010437f:	59                   	pop    %ecx
        p->kstack = 0;
80104380:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir,curproc->nshared);
80104387:	ff b6 88 00 00 00    	pushl  0x88(%esi)
8010438d:	ff 73 04             	pushl  0x4(%ebx)
80104390:	e8 9b 2e 00 00       	call   80107230 <freevm>
        release(&ptable.lock);
80104395:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
        p->pid = 0;
8010439c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801043a3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801043aa:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801043ae:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801043b5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801043bc:	e8 cf 04 00 00       	call   80104890 <release>
        return pid;
801043c1:	83 c4 10             	add    $0x10,%esp
}
801043c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043c7:	89 f8                	mov    %edi,%eax
801043c9:	5b                   	pop    %ebx
801043ca:	5e                   	pop    %esi
801043cb:	5f                   	pop    %edi
801043cc:	5d                   	pop    %ebp
801043cd:	c3                   	ret    
      release(&ptable.lock);
801043ce:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801043d1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      release(&ptable.lock);
801043d6:	68 80 2d 11 80       	push   $0x80112d80
801043db:	e8 b0 04 00 00       	call   80104890 <release>
      return -1;
801043e0:	83 c4 10             	add    $0x10,%esp
801043e3:	eb df                	jmp    801043c4 <wait+0xe4>
801043e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043f0 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	53                   	push   %ebx
801043f4:	83 ec 10             	sub    $0x10,%esp
801043f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043fa:	68 80 2d 11 80       	push   $0x80112d80
801043ff:	e8 6c 03 00 00       	call   80104770 <acquire>
  wakeup1(chan);
80104404:	89 d8                	mov    %ebx,%eax
80104406:	e8 b5 f6 ff ff       	call   80103ac0 <wakeup1>
  release(&ptable.lock);
8010440b:	83 c4 10             	add    $0x10,%esp
8010440e:	c7 45 08 80 2d 11 80 	movl   $0x80112d80,0x8(%ebp)
}
80104415:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104418:	c9                   	leave  
  release(&ptable.lock);
80104419:	e9 72 04 00 00       	jmp    80104890 <release>
8010441e:	66 90                	xchg   %ax,%ax

80104420 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
80104424:	83 ec 10             	sub    $0x10,%esp
80104427:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010442a:	68 80 2d 11 80       	push   $0x80112d80
8010442f:	e8 3c 03 00 00       	call   80104770 <acquire>
80104434:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104437:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
8010443c:	eb 0e                	jmp    8010444c <kill+0x2c>
8010443e:	66 90                	xchg   %ax,%ax
80104440:	05 c4 00 00 00       	add    $0xc4,%eax
80104445:	3d b4 5e 11 80       	cmp    $0x80115eb4,%eax
8010444a:	73 34                	jae    80104480 <kill+0x60>
    if(p->pid == pid){
8010444c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010444f:	75 ef                	jne    80104440 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104451:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104455:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010445c:	75 07                	jne    80104465 <kill+0x45>
        p->state = RUNNABLE;
8010445e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104465:	83 ec 0c             	sub    $0xc,%esp
80104468:	68 80 2d 11 80       	push   $0x80112d80
8010446d:	e8 1e 04 00 00       	call   80104890 <release>
      return 0;
80104472:	83 c4 10             	add    $0x10,%esp
80104475:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104477:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010447a:	c9                   	leave  
8010447b:	c3                   	ret    
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104480:	83 ec 0c             	sub    $0xc,%esp
80104483:	68 80 2d 11 80       	push   $0x80112d80
80104488:	e8 03 04 00 00       	call   80104890 <release>
  return -1;
8010448d:	83 c4 10             	add    $0x10,%esp
80104490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104495:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104498:	c9                   	leave  
80104499:	c3                   	ret    
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	56                   	push   %esi
801044a5:	53                   	push   %ebx
801044a6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044a9:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
{
801044ae:	83 ec 3c             	sub    $0x3c,%esp
801044b1:	eb 27                	jmp    801044da <procdump+0x3a>
801044b3:	90                   	nop
801044b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044b8:	83 ec 0c             	sub    $0xc,%esp
801044bb:	68 07 7f 10 80       	push   $0x80107f07
801044c0:	e8 1b c2 ff ff       	call   801006e0 <cprintf>
801044c5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044c8:	81 c3 c4 00 00 00    	add    $0xc4,%ebx
801044ce:	81 fb b4 5e 11 80    	cmp    $0x80115eb4,%ebx
801044d4:	0f 83 86 00 00 00    	jae    80104560 <procdump+0xc0>
    if(p->state == UNUSED)
801044da:	8b 43 0c             	mov    0xc(%ebx),%eax
801044dd:	85 c0                	test   %eax,%eax
801044df:	74 e7                	je     801044c8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044e1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801044e4:	ba 80 7b 10 80       	mov    $0x80107b80,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044e9:	77 11                	ja     801044fc <procdump+0x5c>
801044eb:	8b 14 85 e0 7b 10 80 	mov    -0x7fef8420(,%eax,4),%edx
      state = "???";
801044f2:	b8 80 7b 10 80       	mov    $0x80107b80,%eax
801044f7:	85 d2                	test   %edx,%edx
801044f9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044fc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044ff:	50                   	push   %eax
80104500:	52                   	push   %edx
80104501:	ff 73 10             	pushl  0x10(%ebx)
80104504:	68 84 7b 10 80       	push   $0x80107b84
80104509:	e8 d2 c1 ff ff       	call   801006e0 <cprintf>
    if(p->state == SLEEPING){
8010450e:	83 c4 10             	add    $0x10,%esp
80104511:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104515:	75 a1                	jne    801044b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104517:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010451a:	83 ec 08             	sub    $0x8,%esp
8010451d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104520:	50                   	push   %eax
80104521:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104524:	8b 40 0c             	mov    0xc(%eax),%eax
80104527:	83 c0 08             	add    $0x8,%eax
8010452a:	50                   	push   %eax
8010452b:	e8 70 01 00 00       	call   801046a0 <getcallerpcs>
80104530:	83 c4 10             	add    $0x10,%esp
80104533:	90                   	nop
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104538:	8b 17                	mov    (%edi),%edx
8010453a:	85 d2                	test   %edx,%edx
8010453c:	0f 84 76 ff ff ff    	je     801044b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104542:	83 ec 08             	sub    $0x8,%esp
80104545:	83 c7 04             	add    $0x4,%edi
80104548:	52                   	push   %edx
80104549:	68 a1 75 10 80       	push   $0x801075a1
8010454e:	e8 8d c1 ff ff       	call   801006e0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104553:	83 c4 10             	add    $0x10,%esp
80104556:	39 fe                	cmp    %edi,%esi
80104558:	75 de                	jne    80104538 <procdump+0x98>
8010455a:	e9 59 ff ff ff       	jmp    801044b8 <procdump+0x18>
8010455f:	90                   	nop
  }
}
80104560:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104563:	5b                   	pop    %ebx
80104564:	5e                   	pop    %esi
80104565:	5f                   	pop    %edi
80104566:	5d                   	pop    %ebp
80104567:	c3                   	ret    
80104568:	66 90                	xchg   %ax,%ax
8010456a:	66 90                	xchg   %ax,%ax
8010456c:	66 90                	xchg   %ax,%ax
8010456e:	66 90                	xchg   %ax,%ax

80104570 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	53                   	push   %ebx
80104574:	83 ec 0c             	sub    $0xc,%esp
80104577:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010457a:	68 f8 7b 10 80       	push   $0x80107bf8
8010457f:	8d 43 04             	lea    0x4(%ebx),%eax
80104582:	50                   	push   %eax
80104583:	e8 f8 00 00 00       	call   80104680 <initlock>
  lk->name = name;
80104588:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010458b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104591:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104594:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010459b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010459e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045a1:	c9                   	leave  
801045a2:	c3                   	ret    
801045a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
801045b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	8d 73 04             	lea    0x4(%ebx),%esi
801045be:	56                   	push   %esi
801045bf:	e8 ac 01 00 00       	call   80104770 <acquire>
  while (lk->locked) {
801045c4:	8b 13                	mov    (%ebx),%edx
801045c6:	83 c4 10             	add    $0x10,%esp
801045c9:	85 d2                	test   %edx,%edx
801045cb:	74 16                	je     801045e3 <acquiresleep+0x33>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045d0:	83 ec 08             	sub    $0x8,%esp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
801045d5:	e8 46 fc ff ff       	call   80104220 <sleep>
  while (lk->locked) {
801045da:	8b 03                	mov    (%ebx),%eax
801045dc:	83 c4 10             	add    $0x10,%esp
801045df:	85 c0                	test   %eax,%eax
801045e1:	75 ed                	jne    801045d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801045e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045e9:	e8 12 f4 ff ff       	call   80103a00 <myproc>
801045ee:	8b 40 10             	mov    0x10(%eax),%eax
801045f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045fa:	5b                   	pop    %ebx
801045fb:	5e                   	pop    %esi
801045fc:	5d                   	pop    %ebp
  release(&lk->lk);
801045fd:	e9 8e 02 00 00       	jmp    80104890 <release>
80104602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104610 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
80104615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104618:	83 ec 0c             	sub    $0xc,%esp
8010461b:	8d 73 04             	lea    0x4(%ebx),%esi
8010461e:	56                   	push   %esi
8010461f:	e8 4c 01 00 00       	call   80104770 <acquire>
  lk->locked = 0;
80104624:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010462a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104631:	89 1c 24             	mov    %ebx,(%esp)
80104634:	e8 b7 fd ff ff       	call   801043f0 <wakeup>
  release(&lk->lk);
80104639:	89 75 08             	mov    %esi,0x8(%ebp)
8010463c:	83 c4 10             	add    $0x10,%esp
}
8010463f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104642:	5b                   	pop    %ebx
80104643:	5e                   	pop    %esi
80104644:	5d                   	pop    %ebp
  release(&lk->lk);
80104645:	e9 46 02 00 00       	jmp    80104890 <release>
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104650 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010465e:	53                   	push   %ebx
8010465f:	e8 0c 01 00 00       	call   80104770 <acquire>
  r = lk->locked;
80104664:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104666:	89 1c 24             	mov    %ebx,(%esp)
80104669:	e8 22 02 00 00       	call   80104890 <release>
  return r;
}
8010466e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104671:	89 f0                	mov    %esi,%eax
80104673:	5b                   	pop    %ebx
80104674:	5e                   	pop    %esi
80104675:	5d                   	pop    %ebp
80104676:	c3                   	ret    
80104677:	66 90                	xchg   %ax,%ax
80104679:	66 90                	xchg   %ax,%ax
8010467b:	66 90                	xchg   %ax,%ax
8010467d:	66 90                	xchg   %ax,%ax
8010467f:	90                   	nop

80104680 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104686:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010468f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104692:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104699:	5d                   	pop    %ebp
8010469a:	c3                   	ret    
8010469b:	90                   	nop
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046a0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046a1:	31 d2                	xor    %edx,%edx
{
801046a3:	89 e5                	mov    %esp,%ebp
801046a5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046a6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046ac:	83 e8 08             	sub    $0x8,%eax
801046af:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046b0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046bc:	77 1a                	ja     801046d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046be:	8b 58 04             	mov    0x4(%eax),%ebx
801046c1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046c4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046c7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046c9:	83 fa 0a             	cmp    $0xa,%edx
801046cc:	75 e2                	jne    801046b0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046ce:	5b                   	pop    %ebx
801046cf:	5d                   	pop    %ebp
801046d0:	c3                   	ret    
801046d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046d8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046db:	83 c1 28             	add    $0x28,%ecx
801046de:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801046e6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801046e9:	39 c1                	cmp    %eax,%ecx
801046eb:	75 f3                	jne    801046e0 <getcallerpcs+0x40>
}
801046ed:	5b                   	pop    %ebx
801046ee:	5d                   	pop    %ebp
801046ef:	c3                   	ret    

801046f0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 04             	sub    $0x4,%esp
801046f7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801046fa:	8b 02                	mov    (%edx),%eax
801046fc:	85 c0                	test   %eax,%eax
801046fe:	75 10                	jne    80104710 <holding+0x20>
}
80104700:	83 c4 04             	add    $0x4,%esp
80104703:	31 c0                	xor    %eax,%eax
80104705:	5b                   	pop    %ebx
80104706:	5d                   	pop    %ebp
80104707:	c3                   	ret    
80104708:	90                   	nop
80104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104710:	8b 5a 08             	mov    0x8(%edx),%ebx
80104713:	e8 48 f2 ff ff       	call   80103960 <mycpu>
80104718:	39 c3                	cmp    %eax,%ebx
8010471a:	0f 94 c0             	sete   %al
}
8010471d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104720:	0f b6 c0             	movzbl %al,%eax
}
80104723:	5b                   	pop    %ebx
80104724:	5d                   	pop    %ebp
80104725:	c3                   	ret    
80104726:	8d 76 00             	lea    0x0(%esi),%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104730 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 04             	sub    $0x4,%esp
80104737:	9c                   	pushf  
80104738:	5b                   	pop    %ebx
  asm volatile("cli");
80104739:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010473a:	e8 21 f2 ff ff       	call   80103960 <mycpu>
8010473f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104745:	85 c0                	test   %eax,%eax
80104747:	75 11                	jne    8010475a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104749:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010474f:	e8 0c f2 ff ff       	call   80103960 <mycpu>
80104754:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010475a:	e8 01 f2 ff ff       	call   80103960 <mycpu>
8010475f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104766:	83 c4 04             	add    $0x4,%esp
80104769:	5b                   	pop    %ebx
8010476a:	5d                   	pop    %ebp
8010476b:	c3                   	ret    
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104770 <acquire>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104775:	e8 b6 ff ff ff       	call   80104730 <pushcli>
  if(holding(lk))
8010477a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010477d:	8b 03                	mov    (%ebx),%eax
8010477f:	85 c0                	test   %eax,%eax
80104781:	0f 85 81 00 00 00    	jne    80104808 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104787:	ba 01 00 00 00       	mov    $0x1,%edx
8010478c:	eb 05                	jmp    80104793 <acquire+0x23>
8010478e:	66 90                	xchg   %ax,%ax
80104790:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104793:	89 d0                	mov    %edx,%eax
80104795:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104798:	85 c0                	test   %eax,%eax
8010479a:	75 f4                	jne    80104790 <acquire+0x20>
  __sync_synchronize();
8010479c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047a4:	e8 b7 f1 ff ff       	call   80103960 <mycpu>
  for(i = 0; i < 10; i++){
801047a9:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
801047ab:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
801047ae:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801047b1:	89 e8                	mov    %ebp,%eax
801047b3:	90                   	nop
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047b8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047c4:	77 1a                	ja     801047e0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801047c6:	8b 58 04             	mov    0x4(%eax),%ebx
801047c9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047cc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047cf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047d1:	83 fa 0a             	cmp    $0xa,%edx
801047d4:	75 e2                	jne    801047b8 <acquire+0x48>
}
801047d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d9:	5b                   	pop    %ebx
801047da:	5e                   	pop    %esi
801047db:	5d                   	pop    %ebp
801047dc:	c3                   	ret    
801047dd:	8d 76 00             	lea    0x0(%esi),%esi
801047e0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801047e3:	83 c1 28             	add    $0x28,%ecx
801047e6:	8d 76 00             	lea    0x0(%esi),%esi
801047e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801047f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801047f6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801047f9:	39 c8                	cmp    %ecx,%eax
801047fb:	75 f3                	jne    801047f0 <acquire+0x80>
}
801047fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104800:	5b                   	pop    %ebx
80104801:	5e                   	pop    %esi
80104802:	5d                   	pop    %ebp
80104803:	c3                   	ret    
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104808:	8b 73 08             	mov    0x8(%ebx),%esi
8010480b:	e8 50 f1 ff ff       	call   80103960 <mycpu>
80104810:	39 c6                	cmp    %eax,%esi
80104812:	0f 85 6f ff ff ff    	jne    80104787 <acquire+0x17>
    panic("acquire");
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	68 03 7c 10 80       	push   $0x80107c03
80104820:	e8 6b bb ff ff       	call   80100390 <panic>
80104825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <popcli>:

void
popcli(void)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104836:	9c                   	pushf  
80104837:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104838:	f6 c4 02             	test   $0x2,%ah
8010483b:	75 35                	jne    80104872 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010483d:	e8 1e f1 ff ff       	call   80103960 <mycpu>
80104842:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104849:	78 34                	js     8010487f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010484b:	e8 10 f1 ff ff       	call   80103960 <mycpu>
80104850:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104856:	85 d2                	test   %edx,%edx
80104858:	74 06                	je     80104860 <popcli+0x30>
    sti();
}
8010485a:	c9                   	leave  
8010485b:	c3                   	ret    
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104860:	e8 fb f0 ff ff       	call   80103960 <mycpu>
80104865:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010486b:	85 c0                	test   %eax,%eax
8010486d:	74 eb                	je     8010485a <popcli+0x2a>
  asm volatile("sti");
8010486f:	fb                   	sti    
}
80104870:	c9                   	leave  
80104871:	c3                   	ret    
    panic("popcli - interruptible");
80104872:	83 ec 0c             	sub    $0xc,%esp
80104875:	68 0b 7c 10 80       	push   $0x80107c0b
8010487a:	e8 11 bb ff ff       	call   80100390 <panic>
    panic("popcli");
8010487f:	83 ec 0c             	sub    $0xc,%esp
80104882:	68 22 7c 10 80       	push   $0x80107c22
80104887:	e8 04 bb ff ff       	call   80100390 <panic>
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104890 <release>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104898:	8b 03                	mov    (%ebx),%eax
8010489a:	85 c0                	test   %eax,%eax
8010489c:	74 0c                	je     801048aa <release+0x1a>
8010489e:	8b 73 08             	mov    0x8(%ebx),%esi
801048a1:	e8 ba f0 ff ff       	call   80103960 <mycpu>
801048a6:	39 c6                	cmp    %eax,%esi
801048a8:	74 16                	je     801048c0 <release+0x30>
    panic("release");
801048aa:	83 ec 0c             	sub    $0xc,%esp
801048ad:	68 29 7c 10 80       	push   $0x80107c29
801048b2:	e8 d9 ba ff ff       	call   80100390 <panic>
801048b7:	89 f6                	mov    %esi,%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
801048c0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048c7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048ce:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801048d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048dc:	5b                   	pop    %ebx
801048dd:	5e                   	pop    %esi
801048de:	5d                   	pop    %ebp
  popcli();
801048df:	e9 4c ff ff ff       	jmp    80104830 <popcli>
801048e4:	66 90                	xchg   %ax,%ax
801048e6:	66 90                	xchg   %ax,%ax
801048e8:	66 90                	xchg   %ax,%ax
801048ea:	66 90                	xchg   %ax,%ax
801048ec:	66 90                	xchg   %ax,%ax
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	53                   	push   %ebx
801048f5:	8b 55 08             	mov    0x8(%ebp),%edx
801048f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801048fb:	f6 c2 03             	test   $0x3,%dl
801048fe:	75 05                	jne    80104905 <memset+0x15>
80104900:	f6 c1 03             	test   $0x3,%cl
80104903:	74 13                	je     80104918 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104905:	89 d7                	mov    %edx,%edi
80104907:	8b 45 0c             	mov    0xc(%ebp),%eax
8010490a:	fc                   	cld    
8010490b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010490d:	5b                   	pop    %ebx
8010490e:	89 d0                	mov    %edx,%eax
80104910:	5f                   	pop    %edi
80104911:	5d                   	pop    %ebp
80104912:	c3                   	ret    
80104913:	90                   	nop
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104918:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010491c:	c1 e9 02             	shr    $0x2,%ecx
8010491f:	89 f8                	mov    %edi,%eax
80104921:	89 fb                	mov    %edi,%ebx
80104923:	c1 e0 18             	shl    $0x18,%eax
80104926:	c1 e3 10             	shl    $0x10,%ebx
80104929:	09 d8                	or     %ebx,%eax
8010492b:	09 f8                	or     %edi,%eax
8010492d:	c1 e7 08             	shl    $0x8,%edi
80104930:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104932:	89 d7                	mov    %edx,%edi
80104934:	fc                   	cld    
80104935:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104937:	5b                   	pop    %ebx
80104938:	89 d0                	mov    %edx,%eax
8010493a:	5f                   	pop    %edi
8010493b:	5d                   	pop    %ebp
8010493c:	c3                   	ret    
8010493d:	8d 76 00             	lea    0x0(%esi),%esi

80104940 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	56                   	push   %esi
80104945:	53                   	push   %ebx
80104946:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104949:	8b 75 08             	mov    0x8(%ebp),%esi
8010494c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010494f:	85 db                	test   %ebx,%ebx
80104951:	74 29                	je     8010497c <memcmp+0x3c>
    if(*s1 != *s2)
80104953:	0f b6 16             	movzbl (%esi),%edx
80104956:	0f b6 0f             	movzbl (%edi),%ecx
80104959:	38 d1                	cmp    %dl,%cl
8010495b:	75 2b                	jne    80104988 <memcmp+0x48>
8010495d:	b8 01 00 00 00       	mov    $0x1,%eax
80104962:	eb 14                	jmp    80104978 <memcmp+0x38>
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104968:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010496c:	83 c0 01             	add    $0x1,%eax
8010496f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104974:	38 ca                	cmp    %cl,%dl
80104976:	75 10                	jne    80104988 <memcmp+0x48>
  while(n-- > 0){
80104978:	39 d8                	cmp    %ebx,%eax
8010497a:	75 ec                	jne    80104968 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010497c:	5b                   	pop    %ebx
  return 0;
8010497d:	31 c0                	xor    %eax,%eax
}
8010497f:	5e                   	pop    %esi
80104980:	5f                   	pop    %edi
80104981:	5d                   	pop    %ebp
80104982:	c3                   	ret    
80104983:	90                   	nop
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104988:	0f b6 c2             	movzbl %dl,%eax
}
8010498b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010498c:	29 c8                	sub    %ecx,%eax
}
8010498e:	5e                   	pop    %esi
8010498f:	5f                   	pop    %edi
80104990:	5d                   	pop    %ebp
80104991:	c3                   	ret    
80104992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
801049a5:	8b 45 08             	mov    0x8(%ebp),%eax
801049a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801049ab:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049ae:	39 c3                	cmp    %eax,%ebx
801049b0:	73 26                	jae    801049d8 <memmove+0x38>
801049b2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801049b5:	39 c8                	cmp    %ecx,%eax
801049b7:	73 1f                	jae    801049d8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801049b9:	85 f6                	test   %esi,%esi
801049bb:	8d 56 ff             	lea    -0x1(%esi),%edx
801049be:	74 0f                	je     801049cf <memmove+0x2f>
      *--d = *--s;
801049c0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801049c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801049c7:	83 ea 01             	sub    $0x1,%edx
801049ca:	83 fa ff             	cmp    $0xffffffff,%edx
801049cd:	75 f1                	jne    801049c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049cf:	5b                   	pop    %ebx
801049d0:	5e                   	pop    %esi
801049d1:	5d                   	pop    %ebp
801049d2:	c3                   	ret    
801049d3:	90                   	nop
801049d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801049d8:	31 d2                	xor    %edx,%edx
801049da:	85 f6                	test   %esi,%esi
801049dc:	74 f1                	je     801049cf <memmove+0x2f>
801049de:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801049e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801049e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801049e7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801049ea:	39 d6                	cmp    %edx,%esi
801049ec:	75 f2                	jne    801049e0 <memmove+0x40>
}
801049ee:	5b                   	pop    %ebx
801049ef:	5e                   	pop    %esi
801049f0:	5d                   	pop    %ebp
801049f1:	c3                   	ret    
801049f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104a03:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104a04:	eb 9a                	jmp    801049a0 <memmove>
80104a06:	8d 76 00             	lea    0x0(%esi),%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a10 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	57                   	push   %edi
80104a14:	56                   	push   %esi
80104a15:	8b 7d 10             	mov    0x10(%ebp),%edi
80104a18:	53                   	push   %ebx
80104a19:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104a1f:	85 ff                	test   %edi,%edi
80104a21:	74 2f                	je     80104a52 <strncmp+0x42>
80104a23:	0f b6 01             	movzbl (%ecx),%eax
80104a26:	0f b6 1e             	movzbl (%esi),%ebx
80104a29:	84 c0                	test   %al,%al
80104a2b:	74 37                	je     80104a64 <strncmp+0x54>
80104a2d:	38 c3                	cmp    %al,%bl
80104a2f:	75 33                	jne    80104a64 <strncmp+0x54>
80104a31:	01 f7                	add    %esi,%edi
80104a33:	eb 13                	jmp    80104a48 <strncmp+0x38>
80104a35:	8d 76 00             	lea    0x0(%esi),%esi
80104a38:	0f b6 01             	movzbl (%ecx),%eax
80104a3b:	84 c0                	test   %al,%al
80104a3d:	74 21                	je     80104a60 <strncmp+0x50>
80104a3f:	0f b6 1a             	movzbl (%edx),%ebx
80104a42:	89 d6                	mov    %edx,%esi
80104a44:	38 d8                	cmp    %bl,%al
80104a46:	75 1c                	jne    80104a64 <strncmp+0x54>
    n--, p++, q++;
80104a48:	8d 56 01             	lea    0x1(%esi),%edx
80104a4b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a4e:	39 fa                	cmp    %edi,%edx
80104a50:	75 e6                	jne    80104a38 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104a52:	5b                   	pop    %ebx
    return 0;
80104a53:	31 c0                	xor    %eax,%eax
}
80104a55:	5e                   	pop    %esi
80104a56:	5f                   	pop    %edi
80104a57:	5d                   	pop    %ebp
80104a58:	c3                   	ret    
80104a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a60:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104a64:	29 d8                	sub    %ebx,%eax
}
80104a66:	5b                   	pop    %ebx
80104a67:	5e                   	pop    %esi
80104a68:	5f                   	pop    %edi
80104a69:	5d                   	pop    %ebp
80104a6a:	c3                   	ret    
80104a6b:	90                   	nop
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a70 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	8b 45 08             	mov    0x8(%ebp),%eax
80104a78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a7e:	89 c2                	mov    %eax,%edx
80104a80:	eb 19                	jmp    80104a9b <strncpy+0x2b>
80104a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a88:	83 c3 01             	add    $0x1,%ebx
80104a8b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104a8f:	83 c2 01             	add    $0x1,%edx
80104a92:	84 c9                	test   %cl,%cl
80104a94:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a97:	74 09                	je     80104aa2 <strncpy+0x32>
80104a99:	89 f1                	mov    %esi,%ecx
80104a9b:	85 c9                	test   %ecx,%ecx
80104a9d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104aa0:	7f e6                	jg     80104a88 <strncpy+0x18>
    ;
  while(n-- > 0)
80104aa2:	31 c9                	xor    %ecx,%ecx
80104aa4:	85 f6                	test   %esi,%esi
80104aa6:	7e 17                	jle    80104abf <strncpy+0x4f>
80104aa8:	90                   	nop
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ab0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ab4:	89 f3                	mov    %esi,%ebx
80104ab6:	83 c1 01             	add    $0x1,%ecx
80104ab9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104abb:	85 db                	test   %ebx,%ebx
80104abd:	7f f1                	jg     80104ab0 <strncpy+0x40>
  return os;
}
80104abf:	5b                   	pop    %ebx
80104ac0:	5e                   	pop    %esi
80104ac1:	5d                   	pop    %ebp
80104ac2:	c3                   	ret    
80104ac3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80104adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104ade:	85 c9                	test   %ecx,%ecx
80104ae0:	7e 26                	jle    80104b08 <safestrcpy+0x38>
80104ae2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ae6:	89 c1                	mov    %eax,%ecx
80104ae8:	eb 17                	jmp    80104b01 <safestrcpy+0x31>
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104af0:	83 c2 01             	add    $0x1,%edx
80104af3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104af7:	83 c1 01             	add    $0x1,%ecx
80104afa:	84 db                	test   %bl,%bl
80104afc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104aff:	74 04                	je     80104b05 <safestrcpy+0x35>
80104b01:	39 f2                	cmp    %esi,%edx
80104b03:	75 eb                	jne    80104af0 <safestrcpy+0x20>
    ;
  *s = 0;
80104b05:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b08:	5b                   	pop    %ebx
80104b09:	5e                   	pop    %esi
80104b0a:	5d                   	pop    %ebp
80104b0b:	c3                   	ret    
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b10 <strlen>:

int
strlen(const char *s)
{
80104b10:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b11:	31 c0                	xor    %eax,%eax
{
80104b13:	89 e5                	mov    %esp,%ebp
80104b15:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b18:	80 3a 00             	cmpb   $0x0,(%edx)
80104b1b:	74 0c                	je     80104b29 <strlen+0x19>
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi
80104b20:	83 c0 01             	add    $0x1,%eax
80104b23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b27:	75 f7                	jne    80104b20 <strlen+0x10>
    ;
  return n;
}
80104b29:	5d                   	pop    %ebp
80104b2a:	c3                   	ret    

80104b2b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b2f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104b33:	55                   	push   %ebp
  pushl %ebx
80104b34:	53                   	push   %ebx
  pushl %esi
80104b35:	56                   	push   %esi
  pushl %edi
80104b36:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b37:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b39:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104b3b:	5f                   	pop    %edi
  popl %esi
80104b3c:	5e                   	pop    %esi
  popl %ebx
80104b3d:	5b                   	pop    %ebx
  popl %ebp
80104b3e:	5d                   	pop    %ebp
  ret
80104b3f:	c3                   	ret    

80104b40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	53                   	push   %ebx
80104b44:	83 ec 04             	sub    $0x4,%esp
80104b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b4a:	e8 b1 ee ff ff       	call   80103a00 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b4f:	8b 00                	mov    (%eax),%eax
80104b51:	39 d8                	cmp    %ebx,%eax
80104b53:	76 1b                	jbe    80104b70 <fetchint+0x30>
80104b55:	8d 53 04             	lea    0x4(%ebx),%edx
80104b58:	39 d0                	cmp    %edx,%eax
80104b5a:	72 14                	jb     80104b70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5f:	8b 13                	mov    (%ebx),%edx
80104b61:	89 10                	mov    %edx,(%eax)
  return 0;
80104b63:	31 c0                	xor    %eax,%eax
}
80104b65:	83 c4 04             	add    $0x4,%esp
80104b68:	5b                   	pop    %ebx
80104b69:	5d                   	pop    %ebp
80104b6a:	c3                   	ret    
80104b6b:	90                   	nop
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b75:	eb ee                	jmp    80104b65 <fetchint+0x25>
80104b77:	89 f6                	mov    %esi,%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 04             	sub    $0x4,%esp
80104b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b8a:	e8 71 ee ff ff       	call   80103a00 <myproc>

  if(addr >= curproc->sz)
80104b8f:	39 18                	cmp    %ebx,(%eax)
80104b91:	76 29                	jbe    80104bbc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104b93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104b96:	89 da                	mov    %ebx,%edx
80104b98:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104b9a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104b9c:	39 c3                	cmp    %eax,%ebx
80104b9e:	73 1c                	jae    80104bbc <fetchstr+0x3c>
    if(*s == 0)
80104ba0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104ba3:	75 10                	jne    80104bb5 <fetchstr+0x35>
80104ba5:	eb 39                	jmp    80104be0 <fetchstr+0x60>
80104ba7:	89 f6                	mov    %esi,%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bb0:	80 3a 00             	cmpb   $0x0,(%edx)
80104bb3:	74 1b                	je     80104bd0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104bb5:	83 c2 01             	add    $0x1,%edx
80104bb8:	39 d0                	cmp    %edx,%eax
80104bba:	77 f4                	ja     80104bb0 <fetchstr+0x30>
    return -1;
80104bbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104bc1:	83 c4 04             	add    $0x4,%esp
80104bc4:	5b                   	pop    %ebx
80104bc5:	5d                   	pop    %ebp
80104bc6:	c3                   	ret    
80104bc7:	89 f6                	mov    %esi,%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bd0:	83 c4 04             	add    $0x4,%esp
80104bd3:	89 d0                	mov    %edx,%eax
80104bd5:	29 d8                	sub    %ebx,%eax
80104bd7:	5b                   	pop    %ebx
80104bd8:	5d                   	pop    %ebp
80104bd9:	c3                   	ret    
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104be0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104be2:	eb dd                	jmp    80104bc1 <fetchstr+0x41>
80104be4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104bf0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bf5:	e8 06 ee ff ff       	call   80103a00 <myproc>
80104bfa:	8b 40 18             	mov    0x18(%eax),%eax
80104bfd:	8b 55 08             	mov    0x8(%ebp),%edx
80104c00:	8b 40 44             	mov    0x44(%eax),%eax
80104c03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c06:	e8 f5 ed ff ff       	call   80103a00 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c0b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c0d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c10:	39 c6                	cmp    %eax,%esi
80104c12:	73 1c                	jae    80104c30 <argint+0x40>
80104c14:	8d 53 08             	lea    0x8(%ebx),%edx
80104c17:	39 d0                	cmp    %edx,%eax
80104c19:	72 15                	jb     80104c30 <argint+0x40>
  *ip = *(int*)(addr);
80104c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c1e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c21:	89 10                	mov    %edx,(%eax)
  return 0;
80104c23:	31 c0                	xor    %eax,%eax
}
80104c25:	5b                   	pop    %ebx
80104c26:	5e                   	pop    %esi
80104c27:	5d                   	pop    %ebp
80104c28:	c3                   	ret    
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c35:	eb ee                	jmp    80104c25 <argint+0x35>
80104c37:	89 f6                	mov    %esi,%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
80104c45:	83 ec 10             	sub    $0x10,%esp
80104c48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104c4b:	e8 b0 ed ff ff       	call   80103a00 <myproc>
80104c50:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104c52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c55:	83 ec 08             	sub    $0x8,%esp
80104c58:	50                   	push   %eax
80104c59:	ff 75 08             	pushl  0x8(%ebp)
80104c5c:	e8 8f ff ff ff       	call   80104bf0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c61:	83 c4 10             	add    $0x10,%esp
80104c64:	85 c0                	test   %eax,%eax
80104c66:	78 28                	js     80104c90 <argptr+0x50>
80104c68:	85 db                	test   %ebx,%ebx
80104c6a:	78 24                	js     80104c90 <argptr+0x50>
80104c6c:	8b 16                	mov    (%esi),%edx
80104c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c71:	39 c2                	cmp    %eax,%edx
80104c73:	76 1b                	jbe    80104c90 <argptr+0x50>
80104c75:	01 c3                	add    %eax,%ebx
80104c77:	39 da                	cmp    %ebx,%edx
80104c79:	72 15                	jb     80104c90 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c7e:	89 02                	mov    %eax,(%edx)
  return 0;
80104c80:	31 c0                	xor    %eax,%eax
}
80104c82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c85:	5b                   	pop    %ebx
80104c86:	5e                   	pop    %esi
80104c87:	5d                   	pop    %ebp
80104c88:	c3                   	ret    
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c95:	eb eb                	jmp    80104c82 <argptr+0x42>
80104c97:	89 f6                	mov    %esi,%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ca0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ca6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ca9:	50                   	push   %eax
80104caa:	ff 75 08             	pushl  0x8(%ebp)
80104cad:	e8 3e ff ff ff       	call   80104bf0 <argint>
80104cb2:	83 c4 10             	add    $0x10,%esp
80104cb5:	85 c0                	test   %eax,%eax
80104cb7:	78 17                	js     80104cd0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104cb9:	83 ec 08             	sub    $0x8,%esp
80104cbc:	ff 75 0c             	pushl  0xc(%ebp)
80104cbf:	ff 75 f4             	pushl  -0xc(%ebp)
80104cc2:	e8 b9 fe ff ff       	call   80104b80 <fetchstr>
80104cc7:	83 c4 10             	add    $0x10,%esp
}
80104cca:	c9                   	leave  
80104ccb:	c3                   	ret    
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cd5:	c9                   	leave  
80104cd6:	c3                   	ret    
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <syscall>:
[SYS_split]  sys_split,
};

void
syscall(void)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	53                   	push   %ebx
80104ce4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ce7:	e8 14 ed ff ff       	call   80103a00 <myproc>
80104cec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cee:	8b 40 18             	mov    0x18(%eax),%eax
80104cf1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104cf4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cf7:	83 fa 18             	cmp    $0x18,%edx
80104cfa:	77 1c                	ja     80104d18 <syscall+0x38>
80104cfc:	8b 14 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%edx
80104d03:	85 d2                	test   %edx,%edx
80104d05:	74 11                	je     80104d18 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104d07:	ff d2                	call   *%edx
80104d09:	8b 53 18             	mov    0x18(%ebx),%edx
80104d0c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d12:	c9                   	leave  
80104d13:	c3                   	ret    
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d18:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d19:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d1c:	50                   	push   %eax
80104d1d:	ff 73 10             	pushl  0x10(%ebx)
80104d20:	68 31 7c 10 80       	push   $0x80107c31
80104d25:	e8 b6 b9 ff ff       	call   801006e0 <cprintf>
    curproc->tf->eax = -1;
80104d2a:	8b 43 18             	mov    0x18(%ebx),%eax
80104d2d:	83 c4 10             	add    $0x10,%esp
80104d30:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d3a:	c9                   	leave  
80104d3b:	c3                   	ret    
80104d3c:	66 90                	xchg   %ax,%ax
80104d3e:	66 90                	xchg   %ax,%ax

80104d40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	57                   	push   %edi
80104d44:	56                   	push   %esi
80104d45:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d46:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104d49:	83 ec 44             	sub    $0x44,%esp
80104d4c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104d4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d52:	56                   	push   %esi
80104d53:	50                   	push   %eax
{
80104d54:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104d57:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d5a:	e8 a1 d3 ff ff       	call   80102100 <nameiparent>
80104d5f:	83 c4 10             	add    $0x10,%esp
80104d62:	85 c0                	test   %eax,%eax
80104d64:	0f 84 46 01 00 00    	je     80104eb0 <create+0x170>
    return 0;
  ilock(dp);
80104d6a:	83 ec 0c             	sub    $0xc,%esp
80104d6d:	89 c3                	mov    %eax,%ebx
80104d6f:	50                   	push   %eax
80104d70:	e8 0b cb ff ff       	call   80101880 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104d75:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104d78:	83 c4 0c             	add    $0xc,%esp
80104d7b:	50                   	push   %eax
80104d7c:	56                   	push   %esi
80104d7d:	53                   	push   %ebx
80104d7e:	e8 2d d0 ff ff       	call   80101db0 <dirlookup>
80104d83:	83 c4 10             	add    $0x10,%esp
80104d86:	85 c0                	test   %eax,%eax
80104d88:	89 c7                	mov    %eax,%edi
80104d8a:	74 34                	je     80104dc0 <create+0x80>
    iunlockput(dp);
80104d8c:	83 ec 0c             	sub    $0xc,%esp
80104d8f:	53                   	push   %ebx
80104d90:	e8 7b cd ff ff       	call   80101b10 <iunlockput>
    ilock(ip);
80104d95:	89 3c 24             	mov    %edi,(%esp)
80104d98:	e8 e3 ca ff ff       	call   80101880 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d9d:	83 c4 10             	add    $0x10,%esp
80104da0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104da5:	0f 85 95 00 00 00    	jne    80104e40 <create+0x100>
80104dab:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104db0:	0f 85 8a 00 00 00    	jne    80104e40 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104db9:	89 f8                	mov    %edi,%eax
80104dbb:	5b                   	pop    %ebx
80104dbc:	5e                   	pop    %esi
80104dbd:	5f                   	pop    %edi
80104dbe:	5d                   	pop    %ebp
80104dbf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104dc0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104dc4:	83 ec 08             	sub    $0x8,%esp
80104dc7:	50                   	push   %eax
80104dc8:	ff 33                	pushl  (%ebx)
80104dca:	e8 41 c9 ff ff       	call   80101710 <ialloc>
80104dcf:	83 c4 10             	add    $0x10,%esp
80104dd2:	85 c0                	test   %eax,%eax
80104dd4:	89 c7                	mov    %eax,%edi
80104dd6:	0f 84 e8 00 00 00    	je     80104ec4 <create+0x184>
  ilock(ip);
80104ddc:	83 ec 0c             	sub    $0xc,%esp
80104ddf:	50                   	push   %eax
80104de0:	e8 9b ca ff ff       	call   80101880 <ilock>
  ip->major = major;
80104de5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104de9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104ded:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104df1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104df5:	b8 01 00 00 00       	mov    $0x1,%eax
80104dfa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104dfe:	89 3c 24             	mov    %edi,(%esp)
80104e01:	e8 ca c9 ff ff       	call   801017d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e06:	83 c4 10             	add    $0x10,%esp
80104e09:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104e0e:	74 50                	je     80104e60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e10:	83 ec 04             	sub    $0x4,%esp
80104e13:	ff 77 04             	pushl  0x4(%edi)
80104e16:	56                   	push   %esi
80104e17:	53                   	push   %ebx
80104e18:	e8 03 d2 ff ff       	call   80102020 <dirlink>
80104e1d:	83 c4 10             	add    $0x10,%esp
80104e20:	85 c0                	test   %eax,%eax
80104e22:	0f 88 8f 00 00 00    	js     80104eb7 <create+0x177>
  iunlockput(dp);
80104e28:	83 ec 0c             	sub    $0xc,%esp
80104e2b:	53                   	push   %ebx
80104e2c:	e8 df cc ff ff       	call   80101b10 <iunlockput>
  return ip;
80104e31:	83 c4 10             	add    $0x10,%esp
}
80104e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e37:	89 f8                	mov    %edi,%eax
80104e39:	5b                   	pop    %ebx
80104e3a:	5e                   	pop    %esi
80104e3b:	5f                   	pop    %edi
80104e3c:	5d                   	pop    %ebp
80104e3d:	c3                   	ret    
80104e3e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104e40:	83 ec 0c             	sub    $0xc,%esp
80104e43:	57                   	push   %edi
    return 0;
80104e44:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104e46:	e8 c5 cc ff ff       	call   80101b10 <iunlockput>
    return 0;
80104e4b:	83 c4 10             	add    $0x10,%esp
}
80104e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e51:	89 f8                	mov    %edi,%eax
80104e53:	5b                   	pop    %ebx
80104e54:	5e                   	pop    %esi
80104e55:	5f                   	pop    %edi
80104e56:	5d                   	pop    %ebp
80104e57:	c3                   	ret    
80104e58:	90                   	nop
80104e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104e60:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e65:	83 ec 0c             	sub    $0xc,%esp
80104e68:	53                   	push   %ebx
80104e69:	e8 62 c9 ff ff       	call   801017d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e6e:	83 c4 0c             	add    $0xc,%esp
80104e71:	ff 77 04             	pushl  0x4(%edi)
80104e74:	68 e4 7c 10 80       	push   $0x80107ce4
80104e79:	57                   	push   %edi
80104e7a:	e8 a1 d1 ff ff       	call   80102020 <dirlink>
80104e7f:	83 c4 10             	add    $0x10,%esp
80104e82:	85 c0                	test   %eax,%eax
80104e84:	78 1c                	js     80104ea2 <create+0x162>
80104e86:	83 ec 04             	sub    $0x4,%esp
80104e89:	ff 73 04             	pushl  0x4(%ebx)
80104e8c:	68 e3 7c 10 80       	push   $0x80107ce3
80104e91:	57                   	push   %edi
80104e92:	e8 89 d1 ff ff       	call   80102020 <dirlink>
80104e97:	83 c4 10             	add    $0x10,%esp
80104e9a:	85 c0                	test   %eax,%eax
80104e9c:	0f 89 6e ff ff ff    	jns    80104e10 <create+0xd0>
      panic("create dots");
80104ea2:	83 ec 0c             	sub    $0xc,%esp
80104ea5:	68 d7 7c 10 80       	push   $0x80107cd7
80104eaa:	e8 e1 b4 ff ff       	call   80100390 <panic>
80104eaf:	90                   	nop
    return 0;
80104eb0:	31 ff                	xor    %edi,%edi
80104eb2:	e9 ff fe ff ff       	jmp    80104db6 <create+0x76>
    panic("create: dirlink");
80104eb7:	83 ec 0c             	sub    $0xc,%esp
80104eba:	68 e6 7c 10 80       	push   $0x80107ce6
80104ebf:	e8 cc b4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	68 c8 7c 10 80       	push   $0x80107cc8
80104ecc:	e8 bf b4 ff ff       	call   80100390 <panic>
80104ed1:	eb 0d                	jmp    80104ee0 <argfd.constprop.0>
80104ed3:	90                   	nop
80104ed4:	90                   	nop
80104ed5:	90                   	nop
80104ed6:	90                   	nop
80104ed7:	90                   	nop
80104ed8:	90                   	nop
80104ed9:	90                   	nop
80104eda:	90                   	nop
80104edb:	90                   	nop
80104edc:	90                   	nop
80104edd:	90                   	nop
80104ede:	90                   	nop
80104edf:	90                   	nop

80104ee0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
80104ee5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104ee7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104eea:	89 d6                	mov    %edx,%esi
80104eec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eef:	50                   	push   %eax
80104ef0:	6a 00                	push   $0x0
80104ef2:	e8 f9 fc ff ff       	call   80104bf0 <argint>
80104ef7:	83 c4 10             	add    $0x10,%esp
80104efa:	85 c0                	test   %eax,%eax
80104efc:	78 2a                	js     80104f28 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104efe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f02:	77 24                	ja     80104f28 <argfd.constprop.0+0x48>
80104f04:	e8 f7 ea ff ff       	call   80103a00 <myproc>
80104f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f0c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104f10:	85 c0                	test   %eax,%eax
80104f12:	74 14                	je     80104f28 <argfd.constprop.0+0x48>
  if(pfd)
80104f14:	85 db                	test   %ebx,%ebx
80104f16:	74 02                	je     80104f1a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104f18:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104f1a:	89 06                	mov    %eax,(%esi)
  return 0;
80104f1c:	31 c0                	xor    %eax,%eax
}
80104f1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f21:	5b                   	pop    %ebx
80104f22:	5e                   	pop    %esi
80104f23:	5d                   	pop    %ebp
80104f24:	c3                   	ret    
80104f25:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f2d:	eb ef                	jmp    80104f1e <argfd.constprop.0+0x3e>
80104f2f:	90                   	nop

80104f30 <sys_dup>:
{
80104f30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104f31:	31 c0                	xor    %eax,%eax
{
80104f33:	89 e5                	mov    %esp,%ebp
80104f35:	56                   	push   %esi
80104f36:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104f37:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104f3a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104f3d:	e8 9e ff ff ff       	call   80104ee0 <argfd.constprop.0>
80104f42:	85 c0                	test   %eax,%eax
80104f44:	78 42                	js     80104f88 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104f46:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f49:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104f4b:	e8 b0 ea ff ff       	call   80103a00 <myproc>
80104f50:	eb 0e                	jmp    80104f60 <sys_dup+0x30>
80104f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f58:	83 c3 01             	add    $0x1,%ebx
80104f5b:	83 fb 10             	cmp    $0x10,%ebx
80104f5e:	74 28                	je     80104f88 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104f60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f64:	85 d2                	test   %edx,%edx
80104f66:	75 f0                	jne    80104f58 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104f68:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f6c:	83 ec 0c             	sub    $0xc,%esp
80104f6f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f72:	e8 69 c0 ff ff       	call   80100fe0 <filedup>
  return fd;
80104f77:	83 c4 10             	add    $0x10,%esp
}
80104f7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f7d:	89 d8                	mov    %ebx,%eax
80104f7f:	5b                   	pop    %ebx
80104f80:	5e                   	pop    %esi
80104f81:	5d                   	pop    %ebp
80104f82:	c3                   	ret    
80104f83:	90                   	nop
80104f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f88:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f90:	89 d8                	mov    %ebx,%eax
80104f92:	5b                   	pop    %ebx
80104f93:	5e                   	pop    %esi
80104f94:	5d                   	pop    %ebp
80104f95:	c3                   	ret    
80104f96:	8d 76 00             	lea    0x0(%esi),%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fa0 <sys_read>:
{
80104fa0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fa1:	31 c0                	xor    %eax,%eax
{
80104fa3:	89 e5                	mov    %esp,%ebp
80104fa5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fa8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104fab:	e8 30 ff ff ff       	call   80104ee0 <argfd.constprop.0>
80104fb0:	85 c0                	test   %eax,%eax
80104fb2:	78 4c                	js     80105000 <sys_read+0x60>
80104fb4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fb7:	83 ec 08             	sub    $0x8,%esp
80104fba:	50                   	push   %eax
80104fbb:	6a 02                	push   $0x2
80104fbd:	e8 2e fc ff ff       	call   80104bf0 <argint>
80104fc2:	83 c4 10             	add    $0x10,%esp
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	78 37                	js     80105000 <sys_read+0x60>
80104fc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fcc:	83 ec 04             	sub    $0x4,%esp
80104fcf:	ff 75 f0             	pushl  -0x10(%ebp)
80104fd2:	50                   	push   %eax
80104fd3:	6a 01                	push   $0x1
80104fd5:	e8 66 fc ff ff       	call   80104c40 <argptr>
80104fda:	83 c4 10             	add    $0x10,%esp
80104fdd:	85 c0                	test   %eax,%eax
80104fdf:	78 1f                	js     80105000 <sys_read+0x60>
  return fileread(f, p, n);
80104fe1:	83 ec 04             	sub    $0x4,%esp
80104fe4:	ff 75 f0             	pushl  -0x10(%ebp)
80104fe7:	ff 75 f4             	pushl  -0xc(%ebp)
80104fea:	ff 75 ec             	pushl  -0x14(%ebp)
80104fed:	e8 5e c1 ff ff       	call   80101150 <fileread>
80104ff2:	83 c4 10             	add    $0x10,%esp
}
80104ff5:	c9                   	leave  
80104ff6:	c3                   	ret    
80104ff7:	89 f6                	mov    %esi,%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105005:	c9                   	leave  
80105006:	c3                   	ret    
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <sys_write>:
{
80105010:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105011:	31 c0                	xor    %eax,%eax
{
80105013:	89 e5                	mov    %esp,%ebp
80105015:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105018:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010501b:	e8 c0 fe ff ff       	call   80104ee0 <argfd.constprop.0>
80105020:	85 c0                	test   %eax,%eax
80105022:	78 4c                	js     80105070 <sys_write+0x60>
80105024:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105027:	83 ec 08             	sub    $0x8,%esp
8010502a:	50                   	push   %eax
8010502b:	6a 02                	push   $0x2
8010502d:	e8 be fb ff ff       	call   80104bf0 <argint>
80105032:	83 c4 10             	add    $0x10,%esp
80105035:	85 c0                	test   %eax,%eax
80105037:	78 37                	js     80105070 <sys_write+0x60>
80105039:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010503c:	83 ec 04             	sub    $0x4,%esp
8010503f:	ff 75 f0             	pushl  -0x10(%ebp)
80105042:	50                   	push   %eax
80105043:	6a 01                	push   $0x1
80105045:	e8 f6 fb ff ff       	call   80104c40 <argptr>
8010504a:	83 c4 10             	add    $0x10,%esp
8010504d:	85 c0                	test   %eax,%eax
8010504f:	78 1f                	js     80105070 <sys_write+0x60>
  return filewrite(f, p, n);
80105051:	83 ec 04             	sub    $0x4,%esp
80105054:	ff 75 f0             	pushl  -0x10(%ebp)
80105057:	ff 75 f4             	pushl  -0xc(%ebp)
8010505a:	ff 75 ec             	pushl  -0x14(%ebp)
8010505d:	e8 7e c1 ff ff       	call   801011e0 <filewrite>
80105062:	83 c4 10             	add    $0x10,%esp
}
80105065:	c9                   	leave  
80105066:	c3                   	ret    
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105075:	c9                   	leave  
80105076:	c3                   	ret    
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <sys_close>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105086:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105089:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010508c:	e8 4f fe ff ff       	call   80104ee0 <argfd.constprop.0>
80105091:	85 c0                	test   %eax,%eax
80105093:	78 2b                	js     801050c0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105095:	e8 66 e9 ff ff       	call   80103a00 <myproc>
8010509a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010509d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050a0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801050a7:	00 
  fileclose(f);
801050a8:	ff 75 f4             	pushl  -0xc(%ebp)
801050ab:	e8 80 bf ff ff       	call   80101030 <fileclose>
  return 0;
801050b0:	83 c4 10             	add    $0x10,%esp
801050b3:	31 c0                	xor    %eax,%eax
}
801050b5:	c9                   	leave  
801050b6:	c3                   	ret    
801050b7:	89 f6                	mov    %esi,%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050c5:	c9                   	leave  
801050c6:	c3                   	ret    
801050c7:	89 f6                	mov    %esi,%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050d0 <sys_fstat>:
{
801050d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050d1:	31 c0                	xor    %eax,%eax
{
801050d3:	89 e5                	mov    %esp,%ebp
801050d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050d8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801050db:	e8 00 fe ff ff       	call   80104ee0 <argfd.constprop.0>
801050e0:	85 c0                	test   %eax,%eax
801050e2:	78 2c                	js     80105110 <sys_fstat+0x40>
801050e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050e7:	83 ec 04             	sub    $0x4,%esp
801050ea:	6a 14                	push   $0x14
801050ec:	50                   	push   %eax
801050ed:	6a 01                	push   $0x1
801050ef:	e8 4c fb ff ff       	call   80104c40 <argptr>
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	85 c0                	test   %eax,%eax
801050f9:	78 15                	js     80105110 <sys_fstat+0x40>
  return filestat(f, st);
801050fb:	83 ec 08             	sub    $0x8,%esp
801050fe:	ff 75 f4             	pushl  -0xc(%ebp)
80105101:	ff 75 f0             	pushl  -0x10(%ebp)
80105104:	e8 f7 bf ff ff       	call   80101100 <filestat>
80105109:	83 c4 10             	add    $0x10,%esp
}
8010510c:	c9                   	leave  
8010510d:	c3                   	ret    
8010510e:	66 90                	xchg   %ax,%ax
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105115:	c9                   	leave  
80105116:	c3                   	ret    
80105117:	89 f6                	mov    %esi,%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <sys_link>:
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	57                   	push   %edi
80105124:	56                   	push   %esi
80105125:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105126:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105129:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010512c:	50                   	push   %eax
8010512d:	6a 00                	push   $0x0
8010512f:	e8 6c fb ff ff       	call   80104ca0 <argstr>
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	85 c0                	test   %eax,%eax
80105139:	0f 88 fb 00 00 00    	js     8010523a <sys_link+0x11a>
8010513f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105142:	83 ec 08             	sub    $0x8,%esp
80105145:	50                   	push   %eax
80105146:	6a 01                	push   $0x1
80105148:	e8 53 fb ff ff       	call   80104ca0 <argstr>
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	85 c0                	test   %eax,%eax
80105152:	0f 88 e2 00 00 00    	js     8010523a <sys_link+0x11a>
  begin_op();
80105158:	e8 43 dc ff ff       	call   80102da0 <begin_op>
  if((ip = namei(old)) == 0){
8010515d:	83 ec 0c             	sub    $0xc,%esp
80105160:	ff 75 d4             	pushl  -0x2c(%ebp)
80105163:	e8 78 cf ff ff       	call   801020e0 <namei>
80105168:	83 c4 10             	add    $0x10,%esp
8010516b:	85 c0                	test   %eax,%eax
8010516d:	89 c3                	mov    %eax,%ebx
8010516f:	0f 84 ea 00 00 00    	je     8010525f <sys_link+0x13f>
  ilock(ip);
80105175:	83 ec 0c             	sub    $0xc,%esp
80105178:	50                   	push   %eax
80105179:	e8 02 c7 ff ff       	call   80101880 <ilock>
  if(ip->type == T_DIR){
8010517e:	83 c4 10             	add    $0x10,%esp
80105181:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105186:	0f 84 bb 00 00 00    	je     80105247 <sys_link+0x127>
  ip->nlink++;
8010518c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105191:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105194:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105197:	53                   	push   %ebx
80105198:	e8 33 c6 ff ff       	call   801017d0 <iupdate>
  iunlock(ip);
8010519d:	89 1c 24             	mov    %ebx,(%esp)
801051a0:	e8 bb c7 ff ff       	call   80101960 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051a5:	58                   	pop    %eax
801051a6:	5a                   	pop    %edx
801051a7:	57                   	push   %edi
801051a8:	ff 75 d0             	pushl  -0x30(%ebp)
801051ab:	e8 50 cf ff ff       	call   80102100 <nameiparent>
801051b0:	83 c4 10             	add    $0x10,%esp
801051b3:	85 c0                	test   %eax,%eax
801051b5:	89 c6                	mov    %eax,%esi
801051b7:	74 5b                	je     80105214 <sys_link+0xf4>
  ilock(dp);
801051b9:	83 ec 0c             	sub    $0xc,%esp
801051bc:	50                   	push   %eax
801051bd:	e8 be c6 ff ff       	call   80101880 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051c2:	83 c4 10             	add    $0x10,%esp
801051c5:	8b 03                	mov    (%ebx),%eax
801051c7:	39 06                	cmp    %eax,(%esi)
801051c9:	75 3d                	jne    80105208 <sys_link+0xe8>
801051cb:	83 ec 04             	sub    $0x4,%esp
801051ce:	ff 73 04             	pushl  0x4(%ebx)
801051d1:	57                   	push   %edi
801051d2:	56                   	push   %esi
801051d3:	e8 48 ce ff ff       	call   80102020 <dirlink>
801051d8:	83 c4 10             	add    $0x10,%esp
801051db:	85 c0                	test   %eax,%eax
801051dd:	78 29                	js     80105208 <sys_link+0xe8>
  iunlockput(dp);
801051df:	83 ec 0c             	sub    $0xc,%esp
801051e2:	56                   	push   %esi
801051e3:	e8 28 c9 ff ff       	call   80101b10 <iunlockput>
  iput(ip);
801051e8:	89 1c 24             	mov    %ebx,(%esp)
801051eb:	e8 c0 c7 ff ff       	call   801019b0 <iput>
  end_op();
801051f0:	e8 1b dc ff ff       	call   80102e10 <end_op>
  return 0;
801051f5:	83 c4 10             	add    $0x10,%esp
801051f8:	31 c0                	xor    %eax,%eax
}
801051fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051fd:	5b                   	pop    %ebx
801051fe:	5e                   	pop    %esi
801051ff:	5f                   	pop    %edi
80105200:	5d                   	pop    %ebp
80105201:	c3                   	ret    
80105202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105208:	83 ec 0c             	sub    $0xc,%esp
8010520b:	56                   	push   %esi
8010520c:	e8 ff c8 ff ff       	call   80101b10 <iunlockput>
    goto bad;
80105211:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105214:	83 ec 0c             	sub    $0xc,%esp
80105217:	53                   	push   %ebx
80105218:	e8 63 c6 ff ff       	call   80101880 <ilock>
  ip->nlink--;
8010521d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105222:	89 1c 24             	mov    %ebx,(%esp)
80105225:	e8 a6 c5 ff ff       	call   801017d0 <iupdate>
  iunlockput(ip);
8010522a:	89 1c 24             	mov    %ebx,(%esp)
8010522d:	e8 de c8 ff ff       	call   80101b10 <iunlockput>
  end_op();
80105232:	e8 d9 db ff ff       	call   80102e10 <end_op>
  return -1;
80105237:	83 c4 10             	add    $0x10,%esp
}
8010523a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010523d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105242:	5b                   	pop    %ebx
80105243:	5e                   	pop    %esi
80105244:	5f                   	pop    %edi
80105245:	5d                   	pop    %ebp
80105246:	c3                   	ret    
    iunlockput(ip);
80105247:	83 ec 0c             	sub    $0xc,%esp
8010524a:	53                   	push   %ebx
8010524b:	e8 c0 c8 ff ff       	call   80101b10 <iunlockput>
    end_op();
80105250:	e8 bb db ff ff       	call   80102e10 <end_op>
    return -1;
80105255:	83 c4 10             	add    $0x10,%esp
80105258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525d:	eb 9b                	jmp    801051fa <sys_link+0xda>
    end_op();
8010525f:	e8 ac db ff ff       	call   80102e10 <end_op>
    return -1;
80105264:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105269:	eb 8f                	jmp    801051fa <sys_link+0xda>
8010526b:	90                   	nop
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105270 <sys_unlink>:
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	57                   	push   %edi
80105274:	56                   	push   %esi
80105275:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105276:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105279:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010527c:	50                   	push   %eax
8010527d:	6a 00                	push   $0x0
8010527f:	e8 1c fa ff ff       	call   80104ca0 <argstr>
80105284:	83 c4 10             	add    $0x10,%esp
80105287:	85 c0                	test   %eax,%eax
80105289:	0f 88 77 01 00 00    	js     80105406 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010528f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105292:	e8 09 db ff ff       	call   80102da0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105297:	83 ec 08             	sub    $0x8,%esp
8010529a:	53                   	push   %ebx
8010529b:	ff 75 c0             	pushl  -0x40(%ebp)
8010529e:	e8 5d ce ff ff       	call   80102100 <nameiparent>
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	85 c0                	test   %eax,%eax
801052a8:	89 c6                	mov    %eax,%esi
801052aa:	0f 84 60 01 00 00    	je     80105410 <sys_unlink+0x1a0>
  ilock(dp);
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	50                   	push   %eax
801052b4:	e8 c7 c5 ff ff       	call   80101880 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052b9:	58                   	pop    %eax
801052ba:	5a                   	pop    %edx
801052bb:	68 e4 7c 10 80       	push   $0x80107ce4
801052c0:	53                   	push   %ebx
801052c1:	e8 ca ca ff ff       	call   80101d90 <namecmp>
801052c6:	83 c4 10             	add    $0x10,%esp
801052c9:	85 c0                	test   %eax,%eax
801052cb:	0f 84 03 01 00 00    	je     801053d4 <sys_unlink+0x164>
801052d1:	83 ec 08             	sub    $0x8,%esp
801052d4:	68 e3 7c 10 80       	push   $0x80107ce3
801052d9:	53                   	push   %ebx
801052da:	e8 b1 ca ff ff       	call   80101d90 <namecmp>
801052df:	83 c4 10             	add    $0x10,%esp
801052e2:	85 c0                	test   %eax,%eax
801052e4:	0f 84 ea 00 00 00    	je     801053d4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801052ea:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052ed:	83 ec 04             	sub    $0x4,%esp
801052f0:	50                   	push   %eax
801052f1:	53                   	push   %ebx
801052f2:	56                   	push   %esi
801052f3:	e8 b8 ca ff ff       	call   80101db0 <dirlookup>
801052f8:	83 c4 10             	add    $0x10,%esp
801052fb:	85 c0                	test   %eax,%eax
801052fd:	89 c3                	mov    %eax,%ebx
801052ff:	0f 84 cf 00 00 00    	je     801053d4 <sys_unlink+0x164>
  ilock(ip);
80105305:	83 ec 0c             	sub    $0xc,%esp
80105308:	50                   	push   %eax
80105309:	e8 72 c5 ff ff       	call   80101880 <ilock>
  if(ip->nlink < 1)
8010530e:	83 c4 10             	add    $0x10,%esp
80105311:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105316:	0f 8e 10 01 00 00    	jle    8010542c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010531c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105321:	74 6d                	je     80105390 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105323:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105326:	83 ec 04             	sub    $0x4,%esp
80105329:	6a 10                	push   $0x10
8010532b:	6a 00                	push   $0x0
8010532d:	50                   	push   %eax
8010532e:	e8 bd f5 ff ff       	call   801048f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105333:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105336:	6a 10                	push   $0x10
80105338:	ff 75 c4             	pushl  -0x3c(%ebp)
8010533b:	50                   	push   %eax
8010533c:	56                   	push   %esi
8010533d:	e8 1e c9 ff ff       	call   80101c60 <writei>
80105342:	83 c4 20             	add    $0x20,%esp
80105345:	83 f8 10             	cmp    $0x10,%eax
80105348:	0f 85 eb 00 00 00    	jne    80105439 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010534e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105353:	0f 84 97 00 00 00    	je     801053f0 <sys_unlink+0x180>
  iunlockput(dp);
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	56                   	push   %esi
8010535d:	e8 ae c7 ff ff       	call   80101b10 <iunlockput>
  ip->nlink--;
80105362:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105367:	89 1c 24             	mov    %ebx,(%esp)
8010536a:	e8 61 c4 ff ff       	call   801017d0 <iupdate>
  iunlockput(ip);
8010536f:	89 1c 24             	mov    %ebx,(%esp)
80105372:	e8 99 c7 ff ff       	call   80101b10 <iunlockput>
  end_op();
80105377:	e8 94 da ff ff       	call   80102e10 <end_op>
  return 0;
8010537c:	83 c4 10             	add    $0x10,%esp
8010537f:	31 c0                	xor    %eax,%eax
}
80105381:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105384:	5b                   	pop    %ebx
80105385:	5e                   	pop    %esi
80105386:	5f                   	pop    %edi
80105387:	5d                   	pop    %ebp
80105388:	c3                   	ret    
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105390:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105394:	76 8d                	jbe    80105323 <sys_unlink+0xb3>
80105396:	bf 20 00 00 00       	mov    $0x20,%edi
8010539b:	eb 0f                	jmp    801053ac <sys_unlink+0x13c>
8010539d:	8d 76 00             	lea    0x0(%esi),%esi
801053a0:	83 c7 10             	add    $0x10,%edi
801053a3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801053a6:	0f 83 77 ff ff ff    	jae    80105323 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053ac:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053af:	6a 10                	push   $0x10
801053b1:	57                   	push   %edi
801053b2:	50                   	push   %eax
801053b3:	53                   	push   %ebx
801053b4:	e8 a7 c7 ff ff       	call   80101b60 <readi>
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	83 f8 10             	cmp    $0x10,%eax
801053bf:	75 5e                	jne    8010541f <sys_unlink+0x1af>
    if(de.inum != 0)
801053c1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053c6:	74 d8                	je     801053a0 <sys_unlink+0x130>
    iunlockput(ip);
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	53                   	push   %ebx
801053cc:	e8 3f c7 ff ff       	call   80101b10 <iunlockput>
    goto bad;
801053d1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	56                   	push   %esi
801053d8:	e8 33 c7 ff ff       	call   80101b10 <iunlockput>
  end_op();
801053dd:	e8 2e da ff ff       	call   80102e10 <end_op>
  return -1;
801053e2:	83 c4 10             	add    $0x10,%esp
801053e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ea:	eb 95                	jmp    80105381 <sys_unlink+0x111>
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801053f0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801053f5:	83 ec 0c             	sub    $0xc,%esp
801053f8:	56                   	push   %esi
801053f9:	e8 d2 c3 ff ff       	call   801017d0 <iupdate>
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	e9 53 ff ff ff       	jmp    80105359 <sys_unlink+0xe9>
    return -1;
80105406:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010540b:	e9 71 ff ff ff       	jmp    80105381 <sys_unlink+0x111>
    end_op();
80105410:	e8 fb d9 ff ff       	call   80102e10 <end_op>
    return -1;
80105415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541a:	e9 62 ff ff ff       	jmp    80105381 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010541f:	83 ec 0c             	sub    $0xc,%esp
80105422:	68 08 7d 10 80       	push   $0x80107d08
80105427:	e8 64 af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010542c:	83 ec 0c             	sub    $0xc,%esp
8010542f:	68 f6 7c 10 80       	push   $0x80107cf6
80105434:	e8 57 af ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105439:	83 ec 0c             	sub    $0xc,%esp
8010543c:	68 1a 7d 10 80       	push   $0x80107d1a
80105441:	e8 4a af ff ff       	call   80100390 <panic>
80105446:	8d 76 00             	lea    0x0(%esi),%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <sys_open>:

int
sys_open(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105456:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105459:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010545c:	50                   	push   %eax
8010545d:	6a 00                	push   $0x0
8010545f:	e8 3c f8 ff ff       	call   80104ca0 <argstr>
80105464:	83 c4 10             	add    $0x10,%esp
80105467:	85 c0                	test   %eax,%eax
80105469:	0f 88 1d 01 00 00    	js     8010558c <sys_open+0x13c>
8010546f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105472:	83 ec 08             	sub    $0x8,%esp
80105475:	50                   	push   %eax
80105476:	6a 01                	push   $0x1
80105478:	e8 73 f7 ff ff       	call   80104bf0 <argint>
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	85 c0                	test   %eax,%eax
80105482:	0f 88 04 01 00 00    	js     8010558c <sys_open+0x13c>
    return -1;

  begin_op();
80105488:	e8 13 d9 ff ff       	call   80102da0 <begin_op>

  if(omode & O_CREATE){
8010548d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105491:	0f 85 a9 00 00 00    	jne    80105540 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105497:	83 ec 0c             	sub    $0xc,%esp
8010549a:	ff 75 e0             	pushl  -0x20(%ebp)
8010549d:	e8 3e cc ff ff       	call   801020e0 <namei>
801054a2:	83 c4 10             	add    $0x10,%esp
801054a5:	85 c0                	test   %eax,%eax
801054a7:	89 c6                	mov    %eax,%esi
801054a9:	0f 84 b2 00 00 00    	je     80105561 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801054af:	83 ec 0c             	sub    $0xc,%esp
801054b2:	50                   	push   %eax
801054b3:	e8 c8 c3 ff ff       	call   80101880 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054b8:	83 c4 10             	add    $0x10,%esp
801054bb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054c0:	0f 84 aa 00 00 00    	je     80105570 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054c6:	e8 a5 ba ff ff       	call   80100f70 <filealloc>
801054cb:	85 c0                	test   %eax,%eax
801054cd:	89 c7                	mov    %eax,%edi
801054cf:	0f 84 a6 00 00 00    	je     8010557b <sys_open+0x12b>
  struct proc *curproc = myproc();
801054d5:	e8 26 e5 ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054da:	31 db                	xor    %ebx,%ebx
801054dc:	eb 0e                	jmp    801054ec <sys_open+0x9c>
801054de:	66 90                	xchg   %ax,%ax
801054e0:	83 c3 01             	add    $0x1,%ebx
801054e3:	83 fb 10             	cmp    $0x10,%ebx
801054e6:	0f 84 ac 00 00 00    	je     80105598 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801054ec:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054f0:	85 d2                	test   %edx,%edx
801054f2:	75 ec                	jne    801054e0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054f4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054f7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054fb:	56                   	push   %esi
801054fc:	e8 5f c4 ff ff       	call   80101960 <iunlock>
  end_op();
80105501:	e8 0a d9 ff ff       	call   80102e10 <end_op>

  f->type = FD_INODE;
80105506:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010550c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010550f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105512:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105515:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010551c:	89 d0                	mov    %edx,%eax
8010551e:	f7 d0                	not    %eax
80105520:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105523:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105526:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105529:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010552d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105530:	89 d8                	mov    %ebx,%eax
80105532:	5b                   	pop    %ebx
80105533:	5e                   	pop    %esi
80105534:	5f                   	pop    %edi
80105535:	5d                   	pop    %ebp
80105536:	c3                   	ret    
80105537:	89 f6                	mov    %esi,%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105546:	31 c9                	xor    %ecx,%ecx
80105548:	6a 00                	push   $0x0
8010554a:	ba 02 00 00 00       	mov    $0x2,%edx
8010554f:	e8 ec f7 ff ff       	call   80104d40 <create>
    if(ip == 0){
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105559:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010555b:	0f 85 65 ff ff ff    	jne    801054c6 <sys_open+0x76>
      end_op();
80105561:	e8 aa d8 ff ff       	call   80102e10 <end_op>
      return -1;
80105566:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010556b:	eb c0                	jmp    8010552d <sys_open+0xdd>
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105570:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105573:	85 c9                	test   %ecx,%ecx
80105575:	0f 84 4b ff ff ff    	je     801054c6 <sys_open+0x76>
    iunlockput(ip);
8010557b:	83 ec 0c             	sub    $0xc,%esp
8010557e:	56                   	push   %esi
8010557f:	e8 8c c5 ff ff       	call   80101b10 <iunlockput>
    end_op();
80105584:	e8 87 d8 ff ff       	call   80102e10 <end_op>
    return -1;
80105589:	83 c4 10             	add    $0x10,%esp
8010558c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105591:	eb 9a                	jmp    8010552d <sys_open+0xdd>
80105593:	90                   	nop
80105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105598:	83 ec 0c             	sub    $0xc,%esp
8010559b:	57                   	push   %edi
8010559c:	e8 8f ba ff ff       	call   80101030 <fileclose>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	eb d5                	jmp    8010557b <sys_open+0x12b>
801055a6:	8d 76 00             	lea    0x0(%esi),%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055b6:	e8 e5 d7 ff ff       	call   80102da0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055be:	83 ec 08             	sub    $0x8,%esp
801055c1:	50                   	push   %eax
801055c2:	6a 00                	push   $0x0
801055c4:	e8 d7 f6 ff ff       	call   80104ca0 <argstr>
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	85 c0                	test   %eax,%eax
801055ce:	78 30                	js     80105600 <sys_mkdir+0x50>
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d6:	31 c9                	xor    %ecx,%ecx
801055d8:	6a 00                	push   $0x0
801055da:	ba 01 00 00 00       	mov    $0x1,%edx
801055df:	e8 5c f7 ff ff       	call   80104d40 <create>
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
801055e9:	74 15                	je     80105600 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055eb:	83 ec 0c             	sub    $0xc,%esp
801055ee:	50                   	push   %eax
801055ef:	e8 1c c5 ff ff       	call   80101b10 <iunlockput>
  end_op();
801055f4:	e8 17 d8 ff ff       	call   80102e10 <end_op>
  return 0;
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	31 c0                	xor    %eax,%eax
}
801055fe:	c9                   	leave  
801055ff:	c3                   	ret    
    end_op();
80105600:	e8 0b d8 ff ff       	call   80102e10 <end_op>
    return -1;
80105605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010560a:	c9                   	leave  
8010560b:	c3                   	ret    
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_mknod>:

int
sys_mknod(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105616:	e8 85 d7 ff ff       	call   80102da0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010561b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010561e:	83 ec 08             	sub    $0x8,%esp
80105621:	50                   	push   %eax
80105622:	6a 00                	push   $0x0
80105624:	e8 77 f6 ff ff       	call   80104ca0 <argstr>
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	85 c0                	test   %eax,%eax
8010562e:	78 60                	js     80105690 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105630:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105633:	83 ec 08             	sub    $0x8,%esp
80105636:	50                   	push   %eax
80105637:	6a 01                	push   $0x1
80105639:	e8 b2 f5 ff ff       	call   80104bf0 <argint>
  if((argstr(0, &path)) < 0 ||
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	85 c0                	test   %eax,%eax
80105643:	78 4b                	js     80105690 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105645:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105648:	83 ec 08             	sub    $0x8,%esp
8010564b:	50                   	push   %eax
8010564c:	6a 02                	push   $0x2
8010564e:	e8 9d f5 ff ff       	call   80104bf0 <argint>
     argint(1, &major) < 0 ||
80105653:	83 c4 10             	add    $0x10,%esp
80105656:	85 c0                	test   %eax,%eax
80105658:	78 36                	js     80105690 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010565a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010565e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105661:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105665:	ba 03 00 00 00       	mov    $0x3,%edx
8010566a:	50                   	push   %eax
8010566b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010566e:	e8 cd f6 ff ff       	call   80104d40 <create>
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 c0                	test   %eax,%eax
80105678:	74 16                	je     80105690 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010567a:	83 ec 0c             	sub    $0xc,%esp
8010567d:	50                   	push   %eax
8010567e:	e8 8d c4 ff ff       	call   80101b10 <iunlockput>
  end_op();
80105683:	e8 88 d7 ff ff       	call   80102e10 <end_op>
  return 0;
80105688:	83 c4 10             	add    $0x10,%esp
8010568b:	31 c0                	xor    %eax,%eax
}
8010568d:	c9                   	leave  
8010568e:	c3                   	ret    
8010568f:	90                   	nop
    end_op();
80105690:	e8 7b d7 ff ff       	call   80102e10 <end_op>
    return -1;
80105695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010569a:	c9                   	leave  
8010569b:	c3                   	ret    
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_chdir>:

int
sys_chdir(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	56                   	push   %esi
801056a4:	53                   	push   %ebx
801056a5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056a8:	e8 53 e3 ff ff       	call   80103a00 <myproc>
801056ad:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056af:	e8 ec d6 ff ff       	call   80102da0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056b7:	83 ec 08             	sub    $0x8,%esp
801056ba:	50                   	push   %eax
801056bb:	6a 00                	push   $0x0
801056bd:	e8 de f5 ff ff       	call   80104ca0 <argstr>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	85 c0                	test   %eax,%eax
801056c7:	78 77                	js     80105740 <sys_chdir+0xa0>
801056c9:	83 ec 0c             	sub    $0xc,%esp
801056cc:	ff 75 f4             	pushl  -0xc(%ebp)
801056cf:	e8 0c ca ff ff       	call   801020e0 <namei>
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	85 c0                	test   %eax,%eax
801056d9:	89 c3                	mov    %eax,%ebx
801056db:	74 63                	je     80105740 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056dd:	83 ec 0c             	sub    $0xc,%esp
801056e0:	50                   	push   %eax
801056e1:	e8 9a c1 ff ff       	call   80101880 <ilock>
  if(ip->type != T_DIR){
801056e6:	83 c4 10             	add    $0x10,%esp
801056e9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056ee:	75 30                	jne    80105720 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	53                   	push   %ebx
801056f4:	e8 67 c2 ff ff       	call   80101960 <iunlock>
  iput(curproc->cwd);
801056f9:	58                   	pop    %eax
801056fa:	ff 76 68             	pushl  0x68(%esi)
801056fd:	e8 ae c2 ff ff       	call   801019b0 <iput>
  end_op();
80105702:	e8 09 d7 ff ff       	call   80102e10 <end_op>
  curproc->cwd = ip;
80105707:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010570a:	83 c4 10             	add    $0x10,%esp
8010570d:	31 c0                	xor    %eax,%eax
}
8010570f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105712:	5b                   	pop    %ebx
80105713:	5e                   	pop    %esi
80105714:	5d                   	pop    %ebp
80105715:	c3                   	ret    
80105716:	8d 76 00             	lea    0x0(%esi),%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	53                   	push   %ebx
80105724:	e8 e7 c3 ff ff       	call   80101b10 <iunlockput>
    end_op();
80105729:	e8 e2 d6 ff ff       	call   80102e10 <end_op>
    return -1;
8010572e:	83 c4 10             	add    $0x10,%esp
80105731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105736:	eb d7                	jmp    8010570f <sys_chdir+0x6f>
80105738:	90                   	nop
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105740:	e8 cb d6 ff ff       	call   80102e10 <end_op>
    return -1;
80105745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574a:	eb c3                	jmp    8010570f <sys_chdir+0x6f>
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_exec>:

int
sys_exec(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	57                   	push   %edi
80105754:	56                   	push   %esi
80105755:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105756:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010575c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105762:	50                   	push   %eax
80105763:	6a 00                	push   $0x0
80105765:	e8 36 f5 ff ff       	call   80104ca0 <argstr>
8010576a:	83 c4 10             	add    $0x10,%esp
8010576d:	85 c0                	test   %eax,%eax
8010576f:	0f 88 87 00 00 00    	js     801057fc <sys_exec+0xac>
80105775:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010577b:	83 ec 08             	sub    $0x8,%esp
8010577e:	50                   	push   %eax
8010577f:	6a 01                	push   $0x1
80105781:	e8 6a f4 ff ff       	call   80104bf0 <argint>
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	85 c0                	test   %eax,%eax
8010578b:	78 6f                	js     801057fc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010578d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105793:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105796:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105798:	68 80 00 00 00       	push   $0x80
8010579d:	6a 00                	push   $0x0
8010579f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801057a5:	50                   	push   %eax
801057a6:	e8 45 f1 ff ff       	call   801048f0 <memset>
801057ab:	83 c4 10             	add    $0x10,%esp
801057ae:	eb 2c                	jmp    801057dc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801057b0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057b6:	85 c0                	test   %eax,%eax
801057b8:	74 56                	je     80105810 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057ba:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801057c0:	83 ec 08             	sub    $0x8,%esp
801057c3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801057c6:	52                   	push   %edx
801057c7:	50                   	push   %eax
801057c8:	e8 b3 f3 ff ff       	call   80104b80 <fetchstr>
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	85 c0                	test   %eax,%eax
801057d2:	78 28                	js     801057fc <sys_exec+0xac>
  for(i=0;; i++){
801057d4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057d7:	83 fb 20             	cmp    $0x20,%ebx
801057da:	74 20                	je     801057fc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057dc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057e2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801057e9:	83 ec 08             	sub    $0x8,%esp
801057ec:	57                   	push   %edi
801057ed:	01 f0                	add    %esi,%eax
801057ef:	50                   	push   %eax
801057f0:	e8 4b f3 ff ff       	call   80104b40 <fetchint>
801057f5:	83 c4 10             	add    $0x10,%esp
801057f8:	85 c0                	test   %eax,%eax
801057fa:	79 b4                	jns    801057b0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105804:	5b                   	pop    %ebx
80105805:	5e                   	pop    %esi
80105806:	5f                   	pop    %edi
80105807:	5d                   	pop    %ebp
80105808:	c3                   	ret    
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105810:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105816:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105819:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105820:	00 00 00 00 
  return exec(path, argv);
80105824:	50                   	push   %eax
80105825:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010582b:	e8 70 b3 ff ff       	call   80100ba0 <exec>
80105830:	83 c4 10             	add    $0x10,%esp
}
80105833:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105836:	5b                   	pop    %ebx
80105837:	5e                   	pop    %esi
80105838:	5f                   	pop    %edi
80105839:	5d                   	pop    %ebp
8010583a:	c3                   	ret    
8010583b:	90                   	nop
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105840 <sys_pipe>:

int
sys_pipe(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	57                   	push   %edi
80105844:	56                   	push   %esi
80105845:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105846:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105849:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010584c:	6a 08                	push   $0x8
8010584e:	50                   	push   %eax
8010584f:	6a 00                	push   $0x0
80105851:	e8 ea f3 ff ff       	call   80104c40 <argptr>
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	85 c0                	test   %eax,%eax
8010585b:	0f 88 ae 00 00 00    	js     8010590f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105861:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105864:	83 ec 08             	sub    $0x8,%esp
80105867:	50                   	push   %eax
80105868:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010586b:	50                   	push   %eax
8010586c:	e8 cf db ff ff       	call   80103440 <pipealloc>
80105871:	83 c4 10             	add    $0x10,%esp
80105874:	85 c0                	test   %eax,%eax
80105876:	0f 88 93 00 00 00    	js     8010590f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010587c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010587f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105881:	e8 7a e1 ff ff       	call   80103a00 <myproc>
80105886:	eb 10                	jmp    80105898 <sys_pipe+0x58>
80105888:	90                   	nop
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105890:	83 c3 01             	add    $0x1,%ebx
80105893:	83 fb 10             	cmp    $0x10,%ebx
80105896:	74 60                	je     801058f8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105898:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010589c:	85 f6                	test   %esi,%esi
8010589e:	75 f0                	jne    80105890 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801058a0:	8d 73 08             	lea    0x8(%ebx),%esi
801058a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058aa:	e8 51 e1 ff ff       	call   80103a00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058af:	31 d2                	xor    %edx,%edx
801058b1:	eb 0d                	jmp    801058c0 <sys_pipe+0x80>
801058b3:	90                   	nop
801058b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058b8:	83 c2 01             	add    $0x1,%edx
801058bb:	83 fa 10             	cmp    $0x10,%edx
801058be:	74 28                	je     801058e8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801058c0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058c4:	85 c9                	test   %ecx,%ecx
801058c6:	75 f0                	jne    801058b8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801058c8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801058cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058cf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058d4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058d7:	31 c0                	xor    %eax,%eax
}
801058d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058dc:	5b                   	pop    %ebx
801058dd:	5e                   	pop    %esi
801058de:	5f                   	pop    %edi
801058df:	5d                   	pop    %ebp
801058e0:	c3                   	ret    
801058e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801058e8:	e8 13 e1 ff ff       	call   80103a00 <myproc>
801058ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801058f4:	00 
801058f5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801058f8:	83 ec 0c             	sub    $0xc,%esp
801058fb:	ff 75 e0             	pushl  -0x20(%ebp)
801058fe:	e8 2d b7 ff ff       	call   80101030 <fileclose>
    fileclose(wf);
80105903:	58                   	pop    %eax
80105904:	ff 75 e4             	pushl  -0x1c(%ebp)
80105907:	e8 24 b7 ff ff       	call   80101030 <fileclose>
    return -1;
8010590c:	83 c4 10             	add    $0x10,%esp
8010590f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105914:	eb c3                	jmp    801058d9 <sys_pipe+0x99>
80105916:	66 90                	xchg   %ax,%ax
80105918:	66 90                	xchg   %ax,%ax
8010591a:	66 90                	xchg   %ax,%ax
8010591c:	66 90                	xchg   %ax,%ax
8010591e:	66 90                	xchg   %ax,%ax

80105920 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105923:	5d                   	pop    %ebp
  return fork();
80105924:	e9 57 e4 ff ff       	jmp    80103d80 <fork>
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_exit>:

int
sys_exit(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 08             	sub    $0x8,%esp
  exit();
80105936:	e8 85 e7 ff ff       	call   801040c0 <exit>
  return 0;  // not reached
}
8010593b:	31 c0                	xor    %eax,%eax
8010593d:	c9                   	leave  
8010593e:	c3                   	ret    
8010593f:	90                   	nop

80105940 <sys_wait>:

int
sys_wait(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105943:	5d                   	pop    %ebp
  return wait();
80105944:	e9 97 e9 ff ff       	jmp    801042e0 <wait>
80105949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105950 <sys_kill>:

int
sys_kill(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105956:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105959:	50                   	push   %eax
8010595a:	6a 00                	push   $0x0
8010595c:	e8 8f f2 ff ff       	call   80104bf0 <argint>
80105961:	83 c4 10             	add    $0x10,%esp
80105964:	85 c0                	test   %eax,%eax
80105966:	78 18                	js     80105980 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105968:	83 ec 0c             	sub    $0xc,%esp
8010596b:	ff 75 f4             	pushl  -0xc(%ebp)
8010596e:	e8 ad ea ff ff       	call   80104420 <kill>
80105973:	83 c4 10             	add    $0x10,%esp
}
80105976:	c9                   	leave  
80105977:	c3                   	ret    
80105978:	90                   	nop
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105985:	c9                   	leave  
80105986:	c3                   	ret    
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105990 <sys_getpid>:

int
sys_getpid(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105996:	e8 65 e0 ff ff       	call   80103a00 <myproc>
8010599b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010599e:	c9                   	leave  
8010599f:	c3                   	ret    

801059a0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059aa:	50                   	push   %eax
801059ab:	6a 00                	push   $0x0
801059ad:	e8 3e f2 ff ff       	call   80104bf0 <argint>
801059b2:	83 c4 10             	add    $0x10,%esp
801059b5:	85 c0                	test   %eax,%eax
801059b7:	78 27                	js     801059e0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059b9:	e8 42 e0 ff ff       	call   80103a00 <myproc>
  if(growproc(n) < 0)
801059be:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059c1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059c3:	ff 75 f4             	pushl  -0xc(%ebp)
801059c6:	e8 35 e3 ff ff       	call   80103d00 <growproc>
801059cb:	83 c4 10             	add    $0x10,%esp
801059ce:	85 c0                	test   %eax,%eax
801059d0:	78 0e                	js     801059e0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059d2:	89 d8                	mov    %ebx,%eax
801059d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059d7:	c9                   	leave  
801059d8:	c3                   	ret    
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059e5:	eb eb                	jmp    801059d2 <sys_sbrk+0x32>
801059e7:	89 f6                	mov    %esi,%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059f0 <sys_sleep>:

int
sys_sleep(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801059f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059fa:	50                   	push   %eax
801059fb:	6a 00                	push   $0x0
801059fd:	e8 ee f1 ff ff       	call   80104bf0 <argint>
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	85 c0                	test   %eax,%eax
80105a07:	0f 88 8a 00 00 00    	js     80105a97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a0d:	83 ec 0c             	sub    $0xc,%esp
80105a10:	68 e0 5e 11 80       	push   $0x80115ee0
80105a15:	e8 56 ed ff ff       	call   80104770 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a1d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105a20:	8b 1d 20 67 11 80    	mov    0x80116720,%ebx
  while(ticks - ticks0 < n){
80105a26:	85 d2                	test   %edx,%edx
80105a28:	75 27                	jne    80105a51 <sys_sleep+0x61>
80105a2a:	eb 54                	jmp    80105a80 <sys_sleep+0x90>
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a30:	83 ec 08             	sub    $0x8,%esp
80105a33:	68 e0 5e 11 80       	push   $0x80115ee0
80105a38:	68 20 67 11 80       	push   $0x80116720
80105a3d:	e8 de e7 ff ff       	call   80104220 <sleep>
  while(ticks - ticks0 < n){
80105a42:	a1 20 67 11 80       	mov    0x80116720,%eax
80105a47:	83 c4 10             	add    $0x10,%esp
80105a4a:	29 d8                	sub    %ebx,%eax
80105a4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a4f:	73 2f                	jae    80105a80 <sys_sleep+0x90>
    if(myproc()->killed){
80105a51:	e8 aa df ff ff       	call   80103a00 <myproc>
80105a56:	8b 40 24             	mov    0x24(%eax),%eax
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	74 d3                	je     80105a30 <sys_sleep+0x40>
      release(&tickslock);
80105a5d:	83 ec 0c             	sub    $0xc,%esp
80105a60:	68 e0 5e 11 80       	push   $0x80115ee0
80105a65:	e8 26 ee ff ff       	call   80104890 <release>
      return -1;
80105a6a:	83 c4 10             	add    $0x10,%esp
80105a6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105a72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a75:	c9                   	leave  
80105a76:	c3                   	ret    
80105a77:	89 f6                	mov    %esi,%esi
80105a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	68 e0 5e 11 80       	push   $0x80115ee0
80105a88:	e8 03 ee ff ff       	call   80104890 <release>
  return 0;
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	31 c0                	xor    %eax,%eax
}
80105a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
    return -1;
80105a97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9c:	eb f4                	jmp    80105a92 <sys_sleep+0xa2>
80105a9e:	66 90                	xchg   %ax,%ax

80105aa0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	53                   	push   %ebx
80105aa4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105aa7:	68 e0 5e 11 80       	push   $0x80115ee0
80105aac:	e8 bf ec ff ff       	call   80104770 <acquire>
  xticks = ticks;
80105ab1:	8b 1d 20 67 11 80    	mov    0x80116720,%ebx
  release(&tickslock);
80105ab7:	c7 04 24 e0 5e 11 80 	movl   $0x80115ee0,(%esp)
80105abe:	e8 cd ed ff ff       	call   80104890 <release>
  return xticks;
}
80105ac3:	89 d8                	mov    %ebx,%eax
80105ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ac8:	c9                   	leave  
80105ac9:	c3                   	ret    
80105aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ad0 <sys_trace>:

int
sys_trace(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->timepiece;
80105ad6:	e8 25 df ff ff       	call   80103a00 <myproc>
80105adb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80105ae1:	c9                   	leave  
80105ae2:	c3                   	ret    
80105ae3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105af0 <sys_releasesharem>:

int
sys_releasesharem(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	83 ec 20             	sub    $0x20,%esp
  int idx;
  if(argint(0,&idx)<0)
80105af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105af9:	50                   	push   %eax
80105afa:	6a 00                	push   $0x0
80105afc:	e8 ef f0 ff ff       	call   80104bf0 <argint>
80105b01:	83 c4 10             	add    $0x10,%esp
80105b04:	85 c0                	test   %eax,%eax
80105b06:	78 18                	js     80105b20 <sys_releasesharem+0x30>
    return -1;
  releaseshared(idx);
80105b08:	83 ec 0c             	sub    $0xc,%esp
80105b0b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b0e:	e8 0d e1 ff ff       	call   80103c20 <releaseshared>
  return 0;
80105b13:	83 c4 10             	add    $0x10,%esp
80105b16:	31 c0                	xor    %eax,%eax
}
80105b18:	c9                   	leave  
80105b19:	c3                   	ret    
80105b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b25:	c9                   	leave  
80105b26:	c3                   	ret    
80105b27:	89 f6                	mov    %esi,%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b30 <sys_getsharem>:

int
sys_getsharem(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	83 ec 20             	sub    $0x20,%esp
  int idx;
  if(argint(0,&idx)<0)
80105b36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b39:	50                   	push   %eax
80105b3a:	6a 00                	push   $0x0
80105b3c:	e8 af f0 ff ff       	call   80104bf0 <argint>
80105b41:	83 c4 10             	add    $0x10,%esp
80105b44:	85 c0                	test   %eax,%eax
80105b46:	78 18                	js     80105b60 <sys_getsharem+0x30>
    return -1;
  return (int)getshared(idx);
80105b48:	83 ec 0c             	sub    $0xc,%esp
80105b4b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b4e:	e8 1d e1 ff ff       	call   80103c70 <getshared>
80105b53:	83 c4 10             	add    $0x10,%esp
}
80105b56:	c9                   	leave  
80105b57:	c3                   	ret    
80105b58:	90                   	nop
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b65:	c9                   	leave  
80105b66:	c3                   	ret    
80105b67:	89 f6                	mov    %esi,%esi
80105b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b70 <sys_split>:

int
sys_split(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 20             	sub    $0x20,%esp
  int d;
  if(argint(0,&d)<0)
80105b76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b79:	50                   	push   %eax
80105b7a:	6a 00                	push   $0x0
80105b7c:	e8 6f f0 ff ff       	call   80104bf0 <argint>
80105b81:	83 c4 10             	add    $0x10,%esp
80105b84:	85 c0                	test   %eax,%eax
80105b86:	78 18                	js     80105ba0 <sys_split+0x30>
    return -1;
  return (int)splitw(d);
80105b88:	83 ec 0c             	sub    $0xc,%esp
80105b8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b8e:	e8 ad ae ff ff       	call   80100a40 <splitw>
80105b93:	83 c4 10             	add    $0x10,%esp
}
80105b96:	c9                   	leave  
80105b97:	c3                   	ret    
80105b98:	90                   	nop
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ba5:	c9                   	leave  
80105ba6:	c3                   	ret    

80105ba7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ba7:	1e                   	push   %ds
  pushl %es
80105ba8:	06                   	push   %es
  pushl %fs
80105ba9:	0f a0                	push   %fs
  pushl %gs
80105bab:	0f a8                	push   %gs
  pushal
80105bad:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105bae:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105bb2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105bb4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105bb6:	54                   	push   %esp
  call trap
80105bb7:	e8 c4 00 00 00       	call   80105c80 <trap>
  addl $4, %esp
80105bbc:	83 c4 04             	add    $0x4,%esp

80105bbf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105bbf:	61                   	popa   
  popl %gs
80105bc0:	0f a9                	pop    %gs
  popl %fs
80105bc2:	0f a1                	pop    %fs
  popl %es
80105bc4:	07                   	pop    %es
  popl %ds
80105bc5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bc6:	83 c4 08             	add    $0x8,%esp
  iret
80105bc9:	cf                   	iret   
80105bca:	66 90                	xchg   %ax,%ax
80105bcc:	66 90                	xchg   %ax,%ax
80105bce:	66 90                	xchg   %ax,%ax

80105bd0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bd0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105bd1:	31 c0                	xor    %eax,%eax
{
80105bd3:	89 e5                	mov    %esp,%ebp
80105bd5:	83 ec 08             	sub    $0x8,%esp
80105bd8:	90                   	nop
80105bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105be0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105be7:	c7 04 c5 22 5f 11 80 	movl   $0x8e000008,-0x7feea0de(,%eax,8)
80105bee:	08 00 00 8e 
80105bf2:	66 89 14 c5 20 5f 11 	mov    %dx,-0x7feea0e0(,%eax,8)
80105bf9:	80 
80105bfa:	c1 ea 10             	shr    $0x10,%edx
80105bfd:	66 89 14 c5 26 5f 11 	mov    %dx,-0x7feea0da(,%eax,8)
80105c04:	80 
  for(i = 0; i < 256; i++)
80105c05:	83 c0 01             	add    $0x1,%eax
80105c08:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c0d:	75 d1                	jne    80105be0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c0f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105c14:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c17:	c7 05 22 61 11 80 08 	movl   $0xef000008,0x80116122
80105c1e:	00 00 ef 
  initlock(&tickslock, "time");
80105c21:	68 29 7d 10 80       	push   $0x80107d29
80105c26:	68 e0 5e 11 80       	push   $0x80115ee0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c2b:	66 a3 20 61 11 80    	mov    %ax,0x80116120
80105c31:	c1 e8 10             	shr    $0x10,%eax
80105c34:	66 a3 26 61 11 80    	mov    %ax,0x80116126
  initlock(&tickslock, "time");
80105c3a:	e8 41 ea ff ff       	call   80104680 <initlock>
}
80105c3f:	83 c4 10             	add    $0x10,%esp
80105c42:	c9                   	leave  
80105c43:	c3                   	ret    
80105c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c50 <idtinit>:

void
idtinit(void)
{
80105c50:	55                   	push   %ebp
  pd[0] = size-1;
80105c51:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c56:	89 e5                	mov    %esp,%ebp
80105c58:	83 ec 10             	sub    $0x10,%esp
80105c5b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c5f:	b8 20 5f 11 80       	mov    $0x80115f20,%eax
80105c64:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c68:	c1 e8 10             	shr    $0x10,%eax
80105c6b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c6f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c72:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    
80105c77:	89 f6                	mov    %esi,%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c80 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	57                   	push   %edi
80105c84:	56                   	push   %esi
80105c85:	53                   	push   %ebx
80105c86:	83 ec 1c             	sub    $0x1c,%esp
80105c89:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105c8c:	8b 47 30             	mov    0x30(%edi),%eax
80105c8f:	83 f8 40             	cmp    $0x40,%eax
80105c92:	0f 84 f0 00 00 00    	je     80105d88 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c98:	83 e8 20             	sub    $0x20,%eax
80105c9b:	83 f8 1f             	cmp    $0x1f,%eax
80105c9e:	77 10                	ja     80105cb0 <trap+0x30>
80105ca0:	ff 24 85 d0 7d 10 80 	jmp    *-0x7fef8230(,%eax,4)
80105ca7:	89 f6                	mov    %esi,%esi
80105ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105cb0:	e8 4b dd ff ff       	call   80103a00 <myproc>
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105cba:	0f 84 24 02 00 00    	je     80105ee4 <trap+0x264>
80105cc0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105cc4:	0f 84 1a 02 00 00    	je     80105ee4 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105cca:	0f 20 d1             	mov    %cr2,%ecx
80105ccd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cd0:	e8 0b dd ff ff       	call   801039e0 <cpuid>
80105cd5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105cd8:	8b 47 34             	mov    0x34(%edi),%eax
80105cdb:	8b 77 30             	mov    0x30(%edi),%esi
80105cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105ce1:	e8 1a dd ff ff       	call   80103a00 <myproc>
80105ce6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ce9:	e8 12 dd ff ff       	call   80103a00 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105cf1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105cf4:	51                   	push   %ecx
80105cf5:	53                   	push   %ebx
80105cf6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105cf7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cfa:	ff 75 e4             	pushl  -0x1c(%ebp)
80105cfd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105cfe:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d01:	52                   	push   %edx
80105d02:	ff 70 10             	pushl  0x10(%eax)
80105d05:	68 8c 7d 10 80       	push   $0x80107d8c
80105d0a:	e8 d1 a9 ff ff       	call   801006e0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105d0f:	83 c4 20             	add    $0x20,%esp
80105d12:	e8 e9 dc ff ff       	call   80103a00 <myproc>
80105d17:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d1e:	e8 dd dc ff ff       	call   80103a00 <myproc>
80105d23:	85 c0                	test   %eax,%eax
80105d25:	74 1d                	je     80105d44 <trap+0xc4>
80105d27:	e8 d4 dc ff ff       	call   80103a00 <myproc>
80105d2c:	8b 50 24             	mov    0x24(%eax),%edx
80105d2f:	85 d2                	test   %edx,%edx
80105d31:	74 11                	je     80105d44 <trap+0xc4>
80105d33:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d37:	83 e0 03             	and    $0x3,%eax
80105d3a:	66 83 f8 03          	cmp    $0x3,%ax
80105d3e:	0f 84 5c 01 00 00    	je     80105ea0 <trap+0x220>
    exit();

  //brand new
  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d44:	e8 b7 dc ff ff       	call   80103a00 <myproc>
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	74 0b                	je     80105d58 <trap+0xd8>
80105d4d:	e8 ae dc ff ff       	call   80103a00 <myproc>
80105d52:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d56:	74 68                	je     80105dc0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER && (--myproc()->timepiece)<=0)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d58:	e8 a3 dc ff ff       	call   80103a00 <myproc>
80105d5d:	85 c0                	test   %eax,%eax
80105d5f:	74 19                	je     80105d7a <trap+0xfa>
80105d61:	e8 9a dc ff ff       	call   80103a00 <myproc>
80105d66:	8b 40 24             	mov    0x24(%eax),%eax
80105d69:	85 c0                	test   %eax,%eax
80105d6b:	74 0d                	je     80105d7a <trap+0xfa>
80105d6d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d71:	83 e0 03             	and    $0x3,%eax
80105d74:	66 83 f8 03          	cmp    $0x3,%ax
80105d78:	74 37                	je     80105db1 <trap+0x131>
    exit();
}
80105d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d7d:	5b                   	pop    %ebx
80105d7e:	5e                   	pop    %esi
80105d7f:	5f                   	pop    %edi
80105d80:	5d                   	pop    %ebp
80105d81:	c3                   	ret    
80105d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105d88:	e8 73 dc ff ff       	call   80103a00 <myproc>
80105d8d:	8b 58 24             	mov    0x24(%eax),%ebx
80105d90:	85 db                	test   %ebx,%ebx
80105d92:	0f 85 f8 00 00 00    	jne    80105e90 <trap+0x210>
    myproc()->tf = tf;
80105d98:	e8 63 dc ff ff       	call   80103a00 <myproc>
80105d9d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105da0:	e8 3b ef ff ff       	call   80104ce0 <syscall>
    if(myproc()->killed)
80105da5:	e8 56 dc ff ff       	call   80103a00 <myproc>
80105daa:	8b 48 24             	mov    0x24(%eax),%ecx
80105dad:	85 c9                	test   %ecx,%ecx
80105daf:	74 c9                	je     80105d7a <trap+0xfa>
}
80105db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105db4:	5b                   	pop    %ebx
80105db5:	5e                   	pop    %esi
80105db6:	5f                   	pop    %edi
80105db7:	5d                   	pop    %ebp
      exit();
80105db8:	e9 03 e3 ff ff       	jmp    801040c0 <exit>
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105dc0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105dc4:	75 92                	jne    80105d58 <trap+0xd8>
     tf->trapno == T_IRQ0+IRQ_TIMER && (--myproc()->timepiece)<=0)
80105dc6:	e8 35 dc ff ff       	call   80103a00 <myproc>
80105dcb:	83 a8 84 00 00 00 01 	subl   $0x1,0x84(%eax)
80105dd2:	75 84                	jne    80105d58 <trap+0xd8>
    yield();
80105dd4:	e8 d7 e3 ff ff       	call   801041b0 <yield>
80105dd9:	e9 7a ff ff ff       	jmp    80105d58 <trap+0xd8>
80105dde:	66 90                	xchg   %ax,%ax
    if(cpuid() == 0){
80105de0:	e8 fb db ff ff       	call   801039e0 <cpuid>
80105de5:	85 c0                	test   %eax,%eax
80105de7:	0f 84 c3 00 00 00    	je     80105eb0 <trap+0x230>
    lapiceoi();
80105ded:	e8 5e cb ff ff       	call   80102950 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105df2:	e8 09 dc ff ff       	call   80103a00 <myproc>
80105df7:	85 c0                	test   %eax,%eax
80105df9:	0f 85 28 ff ff ff    	jne    80105d27 <trap+0xa7>
80105dff:	e9 40 ff ff ff       	jmp    80105d44 <trap+0xc4>
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e08:	e8 03 ca ff ff       	call   80102810 <kbdintr>
    lapiceoi();
80105e0d:	e8 3e cb ff ff       	call   80102950 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e12:	e8 e9 db ff ff       	call   80103a00 <myproc>
80105e17:	85 c0                	test   %eax,%eax
80105e19:	0f 85 08 ff ff ff    	jne    80105d27 <trap+0xa7>
80105e1f:	e9 20 ff ff ff       	jmp    80105d44 <trap+0xc4>
80105e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e28:	e8 53 02 00 00       	call   80106080 <uartintr>
    lapiceoi();
80105e2d:	e8 1e cb ff ff       	call   80102950 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e32:	e8 c9 db ff ff       	call   80103a00 <myproc>
80105e37:	85 c0                	test   %eax,%eax
80105e39:	0f 85 e8 fe ff ff    	jne    80105d27 <trap+0xa7>
80105e3f:	e9 00 ff ff ff       	jmp    80105d44 <trap+0xc4>
80105e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e48:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105e4c:	8b 77 38             	mov    0x38(%edi),%esi
80105e4f:	e8 8c db ff ff       	call   801039e0 <cpuid>
80105e54:	56                   	push   %esi
80105e55:	53                   	push   %ebx
80105e56:	50                   	push   %eax
80105e57:	68 34 7d 10 80       	push   $0x80107d34
80105e5c:	e8 7f a8 ff ff       	call   801006e0 <cprintf>
    lapiceoi();
80105e61:	e8 ea ca ff ff       	call   80102950 <lapiceoi>
    break;
80105e66:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e69:	e8 92 db ff ff       	call   80103a00 <myproc>
80105e6e:	85 c0                	test   %eax,%eax
80105e70:	0f 85 b1 fe ff ff    	jne    80105d27 <trap+0xa7>
80105e76:	e9 c9 fe ff ff       	jmp    80105d44 <trap+0xc4>
80105e7b:	90                   	nop
80105e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105e80:	e8 fb c3 ff ff       	call   80102280 <ideintr>
80105e85:	e9 63 ff ff ff       	jmp    80105ded <trap+0x16d>
80105e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e90:	e8 2b e2 ff ff       	call   801040c0 <exit>
80105e95:	e9 fe fe ff ff       	jmp    80105d98 <trap+0x118>
80105e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105ea0:	e8 1b e2 ff ff       	call   801040c0 <exit>
80105ea5:	e9 9a fe ff ff       	jmp    80105d44 <trap+0xc4>
80105eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	68 e0 5e 11 80       	push   $0x80115ee0
80105eb8:	e8 b3 e8 ff ff       	call   80104770 <acquire>
      wakeup(&ticks);
80105ebd:	c7 04 24 20 67 11 80 	movl   $0x80116720,(%esp)
      ticks++;
80105ec4:	83 05 20 67 11 80 01 	addl   $0x1,0x80116720
      wakeup(&ticks);
80105ecb:	e8 20 e5 ff ff       	call   801043f0 <wakeup>
      release(&tickslock);
80105ed0:	c7 04 24 e0 5e 11 80 	movl   $0x80115ee0,(%esp)
80105ed7:	e8 b4 e9 ff ff       	call   80104890 <release>
80105edc:	83 c4 10             	add    $0x10,%esp
80105edf:	e9 09 ff ff ff       	jmp    80105ded <trap+0x16d>
80105ee4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ee7:	e8 f4 da ff ff       	call   801039e0 <cpuid>
80105eec:	83 ec 0c             	sub    $0xc,%esp
80105eef:	56                   	push   %esi
80105ef0:	53                   	push   %ebx
80105ef1:	50                   	push   %eax
80105ef2:	ff 77 30             	pushl  0x30(%edi)
80105ef5:	68 58 7d 10 80       	push   $0x80107d58
80105efa:	e8 e1 a7 ff ff       	call   801006e0 <cprintf>
      panic("trap");
80105eff:	83 c4 14             	add    $0x14,%esp
80105f02:	68 2e 7d 10 80       	push   $0x80107d2e
80105f07:	e8 84 a4 ff ff       	call   80100390 <panic>
80105f0c:	66 90                	xchg   %ax,%ax
80105f0e:	66 90                	xchg   %ax,%ax

80105f10 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f10:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105f15:	55                   	push   %ebp
80105f16:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f18:	85 c0                	test   %eax,%eax
80105f1a:	74 1c                	je     80105f38 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f1c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f21:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f22:	a8 01                	test   $0x1,%al
80105f24:	74 12                	je     80105f38 <uartgetc+0x28>
80105f26:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f2b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f2c:	0f b6 c0             	movzbl %al,%eax
}
80105f2f:	5d                   	pop    %ebp
80105f30:	c3                   	ret    
80105f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f3d:	5d                   	pop    %ebp
80105f3e:	c3                   	ret    
80105f3f:	90                   	nop

80105f40 <uartputc.part.0>:
uartputc(int c)
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	57                   	push   %edi
80105f44:	56                   	push   %esi
80105f45:	53                   	push   %ebx
80105f46:	89 c7                	mov    %eax,%edi
80105f48:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f4d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f52:	83 ec 0c             	sub    $0xc,%esp
80105f55:	eb 1b                	jmp    80105f72 <uartputc.part.0+0x32>
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105f60:	83 ec 0c             	sub    $0xc,%esp
80105f63:	6a 0a                	push   $0xa
80105f65:	e8 06 ca ff ff       	call   80102970 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f6a:	83 c4 10             	add    $0x10,%esp
80105f6d:	83 eb 01             	sub    $0x1,%ebx
80105f70:	74 07                	je     80105f79 <uartputc.part.0+0x39>
80105f72:	89 f2                	mov    %esi,%edx
80105f74:	ec                   	in     (%dx),%al
80105f75:	a8 20                	test   $0x20,%al
80105f77:	74 e7                	je     80105f60 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f79:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f7e:	89 f8                	mov    %edi,%eax
80105f80:	ee                   	out    %al,(%dx)
}
80105f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f84:	5b                   	pop    %ebx
80105f85:	5e                   	pop    %esi
80105f86:	5f                   	pop    %edi
80105f87:	5d                   	pop    %ebp
80105f88:	c3                   	ret    
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f90 <uartinit>:
{
80105f90:	55                   	push   %ebp
80105f91:	31 c9                	xor    %ecx,%ecx
80105f93:	89 c8                	mov    %ecx,%eax
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	57                   	push   %edi
80105f98:	56                   	push   %esi
80105f99:	53                   	push   %ebx
80105f9a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f9f:	89 da                	mov    %ebx,%edx
80105fa1:	83 ec 0c             	sub    $0xc,%esp
80105fa4:	ee                   	out    %al,(%dx)
80105fa5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105faa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105faf:	89 fa                	mov    %edi,%edx
80105fb1:	ee                   	out    %al,(%dx)
80105fb2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105fb7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fbc:	ee                   	out    %al,(%dx)
80105fbd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105fc2:	89 c8                	mov    %ecx,%eax
80105fc4:	89 f2                	mov    %esi,%edx
80105fc6:	ee                   	out    %al,(%dx)
80105fc7:	b8 03 00 00 00       	mov    $0x3,%eax
80105fcc:	89 fa                	mov    %edi,%edx
80105fce:	ee                   	out    %al,(%dx)
80105fcf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fd4:	89 c8                	mov    %ecx,%eax
80105fd6:	ee                   	out    %al,(%dx)
80105fd7:	b8 01 00 00 00       	mov    $0x1,%eax
80105fdc:	89 f2                	mov    %esi,%edx
80105fde:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fdf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fe4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fe5:	3c ff                	cmp    $0xff,%al
80105fe7:	74 5a                	je     80106043 <uartinit+0xb3>
  uart = 1;
80105fe9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ff0:	00 00 00 
80105ff3:	89 da                	mov    %ebx,%edx
80105ff5:	ec                   	in     (%dx),%al
80105ff6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ffb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105ffc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105fff:	bb 50 7e 10 80       	mov    $0x80107e50,%ebx
  ioapicenable(IRQ_COM1, 0);
80106004:	6a 00                	push   $0x0
80106006:	6a 04                	push   $0x4
80106008:	e8 c3 c4 ff ff       	call   801024d0 <ioapicenable>
8010600d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106010:	b8 78 00 00 00       	mov    $0x78,%eax
80106015:	eb 13                	jmp    8010602a <uartinit+0x9a>
80106017:	89 f6                	mov    %esi,%esi
80106019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106020:	83 c3 01             	add    $0x1,%ebx
80106023:	0f be 03             	movsbl (%ebx),%eax
80106026:	84 c0                	test   %al,%al
80106028:	74 19                	je     80106043 <uartinit+0xb3>
  if(!uart)
8010602a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80106030:	85 d2                	test   %edx,%edx
80106032:	74 ec                	je     80106020 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106034:	83 c3 01             	add    $0x1,%ebx
80106037:	e8 04 ff ff ff       	call   80105f40 <uartputc.part.0>
8010603c:	0f be 03             	movsbl (%ebx),%eax
8010603f:	84 c0                	test   %al,%al
80106041:	75 e7                	jne    8010602a <uartinit+0x9a>
}
80106043:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106046:	5b                   	pop    %ebx
80106047:	5e                   	pop    %esi
80106048:	5f                   	pop    %edi
80106049:	5d                   	pop    %ebp
8010604a:	c3                   	ret    
8010604b:	90                   	nop
8010604c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106050 <uartputc>:
  if(!uart)
80106050:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80106056:	55                   	push   %ebp
80106057:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106059:	85 d2                	test   %edx,%edx
{
8010605b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010605e:	74 10                	je     80106070 <uartputc+0x20>
}
80106060:	5d                   	pop    %ebp
80106061:	e9 da fe ff ff       	jmp    80105f40 <uartputc.part.0>
80106066:	8d 76 00             	lea    0x0(%esi),%esi
80106069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106070:	5d                   	pop    %ebp
80106071:	c3                   	ret    
80106072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106080 <uartintr>:

void
uartintr(void)
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106086:	68 10 5f 10 80       	push   $0x80105f10
8010608b:	e8 00 a8 ff ff       	call   80100890 <consoleintr>
}
80106090:	83 c4 10             	add    $0x10,%esp
80106093:	c9                   	leave  
80106094:	c3                   	ret    

80106095 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $0
80106097:	6a 00                	push   $0x0
  jmp alltraps
80106099:	e9 09 fb ff ff       	jmp    80105ba7 <alltraps>

8010609e <vector1>:
.globl vector1
vector1:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $1
801060a0:	6a 01                	push   $0x1
  jmp alltraps
801060a2:	e9 00 fb ff ff       	jmp    80105ba7 <alltraps>

801060a7 <vector2>:
.globl vector2
vector2:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $2
801060a9:	6a 02                	push   $0x2
  jmp alltraps
801060ab:	e9 f7 fa ff ff       	jmp    80105ba7 <alltraps>

801060b0 <vector3>:
.globl vector3
vector3:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $3
801060b2:	6a 03                	push   $0x3
  jmp alltraps
801060b4:	e9 ee fa ff ff       	jmp    80105ba7 <alltraps>

801060b9 <vector4>:
.globl vector4
vector4:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $4
801060bb:	6a 04                	push   $0x4
  jmp alltraps
801060bd:	e9 e5 fa ff ff       	jmp    80105ba7 <alltraps>

801060c2 <vector5>:
.globl vector5
vector5:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $5
801060c4:	6a 05                	push   $0x5
  jmp alltraps
801060c6:	e9 dc fa ff ff       	jmp    80105ba7 <alltraps>

801060cb <vector6>:
.globl vector6
vector6:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $6
801060cd:	6a 06                	push   $0x6
  jmp alltraps
801060cf:	e9 d3 fa ff ff       	jmp    80105ba7 <alltraps>

801060d4 <vector7>:
.globl vector7
vector7:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $7
801060d6:	6a 07                	push   $0x7
  jmp alltraps
801060d8:	e9 ca fa ff ff       	jmp    80105ba7 <alltraps>

801060dd <vector8>:
.globl vector8
vector8:
  pushl $8
801060dd:	6a 08                	push   $0x8
  jmp alltraps
801060df:	e9 c3 fa ff ff       	jmp    80105ba7 <alltraps>

801060e4 <vector9>:
.globl vector9
vector9:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $9
801060e6:	6a 09                	push   $0x9
  jmp alltraps
801060e8:	e9 ba fa ff ff       	jmp    80105ba7 <alltraps>

801060ed <vector10>:
.globl vector10
vector10:
  pushl $10
801060ed:	6a 0a                	push   $0xa
  jmp alltraps
801060ef:	e9 b3 fa ff ff       	jmp    80105ba7 <alltraps>

801060f4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060f4:	6a 0b                	push   $0xb
  jmp alltraps
801060f6:	e9 ac fa ff ff       	jmp    80105ba7 <alltraps>

801060fb <vector12>:
.globl vector12
vector12:
  pushl $12
801060fb:	6a 0c                	push   $0xc
  jmp alltraps
801060fd:	e9 a5 fa ff ff       	jmp    80105ba7 <alltraps>

80106102 <vector13>:
.globl vector13
vector13:
  pushl $13
80106102:	6a 0d                	push   $0xd
  jmp alltraps
80106104:	e9 9e fa ff ff       	jmp    80105ba7 <alltraps>

80106109 <vector14>:
.globl vector14
vector14:
  pushl $14
80106109:	6a 0e                	push   $0xe
  jmp alltraps
8010610b:	e9 97 fa ff ff       	jmp    80105ba7 <alltraps>

80106110 <vector15>:
.globl vector15
vector15:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $15
80106112:	6a 0f                	push   $0xf
  jmp alltraps
80106114:	e9 8e fa ff ff       	jmp    80105ba7 <alltraps>

80106119 <vector16>:
.globl vector16
vector16:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $16
8010611b:	6a 10                	push   $0x10
  jmp alltraps
8010611d:	e9 85 fa ff ff       	jmp    80105ba7 <alltraps>

80106122 <vector17>:
.globl vector17
vector17:
  pushl $17
80106122:	6a 11                	push   $0x11
  jmp alltraps
80106124:	e9 7e fa ff ff       	jmp    80105ba7 <alltraps>

80106129 <vector18>:
.globl vector18
vector18:
  pushl $0
80106129:	6a 00                	push   $0x0
  pushl $18
8010612b:	6a 12                	push   $0x12
  jmp alltraps
8010612d:	e9 75 fa ff ff       	jmp    80105ba7 <alltraps>

80106132 <vector19>:
.globl vector19
vector19:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $19
80106134:	6a 13                	push   $0x13
  jmp alltraps
80106136:	e9 6c fa ff ff       	jmp    80105ba7 <alltraps>

8010613b <vector20>:
.globl vector20
vector20:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $20
8010613d:	6a 14                	push   $0x14
  jmp alltraps
8010613f:	e9 63 fa ff ff       	jmp    80105ba7 <alltraps>

80106144 <vector21>:
.globl vector21
vector21:
  pushl $0
80106144:	6a 00                	push   $0x0
  pushl $21
80106146:	6a 15                	push   $0x15
  jmp alltraps
80106148:	e9 5a fa ff ff       	jmp    80105ba7 <alltraps>

8010614d <vector22>:
.globl vector22
vector22:
  pushl $0
8010614d:	6a 00                	push   $0x0
  pushl $22
8010614f:	6a 16                	push   $0x16
  jmp alltraps
80106151:	e9 51 fa ff ff       	jmp    80105ba7 <alltraps>

80106156 <vector23>:
.globl vector23
vector23:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $23
80106158:	6a 17                	push   $0x17
  jmp alltraps
8010615a:	e9 48 fa ff ff       	jmp    80105ba7 <alltraps>

8010615f <vector24>:
.globl vector24
vector24:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $24
80106161:	6a 18                	push   $0x18
  jmp alltraps
80106163:	e9 3f fa ff ff       	jmp    80105ba7 <alltraps>

80106168 <vector25>:
.globl vector25
vector25:
  pushl $0
80106168:	6a 00                	push   $0x0
  pushl $25
8010616a:	6a 19                	push   $0x19
  jmp alltraps
8010616c:	e9 36 fa ff ff       	jmp    80105ba7 <alltraps>

80106171 <vector26>:
.globl vector26
vector26:
  pushl $0
80106171:	6a 00                	push   $0x0
  pushl $26
80106173:	6a 1a                	push   $0x1a
  jmp alltraps
80106175:	e9 2d fa ff ff       	jmp    80105ba7 <alltraps>

8010617a <vector27>:
.globl vector27
vector27:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $27
8010617c:	6a 1b                	push   $0x1b
  jmp alltraps
8010617e:	e9 24 fa ff ff       	jmp    80105ba7 <alltraps>

80106183 <vector28>:
.globl vector28
vector28:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $28
80106185:	6a 1c                	push   $0x1c
  jmp alltraps
80106187:	e9 1b fa ff ff       	jmp    80105ba7 <alltraps>

8010618c <vector29>:
.globl vector29
vector29:
  pushl $0
8010618c:	6a 00                	push   $0x0
  pushl $29
8010618e:	6a 1d                	push   $0x1d
  jmp alltraps
80106190:	e9 12 fa ff ff       	jmp    80105ba7 <alltraps>

80106195 <vector30>:
.globl vector30
vector30:
  pushl $0
80106195:	6a 00                	push   $0x0
  pushl $30
80106197:	6a 1e                	push   $0x1e
  jmp alltraps
80106199:	e9 09 fa ff ff       	jmp    80105ba7 <alltraps>

8010619e <vector31>:
.globl vector31
vector31:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $31
801061a0:	6a 1f                	push   $0x1f
  jmp alltraps
801061a2:	e9 00 fa ff ff       	jmp    80105ba7 <alltraps>

801061a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $32
801061a9:	6a 20                	push   $0x20
  jmp alltraps
801061ab:	e9 f7 f9 ff ff       	jmp    80105ba7 <alltraps>

801061b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801061b0:	6a 00                	push   $0x0
  pushl $33
801061b2:	6a 21                	push   $0x21
  jmp alltraps
801061b4:	e9 ee f9 ff ff       	jmp    80105ba7 <alltraps>

801061b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801061b9:	6a 00                	push   $0x0
  pushl $34
801061bb:	6a 22                	push   $0x22
  jmp alltraps
801061bd:	e9 e5 f9 ff ff       	jmp    80105ba7 <alltraps>

801061c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $35
801061c4:	6a 23                	push   $0x23
  jmp alltraps
801061c6:	e9 dc f9 ff ff       	jmp    80105ba7 <alltraps>

801061cb <vector36>:
.globl vector36
vector36:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $36
801061cd:	6a 24                	push   $0x24
  jmp alltraps
801061cf:	e9 d3 f9 ff ff       	jmp    80105ba7 <alltraps>

801061d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801061d4:	6a 00                	push   $0x0
  pushl $37
801061d6:	6a 25                	push   $0x25
  jmp alltraps
801061d8:	e9 ca f9 ff ff       	jmp    80105ba7 <alltraps>

801061dd <vector38>:
.globl vector38
vector38:
  pushl $0
801061dd:	6a 00                	push   $0x0
  pushl $38
801061df:	6a 26                	push   $0x26
  jmp alltraps
801061e1:	e9 c1 f9 ff ff       	jmp    80105ba7 <alltraps>

801061e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $39
801061e8:	6a 27                	push   $0x27
  jmp alltraps
801061ea:	e9 b8 f9 ff ff       	jmp    80105ba7 <alltraps>

801061ef <vector40>:
.globl vector40
vector40:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $40
801061f1:	6a 28                	push   $0x28
  jmp alltraps
801061f3:	e9 af f9 ff ff       	jmp    80105ba7 <alltraps>

801061f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061f8:	6a 00                	push   $0x0
  pushl $41
801061fa:	6a 29                	push   $0x29
  jmp alltraps
801061fc:	e9 a6 f9 ff ff       	jmp    80105ba7 <alltraps>

80106201 <vector42>:
.globl vector42
vector42:
  pushl $0
80106201:	6a 00                	push   $0x0
  pushl $42
80106203:	6a 2a                	push   $0x2a
  jmp alltraps
80106205:	e9 9d f9 ff ff       	jmp    80105ba7 <alltraps>

8010620a <vector43>:
.globl vector43
vector43:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $43
8010620c:	6a 2b                	push   $0x2b
  jmp alltraps
8010620e:	e9 94 f9 ff ff       	jmp    80105ba7 <alltraps>

80106213 <vector44>:
.globl vector44
vector44:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $44
80106215:	6a 2c                	push   $0x2c
  jmp alltraps
80106217:	e9 8b f9 ff ff       	jmp    80105ba7 <alltraps>

8010621c <vector45>:
.globl vector45
vector45:
  pushl $0
8010621c:	6a 00                	push   $0x0
  pushl $45
8010621e:	6a 2d                	push   $0x2d
  jmp alltraps
80106220:	e9 82 f9 ff ff       	jmp    80105ba7 <alltraps>

80106225 <vector46>:
.globl vector46
vector46:
  pushl $0
80106225:	6a 00                	push   $0x0
  pushl $46
80106227:	6a 2e                	push   $0x2e
  jmp alltraps
80106229:	e9 79 f9 ff ff       	jmp    80105ba7 <alltraps>

8010622e <vector47>:
.globl vector47
vector47:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $47
80106230:	6a 2f                	push   $0x2f
  jmp alltraps
80106232:	e9 70 f9 ff ff       	jmp    80105ba7 <alltraps>

80106237 <vector48>:
.globl vector48
vector48:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $48
80106239:	6a 30                	push   $0x30
  jmp alltraps
8010623b:	e9 67 f9 ff ff       	jmp    80105ba7 <alltraps>

80106240 <vector49>:
.globl vector49
vector49:
  pushl $0
80106240:	6a 00                	push   $0x0
  pushl $49
80106242:	6a 31                	push   $0x31
  jmp alltraps
80106244:	e9 5e f9 ff ff       	jmp    80105ba7 <alltraps>

80106249 <vector50>:
.globl vector50
vector50:
  pushl $0
80106249:	6a 00                	push   $0x0
  pushl $50
8010624b:	6a 32                	push   $0x32
  jmp alltraps
8010624d:	e9 55 f9 ff ff       	jmp    80105ba7 <alltraps>

80106252 <vector51>:
.globl vector51
vector51:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $51
80106254:	6a 33                	push   $0x33
  jmp alltraps
80106256:	e9 4c f9 ff ff       	jmp    80105ba7 <alltraps>

8010625b <vector52>:
.globl vector52
vector52:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $52
8010625d:	6a 34                	push   $0x34
  jmp alltraps
8010625f:	e9 43 f9 ff ff       	jmp    80105ba7 <alltraps>

80106264 <vector53>:
.globl vector53
vector53:
  pushl $0
80106264:	6a 00                	push   $0x0
  pushl $53
80106266:	6a 35                	push   $0x35
  jmp alltraps
80106268:	e9 3a f9 ff ff       	jmp    80105ba7 <alltraps>

8010626d <vector54>:
.globl vector54
vector54:
  pushl $0
8010626d:	6a 00                	push   $0x0
  pushl $54
8010626f:	6a 36                	push   $0x36
  jmp alltraps
80106271:	e9 31 f9 ff ff       	jmp    80105ba7 <alltraps>

80106276 <vector55>:
.globl vector55
vector55:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $55
80106278:	6a 37                	push   $0x37
  jmp alltraps
8010627a:	e9 28 f9 ff ff       	jmp    80105ba7 <alltraps>

8010627f <vector56>:
.globl vector56
vector56:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $56
80106281:	6a 38                	push   $0x38
  jmp alltraps
80106283:	e9 1f f9 ff ff       	jmp    80105ba7 <alltraps>

80106288 <vector57>:
.globl vector57
vector57:
  pushl $0
80106288:	6a 00                	push   $0x0
  pushl $57
8010628a:	6a 39                	push   $0x39
  jmp alltraps
8010628c:	e9 16 f9 ff ff       	jmp    80105ba7 <alltraps>

80106291 <vector58>:
.globl vector58
vector58:
  pushl $0
80106291:	6a 00                	push   $0x0
  pushl $58
80106293:	6a 3a                	push   $0x3a
  jmp alltraps
80106295:	e9 0d f9 ff ff       	jmp    80105ba7 <alltraps>

8010629a <vector59>:
.globl vector59
vector59:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $59
8010629c:	6a 3b                	push   $0x3b
  jmp alltraps
8010629e:	e9 04 f9 ff ff       	jmp    80105ba7 <alltraps>

801062a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $60
801062a5:	6a 3c                	push   $0x3c
  jmp alltraps
801062a7:	e9 fb f8 ff ff       	jmp    80105ba7 <alltraps>

801062ac <vector61>:
.globl vector61
vector61:
  pushl $0
801062ac:	6a 00                	push   $0x0
  pushl $61
801062ae:	6a 3d                	push   $0x3d
  jmp alltraps
801062b0:	e9 f2 f8 ff ff       	jmp    80105ba7 <alltraps>

801062b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801062b5:	6a 00                	push   $0x0
  pushl $62
801062b7:	6a 3e                	push   $0x3e
  jmp alltraps
801062b9:	e9 e9 f8 ff ff       	jmp    80105ba7 <alltraps>

801062be <vector63>:
.globl vector63
vector63:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $63
801062c0:	6a 3f                	push   $0x3f
  jmp alltraps
801062c2:	e9 e0 f8 ff ff       	jmp    80105ba7 <alltraps>

801062c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $64
801062c9:	6a 40                	push   $0x40
  jmp alltraps
801062cb:	e9 d7 f8 ff ff       	jmp    80105ba7 <alltraps>

801062d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801062d0:	6a 00                	push   $0x0
  pushl $65
801062d2:	6a 41                	push   $0x41
  jmp alltraps
801062d4:	e9 ce f8 ff ff       	jmp    80105ba7 <alltraps>

801062d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801062d9:	6a 00                	push   $0x0
  pushl $66
801062db:	6a 42                	push   $0x42
  jmp alltraps
801062dd:	e9 c5 f8 ff ff       	jmp    80105ba7 <alltraps>

801062e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $67
801062e4:	6a 43                	push   $0x43
  jmp alltraps
801062e6:	e9 bc f8 ff ff       	jmp    80105ba7 <alltraps>

801062eb <vector68>:
.globl vector68
vector68:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $68
801062ed:	6a 44                	push   $0x44
  jmp alltraps
801062ef:	e9 b3 f8 ff ff       	jmp    80105ba7 <alltraps>

801062f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $69
801062f6:	6a 45                	push   $0x45
  jmp alltraps
801062f8:	e9 aa f8 ff ff       	jmp    80105ba7 <alltraps>

801062fd <vector70>:
.globl vector70
vector70:
  pushl $0
801062fd:	6a 00                	push   $0x0
  pushl $70
801062ff:	6a 46                	push   $0x46
  jmp alltraps
80106301:	e9 a1 f8 ff ff       	jmp    80105ba7 <alltraps>

80106306 <vector71>:
.globl vector71
vector71:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $71
80106308:	6a 47                	push   $0x47
  jmp alltraps
8010630a:	e9 98 f8 ff ff       	jmp    80105ba7 <alltraps>

8010630f <vector72>:
.globl vector72
vector72:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $72
80106311:	6a 48                	push   $0x48
  jmp alltraps
80106313:	e9 8f f8 ff ff       	jmp    80105ba7 <alltraps>

80106318 <vector73>:
.globl vector73
vector73:
  pushl $0
80106318:	6a 00                	push   $0x0
  pushl $73
8010631a:	6a 49                	push   $0x49
  jmp alltraps
8010631c:	e9 86 f8 ff ff       	jmp    80105ba7 <alltraps>

80106321 <vector74>:
.globl vector74
vector74:
  pushl $0
80106321:	6a 00                	push   $0x0
  pushl $74
80106323:	6a 4a                	push   $0x4a
  jmp alltraps
80106325:	e9 7d f8 ff ff       	jmp    80105ba7 <alltraps>

8010632a <vector75>:
.globl vector75
vector75:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $75
8010632c:	6a 4b                	push   $0x4b
  jmp alltraps
8010632e:	e9 74 f8 ff ff       	jmp    80105ba7 <alltraps>

80106333 <vector76>:
.globl vector76
vector76:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $76
80106335:	6a 4c                	push   $0x4c
  jmp alltraps
80106337:	e9 6b f8 ff ff       	jmp    80105ba7 <alltraps>

8010633c <vector77>:
.globl vector77
vector77:
  pushl $0
8010633c:	6a 00                	push   $0x0
  pushl $77
8010633e:	6a 4d                	push   $0x4d
  jmp alltraps
80106340:	e9 62 f8 ff ff       	jmp    80105ba7 <alltraps>

80106345 <vector78>:
.globl vector78
vector78:
  pushl $0
80106345:	6a 00                	push   $0x0
  pushl $78
80106347:	6a 4e                	push   $0x4e
  jmp alltraps
80106349:	e9 59 f8 ff ff       	jmp    80105ba7 <alltraps>

8010634e <vector79>:
.globl vector79
vector79:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $79
80106350:	6a 4f                	push   $0x4f
  jmp alltraps
80106352:	e9 50 f8 ff ff       	jmp    80105ba7 <alltraps>

80106357 <vector80>:
.globl vector80
vector80:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $80
80106359:	6a 50                	push   $0x50
  jmp alltraps
8010635b:	e9 47 f8 ff ff       	jmp    80105ba7 <alltraps>

80106360 <vector81>:
.globl vector81
vector81:
  pushl $0
80106360:	6a 00                	push   $0x0
  pushl $81
80106362:	6a 51                	push   $0x51
  jmp alltraps
80106364:	e9 3e f8 ff ff       	jmp    80105ba7 <alltraps>

80106369 <vector82>:
.globl vector82
vector82:
  pushl $0
80106369:	6a 00                	push   $0x0
  pushl $82
8010636b:	6a 52                	push   $0x52
  jmp alltraps
8010636d:	e9 35 f8 ff ff       	jmp    80105ba7 <alltraps>

80106372 <vector83>:
.globl vector83
vector83:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $83
80106374:	6a 53                	push   $0x53
  jmp alltraps
80106376:	e9 2c f8 ff ff       	jmp    80105ba7 <alltraps>

8010637b <vector84>:
.globl vector84
vector84:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $84
8010637d:	6a 54                	push   $0x54
  jmp alltraps
8010637f:	e9 23 f8 ff ff       	jmp    80105ba7 <alltraps>

80106384 <vector85>:
.globl vector85
vector85:
  pushl $0
80106384:	6a 00                	push   $0x0
  pushl $85
80106386:	6a 55                	push   $0x55
  jmp alltraps
80106388:	e9 1a f8 ff ff       	jmp    80105ba7 <alltraps>

8010638d <vector86>:
.globl vector86
vector86:
  pushl $0
8010638d:	6a 00                	push   $0x0
  pushl $86
8010638f:	6a 56                	push   $0x56
  jmp alltraps
80106391:	e9 11 f8 ff ff       	jmp    80105ba7 <alltraps>

80106396 <vector87>:
.globl vector87
vector87:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $87
80106398:	6a 57                	push   $0x57
  jmp alltraps
8010639a:	e9 08 f8 ff ff       	jmp    80105ba7 <alltraps>

8010639f <vector88>:
.globl vector88
vector88:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $88
801063a1:	6a 58                	push   $0x58
  jmp alltraps
801063a3:	e9 ff f7 ff ff       	jmp    80105ba7 <alltraps>

801063a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801063a8:	6a 00                	push   $0x0
  pushl $89
801063aa:	6a 59                	push   $0x59
  jmp alltraps
801063ac:	e9 f6 f7 ff ff       	jmp    80105ba7 <alltraps>

801063b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801063b1:	6a 00                	push   $0x0
  pushl $90
801063b3:	6a 5a                	push   $0x5a
  jmp alltraps
801063b5:	e9 ed f7 ff ff       	jmp    80105ba7 <alltraps>

801063ba <vector91>:
.globl vector91
vector91:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $91
801063bc:	6a 5b                	push   $0x5b
  jmp alltraps
801063be:	e9 e4 f7 ff ff       	jmp    80105ba7 <alltraps>

801063c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $92
801063c5:	6a 5c                	push   $0x5c
  jmp alltraps
801063c7:	e9 db f7 ff ff       	jmp    80105ba7 <alltraps>

801063cc <vector93>:
.globl vector93
vector93:
  pushl $0
801063cc:	6a 00                	push   $0x0
  pushl $93
801063ce:	6a 5d                	push   $0x5d
  jmp alltraps
801063d0:	e9 d2 f7 ff ff       	jmp    80105ba7 <alltraps>

801063d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801063d5:	6a 00                	push   $0x0
  pushl $94
801063d7:	6a 5e                	push   $0x5e
  jmp alltraps
801063d9:	e9 c9 f7 ff ff       	jmp    80105ba7 <alltraps>

801063de <vector95>:
.globl vector95
vector95:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $95
801063e0:	6a 5f                	push   $0x5f
  jmp alltraps
801063e2:	e9 c0 f7 ff ff       	jmp    80105ba7 <alltraps>

801063e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $96
801063e9:	6a 60                	push   $0x60
  jmp alltraps
801063eb:	e9 b7 f7 ff ff       	jmp    80105ba7 <alltraps>

801063f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063f0:	6a 00                	push   $0x0
  pushl $97
801063f2:	6a 61                	push   $0x61
  jmp alltraps
801063f4:	e9 ae f7 ff ff       	jmp    80105ba7 <alltraps>

801063f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063f9:	6a 00                	push   $0x0
  pushl $98
801063fb:	6a 62                	push   $0x62
  jmp alltraps
801063fd:	e9 a5 f7 ff ff       	jmp    80105ba7 <alltraps>

80106402 <vector99>:
.globl vector99
vector99:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $99
80106404:	6a 63                	push   $0x63
  jmp alltraps
80106406:	e9 9c f7 ff ff       	jmp    80105ba7 <alltraps>

8010640b <vector100>:
.globl vector100
vector100:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $100
8010640d:	6a 64                	push   $0x64
  jmp alltraps
8010640f:	e9 93 f7 ff ff       	jmp    80105ba7 <alltraps>

80106414 <vector101>:
.globl vector101
vector101:
  pushl $0
80106414:	6a 00                	push   $0x0
  pushl $101
80106416:	6a 65                	push   $0x65
  jmp alltraps
80106418:	e9 8a f7 ff ff       	jmp    80105ba7 <alltraps>

8010641d <vector102>:
.globl vector102
vector102:
  pushl $0
8010641d:	6a 00                	push   $0x0
  pushl $102
8010641f:	6a 66                	push   $0x66
  jmp alltraps
80106421:	e9 81 f7 ff ff       	jmp    80105ba7 <alltraps>

80106426 <vector103>:
.globl vector103
vector103:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $103
80106428:	6a 67                	push   $0x67
  jmp alltraps
8010642a:	e9 78 f7 ff ff       	jmp    80105ba7 <alltraps>

8010642f <vector104>:
.globl vector104
vector104:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $104
80106431:	6a 68                	push   $0x68
  jmp alltraps
80106433:	e9 6f f7 ff ff       	jmp    80105ba7 <alltraps>

80106438 <vector105>:
.globl vector105
vector105:
  pushl $0
80106438:	6a 00                	push   $0x0
  pushl $105
8010643a:	6a 69                	push   $0x69
  jmp alltraps
8010643c:	e9 66 f7 ff ff       	jmp    80105ba7 <alltraps>

80106441 <vector106>:
.globl vector106
vector106:
  pushl $0
80106441:	6a 00                	push   $0x0
  pushl $106
80106443:	6a 6a                	push   $0x6a
  jmp alltraps
80106445:	e9 5d f7 ff ff       	jmp    80105ba7 <alltraps>

8010644a <vector107>:
.globl vector107
vector107:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $107
8010644c:	6a 6b                	push   $0x6b
  jmp alltraps
8010644e:	e9 54 f7 ff ff       	jmp    80105ba7 <alltraps>

80106453 <vector108>:
.globl vector108
vector108:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $108
80106455:	6a 6c                	push   $0x6c
  jmp alltraps
80106457:	e9 4b f7 ff ff       	jmp    80105ba7 <alltraps>

8010645c <vector109>:
.globl vector109
vector109:
  pushl $0
8010645c:	6a 00                	push   $0x0
  pushl $109
8010645e:	6a 6d                	push   $0x6d
  jmp alltraps
80106460:	e9 42 f7 ff ff       	jmp    80105ba7 <alltraps>

80106465 <vector110>:
.globl vector110
vector110:
  pushl $0
80106465:	6a 00                	push   $0x0
  pushl $110
80106467:	6a 6e                	push   $0x6e
  jmp alltraps
80106469:	e9 39 f7 ff ff       	jmp    80105ba7 <alltraps>

8010646e <vector111>:
.globl vector111
vector111:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $111
80106470:	6a 6f                	push   $0x6f
  jmp alltraps
80106472:	e9 30 f7 ff ff       	jmp    80105ba7 <alltraps>

80106477 <vector112>:
.globl vector112
vector112:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $112
80106479:	6a 70                	push   $0x70
  jmp alltraps
8010647b:	e9 27 f7 ff ff       	jmp    80105ba7 <alltraps>

80106480 <vector113>:
.globl vector113
vector113:
  pushl $0
80106480:	6a 00                	push   $0x0
  pushl $113
80106482:	6a 71                	push   $0x71
  jmp alltraps
80106484:	e9 1e f7 ff ff       	jmp    80105ba7 <alltraps>

80106489 <vector114>:
.globl vector114
vector114:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $114
8010648b:	6a 72                	push   $0x72
  jmp alltraps
8010648d:	e9 15 f7 ff ff       	jmp    80105ba7 <alltraps>

80106492 <vector115>:
.globl vector115
vector115:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $115
80106494:	6a 73                	push   $0x73
  jmp alltraps
80106496:	e9 0c f7 ff ff       	jmp    80105ba7 <alltraps>

8010649b <vector116>:
.globl vector116
vector116:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $116
8010649d:	6a 74                	push   $0x74
  jmp alltraps
8010649f:	e9 03 f7 ff ff       	jmp    80105ba7 <alltraps>

801064a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $117
801064a6:	6a 75                	push   $0x75
  jmp alltraps
801064a8:	e9 fa f6 ff ff       	jmp    80105ba7 <alltraps>

801064ad <vector118>:
.globl vector118
vector118:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $118
801064af:	6a 76                	push   $0x76
  jmp alltraps
801064b1:	e9 f1 f6 ff ff       	jmp    80105ba7 <alltraps>

801064b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $119
801064b8:	6a 77                	push   $0x77
  jmp alltraps
801064ba:	e9 e8 f6 ff ff       	jmp    80105ba7 <alltraps>

801064bf <vector120>:
.globl vector120
vector120:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $120
801064c1:	6a 78                	push   $0x78
  jmp alltraps
801064c3:	e9 df f6 ff ff       	jmp    80105ba7 <alltraps>

801064c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801064c8:	6a 00                	push   $0x0
  pushl $121
801064ca:	6a 79                	push   $0x79
  jmp alltraps
801064cc:	e9 d6 f6 ff ff       	jmp    80105ba7 <alltraps>

801064d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801064d1:	6a 00                	push   $0x0
  pushl $122
801064d3:	6a 7a                	push   $0x7a
  jmp alltraps
801064d5:	e9 cd f6 ff ff       	jmp    80105ba7 <alltraps>

801064da <vector123>:
.globl vector123
vector123:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $123
801064dc:	6a 7b                	push   $0x7b
  jmp alltraps
801064de:	e9 c4 f6 ff ff       	jmp    80105ba7 <alltraps>

801064e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $124
801064e5:	6a 7c                	push   $0x7c
  jmp alltraps
801064e7:	e9 bb f6 ff ff       	jmp    80105ba7 <alltraps>

801064ec <vector125>:
.globl vector125
vector125:
  pushl $0
801064ec:	6a 00                	push   $0x0
  pushl $125
801064ee:	6a 7d                	push   $0x7d
  jmp alltraps
801064f0:	e9 b2 f6 ff ff       	jmp    80105ba7 <alltraps>

801064f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064f5:	6a 00                	push   $0x0
  pushl $126
801064f7:	6a 7e                	push   $0x7e
  jmp alltraps
801064f9:	e9 a9 f6 ff ff       	jmp    80105ba7 <alltraps>

801064fe <vector127>:
.globl vector127
vector127:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $127
80106500:	6a 7f                	push   $0x7f
  jmp alltraps
80106502:	e9 a0 f6 ff ff       	jmp    80105ba7 <alltraps>

80106507 <vector128>:
.globl vector128
vector128:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $128
80106509:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010650e:	e9 94 f6 ff ff       	jmp    80105ba7 <alltraps>

80106513 <vector129>:
.globl vector129
vector129:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $129
80106515:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010651a:	e9 88 f6 ff ff       	jmp    80105ba7 <alltraps>

8010651f <vector130>:
.globl vector130
vector130:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $130
80106521:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106526:	e9 7c f6 ff ff       	jmp    80105ba7 <alltraps>

8010652b <vector131>:
.globl vector131
vector131:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $131
8010652d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106532:	e9 70 f6 ff ff       	jmp    80105ba7 <alltraps>

80106537 <vector132>:
.globl vector132
vector132:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $132
80106539:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010653e:	e9 64 f6 ff ff       	jmp    80105ba7 <alltraps>

80106543 <vector133>:
.globl vector133
vector133:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $133
80106545:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010654a:	e9 58 f6 ff ff       	jmp    80105ba7 <alltraps>

8010654f <vector134>:
.globl vector134
vector134:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $134
80106551:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106556:	e9 4c f6 ff ff       	jmp    80105ba7 <alltraps>

8010655b <vector135>:
.globl vector135
vector135:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $135
8010655d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106562:	e9 40 f6 ff ff       	jmp    80105ba7 <alltraps>

80106567 <vector136>:
.globl vector136
vector136:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $136
80106569:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010656e:	e9 34 f6 ff ff       	jmp    80105ba7 <alltraps>

80106573 <vector137>:
.globl vector137
vector137:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $137
80106575:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010657a:	e9 28 f6 ff ff       	jmp    80105ba7 <alltraps>

8010657f <vector138>:
.globl vector138
vector138:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $138
80106581:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106586:	e9 1c f6 ff ff       	jmp    80105ba7 <alltraps>

8010658b <vector139>:
.globl vector139
vector139:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $139
8010658d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106592:	e9 10 f6 ff ff       	jmp    80105ba7 <alltraps>

80106597 <vector140>:
.globl vector140
vector140:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $140
80106599:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010659e:	e9 04 f6 ff ff       	jmp    80105ba7 <alltraps>

801065a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $141
801065a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801065aa:	e9 f8 f5 ff ff       	jmp    80105ba7 <alltraps>

801065af <vector142>:
.globl vector142
vector142:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $142
801065b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801065b6:	e9 ec f5 ff ff       	jmp    80105ba7 <alltraps>

801065bb <vector143>:
.globl vector143
vector143:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $143
801065bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801065c2:	e9 e0 f5 ff ff       	jmp    80105ba7 <alltraps>

801065c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $144
801065c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801065ce:	e9 d4 f5 ff ff       	jmp    80105ba7 <alltraps>

801065d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $145
801065d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065da:	e9 c8 f5 ff ff       	jmp    80105ba7 <alltraps>

801065df <vector146>:
.globl vector146
vector146:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $146
801065e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065e6:	e9 bc f5 ff ff       	jmp    80105ba7 <alltraps>

801065eb <vector147>:
.globl vector147
vector147:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $147
801065ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065f2:	e9 b0 f5 ff ff       	jmp    80105ba7 <alltraps>

801065f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $148
801065f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065fe:	e9 a4 f5 ff ff       	jmp    80105ba7 <alltraps>

80106603 <vector149>:
.globl vector149
vector149:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $149
80106605:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010660a:	e9 98 f5 ff ff       	jmp    80105ba7 <alltraps>

8010660f <vector150>:
.globl vector150
vector150:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $150
80106611:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106616:	e9 8c f5 ff ff       	jmp    80105ba7 <alltraps>

8010661b <vector151>:
.globl vector151
vector151:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $151
8010661d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106622:	e9 80 f5 ff ff       	jmp    80105ba7 <alltraps>

80106627 <vector152>:
.globl vector152
vector152:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $152
80106629:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010662e:	e9 74 f5 ff ff       	jmp    80105ba7 <alltraps>

80106633 <vector153>:
.globl vector153
vector153:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $153
80106635:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010663a:	e9 68 f5 ff ff       	jmp    80105ba7 <alltraps>

8010663f <vector154>:
.globl vector154
vector154:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $154
80106641:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106646:	e9 5c f5 ff ff       	jmp    80105ba7 <alltraps>

8010664b <vector155>:
.globl vector155
vector155:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $155
8010664d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106652:	e9 50 f5 ff ff       	jmp    80105ba7 <alltraps>

80106657 <vector156>:
.globl vector156
vector156:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $156
80106659:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010665e:	e9 44 f5 ff ff       	jmp    80105ba7 <alltraps>

80106663 <vector157>:
.globl vector157
vector157:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $157
80106665:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010666a:	e9 38 f5 ff ff       	jmp    80105ba7 <alltraps>

8010666f <vector158>:
.globl vector158
vector158:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $158
80106671:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106676:	e9 2c f5 ff ff       	jmp    80105ba7 <alltraps>

8010667b <vector159>:
.globl vector159
vector159:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $159
8010667d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106682:	e9 20 f5 ff ff       	jmp    80105ba7 <alltraps>

80106687 <vector160>:
.globl vector160
vector160:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $160
80106689:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010668e:	e9 14 f5 ff ff       	jmp    80105ba7 <alltraps>

80106693 <vector161>:
.globl vector161
vector161:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $161
80106695:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010669a:	e9 08 f5 ff ff       	jmp    80105ba7 <alltraps>

8010669f <vector162>:
.globl vector162
vector162:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $162
801066a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801066a6:	e9 fc f4 ff ff       	jmp    80105ba7 <alltraps>

801066ab <vector163>:
.globl vector163
vector163:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $163
801066ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801066b2:	e9 f0 f4 ff ff       	jmp    80105ba7 <alltraps>

801066b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $164
801066b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801066be:	e9 e4 f4 ff ff       	jmp    80105ba7 <alltraps>

801066c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $165
801066c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801066ca:	e9 d8 f4 ff ff       	jmp    80105ba7 <alltraps>

801066cf <vector166>:
.globl vector166
vector166:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $166
801066d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066d6:	e9 cc f4 ff ff       	jmp    80105ba7 <alltraps>

801066db <vector167>:
.globl vector167
vector167:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $167
801066dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066e2:	e9 c0 f4 ff ff       	jmp    80105ba7 <alltraps>

801066e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $168
801066e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066ee:	e9 b4 f4 ff ff       	jmp    80105ba7 <alltraps>

801066f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $169
801066f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066fa:	e9 a8 f4 ff ff       	jmp    80105ba7 <alltraps>

801066ff <vector170>:
.globl vector170
vector170:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $170
80106701:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106706:	e9 9c f4 ff ff       	jmp    80105ba7 <alltraps>

8010670b <vector171>:
.globl vector171
vector171:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $171
8010670d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106712:	e9 90 f4 ff ff       	jmp    80105ba7 <alltraps>

80106717 <vector172>:
.globl vector172
vector172:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $172
80106719:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010671e:	e9 84 f4 ff ff       	jmp    80105ba7 <alltraps>

80106723 <vector173>:
.globl vector173
vector173:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $173
80106725:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010672a:	e9 78 f4 ff ff       	jmp    80105ba7 <alltraps>

8010672f <vector174>:
.globl vector174
vector174:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $174
80106731:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106736:	e9 6c f4 ff ff       	jmp    80105ba7 <alltraps>

8010673b <vector175>:
.globl vector175
vector175:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $175
8010673d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106742:	e9 60 f4 ff ff       	jmp    80105ba7 <alltraps>

80106747 <vector176>:
.globl vector176
vector176:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $176
80106749:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010674e:	e9 54 f4 ff ff       	jmp    80105ba7 <alltraps>

80106753 <vector177>:
.globl vector177
vector177:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $177
80106755:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010675a:	e9 48 f4 ff ff       	jmp    80105ba7 <alltraps>

8010675f <vector178>:
.globl vector178
vector178:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $178
80106761:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106766:	e9 3c f4 ff ff       	jmp    80105ba7 <alltraps>

8010676b <vector179>:
.globl vector179
vector179:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $179
8010676d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106772:	e9 30 f4 ff ff       	jmp    80105ba7 <alltraps>

80106777 <vector180>:
.globl vector180
vector180:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $180
80106779:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010677e:	e9 24 f4 ff ff       	jmp    80105ba7 <alltraps>

80106783 <vector181>:
.globl vector181
vector181:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $181
80106785:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010678a:	e9 18 f4 ff ff       	jmp    80105ba7 <alltraps>

8010678f <vector182>:
.globl vector182
vector182:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $182
80106791:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106796:	e9 0c f4 ff ff       	jmp    80105ba7 <alltraps>

8010679b <vector183>:
.globl vector183
vector183:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $183
8010679d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801067a2:	e9 00 f4 ff ff       	jmp    80105ba7 <alltraps>

801067a7 <vector184>:
.globl vector184
vector184:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $184
801067a9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801067ae:	e9 f4 f3 ff ff       	jmp    80105ba7 <alltraps>

801067b3 <vector185>:
.globl vector185
vector185:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $185
801067b5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801067ba:	e9 e8 f3 ff ff       	jmp    80105ba7 <alltraps>

801067bf <vector186>:
.globl vector186
vector186:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $186
801067c1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801067c6:	e9 dc f3 ff ff       	jmp    80105ba7 <alltraps>

801067cb <vector187>:
.globl vector187
vector187:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $187
801067cd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067d2:	e9 d0 f3 ff ff       	jmp    80105ba7 <alltraps>

801067d7 <vector188>:
.globl vector188
vector188:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $188
801067d9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067de:	e9 c4 f3 ff ff       	jmp    80105ba7 <alltraps>

801067e3 <vector189>:
.globl vector189
vector189:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $189
801067e5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067ea:	e9 b8 f3 ff ff       	jmp    80105ba7 <alltraps>

801067ef <vector190>:
.globl vector190
vector190:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $190
801067f1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067f6:	e9 ac f3 ff ff       	jmp    80105ba7 <alltraps>

801067fb <vector191>:
.globl vector191
vector191:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $191
801067fd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106802:	e9 a0 f3 ff ff       	jmp    80105ba7 <alltraps>

80106807 <vector192>:
.globl vector192
vector192:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $192
80106809:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010680e:	e9 94 f3 ff ff       	jmp    80105ba7 <alltraps>

80106813 <vector193>:
.globl vector193
vector193:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $193
80106815:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010681a:	e9 88 f3 ff ff       	jmp    80105ba7 <alltraps>

8010681f <vector194>:
.globl vector194
vector194:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $194
80106821:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106826:	e9 7c f3 ff ff       	jmp    80105ba7 <alltraps>

8010682b <vector195>:
.globl vector195
vector195:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $195
8010682d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106832:	e9 70 f3 ff ff       	jmp    80105ba7 <alltraps>

80106837 <vector196>:
.globl vector196
vector196:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $196
80106839:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010683e:	e9 64 f3 ff ff       	jmp    80105ba7 <alltraps>

80106843 <vector197>:
.globl vector197
vector197:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $197
80106845:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010684a:	e9 58 f3 ff ff       	jmp    80105ba7 <alltraps>

8010684f <vector198>:
.globl vector198
vector198:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $198
80106851:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106856:	e9 4c f3 ff ff       	jmp    80105ba7 <alltraps>

8010685b <vector199>:
.globl vector199
vector199:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $199
8010685d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106862:	e9 40 f3 ff ff       	jmp    80105ba7 <alltraps>

80106867 <vector200>:
.globl vector200
vector200:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $200
80106869:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010686e:	e9 34 f3 ff ff       	jmp    80105ba7 <alltraps>

80106873 <vector201>:
.globl vector201
vector201:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $201
80106875:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010687a:	e9 28 f3 ff ff       	jmp    80105ba7 <alltraps>

8010687f <vector202>:
.globl vector202
vector202:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $202
80106881:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106886:	e9 1c f3 ff ff       	jmp    80105ba7 <alltraps>

8010688b <vector203>:
.globl vector203
vector203:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $203
8010688d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106892:	e9 10 f3 ff ff       	jmp    80105ba7 <alltraps>

80106897 <vector204>:
.globl vector204
vector204:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $204
80106899:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010689e:	e9 04 f3 ff ff       	jmp    80105ba7 <alltraps>

801068a3 <vector205>:
.globl vector205
vector205:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $205
801068a5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801068aa:	e9 f8 f2 ff ff       	jmp    80105ba7 <alltraps>

801068af <vector206>:
.globl vector206
vector206:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $206
801068b1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801068b6:	e9 ec f2 ff ff       	jmp    80105ba7 <alltraps>

801068bb <vector207>:
.globl vector207
vector207:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $207
801068bd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801068c2:	e9 e0 f2 ff ff       	jmp    80105ba7 <alltraps>

801068c7 <vector208>:
.globl vector208
vector208:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $208
801068c9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801068ce:	e9 d4 f2 ff ff       	jmp    80105ba7 <alltraps>

801068d3 <vector209>:
.globl vector209
vector209:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $209
801068d5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068da:	e9 c8 f2 ff ff       	jmp    80105ba7 <alltraps>

801068df <vector210>:
.globl vector210
vector210:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $210
801068e1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068e6:	e9 bc f2 ff ff       	jmp    80105ba7 <alltraps>

801068eb <vector211>:
.globl vector211
vector211:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $211
801068ed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068f2:	e9 b0 f2 ff ff       	jmp    80105ba7 <alltraps>

801068f7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $212
801068f9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068fe:	e9 a4 f2 ff ff       	jmp    80105ba7 <alltraps>

80106903 <vector213>:
.globl vector213
vector213:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $213
80106905:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010690a:	e9 98 f2 ff ff       	jmp    80105ba7 <alltraps>

8010690f <vector214>:
.globl vector214
vector214:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $214
80106911:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106916:	e9 8c f2 ff ff       	jmp    80105ba7 <alltraps>

8010691b <vector215>:
.globl vector215
vector215:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $215
8010691d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106922:	e9 80 f2 ff ff       	jmp    80105ba7 <alltraps>

80106927 <vector216>:
.globl vector216
vector216:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $216
80106929:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010692e:	e9 74 f2 ff ff       	jmp    80105ba7 <alltraps>

80106933 <vector217>:
.globl vector217
vector217:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $217
80106935:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010693a:	e9 68 f2 ff ff       	jmp    80105ba7 <alltraps>

8010693f <vector218>:
.globl vector218
vector218:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $218
80106941:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106946:	e9 5c f2 ff ff       	jmp    80105ba7 <alltraps>

8010694b <vector219>:
.globl vector219
vector219:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $219
8010694d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106952:	e9 50 f2 ff ff       	jmp    80105ba7 <alltraps>

80106957 <vector220>:
.globl vector220
vector220:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $220
80106959:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010695e:	e9 44 f2 ff ff       	jmp    80105ba7 <alltraps>

80106963 <vector221>:
.globl vector221
vector221:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $221
80106965:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010696a:	e9 38 f2 ff ff       	jmp    80105ba7 <alltraps>

8010696f <vector222>:
.globl vector222
vector222:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $222
80106971:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106976:	e9 2c f2 ff ff       	jmp    80105ba7 <alltraps>

8010697b <vector223>:
.globl vector223
vector223:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $223
8010697d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106982:	e9 20 f2 ff ff       	jmp    80105ba7 <alltraps>

80106987 <vector224>:
.globl vector224
vector224:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $224
80106989:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010698e:	e9 14 f2 ff ff       	jmp    80105ba7 <alltraps>

80106993 <vector225>:
.globl vector225
vector225:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $225
80106995:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010699a:	e9 08 f2 ff ff       	jmp    80105ba7 <alltraps>

8010699f <vector226>:
.globl vector226
vector226:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $226
801069a1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801069a6:	e9 fc f1 ff ff       	jmp    80105ba7 <alltraps>

801069ab <vector227>:
.globl vector227
vector227:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $227
801069ad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801069b2:	e9 f0 f1 ff ff       	jmp    80105ba7 <alltraps>

801069b7 <vector228>:
.globl vector228
vector228:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $228
801069b9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801069be:	e9 e4 f1 ff ff       	jmp    80105ba7 <alltraps>

801069c3 <vector229>:
.globl vector229
vector229:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $229
801069c5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801069ca:	e9 d8 f1 ff ff       	jmp    80105ba7 <alltraps>

801069cf <vector230>:
.globl vector230
vector230:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $230
801069d1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069d6:	e9 cc f1 ff ff       	jmp    80105ba7 <alltraps>

801069db <vector231>:
.globl vector231
vector231:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $231
801069dd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069e2:	e9 c0 f1 ff ff       	jmp    80105ba7 <alltraps>

801069e7 <vector232>:
.globl vector232
vector232:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $232
801069e9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069ee:	e9 b4 f1 ff ff       	jmp    80105ba7 <alltraps>

801069f3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $233
801069f5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069fa:	e9 a8 f1 ff ff       	jmp    80105ba7 <alltraps>

801069ff <vector234>:
.globl vector234
vector234:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $234
80106a01:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a06:	e9 9c f1 ff ff       	jmp    80105ba7 <alltraps>

80106a0b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $235
80106a0d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a12:	e9 90 f1 ff ff       	jmp    80105ba7 <alltraps>

80106a17 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $236
80106a19:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a1e:	e9 84 f1 ff ff       	jmp    80105ba7 <alltraps>

80106a23 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $237
80106a25:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a2a:	e9 78 f1 ff ff       	jmp    80105ba7 <alltraps>

80106a2f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $238
80106a31:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a36:	e9 6c f1 ff ff       	jmp    80105ba7 <alltraps>

80106a3b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $239
80106a3d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a42:	e9 60 f1 ff ff       	jmp    80105ba7 <alltraps>

80106a47 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $240
80106a49:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a4e:	e9 54 f1 ff ff       	jmp    80105ba7 <alltraps>

80106a53 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $241
80106a55:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a5a:	e9 48 f1 ff ff       	jmp    80105ba7 <alltraps>

80106a5f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $242
80106a61:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a66:	e9 3c f1 ff ff       	jmp    80105ba7 <alltraps>

80106a6b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $243
80106a6d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a72:	e9 30 f1 ff ff       	jmp    80105ba7 <alltraps>

80106a77 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $244
80106a79:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a7e:	e9 24 f1 ff ff       	jmp    80105ba7 <alltraps>

80106a83 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $245
80106a85:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a8a:	e9 18 f1 ff ff       	jmp    80105ba7 <alltraps>

80106a8f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $246
80106a91:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a96:	e9 0c f1 ff ff       	jmp    80105ba7 <alltraps>

80106a9b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $247
80106a9d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106aa2:	e9 00 f1 ff ff       	jmp    80105ba7 <alltraps>

80106aa7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $248
80106aa9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106aae:	e9 f4 f0 ff ff       	jmp    80105ba7 <alltraps>

80106ab3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $249
80106ab5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106aba:	e9 e8 f0 ff ff       	jmp    80105ba7 <alltraps>

80106abf <vector250>:
.globl vector250
vector250:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $250
80106ac1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ac6:	e9 dc f0 ff ff       	jmp    80105ba7 <alltraps>

80106acb <vector251>:
.globl vector251
vector251:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $251
80106acd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ad2:	e9 d0 f0 ff ff       	jmp    80105ba7 <alltraps>

80106ad7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $252
80106ad9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106ade:	e9 c4 f0 ff ff       	jmp    80105ba7 <alltraps>

80106ae3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $253
80106ae5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106aea:	e9 b8 f0 ff ff       	jmp    80105ba7 <alltraps>

80106aef <vector254>:
.globl vector254
vector254:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $254
80106af1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106af6:	e9 ac f0 ff ff       	jmp    80105ba7 <alltraps>

80106afb <vector255>:
.globl vector255
vector255:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $255
80106afd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b02:	e9 a0 f0 ff ff       	jmp    80105ba7 <alltraps>
80106b07:	66 90                	xchg   %ax,%ax
80106b09:	66 90                	xchg   %ax,%ax
80106b0b:	66 90                	xchg   %ax,%ax
80106b0d:	66 90                	xchg   %ax,%ax
80106b0f:	90                   	nop

80106b10 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	57                   	push   %edi
80106b14:	56                   	push   %esi
80106b15:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106b16:	89 d3                	mov    %edx,%ebx
{
80106b18:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106b1a:	c1 eb 16             	shr    $0x16,%ebx
80106b1d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106b20:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106b23:	8b 06                	mov    (%esi),%eax
80106b25:	a8 01                	test   $0x1,%al
80106b27:	74 27                	je     80106b50 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b2e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106b34:	c1 ef 0a             	shr    $0xa,%edi
}
80106b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106b3a:	89 fa                	mov    %edi,%edx
80106b3c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b42:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106b45:	5b                   	pop    %ebx
80106b46:	5e                   	pop    %esi
80106b47:	5f                   	pop    %edi
80106b48:	5d                   	pop    %ebp
80106b49:	c3                   	ret    
80106b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b50:	85 c9                	test   %ecx,%ecx
80106b52:	74 2c                	je     80106b80 <walkpgdir+0x70>
80106b54:	e8 67 bb ff ff       	call   801026c0 <kalloc>
80106b59:	85 c0                	test   %eax,%eax
80106b5b:	89 c3                	mov    %eax,%ebx
80106b5d:	74 21                	je     80106b80 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106b5f:	83 ec 04             	sub    $0x4,%esp
80106b62:	68 00 10 00 00       	push   $0x1000
80106b67:	6a 00                	push   $0x0
80106b69:	50                   	push   %eax
80106b6a:	e8 81 dd ff ff       	call   801048f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b6f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b75:	83 c4 10             	add    $0x10,%esp
80106b78:	83 c8 07             	or     $0x7,%eax
80106b7b:	89 06                	mov    %eax,(%esi)
80106b7d:	eb b5                	jmp    80106b34 <walkpgdir+0x24>
80106b7f:	90                   	nop
}
80106b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b83:	31 c0                	xor    %eax,%eax
}
80106b85:	5b                   	pop    %ebx
80106b86:	5e                   	pop    %esi
80106b87:	5f                   	pop    %edi
80106b88:	5d                   	pop    %ebp
80106b89:	c3                   	ret    
80106b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b90 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b96:	89 d3                	mov    %edx,%ebx
80106b98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b9e:	83 ec 1c             	sub    $0x1c,%esp
80106ba1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ba4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ba8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106bab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bb6:	29 df                	sub    %ebx,%edi
80106bb8:	83 c8 01             	or     $0x1,%eax
80106bbb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106bbe:	eb 15                	jmp    80106bd5 <mappages+0x45>
    if(*pte & PTE_P)
80106bc0:	f6 00 01             	testb  $0x1,(%eax)
80106bc3:	75 45                	jne    80106c0a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106bc5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106bc8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106bcb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106bcd:	74 31                	je     80106c00 <mappages+0x70>
      break;
    a += PGSIZE;
80106bcf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106bd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bd8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106bdd:	89 da                	mov    %ebx,%edx
80106bdf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106be2:	e8 29 ff ff ff       	call   80106b10 <walkpgdir>
80106be7:	85 c0                	test   %eax,%eax
80106be9:	75 d5                	jne    80106bc0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bf3:	5b                   	pop    %ebx
80106bf4:	5e                   	pop    %esi
80106bf5:	5f                   	pop    %edi
80106bf6:	5d                   	pop    %ebp
80106bf7:	c3                   	ret    
80106bf8:	90                   	nop
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c03:	31 c0                	xor    %eax,%eax
}
80106c05:	5b                   	pop    %ebx
80106c06:	5e                   	pop    %esi
80106c07:	5f                   	pop    %edi
80106c08:	5d                   	pop    %ebp
80106c09:	c3                   	ret    
      panic("remap");
80106c0a:	83 ec 0c             	sub    $0xc,%esp
80106c0d:	68 58 7e 10 80       	push   $0x80107e58
80106c12:	e8 79 97 ff ff       	call   80100390 <panic>
80106c17:	89 f6                	mov    %esi,%esi
80106c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c26:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c2c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106c2e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c34:	83 ec 1c             	sub    $0x1c,%esp
80106c37:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c3a:	39 d3                	cmp    %edx,%ebx
80106c3c:	73 66                	jae    80106ca4 <deallocuvm.part.0+0x84>
80106c3e:	89 d6                	mov    %edx,%esi
80106c40:	eb 3d                	jmp    80106c7f <deallocuvm.part.0+0x5f>
80106c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106c48:	8b 10                	mov    (%eax),%edx
80106c4a:	f6 c2 01             	test   $0x1,%dl
80106c4d:	74 26                	je     80106c75 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106c4f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c55:	74 58                	je     80106caf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106c57:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c5a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106c63:	52                   	push   %edx
80106c64:	e8 a7 b8 ff ff       	call   80102510 <kfree>
      *pte = 0;
80106c69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c6c:	83 c4 10             	add    $0x10,%esp
80106c6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106c75:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c7b:	39 f3                	cmp    %esi,%ebx
80106c7d:	73 25                	jae    80106ca4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106c7f:	31 c9                	xor    %ecx,%ecx
80106c81:	89 da                	mov    %ebx,%edx
80106c83:	89 f8                	mov    %edi,%eax
80106c85:	e8 86 fe ff ff       	call   80106b10 <walkpgdir>
    if(!pte)
80106c8a:	85 c0                	test   %eax,%eax
80106c8c:	75 ba                	jne    80106c48 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c8e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c94:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c9a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ca0:	39 f3                	cmp    %esi,%ebx
80106ca2:	72 db                	jb     80106c7f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106ca4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ca7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106caa:	5b                   	pop    %ebx
80106cab:	5e                   	pop    %esi
80106cac:	5f                   	pop    %edi
80106cad:	5d                   	pop    %ebp
80106cae:	c3                   	ret    
        panic("kfree");
80106caf:	83 ec 0c             	sub    $0xc,%esp
80106cb2:	68 d6 77 10 80       	push   $0x801077d6
80106cb7:	e8 d4 96 ff ff       	call   80100390 <panic>
80106cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106cc0 <seginit>:
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106cc6:	e8 15 cd ff ff       	call   801039e0 <cpuid>
80106ccb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106cd1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106cd6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106cda:	c7 80 58 28 11 80 ff 	movl   $0xffff,-0x7feed7a8(%eax)
80106ce1:	ff 00 00 
80106ce4:	c7 80 5c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7a4(%eax)
80106ceb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cee:	c7 80 60 28 11 80 ff 	movl   $0xffff,-0x7feed7a0(%eax)
80106cf5:	ff 00 00 
80106cf8:	c7 80 64 28 11 80 00 	movl   $0xcf9200,-0x7feed79c(%eax)
80106cff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d02:	c7 80 68 28 11 80 ff 	movl   $0xffff,-0x7feed798(%eax)
80106d09:	ff 00 00 
80106d0c:	c7 80 6c 28 11 80 00 	movl   $0xcffa00,-0x7feed794(%eax)
80106d13:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d16:	c7 80 70 28 11 80 ff 	movl   $0xffff,-0x7feed790(%eax)
80106d1d:	ff 00 00 
80106d20:	c7 80 74 28 11 80 00 	movl   $0xcff200,-0x7feed78c(%eax)
80106d27:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d2a:	05 50 28 11 80       	add    $0x80112850,%eax
  pd[1] = (uint)p;
80106d2f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d33:	c1 e8 10             	shr    $0x10,%eax
80106d36:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d3a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d3d:	0f 01 10             	lgdtl  (%eax)
}
80106d40:	c9                   	leave  
80106d41:	c3                   	ret    
80106d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d50 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d50:	a1 24 67 11 80       	mov    0x80116724,%eax
{
80106d55:	55                   	push   %ebp
80106d56:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d58:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d5d:	0f 22 d8             	mov    %eax,%cr3
}
80106d60:	5d                   	pop    %ebp
80106d61:	c3                   	ret    
80106d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d70 <switchuvm>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 1c             	sub    $0x1c,%esp
80106d79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106d7c:	85 db                	test   %ebx,%ebx
80106d7e:	0f 84 cb 00 00 00    	je     80106e4f <switchuvm+0xdf>
  if(p->kstack == 0)
80106d84:	8b 43 08             	mov    0x8(%ebx),%eax
80106d87:	85 c0                	test   %eax,%eax
80106d89:	0f 84 da 00 00 00    	je     80106e69 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d8f:	8b 43 04             	mov    0x4(%ebx),%eax
80106d92:	85 c0                	test   %eax,%eax
80106d94:	0f 84 c2 00 00 00    	je     80106e5c <switchuvm+0xec>
  pushcli();
80106d9a:	e8 91 d9 ff ff       	call   80104730 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d9f:	e8 bc cb ff ff       	call   80103960 <mycpu>
80106da4:	89 c6                	mov    %eax,%esi
80106da6:	e8 b5 cb ff ff       	call   80103960 <mycpu>
80106dab:	89 c7                	mov    %eax,%edi
80106dad:	e8 ae cb ff ff       	call   80103960 <mycpu>
80106db2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106db5:	83 c7 08             	add    $0x8,%edi
80106db8:	e8 a3 cb ff ff       	call   80103960 <mycpu>
80106dbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106dc0:	83 c0 08             	add    $0x8,%eax
80106dc3:	ba 67 00 00 00       	mov    $0x67,%edx
80106dc8:	c1 e8 18             	shr    $0x18,%eax
80106dcb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106dd2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106dd9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ddf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106de4:	83 c1 08             	add    $0x8,%ecx
80106de7:	c1 e9 10             	shr    $0x10,%ecx
80106dea:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106df0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106df5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dfc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106e01:	e8 5a cb ff ff       	call   80103960 <mycpu>
80106e06:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e0d:	e8 4e cb ff ff       	call   80103960 <mycpu>
80106e12:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e16:	8b 73 08             	mov    0x8(%ebx),%esi
80106e19:	e8 42 cb ff ff       	call   80103960 <mycpu>
80106e1e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e24:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e27:	e8 34 cb ff ff       	call   80103960 <mycpu>
80106e2c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e30:	b8 28 00 00 00       	mov    $0x28,%eax
80106e35:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e38:	8b 43 04             	mov    0x4(%ebx),%eax
80106e3b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e40:	0f 22 d8             	mov    %eax,%cr3
}
80106e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e46:	5b                   	pop    %ebx
80106e47:	5e                   	pop    %esi
80106e48:	5f                   	pop    %edi
80106e49:	5d                   	pop    %ebp
  popcli();
80106e4a:	e9 e1 d9 ff ff       	jmp    80104830 <popcli>
    panic("switchuvm: no process");
80106e4f:	83 ec 0c             	sub    $0xc,%esp
80106e52:	68 5e 7e 10 80       	push   $0x80107e5e
80106e57:	e8 34 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106e5c:	83 ec 0c             	sub    $0xc,%esp
80106e5f:	68 89 7e 10 80       	push   $0x80107e89
80106e64:	e8 27 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106e69:	83 ec 0c             	sub    $0xc,%esp
80106e6c:	68 74 7e 10 80       	push   $0x80107e74
80106e71:	e8 1a 95 ff ff       	call   80100390 <panic>
80106e76:	8d 76 00             	lea    0x0(%esi),%esi
80106e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e80 <inituvm>:
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	53                   	push   %ebx
80106e86:	83 ec 1c             	sub    $0x1c,%esp
80106e89:	8b 75 10             	mov    0x10(%ebp),%esi
80106e8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e8f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e92:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106e98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e9b:	77 49                	ja     80106ee6 <inituvm+0x66>
  mem = kalloc();
80106e9d:	e8 1e b8 ff ff       	call   801026c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106ea2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106ea5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ea7:	68 00 10 00 00       	push   $0x1000
80106eac:	6a 00                	push   $0x0
80106eae:	50                   	push   %eax
80106eaf:	e8 3c da ff ff       	call   801048f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106eb4:	58                   	pop    %eax
80106eb5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ebb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ec0:	5a                   	pop    %edx
80106ec1:	6a 06                	push   $0x6
80106ec3:	50                   	push   %eax
80106ec4:	31 d2                	xor    %edx,%edx
80106ec6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ec9:	e8 c2 fc ff ff       	call   80106b90 <mappages>
  memmove(mem, init, sz);
80106ece:	89 75 10             	mov    %esi,0x10(%ebp)
80106ed1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106ed4:	83 c4 10             	add    $0x10,%esp
80106ed7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106edd:	5b                   	pop    %ebx
80106ede:	5e                   	pop    %esi
80106edf:	5f                   	pop    %edi
80106ee0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ee1:	e9 ba da ff ff       	jmp    801049a0 <memmove>
    panic("inituvm: more than a page");
80106ee6:	83 ec 0c             	sub    $0xc,%esp
80106ee9:	68 9d 7e 10 80       	push   $0x80107e9d
80106eee:	e8 9d 94 ff ff       	call   80100390 <panic>
80106ef3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f00 <loaduvm>:
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106f09:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106f10:	0f 85 91 00 00 00    	jne    80106fa7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106f16:	8b 75 18             	mov    0x18(%ebp),%esi
80106f19:	31 db                	xor    %ebx,%ebx
80106f1b:	85 f6                	test   %esi,%esi
80106f1d:	75 1a                	jne    80106f39 <loaduvm+0x39>
80106f1f:	eb 6f                	jmp    80106f90 <loaduvm+0x90>
80106f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f28:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f2e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106f34:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106f37:	76 57                	jbe    80106f90 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f39:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f3c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3f:	31 c9                	xor    %ecx,%ecx
80106f41:	01 da                	add    %ebx,%edx
80106f43:	e8 c8 fb ff ff       	call   80106b10 <walkpgdir>
80106f48:	85 c0                	test   %eax,%eax
80106f4a:	74 4e                	je     80106f9a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106f4c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f4e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f51:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f5b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f61:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f64:	01 d9                	add    %ebx,%ecx
80106f66:	05 00 00 00 80       	add    $0x80000000,%eax
80106f6b:	57                   	push   %edi
80106f6c:	51                   	push   %ecx
80106f6d:	50                   	push   %eax
80106f6e:	ff 75 10             	pushl  0x10(%ebp)
80106f71:	e8 ea ab ff ff       	call   80101b60 <readi>
80106f76:	83 c4 10             	add    $0x10,%esp
80106f79:	39 f8                	cmp    %edi,%eax
80106f7b:	74 ab                	je     80106f28 <loaduvm+0x28>
}
80106f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f85:	5b                   	pop    %ebx
80106f86:	5e                   	pop    %esi
80106f87:	5f                   	pop    %edi
80106f88:	5d                   	pop    %ebp
80106f89:	c3                   	ret    
80106f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f93:	31 c0                	xor    %eax,%eax
}
80106f95:	5b                   	pop    %ebx
80106f96:	5e                   	pop    %esi
80106f97:	5f                   	pop    %edi
80106f98:	5d                   	pop    %ebp
80106f99:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f9a:	83 ec 0c             	sub    $0xc,%esp
80106f9d:	68 b7 7e 10 80       	push   $0x80107eb7
80106fa2:	e8 e9 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106fa7:	83 ec 0c             	sub    $0xc,%esp
80106faa:	68 58 7f 10 80       	push   $0x80107f58
80106faf:	e8 dc 93 ff ff       	call   80100390 <panic>
80106fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106fc0 <sharevm>:
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
80106fc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fcc:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fcf:	8b 55 10             	mov    0x10(%ebp),%edx
  if(sharedmemo.recs[idx]>0){
80106fd2:	8d 59 08             	lea    0x8(%ecx),%ebx
80106fd5:	8b 04 9d c8 a5 10 80 	mov    -0x7fef5a38(,%ebx,4),%eax
80106fdc:	85 c0                	test   %eax,%eax
80106fde:	74 48                	je     80107028 <sharevm+0x68>
    mem=sharedmemo.shared[idx];
80106fe0:	8b 34 8d c0 a5 10 80 	mov    -0x7fef5a40(,%ecx,4),%esi
  if(mappages(pgdir, (char*)(KERNBASE-(nshared+1)*PGSIZE), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fe7:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106fed:	83 ec 08             	sub    $0x8,%esp
80106ff0:	f7 da                	neg    %edx
80106ff2:	6a 06                	push   $0x6
80106ff4:	c1 e2 0c             	shl    $0xc,%edx
80106ff7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ffc:	50                   	push   %eax
80106ffd:	81 c2 00 f0 ff 7f    	add    $0x7ffff000,%edx
80107003:	89 f8                	mov    %edi,%eax
80107005:	e8 86 fb ff ff       	call   80106b90 <mappages>
8010700a:	83 c4 10             	add    $0x10,%esp
8010700d:	85 c0                	test   %eax,%eax
8010700f:	78 5f                	js     80107070 <sharevm+0xb0>
  sharedmemo.recs[idx]++;
80107011:	83 04 9d c8 a5 10 80 	addl   $0x1,-0x7fef5a38(,%ebx,4)
80107018:	01 
}
80107019:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010701c:	5b                   	pop    %ebx
8010701d:	5e                   	pop    %esi
8010701e:	5f                   	pop    %edi
8010701f:	5d                   	pop    %ebp
80107020:	c3                   	ret    
80107021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107028:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010702b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    mem = kalloc();
8010702e:	e8 8d b6 ff ff       	call   801026c0 <kalloc>
    if(mem == 0){
80107033:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107035:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107037:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010703a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010703d:	74 51                	je     80107090 <sharevm+0xd0>
    memset(mem, 0, PGSIZE);
8010703f:	83 ec 04             	sub    $0x4,%esp
80107042:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107045:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107048:	68 00 10 00 00       	push   $0x1000
8010704d:	6a 00                	push   $0x0
8010704f:	50                   	push   %eax
80107050:	e8 9b d8 ff ff       	call   801048f0 <memset>
    sharedmemo.shared[idx]=mem;
80107055:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107058:	83 c4 10             	add    $0x10,%esp
8010705b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010705e:	89 34 8d c0 a5 10 80 	mov    %esi,-0x7fef5a40(,%ecx,4)
80107065:	eb 80                	jmp    80106fe7 <sharevm+0x27>
80107067:	89 f6                	mov    %esi,%esi
80107069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("allocuvm out of memory (2)\n");
80107070:	83 ec 0c             	sub    $0xc,%esp
80107073:	68 ed 7e 10 80       	push   $0x80107eed
80107078:	e8 63 96 ff ff       	call   801006e0 <cprintf>
    kfree(mem);
8010707d:	89 75 08             	mov    %esi,0x8(%ebp)
80107080:	83 c4 10             	add    $0x10,%esp
}
80107083:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107086:	5b                   	pop    %ebx
80107087:	5e                   	pop    %esi
80107088:	5f                   	pop    %edi
80107089:	5d                   	pop    %ebp
    kfree(mem);
8010708a:	e9 81 b4 ff ff       	jmp    80102510 <kfree>
8010708f:	90                   	nop
      cprintf("allocuvm out of memory\n");
80107090:	c7 45 08 d5 7e 10 80 	movl   $0x80107ed5,0x8(%ebp)
}
80107097:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709a:	5b                   	pop    %ebx
8010709b:	5e                   	pop    %esi
8010709c:	5f                   	pop    %edi
8010709d:	5d                   	pop    %ebp
      cprintf("allocuvm out of memory\n");
8010709e:	e9 3d 96 ff ff       	jmp    801006e0 <cprintf>
801070a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070b0 <allocuvm>:
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	57                   	push   %edi
801070b4:	56                   	push   %esi
801070b5:	53                   	push   %ebx
801070b6:	83 ec 0c             	sub    $0xc,%esp
  if(newsz >= KERNBASE-nshared*PGSIZE)
801070b9:	8b 45 14             	mov    0x14(%ebp),%eax
{
801070bc:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE-nshared*PGSIZE)
801070bf:	f7 d8                	neg    %eax
801070c1:	c1 e0 0c             	shl    $0xc,%eax
801070c4:	05 00 00 00 80       	add    $0x80000000,%eax
801070c9:	39 f8                	cmp    %edi,%eax
801070cb:	0f 86 7f 00 00 00    	jbe    80107150 <allocuvm+0xa0>
  if(newsz < oldsz)
801070d1:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801070d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801070d7:	72 79                	jb     80107152 <allocuvm+0xa2>
  a = PGROUNDUP(oldsz);
801070d9:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801070df:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801070e5:	39 df                	cmp    %ebx,%edi
801070e7:	77 42                	ja     8010712b <allocuvm+0x7b>
801070e9:	eb 75                	jmp    80107160 <allocuvm+0xb0>
801070eb:	90                   	nop
801070ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801070f0:	83 ec 04             	sub    $0x4,%esp
801070f3:	68 00 10 00 00       	push   $0x1000
801070f8:	6a 00                	push   $0x0
801070fa:	50                   	push   %eax
801070fb:	e8 f0 d7 ff ff       	call   801048f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107100:	58                   	pop    %eax
80107101:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107107:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010710c:	5a                   	pop    %edx
8010710d:	6a 06                	push   $0x6
8010710f:	50                   	push   %eax
80107110:	89 da                	mov    %ebx,%edx
80107112:	8b 45 08             	mov    0x8(%ebp),%eax
80107115:	e8 76 fa ff ff       	call   80106b90 <mappages>
8010711a:	83 c4 10             	add    $0x10,%esp
8010711d:	85 c0                	test   %eax,%eax
8010711f:	78 4f                	js     80107170 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107121:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107127:	39 df                	cmp    %ebx,%edi
80107129:	76 35                	jbe    80107160 <allocuvm+0xb0>
    mem = kalloc();
8010712b:	e8 90 b5 ff ff       	call   801026c0 <kalloc>
    if(mem == 0){
80107130:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107132:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107134:	75 ba                	jne    801070f0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107136:	83 ec 0c             	sub    $0xc,%esp
80107139:	68 d5 7e 10 80       	push   $0x80107ed5
8010713e:	e8 9d 95 ff ff       	call   801006e0 <cprintf>
  if(newsz >= oldsz)
80107143:	83 c4 10             	add    $0x10,%esp
80107146:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107149:	77 5d                	ja     801071a8 <allocuvm+0xf8>
8010714b:	90                   	nop
8010714c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
80107150:	31 c0                	xor    %eax,%eax
}
80107152:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107155:	5b                   	pop    %ebx
80107156:	5e                   	pop    %esi
80107157:	5f                   	pop    %edi
80107158:	5d                   	pop    %ebp
80107159:	c3                   	ret    
8010715a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return newsz;
80107163:	89 f8                	mov    %edi,%eax
}
80107165:	5b                   	pop    %ebx
80107166:	5e                   	pop    %esi
80107167:	5f                   	pop    %edi
80107168:	5d                   	pop    %ebp
80107169:	c3                   	ret    
8010716a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107170:	83 ec 0c             	sub    $0xc,%esp
80107173:	68 ed 7e 10 80       	push   $0x80107eed
80107178:	e8 63 95 ff ff       	call   801006e0 <cprintf>
  if(newsz >= oldsz)
8010717d:	83 c4 10             	add    $0x10,%esp
80107180:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107183:	76 0d                	jbe    80107192 <allocuvm+0xe2>
80107185:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107188:	8b 45 08             	mov    0x8(%ebp),%eax
8010718b:	89 fa                	mov    %edi,%edx
8010718d:	e8 8e fa ff ff       	call   80106c20 <deallocuvm.part.0>
      kfree(mem);
80107192:	83 ec 0c             	sub    $0xc,%esp
80107195:	56                   	push   %esi
80107196:	e8 75 b3 ff ff       	call   80102510 <kfree>
      return 0;
8010719b:	83 c4 10             	add    $0x10,%esp
8010719e:	31 c0                	xor    %eax,%eax
801071a0:	eb b0                	jmp    80107152 <allocuvm+0xa2>
801071a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071ab:	8b 45 08             	mov    0x8(%ebp),%eax
801071ae:	89 fa                	mov    %edi,%edx
801071b0:	e8 6b fa ff ff       	call   80106c20 <deallocuvm.part.0>
      return 0;
801071b5:	31 c0                	xor    %eax,%eax
801071b7:	eb 99                	jmp    80107152 <allocuvm+0xa2>
801071b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071c0 <deallocuvm>:
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801071c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801071c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801071cc:	39 d1                	cmp    %edx,%ecx
801071ce:	73 10                	jae    801071e0 <deallocuvm+0x20>
}
801071d0:	5d                   	pop    %ebp
801071d1:	e9 4a fa ff ff       	jmp    80106c20 <deallocuvm.part.0>
801071d6:	8d 76 00             	lea    0x0(%esi),%esi
801071d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801071e0:	89 d0                	mov    %edx,%eax
801071e2:	5d                   	pop    %ebp
801071e3:	c3                   	ret    
801071e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071f0 <desharevm>:

void
desharevm(int idx)
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(sharedmemo.recs[idx]<=0)
801071f6:	8d 51 08             	lea    0x8(%ecx),%edx
801071f9:	8b 04 95 c8 a5 10 80 	mov    -0x7fef5a38(,%edx,4),%eax
80107200:	85 c0                	test   %eax,%eax
80107202:	74 0e                	je     80107212 <desharevm+0x22>
    return;

  sharedmemo.recs[idx]--;
80107204:	83 e8 01             	sub    $0x1,%eax
  if(sharedmemo.recs[idx]<=0){
80107207:	85 c0                	test   %eax,%eax
  sharedmemo.recs[idx]--;
80107209:	89 04 95 c8 a5 10 80 	mov    %eax,-0x7fef5a38(,%edx,4)
  if(sharedmemo.recs[idx]<=0){
80107210:	74 06                	je     80107218 <desharevm+0x28>
    kfree(sharedmemo.shared[idx]);
  }
}
80107212:	5d                   	pop    %ebp
80107213:	c3                   	ret    
80107214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(sharedmemo.shared[idx]);
80107218:	8b 04 8d c0 a5 10 80 	mov    -0x7fef5a40(,%ecx,4),%eax
8010721f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80107222:	5d                   	pop    %ebp
    kfree(sharedmemo.shared[idx]);
80107223:	e9 e8 b2 ff ff       	jmp    80102510 <kfree>
80107228:	90                   	nop
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107230 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir,uint nshared)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	53                   	push   %ebx
80107236:	83 ec 0c             	sub    $0xc,%esp
80107239:	8b 75 08             	mov    0x8(%ebp),%esi
8010723c:	8b 45 0c             	mov    0xc(%ebp),%eax
  uint i;

  if(pgdir == 0)
8010723f:	85 f6                	test   %esi,%esi
80107241:	74 61                	je     801072a4 <freevm+0x74>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE-nshared*PGSIZE, 0);
80107243:	f7 d8                	neg    %eax
80107245:	c1 e0 0c             	shl    $0xc,%eax
  if(newsz >= oldsz)
80107248:	05 00 00 00 80       	add    $0x80000000,%eax
8010724d:	89 c2                	mov    %eax,%edx
8010724f:	75 48                	jne    80107299 <freevm+0x69>
80107251:	89 f3                	mov    %esi,%ebx
80107253:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107259:	eb 0c                	jmp    80107267 <freevm+0x37>
8010725b:	90                   	nop
8010725c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107260:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107263:	39 fb                	cmp    %edi,%ebx
80107265:	74 23                	je     8010728a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107267:	8b 03                	mov    (%ebx),%eax
80107269:	a8 01                	test   $0x1,%al
8010726b:	74 f3                	je     80107260 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010726d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107272:	83 ec 0c             	sub    $0xc,%esp
80107275:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107278:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010727d:	50                   	push   %eax
8010727e:	e8 8d b2 ff ff       	call   80102510 <kfree>
80107283:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107286:	39 fb                	cmp    %edi,%ebx
80107288:	75 dd                	jne    80107267 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010728a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010728d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107290:	5b                   	pop    %ebx
80107291:	5e                   	pop    %esi
80107292:	5f                   	pop    %edi
80107293:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107294:	e9 77 b2 ff ff       	jmp    80102510 <kfree>
80107299:	31 c9                	xor    %ecx,%ecx
8010729b:	89 f0                	mov    %esi,%eax
8010729d:	e8 7e f9 ff ff       	call   80106c20 <deallocuvm.part.0>
801072a2:	eb ad                	jmp    80107251 <freevm+0x21>
    panic("freevm: no pgdir");
801072a4:	83 ec 0c             	sub    $0xc,%esp
801072a7:	68 09 7f 10 80       	push   $0x80107f09
801072ac:	e8 df 90 ff ff       	call   80100390 <panic>
801072b1:	eb 0d                	jmp    801072c0 <setupkvm>
801072b3:	90                   	nop
801072b4:	90                   	nop
801072b5:	90                   	nop
801072b6:	90                   	nop
801072b7:	90                   	nop
801072b8:	90                   	nop
801072b9:	90                   	nop
801072ba:	90                   	nop
801072bb:	90                   	nop
801072bc:	90                   	nop
801072bd:	90                   	nop
801072be:	90                   	nop
801072bf:	90                   	nop

801072c0 <setupkvm>:
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	56                   	push   %esi
801072c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801072c5:	e8 f6 b3 ff ff       	call   801026c0 <kalloc>
801072ca:	85 c0                	test   %eax,%eax
801072cc:	89 c6                	mov    %eax,%esi
801072ce:	74 42                	je     80107312 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801072d0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801072d3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801072d8:	68 00 10 00 00       	push   $0x1000
801072dd:	6a 00                	push   $0x0
801072df:	50                   	push   %eax
801072e0:	e8 0b d6 ff ff       	call   801048f0 <memset>
801072e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801072e8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801072eb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801072ee:	83 ec 08             	sub    $0x8,%esp
801072f1:	8b 13                	mov    (%ebx),%edx
801072f3:	ff 73 0c             	pushl  0xc(%ebx)
801072f6:	50                   	push   %eax
801072f7:	29 c1                	sub    %eax,%ecx
801072f9:	89 f0                	mov    %esi,%eax
801072fb:	e8 90 f8 ff ff       	call   80106b90 <mappages>
80107300:	83 c4 10             	add    $0x10,%esp
80107303:	85 c0                	test   %eax,%eax
80107305:	78 19                	js     80107320 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107307:	83 c3 10             	add    $0x10,%ebx
8010730a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107310:	75 d6                	jne    801072e8 <setupkvm+0x28>
}
80107312:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107315:	89 f0                	mov    %esi,%eax
80107317:	5b                   	pop    %ebx
80107318:	5e                   	pop    %esi
80107319:	5d                   	pop    %ebp
8010731a:	c3                   	ret    
8010731b:	90                   	nop
8010731c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir,0);
80107320:	83 ec 08             	sub    $0x8,%esp
80107323:	6a 00                	push   $0x0
80107325:	56                   	push   %esi
      return 0;
80107326:	31 f6                	xor    %esi,%esi
      freevm(pgdir,0);
80107328:	e8 03 ff ff ff       	call   80107230 <freevm>
      return 0;
8010732d:	83 c4 10             	add    $0x10,%esp
}
80107330:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107333:	89 f0                	mov    %esi,%eax
80107335:	5b                   	pop    %ebx
80107336:	5e                   	pop    %esi
80107337:	5d                   	pop    %ebp
80107338:	c3                   	ret    
80107339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107340 <kvmalloc>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107346:	e8 75 ff ff ff       	call   801072c0 <setupkvm>
8010734b:	a3 24 67 11 80       	mov    %eax,0x80116724
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107350:	05 00 00 00 80       	add    $0x80000000,%eax
80107355:	0f 22 d8             	mov    %eax,%cr3
}
80107358:	c9                   	leave  
80107359:	c3                   	ret    
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107360 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107360:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107361:	31 c9                	xor    %ecx,%ecx
{
80107363:	89 e5                	mov    %esp,%ebp
80107365:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107368:	8b 55 0c             	mov    0xc(%ebp),%edx
8010736b:	8b 45 08             	mov    0x8(%ebp),%eax
8010736e:	e8 9d f7 ff ff       	call   80106b10 <walkpgdir>
  if(pte == 0)
80107373:	85 c0                	test   %eax,%eax
80107375:	74 05                	je     8010737c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107377:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010737a:	c9                   	leave  
8010737b:	c3                   	ret    
    panic("clearpteu");
8010737c:	83 ec 0c             	sub    $0xc,%esp
8010737f:	68 1a 7f 10 80       	push   $0x80107f1a
80107384:	e8 07 90 ff ff       	call   80100390 <panic>
80107389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107390 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	53                   	push   %ebx
80107396:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107399:	e8 22 ff ff ff       	call   801072c0 <setupkvm>
8010739e:	85 c0                	test   %eax,%eax
801073a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801073a3:	0f 84 a2 00 00 00    	je     8010744b <copyuvm+0xbb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801073a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073ac:	85 c9                	test   %ecx,%ecx
801073ae:	0f 84 97 00 00 00    	je     8010744b <copyuvm+0xbb>
801073b4:	31 f6                	xor    %esi,%esi
801073b6:	eb 4e                	jmp    80107406 <copyuvm+0x76>
801073b8:	90                   	nop
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801073c0:	83 ec 04             	sub    $0x4,%esp
801073c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801073c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073cc:	68 00 10 00 00       	push   $0x1000
801073d1:	57                   	push   %edi
801073d2:	50                   	push   %eax
801073d3:	e8 c8 d5 ff ff       	call   801049a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801073d8:	58                   	pop    %eax
801073d9:	5a                   	pop    %edx
801073da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801073dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073e5:	53                   	push   %ebx
801073e6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801073ec:	52                   	push   %edx
801073ed:	89 f2                	mov    %esi,%edx
801073ef:	e8 9c f7 ff ff       	call   80106b90 <mappages>
801073f4:	83 c4 10             	add    $0x10,%esp
801073f7:	85 c0                	test   %eax,%eax
801073f9:	78 39                	js     80107434 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
801073fb:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107401:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107404:	76 45                	jbe    8010744b <copyuvm+0xbb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107406:	8b 45 08             	mov    0x8(%ebp),%eax
80107409:	31 c9                	xor    %ecx,%ecx
8010740b:	89 f2                	mov    %esi,%edx
8010740d:	e8 fe f6 ff ff       	call   80106b10 <walkpgdir>
80107412:	85 c0                	test   %eax,%eax
80107414:	74 40                	je     80107456 <copyuvm+0xc6>
    if(!(*pte & PTE_P))
80107416:	8b 18                	mov    (%eax),%ebx
80107418:	f6 c3 01             	test   $0x1,%bl
8010741b:	74 46                	je     80107463 <copyuvm+0xd3>
    pa = PTE_ADDR(*pte);
8010741d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010741f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107425:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010742b:	e8 90 b2 ff ff       	call   801026c0 <kalloc>
80107430:	85 c0                	test   %eax,%eax
80107432:	75 8c                	jne    801073c0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d,0);
80107434:	83 ec 08             	sub    $0x8,%esp
80107437:	6a 00                	push   $0x0
80107439:	ff 75 e0             	pushl  -0x20(%ebp)
8010743c:	e8 ef fd ff ff       	call   80107230 <freevm>
  return 0;
80107441:	83 c4 10             	add    $0x10,%esp
80107444:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
8010744b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010744e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107451:	5b                   	pop    %ebx
80107452:	5e                   	pop    %esi
80107453:	5f                   	pop    %edi
80107454:	5d                   	pop    %ebp
80107455:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107456:	83 ec 0c             	sub    $0xc,%esp
80107459:	68 24 7f 10 80       	push   $0x80107f24
8010745e:	e8 2d 8f ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107463:	83 ec 0c             	sub    $0xc,%esp
80107466:	68 3e 7f 10 80       	push   $0x80107f3e
8010746b:	e8 20 8f ff ff       	call   80100390 <panic>

80107470 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107470:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107471:	31 c9                	xor    %ecx,%ecx
{
80107473:	89 e5                	mov    %esp,%ebp
80107475:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107478:	8b 55 0c             	mov    0xc(%ebp),%edx
8010747b:	8b 45 08             	mov    0x8(%ebp),%eax
8010747e:	e8 8d f6 ff ff       	call   80106b10 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107483:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107485:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107486:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107488:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010748d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107490:	05 00 00 00 80       	add    $0x80000000,%eax
80107495:	83 fa 05             	cmp    $0x5,%edx
80107498:	ba 00 00 00 00       	mov    $0x0,%edx
8010749d:	0f 45 c2             	cmovne %edx,%eax
}
801074a0:	c3                   	ret    
801074a1:	eb 0d                	jmp    801074b0 <copyout>
801074a3:	90                   	nop
801074a4:	90                   	nop
801074a5:	90                   	nop
801074a6:	90                   	nop
801074a7:	90                   	nop
801074a8:	90                   	nop
801074a9:	90                   	nop
801074aa:	90                   	nop
801074ab:	90                   	nop
801074ac:	90                   	nop
801074ad:	90                   	nop
801074ae:	90                   	nop
801074af:	90                   	nop

801074b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
801074b6:	83 ec 1c             	sub    $0x1c,%esp
801074b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801074bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801074bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801074c2:	85 db                	test   %ebx,%ebx
801074c4:	75 40                	jne    80107506 <copyout+0x56>
801074c6:	eb 70                	jmp    80107538 <copyout+0x88>
801074c8:	90                   	nop
801074c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801074d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074d3:	89 f1                	mov    %esi,%ecx
801074d5:	29 d1                	sub    %edx,%ecx
801074d7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801074dd:	39 d9                	cmp    %ebx,%ecx
801074df:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801074e2:	29 f2                	sub    %esi,%edx
801074e4:	83 ec 04             	sub    $0x4,%esp
801074e7:	01 d0                	add    %edx,%eax
801074e9:	51                   	push   %ecx
801074ea:	57                   	push   %edi
801074eb:	50                   	push   %eax
801074ec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801074ef:	e8 ac d4 ff ff       	call   801049a0 <memmove>
    len -= n;
    buf += n;
801074f4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801074f7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801074fa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107500:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107502:	29 cb                	sub    %ecx,%ebx
80107504:	74 32                	je     80107538 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107506:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107508:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010750b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010750e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107514:	56                   	push   %esi
80107515:	ff 75 08             	pushl  0x8(%ebp)
80107518:	e8 53 ff ff ff       	call   80107470 <uva2ka>
    if(pa0 == 0)
8010751d:	83 c4 10             	add    $0x10,%esp
80107520:	85 c0                	test   %eax,%eax
80107522:	75 ac                	jne    801074d0 <copyout+0x20>
  }
  return 0;
}
80107524:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010752c:	5b                   	pop    %ebx
8010752d:	5e                   	pop    %esi
8010752e:	5f                   	pop    %edi
8010752f:	5d                   	pop    %ebp
80107530:	c3                   	ret    
80107531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107538:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010753b:	31 c0                	xor    %eax,%eax
}
8010753d:	5b                   	pop    %ebx
8010753e:	5e                   	pop    %esi
8010753f:	5f                   	pop    %edi
80107540:	5d                   	pop    %ebp
80107541:	c3                   	ret    
