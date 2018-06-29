
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
8010002d:	b8 20 34 10 80       	mov    $0x80103420,%eax
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
8010004c:	68 c0 7a 10 80       	push   $0x80107ac0
80100051:	68 40 c6 10 80       	push   $0x8010c640
80100056:	e8 25 4a 00 00       	call   80104a80 <initlock>
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
80100092:	68 c7 7a 10 80       	push   $0x80107ac7
80100097:	50                   	push   %eax
80100098:	e8 d3 48 00 00       	call   80104970 <initsleeplock>
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
801000e4:	e8 97 4a 00 00       	call   80104b80 <acquire>
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
80100162:	e8 39 4b 00 00       	call   80104ca0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 48 00 00       	call   801049b0 <acquiresleep>
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
8010018c:	e8 df 24 00 00       	call   80102670 <iderw>
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
801001a3:	68 ce 7a 10 80       	push   $0x80107ace
801001a8:	e8 33 02 00 00       	call   801003e0 <panic>
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
801001be:	e8 8d 48 00 00       	call   80104a50 <holdingsleep>
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
801001d4:	e9 97 24 00 00       	jmp    80102670 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 7a 10 80       	push   $0x80107adf
801001e1:	e8 fa 01 00 00       	call   801003e0 <panic>
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
801001ff:	e8 4c 48 00 00       	call   80104a50 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 fc 47 00 00       	call   80104a10 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010021b:	e8 60 49 00 00       	call   80104b80 <acquire>
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
8010026c:	e9 2f 4a 00 00       	jmp    80104ca0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 7a 10 80       	push   $0x80107ae6
80100279:	e8 62 01 00 00       	call   801003e0 <panic>
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
8010028f:	e8 dc 19 00 00       	call   80101c70 <iunlock>
  target = n;
  acquire(&cons.lock);
80100294:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010029b:	e8 e0 48 00 00       	call   80104b80 <acquire>
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
801002b4:	8b 15 40 10 11 80    	mov    0x80111040,%edx
801002ba:	39 15 44 10 11 80    	cmp    %edx,0x80111044
801002c0:	74 29                	je     801002eb <consoleread+0x6b>
801002c2:	eb 5c                	jmp    80100320 <consoleread+0xa0>
801002c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 40 b5 10 80       	push   $0x8010b540
801002d0:	68 40 10 11 80       	push   $0x80111040
801002d5:	e8 66 43 00 00       	call   80104640 <sleep>
    while(input.r == input.w){
801002da:	8b 15 40 10 11 80    	mov    0x80111040,%edx
801002e0:	83 c4 10             	add    $0x10,%esp
801002e3:	3b 15 44 10 11 80    	cmp    0x80111044,%edx
801002e9:	75 35                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002eb:	e8 d0 3a 00 00       	call   80103dc0 <myproc>
801002f0:	8b 48 24             	mov    0x24(%eax),%ecx
801002f3:	85 c9                	test   %ecx,%ecx
801002f5:	74 d1                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f7:	83 ec 0c             	sub    $0xc,%esp
801002fa:	68 40 b5 10 80       	push   $0x8010b540
801002ff:	e8 9c 49 00 00       	call   80104ca0 <release>
        ilock(ip);
80100304:	5a                   	pop    %edx
80100305:	ff 75 08             	pushl  0x8(%ebp)
80100308:	e8 83 18 00 00       	call   80101b90 <ilock>
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
80100323:	a3 40 10 11 80       	mov    %eax,0x80111040
80100328:	89 d0                	mov    %edx,%eax
8010032a:	83 e0 7f             	and    $0x7f,%eax
8010032d:	0f be 80 c0 0f 11 80 	movsbl -0x7feef040(%eax),%eax
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
8010035d:	e8 3e 49 00 00       	call   80104ca0 <release>
  ilock(ip);
80100362:	58                   	pop    %eax
80100363:	ff 75 08             	pushl  0x8(%ebp)
80100366:	e8 25 18 00 00       	call   80101b90 <ilock>
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
80100387:	89 15 40 10 11 80    	mov    %edx,0x80111040
8010038d:	eb c3                	jmp    80100352 <consoleread+0xd2>
8010038f:	90                   	nop

80100390 <display.part.1>:
display(int f)
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100394:	be d4 03 00 00       	mov    $0x3d4,%esi
80100399:	53                   	push   %ebx
    memset(adr, 0, sizeof(adr[0])*(23*80));
8010039a:	83 ec 04             	sub    $0x4,%esp
8010039d:	68 60 0e 00 00       	push   $0xe60
801003a2:	6a 00                	push   $0x0
801003a4:	68 00 80 0b 80       	push   $0x800b8000
801003a9:	e8 42 49 00 00       	call   80104cf0 <memset>
801003ae:	b8 0e 00 00 00       	mov    $0xe,%eax
801003b3:	89 f2                	mov    %esi,%edx
801003b5:	ee                   	out    %al,(%dx)
801003b6:	31 c9                	xor    %ecx,%ecx
801003b8:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003bd:	89 c8                	mov    %ecx,%eax
801003bf:	89 da                	mov    %ebx,%edx
801003c1:	ee                   	out    %al,(%dx)
801003c2:	b8 0f 00 00 00       	mov    $0xf,%eax
801003c7:	89 f2                	mov    %esi,%edx
801003c9:	ee                   	out    %al,(%dx)
801003ca:	89 c8                	mov    %ecx,%eax
801003cc:	89 da                	mov    %ebx,%edx
801003ce:	ee                   	out    %al,(%dx)
801003cf:	83 c4 10             	add    $0x10,%esp
}
801003d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801003d5:	5b                   	pop    %ebx
801003d6:	5e                   	pop    %esi
801003d7:	5d                   	pop    %ebp
801003d8:	c3                   	ret    
801003d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801003e0 <panic>:
{
801003e0:	55                   	push   %ebp
801003e1:	89 e5                	mov    %esp,%ebp
801003e3:	56                   	push   %esi
801003e4:	53                   	push   %ebx
801003e5:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
801003e8:	fa                   	cli    
  cons.locking = 0;
801003e9:	c7 05 74 b5 10 80 00 	movl   $0x0,0x8010b574
801003f0:	00 00 00 
  getcallerpcs(&s, pcs);
801003f3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003f6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003f9:	e8 a2 28 00 00       	call   80102ca0 <lapicid>
801003fe:	83 ec 08             	sub    $0x8,%esp
80100401:	50                   	push   %eax
80100402:	68 ed 7a 10 80       	push   $0x80107aed
80100407:	e8 e4 02 00 00       	call   801006f0 <cprintf>
  cprintf(s);
8010040c:	58                   	pop    %eax
8010040d:	ff 75 08             	pushl  0x8(%ebp)
80100410:	e8 db 02 00 00       	call   801006f0 <cprintf>
  cprintf("\n");
80100415:	c7 04 24 79 84 10 80 	movl   $0x80108479,(%esp)
8010041c:	e8 cf 02 00 00       	call   801006f0 <cprintf>
  getcallerpcs(&s, pcs);
80100421:	8d 45 08             	lea    0x8(%ebp),%eax
80100424:	5a                   	pop    %edx
80100425:	59                   	pop    %ecx
80100426:	53                   	push   %ebx
80100427:	50                   	push   %eax
80100428:	e8 73 46 00 00       	call   80104aa0 <getcallerpcs>
  for(i=0; i<10; i++)
8010042d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100430:	83 ec 08             	sub    $0x8,%esp
80100433:	ff 33                	pushl  (%ebx)
80100435:	83 c3 04             	add    $0x4,%ebx
80100438:	68 01 7b 10 80       	push   $0x80107b01
8010043d:	e8 ae 02 00 00       	call   801006f0 <cprintf>
  for(i=0; i<10; i++)
80100442:	83 c4 10             	add    $0x10,%esp
80100445:	39 f3                	cmp    %esi,%ebx
80100447:	75 e7                	jne    80100430 <panic+0x50>
  panicked = 1; // freeze other CPU
80100449:	c7 05 78 b5 10 80 01 	movl   $0x1,0x8010b578
80100450:	00 00 00 
    ;
80100453:	eb fe                	jmp    80100453 <panic+0x73>
80100455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100460 <consputc>:
  if(panicked){
80100460:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
80100466:	85 d2                	test   %edx,%edx
80100468:	74 06                	je     80100470 <consputc+0x10>
8010046a:	fa                   	cli    
      ;
8010046b:	eb fe                	jmp    8010046b <consputc+0xb>
8010046d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100470:	55                   	push   %ebp
80100471:	89 e5                	mov    %esp,%ebp
80100473:	57                   	push   %edi
80100474:	56                   	push   %esi
80100475:	89 c6                	mov    %eax,%esi
80100477:	53                   	push   %ebx
80100478:	83 ec 0c             	sub    $0xc,%esp
  if(mycpu()->consflag)
8010047b:	e8 a0 38 00 00       	call   80103d20 <mycpu>
80100480:	80 b8 b4 00 00 00 00 	cmpb   $0x0,0xb4(%eax)
80100487:	0f 85 db 00 00 00    	jne    80100568 <consputc+0x108>
  if(c == BACKSPACE){
8010048d:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100493:	74 0e                	je     801004a3 <consputc+0x43>
    uartputc(c);
80100495:	83 ec 0c             	sub    $0xc,%esp
80100498:	56                   	push   %esi
80100499:	e8 42 61 00 00       	call   801065e0 <uartputc>
8010049e:	83 c4 10             	add    $0x10,%esp
801004a1:	eb 25                	jmp    801004c8 <consputc+0x68>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004a3:	83 ec 0c             	sub    $0xc,%esp
801004a6:	6a 08                	push   $0x8
801004a8:	e8 33 61 00 00       	call   801065e0 <uartputc>
801004ad:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004b4:	e8 27 61 00 00       	call   801065e0 <uartputc>
801004b9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004c0:	e8 1b 61 00 00       	call   801065e0 <uartputc>
801004c5:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004c8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004cd:	b8 0e 00 00 00       	mov    $0xe,%eax
801004d2:	89 da                	mov    %ebx,%edx
801004d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801004d5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004da:	89 ca                	mov    %ecx,%edx
801004dc:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801004dd:	0f b6 f8             	movzbl %al,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004e0:	89 da                	mov    %ebx,%edx
801004e2:	b8 0f 00 00 00       	mov    $0xf,%eax
801004e7:	c1 e7 08             	shl    $0x8,%edi
801004ea:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801004eb:	89 ca                	mov    %ecx,%edx
801004ed:	ec                   	in     (%dx),%al
801004ee:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
801004f1:	09 fb                	or     %edi,%ebx
  if(c == '\n')
801004f3:	83 fe 0a             	cmp    $0xa,%esi
801004f6:	0f 84 b8 00 00 00    	je     801005b4 <consputc+0x154>
  else if(c == BACKSPACE){
801004fc:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100502:	0f 84 c8 00 00 00    	je     801005d0 <consputc+0x170>
    crt[pos] = (c&0xff) | 0x0b00;  // black on white
80100508:	89 f0                	mov    %esi,%eax
8010050a:	0f b6 c0             	movzbl %al,%eax
8010050d:	80 cc 0b             	or     $0xb,%ah
80100510:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100517:	80 
    pos++;
80100518:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 24*80)
8010051b:	81 fb 80 07 00 00    	cmp    $0x780,%ebx
80100521:	0f 87 b5 00 00 00    	ja     801005dc <consputc+0x17c>
  if((pos/80) >= 23){  // Scroll up.
80100527:	81 fb 2f 07 00 00    	cmp    $0x72f,%ebx
8010052d:	77 41                	ja     80100570 <consputc+0x110>
8010052f:	0f b6 f7             	movzbl %bh,%esi
80100532:	89 d9                	mov    %ebx,%ecx
80100534:	8d 9c 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010053b:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100540:	b8 0e 00 00 00       	mov    $0xe,%eax
80100545:	89 fa                	mov    %edi,%edx
80100547:	ee                   	out    %al,(%dx)
80100548:	ba d5 03 00 00       	mov    $0x3d5,%edx
8010054d:	89 f0                	mov    %esi,%eax
8010054f:	ee                   	out    %al,(%dx)
80100550:	b8 0f 00 00 00       	mov    $0xf,%eax
80100555:	89 fa                	mov    %edi,%edx
80100557:	ee                   	out    %al,(%dx)
80100558:	ba d5 03 00 00       	mov    $0x3d5,%edx
8010055d:	89 c8                	mov    %ecx,%eax
8010055f:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100560:	b8 20 07 00 00       	mov    $0x720,%eax
80100565:	66 89 03             	mov    %ax,(%ebx)
}
80100568:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010056b:	5b                   	pop    %ebx
8010056c:	5e                   	pop    %esi
8010056d:	5f                   	pop    %edi
8010056e:	5d                   	pop    %ebp
8010056f:	c3                   	ret    
    memmove(crt, crt+80, sizeof(crt[0])*22*80);
80100570:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100573:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memmove(crt, crt+80, sizeof(crt[0])*22*80);
80100576:	68 c0 0d 00 00       	push   $0xdc0
    memset(crt+pos, 0, sizeof(crt[0])*(23*80 - pos));
8010057b:	8d 9c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*22*80);
80100582:	68 a0 80 0b 80       	push   $0x800b80a0
80100587:	68 00 80 0b 80       	push   $0x800b8000
8010058c:	e8 ff 47 00 00       	call   80104d90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(23*80 - pos));
80100591:	89 f8                	mov    %edi,%eax
80100593:	83 c4 0c             	add    $0xc,%esp
80100596:	f7 d8                	neg    %eax
80100598:	8d 84 00 60 0e 00 00 	lea    0xe60(%eax,%eax,1),%eax
8010059f:	50                   	push   %eax
801005a0:	6a 00                	push   $0x0
801005a2:	53                   	push   %ebx
801005a3:	e8 48 47 00 00       	call   80104cf0 <memset>
801005a8:	89 f8                	mov    %edi,%eax
801005aa:	89 f9                	mov    %edi,%ecx
801005ac:	83 c4 10             	add    $0x10,%esp
801005af:	0f b6 f4             	movzbl %ah,%esi
801005b2:	eb 87                	jmp    8010053b <consputc+0xdb>
    pos += 80 - pos%80;
801005b4:	89 d8                	mov    %ebx,%eax
801005b6:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801005bb:	f7 e2                	mul    %edx
801005bd:	89 d0                	mov    %edx,%eax
801005bf:	c1 e8 06             	shr    $0x6,%eax
801005c2:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
801005c5:	c1 e3 04             	shl    $0x4,%ebx
801005c8:	83 c3 50             	add    $0x50,%ebx
801005cb:	e9 4b ff ff ff       	jmp    8010051b <consputc+0xbb>
    if(pos > 0)
801005d0:	85 db                	test   %ebx,%ebx
801005d2:	74 1c                	je     801005f0 <consputc+0x190>
      --pos;
801005d4:	83 eb 01             	sub    $0x1,%ebx
801005d7:	e9 3f ff ff ff       	jmp    8010051b <consputc+0xbb>
    panic("pos under/overflow");
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 05 7b 10 80       	push   $0x80107b05
801005e4:	e8 f7 fd ff ff       	call   801003e0 <panic>
801005e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0)
801005f0:	bb 00 80 0b 80       	mov    $0x800b8000,%ebx
801005f5:	31 c9                	xor    %ecx,%ecx
801005f7:	31 f6                	xor    %esi,%esi
801005f9:	e9 3d ff ff ff       	jmp    8010053b <consputc+0xdb>
801005fe:	66 90                	xchg   %ax,%ax

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	89 d3                	mov    %edx,%ebx
80100608:	83 ec 2c             	sub    $0x2c,%esp
8010060b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010060e:	85 c9                	test   %ecx,%ecx
80100610:	74 04                	je     80100616 <printint+0x16>
80100612:	85 c0                	test   %eax,%eax
80100614:	78 6a                	js     80100680 <printint+0x80>
    x = xx;
80100616:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010061d:	89 c1                	mov    %eax,%ecx
  i = 0;
8010061f:	31 f6                	xor    %esi,%esi
80100621:	eb 09                	jmp    8010062c <printint+0x2c>
80100623:	90                   	nop
80100624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }while((x /= base) != 0);
80100628:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010062a:	89 fe                	mov    %edi,%esi
8010062c:	89 c8                	mov    %ecx,%eax
8010062e:	31 d2                	xor    %edx,%edx
80100630:	8d 7e 01             	lea    0x1(%esi),%edi
80100633:	f7 f3                	div    %ebx
80100635:	0f b6 92 58 7b 10 80 	movzbl -0x7fef84a8(%edx),%edx
8010063c:	88 54 3d d7          	mov    %dl,-0x29(%ebp,%edi,1)
  }while((x /= base) != 0);
80100640:	39 d9                	cmp    %ebx,%ecx
80100642:	73 e4                	jae    80100628 <printint+0x28>
  if(sign)
80100644:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100647:	85 c0                	test   %eax,%eax
80100649:	74 0c                	je     80100657 <printint+0x57>
    buf[i++] = '-';
8010064b:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
80100650:	89 fe                	mov    %edi,%esi
    buf[i++] = '-';
80100652:	ba 2d 00 00 00       	mov    $0x2d,%edx
80100657:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065b:	0f be c2             	movsbl %dl,%eax
8010065e:	eb 06                	jmp    80100666 <printint+0x66>
80100660:	0f be 03             	movsbl (%ebx),%eax
80100663:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
80100666:	e8 f5 fd ff ff       	call   80100460 <consputc>
  while(--i >= 0)
8010066b:	8d 45 d7             	lea    -0x29(%ebp),%eax
8010066e:	39 c3                	cmp    %eax,%ebx
80100670:	75 ee                	jne    80100660 <printint+0x60>
}
80100672:	83 c4 2c             	add    $0x2c,%esp
80100675:	5b                   	pop    %ebx
80100676:	5e                   	pop    %esi
80100677:	5f                   	pop    %edi
80100678:	5d                   	pop    %ebp
80100679:	c3                   	ret    
8010067a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = -xx;
80100680:	f7 d8                	neg    %eax
80100682:	89 c1                	mov    %eax,%ecx
80100684:	eb 99                	jmp    8010061f <printint+0x1f>
80100686:	8d 76 00             	lea    0x0(%esi),%esi
80100689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100690 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100690:	55                   	push   %ebp
80100691:	89 e5                	mov    %esp,%ebp
80100693:	57                   	push   %edi
80100694:	56                   	push   %esi
80100695:	53                   	push   %ebx
80100696:	83 ec 18             	sub    $0x18,%esp
  int i;


  iunlock(ip);
80100699:	ff 75 08             	pushl  0x8(%ebp)
{
8010069c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010069f:	e8 cc 15 00 00       	call   80101c70 <iunlock>
  acquire(&cons.lock);
801006a4:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
801006ab:	e8 d0 44 00 00       	call   80104b80 <acquire>
  for(i = 0; i < n; i++)
801006b0:	83 c4 10             	add    $0x10,%esp
801006b3:	85 f6                	test   %esi,%esi
801006b5:	7e 18                	jle    801006cf <consolewrite+0x3f>
801006b7:	8b 7d 0c             	mov    0xc(%ebp),%edi
801006ba:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
801006bd:	8d 76 00             	lea    0x0(%esi),%esi
  {
    consputc(buf[i] & 0xff);
801006c0:	0f b6 07             	movzbl (%edi),%eax
801006c3:	83 c7 01             	add    $0x1,%edi
801006c6:	e8 95 fd ff ff       	call   80100460 <consputc>
  for(i = 0; i < n; i++)
801006cb:	39 fb                	cmp    %edi,%ebx
801006cd:	75 f1                	jne    801006c0 <consolewrite+0x30>
  }
  release(&cons.lock);
801006cf:	83 ec 0c             	sub    $0xc,%esp
801006d2:	68 40 b5 10 80       	push   $0x8010b540
801006d7:	e8 c4 45 00 00       	call   80104ca0 <release>
  ilock(ip);
801006dc:	58                   	pop    %eax
801006dd:	ff 75 08             	pushl  0x8(%ebp)
801006e0:	e8 ab 14 00 00       	call   80101b90 <ilock>

  return n;
}
801006e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006e8:	89 f0                	mov    %esi,%eax
801006ea:	5b                   	pop    %ebx
801006eb:	5e                   	pop    %esi
801006ec:	5f                   	pop    %edi
801006ed:	5d                   	pop    %ebp
801006ee:	c3                   	ret    
801006ef:	90                   	nop

801006f0 <cprintf>:
{
801006f0:	55                   	push   %ebp
801006f1:	89 e5                	mov    %esp,%ebp
801006f3:	57                   	push   %edi
801006f4:	56                   	push   %esi
801006f5:	53                   	push   %ebx
801006f6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006f9:	a1 74 b5 10 80       	mov    0x8010b574,%eax
801006fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if(locking)
80100701:	85 c0                	test   %eax,%eax
80100703:	0f 85 67 01 00 00    	jne    80100870 <cprintf+0x180>
  if (fmt == 0)
80100709:	8b 45 08             	mov    0x8(%ebp),%eax
8010070c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010070f:	85 c0                	test   %eax,%eax
80100711:	0f 84 89 01 00 00    	je     801008a0 <cprintf+0x1b0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100717:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
8010071a:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071d:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010071f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	85 c0                	test   %eax,%eax
80100724:	75 58                	jne    8010077e <cprintf+0x8e>
80100726:	eb 78                	jmp    801007a0 <cprintf+0xb0>
80100728:	90                   	nop
80100729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[++i] & 0xff;
80100730:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
80100733:	85 d2                	test   %edx,%edx
80100735:	74 69                	je     801007a0 <cprintf+0xb0>
    switch(c){
80100737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073a:	83 c3 02             	add    $0x2,%ebx
8010073d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80100740:	83 fa 70             	cmp    $0x70,%edx
80100743:	0f 84 df 00 00 00    	je     80100828 <cprintf+0x138>
80100749:	7f 6d                	jg     801007b8 <cprintf+0xc8>
8010074b:	83 fa 25             	cmp    $0x25,%edx
8010074e:	0f 84 f4 00 00 00    	je     80100848 <cprintf+0x158>
80100754:	83 fa 64             	cmp    $0x64,%edx
80100757:	0f 85 a8 00 00 00    	jne    80100805 <cprintf+0x115>
      printint(*argp++, 10, 1);
8010075d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100760:	b9 01 00 00 00       	mov    $0x1,%ecx
80100765:	ba 0a 00 00 00       	mov    $0xa,%edx
8010076a:	8d 78 04             	lea    0x4(%eax),%edi
8010076d:	8b 00                	mov    (%eax),%eax
8010076f:	e8 8c fe ff ff       	call   80100600 <printint>
80100774:	89 7d e0             	mov    %edi,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100777:	0f b6 06             	movzbl (%esi),%eax
8010077a:	85 c0                	test   %eax,%eax
8010077c:	74 22                	je     801007a0 <cprintf+0xb0>
    if(c != '%'){
8010077e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80100781:	8d 7b 01             	lea    0x1(%ebx),%edi
80100784:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80100787:	83 f8 25             	cmp    $0x25,%eax
8010078a:	74 a4                	je     80100730 <cprintf+0x40>
      consputc(c);
8010078c:	e8 cf fc ff ff       	call   80100460 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100791:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100794:	89 fb                	mov    %edi,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100796:	85 c0                	test   %eax,%eax
80100798:	75 e4                	jne    8010077e <cprintf+0x8e>
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
801007a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801007a3:	85 c0                	test   %eax,%eax
801007a5:	0f 85 dd 00 00 00    	jne    80100888 <cprintf+0x198>
}
801007ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007ae:	5b                   	pop    %ebx
801007af:	5e                   	pop    %esi
801007b0:	5f                   	pop    %edi
801007b1:	5d                   	pop    %ebp
801007b2:	c3                   	ret    
801007b3:	90                   	nop
801007b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007b8:	83 fa 73             	cmp    $0x73,%edx
801007bb:	75 43                	jne    80100800 <cprintf+0x110>
      if((s = (char*)*argp++) == 0)
801007bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007c0:	8b 10                	mov    (%eax),%edx
801007c2:	8d 48 04             	lea    0x4(%eax),%ecx
801007c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801007c8:	85 d2                	test   %edx,%edx
801007ca:	0f 84 90 00 00 00    	je     80100860 <cprintf+0x170>
      for(; *s; s++)
801007d0:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
801007d3:	89 d7                	mov    %edx,%edi
801007d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      for(; *s; s++)
801007d8:	84 c0                	test   %al,%al
801007da:	74 9b                	je     80100777 <cprintf+0x87>
801007dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        consputc(*s);
801007e0:	e8 7b fc ff ff       	call   80100460 <consputc>
      for(; *s; s++)
801007e5:	83 c7 01             	add    $0x1,%edi
801007e8:	0f be 07             	movsbl (%edi),%eax
801007eb:	84 c0                	test   %al,%al
801007ed:	75 f1                	jne    801007e0 <cprintf+0xf0>
      if((s = (char*)*argp++) == 0)
801007ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
801007f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007f5:	e9 7d ff ff ff       	jmp    80100777 <cprintf+0x87>
801007fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100800:	83 fa 78             	cmp    $0x78,%edx
80100803:	74 23                	je     80100828 <cprintf+0x138>
      consputc('%');
80100805:	b8 25 00 00 00       	mov    $0x25,%eax
8010080a:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010080d:	e8 4e fc ff ff       	call   80100460 <consputc>
      consputc(c);
80100812:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100815:	89 d0                	mov    %edx,%eax
80100817:	e8 44 fc ff ff       	call   80100460 <consputc>
      break;
8010081c:	e9 56 ff ff ff       	jmp    80100777 <cprintf+0x87>
80100821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
80100828:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010082b:	31 c9                	xor    %ecx,%ecx
8010082d:	ba 10 00 00 00       	mov    $0x10,%edx
80100832:	8d 78 04             	lea    0x4(%eax),%edi
80100835:	8b 00                	mov    (%eax),%eax
80100837:	e8 c4 fd ff ff       	call   80100600 <printint>
8010083c:	89 7d e0             	mov    %edi,-0x20(%ebp)
      break;
8010083f:	e9 33 ff ff ff       	jmp    80100777 <cprintf+0x87>
80100844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100848:	b8 25 00 00 00       	mov    $0x25,%eax
8010084d:	e8 0e fc ff ff       	call   80100460 <consputc>
      break;
80100852:	e9 20 ff ff ff       	jmp    80100777 <cprintf+0x87>
80100857:	89 f6                	mov    %esi,%esi
80100859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        s = "(null)";
80100860:	bf 18 7b 10 80       	mov    $0x80107b18,%edi
      for(; *s; s++)
80100865:	b8 28 00 00 00       	mov    $0x28,%eax
8010086a:	e9 71 ff ff ff       	jmp    801007e0 <cprintf+0xf0>
8010086f:	90                   	nop
    acquire(&cons.lock);
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 40 b5 10 80       	push   $0x8010b540
80100878:	e8 03 43 00 00       	call   80104b80 <acquire>
8010087d:	83 c4 10             	add    $0x10,%esp
80100880:	e9 84 fe ff ff       	jmp    80100709 <cprintf+0x19>
80100885:	8d 76 00             	lea    0x0(%esi),%esi
    release(&cons.lock);
80100888:	83 ec 0c             	sub    $0xc,%esp
8010088b:	68 40 b5 10 80       	push   $0x8010b540
80100890:	e8 0b 44 00 00       	call   80104ca0 <release>
80100895:	83 c4 10             	add    $0x10,%esp
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    panic("null fmt");
801008a0:	83 ec 0c             	sub    $0xc,%esp
801008a3:	68 1f 7b 10 80       	push   $0x80107b1f
801008a8:	e8 33 fb ff ff       	call   801003e0 <panic>
801008ad:	8d 76 00             	lea    0x0(%esi),%esi

801008b0 <show>:
{
801008b0:	55                   	push   %ebp
801008b1:	89 e5                	mov    %esp,%ebp
801008b3:	57                   	push   %edi
801008b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801008b7:	8b 7d 08             	mov    0x8(%ebp),%edi
801008ba:	56                   	push   %esi
801008bb:	8b 75 0c             	mov    0xc(%ebp),%esi
801008be:	53                   	push   %ebx
801008bf:	0f b7 5d 14          	movzwl 0x14(%ebp),%ebx
  for(i=0;i<n;i++)
801008c3:	85 c9                	test   %ecx,%ecx
801008c5:	7e 1b                	jle    801008e2 <show+0x32>
801008c7:	31 c0                	xor    %eax,%eax
801008c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    crt[i]= str[i] | cl;
801008d0:	66 0f be 14 06       	movsbw (%esi,%eax,1),%dx
801008d5:	09 da                	or     %ebx,%edx
801008d7:	66 89 14 47          	mov    %dx,(%edi,%eax,2)
  for(i=0;i<n;i++)
801008db:	83 c0 01             	add    $0x1,%eax
801008de:	39 c1                	cmp    %eax,%ecx
801008e0:	75 ee                	jne    801008d0 <show+0x20>
}
801008e2:	5b                   	pop    %ebx
801008e3:	5e                   	pop    %esi
801008e4:	5f                   	pop    %edi
801008e5:	5d                   	pop    %ebp
801008e6:	c3                   	ret    
801008e7:	89 f6                	mov    %esi,%esi
801008e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801008f0 <tostring>:
{
801008f0:	55                   	push   %ebp
801008f1:	89 e5                	mov    %esp,%ebp
801008f3:	57                   	push   %edi
801008f4:	56                   	push   %esi
801008f5:	53                   	push   %ebx
801008f6:	83 ec 04             	sub    $0x4,%esp
801008f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(t>0)
801008fc:	85 db                	test   %ebx,%ebx
801008fe:	7e 70                	jle    80100970 <tostring+0x80>
80100900:	89 de                	mov    %ebx,%esi
  int s=0,t=n,res;
80100902:	31 c9                	xor    %ecx,%ecx
80100904:	eb 0e                	jmp    80100914 <tostring+0x24>
80100906:	8d 76 00             	lea    0x0(%esi),%esi
80100909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    t/=10;
80100910:	89 d6                	mov    %edx,%esi
    s++;
80100912:	89 f9                	mov    %edi,%ecx
    t/=10;
80100914:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
    s++;
80100919:	8d 79 01             	lea    0x1(%ecx),%edi
    t/=10;
8010091c:	f7 e6                	mul    %esi
8010091e:	c1 ea 03             	shr    $0x3,%edx
  while(t>0)
80100921:	83 fe 09             	cmp    $0x9,%esi
80100924:	7f ea                	jg     80100910 <tostring+0x20>
  str[s]=0;
80100926:	8b 45 08             	mov    0x8(%ebp),%eax
    str[--s]=n%10+'0';
80100929:	be cd cc cc cc       	mov    $0xcccccccd,%esi
8010092e:	89 7d f0             	mov    %edi,-0x10(%ebp)
  str[s]=0;
80100931:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
  while(n>0)
80100935:	01 c1                	add    %eax,%ecx
80100937:	eb 09                	jmp    80100942 <tostring+0x52>
80100939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
80100940:	89 d3                	mov    %edx,%ebx
    str[--s]=n%10+'0';
80100942:	89 d8                	mov    %ebx,%eax
80100944:	89 df                	mov    %ebx,%edi
80100946:	83 e9 01             	sub    $0x1,%ecx
80100949:	f7 e6                	mul    %esi
8010094b:	c1 ea 03             	shr    $0x3,%edx
8010094e:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100951:	01 c0                	add    %eax,%eax
80100953:	29 c7                	sub    %eax,%edi
80100955:	89 f8                	mov    %edi,%eax
80100957:	83 c0 30             	add    $0x30,%eax
8010095a:	88 41 01             	mov    %al,0x1(%ecx)
  while(n>0)
8010095d:	83 fb 09             	cmp    $0x9,%ebx
80100960:	7f de                	jg     80100940 <tostring+0x50>
80100962:	8b 7d f0             	mov    -0x10(%ebp),%edi
}
80100965:	83 c4 04             	add    $0x4,%esp
80100968:	5b                   	pop    %ebx
80100969:	5e                   	pop    %esi
8010096a:	89 f8                	mov    %edi,%eax
8010096c:	5f                   	pop    %edi
8010096d:	5d                   	pop    %ebp
8010096e:	c3                   	ret    
8010096f:	90                   	nop
  str[s]=0;
80100970:	8b 45 08             	mov    0x8(%ebp),%eax
  int s=0,t=n,res;
80100973:	31 ff                	xor    %edi,%edi
  str[s]=0;
80100975:	c6 00 00             	movb   $0x0,(%eax)
}
80100978:	83 c4 04             	add    $0x4,%esp
8010097b:	89 f8                	mov    %edi,%eax
8010097d:	5b                   	pop    %ebx
8010097e:	5e                   	pop    %esi
8010097f:	5f                   	pop    %edi
80100980:	5d                   	pop    %ebp
80100981:	c3                   	ret    
80100982:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100990 <title>:
{
80100990:	55                   	push   %ebp
80100991:	b8 60 8e 0b 80       	mov    $0x800b8e60,%eax
80100996:	89 e5                	mov    %esp,%ebp
80100998:	57                   	push   %edi
80100999:	56                   	push   %esi
8010099a:	53                   	push   %ebx
8010099b:	83 ec 3c             	sub    $0x3c,%esp
8010099e:	66 90                	xchg   %ax,%ax
   crt[pos] = '-' | 0x0f00;
801009a0:	bb 2d 0f 00 00       	mov    $0xf2d,%ebx
801009a5:	83 c0 02             	add    $0x2,%eax
801009a8:	66 89 58 fe          	mov    %bx,-0x2(%eax)
  for(;pos<24*80;pos++)
801009ac:	3d 00 8f 0b 80       	cmp    $0x800b8f00,%eax
801009b1:	75 ed                	jne    801009a0 <title+0x10>
  asm volatile("cli");
801009b3:	fa                   	cli    
  struct proc* cur=myproc();
801009b4:	e8 07 34 00 00       	call   80103dc0 <myproc>
801009b9:	bb 29 7b 10 80       	mov    $0x80107b29,%ebx
801009be:	89 c6                	mov    %eax,%esi
  struct cpu* cpu=mycpu();
801009c0:	e8 5b 33 00 00       	call   80103d20 <mycpu>
801009c5:	b9 06 8f 0b 80       	mov    $0x800b8f06,%ecx
801009ca:	ba 77 00 00 00       	mov    $0x77,%edx
801009cf:	eb 0e                	jmp    801009df <title+0x4f>
801009d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009d8:	66 0f be 13          	movsbw (%ebx),%dx
801009dc:	83 c3 01             	add    $0x1,%ebx
    crt[i]= str[i] | cl;
801009df:	80 ce 0f             	or     $0xf,%dh
801009e2:	83 c1 02             	add    $0x2,%ecx
801009e5:	66 89 51 fe          	mov    %dx,-0x2(%ecx)
  for(i=0;i<n;i++)
801009e9:	81 f9 16 8f 0b 80    	cmp    $0x800b8f16,%ecx
801009ef:	75 e7                	jne    801009d8 <title+0x48>
  crt[24*80+11]= (curidx+'0') | 0x0b00;
801009f1:	0f b7 3d 20 b5 10 80 	movzwl 0x8010b520,%edi
801009f8:	bb 32 7b 10 80       	mov    $0x80107b32,%ebx
801009fd:	b9 1c 8f 0b 80       	mov    $0x800b8f1c,%ecx
80100a02:	8d 57 30             	lea    0x30(%edi),%edx
80100a05:	80 ce 0b             	or     $0xb,%dh
80100a08:	66 89 15 16 8f 0b 80 	mov    %dx,0x800b8f16
80100a0f:	ba 70 00 00 00       	mov    $0x70,%edx
80100a14:	eb 11                	jmp    80100a27 <title+0x97>
80100a16:	8d 76 00             	lea    0x0(%esi),%esi
80100a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80100a20:	66 0f be 13          	movsbw (%ebx),%dx
80100a24:	83 c3 01             	add    $0x1,%ebx
    crt[i]= str[i] | cl;
80100a27:	80 ce 0f             	or     $0xf,%dh
80100a2a:	83 c1 02             	add    $0x2,%ecx
80100a2d:	66 89 51 fe          	mov    %dx,-0x2(%ecx)
  for(i=0;i<n;i++)
80100a31:	81 f9 3a 8f 0b 80    	cmp    $0x800b8f3a,%ecx
80100a37:	75 e7                	jne    80100a20 <title+0x90>
  crt[24*80+29]= (cur->priority+'0') | 0x0b00;
80100a39:	0f b7 be 80 00 00 00 	movzwl 0x80(%esi),%edi
    crt[i]= str[i] | cl;
80100a40:	b9 63 0f 00 00       	mov    $0xf63,%ecx
80100a45:	bb 70 0f 00 00       	mov    $0xf70,%ebx
80100a4a:	66 89 0d 40 8f 0b 80 	mov    %cx,0x800b8f40
80100a51:	b9 20 0f 00 00       	mov    $0xf20,%ecx
  crt[24*80+29]= (cur->priority+'0') | 0x0b00;
80100a56:	8d 57 30             	lea    0x30(%edi),%edx
    crt[i]= str[i] | cl;
80100a59:	bf 75 0f 00 00       	mov    $0xf75,%edi
80100a5e:	66 89 1d 42 8f 0b 80 	mov    %bx,0x800b8f42
  crt[24*80+29]= (cur->priority+'0') | 0x0b00;
80100a65:	80 ce 0b             	or     $0xb,%dh
    crt[i]= str[i] | cl;
80100a68:	66 89 3d 44 8f 0b 80 	mov    %di,0x800b8f44
  crt[24*80+29]= (cur->priority+'0') | 0x0b00;
80100a6f:	66 89 15 3a 8f 0b 80 	mov    %dx,0x800b8f3a
    crt[i]= str[i] | cl;
80100a76:	ba 3a 0f 00 00       	mov    $0xf3a,%edx
80100a7b:	66 89 15 46 8f 0b 80 	mov    %dx,0x800b8f46
80100a82:	66 89 0d 48 8f 0b 80 	mov    %cx,0x800b8f48
  crt[24*80+37]=(cpu->apicid+'0')| 0x0b00;
80100a89:	0f b6 00             	movzbl (%eax),%eax
80100a8c:	83 c0 30             	add    $0x30,%eax
80100a8f:	80 cc 0b             	or     $0xb,%ah
80100a92:	66 a3 4a 8f 0b 80    	mov    %ax,0x800b8f4a
  int n=tostring(buf, cur->sz);
80100a98:	8b 0e                	mov    (%esi),%ecx
  while(t>0)
80100a9a:	85 c9                	test   %ecx,%ecx
80100a9c:	0f 8e dd 00 00 00    	jle    80100b7f <title+0x1ef>
80100aa2:	89 cb                	mov    %ecx,%ebx
  int s=0,t=n,res;
80100aa4:	31 f6                	xor    %esi,%esi
80100aa6:	eb 0c                	jmp    80100ab4 <title+0x124>
80100aa8:	90                   	nop
80100aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    s++;
80100ab0:	89 fe                	mov    %edi,%esi
    t/=10;
80100ab2:	89 d3                	mov    %edx,%ebx
80100ab4:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
    s++;
80100ab9:	8d 7e 01             	lea    0x1(%esi),%edi
    t/=10;
80100abc:	f7 e3                	mul    %ebx
80100abe:	c1 ea 03             	shr    $0x3,%edx
  while(t>0)
80100ac1:	83 fb 09             	cmp    $0x9,%ebx
80100ac4:	7f ea                	jg     80100ab0 <title+0x120>
  str[s]=0;
80100ac6:	c6 44 3d d4 00       	movb   $0x0,-0x2c(%ebp,%edi,1)
  while(n>0)
80100acb:	8d 5c 35 d4          	lea    -0x2c(%ebp,%esi,1),%ebx
80100acf:	89 75 c4             	mov    %esi,-0x3c(%ebp)
80100ad2:	eb 06                	jmp    80100ada <title+0x14a>
80100ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
80100ad8:	89 d1                	mov    %edx,%ecx
    str[--s]=n%10+'0';
80100ada:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80100adf:	89 ce                	mov    %ecx,%esi
80100ae1:	83 eb 01             	sub    $0x1,%ebx
80100ae4:	f7 e1                	mul    %ecx
80100ae6:	c1 ea 03             	shr    $0x3,%edx
80100ae9:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100aec:	01 c0                	add    %eax,%eax
80100aee:	29 c6                	sub    %eax,%esi
80100af0:	89 f0                	mov    %esi,%eax
80100af2:	83 c0 30             	add    $0x30,%eax
80100af5:	88 43 01             	mov    %al,0x1(%ebx)
  while(n>0)
80100af8:	83 f9 09             	cmp    $0x9,%ecx
80100afb:	7f db                	jg     80100ad8 <title+0x148>
80100afd:	8b 75 c4             	mov    -0x3c(%ebp),%esi
80100b00:	8d 9c 36 68 0f 00 00 	lea    0xf68(%esi,%esi,1),%ebx
80100b07:	8d b3 00 80 0b 80    	lea    -0x7ff48000(%ebx),%esi
80100b0d:	81 eb fe 7f f4 7f    	sub    $0x7ff47ffe,%ebx
80100b13:	b9 42 7b 10 80       	mov    $0x80107b42,%ecx
  int s=0,t=n,res;
80100b18:	b8 50 8f 0b 80       	mov    $0x800b8f50,%eax
80100b1d:	ba 75 00 00 00       	mov    $0x75,%edx
80100b22:	eb 0b                	jmp    80100b2f <title+0x19f>
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b28:	66 0f be 11          	movsbw (%ecx),%dx
80100b2c:	83 c1 01             	add    $0x1,%ecx
    crt[i]= str[i] | cl;
80100b2f:	80 ce 0f             	or     $0xf,%dh
80100b32:	83 c0 02             	add    $0x2,%eax
80100b35:	66 89 50 fe          	mov    %dx,-0x2(%eax)
  for(i=0;i<n;i++)
80100b39:	3d 66 8f 0b 80       	cmp    $0x800b8f66,%eax
80100b3e:	75 e8                	jne    80100b28 <title+0x198>
80100b40:	8d 55 d4             	lea    -0x2c(%ebp),%edx
80100b43:	8d 8c 3f 66 8f 0b 80 	lea    -0x7ff4709a(%edi,%edi,1),%ecx
80100b4a:	85 ff                	test   %edi,%edi
80100b4c:	74 19                	je     80100b67 <title+0x1d7>
80100b4e:	66 90                	xchg   %ax,%ax
    crt[i]= str[i] | cl;
80100b50:	66 0f be 3a          	movsbw (%edx),%di
80100b54:	83 c0 02             	add    $0x2,%eax
80100b57:	83 c2 01             	add    $0x1,%edx
80100b5a:	66 81 cf 00 0b       	or     $0xb00,%di
80100b5f:	66 89 78 fe          	mov    %di,-0x2(%eax)
  for(i=0;i<n;i++)
80100b63:	39 c8                	cmp    %ecx,%eax
80100b65:	75 e9                	jne    80100b50 <title+0x1c0>
  crt[24*80+51+n]=' '| 0x0b00;
80100b67:	b8 20 0b 00 00       	mov    $0xb20,%eax
  crt[24*80+51+n+1]='B'| 0x0f00;
80100b6c:	ba 42 0f 00 00       	mov    $0xf42,%edx
  crt[24*80+51+n]=' '| 0x0b00;
80100b71:	66 89 06             	mov    %ax,(%esi)
  crt[24*80+51+n+1]='B'| 0x0f00;
80100b74:	66 89 13             	mov    %dx,(%ebx)
}
80100b77:	83 c4 3c             	add    $0x3c,%esp
80100b7a:	5b                   	pop    %ebx
80100b7b:	5e                   	pop    %esi
80100b7c:	5f                   	pop    %edi
80100b7d:	5d                   	pop    %ebp
80100b7e:	c3                   	ret    
  str[s]=0;
80100b7f:	c6 45 d4 00          	movb   $0x0,-0x2c(%ebp)
80100b83:	bb 68 8f 0b 80       	mov    $0x800b8f68,%ebx
80100b88:	be 66 8f 0b 80       	mov    $0x800b8f66,%esi
  int s=0,t=n,res;
80100b8d:	31 ff                	xor    %edi,%edi
80100b8f:	eb 82                	jmp    80100b13 <title+0x183>
80100b91:	eb 0d                	jmp    80100ba0 <display>
80100b93:	90                   	nop
80100b94:	90                   	nop
80100b95:	90                   	nop
80100b96:	90                   	nop
80100b97:	90                   	nop
80100b98:	90                   	nop
80100b99:	90                   	nop
80100b9a:	90                   	nop
80100b9b:	90                   	nop
80100b9c:	90                   	nop
80100b9d:	90                   	nop
80100b9e:	90                   	nop
80100b9f:	90                   	nop

80100ba0 <display>:
{
80100ba0:	55                   	push   %ebp
80100ba1:	89 e5                	mov    %esp,%ebp
80100ba3:	56                   	push   %esi
80100ba4:	8b 45 08             	mov    0x8(%ebp),%eax
80100ba7:	53                   	push   %ebx
  if(f==-1)
80100ba8:	83 f8 ff             	cmp    $0xffffffff,%eax
80100bab:	74 5b                	je     80100c08 <display+0x68>
  if(f==-2)
80100bad:	83 f8 fe             	cmp    $0xfffffffe,%eax
80100bb0:	74 0e                	je     80100bc0 <display+0x20>
}
80100bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100bb5:	5b                   	pop    %ebx
80100bb6:	5e                   	pop    %esi
80100bb7:	5d                   	pop    %ebp
80100bb8:	c3                   	ret    
80100bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(adr, 0, sizeof(adr[0])*(23*80));
80100bc0:	83 ec 04             	sub    $0x4,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100bc3:	be d4 03 00 00       	mov    $0x3d4,%esi
80100bc8:	68 60 0e 00 00       	push   $0xe60
80100bcd:	6a 00                	push   $0x0
80100bcf:	68 00 80 0b 80       	push   $0x800b8000
80100bd4:	e8 17 41 00 00       	call   80104cf0 <memset>
80100bd9:	b8 0e 00 00 00       	mov    $0xe,%eax
80100bde:	89 f2                	mov    %esi,%edx
80100be0:	ee                   	out    %al,(%dx)
80100be1:	31 c9                	xor    %ecx,%ecx
80100be3:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100be8:	89 c8                	mov    %ecx,%eax
80100bea:	89 da                	mov    %ebx,%edx
80100bec:	ee                   	out    %al,(%dx)
80100bed:	b8 0f 00 00 00       	mov    $0xf,%eax
80100bf2:	89 f2                	mov    %esi,%edx
80100bf4:	ee                   	out    %al,(%dx)
80100bf5:	89 c8                	mov    %ecx,%eax
80100bf7:	89 da                	mov    %ebx,%edx
80100bf9:	ee                   	out    %al,(%dx)
80100bfa:	83 c4 10             	add    $0x10,%esp
}
80100bfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100c00:	5b                   	pop    %ebx
80100c01:	5e                   	pop    %esi
80100c02:	5d                   	pop    %ebp
80100c03:	c3                   	ret    
80100c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c08:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100c0b:	5b                   	pop    %ebx
80100c0c:	5e                   	pop    %esi
80100c0d:	5d                   	pop    %ebp
80100c0e:	e9 7d f7 ff ff       	jmp    80100390 <display.part.1>
80100c13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100c20 <splitw>:
{
80100c20:	55                   	push   %ebp
80100c21:	89 e5                	mov    %esp,%ebp
80100c23:	53                   	push   %ebx
80100c24:	83 ec 04             	sub    $0x4,%esp
80100c27:	8b 45 08             	mov    0x8(%ebp),%eax
  cgaflag=1;
80100c2a:	c7 05 24 b5 10 80 01 	movl   $0x1,0x8010b524
80100c31:	00 00 00 
  if(n==-1)
80100c34:	83 f8 ff             	cmp    $0xffffffff,%eax
80100c37:	74 37                	je     80100c70 <splitw+0x50>
  if(n>=0)
80100c39:	85 c0                	test   %eax,%eax
80100c3b:	78 09                	js     80100c46 <splitw+0x26>
    if(crtflags[n]>0)
80100c3d:	80 b8 a0 0f 11 80 00 	cmpb   $0x0,-0x7feef060(%eax)
80100c44:	7f 0a                	jg     80100c50 <splitw+0x30>
}
80100c46:	31 c0                	xor    %eax,%eax
80100c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c4b:	c9                   	leave  
80100c4c:	c3                   	ret    
80100c4d:	8d 76 00             	lea    0x0(%esi),%esi
      display(-2);
80100c50:	83 ec 0c             	sub    $0xc,%esp
      curidx=n;
80100c53:	a3 20 b5 10 80       	mov    %eax,0x8010b520
      display(-2);
80100c58:	6a fe                	push   $0xfffffffe
80100c5a:	e8 41 ff ff ff       	call   80100ba0 <display>
      title();
80100c5f:	e8 2c fd ff ff       	call   80100990 <title>
80100c64:	83 c4 10             	add    $0x10,%esp
}
80100c67:	31 c0                	xor    %eax,%eax
80100c69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c6c:	c9                   	leave  
80100c6d:	c3                   	ret    
80100c6e:	66 90                	xchg   %ax,%ax
    for(i=0;i<MAXWINDOWS;i++)
80100c70:	31 db                	xor    %ebx,%ebx
      if(crtflags[i]==0)
80100c72:	80 bb a0 0f 11 80 00 	cmpb   $0x0,-0x7feef060(%ebx)
80100c79:	74 16                	je     80100c91 <splitw+0x71>
80100c7b:	90                   	nop
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(i=0;i<MAXWINDOWS;i++)
80100c80:	83 c3 01             	add    $0x1,%ebx
80100c83:	83 fb 0a             	cmp    $0xa,%ebx
80100c86:	74 be                	je     80100c46 <splitw+0x26>
      if(crtflags[i]==0)
80100c88:	80 bb a0 0f 11 80 00 	cmpb   $0x0,-0x7feef060(%ebx)
80100c8f:	75 ef                	jne    80100c80 <splitw+0x60>
        myproc()->widx=i;
80100c91:	e8 2a 31 00 00       	call   80103dc0 <myproc>
        curidx=i;
80100c96:	89 1d 20 b5 10 80    	mov    %ebx,0x8010b520
        myproc()->widx=i;
80100c9c:	89 98 94 00 00 00    	mov    %ebx,0x94(%eax)
        crtflags[i]=1;
80100ca2:	c6 83 a0 0f 11 80 01 	movb   $0x1,-0x7feef060(%ebx)
  if(f==-1)
80100ca9:	e8 e2 f6 ff ff       	call   80100390 <display.part.1>
        title();
80100cae:	e8 dd fc ff ff       	call   80100990 <title>
}
80100cb3:	31 c0                	xor    %eax,%eax
80100cb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cb8:	c9                   	leave  
80100cb9:	c3                   	ret    
80100cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100cc0 <consoleintr>:
{
80100cc0:	55                   	push   %ebp
80100cc1:	89 e5                	mov    %esp,%ebp
80100cc3:	57                   	push   %edi
80100cc4:	56                   	push   %esi
  int c, doprocdump = 0;
80100cc5:	31 f6                	xor    %esi,%esi
{
80100cc7:	53                   	push   %ebx
80100cc8:	83 ec 18             	sub    $0x18,%esp
80100ccb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100cce:	68 40 b5 10 80       	push   $0x8010b540
80100cd3:	e8 a8 3e 00 00       	call   80104b80 <acquire>
  while((c = getc()) >= 0){
80100cd8:	83 c4 10             	add    $0x10,%esp
80100cdb:	90                   	nop
80100cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ce0:	ff d3                	call   *%ebx
80100ce2:	89 c7                	mov    %eax,%edi
80100ce4:	85 c0                	test   %eax,%eax
80100ce6:	78 60                	js     80100d48 <consoleintr+0x88>
    switch(c){
80100ce8:	83 ff 10             	cmp    $0x10,%edi
80100ceb:	0f 84 47 01 00 00    	je     80100e38 <consoleintr+0x178>
80100cf1:	7e 7d                	jle    80100d70 <consoleintr+0xb0>
80100cf3:	83 ff 15             	cmp    $0x15,%edi
80100cf6:	0f 85 04 01 00 00    	jne    80100e00 <consoleintr+0x140>
      while(input.e != input.w &&
80100cfc:	a1 48 10 11 80       	mov    0x80111048,%eax
80100d01:	39 05 44 10 11 80    	cmp    %eax,0x80111044
80100d07:	74 d7                	je     80100ce0 <consoleintr+0x20>
80100d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100d10:	83 e8 01             	sub    $0x1,%eax
80100d13:	89 c2                	mov    %eax,%edx
80100d15:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100d18:	80 ba c0 0f 11 80 0a 	cmpb   $0xa,-0x7feef040(%edx)
80100d1f:	74 bf                	je     80100ce0 <consoleintr+0x20>
        input.e--;
80100d21:	a3 48 10 11 80       	mov    %eax,0x80111048
        consputc(BACKSPACE);
80100d26:	b8 00 01 00 00       	mov    $0x100,%eax
80100d2b:	e8 30 f7 ff ff       	call   80100460 <consputc>
      while(input.e != input.w &&
80100d30:	a1 48 10 11 80       	mov    0x80111048,%eax
80100d35:	3b 05 44 10 11 80    	cmp    0x80111044,%eax
80100d3b:	75 d3                	jne    80100d10 <consoleintr+0x50>
  while((c = getc()) >= 0){
80100d3d:	ff d3                	call   *%ebx
80100d3f:	89 c7                	mov    %eax,%edi
80100d41:	85 c0                	test   %eax,%eax
80100d43:	79 a3                	jns    80100ce8 <consoleintr+0x28>
80100d45:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100d48:	83 ec 0c             	sub    $0xc,%esp
80100d4b:	68 40 b5 10 80       	push   $0x8010b540
80100d50:	e8 4b 3f 00 00       	call   80104ca0 <release>
  if(doprocdump) {
80100d55:	83 c4 10             	add    $0x10,%esp
80100d58:	85 f6                	test   %esi,%esi
80100d5a:	0f 85 e8 00 00 00    	jne    80100e48 <consoleintr+0x188>
}
80100d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d63:	5b                   	pop    %ebx
80100d64:	5e                   	pop    %esi
80100d65:	5f                   	pop    %edi
80100d66:	5d                   	pop    %ebp
80100d67:	c3                   	ret    
80100d68:	90                   	nop
80100d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d70:	83 ff 08             	cmp    $0x8,%edi
80100d73:	0f 84 90 00 00 00    	je     80100e09 <consoleintr+0x149>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100d79:	85 ff                	test   %edi,%edi
80100d7b:	0f 84 5f ff ff ff    	je     80100ce0 <consoleintr+0x20>
80100d81:	a1 48 10 11 80       	mov    0x80111048,%eax
80100d86:	89 c2                	mov    %eax,%edx
80100d88:	2b 15 40 10 11 80    	sub    0x80111040,%edx
80100d8e:	83 fa 7f             	cmp    $0x7f,%edx
80100d91:	0f 87 49 ff ff ff    	ja     80100ce0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
80100d97:	8d 50 01             	lea    0x1(%eax),%edx
80100d9a:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100d9d:	89 15 48 10 11 80    	mov    %edx,0x80111048
        c = (c == '\r') ? '\n' : c;
80100da3:	83 ff 0d             	cmp    $0xd,%edi
80100da6:	0f 84 a8 00 00 00    	je     80100e54 <consoleintr+0x194>
        input.buf[input.e++ % INPUT_BUF] = c;
80100dac:	89 f9                	mov    %edi,%ecx
80100dae:	88 88 c0 0f 11 80    	mov    %cl,-0x7feef040(%eax)
        consputc(c);
80100db4:	89 f8                	mov    %edi,%eax
80100db6:	e8 a5 f6 ff ff       	call   80100460 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100dbb:	83 ff 0a             	cmp    $0xa,%edi
80100dbe:	0f 84 a1 00 00 00    	je     80100e65 <consoleintr+0x1a5>
80100dc4:	83 ff 04             	cmp    $0x4,%edi
80100dc7:	0f 84 98 00 00 00    	je     80100e65 <consoleintr+0x1a5>
80100dcd:	a1 40 10 11 80       	mov    0x80111040,%eax
80100dd2:	83 e8 80             	sub    $0xffffff80,%eax
80100dd5:	39 05 48 10 11 80    	cmp    %eax,0x80111048
80100ddb:	0f 85 ff fe ff ff    	jne    80100ce0 <consoleintr+0x20>
          wakeup(&input.r);
80100de1:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100de4:	a3 44 10 11 80       	mov    %eax,0x80111044
          wakeup(&input.r);
80100de9:	68 40 10 11 80       	push   $0x80111040
80100dee:	e8 0d 3a 00 00       	call   80104800 <wakeup>
80100df3:	83 c4 10             	add    $0x10,%esp
80100df6:	e9 e5 fe ff ff       	jmp    80100ce0 <consoleintr+0x20>
80100dfb:	90                   	nop
80100dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e00:	83 ff 7f             	cmp    $0x7f,%edi
80100e03:	0f 85 70 ff ff ff    	jne    80100d79 <consoleintr+0xb9>
      if(input.e != input.w){
80100e09:	a1 48 10 11 80       	mov    0x80111048,%eax
80100e0e:	3b 05 44 10 11 80    	cmp    0x80111044,%eax
80100e14:	0f 84 c6 fe ff ff    	je     80100ce0 <consoleintr+0x20>
        input.e--;
80100e1a:	83 e8 01             	sub    $0x1,%eax
80100e1d:	a3 48 10 11 80       	mov    %eax,0x80111048
        consputc(BACKSPACE);
80100e22:	b8 00 01 00 00       	mov    $0x100,%eax
80100e27:	e8 34 f6 ff ff       	call   80100460 <consputc>
80100e2c:	e9 af fe ff ff       	jmp    80100ce0 <consoleintr+0x20>
80100e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100e38:	be 01 00 00 00       	mov    $0x1,%esi
80100e3d:	e9 9e fe ff ff       	jmp    80100ce0 <consoleintr+0x20>
80100e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e4b:	5b                   	pop    %ebx
80100e4c:	5e                   	pop    %esi
80100e4d:	5f                   	pop    %edi
80100e4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100e4f:	e9 5c 3a 00 00       	jmp    801048b0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100e54:	c6 80 c0 0f 11 80 0a 	movb   $0xa,-0x7feef040(%eax)
        consputc(c);
80100e5b:	b8 0a 00 00 00       	mov    $0xa,%eax
80100e60:	e8 fb f5 ff ff       	call   80100460 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100e65:	a1 48 10 11 80       	mov    0x80111048,%eax
80100e6a:	e9 72 ff ff ff       	jmp    80100de1 <consoleintr+0x121>
80100e6f:	90                   	nop

80100e70 <consoleinit>:

void
consoleinit(void)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100e76:	68 4d 7b 10 80       	push   $0x80107b4d
80100e7b:	68 40 b5 10 80       	push   $0x8010b540
80100e80:	e8 fb 3b 00 00       	call   80104a80 <initlock>
  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;
  crtflags[0]=1;

  ioapicenable(IRQ_KBD, 0);
80100e85:	58                   	pop    %eax
80100e86:	5a                   	pop    %edx
80100e87:	6a 00                	push   $0x0
80100e89:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100e8b:	c7 05 0c 1a 11 80 90 	movl   $0x80100690,0x80111a0c
80100e92:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100e95:	c7 05 08 1a 11 80 80 	movl   $0x80100280,0x80111a08
80100e9c:	02 10 80 
  cons.locking = 1;
80100e9f:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
80100ea6:	00 00 00 
  crtflags[0]=1;
80100ea9:	c6 05 a0 0f 11 80 01 	movb   $0x1,0x80110fa0
  ioapicenable(IRQ_KBD, 0);
80100eb0:	e8 6b 19 00 00       	call   80102820 <ioapicenable>
}
80100eb5:	83 c4 10             	add    $0x10,%esp
80100eb8:	c9                   	leave  
80100eb9:	c3                   	ret    
80100eba:	66 90                	xchg   %ax,%ax
80100ebc:	66 90                	xchg   %ax,%ax
80100ebe:	66 90                	xchg   %ax,%ax

80100ec0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	57                   	push   %edi
80100ec4:	56                   	push   %esi
80100ec5:	53                   	push   %ebx
80100ec6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100ecc:	e8 ef 2e 00 00       	call   80103dc0 <myproc>
80100ed1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ed7:	e8 34 22 00 00       	call   80103110 <begin_op>

  if((ip = namei(path)) == 0){
80100edc:	83 ec 0c             	sub    $0xc,%esp
80100edf:	ff 75 08             	pushl  0x8(%ebp)
80100ee2:	e8 49 15 00 00       	call   80102430 <namei>
80100ee7:	83 c4 10             	add    $0x10,%esp
80100eea:	85 c0                	test   %eax,%eax
80100eec:	0f 84 02 03 00 00    	je     801011f4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
80100ef5:	89 c3                	mov    %eax,%ebx
80100ef7:	50                   	push   %eax
80100ef8:	e8 93 0c 00 00       	call   80101b90 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100efd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100f03:	6a 34                	push   $0x34
80100f05:	6a 00                	push   $0x0
80100f07:	50                   	push   %eax
80100f08:	53                   	push   %ebx
80100f09:	e8 62 0f 00 00       	call   80101e70 <readi>
80100f0e:	83 c4 20             	add    $0x20,%esp
80100f11:	83 f8 34             	cmp    $0x34,%eax
80100f14:	74 22                	je     80100f38 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100f16:	83 ec 0c             	sub    $0xc,%esp
80100f19:	53                   	push   %ebx
80100f1a:	e8 01 0f 00 00       	call   80101e20 <iunlockput>
    end_op();
80100f1f:	e8 5c 22 00 00       	call   80103180 <end_op>
80100f24:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f2f:	5b                   	pop    %ebx
80100f30:	5e                   	pop    %esi
80100f31:	5f                   	pop    %edi
80100f32:	5d                   	pop    %ebp
80100f33:	c3                   	ret    
80100f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100f38:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100f3f:	45 4c 46 
80100f42:	75 d2                	jne    80100f16 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100f44:	e8 f7 68 00 00       	call   80107840 <setupkvm>
80100f49:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100f4f:	85 c0                	test   %eax,%eax
80100f51:	74 c3                	je     80100f16 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f53:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100f5a:	00 
80100f5b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100f61:	0f 84 ac 02 00 00    	je     80101213 <exec+0x353>
  sz = 0;
80100f67:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100f6e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f71:	31 ff                	xor    %edi,%edi
80100f73:	e9 8e 00 00 00       	jmp    80101006 <exec+0x146>
80100f78:	90                   	nop
80100f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100f80:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100f87:	75 6c                	jne    80100ff5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100f89:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100f8f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100f95:	0f 82 87 00 00 00    	jb     80101022 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100f9b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100fa1:	72 7f                	jb     80101022 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100fa3:	83 ec 04             	sub    $0x4,%esp
80100fa6:	50                   	push   %eax
80100fa7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100fad:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100fb3:	e8 78 66 00 00       	call   80107630 <allocuvm>
80100fb8:	83 c4 10             	add    $0x10,%esp
80100fbb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100fc1:	85 c0                	test   %eax,%eax
80100fc3:	74 5d                	je     80101022 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100fc5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100fcb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100fd0:	75 50                	jne    80101022 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100fd2:	83 ec 0c             	sub    $0xc,%esp
80100fd5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100fdb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100fe1:	53                   	push   %ebx
80100fe2:	50                   	push   %eax
80100fe3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100fe9:	e8 a2 64 00 00       	call   80107490 <loaduvm>
80100fee:	83 c4 20             	add    $0x20,%esp
80100ff1:	85 c0                	test   %eax,%eax
80100ff3:	78 2d                	js     80101022 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ff5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ffc:	83 c7 01             	add    $0x1,%edi
80100fff:	83 c6 20             	add    $0x20,%esi
80101002:	39 f8                	cmp    %edi,%eax
80101004:	7e 3a                	jle    80101040 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101006:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010100c:	6a 20                	push   $0x20
8010100e:	56                   	push   %esi
8010100f:	50                   	push   %eax
80101010:	53                   	push   %ebx
80101011:	e8 5a 0e 00 00       	call   80101e70 <readi>
80101016:	83 c4 10             	add    $0x10,%esp
80101019:	83 f8 20             	cmp    $0x20,%eax
8010101c:	0f 84 5e ff ff ff    	je     80100f80 <exec+0xc0>
    freevm(pgdir);
80101022:	83 ec 0c             	sub    $0xc,%esp
80101025:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010102b:	e8 90 67 00 00       	call   801077c0 <freevm>
  if(ip){
80101030:	83 c4 10             	add    $0x10,%esp
80101033:	e9 de fe ff ff       	jmp    80100f16 <exec+0x56>
80101038:	90                   	nop
80101039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101040:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101046:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010104c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80101052:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101058:	83 ec 0c             	sub    $0xc,%esp
8010105b:	53                   	push   %ebx
8010105c:	e8 bf 0d 00 00       	call   80101e20 <iunlockput>
  end_op();
80101061:	e8 1a 21 00 00       	call   80103180 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101066:	83 c4 0c             	add    $0xc,%esp
80101069:	56                   	push   %esi
8010106a:	57                   	push   %edi
8010106b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101071:	57                   	push   %edi
80101072:	e8 b9 65 00 00       	call   80107630 <allocuvm>
80101077:	83 c4 10             	add    $0x10,%esp
8010107a:	89 c6                	mov    %eax,%esi
8010107c:	85 c0                	test   %eax,%eax
8010107e:	0f 84 94 00 00 00    	je     80101118 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101084:	83 ec 08             	sub    $0x8,%esp
80101087:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010108d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010108f:	50                   	push   %eax
80101090:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101091:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101093:	e8 48 68 00 00       	call   801078e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101098:	8b 45 0c             	mov    0xc(%ebp),%eax
8010109b:	83 c4 10             	add    $0x10,%esp
8010109e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801010a4:	8b 00                	mov    (%eax),%eax
801010a6:	85 c0                	test   %eax,%eax
801010a8:	0f 84 8b 00 00 00    	je     80101139 <exec+0x279>
801010ae:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
801010b4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801010ba:	eb 23                	jmp    801010df <exec+0x21f>
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
801010c3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
801010ca:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
801010cd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
801010d3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
801010d6:	85 c0                	test   %eax,%eax
801010d8:	74 59                	je     80101133 <exec+0x273>
    if(argc >= MAXARG)
801010da:	83 ff 20             	cmp    $0x20,%edi
801010dd:	74 39                	je     80101118 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801010df:	83 ec 0c             	sub    $0xc,%esp
801010e2:	50                   	push   %eax
801010e3:	e8 18 3e 00 00       	call   80104f00 <strlen>
801010e8:	f7 d0                	not    %eax
801010ea:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801010ec:	58                   	pop    %eax
801010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801010f0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801010f3:	ff 34 b8             	pushl  (%eax,%edi,4)
801010f6:	e8 05 3e 00 00       	call   80104f00 <strlen>
801010fb:	83 c0 01             	add    $0x1,%eax
801010fe:	50                   	push   %eax
801010ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80101102:	ff 34 b8             	pushl  (%eax,%edi,4)
80101105:	53                   	push   %ebx
80101106:	56                   	push   %esi
80101107:	e8 24 69 00 00       	call   80107a30 <copyout>
8010110c:	83 c4 20             	add    $0x20,%esp
8010110f:	85 c0                	test   %eax,%eax
80101111:	79 ad                	jns    801010c0 <exec+0x200>
80101113:	90                   	nop
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80101118:	83 ec 0c             	sub    $0xc,%esp
8010111b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101121:	e8 9a 66 00 00       	call   801077c0 <freevm>
80101126:	83 c4 10             	add    $0x10,%esp
  return -1;
80101129:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010112e:	e9 f9 fd ff ff       	jmp    80100f2c <exec+0x6c>
80101133:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101139:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101140:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101142:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101149:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010114d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010114f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101152:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101158:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010115a:	50                   	push   %eax
8010115b:	52                   	push   %edx
8010115c:	53                   	push   %ebx
8010115d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101163:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010116a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010116d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101173:	e8 b8 68 00 00       	call   80107a30 <copyout>
80101178:	83 c4 10             	add    $0x10,%esp
8010117b:	85 c0                	test   %eax,%eax
8010117d:	78 99                	js     80101118 <exec+0x258>
  for(last=s=path; *s; s++)
8010117f:	8b 45 08             	mov    0x8(%ebp),%eax
80101182:	8b 55 08             	mov    0x8(%ebp),%edx
80101185:	0f b6 00             	movzbl (%eax),%eax
80101188:	84 c0                	test   %al,%al
8010118a:	74 13                	je     8010119f <exec+0x2df>
8010118c:	89 d1                	mov    %edx,%ecx
8010118e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80101190:	83 c1 01             	add    $0x1,%ecx
80101193:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101195:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80101198:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010119b:	84 c0                	test   %al,%al
8010119d:	75 f1                	jne    80101190 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010119f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801011a5:	83 ec 04             	sub    $0x4,%esp
801011a8:	6a 10                	push   $0x10
801011aa:	89 f8                	mov    %edi,%eax
801011ac:	52                   	push   %edx
801011ad:	83 c0 6c             	add    $0x6c,%eax
801011b0:	50                   	push   %eax
801011b1:	e8 0a 3d 00 00       	call   80104ec0 <safestrcpy>
  curproc->pgdir = pgdir;
801011b6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801011bc:	89 f8                	mov    %edi,%eax
801011be:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
801011c1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
801011c3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801011c6:	89 c1                	mov    %eax,%ecx
801011c8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801011ce:	8b 40 18             	mov    0x18(%eax),%eax
801011d1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801011d4:	8b 41 18             	mov    0x18(%ecx),%eax
801011d7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801011da:	89 0c 24             	mov    %ecx,(%esp)
801011dd:	e8 1e 61 00 00       	call   80107300 <switchuvm>
  freevm(oldpgdir);
801011e2:	89 3c 24             	mov    %edi,(%esp)
801011e5:	e8 d6 65 00 00       	call   801077c0 <freevm>
  return 0;
801011ea:	83 c4 10             	add    $0x10,%esp
801011ed:	31 c0                	xor    %eax,%eax
801011ef:	e9 38 fd ff ff       	jmp    80100f2c <exec+0x6c>
    end_op();
801011f4:	e8 87 1f 00 00       	call   80103180 <end_op>
    cprintf("exec: fail\n");
801011f9:	83 ec 0c             	sub    $0xc,%esp
801011fc:	68 69 7b 10 80       	push   $0x80107b69
80101201:	e8 ea f4 ff ff       	call   801006f0 <cprintf>
    return -1;
80101206:	83 c4 10             	add    $0x10,%esp
80101209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010120e:	e9 19 fd ff ff       	jmp    80100f2c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101213:	31 ff                	xor    %edi,%edi
80101215:	be 00 20 00 00       	mov    $0x2000,%esi
8010121a:	e9 39 fe ff ff       	jmp    80101058 <exec+0x198>
8010121f:	90                   	nop

80101220 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101226:	68 75 7b 10 80       	push   $0x80107b75
8010122b:	68 60 10 11 80       	push   $0x80111060
80101230:	e8 4b 38 00 00       	call   80104a80 <initlock>
}
80101235:	83 c4 10             	add    $0x10,%esp
80101238:	c9                   	leave  
80101239:	c3                   	ret    
8010123a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101240 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101244:	bb 94 10 11 80       	mov    $0x80111094,%ebx
{
80101249:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010124c:	68 60 10 11 80       	push   $0x80111060
80101251:	e8 2a 39 00 00       	call   80104b80 <acquire>
80101256:	83 c4 10             	add    $0x10,%esp
80101259:	eb 10                	jmp    8010126b <filealloc+0x2b>
8010125b:	90                   	nop
8010125c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101260:	83 c3 18             	add    $0x18,%ebx
80101263:	81 fb f4 19 11 80    	cmp    $0x801119f4,%ebx
80101269:	74 25                	je     80101290 <filealloc+0x50>
    if(f->ref == 0){
8010126b:	8b 43 04             	mov    0x4(%ebx),%eax
8010126e:	85 c0                	test   %eax,%eax
80101270:	75 ee                	jne    80101260 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101272:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101275:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010127c:	68 60 10 11 80       	push   $0x80111060
80101281:	e8 1a 3a 00 00       	call   80104ca0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101286:	89 d8                	mov    %ebx,%eax
      return f;
80101288:	83 c4 10             	add    $0x10,%esp
}
8010128b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010128e:	c9                   	leave  
8010128f:	c3                   	ret    
  release(&ftable.lock);
80101290:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101293:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101295:	68 60 10 11 80       	push   $0x80111060
8010129a:	e8 01 3a 00 00       	call   80104ca0 <release>
}
8010129f:	89 d8                	mov    %ebx,%eax
  return 0;
801012a1:	83 c4 10             	add    $0x10,%esp
}
801012a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012a7:	c9                   	leave  
801012a8:	c3                   	ret    
801012a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012b0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	53                   	push   %ebx
801012b4:	83 ec 10             	sub    $0x10,%esp
801012b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801012ba:	68 60 10 11 80       	push   $0x80111060
801012bf:	e8 bc 38 00 00       	call   80104b80 <acquire>
  if(f->ref < 1)
801012c4:	8b 43 04             	mov    0x4(%ebx),%eax
801012c7:	83 c4 10             	add    $0x10,%esp
801012ca:	85 c0                	test   %eax,%eax
801012cc:	7e 1a                	jle    801012e8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801012ce:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801012d1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801012d4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801012d7:	68 60 10 11 80       	push   $0x80111060
801012dc:	e8 bf 39 00 00       	call   80104ca0 <release>
  return f;
}
801012e1:	89 d8                	mov    %ebx,%eax
801012e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012e6:	c9                   	leave  
801012e7:	c3                   	ret    
    panic("filedup");
801012e8:	83 ec 0c             	sub    $0xc,%esp
801012eb:	68 7c 7b 10 80       	push   $0x80107b7c
801012f0:	e8 eb f0 ff ff       	call   801003e0 <panic>
801012f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101300 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	57                   	push   %edi
80101304:	56                   	push   %esi
80101305:	53                   	push   %ebx
80101306:	83 ec 28             	sub    $0x28,%esp
80101309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010130c:	68 60 10 11 80       	push   $0x80111060
80101311:	e8 6a 38 00 00       	call   80104b80 <acquire>
  if(f->ref < 1)
80101316:	8b 43 04             	mov    0x4(%ebx),%eax
80101319:	83 c4 10             	add    $0x10,%esp
8010131c:	85 c0                	test   %eax,%eax
8010131e:	0f 8e a3 00 00 00    	jle    801013c7 <fileclose+0xc7>
    panic("fileclose");
  if(--f->ref > 0){
80101324:	83 e8 01             	sub    $0x1,%eax
80101327:	89 43 04             	mov    %eax,0x4(%ebx)
8010132a:	75 44                	jne    80101370 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }

  ff = *f;
8010132c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101330:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101333:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101335:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010133b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010133e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101341:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101344:	68 60 10 11 80       	push   $0x80111060
  ff = *f;
80101349:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010134c:	e8 4f 39 00 00       	call   80104ca0 <release>

  if(ff.type == FD_PIPE)
80101351:	83 c4 10             	add    $0x10,%esp
80101354:	83 ff 01             	cmp    $0x1,%edi
80101357:	74 2f                	je     80101388 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101359:	83 ff 03             	cmp    $0x3,%edi
8010135c:	74 4a                	je     801013a8 <fileclose+0xa8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010135e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101361:	5b                   	pop    %ebx
80101362:	5e                   	pop    %esi
80101363:	5f                   	pop    %edi
80101364:	5d                   	pop    %ebp
80101365:	c3                   	ret    
80101366:	8d 76 00             	lea    0x0(%esi),%esi
80101369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&ftable.lock);
80101370:	c7 45 08 60 10 11 80 	movl   $0x80111060,0x8(%ebp)
}
80101377:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137a:	5b                   	pop    %ebx
8010137b:	5e                   	pop    %esi
8010137c:	5f                   	pop    %edi
8010137d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010137e:	e9 1d 39 00 00       	jmp    80104ca0 <release>
80101383:	90                   	nop
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pipeclose(ff.pipe, ff.writable);
80101388:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010138c:	83 ec 08             	sub    $0x8,%esp
8010138f:	53                   	push   %ebx
80101390:	56                   	push   %esi
80101391:	e8 7a 25 00 00       	call   80103910 <pipeclose>
80101396:	83 c4 10             	add    $0x10,%esp
}
80101399:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139c:	5b                   	pop    %ebx
8010139d:	5e                   	pop    %esi
8010139e:	5f                   	pop    %edi
8010139f:	5d                   	pop    %ebp
801013a0:	c3                   	ret    
801013a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
801013a8:	e8 63 1d 00 00       	call   80103110 <begin_op>
    iput(ff.ip);
801013ad:	83 ec 0c             	sub    $0xc,%esp
801013b0:	ff 75 e0             	pushl  -0x20(%ebp)
801013b3:	e8 08 09 00 00       	call   80101cc0 <iput>
    end_op();
801013b8:	83 c4 10             	add    $0x10,%esp
}
801013bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013be:	5b                   	pop    %ebx
801013bf:	5e                   	pop    %esi
801013c0:	5f                   	pop    %edi
801013c1:	5d                   	pop    %ebp
    end_op();
801013c2:	e9 b9 1d 00 00       	jmp    80103180 <end_op>
    panic("fileclose");
801013c7:	83 ec 0c             	sub    $0xc,%esp
801013ca:	68 84 7b 10 80       	push   $0x80107b84
801013cf:	e8 0c f0 ff ff       	call   801003e0 <panic>
801013d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013e0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	53                   	push   %ebx
801013e4:	83 ec 04             	sub    $0x4,%esp
801013e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801013ea:	83 3b 03             	cmpl   $0x3,(%ebx)
801013ed:	75 31                	jne    80101420 <filestat+0x40>
    ilock(f->ip);
801013ef:	83 ec 0c             	sub    $0xc,%esp
801013f2:	ff 73 10             	pushl  0x10(%ebx)
801013f5:	e8 96 07 00 00       	call   80101b90 <ilock>
    stati(f->ip, st);
801013fa:	58                   	pop    %eax
801013fb:	5a                   	pop    %edx
801013fc:	ff 75 0c             	pushl  0xc(%ebp)
801013ff:	ff 73 10             	pushl  0x10(%ebx)
80101402:	e8 39 0a 00 00       	call   80101e40 <stati>
    iunlock(f->ip);
80101407:	59                   	pop    %ecx
80101408:	ff 73 10             	pushl  0x10(%ebx)
8010140b:	e8 60 08 00 00       	call   80101c70 <iunlock>
    return 0;
80101410:	83 c4 10             	add    $0x10,%esp
80101413:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101415:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101418:	c9                   	leave  
80101419:	c3                   	ret    
8010141a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101425:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101428:	c9                   	leave  
80101429:	c3                   	ret    
8010142a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101430 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	53                   	push   %ebx
80101436:	83 ec 0c             	sub    $0xc,%esp
80101439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010143c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010143f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101442:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101446:	74 60                	je     801014a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101448:	8b 03                	mov    (%ebx),%eax
8010144a:	83 f8 01             	cmp    $0x1,%eax
8010144d:	74 41                	je     80101490 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010144f:	83 f8 03             	cmp    $0x3,%eax
80101452:	75 5b                	jne    801014af <fileread+0x7f>
    ilock(f->ip);
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	ff 73 10             	pushl  0x10(%ebx)
8010145a:	e8 31 07 00 00       	call   80101b90 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010145f:	57                   	push   %edi
80101460:	ff 73 14             	pushl  0x14(%ebx)
80101463:	56                   	push   %esi
80101464:	ff 73 10             	pushl  0x10(%ebx)
80101467:	e8 04 0a 00 00       	call   80101e70 <readi>
8010146c:	83 c4 20             	add    $0x20,%esp
8010146f:	89 c6                	mov    %eax,%esi
80101471:	85 c0                	test   %eax,%eax
80101473:	7e 03                	jle    80101478 <fileread+0x48>
      f->off += r;
80101475:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101478:	83 ec 0c             	sub    $0xc,%esp
8010147b:	ff 73 10             	pushl  0x10(%ebx)
8010147e:	e8 ed 07 00 00       	call   80101c70 <iunlock>
    return r;
80101483:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101486:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101489:	89 f0                	mov    %esi,%eax
8010148b:	5b                   	pop    %ebx
8010148c:	5e                   	pop    %esi
8010148d:	5f                   	pop    %edi
8010148e:	5d                   	pop    %ebp
8010148f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101490:	8b 43 0c             	mov    0xc(%ebx),%eax
80101493:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101496:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101499:	5b                   	pop    %ebx
8010149a:	5e                   	pop    %esi
8010149b:	5f                   	pop    %edi
8010149c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010149d:	e9 1e 26 00 00       	jmp    80103ac0 <piperead>
801014a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801014a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801014ad:	eb d7                	jmp    80101486 <fileread+0x56>
  panic("fileread");
801014af:	83 ec 0c             	sub    $0xc,%esp
801014b2:	68 8e 7b 10 80       	push   $0x80107b8e
801014b7:	e8 24 ef ff ff       	call   801003e0 <panic>
801014bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	57                   	push   %edi
801014c4:	56                   	push   %esi
801014c5:	53                   	push   %ebx
801014c6:	83 ec 1c             	sub    $0x1c,%esp
801014c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801014cc:	8b 75 08             	mov    0x8(%ebp),%esi
801014cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801014d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801014d5:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801014d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801014dc:	0f 84 c3 00 00 00    	je     801015a5 <filewrite+0xe5>
    return -1;
  if(f->type == FD_PIPE)
801014e2:	8b 06                	mov    (%esi),%eax
801014e4:	83 f8 01             	cmp    $0x1,%eax
801014e7:	0f 84 cb 00 00 00    	je     801015b8 <filewrite+0xf8>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_MEMO){
801014ed:	83 f8 02             	cmp    $0x2,%eax
801014f0:	0f 84 d4 00 00 00    	je     801015ca <filewrite+0x10a>
    memowrite(addr,n);
    return n;
  }
  if(f->type == FD_INODE){
801014f6:	83 f8 03             	cmp    $0x3,%eax
801014f9:	0f 85 e7 00 00 00    	jne    801015e6 <filewrite+0x126>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801014ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101502:	31 ff                	xor    %edi,%edi
    while(i < n){
80101504:	85 c0                	test   %eax,%eax
80101506:	7f 2f                	jg     80101537 <filewrite+0x77>
80101508:	e9 93 00 00 00       	jmp    801015a0 <filewrite+0xe0>
8010150d:	8d 76 00             	lea    0x0(%esi),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101510:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101513:	83 ec 0c             	sub    $0xc,%esp
80101516:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101519:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010151c:	e8 4f 07 00 00       	call   80101c70 <iunlock>
      end_op();
80101521:	e8 5a 1c 00 00       	call   80103180 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101526:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101529:	83 c4 10             	add    $0x10,%esp
8010152c:	39 c3                	cmp    %eax,%ebx
8010152e:	75 60                	jne    80101590 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101530:	01 df                	add    %ebx,%edi
    while(i < n){
80101532:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101535:	7e 69                	jle    801015a0 <filewrite+0xe0>
      int n1 = n - i;
80101537:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010153a:	b8 00 06 00 00       	mov    $0x600,%eax
8010153f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101541:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101547:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010154a:	e8 c1 1b 00 00       	call   80103110 <begin_op>
      ilock(f->ip);
8010154f:	83 ec 0c             	sub    $0xc,%esp
80101552:	ff 76 10             	pushl  0x10(%esi)
80101555:	e8 36 06 00 00       	call   80101b90 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010155a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010155d:	53                   	push   %ebx
8010155e:	ff 76 14             	pushl  0x14(%esi)
80101561:	01 f8                	add    %edi,%eax
80101563:	50                   	push   %eax
80101564:	ff 76 10             	pushl  0x10(%esi)
80101567:	e8 04 0a 00 00       	call   80101f70 <writei>
8010156c:	83 c4 20             	add    $0x20,%esp
8010156f:	85 c0                	test   %eax,%eax
80101571:	7f 9d                	jg     80101510 <filewrite+0x50>
      iunlock(f->ip);
80101573:	83 ec 0c             	sub    $0xc,%esp
80101576:	ff 76 10             	pushl  0x10(%esi)
80101579:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010157c:	e8 ef 06 00 00       	call   80101c70 <iunlock>
      end_op();
80101581:	e8 fa 1b 00 00       	call   80103180 <end_op>
      if(r < 0)
80101586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101589:	83 c4 10             	add    $0x10,%esp
8010158c:	85 c0                	test   %eax,%eax
8010158e:	75 15                	jne    801015a5 <filewrite+0xe5>
        panic("short filewrite");
80101590:	83 ec 0c             	sub    $0xc,%esp
80101593:	68 97 7b 10 80       	push   $0x80107b97
80101598:	e8 43 ee ff ff       	call   801003e0 <panic>
8010159d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801015a0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801015a3:	74 05                	je     801015aa <filewrite+0xea>
    return -1;
801015a5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  }
  panic("filewrite");
}
801015aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015ad:	89 f8                	mov    %edi,%eax
801015af:	5b                   	pop    %ebx
801015b0:	5e                   	pop    %esi
801015b1:	5f                   	pop    %edi
801015b2:	5d                   	pop    %ebp
801015b3:	c3                   	ret    
801015b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return pipewrite(f->pipe, addr, n);
801015b8:	8b 46 0c             	mov    0xc(%esi),%eax
801015bb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801015be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015c1:	5b                   	pop    %ebx
801015c2:	5e                   	pop    %esi
801015c3:	5f                   	pop    %edi
801015c4:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801015c5:	e9 e6 23 00 00       	jmp    801039b0 <pipewrite>
    memowrite(addr,n);
801015ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801015cd:	83 ec 08             	sub    $0x8,%esp
801015d0:	57                   	push   %edi
801015d1:	ff 75 dc             	pushl  -0x24(%ebp)
801015d4:	e8 e7 21 00 00       	call   801037c0 <memowrite>
    return n;
801015d9:	83 c4 10             	add    $0x10,%esp
}
801015dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015df:	89 f8                	mov    %edi,%eax
801015e1:	5b                   	pop    %ebx
801015e2:	5e                   	pop    %esi
801015e3:	5f                   	pop    %edi
801015e4:	5d                   	pop    %ebp
801015e5:	c3                   	ret    
  panic("filewrite");
801015e6:	83 ec 0c             	sub    $0xc,%esp
801015e9:	68 9d 7b 10 80       	push   $0x80107b9d
801015ee:	e8 ed ed ff ff       	call   801003e0 <panic>
801015f3:	66 90                	xchg   %ax,%ax
801015f5:	66 90                	xchg   %ax,%ax
801015f7:	66 90                	xchg   %ax,%ax
801015f9:	66 90                	xchg   %ax,%ax
801015fb:	66 90                	xchg   %ax,%ax
801015fd:	66 90                	xchg   %ax,%ax
801015ff:	90                   	nop

80101600 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	57                   	push   %edi
80101604:	56                   	push   %esi
80101605:	53                   	push   %ebx
80101606:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101609:	8b 0d 60 1a 11 80    	mov    0x80111a60,%ecx
{
8010160f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101612:	85 c9                	test   %ecx,%ecx
80101614:	0f 84 87 00 00 00    	je     801016a1 <balloc+0xa1>
8010161a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101621:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101624:	83 ec 08             	sub    $0x8,%esp
80101627:	89 f0                	mov    %esi,%eax
80101629:	c1 f8 0c             	sar    $0xc,%eax
8010162c:	03 05 78 1a 11 80    	add    0x80111a78,%eax
80101632:	50                   	push   %eax
80101633:	ff 75 d8             	pushl  -0x28(%ebp)
80101636:	e8 95 ea ff ff       	call   801000d0 <bread>
8010163b:	83 c4 10             	add    $0x10,%esp
8010163e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101641:	a1 60 1a 11 80       	mov    0x80111a60,%eax
80101646:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101649:	31 c0                	xor    %eax,%eax
8010164b:	eb 2f                	jmp    8010167c <balloc+0x7c>
8010164d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101650:	89 c1                	mov    %eax,%ecx
80101652:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101657:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010165a:	83 e1 07             	and    $0x7,%ecx
8010165d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010165f:	89 c1                	mov    %eax,%ecx
80101661:	c1 f9 03             	sar    $0x3,%ecx
80101664:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101669:	89 fa                	mov    %edi,%edx
8010166b:	85 df                	test   %ebx,%edi
8010166d:	74 41                	je     801016b0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010166f:	83 c0 01             	add    $0x1,%eax
80101672:	83 c6 01             	add    $0x1,%esi
80101675:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010167a:	74 05                	je     80101681 <balloc+0x81>
8010167c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010167f:	77 cf                	ja     80101650 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101681:	83 ec 0c             	sub    $0xc,%esp
80101684:	ff 75 e4             	pushl  -0x1c(%ebp)
80101687:	e8 64 eb ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010168c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101693:	83 c4 10             	add    $0x10,%esp
80101696:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101699:	39 05 60 1a 11 80    	cmp    %eax,0x80111a60
8010169f:	77 80                	ja     80101621 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801016a1:	83 ec 0c             	sub    $0xc,%esp
801016a4:	68 a7 7b 10 80       	push   $0x80107ba7
801016a9:	e8 32 ed ff ff       	call   801003e0 <panic>
801016ae:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801016b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801016b3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801016b6:	09 da                	or     %ebx,%edx
801016b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801016bc:	57                   	push   %edi
801016bd:	e8 2e 1c 00 00       	call   801032f0 <log_write>
        brelse(bp);
801016c2:	89 3c 24             	mov    %edi,(%esp)
801016c5:	e8 26 eb ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801016ca:	58                   	pop    %eax
801016cb:	5a                   	pop    %edx
801016cc:	56                   	push   %esi
801016cd:	ff 75 d8             	pushl  -0x28(%ebp)
801016d0:	e8 fb e9 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801016d5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801016d8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801016da:	8d 40 5c             	lea    0x5c(%eax),%eax
801016dd:	68 00 02 00 00       	push   $0x200
801016e2:	6a 00                	push   $0x0
801016e4:	50                   	push   %eax
801016e5:	e8 06 36 00 00       	call   80104cf0 <memset>
  log_write(bp);
801016ea:	89 1c 24             	mov    %ebx,(%esp)
801016ed:	e8 fe 1b 00 00       	call   801032f0 <log_write>
  brelse(bp);
801016f2:	89 1c 24             	mov    %ebx,(%esp)
801016f5:	e8 f6 ea ff ff       	call   801001f0 <brelse>
}
801016fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016fd:	89 f0                	mov    %esi,%eax
801016ff:	5b                   	pop    %ebx
80101700:	5e                   	pop    %esi
80101701:	5f                   	pop    %edi
80101702:	5d                   	pop    %ebp
80101703:	c3                   	ret    
80101704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010170a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101710 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	57                   	push   %edi
80101714:	89 c7                	mov    %eax,%edi
80101716:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101717:	31 f6                	xor    %esi,%esi
{
80101719:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010171a:	bb b4 1a 11 80       	mov    $0x80111ab4,%ebx
{
8010171f:	83 ec 28             	sub    $0x28,%esp
80101722:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101725:	68 80 1a 11 80       	push   $0x80111a80
8010172a:	e8 51 34 00 00       	call   80104b80 <acquire>
8010172f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101732:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101735:	eb 1b                	jmp    80101752 <iget+0x42>
80101737:	89 f6                	mov    %esi,%esi
80101739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101740:	39 3b                	cmp    %edi,(%ebx)
80101742:	74 6c                	je     801017b0 <iget+0xa0>
80101744:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010174a:	81 fb d4 36 11 80    	cmp    $0x801136d4,%ebx
80101750:	73 26                	jae    80101778 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101752:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101755:	85 c9                	test   %ecx,%ecx
80101757:	7f e7                	jg     80101740 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101759:	85 f6                	test   %esi,%esi
8010175b:	75 e7                	jne    80101744 <iget+0x34>
8010175d:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80101763:	85 c9                	test   %ecx,%ecx
80101765:	75 70                	jne    801017d7 <iget+0xc7>
80101767:	89 de                	mov    %ebx,%esi
80101769:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010176b:	81 fb d4 36 11 80    	cmp    $0x801136d4,%ebx
80101771:	72 df                	jb     80101752 <iget+0x42>
80101773:	90                   	nop
80101774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101778:	85 f6                	test   %esi,%esi
8010177a:	74 74                	je     801017f0 <iget+0xe0>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010177c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010177f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101781:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101784:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010178b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101792:	68 80 1a 11 80       	push   $0x80111a80
80101797:	e8 04 35 00 00       	call   80104ca0 <release>

  return ip;
8010179c:	83 c4 10             	add    $0x10,%esp
}
8010179f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017a2:	89 f0                	mov    %esi,%eax
801017a4:	5b                   	pop    %ebx
801017a5:	5e                   	pop    %esi
801017a6:	5f                   	pop    %edi
801017a7:	5d                   	pop    %ebp
801017a8:	c3                   	ret    
801017a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017b0:	39 53 04             	cmp    %edx,0x4(%ebx)
801017b3:	75 8f                	jne    80101744 <iget+0x34>
      release(&icache.lock);
801017b5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801017b8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801017bb:	89 de                	mov    %ebx,%esi
      ip->ref++;
801017bd:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801017c0:	68 80 1a 11 80       	push   $0x80111a80
801017c5:	e8 d6 34 00 00       	call   80104ca0 <release>
      return ip;
801017ca:	83 c4 10             	add    $0x10,%esp
}
801017cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017d0:	89 f0                	mov    %esi,%eax
801017d2:	5b                   	pop    %ebx
801017d3:	5e                   	pop    %esi
801017d4:	5f                   	pop    %edi
801017d5:	5d                   	pop    %ebp
801017d6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017d7:	3d d4 36 11 80       	cmp    $0x801136d4,%eax
801017dc:	73 12                	jae    801017f0 <iget+0xe0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017de:	8b 48 08             	mov    0x8(%eax),%ecx
801017e1:	89 c3                	mov    %eax,%ebx
801017e3:	85 c9                	test   %ecx,%ecx
801017e5:	0f 8f 55 ff ff ff    	jg     80101740 <iget+0x30>
801017eb:	e9 6d ff ff ff       	jmp    8010175d <iget+0x4d>
    panic("iget: no inodes");
801017f0:	83 ec 0c             	sub    $0xc,%esp
801017f3:	68 bd 7b 10 80       	push   $0x80107bbd
801017f8:	e8 e3 eb ff ff       	call   801003e0 <panic>
801017fd:	8d 76 00             	lea    0x0(%esi),%esi

80101800 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	57                   	push   %edi
80101804:	56                   	push   %esi
80101805:	89 c6                	mov    %eax,%esi
80101807:	53                   	push   %ebx
80101808:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010180b:	83 fa 0b             	cmp    $0xb,%edx
8010180e:	0f 86 84 00 00 00    	jbe    80101898 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101814:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101817:	83 fb 7f             	cmp    $0x7f,%ebx
8010181a:	0f 87 98 00 00 00    	ja     801018b8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101820:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101826:	8b 00                	mov    (%eax),%eax
80101828:	85 d2                	test   %edx,%edx
8010182a:	74 54                	je     80101880 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010182c:	83 ec 08             	sub    $0x8,%esp
8010182f:	52                   	push   %edx
80101830:	50                   	push   %eax
80101831:	e8 9a e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101836:	83 c4 10             	add    $0x10,%esp
80101839:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010183d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010183f:	8b 1a                	mov    (%edx),%ebx
80101841:	85 db                	test   %ebx,%ebx
80101843:	74 1b                	je     80101860 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101845:	83 ec 0c             	sub    $0xc,%esp
80101848:	57                   	push   %edi
80101849:	e8 a2 e9 ff ff       	call   801001f0 <brelse>
    return addr;
8010184e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101851:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101854:	89 d8                	mov    %ebx,%eax
80101856:	5b                   	pop    %ebx
80101857:	5e                   	pop    %esi
80101858:	5f                   	pop    %edi
80101859:	5d                   	pop    %ebp
8010185a:	c3                   	ret    
8010185b:	90                   	nop
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a[bn] = addr = balloc(ip->dev);
80101860:	8b 06                	mov    (%esi),%eax
80101862:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101865:	e8 96 fd ff ff       	call   80101600 <balloc>
8010186a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010186d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101870:	89 c3                	mov    %eax,%ebx
80101872:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101874:	57                   	push   %edi
80101875:	e8 76 1a 00 00       	call   801032f0 <log_write>
8010187a:	83 c4 10             	add    $0x10,%esp
8010187d:	eb c6                	jmp    80101845 <bmap+0x45>
8010187f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101880:	e8 7b fd ff ff       	call   80101600 <balloc>
80101885:	89 c2                	mov    %eax,%edx
80101887:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010188d:	8b 06                	mov    (%esi),%eax
8010188f:	eb 9b                	jmp    8010182c <bmap+0x2c>
80101891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101898:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010189b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010189e:	85 db                	test   %ebx,%ebx
801018a0:	75 af                	jne    80101851 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801018a2:	8b 00                	mov    (%eax),%eax
801018a4:	e8 57 fd ff ff       	call   80101600 <balloc>
801018a9:	89 47 5c             	mov    %eax,0x5c(%edi)
801018ac:	89 c3                	mov    %eax,%ebx
}
801018ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018b1:	89 d8                	mov    %ebx,%eax
801018b3:	5b                   	pop    %ebx
801018b4:	5e                   	pop    %esi
801018b5:	5f                   	pop    %edi
801018b6:	5d                   	pop    %ebp
801018b7:	c3                   	ret    
  panic("bmap: out of range");
801018b8:	83 ec 0c             	sub    $0xc,%esp
801018bb:	68 cd 7b 10 80       	push   $0x80107bcd
801018c0:	e8 1b eb ff ff       	call   801003e0 <panic>
801018c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801018d0 <readsb>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	56                   	push   %esi
801018d4:	53                   	push   %ebx
801018d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801018d8:	83 ec 08             	sub    $0x8,%esp
801018db:	6a 01                	push   $0x1
801018dd:	ff 75 08             	pushl  0x8(%ebp)
801018e0:	e8 eb e7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801018e5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801018e8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801018ea:	8d 40 5c             	lea    0x5c(%eax),%eax
801018ed:	6a 1c                	push   $0x1c
801018ef:	50                   	push   %eax
801018f0:	56                   	push   %esi
801018f1:	e8 9a 34 00 00       	call   80104d90 <memmove>
  brelse(bp);
801018f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018f9:	83 c4 10             	add    $0x10,%esp
}
801018fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ff:	5b                   	pop    %ebx
80101900:	5e                   	pop    %esi
80101901:	5d                   	pop    %ebp
  brelse(bp);
80101902:	e9 e9 e8 ff ff       	jmp    801001f0 <brelse>
80101907:	89 f6                	mov    %esi,%esi
80101909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101910 <bfree>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	56                   	push   %esi
80101914:	89 c6                	mov    %eax,%esi
80101916:	53                   	push   %ebx
80101917:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
80101919:	83 ec 08             	sub    $0x8,%esp
8010191c:	68 60 1a 11 80       	push   $0x80111a60
80101921:	50                   	push   %eax
80101922:	e8 a9 ff ff ff       	call   801018d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101927:	58                   	pop    %eax
80101928:	5a                   	pop    %edx
80101929:	89 da                	mov    %ebx,%edx
8010192b:	c1 ea 0c             	shr    $0xc,%edx
8010192e:	03 15 78 1a 11 80    	add    0x80111a78,%edx
80101934:	52                   	push   %edx
80101935:	56                   	push   %esi
80101936:	e8 95 e7 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010193b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010193d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101940:	ba 01 00 00 00       	mov    $0x1,%edx
80101945:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101948:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010194e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101951:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101953:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101958:	85 d1                	test   %edx,%ecx
8010195a:	74 25                	je     80101981 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010195c:	f7 d2                	not    %edx
8010195e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101960:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101963:	21 ca                	and    %ecx,%edx
80101965:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101969:	56                   	push   %esi
8010196a:	e8 81 19 00 00       	call   801032f0 <log_write>
  brelse(bp);
8010196f:	89 34 24             	mov    %esi,(%esp)
80101972:	e8 79 e8 ff ff       	call   801001f0 <brelse>
}
80101977:	83 c4 10             	add    $0x10,%esp
8010197a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010197d:	5b                   	pop    %ebx
8010197e:	5e                   	pop    %esi
8010197f:	5d                   	pop    %ebp
80101980:	c3                   	ret    
    panic("freeing free block");
80101981:	83 ec 0c             	sub    $0xc,%esp
80101984:	68 e0 7b 10 80       	push   $0x80107be0
80101989:	e8 52 ea ff ff       	call   801003e0 <panic>
8010198e:	66 90                	xchg   %ax,%ax

80101990 <iinit>:
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	53                   	push   %ebx
80101994:	bb c0 1a 11 80       	mov    $0x80111ac0,%ebx
80101999:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010199c:	68 f3 7b 10 80       	push   $0x80107bf3
801019a1:	68 80 1a 11 80       	push   $0x80111a80
801019a6:	e8 d5 30 00 00       	call   80104a80 <initlock>
  for(i = 0; i < NINODE; i++) {
801019ab:	83 c4 10             	add    $0x10,%esp
801019ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801019b0:	83 ec 08             	sub    $0x8,%esp
801019b3:	68 fa 7b 10 80       	push   $0x80107bfa
801019b8:	53                   	push   %ebx
801019b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801019bf:	e8 ac 2f 00 00       	call   80104970 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801019c4:	83 c4 10             	add    $0x10,%esp
801019c7:	81 fb e0 36 11 80    	cmp    $0x801136e0,%ebx
801019cd:	75 e1                	jne    801019b0 <iinit+0x20>
  readsb(dev, &sb);
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	68 60 1a 11 80       	push   $0x80111a60
801019d7:	ff 75 08             	pushl  0x8(%ebp)
801019da:	e8 f1 fe ff ff       	call   801018d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801019df:	ff 35 78 1a 11 80    	pushl  0x80111a78
801019e5:	ff 35 74 1a 11 80    	pushl  0x80111a74
801019eb:	ff 35 70 1a 11 80    	pushl  0x80111a70
801019f1:	ff 35 6c 1a 11 80    	pushl  0x80111a6c
801019f7:	ff 35 68 1a 11 80    	pushl  0x80111a68
801019fd:	ff 35 64 1a 11 80    	pushl  0x80111a64
80101a03:	ff 35 60 1a 11 80    	pushl  0x80111a60
80101a09:	68 60 7c 10 80       	push   $0x80107c60
80101a0e:	e8 dd ec ff ff       	call   801006f0 <cprintf>
}
80101a13:	83 c4 30             	add    $0x30,%esp
80101a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a19:	c9                   	leave  
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a20 <ialloc>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	56                   	push   %esi
80101a25:	53                   	push   %ebx
80101a26:	83 ec 1c             	sub    $0x1c,%esp
80101a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101a2c:	83 3d 68 1a 11 80 01 	cmpl   $0x1,0x80111a68
{
80101a33:	8b 75 08             	mov    0x8(%ebp),%esi
80101a36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101a39:	0f 86 91 00 00 00    	jbe    80101ad0 <ialloc+0xb0>
80101a3f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101a44:	eb 21                	jmp    80101a67 <ialloc+0x47>
80101a46:	8d 76 00             	lea    0x0(%esi),%esi
80101a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101a50:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101a53:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101a56:	57                   	push   %edi
80101a57:	e8 94 e7 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101a5c:	83 c4 10             	add    $0x10,%esp
80101a5f:	3b 1d 68 1a 11 80    	cmp    0x80111a68,%ebx
80101a65:	73 69                	jae    80101ad0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101a67:	89 d8                	mov    %ebx,%eax
80101a69:	83 ec 08             	sub    $0x8,%esp
80101a6c:	c1 e8 03             	shr    $0x3,%eax
80101a6f:	03 05 74 1a 11 80    	add    0x80111a74,%eax
80101a75:	50                   	push   %eax
80101a76:	56                   	push   %esi
80101a77:	e8 54 e6 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101a7c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101a7f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101a81:	89 d8                	mov    %ebx,%eax
80101a83:	83 e0 07             	and    $0x7,%eax
80101a86:	c1 e0 06             	shl    $0x6,%eax
80101a89:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101a8d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101a91:	75 bd                	jne    80101a50 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101a93:	83 ec 04             	sub    $0x4,%esp
80101a96:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101a99:	6a 40                	push   $0x40
80101a9b:	6a 00                	push   $0x0
80101a9d:	51                   	push   %ecx
80101a9e:	e8 4d 32 00 00       	call   80104cf0 <memset>
      dip->type = type;
80101aa3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101aa7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aaa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101aad:	89 3c 24             	mov    %edi,(%esp)
80101ab0:	e8 3b 18 00 00       	call   801032f0 <log_write>
      brelse(bp);
80101ab5:	89 3c 24             	mov    %edi,(%esp)
80101ab8:	e8 33 e7 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101abd:	83 c4 10             	add    $0x10,%esp
}
80101ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101ac3:	89 da                	mov    %ebx,%edx
80101ac5:	89 f0                	mov    %esi,%eax
}
80101ac7:	5b                   	pop    %ebx
80101ac8:	5e                   	pop    %esi
80101ac9:	5f                   	pop    %edi
80101aca:	5d                   	pop    %ebp
      return iget(dev, inum);
80101acb:	e9 40 fc ff ff       	jmp    80101710 <iget>
  panic("ialloc: no inodes");
80101ad0:	83 ec 0c             	sub    $0xc,%esp
80101ad3:	68 00 7c 10 80       	push   $0x80107c00
80101ad8:	e8 03 e9 ff ff       	call   801003e0 <panic>
80101add:	8d 76 00             	lea    0x0(%esi),%esi

80101ae0 <iupdate>:
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	56                   	push   %esi
80101ae4:	53                   	push   %ebx
80101ae5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ae8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101aeb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101aee:	83 ec 08             	sub    $0x8,%esp
80101af1:	c1 e8 03             	shr    $0x3,%eax
80101af4:	03 05 74 1a 11 80    	add    0x80111a74,%eax
80101afa:	50                   	push   %eax
80101afb:	ff 73 a4             	pushl  -0x5c(%ebx)
80101afe:	e8 cd e5 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101b03:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b07:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b0a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b0c:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101b0f:	83 e0 07             	and    $0x7,%eax
80101b12:	c1 e0 06             	shl    $0x6,%eax
80101b15:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101b19:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101b1c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b20:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101b23:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101b27:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101b2b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101b2f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101b33:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101b37:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101b3a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b3d:	6a 34                	push   $0x34
80101b3f:	53                   	push   %ebx
80101b40:	50                   	push   %eax
80101b41:	e8 4a 32 00 00       	call   80104d90 <memmove>
  log_write(bp);
80101b46:	89 34 24             	mov    %esi,(%esp)
80101b49:	e8 a2 17 00 00       	call   801032f0 <log_write>
  brelse(bp);
80101b4e:	89 75 08             	mov    %esi,0x8(%ebp)
80101b51:	83 c4 10             	add    $0x10,%esp
}
80101b54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b57:	5b                   	pop    %ebx
80101b58:	5e                   	pop    %esi
80101b59:	5d                   	pop    %ebp
  brelse(bp);
80101b5a:	e9 91 e6 ff ff       	jmp    801001f0 <brelse>
80101b5f:	90                   	nop

80101b60 <idup>:
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	53                   	push   %ebx
80101b64:	83 ec 10             	sub    $0x10,%esp
80101b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101b6a:	68 80 1a 11 80       	push   $0x80111a80
80101b6f:	e8 0c 30 00 00       	call   80104b80 <acquire>
  ip->ref++;
80101b74:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b78:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101b7f:	e8 1c 31 00 00       	call   80104ca0 <release>
}
80101b84:	89 d8                	mov    %ebx,%eax
80101b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b89:	c9                   	leave  
80101b8a:	c3                   	ret    
80101b8b:	90                   	nop
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b90 <ilock>:
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	56                   	push   %esi
80101b94:	53                   	push   %ebx
80101b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101b98:	85 db                	test   %ebx,%ebx
80101b9a:	0f 84 b7 00 00 00    	je     80101c57 <ilock+0xc7>
80101ba0:	8b 53 08             	mov    0x8(%ebx),%edx
80101ba3:	85 d2                	test   %edx,%edx
80101ba5:	0f 8e ac 00 00 00    	jle    80101c57 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101bab:	83 ec 0c             	sub    $0xc,%esp
80101bae:	8d 43 0c             	lea    0xc(%ebx),%eax
80101bb1:	50                   	push   %eax
80101bb2:	e8 f9 2d 00 00       	call   801049b0 <acquiresleep>
  if(ip->valid == 0){
80101bb7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101bba:	83 c4 10             	add    $0x10,%esp
80101bbd:	85 c0                	test   %eax,%eax
80101bbf:	74 0f                	je     80101bd0 <ilock+0x40>
}
80101bc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101bc4:	5b                   	pop    %ebx
80101bc5:	5e                   	pop    %esi
80101bc6:	5d                   	pop    %ebp
80101bc7:	c3                   	ret    
80101bc8:	90                   	nop
80101bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bd0:	8b 43 04             	mov    0x4(%ebx),%eax
80101bd3:	83 ec 08             	sub    $0x8,%esp
80101bd6:	c1 e8 03             	shr    $0x3,%eax
80101bd9:	03 05 74 1a 11 80    	add    0x80111a74,%eax
80101bdf:	50                   	push   %eax
80101be0:	ff 33                	pushl  (%ebx)
80101be2:	e8 e9 e4 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101be7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101bec:	8b 43 04             	mov    0x4(%ebx),%eax
80101bef:	83 e0 07             	and    $0x7,%eax
80101bf2:	c1 e0 06             	shl    $0x6,%eax
80101bf5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101bf9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101bfc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101bff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101c03:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101c07:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101c0b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101c0f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101c13:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101c17:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101c1b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101c1e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c21:	6a 34                	push   $0x34
80101c23:	50                   	push   %eax
80101c24:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101c27:	50                   	push   %eax
80101c28:	e8 63 31 00 00       	call   80104d90 <memmove>
    brelse(bp);
80101c2d:	89 34 24             	mov    %esi,(%esp)
80101c30:	e8 bb e5 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101c35:	83 c4 10             	add    $0x10,%esp
80101c38:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101c3d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101c44:	0f 85 77 ff ff ff    	jne    80101bc1 <ilock+0x31>
      panic("ilock: no type");
80101c4a:	83 ec 0c             	sub    $0xc,%esp
80101c4d:	68 18 7c 10 80       	push   $0x80107c18
80101c52:	e8 89 e7 ff ff       	call   801003e0 <panic>
    panic("ilock");
80101c57:	83 ec 0c             	sub    $0xc,%esp
80101c5a:	68 12 7c 10 80       	push   $0x80107c12
80101c5f:	e8 7c e7 ff ff       	call   801003e0 <panic>
80101c64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c70 <iunlock>:
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	56                   	push   %esi
80101c74:	53                   	push   %ebx
80101c75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c78:	85 db                	test   %ebx,%ebx
80101c7a:	74 28                	je     80101ca4 <iunlock+0x34>
80101c7c:	83 ec 0c             	sub    $0xc,%esp
80101c7f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101c82:	56                   	push   %esi
80101c83:	e8 c8 2d 00 00       	call   80104a50 <holdingsleep>
80101c88:	83 c4 10             	add    $0x10,%esp
80101c8b:	85 c0                	test   %eax,%eax
80101c8d:	74 15                	je     80101ca4 <iunlock+0x34>
80101c8f:	8b 43 08             	mov    0x8(%ebx),%eax
80101c92:	85 c0                	test   %eax,%eax
80101c94:	7e 0e                	jle    80101ca4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101c96:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101c99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c9c:	5b                   	pop    %ebx
80101c9d:	5e                   	pop    %esi
80101c9e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101c9f:	e9 6c 2d 00 00       	jmp    80104a10 <releasesleep>
    panic("iunlock");
80101ca4:	83 ec 0c             	sub    $0xc,%esp
80101ca7:	68 27 7c 10 80       	push   $0x80107c27
80101cac:	e8 2f e7 ff ff       	call   801003e0 <panic>
80101cb1:	eb 0d                	jmp    80101cc0 <iput>
80101cb3:	90                   	nop
80101cb4:	90                   	nop
80101cb5:	90                   	nop
80101cb6:	90                   	nop
80101cb7:	90                   	nop
80101cb8:	90                   	nop
80101cb9:	90                   	nop
80101cba:	90                   	nop
80101cbb:	90                   	nop
80101cbc:	90                   	nop
80101cbd:	90                   	nop
80101cbe:	90                   	nop
80101cbf:	90                   	nop

80101cc0 <iput>:
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	57                   	push   %edi
80101cc4:	56                   	push   %esi
80101cc5:	53                   	push   %ebx
80101cc6:	83 ec 28             	sub    $0x28,%esp
80101cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101ccc:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101ccf:	57                   	push   %edi
80101cd0:	e8 db 2c 00 00       	call   801049b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101cd5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101cd8:	83 c4 10             	add    $0x10,%esp
80101cdb:	85 d2                	test   %edx,%edx
80101cdd:	74 07                	je     80101ce6 <iput+0x26>
80101cdf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101ce4:	74 32                	je     80101d18 <iput+0x58>
  releasesleep(&ip->lock);
80101ce6:	83 ec 0c             	sub    $0xc,%esp
80101ce9:	57                   	push   %edi
80101cea:	e8 21 2d 00 00       	call   80104a10 <releasesleep>
  acquire(&icache.lock);
80101cef:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101cf6:	e8 85 2e 00 00       	call   80104b80 <acquire>
  ip->ref--;
80101cfb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101cff:	83 c4 10             	add    $0x10,%esp
80101d02:	c7 45 08 80 1a 11 80 	movl   $0x80111a80,0x8(%ebp)
}
80101d09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0c:	5b                   	pop    %ebx
80101d0d:	5e                   	pop    %esi
80101d0e:	5f                   	pop    %edi
80101d0f:	5d                   	pop    %ebp
  release(&icache.lock);
80101d10:	e9 8b 2f 00 00       	jmp    80104ca0 <release>
80101d15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	68 80 1a 11 80       	push   $0x80111a80
80101d20:	e8 5b 2e 00 00       	call   80104b80 <acquire>
    int r = ip->ref;
80101d25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101d28:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
80101d2f:	e8 6c 2f 00 00       	call   80104ca0 <release>
    if(r == 1){
80101d34:	83 c4 10             	add    $0x10,%esp
80101d37:	83 fe 01             	cmp    $0x1,%esi
80101d3a:	75 aa                	jne    80101ce6 <iput+0x26>
80101d3c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101d42:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101d45:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101d48:	89 cf                	mov    %ecx,%edi
80101d4a:	eb 0b                	jmp    80101d57 <iput+0x97>
80101d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d50:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d53:	39 fe                	cmp    %edi,%esi
80101d55:	74 19                	je     80101d70 <iput+0xb0>
    if(ip->addrs[i]){
80101d57:	8b 16                	mov    (%esi),%edx
80101d59:	85 d2                	test   %edx,%edx
80101d5b:	74 f3                	je     80101d50 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101d5d:	8b 03                	mov    (%ebx),%eax
80101d5f:	e8 ac fb ff ff       	call   80101910 <bfree>
      ip->addrs[i] = 0;
80101d64:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101d6a:	eb e4                	jmp    80101d50 <iput+0x90>
80101d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101d70:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101d76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d79:	85 c0                	test   %eax,%eax
80101d7b:	75 33                	jne    80101db0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101d7d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101d80:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101d87:	53                   	push   %ebx
80101d88:	e8 53 fd ff ff       	call   80101ae0 <iupdate>
      ip->type = 0;
80101d8d:	31 c0                	xor    %eax,%eax
80101d8f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101d93:	89 1c 24             	mov    %ebx,(%esp)
80101d96:	e8 45 fd ff ff       	call   80101ae0 <iupdate>
      ip->valid = 0;
80101d9b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101da2:	83 c4 10             	add    $0x10,%esp
80101da5:	e9 3c ff ff ff       	jmp    80101ce6 <iput+0x26>
80101daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101db0:	83 ec 08             	sub    $0x8,%esp
80101db3:	50                   	push   %eax
80101db4:	ff 33                	pushl  (%ebx)
80101db6:	e8 15 e3 ff ff       	call   801000d0 <bread>
80101dbb:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101dbe:	83 c4 10             	add    $0x10,%esp
80101dc1:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101dc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101dca:	8d 70 5c             	lea    0x5c(%eax),%esi
80101dcd:	89 cf                	mov    %ecx,%edi
80101dcf:	eb 0e                	jmp    80101ddf <iput+0x11f>
80101dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dd8:	83 c6 04             	add    $0x4,%esi
80101ddb:	39 f7                	cmp    %esi,%edi
80101ddd:	74 11                	je     80101df0 <iput+0x130>
      if(a[j])
80101ddf:	8b 16                	mov    (%esi),%edx
80101de1:	85 d2                	test   %edx,%edx
80101de3:	74 f3                	je     80101dd8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101de5:	8b 03                	mov    (%ebx),%eax
80101de7:	e8 24 fb ff ff       	call   80101910 <bfree>
80101dec:	eb ea                	jmp    80101dd8 <iput+0x118>
80101dee:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101df0:	83 ec 0c             	sub    $0xc,%esp
80101df3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101df6:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101df9:	e8 f2 e3 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101dfe:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101e04:	8b 03                	mov    (%ebx),%eax
80101e06:	e8 05 fb ff ff       	call   80101910 <bfree>
    ip->addrs[NDIRECT] = 0;
80101e0b:	83 c4 10             	add    $0x10,%esp
80101e0e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101e15:	00 00 00 
80101e18:	e9 60 ff ff ff       	jmp    80101d7d <iput+0xbd>
80101e1d:	8d 76 00             	lea    0x0(%esi),%esi

80101e20 <iunlockput>:
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	53                   	push   %ebx
80101e24:	83 ec 10             	sub    $0x10,%esp
80101e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101e2a:	53                   	push   %ebx
80101e2b:	e8 40 fe ff ff       	call   80101c70 <iunlock>
  iput(ip);
80101e30:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101e33:	83 c4 10             	add    $0x10,%esp
}
80101e36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e39:	c9                   	leave  
  iput(ip);
80101e3a:	e9 81 fe ff ff       	jmp    80101cc0 <iput>
80101e3f:	90                   	nop

80101e40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	8b 55 08             	mov    0x8(%ebp),%edx
80101e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101e49:	8b 0a                	mov    (%edx),%ecx
80101e4b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101e4e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101e51:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101e54:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101e58:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101e5b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101e5f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101e63:	8b 52 58             	mov    0x58(%edx),%edx
80101e66:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e69:	5d                   	pop    %ebp
80101e6a:	c3                   	ret    
80101e6b:	90                   	nop
80101e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	57                   	push   %edi
80101e74:	56                   	push   %esi
80101e75:	53                   	push   %ebx
80101e76:	83 ec 1c             	sub    $0x1c,%esp
80101e79:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101e87:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101e8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101e90:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101e93:	0f 84 a7 00 00 00    	je     80101f40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101e99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e9c:	8b 40 58             	mov    0x58(%eax),%eax
80101e9f:	39 c6                	cmp    %eax,%esi
80101ea1:	0f 87 ba 00 00 00    	ja     80101f61 <readi+0xf1>
80101ea7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101eaa:	89 f9                	mov    %edi,%ecx
80101eac:	01 f1                	add    %esi,%ecx
80101eae:	0f 82 ad 00 00 00    	jb     80101f61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101eb4:	89 c2                	mov    %eax,%edx
80101eb6:	29 f2                	sub    %esi,%edx
80101eb8:	39 c8                	cmp    %ecx,%eax
80101eba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ebd:	31 ff                	xor    %edi,%edi
    n = ip->size - off;
80101ebf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ec2:	85 d2                	test   %edx,%edx
80101ec4:	74 6c                	je     80101f32 <readi+0xc2>
80101ec6:	8d 76 00             	lea    0x0(%esi),%esi
80101ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ed0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ed3:	89 f2                	mov    %esi,%edx
80101ed5:	c1 ea 09             	shr    $0x9,%edx
80101ed8:	89 d8                	mov    %ebx,%eax
80101eda:	e8 21 f9 ff ff       	call   80101800 <bmap>
80101edf:	83 ec 08             	sub    $0x8,%esp
80101ee2:	50                   	push   %eax
80101ee3:	ff 33                	pushl  (%ebx)
80101ee5:	e8 e6 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101eea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101eed:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ef2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ef5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ef7:	89 f0                	mov    %esi,%eax
80101ef9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101efe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101f00:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f03:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101f05:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101f09:	39 d9                	cmp    %ebx,%ecx
80101f0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101f0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f0f:	01 df                	add    %ebx,%edi
80101f11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101f13:	50                   	push   %eax
80101f14:	ff 75 e0             	pushl  -0x20(%ebp)
80101f17:	e8 74 2e 00 00       	call   80104d90 <memmove>
    brelse(bp);
80101f1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f1f:	89 14 24             	mov    %edx,(%esp)
80101f22:	e8 c9 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101f30:	77 9e                	ja     80101ed0 <readi+0x60>
  }
  return n;
80101f32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f38:	5b                   	pop    %ebx
80101f39:	5e                   	pop    %esi
80101f3a:	5f                   	pop    %edi
80101f3b:	5d                   	pop    %ebp
80101f3c:	c3                   	ret    
80101f3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f44:	66 83 f8 09          	cmp    $0x9,%ax
80101f48:	77 17                	ja     80101f61 <readi+0xf1>
80101f4a:	8b 04 c5 00 1a 11 80 	mov    -0x7feee600(,%eax,8),%eax
80101f51:	85 c0                	test   %eax,%eax
80101f53:	74 0c                	je     80101f61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101f55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5b:	5b                   	pop    %ebx
80101f5c:	5e                   	pop    %esi
80101f5d:	5f                   	pop    %edi
80101f5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101f5f:	ff e0                	jmp    *%eax
      return -1;
80101f61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f66:	eb cd                	jmp    80101f35 <readi+0xc5>
80101f68:	90                   	nop
80101f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	57                   	push   %edi
80101f74:	56                   	push   %esi
80101f75:	53                   	push   %ebx
80101f76:	83 ec 1c             	sub    $0x1c,%esp
80101f79:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101f7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101f8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101f90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101f93:	0f 84 b7 00 00 00    	je     80102050 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101f99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101f9f:	0f 82 e7 00 00 00    	jb     8010208c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101fa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101fa8:	89 f8                	mov    %edi,%eax
80101faa:	01 f0                	add    %esi,%eax
80101fac:	0f 82 da 00 00 00    	jb     8010208c <writei+0x11c>
80101fb2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fb7:	0f 87 cf 00 00 00    	ja     8010208c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fbd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101fc4:	85 ff                	test   %edi,%edi
80101fc6:	74 79                	je     80102041 <writei+0xd1>
80101fc8:	90                   	nop
80101fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101fd3:	89 f2                	mov    %esi,%edx
80101fd5:	c1 ea 09             	shr    $0x9,%edx
80101fd8:	89 f8                	mov    %edi,%eax
80101fda:	e8 21 f8 ff ff       	call   80101800 <bmap>
80101fdf:	83 ec 08             	sub    $0x8,%esp
80101fe2:	50                   	push   %eax
80101fe3:	ff 37                	pushl  (%edi)
80101fe5:	e8 e6 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101fea:	b9 00 02 00 00       	mov    $0x200,%ecx
80101fef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ff2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ff5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ff7:	89 f0                	mov    %esi,%eax
80101ff9:	83 c4 0c             	add    $0xc,%esp
80101ffc:	25 ff 01 00 00       	and    $0x1ff,%eax
80102001:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102003:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102007:	39 d9                	cmp    %ebx,%ecx
80102009:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010200c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010200d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010200f:	ff 75 dc             	pushl  -0x24(%ebp)
80102012:	50                   	push   %eax
80102013:	e8 78 2d 00 00       	call   80104d90 <memmove>
    log_write(bp);
80102018:	89 3c 24             	mov    %edi,(%esp)
8010201b:	e8 d0 12 00 00       	call   801032f0 <log_write>
    brelse(bp);
80102020:	89 3c 24             	mov    %edi,(%esp)
80102023:	e8 c8 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102028:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010202b:	83 c4 10             	add    $0x10,%esp
8010202e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102031:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102034:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102037:	77 97                	ja     80101fd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102039:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010203c:	3b 70 58             	cmp    0x58(%eax),%esi
8010203f:	77 37                	ja     80102078 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102041:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102044:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102047:	5b                   	pop    %ebx
80102048:	5e                   	pop    %esi
80102049:	5f                   	pop    %edi
8010204a:	5d                   	pop    %ebp
8010204b:	c3                   	ret    
8010204c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102050:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102054:	66 83 f8 09          	cmp    $0x9,%ax
80102058:	77 32                	ja     8010208c <writei+0x11c>
8010205a:	8b 04 c5 04 1a 11 80 	mov    -0x7feee5fc(,%eax,8),%eax
80102061:	85 c0                	test   %eax,%eax
80102063:	74 27                	je     8010208c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102065:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102068:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010206b:	5b                   	pop    %ebx
8010206c:	5e                   	pop    %esi
8010206d:	5f                   	pop    %edi
8010206e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010206f:	ff e0                	jmp    *%eax
80102071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102078:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010207b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010207e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102081:	50                   	push   %eax
80102082:	e8 59 fa ff ff       	call   80101ae0 <iupdate>
80102087:	83 c4 10             	add    $0x10,%esp
8010208a:	eb b5                	jmp    80102041 <writei+0xd1>
      return -1;
8010208c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102091:	eb b1                	jmp    80102044 <writei+0xd4>
80102093:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020a0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801020a6:	6a 0e                	push   $0xe
801020a8:	ff 75 0c             	pushl  0xc(%ebp)
801020ab:	ff 75 08             	pushl  0x8(%ebp)
801020ae:	e8 4d 2d 00 00       	call   80104e00 <strncmp>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020c0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 1c             	sub    $0x1c,%esp
801020c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020cc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020d1:	0f 85 85 00 00 00    	jne    8010215c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801020d7:	8b 53 58             	mov    0x58(%ebx),%edx
801020da:	31 ff                	xor    %edi,%edi
801020dc:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020df:	85 d2                	test   %edx,%edx
801020e1:	74 3e                	je     80102121 <dirlookup+0x61>
801020e3:	90                   	nop
801020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020e8:	6a 10                	push   $0x10
801020ea:	57                   	push   %edi
801020eb:	56                   	push   %esi
801020ec:	53                   	push   %ebx
801020ed:	e8 7e fd ff ff       	call   80101e70 <readi>
801020f2:	83 c4 10             	add    $0x10,%esp
801020f5:	83 f8 10             	cmp    $0x10,%eax
801020f8:	75 55                	jne    8010214f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801020fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020ff:	74 18                	je     80102119 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102101:	83 ec 04             	sub    $0x4,%esp
80102104:	8d 45 da             	lea    -0x26(%ebp),%eax
80102107:	6a 0e                	push   $0xe
80102109:	50                   	push   %eax
8010210a:	ff 75 0c             	pushl  0xc(%ebp)
8010210d:	e8 ee 2c 00 00       	call   80104e00 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102112:	83 c4 10             	add    $0x10,%esp
80102115:	85 c0                	test   %eax,%eax
80102117:	74 17                	je     80102130 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102119:	83 c7 10             	add    $0x10,%edi
8010211c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010211f:	72 c7                	jb     801020e8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102121:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102124:	31 c0                	xor    %eax,%eax
}
80102126:	5b                   	pop    %ebx
80102127:	5e                   	pop    %esi
80102128:	5f                   	pop    %edi
80102129:	5d                   	pop    %ebp
8010212a:	c3                   	ret    
8010212b:	90                   	nop
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80102130:	8b 45 10             	mov    0x10(%ebp),%eax
80102133:	85 c0                	test   %eax,%eax
80102135:	74 05                	je     8010213c <dirlookup+0x7c>
        *poff = off;
80102137:	8b 45 10             	mov    0x10(%ebp),%eax
8010213a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010213c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102140:	8b 03                	mov    (%ebx),%eax
80102142:	e8 c9 f5 ff ff       	call   80101710 <iget>
}
80102147:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214a:	5b                   	pop    %ebx
8010214b:	5e                   	pop    %esi
8010214c:	5f                   	pop    %edi
8010214d:	5d                   	pop    %ebp
8010214e:	c3                   	ret    
      panic("dirlookup read");
8010214f:	83 ec 0c             	sub    $0xc,%esp
80102152:	68 41 7c 10 80       	push   $0x80107c41
80102157:	e8 84 e2 ff ff       	call   801003e0 <panic>
    panic("dirlookup not DIR");
8010215c:	83 ec 0c             	sub    $0xc,%esp
8010215f:	68 2f 7c 10 80       	push   $0x80107c2f
80102164:	e8 77 e2 ff ff       	call   801003e0 <panic>
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102170 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102170:	55                   	push   %ebp
80102171:	89 e5                	mov    %esp,%ebp
80102173:	57                   	push   %edi
80102174:	56                   	push   %esi
80102175:	53                   	push   %ebx
80102176:	89 c3                	mov    %eax,%ebx
80102178:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010217b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010217e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102181:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102184:	0f 84 86 01 00 00    	je     80102310 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010218a:	e8 31 1c 00 00       	call   80103dc0 <myproc>
  acquire(&icache.lock);
8010218f:	83 ec 0c             	sub    $0xc,%esp
80102192:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102194:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102197:	68 80 1a 11 80       	push   $0x80111a80
8010219c:	e8 df 29 00 00       	call   80104b80 <acquire>
  ip->ref++;
801021a1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801021a5:	c7 04 24 80 1a 11 80 	movl   $0x80111a80,(%esp)
801021ac:	e8 ef 2a 00 00       	call   80104ca0 <release>
801021b1:	83 c4 10             	add    $0x10,%esp
801021b4:	eb 0d                	jmp    801021c3 <namex+0x53>
801021b6:	8d 76 00             	lea    0x0(%esi),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
801021c0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801021c3:	0f b6 07             	movzbl (%edi),%eax
801021c6:	3c 2f                	cmp    $0x2f,%al
801021c8:	74 f6                	je     801021c0 <namex+0x50>
  if(*path == 0)
801021ca:	84 c0                	test   %al,%al
801021cc:	0f 84 ee 00 00 00    	je     801022c0 <namex+0x150>
  while(*path != '/' && *path != 0)
801021d2:	0f b6 07             	movzbl (%edi),%eax
801021d5:	3c 2f                	cmp    $0x2f,%al
801021d7:	0f 84 fb 00 00 00    	je     801022d8 <namex+0x168>
801021dd:	89 fb                	mov    %edi,%ebx
801021df:	84 c0                	test   %al,%al
801021e1:	0f 84 f1 00 00 00    	je     801022d8 <namex+0x168>
801021e7:	89 f6                	mov    %esi,%esi
801021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
801021f0:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
801021f3:	0f b6 03             	movzbl (%ebx),%eax
801021f6:	3c 2f                	cmp    $0x2f,%al
801021f8:	74 04                	je     801021fe <namex+0x8e>
801021fa:	84 c0                	test   %al,%al
801021fc:	75 f2                	jne    801021f0 <namex+0x80>
  len = path - s;
801021fe:	89 d8                	mov    %ebx,%eax
80102200:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102202:	83 f8 0d             	cmp    $0xd,%eax
80102205:	0f 8e 85 00 00 00    	jle    80102290 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010220b:	83 ec 04             	sub    $0x4,%esp
8010220e:	6a 0e                	push   $0xe
80102210:	57                   	push   %edi
    path++;
80102211:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102213:	ff 75 e4             	pushl  -0x1c(%ebp)
80102216:	e8 75 2b 00 00       	call   80104d90 <memmove>
8010221b:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010221e:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102221:	75 0d                	jne    80102230 <namex+0xc0>
80102223:	90                   	nop
80102224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102228:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010222b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010222e:	74 f8                	je     80102228 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102230:	83 ec 0c             	sub    $0xc,%esp
80102233:	56                   	push   %esi
80102234:	e8 57 f9 ff ff       	call   80101b90 <ilock>
    if(ip->type != T_DIR){
80102239:	83 c4 10             	add    $0x10,%esp
8010223c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102241:	0f 85 a1 00 00 00    	jne    801022e8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102247:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010224a:	85 d2                	test   %edx,%edx
8010224c:	74 09                	je     80102257 <namex+0xe7>
8010224e:	80 3f 00             	cmpb   $0x0,(%edi)
80102251:	0f 84 d9 00 00 00    	je     80102330 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102257:	83 ec 04             	sub    $0x4,%esp
8010225a:	6a 00                	push   $0x0
8010225c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010225f:	56                   	push   %esi
80102260:	e8 5b fe ff ff       	call   801020c0 <dirlookup>
80102265:	83 c4 10             	add    $0x10,%esp
80102268:	89 c3                	mov    %eax,%ebx
8010226a:	85 c0                	test   %eax,%eax
8010226c:	74 7a                	je     801022e8 <namex+0x178>
  iunlock(ip);
8010226e:	83 ec 0c             	sub    $0xc,%esp
80102271:	56                   	push   %esi
80102272:	e8 f9 f9 ff ff       	call   80101c70 <iunlock>
  iput(ip);
80102277:	89 34 24             	mov    %esi,(%esp)
8010227a:	89 de                	mov    %ebx,%esi
8010227c:	e8 3f fa ff ff       	call   80101cc0 <iput>
  while(*path == '/')
80102281:	83 c4 10             	add    $0x10,%esp
80102284:	e9 3a ff ff ff       	jmp    801021c3 <namex+0x53>
80102289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102290:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102293:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102296:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102299:	83 ec 04             	sub    $0x4,%esp
8010229c:	50                   	push   %eax
8010229d:	57                   	push   %edi
    name[len] = 0;
8010229e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
801022a0:	ff 75 e4             	pushl  -0x1c(%ebp)
801022a3:	e8 e8 2a 00 00       	call   80104d90 <memmove>
    name[len] = 0;
801022a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801022ab:	83 c4 10             	add    $0x10,%esp
801022ae:	c6 00 00             	movb   $0x0,(%eax)
801022b1:	e9 68 ff ff ff       	jmp    8010221e <namex+0xae>
801022b6:	8d 76 00             	lea    0x0(%esi),%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801022c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801022c3:	85 c0                	test   %eax,%eax
801022c5:	0f 85 85 00 00 00    	jne    80102350 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
801022cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022ce:	89 f0                	mov    %esi,%eax
801022d0:	5b                   	pop    %ebx
801022d1:	5e                   	pop    %esi
801022d2:	5f                   	pop    %edi
801022d3:	5d                   	pop    %ebp
801022d4:	c3                   	ret    
801022d5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
801022d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801022db:	89 fb                	mov    %edi,%ebx
801022dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801022e0:	31 c0                	xor    %eax,%eax
801022e2:	eb b5                	jmp    80102299 <namex+0x129>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801022e8:	83 ec 0c             	sub    $0xc,%esp
801022eb:	56                   	push   %esi
801022ec:	e8 7f f9 ff ff       	call   80101c70 <iunlock>
  iput(ip);
801022f1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801022f4:	31 f6                	xor    %esi,%esi
  iput(ip);
801022f6:	e8 c5 f9 ff ff       	call   80101cc0 <iput>
      return 0;
801022fb:	83 c4 10             	add    $0x10,%esp
}
801022fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102301:	89 f0                	mov    %esi,%eax
80102303:	5b                   	pop    %ebx
80102304:	5e                   	pop    %esi
80102305:	5f                   	pop    %edi
80102306:	5d                   	pop    %ebp
80102307:	c3                   	ret    
80102308:	90                   	nop
80102309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip = iget(ROOTDEV, ROOTINO);
80102310:	ba 01 00 00 00       	mov    $0x1,%edx
80102315:	b8 01 00 00 00       	mov    $0x1,%eax
8010231a:	89 df                	mov    %ebx,%edi
8010231c:	e8 ef f3 ff ff       	call   80101710 <iget>
80102321:	89 c6                	mov    %eax,%esi
80102323:	e9 9b fe ff ff       	jmp    801021c3 <namex+0x53>
80102328:	90                   	nop
80102329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      iunlock(ip);
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	56                   	push   %esi
80102334:	e8 37 f9 ff ff       	call   80101c70 <iunlock>
      return ip;
80102339:	83 c4 10             	add    $0x10,%esp
}
8010233c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010233f:	89 f0                	mov    %esi,%eax
80102341:	5b                   	pop    %ebx
80102342:	5e                   	pop    %esi
80102343:	5f                   	pop    %edi
80102344:	5d                   	pop    %ebp
80102345:	c3                   	ret    
80102346:	8d 76 00             	lea    0x0(%esi),%esi
80102349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iput(ip);
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	56                   	push   %esi
    return 0;
80102354:	31 f6                	xor    %esi,%esi
    iput(ip);
80102356:	e8 65 f9 ff ff       	call   80101cc0 <iput>
    return 0;
8010235b:	83 c4 10             	add    $0x10,%esp
8010235e:	e9 68 ff ff ff       	jmp    801022cb <namex+0x15b>
80102363:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102370 <dirlink>:
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	57                   	push   %edi
80102374:	56                   	push   %esi
80102375:	53                   	push   %ebx
80102376:	83 ec 20             	sub    $0x20,%esp
80102379:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010237c:	6a 00                	push   $0x0
8010237e:	ff 75 0c             	pushl  0xc(%ebp)
80102381:	53                   	push   %ebx
80102382:	e8 39 fd ff ff       	call   801020c0 <dirlookup>
80102387:	83 c4 10             	add    $0x10,%esp
8010238a:	85 c0                	test   %eax,%eax
8010238c:	75 67                	jne    801023f5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010238e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102391:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102394:	85 ff                	test   %edi,%edi
80102396:	74 29                	je     801023c1 <dirlink+0x51>
80102398:	31 ff                	xor    %edi,%edi
8010239a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010239d:	eb 09                	jmp    801023a8 <dirlink+0x38>
8010239f:	90                   	nop
801023a0:	83 c7 10             	add    $0x10,%edi
801023a3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801023a6:	73 19                	jae    801023c1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023a8:	6a 10                	push   $0x10
801023aa:	57                   	push   %edi
801023ab:	56                   	push   %esi
801023ac:	53                   	push   %ebx
801023ad:	e8 be fa ff ff       	call   80101e70 <readi>
801023b2:	83 c4 10             	add    $0x10,%esp
801023b5:	83 f8 10             	cmp    $0x10,%eax
801023b8:	75 4e                	jne    80102408 <dirlink+0x98>
    if(de.inum == 0)
801023ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801023bf:	75 df                	jne    801023a0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801023c1:	83 ec 04             	sub    $0x4,%esp
801023c4:	8d 45 da             	lea    -0x26(%ebp),%eax
801023c7:	6a 0e                	push   $0xe
801023c9:	ff 75 0c             	pushl  0xc(%ebp)
801023cc:	50                   	push   %eax
801023cd:	e8 8e 2a 00 00       	call   80104e60 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023d2:	6a 10                	push   $0x10
  de.inum = inum;
801023d4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023d7:	57                   	push   %edi
801023d8:	56                   	push   %esi
801023d9:	53                   	push   %ebx
  de.inum = inum;
801023da:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023de:	e8 8d fb ff ff       	call   80101f70 <writei>
801023e3:	83 c4 20             	add    $0x20,%esp
801023e6:	83 f8 10             	cmp    $0x10,%eax
801023e9:	75 2a                	jne    80102415 <dirlink+0xa5>
  return 0;
801023eb:	31 c0                	xor    %eax,%eax
}
801023ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023f0:	5b                   	pop    %ebx
801023f1:	5e                   	pop    %esi
801023f2:	5f                   	pop    %edi
801023f3:	5d                   	pop    %ebp
801023f4:	c3                   	ret    
    iput(ip);
801023f5:	83 ec 0c             	sub    $0xc,%esp
801023f8:	50                   	push   %eax
801023f9:	e8 c2 f8 ff ff       	call   80101cc0 <iput>
    return -1;
801023fe:	83 c4 10             	add    $0x10,%esp
80102401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102406:	eb e5                	jmp    801023ed <dirlink+0x7d>
      panic("dirlink read");
80102408:	83 ec 0c             	sub    $0xc,%esp
8010240b:	68 50 7c 10 80       	push   $0x80107c50
80102410:	e8 cb df ff ff       	call   801003e0 <panic>
    panic("dirlink");
80102415:	83 ec 0c             	sub    $0xc,%esp
80102418:	68 5e 82 10 80       	push   $0x8010825e
8010241d:	e8 be df ff ff       	call   801003e0 <panic>
80102422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <namei>:

struct inode*
namei(char *path)
{
80102430:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102431:	31 d2                	xor    %edx,%edx
{
80102433:	89 e5                	mov    %esp,%ebp
80102435:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102438:	8b 45 08             	mov    0x8(%ebp),%eax
8010243b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010243e:	e8 2d fd ff ff       	call   80102170 <namex>
}
80102443:	c9                   	leave  
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102450:	55                   	push   %ebp
  return namex(path, 1, name);
80102451:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102456:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102458:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010245b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010245e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010245f:	e9 0c fd ff ff       	jmp    80102170 <namex>
80102464:	66 90                	xchg   %ax,%ax
80102466:	66 90                	xchg   %ax,%ax
80102468:	66 90                	xchg   %ax,%ax
8010246a:	66 90                	xchg   %ax,%ax
8010246c:	66 90                	xchg   %ax,%ax
8010246e:	66 90                	xchg   %ax,%ax

80102470 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	57                   	push   %edi
80102474:	56                   	push   %esi
80102475:	53                   	push   %ebx
80102476:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102479:	85 c0                	test   %eax,%eax
8010247b:	0f 84 b4 00 00 00    	je     80102535 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102481:	8b 70 08             	mov    0x8(%eax),%esi
80102484:	89 c3                	mov    %eax,%ebx
80102486:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010248c:	0f 87 96 00 00 00    	ja     80102528 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102492:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102497:	89 f6                	mov    %esi,%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801024a0:	89 ca                	mov    %ecx,%edx
801024a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024a3:	83 e0 c0             	and    $0xffffffc0,%eax
801024a6:	3c 40                	cmp    $0x40,%al
801024a8:	75 f6                	jne    801024a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024aa:	31 ff                	xor    %edi,%edi
801024ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801024b1:	89 f8                	mov    %edi,%eax
801024b3:	ee                   	out    %al,(%dx)
801024b4:	b8 01 00 00 00       	mov    $0x1,%eax
801024b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801024be:	ee                   	out    %al,(%dx)
801024bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801024c4:	89 f0                	mov    %esi,%eax
801024c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801024c7:	89 f0                	mov    %esi,%eax
801024c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801024ce:	c1 f8 08             	sar    $0x8,%eax
801024d1:	ee                   	out    %al,(%dx)
801024d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801024d7:	89 f8                	mov    %edi,%eax
801024d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801024da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801024de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024e3:	c1 e0 04             	shl    $0x4,%eax
801024e6:	83 e0 10             	and    $0x10,%eax
801024e9:	83 c8 e0             	or     $0xffffffe0,%eax
801024ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801024ed:	f6 03 04             	testb  $0x4,(%ebx)
801024f0:	75 16                	jne    80102508 <idestart+0x98>
801024f2:	b8 20 00 00 00       	mov    $0x20,%eax
801024f7:	89 ca                	mov    %ecx,%edx
801024f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801024fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024fd:	5b                   	pop    %ebx
801024fe:	5e                   	pop    %esi
801024ff:	5f                   	pop    %edi
80102500:	5d                   	pop    %ebp
80102501:	c3                   	ret    
80102502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102508:	b8 30 00 00 00       	mov    $0x30,%eax
8010250d:	89 ca                	mov    %ecx,%edx
8010250f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102510:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102515:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102518:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010251d:	fc                   	cld    
8010251e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102520:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102523:	5b                   	pop    %ebx
80102524:	5e                   	pop    %esi
80102525:	5f                   	pop    %edi
80102526:	5d                   	pop    %ebp
80102527:	c3                   	ret    
    panic("incorrect blockno");
80102528:	83 ec 0c             	sub    $0xc,%esp
8010252b:	68 bc 7c 10 80       	push   $0x80107cbc
80102530:	e8 ab de ff ff       	call   801003e0 <panic>
    panic("idestart");
80102535:	83 ec 0c             	sub    $0xc,%esp
80102538:	68 b3 7c 10 80       	push   $0x80107cb3
8010253d:	e8 9e de ff ff       	call   801003e0 <panic>
80102542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102550 <ideinit>:
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102556:	68 ce 7c 10 80       	push   $0x80107cce
8010255b:	68 a0 b5 10 80       	push   $0x8010b5a0
80102560:	e8 1b 25 00 00       	call   80104a80 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102565:	58                   	pop    %eax
80102566:	a1 e0 3d 11 80       	mov    0x80113de0,%eax
8010256b:	5a                   	pop    %edx
8010256c:	83 e8 01             	sub    $0x1,%eax
8010256f:	50                   	push   %eax
80102570:	6a 0e                	push   $0xe
80102572:	e8 a9 02 00 00       	call   80102820 <ioapicenable>
80102577:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010257a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010257f:	90                   	nop
80102580:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102581:	83 e0 c0             	and    $0xffffffc0,%eax
80102584:	3c 40                	cmp    $0x40,%al
80102586:	75 f8                	jne    80102580 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102588:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010258d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102592:	ee                   	out    %al,(%dx)
80102593:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102598:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010259d:	eb 06                	jmp    801025a5 <ideinit+0x55>
8010259f:	90                   	nop
  for(i=0; i<1000; i++){
801025a0:	83 e9 01             	sub    $0x1,%ecx
801025a3:	74 0f                	je     801025b4 <ideinit+0x64>
801025a5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801025a6:	84 c0                	test   %al,%al
801025a8:	74 f6                	je     801025a0 <ideinit+0x50>
      havedisk1 = 1;
801025aa:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
801025b1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025b4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801025b9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025be:	ee                   	out    %al,(%dx)
}
801025bf:	c9                   	leave  
801025c0:	c3                   	ret    
801025c1:	eb 0d                	jmp    801025d0 <ideintr>
801025c3:	90                   	nop
801025c4:	90                   	nop
801025c5:	90                   	nop
801025c6:	90                   	nop
801025c7:	90                   	nop
801025c8:	90                   	nop
801025c9:	90                   	nop
801025ca:	90                   	nop
801025cb:	90                   	nop
801025cc:	90                   	nop
801025cd:	90                   	nop
801025ce:	90                   	nop
801025cf:	90                   	nop

801025d0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	57                   	push   %edi
801025d4:	56                   	push   %esi
801025d5:	53                   	push   %ebx
801025d6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801025d9:	68 a0 b5 10 80       	push   $0x8010b5a0
801025de:	e8 9d 25 00 00       	call   80104b80 <acquire>

  if((b = idequeue) == 0){
801025e3:	8b 1d 84 b5 10 80    	mov    0x8010b584,%ebx
801025e9:	83 c4 10             	add    $0x10,%esp
801025ec:	85 db                	test   %ebx,%ebx
801025ee:	74 63                	je     80102653 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801025f0:	8b 43 58             	mov    0x58(%ebx),%eax
801025f3:	a3 84 b5 10 80       	mov    %eax,0x8010b584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801025f8:	8b 33                	mov    (%ebx),%esi
801025fa:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102600:	75 2f                	jne    80102631 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102602:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102607:	89 f6                	mov    %esi,%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102610:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102611:	89 c1                	mov    %eax,%ecx
80102613:	83 e1 c0             	and    $0xffffffc0,%ecx
80102616:	80 f9 40             	cmp    $0x40,%cl
80102619:	75 f5                	jne    80102610 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010261b:	a8 21                	test   $0x21,%al
8010261d:	75 12                	jne    80102631 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010261f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102622:	b9 80 00 00 00       	mov    $0x80,%ecx
80102627:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010262c:	fc                   	cld    
8010262d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010262f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102631:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102634:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102637:	83 ce 02             	or     $0x2,%esi
8010263a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010263c:	53                   	push   %ebx
8010263d:	e8 be 21 00 00       	call   80104800 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102642:	a1 84 b5 10 80       	mov    0x8010b584,%eax
80102647:	83 c4 10             	add    $0x10,%esp
8010264a:	85 c0                	test   %eax,%eax
8010264c:	74 05                	je     80102653 <ideintr+0x83>
    idestart(idequeue);
8010264e:	e8 1d fe ff ff       	call   80102470 <idestart>
    release(&idelock);
80102653:	83 ec 0c             	sub    $0xc,%esp
80102656:	68 a0 b5 10 80       	push   $0x8010b5a0
8010265b:	e8 40 26 00 00       	call   80104ca0 <release>

  release(&idelock);
}
80102660:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102663:	5b                   	pop    %ebx
80102664:	5e                   	pop    %esi
80102665:	5f                   	pop    %edi
80102666:	5d                   	pop    %ebp
80102667:	c3                   	ret    
80102668:	90                   	nop
80102669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102670 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	53                   	push   %ebx
80102674:	83 ec 10             	sub    $0x10,%esp
80102677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010267a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010267d:	50                   	push   %eax
8010267e:	e8 cd 23 00 00       	call   80104a50 <holdingsleep>
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	85 c0                	test   %eax,%eax
80102688:	0f 84 d3 00 00 00    	je     80102761 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010268e:	8b 03                	mov    (%ebx),%eax
80102690:	83 e0 06             	and    $0x6,%eax
80102693:	83 f8 02             	cmp    $0x2,%eax
80102696:	0f 84 b8 00 00 00    	je     80102754 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010269c:	8b 53 04             	mov    0x4(%ebx),%edx
8010269f:	85 d2                	test   %edx,%edx
801026a1:	74 0d                	je     801026b0 <iderw+0x40>
801026a3:	a1 80 b5 10 80       	mov    0x8010b580,%eax
801026a8:	85 c0                	test   %eax,%eax
801026aa:	0f 84 97 00 00 00    	je     80102747 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	68 a0 b5 10 80       	push   $0x8010b5a0
801026b8:	e8 c3 24 00 00       	call   80104b80 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026bd:	8b 15 84 b5 10 80    	mov    0x8010b584,%edx
  b->qnext = 0;
801026c3:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026ca:	83 c4 10             	add    $0x10,%esp
801026cd:	85 d2                	test   %edx,%edx
801026cf:	75 09                	jne    801026da <iderw+0x6a>
801026d1:	eb 6d                	jmp    80102740 <iderw+0xd0>
801026d3:	90                   	nop
801026d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026d8:	89 c2                	mov    %eax,%edx
801026da:	8b 42 58             	mov    0x58(%edx),%eax
801026dd:	85 c0                	test   %eax,%eax
801026df:	75 f7                	jne    801026d8 <iderw+0x68>
801026e1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801026e4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801026e6:	39 1d 84 b5 10 80    	cmp    %ebx,0x8010b584
801026ec:	74 42                	je     80102730 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026ee:	8b 03                	mov    (%ebx),%eax
801026f0:	83 e0 06             	and    $0x6,%eax
801026f3:	83 f8 02             	cmp    $0x2,%eax
801026f6:	74 23                	je     8010271b <iderw+0xab>
801026f8:	90                   	nop
801026f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102700:	83 ec 08             	sub    $0x8,%esp
80102703:	68 a0 b5 10 80       	push   $0x8010b5a0
80102708:	53                   	push   %ebx
80102709:	e8 32 1f 00 00       	call   80104640 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010270e:	8b 03                	mov    (%ebx),%eax
80102710:	83 c4 10             	add    $0x10,%esp
80102713:	83 e0 06             	and    $0x6,%eax
80102716:	83 f8 02             	cmp    $0x2,%eax
80102719:	75 e5                	jne    80102700 <iderw+0x90>
  }


  release(&idelock);
8010271b:	c7 45 08 a0 b5 10 80 	movl   $0x8010b5a0,0x8(%ebp)
}
80102722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102725:	c9                   	leave  
  release(&idelock);
80102726:	e9 75 25 00 00       	jmp    80104ca0 <release>
8010272b:	90                   	nop
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102730:	89 d8                	mov    %ebx,%eax
80102732:	e8 39 fd ff ff       	call   80102470 <idestart>
80102737:	eb b5                	jmp    801026ee <iderw+0x7e>
80102739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102740:	ba 84 b5 10 80       	mov    $0x8010b584,%edx
80102745:	eb 9d                	jmp    801026e4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102747:	83 ec 0c             	sub    $0xc,%esp
8010274a:	68 fd 7c 10 80       	push   $0x80107cfd
8010274f:	e8 8c dc ff ff       	call   801003e0 <panic>
    panic("iderw: nothing to do");
80102754:	83 ec 0c             	sub    $0xc,%esp
80102757:	68 e8 7c 10 80       	push   $0x80107ce8
8010275c:	e8 7f dc ff ff       	call   801003e0 <panic>
    panic("iderw: buf not locked");
80102761:	83 ec 0c             	sub    $0xc,%esp
80102764:	68 d2 7c 10 80       	push   $0x80107cd2
80102769:	e8 72 dc ff ff       	call   801003e0 <panic>
8010276e:	66 90                	xchg   %ax,%ax

80102770 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102770:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102771:	c7 05 d4 36 11 80 00 	movl   $0xfec00000,0x801136d4
80102778:	00 c0 fe 
{
8010277b:	89 e5                	mov    %esp,%ebp
8010277d:	56                   	push   %esi
8010277e:	53                   	push   %ebx
  ioapic->reg = reg;
8010277f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102786:	00 00 00 
  return ioapic->data;
80102789:	8b 15 d4 36 11 80    	mov    0x801136d4,%edx
8010278f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102792:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102798:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010279e:	0f b6 15 00 38 11 80 	movzbl 0x80113800,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801027a5:	c1 ee 10             	shr    $0x10,%esi
801027a8:	89 f0                	mov    %esi,%eax
801027aa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801027ad:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801027b0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801027b3:	39 c2                	cmp    %eax,%edx
801027b5:	74 16                	je     801027cd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801027b7:	83 ec 0c             	sub    $0xc,%esp
801027ba:	68 1c 7d 10 80       	push   $0x80107d1c
801027bf:	e8 2c df ff ff       	call   801006f0 <cprintf>
801027c4:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
801027ca:	83 c4 10             	add    $0x10,%esp
801027cd:	83 c6 21             	add    $0x21,%esi
{
801027d0:	ba 10 00 00 00       	mov    $0x10,%edx
801027d5:	b8 20 00 00 00       	mov    $0x20,%eax
801027da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801027e0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801027e2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801027e4:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
801027ea:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801027ed:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801027f3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801027f6:	8d 5a 01             	lea    0x1(%edx),%ebx
801027f9:	83 c2 02             	add    $0x2,%edx
801027fc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801027fe:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
80102804:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010280b:	39 f0                	cmp    %esi,%eax
8010280d:	75 d1                	jne    801027e0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010280f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102812:	5b                   	pop    %ebx
80102813:	5e                   	pop    %esi
80102814:	5d                   	pop    %ebp
80102815:	c3                   	ret    
80102816:	8d 76 00             	lea    0x0(%esi),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102820:	55                   	push   %ebp
  ioapic->reg = reg;
80102821:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
{
80102827:	89 e5                	mov    %esp,%ebp
80102829:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010282c:	8d 50 20             	lea    0x20(%eax),%edx
8010282f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102833:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102835:	8b 0d d4 36 11 80    	mov    0x801136d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010283b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010283e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102841:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102844:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102846:	a1 d4 36 11 80       	mov    0x801136d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010284b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010284e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102851:	5d                   	pop    %ebp
80102852:	c3                   	ret    
80102853:	66 90                	xchg   %ax,%ax
80102855:	66 90                	xchg   %ax,%ax
80102857:	66 90                	xchg   %ax,%ax
80102859:	66 90                	xchg   %ax,%ax
8010285b:	66 90                	xchg   %ax,%ax
8010285d:	66 90                	xchg   %ax,%ax
8010285f:	90                   	nop

80102860 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	53                   	push   %ebx
80102864:	83 ec 04             	sub    $0x4,%esp
80102867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010286a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102870:	75 76                	jne    801028e8 <kfree+0x88>
80102872:	81 fb a8 6c 11 80    	cmp    $0x80116ca8,%ebx
80102878:	72 6e                	jb     801028e8 <kfree+0x88>
8010287a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102880:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102885:	77 61                	ja     801028e8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102887:	83 ec 04             	sub    $0x4,%esp
8010288a:	68 00 10 00 00       	push   $0x1000
8010288f:	6a 01                	push   $0x1
80102891:	53                   	push   %ebx
80102892:	e8 59 24 00 00       	call   80104cf0 <memset>

  if(kmem.use_lock)
80102897:	8b 15 14 37 11 80    	mov    0x80113714,%edx
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	85 d2                	test   %edx,%edx
801028a2:	75 1c                	jne    801028c0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801028a4:	a1 18 37 11 80       	mov    0x80113718,%eax
801028a9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801028ab:	a1 14 37 11 80       	mov    0x80113714,%eax
  kmem.freelist = r;
801028b0:	89 1d 18 37 11 80    	mov    %ebx,0x80113718
  if(kmem.use_lock)
801028b6:	85 c0                	test   %eax,%eax
801028b8:	75 1e                	jne    801028d8 <kfree+0x78>
    release(&kmem.lock);
}
801028ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028bd:	c9                   	leave  
801028be:	c3                   	ret    
801028bf:	90                   	nop
    acquire(&kmem.lock);
801028c0:	83 ec 0c             	sub    $0xc,%esp
801028c3:	68 e0 36 11 80       	push   $0x801136e0
801028c8:	e8 b3 22 00 00       	call   80104b80 <acquire>
801028cd:	83 c4 10             	add    $0x10,%esp
801028d0:	eb d2                	jmp    801028a4 <kfree+0x44>
801028d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801028d8:	c7 45 08 e0 36 11 80 	movl   $0x801136e0,0x8(%ebp)
}
801028df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028e2:	c9                   	leave  
    release(&kmem.lock);
801028e3:	e9 b8 23 00 00       	jmp    80104ca0 <release>
    panic("kfree");
801028e8:	83 ec 0c             	sub    $0xc,%esp
801028eb:	68 4e 7d 10 80       	push   $0x80107d4e
801028f0:	e8 eb da ff ff       	call   801003e0 <panic>
801028f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102900 <freerange>:
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102904:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102907:	8b 75 0c             	mov    0xc(%ebp),%esi
8010290a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010290b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102911:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102917:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010291d:	39 de                	cmp    %ebx,%esi
8010291f:	72 23                	jb     80102944 <freerange+0x44>
80102921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102928:	83 ec 0c             	sub    $0xc,%esp
8010292b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102931:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102937:	50                   	push   %eax
80102938:	e8 23 ff ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010293d:	83 c4 10             	add    $0x10,%esp
80102940:	39 f3                	cmp    %esi,%ebx
80102942:	76 e4                	jbe    80102928 <freerange+0x28>
}
80102944:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102947:	5b                   	pop    %ebx
80102948:	5e                   	pop    %esi
80102949:	5d                   	pop    %ebp
8010294a:	c3                   	ret    
8010294b:	90                   	nop
8010294c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102950 <kinit1>:
{
80102950:	55                   	push   %ebp
80102951:	89 e5                	mov    %esp,%ebp
80102953:	56                   	push   %esi
80102954:	53                   	push   %ebx
80102955:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102958:	83 ec 08             	sub    $0x8,%esp
8010295b:	68 54 7d 10 80       	push   $0x80107d54
80102960:	68 e0 36 11 80       	push   $0x801136e0
80102965:	e8 16 21 00 00       	call   80104a80 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010296a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010296d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102970:	c7 05 14 37 11 80 00 	movl   $0x0,0x80113714
80102977:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010297a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102980:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102986:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010298c:	39 de                	cmp    %ebx,%esi
8010298e:	72 1c                	jb     801029ac <kinit1+0x5c>
    kfree(p);
80102990:	83 ec 0c             	sub    $0xc,%esp
80102993:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102999:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010299f:	50                   	push   %eax
801029a0:	e8 bb fe ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029a5:	83 c4 10             	add    $0x10,%esp
801029a8:	39 de                	cmp    %ebx,%esi
801029aa:	73 e4                	jae    80102990 <kinit1+0x40>
}
801029ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029af:	5b                   	pop    %ebx
801029b0:	5e                   	pop    %esi
801029b1:	5d                   	pop    %ebp
801029b2:	c3                   	ret    
801029b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029c0 <kinit2>:
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
801029df:	72 23                	jb     80102a04 <kinit2+0x44>
801029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801029e8:	83 ec 0c             	sub    $0xc,%esp
801029eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801029f7:	50                   	push   %eax
801029f8:	e8 63 fe ff ff       	call   80102860 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029fd:	83 c4 10             	add    $0x10,%esp
80102a00:	39 de                	cmp    %ebx,%esi
80102a02:	73 e4                	jae    801029e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102a04:	c7 05 14 37 11 80 01 	movl   $0x1,0x80113714
80102a0b:	00 00 00 
}
80102a0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a11:	5b                   	pop    %ebx
80102a12:	5e                   	pop    %esi
80102a13:	5d                   	pop    %ebp
80102a14:	c3                   	ret    
80102a15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	53                   	push   %ebx
80102a24:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102a27:	a1 14 37 11 80       	mov    0x80113714,%eax
80102a2c:	85 c0                	test   %eax,%eax
80102a2e:	75 20                	jne    80102a50 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102a30:	8b 1d 18 37 11 80    	mov    0x80113718,%ebx
  if(r)
80102a36:	85 db                	test   %ebx,%ebx
80102a38:	74 07                	je     80102a41 <kalloc+0x21>
    kmem.freelist = r->next;
80102a3a:	8b 03                	mov    (%ebx),%eax
80102a3c:	a3 18 37 11 80       	mov    %eax,0x80113718
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102a41:	89 d8                	mov    %ebx,%eax
80102a43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a46:	c9                   	leave  
80102a47:	c3                   	ret    
80102a48:	90                   	nop
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102a50:	83 ec 0c             	sub    $0xc,%esp
80102a53:	68 e0 36 11 80       	push   $0x801136e0
80102a58:	e8 23 21 00 00       	call   80104b80 <acquire>
  r = kmem.freelist;
80102a5d:	8b 1d 18 37 11 80    	mov    0x80113718,%ebx
  if(r)
80102a63:	83 c4 10             	add    $0x10,%esp
80102a66:	a1 14 37 11 80       	mov    0x80113714,%eax
80102a6b:	85 db                	test   %ebx,%ebx
80102a6d:	74 08                	je     80102a77 <kalloc+0x57>
    kmem.freelist = r->next;
80102a6f:	8b 13                	mov    (%ebx),%edx
80102a71:	89 15 18 37 11 80    	mov    %edx,0x80113718
  if(kmem.use_lock)
80102a77:	85 c0                	test   %eax,%eax
80102a79:	74 c6                	je     80102a41 <kalloc+0x21>
    release(&kmem.lock);
80102a7b:	83 ec 0c             	sub    $0xc,%esp
80102a7e:	68 e0 36 11 80       	push   $0x801136e0
80102a83:	e8 18 22 00 00       	call   80104ca0 <release>
}
80102a88:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
80102a8a:	83 c4 10             	add    $0x10,%esp
}
80102a8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a90:	c9                   	leave  
80102a91:	c3                   	ret    
80102a92:	66 90                	xchg   %ax,%ax
80102a94:	66 90                	xchg   %ax,%ax
80102a96:	66 90                	xchg   %ax,%ax
80102a98:	66 90                	xchg   %ax,%ax
80102a9a:	66 90                	xchg   %ax,%ax
80102a9c:	66 90                	xchg   %ax,%ax
80102a9e:	66 90                	xchg   %ax,%ax

80102aa0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa0:	ba 64 00 00 00       	mov    $0x64,%edx
80102aa5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102aa6:	a8 01                	test   $0x1,%al
80102aa8:	0f 84 c2 00 00 00    	je     80102b70 <kbdgetc+0xd0>
{
80102aae:	55                   	push   %ebp
80102aaf:	ba 60 00 00 00       	mov    $0x60,%edx
80102ab4:	89 e5                	mov    %esp,%ebp
80102ab6:	53                   	push   %ebx
80102ab7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102ab8:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102abb:	8b 1d d4 b5 10 80    	mov    0x8010b5d4,%ebx
80102ac1:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102ac7:	74 57                	je     80102b20 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102ac9:	89 d9                	mov    %ebx,%ecx
80102acb:	83 e1 40             	and    $0x40,%ecx
80102ace:	84 c0                	test   %al,%al
80102ad0:	78 5e                	js     80102b30 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102ad2:	85 c9                	test   %ecx,%ecx
80102ad4:	74 09                	je     80102adf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ad6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102ad9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102adc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102adf:	0f b6 8a 80 7e 10 80 	movzbl -0x7fef8180(%edx),%ecx
  shift ^= togglecode[data];
80102ae6:	0f b6 82 80 7d 10 80 	movzbl -0x7fef8280(%edx),%eax
  shift |= shiftcode[data];
80102aed:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102aef:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102af1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102af3:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102af9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102afc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102aff:	8b 04 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%eax
80102b06:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102b0a:	74 0b                	je     80102b17 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102b0c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102b0f:	83 fa 19             	cmp    $0x19,%edx
80102b12:	77 44                	ja     80102b58 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102b14:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102b17:	5b                   	pop    %ebx
80102b18:	5d                   	pop    %ebp
80102b19:	c3                   	ret    
80102b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102b20:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102b23:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102b25:	89 1d d4 b5 10 80    	mov    %ebx,0x8010b5d4
}
80102b2b:	5b                   	pop    %ebx
80102b2c:	5d                   	pop    %ebp
80102b2d:	c3                   	ret    
80102b2e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102b30:	83 e0 7f             	and    $0x7f,%eax
80102b33:	85 c9                	test   %ecx,%ecx
80102b35:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102b38:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102b3a:	0f b6 8a 80 7e 10 80 	movzbl -0x7fef8180(%edx),%ecx
80102b41:	83 c9 40             	or     $0x40,%ecx
80102b44:	0f b6 c9             	movzbl %cl,%ecx
80102b47:	f7 d1                	not    %ecx
80102b49:	21 d9                	and    %ebx,%ecx
}
80102b4b:	5b                   	pop    %ebx
80102b4c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102b4d:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
}
80102b53:	c3                   	ret    
80102b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102b58:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102b5b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102b5e:	5b                   	pop    %ebx
80102b5f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102b60:	83 f9 1a             	cmp    $0x1a,%ecx
80102b63:	0f 42 c2             	cmovb  %edx,%eax
}
80102b66:	c3                   	ret    
80102b67:	89 f6                	mov    %esi,%esi
80102b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b75:	c3                   	ret    
80102b76:	8d 76 00             	lea    0x0(%esi),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <kbdintr>:

void
kbdintr(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b86:	68 a0 2a 10 80       	push   $0x80102aa0
80102b8b:	e8 30 e1 ff ff       	call   80100cc0 <consoleintr>
}
80102b90:	83 c4 10             	add    $0x10,%esp
80102b93:	c9                   	leave  
80102b94:	c3                   	ret    
80102b95:	66 90                	xchg   %ax,%ax
80102b97:	66 90                	xchg   %ax,%ax
80102b99:	66 90                	xchg   %ax,%ax
80102b9b:	66 90                	xchg   %ax,%ax
80102b9d:	66 90                	xchg   %ax,%ax
80102b9f:	90                   	nop

80102ba0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102ba0:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102ba5:	85 c0                	test   %eax,%eax
80102ba7:	0f 84 cb 00 00 00    	je     80102c78 <lapicinit+0xd8>
  lapic[index] = value;
80102bad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102bb4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102bc1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bc7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102bce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bd4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102bdb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102bde:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102be1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102be8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102beb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102bf5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bf8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102bfb:	8b 50 30             	mov    0x30(%eax),%edx
80102bfe:	c1 ea 10             	shr    $0x10,%edx
80102c01:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102c07:	75 77                	jne    80102c80 <lapicinit+0xe0>
  lapic[index] = value;
80102c09:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102c10:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c13:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c16:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c1d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c20:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c23:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102c2a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c2d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c30:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c37:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c3a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c3d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102c44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c4a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102c51:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102c54:	8b 50 20             	mov    0x20(%eax),%edx
80102c57:	89 f6                	mov    %esi,%esi
80102c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102c60:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102c66:	80 e6 10             	and    $0x10,%dh
80102c69:	75 f5                	jne    80102c60 <lapicinit+0xc0>
  lapic[index] = value;
80102c6b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102c72:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c75:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102c78:	c3                   	ret    
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102c80:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c87:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c8a:	8b 50 20             	mov    0x20(%eax),%edx
80102c8d:	e9 77 ff ff ff       	jmp    80102c09 <lapicinit+0x69>
80102c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ca0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ca0:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	74 07                	je     80102cb0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102ca9:	8b 40 20             	mov    0x20(%eax),%eax
80102cac:	c1 e8 18             	shr    $0x18,%eax
80102caf:	c3                   	ret    
    return 0;
80102cb0:	31 c0                	xor    %eax,%eax
}
80102cb2:	c3                   	ret    
80102cb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cc0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102cc0:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102cc5:	85 c0                	test   %eax,%eax
80102cc7:	74 0d                	je     80102cd6 <lapiceoi+0x16>
  lapic[index] = value;
80102cc9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cd0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102cd6:	c3                   	ret    
80102cd7:	89 f6                	mov    %esi,%esi
80102cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ce0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102ce0:	c3                   	ret    
80102ce1:	eb 0d                	jmp    80102cf0 <lapicstartap>
80102ce3:	90                   	nop
80102ce4:	90                   	nop
80102ce5:	90                   	nop
80102ce6:	90                   	nop
80102ce7:	90                   	nop
80102ce8:	90                   	nop
80102ce9:	90                   	nop
80102cea:	90                   	nop
80102ceb:	90                   	nop
80102cec:	90                   	nop
80102ced:	90                   	nop
80102cee:	90                   	nop
80102cef:	90                   	nop

80102cf0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102cf0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102cf6:	ba 70 00 00 00       	mov    $0x70,%edx
80102cfb:	89 e5                	mov    %esp,%ebp
80102cfd:	53                   	push   %ebx
80102cfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102d01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d04:	ee                   	out    %al,(%dx)
80102d05:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d0a:	ba 71 00 00 00       	mov    $0x71,%edx
80102d0f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102d10:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102d12:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102d15:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102d1b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d1d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102d20:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102d22:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102d25:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102d28:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102d2e:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102d33:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d39:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d3c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102d43:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d46:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d49:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102d50:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d53:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d56:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d5c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d5f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d65:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d68:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d71:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102d77:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102d78:	8b 40 20             	mov    0x20(%eax),%eax
}
80102d7b:	5d                   	pop    %ebp
80102d7c:	c3                   	ret    
80102d7d:	8d 76 00             	lea    0x0(%esi),%esi

80102d80 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102d80:	55                   	push   %ebp
80102d81:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d86:	ba 70 00 00 00       	mov    $0x70,%edx
80102d8b:	89 e5                	mov    %esp,%ebp
80102d8d:	57                   	push   %edi
80102d8e:	56                   	push   %esi
80102d8f:	53                   	push   %ebx
80102d90:	83 ec 4c             	sub    $0x4c,%esp
80102d93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d94:	ba 71 00 00 00       	mov    $0x71,%edx
80102d99:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102d9a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d9d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102da2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102da5:	8d 76 00             	lea    0x0(%esi),%esi
80102da8:	31 c0                	xor    %eax,%eax
80102daa:	89 da                	mov    %ebx,%edx
80102dac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dad:	b9 71 00 00 00       	mov    $0x71,%ecx
80102db2:	89 ca                	mov    %ecx,%edx
80102db4:	ec                   	in     (%dx),%al
80102db5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db8:	89 da                	mov    %ebx,%edx
80102dba:	b8 02 00 00 00       	mov    $0x2,%eax
80102dbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dc0:	89 ca                	mov    %ecx,%edx
80102dc2:	ec                   	in     (%dx),%al
80102dc3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc6:	89 da                	mov    %ebx,%edx
80102dc8:	b8 04 00 00 00       	mov    $0x4,%eax
80102dcd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dce:	89 ca                	mov    %ecx,%edx
80102dd0:	ec                   	in     (%dx),%al
80102dd1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd4:	89 da                	mov    %ebx,%edx
80102dd6:	b8 07 00 00 00       	mov    $0x7,%eax
80102ddb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ddc:	89 ca                	mov    %ecx,%edx
80102dde:	ec                   	in     (%dx),%al
80102ddf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102de2:	89 da                	mov    %ebx,%edx
80102de4:	b8 08 00 00 00       	mov    $0x8,%eax
80102de9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dea:	89 ca                	mov    %ecx,%edx
80102dec:	ec                   	in     (%dx),%al
80102ded:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102def:	89 da                	mov    %ebx,%edx
80102df1:	b8 09 00 00 00       	mov    $0x9,%eax
80102df6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102df7:	89 ca                	mov    %ecx,%edx
80102df9:	ec                   	in     (%dx),%al
80102dfa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dfc:	89 da                	mov    %ebx,%edx
80102dfe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e04:	89 ca                	mov    %ecx,%edx
80102e06:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102e07:	84 c0                	test   %al,%al
80102e09:	78 9d                	js     80102da8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102e0b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102e0f:	89 fa                	mov    %edi,%edx
80102e11:	0f b6 fa             	movzbl %dl,%edi
80102e14:	89 f2                	mov    %esi,%edx
80102e16:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102e19:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102e1d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e20:	89 da                	mov    %ebx,%edx
80102e22:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102e25:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102e28:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102e2c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102e2f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102e32:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102e36:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102e39:	31 c0                	xor    %eax,%eax
80102e3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e3c:	89 ca                	mov    %ecx,%edx
80102e3e:	ec                   	in     (%dx),%al
80102e3f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e42:	89 da                	mov    %ebx,%edx
80102e44:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102e47:	b8 02 00 00 00       	mov    $0x2,%eax
80102e4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e4d:	89 ca                	mov    %ecx,%edx
80102e4f:	ec                   	in     (%dx),%al
80102e50:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e53:	89 da                	mov    %ebx,%edx
80102e55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102e58:	b8 04 00 00 00       	mov    $0x4,%eax
80102e5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e5e:	89 ca                	mov    %ecx,%edx
80102e60:	ec                   	in     (%dx),%al
80102e61:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e64:	89 da                	mov    %ebx,%edx
80102e66:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102e69:	b8 07 00 00 00       	mov    $0x7,%eax
80102e6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e6f:	89 ca                	mov    %ecx,%edx
80102e71:	ec                   	in     (%dx),%al
80102e72:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e75:	89 da                	mov    %ebx,%edx
80102e77:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e7a:	b8 08 00 00 00       	mov    $0x8,%eax
80102e7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e80:	89 ca                	mov    %ecx,%edx
80102e82:	ec                   	in     (%dx),%al
80102e83:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e86:	89 da                	mov    %ebx,%edx
80102e88:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e8b:	b8 09 00 00 00       	mov    $0x9,%eax
80102e90:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e91:	89 ca                	mov    %ecx,%edx
80102e93:	ec                   	in     (%dx),%al
80102e94:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e97:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e9d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ea0:	6a 18                	push   $0x18
80102ea2:	50                   	push   %eax
80102ea3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ea6:	50                   	push   %eax
80102ea7:	e8 94 1e 00 00       	call   80104d40 <memcmp>
80102eac:	83 c4 10             	add    $0x10,%esp
80102eaf:	85 c0                	test   %eax,%eax
80102eb1:	0f 85 f1 fe ff ff    	jne    80102da8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102eb7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ebb:	75 78                	jne    80102f35 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ebd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ec0:	89 c2                	mov    %eax,%edx
80102ec2:	83 e0 0f             	and    $0xf,%eax
80102ec5:	c1 ea 04             	shr    $0x4,%edx
80102ec8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ecb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ece:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ed1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ed4:	89 c2                	mov    %eax,%edx
80102ed6:	83 e0 0f             	and    $0xf,%eax
80102ed9:	c1 ea 04             	shr    $0x4,%edx
80102edc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102edf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ee2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ee5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ee8:	89 c2                	mov    %eax,%edx
80102eea:	83 e0 0f             	and    $0xf,%eax
80102eed:	c1 ea 04             	shr    $0x4,%edx
80102ef0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ef3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ef6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ef9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102efc:	89 c2                	mov    %eax,%edx
80102efe:	83 e0 0f             	and    $0xf,%eax
80102f01:	c1 ea 04             	shr    $0x4,%edx
80102f04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102f0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102f10:	89 c2                	mov    %eax,%edx
80102f12:	83 e0 0f             	and    $0xf,%eax
80102f15:	c1 ea 04             	shr    $0x4,%edx
80102f18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f1e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102f21:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f24:	89 c2                	mov    %eax,%edx
80102f26:	83 e0 0f             	and    $0xf,%eax
80102f29:	c1 ea 04             	shr    $0x4,%edx
80102f2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f32:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102f35:	8b 75 08             	mov    0x8(%ebp),%esi
80102f38:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f3b:	89 06                	mov    %eax,(%esi)
80102f3d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f40:	89 46 04             	mov    %eax,0x4(%esi)
80102f43:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102f46:	89 46 08             	mov    %eax,0x8(%esi)
80102f49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102f4c:	89 46 0c             	mov    %eax,0xc(%esi)
80102f4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102f52:	89 46 10             	mov    %eax,0x10(%esi)
80102f55:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102f58:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102f5b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f65:	5b                   	pop    %ebx
80102f66:	5e                   	pop    %esi
80102f67:	5f                   	pop    %edi
80102f68:	5d                   	pop    %ebp
80102f69:	c3                   	ret    
80102f6a:	66 90                	xchg   %ax,%ax
80102f6c:	66 90                	xchg   %ax,%ax
80102f6e:	66 90                	xchg   %ax,%ax

80102f70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f70:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
80102f76:	85 c9                	test   %ecx,%ecx
80102f78:	0f 8e 8a 00 00 00    	jle    80103008 <install_trans+0x98>
{
80102f7e:	55                   	push   %ebp
80102f7f:	89 e5                	mov    %esp,%ebp
80102f81:	57                   	push   %edi
80102f82:	56                   	push   %esi
80102f83:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102f84:	31 db                	xor    %ebx,%ebx
{
80102f86:	83 ec 0c             	sub    $0xc,%esp
80102f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f90:	a1 54 37 11 80       	mov    0x80113754,%eax
80102f95:	83 ec 08             	sub    $0x8,%esp
80102f98:	01 d8                	add    %ebx,%eax
80102f9a:	83 c0 01             	add    $0x1,%eax
80102f9d:	50                   	push   %eax
80102f9e:	ff 35 64 37 11 80    	pushl  0x80113764
80102fa4:	e8 27 d1 ff ff       	call   801000d0 <bread>
80102fa9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102fab:	58                   	pop    %eax
80102fac:	5a                   	pop    %edx
80102fad:	ff 34 9d 6c 37 11 80 	pushl  -0x7feec894(,%ebx,4)
80102fb4:	ff 35 64 37 11 80    	pushl  0x80113764
  for (tail = 0; tail < log.lh.n; tail++) {
80102fba:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102fbd:	e8 0e d1 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102fc2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102fc5:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102fc7:	8d 47 5c             	lea    0x5c(%edi),%eax
80102fca:	68 00 02 00 00       	push   $0x200
80102fcf:	50                   	push   %eax
80102fd0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fd3:	50                   	push   %eax
80102fd4:	e8 b7 1d 00 00       	call   80104d90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102fd9:	89 34 24             	mov    %esi,(%esp)
80102fdc:	e8 cf d1 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102fe1:	89 3c 24             	mov    %edi,(%esp)
80102fe4:	e8 07 d2 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102fe9:	89 34 24             	mov    %esi,(%esp)
80102fec:	e8 ff d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ff1:	83 c4 10             	add    $0x10,%esp
80102ff4:	39 1d 68 37 11 80    	cmp    %ebx,0x80113768
80102ffa:	7f 94                	jg     80102f90 <install_trans+0x20>
  }
}
80102ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fff:	5b                   	pop    %ebx
80103000:	5e                   	pop    %esi
80103001:	5f                   	pop    %edi
80103002:	5d                   	pop    %ebp
80103003:	c3                   	ret    
80103004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103008:	c3                   	ret    
80103009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103010 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103017:	ff 35 54 37 11 80    	pushl  0x80113754
8010301d:	ff 35 64 37 11 80    	pushl  0x80113764
80103023:	e8 a8 d0 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103028:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010302b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010302d:	a1 68 37 11 80       	mov    0x80113768,%eax
80103032:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103035:	85 c0                	test   %eax,%eax
80103037:	7e 19                	jle    80103052 <write_head+0x42>
80103039:	31 d2                	xor    %edx,%edx
8010303b:	90                   	nop
8010303c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80103040:	8b 0c 95 6c 37 11 80 	mov    -0x7feec894(,%edx,4),%ecx
80103047:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010304b:	83 c2 01             	add    $0x1,%edx
8010304e:	39 d0                	cmp    %edx,%eax
80103050:	75 ee                	jne    80103040 <write_head+0x30>
  }
  bwrite(buf);
80103052:	83 ec 0c             	sub    $0xc,%esp
80103055:	53                   	push   %ebx
80103056:	e8 55 d1 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010305b:	89 1c 24             	mov    %ebx,(%esp)
8010305e:	e8 8d d1 ff ff       	call   801001f0 <brelse>
}
80103063:	83 c4 10             	add    $0x10,%esp
80103066:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103069:	c9                   	leave  
8010306a:	c3                   	ret    
8010306b:	90                   	nop
8010306c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103070 <initlog>:
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	53                   	push   %ebx
80103074:	83 ec 2c             	sub    $0x2c,%esp
80103077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010307a:	68 80 7f 10 80       	push   $0x80107f80
8010307f:	68 20 37 11 80       	push   $0x80113720
80103084:	e8 f7 19 00 00       	call   80104a80 <initlock>
  readsb(dev, &sb);
80103089:	58                   	pop    %eax
8010308a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010308d:	5a                   	pop    %edx
8010308e:	50                   	push   %eax
8010308f:	53                   	push   %ebx
80103090:	e8 3b e8 ff ff       	call   801018d0 <readsb>
  log.start = sb.logstart;
80103095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103098:	59                   	pop    %ecx
  log.dev = dev;
80103099:	89 1d 64 37 11 80    	mov    %ebx,0x80113764
  log.size = sb.nlog;
8010309f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801030a2:	a3 54 37 11 80       	mov    %eax,0x80113754
  log.size = sb.nlog;
801030a7:	89 15 58 37 11 80    	mov    %edx,0x80113758
  struct buf *buf = bread(log.dev, log.start);
801030ad:	5a                   	pop    %edx
801030ae:	50                   	push   %eax
801030af:	53                   	push   %ebx
801030b0:	e8 1b d0 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801030b5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801030b8:	8b 48 5c             	mov    0x5c(%eax),%ecx
801030bb:	89 0d 68 37 11 80    	mov    %ecx,0x80113768
  for (i = 0; i < log.lh.n; i++) {
801030c1:	85 c9                	test   %ecx,%ecx
801030c3:	7e 1d                	jle    801030e2 <initlog+0x72>
801030c5:	31 d2                	xor    %edx,%edx
801030c7:	89 f6                	mov    %esi,%esi
801030c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.lh.block[i] = lh->block[i];
801030d0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801030d4:	89 1c 95 6c 37 11 80 	mov    %ebx,-0x7feec894(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801030db:	83 c2 01             	add    $0x1,%edx
801030de:	39 d1                	cmp    %edx,%ecx
801030e0:	75 ee                	jne    801030d0 <initlog+0x60>
  brelse(buf);
801030e2:	83 ec 0c             	sub    $0xc,%esp
801030e5:	50                   	push   %eax
801030e6:	e8 05 d1 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801030eb:	e8 80 fe ff ff       	call   80102f70 <install_trans>
  log.lh.n = 0;
801030f0:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
801030f7:	00 00 00 
  write_head(); // clear the log
801030fa:	e8 11 ff ff ff       	call   80103010 <write_head>
}
801030ff:	83 c4 10             	add    $0x10,%esp
80103102:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103105:	c9                   	leave  
80103106:	c3                   	ret    
80103107:	89 f6                	mov    %esi,%esi
80103109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103110 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103116:	68 20 37 11 80       	push   $0x80113720
8010311b:	e8 60 1a 00 00       	call   80104b80 <acquire>
80103120:	83 c4 10             	add    $0x10,%esp
80103123:	eb 18                	jmp    8010313d <begin_op+0x2d>
80103125:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103128:	83 ec 08             	sub    $0x8,%esp
8010312b:	68 20 37 11 80       	push   $0x80113720
80103130:	68 20 37 11 80       	push   $0x80113720
80103135:	e8 06 15 00 00       	call   80104640 <sleep>
8010313a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010313d:	a1 60 37 11 80       	mov    0x80113760,%eax
80103142:	85 c0                	test   %eax,%eax
80103144:	75 e2                	jne    80103128 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103146:	a1 5c 37 11 80       	mov    0x8011375c,%eax
8010314b:	8b 15 68 37 11 80    	mov    0x80113768,%edx
80103151:	83 c0 01             	add    $0x1,%eax
80103154:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103157:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010315a:	83 fa 1e             	cmp    $0x1e,%edx
8010315d:	7f c9                	jg     80103128 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010315f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103162:	a3 5c 37 11 80       	mov    %eax,0x8011375c
      release(&log.lock);
80103167:	68 20 37 11 80       	push   $0x80113720
8010316c:	e8 2f 1b 00 00       	call   80104ca0 <release>
      break;
    }
  }
}
80103171:	83 c4 10             	add    $0x10,%esp
80103174:	c9                   	leave  
80103175:	c3                   	ret    
80103176:	8d 76 00             	lea    0x0(%esi),%esi
80103179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103180 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
80103185:	53                   	push   %ebx
80103186:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103189:	68 20 37 11 80       	push   $0x80113720
8010318e:	e8 ed 19 00 00       	call   80104b80 <acquire>
  log.outstanding -= 1;
80103193:	a1 5c 37 11 80       	mov    0x8011375c,%eax
  if(log.committing)
80103198:	8b 35 60 37 11 80    	mov    0x80113760,%esi
8010319e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801031a1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801031a4:	89 1d 5c 37 11 80    	mov    %ebx,0x8011375c
  if(log.committing)
801031aa:	85 f6                	test   %esi,%esi
801031ac:	0f 85 22 01 00 00    	jne    801032d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801031b2:	85 db                	test   %ebx,%ebx
801031b4:	0f 85 f6 00 00 00    	jne    801032b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801031ba:	c7 05 60 37 11 80 01 	movl   $0x1,0x80113760
801031c1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801031c4:	83 ec 0c             	sub    $0xc,%esp
801031c7:	68 20 37 11 80       	push   $0x80113720
801031cc:	e8 cf 1a 00 00       	call   80104ca0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801031d1:	8b 0d 68 37 11 80    	mov    0x80113768,%ecx
801031d7:	83 c4 10             	add    $0x10,%esp
801031da:	85 c9                	test   %ecx,%ecx
801031dc:	7f 42                	jg     80103220 <end_op+0xa0>
    acquire(&log.lock);
801031de:	83 ec 0c             	sub    $0xc,%esp
801031e1:	68 20 37 11 80       	push   $0x80113720
801031e6:	e8 95 19 00 00       	call   80104b80 <acquire>
    wakeup(&log);
801031eb:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
    log.committing = 0;
801031f2:	c7 05 60 37 11 80 00 	movl   $0x0,0x80113760
801031f9:	00 00 00 
    wakeup(&log);
801031fc:	e8 ff 15 00 00       	call   80104800 <wakeup>
    release(&log.lock);
80103201:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
80103208:	e8 93 1a 00 00       	call   80104ca0 <release>
8010320d:	83 c4 10             	add    $0x10,%esp
}
80103210:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103213:	5b                   	pop    %ebx
80103214:	5e                   	pop    %esi
80103215:	5f                   	pop    %edi
80103216:	5d                   	pop    %ebp
80103217:	c3                   	ret    
80103218:	90                   	nop
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103220:	a1 54 37 11 80       	mov    0x80113754,%eax
80103225:	83 ec 08             	sub    $0x8,%esp
80103228:	01 d8                	add    %ebx,%eax
8010322a:	83 c0 01             	add    $0x1,%eax
8010322d:	50                   	push   %eax
8010322e:	ff 35 64 37 11 80    	pushl  0x80113764
80103234:	e8 97 ce ff ff       	call   801000d0 <bread>
80103239:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010323b:	58                   	pop    %eax
8010323c:	5a                   	pop    %edx
8010323d:	ff 34 9d 6c 37 11 80 	pushl  -0x7feec894(,%ebx,4)
80103244:	ff 35 64 37 11 80    	pushl  0x80113764
  for (tail = 0; tail < log.lh.n; tail++) {
8010324a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010324d:	e8 7e ce ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103252:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103255:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010325a:	68 00 02 00 00       	push   $0x200
8010325f:	50                   	push   %eax
80103260:	8d 46 5c             	lea    0x5c(%esi),%eax
80103263:	50                   	push   %eax
80103264:	e8 27 1b 00 00       	call   80104d90 <memmove>
    bwrite(to);  // write the log
80103269:	89 34 24             	mov    %esi,(%esp)
8010326c:	e8 3f cf ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103271:	89 3c 24             	mov    %edi,(%esp)
80103274:	e8 77 cf ff ff       	call   801001f0 <brelse>
    brelse(to);
80103279:	89 34 24             	mov    %esi,(%esp)
8010327c:	e8 6f cf ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103281:	83 c4 10             	add    $0x10,%esp
80103284:	3b 1d 68 37 11 80    	cmp    0x80113768,%ebx
8010328a:	7c 94                	jl     80103220 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010328c:	e8 7f fd ff ff       	call   80103010 <write_head>
    install_trans(); // Now install writes to home locations
80103291:	e8 da fc ff ff       	call   80102f70 <install_trans>
    log.lh.n = 0;
80103296:	c7 05 68 37 11 80 00 	movl   $0x0,0x80113768
8010329d:	00 00 00 
    write_head();    // Erase the transaction from the log
801032a0:	e8 6b fd ff ff       	call   80103010 <write_head>
801032a5:	e9 34 ff ff ff       	jmp    801031de <end_op+0x5e>
801032aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801032b0:	83 ec 0c             	sub    $0xc,%esp
801032b3:	68 20 37 11 80       	push   $0x80113720
801032b8:	e8 43 15 00 00       	call   80104800 <wakeup>
  release(&log.lock);
801032bd:	c7 04 24 20 37 11 80 	movl   $0x80113720,(%esp)
801032c4:	e8 d7 19 00 00       	call   80104ca0 <release>
801032c9:	83 c4 10             	add    $0x10,%esp
}
801032cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032cf:	5b                   	pop    %ebx
801032d0:	5e                   	pop    %esi
801032d1:	5f                   	pop    %edi
801032d2:	5d                   	pop    %ebp
801032d3:	c3                   	ret    
    panic("log.committing");
801032d4:	83 ec 0c             	sub    $0xc,%esp
801032d7:	68 84 7f 10 80       	push   $0x80107f84
801032dc:	e8 ff d0 ff ff       	call   801003e0 <panic>
801032e1:	eb 0d                	jmp    801032f0 <log_write>
801032e3:	90                   	nop
801032e4:	90                   	nop
801032e5:	90                   	nop
801032e6:	90                   	nop
801032e7:	90                   	nop
801032e8:	90                   	nop
801032e9:	90                   	nop
801032ea:	90                   	nop
801032eb:	90                   	nop
801032ec:	90                   	nop
801032ed:	90                   	nop
801032ee:	90                   	nop
801032ef:	90                   	nop

801032f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	53                   	push   %ebx
801032f4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032f7:	8b 15 68 37 11 80    	mov    0x80113768,%edx
{
801032fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103300:	83 fa 1d             	cmp    $0x1d,%edx
80103303:	0f 8f 94 00 00 00    	jg     8010339d <log_write+0xad>
80103309:	a1 58 37 11 80       	mov    0x80113758,%eax
8010330e:	83 e8 01             	sub    $0x1,%eax
80103311:	39 c2                	cmp    %eax,%edx
80103313:	0f 8d 84 00 00 00    	jge    8010339d <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103319:	a1 5c 37 11 80       	mov    0x8011375c,%eax
8010331e:	85 c0                	test   %eax,%eax
80103320:	0f 8e 84 00 00 00    	jle    801033aa <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103326:	83 ec 0c             	sub    $0xc,%esp
80103329:	68 20 37 11 80       	push   $0x80113720
8010332e:	e8 4d 18 00 00       	call   80104b80 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103333:	8b 15 68 37 11 80    	mov    0x80113768,%edx
80103339:	83 c4 10             	add    $0x10,%esp
8010333c:	85 d2                	test   %edx,%edx
8010333e:	7e 51                	jle    80103391 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103340:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103343:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103345:	3b 0d 6c 37 11 80    	cmp    0x8011376c,%ecx
8010334b:	75 0c                	jne    80103359 <log_write+0x69>
8010334d:	eb 39                	jmp    80103388 <log_write+0x98>
8010334f:	90                   	nop
80103350:	39 0c 85 6c 37 11 80 	cmp    %ecx,-0x7feec894(,%eax,4)
80103357:	74 2f                	je     80103388 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103359:	83 c0 01             	add    $0x1,%eax
8010335c:	39 c2                	cmp    %eax,%edx
8010335e:	75 f0                	jne    80103350 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103360:	89 0c 95 6c 37 11 80 	mov    %ecx,-0x7feec894(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103367:	83 c2 01             	add    $0x1,%edx
8010336a:	89 15 68 37 11 80    	mov    %edx,0x80113768
  b->flags |= B_DIRTY; // prevent eviction
80103370:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80103373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103376:	c7 45 08 20 37 11 80 	movl   $0x80113720,0x8(%ebp)
}
8010337d:	c9                   	leave  
  release(&log.lock);
8010337e:	e9 1d 19 00 00       	jmp    80104ca0 <release>
80103383:	90                   	nop
80103384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80103388:	89 0c 85 6c 37 11 80 	mov    %ecx,-0x7feec894(,%eax,4)
  if (i == log.lh.n)
8010338f:	eb df                	jmp    80103370 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80103391:	8b 43 08             	mov    0x8(%ebx),%eax
80103394:	a3 6c 37 11 80       	mov    %eax,0x8011376c
  if (i == log.lh.n)
80103399:	75 d5                	jne    80103370 <log_write+0x80>
8010339b:	eb ca                	jmp    80103367 <log_write+0x77>
    panic("too big a transaction");
8010339d:	83 ec 0c             	sub    $0xc,%esp
801033a0:	68 93 7f 10 80       	push   $0x80107f93
801033a5:	e8 36 d0 ff ff       	call   801003e0 <panic>
    panic("log_write outside of trans");
801033aa:	83 ec 0c             	sub    $0xc,%esp
801033ad:	68 a9 7f 10 80       	push   $0x80107fa9
801033b2:	e8 29 d0 ff ff       	call   801003e0 <panic>
801033b7:	66 90                	xchg   %ax,%ax
801033b9:	66 90                	xchg   %ax,%ax
801033bb:	66 90                	xchg   %ax,%ax
801033bd:	66 90                	xchg   %ax,%ax
801033bf:	90                   	nop

801033c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	53                   	push   %ebx
801033c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801033c7:	e8 d4 09 00 00       	call   80103da0 <cpuid>
801033cc:	89 c3                	mov    %eax,%ebx
801033ce:	e8 cd 09 00 00       	call   80103da0 <cpuid>
801033d3:	83 ec 04             	sub    $0x4,%esp
801033d6:	53                   	push   %ebx
801033d7:	50                   	push   %eax
801033d8:	68 c4 7f 10 80       	push   $0x80107fc4
801033dd:	e8 0e d3 ff ff       	call   801006f0 <cprintf>
  idtinit();       // load idt register
801033e2:	e8 c9 2d 00 00       	call   801061b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801033e7:	e8 34 09 00 00       	call   80103d20 <mycpu>
801033ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033ee:	b8 01 00 00 00       	mov    $0x1,%eax
801033f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801033fa:	e8 11 0f 00 00       	call   80104310 <scheduler>
801033ff:	90                   	nop

80103400 <mpenter>:
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103406:	e8 e5 3e 00 00       	call   801072f0 <switchkvm>
  seginit();
8010340b:	e8 50 3e 00 00       	call   80107260 <seginit>
  lapicinit();
80103410:	e8 8b f7 ff ff       	call   80102ba0 <lapicinit>
  mpmain();
80103415:	e8 a6 ff ff ff       	call   801033c0 <mpmain>
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <main>:
{
80103420:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103424:	83 e4 f0             	and    $0xfffffff0,%esp
80103427:	ff 71 fc             	pushl  -0x4(%ecx)
8010342a:	55                   	push   %ebp
8010342b:	89 e5                	mov    %esp,%ebp
8010342d:	53                   	push   %ebx
8010342e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010342f:	83 ec 08             	sub    $0x8,%esp
80103432:	68 00 00 40 80       	push   $0x80400000
80103437:	68 a8 6c 11 80       	push   $0x80116ca8
8010343c:	e8 0f f5 ff ff       	call   80102950 <kinit1>
  kvmalloc();      // kernel page table
80103441:	e8 7a 44 00 00       	call   801078c0 <kvmalloc>
  mpinit();        // detect other processors
80103446:	e8 85 01 00 00       	call   801035d0 <mpinit>
  lapicinit();     // interrupt controller
8010344b:	e8 50 f7 ff ff       	call   80102ba0 <lapicinit>
  seginit();       // segment descriptors
80103450:	e8 0b 3e 00 00       	call   80107260 <seginit>
  picinit();       // disable pic
80103455:	e8 46 03 00 00       	call   801037a0 <picinit>
  ioapicinit();    // another interrupt controller
8010345a:	e8 11 f3 ff ff       	call   80102770 <ioapicinit>
  consoleinit();   // console hardware
8010345f:	e8 0c da ff ff       	call   80100e70 <consoleinit>
  uartinit();      // serial port
80103464:	e8 b7 30 00 00       	call   80106520 <uartinit>
  pinit();         // process table
80103469:	e8 92 08 00 00       	call   80103d00 <pinit>
  tvinit();        // trap vectors
8010346e:	e8 bd 2c 00 00       	call   80106130 <tvinit>
  binit();         // buffer cache
80103473:	e8 c8 cb ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103478:	e8 a3 dd ff ff       	call   80101220 <fileinit>
  ideinit();       // disk 
8010347d:	e8 ce f0 ff ff       	call   80102550 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103482:	83 c4 0c             	add    $0xc,%esp
80103485:	68 8a 00 00 00       	push   $0x8a
8010348a:	68 8c b4 10 80       	push   $0x8010b48c
8010348f:	68 00 70 00 80       	push   $0x80007000
80103494:	e8 f7 18 00 00       	call   80104d90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	69 05 e0 3d 11 80 b8 	imul   $0xb8,0x80113de0,%eax
801034a3:	00 00 00 
801034a6:	05 20 38 11 80       	add    $0x80113820,%eax
801034ab:	3d 20 38 11 80       	cmp    $0x80113820,%eax
801034b0:	76 7e                	jbe    80103530 <main+0x110>
801034b2:	bb 20 38 11 80       	mov    $0x80113820,%ebx
801034b7:	eb 20                	jmp    801034d9 <main+0xb9>
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034c0:	69 05 e0 3d 11 80 b8 	imul   $0xb8,0x80113de0,%eax
801034c7:	00 00 00 
801034ca:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
801034d0:	05 20 38 11 80       	add    $0x80113820,%eax
801034d5:	39 c3                	cmp    %eax,%ebx
801034d7:	73 57                	jae    80103530 <main+0x110>
    if(c == mycpu())  // We've started already.
801034d9:	e8 42 08 00 00       	call   80103d20 <mycpu>
801034de:	39 d8                	cmp    %ebx,%eax
801034e0:	74 de                	je     801034c0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801034e2:	e8 39 f5 ff ff       	call   80102a20 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801034e7:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
801034ea:	c7 05 f8 6f 00 80 00 	movl   $0x80103400,0x80006ff8
801034f1:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801034f4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801034fb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801034fe:	05 00 10 00 00       	add    $0x1000,%eax
80103503:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103508:	0f b6 03             	movzbl (%ebx),%eax
8010350b:	68 00 70 00 00       	push   $0x7000
80103510:	50                   	push   %eax
80103511:	e8 da f7 ff ff       	call   80102cf0 <lapicstartap>
80103516:	83 c4 10             	add    $0x10,%esp
80103519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103520:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103526:	85 c0                	test   %eax,%eax
80103528:	74 f6                	je     80103520 <main+0x100>
8010352a:	eb 94                	jmp    801034c0 <main+0xa0>
8010352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103530:	83 ec 08             	sub    $0x8,%esp
80103533:	68 00 00 00 8e       	push   $0x8e000000
80103538:	68 00 00 40 80       	push   $0x80400000
8010353d:	e8 7e f4 ff ff       	call   801029c0 <kinit2>
  userinit();      // first user process
80103542:	e8 a9 09 00 00       	call   80103ef0 <userinit>
  mpmain();        // finish this processor's setup
80103547:	e8 74 fe ff ff       	call   801033c0 <mpmain>
8010354c:	66 90                	xchg   %ax,%ax
8010354e:	66 90                	xchg   %ax,%ax

80103550 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	57                   	push   %edi
80103554:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103555:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010355b:	53                   	push   %ebx
  e = addr+len;
8010355c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010355f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103562:	39 de                	cmp    %ebx,%esi
80103564:	72 10                	jb     80103576 <mpsearch1+0x26>
80103566:	eb 50                	jmp    801035b8 <mpsearch1+0x68>
80103568:	90                   	nop
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103570:	89 fe                	mov    %edi,%esi
80103572:	39 fb                	cmp    %edi,%ebx
80103574:	76 42                	jbe    801035b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103576:	83 ec 04             	sub    $0x4,%esp
80103579:	8d 7e 10             	lea    0x10(%esi),%edi
8010357c:	6a 04                	push   $0x4
8010357e:	68 d8 7f 10 80       	push   $0x80107fd8
80103583:	56                   	push   %esi
80103584:	e8 b7 17 00 00       	call   80104d40 <memcmp>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	85 c0                	test   %eax,%eax
8010358e:	75 e0                	jne    80103570 <mpsearch1+0x20>
80103590:	89 f1                	mov    %esi,%ecx
80103592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103598:	0f b6 11             	movzbl (%ecx),%edx
8010359b:	83 c1 01             	add    $0x1,%ecx
8010359e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801035a0:	39 f9                	cmp    %edi,%ecx
801035a2:	75 f4                	jne    80103598 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035a4:	84 c0                	test   %al,%al
801035a6:	75 c8                	jne    80103570 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801035a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ab:	89 f0                	mov    %esi,%eax
801035ad:	5b                   	pop    %ebx
801035ae:	5e                   	pop    %esi
801035af:	5f                   	pop    %edi
801035b0:	5d                   	pop    %ebp
801035b1:	c3                   	ret    
801035b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035bb:	31 f6                	xor    %esi,%esi
}
801035bd:	5b                   	pop    %ebx
801035be:	89 f0                	mov    %esi,%eax
801035c0:	5e                   	pop    %esi
801035c1:	5f                   	pop    %edi
801035c2:	5d                   	pop    %ebp
801035c3:	c3                   	ret    
801035c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801035d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801035e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801035e7:	c1 e0 08             	shl    $0x8,%eax
801035ea:	09 d0                	or     %edx,%eax
801035ec:	c1 e0 04             	shl    $0x4,%eax
801035ef:	75 1b                	jne    8010360c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801035f1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801035f8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801035ff:	c1 e0 08             	shl    $0x8,%eax
80103602:	09 d0                	or     %edx,%eax
80103604:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103607:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010360c:	ba 00 04 00 00       	mov    $0x400,%edx
80103611:	e8 3a ff ff ff       	call   80103550 <mpsearch1>
80103616:	89 c7                	mov    %eax,%edi
80103618:	85 c0                	test   %eax,%eax
8010361a:	0f 84 c0 00 00 00    	je     801036e0 <mpinit+0x110>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103620:	8b 5f 04             	mov    0x4(%edi),%ebx
80103623:	85 db                	test   %ebx,%ebx
80103625:	0f 84 d5 00 00 00    	je     80103700 <mpinit+0x130>
  if(memcmp(conf, "PCMP", 4) != 0)
8010362b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010362e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103634:	6a 04                	push   $0x4
80103636:	68 f5 7f 10 80       	push   $0x80107ff5
8010363b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010363c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010363f:	e8 fc 16 00 00       	call   80104d40 <memcmp>
80103644:	83 c4 10             	add    $0x10,%esp
80103647:	85 c0                	test   %eax,%eax
80103649:	0f 85 b1 00 00 00    	jne    80103700 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
8010364f:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103656:	3c 01                	cmp    $0x1,%al
80103658:	0f 95 c2             	setne  %dl
8010365b:	3c 04                	cmp    $0x4,%al
8010365d:	0f 95 c0             	setne  %al
80103660:	20 c2                	and    %al,%dl
80103662:	0f 85 98 00 00 00    	jne    80103700 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
80103668:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
8010366f:	66 85 c9             	test   %cx,%cx
80103672:	74 21                	je     80103695 <mpinit+0xc5>
80103674:	89 d8                	mov    %ebx,%eax
80103676:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  sum = 0;
80103679:	31 d2                	xor    %edx,%edx
8010367b:	90                   	nop
8010367c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103680:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103687:	83 c0 01             	add    $0x1,%eax
8010368a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010368c:	39 c6                	cmp    %eax,%esi
8010368e:	75 f0                	jne    80103680 <mpinit+0xb0>
80103690:	84 d2                	test   %dl,%dl
80103692:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103695:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103698:	85 c9                	test   %ecx,%ecx
8010369a:	74 64                	je     80103700 <mpinit+0x130>
8010369c:	84 d2                	test   %dl,%dl
8010369e:	75 60                	jne    80103700 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801036a0:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801036a6:	a3 1c 37 11 80       	mov    %eax,0x8011371c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801036ab:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801036b2:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801036b8:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801036bd:	01 d1                	add    %edx,%ecx
801036bf:	89 ce                	mov    %ecx,%esi
801036c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036c8:	39 c6                	cmp    %eax,%esi
801036ca:	76 4b                	jbe    80103717 <mpinit+0x147>
    switch(*p){
801036cc:	0f b6 10             	movzbl (%eax),%edx
801036cf:	80 fa 04             	cmp    $0x4,%dl
801036d2:	0f 87 bf 00 00 00    	ja     80103797 <mpinit+0x1c7>
801036d8:	ff 24 95 1c 80 10 80 	jmp    *-0x7fef7fe4(,%edx,4)
801036df:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
801036e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801036e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801036ea:	e8 61 fe ff ff       	call   80103550 <mpsearch1>
801036ef:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036f1:	85 c0                	test   %eax,%eax
801036f3:	0f 85 27 ff ff ff    	jne    80103620 <mpinit+0x50>
801036f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	68 dd 7f 10 80       	push   $0x80107fdd
80103708:	e8 d3 cc ff ff       	call   801003e0 <panic>
8010370d:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103710:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103713:	39 c6                	cmp    %eax,%esi
80103715:	77 b5                	ja     801036cc <mpinit+0xfc>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103717:	85 db                	test   %ebx,%ebx
80103719:	74 6f                	je     8010378a <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010371b:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010371f:	74 15                	je     80103736 <mpinit+0x166>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103721:	b8 70 00 00 00       	mov    $0x70,%eax
80103726:	ba 22 00 00 00       	mov    $0x22,%edx
8010372b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010372c:	ba 23 00 00 00       	mov    $0x23,%edx
80103731:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103732:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103735:	ee                   	out    %al,(%dx)
  }
}
80103736:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103739:	5b                   	pop    %ebx
8010373a:	5e                   	pop    %esi
8010373b:	5f                   	pop    %edi
8010373c:	5d                   	pop    %ebp
8010373d:	c3                   	ret    
8010373e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103740:	8b 15 e0 3d 11 80    	mov    0x80113de0,%edx
80103746:	83 fa 07             	cmp    $0x7,%edx
80103749:	7f 1f                	jg     8010376a <mpinit+0x19a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010374b:	69 ca b8 00 00 00    	imul   $0xb8,%edx,%ecx
80103751:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103754:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103758:	88 91 20 38 11 80    	mov    %dl,-0x7feec7e0(%ecx)
        ncpu++;
8010375e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103761:	83 c2 01             	add    $0x1,%edx
80103764:	89 15 e0 3d 11 80    	mov    %edx,0x80113de0
      p += sizeof(struct mpproc);
8010376a:	83 c0 14             	add    $0x14,%eax
      continue;
8010376d:	e9 56 ff ff ff       	jmp    801036c8 <mpinit+0xf8>
80103772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103778:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010377c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010377f:	88 15 00 38 11 80    	mov    %dl,0x80113800
      continue;
80103785:	e9 3e ff ff ff       	jmp    801036c8 <mpinit+0xf8>
    panic("Didn't find a suitable machine");
8010378a:	83 ec 0c             	sub    $0xc,%esp
8010378d:	68 fc 7f 10 80       	push   $0x80107ffc
80103792:	e8 49 cc ff ff       	call   801003e0 <panic>
      ismp = 0;
80103797:	31 db                	xor    %ebx,%ebx
80103799:	e9 31 ff ff ff       	jmp    801036cf <mpinit+0xff>
8010379e:	66 90                	xchg   %ax,%ax

801037a0 <picinit>:
801037a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801037a5:	ba 21 00 00 00       	mov    $0x21,%edx
801037aa:	ee                   	out    %al,(%dx)
801037ab:	ba a1 00 00 00       	mov    $0xa1,%edx
801037b0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801037b1:	c3                   	ret    
801037b2:	66 90                	xchg   %ax,%ax
801037b4:	66 90                	xchg   %ax,%ax
801037b6:	66 90                	xchg   %ax,%ax
801037b8:	66 90                	xchg   %ax,%ax
801037ba:	66 90                	xchg   %ax,%ax
801037bc:	66 90                	xchg   %ax,%ax
801037be:	66 90                	xchg   %ax,%ax

801037c0 <memowrite>:
  int writeopen;  // write fd is still open
};

int
memowrite(char* addr, int n)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	56                   	push   %esi
801037c4:	53                   	push   %ebx
801037c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct memo* ch=(struct memo*)getshared(2);
801037c8:	83 ec 0c             	sub    $0xc,%esp
801037cb:	6a 02                	push   $0x2
801037cd:	e8 6e 08 00 00       	call   80104040 <getshared>
801037d2:	89 c3                	mov    %eax,%ebx
  acquire(&ch->lock);
801037d4:	89 04 24             	mov    %eax,(%esp)
801037d7:	e8 a4 13 00 00       	call   80104b80 <acquire>
  strncpy(ch->memo+ch->lmemo, addr, n);
801037dc:	83 c4 0c             	add    $0xc,%esp
801037df:	56                   	push   %esi
801037e0:	ff 75 08             	pushl  0x8(%ebp)
801037e3:	8b 43 34             	mov    0x34(%ebx),%eax
801037e6:	8d 44 03 38          	lea    0x38(%ebx,%eax,1),%eax
801037ea:	50                   	push   %eax
801037eb:	e8 70 16 00 00       	call   80104e60 <strncpy>
  ch->lmemo+=n;
801037f0:	03 73 34             	add    0x34(%ebx),%esi
801037f3:	89 73 34             	mov    %esi,0x34(%ebx)
  ch->memo[ch->lmemo]=0;
801037f6:	c6 44 33 38 00       	movb   $0x0,0x38(%ebx,%esi,1)
  release(&ch->lock);
801037fb:	89 1c 24             	mov    %ebx,(%esp)
801037fe:	e8 9d 14 00 00       	call   80104ca0 <release>
  return 0;
}
80103803:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103806:	31 c0                	xor    %eax,%eax
80103808:	5b                   	pop    %ebx
80103809:	5e                   	pop    %esi
8010380a:	5d                   	pop    %ebp
8010380b:	c3                   	ret    
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103810 <pipealloc>:

int
pipealloc(struct file **f0, struct file **f1)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	57                   	push   %edi
80103814:	56                   	push   %esi
80103815:	53                   	push   %ebx
80103816:	83 ec 0c             	sub    $0xc,%esp
80103819:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010381c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010381f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103825:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010382b:	e8 10 da ff ff       	call   80101240 <filealloc>
80103830:	89 03                	mov    %eax,(%ebx)
80103832:	85 c0                	test   %eax,%eax
80103834:	0f 84 a8 00 00 00    	je     801038e2 <pipealloc+0xd2>
8010383a:	e8 01 da ff ff       	call   80101240 <filealloc>
8010383f:	89 06                	mov    %eax,(%esi)
80103841:	85 c0                	test   %eax,%eax
80103843:	0f 84 87 00 00 00    	je     801038d0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103849:	e8 d2 f1 ff ff       	call   80102a20 <kalloc>
8010384e:	89 c7                	mov    %eax,%edi
80103850:	85 c0                	test   %eax,%eax
80103852:	0f 84 b0 00 00 00    	je     80103908 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103858:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010385f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103862:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103865:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010386c:	00 00 00 
  p->nwrite = 0;
8010386f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103876:	00 00 00 
  p->nread = 0;
80103879:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103880:	00 00 00 
  initlock(&p->lock, "pipe");
80103883:	68 30 80 10 80       	push   $0x80108030
80103888:	50                   	push   %eax
80103889:	e8 f2 11 00 00       	call   80104a80 <initlock>
  (*f0)->type = FD_PIPE;
8010388e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103890:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103893:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103899:	8b 03                	mov    (%ebx),%eax
8010389b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010389f:	8b 03                	mov    (%ebx),%eax
801038a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801038a5:	8b 03                	mov    (%ebx),%eax
801038a7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801038aa:	8b 06                	mov    (%esi),%eax
801038ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801038b2:	8b 06                	mov    (%esi),%eax
801038b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801038b8:	8b 06                	mov    (%esi),%eax
801038ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801038be:	8b 06                	mov    (%esi),%eax
801038c0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801038c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801038c6:	31 c0                	xor    %eax,%eax
}
801038c8:	5b                   	pop    %ebx
801038c9:	5e                   	pop    %esi
801038ca:	5f                   	pop    %edi
801038cb:	5d                   	pop    %ebp
801038cc:	c3                   	ret    
801038cd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801038d0:	8b 03                	mov    (%ebx),%eax
801038d2:	85 c0                	test   %eax,%eax
801038d4:	74 1e                	je     801038f4 <pipealloc+0xe4>
    fileclose(*f0);
801038d6:	83 ec 0c             	sub    $0xc,%esp
801038d9:	50                   	push   %eax
801038da:	e8 21 da ff ff       	call   80101300 <fileclose>
801038df:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801038e2:	8b 06                	mov    (%esi),%eax
801038e4:	85 c0                	test   %eax,%eax
801038e6:	74 0c                	je     801038f4 <pipealloc+0xe4>
    fileclose(*f1);
801038e8:	83 ec 0c             	sub    $0xc,%esp
801038eb:	50                   	push   %eax
801038ec:	e8 0f da ff ff       	call   80101300 <fileclose>
801038f1:	83 c4 10             	add    $0x10,%esp
}
801038f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801038f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801038fc:	5b                   	pop    %ebx
801038fd:	5e                   	pop    %esi
801038fe:	5f                   	pop    %edi
801038ff:	5d                   	pop    %ebp
80103900:	c3                   	ret    
80103901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103908:	8b 03                	mov    (%ebx),%eax
8010390a:	85 c0                	test   %eax,%eax
8010390c:	75 c8                	jne    801038d6 <pipealloc+0xc6>
8010390e:	eb d2                	jmp    801038e2 <pipealloc+0xd2>

80103910 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
80103915:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103918:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010391b:	83 ec 0c             	sub    $0xc,%esp
8010391e:	53                   	push   %ebx
8010391f:	e8 5c 12 00 00       	call   80104b80 <acquire>
  if(writable){
80103924:	83 c4 10             	add    $0x10,%esp
80103927:	85 f6                	test   %esi,%esi
80103929:	74 65                	je     80103990 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010392b:	83 ec 0c             	sub    $0xc,%esp
8010392e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103934:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010393b:	00 00 00 
    wakeup(&p->nread);
8010393e:	50                   	push   %eax
8010393f:	e8 bc 0e 00 00       	call   80104800 <wakeup>
80103944:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103947:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010394d:	85 d2                	test   %edx,%edx
8010394f:	75 0a                	jne    8010395b <pipeclose+0x4b>
80103951:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103957:	85 c0                	test   %eax,%eax
80103959:	74 15                	je     80103970 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010395b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010395e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103961:	5b                   	pop    %ebx
80103962:	5e                   	pop    %esi
80103963:	5d                   	pop    %ebp
    release(&p->lock);
80103964:	e9 37 13 00 00       	jmp    80104ca0 <release>
80103969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103970:	83 ec 0c             	sub    $0xc,%esp
80103973:	53                   	push   %ebx
80103974:	e8 27 13 00 00       	call   80104ca0 <release>
    kfree((char*)p);
80103979:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010397c:	83 c4 10             	add    $0x10,%esp
}
8010397f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103982:	5b                   	pop    %ebx
80103983:	5e                   	pop    %esi
80103984:	5d                   	pop    %ebp
    kfree((char*)p);
80103985:	e9 d6 ee ff ff       	jmp    80102860 <kfree>
8010398a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103990:	83 ec 0c             	sub    $0xc,%esp
80103993:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103999:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801039a0:	00 00 00 
    wakeup(&p->nwrite);
801039a3:	50                   	push   %eax
801039a4:	e8 57 0e 00 00       	call   80104800 <wakeup>
801039a9:	83 c4 10             	add    $0x10,%esp
801039ac:	eb 99                	jmp    80103947 <pipeclose+0x37>
801039ae:	66 90                	xchg   %ax,%ax

801039b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	57                   	push   %edi
801039b4:	56                   	push   %esi
801039b5:	53                   	push   %ebx
801039b6:	83 ec 28             	sub    $0x28,%esp
801039b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801039bc:	53                   	push   %ebx
801039bd:	e8 be 11 00 00       	call   80104b80 <acquire>
  for(i = 0; i < n; i++){
801039c2:	8b 45 10             	mov    0x10(%ebp),%eax
801039c5:	83 c4 10             	add    $0x10,%esp
801039c8:	85 c0                	test   %eax,%eax
801039ca:	0f 8e c8 00 00 00    	jle    80103a98 <pipewrite+0xe8>
801039d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801039d3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801039d9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801039df:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801039e2:	03 4d 10             	add    0x10(%ebp),%ecx
801039e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039e8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801039ee:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801039f4:	39 d0                	cmp    %edx,%eax
801039f6:	75 71                	jne    80103a69 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801039f8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801039fe:	85 c0                	test   %eax,%eax
80103a00:	74 4e                	je     80103a50 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a02:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103a08:	eb 3a                	jmp    80103a44 <pipewrite+0x94>
80103a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103a10:	83 ec 0c             	sub    $0xc,%esp
80103a13:	57                   	push   %edi
80103a14:	e8 e7 0d 00 00       	call   80104800 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a19:	5a                   	pop    %edx
80103a1a:	59                   	pop    %ecx
80103a1b:	53                   	push   %ebx
80103a1c:	56                   	push   %esi
80103a1d:	e8 1e 0c 00 00       	call   80104640 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a22:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103a28:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103a2e:	83 c4 10             	add    $0x10,%esp
80103a31:	05 00 02 00 00       	add    $0x200,%eax
80103a36:	39 c2                	cmp    %eax,%edx
80103a38:	75 36                	jne    80103a70 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103a3a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103a40:	85 c0                	test   %eax,%eax
80103a42:	74 0c                	je     80103a50 <pipewrite+0xa0>
80103a44:	e8 77 03 00 00       	call   80103dc0 <myproc>
80103a49:	8b 40 24             	mov    0x24(%eax),%eax
80103a4c:	85 c0                	test   %eax,%eax
80103a4e:	74 c0                	je     80103a10 <pipewrite+0x60>
        release(&p->lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	53                   	push   %ebx
80103a54:	e8 47 12 00 00       	call   80104ca0 <release>
        return -1;
80103a59:	83 c4 10             	add    $0x10,%esp
80103a5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a64:	5b                   	pop    %ebx
80103a65:	5e                   	pop    %esi
80103a66:	5f                   	pop    %edi
80103a67:	5d                   	pop    %ebp
80103a68:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a69:	89 c2                	mov    %eax,%edx
80103a6b:	90                   	nop
80103a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103a70:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103a73:	8d 42 01             	lea    0x1(%edx),%eax
80103a76:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103a7c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103a82:	0f b6 0e             	movzbl (%esi),%ecx
80103a85:	83 c6 01             	add    $0x1,%esi
80103a88:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103a8b:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103a8f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103a92:	0f 85 50 ff ff ff    	jne    801039e8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103a98:	83 ec 0c             	sub    $0xc,%esp
80103a9b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103aa1:	50                   	push   %eax
80103aa2:	e8 59 0d 00 00       	call   80104800 <wakeup>
  release(&p->lock);
80103aa7:	89 1c 24             	mov    %ebx,(%esp)
80103aaa:	e8 f1 11 00 00       	call   80104ca0 <release>
  return n;
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	8b 45 10             	mov    0x10(%ebp),%eax
80103ab5:	eb aa                	jmp    80103a61 <pipewrite+0xb1>
80103ab7:	89 f6                	mov    %esi,%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ac0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	57                   	push   %edi
80103ac4:	56                   	push   %esi
80103ac5:	53                   	push   %ebx
80103ac6:	83 ec 18             	sub    $0x18,%esp
80103ac9:	8b 75 08             	mov    0x8(%ebp),%esi
80103acc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103acf:	56                   	push   %esi
80103ad0:	e8 ab 10 00 00       	call   80104b80 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ad5:	83 c4 10             	add    $0x10,%esp
80103ad8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103ade:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103ae4:	75 6a                	jne    80103b50 <piperead+0x90>
80103ae6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103aec:	85 db                	test   %ebx,%ebx
80103aee:	0f 84 c4 00 00 00    	je     80103bb8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103af4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103afa:	eb 2d                	jmp    80103b29 <piperead+0x69>
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b00:	83 ec 08             	sub    $0x8,%esp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
80103b05:	e8 36 0b 00 00       	call   80104640 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b0a:	83 c4 10             	add    $0x10,%esp
80103b0d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103b13:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103b19:	75 35                	jne    80103b50 <piperead+0x90>
80103b1b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103b21:	85 d2                	test   %edx,%edx
80103b23:	0f 84 8f 00 00 00    	je     80103bb8 <piperead+0xf8>
    if(myproc()->killed){
80103b29:	e8 92 02 00 00       	call   80103dc0 <myproc>
80103b2e:	8b 48 24             	mov    0x24(%eax),%ecx
80103b31:	85 c9                	test   %ecx,%ecx
80103b33:	74 cb                	je     80103b00 <piperead+0x40>
      release(&p->lock);
80103b35:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103b38:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103b3d:	56                   	push   %esi
80103b3e:	e8 5d 11 00 00       	call   80104ca0 <release>
      return -1;
80103b43:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103b46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b49:	89 d8                	mov    %ebx,%eax
80103b4b:	5b                   	pop    %ebx
80103b4c:	5e                   	pop    %esi
80103b4d:	5f                   	pop    %edi
80103b4e:	5d                   	pop    %ebp
80103b4f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103b50:	8b 45 10             	mov    0x10(%ebp),%eax
80103b53:	85 c0                	test   %eax,%eax
80103b55:	7e 61                	jle    80103bb8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103b57:	31 db                	xor    %ebx,%ebx
80103b59:	eb 13                	jmp    80103b6e <piperead+0xae>
80103b5b:	90                   	nop
80103b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b60:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103b66:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103b6c:	74 1f                	je     80103b8d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103b6e:	8d 41 01             	lea    0x1(%ecx),%eax
80103b71:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103b77:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103b7d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103b82:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103b85:	83 c3 01             	add    $0x1,%ebx
80103b88:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103b8b:	75 d3                	jne    80103b60 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103b8d:	83 ec 0c             	sub    $0xc,%esp
80103b90:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103b96:	50                   	push   %eax
80103b97:	e8 64 0c 00 00       	call   80104800 <wakeup>
  release(&p->lock);
80103b9c:	89 34 24             	mov    %esi,(%esp)
80103b9f:	e8 fc 10 00 00       	call   80104ca0 <release>
  return i;
80103ba4:	83 c4 10             	add    $0x10,%esp
}
80103ba7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103baa:	89 d8                	mov    %ebx,%eax
80103bac:	5b                   	pop    %ebx
80103bad:	5e                   	pop    %esi
80103bae:	5f                   	pop    %edi
80103baf:	5d                   	pop    %ebp
80103bb0:	c3                   	ret    
80103bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
80103bb8:	31 db                	xor    %ebx,%ebx
80103bba:	eb d1                	jmp    80103b8d <piperead+0xcd>
80103bbc:	66 90                	xchg   %ax,%ax
80103bbe:	66 90                	xchg   %ax,%ax

80103bc0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bc4:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
{
80103bc9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103bcc:	68 00 3e 11 80       	push   $0x80113e00
80103bd1:	e8 aa 0f 00 00       	call   80104b80 <acquire>
80103bd6:	83 c4 10             	add    $0x10,%esp
80103bd9:	eb 17                	jmp    80103bf2 <allocproc+0x32>
80103bdb:	90                   	nop
80103bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103be0:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103be6:	81 fb 34 64 11 80    	cmp    $0x80116434,%ebx
80103bec:	0f 84 8e 00 00 00    	je     80103c80 <allocproc+0xc0>
    if(p->state == UNUSED)
80103bf2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103bf5:	85 c0                	test   %eax,%eax
80103bf7:	75 e7                	jne    80103be0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103bf9:	a1 04 b0 10 80       	mov    0x8010b004,%eax


  release(&ptable.lock);
80103bfe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103c01:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103c08:	89 43 10             	mov    %eax,0x10(%ebx)
80103c0b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103c0e:	68 00 3e 11 80       	push   $0x80113e00
  p->pid = nextpid++;
80103c13:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103c19:	e8 82 10 00 00       	call   80104ca0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103c1e:	e8 fd ed ff ff       	call   80102a20 <kalloc>
80103c23:	83 c4 10             	add    $0x10,%esp
80103c26:	89 43 08             	mov    %eax,0x8(%ebx)
80103c29:	85 c0                	test   %eax,%eax
80103c2b:	74 6c                	je     80103c99 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103c2d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103c33:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103c36:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103c3b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103c3e:	c7 40 14 22 61 10 80 	movl   $0x80106122,0x14(%eax)
  p->context = (struct context*)sp;
80103c45:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103c48:	6a 14                	push   $0x14
80103c4a:	6a 00                	push   $0x0
80103c4c:	50                   	push   %eax
80103c4d:	e8 9e 10 00 00       	call   80104cf0 <memset>
  p->context->eip = (uint)forkret;
80103c52:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103c55:	c7 40 10 b0 3c 10 80 	movl   $0x80103cb0,0x10(%eax)

  //brand new
  p->priority=NPROCQ-1;
80103c5c:	c7 83 80 00 00 00 02 	movl   $0x2,0x80(%ebx)
80103c63:	00 00 00 
  p->widx=0;
80103c66:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103c6d:	00 00 00 
  asm volatile("cli");
80103c70:	fa                   	cli    
  cli();

  return p;
}
80103c71:	89 d8                	mov    %ebx,%eax
  return p;
80103c73:	83 c4 10             	add    $0x10,%esp
}
80103c76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c79:	c9                   	leave  
80103c7a:	c3                   	ret    
80103c7b:	90                   	nop
80103c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103c80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103c83:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103c85:	68 00 3e 11 80       	push   $0x80113e00
80103c8a:	e8 11 10 00 00       	call   80104ca0 <release>
}
80103c8f:	89 d8                	mov    %ebx,%eax
  return 0;
80103c91:	83 c4 10             	add    $0x10,%esp
}
80103c94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c97:	c9                   	leave  
80103c98:	c3                   	ret    
    p->state = UNUSED;
80103c99:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ca0:	31 db                	xor    %ebx,%ebx
}
80103ca2:	89 d8                	mov    %ebx,%eax
80103ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ca7:	c9                   	leave  
80103ca8:	c3                   	ret    
80103ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cb0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103cb6:	68 00 3e 11 80       	push   $0x80113e00
80103cbb:	e8 e0 0f 00 00       	call   80104ca0 <release>

  if (first) {
80103cc0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103cc5:	83 c4 10             	add    $0x10,%esp
80103cc8:	85 c0                	test   %eax,%eax
80103cca:	75 04                	jne    80103cd0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103ccc:	c9                   	leave  
80103ccd:	c3                   	ret    
80103cce:	66 90                	xchg   %ax,%ax
    first = 0;
80103cd0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103cd7:	00 00 00 
    iinit(ROOTDEV);
80103cda:	83 ec 0c             	sub    $0xc,%esp
80103cdd:	6a 01                	push   $0x1
80103cdf:	e8 ac dc ff ff       	call   80101990 <iinit>
    initlog(ROOTDEV);
80103ce4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103ceb:	e8 80 f3 ff ff       	call   80103070 <initlog>
80103cf0:	83 c4 10             	add    $0x10,%esp
}
80103cf3:	c9                   	leave  
80103cf4:	c3                   	ret    
80103cf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <pinit>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d06:	68 35 80 10 80       	push   $0x80108035
80103d0b:	68 00 3e 11 80       	push   $0x80113e00
80103d10:	e8 6b 0d 00 00       	call   80104a80 <initlock>
}
80103d15:	83 c4 10             	add    $0x10,%esp
80103d18:	c9                   	leave  
80103d19:	c3                   	ret    
80103d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d20 <mycpu>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	56                   	push   %esi
80103d24:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d25:	9c                   	pushf  
80103d26:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d27:	f6 c4 02             	test   $0x2,%ah
80103d2a:	75 5d                	jne    80103d89 <mycpu+0x69>
  apicid = lapicid();
80103d2c:	e8 6f ef ff ff       	call   80102ca0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103d31:	8b 35 e0 3d 11 80    	mov    0x80113de0,%esi
80103d37:	85 f6                	test   %esi,%esi
80103d39:	7e 41                	jle    80103d7c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
80103d3b:	0f b6 15 20 38 11 80 	movzbl 0x80113820,%edx
80103d42:	39 d0                	cmp    %edx,%eax
80103d44:	74 2f                	je     80103d75 <mycpu+0x55>
  for (i = 0; i < ncpu; ++i) {
80103d46:	31 d2                	xor    %edx,%edx
80103d48:	90                   	nop
80103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d50:	83 c2 01             	add    $0x1,%edx
80103d53:	39 f2                	cmp    %esi,%edx
80103d55:	74 25                	je     80103d7c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
80103d57:	69 ca b8 00 00 00    	imul   $0xb8,%edx,%ecx
80103d5d:	0f b6 99 20 38 11 80 	movzbl -0x7feec7e0(%ecx),%ebx
80103d64:	39 c3                	cmp    %eax,%ebx
80103d66:	75 e8                	jne    80103d50 <mycpu+0x30>
80103d68:	8d 81 20 38 11 80    	lea    -0x7feec7e0(%ecx),%eax
}
80103d6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d71:	5b                   	pop    %ebx
80103d72:	5e                   	pop    %esi
80103d73:	5d                   	pop    %ebp
80103d74:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103d75:	b8 20 38 11 80       	mov    $0x80113820,%eax
      return &cpus[i];
80103d7a:	eb f2                	jmp    80103d6e <mycpu+0x4e>
  panic("unknown apicid\n");
80103d7c:	83 ec 0c             	sub    $0xc,%esp
80103d7f:	68 3c 80 10 80       	push   $0x8010803c
80103d84:	e8 57 c6 ff ff       	call   801003e0 <panic>
    panic("mycpu called with interrupts enabled\n");
80103d89:	83 ec 0c             	sub    $0xc,%esp
80103d8c:	68 18 81 10 80       	push   $0x80108118
80103d91:	e8 4a c6 ff ff       	call   801003e0 <panic>
80103d96:	8d 76 00             	lea    0x0(%esi),%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103da0 <cpuid>:
cpuid() {
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103da6:	e8 75 ff ff ff       	call   80103d20 <mycpu>
}
80103dab:	c9                   	leave  
  return mycpu()-cpus;
80103dac:	2d 20 38 11 80       	sub    $0x80113820,%eax
80103db1:	c1 f8 03             	sar    $0x3,%eax
80103db4:	69 c0 a7 37 bd e9    	imul   $0xe9bd37a7,%eax,%eax
}
80103dba:	c3                   	ret    
80103dbb:	90                   	nop
80103dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103dc0 <myproc>:
myproc(void) {
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	53                   	push   %ebx
80103dc4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103dc7:	e8 64 0d 00 00       	call   80104b30 <pushcli>
  c = mycpu();
80103dcc:	e8 4f ff ff ff       	call   80103d20 <mycpu>
  p = c->proc;
80103dd1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dd7:	e8 64 0e 00 00       	call   80104c40 <popcli>
}
80103ddc:	83 c4 04             	add    $0x4,%esp
80103ddf:	89 d8                	mov    %ebx,%eax
80103de1:	5b                   	pop    %ebx
80103de2:	5d                   	pop    %ebp
80103de3:	c3                   	ret    
80103de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103df0 <qpush>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	8b 45 08             	mov    0x8(%ebp),%eax
  if(ptable.count[np->priority]<=0)
80103df7:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103dfd:	8b 0c 95 4c 64 11 80 	mov    -0x7fee9bb4(,%edx,4),%ecx
80103e04:	85 c9                	test   %ecx,%ecx
80103e06:	75 40                	jne    80103e48 <qpush+0x58>
    np->next=np;
80103e08:	89 40 7c             	mov    %eax,0x7c(%eax)
    ptable.pqueue[np->priority].head=np;
80103e0b:	89 04 d5 34 64 11 80 	mov    %eax,-0x7fee9bcc(,%edx,8)
    ptable.pqueue[np->priority].last=np;
80103e12:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103e18:	89 04 d5 38 64 11 80 	mov    %eax,-0x7fee9bc8(,%edx,8)
  np->timepiece=(1<<(NPROCQ-np->priority-1));
80103e1f:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103e25:	b9 02 00 00 00       	mov    $0x2,%ecx
80103e2a:	bb 01 00 00 00       	mov    $0x1,%ebx
80103e2f:	29 d1                	sub    %edx,%ecx
80103e31:	d3 e3                	shl    %cl,%ebx
80103e33:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
}
80103e39:	5b                   	pop    %ebx
  ptable.count[np->priority]++;
80103e3a:	83 04 95 4c 64 11 80 	addl   $0x1,-0x7fee9bb4(,%edx,4)
80103e41:	01 
}
80103e42:	5d                   	pop    %ebp
80103e43:	c3                   	ret    
80103e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->next=ptable.pqueue[np->priority].head;
80103e48:	81 c2 c6 04 00 00    	add    $0x4c6,%edx
80103e4e:	8b 0c d5 04 3e 11 80 	mov    -0x7feec1fc(,%edx,8),%ecx
80103e55:	89 48 7c             	mov    %ecx,0x7c(%eax)
    ptable.pqueue[np->priority].last->next=np;
80103e58:	8b 14 d5 08 3e 11 80 	mov    -0x7feec1f8(,%edx,8),%edx
80103e5f:	89 42 7c             	mov    %eax,0x7c(%edx)
    ptable.pqueue[np->priority].last=np;
80103e62:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103e68:	89 04 d5 38 64 11 80 	mov    %eax,-0x7fee9bc8(,%edx,8)
80103e6f:	eb ae                	jmp    80103e1f <qpush+0x2f>
80103e71:	eb 0d                	jmp    80103e80 <wakeup1>
80103e73:	90                   	nop
80103e74:	90                   	nop
80103e75:	90                   	nop
80103e76:	90                   	nop
80103e77:	90                   	nop
80103e78:	90                   	nop
80103e79:	90                   	nop
80103e7a:	90                   	nop
80103e7b:	90                   	nop
80103e7c:	90                   	nop
80103e7d:	90                   	nop
80103e7e:	90                   	nop
80103e7f:	90                   	nop

80103e80 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	56                   	push   %esi
80103e84:	89 c6                	mov    %eax,%esi
80103e86:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e87:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
80103e8c:	eb 10                	jmp    80103e9e <wakeup1+0x1e>
80103e8e:	66 90                	xchg   %ax,%ax
80103e90:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103e96:	81 fb 34 64 11 80    	cmp    $0x80116434,%ebx
80103e9c:	74 40                	je     80103ede <wakeup1+0x5e>
    if(p->state == SLEEPING && p->chan == chan)
80103e9e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103ea2:	75 ec                	jne    80103e90 <wakeup1+0x10>
80103ea4:	39 73 20             	cmp    %esi,0x20(%ebx)
80103ea7:	75 e7                	jne    80103e90 <wakeup1+0x10>
    {
      p->state = RUNNABLE;

      //brand new
      if(p->priority<NPROCQ-1)
80103ea9:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
      p->state = RUNNABLE;
80103eaf:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      if(p->priority<NPROCQ-1)
80103eb6:	83 f8 01             	cmp    $0x1,%eax
80103eb9:	77 09                	ja     80103ec4 <wakeup1+0x44>
        p->priority++;
80103ebb:	83 c0 01             	add    $0x1,%eax
80103ebe:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
      qpush(p);
80103ec4:	83 ec 0c             	sub    $0xc,%esp
80103ec7:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec8:	81 c3 98 00 00 00    	add    $0x98,%ebx
      qpush(p);
80103ece:	e8 1d ff ff ff       	call   80103df0 <qpush>
80103ed3:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ed6:	81 fb 34 64 11 80    	cmp    $0x80116434,%ebx
80103edc:	75 c0                	jne    80103e9e <wakeup1+0x1e>

    }
}
80103ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ee1:	5b                   	pop    %ebx
80103ee2:	5e                   	pop    %esi
80103ee3:	5d                   	pop    %ebp
80103ee4:	c3                   	ret    
80103ee5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <userinit>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	53                   	push   %ebx
80103ef4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ef7:	e8 c4 fc ff ff       	call   80103bc0 <allocproc>
80103efc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103efe:	a3 d8 b5 10 80       	mov    %eax,0x8010b5d8
  if((p->pgdir = setupkvm()) == 0)
80103f03:	e8 38 39 00 00       	call   80107840 <setupkvm>
80103f08:	89 43 04             	mov    %eax,0x4(%ebx)
80103f0b:	85 c0                	test   %eax,%eax
80103f0d:	0f 84 c5 00 00 00    	je     80103fd8 <userinit+0xe8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f13:	83 ec 04             	sub    $0x4,%esp
80103f16:	68 2c 00 00 00       	push   $0x2c
80103f1b:	68 60 b4 10 80       	push   $0x8010b460
80103f20:	50                   	push   %eax
80103f21:	e8 ea 34 00 00       	call   80107410 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f26:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103f2f:	6a 4c                	push   $0x4c
80103f31:	6a 00                	push   $0x0
80103f33:	ff 73 18             	pushl  0x18(%ebx)
80103f36:	e8 b5 0d 00 00       	call   80104cf0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103f3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f43:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f46:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103f56:	8b 43 18             	mov    0x18(%ebx),%eax
80103f59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103f61:	8b 43 18             	mov    0x18(%ebx),%eax
80103f64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103f6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103f6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103f76:	8b 43 18             	mov    0x18(%ebx),%eax
80103f79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103f80:	8b 43 18             	mov    0x18(%ebx),%eax
80103f83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f8d:	6a 10                	push   $0x10
80103f8f:	68 65 80 10 80       	push   $0x80108065
80103f94:	50                   	push   %eax
80103f95:	e8 26 0f 00 00       	call   80104ec0 <safestrcpy>
  p->cwd = namei("/");
80103f9a:	c7 04 24 6e 80 10 80 	movl   $0x8010806e,(%esp)
80103fa1:	e8 8a e4 ff ff       	call   80102430 <namei>
80103fa6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103fa9:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80103fb0:	e8 cb 0b 00 00       	call   80104b80 <acquire>
  p->state = RUNNABLE;
80103fb5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  qpush(p);
80103fbc:	89 1c 24             	mov    %ebx,(%esp)
80103fbf:	e8 2c fe ff ff       	call   80103df0 <qpush>
  release(&ptable.lock);
80103fc4:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80103fcb:	e8 d0 0c 00 00       	call   80104ca0 <release>
}
80103fd0:	83 c4 10             	add    $0x10,%esp
80103fd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fd6:	c9                   	leave  
80103fd7:	c3                   	ret    
    panic("userinit: out of memory?");
80103fd8:	83 ec 0c             	sub    $0xc,%esp
80103fdb:	68 4c 80 10 80       	push   $0x8010804c
80103fe0:	e8 fb c3 ff ff       	call   801003e0 <panic>
80103fe5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ff0 <releaseshared>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	56                   	push   %esi
80103ff4:	53                   	push   %ebx
80103ff5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103ff8:	e8 33 0b 00 00       	call   80104b30 <pushcli>
  c = mycpu();
80103ffd:	e8 1e fd ff ff       	call   80103d20 <mycpu>
  p = c->proc;
80104002:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104008:	e8 33 0c 00 00       	call   80104c40 <popcli>
  if(curproc->sharedrec[idx]!='s')
8010400d:	80 bc 1e 88 00 00 00 	cmpb   $0x73,0x88(%esi,%ebx,1)
80104014:	73 
80104015:	74 09                	je     80104020 <releaseshared+0x30>
}
80104017:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010401a:	31 c0                	xor    %eax,%eax
8010401c:	5b                   	pop    %ebx
8010401d:	5e                   	pop    %esi
8010401e:	5d                   	pop    %ebp
8010401f:	c3                   	ret    
  desharevm(idx);
80104020:	83 ec 0c             	sub    $0xc,%esp
  curproc->sharedrec[idx]=0;
80104023:	c6 84 1e 88 00 00 00 	movb   $0x0,0x88(%esi,%ebx,1)
8010402a:	00 
  desharevm(idx);
8010402b:	53                   	push   %ebx
8010402c:	e8 4f 37 00 00       	call   80107780 <desharevm>
  return 0;
80104031:	83 c4 10             	add    $0x10,%esp
}
80104034:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104037:	31 c0                	xor    %eax,%eax
80104039:	5b                   	pop    %ebx
8010403a:	5e                   	pop    %esi
8010403b:	5d                   	pop    %ebp
8010403c:	c3                   	ret    
8010403d:	8d 76 00             	lea    0x0(%esi),%esi

80104040 <getshared>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	57                   	push   %edi
80104044:	56                   	push   %esi
80104045:	be 00 00 00 80       	mov    $0x80000000,%esi
8010404a:	53                   	push   %ebx
8010404b:	83 ec 0c             	sub    $0xc,%esp
8010404e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104051:	e8 da 0a 00 00       	call   80104b30 <pushcli>
  c = mycpu();
80104056:	e8 c5 fc ff ff       	call   80103d20 <mycpu>
  p = c->proc;
8010405b:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104061:	e8 da 0b 00 00       	call   80104c40 <popcli>
  if(curproc->sharedrec[idx]=='s'){
80104066:	8d 43 01             	lea    0x1(%ebx),%eax
80104069:	c1 e0 0c             	shl    $0xc,%eax
8010406c:	29 c6                	sub    %eax,%esi
8010406e:	80 bc 1f 88 00 00 00 	cmpb   $0x73,0x88(%edi,%ebx,1)
80104075:	73 
80104076:	74 1f                	je     80104097 <getshared+0x57>
  sharevm(curproc->pgdir, idx);
80104078:	83 ec 08             	sub    $0x8,%esp
8010407b:	53                   	push   %ebx
8010407c:	ff 77 04             	pushl  0x4(%edi)
8010407f:	e8 cc 34 00 00       	call   80107550 <sharevm>
  curproc->sharedrec[idx]='s';
80104084:	c6 84 1f 88 00 00 00 	movb   $0x73,0x88(%edi,%ebx,1)
8010408b:	73 
  switchuvm(curproc);
8010408c:	89 3c 24             	mov    %edi,(%esp)
8010408f:	e8 6c 32 00 00       	call   80107300 <switchuvm>
  return (char*)KERNBASE-(idx+1)*PGSIZE;
80104094:	83 c4 10             	add    $0x10,%esp
}
80104097:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010409a:	89 f0                	mov    %esi,%eax
8010409c:	5b                   	pop    %ebx
8010409d:	5e                   	pop    %esi
8010409e:	5f                   	pop    %edi
8010409f:	5d                   	pop    %ebp
801040a0:	c3                   	ret    
801040a1:	eb 0d                	jmp    801040b0 <growproc>
801040a3:	90                   	nop
801040a4:	90                   	nop
801040a5:	90                   	nop
801040a6:	90                   	nop
801040a7:	90                   	nop
801040a8:	90                   	nop
801040a9:	90                   	nop
801040aa:	90                   	nop
801040ab:	90                   	nop
801040ac:	90                   	nop
801040ad:	90                   	nop
801040ae:	90                   	nop
801040af:	90                   	nop

801040b0 <growproc>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	56                   	push   %esi
801040b4:	53                   	push   %ebx
801040b5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801040b8:	e8 73 0a 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801040bd:	e8 5e fc ff ff       	call   80103d20 <mycpu>
  p = c->proc;
801040c2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040c8:	e8 73 0b 00 00       	call   80104c40 <popcli>
  sz = curproc->sz;
801040cd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801040cf:	85 f6                	test   %esi,%esi
801040d1:	7f 1d                	jg     801040f0 <growproc+0x40>
  } else if(n < 0){
801040d3:	75 3b                	jne    80104110 <growproc+0x60>
  switchuvm(curproc);
801040d5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801040d8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801040da:	53                   	push   %ebx
801040db:	e8 20 32 00 00       	call   80107300 <switchuvm>
  return 0;
801040e0:	83 c4 10             	add    $0x10,%esp
801040e3:	31 c0                	xor    %eax,%eax
}
801040e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040e8:	5b                   	pop    %ebx
801040e9:	5e                   	pop    %esi
801040ea:	5d                   	pop    %ebp
801040eb:	c3                   	ret    
801040ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801040f0:	83 ec 04             	sub    $0x4,%esp
801040f3:	01 c6                	add    %eax,%esi
801040f5:	56                   	push   %esi
801040f6:	50                   	push   %eax
801040f7:	ff 73 04             	pushl  0x4(%ebx)
801040fa:	e8 31 35 00 00       	call   80107630 <allocuvm>
801040ff:	83 c4 10             	add    $0x10,%esp
80104102:	85 c0                	test   %eax,%eax
80104104:	75 cf                	jne    801040d5 <growproc+0x25>
      return -1;
80104106:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010410b:	eb d8                	jmp    801040e5 <growproc+0x35>
8010410d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104110:	83 ec 04             	sub    $0x4,%esp
80104113:	01 c6                	add    %eax,%esi
80104115:	56                   	push   %esi
80104116:	50                   	push   %eax
80104117:	ff 73 04             	pushl  0x4(%ebx)
8010411a:	e8 31 36 00 00       	call   80107750 <deallocuvm>
8010411f:	83 c4 10             	add    $0x10,%esp
80104122:	85 c0                	test   %eax,%eax
80104124:	75 af                	jne    801040d5 <growproc+0x25>
80104126:	eb de                	jmp    80104106 <growproc+0x56>
80104128:	90                   	nop
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104130 <fork>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	57                   	push   %edi
80104134:	56                   	push   %esi
80104135:	53                   	push   %ebx
80104136:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104139:	e8 f2 09 00 00       	call   80104b30 <pushcli>
  c = mycpu();
8010413e:	e8 dd fb ff ff       	call   80103d20 <mycpu>
  p = c->proc;
80104143:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104149:	e8 f2 0a 00 00       	call   80104c40 <popcli>
  if((np = allocproc()) == 0){
8010414e:	e8 6d fa ff ff       	call   80103bc0 <allocproc>
80104153:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104156:	85 c0                	test   %eax,%eax
80104158:	0f 84 df 00 00 00    	je     8010423d <fork+0x10d>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010415e:	83 ec 08             	sub    $0x8,%esp
80104161:	ff 33                	pushl  (%ebx)
80104163:	89 c7                	mov    %eax,%edi
80104165:	ff 73 04             	pushl  0x4(%ebx)
80104168:	e8 a3 37 00 00       	call   80107910 <copyuvm>
8010416d:	83 c4 10             	add    $0x10,%esp
80104170:	89 47 04             	mov    %eax,0x4(%edi)
80104173:	85 c0                	test   %eax,%eax
80104175:	0f 84 c9 00 00 00    	je     80104244 <fork+0x114>
  np->sz = curproc->sz;
8010417b:	8b 03                	mov    (%ebx),%eax
8010417d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80104180:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80104185:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80104187:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
8010418a:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
8010418d:	8b 73 18             	mov    0x18(%ebx),%esi
80104190:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104192:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104194:	8b 42 18             	mov    0x18(%edx),%eax
80104197:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010419e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
801041a0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801041a4:	85 c0                	test   %eax,%eax
801041a6:	74 13                	je     801041bb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	50                   	push   %eax
801041ac:	e8 ff d0 ff ff       	call   801012b0 <filedup>
801041b1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801041b4:	83 c4 10             	add    $0x10,%esp
801041b7:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801041bb:	83 c6 01             	add    $0x1,%esi
801041be:	83 fe 10             	cmp    $0x10,%esi
801041c1:	75 dd                	jne    801041a0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801041c3:	83 ec 0c             	sub    $0xc,%esp
801041c6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041c9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801041cc:	e8 8f d9 ff ff       	call   80101b60 <idup>
801041d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041d4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801041d7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041da:	8d 47 6c             	lea    0x6c(%edi),%eax
801041dd:	6a 10                	push   $0x10
801041df:	53                   	push   %ebx
801041e0:	50                   	push   %eax
801041e1:	e8 da 0c 00 00       	call   80104ec0 <safestrcpy>
  pid = np->pid;
801041e6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801041e9:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
801041f0:	e8 8b 09 00 00       	call   80104b80 <acquire>
  np->state = RUNNABLE;
801041f5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  qpush(np);
801041fc:	89 3c 24             	mov    %edi,(%esp)
801041ff:	e8 ec fb ff ff       	call   80103df0 <qpush>
  for(i=1;i<MAXSHAREDPG;i++)
80104204:	8d 87 89 00 00 00    	lea    0x89(%edi),%eax
8010420a:	8d 97 92 00 00 00    	lea    0x92(%edi),%edx
80104210:	83 c4 10             	add    $0x10,%esp
80104213:	90                   	nop
80104214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->sharedrec[i]=0;
80104218:	c6 00 00             	movb   $0x0,(%eax)
8010421b:	83 c0 01             	add    $0x1,%eax
  for(i=1;i<MAXSHAREDPG;i++)
8010421e:	39 c2                	cmp    %eax,%edx
80104220:	75 f6                	jne    80104218 <fork+0xe8>
  asm volatile("cli");
80104222:	fa                   	cli    
  release(&ptable.lock);
80104223:	83 ec 0c             	sub    $0xc,%esp
80104226:	68 00 3e 11 80       	push   $0x80113e00
8010422b:	e8 70 0a 00 00       	call   80104ca0 <release>
  return pid;
80104230:	83 c4 10             	add    $0x10,%esp
}
80104233:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104236:	89 d8                	mov    %ebx,%eax
80104238:	5b                   	pop    %ebx
80104239:	5e                   	pop    %esi
8010423a:	5f                   	pop    %edi
8010423b:	5d                   	pop    %ebp
8010423c:	c3                   	ret    
    return -1;
8010423d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104242:	eb ef                	jmp    80104233 <fork+0x103>
    kfree(np->kstack);
80104244:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104247:	83 ec 0c             	sub    $0xc,%esp
8010424a:	ff 73 08             	pushl  0x8(%ebx)
8010424d:	e8 0e e6 ff ff       	call   80102860 <kfree>
    np->kstack = 0;
80104252:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104259:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010425c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104263:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104268:	eb c9                	jmp    80104233 <fork+0x103>
8010426a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104270 <schedulerR>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	57                   	push   %edi
80104274:	56                   	push   %esi
80104275:	53                   	push   %ebx
80104276:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104279:	e8 a2 fa ff ff       	call   80103d20 <mycpu>
  c->proc = 0;
8010427e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104285:	00 00 00 
  struct cpu *c = mycpu();
80104288:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010428a:	8d 78 04             	lea    0x4(%eax),%edi
8010428d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104290:	fb                   	sti    
    acquire(&ptable.lock);
80104291:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104294:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
    acquire(&ptable.lock);
80104299:	68 00 3e 11 80       	push   $0x80113e00
8010429e:	e8 dd 08 00 00       	call   80104b80 <acquire>
801042a3:	83 c4 10             	add    $0x10,%esp
801042a6:	8d 76 00             	lea    0x0(%esi),%esi
801042a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801042b0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801042b4:	75 33                	jne    801042e9 <schedulerR+0x79>
      switchuvm(p);
801042b6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801042b9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801042bf:	53                   	push   %ebx
801042c0:	e8 3b 30 00 00       	call   80107300 <switchuvm>
      swtch(&(c->scheduler), p->context);
801042c5:	58                   	pop    %eax
801042c6:	5a                   	pop    %edx
801042c7:	ff 73 1c             	pushl  0x1c(%ebx)
801042ca:	57                   	push   %edi
      p->state = RUNNING;
801042cb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801042d2:	e8 44 0c 00 00       	call   80104f1b <swtch>
      switchkvm();
801042d7:	e8 14 30 00 00       	call   801072f0 <switchkvm>
      c->proc = 0;
801042dc:	83 c4 10             	add    $0x10,%esp
801042df:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801042e6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e9:	81 c3 98 00 00 00    	add    $0x98,%ebx
801042ef:	81 fb 34 64 11 80    	cmp    $0x80116434,%ebx
801042f5:	75 b9                	jne    801042b0 <schedulerR+0x40>
    release(&ptable.lock);
801042f7:	83 ec 0c             	sub    $0xc,%esp
801042fa:	68 00 3e 11 80       	push   $0x80113e00
801042ff:	e8 9c 09 00 00       	call   80104ca0 <release>
    sti();
80104304:	83 c4 10             	add    $0x10,%esp
80104307:	eb 87                	jmp    80104290 <schedulerR+0x20>
80104309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104310 <scheduler>:
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	56                   	push   %esi
80104315:	53                   	push   %ebx
80104316:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80104319:	e8 02 fa ff ff       	call   80103d20 <mycpu>
  c->proc = 0;
8010431e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104325:	00 00 00 
  struct cpu *c = mycpu();
80104328:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
8010432a:	8d 70 04             	lea    0x4(%eax),%esi
8010432d:	8d 76 00             	lea    0x0(%esi),%esi
80104330:	fb                   	sti    
    acquire(&ptable.lock);
80104331:	83 ec 0c             	sub    $0xc,%esp
80104334:	68 00 3e 11 80       	push   $0x80113e00
80104339:	e8 42 08 00 00       	call   80104b80 <acquire>
8010433e:	83 c4 10             	add    $0x10,%esp
    int queue=NPROCQ-1;
80104341:	ba 02 00 00 00       	mov    $0x2,%edx
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80104346:	8b 04 95 4c 64 11 80 	mov    -0x7fee9bb4(,%edx,4),%eax
8010434d:	85 c0                	test   %eax,%eax
8010434f:	74 33                	je     80104384 <scheduler+0x74>
80104351:	8b 3c d5 34 64 11 80 	mov    -0x7fee9bcc(,%edx,8),%edi
80104358:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
8010435c:	75 10                	jne    8010436e <scheduler+0x5e>
8010435e:	e9 ac 00 00 00       	jmp    8010440f <scheduler+0xff>
80104363:	90                   	nop
80104364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104368:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
8010436c:	74 32                	je     801043a0 <scheduler+0x90>
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
8010436e:	8b 7f 7c             	mov    0x7c(%edi),%edi
        ptable.count[queue]--;
80104371:	83 e8 01             	sub    $0x1,%eax
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
80104374:	89 3c d5 34 64 11 80 	mov    %edi,-0x7fee9bcc(,%edx,8)
        ptable.count[queue]--;
8010437b:	89 04 95 4c 64 11 80 	mov    %eax,-0x7fee9bb4(,%edx,4)
      while((ptable.count[queue]>0)&&(ptable.pqueue[queue].head->state!=RUNNABLE))
80104382:	75 e4                	jne    80104368 <scheduler+0x58>
    for(;queue>=0;queue--)
80104384:	83 ea 01             	sub    $0x1,%edx
80104387:	83 fa ff             	cmp    $0xffffffff,%edx
8010438a:	75 ba                	jne    80104346 <scheduler+0x36>
    release(&ptable.lock);
8010438c:	83 ec 0c             	sub    $0xc,%esp
8010438f:	68 00 3e 11 80       	push   $0x80113e00
80104394:	e8 07 09 00 00       	call   80104ca0 <release>
  for(;;){
80104399:	83 c4 10             	add    $0x10,%esp
8010439c:	eb 92                	jmp    80104330 <scheduler+0x20>
8010439e:	66 90                	xchg   %ax,%ax
801043a0:	8d 8a c6 04 00 00    	lea    0x4c6(%edx),%ecx
801043a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043a9:	8b 3c cd 04 3e 11 80 	mov    -0x7feec1fc(,%ecx,8),%edi
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
801043b0:	8b 47 7c             	mov    0x7c(%edi),%eax
        switchuvm(p);
801043b3:	83 ec 0c             	sub    $0xc,%esp
        ptable.pqueue[queue].head=ptable.pqueue[queue].head->next;
801043b6:	89 04 cd 04 3e 11 80 	mov    %eax,-0x7feec1fc(,%ecx,8)
        ptable.count[queue]--;
801043bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043c0:	83 e8 01             	sub    $0x1,%eax
801043c3:	89 04 95 4c 64 11 80 	mov    %eax,-0x7fee9bb4(,%edx,4)
        c->proc = p;
801043ca:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(p);
801043d0:	57                   	push   %edi
801043d1:	e8 2a 2f 00 00       	call   80107300 <switchuvm>
        p->state = RUNNING;
801043d6:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&(c->scheduler), p->context);
801043dd:	58                   	pop    %eax
801043de:	5a                   	pop    %edx
801043df:	ff 77 1c             	pushl  0x1c(%edi)
801043e2:	56                   	push   %esi
801043e3:	e8 33 0b 00 00       	call   80104f1b <swtch>
        switchkvm();
801043e8:	e8 03 2f 00 00       	call   801072f0 <switchkvm>
        break;
801043ed:	83 c4 10             	add    $0x10,%esp
        c->proc = 0;
801043f0:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801043f7:	00 00 00 
    release(&ptable.lock);
801043fa:	83 ec 0c             	sub    $0xc,%esp
801043fd:	68 00 3e 11 80       	push   $0x80113e00
80104402:	e8 99 08 00 00       	call   80104ca0 <release>
  for(;;){
80104407:	83 c4 10             	add    $0x10,%esp
8010440a:	e9 21 ff ff ff       	jmp    80104330 <scheduler+0x20>
8010440f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104412:	8d 8a c6 04 00 00    	lea    0x4c6(%edx),%ecx
80104418:	eb 96                	jmp    801043b0 <scheduler+0xa0>
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104420 <sched>:
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
  pushcli();
80104425:	e8 06 07 00 00       	call   80104b30 <pushcli>
  c = mycpu();
8010442a:	e8 f1 f8 ff ff       	call   80103d20 <mycpu>
  p = c->proc;
8010442f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104435:	e8 06 08 00 00       	call   80104c40 <popcli>
  if(!holding(&ptable.lock))
8010443a:	83 ec 0c             	sub    $0xc,%esp
8010443d:	68 00 3e 11 80       	push   $0x80113e00
80104442:	e8 a9 06 00 00       	call   80104af0 <holding>
80104447:	83 c4 10             	add    $0x10,%esp
8010444a:	85 c0                	test   %eax,%eax
8010444c:	74 4f                	je     8010449d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010444e:	e8 cd f8 ff ff       	call   80103d20 <mycpu>
80104453:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010445a:	75 68                	jne    801044c4 <sched+0xa4>
  if(p->state == RUNNING)
8010445c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104460:	74 55                	je     801044b7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104462:	9c                   	pushf  
80104463:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104464:	f6 c4 02             	test   $0x2,%ah
80104467:	75 41                	jne    801044aa <sched+0x8a>
  intena = mycpu()->intena;
80104469:	e8 b2 f8 ff ff       	call   80103d20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010446e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104471:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104477:	e8 a4 f8 ff ff       	call   80103d20 <mycpu>
8010447c:	83 ec 08             	sub    $0x8,%esp
8010447f:	ff 70 04             	pushl  0x4(%eax)
80104482:	53                   	push   %ebx
80104483:	e8 93 0a 00 00       	call   80104f1b <swtch>
  mycpu()->intena = intena;
80104488:	e8 93 f8 ff ff       	call   80103d20 <mycpu>
}
8010448d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104490:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104496:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104499:	5b                   	pop    %ebx
8010449a:	5e                   	pop    %esi
8010449b:	5d                   	pop    %ebp
8010449c:	c3                   	ret    
    panic("sched ptable.lock");
8010449d:	83 ec 0c             	sub    $0xc,%esp
801044a0:	68 70 80 10 80       	push   $0x80108070
801044a5:	e8 36 bf ff ff       	call   801003e0 <panic>
    panic("sched interruptible");
801044aa:	83 ec 0c             	sub    $0xc,%esp
801044ad:	68 9c 80 10 80       	push   $0x8010809c
801044b2:	e8 29 bf ff ff       	call   801003e0 <panic>
    panic("sched running");
801044b7:	83 ec 0c             	sub    $0xc,%esp
801044ba:	68 8e 80 10 80       	push   $0x8010808e
801044bf:	e8 1c bf ff ff       	call   801003e0 <panic>
    panic("sched locks");
801044c4:	83 ec 0c             	sub    $0xc,%esp
801044c7:	68 82 80 10 80       	push   $0x80108082
801044cc:	e8 0f bf ff ff       	call   801003e0 <panic>
801044d1:	eb 0d                	jmp    801044e0 <exit>
801044d3:	90                   	nop
801044d4:	90                   	nop
801044d5:	90                   	nop
801044d6:	90                   	nop
801044d7:	90                   	nop
801044d8:	90                   	nop
801044d9:	90                   	nop
801044da:	90                   	nop
801044db:	90                   	nop
801044dc:	90                   	nop
801044dd:	90                   	nop
801044de:	90                   	nop
801044df:	90                   	nop

801044e0 <exit>:
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	56                   	push   %esi
801044e5:	53                   	push   %ebx
801044e6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801044e9:	e8 42 06 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801044ee:	e8 2d f8 ff ff       	call   80103d20 <mycpu>
  p = c->proc;
801044f3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044f9:	e8 42 07 00 00       	call   80104c40 <popcli>
  if(curproc == initproc)
801044fe:	8d 5e 28             	lea    0x28(%esi),%ebx
80104501:	8d 7e 68             	lea    0x68(%esi),%edi
80104504:	39 35 d8 b5 10 80    	cmp    %esi,0x8010b5d8
8010450a:	0f 84 b1 00 00 00    	je     801045c1 <exit+0xe1>
    if(curproc->ofile[fd]){
80104510:	8b 03                	mov    (%ebx),%eax
80104512:	85 c0                	test   %eax,%eax
80104514:	74 12                	je     80104528 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104516:	83 ec 0c             	sub    $0xc,%esp
80104519:	50                   	push   %eax
8010451a:	e8 e1 cd ff ff       	call   80101300 <fileclose>
      curproc->ofile[fd] = 0;
8010451f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104525:	83 c4 10             	add    $0x10,%esp
80104528:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010452b:	39 fb                	cmp    %edi,%ebx
8010452d:	75 e1                	jne    80104510 <exit+0x30>
  begin_op();
8010452f:	e8 dc eb ff ff       	call   80103110 <begin_op>
  iput(curproc->cwd);
80104534:	83 ec 0c             	sub    $0xc,%esp
80104537:	ff 76 68             	pushl  0x68(%esi)
8010453a:	e8 81 d7 ff ff       	call   80101cc0 <iput>
  end_op();
8010453f:	e8 3c ec ff ff       	call   80103180 <end_op>
  curproc->cwd = 0;
80104544:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  asm volatile("cli");
8010454b:	fa                   	cli    
  acquire(&ptable.lock);
8010454c:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104553:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
  acquire(&ptable.lock);
80104558:	e8 23 06 00 00       	call   80104b80 <acquire>
  wakeup1(curproc->parent);
8010455d:	8b 46 14             	mov    0x14(%esi),%eax
80104560:	e8 1b f9 ff ff       	call   80103e80 <wakeup1>
80104565:	83 c4 10             	add    $0x10,%esp
80104568:	eb 14                	jmp    8010457e <exit+0x9e>
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104570:	81 c3 98 00 00 00    	add    $0x98,%ebx
80104576:	81 fb 34 64 11 80    	cmp    $0x80116434,%ebx
8010457c:	74 2a                	je     801045a8 <exit+0xc8>
    if(p->parent == curproc){
8010457e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104581:	75 ed                	jne    80104570 <exit+0x90>
      p->parent = initproc;
80104583:	a1 d8 b5 10 80       	mov    0x8010b5d8,%eax
      if(p->state == ZOMBIE)
80104588:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
8010458c:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
8010458f:	75 df                	jne    80104570 <exit+0x90>
        wakeup1(initproc);
80104591:	e8 ea f8 ff ff       	call   80103e80 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104596:	81 c3 98 00 00 00    	add    $0x98,%ebx
8010459c:	81 fb 34 64 11 80    	cmp    $0x80116434,%ebx
801045a2:	75 da                	jne    8010457e <exit+0x9e>
801045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
801045a8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801045af:	e8 6c fe ff ff       	call   80104420 <sched>
  panic("zombie exit");
801045b4:	83 ec 0c             	sub    $0xc,%esp
801045b7:	68 bd 80 10 80       	push   $0x801080bd
801045bc:	e8 1f be ff ff       	call   801003e0 <panic>
    panic("init exiting");
801045c1:	83 ec 0c             	sub    $0xc,%esp
801045c4:	68 b0 80 10 80       	push   $0x801080b0
801045c9:	e8 12 be ff ff       	call   801003e0 <panic>
801045ce:	66 90                	xchg   %ax,%ax

801045d0 <yield>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801045d7:	e8 54 05 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801045dc:	e8 3f f7 ff ff       	call   80103d20 <mycpu>
  p = c->proc;
801045e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045e7:	e8 54 06 00 00       	call   80104c40 <popcli>
  acquire(&ptable.lock);  //DOC: yieldlock
801045ec:	83 ec 0c             	sub    $0xc,%esp
801045ef:	68 00 3e 11 80       	push   $0x80113e00
801045f4:	e8 87 05 00 00       	call   80104b80 <acquire>
  if(p->priority>0)
801045f9:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  p->state = RUNNABLE;
801045ff:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  if(p->priority>0)
80104606:	83 c4 10             	add    $0x10,%esp
80104609:	85 c0                	test   %eax,%eax
8010460b:	74 09                	je     80104616 <yield+0x46>
    p->priority--;
8010460d:	83 e8 01             	sub    $0x1,%eax
80104610:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  qpush(p);
80104616:	83 ec 0c             	sub    $0xc,%esp
80104619:	53                   	push   %ebx
8010461a:	e8 d1 f7 ff ff       	call   80103df0 <qpush>
  sched();
8010461f:	e8 fc fd ff ff       	call   80104420 <sched>
  release(&ptable.lock);
80104624:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
8010462b:	e8 70 06 00 00       	call   80104ca0 <release>
}
80104630:	83 c4 10             	add    $0x10,%esp
80104633:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104636:	c9                   	leave  
80104637:	c3                   	ret    
80104638:	90                   	nop
80104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104640 <sleep>:
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	57                   	push   %edi
80104644:	56                   	push   %esi
80104645:	53                   	push   %ebx
80104646:	83 ec 0c             	sub    $0xc,%esp
80104649:	8b 7d 08             	mov    0x8(%ebp),%edi
8010464c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010464f:	e8 dc 04 00 00       	call   80104b30 <pushcli>
  c = mycpu();
80104654:	e8 c7 f6 ff ff       	call   80103d20 <mycpu>
  p = c->proc;
80104659:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010465f:	e8 dc 05 00 00       	call   80104c40 <popcli>
  if(p == 0)
80104664:	85 db                	test   %ebx,%ebx
80104666:	0f 84 87 00 00 00    	je     801046f3 <sleep+0xb3>
  if(lk == 0)
8010466c:	85 f6                	test   %esi,%esi
8010466e:	74 76                	je     801046e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104670:	81 fe 00 3e 11 80    	cmp    $0x80113e00,%esi
80104676:	74 50                	je     801046c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	68 00 3e 11 80       	push   $0x80113e00
80104680:	e8 fb 04 00 00       	call   80104b80 <acquire>
    release(lk);
80104685:	89 34 24             	mov    %esi,(%esp)
80104688:	e8 13 06 00 00       	call   80104ca0 <release>
  p->chan = chan;
8010468d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104690:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104697:	e8 84 fd ff ff       	call   80104420 <sched>
  p->chan = 0;
8010469c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801046a3:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
801046aa:	e8 f1 05 00 00       	call   80104ca0 <release>
    acquire(lk);
801046af:	89 75 08             	mov    %esi,0x8(%ebp)
801046b2:	83 c4 10             	add    $0x10,%esp
}
801046b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046b8:	5b                   	pop    %ebx
801046b9:	5e                   	pop    %esi
801046ba:	5f                   	pop    %edi
801046bb:	5d                   	pop    %ebp
    acquire(lk);
801046bc:	e9 bf 04 00 00       	jmp    80104b80 <acquire>
801046c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801046c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801046cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046d2:	e8 49 fd ff ff       	call   80104420 <sched>
  p->chan = 0;
801046d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801046de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046e1:	5b                   	pop    %ebx
801046e2:	5e                   	pop    %esi
801046e3:	5f                   	pop    %edi
801046e4:	5d                   	pop    %ebp
801046e5:	c3                   	ret    
    panic("sleep without lk");
801046e6:	83 ec 0c             	sub    $0xc,%esp
801046e9:	68 cf 80 10 80       	push   $0x801080cf
801046ee:	e8 ed bc ff ff       	call   801003e0 <panic>
    panic("sleep");
801046f3:	83 ec 0c             	sub    $0xc,%esp
801046f6:	68 c9 80 10 80       	push   $0x801080c9
801046fb:	e8 e0 bc ff ff       	call   801003e0 <panic>

80104700 <wait>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
  pushcli();
80104705:	e8 26 04 00 00       	call   80104b30 <pushcli>
  c = mycpu();
8010470a:	e8 11 f6 ff ff       	call   80103d20 <mycpu>
  p = c->proc;
8010470f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104715:	e8 26 05 00 00       	call   80104c40 <popcli>
  acquire(&ptable.lock);
8010471a:	83 ec 0c             	sub    $0xc,%esp
8010471d:	68 00 3e 11 80       	push   $0x80113e00
80104722:	e8 59 04 00 00       	call   80104b80 <acquire>
80104727:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010472a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010472c:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
80104731:	eb 13                	jmp    80104746 <wait+0x46>
80104733:	90                   	nop
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104738:	81 c3 98 00 00 00    	add    $0x98,%ebx
8010473e:	81 fb 34 64 11 80    	cmp    $0x80116434,%ebx
80104744:	74 1e                	je     80104764 <wait+0x64>
      if(p->parent != curproc)
80104746:	39 73 14             	cmp    %esi,0x14(%ebx)
80104749:	75 ed                	jne    80104738 <wait+0x38>
      if(p->state == ZOMBIE){
8010474b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010474f:	74 37                	je     80104788 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104751:	81 c3 98 00 00 00    	add    $0x98,%ebx
      havekids = 1;
80104757:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010475c:	81 fb 34 64 11 80    	cmp    $0x80116434,%ebx
80104762:	75 e2                	jne    80104746 <wait+0x46>
    if(!havekids || curproc->killed){
80104764:	85 c0                	test   %eax,%eax
80104766:	74 76                	je     801047de <wait+0xde>
80104768:	8b 46 24             	mov    0x24(%esi),%eax
8010476b:	85 c0                	test   %eax,%eax
8010476d:	75 6f                	jne    801047de <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010476f:	83 ec 08             	sub    $0x8,%esp
80104772:	68 00 3e 11 80       	push   $0x80113e00
80104777:	56                   	push   %esi
80104778:	e8 c3 fe ff ff       	call   80104640 <sleep>
    havekids = 0;
8010477d:	83 c4 10             	add    $0x10,%esp
80104780:	eb a8                	jmp    8010472a <wait+0x2a>
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104788:	83 ec 0c             	sub    $0xc,%esp
8010478b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010478e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104791:	e8 ca e0 ff ff       	call   80102860 <kfree>
        freevm(p->pgdir);
80104796:	5a                   	pop    %edx
80104797:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010479a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801047a1:	e8 1a 30 00 00       	call   801077c0 <freevm>
        release(&ptable.lock);
801047a6:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
        p->pid = 0;
801047ad:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801047b4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801047bb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801047bf:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801047c6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801047cd:	e8 ce 04 00 00       	call   80104ca0 <release>
        return pid;
801047d2:	83 c4 10             	add    $0x10,%esp
}
801047d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d8:	89 f0                	mov    %esi,%eax
801047da:	5b                   	pop    %ebx
801047db:	5e                   	pop    %esi
801047dc:	5d                   	pop    %ebp
801047dd:	c3                   	ret    
      release(&ptable.lock);
801047de:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801047e1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801047e6:	68 00 3e 11 80       	push   $0x80113e00
801047eb:	e8 b0 04 00 00       	call   80104ca0 <release>
      return -1;
801047f0:	83 c4 10             	add    $0x10,%esp
801047f3:	eb e0                	jmp    801047d5 <wait+0xd5>
801047f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	83 ec 10             	sub    $0x10,%esp
80104807:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010480a:	68 00 3e 11 80       	push   $0x80113e00
8010480f:	e8 6c 03 00 00       	call   80104b80 <acquire>
  wakeup1(chan);
80104814:	89 d8                	mov    %ebx,%eax
80104816:	e8 65 f6 ff ff       	call   80103e80 <wakeup1>
  release(&ptable.lock);
8010481b:	83 c4 10             	add    $0x10,%esp
8010481e:	c7 45 08 00 3e 11 80 	movl   $0x80113e00,0x8(%ebp)
}
80104825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104828:	c9                   	leave  
  release(&ptable.lock);
80104829:	e9 72 04 00 00       	jmp    80104ca0 <release>
8010482e:	66 90                	xchg   %ax,%ax

80104830 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 10             	sub    $0x10,%esp
80104837:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010483a:	68 00 3e 11 80       	push   $0x80113e00
8010483f:	e8 3c 03 00 00       	call   80104b80 <acquire>
80104844:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104847:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
8010484c:	eb 0e                	jmp    8010485c <kill+0x2c>
8010484e:	66 90                	xchg   %ax,%ax
80104850:	05 98 00 00 00       	add    $0x98,%eax
80104855:	3d 34 64 11 80       	cmp    $0x80116434,%eax
8010485a:	74 34                	je     80104890 <kill+0x60>
    if(p->pid == pid){
8010485c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010485f:	75 ef                	jne    80104850 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104861:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104865:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010486c:	75 07                	jne    80104875 <kill+0x45>
        p->state = RUNNABLE;
8010486e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104875:	83 ec 0c             	sub    $0xc,%esp
80104878:	68 00 3e 11 80       	push   $0x80113e00
8010487d:	e8 1e 04 00 00       	call   80104ca0 <release>
      return 0;
80104882:	83 c4 10             	add    $0x10,%esp
80104885:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010488a:	c9                   	leave  
8010488b:	c3                   	ret    
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104890:	83 ec 0c             	sub    $0xc,%esp
80104893:	68 00 3e 11 80       	push   $0x80113e00
80104898:	e8 03 04 00 00       	call   80104ca0 <release>
  return -1;
8010489d:	83 c4 10             	add    $0x10,%esp
801048a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048a8:	c9                   	leave  
801048a9:	c3                   	ret    
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	56                   	push   %esi
801048b5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801048b8:	53                   	push   %ebx
801048b9:	bb a0 3e 11 80       	mov    $0x80113ea0,%ebx
801048be:	83 ec 3c             	sub    $0x3c,%esp
801048c1:	eb 27                	jmp    801048ea <procdump+0x3a>
801048c3:	90                   	nop
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801048c8:	83 ec 0c             	sub    $0xc,%esp
801048cb:	68 79 84 10 80       	push   $0x80108479
801048d0:	e8 1b be ff ff       	call   801006f0 <cprintf>
801048d5:	83 c4 10             	add    $0x10,%esp
801048d8:	81 c3 98 00 00 00    	add    $0x98,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048de:	81 fb a0 64 11 80    	cmp    $0x801164a0,%ebx
801048e4:	0f 84 7e 00 00 00    	je     80104968 <procdump+0xb8>
    if(p->state == UNUSED)
801048ea:	8b 43 a0             	mov    -0x60(%ebx),%eax
801048ed:	85 c0                	test   %eax,%eax
801048ef:	74 e7                	je     801048d8 <procdump+0x28>
      state = "???";
801048f1:	ba e0 80 10 80       	mov    $0x801080e0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801048f6:	83 f8 05             	cmp    $0x5,%eax
801048f9:	77 11                	ja     8010490c <procdump+0x5c>
801048fb:	8b 14 85 40 81 10 80 	mov    -0x7fef7ec0(,%eax,4),%edx
      state = "???";
80104902:	b8 e0 80 10 80       	mov    $0x801080e0,%eax
80104907:	85 d2                	test   %edx,%edx
80104909:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010490c:	53                   	push   %ebx
8010490d:	52                   	push   %edx
8010490e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104911:	68 e4 80 10 80       	push   $0x801080e4
80104916:	e8 d5 bd ff ff       	call   801006f0 <cprintf>
    if(p->state == SLEEPING){
8010491b:	83 c4 10             	add    $0x10,%esp
8010491e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104922:	75 a4                	jne    801048c8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104924:	83 ec 08             	sub    $0x8,%esp
80104927:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010492a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010492d:	50                   	push   %eax
8010492e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104931:	8b 40 0c             	mov    0xc(%eax),%eax
80104934:	83 c0 08             	add    $0x8,%eax
80104937:	50                   	push   %eax
80104938:	e8 63 01 00 00       	call   80104aa0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010493d:	83 c4 10             	add    $0x10,%esp
80104940:	8b 17                	mov    (%edi),%edx
80104942:	85 d2                	test   %edx,%edx
80104944:	74 82                	je     801048c8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104946:	83 ec 08             	sub    $0x8,%esp
80104949:	83 c7 04             	add    $0x4,%edi
8010494c:	52                   	push   %edx
8010494d:	68 01 7b 10 80       	push   $0x80107b01
80104952:	e8 99 bd ff ff       	call   801006f0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104957:	83 c4 10             	add    $0x10,%esp
8010495a:	39 fe                	cmp    %edi,%esi
8010495c:	75 e2                	jne    80104940 <procdump+0x90>
8010495e:	e9 65 ff ff ff       	jmp    801048c8 <procdump+0x18>
80104963:	90                   	nop
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104968:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010496b:	5b                   	pop    %ebx
8010496c:	5e                   	pop    %esi
8010496d:	5f                   	pop    %edi
8010496e:	5d                   	pop    %ebp
8010496f:	c3                   	ret    

80104970 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 0c             	sub    $0xc,%esp
80104977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010497a:	68 58 81 10 80       	push   $0x80108158
8010497f:	8d 43 04             	lea    0x4(%ebx),%eax
80104982:	50                   	push   %eax
80104983:	e8 f8 00 00 00       	call   80104a80 <initlock>
  lk->name = name;
80104988:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010498b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104991:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104994:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010499b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010499e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a1:	c9                   	leave  
801049a2:	c3                   	ret    
801049a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049b8:	8d 73 04             	lea    0x4(%ebx),%esi
801049bb:	83 ec 0c             	sub    $0xc,%esp
801049be:	56                   	push   %esi
801049bf:	e8 bc 01 00 00       	call   80104b80 <acquire>
  while (lk->locked) {
801049c4:	8b 13                	mov    (%ebx),%edx
801049c6:	83 c4 10             	add    $0x10,%esp
801049c9:	85 d2                	test   %edx,%edx
801049cb:	74 16                	je     801049e3 <acquiresleep+0x33>
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049d0:	83 ec 08             	sub    $0x8,%esp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	e8 66 fc ff ff       	call   80104640 <sleep>
  while (lk->locked) {
801049da:	8b 03                	mov    (%ebx),%eax
801049dc:	83 c4 10             	add    $0x10,%esp
801049df:	85 c0                	test   %eax,%eax
801049e1:	75 ed                	jne    801049d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801049e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049e9:	e8 d2 f3 ff ff       	call   80103dc0 <myproc>
801049ee:	8b 40 10             	mov    0x10(%eax),%eax
801049f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049fa:	5b                   	pop    %ebx
801049fb:	5e                   	pop    %esi
801049fc:	5d                   	pop    %ebp
  release(&lk->lk);
801049fd:	e9 9e 02 00 00       	jmp    80104ca0 <release>
80104a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a10 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	53                   	push   %ebx
80104a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a18:	8d 73 04             	lea    0x4(%ebx),%esi
80104a1b:	83 ec 0c             	sub    $0xc,%esp
80104a1e:	56                   	push   %esi
80104a1f:	e8 5c 01 00 00       	call   80104b80 <acquire>
  lk->locked = 0;
80104a24:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a2a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a31:	89 1c 24             	mov    %ebx,(%esp)
80104a34:	e8 c7 fd ff ff       	call   80104800 <wakeup>
  release(&lk->lk);
80104a39:	89 75 08             	mov    %esi,0x8(%ebp)
80104a3c:	83 c4 10             	add    $0x10,%esp
}
80104a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a42:	5b                   	pop    %ebx
80104a43:	5e                   	pop    %esi
80104a44:	5d                   	pop    %ebp
  release(&lk->lk);
80104a45:	e9 56 02 00 00       	jmp    80104ca0 <release>
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a50 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104a58:	8d 5e 04             	lea    0x4(%esi),%ebx
80104a5b:	83 ec 0c             	sub    $0xc,%esp
80104a5e:	53                   	push   %ebx
80104a5f:	e8 1c 01 00 00       	call   80104b80 <acquire>
  r = lk->locked;
80104a64:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104a66:	89 1c 24             	mov    %ebx,(%esp)
80104a69:	e8 32 02 00 00       	call   80104ca0 <release>
  return r;
}
80104a6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a71:	89 f0                	mov    %esi,%eax
80104a73:	5b                   	pop    %ebx
80104a74:	5e                   	pop    %esi
80104a75:	5d                   	pop    %ebp
80104a76:	c3                   	ret    
80104a77:	66 90                	xchg   %ax,%ax
80104a79:	66 90                	xchg   %ax,%ax
80104a7b:	66 90                	xchg   %ax,%ax
80104a7d:	66 90                	xchg   %ax,%ax
80104a7f:	90                   	nop

80104a80 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a8f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a99:	5d                   	pop    %ebp
80104a9a:	c3                   	ret    
80104a9b:	90                   	nop
80104a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104aa0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104aa0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104aa1:	31 d2                	xor    %edx,%edx
{
80104aa3:	89 e5                	mov    %esp,%ebp
80104aa5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104aa6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104aa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104aac:	83 e8 08             	sub    $0x8,%eax
80104aaf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ab0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ab6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104abc:	77 1a                	ja     80104ad8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104abe:	8b 58 04             	mov    0x4(%eax),%ebx
80104ac1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104ac4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ac7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ac9:	83 fa 0a             	cmp    $0xa,%edx
80104acc:	75 e2                	jne    80104ab0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104ace:	5b                   	pop    %ebx
80104acf:	5d                   	pop    %ebp
80104ad0:	c3                   	ret    
80104ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104adb:	8d 51 28             	lea    0x28(%ecx),%edx
80104ade:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ae6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ae9:	39 c2                	cmp    %eax,%edx
80104aeb:	75 f3                	jne    80104ae0 <getcallerpcs+0x40>
}
80104aed:	5b                   	pop    %ebx
80104aee:	5d                   	pop    %ebp
80104aef:	c3                   	ret    

80104af0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 04             	sub    $0x4,%esp
80104af7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
80104afa:	8b 02                	mov    (%edx),%eax
80104afc:	85 c0                	test   %eax,%eax
80104afe:	75 10                	jne    80104b10 <holding+0x20>
}
80104b00:	83 c4 04             	add    $0x4,%esp
80104b03:	31 c0                	xor    %eax,%eax
80104b05:	5b                   	pop    %ebx
80104b06:	5d                   	pop    %ebp
80104b07:	c3                   	ret    
80104b08:	90                   	nop
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104b10:	8b 5a 08             	mov    0x8(%edx),%ebx
80104b13:	e8 08 f2 ff ff       	call   80103d20 <mycpu>
80104b18:	39 c3                	cmp    %eax,%ebx
80104b1a:	0f 94 c0             	sete   %al
}
80104b1d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104b20:	0f b6 c0             	movzbl %al,%eax
}
80104b23:	5b                   	pop    %ebx
80104b24:	5d                   	pop    %ebp
80104b25:	c3                   	ret    
80104b26:	8d 76 00             	lea    0x0(%esi),%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b30 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b37:	9c                   	pushf  
80104b38:	5b                   	pop    %ebx
  asm volatile("cli");
80104b39:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b3a:	e8 e1 f1 ff ff       	call   80103d20 <mycpu>
80104b3f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b45:	85 c0                	test   %eax,%eax
80104b47:	74 17                	je     80104b60 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104b49:	e8 d2 f1 ff ff       	call   80103d20 <mycpu>
80104b4e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b55:	83 c4 04             	add    $0x4,%esp
80104b58:	5b                   	pop    %ebx
80104b59:	5d                   	pop    %ebp
80104b5a:	c3                   	ret    
80104b5b:	90                   	nop
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    mycpu()->intena = eflags & FL_IF;
80104b60:	e8 bb f1 ff ff       	call   80103d20 <mycpu>
80104b65:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b6b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104b71:	eb d6                	jmp    80104b49 <pushcli+0x19>
80104b73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <acquire>:
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b85:	e8 a6 ff ff ff       	call   80104b30 <pushcli>
  if(holding(lk))
80104b8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104b8d:	8b 03                	mov    (%ebx),%eax
80104b8f:	85 c0                	test   %eax,%eax
80104b91:	0f 85 81 00 00 00    	jne    80104c18 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104b97:	ba 01 00 00 00       	mov    $0x1,%edx
80104b9c:	eb 05                	jmp    80104ba3 <acquire+0x23>
80104b9e:	66 90                	xchg   %ax,%ax
80104ba0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ba3:	89 d0                	mov    %edx,%eax
80104ba5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104ba8:	85 c0                	test   %eax,%eax
80104baa:	75 f4                	jne    80104ba0 <acquire+0x20>
  __sync_synchronize();
80104bac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104bb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bb4:	e8 67 f1 ff ff       	call   80103d20 <mycpu>
  ebp = (uint*)v - 2;
80104bb9:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104bbb:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104bbe:	31 c0                	xor    %eax,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bc0:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
80104bc6:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104bcc:	77 22                	ja     80104bf0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104bce:	8b 4a 04             	mov    0x4(%edx),%ecx
80104bd1:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
80104bd5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104bd8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104bda:	83 f8 0a             	cmp    $0xa,%eax
80104bdd:	75 e1                	jne    80104bc0 <acquire+0x40>
}
80104bdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104be2:	5b                   	pop    %ebx
80104be3:	5e                   	pop    %esi
80104be4:	5d                   	pop    %ebp
80104be5:	c3                   	ret    
80104be6:	8d 76 00             	lea    0x0(%esi),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bf0:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
80104bf4:	83 c3 34             	add    $0x34,%ebx
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104c00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104c06:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104c09:	39 c3                	cmp    %eax,%ebx
80104c0b:	75 f3                	jne    80104c00 <acquire+0x80>
}
80104c0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c10:	5b                   	pop    %ebx
80104c11:	5e                   	pop    %esi
80104c12:	5d                   	pop    %ebp
80104c13:	c3                   	ret    
80104c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104c18:	8b 73 08             	mov    0x8(%ebx),%esi
80104c1b:	e8 00 f1 ff ff       	call   80103d20 <mycpu>
80104c20:	39 c6                	cmp    %eax,%esi
80104c22:	0f 85 6f ff ff ff    	jne    80104b97 <acquire+0x17>
    panic("acquire");
80104c28:	83 ec 0c             	sub    $0xc,%esp
80104c2b:	68 63 81 10 80       	push   $0x80108163
80104c30:	e8 ab b7 ff ff       	call   801003e0 <panic>
80104c35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c40 <popcli>:

void
popcli(void)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c46:	9c                   	pushf  
80104c47:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c48:	f6 c4 02             	test   $0x2,%ah
80104c4b:	75 35                	jne    80104c82 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c4d:	e8 ce f0 ff ff       	call   80103d20 <mycpu>
80104c52:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c59:	78 34                	js     80104c8f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c5b:	e8 c0 f0 ff ff       	call   80103d20 <mycpu>
80104c60:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c66:	85 d2                	test   %edx,%edx
80104c68:	74 06                	je     80104c70 <popcli+0x30>
    sti();
}
80104c6a:	c9                   	leave  
80104c6b:	c3                   	ret    
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c70:	e8 ab f0 ff ff       	call   80103d20 <mycpu>
80104c75:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c7b:	85 c0                	test   %eax,%eax
80104c7d:	74 eb                	je     80104c6a <popcli+0x2a>
  asm volatile("sti");
80104c7f:	fb                   	sti    
}
80104c80:	c9                   	leave  
80104c81:	c3                   	ret    
    panic("popcli - interruptible");
80104c82:	83 ec 0c             	sub    $0xc,%esp
80104c85:	68 6b 81 10 80       	push   $0x8010816b
80104c8a:	e8 51 b7 ff ff       	call   801003e0 <panic>
    panic("popcli");
80104c8f:	83 ec 0c             	sub    $0xc,%esp
80104c92:	68 82 81 10 80       	push   $0x80108182
80104c97:	e8 44 b7 ff ff       	call   801003e0 <panic>
80104c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ca0 <release>:
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
80104ca5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104ca8:	8b 03                	mov    (%ebx),%eax
80104caa:	85 c0                	test   %eax,%eax
80104cac:	75 12                	jne    80104cc0 <release+0x20>
    panic("release");
80104cae:	83 ec 0c             	sub    $0xc,%esp
80104cb1:	68 89 81 10 80       	push   $0x80108189
80104cb6:	e8 25 b7 ff ff       	call   801003e0 <panic>
80104cbb:	90                   	nop
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104cc0:	8b 73 08             	mov    0x8(%ebx),%esi
80104cc3:	e8 58 f0 ff ff       	call   80103d20 <mycpu>
80104cc8:	39 c6                	cmp    %eax,%esi
80104cca:	75 e2                	jne    80104cae <release+0xe>
  lk->pcs[0] = 0;
80104ccc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104cd3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104cda:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104cdf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ce5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ce8:	5b                   	pop    %ebx
80104ce9:	5e                   	pop    %esi
80104cea:	5d                   	pop    %ebp
  popcli();
80104ceb:	e9 50 ff ff ff       	jmp    80104c40 <popcli>

80104cf0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	8b 55 08             	mov    0x8(%ebp),%edx
80104cf7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104cfa:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
80104cfb:	89 d0                	mov    %edx,%eax
80104cfd:	09 c8                	or     %ecx,%eax
80104cff:	a8 03                	test   $0x3,%al
80104d01:	75 2d                	jne    80104d30 <memset+0x40>
    c &= 0xFF;
80104d03:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d07:	c1 e9 02             	shr    $0x2,%ecx
80104d0a:	89 f8                	mov    %edi,%eax
80104d0c:	89 fb                	mov    %edi,%ebx
80104d0e:	c1 e0 18             	shl    $0x18,%eax
80104d11:	c1 e3 10             	shl    $0x10,%ebx
80104d14:	09 d8                	or     %ebx,%eax
80104d16:	09 f8                	or     %edi,%eax
80104d18:	c1 e7 08             	shl    $0x8,%edi
80104d1b:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d1d:	89 d7                	mov    %edx,%edi
80104d1f:	fc                   	cld    
80104d20:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104d22:	5b                   	pop    %ebx
80104d23:	89 d0                	mov    %edx,%eax
80104d25:	5f                   	pop    %edi
80104d26:	5d                   	pop    %ebp
80104d27:	c3                   	ret    
80104d28:	90                   	nop
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104d30:	89 d7                	mov    %edx,%edi
80104d32:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d35:	fc                   	cld    
80104d36:	f3 aa                	rep stos %al,%es:(%edi)
80104d38:	5b                   	pop    %ebx
80104d39:	89 d0                	mov    %edx,%eax
80104d3b:	5f                   	pop    %edi
80104d3c:	5d                   	pop    %ebp
80104d3d:	c3                   	ret    
80104d3e:	66 90                	xchg   %ax,%ax

80104d40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	8b 75 10             	mov    0x10(%ebp),%esi
80104d47:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4a:	53                   	push   %ebx
80104d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d4e:	85 f6                	test   %esi,%esi
80104d50:	74 22                	je     80104d74 <memcmp+0x34>
    if(*s1 != *s2)
80104d52:	0f b6 08             	movzbl (%eax),%ecx
80104d55:	0f b6 1a             	movzbl (%edx),%ebx
80104d58:	01 c6                	add    %eax,%esi
80104d5a:	38 cb                	cmp    %cl,%bl
80104d5c:	74 0c                	je     80104d6a <memcmp+0x2a>
80104d5e:	eb 20                	jmp    80104d80 <memcmp+0x40>
80104d60:	0f b6 08             	movzbl (%eax),%ecx
80104d63:	0f b6 1a             	movzbl (%edx),%ebx
80104d66:	38 d9                	cmp    %bl,%cl
80104d68:	75 16                	jne    80104d80 <memcmp+0x40>
      return *s1 - *s2;
    s1++, s2++;
80104d6a:	83 c0 01             	add    $0x1,%eax
80104d6d:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104d70:	39 c6                	cmp    %eax,%esi
80104d72:	75 ec                	jne    80104d60 <memcmp+0x20>
  }

  return 0;
}
80104d74:	5b                   	pop    %ebx
  return 0;
80104d75:	31 c0                	xor    %eax,%eax
}
80104d77:	5e                   	pop    %esi
80104d78:	5d                   	pop    %ebp
80104d79:	c3                   	ret    
80104d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return *s1 - *s2;
80104d80:	0f b6 c1             	movzbl %cl,%eax
80104d83:	29 d8                	sub    %ebx,%eax
}
80104d85:	5b                   	pop    %ebx
80104d86:	5e                   	pop    %esi
80104d87:	5d                   	pop    %ebp
80104d88:	c3                   	ret    
80104d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	57                   	push   %edi
80104d94:	8b 45 08             	mov    0x8(%ebp),%eax
80104d97:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d9a:	56                   	push   %esi
80104d9b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d9e:	39 c6                	cmp    %eax,%esi
80104da0:	73 26                	jae    80104dc8 <memmove+0x38>
80104da2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104da5:	39 f8                	cmp    %edi,%eax
80104da7:	73 1f                	jae    80104dc8 <memmove+0x38>
80104da9:	8d 51 ff             	lea    -0x1(%ecx),%edx
    s += n;
    d += n;
    while(n-- > 0)
80104dac:	85 c9                	test   %ecx,%ecx
80104dae:	74 0f                	je     80104dbf <memmove+0x2f>
      *--d = *--s;
80104db0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104db4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104db7:	83 ea 01             	sub    $0x1,%edx
80104dba:	83 fa ff             	cmp    $0xffffffff,%edx
80104dbd:	75 f1                	jne    80104db0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104dbf:	5e                   	pop    %esi
80104dc0:	5f                   	pop    %edi
80104dc1:	5d                   	pop    %ebp
80104dc2:	c3                   	ret    
80104dc3:	90                   	nop
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dc8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
    while(n-- > 0)
80104dcb:	89 c7                	mov    %eax,%edi
80104dcd:	85 c9                	test   %ecx,%ecx
80104dcf:	74 ee                	je     80104dbf <memmove+0x2f>
80104dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104dd8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104dd9:	39 d6                	cmp    %edx,%esi
80104ddb:	75 fb                	jne    80104dd8 <memmove+0x48>
}
80104ddd:	5e                   	pop    %esi
80104dde:	5f                   	pop    %edi
80104ddf:	5d                   	pop    %ebp
80104de0:	c3                   	ret    
80104de1:	eb 0d                	jmp    80104df0 <memcpy>
80104de3:	90                   	nop
80104de4:	90                   	nop
80104de5:	90                   	nop
80104de6:	90                   	nop
80104de7:	90                   	nop
80104de8:	90                   	nop
80104de9:	90                   	nop
80104dea:	90                   	nop
80104deb:	90                   	nop
80104dec:	90                   	nop
80104ded:	90                   	nop
80104dee:	90                   	nop
80104def:	90                   	nop

80104df0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104df0:	eb 9e                	jmp    80104d90 <memmove>
80104df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	57                   	push   %edi
80104e04:	8b 7d 10             	mov    0x10(%ebp),%edi
80104e07:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e0a:	56                   	push   %esi
80104e0b:	8b 75 0c             	mov    0xc(%ebp),%esi
80104e0e:	53                   	push   %ebx
  while(n > 0 && *p && *p == *q)
80104e0f:	85 ff                	test   %edi,%edi
80104e11:	74 2f                	je     80104e42 <strncmp+0x42>
80104e13:	0f b6 11             	movzbl (%ecx),%edx
80104e16:	0f b6 1e             	movzbl (%esi),%ebx
80104e19:	84 d2                	test   %dl,%dl
80104e1b:	74 37                	je     80104e54 <strncmp+0x54>
80104e1d:	38 da                	cmp    %bl,%dl
80104e1f:	75 33                	jne    80104e54 <strncmp+0x54>
80104e21:	01 f7                	add    %esi,%edi
80104e23:	eb 13                	jmp    80104e38 <strncmp+0x38>
80104e25:	8d 76 00             	lea    0x0(%esi),%esi
80104e28:	0f b6 11             	movzbl (%ecx),%edx
80104e2b:	84 d2                	test   %dl,%dl
80104e2d:	74 21                	je     80104e50 <strncmp+0x50>
80104e2f:	0f b6 18             	movzbl (%eax),%ebx
80104e32:	89 c6                	mov    %eax,%esi
80104e34:	38 da                	cmp    %bl,%dl
80104e36:	75 1c                	jne    80104e54 <strncmp+0x54>
    n--, p++, q++;
80104e38:	8d 46 01             	lea    0x1(%esi),%eax
80104e3b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e3e:	39 f8                	cmp    %edi,%eax
80104e40:	75 e6                	jne    80104e28 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e42:	5b                   	pop    %ebx
    return 0;
80104e43:	31 c0                	xor    %eax,%eax
}
80104e45:	5e                   	pop    %esi
80104e46:	5f                   	pop    %edi
80104e47:	5d                   	pop    %ebp
80104e48:	c3                   	ret    
80104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e50:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e54:	0f b6 c2             	movzbl %dl,%eax
80104e57:	29 d8                	sub    %ebx,%eax
}
80104e59:	5b                   	pop    %ebx
80104e5a:	5e                   	pop    %esi
80104e5b:	5f                   	pop    %edi
80104e5c:	5d                   	pop    %ebp
80104e5d:	c3                   	ret    
80104e5e:	66 90                	xchg   %ax,%ax

80104e60 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	57                   	push   %edi
80104e64:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e67:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
80104e6a:	56                   	push   %esi
80104e6b:	53                   	push   %ebx
80104e6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e6f:	eb 1a                	jmp    80104e8b <strncpy+0x2b>
80104e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e78:	83 c2 01             	add    $0x1,%edx
80104e7b:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
80104e7f:	83 c1 01             	add    $0x1,%ecx
80104e82:	88 41 ff             	mov    %al,-0x1(%ecx)
80104e85:	84 c0                	test   %al,%al
80104e87:	74 09                	je     80104e92 <strncpy+0x32>
80104e89:	89 fb                	mov    %edi,%ebx
80104e8b:	8d 7b ff             	lea    -0x1(%ebx),%edi
80104e8e:	85 db                	test   %ebx,%ebx
80104e90:	7f e6                	jg     80104e78 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e92:	89 ce                	mov    %ecx,%esi
80104e94:	85 ff                	test   %edi,%edi
80104e96:	7e 1b                	jle    80104eb3 <strncpy+0x53>
80104e98:	90                   	nop
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ea0:	83 c6 01             	add    $0x1,%esi
80104ea3:	c6 46 ff 00          	movb   $0x0,-0x1(%esi)
80104ea7:	89 f2                	mov    %esi,%edx
80104ea9:	f7 d2                	not    %edx
80104eab:	01 ca                	add    %ecx,%edx
80104ead:	01 da                	add    %ebx,%edx
  while(n-- > 0)
80104eaf:	85 d2                	test   %edx,%edx
80104eb1:	7f ed                	jg     80104ea0 <strncpy+0x40>
  return os;
}
80104eb3:	5b                   	pop    %ebx
80104eb4:	8b 45 08             	mov    0x8(%ebp),%eax
80104eb7:	5e                   	pop    %esi
80104eb8:	5f                   	pop    %edi
80104eb9:	5d                   	pop    %ebp
80104eba:	c3                   	ret    
80104ebb:	90                   	nop
80104ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ec0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ec7:	8b 45 08             	mov    0x8(%ebp),%eax
80104eca:	53                   	push   %ebx
80104ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104ece:	85 c9                	test   %ecx,%ecx
80104ed0:	7e 26                	jle    80104ef8 <safestrcpy+0x38>
80104ed2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ed6:	89 c1                	mov    %eax,%ecx
80104ed8:	eb 17                	jmp    80104ef1 <safestrcpy+0x31>
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ee0:	83 c2 01             	add    $0x1,%edx
80104ee3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ee7:	83 c1 01             	add    $0x1,%ecx
80104eea:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104eed:	84 db                	test   %bl,%bl
80104eef:	74 04                	je     80104ef5 <safestrcpy+0x35>
80104ef1:	39 f2                	cmp    %esi,%edx
80104ef3:	75 eb                	jne    80104ee0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ef5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ef8:	5b                   	pop    %ebx
80104ef9:	5e                   	pop    %esi
80104efa:	5d                   	pop    %ebp
80104efb:	c3                   	ret    
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f00 <strlen>:

int
strlen(const char *s)
{
80104f00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f01:	31 c0                	xor    %eax,%eax
{
80104f03:	89 e5                	mov    %esp,%ebp
80104f05:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f08:	80 3a 00             	cmpb   $0x0,(%edx)
80104f0b:	74 0c                	je     80104f19 <strlen+0x19>
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
80104f10:	83 c0 01             	add    $0x1,%eax
80104f13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f17:	75 f7                	jne    80104f10 <strlen+0x10>
    ;
  return n;
}
80104f19:	5d                   	pop    %ebp
80104f1a:	c3                   	ret    

80104f1b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f1b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f1f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104f23:	55                   	push   %ebp
  pushl %ebx
80104f24:	53                   	push   %ebx
  pushl %esi
80104f25:	56                   	push   %esi
  pushl %edi
80104f26:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f27:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f29:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104f2b:	5f                   	pop    %edi
  popl %esi
80104f2c:	5e                   	pop    %esi
  popl %ebx
80104f2d:	5b                   	pop    %ebx
  popl %ebp
80104f2e:	5d                   	pop    %ebp
  ret
80104f2f:	c3                   	ret    

80104f30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	53                   	push   %ebx
80104f34:	83 ec 04             	sub    $0x4,%esp
80104f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f3a:	e8 81 ee ff ff       	call   80103dc0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f3f:	8b 00                	mov    (%eax),%eax
80104f41:	39 d8                	cmp    %ebx,%eax
80104f43:	76 1b                	jbe    80104f60 <fetchint+0x30>
80104f45:	8d 53 04             	lea    0x4(%ebx),%edx
80104f48:	39 d0                	cmp    %edx,%eax
80104f4a:	72 14                	jb     80104f60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f4f:	8b 13                	mov    (%ebx),%edx
80104f51:	89 10                	mov    %edx,(%eax)
  return 0;
80104f53:	31 c0                	xor    %eax,%eax
}
80104f55:	83 c4 04             	add    $0x4,%esp
80104f58:	5b                   	pop    %ebx
80104f59:	5d                   	pop    %ebp
80104f5a:	c3                   	ret    
80104f5b:	90                   	nop
80104f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f65:	eb ee                	jmp    80104f55 <fetchint+0x25>
80104f67:	89 f6                	mov    %esi,%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	53                   	push   %ebx
80104f74:	83 ec 04             	sub    $0x4,%esp
80104f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f7a:	e8 41 ee ff ff       	call   80103dc0 <myproc>

  if(addr >= curproc->sz)
80104f7f:	39 18                	cmp    %ebx,(%eax)
80104f81:	76 29                	jbe    80104fac <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104f83:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f86:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f88:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f8a:	39 d3                	cmp    %edx,%ebx
80104f8c:	73 1e                	jae    80104fac <fetchstr+0x3c>
    if(*s == 0)
80104f8e:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f91:	74 35                	je     80104fc8 <fetchstr+0x58>
80104f93:	89 d8                	mov    %ebx,%eax
80104f95:	eb 0e                	jmp    80104fa5 <fetchstr+0x35>
80104f97:	89 f6                	mov    %esi,%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fa0:	80 38 00             	cmpb   $0x0,(%eax)
80104fa3:	74 1b                	je     80104fc0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104fa5:	83 c0 01             	add    $0x1,%eax
80104fa8:	39 c2                	cmp    %eax,%edx
80104faa:	77 f4                	ja     80104fa0 <fetchstr+0x30>
    return -1;
80104fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104fb1:	83 c4 04             	add    $0x4,%esp
80104fb4:	5b                   	pop    %ebx
80104fb5:	5d                   	pop    %ebp
80104fb6:	c3                   	ret    
80104fb7:	89 f6                	mov    %esi,%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fc0:	83 c4 04             	add    $0x4,%esp
80104fc3:	29 d8                	sub    %ebx,%eax
80104fc5:	5b                   	pop    %ebx
80104fc6:	5d                   	pop    %ebp
80104fc7:	c3                   	ret    
    if(*s == 0)
80104fc8:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104fca:	eb e5                	jmp    80104fb1 <fetchstr+0x41>
80104fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fd5:	e8 e6 ed ff ff       	call   80103dc0 <myproc>
80104fda:	8b 55 08             	mov    0x8(%ebp),%edx
80104fdd:	8b 40 18             	mov    0x18(%eax),%eax
80104fe0:	8b 40 44             	mov    0x44(%eax),%eax
80104fe3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fe6:	e8 d5 ed ff ff       	call   80103dc0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104feb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fee:	8b 00                	mov    (%eax),%eax
80104ff0:	39 c6                	cmp    %eax,%esi
80104ff2:	73 1c                	jae    80105010 <argint+0x40>
80104ff4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ff7:	39 d0                	cmp    %edx,%eax
80104ff9:	72 15                	jb     80105010 <argint+0x40>
  *ip = *(int*)(addr);
80104ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ffe:	8b 53 04             	mov    0x4(%ebx),%edx
80105001:	89 10                	mov    %edx,(%eax)
  return 0;
80105003:	31 c0                	xor    %eax,%eax
}
80105005:	5b                   	pop    %ebx
80105006:	5e                   	pop    %esi
80105007:	5d                   	pop    %ebp
80105008:	c3                   	ret    
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105015:	eb ee                	jmp    80105005 <argint+0x35>
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
80105025:	83 ec 10             	sub    $0x10,%esp
80105028:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010502b:	e8 90 ed ff ff       	call   80103dc0 <myproc>
 
  if(argint(n, &i) < 0)
80105030:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105033:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105035:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105038:	50                   	push   %eax
80105039:	ff 75 08             	pushl  0x8(%ebp)
8010503c:	e8 8f ff ff ff       	call   80104fd0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105041:	83 c4 10             	add    $0x10,%esp
80105044:	85 c0                	test   %eax,%eax
80105046:	78 28                	js     80105070 <argptr+0x50>
80105048:	85 db                	test   %ebx,%ebx
8010504a:	78 24                	js     80105070 <argptr+0x50>
8010504c:	8b 16                	mov    (%esi),%edx
8010504e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105051:	39 c2                	cmp    %eax,%edx
80105053:	76 1b                	jbe    80105070 <argptr+0x50>
80105055:	01 c3                	add    %eax,%ebx
80105057:	39 da                	cmp    %ebx,%edx
80105059:	72 15                	jb     80105070 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010505b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010505e:	89 02                	mov    %eax,(%edx)
  return 0;
80105060:	31 c0                	xor    %eax,%eax
}
80105062:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105065:	5b                   	pop    %ebx
80105066:	5e                   	pop    %esi
80105067:	5d                   	pop    %ebp
80105068:	c3                   	ret    
80105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105075:	eb eb                	jmp    80105062 <argptr+0x42>
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105086:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105089:	50                   	push   %eax
8010508a:	ff 75 08             	pushl  0x8(%ebp)
8010508d:	e8 3e ff ff ff       	call   80104fd0 <argint>
80105092:	83 c4 10             	add    $0x10,%esp
80105095:	85 c0                	test   %eax,%eax
80105097:	78 17                	js     801050b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105099:	83 ec 08             	sub    $0x8,%esp
8010509c:	ff 75 0c             	pushl  0xc(%ebp)
8010509f:	ff 75 f4             	pushl  -0xc(%ebp)
801050a2:	e8 c9 fe ff ff       	call   80104f70 <fetchstr>
801050a7:	83 c4 10             	add    $0x10,%esp
}
801050aa:	c9                   	leave  
801050ab:	c3                   	ret    
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050b0:	c9                   	leave  
    return -1;
801050b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050b6:	c3                   	ret    
801050b7:	89 f6                	mov    %esi,%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050c0 <syscall>:
[SYS_att]  sys_att,
};

void
syscall(void)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	53                   	push   %ebx
801050c4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801050c7:	e8 f4 ec ff ff       	call   80103dc0 <myproc>
801050cc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050ce:	8b 40 18             	mov    0x18(%eax),%eax
801050d1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801050d7:	83 fa 1c             	cmp    $0x1c,%edx
801050da:	77 1c                	ja     801050f8 <syscall+0x38>
801050dc:	8b 14 85 c0 81 10 80 	mov    -0x7fef7e40(,%eax,4),%edx
801050e3:	85 d2                	test   %edx,%edx
801050e5:	74 11                	je     801050f8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801050e7:	ff d2                	call   *%edx
801050e9:	8b 53 18             	mov    0x18(%ebx),%edx
801050ec:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f2:	c9                   	leave  
801050f3:	c3                   	ret    
801050f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801050f8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801050f9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801050fc:	50                   	push   %eax
801050fd:	ff 73 10             	pushl  0x10(%ebx)
80105100:	68 91 81 10 80       	push   $0x80108191
80105105:	e8 e6 b5 ff ff       	call   801006f0 <cprintf>
    curproc->tf->eax = -1;
8010510a:	8b 43 18             	mov    0x18(%ebx),%eax
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010511a:	c9                   	leave  
8010511b:	c3                   	ret    
8010511c:	66 90                	xchg   %ax,%ax
8010511e:	66 90                	xchg   %ax,%ax

80105120 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	57                   	push   %edi
80105124:	56                   	push   %esi
80105125:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105126:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80105129:	83 ec 44             	sub    $0x44,%esp
8010512c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010512f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105132:	53                   	push   %ebx
80105133:	50                   	push   %eax
{
80105134:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105137:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010513a:	e8 11 d3 ff ff       	call   80102450 <nameiparent>
8010513f:	83 c4 10             	add    $0x10,%esp
80105142:	85 c0                	test   %eax,%eax
80105144:	0f 84 46 01 00 00    	je     80105290 <create+0x170>
    return 0;
  ilock(dp);
8010514a:	83 ec 0c             	sub    $0xc,%esp
8010514d:	89 c6                	mov    %eax,%esi
8010514f:	50                   	push   %eax
80105150:	e8 3b ca ff ff       	call   80101b90 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105155:	83 c4 0c             	add    $0xc,%esp
80105158:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010515b:	50                   	push   %eax
8010515c:	53                   	push   %ebx
8010515d:	56                   	push   %esi
8010515e:	e8 5d cf ff ff       	call   801020c0 <dirlookup>
80105163:	83 c4 10             	add    $0x10,%esp
80105166:	89 c7                	mov    %eax,%edi
80105168:	85 c0                	test   %eax,%eax
8010516a:	74 54                	je     801051c0 <create+0xa0>
    iunlockput(dp);
8010516c:	83 ec 0c             	sub    $0xc,%esp
8010516f:	56                   	push   %esi
80105170:	e8 ab cc ff ff       	call   80101e20 <iunlockput>
    ilock(ip);
80105175:	89 3c 24             	mov    %edi,(%esp)
80105178:	e8 13 ca ff ff       	call   80101b90 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010517d:	83 c4 10             	add    $0x10,%esp
80105180:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105185:	75 19                	jne    801051a0 <create+0x80>
80105187:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010518c:	75 12                	jne    801051a0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010518e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105191:	89 f8                	mov    %edi,%eax
80105193:	5b                   	pop    %ebx
80105194:	5e                   	pop    %esi
80105195:	5f                   	pop    %edi
80105196:	5d                   	pop    %ebp
80105197:	c3                   	ret    
80105198:	90                   	nop
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
801051a0:	83 ec 0c             	sub    $0xc,%esp
801051a3:	57                   	push   %edi
    return 0;
801051a4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801051a6:	e8 75 cc ff ff       	call   80101e20 <iunlockput>
    return 0;
801051ab:	83 c4 10             	add    $0x10,%esp
}
801051ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051b1:	89 f8                	mov    %edi,%eax
801051b3:	5b                   	pop    %ebx
801051b4:	5e                   	pop    %esi
801051b5:	5f                   	pop    %edi
801051b6:	5d                   	pop    %ebp
801051b7:	c3                   	ret    
801051b8:	90                   	nop
801051b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801051c0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801051c4:	83 ec 08             	sub    $0x8,%esp
801051c7:	50                   	push   %eax
801051c8:	ff 36                	pushl  (%esi)
801051ca:	e8 51 c8 ff ff       	call   80101a20 <ialloc>
801051cf:	83 c4 10             	add    $0x10,%esp
801051d2:	89 c7                	mov    %eax,%edi
801051d4:	85 c0                	test   %eax,%eax
801051d6:	0f 84 cd 00 00 00    	je     801052a9 <create+0x189>
  ilock(ip);
801051dc:	83 ec 0c             	sub    $0xc,%esp
801051df:	50                   	push   %eax
801051e0:	e8 ab c9 ff ff       	call   80101b90 <ilock>
  ip->major = major;
801051e5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801051e9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801051ed:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801051f1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801051f5:	b8 01 00 00 00       	mov    $0x1,%eax
801051fa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801051fe:	89 3c 24             	mov    %edi,(%esp)
80105201:	e8 da c8 ff ff       	call   80101ae0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105206:	83 c4 10             	add    $0x10,%esp
80105209:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010520e:	74 30                	je     80105240 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105210:	83 ec 04             	sub    $0x4,%esp
80105213:	ff 77 04             	pushl  0x4(%edi)
80105216:	53                   	push   %ebx
80105217:	56                   	push   %esi
80105218:	e8 53 d1 ff ff       	call   80102370 <dirlink>
8010521d:	83 c4 10             	add    $0x10,%esp
80105220:	85 c0                	test   %eax,%eax
80105222:	78 78                	js     8010529c <create+0x17c>
  iunlockput(dp);
80105224:	83 ec 0c             	sub    $0xc,%esp
80105227:	56                   	push   %esi
80105228:	e8 f3 cb ff ff       	call   80101e20 <iunlockput>
  return ip;
8010522d:	83 c4 10             	add    $0x10,%esp
}
80105230:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105233:	89 f8                	mov    %edi,%eax
80105235:	5b                   	pop    %ebx
80105236:	5e                   	pop    %esi
80105237:	5f                   	pop    %edi
80105238:	5d                   	pop    %ebp
80105239:	c3                   	ret    
8010523a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105240:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105243:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105248:	56                   	push   %esi
80105249:	e8 92 c8 ff ff       	call   80101ae0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010524e:	83 c4 0c             	add    $0xc,%esp
80105251:	ff 77 04             	pushl  0x4(%edi)
80105254:	68 54 82 10 80       	push   $0x80108254
80105259:	57                   	push   %edi
8010525a:	e8 11 d1 ff ff       	call   80102370 <dirlink>
8010525f:	83 c4 10             	add    $0x10,%esp
80105262:	85 c0                	test   %eax,%eax
80105264:	78 18                	js     8010527e <create+0x15e>
80105266:	83 ec 04             	sub    $0x4,%esp
80105269:	ff 76 04             	pushl  0x4(%esi)
8010526c:	68 53 82 10 80       	push   $0x80108253
80105271:	57                   	push   %edi
80105272:	e8 f9 d0 ff ff       	call   80102370 <dirlink>
80105277:	83 c4 10             	add    $0x10,%esp
8010527a:	85 c0                	test   %eax,%eax
8010527c:	79 92                	jns    80105210 <create+0xf0>
      panic("create dots");
8010527e:	83 ec 0c             	sub    $0xc,%esp
80105281:	68 47 82 10 80       	push   $0x80108247
80105286:	e8 55 b1 ff ff       	call   801003e0 <panic>
8010528b:	90                   	nop
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80105290:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105293:	31 ff                	xor    %edi,%edi
}
80105295:	5b                   	pop    %ebx
80105296:	89 f8                	mov    %edi,%eax
80105298:	5e                   	pop    %esi
80105299:	5f                   	pop    %edi
8010529a:	5d                   	pop    %ebp
8010529b:	c3                   	ret    
    panic("create: dirlink");
8010529c:	83 ec 0c             	sub    $0xc,%esp
8010529f:	68 56 82 10 80       	push   $0x80108256
801052a4:	e8 37 b1 ff ff       	call   801003e0 <panic>
    panic("create: ialloc");
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	68 38 82 10 80       	push   $0x80108238
801052b1:	e8 2a b1 ff ff       	call   801003e0 <panic>
801052b6:	8d 76 00             	lea    0x0(%esi),%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	56                   	push   %esi
801052c4:	89 d6                	mov    %edx,%esi
801052c6:	53                   	push   %ebx
801052c7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801052c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801052cc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052cf:	50                   	push   %eax
801052d0:	6a 00                	push   $0x0
801052d2:	e8 f9 fc ff ff       	call   80104fd0 <argint>
801052d7:	83 c4 10             	add    $0x10,%esp
801052da:	85 c0                	test   %eax,%eax
801052dc:	78 2a                	js     80105308 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052de:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052e2:	77 24                	ja     80105308 <argfd.constprop.0+0x48>
801052e4:	e8 d7 ea ff ff       	call   80103dc0 <myproc>
801052e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052ec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801052f0:	85 c0                	test   %eax,%eax
801052f2:	74 14                	je     80105308 <argfd.constprop.0+0x48>
  if(pfd)
801052f4:	85 db                	test   %ebx,%ebx
801052f6:	74 02                	je     801052fa <argfd.constprop.0+0x3a>
    *pfd = fd;
801052f8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801052fa:	89 06                	mov    %eax,(%esi)
  return 0;
801052fc:	31 c0                	xor    %eax,%eax
}
801052fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105301:	5b                   	pop    %ebx
80105302:	5e                   	pop    %esi
80105303:	5d                   	pop    %ebp
80105304:	c3                   	ret    
80105305:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530d:	eb ef                	jmp    801052fe <argfd.constprop.0+0x3e>
8010530f:	90                   	nop

80105310 <sys_dup>:
{
80105310:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105311:	31 c0                	xor    %eax,%eax
{
80105313:	89 e5                	mov    %esp,%ebp
80105315:	56                   	push   %esi
80105316:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105317:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010531a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010531d:	e8 9e ff ff ff       	call   801052c0 <argfd.constprop.0>
80105322:	85 c0                	test   %eax,%eax
80105324:	78 1a                	js     80105340 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80105326:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105329:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010532b:	e8 90 ea ff ff       	call   80103dc0 <myproc>
    if(curproc->ofile[fd] == 0){
80105330:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105334:	85 d2                	test   %edx,%edx
80105336:	74 18                	je     80105350 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80105338:	83 c3 01             	add    $0x1,%ebx
8010533b:	83 fb 10             	cmp    $0x10,%ebx
8010533e:	75 f0                	jne    80105330 <sys_dup+0x20>
}
80105340:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105343:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105348:	89 d8                	mov    %ebx,%eax
8010534a:	5b                   	pop    %ebx
8010534b:	5e                   	pop    %esi
8010534c:	5d                   	pop    %ebp
8010534d:	c3                   	ret    
8010534e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105350:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105354:	83 ec 0c             	sub    $0xc,%esp
80105357:	ff 75 f4             	pushl  -0xc(%ebp)
8010535a:	e8 51 bf ff ff       	call   801012b0 <filedup>
  return fd;
8010535f:	83 c4 10             	add    $0x10,%esp
}
80105362:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105365:	89 d8                	mov    %ebx,%eax
80105367:	5b                   	pop    %ebx
80105368:	5e                   	pop    %esi
80105369:	5d                   	pop    %ebp
8010536a:	c3                   	ret    
8010536b:	90                   	nop
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_read>:
{
80105370:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105371:	31 c0                	xor    %eax,%eax
{
80105373:	89 e5                	mov    %esp,%ebp
80105375:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105378:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010537b:	e8 40 ff ff ff       	call   801052c0 <argfd.constprop.0>
80105380:	85 c0                	test   %eax,%eax
80105382:	78 4c                	js     801053d0 <sys_read+0x60>
80105384:	83 ec 08             	sub    $0x8,%esp
80105387:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010538a:	50                   	push   %eax
8010538b:	6a 02                	push   $0x2
8010538d:	e8 3e fc ff ff       	call   80104fd0 <argint>
80105392:	83 c4 10             	add    $0x10,%esp
80105395:	85 c0                	test   %eax,%eax
80105397:	78 37                	js     801053d0 <sys_read+0x60>
80105399:	83 ec 04             	sub    $0x4,%esp
8010539c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539f:	ff 75 f0             	pushl  -0x10(%ebp)
801053a2:	50                   	push   %eax
801053a3:	6a 01                	push   $0x1
801053a5:	e8 76 fc ff ff       	call   80105020 <argptr>
801053aa:	83 c4 10             	add    $0x10,%esp
801053ad:	85 c0                	test   %eax,%eax
801053af:	78 1f                	js     801053d0 <sys_read+0x60>
  return fileread(f, p, n);
801053b1:	83 ec 04             	sub    $0x4,%esp
801053b4:	ff 75 f0             	pushl  -0x10(%ebp)
801053b7:	ff 75 f4             	pushl  -0xc(%ebp)
801053ba:	ff 75 ec             	pushl  -0x14(%ebp)
801053bd:	e8 6e c0 ff ff       	call   80101430 <fileread>
801053c2:	83 c4 10             	add    $0x10,%esp
}
801053c5:	c9                   	leave  
801053c6:	c3                   	ret    
801053c7:	89 f6                	mov    %esi,%esi
801053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801053d0:	c9                   	leave  
    return -1;
801053d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d6:	c3                   	ret    
801053d7:	89 f6                	mov    %esi,%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <sys_write>:
{
801053e0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053e1:	31 c0                	xor    %eax,%eax
{
801053e3:	89 e5                	mov    %esp,%ebp
801053e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053e8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053eb:	e8 d0 fe ff ff       	call   801052c0 <argfd.constprop.0>
801053f0:	85 c0                	test   %eax,%eax
801053f2:	78 4c                	js     80105440 <sys_write+0x60>
801053f4:	83 ec 08             	sub    $0x8,%esp
801053f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053fa:	50                   	push   %eax
801053fb:	6a 02                	push   $0x2
801053fd:	e8 ce fb ff ff       	call   80104fd0 <argint>
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	85 c0                	test   %eax,%eax
80105407:	78 37                	js     80105440 <sys_write+0x60>
80105409:	83 ec 04             	sub    $0x4,%esp
8010540c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540f:	ff 75 f0             	pushl  -0x10(%ebp)
80105412:	50                   	push   %eax
80105413:	6a 01                	push   $0x1
80105415:	e8 06 fc ff ff       	call   80105020 <argptr>
8010541a:	83 c4 10             	add    $0x10,%esp
8010541d:	85 c0                	test   %eax,%eax
8010541f:	78 1f                	js     80105440 <sys_write+0x60>
  return filewrite(f, p, n);
80105421:	83 ec 04             	sub    $0x4,%esp
80105424:	ff 75 f0             	pushl  -0x10(%ebp)
80105427:	ff 75 f4             	pushl  -0xc(%ebp)
8010542a:	ff 75 ec             	pushl  -0x14(%ebp)
8010542d:	e8 8e c0 ff ff       	call   801014c0 <filewrite>
80105432:	83 c4 10             	add    $0x10,%esp
}
80105435:	c9                   	leave  
80105436:	c3                   	ret    
80105437:	89 f6                	mov    %esi,%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105440:	c9                   	leave  
    return -1;
80105441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105446:	c3                   	ret    
80105447:	89 f6                	mov    %esi,%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <sys_close>:
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105456:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105459:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010545c:	e8 5f fe ff ff       	call   801052c0 <argfd.constprop.0>
80105461:	85 c0                	test   %eax,%eax
80105463:	78 2b                	js     80105490 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105465:	e8 56 e9 ff ff       	call   80103dc0 <myproc>
8010546a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010546d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105470:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105477:	00 
  fileclose(f);
80105478:	ff 75 f4             	pushl  -0xc(%ebp)
8010547b:	e8 80 be ff ff       	call   80101300 <fileclose>
  return 0;
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	31 c0                	xor    %eax,%eax
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

801054a0 <sys_fstat>:
{
801054a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054a1:	31 c0                	xor    %eax,%eax
{
801054a3:	89 e5                	mov    %esp,%ebp
801054a5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054a8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801054ab:	e8 10 fe ff ff       	call   801052c0 <argfd.constprop.0>
801054b0:	85 c0                	test   %eax,%eax
801054b2:	78 2c                	js     801054e0 <sys_fstat+0x40>
801054b4:	83 ec 04             	sub    $0x4,%esp
801054b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ba:	6a 14                	push   $0x14
801054bc:	50                   	push   %eax
801054bd:	6a 01                	push   $0x1
801054bf:	e8 5c fb ff ff       	call   80105020 <argptr>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	85 c0                	test   %eax,%eax
801054c9:	78 15                	js     801054e0 <sys_fstat+0x40>
  return filestat(f, st);
801054cb:	83 ec 08             	sub    $0x8,%esp
801054ce:	ff 75 f4             	pushl  -0xc(%ebp)
801054d1:	ff 75 f0             	pushl  -0x10(%ebp)
801054d4:	e8 07 bf ff ff       	call   801013e0 <filestat>
801054d9:	83 c4 10             	add    $0x10,%esp
}
801054dc:	c9                   	leave  
801054dd:	c3                   	ret    
801054de:	66 90                	xchg   %ax,%ax
801054e0:	c9                   	leave  
    return -1;
801054e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054e6:	c3                   	ret    
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054f0 <sys_link>:
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054f5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801054f8:	53                   	push   %ebx
801054f9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054fc:	50                   	push   %eax
801054fd:	6a 00                	push   $0x0
801054ff:	e8 7c fb ff ff       	call   80105080 <argstr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	0f 88 fb 00 00 00    	js     8010560a <sys_link+0x11a>
8010550f:	83 ec 08             	sub    $0x8,%esp
80105512:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105515:	50                   	push   %eax
80105516:	6a 01                	push   $0x1
80105518:	e8 63 fb ff ff       	call   80105080 <argstr>
8010551d:	83 c4 10             	add    $0x10,%esp
80105520:	85 c0                	test   %eax,%eax
80105522:	0f 88 e2 00 00 00    	js     8010560a <sys_link+0x11a>
  begin_op();
80105528:	e8 e3 db ff ff       	call   80103110 <begin_op>
  if((ip = namei(old)) == 0){
8010552d:	83 ec 0c             	sub    $0xc,%esp
80105530:	ff 75 d4             	pushl  -0x2c(%ebp)
80105533:	e8 f8 ce ff ff       	call   80102430 <namei>
80105538:	83 c4 10             	add    $0x10,%esp
8010553b:	89 c3                	mov    %eax,%ebx
8010553d:	85 c0                	test   %eax,%eax
8010553f:	0f 84 e4 00 00 00    	je     80105629 <sys_link+0x139>
  ilock(ip);
80105545:	83 ec 0c             	sub    $0xc,%esp
80105548:	50                   	push   %eax
80105549:	e8 42 c6 ff ff       	call   80101b90 <ilock>
  if(ip->type == T_DIR){
8010554e:	83 c4 10             	add    $0x10,%esp
80105551:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105556:	0f 84 b5 00 00 00    	je     80105611 <sys_link+0x121>
  iupdate(ip);
8010555c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010555f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105564:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105567:	53                   	push   %ebx
80105568:	e8 73 c5 ff ff       	call   80101ae0 <iupdate>
  iunlock(ip);
8010556d:	89 1c 24             	mov    %ebx,(%esp)
80105570:	e8 fb c6 ff ff       	call   80101c70 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105575:	58                   	pop    %eax
80105576:	5a                   	pop    %edx
80105577:	57                   	push   %edi
80105578:	ff 75 d0             	pushl  -0x30(%ebp)
8010557b:	e8 d0 ce ff ff       	call   80102450 <nameiparent>
80105580:	83 c4 10             	add    $0x10,%esp
80105583:	89 c6                	mov    %eax,%esi
80105585:	85 c0                	test   %eax,%eax
80105587:	74 5b                	je     801055e4 <sys_link+0xf4>
  ilock(dp);
80105589:	83 ec 0c             	sub    $0xc,%esp
8010558c:	50                   	push   %eax
8010558d:	e8 fe c5 ff ff       	call   80101b90 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	8b 03                	mov    (%ebx),%eax
80105597:	39 06                	cmp    %eax,(%esi)
80105599:	75 3d                	jne    801055d8 <sys_link+0xe8>
8010559b:	83 ec 04             	sub    $0x4,%esp
8010559e:	ff 73 04             	pushl  0x4(%ebx)
801055a1:	57                   	push   %edi
801055a2:	56                   	push   %esi
801055a3:	e8 c8 cd ff ff       	call   80102370 <dirlink>
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	85 c0                	test   %eax,%eax
801055ad:	78 29                	js     801055d8 <sys_link+0xe8>
  iunlockput(dp);
801055af:	83 ec 0c             	sub    $0xc,%esp
801055b2:	56                   	push   %esi
801055b3:	e8 68 c8 ff ff       	call   80101e20 <iunlockput>
  iput(ip);
801055b8:	89 1c 24             	mov    %ebx,(%esp)
801055bb:	e8 00 c7 ff ff       	call   80101cc0 <iput>
  end_op();
801055c0:	e8 bb db ff ff       	call   80103180 <end_op>
  return 0;
801055c5:	83 c4 10             	add    $0x10,%esp
801055c8:	31 c0                	xor    %eax,%eax
}
801055ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055cd:	5b                   	pop    %ebx
801055ce:	5e                   	pop    %esi
801055cf:	5f                   	pop    %edi
801055d0:	5d                   	pop    %ebp
801055d1:	c3                   	ret    
801055d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	56                   	push   %esi
801055dc:	e8 3f c8 ff ff       	call   80101e20 <iunlockput>
    goto bad;
801055e1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801055e4:	83 ec 0c             	sub    $0xc,%esp
801055e7:	53                   	push   %ebx
801055e8:	e8 a3 c5 ff ff       	call   80101b90 <ilock>
  ip->nlink--;
801055ed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055f2:	89 1c 24             	mov    %ebx,(%esp)
801055f5:	e8 e6 c4 ff ff       	call   80101ae0 <iupdate>
  iunlockput(ip);
801055fa:	89 1c 24             	mov    %ebx,(%esp)
801055fd:	e8 1e c8 ff ff       	call   80101e20 <iunlockput>
  end_op();
80105602:	e8 79 db ff ff       	call   80103180 <end_op>
  return -1;
80105607:	83 c4 10             	add    $0x10,%esp
8010560a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010560f:	eb b9                	jmp    801055ca <sys_link+0xda>
    iunlockput(ip);
80105611:	83 ec 0c             	sub    $0xc,%esp
80105614:	53                   	push   %ebx
80105615:	e8 06 c8 ff ff       	call   80101e20 <iunlockput>
    end_op();
8010561a:	e8 61 db ff ff       	call   80103180 <end_op>
    return -1;
8010561f:	83 c4 10             	add    $0x10,%esp
80105622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105627:	eb a1                	jmp    801055ca <sys_link+0xda>
    end_op();
80105629:	e8 52 db ff ff       	call   80103180 <end_op>
    return -1;
8010562e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105633:	eb 95                	jmp    801055ca <sys_link+0xda>
80105635:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105640 <sys_unlink>:
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105645:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105648:	53                   	push   %ebx
80105649:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010564c:	50                   	push   %eax
8010564d:	6a 00                	push   $0x0
8010564f:	e8 2c fa ff ff       	call   80105080 <argstr>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
80105659:	0f 88 91 01 00 00    	js     801057f0 <sys_unlink+0x1b0>
  begin_op();
8010565f:	e8 ac da ff ff       	call   80103110 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105664:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105667:	83 ec 08             	sub    $0x8,%esp
8010566a:	53                   	push   %ebx
8010566b:	ff 75 c0             	pushl  -0x40(%ebp)
8010566e:	e8 dd cd ff ff       	call   80102450 <nameiparent>
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	89 c6                	mov    %eax,%esi
80105678:	85 c0                	test   %eax,%eax
8010567a:	0f 84 7a 01 00 00    	je     801057fa <sys_unlink+0x1ba>
  ilock(dp);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	50                   	push   %eax
80105684:	e8 07 c5 ff ff       	call   80101b90 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105689:	58                   	pop    %eax
8010568a:	5a                   	pop    %edx
8010568b:	68 54 82 10 80       	push   $0x80108254
80105690:	53                   	push   %ebx
80105691:	e8 0a ca ff ff       	call   801020a0 <namecmp>
80105696:	83 c4 10             	add    $0x10,%esp
80105699:	85 c0                	test   %eax,%eax
8010569b:	0f 84 0f 01 00 00    	je     801057b0 <sys_unlink+0x170>
801056a1:	83 ec 08             	sub    $0x8,%esp
801056a4:	68 53 82 10 80       	push   $0x80108253
801056a9:	53                   	push   %ebx
801056aa:	e8 f1 c9 ff ff       	call   801020a0 <namecmp>
801056af:	83 c4 10             	add    $0x10,%esp
801056b2:	85 c0                	test   %eax,%eax
801056b4:	0f 84 f6 00 00 00    	je     801057b0 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
801056ba:	83 ec 04             	sub    $0x4,%esp
801056bd:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801056c0:	50                   	push   %eax
801056c1:	53                   	push   %ebx
801056c2:	56                   	push   %esi
801056c3:	e8 f8 c9 ff ff       	call   801020c0 <dirlookup>
801056c8:	83 c4 10             	add    $0x10,%esp
801056cb:	89 c3                	mov    %eax,%ebx
801056cd:	85 c0                	test   %eax,%eax
801056cf:	0f 84 db 00 00 00    	je     801057b0 <sys_unlink+0x170>
  ilock(ip);
801056d5:	83 ec 0c             	sub    $0xc,%esp
801056d8:	50                   	push   %eax
801056d9:	e8 b2 c4 ff ff       	call   80101b90 <ilock>
  if(ip->nlink < 1)
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801056e6:	0f 8e 37 01 00 00    	jle    80105823 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801056ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056f1:	8d 7d d8             	lea    -0x28(%ebp),%edi
801056f4:	74 6a                	je     80105760 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801056f6:	83 ec 04             	sub    $0x4,%esp
801056f9:	6a 10                	push   $0x10
801056fb:	6a 00                	push   $0x0
801056fd:	57                   	push   %edi
801056fe:	e8 ed f5 ff ff       	call   80104cf0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105703:	6a 10                	push   $0x10
80105705:	ff 75 c4             	pushl  -0x3c(%ebp)
80105708:	57                   	push   %edi
80105709:	56                   	push   %esi
8010570a:	e8 61 c8 ff ff       	call   80101f70 <writei>
8010570f:	83 c4 20             	add    $0x20,%esp
80105712:	83 f8 10             	cmp    $0x10,%eax
80105715:	0f 85 fb 00 00 00    	jne    80105816 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
8010571b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105720:	0f 84 aa 00 00 00    	je     801057d0 <sys_unlink+0x190>
  iunlockput(dp);
80105726:	83 ec 0c             	sub    $0xc,%esp
80105729:	56                   	push   %esi
8010572a:	e8 f1 c6 ff ff       	call   80101e20 <iunlockput>
  ip->nlink--;
8010572f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105734:	89 1c 24             	mov    %ebx,(%esp)
80105737:	e8 a4 c3 ff ff       	call   80101ae0 <iupdate>
  iunlockput(ip);
8010573c:	89 1c 24             	mov    %ebx,(%esp)
8010573f:	e8 dc c6 ff ff       	call   80101e20 <iunlockput>
  end_op();
80105744:	e8 37 da ff ff       	call   80103180 <end_op>
  return 0;
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	31 c0                	xor    %eax,%eax
}
8010574e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105751:	5b                   	pop    %ebx
80105752:	5e                   	pop    %esi
80105753:	5f                   	pop    %edi
80105754:	5d                   	pop    %ebp
80105755:	c3                   	ret    
80105756:	8d 76 00             	lea    0x0(%esi),%esi
80105759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105760:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105764:	76 90                	jbe    801056f6 <sys_unlink+0xb6>
80105766:	ba 20 00 00 00       	mov    $0x20,%edx
8010576b:	eb 0f                	jmp    8010577c <sys_unlink+0x13c>
8010576d:	8d 76 00             	lea    0x0(%esi),%esi
80105770:	83 c2 10             	add    $0x10,%edx
80105773:	39 53 58             	cmp    %edx,0x58(%ebx)
80105776:	0f 86 7a ff ff ff    	jbe    801056f6 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010577c:	6a 10                	push   $0x10
8010577e:	52                   	push   %edx
8010577f:	57                   	push   %edi
80105780:	53                   	push   %ebx
80105781:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105784:	e8 e7 c6 ff ff       	call   80101e70 <readi>
80105789:	83 c4 10             	add    $0x10,%esp
8010578c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010578f:	83 f8 10             	cmp    $0x10,%eax
80105792:	75 75                	jne    80105809 <sys_unlink+0x1c9>
    if(de.inum != 0)
80105794:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105799:	74 d5                	je     80105770 <sys_unlink+0x130>
    iunlockput(ip);
8010579b:	83 ec 0c             	sub    $0xc,%esp
8010579e:	53                   	push   %ebx
8010579f:	e8 7c c6 ff ff       	call   80101e20 <iunlockput>
    goto bad;
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	89 f6                	mov    %esi,%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  iunlockput(dp);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	56                   	push   %esi
801057b4:	e8 67 c6 ff ff       	call   80101e20 <iunlockput>
  end_op();
801057b9:	e8 c2 d9 ff ff       	call   80103180 <end_op>
  return -1;
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c6:	eb 86                	jmp    8010574e <sys_unlink+0x10e>
801057c8:	90                   	nop
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(dp);
801057d0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801057d3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801057d8:	56                   	push   %esi
801057d9:	e8 02 c3 ff ff       	call   80101ae0 <iupdate>
801057de:	83 c4 10             	add    $0x10,%esp
801057e1:	e9 40 ff ff ff       	jmp    80105726 <sys_unlink+0xe6>
801057e6:	8d 76 00             	lea    0x0(%esi),%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801057f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f5:	e9 54 ff ff ff       	jmp    8010574e <sys_unlink+0x10e>
    end_op();
801057fa:	e8 81 d9 ff ff       	call   80103180 <end_op>
    return -1;
801057ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105804:	e9 45 ff ff ff       	jmp    8010574e <sys_unlink+0x10e>
      panic("isdirempty: readi");
80105809:	83 ec 0c             	sub    $0xc,%esp
8010580c:	68 78 82 10 80       	push   $0x80108278
80105811:	e8 ca ab ff ff       	call   801003e0 <panic>
    panic("unlink: writei");
80105816:	83 ec 0c             	sub    $0xc,%esp
80105819:	68 8a 82 10 80       	push   $0x8010828a
8010581e:	e8 bd ab ff ff       	call   801003e0 <panic>
    panic("unlink: nlink < 1");
80105823:	83 ec 0c             	sub    $0xc,%esp
80105826:	68 66 82 10 80       	push   $0x80108266
8010582b:	e8 b0 ab ff ff       	call   801003e0 <panic>

80105830 <sys_setmemo>:

int
sys_setmemo(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	56                   	push   %esi
80105834:	53                   	push   %ebx
  int i;
  struct proc* cur=myproc();
  for(i=1;i<MAXSHAREDPG;i++)
80105835:	bb 01 00 00 00       	mov    $0x1,%ebx
  struct proc* cur=myproc();
8010583a:	e8 81 e5 ff ff       	call   80103dc0 <myproc>
8010583f:	89 c6                	mov    %eax,%esi
  for(i=1;i<MAXSHAREDPG;i++)
80105841:	eb 0d                	jmp    80105850 <sys_setmemo+0x20>
80105843:	90                   	nop
80105844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105848:	83 c3 01             	add    $0x1,%ebx
8010584b:	83 fb 0a             	cmp    $0xa,%ebx
8010584e:	74 1e                	je     8010586e <sys_setmemo+0x3e>
  {
    if(cur->sharedrec[i]!=0)
80105850:	80 bc 1e 88 00 00 00 	cmpb   $0x0,0x88(%esi,%ebx,1)
80105857:	00 
80105858:	74 ee                	je     80105848 <sys_setmemo+0x18>
    {
      getshared(i);
8010585a:	83 ec 0c             	sub    $0xc,%esp
8010585d:	53                   	push   %ebx
  for(i=1;i<MAXSHAREDPG;i++)
8010585e:	83 c3 01             	add    $0x1,%ebx
      getshared(i);
80105861:	e8 da e7 ff ff       	call   80104040 <getshared>
80105866:	83 c4 10             	add    $0x10,%esp
  for(i=1;i<MAXSHAREDPG;i++)
80105869:	83 fb 0a             	cmp    $0xa,%ebx
8010586c:	75 e2                	jne    80105850 <sys_setmemo+0x20>
    }
  }
  return 0;
}
8010586e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105871:	31 c0                	xor    %eax,%eax
80105873:	5b                   	pop    %ebx
80105874:	5e                   	pop    %esi
80105875:	5d                   	pop    %ebp
80105876:	c3                   	ret    
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105880 <sys_getmemo>:

int
sys_getmemo(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	56                   	push   %esi
80105884:	53                   	push   %ebx
  char *path;
  int n;
  if(argstr(0, &path) < 0)
80105885:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105888:	83 ec 18             	sub    $0x18,%esp
  if(argstr(0, &path) < 0)
8010588b:	50                   	push   %eax
8010588c:	6a 00                	push   $0x0
8010588e:	e8 ed f7 ff ff       	call   80105080 <argstr>
80105893:	83 c4 10             	add    $0x10,%esp
80105896:	85 c0                	test   %eax,%eax
80105898:	78 46                	js     801058e0 <sys_getmemo+0x60>
    return -1;
  struct memo* ch=(struct memo*)getshared(2);
8010589a:	83 ec 0c             	sub    $0xc,%esp
8010589d:	6a 02                	push   $0x2
8010589f:	e8 9c e7 ff ff       	call   80104040 <getshared>
801058a4:	89 c3                	mov    %eax,%ebx
  acquire(&ch->lock);
801058a6:	89 04 24             	mov    %eax,(%esp)
801058a9:	e8 d2 f2 ff ff       	call   80104b80 <acquire>
  strncpy(path, ch->memo, ch->lmemo);
801058ae:	83 c4 0c             	add    $0xc,%esp
801058b1:	8d 43 38             	lea    0x38(%ebx),%eax
801058b4:	ff 73 34             	pushl  0x34(%ebx)
801058b7:	50                   	push   %eax
801058b8:	ff 75 f4             	pushl  -0xc(%ebp)
801058bb:	e8 a0 f5 ff ff       	call   80104e60 <strncpy>
  n=ch->lmemo;
801058c0:	8b 73 34             	mov    0x34(%ebx),%esi
  release(&ch->lock);
801058c3:	89 1c 24             	mov    %ebx,(%esp)
801058c6:	e8 d5 f3 ff ff       	call   80104ca0 <release>
  path[n]=0;
801058cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  return n;
801058ce:	83 c4 10             	add    $0x10,%esp
  path[n]=0;
801058d1:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
801058d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058d8:	89 f0                	mov    %esi,%eax
801058da:	5b                   	pop    %ebx
801058db:	5e                   	pop    %esi
801058dc:	5d                   	pop    %ebp
801058dd:	c3                   	ret    
801058de:	66 90                	xchg   %ax,%ax
    return -1;
801058e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801058e5:	eb ee                	jmp    801058d5 <sys_getmemo+0x55>
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058f0 <sys_memo>:

int
sys_memo(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	56                   	push   %esi
801058f4:	53                   	push   %ebx
  struct file *f;
  int fd;

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058f5:	e8 46 b9 ff ff       	call   80101240 <filealloc>
801058fa:	85 c0                	test   %eax,%eax
801058fc:	74 2e                	je     8010592c <sys_memo+0x3c>
801058fe:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
80105900:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105902:	e8 b9 e4 ff ff       	call   80103dc0 <myproc>
80105907:	89 f6                	mov    %esi,%esi
80105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[fd] == 0){
80105910:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105914:	85 d2                	test   %edx,%edx
80105916:	74 20                	je     80105938 <sys_memo+0x48>
  for(fd = 0; fd < NOFILE; fd++){
80105918:	83 c3 01             	add    $0x1,%ebx
8010591b:	83 fb 10             	cmp    $0x10,%ebx
8010591e:	75 f0                	jne    80105910 <sys_memo+0x20>
    if(f)
      fileclose(f);
80105920:	83 ec 0c             	sub    $0xc,%esp
80105923:	56                   	push   %esi
80105924:	e8 d7 b9 ff ff       	call   80101300 <fileclose>
80105929:	83 c4 10             	add    $0x10,%esp
    return -1;
8010592c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105931:	eb 52                	jmp    80105985 <sys_memo+0x95>
80105933:	90                   	nop
80105934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  f->type = FD_MEMO;
  f->off = 0;
  f->readable = 1;
  f->writable = 1;
  struct memo* ch=(struct memo*)getshared(2);
80105938:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010593b:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  f->readable = 1;
8010593f:	b8 01 01 00 00       	mov    $0x101,%eax
  f->type = FD_MEMO;
80105944:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->off = 0;
8010594a:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = 1;
80105951:	66 89 46 08          	mov    %ax,0x8(%esi)
  struct memo* ch=(struct memo*)getshared(2);
80105955:	6a 02                	push   $0x2
80105957:	e8 e4 e6 ff ff       	call   80104040 <getshared>
  initlock(&ch->lock,"memo");
8010595c:	5a                   	pop    %edx
8010595d:	59                   	pop    %ecx
8010595e:	68 99 82 10 80       	push   $0x80108299
80105963:	50                   	push   %eax
  struct memo* ch=(struct memo*)getshared(2);
80105964:	89 c6                	mov    %eax,%esi
  initlock(&ch->lock,"memo");
80105966:	e8 15 f1 ff ff       	call   80104a80 <initlock>
  acquire(&ch->lock);
8010596b:	89 34 24             	mov    %esi,(%esp)
8010596e:	e8 0d f2 ff ff       	call   80104b80 <acquire>
  ch->lmemo=0;
80105973:	c7 46 34 00 00 00 00 	movl   $0x0,0x34(%esi)
  release(&ch->lock);
8010597a:	89 34 24             	mov    %esi,(%esp)
8010597d:	e8 1e f3 ff ff       	call   80104ca0 <release>
  return fd;
80105982:	83 c4 10             	add    $0x10,%esp
}
80105985:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105988:	89 d8                	mov    %ebx,%eax
8010598a:	5b                   	pop    %ebx
8010598b:	5e                   	pop    %esi
8010598c:	5d                   	pop    %ebp
8010598d:	c3                   	ret    
8010598e:	66 90                	xchg   %ax,%ax

80105990 <sys_open>:

int
sys_open(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	57                   	push   %edi
80105994:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105995:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105998:	53                   	push   %ebx
80105999:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010599c:	50                   	push   %eax
8010599d:	6a 00                	push   $0x0
8010599f:	e8 dc f6 ff ff       	call   80105080 <argstr>
801059a4:	83 c4 10             	add    $0x10,%esp
801059a7:	85 c0                	test   %eax,%eax
801059a9:	0f 88 8e 00 00 00    	js     80105a3d <sys_open+0xad>
801059af:	83 ec 08             	sub    $0x8,%esp
801059b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059b5:	50                   	push   %eax
801059b6:	6a 01                	push   $0x1
801059b8:	e8 13 f6 ff ff       	call   80104fd0 <argint>
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	85 c0                	test   %eax,%eax
801059c2:	78 79                	js     80105a3d <sys_open+0xad>
    return -1;

  begin_op();
801059c4:	e8 47 d7 ff ff       	call   80103110 <begin_op>

  if(omode & O_CREATE){
801059c9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801059cd:	75 79                	jne    80105a48 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801059cf:	83 ec 0c             	sub    $0xc,%esp
801059d2:	ff 75 e0             	pushl  -0x20(%ebp)
801059d5:	e8 56 ca ff ff       	call   80102430 <namei>
801059da:	83 c4 10             	add    $0x10,%esp
801059dd:	89 c6                	mov    %eax,%esi
801059df:	85 c0                	test   %eax,%eax
801059e1:	0f 84 7e 00 00 00    	je     80105a65 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801059e7:	83 ec 0c             	sub    $0xc,%esp
801059ea:	50                   	push   %eax
801059eb:	e8 a0 c1 ff ff       	call   80101b90 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801059f0:	83 c4 10             	add    $0x10,%esp
801059f3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801059f8:	0f 84 c2 00 00 00    	je     80105ac0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801059fe:	e8 3d b8 ff ff       	call   80101240 <filealloc>
80105a03:	89 c7                	mov    %eax,%edi
80105a05:	85 c0                	test   %eax,%eax
80105a07:	74 23                	je     80105a2c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a09:	e8 b2 e3 ff ff       	call   80103dc0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a0e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105a10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105a14:	85 d2                	test   %edx,%edx
80105a16:	74 60                	je     80105a78 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105a18:	83 c3 01             	add    $0x1,%ebx
80105a1b:	83 fb 10             	cmp    $0x10,%ebx
80105a1e:	75 f0                	jne    80105a10 <sys_open+0x80>
    if(f)
      fileclose(f);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	57                   	push   %edi
80105a24:	e8 d7 b8 ff ff       	call   80101300 <fileclose>
80105a29:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a2c:	83 ec 0c             	sub    $0xc,%esp
80105a2f:	56                   	push   %esi
80105a30:	e8 eb c3 ff ff       	call   80101e20 <iunlockput>
    end_op();
80105a35:	e8 46 d7 ff ff       	call   80103180 <end_op>
    return -1;
80105a3a:	83 c4 10             	add    $0x10,%esp
80105a3d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a42:	eb 6d                	jmp    80105ab1 <sys_open+0x121>
80105a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105a48:	83 ec 0c             	sub    $0xc,%esp
80105a4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a4e:	31 c9                	xor    %ecx,%ecx
80105a50:	ba 02 00 00 00       	mov    $0x2,%edx
80105a55:	6a 00                	push   $0x0
80105a57:	e8 c4 f6 ff ff       	call   80105120 <create>
    if(ip == 0){
80105a5c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105a5f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105a61:	85 c0                	test   %eax,%eax
80105a63:	75 99                	jne    801059fe <sys_open+0x6e>
      end_op();
80105a65:	e8 16 d7 ff ff       	call   80103180 <end_op>
      return -1;
80105a6a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a6f:	eb 40                	jmp    80105ab1 <sys_open+0x121>
80105a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105a78:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105a7b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105a7f:	56                   	push   %esi
80105a80:	e8 eb c1 ff ff       	call   80101c70 <iunlock>
  end_op();
80105a85:	e8 f6 d6 ff ff       	call   80103180 <end_op>

  f->type = FD_INODE;
80105a8a:	c7 07 03 00 00 00    	movl   $0x3,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a93:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105a96:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105a99:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105a9b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105aa2:	f7 d0                	not    %eax
80105aa4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105aa7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105aaa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105aad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105ab1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab4:	89 d8                	mov    %ebx,%eax
80105ab6:	5b                   	pop    %ebx
80105ab7:	5e                   	pop    %esi
80105ab8:	5f                   	pop    %edi
80105ab9:	5d                   	pop    %ebp
80105aba:	c3                   	ret    
80105abb:	90                   	nop
80105abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ac0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ac3:	85 c9                	test   %ecx,%ecx
80105ac5:	0f 84 33 ff ff ff    	je     801059fe <sys_open+0x6e>
80105acb:	e9 5c ff ff ff       	jmp    80105a2c <sys_open+0x9c>

80105ad0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ad6:	e8 35 d6 ff ff       	call   80103110 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105adb:	83 ec 08             	sub    $0x8,%esp
80105ade:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ae1:	50                   	push   %eax
80105ae2:	6a 00                	push   $0x0
80105ae4:	e8 97 f5 ff ff       	call   80105080 <argstr>
80105ae9:	83 c4 10             	add    $0x10,%esp
80105aec:	85 c0                	test   %eax,%eax
80105aee:	78 30                	js     80105b20 <sys_mkdir+0x50>
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af6:	31 c9                	xor    %ecx,%ecx
80105af8:	ba 01 00 00 00       	mov    $0x1,%edx
80105afd:	6a 00                	push   $0x0
80105aff:	e8 1c f6 ff ff       	call   80105120 <create>
80105b04:	83 c4 10             	add    $0x10,%esp
80105b07:	85 c0                	test   %eax,%eax
80105b09:	74 15                	je     80105b20 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b0b:	83 ec 0c             	sub    $0xc,%esp
80105b0e:	50                   	push   %eax
80105b0f:	e8 0c c3 ff ff       	call   80101e20 <iunlockput>
  end_op();
80105b14:	e8 67 d6 ff ff       	call   80103180 <end_op>
  return 0;
80105b19:	83 c4 10             	add    $0x10,%esp
80105b1c:	31 c0                	xor    %eax,%eax
}
80105b1e:	c9                   	leave  
80105b1f:	c3                   	ret    
    end_op();
80105b20:	e8 5b d6 ff ff       	call   80103180 <end_op>
    return -1;
80105b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b2a:	c9                   	leave  
80105b2b:	c3                   	ret    
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b30 <sys_mknod>:

int
sys_mknod(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105b36:	e8 d5 d5 ff ff       	call   80103110 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105b3b:	83 ec 08             	sub    $0x8,%esp
80105b3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b41:	50                   	push   %eax
80105b42:	6a 00                	push   $0x0
80105b44:	e8 37 f5 ff ff       	call   80105080 <argstr>
80105b49:	83 c4 10             	add    $0x10,%esp
80105b4c:	85 c0                	test   %eax,%eax
80105b4e:	78 60                	js     80105bb0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105b50:	83 ec 08             	sub    $0x8,%esp
80105b53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b56:	50                   	push   %eax
80105b57:	6a 01                	push   $0x1
80105b59:	e8 72 f4 ff ff       	call   80104fd0 <argint>
  if((argstr(0, &path)) < 0 ||
80105b5e:	83 c4 10             	add    $0x10,%esp
80105b61:	85 c0                	test   %eax,%eax
80105b63:	78 4b                	js     80105bb0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105b65:	83 ec 08             	sub    $0x8,%esp
80105b68:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b6b:	50                   	push   %eax
80105b6c:	6a 02                	push   $0x2
80105b6e:	e8 5d f4 ff ff       	call   80104fd0 <argint>
     argint(1, &major) < 0 ||
80105b73:	83 c4 10             	add    $0x10,%esp
80105b76:	85 c0                	test   %eax,%eax
80105b78:	78 36                	js     80105bb0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b7a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105b7e:	83 ec 0c             	sub    $0xc,%esp
80105b81:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105b85:	ba 03 00 00 00       	mov    $0x3,%edx
80105b8a:	50                   	push   %eax
80105b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b8e:	e8 8d f5 ff ff       	call   80105120 <create>
     argint(2, &minor) < 0 ||
80105b93:	83 c4 10             	add    $0x10,%esp
80105b96:	85 c0                	test   %eax,%eax
80105b98:	74 16                	je     80105bb0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b9a:	83 ec 0c             	sub    $0xc,%esp
80105b9d:	50                   	push   %eax
80105b9e:	e8 7d c2 ff ff       	call   80101e20 <iunlockput>
  end_op();
80105ba3:	e8 d8 d5 ff ff       	call   80103180 <end_op>
  return 0;
80105ba8:	83 c4 10             	add    $0x10,%esp
80105bab:	31 c0                	xor    %eax,%eax
}
80105bad:	c9                   	leave  
80105bae:	c3                   	ret    
80105baf:	90                   	nop
    end_op();
80105bb0:	e8 cb d5 ff ff       	call   80103180 <end_op>
    return -1;
80105bb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bba:	c9                   	leave  
80105bbb:	c3                   	ret    
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <sys_chdir>:

int
sys_chdir(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	56                   	push   %esi
80105bc4:	53                   	push   %ebx
80105bc5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105bc8:	e8 f3 e1 ff ff       	call   80103dc0 <myproc>
80105bcd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105bcf:	e8 3c d5 ff ff       	call   80103110 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105bd4:	83 ec 08             	sub    $0x8,%esp
80105bd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bda:	50                   	push   %eax
80105bdb:	6a 00                	push   $0x0
80105bdd:	e8 9e f4 ff ff       	call   80105080 <argstr>
80105be2:	83 c4 10             	add    $0x10,%esp
80105be5:	85 c0                	test   %eax,%eax
80105be7:	78 77                	js     80105c60 <sys_chdir+0xa0>
80105be9:	83 ec 0c             	sub    $0xc,%esp
80105bec:	ff 75 f4             	pushl  -0xc(%ebp)
80105bef:	e8 3c c8 ff ff       	call   80102430 <namei>
80105bf4:	83 c4 10             	add    $0x10,%esp
80105bf7:	89 c3                	mov    %eax,%ebx
80105bf9:	85 c0                	test   %eax,%eax
80105bfb:	74 63                	je     80105c60 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105bfd:	83 ec 0c             	sub    $0xc,%esp
80105c00:	50                   	push   %eax
80105c01:	e8 8a bf ff ff       	call   80101b90 <ilock>
  if(ip->type != T_DIR){
80105c06:	83 c4 10             	add    $0x10,%esp
80105c09:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c0e:	75 30                	jne    80105c40 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c10:	83 ec 0c             	sub    $0xc,%esp
80105c13:	53                   	push   %ebx
80105c14:	e8 57 c0 ff ff       	call   80101c70 <iunlock>
  iput(curproc->cwd);
80105c19:	58                   	pop    %eax
80105c1a:	ff 76 68             	pushl  0x68(%esi)
80105c1d:	e8 9e c0 ff ff       	call   80101cc0 <iput>
  end_op();
80105c22:	e8 59 d5 ff ff       	call   80103180 <end_op>
  curproc->cwd = ip;
80105c27:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105c2a:	83 c4 10             	add    $0x10,%esp
80105c2d:	31 c0                	xor    %eax,%eax
}
80105c2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c32:	5b                   	pop    %ebx
80105c33:	5e                   	pop    %esi
80105c34:	5d                   	pop    %ebp
80105c35:	c3                   	ret    
80105c36:	8d 76 00             	lea    0x0(%esi),%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	53                   	push   %ebx
80105c44:	e8 d7 c1 ff ff       	call   80101e20 <iunlockput>
    end_op();
80105c49:	e8 32 d5 ff ff       	call   80103180 <end_op>
    return -1;
80105c4e:	83 c4 10             	add    $0x10,%esp
80105c51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c56:	eb d7                	jmp    80105c2f <sys_chdir+0x6f>
80105c58:	90                   	nop
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105c60:	e8 1b d5 ff ff       	call   80103180 <end_op>
    return -1;
80105c65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c6a:	eb c3                	jmp    80105c2f <sys_chdir+0x6f>
80105c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c70 <sys_exec>:

int
sys_exec(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c75:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105c7b:	53                   	push   %ebx
80105c7c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c82:	50                   	push   %eax
80105c83:	6a 00                	push   $0x0
80105c85:	e8 f6 f3 ff ff       	call   80105080 <argstr>
80105c8a:	83 c4 10             	add    $0x10,%esp
80105c8d:	85 c0                	test   %eax,%eax
80105c8f:	0f 88 87 00 00 00    	js     80105d1c <sys_exec+0xac>
80105c95:	83 ec 08             	sub    $0x8,%esp
80105c98:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c9e:	50                   	push   %eax
80105c9f:	6a 01                	push   $0x1
80105ca1:	e8 2a f3 ff ff       	call   80104fd0 <argint>
80105ca6:	83 c4 10             	add    $0x10,%esp
80105ca9:	85 c0                	test   %eax,%eax
80105cab:	78 6f                	js     80105d1c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105cad:	83 ec 04             	sub    $0x4,%esp
80105cb0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105cb6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105cb8:	68 80 00 00 00       	push   $0x80
80105cbd:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105cc3:	6a 00                	push   $0x0
80105cc5:	50                   	push   %eax
80105cc6:	e8 25 f0 ff ff       	call   80104cf0 <memset>
80105ccb:	83 c4 10             	add    $0x10,%esp
80105cce:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105cd0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105cd6:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105cdd:	83 ec 08             	sub    $0x8,%esp
80105ce0:	57                   	push   %edi
80105ce1:	01 f0                	add    %esi,%eax
80105ce3:	50                   	push   %eax
80105ce4:	e8 47 f2 ff ff       	call   80104f30 <fetchint>
80105ce9:	83 c4 10             	add    $0x10,%esp
80105cec:	85 c0                	test   %eax,%eax
80105cee:	78 2c                	js     80105d1c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105cf0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105cf6:	85 c0                	test   %eax,%eax
80105cf8:	74 36                	je     80105d30 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105cfa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105d00:	83 ec 08             	sub    $0x8,%esp
80105d03:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105d06:	52                   	push   %edx
80105d07:	50                   	push   %eax
80105d08:	e8 63 f2 ff ff       	call   80104f70 <fetchstr>
80105d0d:	83 c4 10             	add    $0x10,%esp
80105d10:	85 c0                	test   %eax,%eax
80105d12:	78 08                	js     80105d1c <sys_exec+0xac>
  for(i=0;; i++){
80105d14:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d17:	83 fb 20             	cmp    $0x20,%ebx
80105d1a:	75 b4                	jne    80105cd0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d24:	5b                   	pop    %ebx
80105d25:	5e                   	pop    %esi
80105d26:	5f                   	pop    %edi
80105d27:	5d                   	pop    %ebp
80105d28:	c3                   	ret    
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105d30:	83 ec 08             	sub    $0x8,%esp
80105d33:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105d39:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d40:	00 00 00 00 
  return exec(path, argv);
80105d44:	50                   	push   %eax
80105d45:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105d4b:	e8 70 b1 ff ff       	call   80100ec0 <exec>
80105d50:	83 c4 10             	add    $0x10,%esp
}
80105d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d56:	5b                   	pop    %ebx
80105d57:	5e                   	pop    %esi
80105d58:	5f                   	pop    %edi
80105d59:	5d                   	pop    %ebp
80105d5a:	c3                   	ret    
80105d5b:	90                   	nop
80105d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d60 <sys_pipe>:

int
sys_pipe(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	57                   	push   %edi
80105d64:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d65:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105d68:	53                   	push   %ebx
80105d69:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d6c:	6a 08                	push   $0x8
80105d6e:	50                   	push   %eax
80105d6f:	6a 00                	push   $0x0
80105d71:	e8 aa f2 ff ff       	call   80105020 <argptr>
80105d76:	83 c4 10             	add    $0x10,%esp
80105d79:	85 c0                	test   %eax,%eax
80105d7b:	78 4a                	js     80105dc7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105d7d:	83 ec 08             	sub    $0x8,%esp
80105d80:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d83:	50                   	push   %eax
80105d84:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d87:	50                   	push   %eax
80105d88:	e8 83 da ff ff       	call   80103810 <pipealloc>
80105d8d:	83 c4 10             	add    $0x10,%esp
80105d90:	85 c0                	test   %eax,%eax
80105d92:	78 33                	js     80105dc7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d94:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105d97:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105d99:	e8 22 e0 ff ff       	call   80103dc0 <myproc>
80105d9e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105da0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105da4:	85 f6                	test   %esi,%esi
80105da6:	74 28                	je     80105dd0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105da8:	83 c3 01             	add    $0x1,%ebx
80105dab:	83 fb 10             	cmp    $0x10,%ebx
80105dae:	75 f0                	jne    80105da0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105db0:	83 ec 0c             	sub    $0xc,%esp
80105db3:	ff 75 e0             	pushl  -0x20(%ebp)
80105db6:	e8 45 b5 ff ff       	call   80101300 <fileclose>
    fileclose(wf);
80105dbb:	58                   	pop    %eax
80105dbc:	ff 75 e4             	pushl  -0x1c(%ebp)
80105dbf:	e8 3c b5 ff ff       	call   80101300 <fileclose>
    return -1;
80105dc4:	83 c4 10             	add    $0x10,%esp
80105dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dcc:	eb 53                	jmp    80105e21 <sys_pipe+0xc1>
80105dce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105dd0:	8d 73 08             	lea    0x8(%ebx),%esi
80105dd3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105dd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105dda:	e8 e1 df ff ff       	call   80103dc0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ddf:	31 d2                	xor    %edx,%edx
80105de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105de8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105dec:	85 c9                	test   %ecx,%ecx
80105dee:	74 20                	je     80105e10 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105df0:	83 c2 01             	add    $0x1,%edx
80105df3:	83 fa 10             	cmp    $0x10,%edx
80105df6:	75 f0                	jne    80105de8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105df8:	e8 c3 df ff ff       	call   80103dc0 <myproc>
80105dfd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e04:	00 
80105e05:	eb a9                	jmp    80105db0 <sys_pipe+0x50>
80105e07:	89 f6                	mov    %esi,%esi
80105e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      curproc->ofile[fd] = f;
80105e10:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105e14:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e17:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e1c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105e1f:	31 c0                	xor    %eax,%eax
}
80105e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e24:	5b                   	pop    %ebx
80105e25:	5e                   	pop    %esi
80105e26:	5f                   	pop    %edi
80105e27:	5d                   	pop    %ebp
80105e28:	c3                   	ret    
80105e29:	66 90                	xchg   %ax,%ax
80105e2b:	66 90                	xchg   %ax,%ax
80105e2d:	66 90                	xchg   %ax,%ax
80105e2f:	90                   	nop

80105e30 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105e30:	e9 fb e2 ff ff       	jmp    80104130 <fork>
80105e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e40 <sys_exit>:
}

int
sys_exit(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e46:	e8 95 e6 ff ff       	call   801044e0 <exit>
  return 0;  // not reached
}
80105e4b:	31 c0                	xor    %eax,%eax
80105e4d:	c9                   	leave  
80105e4e:	c3                   	ret    
80105e4f:	90                   	nop

80105e50 <sys_split>:

int
sys_split(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 20             	sub    $0x20,%esp
  int op;

  if(argint(0, &op) < 0)
80105e56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e59:	50                   	push   %eax
80105e5a:	6a 00                	push   $0x0
80105e5c:	e8 6f f1 ff ff       	call   80104fd0 <argint>
80105e61:	83 c4 10             	add    $0x10,%esp
80105e64:	85 c0                	test   %eax,%eax
80105e66:	78 18                	js     80105e80 <sys_split+0x30>
    return -1;
  splitw(op);
80105e68:	83 ec 0c             	sub    $0xc,%esp
80105e6b:	ff 75 f4             	pushl  -0xc(%ebp)
80105e6e:	e8 ad ad ff ff       	call   80100c20 <splitw>
  return  0;
80105e73:	83 c4 10             	add    $0x10,%esp
80105e76:	31 c0                	xor    %eax,%eax
}
80105e78:	c9                   	leave  
80105e79:	c3                   	ret    
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e80:	c9                   	leave  
    return -1;
80105e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e86:	c3                   	ret    
80105e87:	89 f6                	mov    %esi,%esi
80105e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e90 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105e90:	e9 6b e8 ff ff       	jmp    80104700 <wait>
80105e95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ea0 <sys_kill>:
}

int
sys_kill(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ea6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ea9:	50                   	push   %eax
80105eaa:	6a 00                	push   $0x0
80105eac:	e8 1f f1 ff ff       	call   80104fd0 <argint>
80105eb1:	83 c4 10             	add    $0x10,%esp
80105eb4:	85 c0                	test   %eax,%eax
80105eb6:	78 18                	js     80105ed0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105eb8:	83 ec 0c             	sub    $0xc,%esp
80105ebb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ebe:	e8 6d e9 ff ff       	call   80104830 <kill>
80105ec3:	83 c4 10             	add    $0x10,%esp
}
80105ec6:	c9                   	leave  
80105ec7:	c3                   	ret    
80105ec8:	90                   	nop
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ed0:	c9                   	leave  
    return -1;
80105ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ed6:	c3                   	ret    
80105ed7:	89 f6                	mov    %esi,%esi
80105ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ee0 <sys_getpid>:

int
sys_getpid(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ee6:	e8 d5 de ff ff       	call   80103dc0 <myproc>
80105eeb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105eee:	c9                   	leave  
80105eef:	c3                   	ret    

80105ef0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ef4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ef7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105efa:	50                   	push   %eax
80105efb:	6a 00                	push   $0x0
80105efd:	e8 ce f0 ff ff       	call   80104fd0 <argint>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	85 c0                	test   %eax,%eax
80105f07:	78 27                	js     80105f30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f09:	e8 b2 de ff ff       	call   80103dc0 <myproc>
  if(growproc(n) < 0)
80105f0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f13:	ff 75 f4             	pushl  -0xc(%ebp)
80105f16:	e8 95 e1 ff ff       	call   801040b0 <growproc>
80105f1b:	83 c4 10             	add    $0x10,%esp
80105f1e:	85 c0                	test   %eax,%eax
80105f20:	78 0e                	js     80105f30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f22:	89 d8                	mov    %ebx,%eax
80105f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f27:	c9                   	leave  
80105f28:	c3                   	ret    
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f35:	eb eb                	jmp    80105f22 <sys_sbrk+0x32>
80105f37:	89 f6                	mov    %esi,%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f40 <sys_sleep>:

int
sys_sleep(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f4a:	50                   	push   %eax
80105f4b:	6a 00                	push   $0x0
80105f4d:	e8 7e f0 ff ff       	call   80104fd0 <argint>
80105f52:	83 c4 10             	add    $0x10,%esp
80105f55:	85 c0                	test   %eax,%eax
80105f57:	0f 88 8a 00 00 00    	js     80105fe7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105f5d:	83 ec 0c             	sub    $0xc,%esp
80105f60:	68 60 64 11 80       	push   $0x80116460
80105f65:	e8 16 ec ff ff       	call   80104b80 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105f6d:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  while(ticks - ticks0 < n){
80105f73:	83 c4 10             	add    $0x10,%esp
80105f76:	85 d2                	test   %edx,%edx
80105f78:	75 27                	jne    80105fa1 <sys_sleep+0x61>
80105f7a:	eb 54                	jmp    80105fd0 <sys_sleep+0x90>
80105f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f80:	83 ec 08             	sub    $0x8,%esp
80105f83:	68 60 64 11 80       	push   $0x80116460
80105f88:	68 a0 6c 11 80       	push   $0x80116ca0
80105f8d:	e8 ae e6 ff ff       	call   80104640 <sleep>
  while(ticks - ticks0 < n){
80105f92:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80105f97:	83 c4 10             	add    $0x10,%esp
80105f9a:	29 d8                	sub    %ebx,%eax
80105f9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105f9f:	73 2f                	jae    80105fd0 <sys_sleep+0x90>
    if(myproc()->killed){
80105fa1:	e8 1a de ff ff       	call   80103dc0 <myproc>
80105fa6:	8b 40 24             	mov    0x24(%eax),%eax
80105fa9:	85 c0                	test   %eax,%eax
80105fab:	74 d3                	je     80105f80 <sys_sleep+0x40>
      release(&tickslock);
80105fad:	83 ec 0c             	sub    $0xc,%esp
80105fb0:	68 60 64 11 80       	push   $0x80116460
80105fb5:	e8 e6 ec ff ff       	call   80104ca0 <release>
      return -1;
80105fba:	83 c4 10             	add    $0x10,%esp
80105fbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105fc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fc5:	c9                   	leave  
80105fc6:	c3                   	ret    
80105fc7:	89 f6                	mov    %esi,%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	68 60 64 11 80       	push   $0x80116460
80105fd8:	e8 c3 ec ff ff       	call   80104ca0 <release>
  return 0;
80105fdd:	83 c4 10             	add    $0x10,%esp
80105fe0:	31 c0                	xor    %eax,%eax
}
80105fe2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fe5:	c9                   	leave  
80105fe6:	c3                   	ret    
    return -1;
80105fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fec:	eb f4                	jmp    80105fe2 <sys_sleep+0xa2>
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	53                   	push   %ebx
80105ff4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ff7:	68 60 64 11 80       	push   $0x80116460
80105ffc:	e8 7f eb ff ff       	call   80104b80 <acquire>
  xticks = ticks;
80106001:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  release(&tickslock);
80106007:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
8010600e:	e8 8d ec ff ff       	call   80104ca0 <release>
  return xticks;
}
80106013:	89 d8                	mov    %ebx,%eax
80106015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106018:	c9                   	leave  
80106019:	c3                   	ret    
8010601a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106020 <sys_trace>:

int
sys_trace(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	83 ec 08             	sub    $0x8,%esp
  return myproc()->timepiece;
80106026:	e8 95 dd ff ff       	call   80103dc0 <myproc>
8010602b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80106031:	c9                   	leave  
80106032:	c3                   	ret    
80106033:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106040 <sys_releasesharem>:

int
sys_releasesharem(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	83 ec 20             	sub    $0x20,%esp
  int idx;
  if(argint(0,&idx)<0)
80106046:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106049:	50                   	push   %eax
8010604a:	6a 00                	push   $0x0
8010604c:	e8 7f ef ff ff       	call   80104fd0 <argint>
80106051:	83 c4 10             	add    $0x10,%esp
80106054:	85 c0                	test   %eax,%eax
80106056:	78 18                	js     80106070 <sys_releasesharem+0x30>
    return -1;
  releaseshared(idx);
80106058:	83 ec 0c             	sub    $0xc,%esp
8010605b:	ff 75 f4             	pushl  -0xc(%ebp)
8010605e:	e8 8d df ff ff       	call   80103ff0 <releaseshared>
  return 0;
80106063:	83 c4 10             	add    $0x10,%esp
80106066:	31 c0                	xor    %eax,%eax
}
80106068:	c9                   	leave  
80106069:	c3                   	ret    
8010606a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106070:	c9                   	leave  
    return -1;
80106071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106076:	c3                   	ret    
80106077:	89 f6                	mov    %esi,%esi
80106079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106080 <sys_getsharem>:

int
sys_getsharem(void)
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	83 ec 20             	sub    $0x20,%esp
  int idx;
  if(argint(0,&idx)<0)
80106086:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106089:	50                   	push   %eax
8010608a:	6a 00                	push   $0x0
8010608c:	e8 3f ef ff ff       	call   80104fd0 <argint>
80106091:	83 c4 10             	add    $0x10,%esp
80106094:	85 c0                	test   %eax,%eax
80106096:	78 2a                	js     801060c2 <sys_getsharem+0x42>
    return -1;
  if(idx==1)
80106098:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609b:	83 f8 01             	cmp    $0x1,%eax
8010609e:	74 10                	je     801060b0 <sys_getsharem+0x30>
    getshared(0);
  return (int)getshared(idx);
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	50                   	push   %eax
801060a4:	e8 97 df ff ff       	call   80104040 <getshared>
801060a9:	83 c4 10             	add    $0x10,%esp
}
801060ac:	c9                   	leave  
801060ad:	c3                   	ret    
801060ae:	66 90                	xchg   %ax,%ax
    getshared(0);
801060b0:	83 ec 0c             	sub    $0xc,%esp
801060b3:	6a 00                	push   $0x0
801060b5:	e8 86 df ff ff       	call   80104040 <getshared>
801060ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060bd:	83 c4 10             	add    $0x10,%esp
801060c0:	eb de                	jmp    801060a0 <sys_getsharem+0x20>
}
801060c2:	c9                   	leave  
    return -1;
801060c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060c8:	c3                   	ret    
801060c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060d0 <sys_att>:

int
sys_att(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	83 ec 20             	sub    $0x20,%esp
  int cmd;
  if(argint(0,&cmd)<0)
801060d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060d9:	50                   	push   %eax
801060da:	6a 00                	push   $0x0
801060dc:	e8 ef ee ff ff       	call   80104fd0 <argint>
801060e1:	83 c4 10             	add    $0x10,%esp
801060e4:	85 c0                	test   %eax,%eax
801060e6:	78 1b                	js     80106103 <sys_att+0x33>
  asm volatile("cli");
801060e8:	fa                   	cli    
    return -1;
  cli();
  cpus[0].consflag=cmd;
801060e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ec:	a2 d4 38 11 80       	mov    %al,0x801138d4
  cpus[1].consflag=cmd;
801060f1:	a2 8c 39 11 80       	mov    %al,0x8011398c
  return cpus[0].rtime+cpus[1].rtime;
801060f6:	a1 88 39 11 80       	mov    0x80113988,%eax
801060fb:	03 05 d0 38 11 80    	add    0x801138d0,%eax
}
80106101:	c9                   	leave  
80106102:	c3                   	ret    
80106103:	c9                   	leave  
    return -1;
80106104:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106109:	c3                   	ret    

8010610a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010610a:	1e                   	push   %ds
  pushl %es
8010610b:	06                   	push   %es
  pushl %fs
8010610c:	0f a0                	push   %fs
  pushl %gs
8010610e:	0f a8                	push   %gs
  pushal
80106110:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106111:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106115:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106117:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106119:	54                   	push   %esp
  call trap
8010611a:	e8 c1 00 00 00       	call   801061e0 <trap>
  addl $4, %esp
8010611f:	83 c4 04             	add    $0x4,%esp

80106122 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106122:	61                   	popa   
  popl %gs
80106123:	0f a9                	pop    %gs
  popl %fs
80106125:	0f a1                	pop    %fs
  popl %es
80106127:	07                   	pop    %es
  popl %ds
80106128:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106129:	83 c4 08             	add    $0x8,%esp
  iret
8010612c:	cf                   	iret   
8010612d:	66 90                	xchg   %ax,%ax
8010612f:	90                   	nop

80106130 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106130:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106131:	31 c0                	xor    %eax,%eax
{
80106133:	89 e5                	mov    %esp,%ebp
80106135:	83 ec 08             	sub    $0x8,%esp
80106138:	90                   	nop
80106139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106140:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106147:	c7 04 c5 a2 64 11 80 	movl   $0x8e000008,-0x7fee9b5e(,%eax,8)
8010614e:	08 00 00 8e 
80106152:	66 89 14 c5 a0 64 11 	mov    %dx,-0x7fee9b60(,%eax,8)
80106159:	80 
8010615a:	c1 ea 10             	shr    $0x10,%edx
8010615d:	66 89 14 c5 a6 64 11 	mov    %dx,-0x7fee9b5a(,%eax,8)
80106164:	80 
  for(i = 0; i < 256; i++)
80106165:	83 c0 01             	add    $0x1,%eax
80106168:	3d 00 01 00 00       	cmp    $0x100,%eax
8010616d:	75 d1                	jne    80106140 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010616f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106172:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106177:	c7 05 a2 66 11 80 08 	movl   $0xef000008,0x801166a2
8010617e:	00 00 ef 
  initlock(&tickslock, "time");
80106181:	68 9e 82 10 80       	push   $0x8010829e
80106186:	68 60 64 11 80       	push   $0x80116460
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010618b:	66 a3 a0 66 11 80    	mov    %ax,0x801166a0
80106191:	c1 e8 10             	shr    $0x10,%eax
80106194:	66 a3 a6 66 11 80    	mov    %ax,0x801166a6
  initlock(&tickslock, "time");
8010619a:	e8 e1 e8 ff ff       	call   80104a80 <initlock>
}
8010619f:	83 c4 10             	add    $0x10,%esp
801061a2:	c9                   	leave  
801061a3:	c3                   	ret    
801061a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801061b0 <idtinit>:

void
idtinit(void)
{
801061b0:	55                   	push   %ebp
  pd[0] = size-1;
801061b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061b6:	89 e5                	mov    %esp,%ebp
801061b8:	83 ec 10             	sub    $0x10,%esp
801061bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061bf:	b8 a0 64 11 80       	mov    $0x801164a0,%eax
801061c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061c8:	c1 e8 10             	shr    $0x10,%eax
801061cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801061d5:	c9                   	leave  
801061d6:	c3                   	ret    
801061d7:	89 f6                	mov    %esi,%esi
801061d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	57                   	push   %edi
801061e4:	56                   	push   %esi
801061e5:	53                   	push   %ebx
801061e6:	83 ec 1c             	sub    $0x1c,%esp
801061e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801061ec:	8b 47 30             	mov    0x30(%edi),%eax
801061ef:	83 f8 40             	cmp    $0x40,%eax
801061f2:	0f 84 c8 01 00 00    	je     801063c0 <trap+0x1e0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801061f8:	83 e8 20             	sub    $0x20,%eax
801061fb:	83 f8 1f             	cmp    $0x1f,%eax
801061fe:	77 10                	ja     80106210 <trap+0x30>
80106200:	ff 24 85 44 83 10 80 	jmp    *-0x7fef7cbc(,%eax,4)
80106207:	89 f6                	mov    %esi,%esi
80106209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106210:	e8 ab db ff ff       	call   80103dc0 <myproc>
80106215:	8b 5f 38             	mov    0x38(%edi),%ebx
80106218:	85 c0                	test   %eax,%eax
8010621a:	0f 84 4a 02 00 00    	je     8010646a <trap+0x28a>
80106220:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106224:	0f 84 40 02 00 00    	je     8010646a <trap+0x28a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010622a:	0f 20 d1             	mov    %cr2,%ecx
8010622d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106230:	e8 6b db ff ff       	call   80103da0 <cpuid>
80106235:	8b 77 30             	mov    0x30(%edi),%esi
80106238:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010623b:	8b 47 34             	mov    0x34(%edi),%eax
8010623e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106241:	e8 7a db ff ff       	call   80103dc0 <myproc>
80106246:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106249:	e8 72 db ff ff       	call   80103dc0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010624e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106251:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106254:	51                   	push   %ecx
80106255:	53                   	push   %ebx
80106256:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106257:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010625a:	ff 75 e4             	pushl  -0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
8010625d:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106260:	56                   	push   %esi
80106261:	52                   	push   %edx
80106262:	ff 70 10             	pushl  0x10(%eax)
80106265:	68 00 83 10 80       	push   $0x80108300
8010626a:	e8 81 a4 ff ff       	call   801006f0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010626f:	83 c4 20             	add    $0x20,%esp
80106272:	e8 49 db ff ff       	call   80103dc0 <myproc>
80106277:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010627e:	e8 3d db ff ff       	call   80103dc0 <myproc>
80106283:	85 c0                	test   %eax,%eax
80106285:	74 1d                	je     801062a4 <trap+0xc4>
80106287:	e8 34 db ff ff       	call   80103dc0 <myproc>
8010628c:	8b 50 24             	mov    0x24(%eax),%edx
8010628f:	85 d2                	test   %edx,%edx
80106291:	74 11                	je     801062a4 <trap+0xc4>
80106293:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106297:	83 e0 03             	and    $0x3,%eax
8010629a:	66 83 f8 03          	cmp    $0x3,%ax
8010629e:	0f 84 74 01 00 00    	je     80106418 <trap+0x238>
    exit();

  //brand new
  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(tf->trapno == T_IRQ0+IRQ_TIMER)
801062a4:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801062a8:	0f 84 52 01 00 00    	je     80106400 <trap+0x220>
  {
    mycpu()->rtime++;
  }
  if(myproc() && myproc()->state == RUNNING &&
801062ae:	e8 0d db ff ff       	call   80103dc0 <myproc>
801062b3:	85 c0                	test   %eax,%eax
801062b5:	74 0b                	je     801062c2 <trap+0xe2>
801062b7:	e8 04 db ff ff       	call   80103dc0 <myproc>
801062bc:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062c0:	74 2e                	je     801062f0 <trap+0x110>
    yield();
    title();
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062c2:	e8 f9 da ff ff       	call   80103dc0 <myproc>
801062c7:	85 c0                	test   %eax,%eax
801062c9:	74 1d                	je     801062e8 <trap+0x108>
801062cb:	e8 f0 da ff ff       	call   80103dc0 <myproc>
801062d0:	8b 40 24             	mov    0x24(%eax),%eax
801062d3:	85 c0                	test   %eax,%eax
801062d5:	74 11                	je     801062e8 <trap+0x108>
801062d7:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801062db:	83 e0 03             	and    $0x3,%eax
801062de:	66 83 f8 03          	cmp    $0x3,%ax
801062e2:	0f 84 05 01 00 00    	je     801063ed <trap+0x20d>
    exit();
}
801062e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062eb:	5b                   	pop    %ebx
801062ec:	5e                   	pop    %esi
801062ed:	5f                   	pop    %edi
801062ee:	5d                   	pop    %ebp
801062ef:	c3                   	ret    
  if(myproc() && myproc()->state == RUNNING &&
801062f0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801062f4:	75 cc                	jne    801062c2 <trap+0xe2>
     tf->trapno == T_IRQ0+IRQ_TIMER && (--myproc()->timepiece)<=0)
801062f6:	e8 c5 da ff ff       	call   80103dc0 <myproc>
801062fb:	83 a8 84 00 00 00 01 	subl   $0x1,0x84(%eax)
80106302:	75 be                	jne    801062c2 <trap+0xe2>
    yield();
80106304:	e8 c7 e2 ff ff       	call   801045d0 <yield>
    title();
80106309:	e8 82 a6 ff ff       	call   80100990 <title>
8010630e:	eb b2                	jmp    801062c2 <trap+0xe2>
    if(cpuid() == 0){
80106310:	e8 8b da ff ff       	call   80103da0 <cpuid>
80106315:	85 c0                	test   %eax,%eax
80106317:	0f 84 0b 01 00 00    	je     80106428 <trap+0x248>
    lapiceoi();
8010631d:	e8 9e c9 ff ff       	call   80102cc0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106322:	e8 99 da ff ff       	call   80103dc0 <myproc>
80106327:	85 c0                	test   %eax,%eax
80106329:	0f 85 58 ff ff ff    	jne    80106287 <trap+0xa7>
8010632f:	e9 70 ff ff ff       	jmp    801062a4 <trap+0xc4>
80106334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106338:	e8 43 c8 ff ff       	call   80102b80 <kbdintr>
    lapiceoi();
8010633d:	e8 7e c9 ff ff       	call   80102cc0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106342:	e8 79 da ff ff       	call   80103dc0 <myproc>
80106347:	85 c0                	test   %eax,%eax
80106349:	0f 85 38 ff ff ff    	jne    80106287 <trap+0xa7>
8010634f:	e9 50 ff ff ff       	jmp    801062a4 <trap+0xc4>
80106354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106358:	e8 b3 02 00 00       	call   80106610 <uartintr>
    lapiceoi();
8010635d:	e8 5e c9 ff ff       	call   80102cc0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106362:	e8 59 da ff ff       	call   80103dc0 <myproc>
80106367:	85 c0                	test   %eax,%eax
80106369:	0f 85 18 ff ff ff    	jne    80106287 <trap+0xa7>
8010636f:	e9 30 ff ff ff       	jmp    801062a4 <trap+0xc4>
80106374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106378:	8b 77 38             	mov    0x38(%edi),%esi
8010637b:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010637f:	e8 1c da ff ff       	call   80103da0 <cpuid>
80106384:	56                   	push   %esi
80106385:	53                   	push   %ebx
80106386:	50                   	push   %eax
80106387:	68 a8 82 10 80       	push   $0x801082a8
8010638c:	e8 5f a3 ff ff       	call   801006f0 <cprintf>
    lapiceoi();
80106391:	e8 2a c9 ff ff       	call   80102cc0 <lapiceoi>
    break;
80106396:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106399:	e8 22 da ff ff       	call   80103dc0 <myproc>
8010639e:	85 c0                	test   %eax,%eax
801063a0:	0f 85 e1 fe ff ff    	jne    80106287 <trap+0xa7>
801063a6:	e9 f9 fe ff ff       	jmp    801062a4 <trap+0xc4>
801063ab:	90                   	nop
801063ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801063b0:	e8 1b c2 ff ff       	call   801025d0 <ideintr>
801063b5:	e9 63 ff ff ff       	jmp    8010631d <trap+0x13d>
801063ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801063c0:	e8 fb d9 ff ff       	call   80103dc0 <myproc>
801063c5:	8b 58 24             	mov    0x24(%eax),%ebx
801063c8:	85 db                	test   %ebx,%ebx
801063ca:	0f 85 90 00 00 00    	jne    80106460 <trap+0x280>
    myproc()->tf = tf;
801063d0:	e8 eb d9 ff ff       	call   80103dc0 <myproc>
801063d5:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801063d8:	e8 e3 ec ff ff       	call   801050c0 <syscall>
    if(myproc()->killed)
801063dd:	e8 de d9 ff ff       	call   80103dc0 <myproc>
801063e2:	8b 48 24             	mov    0x24(%eax),%ecx
801063e5:	85 c9                	test   %ecx,%ecx
801063e7:	0f 84 fb fe ff ff    	je     801062e8 <trap+0x108>
}
801063ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f0:	5b                   	pop    %ebx
801063f1:	5e                   	pop    %esi
801063f2:	5f                   	pop    %edi
801063f3:	5d                   	pop    %ebp
      exit();
801063f4:	e9 e7 e0 ff ff       	jmp    801044e0 <exit>
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    mycpu()->rtime++;
80106400:	e8 1b d9 ff ff       	call   80103d20 <mycpu>
80106405:	83 80 b0 00 00 00 01 	addl   $0x1,0xb0(%eax)
8010640c:	e9 9d fe ff ff       	jmp    801062ae <trap+0xce>
80106411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106418:	e8 c3 e0 ff ff       	call   801044e0 <exit>
8010641d:	e9 82 fe ff ff       	jmp    801062a4 <trap+0xc4>
80106422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106428:	83 ec 0c             	sub    $0xc,%esp
8010642b:	68 60 64 11 80       	push   $0x80116460
80106430:	e8 4b e7 ff ff       	call   80104b80 <acquire>
      wakeup(&ticks);
80106435:	c7 04 24 a0 6c 11 80 	movl   $0x80116ca0,(%esp)
      ticks++;
8010643c:	83 05 a0 6c 11 80 01 	addl   $0x1,0x80116ca0
      wakeup(&ticks);
80106443:	e8 b8 e3 ff ff       	call   80104800 <wakeup>
      release(&tickslock);
80106448:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
8010644f:	e8 4c e8 ff ff       	call   80104ca0 <release>
80106454:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106457:	e9 c1 fe ff ff       	jmp    8010631d <trap+0x13d>
8010645c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80106460:	e8 7b e0 ff ff       	call   801044e0 <exit>
80106465:	e9 66 ff ff ff       	jmp    801063d0 <trap+0x1f0>
8010646a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010646d:	e8 2e d9 ff ff       	call   80103da0 <cpuid>
80106472:	83 ec 0c             	sub    $0xc,%esp
80106475:	56                   	push   %esi
80106476:	53                   	push   %ebx
80106477:	50                   	push   %eax
80106478:	ff 77 30             	pushl  0x30(%edi)
8010647b:	68 cc 82 10 80       	push   $0x801082cc
80106480:	e8 6b a2 ff ff       	call   801006f0 <cprintf>
      panic("trap");
80106485:	83 c4 14             	add    $0x14,%esp
80106488:	68 a3 82 10 80       	push   $0x801082a3
8010648d:	e8 4e 9f ff ff       	call   801003e0 <panic>
80106492:	66 90                	xchg   %ax,%ax
80106494:	66 90                	xchg   %ax,%ax
80106496:	66 90                	xchg   %ax,%ax
80106498:	66 90                	xchg   %ax,%ax
8010649a:	66 90                	xchg   %ax,%ax
8010649c:	66 90                	xchg   %ax,%ax
8010649e:	66 90                	xchg   %ax,%ax

801064a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801064a0:	a1 dc b5 10 80       	mov    0x8010b5dc,%eax
801064a5:	85 c0                	test   %eax,%eax
801064a7:	74 17                	je     801064c0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064a9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064ae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801064af:	a8 01                	test   $0x1,%al
801064b1:	74 0d                	je     801064c0 <uartgetc+0x20>
801064b3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064b8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801064b9:	0f b6 c0             	movzbl %al,%eax
801064bc:	c3                   	ret    
801064bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801064c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064c5:	c3                   	ret    
801064c6:	8d 76 00             	lea    0x0(%esi),%esi
801064c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064d0 <uartputc.part.0>:
uartputc(int c)
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	57                   	push   %edi
801064d4:	89 c7                	mov    %eax,%edi
801064d6:	56                   	push   %esi
801064d7:	be fd 03 00 00       	mov    $0x3fd,%esi
801064dc:	53                   	push   %ebx
801064dd:	bb 80 00 00 00       	mov    $0x80,%ebx
801064e2:	83 ec 0c             	sub    $0xc,%esp
801064e5:	eb 1b                	jmp    80106502 <uartputc.part.0+0x32>
801064e7:	89 f6                	mov    %esi,%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801064f0:	83 ec 0c             	sub    $0xc,%esp
801064f3:	6a 0a                	push   $0xa
801064f5:	e8 e6 c7 ff ff       	call   80102ce0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064fa:	83 c4 10             	add    $0x10,%esp
801064fd:	83 eb 01             	sub    $0x1,%ebx
80106500:	74 07                	je     80106509 <uartputc.part.0+0x39>
80106502:	89 f2                	mov    %esi,%edx
80106504:	ec                   	in     (%dx),%al
80106505:	a8 20                	test   $0x20,%al
80106507:	74 e7                	je     801064f0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106509:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010650e:	89 f8                	mov    %edi,%eax
80106510:	ee                   	out    %al,(%dx)
}
80106511:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106514:	5b                   	pop    %ebx
80106515:	5e                   	pop    %esi
80106516:	5f                   	pop    %edi
80106517:	5d                   	pop    %ebp
80106518:	c3                   	ret    
80106519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106520 <uartinit>:
{
80106520:	55                   	push   %ebp
80106521:	31 c9                	xor    %ecx,%ecx
80106523:	89 c8                	mov    %ecx,%eax
80106525:	89 e5                	mov    %esp,%ebp
80106527:	57                   	push   %edi
80106528:	56                   	push   %esi
80106529:	53                   	push   %ebx
8010652a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010652f:	89 da                	mov    %ebx,%edx
80106531:	83 ec 0c             	sub    $0xc,%esp
80106534:	ee                   	out    %al,(%dx)
80106535:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010653a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010653f:	89 fa                	mov    %edi,%edx
80106541:	ee                   	out    %al,(%dx)
80106542:	b8 0c 00 00 00       	mov    $0xc,%eax
80106547:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010654c:	ee                   	out    %al,(%dx)
8010654d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106552:	89 c8                	mov    %ecx,%eax
80106554:	89 f2                	mov    %esi,%edx
80106556:	ee                   	out    %al,(%dx)
80106557:	b8 03 00 00 00       	mov    $0x3,%eax
8010655c:	89 fa                	mov    %edi,%edx
8010655e:	ee                   	out    %al,(%dx)
8010655f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106564:	89 c8                	mov    %ecx,%eax
80106566:	ee                   	out    %al,(%dx)
80106567:	b8 01 00 00 00       	mov    $0x1,%eax
8010656c:	89 f2                	mov    %esi,%edx
8010656e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010656f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106574:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106575:	3c ff                	cmp    $0xff,%al
80106577:	74 56                	je     801065cf <uartinit+0xaf>
  uart = 1;
80106579:	c7 05 dc b5 10 80 01 	movl   $0x1,0x8010b5dc
80106580:	00 00 00 
80106583:	89 da                	mov    %ebx,%edx
80106585:	ec                   	in     (%dx),%al
80106586:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010658b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010658c:	83 ec 08             	sub    $0x8,%esp
8010658f:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106594:	bb c4 83 10 80       	mov    $0x801083c4,%ebx
  ioapicenable(IRQ_COM1, 0);
80106599:	6a 00                	push   $0x0
8010659b:	6a 04                	push   $0x4
8010659d:	e8 7e c2 ff ff       	call   80102820 <ioapicenable>
801065a2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801065a5:	b8 78 00 00 00       	mov    $0x78,%eax
801065aa:	eb 08                	jmp    801065b4 <uartinit+0x94>
801065ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065b0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801065b4:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
801065ba:	85 d2                	test   %edx,%edx
801065bc:	74 08                	je     801065c6 <uartinit+0xa6>
    uartputc(*p);
801065be:	0f be c0             	movsbl %al,%eax
801065c1:	e8 0a ff ff ff       	call   801064d0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801065c6:	89 f0                	mov    %esi,%eax
801065c8:	83 c3 01             	add    $0x1,%ebx
801065cb:	84 c0                	test   %al,%al
801065cd:	75 e1                	jne    801065b0 <uartinit+0x90>
}
801065cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065d2:	5b                   	pop    %ebx
801065d3:	5e                   	pop    %esi
801065d4:	5f                   	pop    %edi
801065d5:	5d                   	pop    %ebp
801065d6:	c3                   	ret    
801065d7:	89 f6                	mov    %esi,%esi
801065d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065e0 <uartputc>:
{
801065e0:	55                   	push   %ebp
  if(!uart)
801065e1:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
{
801065e7:	89 e5                	mov    %esp,%ebp
801065e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801065ec:	85 d2                	test   %edx,%edx
801065ee:	74 10                	je     80106600 <uartputc+0x20>
}
801065f0:	5d                   	pop    %ebp
801065f1:	e9 da fe ff ff       	jmp    801064d0 <uartputc.part.0>
801065f6:	8d 76 00             	lea    0x0(%esi),%esi
801065f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106600:	5d                   	pop    %ebp
80106601:	c3                   	ret    
80106602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106610 <uartintr>:

void
uartintr(void)
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106616:	68 a0 64 10 80       	push   $0x801064a0
8010661b:	e8 a0 a6 ff ff       	call   80100cc0 <consoleintr>
}
80106620:	83 c4 10             	add    $0x10,%esp
80106623:	c9                   	leave  
80106624:	c3                   	ret    

80106625 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $0
80106627:	6a 00                	push   $0x0
  jmp alltraps
80106629:	e9 dc fa ff ff       	jmp    8010610a <alltraps>

8010662e <vector1>:
.globl vector1
vector1:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $1
80106630:	6a 01                	push   $0x1
  jmp alltraps
80106632:	e9 d3 fa ff ff       	jmp    8010610a <alltraps>

80106637 <vector2>:
.globl vector2
vector2:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $2
80106639:	6a 02                	push   $0x2
  jmp alltraps
8010663b:	e9 ca fa ff ff       	jmp    8010610a <alltraps>

80106640 <vector3>:
.globl vector3
vector3:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $3
80106642:	6a 03                	push   $0x3
  jmp alltraps
80106644:	e9 c1 fa ff ff       	jmp    8010610a <alltraps>

80106649 <vector4>:
.globl vector4
vector4:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $4
8010664b:	6a 04                	push   $0x4
  jmp alltraps
8010664d:	e9 b8 fa ff ff       	jmp    8010610a <alltraps>

80106652 <vector5>:
.globl vector5
vector5:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $5
80106654:	6a 05                	push   $0x5
  jmp alltraps
80106656:	e9 af fa ff ff       	jmp    8010610a <alltraps>

8010665b <vector6>:
.globl vector6
vector6:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $6
8010665d:	6a 06                	push   $0x6
  jmp alltraps
8010665f:	e9 a6 fa ff ff       	jmp    8010610a <alltraps>

80106664 <vector7>:
.globl vector7
vector7:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $7
80106666:	6a 07                	push   $0x7
  jmp alltraps
80106668:	e9 9d fa ff ff       	jmp    8010610a <alltraps>

8010666d <vector8>:
.globl vector8
vector8:
  pushl $8
8010666d:	6a 08                	push   $0x8
  jmp alltraps
8010666f:	e9 96 fa ff ff       	jmp    8010610a <alltraps>

80106674 <vector9>:
.globl vector9
vector9:
  pushl $0
80106674:	6a 00                	push   $0x0
  pushl $9
80106676:	6a 09                	push   $0x9
  jmp alltraps
80106678:	e9 8d fa ff ff       	jmp    8010610a <alltraps>

8010667d <vector10>:
.globl vector10
vector10:
  pushl $10
8010667d:	6a 0a                	push   $0xa
  jmp alltraps
8010667f:	e9 86 fa ff ff       	jmp    8010610a <alltraps>

80106684 <vector11>:
.globl vector11
vector11:
  pushl $11
80106684:	6a 0b                	push   $0xb
  jmp alltraps
80106686:	e9 7f fa ff ff       	jmp    8010610a <alltraps>

8010668b <vector12>:
.globl vector12
vector12:
  pushl $12
8010668b:	6a 0c                	push   $0xc
  jmp alltraps
8010668d:	e9 78 fa ff ff       	jmp    8010610a <alltraps>

80106692 <vector13>:
.globl vector13
vector13:
  pushl $13
80106692:	6a 0d                	push   $0xd
  jmp alltraps
80106694:	e9 71 fa ff ff       	jmp    8010610a <alltraps>

80106699 <vector14>:
.globl vector14
vector14:
  pushl $14
80106699:	6a 0e                	push   $0xe
  jmp alltraps
8010669b:	e9 6a fa ff ff       	jmp    8010610a <alltraps>

801066a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $15
801066a2:	6a 0f                	push   $0xf
  jmp alltraps
801066a4:	e9 61 fa ff ff       	jmp    8010610a <alltraps>

801066a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $16
801066ab:	6a 10                	push   $0x10
  jmp alltraps
801066ad:	e9 58 fa ff ff       	jmp    8010610a <alltraps>

801066b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801066b2:	6a 11                	push   $0x11
  jmp alltraps
801066b4:	e9 51 fa ff ff       	jmp    8010610a <alltraps>

801066b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $18
801066bb:	6a 12                	push   $0x12
  jmp alltraps
801066bd:	e9 48 fa ff ff       	jmp    8010610a <alltraps>

801066c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $19
801066c4:	6a 13                	push   $0x13
  jmp alltraps
801066c6:	e9 3f fa ff ff       	jmp    8010610a <alltraps>

801066cb <vector20>:
.globl vector20
vector20:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $20
801066cd:	6a 14                	push   $0x14
  jmp alltraps
801066cf:	e9 36 fa ff ff       	jmp    8010610a <alltraps>

801066d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $21
801066d6:	6a 15                	push   $0x15
  jmp alltraps
801066d8:	e9 2d fa ff ff       	jmp    8010610a <alltraps>

801066dd <vector22>:
.globl vector22
vector22:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $22
801066df:	6a 16                	push   $0x16
  jmp alltraps
801066e1:	e9 24 fa ff ff       	jmp    8010610a <alltraps>

801066e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $23
801066e8:	6a 17                	push   $0x17
  jmp alltraps
801066ea:	e9 1b fa ff ff       	jmp    8010610a <alltraps>

801066ef <vector24>:
.globl vector24
vector24:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $24
801066f1:	6a 18                	push   $0x18
  jmp alltraps
801066f3:	e9 12 fa ff ff       	jmp    8010610a <alltraps>

801066f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $25
801066fa:	6a 19                	push   $0x19
  jmp alltraps
801066fc:	e9 09 fa ff ff       	jmp    8010610a <alltraps>

80106701 <vector26>:
.globl vector26
vector26:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $26
80106703:	6a 1a                	push   $0x1a
  jmp alltraps
80106705:	e9 00 fa ff ff       	jmp    8010610a <alltraps>

8010670a <vector27>:
.globl vector27
vector27:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $27
8010670c:	6a 1b                	push   $0x1b
  jmp alltraps
8010670e:	e9 f7 f9 ff ff       	jmp    8010610a <alltraps>

80106713 <vector28>:
.globl vector28
vector28:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $28
80106715:	6a 1c                	push   $0x1c
  jmp alltraps
80106717:	e9 ee f9 ff ff       	jmp    8010610a <alltraps>

8010671c <vector29>:
.globl vector29
vector29:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $29
8010671e:	6a 1d                	push   $0x1d
  jmp alltraps
80106720:	e9 e5 f9 ff ff       	jmp    8010610a <alltraps>

80106725 <vector30>:
.globl vector30
vector30:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $30
80106727:	6a 1e                	push   $0x1e
  jmp alltraps
80106729:	e9 dc f9 ff ff       	jmp    8010610a <alltraps>

8010672e <vector31>:
.globl vector31
vector31:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $31
80106730:	6a 1f                	push   $0x1f
  jmp alltraps
80106732:	e9 d3 f9 ff ff       	jmp    8010610a <alltraps>

80106737 <vector32>:
.globl vector32
vector32:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $32
80106739:	6a 20                	push   $0x20
  jmp alltraps
8010673b:	e9 ca f9 ff ff       	jmp    8010610a <alltraps>

80106740 <vector33>:
.globl vector33
vector33:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $33
80106742:	6a 21                	push   $0x21
  jmp alltraps
80106744:	e9 c1 f9 ff ff       	jmp    8010610a <alltraps>

80106749 <vector34>:
.globl vector34
vector34:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $34
8010674b:	6a 22                	push   $0x22
  jmp alltraps
8010674d:	e9 b8 f9 ff ff       	jmp    8010610a <alltraps>

80106752 <vector35>:
.globl vector35
vector35:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $35
80106754:	6a 23                	push   $0x23
  jmp alltraps
80106756:	e9 af f9 ff ff       	jmp    8010610a <alltraps>

8010675b <vector36>:
.globl vector36
vector36:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $36
8010675d:	6a 24                	push   $0x24
  jmp alltraps
8010675f:	e9 a6 f9 ff ff       	jmp    8010610a <alltraps>

80106764 <vector37>:
.globl vector37
vector37:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $37
80106766:	6a 25                	push   $0x25
  jmp alltraps
80106768:	e9 9d f9 ff ff       	jmp    8010610a <alltraps>

8010676d <vector38>:
.globl vector38
vector38:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $38
8010676f:	6a 26                	push   $0x26
  jmp alltraps
80106771:	e9 94 f9 ff ff       	jmp    8010610a <alltraps>

80106776 <vector39>:
.globl vector39
vector39:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $39
80106778:	6a 27                	push   $0x27
  jmp alltraps
8010677a:	e9 8b f9 ff ff       	jmp    8010610a <alltraps>

8010677f <vector40>:
.globl vector40
vector40:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $40
80106781:	6a 28                	push   $0x28
  jmp alltraps
80106783:	e9 82 f9 ff ff       	jmp    8010610a <alltraps>

80106788 <vector41>:
.globl vector41
vector41:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $41
8010678a:	6a 29                	push   $0x29
  jmp alltraps
8010678c:	e9 79 f9 ff ff       	jmp    8010610a <alltraps>

80106791 <vector42>:
.globl vector42
vector42:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $42
80106793:	6a 2a                	push   $0x2a
  jmp alltraps
80106795:	e9 70 f9 ff ff       	jmp    8010610a <alltraps>

8010679a <vector43>:
.globl vector43
vector43:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $43
8010679c:	6a 2b                	push   $0x2b
  jmp alltraps
8010679e:	e9 67 f9 ff ff       	jmp    8010610a <alltraps>

801067a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $44
801067a5:	6a 2c                	push   $0x2c
  jmp alltraps
801067a7:	e9 5e f9 ff ff       	jmp    8010610a <alltraps>

801067ac <vector45>:
.globl vector45
vector45:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $45
801067ae:	6a 2d                	push   $0x2d
  jmp alltraps
801067b0:	e9 55 f9 ff ff       	jmp    8010610a <alltraps>

801067b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $46
801067b7:	6a 2e                	push   $0x2e
  jmp alltraps
801067b9:	e9 4c f9 ff ff       	jmp    8010610a <alltraps>

801067be <vector47>:
.globl vector47
vector47:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $47
801067c0:	6a 2f                	push   $0x2f
  jmp alltraps
801067c2:	e9 43 f9 ff ff       	jmp    8010610a <alltraps>

801067c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $48
801067c9:	6a 30                	push   $0x30
  jmp alltraps
801067cb:	e9 3a f9 ff ff       	jmp    8010610a <alltraps>

801067d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $49
801067d2:	6a 31                	push   $0x31
  jmp alltraps
801067d4:	e9 31 f9 ff ff       	jmp    8010610a <alltraps>

801067d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $50
801067db:	6a 32                	push   $0x32
  jmp alltraps
801067dd:	e9 28 f9 ff ff       	jmp    8010610a <alltraps>

801067e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $51
801067e4:	6a 33                	push   $0x33
  jmp alltraps
801067e6:	e9 1f f9 ff ff       	jmp    8010610a <alltraps>

801067eb <vector52>:
.globl vector52
vector52:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $52
801067ed:	6a 34                	push   $0x34
  jmp alltraps
801067ef:	e9 16 f9 ff ff       	jmp    8010610a <alltraps>

801067f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $53
801067f6:	6a 35                	push   $0x35
  jmp alltraps
801067f8:	e9 0d f9 ff ff       	jmp    8010610a <alltraps>

801067fd <vector54>:
.globl vector54
vector54:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $54
801067ff:	6a 36                	push   $0x36
  jmp alltraps
80106801:	e9 04 f9 ff ff       	jmp    8010610a <alltraps>

80106806 <vector55>:
.globl vector55
vector55:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $55
80106808:	6a 37                	push   $0x37
  jmp alltraps
8010680a:	e9 fb f8 ff ff       	jmp    8010610a <alltraps>

8010680f <vector56>:
.globl vector56
vector56:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $56
80106811:	6a 38                	push   $0x38
  jmp alltraps
80106813:	e9 f2 f8 ff ff       	jmp    8010610a <alltraps>

80106818 <vector57>:
.globl vector57
vector57:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $57
8010681a:	6a 39                	push   $0x39
  jmp alltraps
8010681c:	e9 e9 f8 ff ff       	jmp    8010610a <alltraps>

80106821 <vector58>:
.globl vector58
vector58:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $58
80106823:	6a 3a                	push   $0x3a
  jmp alltraps
80106825:	e9 e0 f8 ff ff       	jmp    8010610a <alltraps>

8010682a <vector59>:
.globl vector59
vector59:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $59
8010682c:	6a 3b                	push   $0x3b
  jmp alltraps
8010682e:	e9 d7 f8 ff ff       	jmp    8010610a <alltraps>

80106833 <vector60>:
.globl vector60
vector60:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $60
80106835:	6a 3c                	push   $0x3c
  jmp alltraps
80106837:	e9 ce f8 ff ff       	jmp    8010610a <alltraps>

8010683c <vector61>:
.globl vector61
vector61:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $61
8010683e:	6a 3d                	push   $0x3d
  jmp alltraps
80106840:	e9 c5 f8 ff ff       	jmp    8010610a <alltraps>

80106845 <vector62>:
.globl vector62
vector62:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $62
80106847:	6a 3e                	push   $0x3e
  jmp alltraps
80106849:	e9 bc f8 ff ff       	jmp    8010610a <alltraps>

8010684e <vector63>:
.globl vector63
vector63:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $63
80106850:	6a 3f                	push   $0x3f
  jmp alltraps
80106852:	e9 b3 f8 ff ff       	jmp    8010610a <alltraps>

80106857 <vector64>:
.globl vector64
vector64:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $64
80106859:	6a 40                	push   $0x40
  jmp alltraps
8010685b:	e9 aa f8 ff ff       	jmp    8010610a <alltraps>

80106860 <vector65>:
.globl vector65
vector65:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $65
80106862:	6a 41                	push   $0x41
  jmp alltraps
80106864:	e9 a1 f8 ff ff       	jmp    8010610a <alltraps>

80106869 <vector66>:
.globl vector66
vector66:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $66
8010686b:	6a 42                	push   $0x42
  jmp alltraps
8010686d:	e9 98 f8 ff ff       	jmp    8010610a <alltraps>

80106872 <vector67>:
.globl vector67
vector67:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $67
80106874:	6a 43                	push   $0x43
  jmp alltraps
80106876:	e9 8f f8 ff ff       	jmp    8010610a <alltraps>

8010687b <vector68>:
.globl vector68
vector68:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $68
8010687d:	6a 44                	push   $0x44
  jmp alltraps
8010687f:	e9 86 f8 ff ff       	jmp    8010610a <alltraps>

80106884 <vector69>:
.globl vector69
vector69:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $69
80106886:	6a 45                	push   $0x45
  jmp alltraps
80106888:	e9 7d f8 ff ff       	jmp    8010610a <alltraps>

8010688d <vector70>:
.globl vector70
vector70:
  pushl $0
8010688d:	6a 00                	push   $0x0
  pushl $70
8010688f:	6a 46                	push   $0x46
  jmp alltraps
80106891:	e9 74 f8 ff ff       	jmp    8010610a <alltraps>

80106896 <vector71>:
.globl vector71
vector71:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $71
80106898:	6a 47                	push   $0x47
  jmp alltraps
8010689a:	e9 6b f8 ff ff       	jmp    8010610a <alltraps>

8010689f <vector72>:
.globl vector72
vector72:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $72
801068a1:	6a 48                	push   $0x48
  jmp alltraps
801068a3:	e9 62 f8 ff ff       	jmp    8010610a <alltraps>

801068a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801068a8:	6a 00                	push   $0x0
  pushl $73
801068aa:	6a 49                	push   $0x49
  jmp alltraps
801068ac:	e9 59 f8 ff ff       	jmp    8010610a <alltraps>

801068b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801068b1:	6a 00                	push   $0x0
  pushl $74
801068b3:	6a 4a                	push   $0x4a
  jmp alltraps
801068b5:	e9 50 f8 ff ff       	jmp    8010610a <alltraps>

801068ba <vector75>:
.globl vector75
vector75:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $75
801068bc:	6a 4b                	push   $0x4b
  jmp alltraps
801068be:	e9 47 f8 ff ff       	jmp    8010610a <alltraps>

801068c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $76
801068c5:	6a 4c                	push   $0x4c
  jmp alltraps
801068c7:	e9 3e f8 ff ff       	jmp    8010610a <alltraps>

801068cc <vector77>:
.globl vector77
vector77:
  pushl $0
801068cc:	6a 00                	push   $0x0
  pushl $77
801068ce:	6a 4d                	push   $0x4d
  jmp alltraps
801068d0:	e9 35 f8 ff ff       	jmp    8010610a <alltraps>

801068d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801068d5:	6a 00                	push   $0x0
  pushl $78
801068d7:	6a 4e                	push   $0x4e
  jmp alltraps
801068d9:	e9 2c f8 ff ff       	jmp    8010610a <alltraps>

801068de <vector79>:
.globl vector79
vector79:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $79
801068e0:	6a 4f                	push   $0x4f
  jmp alltraps
801068e2:	e9 23 f8 ff ff       	jmp    8010610a <alltraps>

801068e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $80
801068e9:	6a 50                	push   $0x50
  jmp alltraps
801068eb:	e9 1a f8 ff ff       	jmp    8010610a <alltraps>

801068f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $81
801068f2:	6a 51                	push   $0x51
  jmp alltraps
801068f4:	e9 11 f8 ff ff       	jmp    8010610a <alltraps>

801068f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $82
801068fb:	6a 52                	push   $0x52
  jmp alltraps
801068fd:	e9 08 f8 ff ff       	jmp    8010610a <alltraps>

80106902 <vector83>:
.globl vector83
vector83:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $83
80106904:	6a 53                	push   $0x53
  jmp alltraps
80106906:	e9 ff f7 ff ff       	jmp    8010610a <alltraps>

8010690b <vector84>:
.globl vector84
vector84:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $84
8010690d:	6a 54                	push   $0x54
  jmp alltraps
8010690f:	e9 f6 f7 ff ff       	jmp    8010610a <alltraps>

80106914 <vector85>:
.globl vector85
vector85:
  pushl $0
80106914:	6a 00                	push   $0x0
  pushl $85
80106916:	6a 55                	push   $0x55
  jmp alltraps
80106918:	e9 ed f7 ff ff       	jmp    8010610a <alltraps>

8010691d <vector86>:
.globl vector86
vector86:
  pushl $0
8010691d:	6a 00                	push   $0x0
  pushl $86
8010691f:	6a 56                	push   $0x56
  jmp alltraps
80106921:	e9 e4 f7 ff ff       	jmp    8010610a <alltraps>

80106926 <vector87>:
.globl vector87
vector87:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $87
80106928:	6a 57                	push   $0x57
  jmp alltraps
8010692a:	e9 db f7 ff ff       	jmp    8010610a <alltraps>

8010692f <vector88>:
.globl vector88
vector88:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $88
80106931:	6a 58                	push   $0x58
  jmp alltraps
80106933:	e9 d2 f7 ff ff       	jmp    8010610a <alltraps>

80106938 <vector89>:
.globl vector89
vector89:
  pushl $0
80106938:	6a 00                	push   $0x0
  pushl $89
8010693a:	6a 59                	push   $0x59
  jmp alltraps
8010693c:	e9 c9 f7 ff ff       	jmp    8010610a <alltraps>

80106941 <vector90>:
.globl vector90
vector90:
  pushl $0
80106941:	6a 00                	push   $0x0
  pushl $90
80106943:	6a 5a                	push   $0x5a
  jmp alltraps
80106945:	e9 c0 f7 ff ff       	jmp    8010610a <alltraps>

8010694a <vector91>:
.globl vector91
vector91:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $91
8010694c:	6a 5b                	push   $0x5b
  jmp alltraps
8010694e:	e9 b7 f7 ff ff       	jmp    8010610a <alltraps>

80106953 <vector92>:
.globl vector92
vector92:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $92
80106955:	6a 5c                	push   $0x5c
  jmp alltraps
80106957:	e9 ae f7 ff ff       	jmp    8010610a <alltraps>

8010695c <vector93>:
.globl vector93
vector93:
  pushl $0
8010695c:	6a 00                	push   $0x0
  pushl $93
8010695e:	6a 5d                	push   $0x5d
  jmp alltraps
80106960:	e9 a5 f7 ff ff       	jmp    8010610a <alltraps>

80106965 <vector94>:
.globl vector94
vector94:
  pushl $0
80106965:	6a 00                	push   $0x0
  pushl $94
80106967:	6a 5e                	push   $0x5e
  jmp alltraps
80106969:	e9 9c f7 ff ff       	jmp    8010610a <alltraps>

8010696e <vector95>:
.globl vector95
vector95:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $95
80106970:	6a 5f                	push   $0x5f
  jmp alltraps
80106972:	e9 93 f7 ff ff       	jmp    8010610a <alltraps>

80106977 <vector96>:
.globl vector96
vector96:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $96
80106979:	6a 60                	push   $0x60
  jmp alltraps
8010697b:	e9 8a f7 ff ff       	jmp    8010610a <alltraps>

80106980 <vector97>:
.globl vector97
vector97:
  pushl $0
80106980:	6a 00                	push   $0x0
  pushl $97
80106982:	6a 61                	push   $0x61
  jmp alltraps
80106984:	e9 81 f7 ff ff       	jmp    8010610a <alltraps>

80106989 <vector98>:
.globl vector98
vector98:
  pushl $0
80106989:	6a 00                	push   $0x0
  pushl $98
8010698b:	6a 62                	push   $0x62
  jmp alltraps
8010698d:	e9 78 f7 ff ff       	jmp    8010610a <alltraps>

80106992 <vector99>:
.globl vector99
vector99:
  pushl $0
80106992:	6a 00                	push   $0x0
  pushl $99
80106994:	6a 63                	push   $0x63
  jmp alltraps
80106996:	e9 6f f7 ff ff       	jmp    8010610a <alltraps>

8010699b <vector100>:
.globl vector100
vector100:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $100
8010699d:	6a 64                	push   $0x64
  jmp alltraps
8010699f:	e9 66 f7 ff ff       	jmp    8010610a <alltraps>

801069a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801069a4:	6a 00                	push   $0x0
  pushl $101
801069a6:	6a 65                	push   $0x65
  jmp alltraps
801069a8:	e9 5d f7 ff ff       	jmp    8010610a <alltraps>

801069ad <vector102>:
.globl vector102
vector102:
  pushl $0
801069ad:	6a 00                	push   $0x0
  pushl $102
801069af:	6a 66                	push   $0x66
  jmp alltraps
801069b1:	e9 54 f7 ff ff       	jmp    8010610a <alltraps>

801069b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801069b6:	6a 00                	push   $0x0
  pushl $103
801069b8:	6a 67                	push   $0x67
  jmp alltraps
801069ba:	e9 4b f7 ff ff       	jmp    8010610a <alltraps>

801069bf <vector104>:
.globl vector104
vector104:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $104
801069c1:	6a 68                	push   $0x68
  jmp alltraps
801069c3:	e9 42 f7 ff ff       	jmp    8010610a <alltraps>

801069c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801069c8:	6a 00                	push   $0x0
  pushl $105
801069ca:	6a 69                	push   $0x69
  jmp alltraps
801069cc:	e9 39 f7 ff ff       	jmp    8010610a <alltraps>

801069d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801069d1:	6a 00                	push   $0x0
  pushl $106
801069d3:	6a 6a                	push   $0x6a
  jmp alltraps
801069d5:	e9 30 f7 ff ff       	jmp    8010610a <alltraps>

801069da <vector107>:
.globl vector107
vector107:
  pushl $0
801069da:	6a 00                	push   $0x0
  pushl $107
801069dc:	6a 6b                	push   $0x6b
  jmp alltraps
801069de:	e9 27 f7 ff ff       	jmp    8010610a <alltraps>

801069e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $108
801069e5:	6a 6c                	push   $0x6c
  jmp alltraps
801069e7:	e9 1e f7 ff ff       	jmp    8010610a <alltraps>

801069ec <vector109>:
.globl vector109
vector109:
  pushl $0
801069ec:	6a 00                	push   $0x0
  pushl $109
801069ee:	6a 6d                	push   $0x6d
  jmp alltraps
801069f0:	e9 15 f7 ff ff       	jmp    8010610a <alltraps>

801069f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801069f5:	6a 00                	push   $0x0
  pushl $110
801069f7:	6a 6e                	push   $0x6e
  jmp alltraps
801069f9:	e9 0c f7 ff ff       	jmp    8010610a <alltraps>

801069fe <vector111>:
.globl vector111
vector111:
  pushl $0
801069fe:	6a 00                	push   $0x0
  pushl $111
80106a00:	6a 6f                	push   $0x6f
  jmp alltraps
80106a02:	e9 03 f7 ff ff       	jmp    8010610a <alltraps>

80106a07 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $112
80106a09:	6a 70                	push   $0x70
  jmp alltraps
80106a0b:	e9 fa f6 ff ff       	jmp    8010610a <alltraps>

80106a10 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a10:	6a 00                	push   $0x0
  pushl $113
80106a12:	6a 71                	push   $0x71
  jmp alltraps
80106a14:	e9 f1 f6 ff ff       	jmp    8010610a <alltraps>

80106a19 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a19:	6a 00                	push   $0x0
  pushl $114
80106a1b:	6a 72                	push   $0x72
  jmp alltraps
80106a1d:	e9 e8 f6 ff ff       	jmp    8010610a <alltraps>

80106a22 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a22:	6a 00                	push   $0x0
  pushl $115
80106a24:	6a 73                	push   $0x73
  jmp alltraps
80106a26:	e9 df f6 ff ff       	jmp    8010610a <alltraps>

80106a2b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $116
80106a2d:	6a 74                	push   $0x74
  jmp alltraps
80106a2f:	e9 d6 f6 ff ff       	jmp    8010610a <alltraps>

80106a34 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a34:	6a 00                	push   $0x0
  pushl $117
80106a36:	6a 75                	push   $0x75
  jmp alltraps
80106a38:	e9 cd f6 ff ff       	jmp    8010610a <alltraps>

80106a3d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a3d:	6a 00                	push   $0x0
  pushl $118
80106a3f:	6a 76                	push   $0x76
  jmp alltraps
80106a41:	e9 c4 f6 ff ff       	jmp    8010610a <alltraps>

80106a46 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a46:	6a 00                	push   $0x0
  pushl $119
80106a48:	6a 77                	push   $0x77
  jmp alltraps
80106a4a:	e9 bb f6 ff ff       	jmp    8010610a <alltraps>

80106a4f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $120
80106a51:	6a 78                	push   $0x78
  jmp alltraps
80106a53:	e9 b2 f6 ff ff       	jmp    8010610a <alltraps>

80106a58 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a58:	6a 00                	push   $0x0
  pushl $121
80106a5a:	6a 79                	push   $0x79
  jmp alltraps
80106a5c:	e9 a9 f6 ff ff       	jmp    8010610a <alltraps>

80106a61 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a61:	6a 00                	push   $0x0
  pushl $122
80106a63:	6a 7a                	push   $0x7a
  jmp alltraps
80106a65:	e9 a0 f6 ff ff       	jmp    8010610a <alltraps>

80106a6a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a6a:	6a 00                	push   $0x0
  pushl $123
80106a6c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a6e:	e9 97 f6 ff ff       	jmp    8010610a <alltraps>

80106a73 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $124
80106a75:	6a 7c                	push   $0x7c
  jmp alltraps
80106a77:	e9 8e f6 ff ff       	jmp    8010610a <alltraps>

80106a7c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a7c:	6a 00                	push   $0x0
  pushl $125
80106a7e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a80:	e9 85 f6 ff ff       	jmp    8010610a <alltraps>

80106a85 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a85:	6a 00                	push   $0x0
  pushl $126
80106a87:	6a 7e                	push   $0x7e
  jmp alltraps
80106a89:	e9 7c f6 ff ff       	jmp    8010610a <alltraps>

80106a8e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a8e:	6a 00                	push   $0x0
  pushl $127
80106a90:	6a 7f                	push   $0x7f
  jmp alltraps
80106a92:	e9 73 f6 ff ff       	jmp    8010610a <alltraps>

80106a97 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $128
80106a99:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a9e:	e9 67 f6 ff ff       	jmp    8010610a <alltraps>

80106aa3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $129
80106aa5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106aaa:	e9 5b f6 ff ff       	jmp    8010610a <alltraps>

80106aaf <vector130>:
.globl vector130
vector130:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $130
80106ab1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ab6:	e9 4f f6 ff ff       	jmp    8010610a <alltraps>

80106abb <vector131>:
.globl vector131
vector131:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $131
80106abd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ac2:	e9 43 f6 ff ff       	jmp    8010610a <alltraps>

80106ac7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $132
80106ac9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ace:	e9 37 f6 ff ff       	jmp    8010610a <alltraps>

80106ad3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $133
80106ad5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106ada:	e9 2b f6 ff ff       	jmp    8010610a <alltraps>

80106adf <vector134>:
.globl vector134
vector134:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $134
80106ae1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ae6:	e9 1f f6 ff ff       	jmp    8010610a <alltraps>

80106aeb <vector135>:
.globl vector135
vector135:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $135
80106aed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106af2:	e9 13 f6 ff ff       	jmp    8010610a <alltraps>

80106af7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $136
80106af9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106afe:	e9 07 f6 ff ff       	jmp    8010610a <alltraps>

80106b03 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $137
80106b05:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b0a:	e9 fb f5 ff ff       	jmp    8010610a <alltraps>

80106b0f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $138
80106b11:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b16:	e9 ef f5 ff ff       	jmp    8010610a <alltraps>

80106b1b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $139
80106b1d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b22:	e9 e3 f5 ff ff       	jmp    8010610a <alltraps>

80106b27 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $140
80106b29:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b2e:	e9 d7 f5 ff ff       	jmp    8010610a <alltraps>

80106b33 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $141
80106b35:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b3a:	e9 cb f5 ff ff       	jmp    8010610a <alltraps>

80106b3f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $142
80106b41:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b46:	e9 bf f5 ff ff       	jmp    8010610a <alltraps>

80106b4b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $143
80106b4d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b52:	e9 b3 f5 ff ff       	jmp    8010610a <alltraps>

80106b57 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $144
80106b59:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b5e:	e9 a7 f5 ff ff       	jmp    8010610a <alltraps>

80106b63 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $145
80106b65:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b6a:	e9 9b f5 ff ff       	jmp    8010610a <alltraps>

80106b6f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $146
80106b71:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b76:	e9 8f f5 ff ff       	jmp    8010610a <alltraps>

80106b7b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $147
80106b7d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b82:	e9 83 f5 ff ff       	jmp    8010610a <alltraps>

80106b87 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $148
80106b89:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b8e:	e9 77 f5 ff ff       	jmp    8010610a <alltraps>

80106b93 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $149
80106b95:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b9a:	e9 6b f5 ff ff       	jmp    8010610a <alltraps>

80106b9f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $150
80106ba1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ba6:	e9 5f f5 ff ff       	jmp    8010610a <alltraps>

80106bab <vector151>:
.globl vector151
vector151:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $151
80106bad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106bb2:	e9 53 f5 ff ff       	jmp    8010610a <alltraps>

80106bb7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $152
80106bb9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106bbe:	e9 47 f5 ff ff       	jmp    8010610a <alltraps>

80106bc3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $153
80106bc5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106bca:	e9 3b f5 ff ff       	jmp    8010610a <alltraps>

80106bcf <vector154>:
.globl vector154
vector154:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $154
80106bd1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106bd6:	e9 2f f5 ff ff       	jmp    8010610a <alltraps>

80106bdb <vector155>:
.globl vector155
vector155:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $155
80106bdd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106be2:	e9 23 f5 ff ff       	jmp    8010610a <alltraps>

80106be7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $156
80106be9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bee:	e9 17 f5 ff ff       	jmp    8010610a <alltraps>

80106bf3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $157
80106bf5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bfa:	e9 0b f5 ff ff       	jmp    8010610a <alltraps>

80106bff <vector158>:
.globl vector158
vector158:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $158
80106c01:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c06:	e9 ff f4 ff ff       	jmp    8010610a <alltraps>

80106c0b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $159
80106c0d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c12:	e9 f3 f4 ff ff       	jmp    8010610a <alltraps>

80106c17 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $160
80106c19:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c1e:	e9 e7 f4 ff ff       	jmp    8010610a <alltraps>

80106c23 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $161
80106c25:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c2a:	e9 db f4 ff ff       	jmp    8010610a <alltraps>

80106c2f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $162
80106c31:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c36:	e9 cf f4 ff ff       	jmp    8010610a <alltraps>

80106c3b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $163
80106c3d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c42:	e9 c3 f4 ff ff       	jmp    8010610a <alltraps>

80106c47 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $164
80106c49:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c4e:	e9 b7 f4 ff ff       	jmp    8010610a <alltraps>

80106c53 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $165
80106c55:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c5a:	e9 ab f4 ff ff       	jmp    8010610a <alltraps>

80106c5f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $166
80106c61:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c66:	e9 9f f4 ff ff       	jmp    8010610a <alltraps>

80106c6b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $167
80106c6d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c72:	e9 93 f4 ff ff       	jmp    8010610a <alltraps>

80106c77 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $168
80106c79:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c7e:	e9 87 f4 ff ff       	jmp    8010610a <alltraps>

80106c83 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $169
80106c85:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c8a:	e9 7b f4 ff ff       	jmp    8010610a <alltraps>

80106c8f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $170
80106c91:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c96:	e9 6f f4 ff ff       	jmp    8010610a <alltraps>

80106c9b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $171
80106c9d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ca2:	e9 63 f4 ff ff       	jmp    8010610a <alltraps>

80106ca7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $172
80106ca9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106cae:	e9 57 f4 ff ff       	jmp    8010610a <alltraps>

80106cb3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $173
80106cb5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106cba:	e9 4b f4 ff ff       	jmp    8010610a <alltraps>

80106cbf <vector174>:
.globl vector174
vector174:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $174
80106cc1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106cc6:	e9 3f f4 ff ff       	jmp    8010610a <alltraps>

80106ccb <vector175>:
.globl vector175
vector175:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $175
80106ccd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106cd2:	e9 33 f4 ff ff       	jmp    8010610a <alltraps>

80106cd7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $176
80106cd9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cde:	e9 27 f4 ff ff       	jmp    8010610a <alltraps>

80106ce3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $177
80106ce5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cea:	e9 1b f4 ff ff       	jmp    8010610a <alltraps>

80106cef <vector178>:
.globl vector178
vector178:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $178
80106cf1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cf6:	e9 0f f4 ff ff       	jmp    8010610a <alltraps>

80106cfb <vector179>:
.globl vector179
vector179:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $179
80106cfd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d02:	e9 03 f4 ff ff       	jmp    8010610a <alltraps>

80106d07 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $180
80106d09:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d0e:	e9 f7 f3 ff ff       	jmp    8010610a <alltraps>

80106d13 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $181
80106d15:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d1a:	e9 eb f3 ff ff       	jmp    8010610a <alltraps>

80106d1f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $182
80106d21:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d26:	e9 df f3 ff ff       	jmp    8010610a <alltraps>

80106d2b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $183
80106d2d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d32:	e9 d3 f3 ff ff       	jmp    8010610a <alltraps>

80106d37 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $184
80106d39:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d3e:	e9 c7 f3 ff ff       	jmp    8010610a <alltraps>

80106d43 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $185
80106d45:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d4a:	e9 bb f3 ff ff       	jmp    8010610a <alltraps>

80106d4f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $186
80106d51:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d56:	e9 af f3 ff ff       	jmp    8010610a <alltraps>

80106d5b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $187
80106d5d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d62:	e9 a3 f3 ff ff       	jmp    8010610a <alltraps>

80106d67 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $188
80106d69:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d6e:	e9 97 f3 ff ff       	jmp    8010610a <alltraps>

80106d73 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $189
80106d75:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d7a:	e9 8b f3 ff ff       	jmp    8010610a <alltraps>

80106d7f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $190
80106d81:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d86:	e9 7f f3 ff ff       	jmp    8010610a <alltraps>

80106d8b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $191
80106d8d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d92:	e9 73 f3 ff ff       	jmp    8010610a <alltraps>

80106d97 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $192
80106d99:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d9e:	e9 67 f3 ff ff       	jmp    8010610a <alltraps>

80106da3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $193
80106da5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106daa:	e9 5b f3 ff ff       	jmp    8010610a <alltraps>

80106daf <vector194>:
.globl vector194
vector194:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $194
80106db1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106db6:	e9 4f f3 ff ff       	jmp    8010610a <alltraps>

80106dbb <vector195>:
.globl vector195
vector195:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $195
80106dbd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106dc2:	e9 43 f3 ff ff       	jmp    8010610a <alltraps>

80106dc7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $196
80106dc9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106dce:	e9 37 f3 ff ff       	jmp    8010610a <alltraps>

80106dd3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $197
80106dd5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dda:	e9 2b f3 ff ff       	jmp    8010610a <alltraps>

80106ddf <vector198>:
.globl vector198
vector198:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $198
80106de1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106de6:	e9 1f f3 ff ff       	jmp    8010610a <alltraps>

80106deb <vector199>:
.globl vector199
vector199:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $199
80106ded:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106df2:	e9 13 f3 ff ff       	jmp    8010610a <alltraps>

80106df7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $200
80106df9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dfe:	e9 07 f3 ff ff       	jmp    8010610a <alltraps>

80106e03 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $201
80106e05:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e0a:	e9 fb f2 ff ff       	jmp    8010610a <alltraps>

80106e0f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $202
80106e11:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e16:	e9 ef f2 ff ff       	jmp    8010610a <alltraps>

80106e1b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $203
80106e1d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e22:	e9 e3 f2 ff ff       	jmp    8010610a <alltraps>

80106e27 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $204
80106e29:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e2e:	e9 d7 f2 ff ff       	jmp    8010610a <alltraps>

80106e33 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $205
80106e35:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e3a:	e9 cb f2 ff ff       	jmp    8010610a <alltraps>

80106e3f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $206
80106e41:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e46:	e9 bf f2 ff ff       	jmp    8010610a <alltraps>

80106e4b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $207
80106e4d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e52:	e9 b3 f2 ff ff       	jmp    8010610a <alltraps>

80106e57 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $208
80106e59:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e5e:	e9 a7 f2 ff ff       	jmp    8010610a <alltraps>

80106e63 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $209
80106e65:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e6a:	e9 9b f2 ff ff       	jmp    8010610a <alltraps>

80106e6f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $210
80106e71:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e76:	e9 8f f2 ff ff       	jmp    8010610a <alltraps>

80106e7b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $211
80106e7d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e82:	e9 83 f2 ff ff       	jmp    8010610a <alltraps>

80106e87 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $212
80106e89:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e8e:	e9 77 f2 ff ff       	jmp    8010610a <alltraps>

80106e93 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $213
80106e95:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e9a:	e9 6b f2 ff ff       	jmp    8010610a <alltraps>

80106e9f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $214
80106ea1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ea6:	e9 5f f2 ff ff       	jmp    8010610a <alltraps>

80106eab <vector215>:
.globl vector215
vector215:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $215
80106ead:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106eb2:	e9 53 f2 ff ff       	jmp    8010610a <alltraps>

80106eb7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $216
80106eb9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ebe:	e9 47 f2 ff ff       	jmp    8010610a <alltraps>

80106ec3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $217
80106ec5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106eca:	e9 3b f2 ff ff       	jmp    8010610a <alltraps>

80106ecf <vector218>:
.globl vector218
vector218:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $218
80106ed1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ed6:	e9 2f f2 ff ff       	jmp    8010610a <alltraps>

80106edb <vector219>:
.globl vector219
vector219:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $219
80106edd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ee2:	e9 23 f2 ff ff       	jmp    8010610a <alltraps>

80106ee7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $220
80106ee9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106eee:	e9 17 f2 ff ff       	jmp    8010610a <alltraps>

80106ef3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $221
80106ef5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106efa:	e9 0b f2 ff ff       	jmp    8010610a <alltraps>

80106eff <vector222>:
.globl vector222
vector222:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $222
80106f01:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f06:	e9 ff f1 ff ff       	jmp    8010610a <alltraps>

80106f0b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $223
80106f0d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f12:	e9 f3 f1 ff ff       	jmp    8010610a <alltraps>

80106f17 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $224
80106f19:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f1e:	e9 e7 f1 ff ff       	jmp    8010610a <alltraps>

80106f23 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $225
80106f25:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f2a:	e9 db f1 ff ff       	jmp    8010610a <alltraps>

80106f2f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $226
80106f31:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f36:	e9 cf f1 ff ff       	jmp    8010610a <alltraps>

80106f3b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $227
80106f3d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f42:	e9 c3 f1 ff ff       	jmp    8010610a <alltraps>

80106f47 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $228
80106f49:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f4e:	e9 b7 f1 ff ff       	jmp    8010610a <alltraps>

80106f53 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $229
80106f55:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f5a:	e9 ab f1 ff ff       	jmp    8010610a <alltraps>

80106f5f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $230
80106f61:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f66:	e9 9f f1 ff ff       	jmp    8010610a <alltraps>

80106f6b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $231
80106f6d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f72:	e9 93 f1 ff ff       	jmp    8010610a <alltraps>

80106f77 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $232
80106f79:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f7e:	e9 87 f1 ff ff       	jmp    8010610a <alltraps>

80106f83 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $233
80106f85:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f8a:	e9 7b f1 ff ff       	jmp    8010610a <alltraps>

80106f8f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $234
80106f91:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f96:	e9 6f f1 ff ff       	jmp    8010610a <alltraps>

80106f9b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $235
80106f9d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106fa2:	e9 63 f1 ff ff       	jmp    8010610a <alltraps>

80106fa7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $236
80106fa9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106fae:	e9 57 f1 ff ff       	jmp    8010610a <alltraps>

80106fb3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $237
80106fb5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106fba:	e9 4b f1 ff ff       	jmp    8010610a <alltraps>

80106fbf <vector238>:
.globl vector238
vector238:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $238
80106fc1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106fc6:	e9 3f f1 ff ff       	jmp    8010610a <alltraps>

80106fcb <vector239>:
.globl vector239
vector239:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $239
80106fcd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fd2:	e9 33 f1 ff ff       	jmp    8010610a <alltraps>

80106fd7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $240
80106fd9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fde:	e9 27 f1 ff ff       	jmp    8010610a <alltraps>

80106fe3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $241
80106fe5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fea:	e9 1b f1 ff ff       	jmp    8010610a <alltraps>

80106fef <vector242>:
.globl vector242
vector242:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $242
80106ff1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ff6:	e9 0f f1 ff ff       	jmp    8010610a <alltraps>

80106ffb <vector243>:
.globl vector243
vector243:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $243
80106ffd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107002:	e9 03 f1 ff ff       	jmp    8010610a <alltraps>

80107007 <vector244>:
.globl vector244
vector244:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $244
80107009:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010700e:	e9 f7 f0 ff ff       	jmp    8010610a <alltraps>

80107013 <vector245>:
.globl vector245
vector245:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $245
80107015:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010701a:	e9 eb f0 ff ff       	jmp    8010610a <alltraps>

8010701f <vector246>:
.globl vector246
vector246:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $246
80107021:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107026:	e9 df f0 ff ff       	jmp    8010610a <alltraps>

8010702b <vector247>:
.globl vector247
vector247:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $247
8010702d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107032:	e9 d3 f0 ff ff       	jmp    8010610a <alltraps>

80107037 <vector248>:
.globl vector248
vector248:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $248
80107039:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010703e:	e9 c7 f0 ff ff       	jmp    8010610a <alltraps>

80107043 <vector249>:
.globl vector249
vector249:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $249
80107045:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010704a:	e9 bb f0 ff ff       	jmp    8010610a <alltraps>

8010704f <vector250>:
.globl vector250
vector250:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $250
80107051:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107056:	e9 af f0 ff ff       	jmp    8010610a <alltraps>

8010705b <vector251>:
.globl vector251
vector251:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $251
8010705d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107062:	e9 a3 f0 ff ff       	jmp    8010610a <alltraps>

80107067 <vector252>:
.globl vector252
vector252:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $252
80107069:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010706e:	e9 97 f0 ff ff       	jmp    8010610a <alltraps>

80107073 <vector253>:
.globl vector253
vector253:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $253
80107075:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010707a:	e9 8b f0 ff ff       	jmp    8010610a <alltraps>

8010707f <vector254>:
.globl vector254
vector254:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $254
80107081:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107086:	e9 7f f0 ff ff       	jmp    8010610a <alltraps>

8010708b <vector255>:
.globl vector255
vector255:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $255
8010708d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107092:	e9 73 f0 ff ff       	jmp    8010610a <alltraps>
80107097:	66 90                	xchg   %ax,%ax
80107099:	66 90                	xchg   %ax,%ax
8010709b:	66 90                	xchg   %ax,%ax
8010709d:	66 90                	xchg   %ax,%ax
8010709f:	90                   	nop

801070a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801070a7:	c1 ea 16             	shr    $0x16,%edx
{
801070aa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801070ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801070ae:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801070b1:	8b 07                	mov    (%edi),%eax
801070b3:	a8 01                	test   $0x1,%al
801070b5:	74 29                	je     801070e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070bc:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801070c2:	c1 ee 0a             	shr    $0xa,%esi
}
801070c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801070c8:	89 f2                	mov    %esi,%edx
801070ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801070d0:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801070d3:	5b                   	pop    %ebx
801070d4:	5e                   	pop    %esi
801070d5:	5f                   	pop    %edi
801070d6:	5d                   	pop    %ebp
801070d7:	c3                   	ret    
801070d8:	90                   	nop
801070d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070e0:	85 c9                	test   %ecx,%ecx
801070e2:	74 2c                	je     80107110 <walkpgdir+0x70>
801070e4:	e8 37 b9 ff ff       	call   80102a20 <kalloc>
801070e9:	89 c3                	mov    %eax,%ebx
801070eb:	85 c0                	test   %eax,%eax
801070ed:	74 21                	je     80107110 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801070ef:	83 ec 04             	sub    $0x4,%esp
801070f2:	68 00 10 00 00       	push   $0x1000
801070f7:	6a 00                	push   $0x0
801070f9:	50                   	push   %eax
801070fa:	e8 f1 db ff ff       	call   80104cf0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107105:	83 c4 10             	add    $0x10,%esp
80107108:	83 c8 07             	or     $0x7,%eax
8010710b:	89 07                	mov    %eax,(%edi)
8010710d:	eb b3                	jmp    801070c2 <walkpgdir+0x22>
8010710f:	90                   	nop
}
80107110:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107113:	31 c0                	xor    %eax,%eax
}
80107115:	5b                   	pop    %ebx
80107116:	5e                   	pop    %esi
80107117:	5f                   	pop    %edi
80107118:	5d                   	pop    %ebp
80107119:	c3                   	ret    
8010711a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107120 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107125:	89 d6                	mov    %edx,%esi
{
80107127:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107128:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
8010712e:	83 ec 1c             	sub    $0x1c,%esp
80107131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107134:	8b 7d 08             	mov    0x8(%ebp),%edi
80107137:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010713b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107140:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107143:	29 f7                	sub    %esi,%edi
80107145:	eb 21                	jmp    80107168 <mappages+0x48>
80107147:	89 f6                	mov    %esi,%esi
80107149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107150:	f6 00 01             	testb  $0x1,(%eax)
80107153:	75 45                	jne    8010719a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107155:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107158:	83 cb 01             	or     $0x1,%ebx
8010715b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010715d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107160:	74 2e                	je     80107190 <mappages+0x70>
      break;
    a += PGSIZE;
80107162:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010716b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107170:	89 f2                	mov    %esi,%edx
80107172:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80107175:	e8 26 ff ff ff       	call   801070a0 <walkpgdir>
8010717a:	85 c0                	test   %eax,%eax
8010717c:	75 d2                	jne    80107150 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010717e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107186:	5b                   	pop    %ebx
80107187:	5e                   	pop    %esi
80107188:	5f                   	pop    %edi
80107189:	5d                   	pop    %ebp
8010718a:	c3                   	ret    
8010718b:	90                   	nop
8010718c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107193:	31 c0                	xor    %eax,%eax
}
80107195:	5b                   	pop    %ebx
80107196:	5e                   	pop    %esi
80107197:	5f                   	pop    %edi
80107198:	5d                   	pop    %ebp
80107199:	c3                   	ret    
      panic("remap");
8010719a:	83 ec 0c             	sub    $0xc,%esp
8010719d:	68 cc 83 10 80       	push   $0x801083cc
801071a2:	e8 39 92 ff ff       	call   801003e0 <panic>
801071a7:	89 f6                	mov    %esi,%esi
801071a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	89 c7                	mov    %eax,%edi
801071b6:	56                   	push   %esi
801071b7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801071b8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801071be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071c4:	83 ec 1c             	sub    $0x1c,%esp
801071c7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801071ca:	39 d3                	cmp    %edx,%ebx
801071cc:	73 5a                	jae    80107228 <deallocuvm.part.0+0x78>
801071ce:	89 d6                	mov    %edx,%esi
801071d0:	eb 10                	jmp    801071e2 <deallocuvm.part.0+0x32>
801071d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071de:	39 de                	cmp    %ebx,%esi
801071e0:	76 46                	jbe    80107228 <deallocuvm.part.0+0x78>
    pte = walkpgdir(pgdir, (char*)a, 0);
801071e2:	31 c9                	xor    %ecx,%ecx
801071e4:	89 da                	mov    %ebx,%edx
801071e6:	89 f8                	mov    %edi,%eax
801071e8:	e8 b3 fe ff ff       	call   801070a0 <walkpgdir>
    if(!pte)
801071ed:	85 c0                	test   %eax,%eax
801071ef:	74 47                	je     80107238 <deallocuvm.part.0+0x88>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801071f1:	8b 10                	mov    (%eax),%edx
801071f3:	f6 c2 01             	test   $0x1,%dl
801071f6:	74 e0                	je     801071d8 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801071f8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801071fe:	74 46                	je     80107246 <deallocuvm.part.0+0x96>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107200:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107203:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107209:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010720c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107212:	52                   	push   %edx
80107213:	e8 48 b6 ff ff       	call   80102860 <kfree>
      *pte = 0;
80107218:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010721b:	83 c4 10             	add    $0x10,%esp
8010721e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107224:	39 de                	cmp    %ebx,%esi
80107226:	77 ba                	ja     801071e2 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80107228:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010722b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010722e:	5b                   	pop    %ebx
8010722f:	5e                   	pop    %esi
80107230:	5f                   	pop    %edi
80107231:	5d                   	pop    %ebp
80107232:	c3                   	ret    
80107233:	90                   	nop
80107234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107238:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
8010723e:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80107244:	eb 98                	jmp    801071de <deallocuvm.part.0+0x2e>
        panic("kfree");
80107246:	83 ec 0c             	sub    $0xc,%esp
80107249:	68 4e 7d 10 80       	push   $0x80107d4e
8010724e:	e8 8d 91 ff ff       	call   801003e0 <panic>
80107253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107260 <seginit>:
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107266:	e8 35 cb ff ff       	call   80103da0 <cpuid>
  pd[0] = size-1;
8010726b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107270:	69 c0 b8 00 00 00    	imul   $0xb8,%eax,%eax
80107276:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010727a:	c7 80 98 38 11 80 ff 	movl   $0xffff,-0x7feec768(%eax)
80107281:	ff 00 00 
80107284:	c7 80 9c 38 11 80 00 	movl   $0xcf9a00,-0x7feec764(%eax)
8010728b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010728e:	c7 80 a0 38 11 80 ff 	movl   $0xffff,-0x7feec760(%eax)
80107295:	ff 00 00 
80107298:	c7 80 a4 38 11 80 00 	movl   $0xcf9200,-0x7feec75c(%eax)
8010729f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072a2:	c7 80 a8 38 11 80 ff 	movl   $0xffff,-0x7feec758(%eax)
801072a9:	ff 00 00 
801072ac:	c7 80 ac 38 11 80 00 	movl   $0xcffa00,-0x7feec754(%eax)
801072b3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072b6:	c7 80 b0 38 11 80 ff 	movl   $0xffff,-0x7feec750(%eax)
801072bd:	ff 00 00 
801072c0:	c7 80 b4 38 11 80 00 	movl   $0xcff200,-0x7feec74c(%eax)
801072c7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072ca:	05 90 38 11 80       	add    $0x80113890,%eax
  pd[1] = (uint)p;
801072cf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072d3:	c1 e8 10             	shr    $0x10,%eax
801072d6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801072da:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072dd:	0f 01 10             	lgdtl  (%eax)
}
801072e0:	c9                   	leave  
801072e1:	c3                   	ret    
801072e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072f0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072f0:	a1 a4 6c 11 80       	mov    0x80116ca4,%eax
801072f5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072fa:	0f 22 d8             	mov    %eax,%cr3
}
801072fd:	c3                   	ret    
801072fe:	66 90                	xchg   %ax,%ax

80107300 <switchuvm>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	56                   	push   %esi
80107305:	53                   	push   %ebx
80107306:	83 ec 1c             	sub    $0x1c,%esp
80107309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010730c:	85 db                	test   %ebx,%ebx
8010730e:	0f 84 cb 00 00 00    	je     801073df <switchuvm+0xdf>
  if(p->kstack == 0)
80107314:	8b 43 08             	mov    0x8(%ebx),%eax
80107317:	85 c0                	test   %eax,%eax
80107319:	0f 84 da 00 00 00    	je     801073f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010731f:	8b 43 04             	mov    0x4(%ebx),%eax
80107322:	85 c0                	test   %eax,%eax
80107324:	0f 84 c2 00 00 00    	je     801073ec <switchuvm+0xec>
  pushcli();
8010732a:	e8 01 d8 ff ff       	call   80104b30 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010732f:	e8 ec c9 ff ff       	call   80103d20 <mycpu>
80107334:	89 c6                	mov    %eax,%esi
80107336:	e8 e5 c9 ff ff       	call   80103d20 <mycpu>
8010733b:	89 c7                	mov    %eax,%edi
8010733d:	e8 de c9 ff ff       	call   80103d20 <mycpu>
80107342:	83 c7 08             	add    $0x8,%edi
80107345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107348:	e8 d3 c9 ff ff       	call   80103d20 <mycpu>
8010734d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107350:	ba 67 00 00 00       	mov    $0x67,%edx
80107355:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
8010735c:	83 c0 08             	add    $0x8,%eax
8010735f:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107366:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010736b:	83 c1 08             	add    $0x8,%ecx
8010736e:	c1 e8 18             	shr    $0x18,%eax
80107371:	c1 e9 10             	shr    $0x10,%ecx
80107374:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
8010737a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107380:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107385:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010738c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107391:	e8 8a c9 ff ff       	call   80103d20 <mycpu>
80107396:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010739d:	e8 7e c9 ff ff       	call   80103d20 <mycpu>
801073a2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073a6:	8b 73 08             	mov    0x8(%ebx),%esi
801073a9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073af:	e8 6c c9 ff ff       	call   80103d20 <mycpu>
801073b4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073b7:	e8 64 c9 ff ff       	call   80103d20 <mycpu>
801073bc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073c0:	b8 28 00 00 00       	mov    $0x28,%eax
801073c5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073c8:	8b 43 04             	mov    0x4(%ebx),%eax
801073cb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073d0:	0f 22 d8             	mov    %eax,%cr3
}
801073d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d6:	5b                   	pop    %ebx
801073d7:	5e                   	pop    %esi
801073d8:	5f                   	pop    %edi
801073d9:	5d                   	pop    %ebp
  popcli();
801073da:	e9 61 d8 ff ff       	jmp    80104c40 <popcli>
    panic("switchuvm: no process");
801073df:	83 ec 0c             	sub    $0xc,%esp
801073e2:	68 d2 83 10 80       	push   $0x801083d2
801073e7:	e8 f4 8f ff ff       	call   801003e0 <panic>
    panic("switchuvm: no pgdir");
801073ec:	83 ec 0c             	sub    $0xc,%esp
801073ef:	68 fd 83 10 80       	push   $0x801083fd
801073f4:	e8 e7 8f ff ff       	call   801003e0 <panic>
    panic("switchuvm: no kstack");
801073f9:	83 ec 0c             	sub    $0xc,%esp
801073fc:	68 e8 83 10 80       	push   $0x801083e8
80107401:	e8 da 8f ff ff       	call   801003e0 <panic>
80107406:	8d 76 00             	lea    0x0(%esi),%esi
80107409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107410 <inituvm>:
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
80107415:	53                   	push   %ebx
80107416:	83 ec 1c             	sub    $0x1c,%esp
80107419:	8b 45 08             	mov    0x8(%ebp),%eax
8010741c:	8b 75 10             	mov    0x10(%ebp),%esi
8010741f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107425:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010742b:	77 49                	ja     80107476 <inituvm+0x66>
  mem = kalloc();
8010742d:	e8 ee b5 ff ff       	call   80102a20 <kalloc>
  memset(mem, 0, PGSIZE);
80107432:	83 ec 04             	sub    $0x4,%esp
80107435:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010743a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010743c:	6a 00                	push   $0x0
8010743e:	50                   	push   %eax
8010743f:	e8 ac d8 ff ff       	call   80104cf0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107444:	58                   	pop    %eax
80107445:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010744b:	5a                   	pop    %edx
8010744c:	6a 06                	push   $0x6
8010744e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107453:	31 d2                	xor    %edx,%edx
80107455:	50                   	push   %eax
80107456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107459:	e8 c2 fc ff ff       	call   80107120 <mappages>
  memmove(mem, init, sz);
8010745e:	89 75 10             	mov    %esi,0x10(%ebp)
80107461:	83 c4 10             	add    $0x10,%esp
80107464:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107467:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010746a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010746d:	5b                   	pop    %ebx
8010746e:	5e                   	pop    %esi
8010746f:	5f                   	pop    %edi
80107470:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107471:	e9 1a d9 ff ff       	jmp    80104d90 <memmove>
    panic("inituvm: more than a page");
80107476:	83 ec 0c             	sub    $0xc,%esp
80107479:	68 11 84 10 80       	push   $0x80108411
8010747e:	e8 5d 8f ff ff       	call   801003e0 <panic>
80107483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107490 <loaduvm>:
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 1c             	sub    $0x1c,%esp
80107499:	8b 45 0c             	mov    0xc(%ebp),%eax
8010749c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010749f:	a9 ff 0f 00 00       	test   $0xfff,%eax
801074a4:	0f 85 8d 00 00 00    	jne    80107537 <loaduvm+0xa7>
801074aa:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
801074ac:	89 f3                	mov    %esi,%ebx
801074ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074b1:	8b 45 14             	mov    0x14(%ebp),%eax
801074b4:	01 f0                	add    %esi,%eax
801074b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074b9:	85 f6                	test   %esi,%esi
801074bb:	75 11                	jne    801074ce <loaduvm+0x3e>
801074bd:	eb 61                	jmp    80107520 <loaduvm+0x90>
801074bf:	90                   	nop
801074c0:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801074c6:	89 f0                	mov    %esi,%eax
801074c8:	29 d8                	sub    %ebx,%eax
801074ca:	39 c6                	cmp    %eax,%esi
801074cc:	76 52                	jbe    80107520 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801074ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074d1:	8b 45 08             	mov    0x8(%ebp),%eax
801074d4:	31 c9                	xor    %ecx,%ecx
801074d6:	29 da                	sub    %ebx,%edx
801074d8:	e8 c3 fb ff ff       	call   801070a0 <walkpgdir>
801074dd:	85 c0                	test   %eax,%eax
801074df:	74 49                	je     8010752a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801074e1:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074e3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801074e6:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801074eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801074f0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801074f6:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074f9:	29 d9                	sub    %ebx,%ecx
801074fb:	05 00 00 00 80       	add    $0x80000000,%eax
80107500:	57                   	push   %edi
80107501:	51                   	push   %ecx
80107502:	50                   	push   %eax
80107503:	ff 75 10             	pushl  0x10(%ebp)
80107506:	e8 65 a9 ff ff       	call   80101e70 <readi>
8010750b:	83 c4 10             	add    $0x10,%esp
8010750e:	39 f8                	cmp    %edi,%eax
80107510:	74 ae                	je     801074c0 <loaduvm+0x30>
}
80107512:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107515:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010751a:	5b                   	pop    %ebx
8010751b:	5e                   	pop    %esi
8010751c:	5f                   	pop    %edi
8010751d:	5d                   	pop    %ebp
8010751e:	c3                   	ret    
8010751f:	90                   	nop
80107520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107523:	31 c0                	xor    %eax,%eax
}
80107525:	5b                   	pop    %ebx
80107526:	5e                   	pop    %esi
80107527:	5f                   	pop    %edi
80107528:	5d                   	pop    %ebp
80107529:	c3                   	ret    
      panic("loaduvm: address should exist");
8010752a:	83 ec 0c             	sub    $0xc,%esp
8010752d:	68 2b 84 10 80       	push   $0x8010842b
80107532:	e8 a9 8e ff ff       	call   801003e0 <panic>
    panic("loaduvm: addr must be page aligned");
80107537:	83 ec 0c             	sub    $0xc,%esp
8010753a:	68 00 85 10 80       	push   $0x80108500
8010753f:	e8 9c 8e ff ff       	call   801003e0 <panic>
80107544:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010754a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107550 <sharevm>:
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	57                   	push   %edi
80107554:	56                   	push   %esi
80107555:	53                   	push   %ebx
80107556:	83 ec 1c             	sub    $0x1c,%esp
80107559:	8b 55 0c             	mov    0xc(%ebp),%edx
8010755c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(sharedmemo.recs[idx]>0){
8010755f:	8d 5a 08             	lea    0x8(%edx),%ebx
80107562:	8b 04 9d e8 b5 10 80 	mov    -0x7fef4a18(,%ebx,4),%eax
80107569:	85 c0                	test   %eax,%eax
8010756b:	74 43                	je     801075b0 <sharevm+0x60>
    mem=sharedmemo.shared[idx];
8010756d:	8b 34 95 e0 b5 10 80 	mov    -0x7fef4a20(,%edx,4),%esi
  if(mappages(pgdir, (char*)(KERNBASE-(idx+1)*PGSIZE), PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107574:	8d 42 01             	lea    0x1(%edx),%eax
80107577:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010757c:	83 ec 08             	sub    $0x8,%esp
8010757f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107584:	c1 e0 0c             	shl    $0xc,%eax
80107587:	6a 06                	push   $0x6
80107589:	29 c2                	sub    %eax,%edx
8010758b:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107591:	50                   	push   %eax
80107592:	89 f8                	mov    %edi,%eax
80107594:	e8 87 fb ff ff       	call   80107120 <mappages>
80107599:	83 c4 10             	add    $0x10,%esp
8010759c:	85 c0                	test   %eax,%eax
8010759e:	78 48                	js     801075e8 <sharevm+0x98>
  sharedmemo.recs[idx]++;
801075a0:	83 04 9d e8 b5 10 80 	addl   $0x1,-0x7fef4a18(,%ebx,4)
801075a7:	01 
}
801075a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ab:	5b                   	pop    %ebx
801075ac:	5e                   	pop    %esi
801075ad:	5f                   	pop    %edi
801075ae:	5d                   	pop    %ebp
801075af:	c3                   	ret    
801075b0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    mem = kalloc();
801075b3:	e8 68 b4 ff ff       	call   80102a20 <kalloc>
    if(mem == 0){
801075b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801075bb:	85 c0                	test   %eax,%eax
    mem = kalloc();
801075bd:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801075bf:	74 4f                	je     80107610 <sharevm+0xc0>
    memset(mem, 0, PGSIZE);
801075c1:	83 ec 04             	sub    $0x4,%esp
801075c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801075c7:	68 00 10 00 00       	push   $0x1000
801075cc:	6a 00                	push   $0x0
801075ce:	50                   	push   %eax
801075cf:	e8 1c d7 ff ff       	call   80104cf0 <memset>
    sharedmemo.shared[idx]=mem;
801075d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801075d7:	83 c4 10             	add    $0x10,%esp
801075da:	89 34 95 e0 b5 10 80 	mov    %esi,-0x7fef4a20(,%edx,4)
801075e1:	eb 91                	jmp    80107574 <sharevm+0x24>
801075e3:	90                   	nop
801075e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("sharevm out of memory (2)\n");
801075e8:	83 ec 0c             	sub    $0xc,%esp
801075eb:	68 60 84 10 80       	push   $0x80108460
801075f0:	e8 fb 90 ff ff       	call   801006f0 <cprintf>
    kfree(mem);
801075f5:	89 75 08             	mov    %esi,0x8(%ebp)
801075f8:	83 c4 10             	add    $0x10,%esp
}
801075fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075fe:	5b                   	pop    %ebx
801075ff:	5e                   	pop    %esi
80107600:	5f                   	pop    %edi
80107601:	5d                   	pop    %ebp
    kfree(mem);
80107602:	e9 59 b2 ff ff       	jmp    80102860 <kfree>
80107607:	89 f6                	mov    %esi,%esi
80107609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      cprintf("sharevm out of memory\n");
80107610:	c7 45 08 49 84 10 80 	movl   $0x80108449,0x8(%ebp)
}
80107617:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010761a:	5b                   	pop    %ebx
8010761b:	5e                   	pop    %esi
8010761c:	5f                   	pop    %edi
8010761d:	5d                   	pop    %ebp
      cprintf("sharevm out of memory\n");
8010761e:	e9 cd 90 ff ff       	jmp    801006f0 <cprintf>
80107623:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107630 <allocuvm>:
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	57                   	push   %edi
80107634:	56                   	push   %esi
80107635:	53                   	push   %ebx
80107636:	83 ec 0c             	sub    $0xc,%esp
  if(newsz >= KERNBASE-MAXSHAREDPG*PGSIZE)
80107639:	81 7d 10 ff 5f ff 7f 	cmpl   $0x7fff5fff,0x10(%ebp)
80107640:	0f 87 aa 00 00 00    	ja     801076f0 <allocuvm+0xc0>
  if(newsz < oldsz)
80107646:	8b 45 0c             	mov    0xc(%ebp),%eax
80107649:	39 45 10             	cmp    %eax,0x10(%ebp)
8010764c:	0f 82 a0 00 00 00    	jb     801076f2 <allocuvm+0xc2>
  a = PGROUNDUP(oldsz);
80107652:	8b 45 0c             	mov    0xc(%ebp),%eax
80107655:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010765b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107661:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107664:	0f 86 96 00 00 00    	jbe    80107700 <allocuvm+0xd0>
8010766a:	8b 45 10             	mov    0x10(%ebp),%eax
8010766d:	83 e8 01             	sub    $0x1,%eax
80107670:	29 d8                	sub    %ebx,%eax
80107672:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107677:	8d bc 03 00 10 00 00 	lea    0x1000(%ebx,%eax,1),%edi
8010767e:	eb 3b                	jmp    801076bb <allocuvm+0x8b>
    memset(mem, 0, PGSIZE);
80107680:	83 ec 04             	sub    $0x4,%esp
80107683:	68 00 10 00 00       	push   $0x1000
80107688:	6a 00                	push   $0x0
8010768a:	50                   	push   %eax
8010768b:	e8 60 d6 ff ff       	call   80104cf0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107690:	58                   	pop    %eax
80107691:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107697:	5a                   	pop    %edx
80107698:	6a 06                	push   $0x6
8010769a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010769f:	89 da                	mov    %ebx,%edx
801076a1:	50                   	push   %eax
801076a2:	8b 45 08             	mov    0x8(%ebp),%eax
801076a5:	e8 76 fa ff ff       	call   80107120 <mappages>
801076aa:	83 c4 10             	add    $0x10,%esp
801076ad:	85 c0                	test   %eax,%eax
801076af:	78 5f                	js     80107710 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
801076b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076b7:	39 fb                	cmp    %edi,%ebx
801076b9:	74 45                	je     80107700 <allocuvm+0xd0>
    mem = kalloc();
801076bb:	e8 60 b3 ff ff       	call   80102a20 <kalloc>
801076c0:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801076c2:	85 c0                	test   %eax,%eax
801076c4:	75 ba                	jne    80107680 <allocuvm+0x50>
      cprintf("allocuvm out of memory\n");
801076c6:	83 ec 0c             	sub    $0xc,%esp
801076c9:	68 7b 84 10 80       	push   $0x8010847b
801076ce:	e8 1d 90 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
801076d3:	83 c4 10             	add    $0x10,%esp
801076d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801076d9:	39 45 10             	cmp    %eax,0x10(%ebp)
801076dc:	74 12                	je     801076f0 <allocuvm+0xc0>
801076de:	89 c1                	mov    %eax,%ecx
801076e0:	8b 55 10             	mov    0x10(%ebp),%edx
801076e3:	8b 45 08             	mov    0x8(%ebp),%eax
801076e6:	e8 c5 fa ff ff       	call   801071b0 <deallocuvm.part.0>
801076eb:	90                   	nop
801076ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
801076f0:	31 c0                	xor    %eax,%eax
}
801076f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076f5:	5b                   	pop    %ebx
801076f6:	5e                   	pop    %esi
801076f7:	5f                   	pop    %edi
801076f8:	5d                   	pop    %ebp
801076f9:	c3                   	ret    
801076fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return newsz;
80107700:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107703:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107706:	5b                   	pop    %ebx
80107707:	5e                   	pop    %esi
80107708:	5f                   	pop    %edi
80107709:	5d                   	pop    %ebp
8010770a:	c3                   	ret    
8010770b:	90                   	nop
8010770c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107710:	83 ec 0c             	sub    $0xc,%esp
80107713:	68 93 84 10 80       	push   $0x80108493
80107718:	e8 d3 8f ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
8010771d:	83 c4 10             	add    $0x10,%esp
80107720:	8b 45 0c             	mov    0xc(%ebp),%eax
80107723:	39 45 10             	cmp    %eax,0x10(%ebp)
80107726:	74 0d                	je     80107735 <allocuvm+0x105>
80107728:	89 c1                	mov    %eax,%ecx
8010772a:	8b 55 10             	mov    0x10(%ebp),%edx
8010772d:	8b 45 08             	mov    0x8(%ebp),%eax
80107730:	e8 7b fa ff ff       	call   801071b0 <deallocuvm.part.0>
      kfree(mem);
80107735:	83 ec 0c             	sub    $0xc,%esp
80107738:	56                   	push   %esi
80107739:	e8 22 b1 ff ff       	call   80102860 <kfree>
      return 0;
8010773e:	83 c4 10             	add    $0x10,%esp
}
80107741:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107744:	31 c0                	xor    %eax,%eax
}
80107746:	5b                   	pop    %ebx
80107747:	5e                   	pop    %esi
80107748:	5f                   	pop    %edi
80107749:	5d                   	pop    %ebp
8010774a:	c3                   	ret    
8010774b:	90                   	nop
8010774c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107750 <deallocuvm>:
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	8b 55 0c             	mov    0xc(%ebp),%edx
80107756:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107759:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010775c:	39 d1                	cmp    %edx,%ecx
8010775e:	73 10                	jae    80107770 <deallocuvm+0x20>
}
80107760:	5d                   	pop    %ebp
80107761:	e9 4a fa ff ff       	jmp    801071b0 <deallocuvm.part.0>
80107766:	8d 76 00             	lea    0x0(%esi),%esi
80107769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107770:	89 d0                	mov    %edx,%eax
80107772:	5d                   	pop    %ebp
80107773:	c3                   	ret    
80107774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010777a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107780 <desharevm>:

void
desharevm(int idx)
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(sharedmemo.recs[idx]<=0)
80107786:	8d 51 08             	lea    0x8(%ecx),%edx
80107789:	8b 04 95 e8 b5 10 80 	mov    -0x7fef4a18(,%edx,4),%eax
80107790:	85 c0                	test   %eax,%eax
80107792:	74 0c                	je     801077a0 <desharevm+0x20>
    return;

  sharedmemo.recs[idx]--;
80107794:	83 e8 01             	sub    $0x1,%eax
80107797:	89 04 95 e8 b5 10 80 	mov    %eax,-0x7fef4a18(,%edx,4)
  if(sharedmemo.recs[idx]<=0){
8010779e:	74 08                	je     801077a8 <desharevm+0x28>
    kfree(sharedmemo.shared[idx]);
  }
}
801077a0:	5d                   	pop    %ebp
801077a1:	c3                   	ret    
801077a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kfree(sharedmemo.shared[idx]);
801077a8:	8b 04 8d e0 b5 10 80 	mov    -0x7fef4a20(,%ecx,4),%eax
801077af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801077b2:	5d                   	pop    %ebp
    kfree(sharedmemo.shared[idx]);
801077b3:	e9 a8 b0 ff ff       	jmp    80102860 <kfree>
801077b8:	90                   	nop
801077b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801077c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	57                   	push   %edi
801077c4:	56                   	push   %esi
801077c5:	53                   	push   %ebx
801077c6:	83 ec 0c             	sub    $0xc,%esp
801077c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801077cc:	85 f6                	test   %esi,%esi
801077ce:	74 59                	je     80107829 <freevm+0x69>
  if(newsz >= oldsz)
801077d0:	31 c9                	xor    %ecx,%ecx
801077d2:	ba 00 60 ff 7f       	mov    $0x7fff6000,%edx
801077d7:	89 f0                	mov    %esi,%eax
801077d9:	89 f3                	mov    %esi,%ebx
801077db:	e8 d0 f9 ff ff       	call   801071b0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE-MAXSHAREDPG*PGSIZE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801077e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801077e6:	eb 0f                	jmp    801077f7 <freevm+0x37>
801077e8:	90                   	nop
801077e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077f0:	83 c3 04             	add    $0x4,%ebx
801077f3:	39 df                	cmp    %ebx,%edi
801077f5:	74 23                	je     8010781a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801077f7:	8b 03                	mov    (%ebx),%eax
801077f9:	a8 01                	test   $0x1,%al
801077fb:	74 f3                	je     801077f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801077fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107802:	83 ec 0c             	sub    $0xc,%esp
80107805:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107808:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010780d:	50                   	push   %eax
8010780e:	e8 4d b0 ff ff       	call   80102860 <kfree>
80107813:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107816:	39 df                	cmp    %ebx,%edi
80107818:	75 dd                	jne    801077f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010781a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010781d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107820:	5b                   	pop    %ebx
80107821:	5e                   	pop    %esi
80107822:	5f                   	pop    %edi
80107823:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107824:	e9 37 b0 ff ff       	jmp    80102860 <kfree>
    panic("freevm: no pgdir");
80107829:	83 ec 0c             	sub    $0xc,%esp
8010782c:	68 af 84 10 80       	push   $0x801084af
80107831:	e8 aa 8b ff ff       	call   801003e0 <panic>
80107836:	8d 76 00             	lea    0x0(%esi),%esi
80107839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107840 <setupkvm>:
{
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	56                   	push   %esi
80107844:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107845:	e8 d6 b1 ff ff       	call   80102a20 <kalloc>
8010784a:	89 c6                	mov    %eax,%esi
8010784c:	85 c0                	test   %eax,%eax
8010784e:	74 42                	je     80107892 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107850:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107853:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107858:	68 00 10 00 00       	push   $0x1000
8010785d:	6a 00                	push   $0x0
8010785f:	50                   	push   %eax
80107860:	e8 8b d4 ff ff       	call   80104cf0 <memset>
80107865:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107868:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010786b:	83 ec 08             	sub    $0x8,%esp
8010786e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107871:	ff 73 0c             	pushl  0xc(%ebx)
80107874:	8b 13                	mov    (%ebx),%edx
80107876:	50                   	push   %eax
80107877:	29 c1                	sub    %eax,%ecx
80107879:	89 f0                	mov    %esi,%eax
8010787b:	e8 a0 f8 ff ff       	call   80107120 <mappages>
80107880:	83 c4 10             	add    $0x10,%esp
80107883:	85 c0                	test   %eax,%eax
80107885:	78 19                	js     801078a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107887:	83 c3 10             	add    $0x10,%ebx
8010788a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107890:	75 d6                	jne    80107868 <setupkvm+0x28>
}
80107892:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107895:	89 f0                	mov    %esi,%eax
80107897:	5b                   	pop    %ebx
80107898:	5e                   	pop    %esi
80107899:	5d                   	pop    %ebp
8010789a:	c3                   	ret    
8010789b:	90                   	nop
8010789c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801078a0:	83 ec 0c             	sub    $0xc,%esp
801078a3:	56                   	push   %esi
      return 0;
801078a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801078a6:	e8 15 ff ff ff       	call   801077c0 <freevm>
      return 0;
801078ab:	83 c4 10             	add    $0x10,%esp
}
801078ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801078b1:	89 f0                	mov    %esi,%eax
801078b3:	5b                   	pop    %ebx
801078b4:	5e                   	pop    %esi
801078b5:	5d                   	pop    %ebp
801078b6:	c3                   	ret    
801078b7:	89 f6                	mov    %esi,%esi
801078b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078c0 <kvmalloc>:
{
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801078c6:	e8 75 ff ff ff       	call   80107840 <setupkvm>
801078cb:	a3 a4 6c 11 80       	mov    %eax,0x80116ca4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801078d0:	05 00 00 00 80       	add    $0x80000000,%eax
801078d5:	0f 22 d8             	mov    %eax,%cr3
}
801078d8:	c9                   	leave  
801078d9:	c3                   	ret    
801078da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801078e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078e1:	31 c9                	xor    %ecx,%ecx
{
801078e3:	89 e5                	mov    %esp,%ebp
801078e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801078e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801078eb:	8b 45 08             	mov    0x8(%ebp),%eax
801078ee:	e8 ad f7 ff ff       	call   801070a0 <walkpgdir>
  if(pte == 0)
801078f3:	85 c0                	test   %eax,%eax
801078f5:	74 05                	je     801078fc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801078f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801078fa:	c9                   	leave  
801078fb:	c3                   	ret    
    panic("clearpteu");
801078fc:	83 ec 0c             	sub    $0xc,%esp
801078ff:	68 c0 84 10 80       	push   $0x801084c0
80107904:	e8 d7 8a ff ff       	call   801003e0 <panic>
80107909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107910 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107910:	55                   	push   %ebp
80107911:	89 e5                	mov    %esp,%ebp
80107913:	57                   	push   %edi
80107914:	56                   	push   %esi
80107915:	53                   	push   %ebx
80107916:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107919:	e8 22 ff ff ff       	call   80107840 <setupkvm>
8010791e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107921:	85 c0                	test   %eax,%eax
80107923:	0f 84 a0 00 00 00    	je     801079c9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107929:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010792c:	85 c9                	test   %ecx,%ecx
8010792e:	0f 84 95 00 00 00    	je     801079c9 <copyuvm+0xb9>
80107934:	31 f6                	xor    %esi,%esi
80107936:	eb 4e                	jmp    80107986 <copyuvm+0x76>
80107938:	90                   	nop
80107939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107940:	83 ec 04             	sub    $0x4,%esp
80107943:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107949:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010794c:	68 00 10 00 00       	push   $0x1000
80107951:	57                   	push   %edi
80107952:	50                   	push   %eax
80107953:	e8 38 d4 ff ff       	call   80104d90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107958:	58                   	pop    %eax
80107959:	5a                   	pop    %edx
8010795a:	53                   	push   %ebx
8010795b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010795e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107961:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107966:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010796c:	52                   	push   %edx
8010796d:	89 f2                	mov    %esi,%edx
8010796f:	e8 ac f7 ff ff       	call   80107120 <mappages>
80107974:	83 c4 10             	add    $0x10,%esp
80107977:	85 c0                	test   %eax,%eax
80107979:	78 39                	js     801079b4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010797b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107981:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107984:	76 43                	jbe    801079c9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107986:	8b 45 08             	mov    0x8(%ebp),%eax
80107989:	31 c9                	xor    %ecx,%ecx
8010798b:	89 f2                	mov    %esi,%edx
8010798d:	e8 0e f7 ff ff       	call   801070a0 <walkpgdir>
80107992:	85 c0                	test   %eax,%eax
80107994:	74 3e                	je     801079d4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107996:	8b 18                	mov    (%eax),%ebx
80107998:	f6 c3 01             	test   $0x1,%bl
8010799b:	74 44                	je     801079e1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
8010799d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010799f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801079a5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801079ab:	e8 70 b0 ff ff       	call   80102a20 <kalloc>
801079b0:	85 c0                	test   %eax,%eax
801079b2:	75 8c                	jne    80107940 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801079b4:	83 ec 0c             	sub    $0xc,%esp
801079b7:	ff 75 e0             	pushl  -0x20(%ebp)
801079ba:	e8 01 fe ff ff       	call   801077c0 <freevm>
  return 0;
801079bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801079c6:	83 c4 10             	add    $0x10,%esp
}
801079c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079cf:	5b                   	pop    %ebx
801079d0:	5e                   	pop    %esi
801079d1:	5f                   	pop    %edi
801079d2:	5d                   	pop    %ebp
801079d3:	c3                   	ret    
      panic("copyuvm: pte should exist");
801079d4:	83 ec 0c             	sub    $0xc,%esp
801079d7:	68 ca 84 10 80       	push   $0x801084ca
801079dc:	e8 ff 89 ff ff       	call   801003e0 <panic>
      panic("copyuvm: page not present");
801079e1:	83 ec 0c             	sub    $0xc,%esp
801079e4:	68 e4 84 10 80       	push   $0x801084e4
801079e9:	e8 f2 89 ff ff       	call   801003e0 <panic>
801079ee:	66 90                	xchg   %ax,%ax

801079f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801079f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801079f1:	31 c9                	xor    %ecx,%ecx
{
801079f3:	89 e5                	mov    %esp,%ebp
801079f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801079f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801079fb:	8b 45 08             	mov    0x8(%ebp),%eax
801079fe:	e8 9d f6 ff ff       	call   801070a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107a03:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107a05:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107a06:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107a0d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a10:	05 00 00 00 80       	add    $0x80000000,%eax
80107a15:	83 fa 05             	cmp    $0x5,%edx
80107a18:	ba 00 00 00 00       	mov    $0x0,%edx
80107a1d:	0f 45 c2             	cmovne %edx,%eax
}
80107a20:	c3                   	ret    
80107a21:	eb 0d                	jmp    80107a30 <copyout>
80107a23:	90                   	nop
80107a24:	90                   	nop
80107a25:	90                   	nop
80107a26:	90                   	nop
80107a27:	90                   	nop
80107a28:	90                   	nop
80107a29:	90                   	nop
80107a2a:	90                   	nop
80107a2b:	90                   	nop
80107a2c:	90                   	nop
80107a2d:	90                   	nop
80107a2e:	90                   	nop
80107a2f:	90                   	nop

80107a30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a30:	55                   	push   %ebp
80107a31:	89 e5                	mov    %esp,%ebp
80107a33:	57                   	push   %edi
80107a34:	56                   	push   %esi
80107a35:	53                   	push   %ebx
80107a36:	83 ec 0c             	sub    $0xc,%esp
80107a39:	8b 75 14             	mov    0x14(%ebp),%esi
80107a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a3f:	85 f6                	test   %esi,%esi
80107a41:	75 38                	jne    80107a7b <copyout+0x4b>
80107a43:	eb 6b                	jmp    80107ab0 <copyout+0x80>
80107a45:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107a48:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a4b:	89 fb                	mov    %edi,%ebx
80107a4d:	29 d3                	sub    %edx,%ebx
80107a4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107a55:	39 f3                	cmp    %esi,%ebx
80107a57:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a5a:	29 fa                	sub    %edi,%edx
80107a5c:	83 ec 04             	sub    $0x4,%esp
80107a5f:	01 c2                	add    %eax,%edx
80107a61:	53                   	push   %ebx
80107a62:	ff 75 10             	pushl  0x10(%ebp)
80107a65:	52                   	push   %edx
80107a66:	e8 25 d3 ff ff       	call   80104d90 <memmove>
    len -= n;
    buf += n;
80107a6b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107a6e:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107a74:	83 c4 10             	add    $0x10,%esp
80107a77:	29 de                	sub    %ebx,%esi
80107a79:	74 35                	je     80107ab0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107a7b:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a7d:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107a80:	89 55 0c             	mov    %edx,0xc(%ebp)
80107a83:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a89:	57                   	push   %edi
80107a8a:	ff 75 08             	pushl  0x8(%ebp)
80107a8d:	e8 5e ff ff ff       	call   801079f0 <uva2ka>
    if(pa0 == 0)
80107a92:	83 c4 10             	add    $0x10,%esp
80107a95:	85 c0                	test   %eax,%eax
80107a97:	75 af                	jne    80107a48 <copyout+0x18>
  }
  return 0;
}
80107a99:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107aa1:	5b                   	pop    %ebx
80107aa2:	5e                   	pop    %esi
80107aa3:	5f                   	pop    %edi
80107aa4:	5d                   	pop    %ebp
80107aa5:	c3                   	ret    
80107aa6:	8d 76 00             	lea    0x0(%esi),%esi
80107aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ab3:	31 c0                	xor    %eax,%eax
}
80107ab5:	5b                   	pop    %ebx
80107ab6:	5e                   	pop    %esi
80107ab7:	5f                   	pop    %edi
80107ab8:	5d                   	pop    %ebp
80107ab9:	c3                   	ret    
