
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	2d013103          	ld	sp,720(sp) # 8000a2d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	699040ef          	jal	80004eae <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00023797          	auipc	a5,0x23
    80000034:	62078793          	addi	a5,a5,1568 # 80023650 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	2d490913          	addi	s2,s2,724 # 8000a320 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	0bb050ef          	jal	80005910 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	143050ef          	jal	800059a8 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	564050ef          	jal	800055e2 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	24650513          	addi	a0,a0,582 # 8000a320 <kmem>
    800000e2:	7ae050ef          	jal	80005890 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	56650513          	addi	a0,a0,1382 # 80023650 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	21848493          	addi	s1,s1,536 # 8000a320 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	7fe050ef          	jal	80005910 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	20450513          	addi	a0,a0,516 # 8000a320 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	083050ef          	jal	800059a8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	1e050513          	addi	a0,a0,480 # 8000a320 <kmem>
    80000148:	061050ef          	jal	800059a8 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb9b1>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f0:	371000ef          	jal	80000e60 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	0000a717          	auipc	a4,0xa
    800002f8:	ffc70713          	addi	a4,a4,-4 # 8000a2f0 <started>
  if(cpuid() == 0){
    800002fc:	c51d                	beqz	a0,8000032a <main+0x42>
    while(started == 0)
    800002fe:	431c                	lw	a5,0(a4)
    80000300:	2781                	sext.w	a5,a5
    80000302:	dff5                	beqz	a5,800002fe <main+0x16>
      ;
    __sync_synchronize();
    80000304:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000308:	359000ef          	jal	80000e60 <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	7fb040ef          	jal	80005310 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	65e010ef          	jal	8000197c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	5a6040ef          	jal	800048c8 <plicinithart>
  }

  scheduler();        
    80000326:	79b000ef          	jal	800012c0 <scheduler>
    consoleinit();
    8000032a:	711040ef          	jal	8000523a <consoleinit>
    printfinit();
    8000032e:	2ee050ef          	jal	8000561c <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	7d7040ef          	jal	80005310 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	7cb040ef          	jal	80005310 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	7bf040ef          	jal	80005310 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	249000ef          	jal	80000daa <procinit>
    trapinit();      // trap vectors
    80000366:	5f2010ef          	jal	80001958 <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	612010ef          	jal	8000197c <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	540040ef          	jal	800048ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	556040ef          	jal	800048c8 <plicinithart>
    binit();         // buffer cache
    80000376:	4f1010ef          	jal	80002066 <binit>
    iinit();         // inode table
    8000037a:	2e2020ef          	jal	8000265c <iinit>
    fileinit();      // file table
    8000037e:	08e030ef          	jal	8000340c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	636040ef          	jal	800049b8 <virtio_disk_init>
    userinit();      // first user process
    80000386:	56f000ef          	jal	800010f4 <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000a717          	auipc	a4,0xa
    80000394:	f6f72023          	sw	a5,-160(a4) # 8000a2f0 <started>
    80000398:	b779                	j	80000326 <main+0x3e>

000000008000039a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003a4:	0000a797          	auipc	a5,0xa
    800003a8:	f547b783          	ld	a5,-172(a5) # 8000a2f8 <kernel_pagetable>
    800003ac:	83b1                	srli	a5,a5,0xc
    800003ae:	577d                	li	a4,-1
    800003b0:	177e                	slli	a4,a4,0x3f
    800003b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003b4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003b8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003bc:	6422                	ld	s0,8(sp)
    800003be:	0141                	addi	sp,sp,16
    800003c0:	8082                	ret

00000000800003c2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c2:	7139                	addi	sp,sp,-64
    800003c4:	fc06                	sd	ra,56(sp)
    800003c6:	f822                	sd	s0,48(sp)
    800003c8:	f426                	sd	s1,40(sp)
    800003ca:	f04a                	sd	s2,32(sp)
    800003cc:	ec4e                	sd	s3,24(sp)
    800003ce:	e852                	sd	s4,16(sp)
    800003d0:	e456                	sd	s5,8(sp)
    800003d2:	e05a                	sd	s6,0(sp)
    800003d4:	0080                	addi	s0,sp,64
    800003d6:	84aa                	mv	s1,a0
    800003d8:	89ae                	mv	s3,a1
    800003da:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003dc:	57fd                	li	a5,-1
    800003de:	83e9                	srli	a5,a5,0x1a
    800003e0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003e4:	02b7fc63          	bgeu	a5,a1,8000041c <walk+0x5a>
    panic("walk");
    800003e8:	00007517          	auipc	a0,0x7
    800003ec:	c6850513          	addi	a0,a0,-920 # 80007050 <etext+0x50>
    800003f0:	1f2050ef          	jal	800055e2 <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003f4:	060a8263          	beqz	s5,80000458 <walk+0x96>
    800003f8:	d07ff0ef          	jal	800000fe <kalloc>
    800003fc:	84aa                	mv	s1,a0
    800003fe:	c139                	beqz	a0,80000444 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000400:	6605                	lui	a2,0x1
    80000402:	4581                	li	a1,0
    80000404:	d4bff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000408:	00c4d793          	srli	a5,s1,0xc
    8000040c:	07aa                	slli	a5,a5,0xa
    8000040e:	0017e793          	ori	a5,a5,1
    80000412:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb9a7>
    80000418:	036a0063          	beq	s4,s6,80000438 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000041c:	0149d933          	srl	s2,s3,s4
    80000420:	1ff97913          	andi	s2,s2,511
    80000424:	090e                	slli	s2,s2,0x3
    80000426:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000428:	00093483          	ld	s1,0(s2)
    8000042c:	0014f793          	andi	a5,s1,1
    80000430:	d3f1                	beqz	a5,800003f4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000432:	80a9                	srli	s1,s1,0xa
    80000434:	04b2                	slli	s1,s1,0xc
    80000436:	b7c5                	j	80000416 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
}
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
        return 0;
    80000458:	4501                	li	a0,0
    8000045a:	b7ed                	j	80000444 <walk+0x82>

000000008000045c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000045c:	57fd                	li	a5,-1
    8000045e:	83e9                	srli	a5,a5,0x1a
    80000460:	00b7f463          	bgeu	a5,a1,80000468 <walkaddr+0xc>
    return 0;
    80000464:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000466:	8082                	ret
{
    80000468:	1141                	addi	sp,sp,-16
    8000046a:	e406                	sd	ra,8(sp)
    8000046c:	e022                	sd	s0,0(sp)
    8000046e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000470:	4601                	li	a2,0
    80000472:	f51ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000476:	c105                	beqz	a0,80000496 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000478:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000047a:	0117f693          	andi	a3,a5,17
    8000047e:	4745                	li	a4,17
    return 0;
    80000480:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000482:	00e68663          	beq	a3,a4,8000048e <walkaddr+0x32>
}
    80000486:	60a2                	ld	ra,8(sp)
    80000488:	6402                	ld	s0,0(sp)
    8000048a:	0141                	addi	sp,sp,16
    8000048c:	8082                	ret
  pa = PTE2PA(*pte);
    8000048e:	83a9                	srli	a5,a5,0xa
    80000490:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000494:	bfcd                	j	80000486 <walkaddr+0x2a>
    return 0;
    80000496:	4501                	li	a0,0
    80000498:	b7fd                	j	80000486 <walkaddr+0x2a>

000000008000049a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000049a:	715d                	addi	sp,sp,-80
    8000049c:	e486                	sd	ra,72(sp)
    8000049e:	e0a2                	sd	s0,64(sp)
    800004a0:	fc26                	sd	s1,56(sp)
    800004a2:	f84a                	sd	s2,48(sp)
    800004a4:	f44e                	sd	s3,40(sp)
    800004a6:	f052                	sd	s4,32(sp)
    800004a8:	ec56                	sd	s5,24(sp)
    800004aa:	e85a                	sd	s6,16(sp)
    800004ac:	e45e                	sd	s7,8(sp)
    800004ae:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004b0:	03459793          	slli	a5,a1,0x34
    800004b4:	e7a9                	bnez	a5,800004fe <mappages+0x64>
    800004b6:	8aaa                	mv	s5,a0
    800004b8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004ba:	03461793          	slli	a5,a2,0x34
    800004be:	e7b1                	bnez	a5,8000050a <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004c0:	ca39                	beqz	a2,80000516 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004c2:	77fd                	lui	a5,0xfffff
    800004c4:	963e                	add	a2,a2,a5
    800004c6:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ca:	892e                	mv	s2,a1
    800004cc:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004d0:	6b85                	lui	s7,0x1
    800004d2:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004d6:	4605                	li	a2,1
    800004d8:	85ca                	mv	a1,s2
    800004da:	8556                	mv	a0,s5
    800004dc:	ee7ff0ef          	jal	800003c2 <walk>
    800004e0:	c539                	beqz	a0,8000052e <mappages+0x94>
    if(*pte & PTE_V)
    800004e2:	611c                	ld	a5,0(a0)
    800004e4:	8b85                	andi	a5,a5,1
    800004e6:	ef95                	bnez	a5,80000522 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004e8:	80b1                	srli	s1,s1,0xc
    800004ea:	04aa                	slli	s1,s1,0xa
    800004ec:	0164e4b3          	or	s1,s1,s6
    800004f0:	0014e493          	ori	s1,s1,1
    800004f4:	e104                	sd	s1,0(a0)
    if(a == last)
    800004f6:	05390863          	beq	s2,s3,80000546 <mappages+0xac>
    a += PGSIZE;
    800004fa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	bfd9                	j	800004d2 <mappages+0x38>
    panic("mappages: va not aligned");
    800004fe:	00007517          	auipc	a0,0x7
    80000502:	b5a50513          	addi	a0,a0,-1190 # 80007058 <etext+0x58>
    80000506:	0dc050ef          	jal	800055e2 <panic>
    panic("mappages: size not aligned");
    8000050a:	00007517          	auipc	a0,0x7
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80007078 <etext+0x78>
    80000512:	0d0050ef          	jal	800055e2 <panic>
    panic("mappages: size");
    80000516:	00007517          	auipc	a0,0x7
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80007098 <etext+0x98>
    8000051e:	0c4050ef          	jal	800055e2 <panic>
      panic("mappages: remap");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b8650513          	addi	a0,a0,-1146 # 800070a8 <etext+0xa8>
    8000052a:	0b8050ef          	jal	800055e2 <panic>
      return -1;
    8000052e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000530:	60a6                	ld	ra,72(sp)
    80000532:	6406                	ld	s0,64(sp)
    80000534:	74e2                	ld	s1,56(sp)
    80000536:	7942                	ld	s2,48(sp)
    80000538:	79a2                	ld	s3,40(sp)
    8000053a:	7a02                	ld	s4,32(sp)
    8000053c:	6ae2                	ld	s5,24(sp)
    8000053e:	6b42                	ld	s6,16(sp)
    80000540:	6ba2                	ld	s7,8(sp)
    80000542:	6161                	addi	sp,sp,80
    80000544:	8082                	ret
  return 0;
    80000546:	4501                	li	a0,0
    80000548:	b7e5                	j	80000530 <mappages+0x96>

000000008000054a <kvmmap>:
{
    8000054a:	1141                	addi	sp,sp,-16
    8000054c:	e406                	sd	ra,8(sp)
    8000054e:	e022                	sd	s0,0(sp)
    80000550:	0800                	addi	s0,sp,16
    80000552:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000554:	86b2                	mv	a3,a2
    80000556:	863e                	mv	a2,a5
    80000558:	f43ff0ef          	jal	8000049a <mappages>
    8000055c:	e509                	bnez	a0,80000566 <kvmmap+0x1c>
}
    8000055e:	60a2                	ld	ra,8(sp)
    80000560:	6402                	ld	s0,0(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret
    panic("kvmmap");
    80000566:	00007517          	auipc	a0,0x7
    8000056a:	b5250513          	addi	a0,a0,-1198 # 800070b8 <etext+0xb8>
    8000056e:	074050ef          	jal	800055e2 <panic>

0000000080000572 <kvmmake>:
{
    80000572:	1101                	addi	sp,sp,-32
    80000574:	ec06                	sd	ra,24(sp)
    80000576:	e822                	sd	s0,16(sp)
    80000578:	e426                	sd	s1,8(sp)
    8000057a:	e04a                	sd	s2,0(sp)
    8000057c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000057e:	b81ff0ef          	jal	800000fe <kalloc>
    80000582:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000584:	6605                	lui	a2,0x1
    80000586:	4581                	li	a1,0
    80000588:	bc7ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000058c:	4719                	li	a4,6
    8000058e:	6685                	lui	a3,0x1
    80000590:	10000637          	lui	a2,0x10000
    80000594:	100005b7          	lui	a1,0x10000
    80000598:	8526                	mv	a0,s1
    8000059a:	fb1ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000059e:	4719                	li	a4,6
    800005a0:	6685                	lui	a3,0x1
    800005a2:	10001637          	lui	a2,0x10001
    800005a6:	100015b7          	lui	a1,0x10001
    800005aa:	8526                	mv	a0,s1
    800005ac:	f9fff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005b0:	4719                	li	a4,6
    800005b2:	040006b7          	lui	a3,0x4000
    800005b6:	0c000637          	lui	a2,0xc000
    800005ba:	0c0005b7          	lui	a1,0xc000
    800005be:	8526                	mv	a0,s1
    800005c0:	f8bff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005c4:	00007917          	auipc	s2,0x7
    800005c8:	a3c90913          	addi	s2,s2,-1476 # 80007000 <etext>
    800005cc:	4729                	li	a4,10
    800005ce:	80007697          	auipc	a3,0x80007
    800005d2:	a3268693          	addi	a3,a3,-1486 # 7000 <_entry-0x7fff9000>
    800005d6:	4605                	li	a2,1
    800005d8:	067e                	slli	a2,a2,0x1f
    800005da:	85b2                	mv	a1,a2
    800005dc:	8526                	mv	a0,s1
    800005de:	f6dff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005e2:	46c5                	li	a3,17
    800005e4:	06ee                	slli	a3,a3,0x1b
    800005e6:	4719                	li	a4,6
    800005e8:	412686b3          	sub	a3,a3,s2
    800005ec:	864a                	mv	a2,s2
    800005ee:	85ca                	mv	a1,s2
    800005f0:	8526                	mv	a0,s1
    800005f2:	f59ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005f6:	4729                	li	a4,10
    800005f8:	6685                	lui	a3,0x1
    800005fa:	00006617          	auipc	a2,0x6
    800005fe:	a0660613          	addi	a2,a2,-1530 # 80006000 <_trampoline>
    80000602:	040005b7          	lui	a1,0x4000
    80000606:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000608:	05b2                	slli	a1,a1,0xc
    8000060a:	8526                	mv	a0,s1
    8000060c:	f3fff0ef          	jal	8000054a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000610:	8526                	mv	a0,s1
    80000612:	700000ef          	jal	80000d12 <proc_mapstacks>
}
    80000616:	8526                	mv	a0,s1
    80000618:	60e2                	ld	ra,24(sp)
    8000061a:	6442                	ld	s0,16(sp)
    8000061c:	64a2                	ld	s1,8(sp)
    8000061e:	6902                	ld	s2,0(sp)
    80000620:	6105                	addi	sp,sp,32
    80000622:	8082                	ret

0000000080000624 <kvminit>:
{
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000062c:	f47ff0ef          	jal	80000572 <kvmmake>
    80000630:	0000a797          	auipc	a5,0xa
    80000634:	cca7b423          	sd	a0,-824(a5) # 8000a2f8 <kernel_pagetable>
}
    80000638:	60a2                	ld	ra,8(sp)
    8000063a:	6402                	ld	s0,0(sp)
    8000063c:	0141                	addi	sp,sp,16
    8000063e:	8082                	ret

0000000080000640 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000640:	715d                	addi	sp,sp,-80
    80000642:	e486                	sd	ra,72(sp)
    80000644:	e0a2                	sd	s0,64(sp)
    80000646:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    80000648:	03459793          	slli	a5,a1,0x34
    8000064c:	e39d                	bnez	a5,80000672 <uvmunmap+0x32>
    8000064e:	f84a                	sd	s2,48(sp)
    80000650:	f44e                	sd	s3,40(sp)
    80000652:	f052                	sd	s4,32(sp)
    80000654:	ec56                	sd	s5,24(sp)
    80000656:	e85a                	sd	s6,16(sp)
    80000658:	e45e                	sd	s7,8(sp)
    8000065a:	8a2a                	mv	s4,a0
    8000065c:	892e                	mv	s2,a1
    8000065e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000660:	0632                	slli	a2,a2,0xc
    80000662:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    80000666:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000668:	6b05                	lui	s6,0x1
    8000066a:	0935f763          	bgeu	a1,s3,800006f8 <uvmunmap+0xb8>
    8000066e:	fc26                	sd	s1,56(sp)
    80000670:	a8a1                	j	800006c8 <uvmunmap+0x88>
    80000672:	fc26                	sd	s1,56(sp)
    80000674:	f84a                	sd	s2,48(sp)
    80000676:	f44e                	sd	s3,40(sp)
    80000678:	f052                	sd	s4,32(sp)
    8000067a:	ec56                	sd	s5,24(sp)
    8000067c:	e85a                	sd	s6,16(sp)
    8000067e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000680:	00007517          	auipc	a0,0x7
    80000684:	a4050513          	addi	a0,a0,-1472 # 800070c0 <etext+0xc0>
    80000688:	75b040ef          	jal	800055e2 <panic>
      panic("uvmunmap: walk");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a4c50513          	addi	a0,a0,-1460 # 800070d8 <etext+0xd8>
    80000694:	74f040ef          	jal	800055e2 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    80000698:	85ca                	mv	a1,s2
    8000069a:	00007517          	auipc	a0,0x7
    8000069e:	a4e50513          	addi	a0,a0,-1458 # 800070e8 <etext+0xe8>
    800006a2:	46f040ef          	jal	80005310 <printf>
      panic("uvmunmap: not mapped");
    800006a6:	00007517          	auipc	a0,0x7
    800006aa:	a5250513          	addi	a0,a0,-1454 # 800070f8 <etext+0xf8>
    800006ae:	735040ef          	jal	800055e2 <panic>
      panic("uvmunmap: not a leaf");
    800006b2:	00007517          	auipc	a0,0x7
    800006b6:	a5e50513          	addi	a0,a0,-1442 # 80007110 <etext+0x110>
    800006ba:	729040ef          	jal	800055e2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006be:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006c2:	995a                	add	s2,s2,s6
    800006c4:	03397963          	bgeu	s2,s3,800006f6 <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006c8:	4601                	li	a2,0
    800006ca:	85ca                	mv	a1,s2
    800006cc:	8552                	mv	a0,s4
    800006ce:	cf5ff0ef          	jal	800003c2 <walk>
    800006d2:	84aa                	mv	s1,a0
    800006d4:	dd45                	beqz	a0,8000068c <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    800006d6:	6110                	ld	a2,0(a0)
    800006d8:	00167793          	andi	a5,a2,1
    800006dc:	dfd5                	beqz	a5,80000698 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006de:	3ff67793          	andi	a5,a2,1023
    800006e2:	fd7788e3          	beq	a5,s7,800006b2 <uvmunmap+0x72>
    if(do_free){
    800006e6:	fc0a8ce3          	beqz	s5,800006be <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    800006ea:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    800006ec:	00c61513          	slli	a0,a2,0xc
    800006f0:	92dff0ef          	jal	8000001c <kfree>
    800006f4:	b7e9                	j	800006be <uvmunmap+0x7e>
    800006f6:	74e2                	ld	s1,56(sp)
    800006f8:	7942                	ld	s2,48(sp)
    800006fa:	79a2                	ld	s3,40(sp)
    800006fc:	7a02                	ld	s4,32(sp)
    800006fe:	6ae2                	ld	s5,24(sp)
    80000700:	6b42                	ld	s6,16(sp)
    80000702:	6ba2                	ld	s7,8(sp)
  }
}
    80000704:	60a6                	ld	ra,72(sp)
    80000706:	6406                	ld	s0,64(sp)
    80000708:	6161                	addi	sp,sp,80
    8000070a:	8082                	ret

000000008000070c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000070c:	1101                	addi	sp,sp,-32
    8000070e:	ec06                	sd	ra,24(sp)
    80000710:	e822                	sd	s0,16(sp)
    80000712:	e426                	sd	s1,8(sp)
    80000714:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000716:	9e9ff0ef          	jal	800000fe <kalloc>
    8000071a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000071c:	c509                	beqz	a0,80000726 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000071e:	6605                	lui	a2,0x1
    80000720:	4581                	li	a1,0
    80000722:	a2dff0ef          	jal	8000014e <memset>
  return pagetable;
}
    80000726:	8526                	mv	a0,s1
    80000728:	60e2                	ld	ra,24(sp)
    8000072a:	6442                	ld	s0,16(sp)
    8000072c:	64a2                	ld	s1,8(sp)
    8000072e:	6105                	addi	sp,sp,32
    80000730:	8082                	ret

0000000080000732 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000732:	7179                	addi	sp,sp,-48
    80000734:	f406                	sd	ra,40(sp)
    80000736:	f022                	sd	s0,32(sp)
    80000738:	ec26                	sd	s1,24(sp)
    8000073a:	e84a                	sd	s2,16(sp)
    8000073c:	e44e                	sd	s3,8(sp)
    8000073e:	e052                	sd	s4,0(sp)
    80000740:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000742:	6785                	lui	a5,0x1
    80000744:	04f67063          	bgeu	a2,a5,80000784 <uvmfirst+0x52>
    80000748:	8a2a                	mv	s4,a0
    8000074a:	89ae                	mv	s3,a1
    8000074c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000074e:	9b1ff0ef          	jal	800000fe <kalloc>
    80000752:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000754:	6605                	lui	a2,0x1
    80000756:	4581                	li	a1,0
    80000758:	9f7ff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000075c:	4779                	li	a4,30
    8000075e:	86ca                	mv	a3,s2
    80000760:	6605                	lui	a2,0x1
    80000762:	4581                	li	a1,0
    80000764:	8552                	mv	a0,s4
    80000766:	d35ff0ef          	jal	8000049a <mappages>
  memmove(mem, src, sz);
    8000076a:	8626                	mv	a2,s1
    8000076c:	85ce                	mv	a1,s3
    8000076e:	854a                	mv	a0,s2
    80000770:	a3bff0ef          	jal	800001aa <memmove>
}
    80000774:	70a2                	ld	ra,40(sp)
    80000776:	7402                	ld	s0,32(sp)
    80000778:	64e2                	ld	s1,24(sp)
    8000077a:	6942                	ld	s2,16(sp)
    8000077c:	69a2                	ld	s3,8(sp)
    8000077e:	6a02                	ld	s4,0(sp)
    80000780:	6145                	addi	sp,sp,48
    80000782:	8082                	ret
    panic("uvmfirst: more than a page");
    80000784:	00007517          	auipc	a0,0x7
    80000788:	9a450513          	addi	a0,a0,-1628 # 80007128 <etext+0x128>
    8000078c:	657040ef          	jal	800055e2 <panic>

0000000080000790 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000790:	1101                	addi	sp,sp,-32
    80000792:	ec06                	sd	ra,24(sp)
    80000794:	e822                	sd	s0,16(sp)
    80000796:	e426                	sd	s1,8(sp)
    80000798:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000079a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000079c:	00b67d63          	bgeu	a2,a1,800007b6 <uvmdealloc+0x26>
    800007a0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007a2:	6785                	lui	a5,0x1
    800007a4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007a6:	00f60733          	add	a4,a2,a5
    800007aa:	76fd                	lui	a3,0xfffff
    800007ac:	8f75                	and	a4,a4,a3
    800007ae:	97ae                	add	a5,a5,a1
    800007b0:	8ff5                	and	a5,a5,a3
    800007b2:	00f76863          	bltu	a4,a5,800007c2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007b6:	8526                	mv	a0,s1
    800007b8:	60e2                	ld	ra,24(sp)
    800007ba:	6442                	ld	s0,16(sp)
    800007bc:	64a2                	ld	s1,8(sp)
    800007be:	6105                	addi	sp,sp,32
    800007c0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007c2:	8f99                	sub	a5,a5,a4
    800007c4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007c6:	4685                	li	a3,1
    800007c8:	0007861b          	sext.w	a2,a5
    800007cc:	85ba                	mv	a1,a4
    800007ce:	e73ff0ef          	jal	80000640 <uvmunmap>
    800007d2:	b7d5                	j	800007b6 <uvmdealloc+0x26>

00000000800007d4 <uvmalloc>:
  if(newsz < oldsz)
    800007d4:	08b66f63          	bltu	a2,a1,80000872 <uvmalloc+0x9e>
{
    800007d8:	7139                	addi	sp,sp,-64
    800007da:	fc06                	sd	ra,56(sp)
    800007dc:	f822                	sd	s0,48(sp)
    800007de:	ec4e                	sd	s3,24(sp)
    800007e0:	e852                	sd	s4,16(sp)
    800007e2:	e456                	sd	s5,8(sp)
    800007e4:	0080                	addi	s0,sp,64
    800007e6:	8aaa                	mv	s5,a0
    800007e8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007ea:	6785                	lui	a5,0x1
    800007ec:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007ee:	95be                	add	a1,a1,a5
    800007f0:	77fd                	lui	a5,0xfffff
    800007f2:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    800007f6:	08c9f063          	bgeu	s3,a2,80000876 <uvmalloc+0xa2>
    800007fa:	f426                	sd	s1,40(sp)
    800007fc:	f04a                	sd	s2,32(sp)
    800007fe:	e05a                	sd	s6,0(sp)
    80000800:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000802:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000806:	8f9ff0ef          	jal	800000fe <kalloc>
    8000080a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000080c:	c515                	beqz	a0,80000838 <uvmalloc+0x64>
    memset(mem, 0, sz);
    8000080e:	6605                	lui	a2,0x1
    80000810:	4581                	li	a1,0
    80000812:	93dff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000816:	875a                	mv	a4,s6
    80000818:	86a6                	mv	a3,s1
    8000081a:	6605                	lui	a2,0x1
    8000081c:	85ca                	mv	a1,s2
    8000081e:	8556                	mv	a0,s5
    80000820:	c7bff0ef          	jal	8000049a <mappages>
    80000824:	e915                	bnez	a0,80000858 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += sz){
    80000826:	6785                	lui	a5,0x1
    80000828:	993e                	add	s2,s2,a5
    8000082a:	fd496ee3          	bltu	s2,s4,80000806 <uvmalloc+0x32>
  return newsz;
    8000082e:	8552                	mv	a0,s4
    80000830:	74a2                	ld	s1,40(sp)
    80000832:	7902                	ld	s2,32(sp)
    80000834:	6b02                	ld	s6,0(sp)
    80000836:	a811                	j	8000084a <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80000838:	864e                	mv	a2,s3
    8000083a:	85ca                	mv	a1,s2
    8000083c:	8556                	mv	a0,s5
    8000083e:	f53ff0ef          	jal	80000790 <uvmdealloc>
      return 0;
    80000842:	4501                	li	a0,0
    80000844:	74a2                	ld	s1,40(sp)
    80000846:	7902                	ld	s2,32(sp)
    80000848:	6b02                	ld	s6,0(sp)
}
    8000084a:	70e2                	ld	ra,56(sp)
    8000084c:	7442                	ld	s0,48(sp)
    8000084e:	69e2                	ld	s3,24(sp)
    80000850:	6a42                	ld	s4,16(sp)
    80000852:	6aa2                	ld	s5,8(sp)
    80000854:	6121                	addi	sp,sp,64
    80000856:	8082                	ret
      kfree(mem);
    80000858:	8526                	mv	a0,s1
    8000085a:	fc2ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000085e:	864e                	mv	a2,s3
    80000860:	85ca                	mv	a1,s2
    80000862:	8556                	mv	a0,s5
    80000864:	f2dff0ef          	jal	80000790 <uvmdealloc>
      return 0;
    80000868:	4501                	li	a0,0
    8000086a:	74a2                	ld	s1,40(sp)
    8000086c:	7902                	ld	s2,32(sp)
    8000086e:	6b02                	ld	s6,0(sp)
    80000870:	bfe9                	j	8000084a <uvmalloc+0x76>
    return oldsz;
    80000872:	852e                	mv	a0,a1
}
    80000874:	8082                	ret
  return newsz;
    80000876:	8532                	mv	a0,a2
    80000878:	bfc9                	j	8000084a <uvmalloc+0x76>

000000008000087a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000087a:	7179                	addi	sp,sp,-48
    8000087c:	f406                	sd	ra,40(sp)
    8000087e:	f022                	sd	s0,32(sp)
    80000880:	ec26                	sd	s1,24(sp)
    80000882:	e84a                	sd	s2,16(sp)
    80000884:	e44e                	sd	s3,8(sp)
    80000886:	e052                	sd	s4,0(sp)
    80000888:	1800                	addi	s0,sp,48
    8000088a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000088c:	84aa                	mv	s1,a0
    8000088e:	6905                	lui	s2,0x1
    80000890:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000892:	4985                	li	s3,1
    80000894:	a819                	j	800008aa <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000896:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000898:	00c79513          	slli	a0,a5,0xc
    8000089c:	fdfff0ef          	jal	8000087a <freewalk>
      pagetable[i] = 0;
    800008a0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008a4:	04a1                	addi	s1,s1,8
    800008a6:	01248f63          	beq	s1,s2,800008c4 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008aa:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008ac:	00f7f713          	andi	a4,a5,15
    800008b0:	ff3703e3          	beq	a4,s3,80000896 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008b4:	8b85                	andi	a5,a5,1
    800008b6:	d7fd                	beqz	a5,800008a4 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008b8:	00007517          	auipc	a0,0x7
    800008bc:	89050513          	addi	a0,a0,-1904 # 80007148 <etext+0x148>
    800008c0:	523040ef          	jal	800055e2 <panic>
    }
  }
  kfree((void*)pagetable);
    800008c4:	8552                	mv	a0,s4
    800008c6:	f56ff0ef          	jal	8000001c <kfree>
}
    800008ca:	70a2                	ld	ra,40(sp)
    800008cc:	7402                	ld	s0,32(sp)
    800008ce:	64e2                	ld	s1,24(sp)
    800008d0:	6942                	ld	s2,16(sp)
    800008d2:	69a2                	ld	s3,8(sp)
    800008d4:	6a02                	ld	s4,0(sp)
    800008d6:	6145                	addi	sp,sp,48
    800008d8:	8082                	ret

00000000800008da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008da:	1101                	addi	sp,sp,-32
    800008dc:	ec06                	sd	ra,24(sp)
    800008de:	e822                	sd	s0,16(sp)
    800008e0:	e426                	sd	s1,8(sp)
    800008e2:	1000                	addi	s0,sp,32
    800008e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800008e6:	e989                	bnez	a1,800008f8 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008e8:	8526                	mv	a0,s1
    800008ea:	f91ff0ef          	jal	8000087a <freewalk>
}
    800008ee:	60e2                	ld	ra,24(sp)
    800008f0:	6442                	ld	s0,16(sp)
    800008f2:	64a2                	ld	s1,8(sp)
    800008f4:	6105                	addi	sp,sp,32
    800008f6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008f8:	6785                	lui	a5,0x1
    800008fa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fc:	95be                	add	a1,a1,a5
    800008fe:	4685                	li	a3,1
    80000900:	00c5d613          	srli	a2,a1,0xc
    80000904:	4581                	li	a1,0
    80000906:	d3bff0ef          	jal	80000640 <uvmunmap>
    8000090a:	bff9                	j	800008e8 <uvmfree+0xe>

000000008000090c <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    8000090c:	c65d                	beqz	a2,800009ba <uvmcopy+0xae>
{
    8000090e:	715d                	addi	sp,sp,-80
    80000910:	e486                	sd	ra,72(sp)
    80000912:	e0a2                	sd	s0,64(sp)
    80000914:	fc26                	sd	s1,56(sp)
    80000916:	f84a                	sd	s2,48(sp)
    80000918:	f44e                	sd	s3,40(sp)
    8000091a:	f052                	sd	s4,32(sp)
    8000091c:	ec56                	sd	s5,24(sp)
    8000091e:	e85a                	sd	s6,16(sp)
    80000920:	e45e                	sd	s7,8(sp)
    80000922:	0880                	addi	s0,sp,80
    80000924:	8b2a                	mv	s6,a0
    80000926:	8aae                	mv	s5,a1
    80000928:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    8000092a:	4981                	li	s3,0
    szinc = PGSIZE;
    szinc = PGSIZE;
    if((pte = walk(old, i, 0)) == 0)
    8000092c:	4601                	li	a2,0
    8000092e:	85ce                	mv	a1,s3
    80000930:	855a                	mv	a0,s6
    80000932:	a91ff0ef          	jal	800003c2 <walk>
    80000936:	c121                	beqz	a0,80000976 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000938:	6118                	ld	a4,0(a0)
    8000093a:	00177793          	andi	a5,a4,1
    8000093e:	c3b1                	beqz	a5,80000982 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000940:	00a75593          	srli	a1,a4,0xa
    80000944:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000948:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000094c:	fb2ff0ef          	jal	800000fe <kalloc>
    80000950:	892a                	mv	s2,a0
    80000952:	c129                	beqz	a0,80000994 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000954:	6605                	lui	a2,0x1
    80000956:	85de                	mv	a1,s7
    80000958:	853ff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000095c:	8726                	mv	a4,s1
    8000095e:	86ca                	mv	a3,s2
    80000960:	6605                	lui	a2,0x1
    80000962:	85ce                	mv	a1,s3
    80000964:	8556                	mv	a0,s5
    80000966:	b35ff0ef          	jal	8000049a <mappages>
    8000096a:	e115                	bnez	a0,8000098e <uvmcopy+0x82>
  for(i = 0; i < sz; i += szinc){
    8000096c:	6785                	lui	a5,0x1
    8000096e:	99be                	add	s3,s3,a5
    80000970:	fb49eee3          	bltu	s3,s4,8000092c <uvmcopy+0x20>
    80000974:	a805                	j	800009a4 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000976:	00006517          	auipc	a0,0x6
    8000097a:	7e250513          	addi	a0,a0,2018 # 80007158 <etext+0x158>
    8000097e:	465040ef          	jal	800055e2 <panic>
      panic("uvmcopy: page not present");
    80000982:	00006517          	auipc	a0,0x6
    80000986:	7f650513          	addi	a0,a0,2038 # 80007178 <etext+0x178>
    8000098a:	459040ef          	jal	800055e2 <panic>
      kfree(mem);
    8000098e:	854a                	mv	a0,s2
    80000990:	e8cff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000994:	4685                	li	a3,1
    80000996:	00c9d613          	srli	a2,s3,0xc
    8000099a:	4581                	li	a1,0
    8000099c:	8556                	mv	a0,s5
    8000099e:	ca3ff0ef          	jal	80000640 <uvmunmap>
  return -1;
    800009a2:	557d                	li	a0,-1
}
    800009a4:	60a6                	ld	ra,72(sp)
    800009a6:	6406                	ld	s0,64(sp)
    800009a8:	74e2                	ld	s1,56(sp)
    800009aa:	7942                	ld	s2,48(sp)
    800009ac:	79a2                	ld	s3,40(sp)
    800009ae:	7a02                	ld	s4,32(sp)
    800009b0:	6ae2                	ld	s5,24(sp)
    800009b2:	6b42                	ld	s6,16(sp)
    800009b4:	6ba2                	ld	s7,8(sp)
    800009b6:	6161                	addi	sp,sp,80
    800009b8:	8082                	ret
  return 0;
    800009ba:	4501                	li	a0,0
}
    800009bc:	8082                	ret

00000000800009be <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009be:	1141                	addi	sp,sp,-16
    800009c0:	e406                	sd	ra,8(sp)
    800009c2:	e022                	sd	s0,0(sp)
    800009c4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009c6:	4601                	li	a2,0
    800009c8:	9fbff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    800009cc:	c901                	beqz	a0,800009dc <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ce:	611c                	ld	a5,0(a0)
    800009d0:	9bbd                	andi	a5,a5,-17
    800009d2:	e11c                	sd	a5,0(a0)
}
    800009d4:	60a2                	ld	ra,8(sp)
    800009d6:	6402                	ld	s0,0(sp)
    800009d8:	0141                	addi	sp,sp,16
    800009da:	8082                	ret
    panic("uvmclear");
    800009dc:	00006517          	auipc	a0,0x6
    800009e0:	7bc50513          	addi	a0,a0,1980 # 80007198 <etext+0x198>
    800009e4:	3ff040ef          	jal	800055e2 <panic>

00000000800009e8 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009e8:	cac1                	beqz	a3,80000a78 <copyout+0x90>
{
    800009ea:	711d                	addi	sp,sp,-96
    800009ec:	ec86                	sd	ra,88(sp)
    800009ee:	e8a2                	sd	s0,80(sp)
    800009f0:	e4a6                	sd	s1,72(sp)
    800009f2:	fc4e                	sd	s3,56(sp)
    800009f4:	f852                	sd	s4,48(sp)
    800009f6:	f456                	sd	s5,40(sp)
    800009f8:	f05a                	sd	s6,32(sp)
    800009fa:	1080                	addi	s0,sp,96
    800009fc:	8b2a                	mv	s6,a0
    800009fe:	8a2e                	mv	s4,a1
    80000a00:	8ab2                	mv	s5,a2
    80000a02:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a04:	74fd                	lui	s1,0xfffff
    80000a06:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000a08:	57fd                	li	a5,-1
    80000a0a:	83e9                	srli	a5,a5,0x1a
    80000a0c:	0697e863          	bltu	a5,s1,80000a7c <copyout+0x94>
    80000a10:	e0ca                	sd	s2,64(sp)
    80000a12:	ec5e                	sd	s7,24(sp)
    80000a14:	e862                	sd	s8,16(sp)
    80000a16:	e466                	sd	s9,8(sp)
    80000a18:	6c05                	lui	s8,0x1
    80000a1a:	8bbe                	mv	s7,a5
    80000a1c:	a015                	j	80000a40 <copyout+0x58>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a1e:	409a04b3          	sub	s1,s4,s1
    80000a22:	0009061b          	sext.w	a2,s2
    80000a26:	85d6                	mv	a1,s5
    80000a28:	9526                	add	a0,a0,s1
    80000a2a:	f80ff0ef          	jal	800001aa <memmove>

    len -= n;
    80000a2e:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a32:	9aca                	add	s5,s5,s2
  while(len > 0){
    80000a34:	02098c63          	beqz	s3,80000a6c <copyout+0x84>
    if (va0 >= MAXVA)
    80000a38:	059be463          	bltu	s7,s9,80000a80 <copyout+0x98>
    80000a3c:	84e6                	mv	s1,s9
    80000a3e:	8a66                	mv	s4,s9
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a40:	4601                	li	a2,0
    80000a42:	85a6                	mv	a1,s1
    80000a44:	855a                	mv	a0,s6
    80000a46:	97dff0ef          	jal	800003c2 <walk>
    80000a4a:	c129                	beqz	a0,80000a8c <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a4c:	611c                	ld	a5,0(a0)
    80000a4e:	8b91                	andi	a5,a5,4
    80000a50:	cfa1                	beqz	a5,80000aa8 <copyout+0xc0>
    pa0 = walkaddr(pagetable, va0);
    80000a52:	85a6                	mv	a1,s1
    80000a54:	855a                	mv	a0,s6
    80000a56:	a07ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    80000a5a:	cd29                	beqz	a0,80000ab4 <copyout+0xcc>
    n = PGSIZE - (dstva - va0);
    80000a5c:	01848cb3          	add	s9,s1,s8
    80000a60:	414c8933          	sub	s2,s9,s4
    if(n > len)
    80000a64:	fb29fde3          	bgeu	s3,s2,80000a1e <copyout+0x36>
    80000a68:	894e                	mv	s2,s3
    80000a6a:	bf55                	j	80000a1e <copyout+0x36>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a6c:	4501                	li	a0,0
    80000a6e:	6906                	ld	s2,64(sp)
    80000a70:	6be2                	ld	s7,24(sp)
    80000a72:	6c42                	ld	s8,16(sp)
    80000a74:	6ca2                	ld	s9,8(sp)
    80000a76:	a005                	j	80000a96 <copyout+0xae>
    80000a78:	4501                	li	a0,0
}
    80000a7a:	8082                	ret
      return -1;
    80000a7c:	557d                	li	a0,-1
    80000a7e:	a821                	j	80000a96 <copyout+0xae>
    80000a80:	557d                	li	a0,-1
    80000a82:	6906                	ld	s2,64(sp)
    80000a84:	6be2                	ld	s7,24(sp)
    80000a86:	6c42                	ld	s8,16(sp)
    80000a88:	6ca2                	ld	s9,8(sp)
    80000a8a:	a031                	j	80000a96 <copyout+0xae>
      return -1;
    80000a8c:	557d                	li	a0,-1
    80000a8e:	6906                	ld	s2,64(sp)
    80000a90:	6be2                	ld	s7,24(sp)
    80000a92:	6c42                	ld	s8,16(sp)
    80000a94:	6ca2                	ld	s9,8(sp)
}
    80000a96:	60e6                	ld	ra,88(sp)
    80000a98:	6446                	ld	s0,80(sp)
    80000a9a:	64a6                	ld	s1,72(sp)
    80000a9c:	79e2                	ld	s3,56(sp)
    80000a9e:	7a42                	ld	s4,48(sp)
    80000aa0:	7aa2                	ld	s5,40(sp)
    80000aa2:	7b02                	ld	s6,32(sp)
    80000aa4:	6125                	addi	sp,sp,96
    80000aa6:	8082                	ret
      return -1;
    80000aa8:	557d                	li	a0,-1
    80000aaa:	6906                	ld	s2,64(sp)
    80000aac:	6be2                	ld	s7,24(sp)
    80000aae:	6c42                	ld	s8,16(sp)
    80000ab0:	6ca2                	ld	s9,8(sp)
    80000ab2:	b7d5                	j	80000a96 <copyout+0xae>
      return -1;
    80000ab4:	557d                	li	a0,-1
    80000ab6:	6906                	ld	s2,64(sp)
    80000ab8:	6be2                	ld	s7,24(sp)
    80000aba:	6c42                	ld	s8,16(sp)
    80000abc:	6ca2                	ld	s9,8(sp)
    80000abe:	bfe1                	j	80000a96 <copyout+0xae>

0000000080000ac0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000ac0:	c6a5                	beqz	a3,80000b28 <copyin+0x68>
{
    80000ac2:	715d                	addi	sp,sp,-80
    80000ac4:	e486                	sd	ra,72(sp)
    80000ac6:	e0a2                	sd	s0,64(sp)
    80000ac8:	fc26                	sd	s1,56(sp)
    80000aca:	f84a                	sd	s2,48(sp)
    80000acc:	f44e                	sd	s3,40(sp)
    80000ace:	f052                	sd	s4,32(sp)
    80000ad0:	ec56                	sd	s5,24(sp)
    80000ad2:	e85a                	sd	s6,16(sp)
    80000ad4:	e45e                	sd	s7,8(sp)
    80000ad6:	e062                	sd	s8,0(sp)
    80000ad8:	0880                	addi	s0,sp,80
    80000ada:	8b2a                	mv	s6,a0
    80000adc:	8a2e                	mv	s4,a1
    80000ade:	8c32                	mv	s8,a2
    80000ae0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ae2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ae4:	6a85                	lui	s5,0x1
    80000ae6:	a00d                	j	80000b08 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ae8:	018505b3          	add	a1,a0,s8
    80000aec:	0004861b          	sext.w	a2,s1
    80000af0:	412585b3          	sub	a1,a1,s2
    80000af4:	8552                	mv	a0,s4
    80000af6:	eb4ff0ef          	jal	800001aa <memmove>

    len -= n;
    80000afa:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000afe:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b00:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b04:	02098063          	beqz	s3,80000b24 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b08:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b0c:	85ca                	mv	a1,s2
    80000b0e:	855a                	mv	a0,s6
    80000b10:	94dff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    80000b14:	cd01                	beqz	a0,80000b2c <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b16:	418904b3          	sub	s1,s2,s8
    80000b1a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b1c:	fc99f6e3          	bgeu	s3,s1,80000ae8 <copyin+0x28>
    80000b20:	84ce                	mv	s1,s3
    80000b22:	b7d9                	j	80000ae8 <copyin+0x28>
  }
  return 0;
    80000b24:	4501                	li	a0,0
    80000b26:	a021                	j	80000b2e <copyin+0x6e>
    80000b28:	4501                	li	a0,0
}
    80000b2a:	8082                	ret
      return -1;
    80000b2c:	557d                	li	a0,-1
}
    80000b2e:	60a6                	ld	ra,72(sp)
    80000b30:	6406                	ld	s0,64(sp)
    80000b32:	74e2                	ld	s1,56(sp)
    80000b34:	7942                	ld	s2,48(sp)
    80000b36:	79a2                	ld	s3,40(sp)
    80000b38:	7a02                	ld	s4,32(sp)
    80000b3a:	6ae2                	ld	s5,24(sp)
    80000b3c:	6b42                	ld	s6,16(sp)
    80000b3e:	6ba2                	ld	s7,8(sp)
    80000b40:	6c02                	ld	s8,0(sp)
    80000b42:	6161                	addi	sp,sp,80
    80000b44:	8082                	ret

0000000080000b46 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b46:	c6dd                	beqz	a3,80000bf4 <copyinstr+0xae>
{
    80000b48:	715d                	addi	sp,sp,-80
    80000b4a:	e486                	sd	ra,72(sp)
    80000b4c:	e0a2                	sd	s0,64(sp)
    80000b4e:	fc26                	sd	s1,56(sp)
    80000b50:	f84a                	sd	s2,48(sp)
    80000b52:	f44e                	sd	s3,40(sp)
    80000b54:	f052                	sd	s4,32(sp)
    80000b56:	ec56                	sd	s5,24(sp)
    80000b58:	e85a                	sd	s6,16(sp)
    80000b5a:	e45e                	sd	s7,8(sp)
    80000b5c:	0880                	addi	s0,sp,80
    80000b5e:	8a2a                	mv	s4,a0
    80000b60:	8b2e                	mv	s6,a1
    80000b62:	8bb2                	mv	s7,a2
    80000b64:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b66:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b68:	6985                	lui	s3,0x1
    80000b6a:	a825                	j	80000ba2 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b6c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b70:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b72:	37fd                	addiw	a5,a5,-1
    80000b74:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b78:	60a6                	ld	ra,72(sp)
    80000b7a:	6406                	ld	s0,64(sp)
    80000b7c:	74e2                	ld	s1,56(sp)
    80000b7e:	7942                	ld	s2,48(sp)
    80000b80:	79a2                	ld	s3,40(sp)
    80000b82:	7a02                	ld	s4,32(sp)
    80000b84:	6ae2                	ld	s5,24(sp)
    80000b86:	6b42                	ld	s6,16(sp)
    80000b88:	6ba2                	ld	s7,8(sp)
    80000b8a:	6161                	addi	sp,sp,80
    80000b8c:	8082                	ret
    80000b8e:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000b92:	9742                	add	a4,a4,a6
      --max;
    80000b94:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000b98:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000b9c:	04e58463          	beq	a1,a4,80000be4 <copyinstr+0x9e>
{
    80000ba0:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000ba2:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000ba6:	85a6                	mv	a1,s1
    80000ba8:	8552                	mv	a0,s4
    80000baa:	8b3ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    80000bae:	cd0d                	beqz	a0,80000be8 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000bb0:	417486b3          	sub	a3,s1,s7
    80000bb4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000bb6:	00d97363          	bgeu	s2,a3,80000bbc <copyinstr+0x76>
    80000bba:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000bbc:	955e                	add	a0,a0,s7
    80000bbe:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000bc0:	c695                	beqz	a3,80000bec <copyinstr+0xa6>
    80000bc2:	87da                	mv	a5,s6
    80000bc4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000bc6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bca:	96da                	add	a3,a3,s6
    80000bcc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bce:	00f60733          	add	a4,a2,a5
    80000bd2:	00074703          	lbu	a4,0(a4)
    80000bd6:	db59                	beqz	a4,80000b6c <copyinstr+0x26>
        *dst = *p;
    80000bd8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bdc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bde:	fed797e3          	bne	a5,a3,80000bcc <copyinstr+0x86>
    80000be2:	b775                	j	80000b8e <copyinstr+0x48>
    80000be4:	4781                	li	a5,0
    80000be6:	b771                	j	80000b72 <copyinstr+0x2c>
      return -1;
    80000be8:	557d                	li	a0,-1
    80000bea:	b779                	j	80000b78 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000bec:	6b85                	lui	s7,0x1
    80000bee:	9ba6                	add	s7,s7,s1
    80000bf0:	87da                	mv	a5,s6
    80000bf2:	b77d                	j	80000ba0 <copyinstr+0x5a>
  int got_null = 0;
    80000bf4:	4781                	li	a5,0
  if(got_null){
    80000bf6:	37fd                	addiw	a5,a5,-1
    80000bf8:	0007851b          	sext.w	a0,a5
}
    80000bfc:	8082                	ret

0000000080000bfe <vmprint_level>:


// Thêm hàm này
void vmprint_level(pagetable_t pagetable, int level)
{
    80000bfe:	7159                	addi	sp,sp,-112
    80000c00:	f486                	sd	ra,104(sp)
    80000c02:	f0a2                	sd	s0,96(sp)
    80000c04:	eca6                	sd	s1,88(sp)
    80000c06:	e8ca                	sd	s2,80(sp)
    80000c08:	e4ce                	sd	s3,72(sp)
    80000c0a:	e0d2                	sd	s4,64(sp)
    80000c0c:	fc56                	sd	s5,56(sp)
    80000c0e:	f85a                	sd	s6,48(sp)
    80000c10:	f45e                	sd	s7,40(sp)
    80000c12:	f062                	sd	s8,32(sp)
    80000c14:	ec66                	sd	s9,24(sp)
    80000c16:	e86a                	sd	s10,16(sp)
    80000c18:	e46e                	sd	s11,8(sp)
    80000c1a:	1880                	addi	s0,sp,112
    80000c1c:	892e                	mv	s2,a1
  for (int i = 0; i < 512; i++)
    80000c1e:	8a2a                	mv	s4,a0
    80000c20:	4981                	li	s3,0
          {
            printf("  ");
          }
        }
        uint64 pa = PTE2PA(pte);
        printf("%d: pte %ld pa %ld\n", i, pte, pa);
    80000c22:	00006c97          	auipc	s9,0x6
    80000c26:	596c8c93          	addi	s9,s9,1430 # 800071b8 <etext+0x1b8>
        for (int j = 0; j <= level; j++)
    80000c2a:	4d81                	li	s11,0
          printf("..");
    80000c2c:	00006b17          	auipc	s6,0x6
    80000c30:	57cb0b13          	addi	s6,s6,1404 # 800071a8 <etext+0x1a8>
            printf("  ");
    80000c34:	00006b97          	auipc	s7,0x6
    80000c38:	57cb8b93          	addi	s7,s7,1404 # 800071b0 <etext+0x1b0>

        if (level < 2 && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000c3c:	4d05                	li	s10,1
  for (int i = 0; i < 512; i++)
    80000c3e:	20000c13          	li	s8,512
    80000c42:	a825                	j	80000c7a <vmprint_level+0x7c>
        for (int j = 0; j <= level; j++)
    80000c44:	2485                	addiw	s1,s1,1 # fffffffffffff001 <end+0xffffffff7ffdb9b1>
    80000c46:	00994b63          	blt	s2,s1,80000c5c <vmprint_level+0x5e>
          printf("..");
    80000c4a:	855a                	mv	a0,s6
    80000c4c:	6c4040ef          	jal	80005310 <printf>
          if (j < level)
    80000c50:	ff24dae3          	bge	s1,s2,80000c44 <vmprint_level+0x46>
            printf("  ");
    80000c54:	855e                	mv	a0,s7
    80000c56:	6ba040ef          	jal	80005310 <printf>
    80000c5a:	b7ed                	j	80000c44 <vmprint_level+0x46>
        uint64 pa = PTE2PA(pte);
    80000c5c:	00aad493          	srli	s1,s5,0xa
    80000c60:	04b2                	slli	s1,s1,0xc
        printf("%d: pte %ld pa %ld\n", i, pte, pa);
    80000c62:	86a6                	mv	a3,s1
    80000c64:	8656                	mv	a2,s5
    80000c66:	85ce                	mv	a1,s3
    80000c68:	8566                	mv	a0,s9
    80000c6a:	6a6040ef          	jal	80005310 <printf>
        if (level < 2 && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000c6e:	032d5863          	bge	s10,s2,80000c9e <vmprint_level+0xa0>
  for (int i = 0; i < 512; i++)
    80000c72:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000c74:	0a21                	addi	s4,s4,8
    80000c76:	03898e63          	beq	s3,s8,80000cb2 <vmprint_level+0xb4>
    pte_t pte = pagetable[i];
    80000c7a:	000a3a83          	ld	s5,0(s4)
    if (pte & PTE_V)
    80000c7e:	001af793          	andi	a5,s5,1
    80000c82:	dbe5                	beqz	a5,80000c72 <vmprint_level+0x74>
        for (int j = 0; j <= level; j++)
    80000c84:	00094463          	bltz	s2,80000c8c <vmprint_level+0x8e>
    80000c88:	84ee                	mv	s1,s11
    80000c8a:	b7c1                	j	80000c4a <vmprint_level+0x4c>
        uint64 pa = PTE2PA(pte);
    80000c8c:	00aad493          	srli	s1,s5,0xa
    80000c90:	04b2                	slli	s1,s1,0xc
        printf("%d: pte %ld pa %ld\n", i, pte, pa);
    80000c92:	86a6                	mv	a3,s1
    80000c94:	8656                	mv	a2,s5
    80000c96:	85ce                	mv	a1,s3
    80000c98:	8566                	mv	a0,s9
    80000c9a:	676040ef          	jal	80005310 <printf>
        if (level < 2 && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000c9e:	00eafa93          	andi	s5,s5,14
    80000ca2:	fc0a98e3          	bnez	s5,80000c72 <vmprint_level+0x74>
        {
          pagetable_t child = (pagetable_t)pa;
          vmprint_level(child, level + 1);
    80000ca6:	0019059b          	addiw	a1,s2,1
    80000caa:	8526                	mv	a0,s1
    80000cac:	f53ff0ef          	jal	80000bfe <vmprint_level>
    80000cb0:	b7c9                	j	80000c72 <vmprint_level+0x74>
        }
    }
  }
}
    80000cb2:	70a6                	ld	ra,104(sp)
    80000cb4:	7406                	ld	s0,96(sp)
    80000cb6:	64e6                	ld	s1,88(sp)
    80000cb8:	6946                	ld	s2,80(sp)
    80000cba:	69a6                	ld	s3,72(sp)
    80000cbc:	6a06                	ld	s4,64(sp)
    80000cbe:	7ae2                	ld	s5,56(sp)
    80000cc0:	7b42                	ld	s6,48(sp)
    80000cc2:	7ba2                	ld	s7,40(sp)
    80000cc4:	7c02                	ld	s8,32(sp)
    80000cc6:	6ce2                	ld	s9,24(sp)
    80000cc8:	6d42                	ld	s10,16(sp)
    80000cca:	6da2                	ld	s11,8(sp)
    80000ccc:	6165                	addi	sp,sp,112
    80000cce:	8082                	ret

0000000080000cd0 <vmprint>:


void
vmprint(pagetable_t pagetable) {
    80000cd0:	1101                	addi	sp,sp,-32
    80000cd2:	ec06                	sd	ra,24(sp)
    80000cd4:	e822                	sd	s0,16(sp)
    80000cd6:	e426                	sd	s1,8(sp)
    80000cd8:	1000                	addi	s0,sp,32
    80000cda:	84aa                	mv	s1,a0
  // your code here
  printf("page table %p\n", pagetable);
    80000cdc:	85aa                	mv	a1,a0
    80000cde:	00006517          	auipc	a0,0x6
    80000ce2:	4f250513          	addi	a0,a0,1266 # 800071d0 <etext+0x1d0>
    80000ce6:	62a040ef          	jal	80005310 <printf>
  vmprint_level(pagetable, 0);
    80000cea:	4581                	li	a1,0
    80000cec:	8526                	mv	a0,s1
    80000cee:	f11ff0ef          	jal	80000bfe <vmprint_level>
}
    80000cf2:	60e2                	ld	ra,24(sp)
    80000cf4:	6442                	ld	s0,16(sp)
    80000cf6:	64a2                	ld	s1,8(sp)
    80000cf8:	6105                	addi	sp,sp,32
    80000cfa:	8082                	ret

0000000080000cfc <pgpte>:



pte_t*
pgpte(pagetable_t pagetable, uint64 va) {
    80000cfc:	1141                	addi	sp,sp,-16
    80000cfe:	e406                	sd	ra,8(sp)
    80000d00:	e022                	sd	s0,0(sp)
    80000d02:	0800                	addi	s0,sp,16
  return walk(pagetable, va, 0);
    80000d04:	4601                	li	a2,0
    80000d06:	ebcff0ef          	jal	800003c2 <walk>
}
    80000d0a:	60a2                	ld	ra,8(sp)
    80000d0c:	6402                	ld	s0,0(sp)
    80000d0e:	0141                	addi	sp,sp,16
    80000d10:	8082                	ret

0000000080000d12 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d12:	7139                	addi	sp,sp,-64
    80000d14:	fc06                	sd	ra,56(sp)
    80000d16:	f822                	sd	s0,48(sp)
    80000d18:	f426                	sd	s1,40(sp)
    80000d1a:	f04a                	sd	s2,32(sp)
    80000d1c:	ec4e                	sd	s3,24(sp)
    80000d1e:	e852                	sd	s4,16(sp)
    80000d20:	e456                	sd	s5,8(sp)
    80000d22:	e05a                	sd	s6,0(sp)
    80000d24:	0080                	addi	s0,sp,64
    80000d26:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d28:	0000a497          	auipc	s1,0xa
    80000d2c:	a4848493          	addi	s1,s1,-1464 # 8000a770 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d30:	8b26                	mv	s6,s1
    80000d32:	04fa5937          	lui	s2,0x4fa5
    80000d36:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d3a:	0932                	slli	s2,s2,0xc
    80000d3c:	fa590913          	addi	s2,s2,-91
    80000d40:	0932                	slli	s2,s2,0xc
    80000d42:	fa590913          	addi	s2,s2,-91
    80000d46:	0932                	slli	s2,s2,0xc
    80000d48:	fa590913          	addi	s2,s2,-91
    80000d4c:	040009b7          	lui	s3,0x4000
    80000d50:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d52:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d54:	0000fa97          	auipc	s5,0xf
    80000d58:	41ca8a93          	addi	s5,s5,1052 # 80010170 <tickslock>
    char *pa = kalloc();
    80000d5c:	ba2ff0ef          	jal	800000fe <kalloc>
    80000d60:	862a                	mv	a2,a0
    if(pa == 0)
    80000d62:	cd15                	beqz	a0,80000d9e <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000d64:	416485b3          	sub	a1,s1,s6
    80000d68:	858d                	srai	a1,a1,0x3
    80000d6a:	032585b3          	mul	a1,a1,s2
    80000d6e:	2585                	addiw	a1,a1,1
    80000d70:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d74:	4719                	li	a4,6
    80000d76:	6685                	lui	a3,0x1
    80000d78:	40b985b3          	sub	a1,s3,a1
    80000d7c:	8552                	mv	a0,s4
    80000d7e:	fccff0ef          	jal	8000054a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d82:	16848493          	addi	s1,s1,360
    80000d86:	fd549be3          	bne	s1,s5,80000d5c <proc_mapstacks+0x4a>
  }
}
    80000d8a:	70e2                	ld	ra,56(sp)
    80000d8c:	7442                	ld	s0,48(sp)
    80000d8e:	74a2                	ld	s1,40(sp)
    80000d90:	7902                	ld	s2,32(sp)
    80000d92:	69e2                	ld	s3,24(sp)
    80000d94:	6a42                	ld	s4,16(sp)
    80000d96:	6aa2                	ld	s5,8(sp)
    80000d98:	6b02                	ld	s6,0(sp)
    80000d9a:	6121                	addi	sp,sp,64
    80000d9c:	8082                	ret
      panic("kalloc");
    80000d9e:	00006517          	auipc	a0,0x6
    80000da2:	44250513          	addi	a0,a0,1090 # 800071e0 <etext+0x1e0>
    80000da6:	03d040ef          	jal	800055e2 <panic>

0000000080000daa <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000daa:	7139                	addi	sp,sp,-64
    80000dac:	fc06                	sd	ra,56(sp)
    80000dae:	f822                	sd	s0,48(sp)
    80000db0:	f426                	sd	s1,40(sp)
    80000db2:	f04a                	sd	s2,32(sp)
    80000db4:	ec4e                	sd	s3,24(sp)
    80000db6:	e852                	sd	s4,16(sp)
    80000db8:	e456                	sd	s5,8(sp)
    80000dba:	e05a                	sd	s6,0(sp)
    80000dbc:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dbe:	00006597          	auipc	a1,0x6
    80000dc2:	42a58593          	addi	a1,a1,1066 # 800071e8 <etext+0x1e8>
    80000dc6:	00009517          	auipc	a0,0x9
    80000dca:	57a50513          	addi	a0,a0,1402 # 8000a340 <pid_lock>
    80000dce:	2c3040ef          	jal	80005890 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dd2:	00006597          	auipc	a1,0x6
    80000dd6:	41e58593          	addi	a1,a1,1054 # 800071f0 <etext+0x1f0>
    80000dda:	00009517          	auipc	a0,0x9
    80000dde:	57e50513          	addi	a0,a0,1406 # 8000a358 <wait_lock>
    80000de2:	2af040ef          	jal	80005890 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de6:	0000a497          	auipc	s1,0xa
    80000dea:	98a48493          	addi	s1,s1,-1654 # 8000a770 <proc>
      initlock(&p->lock, "proc");
    80000dee:	00006b17          	auipc	s6,0x6
    80000df2:	412b0b13          	addi	s6,s6,1042 # 80007200 <etext+0x200>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000df6:	8aa6                	mv	s5,s1
    80000df8:	04fa5937          	lui	s2,0x4fa5
    80000dfc:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000e00:	0932                	slli	s2,s2,0xc
    80000e02:	fa590913          	addi	s2,s2,-91
    80000e06:	0932                	slli	s2,s2,0xc
    80000e08:	fa590913          	addi	s2,s2,-91
    80000e0c:	0932                	slli	s2,s2,0xc
    80000e0e:	fa590913          	addi	s2,s2,-91
    80000e12:	040009b7          	lui	s3,0x4000
    80000e16:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e18:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1a:	0000fa17          	auipc	s4,0xf
    80000e1e:	356a0a13          	addi	s4,s4,854 # 80010170 <tickslock>
      initlock(&p->lock, "proc");
    80000e22:	85da                	mv	a1,s6
    80000e24:	8526                	mv	a0,s1
    80000e26:	26b040ef          	jal	80005890 <initlock>
      p->state = UNUSED;
    80000e2a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e2e:	415487b3          	sub	a5,s1,s5
    80000e32:	878d                	srai	a5,a5,0x3
    80000e34:	032787b3          	mul	a5,a5,s2
    80000e38:	2785                	addiw	a5,a5,1
    80000e3a:	00d7979b          	slliw	a5,a5,0xd
    80000e3e:	40f987b3          	sub	a5,s3,a5
    80000e42:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e44:	16848493          	addi	s1,s1,360
    80000e48:	fd449de3          	bne	s1,s4,80000e22 <procinit+0x78>
  }
}
    80000e4c:	70e2                	ld	ra,56(sp)
    80000e4e:	7442                	ld	s0,48(sp)
    80000e50:	74a2                	ld	s1,40(sp)
    80000e52:	7902                	ld	s2,32(sp)
    80000e54:	69e2                	ld	s3,24(sp)
    80000e56:	6a42                	ld	s4,16(sp)
    80000e58:	6aa2                	ld	s5,8(sp)
    80000e5a:	6b02                	ld	s6,0(sp)
    80000e5c:	6121                	addi	sp,sp,64
    80000e5e:	8082                	ret

0000000080000e60 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e422                	sd	s0,8(sp)
    80000e64:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e66:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e68:	2501                	sext.w	a0,a0
    80000e6a:	6422                	ld	s0,8(sp)
    80000e6c:	0141                	addi	sp,sp,16
    80000e6e:	8082                	ret

0000000080000e70 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e70:	1141                	addi	sp,sp,-16
    80000e72:	e422                	sd	s0,8(sp)
    80000e74:	0800                	addi	s0,sp,16
    80000e76:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e78:	2781                	sext.w	a5,a5
    80000e7a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e7c:	00009517          	auipc	a0,0x9
    80000e80:	4f450513          	addi	a0,a0,1268 # 8000a370 <cpus>
    80000e84:	953e                	add	a0,a0,a5
    80000e86:	6422                	ld	s0,8(sp)
    80000e88:	0141                	addi	sp,sp,16
    80000e8a:	8082                	ret

0000000080000e8c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e8c:	1101                	addi	sp,sp,-32
    80000e8e:	ec06                	sd	ra,24(sp)
    80000e90:	e822                	sd	s0,16(sp)
    80000e92:	e426                	sd	s1,8(sp)
    80000e94:	1000                	addi	s0,sp,32
  push_off();
    80000e96:	23b040ef          	jal	800058d0 <push_off>
    80000e9a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e9c:	2781                	sext.w	a5,a5
    80000e9e:	079e                	slli	a5,a5,0x7
    80000ea0:	00009717          	auipc	a4,0x9
    80000ea4:	4a070713          	addi	a4,a4,1184 # 8000a340 <pid_lock>
    80000ea8:	97ba                	add	a5,a5,a4
    80000eaa:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eac:	2a9040ef          	jal	80005954 <pop_off>
  return p;
}
    80000eb0:	8526                	mv	a0,s1
    80000eb2:	60e2                	ld	ra,24(sp)
    80000eb4:	6442                	ld	s0,16(sp)
    80000eb6:	64a2                	ld	s1,8(sp)
    80000eb8:	6105                	addi	sp,sp,32
    80000eba:	8082                	ret

0000000080000ebc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ebc:	1141                	addi	sp,sp,-16
    80000ebe:	e406                	sd	ra,8(sp)
    80000ec0:	e022                	sd	s0,0(sp)
    80000ec2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ec4:	fc9ff0ef          	jal	80000e8c <myproc>
    80000ec8:	2e1040ef          	jal	800059a8 <release>

  if (first) {
    80000ecc:	00009797          	auipc	a5,0x9
    80000ed0:	3b47a783          	lw	a5,948(a5) # 8000a280 <first.1>
    80000ed4:	e799                	bnez	a5,80000ee2 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000ed6:	2bf000ef          	jal	80001994 <usertrapret>
}
    80000eda:	60a2                	ld	ra,8(sp)
    80000edc:	6402                	ld	s0,0(sp)
    80000ede:	0141                	addi	sp,sp,16
    80000ee0:	8082                	ret
    fsinit(ROOTDEV);
    80000ee2:	4505                	li	a0,1
    80000ee4:	70c010ef          	jal	800025f0 <fsinit>
    first = 0;
    80000ee8:	00009797          	auipc	a5,0x9
    80000eec:	3807ac23          	sw	zero,920(a5) # 8000a280 <first.1>
    __sync_synchronize();
    80000ef0:	0330000f          	fence	rw,rw
    80000ef4:	b7cd                	j	80000ed6 <forkret+0x1a>

0000000080000ef6 <allocpid>:
{
    80000ef6:	1101                	addi	sp,sp,-32
    80000ef8:	ec06                	sd	ra,24(sp)
    80000efa:	e822                	sd	s0,16(sp)
    80000efc:	e426                	sd	s1,8(sp)
    80000efe:	e04a                	sd	s2,0(sp)
    80000f00:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f02:	00009917          	auipc	s2,0x9
    80000f06:	43e90913          	addi	s2,s2,1086 # 8000a340 <pid_lock>
    80000f0a:	854a                	mv	a0,s2
    80000f0c:	205040ef          	jal	80005910 <acquire>
  pid = nextpid;
    80000f10:	00009797          	auipc	a5,0x9
    80000f14:	37478793          	addi	a5,a5,884 # 8000a284 <nextpid>
    80000f18:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f1a:	0014871b          	addiw	a4,s1,1
    80000f1e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f20:	854a                	mv	a0,s2
    80000f22:	287040ef          	jal	800059a8 <release>
}
    80000f26:	8526                	mv	a0,s1
    80000f28:	60e2                	ld	ra,24(sp)
    80000f2a:	6442                	ld	s0,16(sp)
    80000f2c:	64a2                	ld	s1,8(sp)
    80000f2e:	6902                	ld	s2,0(sp)
    80000f30:	6105                	addi	sp,sp,32
    80000f32:	8082                	ret

0000000080000f34 <proc_pagetable>:
{
    80000f34:	1101                	addi	sp,sp,-32
    80000f36:	ec06                	sd	ra,24(sp)
    80000f38:	e822                	sd	s0,16(sp)
    80000f3a:	e426                	sd	s1,8(sp)
    80000f3c:	e04a                	sd	s2,0(sp)
    80000f3e:	1000                	addi	s0,sp,32
    80000f40:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f42:	fcaff0ef          	jal	8000070c <uvmcreate>
    80000f46:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f48:	cd05                	beqz	a0,80000f80 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f4a:	4729                	li	a4,10
    80000f4c:	00005697          	auipc	a3,0x5
    80000f50:	0b468693          	addi	a3,a3,180 # 80006000 <_trampoline>
    80000f54:	6605                	lui	a2,0x1
    80000f56:	040005b7          	lui	a1,0x4000
    80000f5a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f5c:	05b2                	slli	a1,a1,0xc
    80000f5e:	d3cff0ef          	jal	8000049a <mappages>
    80000f62:	02054663          	bltz	a0,80000f8e <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f66:	4719                	li	a4,6
    80000f68:	05893683          	ld	a3,88(s2)
    80000f6c:	6605                	lui	a2,0x1
    80000f6e:	020005b7          	lui	a1,0x2000
    80000f72:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f74:	05b6                	slli	a1,a1,0xd
    80000f76:	8526                	mv	a0,s1
    80000f78:	d22ff0ef          	jal	8000049a <mappages>
    80000f7c:	00054f63          	bltz	a0,80000f9a <proc_pagetable+0x66>
}
    80000f80:	8526                	mv	a0,s1
    80000f82:	60e2                	ld	ra,24(sp)
    80000f84:	6442                	ld	s0,16(sp)
    80000f86:	64a2                	ld	s1,8(sp)
    80000f88:	6902                	ld	s2,0(sp)
    80000f8a:	6105                	addi	sp,sp,32
    80000f8c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f8e:	4581                	li	a1,0
    80000f90:	8526                	mv	a0,s1
    80000f92:	949ff0ef          	jal	800008da <uvmfree>
    return 0;
    80000f96:	4481                	li	s1,0
    80000f98:	b7e5                	j	80000f80 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f9a:	4681                	li	a3,0
    80000f9c:	4605                	li	a2,1
    80000f9e:	040005b7          	lui	a1,0x4000
    80000fa2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fa4:	05b2                	slli	a1,a1,0xc
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	e98ff0ef          	jal	80000640 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fac:	4581                	li	a1,0
    80000fae:	8526                	mv	a0,s1
    80000fb0:	92bff0ef          	jal	800008da <uvmfree>
    return 0;
    80000fb4:	4481                	li	s1,0
    80000fb6:	b7e9                	j	80000f80 <proc_pagetable+0x4c>

0000000080000fb8 <proc_freepagetable>:
{
    80000fb8:	1101                	addi	sp,sp,-32
    80000fba:	ec06                	sd	ra,24(sp)
    80000fbc:	e822                	sd	s0,16(sp)
    80000fbe:	e426                	sd	s1,8(sp)
    80000fc0:	e04a                	sd	s2,0(sp)
    80000fc2:	1000                	addi	s0,sp,32
    80000fc4:	84aa                	mv	s1,a0
    80000fc6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	040005b7          	lui	a1,0x4000
    80000fd0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fd2:	05b2                	slli	a1,a1,0xc
    80000fd4:	e6cff0ef          	jal	80000640 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fd8:	4681                	li	a3,0
    80000fda:	4605                	li	a2,1
    80000fdc:	020005b7          	lui	a1,0x2000
    80000fe0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fe2:	05b6                	slli	a1,a1,0xd
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	e5aff0ef          	jal	80000640 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fea:	85ca                	mv	a1,s2
    80000fec:	8526                	mv	a0,s1
    80000fee:	8edff0ef          	jal	800008da <uvmfree>
}
    80000ff2:	60e2                	ld	ra,24(sp)
    80000ff4:	6442                	ld	s0,16(sp)
    80000ff6:	64a2                	ld	s1,8(sp)
    80000ff8:	6902                	ld	s2,0(sp)
    80000ffa:	6105                	addi	sp,sp,32
    80000ffc:	8082                	ret

0000000080000ffe <freeproc>:
{
    80000ffe:	1101                	addi	sp,sp,-32
    80001000:	ec06                	sd	ra,24(sp)
    80001002:	e822                	sd	s0,16(sp)
    80001004:	e426                	sd	s1,8(sp)
    80001006:	1000                	addi	s0,sp,32
    80001008:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000100a:	6d28                	ld	a0,88(a0)
    8000100c:	c119                	beqz	a0,80001012 <freeproc+0x14>
    kfree((void*)p->trapframe);
    8000100e:	80eff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80001012:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001016:	68a8                	ld	a0,80(s1)
    80001018:	c501                	beqz	a0,80001020 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    8000101a:	64ac                	ld	a1,72(s1)
    8000101c:	f9dff0ef          	jal	80000fb8 <proc_freepagetable>
  p->pagetable = 0;
    80001020:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001024:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001028:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001030:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001034:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001038:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001040:	0004ac23          	sw	zero,24(s1)
}
    80001044:	60e2                	ld	ra,24(sp)
    80001046:	6442                	ld	s0,16(sp)
    80001048:	64a2                	ld	s1,8(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret

000000008000104e <allocproc>:
{
    8000104e:	1101                	addi	sp,sp,-32
    80001050:	ec06                	sd	ra,24(sp)
    80001052:	e822                	sd	s0,16(sp)
    80001054:	e426                	sd	s1,8(sp)
    80001056:	e04a                	sd	s2,0(sp)
    80001058:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105a:	00009497          	auipc	s1,0x9
    8000105e:	71648493          	addi	s1,s1,1814 # 8000a770 <proc>
    80001062:	0000f917          	auipc	s2,0xf
    80001066:	10e90913          	addi	s2,s2,270 # 80010170 <tickslock>
    acquire(&p->lock);
    8000106a:	8526                	mv	a0,s1
    8000106c:	0a5040ef          	jal	80005910 <acquire>
    if(p->state == UNUSED) {
    80001070:	4c9c                	lw	a5,24(s1)
    80001072:	cb91                	beqz	a5,80001086 <allocproc+0x38>
      release(&p->lock);
    80001074:	8526                	mv	a0,s1
    80001076:	133040ef          	jal	800059a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000107a:	16848493          	addi	s1,s1,360
    8000107e:	ff2496e3          	bne	s1,s2,8000106a <allocproc+0x1c>
  return 0;
    80001082:	4481                	li	s1,0
    80001084:	a089                	j	800010c6 <allocproc+0x78>
  p->pid = allocpid();
    80001086:	e71ff0ef          	jal	80000ef6 <allocpid>
    8000108a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000108c:	4785                	li	a5,1
    8000108e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001090:	86eff0ef          	jal	800000fe <kalloc>
    80001094:	892a                	mv	s2,a0
    80001096:	eca8                	sd	a0,88(s1)
    80001098:	cd15                	beqz	a0,800010d4 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    8000109a:	8526                	mv	a0,s1
    8000109c:	e99ff0ef          	jal	80000f34 <proc_pagetable>
    800010a0:	892a                	mv	s2,a0
    800010a2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010a4:	c121                	beqz	a0,800010e4 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    800010a6:	07000613          	li	a2,112
    800010aa:	4581                	li	a1,0
    800010ac:	06048513          	addi	a0,s1,96
    800010b0:	89eff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    800010b4:	00000797          	auipc	a5,0x0
    800010b8:	e0878793          	addi	a5,a5,-504 # 80000ebc <forkret>
    800010bc:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010be:	60bc                	ld	a5,64(s1)
    800010c0:	6705                	lui	a4,0x1
    800010c2:	97ba                	add	a5,a5,a4
    800010c4:	f4bc                	sd	a5,104(s1)
}
    800010c6:	8526                	mv	a0,s1
    800010c8:	60e2                	ld	ra,24(sp)
    800010ca:	6442                	ld	s0,16(sp)
    800010cc:	64a2                	ld	s1,8(sp)
    800010ce:	6902                	ld	s2,0(sp)
    800010d0:	6105                	addi	sp,sp,32
    800010d2:	8082                	ret
    freeproc(p);
    800010d4:	8526                	mv	a0,s1
    800010d6:	f29ff0ef          	jal	80000ffe <freeproc>
    release(&p->lock);
    800010da:	8526                	mv	a0,s1
    800010dc:	0cd040ef          	jal	800059a8 <release>
    return 0;
    800010e0:	84ca                	mv	s1,s2
    800010e2:	b7d5                	j	800010c6 <allocproc+0x78>
    freeproc(p);
    800010e4:	8526                	mv	a0,s1
    800010e6:	f19ff0ef          	jal	80000ffe <freeproc>
    release(&p->lock);
    800010ea:	8526                	mv	a0,s1
    800010ec:	0bd040ef          	jal	800059a8 <release>
    return 0;
    800010f0:	84ca                	mv	s1,s2
    800010f2:	bfd1                	j	800010c6 <allocproc+0x78>

00000000800010f4 <userinit>:
{
    800010f4:	1101                	addi	sp,sp,-32
    800010f6:	ec06                	sd	ra,24(sp)
    800010f8:	e822                	sd	s0,16(sp)
    800010fa:	e426                	sd	s1,8(sp)
    800010fc:	1000                	addi	s0,sp,32
  p = allocproc();
    800010fe:	f51ff0ef          	jal	8000104e <allocproc>
    80001102:	84aa                	mv	s1,a0
  initproc = p;
    80001104:	00009797          	auipc	a5,0x9
    80001108:	1ea7be23          	sd	a0,508(a5) # 8000a300 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000110c:	03400613          	li	a2,52
    80001110:	00009597          	auipc	a1,0x9
    80001114:	18058593          	addi	a1,a1,384 # 8000a290 <initcode>
    80001118:	6928                	ld	a0,80(a0)
    8000111a:	e18ff0ef          	jal	80000732 <uvmfirst>
  p->sz = PGSIZE;
    8000111e:	6785                	lui	a5,0x1
    80001120:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001122:	6cb8                	ld	a4,88(s1)
    80001124:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001128:	6cb8                	ld	a4,88(s1)
    8000112a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000112c:	4641                	li	a2,16
    8000112e:	00006597          	auipc	a1,0x6
    80001132:	0da58593          	addi	a1,a1,218 # 80007208 <etext+0x208>
    80001136:	15848513          	addi	a0,s1,344
    8000113a:	952ff0ef          	jal	8000028c <safestrcpy>
  p->cwd = namei("/");
    8000113e:	00006517          	auipc	a0,0x6
    80001142:	0da50513          	addi	a0,a0,218 # 80007218 <etext+0x218>
    80001146:	5b9010ef          	jal	80002efe <namei>
    8000114a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000114e:	478d                	li	a5,3
    80001150:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001152:	8526                	mv	a0,s1
    80001154:	055040ef          	jal	800059a8 <release>
}
    80001158:	60e2                	ld	ra,24(sp)
    8000115a:	6442                	ld	s0,16(sp)
    8000115c:	64a2                	ld	s1,8(sp)
    8000115e:	6105                	addi	sp,sp,32
    80001160:	8082                	ret

0000000080001162 <growproc>:
{
    80001162:	1101                	addi	sp,sp,-32
    80001164:	ec06                	sd	ra,24(sp)
    80001166:	e822                	sd	s0,16(sp)
    80001168:	e426                	sd	s1,8(sp)
    8000116a:	e04a                	sd	s2,0(sp)
    8000116c:	1000                	addi	s0,sp,32
    8000116e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001170:	d1dff0ef          	jal	80000e8c <myproc>
    80001174:	84aa                	mv	s1,a0
  sz = p->sz;
    80001176:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001178:	01204c63          	bgtz	s2,80001190 <growproc+0x2e>
  } else if(n < 0){
    8000117c:	02094463          	bltz	s2,800011a4 <growproc+0x42>
  p->sz = sz;
    80001180:	e4ac                	sd	a1,72(s1)
  return 0;
    80001182:	4501                	li	a0,0
}
    80001184:	60e2                	ld	ra,24(sp)
    80001186:	6442                	ld	s0,16(sp)
    80001188:	64a2                	ld	s1,8(sp)
    8000118a:	6902                	ld	s2,0(sp)
    8000118c:	6105                	addi	sp,sp,32
    8000118e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001190:	4691                	li	a3,4
    80001192:	00b90633          	add	a2,s2,a1
    80001196:	6928                	ld	a0,80(a0)
    80001198:	e3cff0ef          	jal	800007d4 <uvmalloc>
    8000119c:	85aa                	mv	a1,a0
    8000119e:	f16d                	bnez	a0,80001180 <growproc+0x1e>
      return -1;
    800011a0:	557d                	li	a0,-1
    800011a2:	b7cd                	j	80001184 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011a4:	00b90633          	add	a2,s2,a1
    800011a8:	6928                	ld	a0,80(a0)
    800011aa:	de6ff0ef          	jal	80000790 <uvmdealloc>
    800011ae:	85aa                	mv	a1,a0
    800011b0:	bfc1                	j	80001180 <growproc+0x1e>

00000000800011b2 <fork>:
{
    800011b2:	7139                	addi	sp,sp,-64
    800011b4:	fc06                	sd	ra,56(sp)
    800011b6:	f822                	sd	s0,48(sp)
    800011b8:	f04a                	sd	s2,32(sp)
    800011ba:	e456                	sd	s5,8(sp)
    800011bc:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800011be:	ccfff0ef          	jal	80000e8c <myproc>
    800011c2:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800011c4:	e8bff0ef          	jal	8000104e <allocproc>
    800011c8:	0e050a63          	beqz	a0,800012bc <fork+0x10a>
    800011cc:	e852                	sd	s4,16(sp)
    800011ce:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800011d0:	048ab603          	ld	a2,72(s5)
    800011d4:	692c                	ld	a1,80(a0)
    800011d6:	050ab503          	ld	a0,80(s5)
    800011da:	f32ff0ef          	jal	8000090c <uvmcopy>
    800011de:	04054a63          	bltz	a0,80001232 <fork+0x80>
    800011e2:	f426                	sd	s1,40(sp)
    800011e4:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800011e6:	048ab783          	ld	a5,72(s5)
    800011ea:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800011ee:	058ab683          	ld	a3,88(s5)
    800011f2:	87b6                	mv	a5,a3
    800011f4:	058a3703          	ld	a4,88(s4)
    800011f8:	12068693          	addi	a3,a3,288
    800011fc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001200:	6788                	ld	a0,8(a5)
    80001202:	6b8c                	ld	a1,16(a5)
    80001204:	6f90                	ld	a2,24(a5)
    80001206:	01073023          	sd	a6,0(a4)
    8000120a:	e708                	sd	a0,8(a4)
    8000120c:	eb0c                	sd	a1,16(a4)
    8000120e:	ef10                	sd	a2,24(a4)
    80001210:	02078793          	addi	a5,a5,32
    80001214:	02070713          	addi	a4,a4,32
    80001218:	fed792e3          	bne	a5,a3,800011fc <fork+0x4a>
  np->trapframe->a0 = 0;
    8000121c:	058a3783          	ld	a5,88(s4)
    80001220:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001224:	0d0a8493          	addi	s1,s5,208
    80001228:	0d0a0913          	addi	s2,s4,208
    8000122c:	150a8993          	addi	s3,s5,336
    80001230:	a831                	j	8000124c <fork+0x9a>
    freeproc(np);
    80001232:	8552                	mv	a0,s4
    80001234:	dcbff0ef          	jal	80000ffe <freeproc>
    release(&np->lock);
    80001238:	8552                	mv	a0,s4
    8000123a:	76e040ef          	jal	800059a8 <release>
    return -1;
    8000123e:	597d                	li	s2,-1
    80001240:	6a42                	ld	s4,16(sp)
    80001242:	a0b5                	j	800012ae <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001244:	04a1                	addi	s1,s1,8
    80001246:	0921                	addi	s2,s2,8
    80001248:	01348963          	beq	s1,s3,8000125a <fork+0xa8>
    if(p->ofile[i])
    8000124c:	6088                	ld	a0,0(s1)
    8000124e:	d97d                	beqz	a0,80001244 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001250:	23e020ef          	jal	8000348e <filedup>
    80001254:	00a93023          	sd	a0,0(s2)
    80001258:	b7f5                	j	80001244 <fork+0x92>
  np->cwd = idup(p->cwd);
    8000125a:	150ab503          	ld	a0,336(s5)
    8000125e:	590010ef          	jal	800027ee <idup>
    80001262:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001266:	4641                	li	a2,16
    80001268:	158a8593          	addi	a1,s5,344
    8000126c:	158a0513          	addi	a0,s4,344
    80001270:	81cff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    80001274:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001278:	8552                	mv	a0,s4
    8000127a:	72e040ef          	jal	800059a8 <release>
  acquire(&wait_lock);
    8000127e:	00009497          	auipc	s1,0x9
    80001282:	0da48493          	addi	s1,s1,218 # 8000a358 <wait_lock>
    80001286:	8526                	mv	a0,s1
    80001288:	688040ef          	jal	80005910 <acquire>
  np->parent = p;
    8000128c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001290:	8526                	mv	a0,s1
    80001292:	716040ef          	jal	800059a8 <release>
  acquire(&np->lock);
    80001296:	8552                	mv	a0,s4
    80001298:	678040ef          	jal	80005910 <acquire>
  np->state = RUNNABLE;
    8000129c:	478d                	li	a5,3
    8000129e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800012a2:	8552                	mv	a0,s4
    800012a4:	704040ef          	jal	800059a8 <release>
  return pid;
    800012a8:	74a2                	ld	s1,40(sp)
    800012aa:	69e2                	ld	s3,24(sp)
    800012ac:	6a42                	ld	s4,16(sp)
}
    800012ae:	854a                	mv	a0,s2
    800012b0:	70e2                	ld	ra,56(sp)
    800012b2:	7442                	ld	s0,48(sp)
    800012b4:	7902                	ld	s2,32(sp)
    800012b6:	6aa2                	ld	s5,8(sp)
    800012b8:	6121                	addi	sp,sp,64
    800012ba:	8082                	ret
    return -1;
    800012bc:	597d                	li	s2,-1
    800012be:	bfc5                	j	800012ae <fork+0xfc>

00000000800012c0 <scheduler>:
{
    800012c0:	715d                	addi	sp,sp,-80
    800012c2:	e486                	sd	ra,72(sp)
    800012c4:	e0a2                	sd	s0,64(sp)
    800012c6:	fc26                	sd	s1,56(sp)
    800012c8:	f84a                	sd	s2,48(sp)
    800012ca:	f44e                	sd	s3,40(sp)
    800012cc:	f052                	sd	s4,32(sp)
    800012ce:	ec56                	sd	s5,24(sp)
    800012d0:	e85a                	sd	s6,16(sp)
    800012d2:	e45e                	sd	s7,8(sp)
    800012d4:	e062                	sd	s8,0(sp)
    800012d6:	0880                	addi	s0,sp,80
    800012d8:	8792                	mv	a5,tp
  int id = r_tp();
    800012da:	2781                	sext.w	a5,a5
  c->proc = 0;
    800012dc:	00779b13          	slli	s6,a5,0x7
    800012e0:	00009717          	auipc	a4,0x9
    800012e4:	06070713          	addi	a4,a4,96 # 8000a340 <pid_lock>
    800012e8:	975a                	add	a4,a4,s6
    800012ea:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800012ee:	00009717          	auipc	a4,0x9
    800012f2:	08a70713          	addi	a4,a4,138 # 8000a378 <cpus+0x8>
    800012f6:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800012f8:	4c11                	li	s8,4
        c->proc = p;
    800012fa:	079e                	slli	a5,a5,0x7
    800012fc:	00009a17          	auipc	s4,0x9
    80001300:	044a0a13          	addi	s4,s4,68 # 8000a340 <pid_lock>
    80001304:	9a3e                	add	s4,s4,a5
        found = 1;
    80001306:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001308:	0000f997          	auipc	s3,0xf
    8000130c:	e6898993          	addi	s3,s3,-408 # 80010170 <tickslock>
    80001310:	a0a9                	j	8000135a <scheduler+0x9a>
      release(&p->lock);
    80001312:	8526                	mv	a0,s1
    80001314:	694040ef          	jal	800059a8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001318:	16848493          	addi	s1,s1,360
    8000131c:	03348563          	beq	s1,s3,80001346 <scheduler+0x86>
      acquire(&p->lock);
    80001320:	8526                	mv	a0,s1
    80001322:	5ee040ef          	jal	80005910 <acquire>
      if(p->state == RUNNABLE) {
    80001326:	4c9c                	lw	a5,24(s1)
    80001328:	ff2795e3          	bne	a5,s2,80001312 <scheduler+0x52>
        p->state = RUNNING;
    8000132c:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001330:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001334:	06048593          	addi	a1,s1,96
    80001338:	855a                	mv	a0,s6
    8000133a:	5b4000ef          	jal	800018ee <swtch>
        c->proc = 0;
    8000133e:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001342:	8ade                	mv	s5,s7
    80001344:	b7f9                	j	80001312 <scheduler+0x52>
    if(found == 0) {
    80001346:	000a9a63          	bnez	s5,8000135a <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000134a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000134e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001352:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001356:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000135a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000135e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001362:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001366:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001368:	00009497          	auipc	s1,0x9
    8000136c:	40848493          	addi	s1,s1,1032 # 8000a770 <proc>
      if(p->state == RUNNABLE) {
    80001370:	490d                	li	s2,3
    80001372:	b77d                	j	80001320 <scheduler+0x60>

0000000080001374 <sched>:
{
    80001374:	7179                	addi	sp,sp,-48
    80001376:	f406                	sd	ra,40(sp)
    80001378:	f022                	sd	s0,32(sp)
    8000137a:	ec26                	sd	s1,24(sp)
    8000137c:	e84a                	sd	s2,16(sp)
    8000137e:	e44e                	sd	s3,8(sp)
    80001380:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001382:	b0bff0ef          	jal	80000e8c <myproc>
    80001386:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001388:	51e040ef          	jal	800058a6 <holding>
    8000138c:	c92d                	beqz	a0,800013fe <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000138e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001390:	2781                	sext.w	a5,a5
    80001392:	079e                	slli	a5,a5,0x7
    80001394:	00009717          	auipc	a4,0x9
    80001398:	fac70713          	addi	a4,a4,-84 # 8000a340 <pid_lock>
    8000139c:	97ba                	add	a5,a5,a4
    8000139e:	0a87a703          	lw	a4,168(a5)
    800013a2:	4785                	li	a5,1
    800013a4:	06f71363          	bne	a4,a5,8000140a <sched+0x96>
  if(p->state == RUNNING)
    800013a8:	4c98                	lw	a4,24(s1)
    800013aa:	4791                	li	a5,4
    800013ac:	06f70563          	beq	a4,a5,80001416 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013b0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800013b4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800013b6:	e7b5                	bnez	a5,80001422 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013b8:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800013ba:	00009917          	auipc	s2,0x9
    800013be:	f8690913          	addi	s2,s2,-122 # 8000a340 <pid_lock>
    800013c2:	2781                	sext.w	a5,a5
    800013c4:	079e                	slli	a5,a5,0x7
    800013c6:	97ca                	add	a5,a5,s2
    800013c8:	0ac7a983          	lw	s3,172(a5)
    800013cc:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800013ce:	2781                	sext.w	a5,a5
    800013d0:	079e                	slli	a5,a5,0x7
    800013d2:	00009597          	auipc	a1,0x9
    800013d6:	fa658593          	addi	a1,a1,-90 # 8000a378 <cpus+0x8>
    800013da:	95be                	add	a1,a1,a5
    800013dc:	06048513          	addi	a0,s1,96
    800013e0:	50e000ef          	jal	800018ee <swtch>
    800013e4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800013e6:	2781                	sext.w	a5,a5
    800013e8:	079e                	slli	a5,a5,0x7
    800013ea:	993e                	add	s2,s2,a5
    800013ec:	0b392623          	sw	s3,172(s2)
}
    800013f0:	70a2                	ld	ra,40(sp)
    800013f2:	7402                	ld	s0,32(sp)
    800013f4:	64e2                	ld	s1,24(sp)
    800013f6:	6942                	ld	s2,16(sp)
    800013f8:	69a2                	ld	s3,8(sp)
    800013fa:	6145                	addi	sp,sp,48
    800013fc:	8082                	ret
    panic("sched p->lock");
    800013fe:	00006517          	auipc	a0,0x6
    80001402:	e2250513          	addi	a0,a0,-478 # 80007220 <etext+0x220>
    80001406:	1dc040ef          	jal	800055e2 <panic>
    panic("sched locks");
    8000140a:	00006517          	auipc	a0,0x6
    8000140e:	e2650513          	addi	a0,a0,-474 # 80007230 <etext+0x230>
    80001412:	1d0040ef          	jal	800055e2 <panic>
    panic("sched running");
    80001416:	00006517          	auipc	a0,0x6
    8000141a:	e2a50513          	addi	a0,a0,-470 # 80007240 <etext+0x240>
    8000141e:	1c4040ef          	jal	800055e2 <panic>
    panic("sched interruptible");
    80001422:	00006517          	auipc	a0,0x6
    80001426:	e2e50513          	addi	a0,a0,-466 # 80007250 <etext+0x250>
    8000142a:	1b8040ef          	jal	800055e2 <panic>

000000008000142e <yield>:
{
    8000142e:	1101                	addi	sp,sp,-32
    80001430:	ec06                	sd	ra,24(sp)
    80001432:	e822                	sd	s0,16(sp)
    80001434:	e426                	sd	s1,8(sp)
    80001436:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001438:	a55ff0ef          	jal	80000e8c <myproc>
    8000143c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000143e:	4d2040ef          	jal	80005910 <acquire>
  p->state = RUNNABLE;
    80001442:	478d                	li	a5,3
    80001444:	cc9c                	sw	a5,24(s1)
  sched();
    80001446:	f2fff0ef          	jal	80001374 <sched>
  release(&p->lock);
    8000144a:	8526                	mv	a0,s1
    8000144c:	55c040ef          	jal	800059a8 <release>
}
    80001450:	60e2                	ld	ra,24(sp)
    80001452:	6442                	ld	s0,16(sp)
    80001454:	64a2                	ld	s1,8(sp)
    80001456:	6105                	addi	sp,sp,32
    80001458:	8082                	ret

000000008000145a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000145a:	7179                	addi	sp,sp,-48
    8000145c:	f406                	sd	ra,40(sp)
    8000145e:	f022                	sd	s0,32(sp)
    80001460:	ec26                	sd	s1,24(sp)
    80001462:	e84a                	sd	s2,16(sp)
    80001464:	e44e                	sd	s3,8(sp)
    80001466:	1800                	addi	s0,sp,48
    80001468:	89aa                	mv	s3,a0
    8000146a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000146c:	a21ff0ef          	jal	80000e8c <myproc>
    80001470:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001472:	49e040ef          	jal	80005910 <acquire>
  release(lk);
    80001476:	854a                	mv	a0,s2
    80001478:	530040ef          	jal	800059a8 <release>

  // Go to sleep.
  p->chan = chan;
    8000147c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001480:	4789                	li	a5,2
    80001482:	cc9c                	sw	a5,24(s1)

  sched();
    80001484:	ef1ff0ef          	jal	80001374 <sched>

  // Tidy up.
  p->chan = 0;
    80001488:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000148c:	8526                	mv	a0,s1
    8000148e:	51a040ef          	jal	800059a8 <release>
  acquire(lk);
    80001492:	854a                	mv	a0,s2
    80001494:	47c040ef          	jal	80005910 <acquire>
}
    80001498:	70a2                	ld	ra,40(sp)
    8000149a:	7402                	ld	s0,32(sp)
    8000149c:	64e2                	ld	s1,24(sp)
    8000149e:	6942                	ld	s2,16(sp)
    800014a0:	69a2                	ld	s3,8(sp)
    800014a2:	6145                	addi	sp,sp,48
    800014a4:	8082                	ret

00000000800014a6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800014a6:	7139                	addi	sp,sp,-64
    800014a8:	fc06                	sd	ra,56(sp)
    800014aa:	f822                	sd	s0,48(sp)
    800014ac:	f426                	sd	s1,40(sp)
    800014ae:	f04a                	sd	s2,32(sp)
    800014b0:	ec4e                	sd	s3,24(sp)
    800014b2:	e852                	sd	s4,16(sp)
    800014b4:	e456                	sd	s5,8(sp)
    800014b6:	0080                	addi	s0,sp,64
    800014b8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800014ba:	00009497          	auipc	s1,0x9
    800014be:	2b648493          	addi	s1,s1,694 # 8000a770 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800014c2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800014c4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800014c6:	0000f917          	auipc	s2,0xf
    800014ca:	caa90913          	addi	s2,s2,-854 # 80010170 <tickslock>
    800014ce:	a801                	j	800014de <wakeup+0x38>
      }
      release(&p->lock);
    800014d0:	8526                	mv	a0,s1
    800014d2:	4d6040ef          	jal	800059a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800014d6:	16848493          	addi	s1,s1,360
    800014da:	03248263          	beq	s1,s2,800014fe <wakeup+0x58>
    if(p != myproc()){
    800014de:	9afff0ef          	jal	80000e8c <myproc>
    800014e2:	fea48ae3          	beq	s1,a0,800014d6 <wakeup+0x30>
      acquire(&p->lock);
    800014e6:	8526                	mv	a0,s1
    800014e8:	428040ef          	jal	80005910 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800014ec:	4c9c                	lw	a5,24(s1)
    800014ee:	ff3791e3          	bne	a5,s3,800014d0 <wakeup+0x2a>
    800014f2:	709c                	ld	a5,32(s1)
    800014f4:	fd479ee3          	bne	a5,s4,800014d0 <wakeup+0x2a>
        p->state = RUNNABLE;
    800014f8:	0154ac23          	sw	s5,24(s1)
    800014fc:	bfd1                	j	800014d0 <wakeup+0x2a>
    }
  }
}
    800014fe:	70e2                	ld	ra,56(sp)
    80001500:	7442                	ld	s0,48(sp)
    80001502:	74a2                	ld	s1,40(sp)
    80001504:	7902                	ld	s2,32(sp)
    80001506:	69e2                	ld	s3,24(sp)
    80001508:	6a42                	ld	s4,16(sp)
    8000150a:	6aa2                	ld	s5,8(sp)
    8000150c:	6121                	addi	sp,sp,64
    8000150e:	8082                	ret

0000000080001510 <reparent>:
{
    80001510:	7179                	addi	sp,sp,-48
    80001512:	f406                	sd	ra,40(sp)
    80001514:	f022                	sd	s0,32(sp)
    80001516:	ec26                	sd	s1,24(sp)
    80001518:	e84a                	sd	s2,16(sp)
    8000151a:	e44e                	sd	s3,8(sp)
    8000151c:	e052                	sd	s4,0(sp)
    8000151e:	1800                	addi	s0,sp,48
    80001520:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001522:	00009497          	auipc	s1,0x9
    80001526:	24e48493          	addi	s1,s1,590 # 8000a770 <proc>
      pp->parent = initproc;
    8000152a:	00009a17          	auipc	s4,0x9
    8000152e:	dd6a0a13          	addi	s4,s4,-554 # 8000a300 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001532:	0000f997          	auipc	s3,0xf
    80001536:	c3e98993          	addi	s3,s3,-962 # 80010170 <tickslock>
    8000153a:	a029                	j	80001544 <reparent+0x34>
    8000153c:	16848493          	addi	s1,s1,360
    80001540:	01348b63          	beq	s1,s3,80001556 <reparent+0x46>
    if(pp->parent == p){
    80001544:	7c9c                	ld	a5,56(s1)
    80001546:	ff279be3          	bne	a5,s2,8000153c <reparent+0x2c>
      pp->parent = initproc;
    8000154a:	000a3503          	ld	a0,0(s4)
    8000154e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001550:	f57ff0ef          	jal	800014a6 <wakeup>
    80001554:	b7e5                	j	8000153c <reparent+0x2c>
}
    80001556:	70a2                	ld	ra,40(sp)
    80001558:	7402                	ld	s0,32(sp)
    8000155a:	64e2                	ld	s1,24(sp)
    8000155c:	6942                	ld	s2,16(sp)
    8000155e:	69a2                	ld	s3,8(sp)
    80001560:	6a02                	ld	s4,0(sp)
    80001562:	6145                	addi	sp,sp,48
    80001564:	8082                	ret

0000000080001566 <exit>:
{
    80001566:	7179                	addi	sp,sp,-48
    80001568:	f406                	sd	ra,40(sp)
    8000156a:	f022                	sd	s0,32(sp)
    8000156c:	ec26                	sd	s1,24(sp)
    8000156e:	e84a                	sd	s2,16(sp)
    80001570:	e44e                	sd	s3,8(sp)
    80001572:	e052                	sd	s4,0(sp)
    80001574:	1800                	addi	s0,sp,48
    80001576:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001578:	915ff0ef          	jal	80000e8c <myproc>
    8000157c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000157e:	00009797          	auipc	a5,0x9
    80001582:	d827b783          	ld	a5,-638(a5) # 8000a300 <initproc>
    80001586:	0d050493          	addi	s1,a0,208
    8000158a:	15050913          	addi	s2,a0,336
    8000158e:	00a79f63          	bne	a5,a0,800015ac <exit+0x46>
    panic("init exiting");
    80001592:	00006517          	auipc	a0,0x6
    80001596:	cd650513          	addi	a0,a0,-810 # 80007268 <etext+0x268>
    8000159a:	048040ef          	jal	800055e2 <panic>
      fileclose(f);
    8000159e:	737010ef          	jal	800034d4 <fileclose>
      p->ofile[fd] = 0;
    800015a2:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800015a6:	04a1                	addi	s1,s1,8
    800015a8:	01248563          	beq	s1,s2,800015b2 <exit+0x4c>
    if(p->ofile[fd]){
    800015ac:	6088                	ld	a0,0(s1)
    800015ae:	f965                	bnez	a0,8000159e <exit+0x38>
    800015b0:	bfdd                	j	800015a6 <exit+0x40>
  begin_op();
    800015b2:	309010ef          	jal	800030ba <begin_op>
  iput(p->cwd);
    800015b6:	1509b503          	ld	a0,336(s3)
    800015ba:	3ec010ef          	jal	800029a6 <iput>
  end_op();
    800015be:	367010ef          	jal	80003124 <end_op>
  p->cwd = 0;
    800015c2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800015c6:	00009497          	auipc	s1,0x9
    800015ca:	d9248493          	addi	s1,s1,-622 # 8000a358 <wait_lock>
    800015ce:	8526                	mv	a0,s1
    800015d0:	340040ef          	jal	80005910 <acquire>
  reparent(p);
    800015d4:	854e                	mv	a0,s3
    800015d6:	f3bff0ef          	jal	80001510 <reparent>
  wakeup(p->parent);
    800015da:	0389b503          	ld	a0,56(s3)
    800015de:	ec9ff0ef          	jal	800014a6 <wakeup>
  acquire(&p->lock);
    800015e2:	854e                	mv	a0,s3
    800015e4:	32c040ef          	jal	80005910 <acquire>
  p->xstate = status;
    800015e8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800015ec:	4795                	li	a5,5
    800015ee:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800015f2:	8526                	mv	a0,s1
    800015f4:	3b4040ef          	jal	800059a8 <release>
  sched();
    800015f8:	d7dff0ef          	jal	80001374 <sched>
  panic("zombie exit");
    800015fc:	00006517          	auipc	a0,0x6
    80001600:	c7c50513          	addi	a0,a0,-900 # 80007278 <etext+0x278>
    80001604:	7df030ef          	jal	800055e2 <panic>

0000000080001608 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001608:	7179                	addi	sp,sp,-48
    8000160a:	f406                	sd	ra,40(sp)
    8000160c:	f022                	sd	s0,32(sp)
    8000160e:	ec26                	sd	s1,24(sp)
    80001610:	e84a                	sd	s2,16(sp)
    80001612:	e44e                	sd	s3,8(sp)
    80001614:	1800                	addi	s0,sp,48
    80001616:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001618:	00009497          	auipc	s1,0x9
    8000161c:	15848493          	addi	s1,s1,344 # 8000a770 <proc>
    80001620:	0000f997          	auipc	s3,0xf
    80001624:	b5098993          	addi	s3,s3,-1200 # 80010170 <tickslock>
    acquire(&p->lock);
    80001628:	8526                	mv	a0,s1
    8000162a:	2e6040ef          	jal	80005910 <acquire>
    if(p->pid == pid){
    8000162e:	589c                	lw	a5,48(s1)
    80001630:	01278b63          	beq	a5,s2,80001646 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001634:	8526                	mv	a0,s1
    80001636:	372040ef          	jal	800059a8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000163a:	16848493          	addi	s1,s1,360
    8000163e:	ff3495e3          	bne	s1,s3,80001628 <kill+0x20>
  }
  return -1;
    80001642:	557d                	li	a0,-1
    80001644:	a819                	j	8000165a <kill+0x52>
      p->killed = 1;
    80001646:	4785                	li	a5,1
    80001648:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000164a:	4c98                	lw	a4,24(s1)
    8000164c:	4789                	li	a5,2
    8000164e:	00f70d63          	beq	a4,a5,80001668 <kill+0x60>
      release(&p->lock);
    80001652:	8526                	mv	a0,s1
    80001654:	354040ef          	jal	800059a8 <release>
      return 0;
    80001658:	4501                	li	a0,0
}
    8000165a:	70a2                	ld	ra,40(sp)
    8000165c:	7402                	ld	s0,32(sp)
    8000165e:	64e2                	ld	s1,24(sp)
    80001660:	6942                	ld	s2,16(sp)
    80001662:	69a2                	ld	s3,8(sp)
    80001664:	6145                	addi	sp,sp,48
    80001666:	8082                	ret
        p->state = RUNNABLE;
    80001668:	478d                	li	a5,3
    8000166a:	cc9c                	sw	a5,24(s1)
    8000166c:	b7dd                	j	80001652 <kill+0x4a>

000000008000166e <setkilled>:

void
setkilled(struct proc *p)
{
    8000166e:	1101                	addi	sp,sp,-32
    80001670:	ec06                	sd	ra,24(sp)
    80001672:	e822                	sd	s0,16(sp)
    80001674:	e426                	sd	s1,8(sp)
    80001676:	1000                	addi	s0,sp,32
    80001678:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000167a:	296040ef          	jal	80005910 <acquire>
  p->killed = 1;
    8000167e:	4785                	li	a5,1
    80001680:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001682:	8526                	mv	a0,s1
    80001684:	324040ef          	jal	800059a8 <release>
}
    80001688:	60e2                	ld	ra,24(sp)
    8000168a:	6442                	ld	s0,16(sp)
    8000168c:	64a2                	ld	s1,8(sp)
    8000168e:	6105                	addi	sp,sp,32
    80001690:	8082                	ret

0000000080001692 <killed>:

int
killed(struct proc *p)
{
    80001692:	1101                	addi	sp,sp,-32
    80001694:	ec06                	sd	ra,24(sp)
    80001696:	e822                	sd	s0,16(sp)
    80001698:	e426                	sd	s1,8(sp)
    8000169a:	e04a                	sd	s2,0(sp)
    8000169c:	1000                	addi	s0,sp,32
    8000169e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800016a0:	270040ef          	jal	80005910 <acquire>
  k = p->killed;
    800016a4:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800016a8:	8526                	mv	a0,s1
    800016aa:	2fe040ef          	jal	800059a8 <release>
  return k;
}
    800016ae:	854a                	mv	a0,s2
    800016b0:	60e2                	ld	ra,24(sp)
    800016b2:	6442                	ld	s0,16(sp)
    800016b4:	64a2                	ld	s1,8(sp)
    800016b6:	6902                	ld	s2,0(sp)
    800016b8:	6105                	addi	sp,sp,32
    800016ba:	8082                	ret

00000000800016bc <wait>:
{
    800016bc:	715d                	addi	sp,sp,-80
    800016be:	e486                	sd	ra,72(sp)
    800016c0:	e0a2                	sd	s0,64(sp)
    800016c2:	fc26                	sd	s1,56(sp)
    800016c4:	f84a                	sd	s2,48(sp)
    800016c6:	f44e                	sd	s3,40(sp)
    800016c8:	f052                	sd	s4,32(sp)
    800016ca:	ec56                	sd	s5,24(sp)
    800016cc:	e85a                	sd	s6,16(sp)
    800016ce:	e45e                	sd	s7,8(sp)
    800016d0:	e062                	sd	s8,0(sp)
    800016d2:	0880                	addi	s0,sp,80
    800016d4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016d6:	fb6ff0ef          	jal	80000e8c <myproc>
    800016da:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016dc:	00009517          	auipc	a0,0x9
    800016e0:	c7c50513          	addi	a0,a0,-900 # 8000a358 <wait_lock>
    800016e4:	22c040ef          	jal	80005910 <acquire>
    havekids = 0;
    800016e8:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800016ea:	4a15                	li	s4,5
        havekids = 1;
    800016ec:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016ee:	0000f997          	auipc	s3,0xf
    800016f2:	a8298993          	addi	s3,s3,-1406 # 80010170 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016f6:	00009c17          	auipc	s8,0x9
    800016fa:	c62c0c13          	addi	s8,s8,-926 # 8000a358 <wait_lock>
    800016fe:	a871                	j	8000179a <wait+0xde>
          pid = pp->pid;
    80001700:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001704:	000b0c63          	beqz	s6,8000171c <wait+0x60>
    80001708:	4691                	li	a3,4
    8000170a:	02c48613          	addi	a2,s1,44
    8000170e:	85da                	mv	a1,s6
    80001710:	05093503          	ld	a0,80(s2)
    80001714:	ad4ff0ef          	jal	800009e8 <copyout>
    80001718:	02054b63          	bltz	a0,8000174e <wait+0x92>
          freeproc(pp);
    8000171c:	8526                	mv	a0,s1
    8000171e:	8e1ff0ef          	jal	80000ffe <freeproc>
          release(&pp->lock);
    80001722:	8526                	mv	a0,s1
    80001724:	284040ef          	jal	800059a8 <release>
          release(&wait_lock);
    80001728:	00009517          	auipc	a0,0x9
    8000172c:	c3050513          	addi	a0,a0,-976 # 8000a358 <wait_lock>
    80001730:	278040ef          	jal	800059a8 <release>
}
    80001734:	854e                	mv	a0,s3
    80001736:	60a6                	ld	ra,72(sp)
    80001738:	6406                	ld	s0,64(sp)
    8000173a:	74e2                	ld	s1,56(sp)
    8000173c:	7942                	ld	s2,48(sp)
    8000173e:	79a2                	ld	s3,40(sp)
    80001740:	7a02                	ld	s4,32(sp)
    80001742:	6ae2                	ld	s5,24(sp)
    80001744:	6b42                	ld	s6,16(sp)
    80001746:	6ba2                	ld	s7,8(sp)
    80001748:	6c02                	ld	s8,0(sp)
    8000174a:	6161                	addi	sp,sp,80
    8000174c:	8082                	ret
            release(&pp->lock);
    8000174e:	8526                	mv	a0,s1
    80001750:	258040ef          	jal	800059a8 <release>
            release(&wait_lock);
    80001754:	00009517          	auipc	a0,0x9
    80001758:	c0450513          	addi	a0,a0,-1020 # 8000a358 <wait_lock>
    8000175c:	24c040ef          	jal	800059a8 <release>
            return -1;
    80001760:	59fd                	li	s3,-1
    80001762:	bfc9                	j	80001734 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001764:	16848493          	addi	s1,s1,360
    80001768:	03348063          	beq	s1,s3,80001788 <wait+0xcc>
      if(pp->parent == p){
    8000176c:	7c9c                	ld	a5,56(s1)
    8000176e:	ff279be3          	bne	a5,s2,80001764 <wait+0xa8>
        acquire(&pp->lock);
    80001772:	8526                	mv	a0,s1
    80001774:	19c040ef          	jal	80005910 <acquire>
        if(pp->state == ZOMBIE){
    80001778:	4c9c                	lw	a5,24(s1)
    8000177a:	f94783e3          	beq	a5,s4,80001700 <wait+0x44>
        release(&pp->lock);
    8000177e:	8526                	mv	a0,s1
    80001780:	228040ef          	jal	800059a8 <release>
        havekids = 1;
    80001784:	8756                	mv	a4,s5
    80001786:	bff9                	j	80001764 <wait+0xa8>
    if(!havekids || killed(p)){
    80001788:	cf19                	beqz	a4,800017a6 <wait+0xea>
    8000178a:	854a                	mv	a0,s2
    8000178c:	f07ff0ef          	jal	80001692 <killed>
    80001790:	e919                	bnez	a0,800017a6 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001792:	85e2                	mv	a1,s8
    80001794:	854a                	mv	a0,s2
    80001796:	cc5ff0ef          	jal	8000145a <sleep>
    havekids = 0;
    8000179a:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000179c:	00009497          	auipc	s1,0x9
    800017a0:	fd448493          	addi	s1,s1,-44 # 8000a770 <proc>
    800017a4:	b7e1                	j	8000176c <wait+0xb0>
      release(&wait_lock);
    800017a6:	00009517          	auipc	a0,0x9
    800017aa:	bb250513          	addi	a0,a0,-1102 # 8000a358 <wait_lock>
    800017ae:	1fa040ef          	jal	800059a8 <release>
      return -1;
    800017b2:	59fd                	li	s3,-1
    800017b4:	b741                	j	80001734 <wait+0x78>

00000000800017b6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800017b6:	7179                	addi	sp,sp,-48
    800017b8:	f406                	sd	ra,40(sp)
    800017ba:	f022                	sd	s0,32(sp)
    800017bc:	ec26                	sd	s1,24(sp)
    800017be:	e84a                	sd	s2,16(sp)
    800017c0:	e44e                	sd	s3,8(sp)
    800017c2:	e052                	sd	s4,0(sp)
    800017c4:	1800                	addi	s0,sp,48
    800017c6:	84aa                	mv	s1,a0
    800017c8:	892e                	mv	s2,a1
    800017ca:	89b2                	mv	s3,a2
    800017cc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800017ce:	ebeff0ef          	jal	80000e8c <myproc>
  if(user_dst){
    800017d2:	cc99                	beqz	s1,800017f0 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800017d4:	86d2                	mv	a3,s4
    800017d6:	864e                	mv	a2,s3
    800017d8:	85ca                	mv	a1,s2
    800017da:	6928                	ld	a0,80(a0)
    800017dc:	a0cff0ef          	jal	800009e8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800017e0:	70a2                	ld	ra,40(sp)
    800017e2:	7402                	ld	s0,32(sp)
    800017e4:	64e2                	ld	s1,24(sp)
    800017e6:	6942                	ld	s2,16(sp)
    800017e8:	69a2                	ld	s3,8(sp)
    800017ea:	6a02                	ld	s4,0(sp)
    800017ec:	6145                	addi	sp,sp,48
    800017ee:	8082                	ret
    memmove((char *)dst, src, len);
    800017f0:	000a061b          	sext.w	a2,s4
    800017f4:	85ce                	mv	a1,s3
    800017f6:	854a                	mv	a0,s2
    800017f8:	9b3fe0ef          	jal	800001aa <memmove>
    return 0;
    800017fc:	8526                	mv	a0,s1
    800017fe:	b7cd                	j	800017e0 <either_copyout+0x2a>

0000000080001800 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001800:	7179                	addi	sp,sp,-48
    80001802:	f406                	sd	ra,40(sp)
    80001804:	f022                	sd	s0,32(sp)
    80001806:	ec26                	sd	s1,24(sp)
    80001808:	e84a                	sd	s2,16(sp)
    8000180a:	e44e                	sd	s3,8(sp)
    8000180c:	e052                	sd	s4,0(sp)
    8000180e:	1800                	addi	s0,sp,48
    80001810:	892a                	mv	s2,a0
    80001812:	84ae                	mv	s1,a1
    80001814:	89b2                	mv	s3,a2
    80001816:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001818:	e74ff0ef          	jal	80000e8c <myproc>
  if(user_src){
    8000181c:	cc99                	beqz	s1,8000183a <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000181e:	86d2                	mv	a3,s4
    80001820:	864e                	mv	a2,s3
    80001822:	85ca                	mv	a1,s2
    80001824:	6928                	ld	a0,80(a0)
    80001826:	a9aff0ef          	jal	80000ac0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000182a:	70a2                	ld	ra,40(sp)
    8000182c:	7402                	ld	s0,32(sp)
    8000182e:	64e2                	ld	s1,24(sp)
    80001830:	6942                	ld	s2,16(sp)
    80001832:	69a2                	ld	s3,8(sp)
    80001834:	6a02                	ld	s4,0(sp)
    80001836:	6145                	addi	sp,sp,48
    80001838:	8082                	ret
    memmove(dst, (char*)src, len);
    8000183a:	000a061b          	sext.w	a2,s4
    8000183e:	85ce                	mv	a1,s3
    80001840:	854a                	mv	a0,s2
    80001842:	969fe0ef          	jal	800001aa <memmove>
    return 0;
    80001846:	8526                	mv	a0,s1
    80001848:	b7cd                	j	8000182a <either_copyin+0x2a>

000000008000184a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000184a:	715d                	addi	sp,sp,-80
    8000184c:	e486                	sd	ra,72(sp)
    8000184e:	e0a2                	sd	s0,64(sp)
    80001850:	fc26                	sd	s1,56(sp)
    80001852:	f84a                	sd	s2,48(sp)
    80001854:	f44e                	sd	s3,40(sp)
    80001856:	f052                	sd	s4,32(sp)
    80001858:	ec56                	sd	s5,24(sp)
    8000185a:	e85a                	sd	s6,16(sp)
    8000185c:	e45e                	sd	s7,8(sp)
    8000185e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001860:	00005517          	auipc	a0,0x5
    80001864:	7b850513          	addi	a0,a0,1976 # 80007018 <etext+0x18>
    80001868:	2a9030ef          	jal	80005310 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000186c:	00009497          	auipc	s1,0x9
    80001870:	05c48493          	addi	s1,s1,92 # 8000a8c8 <proc+0x158>
    80001874:	0000f917          	auipc	s2,0xf
    80001878:	a5490913          	addi	s2,s2,-1452 # 800102c8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000187c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000187e:	00006997          	auipc	s3,0x6
    80001882:	a0a98993          	addi	s3,s3,-1526 # 80007288 <etext+0x288>
    printf("%d %s %s", p->pid, state, p->name);
    80001886:	00006a97          	auipc	s5,0x6
    8000188a:	a0aa8a93          	addi	s5,s5,-1526 # 80007290 <etext+0x290>
    printf("\n");
    8000188e:	00005a17          	auipc	s4,0x5
    80001892:	78aa0a13          	addi	s4,s4,1930 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001896:	00006b97          	auipc	s7,0x6
    8000189a:	f1ab8b93          	addi	s7,s7,-230 # 800077b0 <states.0>
    8000189e:	a829                	j	800018b8 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800018a0:	ed86a583          	lw	a1,-296(a3)
    800018a4:	8556                	mv	a0,s5
    800018a6:	26b030ef          	jal	80005310 <printf>
    printf("\n");
    800018aa:	8552                	mv	a0,s4
    800018ac:	265030ef          	jal	80005310 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800018b0:	16848493          	addi	s1,s1,360
    800018b4:	03248263          	beq	s1,s2,800018d8 <procdump+0x8e>
    if(p->state == UNUSED)
    800018b8:	86a6                	mv	a3,s1
    800018ba:	ec04a783          	lw	a5,-320(s1)
    800018be:	dbed                	beqz	a5,800018b0 <procdump+0x66>
      state = "???";
    800018c0:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800018c2:	fcfb6fe3          	bltu	s6,a5,800018a0 <procdump+0x56>
    800018c6:	02079713          	slli	a4,a5,0x20
    800018ca:	01d75793          	srli	a5,a4,0x1d
    800018ce:	97de                	add	a5,a5,s7
    800018d0:	6390                	ld	a2,0(a5)
    800018d2:	f679                	bnez	a2,800018a0 <procdump+0x56>
      state = "???";
    800018d4:	864e                	mv	a2,s3
    800018d6:	b7e9                	j	800018a0 <procdump+0x56>
  }
}
    800018d8:	60a6                	ld	ra,72(sp)
    800018da:	6406                	ld	s0,64(sp)
    800018dc:	74e2                	ld	s1,56(sp)
    800018de:	7942                	ld	s2,48(sp)
    800018e0:	79a2                	ld	s3,40(sp)
    800018e2:	7a02                	ld	s4,32(sp)
    800018e4:	6ae2                	ld	s5,24(sp)
    800018e6:	6b42                	ld	s6,16(sp)
    800018e8:	6ba2                	ld	s7,8(sp)
    800018ea:	6161                	addi	sp,sp,80
    800018ec:	8082                	ret

00000000800018ee <swtch>:
    800018ee:	00153023          	sd	ra,0(a0)
    800018f2:	00253423          	sd	sp,8(a0)
    800018f6:	e900                	sd	s0,16(a0)
    800018f8:	ed04                	sd	s1,24(a0)
    800018fa:	03253023          	sd	s2,32(a0)
    800018fe:	03353423          	sd	s3,40(a0)
    80001902:	03453823          	sd	s4,48(a0)
    80001906:	03553c23          	sd	s5,56(a0)
    8000190a:	05653023          	sd	s6,64(a0)
    8000190e:	05753423          	sd	s7,72(a0)
    80001912:	05853823          	sd	s8,80(a0)
    80001916:	05953c23          	sd	s9,88(a0)
    8000191a:	07a53023          	sd	s10,96(a0)
    8000191e:	07b53423          	sd	s11,104(a0)
    80001922:	0005b083          	ld	ra,0(a1)
    80001926:	0085b103          	ld	sp,8(a1)
    8000192a:	6980                	ld	s0,16(a1)
    8000192c:	6d84                	ld	s1,24(a1)
    8000192e:	0205b903          	ld	s2,32(a1)
    80001932:	0285b983          	ld	s3,40(a1)
    80001936:	0305ba03          	ld	s4,48(a1)
    8000193a:	0385ba83          	ld	s5,56(a1)
    8000193e:	0405bb03          	ld	s6,64(a1)
    80001942:	0485bb83          	ld	s7,72(a1)
    80001946:	0505bc03          	ld	s8,80(a1)
    8000194a:	0585bc83          	ld	s9,88(a1)
    8000194e:	0605bd03          	ld	s10,96(a1)
    80001952:	0685bd83          	ld	s11,104(a1)
    80001956:	8082                	ret

0000000080001958 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001958:	1141                	addi	sp,sp,-16
    8000195a:	e406                	sd	ra,8(sp)
    8000195c:	e022                	sd	s0,0(sp)
    8000195e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001960:	00006597          	auipc	a1,0x6
    80001964:	97058593          	addi	a1,a1,-1680 # 800072d0 <etext+0x2d0>
    80001968:	0000f517          	auipc	a0,0xf
    8000196c:	80850513          	addi	a0,a0,-2040 # 80010170 <tickslock>
    80001970:	721030ef          	jal	80005890 <initlock>
}
    80001974:	60a2                	ld	ra,8(sp)
    80001976:	6402                	ld	s0,0(sp)
    80001978:	0141                	addi	sp,sp,16
    8000197a:	8082                	ret

000000008000197c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000197c:	1141                	addi	sp,sp,-16
    8000197e:	e422                	sd	s0,8(sp)
    80001980:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001982:	00003797          	auipc	a5,0x3
    80001986:	ece78793          	addi	a5,a5,-306 # 80004850 <kernelvec>
    8000198a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000198e:	6422                	ld	s0,8(sp)
    80001990:	0141                	addi	sp,sp,16
    80001992:	8082                	ret

0000000080001994 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001994:	1141                	addi	sp,sp,-16
    80001996:	e406                	sd	ra,8(sp)
    80001998:	e022                	sd	s0,0(sp)
    8000199a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000199c:	cf0ff0ef          	jal	80000e8c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800019a4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019a6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800019aa:	00004697          	auipc	a3,0x4
    800019ae:	65668693          	addi	a3,a3,1622 # 80006000 <_trampoline>
    800019b2:	00004717          	auipc	a4,0x4
    800019b6:	64e70713          	addi	a4,a4,1614 # 80006000 <_trampoline>
    800019ba:	8f15                	sub	a4,a4,a3
    800019bc:	040007b7          	lui	a5,0x4000
    800019c0:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800019c2:	07b2                	slli	a5,a5,0xc
    800019c4:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019c6:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800019ca:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800019cc:	18002673          	csrr	a2,satp
    800019d0:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800019d2:	6d30                	ld	a2,88(a0)
    800019d4:	6138                	ld	a4,64(a0)
    800019d6:	6585                	lui	a1,0x1
    800019d8:	972e                	add	a4,a4,a1
    800019da:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800019dc:	6d38                	ld	a4,88(a0)
    800019de:	00000617          	auipc	a2,0x0
    800019e2:	11060613          	addi	a2,a2,272 # 80001aee <usertrap>
    800019e6:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800019e8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800019ea:	8612                	mv	a2,tp
    800019ec:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019ee:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800019f2:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800019f6:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019fa:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800019fe:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001a00:	6f18                	ld	a4,24(a4)
    80001a02:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001a06:	6928                	ld	a0,80(a0)
    80001a08:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001a0a:	00004717          	auipc	a4,0x4
    80001a0e:	69270713          	addi	a4,a4,1682 # 8000609c <userret>
    80001a12:	8f15                	sub	a4,a4,a3
    80001a14:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001a16:	577d                	li	a4,-1
    80001a18:	177e                	slli	a4,a4,0x3f
    80001a1a:	8d59                	or	a0,a0,a4
    80001a1c:	9782                	jalr	a5
}
    80001a1e:	60a2                	ld	ra,8(sp)
    80001a20:	6402                	ld	s0,0(sp)
    80001a22:	0141                	addi	sp,sp,16
    80001a24:	8082                	ret

0000000080001a26 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001a26:	1101                	addi	sp,sp,-32
    80001a28:	ec06                	sd	ra,24(sp)
    80001a2a:	e822                	sd	s0,16(sp)
    80001a2c:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001a2e:	c32ff0ef          	jal	80000e60 <cpuid>
    80001a32:	cd11                	beqz	a0,80001a4e <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001a34:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001a38:	000f4737          	lui	a4,0xf4
    80001a3c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001a40:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001a42:	14d79073          	csrw	stimecmp,a5
}
    80001a46:	60e2                	ld	ra,24(sp)
    80001a48:	6442                	ld	s0,16(sp)
    80001a4a:	6105                	addi	sp,sp,32
    80001a4c:	8082                	ret
    80001a4e:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001a50:	0000e497          	auipc	s1,0xe
    80001a54:	72048493          	addi	s1,s1,1824 # 80010170 <tickslock>
    80001a58:	8526                	mv	a0,s1
    80001a5a:	6b7030ef          	jal	80005910 <acquire>
    ticks++;
    80001a5e:	00009517          	auipc	a0,0x9
    80001a62:	8aa50513          	addi	a0,a0,-1878 # 8000a308 <ticks>
    80001a66:	411c                	lw	a5,0(a0)
    80001a68:	2785                	addiw	a5,a5,1
    80001a6a:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001a6c:	a3bff0ef          	jal	800014a6 <wakeup>
    release(&tickslock);
    80001a70:	8526                	mv	a0,s1
    80001a72:	737030ef          	jal	800059a8 <release>
    80001a76:	64a2                	ld	s1,8(sp)
    80001a78:	bf75                	j	80001a34 <clockintr+0xe>

0000000080001a7a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001a7a:	1101                	addi	sp,sp,-32
    80001a7c:	ec06                	sd	ra,24(sp)
    80001a7e:	e822                	sd	s0,16(sp)
    80001a80:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a82:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001a86:	57fd                	li	a5,-1
    80001a88:	17fe                	slli	a5,a5,0x3f
    80001a8a:	07a5                	addi	a5,a5,9
    80001a8c:	00f70c63          	beq	a4,a5,80001aa4 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a90:	57fd                	li	a5,-1
    80001a92:	17fe                	slli	a5,a5,0x3f
    80001a94:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a96:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a98:	04f70763          	beq	a4,a5,80001ae6 <devintr+0x6c>
  }
}
    80001a9c:	60e2                	ld	ra,24(sp)
    80001a9e:	6442                	ld	s0,16(sp)
    80001aa0:	6105                	addi	sp,sp,32
    80001aa2:	8082                	ret
    80001aa4:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001aa6:	657020ef          	jal	800048fc <plic_claim>
    80001aaa:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001aac:	47a9                	li	a5,10
    80001aae:	00f50963          	beq	a0,a5,80001ac0 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001ab2:	4785                	li	a5,1
    80001ab4:	00f50963          	beq	a0,a5,80001ac6 <devintr+0x4c>
    return 1;
    80001ab8:	4505                	li	a0,1
    } else if(irq){
    80001aba:	e889                	bnez	s1,80001acc <devintr+0x52>
    80001abc:	64a2                	ld	s1,8(sp)
    80001abe:	bff9                	j	80001a9c <devintr+0x22>
      uartintr();
    80001ac0:	595030ef          	jal	80005854 <uartintr>
    if(irq)
    80001ac4:	a819                	j	80001ada <devintr+0x60>
      virtio_disk_intr();
    80001ac6:	2fc030ef          	jal	80004dc2 <virtio_disk_intr>
    if(irq)
    80001aca:	a801                	j	80001ada <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001acc:	85a6                	mv	a1,s1
    80001ace:	00006517          	auipc	a0,0x6
    80001ad2:	80a50513          	addi	a0,a0,-2038 # 800072d8 <etext+0x2d8>
    80001ad6:	03b030ef          	jal	80005310 <printf>
      plic_complete(irq);
    80001ada:	8526                	mv	a0,s1
    80001adc:	641020ef          	jal	8000491c <plic_complete>
    return 1;
    80001ae0:	4505                	li	a0,1
    80001ae2:	64a2                	ld	s1,8(sp)
    80001ae4:	bf65                	j	80001a9c <devintr+0x22>
    clockintr();
    80001ae6:	f41ff0ef          	jal	80001a26 <clockintr>
    return 2;
    80001aea:	4509                	li	a0,2
    80001aec:	bf45                	j	80001a9c <devintr+0x22>

0000000080001aee <usertrap>:
{
    80001aee:	1101                	addi	sp,sp,-32
    80001af0:	ec06                	sd	ra,24(sp)
    80001af2:	e822                	sd	s0,16(sp)
    80001af4:	e426                	sd	s1,8(sp)
    80001af6:	e04a                	sd	s2,0(sp)
    80001af8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001afa:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001afe:	1007f793          	andi	a5,a5,256
    80001b02:	ef85                	bnez	a5,80001b3a <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b04:	00003797          	auipc	a5,0x3
    80001b08:	d4c78793          	addi	a5,a5,-692 # 80004850 <kernelvec>
    80001b0c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001b10:	b7cff0ef          	jal	80000e8c <myproc>
    80001b14:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001b16:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b18:	14102773          	csrr	a4,sepc
    80001b1c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b1e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001b22:	47a1                	li	a5,8
    80001b24:	02f70163          	beq	a4,a5,80001b46 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001b28:	f53ff0ef          	jal	80001a7a <devintr>
    80001b2c:	892a                	mv	s2,a0
    80001b2e:	c135                	beqz	a0,80001b92 <usertrap+0xa4>
  if(killed(p))
    80001b30:	8526                	mv	a0,s1
    80001b32:	b61ff0ef          	jal	80001692 <killed>
    80001b36:	cd1d                	beqz	a0,80001b74 <usertrap+0x86>
    80001b38:	a81d                	j	80001b6e <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001b3a:	00005517          	auipc	a0,0x5
    80001b3e:	7be50513          	addi	a0,a0,1982 # 800072f8 <etext+0x2f8>
    80001b42:	2a1030ef          	jal	800055e2 <panic>
    if(killed(p))
    80001b46:	b4dff0ef          	jal	80001692 <killed>
    80001b4a:	e121                	bnez	a0,80001b8a <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001b4c:	6cb8                	ld	a4,88(s1)
    80001b4e:	6f1c                	ld	a5,24(a4)
    80001b50:	0791                	addi	a5,a5,4
    80001b52:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b54:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b58:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b5c:	10079073          	csrw	sstatus,a5
    syscall();
    80001b60:	248000ef          	jal	80001da8 <syscall>
  if(killed(p))
    80001b64:	8526                	mv	a0,s1
    80001b66:	b2dff0ef          	jal	80001692 <killed>
    80001b6a:	c901                	beqz	a0,80001b7a <usertrap+0x8c>
    80001b6c:	4901                	li	s2,0
    exit(-1);
    80001b6e:	557d                	li	a0,-1
    80001b70:	9f7ff0ef          	jal	80001566 <exit>
  if(which_dev == 2)
    80001b74:	4789                	li	a5,2
    80001b76:	04f90563          	beq	s2,a5,80001bc0 <usertrap+0xd2>
  usertrapret();
    80001b7a:	e1bff0ef          	jal	80001994 <usertrapret>
}
    80001b7e:	60e2                	ld	ra,24(sp)
    80001b80:	6442                	ld	s0,16(sp)
    80001b82:	64a2                	ld	s1,8(sp)
    80001b84:	6902                	ld	s2,0(sp)
    80001b86:	6105                	addi	sp,sp,32
    80001b88:	8082                	ret
      exit(-1);
    80001b8a:	557d                	li	a0,-1
    80001b8c:	9dbff0ef          	jal	80001566 <exit>
    80001b90:	bf75                	j	80001b4c <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b92:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b96:	5890                	lw	a2,48(s1)
    80001b98:	00005517          	auipc	a0,0x5
    80001b9c:	78050513          	addi	a0,a0,1920 # 80007318 <etext+0x318>
    80001ba0:	770030ef          	jal	80005310 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ba4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ba8:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001bac:	00005517          	auipc	a0,0x5
    80001bb0:	79c50513          	addi	a0,a0,1948 # 80007348 <etext+0x348>
    80001bb4:	75c030ef          	jal	80005310 <printf>
    setkilled(p);
    80001bb8:	8526                	mv	a0,s1
    80001bba:	ab5ff0ef          	jal	8000166e <setkilled>
    80001bbe:	b75d                	j	80001b64 <usertrap+0x76>
    yield();
    80001bc0:	86fff0ef          	jal	8000142e <yield>
    80001bc4:	bf5d                	j	80001b7a <usertrap+0x8c>

0000000080001bc6 <kerneltrap>:
{
    80001bc6:	7179                	addi	sp,sp,-48
    80001bc8:	f406                	sd	ra,40(sp)
    80001bca:	f022                	sd	s0,32(sp)
    80001bcc:	ec26                	sd	s1,24(sp)
    80001bce:	e84a                	sd	s2,16(sp)
    80001bd0:	e44e                	sd	s3,8(sp)
    80001bd2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bd4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bd8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bdc:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001be0:	1004f793          	andi	a5,s1,256
    80001be4:	c795                	beqz	a5,80001c10 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001be6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001bea:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001bec:	eb85                	bnez	a5,80001c1c <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001bee:	e8dff0ef          	jal	80001a7a <devintr>
    80001bf2:	c91d                	beqz	a0,80001c28 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001bf4:	4789                	li	a5,2
    80001bf6:	04f50a63          	beq	a0,a5,80001c4a <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bfa:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bfe:	10049073          	csrw	sstatus,s1
}
    80001c02:	70a2                	ld	ra,40(sp)
    80001c04:	7402                	ld	s0,32(sp)
    80001c06:	64e2                	ld	s1,24(sp)
    80001c08:	6942                	ld	s2,16(sp)
    80001c0a:	69a2                	ld	s3,8(sp)
    80001c0c:	6145                	addi	sp,sp,48
    80001c0e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001c10:	00005517          	auipc	a0,0x5
    80001c14:	76050513          	addi	a0,a0,1888 # 80007370 <etext+0x370>
    80001c18:	1cb030ef          	jal	800055e2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001c1c:	00005517          	auipc	a0,0x5
    80001c20:	77c50513          	addi	a0,a0,1916 # 80007398 <etext+0x398>
    80001c24:	1bf030ef          	jal	800055e2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c28:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001c2c:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001c30:	85ce                	mv	a1,s3
    80001c32:	00005517          	auipc	a0,0x5
    80001c36:	78650513          	addi	a0,a0,1926 # 800073b8 <etext+0x3b8>
    80001c3a:	6d6030ef          	jal	80005310 <printf>
    panic("kerneltrap");
    80001c3e:	00005517          	auipc	a0,0x5
    80001c42:	7a250513          	addi	a0,a0,1954 # 800073e0 <etext+0x3e0>
    80001c46:	19d030ef          	jal	800055e2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001c4a:	a42ff0ef          	jal	80000e8c <myproc>
    80001c4e:	d555                	beqz	a0,80001bfa <kerneltrap+0x34>
    yield();
    80001c50:	fdeff0ef          	jal	8000142e <yield>
    80001c54:	b75d                	j	80001bfa <kerneltrap+0x34>

0000000080001c56 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001c56:	1101                	addi	sp,sp,-32
    80001c58:	ec06                	sd	ra,24(sp)
    80001c5a:	e822                	sd	s0,16(sp)
    80001c5c:	e426                	sd	s1,8(sp)
    80001c5e:	1000                	addi	s0,sp,32
    80001c60:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c62:	a2aff0ef          	jal	80000e8c <myproc>
  switch (n) {
    80001c66:	4795                	li	a5,5
    80001c68:	0497e163          	bltu	a5,s1,80001caa <argraw+0x54>
    80001c6c:	048a                	slli	s1,s1,0x2
    80001c6e:	00006717          	auipc	a4,0x6
    80001c72:	b7270713          	addi	a4,a4,-1166 # 800077e0 <states.0+0x30>
    80001c76:	94ba                	add	s1,s1,a4
    80001c78:	409c                	lw	a5,0(s1)
    80001c7a:	97ba                	add	a5,a5,a4
    80001c7c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001c7e:	6d3c                	ld	a5,88(a0)
    80001c80:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001c82:	60e2                	ld	ra,24(sp)
    80001c84:	6442                	ld	s0,16(sp)
    80001c86:	64a2                	ld	s1,8(sp)
    80001c88:	6105                	addi	sp,sp,32
    80001c8a:	8082                	ret
    return p->trapframe->a1;
    80001c8c:	6d3c                	ld	a5,88(a0)
    80001c8e:	7fa8                	ld	a0,120(a5)
    80001c90:	bfcd                	j	80001c82 <argraw+0x2c>
    return p->trapframe->a2;
    80001c92:	6d3c                	ld	a5,88(a0)
    80001c94:	63c8                	ld	a0,128(a5)
    80001c96:	b7f5                	j	80001c82 <argraw+0x2c>
    return p->trapframe->a3;
    80001c98:	6d3c                	ld	a5,88(a0)
    80001c9a:	67c8                	ld	a0,136(a5)
    80001c9c:	b7dd                	j	80001c82 <argraw+0x2c>
    return p->trapframe->a4;
    80001c9e:	6d3c                	ld	a5,88(a0)
    80001ca0:	6bc8                	ld	a0,144(a5)
    80001ca2:	b7c5                	j	80001c82 <argraw+0x2c>
    return p->trapframe->a5;
    80001ca4:	6d3c                	ld	a5,88(a0)
    80001ca6:	6fc8                	ld	a0,152(a5)
    80001ca8:	bfe9                	j	80001c82 <argraw+0x2c>
  panic("argraw");
    80001caa:	00005517          	auipc	a0,0x5
    80001cae:	74650513          	addi	a0,a0,1862 # 800073f0 <etext+0x3f0>
    80001cb2:	131030ef          	jal	800055e2 <panic>

0000000080001cb6 <fetchaddr>:
{
    80001cb6:	1101                	addi	sp,sp,-32
    80001cb8:	ec06                	sd	ra,24(sp)
    80001cba:	e822                	sd	s0,16(sp)
    80001cbc:	e426                	sd	s1,8(sp)
    80001cbe:	e04a                	sd	s2,0(sp)
    80001cc0:	1000                	addi	s0,sp,32
    80001cc2:	84aa                	mv	s1,a0
    80001cc4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001cc6:	9c6ff0ef          	jal	80000e8c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001cca:	653c                	ld	a5,72(a0)
    80001ccc:	02f4f663          	bgeu	s1,a5,80001cf8 <fetchaddr+0x42>
    80001cd0:	00848713          	addi	a4,s1,8
    80001cd4:	02e7e463          	bltu	a5,a4,80001cfc <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001cd8:	46a1                	li	a3,8
    80001cda:	8626                	mv	a2,s1
    80001cdc:	85ca                	mv	a1,s2
    80001cde:	6928                	ld	a0,80(a0)
    80001ce0:	de1fe0ef          	jal	80000ac0 <copyin>
    80001ce4:	00a03533          	snez	a0,a0
    80001ce8:	40a00533          	neg	a0,a0
}
    80001cec:	60e2                	ld	ra,24(sp)
    80001cee:	6442                	ld	s0,16(sp)
    80001cf0:	64a2                	ld	s1,8(sp)
    80001cf2:	6902                	ld	s2,0(sp)
    80001cf4:	6105                	addi	sp,sp,32
    80001cf6:	8082                	ret
    return -1;
    80001cf8:	557d                	li	a0,-1
    80001cfa:	bfcd                	j	80001cec <fetchaddr+0x36>
    80001cfc:	557d                	li	a0,-1
    80001cfe:	b7fd                	j	80001cec <fetchaddr+0x36>

0000000080001d00 <fetchstr>:
{
    80001d00:	7179                	addi	sp,sp,-48
    80001d02:	f406                	sd	ra,40(sp)
    80001d04:	f022                	sd	s0,32(sp)
    80001d06:	ec26                	sd	s1,24(sp)
    80001d08:	e84a                	sd	s2,16(sp)
    80001d0a:	e44e                	sd	s3,8(sp)
    80001d0c:	1800                	addi	s0,sp,48
    80001d0e:	892a                	mv	s2,a0
    80001d10:	84ae                	mv	s1,a1
    80001d12:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001d14:	978ff0ef          	jal	80000e8c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001d18:	86ce                	mv	a3,s3
    80001d1a:	864a                	mv	a2,s2
    80001d1c:	85a6                	mv	a1,s1
    80001d1e:	6928                	ld	a0,80(a0)
    80001d20:	e27fe0ef          	jal	80000b46 <copyinstr>
    80001d24:	00054c63          	bltz	a0,80001d3c <fetchstr+0x3c>
  return strlen(buf);
    80001d28:	8526                	mv	a0,s1
    80001d2a:	d94fe0ef          	jal	800002be <strlen>
}
    80001d2e:	70a2                	ld	ra,40(sp)
    80001d30:	7402                	ld	s0,32(sp)
    80001d32:	64e2                	ld	s1,24(sp)
    80001d34:	6942                	ld	s2,16(sp)
    80001d36:	69a2                	ld	s3,8(sp)
    80001d38:	6145                	addi	sp,sp,48
    80001d3a:	8082                	ret
    return -1;
    80001d3c:	557d                	li	a0,-1
    80001d3e:	bfc5                	j	80001d2e <fetchstr+0x2e>

0000000080001d40 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001d40:	1101                	addi	sp,sp,-32
    80001d42:	ec06                	sd	ra,24(sp)
    80001d44:	e822                	sd	s0,16(sp)
    80001d46:	e426                	sd	s1,8(sp)
    80001d48:	1000                	addi	s0,sp,32
    80001d4a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d4c:	f0bff0ef          	jal	80001c56 <argraw>
    80001d50:	c088                	sw	a0,0(s1)
}
    80001d52:	60e2                	ld	ra,24(sp)
    80001d54:	6442                	ld	s0,16(sp)
    80001d56:	64a2                	ld	s1,8(sp)
    80001d58:	6105                	addi	sp,sp,32
    80001d5a:	8082                	ret

0000000080001d5c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001d5c:	1101                	addi	sp,sp,-32
    80001d5e:	ec06                	sd	ra,24(sp)
    80001d60:	e822                	sd	s0,16(sp)
    80001d62:	e426                	sd	s1,8(sp)
    80001d64:	1000                	addi	s0,sp,32
    80001d66:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d68:	eefff0ef          	jal	80001c56 <argraw>
    80001d6c:	e088                	sd	a0,0(s1)
}
    80001d6e:	60e2                	ld	ra,24(sp)
    80001d70:	6442                	ld	s0,16(sp)
    80001d72:	64a2                	ld	s1,8(sp)
    80001d74:	6105                	addi	sp,sp,32
    80001d76:	8082                	ret

0000000080001d78 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001d78:	7179                	addi	sp,sp,-48
    80001d7a:	f406                	sd	ra,40(sp)
    80001d7c:	f022                	sd	s0,32(sp)
    80001d7e:	ec26                	sd	s1,24(sp)
    80001d80:	e84a                	sd	s2,16(sp)
    80001d82:	1800                	addi	s0,sp,48
    80001d84:	84ae                	mv	s1,a1
    80001d86:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001d88:	fd840593          	addi	a1,s0,-40
    80001d8c:	fd1ff0ef          	jal	80001d5c <argaddr>
  return fetchstr(addr, buf, max);
    80001d90:	864a                	mv	a2,s2
    80001d92:	85a6                	mv	a1,s1
    80001d94:	fd843503          	ld	a0,-40(s0)
    80001d98:	f69ff0ef          	jal	80001d00 <fetchstr>
}
    80001d9c:	70a2                	ld	ra,40(sp)
    80001d9e:	7402                	ld	s0,32(sp)
    80001da0:	64e2                	ld	s1,24(sp)
    80001da2:	6942                	ld	s2,16(sp)
    80001da4:	6145                	addi	sp,sp,48
    80001da6:	8082                	ret

0000000080001da8 <syscall>:
[SYS_pgaccess] sys_pgaccess,
};

void
syscall(void)
{
    80001da8:	1101                	addi	sp,sp,-32
    80001daa:	ec06                	sd	ra,24(sp)
    80001dac:	e822                	sd	s0,16(sp)
    80001dae:	e426                	sd	s1,8(sp)
    80001db0:	e04a                	sd	s2,0(sp)
    80001db2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001db4:	8d8ff0ef          	jal	80000e8c <myproc>
    80001db8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001dba:	05853903          	ld	s2,88(a0)
    80001dbe:	0a893783          	ld	a5,168(s2)
    80001dc2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001dc6:	37fd                	addiw	a5,a5,-1
    80001dc8:	4755                	li	a4,21
    80001dca:	00f76f63          	bltu	a4,a5,80001de8 <syscall+0x40>
    80001dce:	00369713          	slli	a4,a3,0x3
    80001dd2:	00006797          	auipc	a5,0x6
    80001dd6:	a2678793          	addi	a5,a5,-1498 # 800077f8 <syscalls>
    80001dda:	97ba                	add	a5,a5,a4
    80001ddc:	639c                	ld	a5,0(a5)
    80001dde:	c789                	beqz	a5,80001de8 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001de0:	9782                	jalr	a5
    80001de2:	06a93823          	sd	a0,112(s2)
    80001de6:	a829                	j	80001e00 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001de8:	15848613          	addi	a2,s1,344
    80001dec:	588c                	lw	a1,48(s1)
    80001dee:	00005517          	auipc	a0,0x5
    80001df2:	60a50513          	addi	a0,a0,1546 # 800073f8 <etext+0x3f8>
    80001df6:	51a030ef          	jal	80005310 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001dfa:	6cbc                	ld	a5,88(s1)
    80001dfc:	577d                	li	a4,-1
    80001dfe:	fbb8                	sd	a4,112(a5)
  }
}
    80001e00:	60e2                	ld	ra,24(sp)
    80001e02:	6442                	ld	s0,16(sp)
    80001e04:	64a2                	ld	s1,8(sp)
    80001e06:	6902                	ld	s2,0(sp)
    80001e08:	6105                	addi	sp,sp,32
    80001e0a:	8082                	ret

0000000080001e0c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001e0c:	1101                	addi	sp,sp,-32
    80001e0e:	ec06                	sd	ra,24(sp)
    80001e10:	e822                	sd	s0,16(sp)
    80001e12:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001e14:	fec40593          	addi	a1,s0,-20
    80001e18:	4501                	li	a0,0
    80001e1a:	f27ff0ef          	jal	80001d40 <argint>
  exit(n);
    80001e1e:	fec42503          	lw	a0,-20(s0)
    80001e22:	f44ff0ef          	jal	80001566 <exit>
  return 0;  // not reached
}
    80001e26:	4501                	li	a0,0
    80001e28:	60e2                	ld	ra,24(sp)
    80001e2a:	6442                	ld	s0,16(sp)
    80001e2c:	6105                	addi	sp,sp,32
    80001e2e:	8082                	ret

0000000080001e30 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001e30:	1141                	addi	sp,sp,-16
    80001e32:	e406                	sd	ra,8(sp)
    80001e34:	e022                	sd	s0,0(sp)
    80001e36:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001e38:	854ff0ef          	jal	80000e8c <myproc>
}
    80001e3c:	5908                	lw	a0,48(a0)
    80001e3e:	60a2                	ld	ra,8(sp)
    80001e40:	6402                	ld	s0,0(sp)
    80001e42:	0141                	addi	sp,sp,16
    80001e44:	8082                	ret

0000000080001e46 <sys_fork>:

uint64
sys_fork(void)
{
    80001e46:	1141                	addi	sp,sp,-16
    80001e48:	e406                	sd	ra,8(sp)
    80001e4a:	e022                	sd	s0,0(sp)
    80001e4c:	0800                	addi	s0,sp,16
  return fork();
    80001e4e:	b64ff0ef          	jal	800011b2 <fork>
}
    80001e52:	60a2                	ld	ra,8(sp)
    80001e54:	6402                	ld	s0,0(sp)
    80001e56:	0141                	addi	sp,sp,16
    80001e58:	8082                	ret

0000000080001e5a <sys_wait>:

uint64
sys_wait(void)
{
    80001e5a:	1101                	addi	sp,sp,-32
    80001e5c:	ec06                	sd	ra,24(sp)
    80001e5e:	e822                	sd	s0,16(sp)
    80001e60:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e62:	fe840593          	addi	a1,s0,-24
    80001e66:	4501                	li	a0,0
    80001e68:	ef5ff0ef          	jal	80001d5c <argaddr>
  return wait(p);
    80001e6c:	fe843503          	ld	a0,-24(s0)
    80001e70:	84dff0ef          	jal	800016bc <wait>
}
    80001e74:	60e2                	ld	ra,24(sp)
    80001e76:	6442                	ld	s0,16(sp)
    80001e78:	6105                	addi	sp,sp,32
    80001e7a:	8082                	ret

0000000080001e7c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e7c:	7179                	addi	sp,sp,-48
    80001e7e:	f406                	sd	ra,40(sp)
    80001e80:	f022                	sd	s0,32(sp)
    80001e82:	ec26                	sd	s1,24(sp)
    80001e84:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e86:	fdc40593          	addi	a1,s0,-36
    80001e8a:	4501                	li	a0,0
    80001e8c:	eb5ff0ef          	jal	80001d40 <argint>
  addr = myproc()->sz;
    80001e90:	ffdfe0ef          	jal	80000e8c <myproc>
    80001e94:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e96:	fdc42503          	lw	a0,-36(s0)
    80001e9a:	ac8ff0ef          	jal	80001162 <growproc>
    80001e9e:	00054863          	bltz	a0,80001eae <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001ea2:	8526                	mv	a0,s1
    80001ea4:	70a2                	ld	ra,40(sp)
    80001ea6:	7402                	ld	s0,32(sp)
    80001ea8:	64e2                	ld	s1,24(sp)
    80001eaa:	6145                	addi	sp,sp,48
    80001eac:	8082                	ret
    return -1;
    80001eae:	54fd                	li	s1,-1
    80001eb0:	bfcd                	j	80001ea2 <sys_sbrk+0x26>

0000000080001eb2 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001eb2:	7139                	addi	sp,sp,-64
    80001eb4:	fc06                	sd	ra,56(sp)
    80001eb6:	f822                	sd	s0,48(sp)
    80001eb8:	f04a                	sd	s2,32(sp)
    80001eba:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001ebc:	fcc40593          	addi	a1,s0,-52
    80001ec0:	4501                	li	a0,0
    80001ec2:	e7fff0ef          	jal	80001d40 <argint>
  if(n < 0)
    80001ec6:	fcc42783          	lw	a5,-52(s0)
    80001eca:	0607c763          	bltz	a5,80001f38 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001ece:	0000e517          	auipc	a0,0xe
    80001ed2:	2a250513          	addi	a0,a0,674 # 80010170 <tickslock>
    80001ed6:	23b030ef          	jal	80005910 <acquire>
  ticks0 = ticks;
    80001eda:	00008917          	auipc	s2,0x8
    80001ede:	42e92903          	lw	s2,1070(s2) # 8000a308 <ticks>
  while(ticks - ticks0 < n){
    80001ee2:	fcc42783          	lw	a5,-52(s0)
    80001ee6:	cf8d                	beqz	a5,80001f20 <sys_sleep+0x6e>
    80001ee8:	f426                	sd	s1,40(sp)
    80001eea:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001eec:	0000e997          	auipc	s3,0xe
    80001ef0:	28498993          	addi	s3,s3,644 # 80010170 <tickslock>
    80001ef4:	00008497          	auipc	s1,0x8
    80001ef8:	41448493          	addi	s1,s1,1044 # 8000a308 <ticks>
    if(killed(myproc())){
    80001efc:	f91fe0ef          	jal	80000e8c <myproc>
    80001f00:	f92ff0ef          	jal	80001692 <killed>
    80001f04:	ed0d                	bnez	a0,80001f3e <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001f06:	85ce                	mv	a1,s3
    80001f08:	8526                	mv	a0,s1
    80001f0a:	d50ff0ef          	jal	8000145a <sleep>
  while(ticks - ticks0 < n){
    80001f0e:	409c                	lw	a5,0(s1)
    80001f10:	412787bb          	subw	a5,a5,s2
    80001f14:	fcc42703          	lw	a4,-52(s0)
    80001f18:	fee7e2e3          	bltu	a5,a4,80001efc <sys_sleep+0x4a>
    80001f1c:	74a2                	ld	s1,40(sp)
    80001f1e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001f20:	0000e517          	auipc	a0,0xe
    80001f24:	25050513          	addi	a0,a0,592 # 80010170 <tickslock>
    80001f28:	281030ef          	jal	800059a8 <release>
  return 0;
    80001f2c:	4501                	li	a0,0
}
    80001f2e:	70e2                	ld	ra,56(sp)
    80001f30:	7442                	ld	s0,48(sp)
    80001f32:	7902                	ld	s2,32(sp)
    80001f34:	6121                	addi	sp,sp,64
    80001f36:	8082                	ret
    n = 0;
    80001f38:	fc042623          	sw	zero,-52(s0)
    80001f3c:	bf49                	j	80001ece <sys_sleep+0x1c>
      release(&tickslock);
    80001f3e:	0000e517          	auipc	a0,0xe
    80001f42:	23250513          	addi	a0,a0,562 # 80010170 <tickslock>
    80001f46:	263030ef          	jal	800059a8 <release>
      return -1;
    80001f4a:	557d                	li	a0,-1
    80001f4c:	74a2                	ld	s1,40(sp)
    80001f4e:	69e2                	ld	s3,24(sp)
    80001f50:	bff9                	j	80001f2e <sys_sleep+0x7c>

0000000080001f52 <sys_kill>:

uint64
sys_kill(void)
{
    80001f52:	1101                	addi	sp,sp,-32
    80001f54:	ec06                	sd	ra,24(sp)
    80001f56:	e822                	sd	s0,16(sp)
    80001f58:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f5a:	fec40593          	addi	a1,s0,-20
    80001f5e:	4501                	li	a0,0
    80001f60:	de1ff0ef          	jal	80001d40 <argint>
  return kill(pid);
    80001f64:	fec42503          	lw	a0,-20(s0)
    80001f68:	ea0ff0ef          	jal	80001608 <kill>
}
    80001f6c:	60e2                	ld	ra,24(sp)
    80001f6e:	6442                	ld	s0,16(sp)
    80001f70:	6105                	addi	sp,sp,32
    80001f72:	8082                	ret

0000000080001f74 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f74:	1101                	addi	sp,sp,-32
    80001f76:	ec06                	sd	ra,24(sp)
    80001f78:	e822                	sd	s0,16(sp)
    80001f7a:	e426                	sd	s1,8(sp)
    80001f7c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f7e:	0000e517          	auipc	a0,0xe
    80001f82:	1f250513          	addi	a0,a0,498 # 80010170 <tickslock>
    80001f86:	18b030ef          	jal	80005910 <acquire>
  xticks = ticks;
    80001f8a:	00008497          	auipc	s1,0x8
    80001f8e:	37e4a483          	lw	s1,894(s1) # 8000a308 <ticks>
  release(&tickslock);
    80001f92:	0000e517          	auipc	a0,0xe
    80001f96:	1de50513          	addi	a0,a0,478 # 80010170 <tickslock>
    80001f9a:	20f030ef          	jal	800059a8 <release>
  return xticks;
}
    80001f9e:	02049513          	slli	a0,s1,0x20
    80001fa2:	9101                	srli	a0,a0,0x20
    80001fa4:	60e2                	ld	ra,24(sp)
    80001fa6:	6442                	ld	s0,16(sp)
    80001fa8:	64a2                	ld	s1,8(sp)
    80001faa:	6105                	addi	sp,sp,32
    80001fac:	8082                	ret

0000000080001fae <sys_pgaccess>:
uint64
sys_pgaccess(void)
{
    80001fae:	715d                	addi	sp,sp,-80
    80001fb0:	e486                	sd	ra,72(sp)
    80001fb2:	e0a2                	sd	s0,64(sp)
    80001fb4:	0880                	addi	s0,sp,80
  uint64 va;
  int n;
  uint64 ubuf;
  uint64 bitmask;

  argaddr(0, &va);
    80001fb6:	fc840593          	addi	a1,s0,-56
    80001fba:	4501                	li	a0,0
    80001fbc:	da1ff0ef          	jal	80001d5c <argaddr>
  argint(1, &n);
    80001fc0:	fc440593          	addi	a1,s0,-60
    80001fc4:	4505                	li	a0,1
    80001fc6:	d7bff0ef          	jal	80001d40 <argint>
  argaddr(2, &ubuf);
    80001fca:	fb840593          	addi	a1,s0,-72
    80001fce:	4509                	li	a0,2
    80001fd0:	d8dff0ef          	jal	80001d5c <argaddr>

  if(n > 64) return -1;
    80001fd4:	fc442703          	lw	a4,-60(s0)
    80001fd8:	04000793          	li	a5,64
    80001fdc:	557d                	li	a0,-1
    80001fde:	08e7c063          	blt	a5,a4,8000205e <sys_pgaccess+0xb0>
    80001fe2:	f84a                	sd	s2,48(sp)

  bitmask = 0;
    80001fe4:	fa043823          	sd	zero,-80(s0)

  struct proc *p = myproc();
    80001fe8:	ea5fe0ef          	jal	80000e8c <myproc>
    80001fec:	892a                	mv	s2,a0

  for(int i = 0; i < n; i++){
    80001fee:	fc442783          	lw	a5,-60(s0)
    80001ff2:	04f05b63          	blez	a5,80002048 <sys_pgaccess+0x9a>
    80001ff6:	fc26                	sd	s1,56(sp)
    80001ff8:	f44e                	sd	s3,40(sp)
    80001ffa:	4481                	li	s1,0
    pte_t *pte = walk(p->pagetable, page_va, 0);

    if(pte == 0) continue;

    if(*pte & PTE_A){
      bitmask |= (1L << i);
    80001ffc:	4985                	li	s3,1
    80001ffe:	a801                	j	8000200e <sys_pgaccess+0x60>
  for(int i = 0; i < n; i++){
    80002000:	0485                	addi	s1,s1,1
    80002002:	fc442703          	lw	a4,-60(s0)
    80002006:	0004879b          	sext.w	a5,s1
    8000200a:	02e7dd63          	bge	a5,a4,80002044 <sys_pgaccess+0x96>
    uint64 page_va = va + (uint64)i * PGSIZE;
    8000200e:	00c49593          	slli	a1,s1,0xc
    pte_t *pte = walk(p->pagetable, page_va, 0);
    80002012:	4601                	li	a2,0
    80002014:	fc843783          	ld	a5,-56(s0)
    80002018:	95be                	add	a1,a1,a5
    8000201a:	05093503          	ld	a0,80(s2)
    8000201e:	ba4fe0ef          	jal	800003c2 <walk>
    if(pte == 0) continue;
    80002022:	dd79                	beqz	a0,80002000 <sys_pgaccess+0x52>
    if(*pte & PTE_A){
    80002024:	611c                	ld	a5,0(a0)
    80002026:	0407f793          	andi	a5,a5,64
    8000202a:	dbf9                	beqz	a5,80002000 <sys_pgaccess+0x52>
      bitmask |= (1L << i);
    8000202c:	00999733          	sll	a4,s3,s1
    80002030:	fb043783          	ld	a5,-80(s0)
    80002034:	8fd9                	or	a5,a5,a4
    80002036:	faf43823          	sd	a5,-80(s0)
      *pte &= ~PTE_A;
    8000203a:	611c                	ld	a5,0(a0)
    8000203c:	fbf7f793          	andi	a5,a5,-65
    80002040:	e11c                	sd	a5,0(a0)
    80002042:	bf7d                	j	80002000 <sys_pgaccess+0x52>
    80002044:	74e2                	ld	s1,56(sp)
    80002046:	79a2                	ld	s3,40(sp)
    }
  }

  if(copyout(p->pagetable, ubuf,(char*)&bitmask, sizeof(bitmask)) < 0)
    80002048:	46a1                	li	a3,8
    8000204a:	fb040613          	addi	a2,s0,-80
    8000204e:	fb843583          	ld	a1,-72(s0)
    80002052:	05093503          	ld	a0,80(s2)
    80002056:	993fe0ef          	jal	800009e8 <copyout>
    8000205a:	957d                	srai	a0,a0,0x3f
    8000205c:	7942                	ld	s2,48(sp)
    return -1;

  return 0;
}
    8000205e:	60a6                	ld	ra,72(sp)
    80002060:	6406                	ld	s0,64(sp)
    80002062:	6161                	addi	sp,sp,80
    80002064:	8082                	ret

0000000080002066 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002066:	7179                	addi	sp,sp,-48
    80002068:	f406                	sd	ra,40(sp)
    8000206a:	f022                	sd	s0,32(sp)
    8000206c:	ec26                	sd	s1,24(sp)
    8000206e:	e84a                	sd	s2,16(sp)
    80002070:	e44e                	sd	s3,8(sp)
    80002072:	e052                	sd	s4,0(sp)
    80002074:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002076:	00005597          	auipc	a1,0x5
    8000207a:	3a258593          	addi	a1,a1,930 # 80007418 <etext+0x418>
    8000207e:	0000e517          	auipc	a0,0xe
    80002082:	10a50513          	addi	a0,a0,266 # 80010188 <bcache>
    80002086:	00b030ef          	jal	80005890 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000208a:	00016797          	auipc	a5,0x16
    8000208e:	0fe78793          	addi	a5,a5,254 # 80018188 <bcache+0x8000>
    80002092:	00016717          	auipc	a4,0x16
    80002096:	35e70713          	addi	a4,a4,862 # 800183f0 <bcache+0x8268>
    8000209a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000209e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020a2:	0000e497          	auipc	s1,0xe
    800020a6:	0fe48493          	addi	s1,s1,254 # 800101a0 <bcache+0x18>
    b->next = bcache.head.next;
    800020aa:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800020ac:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800020ae:	00005a17          	auipc	s4,0x5
    800020b2:	372a0a13          	addi	s4,s4,882 # 80007420 <etext+0x420>
    b->next = bcache.head.next;
    800020b6:	2b893783          	ld	a5,696(s2)
    800020ba:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800020bc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800020c0:	85d2                	mv	a1,s4
    800020c2:	01048513          	addi	a0,s1,16
    800020c6:	248010ef          	jal	8000330e <initsleeplock>
    bcache.head.next->prev = b;
    800020ca:	2b893783          	ld	a5,696(s2)
    800020ce:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800020d0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020d4:	45848493          	addi	s1,s1,1112
    800020d8:	fd349fe3          	bne	s1,s3,800020b6 <binit+0x50>
  }
}
    800020dc:	70a2                	ld	ra,40(sp)
    800020de:	7402                	ld	s0,32(sp)
    800020e0:	64e2                	ld	s1,24(sp)
    800020e2:	6942                	ld	s2,16(sp)
    800020e4:	69a2                	ld	s3,8(sp)
    800020e6:	6a02                	ld	s4,0(sp)
    800020e8:	6145                	addi	sp,sp,48
    800020ea:	8082                	ret

00000000800020ec <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800020ec:	7179                	addi	sp,sp,-48
    800020ee:	f406                	sd	ra,40(sp)
    800020f0:	f022                	sd	s0,32(sp)
    800020f2:	ec26                	sd	s1,24(sp)
    800020f4:	e84a                	sd	s2,16(sp)
    800020f6:	e44e                	sd	s3,8(sp)
    800020f8:	1800                	addi	s0,sp,48
    800020fa:	892a                	mv	s2,a0
    800020fc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800020fe:	0000e517          	auipc	a0,0xe
    80002102:	08a50513          	addi	a0,a0,138 # 80010188 <bcache>
    80002106:	00b030ef          	jal	80005910 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000210a:	00016497          	auipc	s1,0x16
    8000210e:	3364b483          	ld	s1,822(s1) # 80018440 <bcache+0x82b8>
    80002112:	00016797          	auipc	a5,0x16
    80002116:	2de78793          	addi	a5,a5,734 # 800183f0 <bcache+0x8268>
    8000211a:	02f48b63          	beq	s1,a5,80002150 <bread+0x64>
    8000211e:	873e                	mv	a4,a5
    80002120:	a021                	j	80002128 <bread+0x3c>
    80002122:	68a4                	ld	s1,80(s1)
    80002124:	02e48663          	beq	s1,a4,80002150 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002128:	449c                	lw	a5,8(s1)
    8000212a:	ff279ce3          	bne	a5,s2,80002122 <bread+0x36>
    8000212e:	44dc                	lw	a5,12(s1)
    80002130:	ff3799e3          	bne	a5,s3,80002122 <bread+0x36>
      b->refcnt++;
    80002134:	40bc                	lw	a5,64(s1)
    80002136:	2785                	addiw	a5,a5,1
    80002138:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000213a:	0000e517          	auipc	a0,0xe
    8000213e:	04e50513          	addi	a0,a0,78 # 80010188 <bcache>
    80002142:	067030ef          	jal	800059a8 <release>
      acquiresleep(&b->lock);
    80002146:	01048513          	addi	a0,s1,16
    8000214a:	1fa010ef          	jal	80003344 <acquiresleep>
      return b;
    8000214e:	a889                	j	800021a0 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002150:	00016497          	auipc	s1,0x16
    80002154:	2e84b483          	ld	s1,744(s1) # 80018438 <bcache+0x82b0>
    80002158:	00016797          	auipc	a5,0x16
    8000215c:	29878793          	addi	a5,a5,664 # 800183f0 <bcache+0x8268>
    80002160:	00f48863          	beq	s1,a5,80002170 <bread+0x84>
    80002164:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002166:	40bc                	lw	a5,64(s1)
    80002168:	cb91                	beqz	a5,8000217c <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000216a:	64a4                	ld	s1,72(s1)
    8000216c:	fee49de3          	bne	s1,a4,80002166 <bread+0x7a>
  panic("bget: no buffers");
    80002170:	00005517          	auipc	a0,0x5
    80002174:	2b850513          	addi	a0,a0,696 # 80007428 <etext+0x428>
    80002178:	46a030ef          	jal	800055e2 <panic>
      b->dev = dev;
    8000217c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002180:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002184:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002188:	4785                	li	a5,1
    8000218a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000218c:	0000e517          	auipc	a0,0xe
    80002190:	ffc50513          	addi	a0,a0,-4 # 80010188 <bcache>
    80002194:	015030ef          	jal	800059a8 <release>
      acquiresleep(&b->lock);
    80002198:	01048513          	addi	a0,s1,16
    8000219c:	1a8010ef          	jal	80003344 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800021a0:	409c                	lw	a5,0(s1)
    800021a2:	cb89                	beqz	a5,800021b4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800021a4:	8526                	mv	a0,s1
    800021a6:	70a2                	ld	ra,40(sp)
    800021a8:	7402                	ld	s0,32(sp)
    800021aa:	64e2                	ld	s1,24(sp)
    800021ac:	6942                	ld	s2,16(sp)
    800021ae:	69a2                	ld	s3,8(sp)
    800021b0:	6145                	addi	sp,sp,48
    800021b2:	8082                	ret
    virtio_disk_rw(b, 0);
    800021b4:	4581                	li	a1,0
    800021b6:	8526                	mv	a0,s1
    800021b8:	1f9020ef          	jal	80004bb0 <virtio_disk_rw>
    b->valid = 1;
    800021bc:	4785                	li	a5,1
    800021be:	c09c                	sw	a5,0(s1)
  return b;
    800021c0:	b7d5                	j	800021a4 <bread+0xb8>

00000000800021c2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800021c2:	1101                	addi	sp,sp,-32
    800021c4:	ec06                	sd	ra,24(sp)
    800021c6:	e822                	sd	s0,16(sp)
    800021c8:	e426                	sd	s1,8(sp)
    800021ca:	1000                	addi	s0,sp,32
    800021cc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021ce:	0541                	addi	a0,a0,16
    800021d0:	1f2010ef          	jal	800033c2 <holdingsleep>
    800021d4:	c911                	beqz	a0,800021e8 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800021d6:	4585                	li	a1,1
    800021d8:	8526                	mv	a0,s1
    800021da:	1d7020ef          	jal	80004bb0 <virtio_disk_rw>
}
    800021de:	60e2                	ld	ra,24(sp)
    800021e0:	6442                	ld	s0,16(sp)
    800021e2:	64a2                	ld	s1,8(sp)
    800021e4:	6105                	addi	sp,sp,32
    800021e6:	8082                	ret
    panic("bwrite");
    800021e8:	00005517          	auipc	a0,0x5
    800021ec:	25850513          	addi	a0,a0,600 # 80007440 <etext+0x440>
    800021f0:	3f2030ef          	jal	800055e2 <panic>

00000000800021f4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800021f4:	1101                	addi	sp,sp,-32
    800021f6:	ec06                	sd	ra,24(sp)
    800021f8:	e822                	sd	s0,16(sp)
    800021fa:	e426                	sd	s1,8(sp)
    800021fc:	e04a                	sd	s2,0(sp)
    800021fe:	1000                	addi	s0,sp,32
    80002200:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002202:	01050913          	addi	s2,a0,16
    80002206:	854a                	mv	a0,s2
    80002208:	1ba010ef          	jal	800033c2 <holdingsleep>
    8000220c:	c135                	beqz	a0,80002270 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000220e:	854a                	mv	a0,s2
    80002210:	17a010ef          	jal	8000338a <releasesleep>

  acquire(&bcache.lock);
    80002214:	0000e517          	auipc	a0,0xe
    80002218:	f7450513          	addi	a0,a0,-140 # 80010188 <bcache>
    8000221c:	6f4030ef          	jal	80005910 <acquire>
  b->refcnt--;
    80002220:	40bc                	lw	a5,64(s1)
    80002222:	37fd                	addiw	a5,a5,-1
    80002224:	0007871b          	sext.w	a4,a5
    80002228:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000222a:	e71d                	bnez	a4,80002258 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000222c:	68b8                	ld	a4,80(s1)
    8000222e:	64bc                	ld	a5,72(s1)
    80002230:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002232:	68b8                	ld	a4,80(s1)
    80002234:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002236:	00016797          	auipc	a5,0x16
    8000223a:	f5278793          	addi	a5,a5,-174 # 80018188 <bcache+0x8000>
    8000223e:	2b87b703          	ld	a4,696(a5)
    80002242:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002244:	00016717          	auipc	a4,0x16
    80002248:	1ac70713          	addi	a4,a4,428 # 800183f0 <bcache+0x8268>
    8000224c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000224e:	2b87b703          	ld	a4,696(a5)
    80002252:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002254:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002258:	0000e517          	auipc	a0,0xe
    8000225c:	f3050513          	addi	a0,a0,-208 # 80010188 <bcache>
    80002260:	748030ef          	jal	800059a8 <release>
}
    80002264:	60e2                	ld	ra,24(sp)
    80002266:	6442                	ld	s0,16(sp)
    80002268:	64a2                	ld	s1,8(sp)
    8000226a:	6902                	ld	s2,0(sp)
    8000226c:	6105                	addi	sp,sp,32
    8000226e:	8082                	ret
    panic("brelse");
    80002270:	00005517          	auipc	a0,0x5
    80002274:	1d850513          	addi	a0,a0,472 # 80007448 <etext+0x448>
    80002278:	36a030ef          	jal	800055e2 <panic>

000000008000227c <bpin>:

void
bpin(struct buf *b) {
    8000227c:	1101                	addi	sp,sp,-32
    8000227e:	ec06                	sd	ra,24(sp)
    80002280:	e822                	sd	s0,16(sp)
    80002282:	e426                	sd	s1,8(sp)
    80002284:	1000                	addi	s0,sp,32
    80002286:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002288:	0000e517          	auipc	a0,0xe
    8000228c:	f0050513          	addi	a0,a0,-256 # 80010188 <bcache>
    80002290:	680030ef          	jal	80005910 <acquire>
  b->refcnt++;
    80002294:	40bc                	lw	a5,64(s1)
    80002296:	2785                	addiw	a5,a5,1
    80002298:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000229a:	0000e517          	auipc	a0,0xe
    8000229e:	eee50513          	addi	a0,a0,-274 # 80010188 <bcache>
    800022a2:	706030ef          	jal	800059a8 <release>
}
    800022a6:	60e2                	ld	ra,24(sp)
    800022a8:	6442                	ld	s0,16(sp)
    800022aa:	64a2                	ld	s1,8(sp)
    800022ac:	6105                	addi	sp,sp,32
    800022ae:	8082                	ret

00000000800022b0 <bunpin>:

void
bunpin(struct buf *b) {
    800022b0:	1101                	addi	sp,sp,-32
    800022b2:	ec06                	sd	ra,24(sp)
    800022b4:	e822                	sd	s0,16(sp)
    800022b6:	e426                	sd	s1,8(sp)
    800022b8:	1000                	addi	s0,sp,32
    800022ba:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800022bc:	0000e517          	auipc	a0,0xe
    800022c0:	ecc50513          	addi	a0,a0,-308 # 80010188 <bcache>
    800022c4:	64c030ef          	jal	80005910 <acquire>
  b->refcnt--;
    800022c8:	40bc                	lw	a5,64(s1)
    800022ca:	37fd                	addiw	a5,a5,-1
    800022cc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800022ce:	0000e517          	auipc	a0,0xe
    800022d2:	eba50513          	addi	a0,a0,-326 # 80010188 <bcache>
    800022d6:	6d2030ef          	jal	800059a8 <release>
}
    800022da:	60e2                	ld	ra,24(sp)
    800022dc:	6442                	ld	s0,16(sp)
    800022de:	64a2                	ld	s1,8(sp)
    800022e0:	6105                	addi	sp,sp,32
    800022e2:	8082                	ret

00000000800022e4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800022e4:	1101                	addi	sp,sp,-32
    800022e6:	ec06                	sd	ra,24(sp)
    800022e8:	e822                	sd	s0,16(sp)
    800022ea:	e426                	sd	s1,8(sp)
    800022ec:	e04a                	sd	s2,0(sp)
    800022ee:	1000                	addi	s0,sp,32
    800022f0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800022f2:	00d5d59b          	srliw	a1,a1,0xd
    800022f6:	00016797          	auipc	a5,0x16
    800022fa:	56e7a783          	lw	a5,1390(a5) # 80018864 <sb+0x1c>
    800022fe:	9dbd                	addw	a1,a1,a5
    80002300:	dedff0ef          	jal	800020ec <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002304:	0074f713          	andi	a4,s1,7
    80002308:	4785                	li	a5,1
    8000230a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000230e:	14ce                	slli	s1,s1,0x33
    80002310:	90d9                	srli	s1,s1,0x36
    80002312:	00950733          	add	a4,a0,s1
    80002316:	05874703          	lbu	a4,88(a4)
    8000231a:	00e7f6b3          	and	a3,a5,a4
    8000231e:	c29d                	beqz	a3,80002344 <bfree+0x60>
    80002320:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002322:	94aa                	add	s1,s1,a0
    80002324:	fff7c793          	not	a5,a5
    80002328:	8f7d                	and	a4,a4,a5
    8000232a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000232e:	711000ef          	jal	8000323e <log_write>
  brelse(bp);
    80002332:	854a                	mv	a0,s2
    80002334:	ec1ff0ef          	jal	800021f4 <brelse>
}
    80002338:	60e2                	ld	ra,24(sp)
    8000233a:	6442                	ld	s0,16(sp)
    8000233c:	64a2                	ld	s1,8(sp)
    8000233e:	6902                	ld	s2,0(sp)
    80002340:	6105                	addi	sp,sp,32
    80002342:	8082                	ret
    panic("freeing free block");
    80002344:	00005517          	auipc	a0,0x5
    80002348:	10c50513          	addi	a0,a0,268 # 80007450 <etext+0x450>
    8000234c:	296030ef          	jal	800055e2 <panic>

0000000080002350 <balloc>:
{
    80002350:	711d                	addi	sp,sp,-96
    80002352:	ec86                	sd	ra,88(sp)
    80002354:	e8a2                	sd	s0,80(sp)
    80002356:	e4a6                	sd	s1,72(sp)
    80002358:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000235a:	00016797          	auipc	a5,0x16
    8000235e:	4f27a783          	lw	a5,1266(a5) # 8001884c <sb+0x4>
    80002362:	0e078f63          	beqz	a5,80002460 <balloc+0x110>
    80002366:	e0ca                	sd	s2,64(sp)
    80002368:	fc4e                	sd	s3,56(sp)
    8000236a:	f852                	sd	s4,48(sp)
    8000236c:	f456                	sd	s5,40(sp)
    8000236e:	f05a                	sd	s6,32(sp)
    80002370:	ec5e                	sd	s7,24(sp)
    80002372:	e862                	sd	s8,16(sp)
    80002374:	e466                	sd	s9,8(sp)
    80002376:	8baa                	mv	s7,a0
    80002378:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000237a:	00016b17          	auipc	s6,0x16
    8000237e:	4ceb0b13          	addi	s6,s6,1230 # 80018848 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002382:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002384:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002386:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002388:	6c89                	lui	s9,0x2
    8000238a:	a0b5                	j	800023f6 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000238c:	97ca                	add	a5,a5,s2
    8000238e:	8e55                	or	a2,a2,a3
    80002390:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002394:	854a                	mv	a0,s2
    80002396:	6a9000ef          	jal	8000323e <log_write>
        brelse(bp);
    8000239a:	854a                	mv	a0,s2
    8000239c:	e59ff0ef          	jal	800021f4 <brelse>
  bp = bread(dev, bno);
    800023a0:	85a6                	mv	a1,s1
    800023a2:	855e                	mv	a0,s7
    800023a4:	d49ff0ef          	jal	800020ec <bread>
    800023a8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800023aa:	40000613          	li	a2,1024
    800023ae:	4581                	li	a1,0
    800023b0:	05850513          	addi	a0,a0,88
    800023b4:	d9bfd0ef          	jal	8000014e <memset>
  log_write(bp);
    800023b8:	854a                	mv	a0,s2
    800023ba:	685000ef          	jal	8000323e <log_write>
  brelse(bp);
    800023be:	854a                	mv	a0,s2
    800023c0:	e35ff0ef          	jal	800021f4 <brelse>
}
    800023c4:	6906                	ld	s2,64(sp)
    800023c6:	79e2                	ld	s3,56(sp)
    800023c8:	7a42                	ld	s4,48(sp)
    800023ca:	7aa2                	ld	s5,40(sp)
    800023cc:	7b02                	ld	s6,32(sp)
    800023ce:	6be2                	ld	s7,24(sp)
    800023d0:	6c42                	ld	s8,16(sp)
    800023d2:	6ca2                	ld	s9,8(sp)
}
    800023d4:	8526                	mv	a0,s1
    800023d6:	60e6                	ld	ra,88(sp)
    800023d8:	6446                	ld	s0,80(sp)
    800023da:	64a6                	ld	s1,72(sp)
    800023dc:	6125                	addi	sp,sp,96
    800023de:	8082                	ret
    brelse(bp);
    800023e0:	854a                	mv	a0,s2
    800023e2:	e13ff0ef          	jal	800021f4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800023e6:	015c87bb          	addw	a5,s9,s5
    800023ea:	00078a9b          	sext.w	s5,a5
    800023ee:	004b2703          	lw	a4,4(s6)
    800023f2:	04eaff63          	bgeu	s5,a4,80002450 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800023f6:	41fad79b          	sraiw	a5,s5,0x1f
    800023fa:	0137d79b          	srliw	a5,a5,0x13
    800023fe:	015787bb          	addw	a5,a5,s5
    80002402:	40d7d79b          	sraiw	a5,a5,0xd
    80002406:	01cb2583          	lw	a1,28(s6)
    8000240a:	9dbd                	addw	a1,a1,a5
    8000240c:	855e                	mv	a0,s7
    8000240e:	cdfff0ef          	jal	800020ec <bread>
    80002412:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002414:	004b2503          	lw	a0,4(s6)
    80002418:	000a849b          	sext.w	s1,s5
    8000241c:	8762                	mv	a4,s8
    8000241e:	fca4f1e3          	bgeu	s1,a0,800023e0 <balloc+0x90>
      m = 1 << (bi % 8);
    80002422:	00777693          	andi	a3,a4,7
    80002426:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000242a:	41f7579b          	sraiw	a5,a4,0x1f
    8000242e:	01d7d79b          	srliw	a5,a5,0x1d
    80002432:	9fb9                	addw	a5,a5,a4
    80002434:	4037d79b          	sraiw	a5,a5,0x3
    80002438:	00f90633          	add	a2,s2,a5
    8000243c:	05864603          	lbu	a2,88(a2)
    80002440:	00c6f5b3          	and	a1,a3,a2
    80002444:	d5a1                	beqz	a1,8000238c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002446:	2705                	addiw	a4,a4,1
    80002448:	2485                	addiw	s1,s1,1
    8000244a:	fd471ae3          	bne	a4,s4,8000241e <balloc+0xce>
    8000244e:	bf49                	j	800023e0 <balloc+0x90>
    80002450:	6906                	ld	s2,64(sp)
    80002452:	79e2                	ld	s3,56(sp)
    80002454:	7a42                	ld	s4,48(sp)
    80002456:	7aa2                	ld	s5,40(sp)
    80002458:	7b02                	ld	s6,32(sp)
    8000245a:	6be2                	ld	s7,24(sp)
    8000245c:	6c42                	ld	s8,16(sp)
    8000245e:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002460:	00005517          	auipc	a0,0x5
    80002464:	00850513          	addi	a0,a0,8 # 80007468 <etext+0x468>
    80002468:	6a9020ef          	jal	80005310 <printf>
  return 0;
    8000246c:	4481                	li	s1,0
    8000246e:	b79d                	j	800023d4 <balloc+0x84>

0000000080002470 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002470:	7179                	addi	sp,sp,-48
    80002472:	f406                	sd	ra,40(sp)
    80002474:	f022                	sd	s0,32(sp)
    80002476:	ec26                	sd	s1,24(sp)
    80002478:	e84a                	sd	s2,16(sp)
    8000247a:	e44e                	sd	s3,8(sp)
    8000247c:	1800                	addi	s0,sp,48
    8000247e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002480:	47ad                	li	a5,11
    80002482:	02b7e663          	bltu	a5,a1,800024ae <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002486:	02059793          	slli	a5,a1,0x20
    8000248a:	01e7d593          	srli	a1,a5,0x1e
    8000248e:	00b504b3          	add	s1,a0,a1
    80002492:	0504a903          	lw	s2,80(s1)
    80002496:	06091a63          	bnez	s2,8000250a <bmap+0x9a>
      addr = balloc(ip->dev);
    8000249a:	4108                	lw	a0,0(a0)
    8000249c:	eb5ff0ef          	jal	80002350 <balloc>
    800024a0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800024a4:	06090363          	beqz	s2,8000250a <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800024a8:	0524a823          	sw	s2,80(s1)
    800024ac:	a8b9                	j	8000250a <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800024ae:	ff45849b          	addiw	s1,a1,-12
    800024b2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800024b6:	0ff00793          	li	a5,255
    800024ba:	06e7ee63          	bltu	a5,a4,80002536 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800024be:	08052903          	lw	s2,128(a0)
    800024c2:	00091d63          	bnez	s2,800024dc <bmap+0x6c>
      addr = balloc(ip->dev);
    800024c6:	4108                	lw	a0,0(a0)
    800024c8:	e89ff0ef          	jal	80002350 <balloc>
    800024cc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800024d0:	02090d63          	beqz	s2,8000250a <bmap+0x9a>
    800024d4:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800024d6:	0929a023          	sw	s2,128(s3)
    800024da:	a011                	j	800024de <bmap+0x6e>
    800024dc:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800024de:	85ca                	mv	a1,s2
    800024e0:	0009a503          	lw	a0,0(s3)
    800024e4:	c09ff0ef          	jal	800020ec <bread>
    800024e8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800024ea:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800024ee:	02049713          	slli	a4,s1,0x20
    800024f2:	01e75593          	srli	a1,a4,0x1e
    800024f6:	00b784b3          	add	s1,a5,a1
    800024fa:	0004a903          	lw	s2,0(s1)
    800024fe:	00090e63          	beqz	s2,8000251a <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002502:	8552                	mv	a0,s4
    80002504:	cf1ff0ef          	jal	800021f4 <brelse>
    return addr;
    80002508:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000250a:	854a                	mv	a0,s2
    8000250c:	70a2                	ld	ra,40(sp)
    8000250e:	7402                	ld	s0,32(sp)
    80002510:	64e2                	ld	s1,24(sp)
    80002512:	6942                	ld	s2,16(sp)
    80002514:	69a2                	ld	s3,8(sp)
    80002516:	6145                	addi	sp,sp,48
    80002518:	8082                	ret
      addr = balloc(ip->dev);
    8000251a:	0009a503          	lw	a0,0(s3)
    8000251e:	e33ff0ef          	jal	80002350 <balloc>
    80002522:	0005091b          	sext.w	s2,a0
      if(addr){
    80002526:	fc090ee3          	beqz	s2,80002502 <bmap+0x92>
        a[bn] = addr;
    8000252a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000252e:	8552                	mv	a0,s4
    80002530:	50f000ef          	jal	8000323e <log_write>
    80002534:	b7f9                	j	80002502 <bmap+0x92>
    80002536:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002538:	00005517          	auipc	a0,0x5
    8000253c:	f4850513          	addi	a0,a0,-184 # 80007480 <etext+0x480>
    80002540:	0a2030ef          	jal	800055e2 <panic>

0000000080002544 <iget>:
{
    80002544:	7179                	addi	sp,sp,-48
    80002546:	f406                	sd	ra,40(sp)
    80002548:	f022                	sd	s0,32(sp)
    8000254a:	ec26                	sd	s1,24(sp)
    8000254c:	e84a                	sd	s2,16(sp)
    8000254e:	e44e                	sd	s3,8(sp)
    80002550:	e052                	sd	s4,0(sp)
    80002552:	1800                	addi	s0,sp,48
    80002554:	89aa                	mv	s3,a0
    80002556:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002558:	00016517          	auipc	a0,0x16
    8000255c:	31050513          	addi	a0,a0,784 # 80018868 <itable>
    80002560:	3b0030ef          	jal	80005910 <acquire>
  empty = 0;
    80002564:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002566:	00016497          	auipc	s1,0x16
    8000256a:	31a48493          	addi	s1,s1,794 # 80018880 <itable+0x18>
    8000256e:	00018697          	auipc	a3,0x18
    80002572:	da268693          	addi	a3,a3,-606 # 8001a310 <log>
    80002576:	a039                	j	80002584 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002578:	02090963          	beqz	s2,800025aa <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000257c:	08848493          	addi	s1,s1,136
    80002580:	02d48863          	beq	s1,a3,800025b0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002584:	449c                	lw	a5,8(s1)
    80002586:	fef059e3          	blez	a5,80002578 <iget+0x34>
    8000258a:	4098                	lw	a4,0(s1)
    8000258c:	ff3716e3          	bne	a4,s3,80002578 <iget+0x34>
    80002590:	40d8                	lw	a4,4(s1)
    80002592:	ff4713e3          	bne	a4,s4,80002578 <iget+0x34>
      ip->ref++;
    80002596:	2785                	addiw	a5,a5,1
    80002598:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000259a:	00016517          	auipc	a0,0x16
    8000259e:	2ce50513          	addi	a0,a0,718 # 80018868 <itable>
    800025a2:	406030ef          	jal	800059a8 <release>
      return ip;
    800025a6:	8926                	mv	s2,s1
    800025a8:	a02d                	j	800025d2 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800025aa:	fbe9                	bnez	a5,8000257c <iget+0x38>
      empty = ip;
    800025ac:	8926                	mv	s2,s1
    800025ae:	b7f9                	j	8000257c <iget+0x38>
  if(empty == 0)
    800025b0:	02090a63          	beqz	s2,800025e4 <iget+0xa0>
  ip->dev = dev;
    800025b4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800025b8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800025bc:	4785                	li	a5,1
    800025be:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800025c2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800025c6:	00016517          	auipc	a0,0x16
    800025ca:	2a250513          	addi	a0,a0,674 # 80018868 <itable>
    800025ce:	3da030ef          	jal	800059a8 <release>
}
    800025d2:	854a                	mv	a0,s2
    800025d4:	70a2                	ld	ra,40(sp)
    800025d6:	7402                	ld	s0,32(sp)
    800025d8:	64e2                	ld	s1,24(sp)
    800025da:	6942                	ld	s2,16(sp)
    800025dc:	69a2                	ld	s3,8(sp)
    800025de:	6a02                	ld	s4,0(sp)
    800025e0:	6145                	addi	sp,sp,48
    800025e2:	8082                	ret
    panic("iget: no inodes");
    800025e4:	00005517          	auipc	a0,0x5
    800025e8:	eb450513          	addi	a0,a0,-332 # 80007498 <etext+0x498>
    800025ec:	7f7020ef          	jal	800055e2 <panic>

00000000800025f0 <fsinit>:
fsinit(int dev) {
    800025f0:	7179                	addi	sp,sp,-48
    800025f2:	f406                	sd	ra,40(sp)
    800025f4:	f022                	sd	s0,32(sp)
    800025f6:	ec26                	sd	s1,24(sp)
    800025f8:	e84a                	sd	s2,16(sp)
    800025fa:	e44e                	sd	s3,8(sp)
    800025fc:	1800                	addi	s0,sp,48
    800025fe:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002600:	4585                	li	a1,1
    80002602:	aebff0ef          	jal	800020ec <bread>
    80002606:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002608:	00016997          	auipc	s3,0x16
    8000260c:	24098993          	addi	s3,s3,576 # 80018848 <sb>
    80002610:	02000613          	li	a2,32
    80002614:	05850593          	addi	a1,a0,88
    80002618:	854e                	mv	a0,s3
    8000261a:	b91fd0ef          	jal	800001aa <memmove>
  brelse(bp);
    8000261e:	8526                	mv	a0,s1
    80002620:	bd5ff0ef          	jal	800021f4 <brelse>
  if(sb.magic != FSMAGIC)
    80002624:	0009a703          	lw	a4,0(s3)
    80002628:	102037b7          	lui	a5,0x10203
    8000262c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002630:	02f71063          	bne	a4,a5,80002650 <fsinit+0x60>
  initlog(dev, &sb);
    80002634:	00016597          	auipc	a1,0x16
    80002638:	21458593          	addi	a1,a1,532 # 80018848 <sb>
    8000263c:	854a                	mv	a0,s2
    8000263e:	1f9000ef          	jal	80003036 <initlog>
}
    80002642:	70a2                	ld	ra,40(sp)
    80002644:	7402                	ld	s0,32(sp)
    80002646:	64e2                	ld	s1,24(sp)
    80002648:	6942                	ld	s2,16(sp)
    8000264a:	69a2                	ld	s3,8(sp)
    8000264c:	6145                	addi	sp,sp,48
    8000264e:	8082                	ret
    panic("invalid file system");
    80002650:	00005517          	auipc	a0,0x5
    80002654:	e5850513          	addi	a0,a0,-424 # 800074a8 <etext+0x4a8>
    80002658:	78b020ef          	jal	800055e2 <panic>

000000008000265c <iinit>:
{
    8000265c:	7179                	addi	sp,sp,-48
    8000265e:	f406                	sd	ra,40(sp)
    80002660:	f022                	sd	s0,32(sp)
    80002662:	ec26                	sd	s1,24(sp)
    80002664:	e84a                	sd	s2,16(sp)
    80002666:	e44e                	sd	s3,8(sp)
    80002668:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000266a:	00005597          	auipc	a1,0x5
    8000266e:	e5658593          	addi	a1,a1,-426 # 800074c0 <etext+0x4c0>
    80002672:	00016517          	auipc	a0,0x16
    80002676:	1f650513          	addi	a0,a0,502 # 80018868 <itable>
    8000267a:	216030ef          	jal	80005890 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000267e:	00016497          	auipc	s1,0x16
    80002682:	21248493          	addi	s1,s1,530 # 80018890 <itable+0x28>
    80002686:	00018997          	auipc	s3,0x18
    8000268a:	c9a98993          	addi	s3,s3,-870 # 8001a320 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000268e:	00005917          	auipc	s2,0x5
    80002692:	e3a90913          	addi	s2,s2,-454 # 800074c8 <etext+0x4c8>
    80002696:	85ca                	mv	a1,s2
    80002698:	8526                	mv	a0,s1
    8000269a:	475000ef          	jal	8000330e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000269e:	08848493          	addi	s1,s1,136
    800026a2:	ff349ae3          	bne	s1,s3,80002696 <iinit+0x3a>
}
    800026a6:	70a2                	ld	ra,40(sp)
    800026a8:	7402                	ld	s0,32(sp)
    800026aa:	64e2                	ld	s1,24(sp)
    800026ac:	6942                	ld	s2,16(sp)
    800026ae:	69a2                	ld	s3,8(sp)
    800026b0:	6145                	addi	sp,sp,48
    800026b2:	8082                	ret

00000000800026b4 <ialloc>:
{
    800026b4:	7139                	addi	sp,sp,-64
    800026b6:	fc06                	sd	ra,56(sp)
    800026b8:	f822                	sd	s0,48(sp)
    800026ba:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800026bc:	00016717          	auipc	a4,0x16
    800026c0:	19872703          	lw	a4,408(a4) # 80018854 <sb+0xc>
    800026c4:	4785                	li	a5,1
    800026c6:	06e7f063          	bgeu	a5,a4,80002726 <ialloc+0x72>
    800026ca:	f426                	sd	s1,40(sp)
    800026cc:	f04a                	sd	s2,32(sp)
    800026ce:	ec4e                	sd	s3,24(sp)
    800026d0:	e852                	sd	s4,16(sp)
    800026d2:	e456                	sd	s5,8(sp)
    800026d4:	e05a                	sd	s6,0(sp)
    800026d6:	8aaa                	mv	s5,a0
    800026d8:	8b2e                	mv	s6,a1
    800026da:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800026dc:	00016a17          	auipc	s4,0x16
    800026e0:	16ca0a13          	addi	s4,s4,364 # 80018848 <sb>
    800026e4:	00495593          	srli	a1,s2,0x4
    800026e8:	018a2783          	lw	a5,24(s4)
    800026ec:	9dbd                	addw	a1,a1,a5
    800026ee:	8556                	mv	a0,s5
    800026f0:	9fdff0ef          	jal	800020ec <bread>
    800026f4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800026f6:	05850993          	addi	s3,a0,88
    800026fa:	00f97793          	andi	a5,s2,15
    800026fe:	079a                	slli	a5,a5,0x6
    80002700:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002702:	00099783          	lh	a5,0(s3)
    80002706:	cb9d                	beqz	a5,8000273c <ialloc+0x88>
    brelse(bp);
    80002708:	aedff0ef          	jal	800021f4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000270c:	0905                	addi	s2,s2,1
    8000270e:	00ca2703          	lw	a4,12(s4)
    80002712:	0009079b          	sext.w	a5,s2
    80002716:	fce7e7e3          	bltu	a5,a4,800026e4 <ialloc+0x30>
    8000271a:	74a2                	ld	s1,40(sp)
    8000271c:	7902                	ld	s2,32(sp)
    8000271e:	69e2                	ld	s3,24(sp)
    80002720:	6a42                	ld	s4,16(sp)
    80002722:	6aa2                	ld	s5,8(sp)
    80002724:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002726:	00005517          	auipc	a0,0x5
    8000272a:	daa50513          	addi	a0,a0,-598 # 800074d0 <etext+0x4d0>
    8000272e:	3e3020ef          	jal	80005310 <printf>
  return 0;
    80002732:	4501                	li	a0,0
}
    80002734:	70e2                	ld	ra,56(sp)
    80002736:	7442                	ld	s0,48(sp)
    80002738:	6121                	addi	sp,sp,64
    8000273a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000273c:	04000613          	li	a2,64
    80002740:	4581                	li	a1,0
    80002742:	854e                	mv	a0,s3
    80002744:	a0bfd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002748:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000274c:	8526                	mv	a0,s1
    8000274e:	2f1000ef          	jal	8000323e <log_write>
      brelse(bp);
    80002752:	8526                	mv	a0,s1
    80002754:	aa1ff0ef          	jal	800021f4 <brelse>
      return iget(dev, inum);
    80002758:	0009059b          	sext.w	a1,s2
    8000275c:	8556                	mv	a0,s5
    8000275e:	de7ff0ef          	jal	80002544 <iget>
    80002762:	74a2                	ld	s1,40(sp)
    80002764:	7902                	ld	s2,32(sp)
    80002766:	69e2                	ld	s3,24(sp)
    80002768:	6a42                	ld	s4,16(sp)
    8000276a:	6aa2                	ld	s5,8(sp)
    8000276c:	6b02                	ld	s6,0(sp)
    8000276e:	b7d9                	j	80002734 <ialloc+0x80>

0000000080002770 <iupdate>:
{
    80002770:	1101                	addi	sp,sp,-32
    80002772:	ec06                	sd	ra,24(sp)
    80002774:	e822                	sd	s0,16(sp)
    80002776:	e426                	sd	s1,8(sp)
    80002778:	e04a                	sd	s2,0(sp)
    8000277a:	1000                	addi	s0,sp,32
    8000277c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000277e:	415c                	lw	a5,4(a0)
    80002780:	0047d79b          	srliw	a5,a5,0x4
    80002784:	00016597          	auipc	a1,0x16
    80002788:	0dc5a583          	lw	a1,220(a1) # 80018860 <sb+0x18>
    8000278c:	9dbd                	addw	a1,a1,a5
    8000278e:	4108                	lw	a0,0(a0)
    80002790:	95dff0ef          	jal	800020ec <bread>
    80002794:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002796:	05850793          	addi	a5,a0,88
    8000279a:	40d8                	lw	a4,4(s1)
    8000279c:	8b3d                	andi	a4,a4,15
    8000279e:	071a                	slli	a4,a4,0x6
    800027a0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800027a2:	04449703          	lh	a4,68(s1)
    800027a6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800027aa:	04649703          	lh	a4,70(s1)
    800027ae:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800027b2:	04849703          	lh	a4,72(s1)
    800027b6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800027ba:	04a49703          	lh	a4,74(s1)
    800027be:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800027c2:	44f8                	lw	a4,76(s1)
    800027c4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800027c6:	03400613          	li	a2,52
    800027ca:	05048593          	addi	a1,s1,80
    800027ce:	00c78513          	addi	a0,a5,12
    800027d2:	9d9fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    800027d6:	854a                	mv	a0,s2
    800027d8:	267000ef          	jal	8000323e <log_write>
  brelse(bp);
    800027dc:	854a                	mv	a0,s2
    800027de:	a17ff0ef          	jal	800021f4 <brelse>
}
    800027e2:	60e2                	ld	ra,24(sp)
    800027e4:	6442                	ld	s0,16(sp)
    800027e6:	64a2                	ld	s1,8(sp)
    800027e8:	6902                	ld	s2,0(sp)
    800027ea:	6105                	addi	sp,sp,32
    800027ec:	8082                	ret

00000000800027ee <idup>:
{
    800027ee:	1101                	addi	sp,sp,-32
    800027f0:	ec06                	sd	ra,24(sp)
    800027f2:	e822                	sd	s0,16(sp)
    800027f4:	e426                	sd	s1,8(sp)
    800027f6:	1000                	addi	s0,sp,32
    800027f8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027fa:	00016517          	auipc	a0,0x16
    800027fe:	06e50513          	addi	a0,a0,110 # 80018868 <itable>
    80002802:	10e030ef          	jal	80005910 <acquire>
  ip->ref++;
    80002806:	449c                	lw	a5,8(s1)
    80002808:	2785                	addiw	a5,a5,1
    8000280a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000280c:	00016517          	auipc	a0,0x16
    80002810:	05c50513          	addi	a0,a0,92 # 80018868 <itable>
    80002814:	194030ef          	jal	800059a8 <release>
}
    80002818:	8526                	mv	a0,s1
    8000281a:	60e2                	ld	ra,24(sp)
    8000281c:	6442                	ld	s0,16(sp)
    8000281e:	64a2                	ld	s1,8(sp)
    80002820:	6105                	addi	sp,sp,32
    80002822:	8082                	ret

0000000080002824 <ilock>:
{
    80002824:	1101                	addi	sp,sp,-32
    80002826:	ec06                	sd	ra,24(sp)
    80002828:	e822                	sd	s0,16(sp)
    8000282a:	e426                	sd	s1,8(sp)
    8000282c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000282e:	cd19                	beqz	a0,8000284c <ilock+0x28>
    80002830:	84aa                	mv	s1,a0
    80002832:	451c                	lw	a5,8(a0)
    80002834:	00f05c63          	blez	a5,8000284c <ilock+0x28>
  acquiresleep(&ip->lock);
    80002838:	0541                	addi	a0,a0,16
    8000283a:	30b000ef          	jal	80003344 <acquiresleep>
  if(ip->valid == 0){
    8000283e:	40bc                	lw	a5,64(s1)
    80002840:	cf89                	beqz	a5,8000285a <ilock+0x36>
}
    80002842:	60e2                	ld	ra,24(sp)
    80002844:	6442                	ld	s0,16(sp)
    80002846:	64a2                	ld	s1,8(sp)
    80002848:	6105                	addi	sp,sp,32
    8000284a:	8082                	ret
    8000284c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000284e:	00005517          	auipc	a0,0x5
    80002852:	c9a50513          	addi	a0,a0,-870 # 800074e8 <etext+0x4e8>
    80002856:	58d020ef          	jal	800055e2 <panic>
    8000285a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000285c:	40dc                	lw	a5,4(s1)
    8000285e:	0047d79b          	srliw	a5,a5,0x4
    80002862:	00016597          	auipc	a1,0x16
    80002866:	ffe5a583          	lw	a1,-2(a1) # 80018860 <sb+0x18>
    8000286a:	9dbd                	addw	a1,a1,a5
    8000286c:	4088                	lw	a0,0(s1)
    8000286e:	87fff0ef          	jal	800020ec <bread>
    80002872:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002874:	05850593          	addi	a1,a0,88
    80002878:	40dc                	lw	a5,4(s1)
    8000287a:	8bbd                	andi	a5,a5,15
    8000287c:	079a                	slli	a5,a5,0x6
    8000287e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002880:	00059783          	lh	a5,0(a1)
    80002884:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002888:	00259783          	lh	a5,2(a1)
    8000288c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002890:	00459783          	lh	a5,4(a1)
    80002894:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002898:	00659783          	lh	a5,6(a1)
    8000289c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800028a0:	459c                	lw	a5,8(a1)
    800028a2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800028a4:	03400613          	li	a2,52
    800028a8:	05b1                	addi	a1,a1,12
    800028aa:	05048513          	addi	a0,s1,80
    800028ae:	8fdfd0ef          	jal	800001aa <memmove>
    brelse(bp);
    800028b2:	854a                	mv	a0,s2
    800028b4:	941ff0ef          	jal	800021f4 <brelse>
    ip->valid = 1;
    800028b8:	4785                	li	a5,1
    800028ba:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800028bc:	04449783          	lh	a5,68(s1)
    800028c0:	c399                	beqz	a5,800028c6 <ilock+0xa2>
    800028c2:	6902                	ld	s2,0(sp)
    800028c4:	bfbd                	j	80002842 <ilock+0x1e>
      panic("ilock: no type");
    800028c6:	00005517          	auipc	a0,0x5
    800028ca:	c2a50513          	addi	a0,a0,-982 # 800074f0 <etext+0x4f0>
    800028ce:	515020ef          	jal	800055e2 <panic>

00000000800028d2 <iunlock>:
{
    800028d2:	1101                	addi	sp,sp,-32
    800028d4:	ec06                	sd	ra,24(sp)
    800028d6:	e822                	sd	s0,16(sp)
    800028d8:	e426                	sd	s1,8(sp)
    800028da:	e04a                	sd	s2,0(sp)
    800028dc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800028de:	c505                	beqz	a0,80002906 <iunlock+0x34>
    800028e0:	84aa                	mv	s1,a0
    800028e2:	01050913          	addi	s2,a0,16
    800028e6:	854a                	mv	a0,s2
    800028e8:	2db000ef          	jal	800033c2 <holdingsleep>
    800028ec:	cd09                	beqz	a0,80002906 <iunlock+0x34>
    800028ee:	449c                	lw	a5,8(s1)
    800028f0:	00f05b63          	blez	a5,80002906 <iunlock+0x34>
  releasesleep(&ip->lock);
    800028f4:	854a                	mv	a0,s2
    800028f6:	295000ef          	jal	8000338a <releasesleep>
}
    800028fa:	60e2                	ld	ra,24(sp)
    800028fc:	6442                	ld	s0,16(sp)
    800028fe:	64a2                	ld	s1,8(sp)
    80002900:	6902                	ld	s2,0(sp)
    80002902:	6105                	addi	sp,sp,32
    80002904:	8082                	ret
    panic("iunlock");
    80002906:	00005517          	auipc	a0,0x5
    8000290a:	bfa50513          	addi	a0,a0,-1030 # 80007500 <etext+0x500>
    8000290e:	4d5020ef          	jal	800055e2 <panic>

0000000080002912 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002912:	7179                	addi	sp,sp,-48
    80002914:	f406                	sd	ra,40(sp)
    80002916:	f022                	sd	s0,32(sp)
    80002918:	ec26                	sd	s1,24(sp)
    8000291a:	e84a                	sd	s2,16(sp)
    8000291c:	e44e                	sd	s3,8(sp)
    8000291e:	1800                	addi	s0,sp,48
    80002920:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002922:	05050493          	addi	s1,a0,80
    80002926:	08050913          	addi	s2,a0,128
    8000292a:	a021                	j	80002932 <itrunc+0x20>
    8000292c:	0491                	addi	s1,s1,4
    8000292e:	01248b63          	beq	s1,s2,80002944 <itrunc+0x32>
    if(ip->addrs[i]){
    80002932:	408c                	lw	a1,0(s1)
    80002934:	dde5                	beqz	a1,8000292c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002936:	0009a503          	lw	a0,0(s3)
    8000293a:	9abff0ef          	jal	800022e4 <bfree>
      ip->addrs[i] = 0;
    8000293e:	0004a023          	sw	zero,0(s1)
    80002942:	b7ed                	j	8000292c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002944:	0809a583          	lw	a1,128(s3)
    80002948:	ed89                	bnez	a1,80002962 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000294a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000294e:	854e                	mv	a0,s3
    80002950:	e21ff0ef          	jal	80002770 <iupdate>
}
    80002954:	70a2                	ld	ra,40(sp)
    80002956:	7402                	ld	s0,32(sp)
    80002958:	64e2                	ld	s1,24(sp)
    8000295a:	6942                	ld	s2,16(sp)
    8000295c:	69a2                	ld	s3,8(sp)
    8000295e:	6145                	addi	sp,sp,48
    80002960:	8082                	ret
    80002962:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002964:	0009a503          	lw	a0,0(s3)
    80002968:	f84ff0ef          	jal	800020ec <bread>
    8000296c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000296e:	05850493          	addi	s1,a0,88
    80002972:	45850913          	addi	s2,a0,1112
    80002976:	a021                	j	8000297e <itrunc+0x6c>
    80002978:	0491                	addi	s1,s1,4
    8000297a:	01248963          	beq	s1,s2,8000298c <itrunc+0x7a>
      if(a[j])
    8000297e:	408c                	lw	a1,0(s1)
    80002980:	dde5                	beqz	a1,80002978 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002982:	0009a503          	lw	a0,0(s3)
    80002986:	95fff0ef          	jal	800022e4 <bfree>
    8000298a:	b7fd                	j	80002978 <itrunc+0x66>
    brelse(bp);
    8000298c:	8552                	mv	a0,s4
    8000298e:	867ff0ef          	jal	800021f4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002992:	0809a583          	lw	a1,128(s3)
    80002996:	0009a503          	lw	a0,0(s3)
    8000299a:	94bff0ef          	jal	800022e4 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000299e:	0809a023          	sw	zero,128(s3)
    800029a2:	6a02                	ld	s4,0(sp)
    800029a4:	b75d                	j	8000294a <itrunc+0x38>

00000000800029a6 <iput>:
{
    800029a6:	1101                	addi	sp,sp,-32
    800029a8:	ec06                	sd	ra,24(sp)
    800029aa:	e822                	sd	s0,16(sp)
    800029ac:	e426                	sd	s1,8(sp)
    800029ae:	1000                	addi	s0,sp,32
    800029b0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800029b2:	00016517          	auipc	a0,0x16
    800029b6:	eb650513          	addi	a0,a0,-330 # 80018868 <itable>
    800029ba:	757020ef          	jal	80005910 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800029be:	4498                	lw	a4,8(s1)
    800029c0:	4785                	li	a5,1
    800029c2:	02f70063          	beq	a4,a5,800029e2 <iput+0x3c>
  ip->ref--;
    800029c6:	449c                	lw	a5,8(s1)
    800029c8:	37fd                	addiw	a5,a5,-1
    800029ca:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800029cc:	00016517          	auipc	a0,0x16
    800029d0:	e9c50513          	addi	a0,a0,-356 # 80018868 <itable>
    800029d4:	7d5020ef          	jal	800059a8 <release>
}
    800029d8:	60e2                	ld	ra,24(sp)
    800029da:	6442                	ld	s0,16(sp)
    800029dc:	64a2                	ld	s1,8(sp)
    800029de:	6105                	addi	sp,sp,32
    800029e0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800029e2:	40bc                	lw	a5,64(s1)
    800029e4:	d3ed                	beqz	a5,800029c6 <iput+0x20>
    800029e6:	04a49783          	lh	a5,74(s1)
    800029ea:	fff1                	bnez	a5,800029c6 <iput+0x20>
    800029ec:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800029ee:	01048913          	addi	s2,s1,16
    800029f2:	854a                	mv	a0,s2
    800029f4:	151000ef          	jal	80003344 <acquiresleep>
    release(&itable.lock);
    800029f8:	00016517          	auipc	a0,0x16
    800029fc:	e7050513          	addi	a0,a0,-400 # 80018868 <itable>
    80002a00:	7a9020ef          	jal	800059a8 <release>
    itrunc(ip);
    80002a04:	8526                	mv	a0,s1
    80002a06:	f0dff0ef          	jal	80002912 <itrunc>
    ip->type = 0;
    80002a0a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002a0e:	8526                	mv	a0,s1
    80002a10:	d61ff0ef          	jal	80002770 <iupdate>
    ip->valid = 0;
    80002a14:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002a18:	854a                	mv	a0,s2
    80002a1a:	171000ef          	jal	8000338a <releasesleep>
    acquire(&itable.lock);
    80002a1e:	00016517          	auipc	a0,0x16
    80002a22:	e4a50513          	addi	a0,a0,-438 # 80018868 <itable>
    80002a26:	6eb020ef          	jal	80005910 <acquire>
    80002a2a:	6902                	ld	s2,0(sp)
    80002a2c:	bf69                	j	800029c6 <iput+0x20>

0000000080002a2e <iunlockput>:
{
    80002a2e:	1101                	addi	sp,sp,-32
    80002a30:	ec06                	sd	ra,24(sp)
    80002a32:	e822                	sd	s0,16(sp)
    80002a34:	e426                	sd	s1,8(sp)
    80002a36:	1000                	addi	s0,sp,32
    80002a38:	84aa                	mv	s1,a0
  iunlock(ip);
    80002a3a:	e99ff0ef          	jal	800028d2 <iunlock>
  iput(ip);
    80002a3e:	8526                	mv	a0,s1
    80002a40:	f67ff0ef          	jal	800029a6 <iput>
}
    80002a44:	60e2                	ld	ra,24(sp)
    80002a46:	6442                	ld	s0,16(sp)
    80002a48:	64a2                	ld	s1,8(sp)
    80002a4a:	6105                	addi	sp,sp,32
    80002a4c:	8082                	ret

0000000080002a4e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a4e:	1141                	addi	sp,sp,-16
    80002a50:	e422                	sd	s0,8(sp)
    80002a52:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a54:	411c                	lw	a5,0(a0)
    80002a56:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a58:	415c                	lw	a5,4(a0)
    80002a5a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a5c:	04451783          	lh	a5,68(a0)
    80002a60:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a64:	04a51783          	lh	a5,74(a0)
    80002a68:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a6c:	04c56783          	lwu	a5,76(a0)
    80002a70:	e99c                	sd	a5,16(a1)
}
    80002a72:	6422                	ld	s0,8(sp)
    80002a74:	0141                	addi	sp,sp,16
    80002a76:	8082                	ret

0000000080002a78 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a78:	457c                	lw	a5,76(a0)
    80002a7a:	0ed7eb63          	bltu	a5,a3,80002b70 <readi+0xf8>
{
    80002a7e:	7159                	addi	sp,sp,-112
    80002a80:	f486                	sd	ra,104(sp)
    80002a82:	f0a2                	sd	s0,96(sp)
    80002a84:	eca6                	sd	s1,88(sp)
    80002a86:	e0d2                	sd	s4,64(sp)
    80002a88:	fc56                	sd	s5,56(sp)
    80002a8a:	f85a                	sd	s6,48(sp)
    80002a8c:	f45e                	sd	s7,40(sp)
    80002a8e:	1880                	addi	s0,sp,112
    80002a90:	8b2a                	mv	s6,a0
    80002a92:	8bae                	mv	s7,a1
    80002a94:	8a32                	mv	s4,a2
    80002a96:	84b6                	mv	s1,a3
    80002a98:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a9a:	9f35                	addw	a4,a4,a3
    return 0;
    80002a9c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a9e:	0cd76063          	bltu	a4,a3,80002b5e <readi+0xe6>
    80002aa2:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002aa4:	00e7f463          	bgeu	a5,a4,80002aac <readi+0x34>
    n = ip->size - off;
    80002aa8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002aac:	080a8f63          	beqz	s5,80002b4a <readi+0xd2>
    80002ab0:	e8ca                	sd	s2,80(sp)
    80002ab2:	f062                	sd	s8,32(sp)
    80002ab4:	ec66                	sd	s9,24(sp)
    80002ab6:	e86a                	sd	s10,16(sp)
    80002ab8:	e46e                	sd	s11,8(sp)
    80002aba:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002abc:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ac0:	5c7d                	li	s8,-1
    80002ac2:	a80d                	j	80002af4 <readi+0x7c>
    80002ac4:	020d1d93          	slli	s11,s10,0x20
    80002ac8:	020ddd93          	srli	s11,s11,0x20
    80002acc:	05890613          	addi	a2,s2,88
    80002ad0:	86ee                	mv	a3,s11
    80002ad2:	963a                	add	a2,a2,a4
    80002ad4:	85d2                	mv	a1,s4
    80002ad6:	855e                	mv	a0,s7
    80002ad8:	cdffe0ef          	jal	800017b6 <either_copyout>
    80002adc:	05850763          	beq	a0,s8,80002b2a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ae0:	854a                	mv	a0,s2
    80002ae2:	f12ff0ef          	jal	800021f4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ae6:	013d09bb          	addw	s3,s10,s3
    80002aea:	009d04bb          	addw	s1,s10,s1
    80002aee:	9a6e                	add	s4,s4,s11
    80002af0:	0559f763          	bgeu	s3,s5,80002b3e <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002af4:	00a4d59b          	srliw	a1,s1,0xa
    80002af8:	855a                	mv	a0,s6
    80002afa:	977ff0ef          	jal	80002470 <bmap>
    80002afe:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b02:	c5b1                	beqz	a1,80002b4e <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002b04:	000b2503          	lw	a0,0(s6)
    80002b08:	de4ff0ef          	jal	800020ec <bread>
    80002b0c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b0e:	3ff4f713          	andi	a4,s1,1023
    80002b12:	40ec87bb          	subw	a5,s9,a4
    80002b16:	413a86bb          	subw	a3,s5,s3
    80002b1a:	8d3e                	mv	s10,a5
    80002b1c:	2781                	sext.w	a5,a5
    80002b1e:	0006861b          	sext.w	a2,a3
    80002b22:	faf671e3          	bgeu	a2,a5,80002ac4 <readi+0x4c>
    80002b26:	8d36                	mv	s10,a3
    80002b28:	bf71                	j	80002ac4 <readi+0x4c>
      brelse(bp);
    80002b2a:	854a                	mv	a0,s2
    80002b2c:	ec8ff0ef          	jal	800021f4 <brelse>
      tot = -1;
    80002b30:	59fd                	li	s3,-1
      break;
    80002b32:	6946                	ld	s2,80(sp)
    80002b34:	7c02                	ld	s8,32(sp)
    80002b36:	6ce2                	ld	s9,24(sp)
    80002b38:	6d42                	ld	s10,16(sp)
    80002b3a:	6da2                	ld	s11,8(sp)
    80002b3c:	a831                	j	80002b58 <readi+0xe0>
    80002b3e:	6946                	ld	s2,80(sp)
    80002b40:	7c02                	ld	s8,32(sp)
    80002b42:	6ce2                	ld	s9,24(sp)
    80002b44:	6d42                	ld	s10,16(sp)
    80002b46:	6da2                	ld	s11,8(sp)
    80002b48:	a801                	j	80002b58 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b4a:	89d6                	mv	s3,s5
    80002b4c:	a031                	j	80002b58 <readi+0xe0>
    80002b4e:	6946                	ld	s2,80(sp)
    80002b50:	7c02                	ld	s8,32(sp)
    80002b52:	6ce2                	ld	s9,24(sp)
    80002b54:	6d42                	ld	s10,16(sp)
    80002b56:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b58:	0009851b          	sext.w	a0,s3
    80002b5c:	69a6                	ld	s3,72(sp)
}
    80002b5e:	70a6                	ld	ra,104(sp)
    80002b60:	7406                	ld	s0,96(sp)
    80002b62:	64e6                	ld	s1,88(sp)
    80002b64:	6a06                	ld	s4,64(sp)
    80002b66:	7ae2                	ld	s5,56(sp)
    80002b68:	7b42                	ld	s6,48(sp)
    80002b6a:	7ba2                	ld	s7,40(sp)
    80002b6c:	6165                	addi	sp,sp,112
    80002b6e:	8082                	ret
    return 0;
    80002b70:	4501                	li	a0,0
}
    80002b72:	8082                	ret

0000000080002b74 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b74:	457c                	lw	a5,76(a0)
    80002b76:	10d7e063          	bltu	a5,a3,80002c76 <writei+0x102>
{
    80002b7a:	7159                	addi	sp,sp,-112
    80002b7c:	f486                	sd	ra,104(sp)
    80002b7e:	f0a2                	sd	s0,96(sp)
    80002b80:	e8ca                	sd	s2,80(sp)
    80002b82:	e0d2                	sd	s4,64(sp)
    80002b84:	fc56                	sd	s5,56(sp)
    80002b86:	f85a                	sd	s6,48(sp)
    80002b88:	f45e                	sd	s7,40(sp)
    80002b8a:	1880                	addi	s0,sp,112
    80002b8c:	8aaa                	mv	s5,a0
    80002b8e:	8bae                	mv	s7,a1
    80002b90:	8a32                	mv	s4,a2
    80002b92:	8936                	mv	s2,a3
    80002b94:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b96:	00e687bb          	addw	a5,a3,a4
    80002b9a:	0ed7e063          	bltu	a5,a3,80002c7a <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b9e:	00043737          	lui	a4,0x43
    80002ba2:	0cf76e63          	bltu	a4,a5,80002c7e <writei+0x10a>
    80002ba6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ba8:	0a0b0f63          	beqz	s6,80002c66 <writei+0xf2>
    80002bac:	eca6                	sd	s1,88(sp)
    80002bae:	f062                	sd	s8,32(sp)
    80002bb0:	ec66                	sd	s9,24(sp)
    80002bb2:	e86a                	sd	s10,16(sp)
    80002bb4:	e46e                	sd	s11,8(sp)
    80002bb6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bb8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002bbc:	5c7d                	li	s8,-1
    80002bbe:	a825                	j	80002bf6 <writei+0x82>
    80002bc0:	020d1d93          	slli	s11,s10,0x20
    80002bc4:	020ddd93          	srli	s11,s11,0x20
    80002bc8:	05848513          	addi	a0,s1,88
    80002bcc:	86ee                	mv	a3,s11
    80002bce:	8652                	mv	a2,s4
    80002bd0:	85de                	mv	a1,s7
    80002bd2:	953a                	add	a0,a0,a4
    80002bd4:	c2dfe0ef          	jal	80001800 <either_copyin>
    80002bd8:	05850a63          	beq	a0,s8,80002c2c <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002bdc:	8526                	mv	a0,s1
    80002bde:	660000ef          	jal	8000323e <log_write>
    brelse(bp);
    80002be2:	8526                	mv	a0,s1
    80002be4:	e10ff0ef          	jal	800021f4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002be8:	013d09bb          	addw	s3,s10,s3
    80002bec:	012d093b          	addw	s2,s10,s2
    80002bf0:	9a6e                	add	s4,s4,s11
    80002bf2:	0569f063          	bgeu	s3,s6,80002c32 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002bf6:	00a9559b          	srliw	a1,s2,0xa
    80002bfa:	8556                	mv	a0,s5
    80002bfc:	875ff0ef          	jal	80002470 <bmap>
    80002c00:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002c04:	c59d                	beqz	a1,80002c32 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002c06:	000aa503          	lw	a0,0(s5)
    80002c0a:	ce2ff0ef          	jal	800020ec <bread>
    80002c0e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c10:	3ff97713          	andi	a4,s2,1023
    80002c14:	40ec87bb          	subw	a5,s9,a4
    80002c18:	413b06bb          	subw	a3,s6,s3
    80002c1c:	8d3e                	mv	s10,a5
    80002c1e:	2781                	sext.w	a5,a5
    80002c20:	0006861b          	sext.w	a2,a3
    80002c24:	f8f67ee3          	bgeu	a2,a5,80002bc0 <writei+0x4c>
    80002c28:	8d36                	mv	s10,a3
    80002c2a:	bf59                	j	80002bc0 <writei+0x4c>
      brelse(bp);
    80002c2c:	8526                	mv	a0,s1
    80002c2e:	dc6ff0ef          	jal	800021f4 <brelse>
  }

  if(off > ip->size)
    80002c32:	04caa783          	lw	a5,76(s5)
    80002c36:	0327fa63          	bgeu	a5,s2,80002c6a <writei+0xf6>
    ip->size = off;
    80002c3a:	052aa623          	sw	s2,76(s5)
    80002c3e:	64e6                	ld	s1,88(sp)
    80002c40:	7c02                	ld	s8,32(sp)
    80002c42:	6ce2                	ld	s9,24(sp)
    80002c44:	6d42                	ld	s10,16(sp)
    80002c46:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c48:	8556                	mv	a0,s5
    80002c4a:	b27ff0ef          	jal	80002770 <iupdate>

  return tot;
    80002c4e:	0009851b          	sext.w	a0,s3
    80002c52:	69a6                	ld	s3,72(sp)
}
    80002c54:	70a6                	ld	ra,104(sp)
    80002c56:	7406                	ld	s0,96(sp)
    80002c58:	6946                	ld	s2,80(sp)
    80002c5a:	6a06                	ld	s4,64(sp)
    80002c5c:	7ae2                	ld	s5,56(sp)
    80002c5e:	7b42                	ld	s6,48(sp)
    80002c60:	7ba2                	ld	s7,40(sp)
    80002c62:	6165                	addi	sp,sp,112
    80002c64:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c66:	89da                	mv	s3,s6
    80002c68:	b7c5                	j	80002c48 <writei+0xd4>
    80002c6a:	64e6                	ld	s1,88(sp)
    80002c6c:	7c02                	ld	s8,32(sp)
    80002c6e:	6ce2                	ld	s9,24(sp)
    80002c70:	6d42                	ld	s10,16(sp)
    80002c72:	6da2                	ld	s11,8(sp)
    80002c74:	bfd1                	j	80002c48 <writei+0xd4>
    return -1;
    80002c76:	557d                	li	a0,-1
}
    80002c78:	8082                	ret
    return -1;
    80002c7a:	557d                	li	a0,-1
    80002c7c:	bfe1                	j	80002c54 <writei+0xe0>
    return -1;
    80002c7e:	557d                	li	a0,-1
    80002c80:	bfd1                	j	80002c54 <writei+0xe0>

0000000080002c82 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c82:	1141                	addi	sp,sp,-16
    80002c84:	e406                	sd	ra,8(sp)
    80002c86:	e022                	sd	s0,0(sp)
    80002c88:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c8a:	4639                	li	a2,14
    80002c8c:	d8efd0ef          	jal	8000021a <strncmp>
}
    80002c90:	60a2                	ld	ra,8(sp)
    80002c92:	6402                	ld	s0,0(sp)
    80002c94:	0141                	addi	sp,sp,16
    80002c96:	8082                	ret

0000000080002c98 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c98:	7139                	addi	sp,sp,-64
    80002c9a:	fc06                	sd	ra,56(sp)
    80002c9c:	f822                	sd	s0,48(sp)
    80002c9e:	f426                	sd	s1,40(sp)
    80002ca0:	f04a                	sd	s2,32(sp)
    80002ca2:	ec4e                	sd	s3,24(sp)
    80002ca4:	e852                	sd	s4,16(sp)
    80002ca6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002ca8:	04451703          	lh	a4,68(a0)
    80002cac:	4785                	li	a5,1
    80002cae:	00f71a63          	bne	a4,a5,80002cc2 <dirlookup+0x2a>
    80002cb2:	892a                	mv	s2,a0
    80002cb4:	89ae                	mv	s3,a1
    80002cb6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cb8:	457c                	lw	a5,76(a0)
    80002cba:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002cbc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cbe:	e39d                	bnez	a5,80002ce4 <dirlookup+0x4c>
    80002cc0:	a095                	j	80002d24 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002cc2:	00005517          	auipc	a0,0x5
    80002cc6:	84650513          	addi	a0,a0,-1978 # 80007508 <etext+0x508>
    80002cca:	119020ef          	jal	800055e2 <panic>
      panic("dirlookup read");
    80002cce:	00005517          	auipc	a0,0x5
    80002cd2:	85250513          	addi	a0,a0,-1966 # 80007520 <etext+0x520>
    80002cd6:	10d020ef          	jal	800055e2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cda:	24c1                	addiw	s1,s1,16
    80002cdc:	04c92783          	lw	a5,76(s2)
    80002ce0:	04f4f163          	bgeu	s1,a5,80002d22 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ce4:	4741                	li	a4,16
    80002ce6:	86a6                	mv	a3,s1
    80002ce8:	fc040613          	addi	a2,s0,-64
    80002cec:	4581                	li	a1,0
    80002cee:	854a                	mv	a0,s2
    80002cf0:	d89ff0ef          	jal	80002a78 <readi>
    80002cf4:	47c1                	li	a5,16
    80002cf6:	fcf51ce3          	bne	a0,a5,80002cce <dirlookup+0x36>
    if(de.inum == 0)
    80002cfa:	fc045783          	lhu	a5,-64(s0)
    80002cfe:	dff1                	beqz	a5,80002cda <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002d00:	fc240593          	addi	a1,s0,-62
    80002d04:	854e                	mv	a0,s3
    80002d06:	f7dff0ef          	jal	80002c82 <namecmp>
    80002d0a:	f961                	bnez	a0,80002cda <dirlookup+0x42>
      if(poff)
    80002d0c:	000a0463          	beqz	s4,80002d14 <dirlookup+0x7c>
        *poff = off;
    80002d10:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002d14:	fc045583          	lhu	a1,-64(s0)
    80002d18:	00092503          	lw	a0,0(s2)
    80002d1c:	829ff0ef          	jal	80002544 <iget>
    80002d20:	a011                	j	80002d24 <dirlookup+0x8c>
  return 0;
    80002d22:	4501                	li	a0,0
}
    80002d24:	70e2                	ld	ra,56(sp)
    80002d26:	7442                	ld	s0,48(sp)
    80002d28:	74a2                	ld	s1,40(sp)
    80002d2a:	7902                	ld	s2,32(sp)
    80002d2c:	69e2                	ld	s3,24(sp)
    80002d2e:	6a42                	ld	s4,16(sp)
    80002d30:	6121                	addi	sp,sp,64
    80002d32:	8082                	ret

0000000080002d34 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d34:	711d                	addi	sp,sp,-96
    80002d36:	ec86                	sd	ra,88(sp)
    80002d38:	e8a2                	sd	s0,80(sp)
    80002d3a:	e4a6                	sd	s1,72(sp)
    80002d3c:	e0ca                	sd	s2,64(sp)
    80002d3e:	fc4e                	sd	s3,56(sp)
    80002d40:	f852                	sd	s4,48(sp)
    80002d42:	f456                	sd	s5,40(sp)
    80002d44:	f05a                	sd	s6,32(sp)
    80002d46:	ec5e                	sd	s7,24(sp)
    80002d48:	e862                	sd	s8,16(sp)
    80002d4a:	e466                	sd	s9,8(sp)
    80002d4c:	1080                	addi	s0,sp,96
    80002d4e:	84aa                	mv	s1,a0
    80002d50:	8b2e                	mv	s6,a1
    80002d52:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d54:	00054703          	lbu	a4,0(a0)
    80002d58:	02f00793          	li	a5,47
    80002d5c:	00f70e63          	beq	a4,a5,80002d78 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d60:	92cfe0ef          	jal	80000e8c <myproc>
    80002d64:	15053503          	ld	a0,336(a0)
    80002d68:	a87ff0ef          	jal	800027ee <idup>
    80002d6c:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d6e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002d72:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d74:	4b85                	li	s7,1
    80002d76:	a871                	j	80002e12 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002d78:	4585                	li	a1,1
    80002d7a:	4505                	li	a0,1
    80002d7c:	fc8ff0ef          	jal	80002544 <iget>
    80002d80:	8a2a                	mv	s4,a0
    80002d82:	b7f5                	j	80002d6e <namex+0x3a>
      iunlockput(ip);
    80002d84:	8552                	mv	a0,s4
    80002d86:	ca9ff0ef          	jal	80002a2e <iunlockput>
      return 0;
    80002d8a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d8c:	8552                	mv	a0,s4
    80002d8e:	60e6                	ld	ra,88(sp)
    80002d90:	6446                	ld	s0,80(sp)
    80002d92:	64a6                	ld	s1,72(sp)
    80002d94:	6906                	ld	s2,64(sp)
    80002d96:	79e2                	ld	s3,56(sp)
    80002d98:	7a42                	ld	s4,48(sp)
    80002d9a:	7aa2                	ld	s5,40(sp)
    80002d9c:	7b02                	ld	s6,32(sp)
    80002d9e:	6be2                	ld	s7,24(sp)
    80002da0:	6c42                	ld	s8,16(sp)
    80002da2:	6ca2                	ld	s9,8(sp)
    80002da4:	6125                	addi	sp,sp,96
    80002da6:	8082                	ret
      iunlock(ip);
    80002da8:	8552                	mv	a0,s4
    80002daa:	b29ff0ef          	jal	800028d2 <iunlock>
      return ip;
    80002dae:	bff9                	j	80002d8c <namex+0x58>
      iunlockput(ip);
    80002db0:	8552                	mv	a0,s4
    80002db2:	c7dff0ef          	jal	80002a2e <iunlockput>
      return 0;
    80002db6:	8a4e                	mv	s4,s3
    80002db8:	bfd1                	j	80002d8c <namex+0x58>
  len = path - s;
    80002dba:	40998633          	sub	a2,s3,s1
    80002dbe:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002dc2:	099c5063          	bge	s8,s9,80002e42 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002dc6:	4639                	li	a2,14
    80002dc8:	85a6                	mv	a1,s1
    80002dca:	8556                	mv	a0,s5
    80002dcc:	bdefd0ef          	jal	800001aa <memmove>
    80002dd0:	84ce                	mv	s1,s3
  while(*path == '/')
    80002dd2:	0004c783          	lbu	a5,0(s1)
    80002dd6:	01279763          	bne	a5,s2,80002de4 <namex+0xb0>
    path++;
    80002dda:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ddc:	0004c783          	lbu	a5,0(s1)
    80002de0:	ff278de3          	beq	a5,s2,80002dda <namex+0xa6>
    ilock(ip);
    80002de4:	8552                	mv	a0,s4
    80002de6:	a3fff0ef          	jal	80002824 <ilock>
    if(ip->type != T_DIR){
    80002dea:	044a1783          	lh	a5,68(s4)
    80002dee:	f9779be3          	bne	a5,s7,80002d84 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002df2:	000b0563          	beqz	s6,80002dfc <namex+0xc8>
    80002df6:	0004c783          	lbu	a5,0(s1)
    80002dfa:	d7dd                	beqz	a5,80002da8 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002dfc:	4601                	li	a2,0
    80002dfe:	85d6                	mv	a1,s5
    80002e00:	8552                	mv	a0,s4
    80002e02:	e97ff0ef          	jal	80002c98 <dirlookup>
    80002e06:	89aa                	mv	s3,a0
    80002e08:	d545                	beqz	a0,80002db0 <namex+0x7c>
    iunlockput(ip);
    80002e0a:	8552                	mv	a0,s4
    80002e0c:	c23ff0ef          	jal	80002a2e <iunlockput>
    ip = next;
    80002e10:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002e12:	0004c783          	lbu	a5,0(s1)
    80002e16:	01279763          	bne	a5,s2,80002e24 <namex+0xf0>
    path++;
    80002e1a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e1c:	0004c783          	lbu	a5,0(s1)
    80002e20:	ff278de3          	beq	a5,s2,80002e1a <namex+0xe6>
  if(*path == 0)
    80002e24:	cb8d                	beqz	a5,80002e56 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002e26:	0004c783          	lbu	a5,0(s1)
    80002e2a:	89a6                	mv	s3,s1
  len = path - s;
    80002e2c:	4c81                	li	s9,0
    80002e2e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002e30:	01278963          	beq	a5,s2,80002e42 <namex+0x10e>
    80002e34:	d3d9                	beqz	a5,80002dba <namex+0x86>
    path++;
    80002e36:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002e38:	0009c783          	lbu	a5,0(s3)
    80002e3c:	ff279ce3          	bne	a5,s2,80002e34 <namex+0x100>
    80002e40:	bfad                	j	80002dba <namex+0x86>
    memmove(name, s, len);
    80002e42:	2601                	sext.w	a2,a2
    80002e44:	85a6                	mv	a1,s1
    80002e46:	8556                	mv	a0,s5
    80002e48:	b62fd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002e4c:	9cd6                	add	s9,s9,s5
    80002e4e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002e52:	84ce                	mv	s1,s3
    80002e54:	bfbd                	j	80002dd2 <namex+0x9e>
  if(nameiparent){
    80002e56:	f20b0be3          	beqz	s6,80002d8c <namex+0x58>
    iput(ip);
    80002e5a:	8552                	mv	a0,s4
    80002e5c:	b4bff0ef          	jal	800029a6 <iput>
    return 0;
    80002e60:	4a01                	li	s4,0
    80002e62:	b72d                	j	80002d8c <namex+0x58>

0000000080002e64 <dirlink>:
{
    80002e64:	7139                	addi	sp,sp,-64
    80002e66:	fc06                	sd	ra,56(sp)
    80002e68:	f822                	sd	s0,48(sp)
    80002e6a:	f04a                	sd	s2,32(sp)
    80002e6c:	ec4e                	sd	s3,24(sp)
    80002e6e:	e852                	sd	s4,16(sp)
    80002e70:	0080                	addi	s0,sp,64
    80002e72:	892a                	mv	s2,a0
    80002e74:	8a2e                	mv	s4,a1
    80002e76:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e78:	4601                	li	a2,0
    80002e7a:	e1fff0ef          	jal	80002c98 <dirlookup>
    80002e7e:	e535                	bnez	a0,80002eea <dirlink+0x86>
    80002e80:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e82:	04c92483          	lw	s1,76(s2)
    80002e86:	c48d                	beqz	s1,80002eb0 <dirlink+0x4c>
    80002e88:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e8a:	4741                	li	a4,16
    80002e8c:	86a6                	mv	a3,s1
    80002e8e:	fc040613          	addi	a2,s0,-64
    80002e92:	4581                	li	a1,0
    80002e94:	854a                	mv	a0,s2
    80002e96:	be3ff0ef          	jal	80002a78 <readi>
    80002e9a:	47c1                	li	a5,16
    80002e9c:	04f51b63          	bne	a0,a5,80002ef2 <dirlink+0x8e>
    if(de.inum == 0)
    80002ea0:	fc045783          	lhu	a5,-64(s0)
    80002ea4:	c791                	beqz	a5,80002eb0 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ea6:	24c1                	addiw	s1,s1,16
    80002ea8:	04c92783          	lw	a5,76(s2)
    80002eac:	fcf4efe3          	bltu	s1,a5,80002e8a <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002eb0:	4639                	li	a2,14
    80002eb2:	85d2                	mv	a1,s4
    80002eb4:	fc240513          	addi	a0,s0,-62
    80002eb8:	b98fd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002ebc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ec0:	4741                	li	a4,16
    80002ec2:	86a6                	mv	a3,s1
    80002ec4:	fc040613          	addi	a2,s0,-64
    80002ec8:	4581                	li	a1,0
    80002eca:	854a                	mv	a0,s2
    80002ecc:	ca9ff0ef          	jal	80002b74 <writei>
    80002ed0:	1541                	addi	a0,a0,-16
    80002ed2:	00a03533          	snez	a0,a0
    80002ed6:	40a00533          	neg	a0,a0
    80002eda:	74a2                	ld	s1,40(sp)
}
    80002edc:	70e2                	ld	ra,56(sp)
    80002ede:	7442                	ld	s0,48(sp)
    80002ee0:	7902                	ld	s2,32(sp)
    80002ee2:	69e2                	ld	s3,24(sp)
    80002ee4:	6a42                	ld	s4,16(sp)
    80002ee6:	6121                	addi	sp,sp,64
    80002ee8:	8082                	ret
    iput(ip);
    80002eea:	abdff0ef          	jal	800029a6 <iput>
    return -1;
    80002eee:	557d                	li	a0,-1
    80002ef0:	b7f5                	j	80002edc <dirlink+0x78>
      panic("dirlink read");
    80002ef2:	00004517          	auipc	a0,0x4
    80002ef6:	63e50513          	addi	a0,a0,1598 # 80007530 <etext+0x530>
    80002efa:	6e8020ef          	jal	800055e2 <panic>

0000000080002efe <namei>:

struct inode*
namei(char *path)
{
    80002efe:	1101                	addi	sp,sp,-32
    80002f00:	ec06                	sd	ra,24(sp)
    80002f02:	e822                	sd	s0,16(sp)
    80002f04:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002f06:	fe040613          	addi	a2,s0,-32
    80002f0a:	4581                	li	a1,0
    80002f0c:	e29ff0ef          	jal	80002d34 <namex>
}
    80002f10:	60e2                	ld	ra,24(sp)
    80002f12:	6442                	ld	s0,16(sp)
    80002f14:	6105                	addi	sp,sp,32
    80002f16:	8082                	ret

0000000080002f18 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002f18:	1141                	addi	sp,sp,-16
    80002f1a:	e406                	sd	ra,8(sp)
    80002f1c:	e022                	sd	s0,0(sp)
    80002f1e:	0800                	addi	s0,sp,16
    80002f20:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002f22:	4585                	li	a1,1
    80002f24:	e11ff0ef          	jal	80002d34 <namex>
}
    80002f28:	60a2                	ld	ra,8(sp)
    80002f2a:	6402                	ld	s0,0(sp)
    80002f2c:	0141                	addi	sp,sp,16
    80002f2e:	8082                	ret

0000000080002f30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f30:	1101                	addi	sp,sp,-32
    80002f32:	ec06                	sd	ra,24(sp)
    80002f34:	e822                	sd	s0,16(sp)
    80002f36:	e426                	sd	s1,8(sp)
    80002f38:	e04a                	sd	s2,0(sp)
    80002f3a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f3c:	00017917          	auipc	s2,0x17
    80002f40:	3d490913          	addi	s2,s2,980 # 8001a310 <log>
    80002f44:	01892583          	lw	a1,24(s2)
    80002f48:	02892503          	lw	a0,40(s2)
    80002f4c:	9a0ff0ef          	jal	800020ec <bread>
    80002f50:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f52:	02c92603          	lw	a2,44(s2)
    80002f56:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f58:	00c05f63          	blez	a2,80002f76 <write_head+0x46>
    80002f5c:	00017717          	auipc	a4,0x17
    80002f60:	3e470713          	addi	a4,a4,996 # 8001a340 <log+0x30>
    80002f64:	87aa                	mv	a5,a0
    80002f66:	060a                	slli	a2,a2,0x2
    80002f68:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f6a:	4314                	lw	a3,0(a4)
    80002f6c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f6e:	0711                	addi	a4,a4,4
    80002f70:	0791                	addi	a5,a5,4
    80002f72:	fec79ce3          	bne	a5,a2,80002f6a <write_head+0x3a>
  }
  bwrite(buf);
    80002f76:	8526                	mv	a0,s1
    80002f78:	a4aff0ef          	jal	800021c2 <bwrite>
  brelse(buf);
    80002f7c:	8526                	mv	a0,s1
    80002f7e:	a76ff0ef          	jal	800021f4 <brelse>
}
    80002f82:	60e2                	ld	ra,24(sp)
    80002f84:	6442                	ld	s0,16(sp)
    80002f86:	64a2                	ld	s1,8(sp)
    80002f88:	6902                	ld	s2,0(sp)
    80002f8a:	6105                	addi	sp,sp,32
    80002f8c:	8082                	ret

0000000080002f8e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f8e:	00017797          	auipc	a5,0x17
    80002f92:	3ae7a783          	lw	a5,942(a5) # 8001a33c <log+0x2c>
    80002f96:	08f05f63          	blez	a5,80003034 <install_trans+0xa6>
{
    80002f9a:	7139                	addi	sp,sp,-64
    80002f9c:	fc06                	sd	ra,56(sp)
    80002f9e:	f822                	sd	s0,48(sp)
    80002fa0:	f426                	sd	s1,40(sp)
    80002fa2:	f04a                	sd	s2,32(sp)
    80002fa4:	ec4e                	sd	s3,24(sp)
    80002fa6:	e852                	sd	s4,16(sp)
    80002fa8:	e456                	sd	s5,8(sp)
    80002faa:	e05a                	sd	s6,0(sp)
    80002fac:	0080                	addi	s0,sp,64
    80002fae:	8b2a                	mv	s6,a0
    80002fb0:	00017a97          	auipc	s5,0x17
    80002fb4:	390a8a93          	addi	s5,s5,912 # 8001a340 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fb8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fba:	00017997          	auipc	s3,0x17
    80002fbe:	35698993          	addi	s3,s3,854 # 8001a310 <log>
    80002fc2:	a829                	j	80002fdc <install_trans+0x4e>
    brelse(lbuf);
    80002fc4:	854a                	mv	a0,s2
    80002fc6:	a2eff0ef          	jal	800021f4 <brelse>
    brelse(dbuf);
    80002fca:	8526                	mv	a0,s1
    80002fcc:	a28ff0ef          	jal	800021f4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fd0:	2a05                	addiw	s4,s4,1
    80002fd2:	0a91                	addi	s5,s5,4
    80002fd4:	02c9a783          	lw	a5,44(s3)
    80002fd8:	04fa5463          	bge	s4,a5,80003020 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fdc:	0189a583          	lw	a1,24(s3)
    80002fe0:	014585bb          	addw	a1,a1,s4
    80002fe4:	2585                	addiw	a1,a1,1
    80002fe6:	0289a503          	lw	a0,40(s3)
    80002fea:	902ff0ef          	jal	800020ec <bread>
    80002fee:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002ff0:	000aa583          	lw	a1,0(s5)
    80002ff4:	0289a503          	lw	a0,40(s3)
    80002ff8:	8f4ff0ef          	jal	800020ec <bread>
    80002ffc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002ffe:	40000613          	li	a2,1024
    80003002:	05890593          	addi	a1,s2,88
    80003006:	05850513          	addi	a0,a0,88
    8000300a:	9a0fd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    8000300e:	8526                	mv	a0,s1
    80003010:	9b2ff0ef          	jal	800021c2 <bwrite>
    if(recovering == 0)
    80003014:	fa0b18e3          	bnez	s6,80002fc4 <install_trans+0x36>
      bunpin(dbuf);
    80003018:	8526                	mv	a0,s1
    8000301a:	a96ff0ef          	jal	800022b0 <bunpin>
    8000301e:	b75d                	j	80002fc4 <install_trans+0x36>
}
    80003020:	70e2                	ld	ra,56(sp)
    80003022:	7442                	ld	s0,48(sp)
    80003024:	74a2                	ld	s1,40(sp)
    80003026:	7902                	ld	s2,32(sp)
    80003028:	69e2                	ld	s3,24(sp)
    8000302a:	6a42                	ld	s4,16(sp)
    8000302c:	6aa2                	ld	s5,8(sp)
    8000302e:	6b02                	ld	s6,0(sp)
    80003030:	6121                	addi	sp,sp,64
    80003032:	8082                	ret
    80003034:	8082                	ret

0000000080003036 <initlog>:
{
    80003036:	7179                	addi	sp,sp,-48
    80003038:	f406                	sd	ra,40(sp)
    8000303a:	f022                	sd	s0,32(sp)
    8000303c:	ec26                	sd	s1,24(sp)
    8000303e:	e84a                	sd	s2,16(sp)
    80003040:	e44e                	sd	s3,8(sp)
    80003042:	1800                	addi	s0,sp,48
    80003044:	892a                	mv	s2,a0
    80003046:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003048:	00017497          	auipc	s1,0x17
    8000304c:	2c848493          	addi	s1,s1,712 # 8001a310 <log>
    80003050:	00004597          	auipc	a1,0x4
    80003054:	4f058593          	addi	a1,a1,1264 # 80007540 <etext+0x540>
    80003058:	8526                	mv	a0,s1
    8000305a:	037020ef          	jal	80005890 <initlock>
  log.start = sb->logstart;
    8000305e:	0149a583          	lw	a1,20(s3)
    80003062:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003064:	0109a783          	lw	a5,16(s3)
    80003068:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000306a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000306e:	854a                	mv	a0,s2
    80003070:	87cff0ef          	jal	800020ec <bread>
  log.lh.n = lh->n;
    80003074:	4d30                	lw	a2,88(a0)
    80003076:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003078:	00c05f63          	blez	a2,80003096 <initlog+0x60>
    8000307c:	87aa                	mv	a5,a0
    8000307e:	00017717          	auipc	a4,0x17
    80003082:	2c270713          	addi	a4,a4,706 # 8001a340 <log+0x30>
    80003086:	060a                	slli	a2,a2,0x2
    80003088:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000308a:	4ff4                	lw	a3,92(a5)
    8000308c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000308e:	0791                	addi	a5,a5,4
    80003090:	0711                	addi	a4,a4,4
    80003092:	fec79ce3          	bne	a5,a2,8000308a <initlog+0x54>
  brelse(buf);
    80003096:	95eff0ef          	jal	800021f4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000309a:	4505                	li	a0,1
    8000309c:	ef3ff0ef          	jal	80002f8e <install_trans>
  log.lh.n = 0;
    800030a0:	00017797          	auipc	a5,0x17
    800030a4:	2807ae23          	sw	zero,668(a5) # 8001a33c <log+0x2c>
  write_head(); // clear the log
    800030a8:	e89ff0ef          	jal	80002f30 <write_head>
}
    800030ac:	70a2                	ld	ra,40(sp)
    800030ae:	7402                	ld	s0,32(sp)
    800030b0:	64e2                	ld	s1,24(sp)
    800030b2:	6942                	ld	s2,16(sp)
    800030b4:	69a2                	ld	s3,8(sp)
    800030b6:	6145                	addi	sp,sp,48
    800030b8:	8082                	ret

00000000800030ba <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800030ba:	1101                	addi	sp,sp,-32
    800030bc:	ec06                	sd	ra,24(sp)
    800030be:	e822                	sd	s0,16(sp)
    800030c0:	e426                	sd	s1,8(sp)
    800030c2:	e04a                	sd	s2,0(sp)
    800030c4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800030c6:	00017517          	auipc	a0,0x17
    800030ca:	24a50513          	addi	a0,a0,586 # 8001a310 <log>
    800030ce:	043020ef          	jal	80005910 <acquire>
  while(1){
    if(log.committing){
    800030d2:	00017497          	auipc	s1,0x17
    800030d6:	23e48493          	addi	s1,s1,574 # 8001a310 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800030da:	4979                	li	s2,30
    800030dc:	a029                	j	800030e6 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030de:	85a6                	mv	a1,s1
    800030e0:	8526                	mv	a0,s1
    800030e2:	b78fe0ef          	jal	8000145a <sleep>
    if(log.committing){
    800030e6:	50dc                	lw	a5,36(s1)
    800030e8:	fbfd                	bnez	a5,800030de <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800030ea:	5098                	lw	a4,32(s1)
    800030ec:	2705                	addiw	a4,a4,1
    800030ee:	0027179b          	slliw	a5,a4,0x2
    800030f2:	9fb9                	addw	a5,a5,a4
    800030f4:	0017979b          	slliw	a5,a5,0x1
    800030f8:	54d4                	lw	a3,44(s1)
    800030fa:	9fb5                	addw	a5,a5,a3
    800030fc:	00f95763          	bge	s2,a5,8000310a <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003100:	85a6                	mv	a1,s1
    80003102:	8526                	mv	a0,s1
    80003104:	b56fe0ef          	jal	8000145a <sleep>
    80003108:	bff9                	j	800030e6 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000310a:	00017517          	auipc	a0,0x17
    8000310e:	20650513          	addi	a0,a0,518 # 8001a310 <log>
    80003112:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003114:	095020ef          	jal	800059a8 <release>
      break;
    }
  }
}
    80003118:	60e2                	ld	ra,24(sp)
    8000311a:	6442                	ld	s0,16(sp)
    8000311c:	64a2                	ld	s1,8(sp)
    8000311e:	6902                	ld	s2,0(sp)
    80003120:	6105                	addi	sp,sp,32
    80003122:	8082                	ret

0000000080003124 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003124:	7139                	addi	sp,sp,-64
    80003126:	fc06                	sd	ra,56(sp)
    80003128:	f822                	sd	s0,48(sp)
    8000312a:	f426                	sd	s1,40(sp)
    8000312c:	f04a                	sd	s2,32(sp)
    8000312e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003130:	00017497          	auipc	s1,0x17
    80003134:	1e048493          	addi	s1,s1,480 # 8001a310 <log>
    80003138:	8526                	mv	a0,s1
    8000313a:	7d6020ef          	jal	80005910 <acquire>
  log.outstanding -= 1;
    8000313e:	509c                	lw	a5,32(s1)
    80003140:	37fd                	addiw	a5,a5,-1
    80003142:	0007891b          	sext.w	s2,a5
    80003146:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003148:	50dc                	lw	a5,36(s1)
    8000314a:	ef9d                	bnez	a5,80003188 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    8000314c:	04091763          	bnez	s2,8000319a <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003150:	00017497          	auipc	s1,0x17
    80003154:	1c048493          	addi	s1,s1,448 # 8001a310 <log>
    80003158:	4785                	li	a5,1
    8000315a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000315c:	8526                	mv	a0,s1
    8000315e:	04b020ef          	jal	800059a8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003162:	54dc                	lw	a5,44(s1)
    80003164:	04f04b63          	bgtz	a5,800031ba <end_op+0x96>
    acquire(&log.lock);
    80003168:	00017497          	auipc	s1,0x17
    8000316c:	1a848493          	addi	s1,s1,424 # 8001a310 <log>
    80003170:	8526                	mv	a0,s1
    80003172:	79e020ef          	jal	80005910 <acquire>
    log.committing = 0;
    80003176:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000317a:	8526                	mv	a0,s1
    8000317c:	b2afe0ef          	jal	800014a6 <wakeup>
    release(&log.lock);
    80003180:	8526                	mv	a0,s1
    80003182:	027020ef          	jal	800059a8 <release>
}
    80003186:	a025                	j	800031ae <end_op+0x8a>
    80003188:	ec4e                	sd	s3,24(sp)
    8000318a:	e852                	sd	s4,16(sp)
    8000318c:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000318e:	00004517          	auipc	a0,0x4
    80003192:	3ba50513          	addi	a0,a0,954 # 80007548 <etext+0x548>
    80003196:	44c020ef          	jal	800055e2 <panic>
    wakeup(&log);
    8000319a:	00017497          	auipc	s1,0x17
    8000319e:	17648493          	addi	s1,s1,374 # 8001a310 <log>
    800031a2:	8526                	mv	a0,s1
    800031a4:	b02fe0ef          	jal	800014a6 <wakeup>
  release(&log.lock);
    800031a8:	8526                	mv	a0,s1
    800031aa:	7fe020ef          	jal	800059a8 <release>
}
    800031ae:	70e2                	ld	ra,56(sp)
    800031b0:	7442                	ld	s0,48(sp)
    800031b2:	74a2                	ld	s1,40(sp)
    800031b4:	7902                	ld	s2,32(sp)
    800031b6:	6121                	addi	sp,sp,64
    800031b8:	8082                	ret
    800031ba:	ec4e                	sd	s3,24(sp)
    800031bc:	e852                	sd	s4,16(sp)
    800031be:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800031c0:	00017a97          	auipc	s5,0x17
    800031c4:	180a8a93          	addi	s5,s5,384 # 8001a340 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800031c8:	00017a17          	auipc	s4,0x17
    800031cc:	148a0a13          	addi	s4,s4,328 # 8001a310 <log>
    800031d0:	018a2583          	lw	a1,24(s4)
    800031d4:	012585bb          	addw	a1,a1,s2
    800031d8:	2585                	addiw	a1,a1,1
    800031da:	028a2503          	lw	a0,40(s4)
    800031de:	f0ffe0ef          	jal	800020ec <bread>
    800031e2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800031e4:	000aa583          	lw	a1,0(s5)
    800031e8:	028a2503          	lw	a0,40(s4)
    800031ec:	f01fe0ef          	jal	800020ec <bread>
    800031f0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800031f2:	40000613          	li	a2,1024
    800031f6:	05850593          	addi	a1,a0,88
    800031fa:	05848513          	addi	a0,s1,88
    800031fe:	fadfc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    80003202:	8526                	mv	a0,s1
    80003204:	fbffe0ef          	jal	800021c2 <bwrite>
    brelse(from);
    80003208:	854e                	mv	a0,s3
    8000320a:	febfe0ef          	jal	800021f4 <brelse>
    brelse(to);
    8000320e:	8526                	mv	a0,s1
    80003210:	fe5fe0ef          	jal	800021f4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003214:	2905                	addiw	s2,s2,1
    80003216:	0a91                	addi	s5,s5,4
    80003218:	02ca2783          	lw	a5,44(s4)
    8000321c:	faf94ae3          	blt	s2,a5,800031d0 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003220:	d11ff0ef          	jal	80002f30 <write_head>
    install_trans(0); // Now install writes to home locations
    80003224:	4501                	li	a0,0
    80003226:	d69ff0ef          	jal	80002f8e <install_trans>
    log.lh.n = 0;
    8000322a:	00017797          	auipc	a5,0x17
    8000322e:	1007a923          	sw	zero,274(a5) # 8001a33c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003232:	cffff0ef          	jal	80002f30 <write_head>
    80003236:	69e2                	ld	s3,24(sp)
    80003238:	6a42                	ld	s4,16(sp)
    8000323a:	6aa2                	ld	s5,8(sp)
    8000323c:	b735                	j	80003168 <end_op+0x44>

000000008000323e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000323e:	1101                	addi	sp,sp,-32
    80003240:	ec06                	sd	ra,24(sp)
    80003242:	e822                	sd	s0,16(sp)
    80003244:	e426                	sd	s1,8(sp)
    80003246:	e04a                	sd	s2,0(sp)
    80003248:	1000                	addi	s0,sp,32
    8000324a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000324c:	00017917          	auipc	s2,0x17
    80003250:	0c490913          	addi	s2,s2,196 # 8001a310 <log>
    80003254:	854a                	mv	a0,s2
    80003256:	6ba020ef          	jal	80005910 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000325a:	02c92603          	lw	a2,44(s2)
    8000325e:	47f5                	li	a5,29
    80003260:	06c7c363          	blt	a5,a2,800032c6 <log_write+0x88>
    80003264:	00017797          	auipc	a5,0x17
    80003268:	0c87a783          	lw	a5,200(a5) # 8001a32c <log+0x1c>
    8000326c:	37fd                	addiw	a5,a5,-1
    8000326e:	04f65c63          	bge	a2,a5,800032c6 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003272:	00017797          	auipc	a5,0x17
    80003276:	0be7a783          	lw	a5,190(a5) # 8001a330 <log+0x20>
    8000327a:	04f05c63          	blez	a5,800032d2 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000327e:	4781                	li	a5,0
    80003280:	04c05f63          	blez	a2,800032de <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003284:	44cc                	lw	a1,12(s1)
    80003286:	00017717          	auipc	a4,0x17
    8000328a:	0ba70713          	addi	a4,a4,186 # 8001a340 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000328e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003290:	4314                	lw	a3,0(a4)
    80003292:	04b68663          	beq	a3,a1,800032de <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003296:	2785                	addiw	a5,a5,1
    80003298:	0711                	addi	a4,a4,4
    8000329a:	fef61be3          	bne	a2,a5,80003290 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000329e:	0621                	addi	a2,a2,8
    800032a0:	060a                	slli	a2,a2,0x2
    800032a2:	00017797          	auipc	a5,0x17
    800032a6:	06e78793          	addi	a5,a5,110 # 8001a310 <log>
    800032aa:	97b2                	add	a5,a5,a2
    800032ac:	44d8                	lw	a4,12(s1)
    800032ae:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800032b0:	8526                	mv	a0,s1
    800032b2:	fcbfe0ef          	jal	8000227c <bpin>
    log.lh.n++;
    800032b6:	00017717          	auipc	a4,0x17
    800032ba:	05a70713          	addi	a4,a4,90 # 8001a310 <log>
    800032be:	575c                	lw	a5,44(a4)
    800032c0:	2785                	addiw	a5,a5,1
    800032c2:	d75c                	sw	a5,44(a4)
    800032c4:	a80d                	j	800032f6 <log_write+0xb8>
    panic("too big a transaction");
    800032c6:	00004517          	auipc	a0,0x4
    800032ca:	29250513          	addi	a0,a0,658 # 80007558 <etext+0x558>
    800032ce:	314020ef          	jal	800055e2 <panic>
    panic("log_write outside of trans");
    800032d2:	00004517          	auipc	a0,0x4
    800032d6:	29e50513          	addi	a0,a0,670 # 80007570 <etext+0x570>
    800032da:	308020ef          	jal	800055e2 <panic>
  log.lh.block[i] = b->blockno;
    800032de:	00878693          	addi	a3,a5,8
    800032e2:	068a                	slli	a3,a3,0x2
    800032e4:	00017717          	auipc	a4,0x17
    800032e8:	02c70713          	addi	a4,a4,44 # 8001a310 <log>
    800032ec:	9736                	add	a4,a4,a3
    800032ee:	44d4                	lw	a3,12(s1)
    800032f0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800032f2:	faf60fe3          	beq	a2,a5,800032b0 <log_write+0x72>
  }
  release(&log.lock);
    800032f6:	00017517          	auipc	a0,0x17
    800032fa:	01a50513          	addi	a0,a0,26 # 8001a310 <log>
    800032fe:	6aa020ef          	jal	800059a8 <release>
}
    80003302:	60e2                	ld	ra,24(sp)
    80003304:	6442                	ld	s0,16(sp)
    80003306:	64a2                	ld	s1,8(sp)
    80003308:	6902                	ld	s2,0(sp)
    8000330a:	6105                	addi	sp,sp,32
    8000330c:	8082                	ret

000000008000330e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000330e:	1101                	addi	sp,sp,-32
    80003310:	ec06                	sd	ra,24(sp)
    80003312:	e822                	sd	s0,16(sp)
    80003314:	e426                	sd	s1,8(sp)
    80003316:	e04a                	sd	s2,0(sp)
    80003318:	1000                	addi	s0,sp,32
    8000331a:	84aa                	mv	s1,a0
    8000331c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000331e:	00004597          	auipc	a1,0x4
    80003322:	27258593          	addi	a1,a1,626 # 80007590 <etext+0x590>
    80003326:	0521                	addi	a0,a0,8
    80003328:	568020ef          	jal	80005890 <initlock>
  lk->name = name;
    8000332c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003330:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003334:	0204a423          	sw	zero,40(s1)
}
    80003338:	60e2                	ld	ra,24(sp)
    8000333a:	6442                	ld	s0,16(sp)
    8000333c:	64a2                	ld	s1,8(sp)
    8000333e:	6902                	ld	s2,0(sp)
    80003340:	6105                	addi	sp,sp,32
    80003342:	8082                	ret

0000000080003344 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003344:	1101                	addi	sp,sp,-32
    80003346:	ec06                	sd	ra,24(sp)
    80003348:	e822                	sd	s0,16(sp)
    8000334a:	e426                	sd	s1,8(sp)
    8000334c:	e04a                	sd	s2,0(sp)
    8000334e:	1000                	addi	s0,sp,32
    80003350:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003352:	00850913          	addi	s2,a0,8
    80003356:	854a                	mv	a0,s2
    80003358:	5b8020ef          	jal	80005910 <acquire>
  while (lk->locked) {
    8000335c:	409c                	lw	a5,0(s1)
    8000335e:	c799                	beqz	a5,8000336c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003360:	85ca                	mv	a1,s2
    80003362:	8526                	mv	a0,s1
    80003364:	8f6fe0ef          	jal	8000145a <sleep>
  while (lk->locked) {
    80003368:	409c                	lw	a5,0(s1)
    8000336a:	fbfd                	bnez	a5,80003360 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000336c:	4785                	li	a5,1
    8000336e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003370:	b1dfd0ef          	jal	80000e8c <myproc>
    80003374:	591c                	lw	a5,48(a0)
    80003376:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003378:	854a                	mv	a0,s2
    8000337a:	62e020ef          	jal	800059a8 <release>
}
    8000337e:	60e2                	ld	ra,24(sp)
    80003380:	6442                	ld	s0,16(sp)
    80003382:	64a2                	ld	s1,8(sp)
    80003384:	6902                	ld	s2,0(sp)
    80003386:	6105                	addi	sp,sp,32
    80003388:	8082                	ret

000000008000338a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000338a:	1101                	addi	sp,sp,-32
    8000338c:	ec06                	sd	ra,24(sp)
    8000338e:	e822                	sd	s0,16(sp)
    80003390:	e426                	sd	s1,8(sp)
    80003392:	e04a                	sd	s2,0(sp)
    80003394:	1000                	addi	s0,sp,32
    80003396:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003398:	00850913          	addi	s2,a0,8
    8000339c:	854a                	mv	a0,s2
    8000339e:	572020ef          	jal	80005910 <acquire>
  lk->locked = 0;
    800033a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800033a6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800033aa:	8526                	mv	a0,s1
    800033ac:	8fafe0ef          	jal	800014a6 <wakeup>
  release(&lk->lk);
    800033b0:	854a                	mv	a0,s2
    800033b2:	5f6020ef          	jal	800059a8 <release>
}
    800033b6:	60e2                	ld	ra,24(sp)
    800033b8:	6442                	ld	s0,16(sp)
    800033ba:	64a2                	ld	s1,8(sp)
    800033bc:	6902                	ld	s2,0(sp)
    800033be:	6105                	addi	sp,sp,32
    800033c0:	8082                	ret

00000000800033c2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800033c2:	7179                	addi	sp,sp,-48
    800033c4:	f406                	sd	ra,40(sp)
    800033c6:	f022                	sd	s0,32(sp)
    800033c8:	ec26                	sd	s1,24(sp)
    800033ca:	e84a                	sd	s2,16(sp)
    800033cc:	1800                	addi	s0,sp,48
    800033ce:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800033d0:	00850913          	addi	s2,a0,8
    800033d4:	854a                	mv	a0,s2
    800033d6:	53a020ef          	jal	80005910 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033da:	409c                	lw	a5,0(s1)
    800033dc:	ef81                	bnez	a5,800033f4 <holdingsleep+0x32>
    800033de:	4481                	li	s1,0
  release(&lk->lk);
    800033e0:	854a                	mv	a0,s2
    800033e2:	5c6020ef          	jal	800059a8 <release>
  return r;
}
    800033e6:	8526                	mv	a0,s1
    800033e8:	70a2                	ld	ra,40(sp)
    800033ea:	7402                	ld	s0,32(sp)
    800033ec:	64e2                	ld	s1,24(sp)
    800033ee:	6942                	ld	s2,16(sp)
    800033f0:	6145                	addi	sp,sp,48
    800033f2:	8082                	ret
    800033f4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800033f6:	0284a983          	lw	s3,40(s1)
    800033fa:	a93fd0ef          	jal	80000e8c <myproc>
    800033fe:	5904                	lw	s1,48(a0)
    80003400:	413484b3          	sub	s1,s1,s3
    80003404:	0014b493          	seqz	s1,s1
    80003408:	69a2                	ld	s3,8(sp)
    8000340a:	bfd9                	j	800033e0 <holdingsleep+0x1e>

000000008000340c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000340c:	1141                	addi	sp,sp,-16
    8000340e:	e406                	sd	ra,8(sp)
    80003410:	e022                	sd	s0,0(sp)
    80003412:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003414:	00004597          	auipc	a1,0x4
    80003418:	18c58593          	addi	a1,a1,396 # 800075a0 <etext+0x5a0>
    8000341c:	00017517          	auipc	a0,0x17
    80003420:	03c50513          	addi	a0,a0,60 # 8001a458 <ftable>
    80003424:	46c020ef          	jal	80005890 <initlock>
}
    80003428:	60a2                	ld	ra,8(sp)
    8000342a:	6402                	ld	s0,0(sp)
    8000342c:	0141                	addi	sp,sp,16
    8000342e:	8082                	ret

0000000080003430 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003430:	1101                	addi	sp,sp,-32
    80003432:	ec06                	sd	ra,24(sp)
    80003434:	e822                	sd	s0,16(sp)
    80003436:	e426                	sd	s1,8(sp)
    80003438:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000343a:	00017517          	auipc	a0,0x17
    8000343e:	01e50513          	addi	a0,a0,30 # 8001a458 <ftable>
    80003442:	4ce020ef          	jal	80005910 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003446:	00017497          	auipc	s1,0x17
    8000344a:	02a48493          	addi	s1,s1,42 # 8001a470 <ftable+0x18>
    8000344e:	00018717          	auipc	a4,0x18
    80003452:	fc270713          	addi	a4,a4,-62 # 8001b410 <disk>
    if(f->ref == 0){
    80003456:	40dc                	lw	a5,4(s1)
    80003458:	cf89                	beqz	a5,80003472 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000345a:	02848493          	addi	s1,s1,40
    8000345e:	fee49ce3          	bne	s1,a4,80003456 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003462:	00017517          	auipc	a0,0x17
    80003466:	ff650513          	addi	a0,a0,-10 # 8001a458 <ftable>
    8000346a:	53e020ef          	jal	800059a8 <release>
  return 0;
    8000346e:	4481                	li	s1,0
    80003470:	a809                	j	80003482 <filealloc+0x52>
      f->ref = 1;
    80003472:	4785                	li	a5,1
    80003474:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003476:	00017517          	auipc	a0,0x17
    8000347a:	fe250513          	addi	a0,a0,-30 # 8001a458 <ftable>
    8000347e:	52a020ef          	jal	800059a8 <release>
}
    80003482:	8526                	mv	a0,s1
    80003484:	60e2                	ld	ra,24(sp)
    80003486:	6442                	ld	s0,16(sp)
    80003488:	64a2                	ld	s1,8(sp)
    8000348a:	6105                	addi	sp,sp,32
    8000348c:	8082                	ret

000000008000348e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000348e:	1101                	addi	sp,sp,-32
    80003490:	ec06                	sd	ra,24(sp)
    80003492:	e822                	sd	s0,16(sp)
    80003494:	e426                	sd	s1,8(sp)
    80003496:	1000                	addi	s0,sp,32
    80003498:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000349a:	00017517          	auipc	a0,0x17
    8000349e:	fbe50513          	addi	a0,a0,-66 # 8001a458 <ftable>
    800034a2:	46e020ef          	jal	80005910 <acquire>
  if(f->ref < 1)
    800034a6:	40dc                	lw	a5,4(s1)
    800034a8:	02f05063          	blez	a5,800034c8 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800034ac:	2785                	addiw	a5,a5,1
    800034ae:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800034b0:	00017517          	auipc	a0,0x17
    800034b4:	fa850513          	addi	a0,a0,-88 # 8001a458 <ftable>
    800034b8:	4f0020ef          	jal	800059a8 <release>
  return f;
}
    800034bc:	8526                	mv	a0,s1
    800034be:	60e2                	ld	ra,24(sp)
    800034c0:	6442                	ld	s0,16(sp)
    800034c2:	64a2                	ld	s1,8(sp)
    800034c4:	6105                	addi	sp,sp,32
    800034c6:	8082                	ret
    panic("filedup");
    800034c8:	00004517          	auipc	a0,0x4
    800034cc:	0e050513          	addi	a0,a0,224 # 800075a8 <etext+0x5a8>
    800034d0:	112020ef          	jal	800055e2 <panic>

00000000800034d4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800034d4:	7139                	addi	sp,sp,-64
    800034d6:	fc06                	sd	ra,56(sp)
    800034d8:	f822                	sd	s0,48(sp)
    800034da:	f426                	sd	s1,40(sp)
    800034dc:	0080                	addi	s0,sp,64
    800034de:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800034e0:	00017517          	auipc	a0,0x17
    800034e4:	f7850513          	addi	a0,a0,-136 # 8001a458 <ftable>
    800034e8:	428020ef          	jal	80005910 <acquire>
  if(f->ref < 1)
    800034ec:	40dc                	lw	a5,4(s1)
    800034ee:	04f05a63          	blez	a5,80003542 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800034f2:	37fd                	addiw	a5,a5,-1
    800034f4:	0007871b          	sext.w	a4,a5
    800034f8:	c0dc                	sw	a5,4(s1)
    800034fa:	04e04e63          	bgtz	a4,80003556 <fileclose+0x82>
    800034fe:	f04a                	sd	s2,32(sp)
    80003500:	ec4e                	sd	s3,24(sp)
    80003502:	e852                	sd	s4,16(sp)
    80003504:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003506:	0004a903          	lw	s2,0(s1)
    8000350a:	0094ca83          	lbu	s5,9(s1)
    8000350e:	0104ba03          	ld	s4,16(s1)
    80003512:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003516:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000351a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000351e:	00017517          	auipc	a0,0x17
    80003522:	f3a50513          	addi	a0,a0,-198 # 8001a458 <ftable>
    80003526:	482020ef          	jal	800059a8 <release>

  if(ff.type == FD_PIPE){
    8000352a:	4785                	li	a5,1
    8000352c:	04f90063          	beq	s2,a5,8000356c <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003530:	3979                	addiw	s2,s2,-2
    80003532:	4785                	li	a5,1
    80003534:	0527f563          	bgeu	a5,s2,8000357e <fileclose+0xaa>
    80003538:	7902                	ld	s2,32(sp)
    8000353a:	69e2                	ld	s3,24(sp)
    8000353c:	6a42                	ld	s4,16(sp)
    8000353e:	6aa2                	ld	s5,8(sp)
    80003540:	a00d                	j	80003562 <fileclose+0x8e>
    80003542:	f04a                	sd	s2,32(sp)
    80003544:	ec4e                	sd	s3,24(sp)
    80003546:	e852                	sd	s4,16(sp)
    80003548:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000354a:	00004517          	auipc	a0,0x4
    8000354e:	06650513          	addi	a0,a0,102 # 800075b0 <etext+0x5b0>
    80003552:	090020ef          	jal	800055e2 <panic>
    release(&ftable.lock);
    80003556:	00017517          	auipc	a0,0x17
    8000355a:	f0250513          	addi	a0,a0,-254 # 8001a458 <ftable>
    8000355e:	44a020ef          	jal	800059a8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003562:	70e2                	ld	ra,56(sp)
    80003564:	7442                	ld	s0,48(sp)
    80003566:	74a2                	ld	s1,40(sp)
    80003568:	6121                	addi	sp,sp,64
    8000356a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000356c:	85d6                	mv	a1,s5
    8000356e:	8552                	mv	a0,s4
    80003570:	336000ef          	jal	800038a6 <pipeclose>
    80003574:	7902                	ld	s2,32(sp)
    80003576:	69e2                	ld	s3,24(sp)
    80003578:	6a42                	ld	s4,16(sp)
    8000357a:	6aa2                	ld	s5,8(sp)
    8000357c:	b7dd                	j	80003562 <fileclose+0x8e>
    begin_op();
    8000357e:	b3dff0ef          	jal	800030ba <begin_op>
    iput(ff.ip);
    80003582:	854e                	mv	a0,s3
    80003584:	c22ff0ef          	jal	800029a6 <iput>
    end_op();
    80003588:	b9dff0ef          	jal	80003124 <end_op>
    8000358c:	7902                	ld	s2,32(sp)
    8000358e:	69e2                	ld	s3,24(sp)
    80003590:	6a42                	ld	s4,16(sp)
    80003592:	6aa2                	ld	s5,8(sp)
    80003594:	b7f9                	j	80003562 <fileclose+0x8e>

0000000080003596 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003596:	715d                	addi	sp,sp,-80
    80003598:	e486                	sd	ra,72(sp)
    8000359a:	e0a2                	sd	s0,64(sp)
    8000359c:	fc26                	sd	s1,56(sp)
    8000359e:	f44e                	sd	s3,40(sp)
    800035a0:	0880                	addi	s0,sp,80
    800035a2:	84aa                	mv	s1,a0
    800035a4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800035a6:	8e7fd0ef          	jal	80000e8c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800035aa:	409c                	lw	a5,0(s1)
    800035ac:	37f9                	addiw	a5,a5,-2
    800035ae:	4705                	li	a4,1
    800035b0:	04f76063          	bltu	a4,a5,800035f0 <filestat+0x5a>
    800035b4:	f84a                	sd	s2,48(sp)
    800035b6:	892a                	mv	s2,a0
    ilock(f->ip);
    800035b8:	6c88                	ld	a0,24(s1)
    800035ba:	a6aff0ef          	jal	80002824 <ilock>
    stati(f->ip, &st);
    800035be:	fb840593          	addi	a1,s0,-72
    800035c2:	6c88                	ld	a0,24(s1)
    800035c4:	c8aff0ef          	jal	80002a4e <stati>
    iunlock(f->ip);
    800035c8:	6c88                	ld	a0,24(s1)
    800035ca:	b08ff0ef          	jal	800028d2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800035ce:	46e1                	li	a3,24
    800035d0:	fb840613          	addi	a2,s0,-72
    800035d4:	85ce                	mv	a1,s3
    800035d6:	05093503          	ld	a0,80(s2)
    800035da:	c0efd0ef          	jal	800009e8 <copyout>
    800035de:	41f5551b          	sraiw	a0,a0,0x1f
    800035e2:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800035e4:	60a6                	ld	ra,72(sp)
    800035e6:	6406                	ld	s0,64(sp)
    800035e8:	74e2                	ld	s1,56(sp)
    800035ea:	79a2                	ld	s3,40(sp)
    800035ec:	6161                	addi	sp,sp,80
    800035ee:	8082                	ret
  return -1;
    800035f0:	557d                	li	a0,-1
    800035f2:	bfcd                	j	800035e4 <filestat+0x4e>

00000000800035f4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800035f4:	7179                	addi	sp,sp,-48
    800035f6:	f406                	sd	ra,40(sp)
    800035f8:	f022                	sd	s0,32(sp)
    800035fa:	e84a                	sd	s2,16(sp)
    800035fc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035fe:	00854783          	lbu	a5,8(a0)
    80003602:	cfd1                	beqz	a5,8000369e <fileread+0xaa>
    80003604:	ec26                	sd	s1,24(sp)
    80003606:	e44e                	sd	s3,8(sp)
    80003608:	84aa                	mv	s1,a0
    8000360a:	89ae                	mv	s3,a1
    8000360c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000360e:	411c                	lw	a5,0(a0)
    80003610:	4705                	li	a4,1
    80003612:	04e78363          	beq	a5,a4,80003658 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003616:	470d                	li	a4,3
    80003618:	04e78763          	beq	a5,a4,80003666 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000361c:	4709                	li	a4,2
    8000361e:	06e79a63          	bne	a5,a4,80003692 <fileread+0x9e>
    ilock(f->ip);
    80003622:	6d08                	ld	a0,24(a0)
    80003624:	a00ff0ef          	jal	80002824 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003628:	874a                	mv	a4,s2
    8000362a:	5094                	lw	a3,32(s1)
    8000362c:	864e                	mv	a2,s3
    8000362e:	4585                	li	a1,1
    80003630:	6c88                	ld	a0,24(s1)
    80003632:	c46ff0ef          	jal	80002a78 <readi>
    80003636:	892a                	mv	s2,a0
    80003638:	00a05563          	blez	a0,80003642 <fileread+0x4e>
      f->off += r;
    8000363c:	509c                	lw	a5,32(s1)
    8000363e:	9fa9                	addw	a5,a5,a0
    80003640:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003642:	6c88                	ld	a0,24(s1)
    80003644:	a8eff0ef          	jal	800028d2 <iunlock>
    80003648:	64e2                	ld	s1,24(sp)
    8000364a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000364c:	854a                	mv	a0,s2
    8000364e:	70a2                	ld	ra,40(sp)
    80003650:	7402                	ld	s0,32(sp)
    80003652:	6942                	ld	s2,16(sp)
    80003654:	6145                	addi	sp,sp,48
    80003656:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003658:	6908                	ld	a0,16(a0)
    8000365a:	388000ef          	jal	800039e2 <piperead>
    8000365e:	892a                	mv	s2,a0
    80003660:	64e2                	ld	s1,24(sp)
    80003662:	69a2                	ld	s3,8(sp)
    80003664:	b7e5                	j	8000364c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003666:	02451783          	lh	a5,36(a0)
    8000366a:	03079693          	slli	a3,a5,0x30
    8000366e:	92c1                	srli	a3,a3,0x30
    80003670:	4725                	li	a4,9
    80003672:	02d76863          	bltu	a4,a3,800036a2 <fileread+0xae>
    80003676:	0792                	slli	a5,a5,0x4
    80003678:	00017717          	auipc	a4,0x17
    8000367c:	d4070713          	addi	a4,a4,-704 # 8001a3b8 <devsw>
    80003680:	97ba                	add	a5,a5,a4
    80003682:	639c                	ld	a5,0(a5)
    80003684:	c39d                	beqz	a5,800036aa <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003686:	4505                	li	a0,1
    80003688:	9782                	jalr	a5
    8000368a:	892a                	mv	s2,a0
    8000368c:	64e2                	ld	s1,24(sp)
    8000368e:	69a2                	ld	s3,8(sp)
    80003690:	bf75                	j	8000364c <fileread+0x58>
    panic("fileread");
    80003692:	00004517          	auipc	a0,0x4
    80003696:	f2e50513          	addi	a0,a0,-210 # 800075c0 <etext+0x5c0>
    8000369a:	749010ef          	jal	800055e2 <panic>
    return -1;
    8000369e:	597d                	li	s2,-1
    800036a0:	b775                	j	8000364c <fileread+0x58>
      return -1;
    800036a2:	597d                	li	s2,-1
    800036a4:	64e2                	ld	s1,24(sp)
    800036a6:	69a2                	ld	s3,8(sp)
    800036a8:	b755                	j	8000364c <fileread+0x58>
    800036aa:	597d                	li	s2,-1
    800036ac:	64e2                	ld	s1,24(sp)
    800036ae:	69a2                	ld	s3,8(sp)
    800036b0:	bf71                	j	8000364c <fileread+0x58>

00000000800036b2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800036b2:	00954783          	lbu	a5,9(a0)
    800036b6:	10078b63          	beqz	a5,800037cc <filewrite+0x11a>
{
    800036ba:	715d                	addi	sp,sp,-80
    800036bc:	e486                	sd	ra,72(sp)
    800036be:	e0a2                	sd	s0,64(sp)
    800036c0:	f84a                	sd	s2,48(sp)
    800036c2:	f052                	sd	s4,32(sp)
    800036c4:	e85a                	sd	s6,16(sp)
    800036c6:	0880                	addi	s0,sp,80
    800036c8:	892a                	mv	s2,a0
    800036ca:	8b2e                	mv	s6,a1
    800036cc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800036ce:	411c                	lw	a5,0(a0)
    800036d0:	4705                	li	a4,1
    800036d2:	02e78763          	beq	a5,a4,80003700 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036d6:	470d                	li	a4,3
    800036d8:	02e78863          	beq	a5,a4,80003708 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800036dc:	4709                	li	a4,2
    800036de:	0ce79c63          	bne	a5,a4,800037b6 <filewrite+0x104>
    800036e2:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800036e4:	0ac05863          	blez	a2,80003794 <filewrite+0xe2>
    800036e8:	fc26                	sd	s1,56(sp)
    800036ea:	ec56                	sd	s5,24(sp)
    800036ec:	e45e                	sd	s7,8(sp)
    800036ee:	e062                	sd	s8,0(sp)
    int i = 0;
    800036f0:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800036f2:	6b85                	lui	s7,0x1
    800036f4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800036f8:	6c05                	lui	s8,0x1
    800036fa:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800036fe:	a8b5                	j	8000377a <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003700:	6908                	ld	a0,16(a0)
    80003702:	1fc000ef          	jal	800038fe <pipewrite>
    80003706:	a04d                	j	800037a8 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003708:	02451783          	lh	a5,36(a0)
    8000370c:	03079693          	slli	a3,a5,0x30
    80003710:	92c1                	srli	a3,a3,0x30
    80003712:	4725                	li	a4,9
    80003714:	0ad76e63          	bltu	a4,a3,800037d0 <filewrite+0x11e>
    80003718:	0792                	slli	a5,a5,0x4
    8000371a:	00017717          	auipc	a4,0x17
    8000371e:	c9e70713          	addi	a4,a4,-866 # 8001a3b8 <devsw>
    80003722:	97ba                	add	a5,a5,a4
    80003724:	679c                	ld	a5,8(a5)
    80003726:	c7dd                	beqz	a5,800037d4 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003728:	4505                	li	a0,1
    8000372a:	9782                	jalr	a5
    8000372c:	a8b5                	j	800037a8 <filewrite+0xf6>
      if(n1 > max)
    8000372e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003732:	989ff0ef          	jal	800030ba <begin_op>
      ilock(f->ip);
    80003736:	01893503          	ld	a0,24(s2)
    8000373a:	8eaff0ef          	jal	80002824 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000373e:	8756                	mv	a4,s5
    80003740:	02092683          	lw	a3,32(s2)
    80003744:	01698633          	add	a2,s3,s6
    80003748:	4585                	li	a1,1
    8000374a:	01893503          	ld	a0,24(s2)
    8000374e:	c26ff0ef          	jal	80002b74 <writei>
    80003752:	84aa                	mv	s1,a0
    80003754:	00a05763          	blez	a0,80003762 <filewrite+0xb0>
        f->off += r;
    80003758:	02092783          	lw	a5,32(s2)
    8000375c:	9fa9                	addw	a5,a5,a0
    8000375e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003762:	01893503          	ld	a0,24(s2)
    80003766:	96cff0ef          	jal	800028d2 <iunlock>
      end_op();
    8000376a:	9bbff0ef          	jal	80003124 <end_op>

      if(r != n1){
    8000376e:	029a9563          	bne	s5,s1,80003798 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80003772:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003776:	0149da63          	bge	s3,s4,8000378a <filewrite+0xd8>
      int n1 = n - i;
    8000377a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000377e:	0004879b          	sext.w	a5,s1
    80003782:	fafbd6e3          	bge	s7,a5,8000372e <filewrite+0x7c>
    80003786:	84e2                	mv	s1,s8
    80003788:	b75d                	j	8000372e <filewrite+0x7c>
    8000378a:	74e2                	ld	s1,56(sp)
    8000378c:	6ae2                	ld	s5,24(sp)
    8000378e:	6ba2                	ld	s7,8(sp)
    80003790:	6c02                	ld	s8,0(sp)
    80003792:	a039                	j	800037a0 <filewrite+0xee>
    int i = 0;
    80003794:	4981                	li	s3,0
    80003796:	a029                	j	800037a0 <filewrite+0xee>
    80003798:	74e2                	ld	s1,56(sp)
    8000379a:	6ae2                	ld	s5,24(sp)
    8000379c:	6ba2                	ld	s7,8(sp)
    8000379e:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800037a0:	033a1c63          	bne	s4,s3,800037d8 <filewrite+0x126>
    800037a4:	8552                	mv	a0,s4
    800037a6:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800037a8:	60a6                	ld	ra,72(sp)
    800037aa:	6406                	ld	s0,64(sp)
    800037ac:	7942                	ld	s2,48(sp)
    800037ae:	7a02                	ld	s4,32(sp)
    800037b0:	6b42                	ld	s6,16(sp)
    800037b2:	6161                	addi	sp,sp,80
    800037b4:	8082                	ret
    800037b6:	fc26                	sd	s1,56(sp)
    800037b8:	f44e                	sd	s3,40(sp)
    800037ba:	ec56                	sd	s5,24(sp)
    800037bc:	e45e                	sd	s7,8(sp)
    800037be:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800037c0:	00004517          	auipc	a0,0x4
    800037c4:	e1050513          	addi	a0,a0,-496 # 800075d0 <etext+0x5d0>
    800037c8:	61b010ef          	jal	800055e2 <panic>
    return -1;
    800037cc:	557d                	li	a0,-1
}
    800037ce:	8082                	ret
      return -1;
    800037d0:	557d                	li	a0,-1
    800037d2:	bfd9                	j	800037a8 <filewrite+0xf6>
    800037d4:	557d                	li	a0,-1
    800037d6:	bfc9                	j	800037a8 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800037d8:	557d                	li	a0,-1
    800037da:	79a2                	ld	s3,40(sp)
    800037dc:	b7f1                	j	800037a8 <filewrite+0xf6>

00000000800037de <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800037de:	7179                	addi	sp,sp,-48
    800037e0:	f406                	sd	ra,40(sp)
    800037e2:	f022                	sd	s0,32(sp)
    800037e4:	ec26                	sd	s1,24(sp)
    800037e6:	e052                	sd	s4,0(sp)
    800037e8:	1800                	addi	s0,sp,48
    800037ea:	84aa                	mv	s1,a0
    800037ec:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037ee:	0005b023          	sd	zero,0(a1)
    800037f2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037f6:	c3bff0ef          	jal	80003430 <filealloc>
    800037fa:	e088                	sd	a0,0(s1)
    800037fc:	c549                	beqz	a0,80003886 <pipealloc+0xa8>
    800037fe:	c33ff0ef          	jal	80003430 <filealloc>
    80003802:	00aa3023          	sd	a0,0(s4)
    80003806:	cd25                	beqz	a0,8000387e <pipealloc+0xa0>
    80003808:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000380a:	8f5fc0ef          	jal	800000fe <kalloc>
    8000380e:	892a                	mv	s2,a0
    80003810:	c12d                	beqz	a0,80003872 <pipealloc+0x94>
    80003812:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003814:	4985                	li	s3,1
    80003816:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000381a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000381e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003822:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003826:	00004597          	auipc	a1,0x4
    8000382a:	dba58593          	addi	a1,a1,-582 # 800075e0 <etext+0x5e0>
    8000382e:	062020ef          	jal	80005890 <initlock>
  (*f0)->type = FD_PIPE;
    80003832:	609c                	ld	a5,0(s1)
    80003834:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003838:	609c                	ld	a5,0(s1)
    8000383a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000383e:	609c                	ld	a5,0(s1)
    80003840:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003844:	609c                	ld	a5,0(s1)
    80003846:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000384a:	000a3783          	ld	a5,0(s4)
    8000384e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003852:	000a3783          	ld	a5,0(s4)
    80003856:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000385a:	000a3783          	ld	a5,0(s4)
    8000385e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003862:	000a3783          	ld	a5,0(s4)
    80003866:	0127b823          	sd	s2,16(a5)
  return 0;
    8000386a:	4501                	li	a0,0
    8000386c:	6942                	ld	s2,16(sp)
    8000386e:	69a2                	ld	s3,8(sp)
    80003870:	a01d                	j	80003896 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003872:	6088                	ld	a0,0(s1)
    80003874:	c119                	beqz	a0,8000387a <pipealloc+0x9c>
    80003876:	6942                	ld	s2,16(sp)
    80003878:	a029                	j	80003882 <pipealloc+0xa4>
    8000387a:	6942                	ld	s2,16(sp)
    8000387c:	a029                	j	80003886 <pipealloc+0xa8>
    8000387e:	6088                	ld	a0,0(s1)
    80003880:	c10d                	beqz	a0,800038a2 <pipealloc+0xc4>
    fileclose(*f0);
    80003882:	c53ff0ef          	jal	800034d4 <fileclose>
  if(*f1)
    80003886:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000388a:	557d                	li	a0,-1
  if(*f1)
    8000388c:	c789                	beqz	a5,80003896 <pipealloc+0xb8>
    fileclose(*f1);
    8000388e:	853e                	mv	a0,a5
    80003890:	c45ff0ef          	jal	800034d4 <fileclose>
  return -1;
    80003894:	557d                	li	a0,-1
}
    80003896:	70a2                	ld	ra,40(sp)
    80003898:	7402                	ld	s0,32(sp)
    8000389a:	64e2                	ld	s1,24(sp)
    8000389c:	6a02                	ld	s4,0(sp)
    8000389e:	6145                	addi	sp,sp,48
    800038a0:	8082                	ret
  return -1;
    800038a2:	557d                	li	a0,-1
    800038a4:	bfcd                	j	80003896 <pipealloc+0xb8>

00000000800038a6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800038a6:	1101                	addi	sp,sp,-32
    800038a8:	ec06                	sd	ra,24(sp)
    800038aa:	e822                	sd	s0,16(sp)
    800038ac:	e426                	sd	s1,8(sp)
    800038ae:	e04a                	sd	s2,0(sp)
    800038b0:	1000                	addi	s0,sp,32
    800038b2:	84aa                	mv	s1,a0
    800038b4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800038b6:	05a020ef          	jal	80005910 <acquire>
  if(writable){
    800038ba:	02090763          	beqz	s2,800038e8 <pipeclose+0x42>
    pi->writeopen = 0;
    800038be:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800038c2:	21848513          	addi	a0,s1,536
    800038c6:	be1fd0ef          	jal	800014a6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800038ca:	2204b783          	ld	a5,544(s1)
    800038ce:	e785                	bnez	a5,800038f6 <pipeclose+0x50>
    release(&pi->lock);
    800038d0:	8526                	mv	a0,s1
    800038d2:	0d6020ef          	jal	800059a8 <release>
    kfree((char*)pi);
    800038d6:	8526                	mv	a0,s1
    800038d8:	f44fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800038dc:	60e2                	ld	ra,24(sp)
    800038de:	6442                	ld	s0,16(sp)
    800038e0:	64a2                	ld	s1,8(sp)
    800038e2:	6902                	ld	s2,0(sp)
    800038e4:	6105                	addi	sp,sp,32
    800038e6:	8082                	ret
    pi->readopen = 0;
    800038e8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038ec:	21c48513          	addi	a0,s1,540
    800038f0:	bb7fd0ef          	jal	800014a6 <wakeup>
    800038f4:	bfd9                	j	800038ca <pipeclose+0x24>
    release(&pi->lock);
    800038f6:	8526                	mv	a0,s1
    800038f8:	0b0020ef          	jal	800059a8 <release>
}
    800038fc:	b7c5                	j	800038dc <pipeclose+0x36>

00000000800038fe <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038fe:	711d                	addi	sp,sp,-96
    80003900:	ec86                	sd	ra,88(sp)
    80003902:	e8a2                	sd	s0,80(sp)
    80003904:	e4a6                	sd	s1,72(sp)
    80003906:	e0ca                	sd	s2,64(sp)
    80003908:	fc4e                	sd	s3,56(sp)
    8000390a:	f852                	sd	s4,48(sp)
    8000390c:	f456                	sd	s5,40(sp)
    8000390e:	1080                	addi	s0,sp,96
    80003910:	84aa                	mv	s1,a0
    80003912:	8aae                	mv	s5,a1
    80003914:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003916:	d76fd0ef          	jal	80000e8c <myproc>
    8000391a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000391c:	8526                	mv	a0,s1
    8000391e:	7f3010ef          	jal	80005910 <acquire>
  while(i < n){
    80003922:	0b405a63          	blez	s4,800039d6 <pipewrite+0xd8>
    80003926:	f05a                	sd	s6,32(sp)
    80003928:	ec5e                	sd	s7,24(sp)
    8000392a:	e862                	sd	s8,16(sp)
  int i = 0;
    8000392c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000392e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003930:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003934:	21c48b93          	addi	s7,s1,540
    80003938:	a81d                	j	8000396e <pipewrite+0x70>
      release(&pi->lock);
    8000393a:	8526                	mv	a0,s1
    8000393c:	06c020ef          	jal	800059a8 <release>
      return -1;
    80003940:	597d                	li	s2,-1
    80003942:	7b02                	ld	s6,32(sp)
    80003944:	6be2                	ld	s7,24(sp)
    80003946:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003948:	854a                	mv	a0,s2
    8000394a:	60e6                	ld	ra,88(sp)
    8000394c:	6446                	ld	s0,80(sp)
    8000394e:	64a6                	ld	s1,72(sp)
    80003950:	6906                	ld	s2,64(sp)
    80003952:	79e2                	ld	s3,56(sp)
    80003954:	7a42                	ld	s4,48(sp)
    80003956:	7aa2                	ld	s5,40(sp)
    80003958:	6125                	addi	sp,sp,96
    8000395a:	8082                	ret
      wakeup(&pi->nread);
    8000395c:	8562                	mv	a0,s8
    8000395e:	b49fd0ef          	jal	800014a6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003962:	85a6                	mv	a1,s1
    80003964:	855e                	mv	a0,s7
    80003966:	af5fd0ef          	jal	8000145a <sleep>
  while(i < n){
    8000396a:	05495b63          	bge	s2,s4,800039c0 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000396e:	2204a783          	lw	a5,544(s1)
    80003972:	d7e1                	beqz	a5,8000393a <pipewrite+0x3c>
    80003974:	854e                	mv	a0,s3
    80003976:	d1dfd0ef          	jal	80001692 <killed>
    8000397a:	f161                	bnez	a0,8000393a <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000397c:	2184a783          	lw	a5,536(s1)
    80003980:	21c4a703          	lw	a4,540(s1)
    80003984:	2007879b          	addiw	a5,a5,512
    80003988:	fcf70ae3          	beq	a4,a5,8000395c <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000398c:	4685                	li	a3,1
    8000398e:	01590633          	add	a2,s2,s5
    80003992:	faf40593          	addi	a1,s0,-81
    80003996:	0509b503          	ld	a0,80(s3)
    8000399a:	926fd0ef          	jal	80000ac0 <copyin>
    8000399e:	03650e63          	beq	a0,s6,800039da <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800039a2:	21c4a783          	lw	a5,540(s1)
    800039a6:	0017871b          	addiw	a4,a5,1
    800039aa:	20e4ae23          	sw	a4,540(s1)
    800039ae:	1ff7f793          	andi	a5,a5,511
    800039b2:	97a6                	add	a5,a5,s1
    800039b4:	faf44703          	lbu	a4,-81(s0)
    800039b8:	00e78c23          	sb	a4,24(a5)
      i++;
    800039bc:	2905                	addiw	s2,s2,1
    800039be:	b775                	j	8000396a <pipewrite+0x6c>
    800039c0:	7b02                	ld	s6,32(sp)
    800039c2:	6be2                	ld	s7,24(sp)
    800039c4:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800039c6:	21848513          	addi	a0,s1,536
    800039ca:	addfd0ef          	jal	800014a6 <wakeup>
  release(&pi->lock);
    800039ce:	8526                	mv	a0,s1
    800039d0:	7d9010ef          	jal	800059a8 <release>
  return i;
    800039d4:	bf95                	j	80003948 <pipewrite+0x4a>
  int i = 0;
    800039d6:	4901                	li	s2,0
    800039d8:	b7fd                	j	800039c6 <pipewrite+0xc8>
    800039da:	7b02                	ld	s6,32(sp)
    800039dc:	6be2                	ld	s7,24(sp)
    800039de:	6c42                	ld	s8,16(sp)
    800039e0:	b7dd                	j	800039c6 <pipewrite+0xc8>

00000000800039e2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800039e2:	715d                	addi	sp,sp,-80
    800039e4:	e486                	sd	ra,72(sp)
    800039e6:	e0a2                	sd	s0,64(sp)
    800039e8:	fc26                	sd	s1,56(sp)
    800039ea:	f84a                	sd	s2,48(sp)
    800039ec:	f44e                	sd	s3,40(sp)
    800039ee:	f052                	sd	s4,32(sp)
    800039f0:	ec56                	sd	s5,24(sp)
    800039f2:	0880                	addi	s0,sp,80
    800039f4:	84aa                	mv	s1,a0
    800039f6:	892e                	mv	s2,a1
    800039f8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039fa:	c92fd0ef          	jal	80000e8c <myproc>
    800039fe:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003a00:	8526                	mv	a0,s1
    80003a02:	70f010ef          	jal	80005910 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a06:	2184a703          	lw	a4,536(s1)
    80003a0a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a0e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a12:	02f71563          	bne	a4,a5,80003a3c <piperead+0x5a>
    80003a16:	2244a783          	lw	a5,548(s1)
    80003a1a:	cb85                	beqz	a5,80003a4a <piperead+0x68>
    if(killed(pr)){
    80003a1c:	8552                	mv	a0,s4
    80003a1e:	c75fd0ef          	jal	80001692 <killed>
    80003a22:	ed19                	bnez	a0,80003a40 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a24:	85a6                	mv	a1,s1
    80003a26:	854e                	mv	a0,s3
    80003a28:	a33fd0ef          	jal	8000145a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a2c:	2184a703          	lw	a4,536(s1)
    80003a30:	21c4a783          	lw	a5,540(s1)
    80003a34:	fef701e3          	beq	a4,a5,80003a16 <piperead+0x34>
    80003a38:	e85a                	sd	s6,16(sp)
    80003a3a:	a809                	j	80003a4c <piperead+0x6a>
    80003a3c:	e85a                	sd	s6,16(sp)
    80003a3e:	a039                	j	80003a4c <piperead+0x6a>
      release(&pi->lock);
    80003a40:	8526                	mv	a0,s1
    80003a42:	767010ef          	jal	800059a8 <release>
      return -1;
    80003a46:	59fd                	li	s3,-1
    80003a48:	a8b1                	j	80003aa4 <piperead+0xc2>
    80003a4a:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a4c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a4e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a50:	05505263          	blez	s5,80003a94 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003a54:	2184a783          	lw	a5,536(s1)
    80003a58:	21c4a703          	lw	a4,540(s1)
    80003a5c:	02f70c63          	beq	a4,a5,80003a94 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a60:	0017871b          	addiw	a4,a5,1
    80003a64:	20e4ac23          	sw	a4,536(s1)
    80003a68:	1ff7f793          	andi	a5,a5,511
    80003a6c:	97a6                	add	a5,a5,s1
    80003a6e:	0187c783          	lbu	a5,24(a5)
    80003a72:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a76:	4685                	li	a3,1
    80003a78:	fbf40613          	addi	a2,s0,-65
    80003a7c:	85ca                	mv	a1,s2
    80003a7e:	050a3503          	ld	a0,80(s4)
    80003a82:	f67fc0ef          	jal	800009e8 <copyout>
    80003a86:	01650763          	beq	a0,s6,80003a94 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a8a:	2985                	addiw	s3,s3,1
    80003a8c:	0905                	addi	s2,s2,1
    80003a8e:	fd3a93e3          	bne	s5,s3,80003a54 <piperead+0x72>
    80003a92:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a94:	21c48513          	addi	a0,s1,540
    80003a98:	a0ffd0ef          	jal	800014a6 <wakeup>
  release(&pi->lock);
    80003a9c:	8526                	mv	a0,s1
    80003a9e:	70b010ef          	jal	800059a8 <release>
    80003aa2:	6b42                	ld	s6,16(sp)
  return i;
}
    80003aa4:	854e                	mv	a0,s3
    80003aa6:	60a6                	ld	ra,72(sp)
    80003aa8:	6406                	ld	s0,64(sp)
    80003aaa:	74e2                	ld	s1,56(sp)
    80003aac:	7942                	ld	s2,48(sp)
    80003aae:	79a2                	ld	s3,40(sp)
    80003ab0:	7a02                	ld	s4,32(sp)
    80003ab2:	6ae2                	ld	s5,24(sp)
    80003ab4:	6161                	addi	sp,sp,80
    80003ab6:	8082                	ret

0000000080003ab8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003ab8:	1141                	addi	sp,sp,-16
    80003aba:	e422                	sd	s0,8(sp)
    80003abc:	0800                	addi	s0,sp,16
    80003abe:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003ac0:	8905                	andi	a0,a0,1
    80003ac2:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003ac4:	8b89                	andi	a5,a5,2
    80003ac6:	c399                	beqz	a5,80003acc <flags2perm+0x14>
      perm |= PTE_W;
    80003ac8:	00456513          	ori	a0,a0,4
    return perm;
}
    80003acc:	6422                	ld	s0,8(sp)
    80003ace:	0141                	addi	sp,sp,16
    80003ad0:	8082                	ret

0000000080003ad2 <exec>:

int
exec(char *path, char **argv)
{
    80003ad2:	df010113          	addi	sp,sp,-528
    80003ad6:	20113423          	sd	ra,520(sp)
    80003ada:	20813023          	sd	s0,512(sp)
    80003ade:	ffa6                	sd	s1,504(sp)
    80003ae0:	fbca                	sd	s2,496(sp)
    80003ae2:	0c00                	addi	s0,sp,528
    80003ae4:	892a                	mv	s2,a0
    80003ae6:	dea43c23          	sd	a0,-520(s0)
    80003aea:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003aee:	b9efd0ef          	jal	80000e8c <myproc>
    80003af2:	84aa                	mv	s1,a0

  begin_op();
    80003af4:	dc6ff0ef          	jal	800030ba <begin_op>

  if((ip = namei(path)) == 0){
    80003af8:	854a                	mv	a0,s2
    80003afa:	c04ff0ef          	jal	80002efe <namei>
    80003afe:	c931                	beqz	a0,80003b52 <exec+0x80>
    80003b00:	f3d2                	sd	s4,480(sp)
    80003b02:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003b04:	d21fe0ef          	jal	80002824 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003b08:	04000713          	li	a4,64
    80003b0c:	4681                	li	a3,0
    80003b0e:	e5040613          	addi	a2,s0,-432
    80003b12:	4581                	li	a1,0
    80003b14:	8552                	mv	a0,s4
    80003b16:	f63fe0ef          	jal	80002a78 <readi>
    80003b1a:	04000793          	li	a5,64
    80003b1e:	00f51a63          	bne	a0,a5,80003b32 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003b22:	e5042703          	lw	a4,-432(s0)
    80003b26:	464c47b7          	lui	a5,0x464c4
    80003b2a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b2e:	02f70663          	beq	a4,a5,80003b5a <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b32:	8552                	mv	a0,s4
    80003b34:	efbfe0ef          	jal	80002a2e <iunlockput>
    end_op();
    80003b38:	decff0ef          	jal	80003124 <end_op>
  }
  return -1;
    80003b3c:	557d                	li	a0,-1
    80003b3e:	7a1e                	ld	s4,480(sp)
}
    80003b40:	20813083          	ld	ra,520(sp)
    80003b44:	20013403          	ld	s0,512(sp)
    80003b48:	74fe                	ld	s1,504(sp)
    80003b4a:	795e                	ld	s2,496(sp)
    80003b4c:	21010113          	addi	sp,sp,528
    80003b50:	8082                	ret
    end_op();
    80003b52:	dd2ff0ef          	jal	80003124 <end_op>
    return -1;
    80003b56:	557d                	li	a0,-1
    80003b58:	b7e5                	j	80003b40 <exec+0x6e>
    80003b5a:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b5c:	8526                	mv	a0,s1
    80003b5e:	bd6fd0ef          	jal	80000f34 <proc_pagetable>
    80003b62:	8b2a                	mv	s6,a0
    80003b64:	2e050563          	beqz	a0,80003e4e <exec+0x37c>
    80003b68:	f7ce                	sd	s3,488(sp)
    80003b6a:	efd6                	sd	s5,472(sp)
    80003b6c:	e7de                	sd	s7,456(sp)
    80003b6e:	e3e2                	sd	s8,448(sp)
    80003b70:	ff66                	sd	s9,440(sp)
    80003b72:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b74:	e7042d03          	lw	s10,-400(s0)
    80003b78:	e8845783          	lhu	a5,-376(s0)
    80003b7c:	12078963          	beqz	a5,80003cae <exec+0x1dc>
    80003b80:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b82:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b84:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003b86:	6c85                	lui	s9,0x1
    80003b88:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b8c:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b90:	6a85                	lui	s5,0x1
    80003b92:	a085                	j	80003bf2 <exec+0x120>
      panic("loadseg: address should exist");
    80003b94:	00004517          	auipc	a0,0x4
    80003b98:	a5450513          	addi	a0,a0,-1452 # 800075e8 <etext+0x5e8>
    80003b9c:	247010ef          	jal	800055e2 <panic>
    if(sz - i < PGSIZE)
    80003ba0:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003ba2:	8726                	mv	a4,s1
    80003ba4:	012c06bb          	addw	a3,s8,s2
    80003ba8:	4581                	li	a1,0
    80003baa:	8552                	mv	a0,s4
    80003bac:	ecdfe0ef          	jal	80002a78 <readi>
    80003bb0:	2501                	sext.w	a0,a0
    80003bb2:	26a49463          	bne	s1,a0,80003e1a <exec+0x348>
  for(i = 0; i < sz; i += PGSIZE){
    80003bb6:	012a893b          	addw	s2,s5,s2
    80003bba:	03397363          	bgeu	s2,s3,80003be0 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003bbe:	02091593          	slli	a1,s2,0x20
    80003bc2:	9181                	srli	a1,a1,0x20
    80003bc4:	95de                	add	a1,a1,s7
    80003bc6:	855a                	mv	a0,s6
    80003bc8:	895fc0ef          	jal	8000045c <walkaddr>
    80003bcc:	862a                	mv	a2,a0
    if(pa == 0)
    80003bce:	d179                	beqz	a0,80003b94 <exec+0xc2>
    if(sz - i < PGSIZE)
    80003bd0:	412984bb          	subw	s1,s3,s2
    80003bd4:	0004879b          	sext.w	a5,s1
    80003bd8:	fcfcf4e3          	bgeu	s9,a5,80003ba0 <exec+0xce>
    80003bdc:	84d6                	mv	s1,s5
    80003bde:	b7c9                	j	80003ba0 <exec+0xce>
    sz = sz1;
    80003be0:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003be4:	2d85                	addiw	s11,s11,1
    80003be6:	038d0d1b          	addiw	s10,s10,56
    80003bea:	e8845783          	lhu	a5,-376(s0)
    80003bee:	08fdd063          	bge	s11,a5,80003c6e <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003bf2:	2d01                	sext.w	s10,s10
    80003bf4:	03800713          	li	a4,56
    80003bf8:	86ea                	mv	a3,s10
    80003bfa:	e1840613          	addi	a2,s0,-488
    80003bfe:	4581                	li	a1,0
    80003c00:	8552                	mv	a0,s4
    80003c02:	e77fe0ef          	jal	80002a78 <readi>
    80003c06:	03800793          	li	a5,56
    80003c0a:	1ef51063          	bne	a0,a5,80003dea <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003c0e:	e1842783          	lw	a5,-488(s0)
    80003c12:	4705                	li	a4,1
    80003c14:	fce798e3          	bne	a5,a4,80003be4 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003c18:	e4043483          	ld	s1,-448(s0)
    80003c1c:	e3843783          	ld	a5,-456(s0)
    80003c20:	1cf4e963          	bltu	s1,a5,80003df2 <exec+0x320>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003c24:	e2843783          	ld	a5,-472(s0)
    80003c28:	94be                	add	s1,s1,a5
    80003c2a:	1cf4e863          	bltu	s1,a5,80003dfa <exec+0x328>
    if(ph.vaddr % PGSIZE != 0)
    80003c2e:	df043703          	ld	a4,-528(s0)
    80003c32:	8ff9                	and	a5,a5,a4
    80003c34:	1c079763          	bnez	a5,80003e02 <exec+0x330>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c38:	e1c42503          	lw	a0,-484(s0)
    80003c3c:	e7dff0ef          	jal	80003ab8 <flags2perm>
    80003c40:	86aa                	mv	a3,a0
    80003c42:	8626                	mv	a2,s1
    80003c44:	85ca                	mv	a1,s2
    80003c46:	855a                	mv	a0,s6
    80003c48:	b8dfc0ef          	jal	800007d4 <uvmalloc>
    80003c4c:	e0a43423          	sd	a0,-504(s0)
    80003c50:	1a050d63          	beqz	a0,80003e0a <exec+0x338>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c54:	e2843b83          	ld	s7,-472(s0)
    80003c58:	e2042c03          	lw	s8,-480(s0)
    80003c5c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c60:	00098463          	beqz	s3,80003c68 <exec+0x196>
    80003c64:	4901                	li	s2,0
    80003c66:	bfa1                	j	80003bbe <exec+0xec>
    sz = sz1;
    80003c68:	e0843903          	ld	s2,-504(s0)
    80003c6c:	bfa5                	j	80003be4 <exec+0x112>
    80003c6e:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003c70:	8552                	mv	a0,s4
    80003c72:	dbdfe0ef          	jal	80002a2e <iunlockput>
  end_op();
    80003c76:	caeff0ef          	jal	80003124 <end_op>
  p = myproc();
    80003c7a:	a12fd0ef          	jal	80000e8c <myproc>
    80003c7e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c80:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003c84:	6985                	lui	s3,0x1
    80003c86:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c88:	99ca                	add	s3,s3,s2
    80003c8a:	77fd                	lui	a5,0xfffff
    80003c8c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c90:	4691                	li	a3,4
    80003c92:	660d                	lui	a2,0x3
    80003c94:	964e                	add	a2,a2,s3
    80003c96:	85ce                	mv	a1,s3
    80003c98:	855a                	mv	a0,s6
    80003c9a:	b3bfc0ef          	jal	800007d4 <uvmalloc>
    80003c9e:	892a                	mv	s2,a0
    80003ca0:	e0a43423          	sd	a0,-504(s0)
    80003ca4:	e519                	bnez	a0,80003cb2 <exec+0x1e0>
  if(pagetable)
    80003ca6:	e1343423          	sd	s3,-504(s0)
    80003caa:	4a01                	li	s4,0
    80003cac:	aa85                	j	80003e1c <exec+0x34a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003cae:	4901                	li	s2,0
    80003cb0:	b7c1                	j	80003c70 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003cb2:	75f5                	lui	a1,0xffffd
    80003cb4:	95aa                	add	a1,a1,a0
    80003cb6:	855a                	mv	a0,s6
    80003cb8:	d07fc0ef          	jal	800009be <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003cbc:	7bf9                	lui	s7,0xffffe
    80003cbe:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003cc0:	e0043783          	ld	a5,-512(s0)
    80003cc4:	6388                	ld	a0,0(a5)
    80003cc6:	cd39                	beqz	a0,80003d24 <exec+0x252>
    80003cc8:	e9040993          	addi	s3,s0,-368
    80003ccc:	f9040c13          	addi	s8,s0,-112
    80003cd0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003cd2:	decfc0ef          	jal	800002be <strlen>
    80003cd6:	0015079b          	addiw	a5,a0,1
    80003cda:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003cde:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003ce2:	13796863          	bltu	s2,s7,80003e12 <exec+0x340>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003ce6:	e0043d03          	ld	s10,-512(s0)
    80003cea:	000d3a03          	ld	s4,0(s10)
    80003cee:	8552                	mv	a0,s4
    80003cf0:	dcefc0ef          	jal	800002be <strlen>
    80003cf4:	0015069b          	addiw	a3,a0,1
    80003cf8:	8652                	mv	a2,s4
    80003cfa:	85ca                	mv	a1,s2
    80003cfc:	855a                	mv	a0,s6
    80003cfe:	cebfc0ef          	jal	800009e8 <copyout>
    80003d02:	10054a63          	bltz	a0,80003e16 <exec+0x344>
    ustack[argc] = sp;
    80003d06:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003d0a:	0485                	addi	s1,s1,1
    80003d0c:	008d0793          	addi	a5,s10,8
    80003d10:	e0f43023          	sd	a5,-512(s0)
    80003d14:	008d3503          	ld	a0,8(s10)
    80003d18:	c909                	beqz	a0,80003d2a <exec+0x258>
    if(argc >= MAXARG)
    80003d1a:	09a1                	addi	s3,s3,8
    80003d1c:	fb899be3          	bne	s3,s8,80003cd2 <exec+0x200>
  ip = 0;
    80003d20:	4a01                	li	s4,0
    80003d22:	a8ed                	j	80003e1c <exec+0x34a>
  sp = sz;
    80003d24:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003d28:	4481                	li	s1,0
  ustack[argc] = 0;
    80003d2a:	00349793          	slli	a5,s1,0x3
    80003d2e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb940>
    80003d32:	97a2                	add	a5,a5,s0
    80003d34:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003d38:	00148693          	addi	a3,s1,1
    80003d3c:	068e                	slli	a3,a3,0x3
    80003d3e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003d42:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003d46:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003d4a:	f5796ee3          	bltu	s2,s7,80003ca6 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d4e:	e9040613          	addi	a2,s0,-368
    80003d52:	85ca                	mv	a1,s2
    80003d54:	855a                	mv	a0,s6
    80003d56:	c93fc0ef          	jal	800009e8 <copyout>
    80003d5a:	0e054c63          	bltz	a0,80003e52 <exec+0x380>
  p->trapframe->a1 = sp;
    80003d5e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d62:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d66:	df843783          	ld	a5,-520(s0)
    80003d6a:	0007c703          	lbu	a4,0(a5)
    80003d6e:	cf11                	beqz	a4,80003d8a <exec+0x2b8>
    80003d70:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d72:	02f00693          	li	a3,47
    80003d76:	a039                	j	80003d84 <exec+0x2b2>
      last = s+1;
    80003d78:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003d7c:	0785                	addi	a5,a5,1
    80003d7e:	fff7c703          	lbu	a4,-1(a5)
    80003d82:	c701                	beqz	a4,80003d8a <exec+0x2b8>
    if(*s == '/')
    80003d84:	fed71ce3          	bne	a4,a3,80003d7c <exec+0x2aa>
    80003d88:	bfc5                	j	80003d78 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d8a:	4641                	li	a2,16
    80003d8c:	df843583          	ld	a1,-520(s0)
    80003d90:	158a8513          	addi	a0,s5,344
    80003d94:	cf8fc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003d98:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d9c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003da0:	e0843783          	ld	a5,-504(s0)
    80003da4:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003da8:	058ab783          	ld	a5,88(s5)
    80003dac:	e6843703          	ld	a4,-408(s0)
    80003db0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003db2:	058ab783          	ld	a5,88(s5)
    80003db6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003dba:	85e6                	mv	a1,s9
    80003dbc:	9fcfd0ef          	jal	80000fb8 <proc_freepagetable>
  if (p -> pid == 1)
    80003dc0:	030aa703          	lw	a4,48(s5)
    80003dc4:	4785                	li	a5,1
    80003dc6:	00f70d63          	beq	a4,a5,80003de0 <exec+0x30e>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003dca:	0004851b          	sext.w	a0,s1
    80003dce:	79be                	ld	s3,488(sp)
    80003dd0:	7a1e                	ld	s4,480(sp)
    80003dd2:	6afe                	ld	s5,472(sp)
    80003dd4:	6b5e                	ld	s6,464(sp)
    80003dd6:	6bbe                	ld	s7,456(sp)
    80003dd8:	6c1e                	ld	s8,448(sp)
    80003dda:	7cfa                	ld	s9,440(sp)
    80003ddc:	7d5a                	ld	s10,432(sp)
    80003dde:	b38d                	j	80003b40 <exec+0x6e>
    vmprint(p -> pagetable);
    80003de0:	050ab503          	ld	a0,80(s5)
    80003de4:	eedfc0ef          	jal	80000cd0 <vmprint>
    80003de8:	b7cd                	j	80003dca <exec+0x2f8>
    80003dea:	e1243423          	sd	s2,-504(s0)
    80003dee:	7dba                	ld	s11,424(sp)
    80003df0:	a035                	j	80003e1c <exec+0x34a>
    80003df2:	e1243423          	sd	s2,-504(s0)
    80003df6:	7dba                	ld	s11,424(sp)
    80003df8:	a015                	j	80003e1c <exec+0x34a>
    80003dfa:	e1243423          	sd	s2,-504(s0)
    80003dfe:	7dba                	ld	s11,424(sp)
    80003e00:	a831                	j	80003e1c <exec+0x34a>
    80003e02:	e1243423          	sd	s2,-504(s0)
    80003e06:	7dba                	ld	s11,424(sp)
    80003e08:	a811                	j	80003e1c <exec+0x34a>
    80003e0a:	e1243423          	sd	s2,-504(s0)
    80003e0e:	7dba                	ld	s11,424(sp)
    80003e10:	a031                	j	80003e1c <exec+0x34a>
  ip = 0;
    80003e12:	4a01                	li	s4,0
    80003e14:	a021                	j	80003e1c <exec+0x34a>
    80003e16:	4a01                	li	s4,0
  if(pagetable)
    80003e18:	a011                	j	80003e1c <exec+0x34a>
    80003e1a:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003e1c:	e0843583          	ld	a1,-504(s0)
    80003e20:	855a                	mv	a0,s6
    80003e22:	996fd0ef          	jal	80000fb8 <proc_freepagetable>
  return -1;
    80003e26:	557d                	li	a0,-1
  if(ip){
    80003e28:	000a1b63          	bnez	s4,80003e3e <exec+0x36c>
    80003e2c:	79be                	ld	s3,488(sp)
    80003e2e:	7a1e                	ld	s4,480(sp)
    80003e30:	6afe                	ld	s5,472(sp)
    80003e32:	6b5e                	ld	s6,464(sp)
    80003e34:	6bbe                	ld	s7,456(sp)
    80003e36:	6c1e                	ld	s8,448(sp)
    80003e38:	7cfa                	ld	s9,440(sp)
    80003e3a:	7d5a                	ld	s10,432(sp)
    80003e3c:	b311                	j	80003b40 <exec+0x6e>
    80003e3e:	79be                	ld	s3,488(sp)
    80003e40:	6afe                	ld	s5,472(sp)
    80003e42:	6b5e                	ld	s6,464(sp)
    80003e44:	6bbe                	ld	s7,456(sp)
    80003e46:	6c1e                	ld	s8,448(sp)
    80003e48:	7cfa                	ld	s9,440(sp)
    80003e4a:	7d5a                	ld	s10,432(sp)
    80003e4c:	b1dd                	j	80003b32 <exec+0x60>
    80003e4e:	6b5e                	ld	s6,464(sp)
    80003e50:	b1cd                	j	80003b32 <exec+0x60>
  sz = sz1;
    80003e52:	e0843983          	ld	s3,-504(s0)
    80003e56:	bd81                	j	80003ca6 <exec+0x1d4>

0000000080003e58 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e58:	7179                	addi	sp,sp,-48
    80003e5a:	f406                	sd	ra,40(sp)
    80003e5c:	f022                	sd	s0,32(sp)
    80003e5e:	ec26                	sd	s1,24(sp)
    80003e60:	e84a                	sd	s2,16(sp)
    80003e62:	1800                	addi	s0,sp,48
    80003e64:	892e                	mv	s2,a1
    80003e66:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e68:	fdc40593          	addi	a1,s0,-36
    80003e6c:	ed5fd0ef          	jal	80001d40 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e70:	fdc42703          	lw	a4,-36(s0)
    80003e74:	47bd                	li	a5,15
    80003e76:	02e7e963          	bltu	a5,a4,80003ea8 <argfd+0x50>
    80003e7a:	812fd0ef          	jal	80000e8c <myproc>
    80003e7e:	fdc42703          	lw	a4,-36(s0)
    80003e82:	01a70793          	addi	a5,a4,26
    80003e86:	078e                	slli	a5,a5,0x3
    80003e88:	953e                	add	a0,a0,a5
    80003e8a:	611c                	ld	a5,0(a0)
    80003e8c:	c385                	beqz	a5,80003eac <argfd+0x54>
    return -1;
  if(pfd)
    80003e8e:	00090463          	beqz	s2,80003e96 <argfd+0x3e>
    *pfd = fd;
    80003e92:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e96:	4501                	li	a0,0
  if(pf)
    80003e98:	c091                	beqz	s1,80003e9c <argfd+0x44>
    *pf = f;
    80003e9a:	e09c                	sd	a5,0(s1)
}
    80003e9c:	70a2                	ld	ra,40(sp)
    80003e9e:	7402                	ld	s0,32(sp)
    80003ea0:	64e2                	ld	s1,24(sp)
    80003ea2:	6942                	ld	s2,16(sp)
    80003ea4:	6145                	addi	sp,sp,48
    80003ea6:	8082                	ret
    return -1;
    80003ea8:	557d                	li	a0,-1
    80003eaa:	bfcd                	j	80003e9c <argfd+0x44>
    80003eac:	557d                	li	a0,-1
    80003eae:	b7fd                	j	80003e9c <argfd+0x44>

0000000080003eb0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003eb0:	1101                	addi	sp,sp,-32
    80003eb2:	ec06                	sd	ra,24(sp)
    80003eb4:	e822                	sd	s0,16(sp)
    80003eb6:	e426                	sd	s1,8(sp)
    80003eb8:	1000                	addi	s0,sp,32
    80003eba:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003ebc:	fd1fc0ef          	jal	80000e8c <myproc>
    80003ec0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003ec2:	0d050793          	addi	a5,a0,208
    80003ec6:	4501                	li	a0,0
    80003ec8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003eca:	6398                	ld	a4,0(a5)
    80003ecc:	cb19                	beqz	a4,80003ee2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003ece:	2505                	addiw	a0,a0,1
    80003ed0:	07a1                	addi	a5,a5,8
    80003ed2:	fed51ce3          	bne	a0,a3,80003eca <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003ed6:	557d                	li	a0,-1
}
    80003ed8:	60e2                	ld	ra,24(sp)
    80003eda:	6442                	ld	s0,16(sp)
    80003edc:	64a2                	ld	s1,8(sp)
    80003ede:	6105                	addi	sp,sp,32
    80003ee0:	8082                	ret
      p->ofile[fd] = f;
    80003ee2:	01a50793          	addi	a5,a0,26
    80003ee6:	078e                	slli	a5,a5,0x3
    80003ee8:	963e                	add	a2,a2,a5
    80003eea:	e204                	sd	s1,0(a2)
      return fd;
    80003eec:	b7f5                	j	80003ed8 <fdalloc+0x28>

0000000080003eee <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003eee:	715d                	addi	sp,sp,-80
    80003ef0:	e486                	sd	ra,72(sp)
    80003ef2:	e0a2                	sd	s0,64(sp)
    80003ef4:	fc26                	sd	s1,56(sp)
    80003ef6:	f84a                	sd	s2,48(sp)
    80003ef8:	f44e                	sd	s3,40(sp)
    80003efa:	ec56                	sd	s5,24(sp)
    80003efc:	e85a                	sd	s6,16(sp)
    80003efe:	0880                	addi	s0,sp,80
    80003f00:	8b2e                	mv	s6,a1
    80003f02:	89b2                	mv	s3,a2
    80003f04:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003f06:	fb040593          	addi	a1,s0,-80
    80003f0a:	80eff0ef          	jal	80002f18 <nameiparent>
    80003f0e:	84aa                	mv	s1,a0
    80003f10:	10050a63          	beqz	a0,80004024 <create+0x136>
    return 0;

  ilock(dp);
    80003f14:	911fe0ef          	jal	80002824 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f18:	4601                	li	a2,0
    80003f1a:	fb040593          	addi	a1,s0,-80
    80003f1e:	8526                	mv	a0,s1
    80003f20:	d79fe0ef          	jal	80002c98 <dirlookup>
    80003f24:	8aaa                	mv	s5,a0
    80003f26:	c129                	beqz	a0,80003f68 <create+0x7a>
    iunlockput(dp);
    80003f28:	8526                	mv	a0,s1
    80003f2a:	b05fe0ef          	jal	80002a2e <iunlockput>
    ilock(ip);
    80003f2e:	8556                	mv	a0,s5
    80003f30:	8f5fe0ef          	jal	80002824 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003f34:	4789                	li	a5,2
    80003f36:	02fb1463          	bne	s6,a5,80003f5e <create+0x70>
    80003f3a:	044ad783          	lhu	a5,68(s5)
    80003f3e:	37f9                	addiw	a5,a5,-2
    80003f40:	17c2                	slli	a5,a5,0x30
    80003f42:	93c1                	srli	a5,a5,0x30
    80003f44:	4705                	li	a4,1
    80003f46:	00f76c63          	bltu	a4,a5,80003f5e <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f4a:	8556                	mv	a0,s5
    80003f4c:	60a6                	ld	ra,72(sp)
    80003f4e:	6406                	ld	s0,64(sp)
    80003f50:	74e2                	ld	s1,56(sp)
    80003f52:	7942                	ld	s2,48(sp)
    80003f54:	79a2                	ld	s3,40(sp)
    80003f56:	6ae2                	ld	s5,24(sp)
    80003f58:	6b42                	ld	s6,16(sp)
    80003f5a:	6161                	addi	sp,sp,80
    80003f5c:	8082                	ret
    iunlockput(ip);
    80003f5e:	8556                	mv	a0,s5
    80003f60:	acffe0ef          	jal	80002a2e <iunlockput>
    return 0;
    80003f64:	4a81                	li	s5,0
    80003f66:	b7d5                	j	80003f4a <create+0x5c>
    80003f68:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f6a:	85da                	mv	a1,s6
    80003f6c:	4088                	lw	a0,0(s1)
    80003f6e:	f46fe0ef          	jal	800026b4 <ialloc>
    80003f72:	8a2a                	mv	s4,a0
    80003f74:	cd15                	beqz	a0,80003fb0 <create+0xc2>
  ilock(ip);
    80003f76:	8affe0ef          	jal	80002824 <ilock>
  ip->major = major;
    80003f7a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003f7e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003f82:	4905                	li	s2,1
    80003f84:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f88:	8552                	mv	a0,s4
    80003f8a:	fe6fe0ef          	jal	80002770 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f8e:	032b0763          	beq	s6,s2,80003fbc <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f92:	004a2603          	lw	a2,4(s4)
    80003f96:	fb040593          	addi	a1,s0,-80
    80003f9a:	8526                	mv	a0,s1
    80003f9c:	ec9fe0ef          	jal	80002e64 <dirlink>
    80003fa0:	06054563          	bltz	a0,8000400a <create+0x11c>
  iunlockput(dp);
    80003fa4:	8526                	mv	a0,s1
    80003fa6:	a89fe0ef          	jal	80002a2e <iunlockput>
  return ip;
    80003faa:	8ad2                	mv	s5,s4
    80003fac:	7a02                	ld	s4,32(sp)
    80003fae:	bf71                	j	80003f4a <create+0x5c>
    iunlockput(dp);
    80003fb0:	8526                	mv	a0,s1
    80003fb2:	a7dfe0ef          	jal	80002a2e <iunlockput>
    return 0;
    80003fb6:	8ad2                	mv	s5,s4
    80003fb8:	7a02                	ld	s4,32(sp)
    80003fba:	bf41                	j	80003f4a <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003fbc:	004a2603          	lw	a2,4(s4)
    80003fc0:	00003597          	auipc	a1,0x3
    80003fc4:	64858593          	addi	a1,a1,1608 # 80007608 <etext+0x608>
    80003fc8:	8552                	mv	a0,s4
    80003fca:	e9bfe0ef          	jal	80002e64 <dirlink>
    80003fce:	02054e63          	bltz	a0,8000400a <create+0x11c>
    80003fd2:	40d0                	lw	a2,4(s1)
    80003fd4:	00003597          	auipc	a1,0x3
    80003fd8:	1d458593          	addi	a1,a1,468 # 800071a8 <etext+0x1a8>
    80003fdc:	8552                	mv	a0,s4
    80003fde:	e87fe0ef          	jal	80002e64 <dirlink>
    80003fe2:	02054463          	bltz	a0,8000400a <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003fe6:	004a2603          	lw	a2,4(s4)
    80003fea:	fb040593          	addi	a1,s0,-80
    80003fee:	8526                	mv	a0,s1
    80003ff0:	e75fe0ef          	jal	80002e64 <dirlink>
    80003ff4:	00054b63          	bltz	a0,8000400a <create+0x11c>
    dp->nlink++;  // for ".."
    80003ff8:	04a4d783          	lhu	a5,74(s1)
    80003ffc:	2785                	addiw	a5,a5,1
    80003ffe:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004002:	8526                	mv	a0,s1
    80004004:	f6cfe0ef          	jal	80002770 <iupdate>
    80004008:	bf71                	j	80003fa4 <create+0xb6>
  ip->nlink = 0;
    8000400a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000400e:	8552                	mv	a0,s4
    80004010:	f60fe0ef          	jal	80002770 <iupdate>
  iunlockput(ip);
    80004014:	8552                	mv	a0,s4
    80004016:	a19fe0ef          	jal	80002a2e <iunlockput>
  iunlockput(dp);
    8000401a:	8526                	mv	a0,s1
    8000401c:	a13fe0ef          	jal	80002a2e <iunlockput>
  return 0;
    80004020:	7a02                	ld	s4,32(sp)
    80004022:	b725                	j	80003f4a <create+0x5c>
    return 0;
    80004024:	8aaa                	mv	s5,a0
    80004026:	b715                	j	80003f4a <create+0x5c>

0000000080004028 <sys_dup>:
{
    80004028:	7179                	addi	sp,sp,-48
    8000402a:	f406                	sd	ra,40(sp)
    8000402c:	f022                	sd	s0,32(sp)
    8000402e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004030:	fd840613          	addi	a2,s0,-40
    80004034:	4581                	li	a1,0
    80004036:	4501                	li	a0,0
    80004038:	e21ff0ef          	jal	80003e58 <argfd>
    return -1;
    8000403c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000403e:	02054363          	bltz	a0,80004064 <sys_dup+0x3c>
    80004042:	ec26                	sd	s1,24(sp)
    80004044:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004046:	fd843903          	ld	s2,-40(s0)
    8000404a:	854a                	mv	a0,s2
    8000404c:	e65ff0ef          	jal	80003eb0 <fdalloc>
    80004050:	84aa                	mv	s1,a0
    return -1;
    80004052:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004054:	00054d63          	bltz	a0,8000406e <sys_dup+0x46>
  filedup(f);
    80004058:	854a                	mv	a0,s2
    8000405a:	c34ff0ef          	jal	8000348e <filedup>
  return fd;
    8000405e:	87a6                	mv	a5,s1
    80004060:	64e2                	ld	s1,24(sp)
    80004062:	6942                	ld	s2,16(sp)
}
    80004064:	853e                	mv	a0,a5
    80004066:	70a2                	ld	ra,40(sp)
    80004068:	7402                	ld	s0,32(sp)
    8000406a:	6145                	addi	sp,sp,48
    8000406c:	8082                	ret
    8000406e:	64e2                	ld	s1,24(sp)
    80004070:	6942                	ld	s2,16(sp)
    80004072:	bfcd                	j	80004064 <sys_dup+0x3c>

0000000080004074 <sys_read>:
{
    80004074:	7179                	addi	sp,sp,-48
    80004076:	f406                	sd	ra,40(sp)
    80004078:	f022                	sd	s0,32(sp)
    8000407a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000407c:	fd840593          	addi	a1,s0,-40
    80004080:	4505                	li	a0,1
    80004082:	cdbfd0ef          	jal	80001d5c <argaddr>
  argint(2, &n);
    80004086:	fe440593          	addi	a1,s0,-28
    8000408a:	4509                	li	a0,2
    8000408c:	cb5fd0ef          	jal	80001d40 <argint>
  if(argfd(0, 0, &f) < 0)
    80004090:	fe840613          	addi	a2,s0,-24
    80004094:	4581                	li	a1,0
    80004096:	4501                	li	a0,0
    80004098:	dc1ff0ef          	jal	80003e58 <argfd>
    8000409c:	87aa                	mv	a5,a0
    return -1;
    8000409e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040a0:	0007ca63          	bltz	a5,800040b4 <sys_read+0x40>
  return fileread(f, p, n);
    800040a4:	fe442603          	lw	a2,-28(s0)
    800040a8:	fd843583          	ld	a1,-40(s0)
    800040ac:	fe843503          	ld	a0,-24(s0)
    800040b0:	d44ff0ef          	jal	800035f4 <fileread>
}
    800040b4:	70a2                	ld	ra,40(sp)
    800040b6:	7402                	ld	s0,32(sp)
    800040b8:	6145                	addi	sp,sp,48
    800040ba:	8082                	ret

00000000800040bc <sys_write>:
{
    800040bc:	7179                	addi	sp,sp,-48
    800040be:	f406                	sd	ra,40(sp)
    800040c0:	f022                	sd	s0,32(sp)
    800040c2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040c4:	fd840593          	addi	a1,s0,-40
    800040c8:	4505                	li	a0,1
    800040ca:	c93fd0ef          	jal	80001d5c <argaddr>
  argint(2, &n);
    800040ce:	fe440593          	addi	a1,s0,-28
    800040d2:	4509                	li	a0,2
    800040d4:	c6dfd0ef          	jal	80001d40 <argint>
  if(argfd(0, 0, &f) < 0)
    800040d8:	fe840613          	addi	a2,s0,-24
    800040dc:	4581                	li	a1,0
    800040de:	4501                	li	a0,0
    800040e0:	d79ff0ef          	jal	80003e58 <argfd>
    800040e4:	87aa                	mv	a5,a0
    return -1;
    800040e6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040e8:	0007ca63          	bltz	a5,800040fc <sys_write+0x40>
  return filewrite(f, p, n);
    800040ec:	fe442603          	lw	a2,-28(s0)
    800040f0:	fd843583          	ld	a1,-40(s0)
    800040f4:	fe843503          	ld	a0,-24(s0)
    800040f8:	dbaff0ef          	jal	800036b2 <filewrite>
}
    800040fc:	70a2                	ld	ra,40(sp)
    800040fe:	7402                	ld	s0,32(sp)
    80004100:	6145                	addi	sp,sp,48
    80004102:	8082                	ret

0000000080004104 <sys_close>:
{
    80004104:	1101                	addi	sp,sp,-32
    80004106:	ec06                	sd	ra,24(sp)
    80004108:	e822                	sd	s0,16(sp)
    8000410a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000410c:	fe040613          	addi	a2,s0,-32
    80004110:	fec40593          	addi	a1,s0,-20
    80004114:	4501                	li	a0,0
    80004116:	d43ff0ef          	jal	80003e58 <argfd>
    return -1;
    8000411a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000411c:	02054063          	bltz	a0,8000413c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004120:	d6dfc0ef          	jal	80000e8c <myproc>
    80004124:	fec42783          	lw	a5,-20(s0)
    80004128:	07e9                	addi	a5,a5,26
    8000412a:	078e                	slli	a5,a5,0x3
    8000412c:	953e                	add	a0,a0,a5
    8000412e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004132:	fe043503          	ld	a0,-32(s0)
    80004136:	b9eff0ef          	jal	800034d4 <fileclose>
  return 0;
    8000413a:	4781                	li	a5,0
}
    8000413c:	853e                	mv	a0,a5
    8000413e:	60e2                	ld	ra,24(sp)
    80004140:	6442                	ld	s0,16(sp)
    80004142:	6105                	addi	sp,sp,32
    80004144:	8082                	ret

0000000080004146 <sys_fstat>:
{
    80004146:	1101                	addi	sp,sp,-32
    80004148:	ec06                	sd	ra,24(sp)
    8000414a:	e822                	sd	s0,16(sp)
    8000414c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000414e:	fe040593          	addi	a1,s0,-32
    80004152:	4505                	li	a0,1
    80004154:	c09fd0ef          	jal	80001d5c <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004158:	fe840613          	addi	a2,s0,-24
    8000415c:	4581                	li	a1,0
    8000415e:	4501                	li	a0,0
    80004160:	cf9ff0ef          	jal	80003e58 <argfd>
    80004164:	87aa                	mv	a5,a0
    return -1;
    80004166:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004168:	0007c863          	bltz	a5,80004178 <sys_fstat+0x32>
  return filestat(f, st);
    8000416c:	fe043583          	ld	a1,-32(s0)
    80004170:	fe843503          	ld	a0,-24(s0)
    80004174:	c22ff0ef          	jal	80003596 <filestat>
}
    80004178:	60e2                	ld	ra,24(sp)
    8000417a:	6442                	ld	s0,16(sp)
    8000417c:	6105                	addi	sp,sp,32
    8000417e:	8082                	ret

0000000080004180 <sys_link>:
{
    80004180:	7169                	addi	sp,sp,-304
    80004182:	f606                	sd	ra,296(sp)
    80004184:	f222                	sd	s0,288(sp)
    80004186:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004188:	08000613          	li	a2,128
    8000418c:	ed040593          	addi	a1,s0,-304
    80004190:	4501                	li	a0,0
    80004192:	be7fd0ef          	jal	80001d78 <argstr>
    return -1;
    80004196:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004198:	0c054e63          	bltz	a0,80004274 <sys_link+0xf4>
    8000419c:	08000613          	li	a2,128
    800041a0:	f5040593          	addi	a1,s0,-176
    800041a4:	4505                	li	a0,1
    800041a6:	bd3fd0ef          	jal	80001d78 <argstr>
    return -1;
    800041aa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041ac:	0c054463          	bltz	a0,80004274 <sys_link+0xf4>
    800041b0:	ee26                	sd	s1,280(sp)
  begin_op();
    800041b2:	f09fe0ef          	jal	800030ba <begin_op>
  if((ip = namei(old)) == 0){
    800041b6:	ed040513          	addi	a0,s0,-304
    800041ba:	d45fe0ef          	jal	80002efe <namei>
    800041be:	84aa                	mv	s1,a0
    800041c0:	c53d                	beqz	a0,8000422e <sys_link+0xae>
  ilock(ip);
    800041c2:	e62fe0ef          	jal	80002824 <ilock>
  if(ip->type == T_DIR){
    800041c6:	04449703          	lh	a4,68(s1)
    800041ca:	4785                	li	a5,1
    800041cc:	06f70663          	beq	a4,a5,80004238 <sys_link+0xb8>
    800041d0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800041d2:	04a4d783          	lhu	a5,74(s1)
    800041d6:	2785                	addiw	a5,a5,1
    800041d8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041dc:	8526                	mv	a0,s1
    800041de:	d92fe0ef          	jal	80002770 <iupdate>
  iunlock(ip);
    800041e2:	8526                	mv	a0,s1
    800041e4:	eeefe0ef          	jal	800028d2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800041e8:	fd040593          	addi	a1,s0,-48
    800041ec:	f5040513          	addi	a0,s0,-176
    800041f0:	d29fe0ef          	jal	80002f18 <nameiparent>
    800041f4:	892a                	mv	s2,a0
    800041f6:	cd21                	beqz	a0,8000424e <sys_link+0xce>
  ilock(dp);
    800041f8:	e2cfe0ef          	jal	80002824 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800041fc:	00092703          	lw	a4,0(s2)
    80004200:	409c                	lw	a5,0(s1)
    80004202:	04f71363          	bne	a4,a5,80004248 <sys_link+0xc8>
    80004206:	40d0                	lw	a2,4(s1)
    80004208:	fd040593          	addi	a1,s0,-48
    8000420c:	854a                	mv	a0,s2
    8000420e:	c57fe0ef          	jal	80002e64 <dirlink>
    80004212:	02054b63          	bltz	a0,80004248 <sys_link+0xc8>
  iunlockput(dp);
    80004216:	854a                	mv	a0,s2
    80004218:	817fe0ef          	jal	80002a2e <iunlockput>
  iput(ip);
    8000421c:	8526                	mv	a0,s1
    8000421e:	f88fe0ef          	jal	800029a6 <iput>
  end_op();
    80004222:	f03fe0ef          	jal	80003124 <end_op>
  return 0;
    80004226:	4781                	li	a5,0
    80004228:	64f2                	ld	s1,280(sp)
    8000422a:	6952                	ld	s2,272(sp)
    8000422c:	a0a1                	j	80004274 <sys_link+0xf4>
    end_op();
    8000422e:	ef7fe0ef          	jal	80003124 <end_op>
    return -1;
    80004232:	57fd                	li	a5,-1
    80004234:	64f2                	ld	s1,280(sp)
    80004236:	a83d                	j	80004274 <sys_link+0xf4>
    iunlockput(ip);
    80004238:	8526                	mv	a0,s1
    8000423a:	ff4fe0ef          	jal	80002a2e <iunlockput>
    end_op();
    8000423e:	ee7fe0ef          	jal	80003124 <end_op>
    return -1;
    80004242:	57fd                	li	a5,-1
    80004244:	64f2                	ld	s1,280(sp)
    80004246:	a03d                	j	80004274 <sys_link+0xf4>
    iunlockput(dp);
    80004248:	854a                	mv	a0,s2
    8000424a:	fe4fe0ef          	jal	80002a2e <iunlockput>
  ilock(ip);
    8000424e:	8526                	mv	a0,s1
    80004250:	dd4fe0ef          	jal	80002824 <ilock>
  ip->nlink--;
    80004254:	04a4d783          	lhu	a5,74(s1)
    80004258:	37fd                	addiw	a5,a5,-1
    8000425a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000425e:	8526                	mv	a0,s1
    80004260:	d10fe0ef          	jal	80002770 <iupdate>
  iunlockput(ip);
    80004264:	8526                	mv	a0,s1
    80004266:	fc8fe0ef          	jal	80002a2e <iunlockput>
  end_op();
    8000426a:	ebbfe0ef          	jal	80003124 <end_op>
  return -1;
    8000426e:	57fd                	li	a5,-1
    80004270:	64f2                	ld	s1,280(sp)
    80004272:	6952                	ld	s2,272(sp)
}
    80004274:	853e                	mv	a0,a5
    80004276:	70b2                	ld	ra,296(sp)
    80004278:	7412                	ld	s0,288(sp)
    8000427a:	6155                	addi	sp,sp,304
    8000427c:	8082                	ret

000000008000427e <sys_unlink>:
{
    8000427e:	7151                	addi	sp,sp,-240
    80004280:	f586                	sd	ra,232(sp)
    80004282:	f1a2                	sd	s0,224(sp)
    80004284:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004286:	08000613          	li	a2,128
    8000428a:	f3040593          	addi	a1,s0,-208
    8000428e:	4501                	li	a0,0
    80004290:	ae9fd0ef          	jal	80001d78 <argstr>
    80004294:	16054063          	bltz	a0,800043f4 <sys_unlink+0x176>
    80004298:	eda6                	sd	s1,216(sp)
  begin_op();
    8000429a:	e21fe0ef          	jal	800030ba <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000429e:	fb040593          	addi	a1,s0,-80
    800042a2:	f3040513          	addi	a0,s0,-208
    800042a6:	c73fe0ef          	jal	80002f18 <nameiparent>
    800042aa:	84aa                	mv	s1,a0
    800042ac:	c945                	beqz	a0,8000435c <sys_unlink+0xde>
  ilock(dp);
    800042ae:	d76fe0ef          	jal	80002824 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800042b2:	00003597          	auipc	a1,0x3
    800042b6:	35658593          	addi	a1,a1,854 # 80007608 <etext+0x608>
    800042ba:	fb040513          	addi	a0,s0,-80
    800042be:	9c5fe0ef          	jal	80002c82 <namecmp>
    800042c2:	10050e63          	beqz	a0,800043de <sys_unlink+0x160>
    800042c6:	00003597          	auipc	a1,0x3
    800042ca:	ee258593          	addi	a1,a1,-286 # 800071a8 <etext+0x1a8>
    800042ce:	fb040513          	addi	a0,s0,-80
    800042d2:	9b1fe0ef          	jal	80002c82 <namecmp>
    800042d6:	10050463          	beqz	a0,800043de <sys_unlink+0x160>
    800042da:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800042dc:	f2c40613          	addi	a2,s0,-212
    800042e0:	fb040593          	addi	a1,s0,-80
    800042e4:	8526                	mv	a0,s1
    800042e6:	9b3fe0ef          	jal	80002c98 <dirlookup>
    800042ea:	892a                	mv	s2,a0
    800042ec:	0e050863          	beqz	a0,800043dc <sys_unlink+0x15e>
  ilock(ip);
    800042f0:	d34fe0ef          	jal	80002824 <ilock>
  if(ip->nlink < 1)
    800042f4:	04a91783          	lh	a5,74(s2)
    800042f8:	06f05763          	blez	a5,80004366 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800042fc:	04491703          	lh	a4,68(s2)
    80004300:	4785                	li	a5,1
    80004302:	06f70963          	beq	a4,a5,80004374 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004306:	4641                	li	a2,16
    80004308:	4581                	li	a1,0
    8000430a:	fc040513          	addi	a0,s0,-64
    8000430e:	e41fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004312:	4741                	li	a4,16
    80004314:	f2c42683          	lw	a3,-212(s0)
    80004318:	fc040613          	addi	a2,s0,-64
    8000431c:	4581                	li	a1,0
    8000431e:	8526                	mv	a0,s1
    80004320:	855fe0ef          	jal	80002b74 <writei>
    80004324:	47c1                	li	a5,16
    80004326:	08f51b63          	bne	a0,a5,800043bc <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000432a:	04491703          	lh	a4,68(s2)
    8000432e:	4785                	li	a5,1
    80004330:	08f70d63          	beq	a4,a5,800043ca <sys_unlink+0x14c>
  iunlockput(dp);
    80004334:	8526                	mv	a0,s1
    80004336:	ef8fe0ef          	jal	80002a2e <iunlockput>
  ip->nlink--;
    8000433a:	04a95783          	lhu	a5,74(s2)
    8000433e:	37fd                	addiw	a5,a5,-1
    80004340:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004344:	854a                	mv	a0,s2
    80004346:	c2afe0ef          	jal	80002770 <iupdate>
  iunlockput(ip);
    8000434a:	854a                	mv	a0,s2
    8000434c:	ee2fe0ef          	jal	80002a2e <iunlockput>
  end_op();
    80004350:	dd5fe0ef          	jal	80003124 <end_op>
  return 0;
    80004354:	4501                	li	a0,0
    80004356:	64ee                	ld	s1,216(sp)
    80004358:	694e                	ld	s2,208(sp)
    8000435a:	a849                	j	800043ec <sys_unlink+0x16e>
    end_op();
    8000435c:	dc9fe0ef          	jal	80003124 <end_op>
    return -1;
    80004360:	557d                	li	a0,-1
    80004362:	64ee                	ld	s1,216(sp)
    80004364:	a061                	j	800043ec <sys_unlink+0x16e>
    80004366:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004368:	00003517          	auipc	a0,0x3
    8000436c:	2a850513          	addi	a0,a0,680 # 80007610 <etext+0x610>
    80004370:	272010ef          	jal	800055e2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004374:	04c92703          	lw	a4,76(s2)
    80004378:	02000793          	li	a5,32
    8000437c:	f8e7f5e3          	bgeu	a5,a4,80004306 <sys_unlink+0x88>
    80004380:	e5ce                	sd	s3,200(sp)
    80004382:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004386:	4741                	li	a4,16
    80004388:	86ce                	mv	a3,s3
    8000438a:	f1840613          	addi	a2,s0,-232
    8000438e:	4581                	li	a1,0
    80004390:	854a                	mv	a0,s2
    80004392:	ee6fe0ef          	jal	80002a78 <readi>
    80004396:	47c1                	li	a5,16
    80004398:	00f51c63          	bne	a0,a5,800043b0 <sys_unlink+0x132>
    if(de.inum != 0)
    8000439c:	f1845783          	lhu	a5,-232(s0)
    800043a0:	efa1                	bnez	a5,800043f8 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800043a2:	29c1                	addiw	s3,s3,16
    800043a4:	04c92783          	lw	a5,76(s2)
    800043a8:	fcf9efe3          	bltu	s3,a5,80004386 <sys_unlink+0x108>
    800043ac:	69ae                	ld	s3,200(sp)
    800043ae:	bfa1                	j	80004306 <sys_unlink+0x88>
      panic("isdirempty: readi");
    800043b0:	00003517          	auipc	a0,0x3
    800043b4:	27850513          	addi	a0,a0,632 # 80007628 <etext+0x628>
    800043b8:	22a010ef          	jal	800055e2 <panic>
    800043bc:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800043be:	00003517          	auipc	a0,0x3
    800043c2:	28250513          	addi	a0,a0,642 # 80007640 <etext+0x640>
    800043c6:	21c010ef          	jal	800055e2 <panic>
    dp->nlink--;
    800043ca:	04a4d783          	lhu	a5,74(s1)
    800043ce:	37fd                	addiw	a5,a5,-1
    800043d0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800043d4:	8526                	mv	a0,s1
    800043d6:	b9afe0ef          	jal	80002770 <iupdate>
    800043da:	bfa9                	j	80004334 <sys_unlink+0xb6>
    800043dc:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800043de:	8526                	mv	a0,s1
    800043e0:	e4efe0ef          	jal	80002a2e <iunlockput>
  end_op();
    800043e4:	d41fe0ef          	jal	80003124 <end_op>
  return -1;
    800043e8:	557d                	li	a0,-1
    800043ea:	64ee                	ld	s1,216(sp)
}
    800043ec:	70ae                	ld	ra,232(sp)
    800043ee:	740e                	ld	s0,224(sp)
    800043f0:	616d                	addi	sp,sp,240
    800043f2:	8082                	ret
    return -1;
    800043f4:	557d                	li	a0,-1
    800043f6:	bfdd                	j	800043ec <sys_unlink+0x16e>
    iunlockput(ip);
    800043f8:	854a                	mv	a0,s2
    800043fa:	e34fe0ef          	jal	80002a2e <iunlockput>
    goto bad;
    800043fe:	694e                	ld	s2,208(sp)
    80004400:	69ae                	ld	s3,200(sp)
    80004402:	bff1                	j	800043de <sys_unlink+0x160>

0000000080004404 <sys_open>:

uint64
sys_open(void)
{
    80004404:	7131                	addi	sp,sp,-192
    80004406:	fd06                	sd	ra,184(sp)
    80004408:	f922                	sd	s0,176(sp)
    8000440a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000440c:	f4c40593          	addi	a1,s0,-180
    80004410:	4505                	li	a0,1
    80004412:	92ffd0ef          	jal	80001d40 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004416:	08000613          	li	a2,128
    8000441a:	f5040593          	addi	a1,s0,-176
    8000441e:	4501                	li	a0,0
    80004420:	959fd0ef          	jal	80001d78 <argstr>
    80004424:	87aa                	mv	a5,a0
    return -1;
    80004426:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004428:	0a07c263          	bltz	a5,800044cc <sys_open+0xc8>
    8000442c:	f526                	sd	s1,168(sp)

  begin_op();
    8000442e:	c8dfe0ef          	jal	800030ba <begin_op>

  if(omode & O_CREATE){
    80004432:	f4c42783          	lw	a5,-180(s0)
    80004436:	2007f793          	andi	a5,a5,512
    8000443a:	c3d5                	beqz	a5,800044de <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000443c:	4681                	li	a3,0
    8000443e:	4601                	li	a2,0
    80004440:	4589                	li	a1,2
    80004442:	f5040513          	addi	a0,s0,-176
    80004446:	aa9ff0ef          	jal	80003eee <create>
    8000444a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000444c:	c541                	beqz	a0,800044d4 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000444e:	04449703          	lh	a4,68(s1)
    80004452:	478d                	li	a5,3
    80004454:	00f71763          	bne	a4,a5,80004462 <sys_open+0x5e>
    80004458:	0464d703          	lhu	a4,70(s1)
    8000445c:	47a5                	li	a5,9
    8000445e:	0ae7ed63          	bltu	a5,a4,80004518 <sys_open+0x114>
    80004462:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004464:	fcdfe0ef          	jal	80003430 <filealloc>
    80004468:	892a                	mv	s2,a0
    8000446a:	c179                	beqz	a0,80004530 <sys_open+0x12c>
    8000446c:	ed4e                	sd	s3,152(sp)
    8000446e:	a43ff0ef          	jal	80003eb0 <fdalloc>
    80004472:	89aa                	mv	s3,a0
    80004474:	0a054a63          	bltz	a0,80004528 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004478:	04449703          	lh	a4,68(s1)
    8000447c:	478d                	li	a5,3
    8000447e:	0cf70263          	beq	a4,a5,80004542 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004482:	4789                	li	a5,2
    80004484:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004488:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000448c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004490:	f4c42783          	lw	a5,-180(s0)
    80004494:	0017c713          	xori	a4,a5,1
    80004498:	8b05                	andi	a4,a4,1
    8000449a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000449e:	0037f713          	andi	a4,a5,3
    800044a2:	00e03733          	snez	a4,a4
    800044a6:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800044aa:	4007f793          	andi	a5,a5,1024
    800044ae:	c791                	beqz	a5,800044ba <sys_open+0xb6>
    800044b0:	04449703          	lh	a4,68(s1)
    800044b4:	4789                	li	a5,2
    800044b6:	08f70d63          	beq	a4,a5,80004550 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800044ba:	8526                	mv	a0,s1
    800044bc:	c16fe0ef          	jal	800028d2 <iunlock>
  end_op();
    800044c0:	c65fe0ef          	jal	80003124 <end_op>

  return fd;
    800044c4:	854e                	mv	a0,s3
    800044c6:	74aa                	ld	s1,168(sp)
    800044c8:	790a                	ld	s2,160(sp)
    800044ca:	69ea                	ld	s3,152(sp)
}
    800044cc:	70ea                	ld	ra,184(sp)
    800044ce:	744a                	ld	s0,176(sp)
    800044d0:	6129                	addi	sp,sp,192
    800044d2:	8082                	ret
      end_op();
    800044d4:	c51fe0ef          	jal	80003124 <end_op>
      return -1;
    800044d8:	557d                	li	a0,-1
    800044da:	74aa                	ld	s1,168(sp)
    800044dc:	bfc5                	j	800044cc <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800044de:	f5040513          	addi	a0,s0,-176
    800044e2:	a1dfe0ef          	jal	80002efe <namei>
    800044e6:	84aa                	mv	s1,a0
    800044e8:	c11d                	beqz	a0,8000450e <sys_open+0x10a>
    ilock(ip);
    800044ea:	b3afe0ef          	jal	80002824 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800044ee:	04449703          	lh	a4,68(s1)
    800044f2:	4785                	li	a5,1
    800044f4:	f4f71de3          	bne	a4,a5,8000444e <sys_open+0x4a>
    800044f8:	f4c42783          	lw	a5,-180(s0)
    800044fc:	d3bd                	beqz	a5,80004462 <sys_open+0x5e>
      iunlockput(ip);
    800044fe:	8526                	mv	a0,s1
    80004500:	d2efe0ef          	jal	80002a2e <iunlockput>
      end_op();
    80004504:	c21fe0ef          	jal	80003124 <end_op>
      return -1;
    80004508:	557d                	li	a0,-1
    8000450a:	74aa                	ld	s1,168(sp)
    8000450c:	b7c1                	j	800044cc <sys_open+0xc8>
      end_op();
    8000450e:	c17fe0ef          	jal	80003124 <end_op>
      return -1;
    80004512:	557d                	li	a0,-1
    80004514:	74aa                	ld	s1,168(sp)
    80004516:	bf5d                	j	800044cc <sys_open+0xc8>
    iunlockput(ip);
    80004518:	8526                	mv	a0,s1
    8000451a:	d14fe0ef          	jal	80002a2e <iunlockput>
    end_op();
    8000451e:	c07fe0ef          	jal	80003124 <end_op>
    return -1;
    80004522:	557d                	li	a0,-1
    80004524:	74aa                	ld	s1,168(sp)
    80004526:	b75d                	j	800044cc <sys_open+0xc8>
      fileclose(f);
    80004528:	854a                	mv	a0,s2
    8000452a:	fabfe0ef          	jal	800034d4 <fileclose>
    8000452e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004530:	8526                	mv	a0,s1
    80004532:	cfcfe0ef          	jal	80002a2e <iunlockput>
    end_op();
    80004536:	beffe0ef          	jal	80003124 <end_op>
    return -1;
    8000453a:	557d                	li	a0,-1
    8000453c:	74aa                	ld	s1,168(sp)
    8000453e:	790a                	ld	s2,160(sp)
    80004540:	b771                	j	800044cc <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004542:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004546:	04649783          	lh	a5,70(s1)
    8000454a:	02f91223          	sh	a5,36(s2)
    8000454e:	bf3d                	j	8000448c <sys_open+0x88>
    itrunc(ip);
    80004550:	8526                	mv	a0,s1
    80004552:	bc0fe0ef          	jal	80002912 <itrunc>
    80004556:	b795                	j	800044ba <sys_open+0xb6>

0000000080004558 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004558:	7175                	addi	sp,sp,-144
    8000455a:	e506                	sd	ra,136(sp)
    8000455c:	e122                	sd	s0,128(sp)
    8000455e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004560:	b5bfe0ef          	jal	800030ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004564:	08000613          	li	a2,128
    80004568:	f7040593          	addi	a1,s0,-144
    8000456c:	4501                	li	a0,0
    8000456e:	80bfd0ef          	jal	80001d78 <argstr>
    80004572:	02054363          	bltz	a0,80004598 <sys_mkdir+0x40>
    80004576:	4681                	li	a3,0
    80004578:	4601                	li	a2,0
    8000457a:	4585                	li	a1,1
    8000457c:	f7040513          	addi	a0,s0,-144
    80004580:	96fff0ef          	jal	80003eee <create>
    80004584:	c911                	beqz	a0,80004598 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004586:	ca8fe0ef          	jal	80002a2e <iunlockput>
  end_op();
    8000458a:	b9bfe0ef          	jal	80003124 <end_op>
  return 0;
    8000458e:	4501                	li	a0,0
}
    80004590:	60aa                	ld	ra,136(sp)
    80004592:	640a                	ld	s0,128(sp)
    80004594:	6149                	addi	sp,sp,144
    80004596:	8082                	ret
    end_op();
    80004598:	b8dfe0ef          	jal	80003124 <end_op>
    return -1;
    8000459c:	557d                	li	a0,-1
    8000459e:	bfcd                	j	80004590 <sys_mkdir+0x38>

00000000800045a0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800045a0:	7135                	addi	sp,sp,-160
    800045a2:	ed06                	sd	ra,152(sp)
    800045a4:	e922                	sd	s0,144(sp)
    800045a6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800045a8:	b13fe0ef          	jal	800030ba <begin_op>
  argint(1, &major);
    800045ac:	f6c40593          	addi	a1,s0,-148
    800045b0:	4505                	li	a0,1
    800045b2:	f8efd0ef          	jal	80001d40 <argint>
  argint(2, &minor);
    800045b6:	f6840593          	addi	a1,s0,-152
    800045ba:	4509                	li	a0,2
    800045bc:	f84fd0ef          	jal	80001d40 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045c0:	08000613          	li	a2,128
    800045c4:	f7040593          	addi	a1,s0,-144
    800045c8:	4501                	li	a0,0
    800045ca:	faefd0ef          	jal	80001d78 <argstr>
    800045ce:	02054563          	bltz	a0,800045f8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800045d2:	f6841683          	lh	a3,-152(s0)
    800045d6:	f6c41603          	lh	a2,-148(s0)
    800045da:	458d                	li	a1,3
    800045dc:	f7040513          	addi	a0,s0,-144
    800045e0:	90fff0ef          	jal	80003eee <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045e4:	c911                	beqz	a0,800045f8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045e6:	c48fe0ef          	jal	80002a2e <iunlockput>
  end_op();
    800045ea:	b3bfe0ef          	jal	80003124 <end_op>
  return 0;
    800045ee:	4501                	li	a0,0
}
    800045f0:	60ea                	ld	ra,152(sp)
    800045f2:	644a                	ld	s0,144(sp)
    800045f4:	610d                	addi	sp,sp,160
    800045f6:	8082                	ret
    end_op();
    800045f8:	b2dfe0ef          	jal	80003124 <end_op>
    return -1;
    800045fc:	557d                	li	a0,-1
    800045fe:	bfcd                	j	800045f0 <sys_mknod+0x50>

0000000080004600 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004600:	7135                	addi	sp,sp,-160
    80004602:	ed06                	sd	ra,152(sp)
    80004604:	e922                	sd	s0,144(sp)
    80004606:	e14a                	sd	s2,128(sp)
    80004608:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000460a:	883fc0ef          	jal	80000e8c <myproc>
    8000460e:	892a                	mv	s2,a0
  
  begin_op();
    80004610:	aabfe0ef          	jal	800030ba <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004614:	08000613          	li	a2,128
    80004618:	f6040593          	addi	a1,s0,-160
    8000461c:	4501                	li	a0,0
    8000461e:	f5afd0ef          	jal	80001d78 <argstr>
    80004622:	04054363          	bltz	a0,80004668 <sys_chdir+0x68>
    80004626:	e526                	sd	s1,136(sp)
    80004628:	f6040513          	addi	a0,s0,-160
    8000462c:	8d3fe0ef          	jal	80002efe <namei>
    80004630:	84aa                	mv	s1,a0
    80004632:	c915                	beqz	a0,80004666 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004634:	9f0fe0ef          	jal	80002824 <ilock>
  if(ip->type != T_DIR){
    80004638:	04449703          	lh	a4,68(s1)
    8000463c:	4785                	li	a5,1
    8000463e:	02f71963          	bne	a4,a5,80004670 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004642:	8526                	mv	a0,s1
    80004644:	a8efe0ef          	jal	800028d2 <iunlock>
  iput(p->cwd);
    80004648:	15093503          	ld	a0,336(s2)
    8000464c:	b5afe0ef          	jal	800029a6 <iput>
  end_op();
    80004650:	ad5fe0ef          	jal	80003124 <end_op>
  p->cwd = ip;
    80004654:	14993823          	sd	s1,336(s2)
  return 0;
    80004658:	4501                	li	a0,0
    8000465a:	64aa                	ld	s1,136(sp)
}
    8000465c:	60ea                	ld	ra,152(sp)
    8000465e:	644a                	ld	s0,144(sp)
    80004660:	690a                	ld	s2,128(sp)
    80004662:	610d                	addi	sp,sp,160
    80004664:	8082                	ret
    80004666:	64aa                	ld	s1,136(sp)
    end_op();
    80004668:	abdfe0ef          	jal	80003124 <end_op>
    return -1;
    8000466c:	557d                	li	a0,-1
    8000466e:	b7fd                	j	8000465c <sys_chdir+0x5c>
    iunlockput(ip);
    80004670:	8526                	mv	a0,s1
    80004672:	bbcfe0ef          	jal	80002a2e <iunlockput>
    end_op();
    80004676:	aaffe0ef          	jal	80003124 <end_op>
    return -1;
    8000467a:	557d                	li	a0,-1
    8000467c:	64aa                	ld	s1,136(sp)
    8000467e:	bff9                	j	8000465c <sys_chdir+0x5c>

0000000080004680 <sys_exec>:

uint64
sys_exec(void)
{
    80004680:	7121                	addi	sp,sp,-448
    80004682:	ff06                	sd	ra,440(sp)
    80004684:	fb22                	sd	s0,432(sp)
    80004686:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004688:	e4840593          	addi	a1,s0,-440
    8000468c:	4505                	li	a0,1
    8000468e:	ecefd0ef          	jal	80001d5c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004692:	08000613          	li	a2,128
    80004696:	f5040593          	addi	a1,s0,-176
    8000469a:	4501                	li	a0,0
    8000469c:	edcfd0ef          	jal	80001d78 <argstr>
    800046a0:	87aa                	mv	a5,a0
    return -1;
    800046a2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800046a4:	0c07c463          	bltz	a5,8000476c <sys_exec+0xec>
    800046a8:	f726                	sd	s1,424(sp)
    800046aa:	f34a                	sd	s2,416(sp)
    800046ac:	ef4e                	sd	s3,408(sp)
    800046ae:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800046b0:	10000613          	li	a2,256
    800046b4:	4581                	li	a1,0
    800046b6:	e5040513          	addi	a0,s0,-432
    800046ba:	a95fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800046be:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800046c2:	89a6                	mv	s3,s1
    800046c4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800046c6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800046ca:	00391513          	slli	a0,s2,0x3
    800046ce:	e4040593          	addi	a1,s0,-448
    800046d2:	e4843783          	ld	a5,-440(s0)
    800046d6:	953e                	add	a0,a0,a5
    800046d8:	ddefd0ef          	jal	80001cb6 <fetchaddr>
    800046dc:	02054663          	bltz	a0,80004708 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800046e0:	e4043783          	ld	a5,-448(s0)
    800046e4:	c3a9                	beqz	a5,80004726 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800046e6:	a19fb0ef          	jal	800000fe <kalloc>
    800046ea:	85aa                	mv	a1,a0
    800046ec:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800046f0:	cd01                	beqz	a0,80004708 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800046f2:	6605                	lui	a2,0x1
    800046f4:	e4043503          	ld	a0,-448(s0)
    800046f8:	e08fd0ef          	jal	80001d00 <fetchstr>
    800046fc:	00054663          	bltz	a0,80004708 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004700:	0905                	addi	s2,s2,1
    80004702:	09a1                	addi	s3,s3,8
    80004704:	fd4913e3          	bne	s2,s4,800046ca <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004708:	f5040913          	addi	s2,s0,-176
    8000470c:	6088                	ld	a0,0(s1)
    8000470e:	c931                	beqz	a0,80004762 <sys_exec+0xe2>
    kfree(argv[i]);
    80004710:	90dfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004714:	04a1                	addi	s1,s1,8
    80004716:	ff249be3          	bne	s1,s2,8000470c <sys_exec+0x8c>
  return -1;
    8000471a:	557d                	li	a0,-1
    8000471c:	74ba                	ld	s1,424(sp)
    8000471e:	791a                	ld	s2,416(sp)
    80004720:	69fa                	ld	s3,408(sp)
    80004722:	6a5a                	ld	s4,400(sp)
    80004724:	a0a1                	j	8000476c <sys_exec+0xec>
      argv[i] = 0;
    80004726:	0009079b          	sext.w	a5,s2
    8000472a:	078e                	slli	a5,a5,0x3
    8000472c:	fd078793          	addi	a5,a5,-48
    80004730:	97a2                	add	a5,a5,s0
    80004732:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004736:	e5040593          	addi	a1,s0,-432
    8000473a:	f5040513          	addi	a0,s0,-176
    8000473e:	b94ff0ef          	jal	80003ad2 <exec>
    80004742:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004744:	f5040993          	addi	s3,s0,-176
    80004748:	6088                	ld	a0,0(s1)
    8000474a:	c511                	beqz	a0,80004756 <sys_exec+0xd6>
    kfree(argv[i]);
    8000474c:	8d1fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004750:	04a1                	addi	s1,s1,8
    80004752:	ff349be3          	bne	s1,s3,80004748 <sys_exec+0xc8>
  return ret;
    80004756:	854a                	mv	a0,s2
    80004758:	74ba                	ld	s1,424(sp)
    8000475a:	791a                	ld	s2,416(sp)
    8000475c:	69fa                	ld	s3,408(sp)
    8000475e:	6a5a                	ld	s4,400(sp)
    80004760:	a031                	j	8000476c <sys_exec+0xec>
  return -1;
    80004762:	557d                	li	a0,-1
    80004764:	74ba                	ld	s1,424(sp)
    80004766:	791a                	ld	s2,416(sp)
    80004768:	69fa                	ld	s3,408(sp)
    8000476a:	6a5a                	ld	s4,400(sp)
}
    8000476c:	70fa                	ld	ra,440(sp)
    8000476e:	745a                	ld	s0,432(sp)
    80004770:	6139                	addi	sp,sp,448
    80004772:	8082                	ret

0000000080004774 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004774:	7139                	addi	sp,sp,-64
    80004776:	fc06                	sd	ra,56(sp)
    80004778:	f822                	sd	s0,48(sp)
    8000477a:	f426                	sd	s1,40(sp)
    8000477c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000477e:	f0efc0ef          	jal	80000e8c <myproc>
    80004782:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004784:	fd840593          	addi	a1,s0,-40
    80004788:	4501                	li	a0,0
    8000478a:	dd2fd0ef          	jal	80001d5c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000478e:	fc840593          	addi	a1,s0,-56
    80004792:	fd040513          	addi	a0,s0,-48
    80004796:	848ff0ef          	jal	800037de <pipealloc>
    return -1;
    8000479a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000479c:	0a054463          	bltz	a0,80004844 <sys_pipe+0xd0>
  fd0 = -1;
    800047a0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800047a4:	fd043503          	ld	a0,-48(s0)
    800047a8:	f08ff0ef          	jal	80003eb0 <fdalloc>
    800047ac:	fca42223          	sw	a0,-60(s0)
    800047b0:	08054163          	bltz	a0,80004832 <sys_pipe+0xbe>
    800047b4:	fc843503          	ld	a0,-56(s0)
    800047b8:	ef8ff0ef          	jal	80003eb0 <fdalloc>
    800047bc:	fca42023          	sw	a0,-64(s0)
    800047c0:	06054063          	bltz	a0,80004820 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047c4:	4691                	li	a3,4
    800047c6:	fc440613          	addi	a2,s0,-60
    800047ca:	fd843583          	ld	a1,-40(s0)
    800047ce:	68a8                	ld	a0,80(s1)
    800047d0:	a18fc0ef          	jal	800009e8 <copyout>
    800047d4:	00054e63          	bltz	a0,800047f0 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800047d8:	4691                	li	a3,4
    800047da:	fc040613          	addi	a2,s0,-64
    800047de:	fd843583          	ld	a1,-40(s0)
    800047e2:	0591                	addi	a1,a1,4
    800047e4:	68a8                	ld	a0,80(s1)
    800047e6:	a02fc0ef          	jal	800009e8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800047ea:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047ec:	04055c63          	bgez	a0,80004844 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800047f0:	fc442783          	lw	a5,-60(s0)
    800047f4:	07e9                	addi	a5,a5,26
    800047f6:	078e                	slli	a5,a5,0x3
    800047f8:	97a6                	add	a5,a5,s1
    800047fa:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047fe:	fc042783          	lw	a5,-64(s0)
    80004802:	07e9                	addi	a5,a5,26
    80004804:	078e                	slli	a5,a5,0x3
    80004806:	94be                	add	s1,s1,a5
    80004808:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000480c:	fd043503          	ld	a0,-48(s0)
    80004810:	cc5fe0ef          	jal	800034d4 <fileclose>
    fileclose(wf);
    80004814:	fc843503          	ld	a0,-56(s0)
    80004818:	cbdfe0ef          	jal	800034d4 <fileclose>
    return -1;
    8000481c:	57fd                	li	a5,-1
    8000481e:	a01d                	j	80004844 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004820:	fc442783          	lw	a5,-60(s0)
    80004824:	0007c763          	bltz	a5,80004832 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004828:	07e9                	addi	a5,a5,26
    8000482a:	078e                	slli	a5,a5,0x3
    8000482c:	97a6                	add	a5,a5,s1
    8000482e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004832:	fd043503          	ld	a0,-48(s0)
    80004836:	c9ffe0ef          	jal	800034d4 <fileclose>
    fileclose(wf);
    8000483a:	fc843503          	ld	a0,-56(s0)
    8000483e:	c97fe0ef          	jal	800034d4 <fileclose>
    return -1;
    80004842:	57fd                	li	a5,-1
}
    80004844:	853e                	mv	a0,a5
    80004846:	70e2                	ld	ra,56(sp)
    80004848:	7442                	ld	s0,48(sp)
    8000484a:	74a2                	ld	s1,40(sp)
    8000484c:	6121                	addi	sp,sp,64
    8000484e:	8082                	ret

0000000080004850 <kernelvec>:
    80004850:	7111                	addi	sp,sp,-256
    80004852:	e006                	sd	ra,0(sp)
    80004854:	e40a                	sd	sp,8(sp)
    80004856:	e80e                	sd	gp,16(sp)
    80004858:	ec12                	sd	tp,24(sp)
    8000485a:	f016                	sd	t0,32(sp)
    8000485c:	f41a                	sd	t1,40(sp)
    8000485e:	f81e                	sd	t2,48(sp)
    80004860:	e4aa                	sd	a0,72(sp)
    80004862:	e8ae                	sd	a1,80(sp)
    80004864:	ecb2                	sd	a2,88(sp)
    80004866:	f0b6                	sd	a3,96(sp)
    80004868:	f4ba                	sd	a4,104(sp)
    8000486a:	f8be                	sd	a5,112(sp)
    8000486c:	fcc2                	sd	a6,120(sp)
    8000486e:	e146                	sd	a7,128(sp)
    80004870:	edf2                	sd	t3,216(sp)
    80004872:	f1f6                	sd	t4,224(sp)
    80004874:	f5fa                	sd	t5,232(sp)
    80004876:	f9fe                	sd	t6,240(sp)
    80004878:	b4efd0ef          	jal	80001bc6 <kerneltrap>
    8000487c:	6082                	ld	ra,0(sp)
    8000487e:	6122                	ld	sp,8(sp)
    80004880:	61c2                	ld	gp,16(sp)
    80004882:	7282                	ld	t0,32(sp)
    80004884:	7322                	ld	t1,40(sp)
    80004886:	73c2                	ld	t2,48(sp)
    80004888:	6526                	ld	a0,72(sp)
    8000488a:	65c6                	ld	a1,80(sp)
    8000488c:	6666                	ld	a2,88(sp)
    8000488e:	7686                	ld	a3,96(sp)
    80004890:	7726                	ld	a4,104(sp)
    80004892:	77c6                	ld	a5,112(sp)
    80004894:	7866                	ld	a6,120(sp)
    80004896:	688a                	ld	a7,128(sp)
    80004898:	6e6e                	ld	t3,216(sp)
    8000489a:	7e8e                	ld	t4,224(sp)
    8000489c:	7f2e                	ld	t5,232(sp)
    8000489e:	7fce                	ld	t6,240(sp)
    800048a0:	6111                	addi	sp,sp,256
    800048a2:	10200073          	sret
	...

00000000800048ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800048ae:	1141                	addi	sp,sp,-16
    800048b0:	e422                	sd	s0,8(sp)
    800048b2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800048b4:	0c0007b7          	lui	a5,0xc000
    800048b8:	4705                	li	a4,1
    800048ba:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800048bc:	0c0007b7          	lui	a5,0xc000
    800048c0:	c3d8                	sw	a4,4(a5)
}
    800048c2:	6422                	ld	s0,8(sp)
    800048c4:	0141                	addi	sp,sp,16
    800048c6:	8082                	ret

00000000800048c8 <plicinithart>:

void
plicinithart(void)
{
    800048c8:	1141                	addi	sp,sp,-16
    800048ca:	e406                	sd	ra,8(sp)
    800048cc:	e022                	sd	s0,0(sp)
    800048ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048d0:	d90fc0ef          	jal	80000e60 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800048d4:	0085171b          	slliw	a4,a0,0x8
    800048d8:	0c0027b7          	lui	a5,0xc002
    800048dc:	97ba                	add	a5,a5,a4
    800048de:	40200713          	li	a4,1026
    800048e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800048e6:	00d5151b          	slliw	a0,a0,0xd
    800048ea:	0c2017b7          	lui	a5,0xc201
    800048ee:	97aa                	add	a5,a5,a0
    800048f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800048f4:	60a2                	ld	ra,8(sp)
    800048f6:	6402                	ld	s0,0(sp)
    800048f8:	0141                	addi	sp,sp,16
    800048fa:	8082                	ret

00000000800048fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800048fc:	1141                	addi	sp,sp,-16
    800048fe:	e406                	sd	ra,8(sp)
    80004900:	e022                	sd	s0,0(sp)
    80004902:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004904:	d5cfc0ef          	jal	80000e60 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004908:	00d5151b          	slliw	a0,a0,0xd
    8000490c:	0c2017b7          	lui	a5,0xc201
    80004910:	97aa                	add	a5,a5,a0
  return irq;
}
    80004912:	43c8                	lw	a0,4(a5)
    80004914:	60a2                	ld	ra,8(sp)
    80004916:	6402                	ld	s0,0(sp)
    80004918:	0141                	addi	sp,sp,16
    8000491a:	8082                	ret

000000008000491c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000491c:	1101                	addi	sp,sp,-32
    8000491e:	ec06                	sd	ra,24(sp)
    80004920:	e822                	sd	s0,16(sp)
    80004922:	e426                	sd	s1,8(sp)
    80004924:	1000                	addi	s0,sp,32
    80004926:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004928:	d38fc0ef          	jal	80000e60 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000492c:	00d5151b          	slliw	a0,a0,0xd
    80004930:	0c2017b7          	lui	a5,0xc201
    80004934:	97aa                	add	a5,a5,a0
    80004936:	c3c4                	sw	s1,4(a5)
}
    80004938:	60e2                	ld	ra,24(sp)
    8000493a:	6442                	ld	s0,16(sp)
    8000493c:	64a2                	ld	s1,8(sp)
    8000493e:	6105                	addi	sp,sp,32
    80004940:	8082                	ret

0000000080004942 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004942:	1141                	addi	sp,sp,-16
    80004944:	e406                	sd	ra,8(sp)
    80004946:	e022                	sd	s0,0(sp)
    80004948:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000494a:	479d                	li	a5,7
    8000494c:	04a7ca63          	blt	a5,a0,800049a0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004950:	00017797          	auipc	a5,0x17
    80004954:	ac078793          	addi	a5,a5,-1344 # 8001b410 <disk>
    80004958:	97aa                	add	a5,a5,a0
    8000495a:	0187c783          	lbu	a5,24(a5)
    8000495e:	e7b9                	bnez	a5,800049ac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004960:	00451693          	slli	a3,a0,0x4
    80004964:	00017797          	auipc	a5,0x17
    80004968:	aac78793          	addi	a5,a5,-1364 # 8001b410 <disk>
    8000496c:	6398                	ld	a4,0(a5)
    8000496e:	9736                	add	a4,a4,a3
    80004970:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004974:	6398                	ld	a4,0(a5)
    80004976:	9736                	add	a4,a4,a3
    80004978:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000497c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004980:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004984:	97aa                	add	a5,a5,a0
    80004986:	4705                	li	a4,1
    80004988:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000498c:	00017517          	auipc	a0,0x17
    80004990:	a9c50513          	addi	a0,a0,-1380 # 8001b428 <disk+0x18>
    80004994:	b13fc0ef          	jal	800014a6 <wakeup>
}
    80004998:	60a2                	ld	ra,8(sp)
    8000499a:	6402                	ld	s0,0(sp)
    8000499c:	0141                	addi	sp,sp,16
    8000499e:	8082                	ret
    panic("free_desc 1");
    800049a0:	00003517          	auipc	a0,0x3
    800049a4:	cb050513          	addi	a0,a0,-848 # 80007650 <etext+0x650>
    800049a8:	43b000ef          	jal	800055e2 <panic>
    panic("free_desc 2");
    800049ac:	00003517          	auipc	a0,0x3
    800049b0:	cb450513          	addi	a0,a0,-844 # 80007660 <etext+0x660>
    800049b4:	42f000ef          	jal	800055e2 <panic>

00000000800049b8 <virtio_disk_init>:
{
    800049b8:	1101                	addi	sp,sp,-32
    800049ba:	ec06                	sd	ra,24(sp)
    800049bc:	e822                	sd	s0,16(sp)
    800049be:	e426                	sd	s1,8(sp)
    800049c0:	e04a                	sd	s2,0(sp)
    800049c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800049c4:	00003597          	auipc	a1,0x3
    800049c8:	cac58593          	addi	a1,a1,-852 # 80007670 <etext+0x670>
    800049cc:	00017517          	auipc	a0,0x17
    800049d0:	b6c50513          	addi	a0,a0,-1172 # 8001b538 <disk+0x128>
    800049d4:	6bd000ef          	jal	80005890 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049d8:	100017b7          	lui	a5,0x10001
    800049dc:	4398                	lw	a4,0(a5)
    800049de:	2701                	sext.w	a4,a4
    800049e0:	747277b7          	lui	a5,0x74727
    800049e4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800049e8:	18f71063          	bne	a4,a5,80004b68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049ec:	100017b7          	lui	a5,0x10001
    800049f0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800049f2:	439c                	lw	a5,0(a5)
    800049f4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049f6:	4709                	li	a4,2
    800049f8:	16e79863          	bne	a5,a4,80004b68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049fc:	100017b7          	lui	a5,0x10001
    80004a00:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004a02:	439c                	lw	a5,0(a5)
    80004a04:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a06:	16e79163          	bne	a5,a4,80004b68 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004a0a:	100017b7          	lui	a5,0x10001
    80004a0e:	47d8                	lw	a4,12(a5)
    80004a10:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a12:	554d47b7          	lui	a5,0x554d4
    80004a16:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004a1a:	14f71763          	bne	a4,a5,80004b68 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a1e:	100017b7          	lui	a5,0x10001
    80004a22:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a26:	4705                	li	a4,1
    80004a28:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a2a:	470d                	li	a4,3
    80004a2c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004a2e:	10001737          	lui	a4,0x10001
    80004a32:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004a34:	c7ffe737          	lui	a4,0xc7ffe
    80004a38:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb10f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004a3c:	8ef9                	and	a3,a3,a4
    80004a3e:	10001737          	lui	a4,0x10001
    80004a42:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a44:	472d                	li	a4,11
    80004a46:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a48:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004a4c:	439c                	lw	a5,0(a5)
    80004a4e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004a52:	8ba1                	andi	a5,a5,8
    80004a54:	12078063          	beqz	a5,80004b74 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004a58:	100017b7          	lui	a5,0x10001
    80004a5c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004a60:	100017b7          	lui	a5,0x10001
    80004a64:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004a68:	439c                	lw	a5,0(a5)
    80004a6a:	2781                	sext.w	a5,a5
    80004a6c:	10079a63          	bnez	a5,80004b80 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004a70:	100017b7          	lui	a5,0x10001
    80004a74:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004a78:	439c                	lw	a5,0(a5)
    80004a7a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004a7c:	10078863          	beqz	a5,80004b8c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004a80:	471d                	li	a4,7
    80004a82:	10f77b63          	bgeu	a4,a5,80004b98 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004a86:	e78fb0ef          	jal	800000fe <kalloc>
    80004a8a:	00017497          	auipc	s1,0x17
    80004a8e:	98648493          	addi	s1,s1,-1658 # 8001b410 <disk>
    80004a92:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004a94:	e6afb0ef          	jal	800000fe <kalloc>
    80004a98:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004a9a:	e64fb0ef          	jal	800000fe <kalloc>
    80004a9e:	87aa                	mv	a5,a0
    80004aa0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004aa2:	6088                	ld	a0,0(s1)
    80004aa4:	10050063          	beqz	a0,80004ba4 <virtio_disk_init+0x1ec>
    80004aa8:	00017717          	auipc	a4,0x17
    80004aac:	97073703          	ld	a4,-1680(a4) # 8001b418 <disk+0x8>
    80004ab0:	0e070a63          	beqz	a4,80004ba4 <virtio_disk_init+0x1ec>
    80004ab4:	0e078863          	beqz	a5,80004ba4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004ab8:	6605                	lui	a2,0x1
    80004aba:	4581                	li	a1,0
    80004abc:	e92fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004ac0:	00017497          	auipc	s1,0x17
    80004ac4:	95048493          	addi	s1,s1,-1712 # 8001b410 <disk>
    80004ac8:	6605                	lui	a2,0x1
    80004aca:	4581                	li	a1,0
    80004acc:	6488                	ld	a0,8(s1)
    80004ace:	e80fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004ad2:	6605                	lui	a2,0x1
    80004ad4:	4581                	li	a1,0
    80004ad6:	6888                	ld	a0,16(s1)
    80004ad8:	e76fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004adc:	100017b7          	lui	a5,0x10001
    80004ae0:	4721                	li	a4,8
    80004ae2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004ae4:	4098                	lw	a4,0(s1)
    80004ae6:	100017b7          	lui	a5,0x10001
    80004aea:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004aee:	40d8                	lw	a4,4(s1)
    80004af0:	100017b7          	lui	a5,0x10001
    80004af4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004af8:	649c                	ld	a5,8(s1)
    80004afa:	0007869b          	sext.w	a3,a5
    80004afe:	10001737          	lui	a4,0x10001
    80004b02:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004b06:	9781                	srai	a5,a5,0x20
    80004b08:	10001737          	lui	a4,0x10001
    80004b0c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004b10:	689c                	ld	a5,16(s1)
    80004b12:	0007869b          	sext.w	a3,a5
    80004b16:	10001737          	lui	a4,0x10001
    80004b1a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004b1e:	9781                	srai	a5,a5,0x20
    80004b20:	10001737          	lui	a4,0x10001
    80004b24:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004b28:	10001737          	lui	a4,0x10001
    80004b2c:	4785                	li	a5,1
    80004b2e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004b30:	00f48c23          	sb	a5,24(s1)
    80004b34:	00f48ca3          	sb	a5,25(s1)
    80004b38:	00f48d23          	sb	a5,26(s1)
    80004b3c:	00f48da3          	sb	a5,27(s1)
    80004b40:	00f48e23          	sb	a5,28(s1)
    80004b44:	00f48ea3          	sb	a5,29(s1)
    80004b48:	00f48f23          	sb	a5,30(s1)
    80004b4c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b50:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b54:	100017b7          	lui	a5,0x10001
    80004b58:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004b5c:	60e2                	ld	ra,24(sp)
    80004b5e:	6442                	ld	s0,16(sp)
    80004b60:	64a2                	ld	s1,8(sp)
    80004b62:	6902                	ld	s2,0(sp)
    80004b64:	6105                	addi	sp,sp,32
    80004b66:	8082                	ret
    panic("could not find virtio disk");
    80004b68:	00003517          	auipc	a0,0x3
    80004b6c:	b1850513          	addi	a0,a0,-1256 # 80007680 <etext+0x680>
    80004b70:	273000ef          	jal	800055e2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b74:	00003517          	auipc	a0,0x3
    80004b78:	b2c50513          	addi	a0,a0,-1236 # 800076a0 <etext+0x6a0>
    80004b7c:	267000ef          	jal	800055e2 <panic>
    panic("virtio disk should not be ready");
    80004b80:	00003517          	auipc	a0,0x3
    80004b84:	b4050513          	addi	a0,a0,-1216 # 800076c0 <etext+0x6c0>
    80004b88:	25b000ef          	jal	800055e2 <panic>
    panic("virtio disk has no queue 0");
    80004b8c:	00003517          	auipc	a0,0x3
    80004b90:	b5450513          	addi	a0,a0,-1196 # 800076e0 <etext+0x6e0>
    80004b94:	24f000ef          	jal	800055e2 <panic>
    panic("virtio disk max queue too short");
    80004b98:	00003517          	auipc	a0,0x3
    80004b9c:	b6850513          	addi	a0,a0,-1176 # 80007700 <etext+0x700>
    80004ba0:	243000ef          	jal	800055e2 <panic>
    panic("virtio disk kalloc");
    80004ba4:	00003517          	auipc	a0,0x3
    80004ba8:	b7c50513          	addi	a0,a0,-1156 # 80007720 <etext+0x720>
    80004bac:	237000ef          	jal	800055e2 <panic>

0000000080004bb0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004bb0:	7159                	addi	sp,sp,-112
    80004bb2:	f486                	sd	ra,104(sp)
    80004bb4:	f0a2                	sd	s0,96(sp)
    80004bb6:	eca6                	sd	s1,88(sp)
    80004bb8:	e8ca                	sd	s2,80(sp)
    80004bba:	e4ce                	sd	s3,72(sp)
    80004bbc:	e0d2                	sd	s4,64(sp)
    80004bbe:	fc56                	sd	s5,56(sp)
    80004bc0:	f85a                	sd	s6,48(sp)
    80004bc2:	f45e                	sd	s7,40(sp)
    80004bc4:	f062                	sd	s8,32(sp)
    80004bc6:	ec66                	sd	s9,24(sp)
    80004bc8:	1880                	addi	s0,sp,112
    80004bca:	8a2a                	mv	s4,a0
    80004bcc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004bce:	00c52c83          	lw	s9,12(a0)
    80004bd2:	001c9c9b          	slliw	s9,s9,0x1
    80004bd6:	1c82                	slli	s9,s9,0x20
    80004bd8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004bdc:	00017517          	auipc	a0,0x17
    80004be0:	95c50513          	addi	a0,a0,-1700 # 8001b538 <disk+0x128>
    80004be4:	52d000ef          	jal	80005910 <acquire>
  for(int i = 0; i < 3; i++){
    80004be8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004bea:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004bec:	00017b17          	auipc	s6,0x17
    80004bf0:	824b0b13          	addi	s6,s6,-2012 # 8001b410 <disk>
  for(int i = 0; i < 3; i++){
    80004bf4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004bf6:	00017c17          	auipc	s8,0x17
    80004bfa:	942c0c13          	addi	s8,s8,-1726 # 8001b538 <disk+0x128>
    80004bfe:	a8b9                	j	80004c5c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004c00:	00fb0733          	add	a4,s6,a5
    80004c04:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004c08:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004c0a:	0207c563          	bltz	a5,80004c34 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004c0e:	2905                	addiw	s2,s2,1
    80004c10:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004c12:	05590963          	beq	s2,s5,80004c64 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004c16:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004c18:	00016717          	auipc	a4,0x16
    80004c1c:	7f870713          	addi	a4,a4,2040 # 8001b410 <disk>
    80004c20:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004c22:	01874683          	lbu	a3,24(a4)
    80004c26:	fee9                	bnez	a3,80004c00 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004c28:	2785                	addiw	a5,a5,1
    80004c2a:	0705                	addi	a4,a4,1
    80004c2c:	fe979be3          	bne	a5,s1,80004c22 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004c30:	57fd                	li	a5,-1
    80004c32:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004c34:	01205d63          	blez	s2,80004c4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c38:	f9042503          	lw	a0,-112(s0)
    80004c3c:	d07ff0ef          	jal	80004942 <free_desc>
      for(int j = 0; j < i; j++)
    80004c40:	4785                	li	a5,1
    80004c42:	0127d663          	bge	a5,s2,80004c4e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c46:	f9442503          	lw	a0,-108(s0)
    80004c4a:	cf9ff0ef          	jal	80004942 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c4e:	85e2                	mv	a1,s8
    80004c50:	00016517          	auipc	a0,0x16
    80004c54:	7d850513          	addi	a0,a0,2008 # 8001b428 <disk+0x18>
    80004c58:	803fc0ef          	jal	8000145a <sleep>
  for(int i = 0; i < 3; i++){
    80004c5c:	f9040613          	addi	a2,s0,-112
    80004c60:	894e                	mv	s2,s3
    80004c62:	bf55                	j	80004c16 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c64:	f9042503          	lw	a0,-112(s0)
    80004c68:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c6c:	00016797          	auipc	a5,0x16
    80004c70:	7a478793          	addi	a5,a5,1956 # 8001b410 <disk>
    80004c74:	00a50713          	addi	a4,a0,10
    80004c78:	0712                	slli	a4,a4,0x4
    80004c7a:	973e                	add	a4,a4,a5
    80004c7c:	01703633          	snez	a2,s7
    80004c80:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c82:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c86:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c8a:	6398                	ld	a4,0(a5)
    80004c8c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c8e:	0a868613          	addi	a2,a3,168
    80004c92:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c94:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004c96:	6390                	ld	a2,0(a5)
    80004c98:	00d605b3          	add	a1,a2,a3
    80004c9c:	4741                	li	a4,16
    80004c9e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004ca0:	4805                	li	a6,1
    80004ca2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004ca6:	f9442703          	lw	a4,-108(s0)
    80004caa:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004cae:	0712                	slli	a4,a4,0x4
    80004cb0:	963a                	add	a2,a2,a4
    80004cb2:	058a0593          	addi	a1,s4,88
    80004cb6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004cb8:	0007b883          	ld	a7,0(a5)
    80004cbc:	9746                	add	a4,a4,a7
    80004cbe:	40000613          	li	a2,1024
    80004cc2:	c710                	sw	a2,8(a4)
  if(write)
    80004cc4:	001bb613          	seqz	a2,s7
    80004cc8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004ccc:	00166613          	ori	a2,a2,1
    80004cd0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004cd4:	f9842583          	lw	a1,-104(s0)
    80004cd8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004cdc:	00250613          	addi	a2,a0,2
    80004ce0:	0612                	slli	a2,a2,0x4
    80004ce2:	963e                	add	a2,a2,a5
    80004ce4:	577d                	li	a4,-1
    80004ce6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004cea:	0592                	slli	a1,a1,0x4
    80004cec:	98ae                	add	a7,a7,a1
    80004cee:	03068713          	addi	a4,a3,48
    80004cf2:	973e                	add	a4,a4,a5
    80004cf4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004cf8:	6398                	ld	a4,0(a5)
    80004cfa:	972e                	add	a4,a4,a1
    80004cfc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004d00:	4689                	li	a3,2
    80004d02:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004d06:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004d0a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004d0e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004d12:	6794                	ld	a3,8(a5)
    80004d14:	0026d703          	lhu	a4,2(a3)
    80004d18:	8b1d                	andi	a4,a4,7
    80004d1a:	0706                	slli	a4,a4,0x1
    80004d1c:	96ba                	add	a3,a3,a4
    80004d1e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004d22:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004d26:	6798                	ld	a4,8(a5)
    80004d28:	00275783          	lhu	a5,2(a4)
    80004d2c:	2785                	addiw	a5,a5,1
    80004d2e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004d32:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004d36:	100017b7          	lui	a5,0x10001
    80004d3a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004d3e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004d42:	00016917          	auipc	s2,0x16
    80004d46:	7f690913          	addi	s2,s2,2038 # 8001b538 <disk+0x128>
  while(b->disk == 1) {
    80004d4a:	4485                	li	s1,1
    80004d4c:	01079a63          	bne	a5,a6,80004d60 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d50:	85ca                	mv	a1,s2
    80004d52:	8552                	mv	a0,s4
    80004d54:	f06fc0ef          	jal	8000145a <sleep>
  while(b->disk == 1) {
    80004d58:	004a2783          	lw	a5,4(s4)
    80004d5c:	fe978ae3          	beq	a5,s1,80004d50 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004d60:	f9042903          	lw	s2,-112(s0)
    80004d64:	00290713          	addi	a4,s2,2
    80004d68:	0712                	slli	a4,a4,0x4
    80004d6a:	00016797          	auipc	a5,0x16
    80004d6e:	6a678793          	addi	a5,a5,1702 # 8001b410 <disk>
    80004d72:	97ba                	add	a5,a5,a4
    80004d74:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d78:	00016997          	auipc	s3,0x16
    80004d7c:	69898993          	addi	s3,s3,1688 # 8001b410 <disk>
    80004d80:	00491713          	slli	a4,s2,0x4
    80004d84:	0009b783          	ld	a5,0(s3)
    80004d88:	97ba                	add	a5,a5,a4
    80004d8a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004d8e:	854a                	mv	a0,s2
    80004d90:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004d94:	bafff0ef          	jal	80004942 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004d98:	8885                	andi	s1,s1,1
    80004d9a:	f0fd                	bnez	s1,80004d80 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004d9c:	00016517          	auipc	a0,0x16
    80004da0:	79c50513          	addi	a0,a0,1948 # 8001b538 <disk+0x128>
    80004da4:	405000ef          	jal	800059a8 <release>
}
    80004da8:	70a6                	ld	ra,104(sp)
    80004daa:	7406                	ld	s0,96(sp)
    80004dac:	64e6                	ld	s1,88(sp)
    80004dae:	6946                	ld	s2,80(sp)
    80004db0:	69a6                	ld	s3,72(sp)
    80004db2:	6a06                	ld	s4,64(sp)
    80004db4:	7ae2                	ld	s5,56(sp)
    80004db6:	7b42                	ld	s6,48(sp)
    80004db8:	7ba2                	ld	s7,40(sp)
    80004dba:	7c02                	ld	s8,32(sp)
    80004dbc:	6ce2                	ld	s9,24(sp)
    80004dbe:	6165                	addi	sp,sp,112
    80004dc0:	8082                	ret

0000000080004dc2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004dc2:	1101                	addi	sp,sp,-32
    80004dc4:	ec06                	sd	ra,24(sp)
    80004dc6:	e822                	sd	s0,16(sp)
    80004dc8:	e426                	sd	s1,8(sp)
    80004dca:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004dcc:	00016497          	auipc	s1,0x16
    80004dd0:	64448493          	addi	s1,s1,1604 # 8001b410 <disk>
    80004dd4:	00016517          	auipc	a0,0x16
    80004dd8:	76450513          	addi	a0,a0,1892 # 8001b538 <disk+0x128>
    80004ddc:	335000ef          	jal	80005910 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004de0:	100017b7          	lui	a5,0x10001
    80004de4:	53b8                	lw	a4,96(a5)
    80004de6:	8b0d                	andi	a4,a4,3
    80004de8:	100017b7          	lui	a5,0x10001
    80004dec:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004dee:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004df2:	689c                	ld	a5,16(s1)
    80004df4:	0204d703          	lhu	a4,32(s1)
    80004df8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004dfc:	04f70663          	beq	a4,a5,80004e48 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004e00:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004e04:	6898                	ld	a4,16(s1)
    80004e06:	0204d783          	lhu	a5,32(s1)
    80004e0a:	8b9d                	andi	a5,a5,7
    80004e0c:	078e                	slli	a5,a5,0x3
    80004e0e:	97ba                	add	a5,a5,a4
    80004e10:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004e12:	00278713          	addi	a4,a5,2
    80004e16:	0712                	slli	a4,a4,0x4
    80004e18:	9726                	add	a4,a4,s1
    80004e1a:	01074703          	lbu	a4,16(a4)
    80004e1e:	e321                	bnez	a4,80004e5e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004e20:	0789                	addi	a5,a5,2
    80004e22:	0792                	slli	a5,a5,0x4
    80004e24:	97a6                	add	a5,a5,s1
    80004e26:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004e28:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004e2c:	e7afc0ef          	jal	800014a6 <wakeup>

    disk.used_idx += 1;
    80004e30:	0204d783          	lhu	a5,32(s1)
    80004e34:	2785                	addiw	a5,a5,1
    80004e36:	17c2                	slli	a5,a5,0x30
    80004e38:	93c1                	srli	a5,a5,0x30
    80004e3a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004e3e:	6898                	ld	a4,16(s1)
    80004e40:	00275703          	lhu	a4,2(a4)
    80004e44:	faf71ee3          	bne	a4,a5,80004e00 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e48:	00016517          	auipc	a0,0x16
    80004e4c:	6f050513          	addi	a0,a0,1776 # 8001b538 <disk+0x128>
    80004e50:	359000ef          	jal	800059a8 <release>
}
    80004e54:	60e2                	ld	ra,24(sp)
    80004e56:	6442                	ld	s0,16(sp)
    80004e58:	64a2                	ld	s1,8(sp)
    80004e5a:	6105                	addi	sp,sp,32
    80004e5c:	8082                	ret
      panic("virtio_disk_intr status");
    80004e5e:	00003517          	auipc	a0,0x3
    80004e62:	8da50513          	addi	a0,a0,-1830 # 80007738 <etext+0x738>
    80004e66:	77c000ef          	jal	800055e2 <panic>

0000000080004e6a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e6a:	1141                	addi	sp,sp,-16
    80004e6c:	e422                	sd	s0,8(sp)
    80004e6e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e70:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004e74:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004e78:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004e7c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e80:	577d                	li	a4,-1
    80004e82:	177e                	slli	a4,a4,0x3f
    80004e84:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e86:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004e8a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004e8e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004e92:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004e96:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004e9a:	000f4737          	lui	a4,0xf4
    80004e9e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004ea2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004ea4:	14d79073          	csrw	stimecmp,a5
}
    80004ea8:	6422                	ld	s0,8(sp)
    80004eaa:	0141                	addi	sp,sp,16
    80004eac:	8082                	ret

0000000080004eae <start>:
{
    80004eae:	1141                	addi	sp,sp,-16
    80004eb0:	e406                	sd	ra,8(sp)
    80004eb2:	e022                	sd	s0,0(sp)
    80004eb4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004eb6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004eba:	7779                	lui	a4,0xffffe
    80004ebc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb1af>
    80004ec0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004ec2:	6705                	lui	a4,0x1
    80004ec4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004ec8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004eca:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004ece:	ffffb797          	auipc	a5,0xffffb
    80004ed2:	41a78793          	addi	a5,a5,1050 # 800002e8 <main>
    80004ed6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004eda:	4781                	li	a5,0
    80004edc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004ee0:	67c1                	lui	a5,0x10
    80004ee2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004ee4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004ee8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004eec:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004ef0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004ef4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004ef8:	57fd                	li	a5,-1
    80004efa:	83a9                	srli	a5,a5,0xa
    80004efc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004f00:	47bd                	li	a5,15
    80004f02:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004f06:	f65ff0ef          	jal	80004e6a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004f0a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004f0e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004f10:	823e                	mv	tp,a5
  asm volatile("mret");
    80004f12:	30200073          	mret
}
    80004f16:	60a2                	ld	ra,8(sp)
    80004f18:	6402                	ld	s0,0(sp)
    80004f1a:	0141                	addi	sp,sp,16
    80004f1c:	8082                	ret

0000000080004f1e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004f1e:	715d                	addi	sp,sp,-80
    80004f20:	e486                	sd	ra,72(sp)
    80004f22:	e0a2                	sd	s0,64(sp)
    80004f24:	f84a                	sd	s2,48(sp)
    80004f26:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004f28:	04c05263          	blez	a2,80004f6c <consolewrite+0x4e>
    80004f2c:	fc26                	sd	s1,56(sp)
    80004f2e:	f44e                	sd	s3,40(sp)
    80004f30:	f052                	sd	s4,32(sp)
    80004f32:	ec56                	sd	s5,24(sp)
    80004f34:	8a2a                	mv	s4,a0
    80004f36:	84ae                	mv	s1,a1
    80004f38:	89b2                	mv	s3,a2
    80004f3a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004f3c:	5afd                	li	s5,-1
    80004f3e:	4685                	li	a3,1
    80004f40:	8626                	mv	a2,s1
    80004f42:	85d2                	mv	a1,s4
    80004f44:	fbf40513          	addi	a0,s0,-65
    80004f48:	8b9fc0ef          	jal	80001800 <either_copyin>
    80004f4c:	03550263          	beq	a0,s5,80004f70 <consolewrite+0x52>
      break;
    uartputc(c);
    80004f50:	fbf44503          	lbu	a0,-65(s0)
    80004f54:	035000ef          	jal	80005788 <uartputc>
  for(i = 0; i < n; i++){
    80004f58:	2905                	addiw	s2,s2,1
    80004f5a:	0485                	addi	s1,s1,1
    80004f5c:	ff2991e3          	bne	s3,s2,80004f3e <consolewrite+0x20>
    80004f60:	894e                	mv	s2,s3
    80004f62:	74e2                	ld	s1,56(sp)
    80004f64:	79a2                	ld	s3,40(sp)
    80004f66:	7a02                	ld	s4,32(sp)
    80004f68:	6ae2                	ld	s5,24(sp)
    80004f6a:	a039                	j	80004f78 <consolewrite+0x5a>
    80004f6c:	4901                	li	s2,0
    80004f6e:	a029                	j	80004f78 <consolewrite+0x5a>
    80004f70:	74e2                	ld	s1,56(sp)
    80004f72:	79a2                	ld	s3,40(sp)
    80004f74:	7a02                	ld	s4,32(sp)
    80004f76:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004f78:	854a                	mv	a0,s2
    80004f7a:	60a6                	ld	ra,72(sp)
    80004f7c:	6406                	ld	s0,64(sp)
    80004f7e:	7942                	ld	s2,48(sp)
    80004f80:	6161                	addi	sp,sp,80
    80004f82:	8082                	ret

0000000080004f84 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004f84:	711d                	addi	sp,sp,-96
    80004f86:	ec86                	sd	ra,88(sp)
    80004f88:	e8a2                	sd	s0,80(sp)
    80004f8a:	e4a6                	sd	s1,72(sp)
    80004f8c:	e0ca                	sd	s2,64(sp)
    80004f8e:	fc4e                	sd	s3,56(sp)
    80004f90:	f852                	sd	s4,48(sp)
    80004f92:	f456                	sd	s5,40(sp)
    80004f94:	f05a                	sd	s6,32(sp)
    80004f96:	1080                	addi	s0,sp,96
    80004f98:	8aaa                	mv	s5,a0
    80004f9a:	8a2e                	mv	s4,a1
    80004f9c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004f9e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004fa2:	0001e517          	auipc	a0,0x1e
    80004fa6:	5ae50513          	addi	a0,a0,1454 # 80023550 <cons>
    80004faa:	167000ef          	jal	80005910 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004fae:	0001e497          	auipc	s1,0x1e
    80004fb2:	5a248493          	addi	s1,s1,1442 # 80023550 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004fb6:	0001e917          	auipc	s2,0x1e
    80004fba:	63290913          	addi	s2,s2,1586 # 800235e8 <cons+0x98>
  while(n > 0){
    80004fbe:	0b305d63          	blez	s3,80005078 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004fc2:	0984a783          	lw	a5,152(s1)
    80004fc6:	09c4a703          	lw	a4,156(s1)
    80004fca:	0af71263          	bne	a4,a5,8000506e <consoleread+0xea>
      if(killed(myproc())){
    80004fce:	ebffb0ef          	jal	80000e8c <myproc>
    80004fd2:	ec0fc0ef          	jal	80001692 <killed>
    80004fd6:	e12d                	bnez	a0,80005038 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004fd8:	85a6                	mv	a1,s1
    80004fda:	854a                	mv	a0,s2
    80004fdc:	c7efc0ef          	jal	8000145a <sleep>
    while(cons.r == cons.w){
    80004fe0:	0984a783          	lw	a5,152(s1)
    80004fe4:	09c4a703          	lw	a4,156(s1)
    80004fe8:	fef703e3          	beq	a4,a5,80004fce <consoleread+0x4a>
    80004fec:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004fee:	0001e717          	auipc	a4,0x1e
    80004ff2:	56270713          	addi	a4,a4,1378 # 80023550 <cons>
    80004ff6:	0017869b          	addiw	a3,a5,1
    80004ffa:	08d72c23          	sw	a3,152(a4)
    80004ffe:	07f7f693          	andi	a3,a5,127
    80005002:	9736                	add	a4,a4,a3
    80005004:	01874703          	lbu	a4,24(a4)
    80005008:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    8000500c:	4691                	li	a3,4
    8000500e:	04db8663          	beq	s7,a3,8000505a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005012:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005016:	4685                	li	a3,1
    80005018:	faf40613          	addi	a2,s0,-81
    8000501c:	85d2                	mv	a1,s4
    8000501e:	8556                	mv	a0,s5
    80005020:	f96fc0ef          	jal	800017b6 <either_copyout>
    80005024:	57fd                	li	a5,-1
    80005026:	04f50863          	beq	a0,a5,80005076 <consoleread+0xf2>
      break;

    dst++;
    8000502a:	0a05                	addi	s4,s4,1
    --n;
    8000502c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000502e:	47a9                	li	a5,10
    80005030:	04fb8d63          	beq	s7,a5,8000508a <consoleread+0x106>
    80005034:	6be2                	ld	s7,24(sp)
    80005036:	b761                	j	80004fbe <consoleread+0x3a>
        release(&cons.lock);
    80005038:	0001e517          	auipc	a0,0x1e
    8000503c:	51850513          	addi	a0,a0,1304 # 80023550 <cons>
    80005040:	169000ef          	jal	800059a8 <release>
        return -1;
    80005044:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005046:	60e6                	ld	ra,88(sp)
    80005048:	6446                	ld	s0,80(sp)
    8000504a:	64a6                	ld	s1,72(sp)
    8000504c:	6906                	ld	s2,64(sp)
    8000504e:	79e2                	ld	s3,56(sp)
    80005050:	7a42                	ld	s4,48(sp)
    80005052:	7aa2                	ld	s5,40(sp)
    80005054:	7b02                	ld	s6,32(sp)
    80005056:	6125                	addi	sp,sp,96
    80005058:	8082                	ret
      if(n < target){
    8000505a:	0009871b          	sext.w	a4,s3
    8000505e:	01677a63          	bgeu	a4,s6,80005072 <consoleread+0xee>
        cons.r--;
    80005062:	0001e717          	auipc	a4,0x1e
    80005066:	58f72323          	sw	a5,1414(a4) # 800235e8 <cons+0x98>
    8000506a:	6be2                	ld	s7,24(sp)
    8000506c:	a031                	j	80005078 <consoleread+0xf4>
    8000506e:	ec5e                	sd	s7,24(sp)
    80005070:	bfbd                	j	80004fee <consoleread+0x6a>
    80005072:	6be2                	ld	s7,24(sp)
    80005074:	a011                	j	80005078 <consoleread+0xf4>
    80005076:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005078:	0001e517          	auipc	a0,0x1e
    8000507c:	4d850513          	addi	a0,a0,1240 # 80023550 <cons>
    80005080:	129000ef          	jal	800059a8 <release>
  return target - n;
    80005084:	413b053b          	subw	a0,s6,s3
    80005088:	bf7d                	j	80005046 <consoleread+0xc2>
    8000508a:	6be2                	ld	s7,24(sp)
    8000508c:	b7f5                	j	80005078 <consoleread+0xf4>

000000008000508e <consputc>:
{
    8000508e:	1141                	addi	sp,sp,-16
    80005090:	e406                	sd	ra,8(sp)
    80005092:	e022                	sd	s0,0(sp)
    80005094:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005096:	10000793          	li	a5,256
    8000509a:	00f50863          	beq	a0,a5,800050aa <consputc+0x1c>
    uartputc_sync(c);
    8000509e:	604000ef          	jal	800056a2 <uartputc_sync>
}
    800050a2:	60a2                	ld	ra,8(sp)
    800050a4:	6402                	ld	s0,0(sp)
    800050a6:	0141                	addi	sp,sp,16
    800050a8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800050aa:	4521                	li	a0,8
    800050ac:	5f6000ef          	jal	800056a2 <uartputc_sync>
    800050b0:	02000513          	li	a0,32
    800050b4:	5ee000ef          	jal	800056a2 <uartputc_sync>
    800050b8:	4521                	li	a0,8
    800050ba:	5e8000ef          	jal	800056a2 <uartputc_sync>
    800050be:	b7d5                	j	800050a2 <consputc+0x14>

00000000800050c0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800050c0:	1101                	addi	sp,sp,-32
    800050c2:	ec06                	sd	ra,24(sp)
    800050c4:	e822                	sd	s0,16(sp)
    800050c6:	e426                	sd	s1,8(sp)
    800050c8:	1000                	addi	s0,sp,32
    800050ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800050cc:	0001e517          	auipc	a0,0x1e
    800050d0:	48450513          	addi	a0,a0,1156 # 80023550 <cons>
    800050d4:	03d000ef          	jal	80005910 <acquire>

  switch(c){
    800050d8:	47d5                	li	a5,21
    800050da:	08f48f63          	beq	s1,a5,80005178 <consoleintr+0xb8>
    800050de:	0297c563          	blt	a5,s1,80005108 <consoleintr+0x48>
    800050e2:	47a1                	li	a5,8
    800050e4:	0ef48463          	beq	s1,a5,800051cc <consoleintr+0x10c>
    800050e8:	47c1                	li	a5,16
    800050ea:	10f49563          	bne	s1,a5,800051f4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800050ee:	f5cfc0ef          	jal	8000184a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800050f2:	0001e517          	auipc	a0,0x1e
    800050f6:	45e50513          	addi	a0,a0,1118 # 80023550 <cons>
    800050fa:	0af000ef          	jal	800059a8 <release>
}
    800050fe:	60e2                	ld	ra,24(sp)
    80005100:	6442                	ld	s0,16(sp)
    80005102:	64a2                	ld	s1,8(sp)
    80005104:	6105                	addi	sp,sp,32
    80005106:	8082                	ret
  switch(c){
    80005108:	07f00793          	li	a5,127
    8000510c:	0cf48063          	beq	s1,a5,800051cc <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005110:	0001e717          	auipc	a4,0x1e
    80005114:	44070713          	addi	a4,a4,1088 # 80023550 <cons>
    80005118:	0a072783          	lw	a5,160(a4)
    8000511c:	09872703          	lw	a4,152(a4)
    80005120:	9f99                	subw	a5,a5,a4
    80005122:	07f00713          	li	a4,127
    80005126:	fcf766e3          	bltu	a4,a5,800050f2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000512a:	47b5                	li	a5,13
    8000512c:	0cf48763          	beq	s1,a5,800051fa <consoleintr+0x13a>
      consputc(c);
    80005130:	8526                	mv	a0,s1
    80005132:	f5dff0ef          	jal	8000508e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005136:	0001e797          	auipc	a5,0x1e
    8000513a:	41a78793          	addi	a5,a5,1050 # 80023550 <cons>
    8000513e:	0a07a683          	lw	a3,160(a5)
    80005142:	0016871b          	addiw	a4,a3,1
    80005146:	0007061b          	sext.w	a2,a4
    8000514a:	0ae7a023          	sw	a4,160(a5)
    8000514e:	07f6f693          	andi	a3,a3,127
    80005152:	97b6                	add	a5,a5,a3
    80005154:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005158:	47a9                	li	a5,10
    8000515a:	0cf48563          	beq	s1,a5,80005224 <consoleintr+0x164>
    8000515e:	4791                	li	a5,4
    80005160:	0cf48263          	beq	s1,a5,80005224 <consoleintr+0x164>
    80005164:	0001e797          	auipc	a5,0x1e
    80005168:	4847a783          	lw	a5,1156(a5) # 800235e8 <cons+0x98>
    8000516c:	9f1d                	subw	a4,a4,a5
    8000516e:	08000793          	li	a5,128
    80005172:	f8f710e3          	bne	a4,a5,800050f2 <consoleintr+0x32>
    80005176:	a07d                	j	80005224 <consoleintr+0x164>
    80005178:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000517a:	0001e717          	auipc	a4,0x1e
    8000517e:	3d670713          	addi	a4,a4,982 # 80023550 <cons>
    80005182:	0a072783          	lw	a5,160(a4)
    80005186:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000518a:	0001e497          	auipc	s1,0x1e
    8000518e:	3c648493          	addi	s1,s1,966 # 80023550 <cons>
    while(cons.e != cons.w &&
    80005192:	4929                	li	s2,10
    80005194:	02f70863          	beq	a4,a5,800051c4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005198:	37fd                	addiw	a5,a5,-1
    8000519a:	07f7f713          	andi	a4,a5,127
    8000519e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800051a0:	01874703          	lbu	a4,24(a4)
    800051a4:	03270263          	beq	a4,s2,800051c8 <consoleintr+0x108>
      cons.e--;
    800051a8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800051ac:	10000513          	li	a0,256
    800051b0:	edfff0ef          	jal	8000508e <consputc>
    while(cons.e != cons.w &&
    800051b4:	0a04a783          	lw	a5,160(s1)
    800051b8:	09c4a703          	lw	a4,156(s1)
    800051bc:	fcf71ee3          	bne	a4,a5,80005198 <consoleintr+0xd8>
    800051c0:	6902                	ld	s2,0(sp)
    800051c2:	bf05                	j	800050f2 <consoleintr+0x32>
    800051c4:	6902                	ld	s2,0(sp)
    800051c6:	b735                	j	800050f2 <consoleintr+0x32>
    800051c8:	6902                	ld	s2,0(sp)
    800051ca:	b725                	j	800050f2 <consoleintr+0x32>
    if(cons.e != cons.w){
    800051cc:	0001e717          	auipc	a4,0x1e
    800051d0:	38470713          	addi	a4,a4,900 # 80023550 <cons>
    800051d4:	0a072783          	lw	a5,160(a4)
    800051d8:	09c72703          	lw	a4,156(a4)
    800051dc:	f0f70be3          	beq	a4,a5,800050f2 <consoleintr+0x32>
      cons.e--;
    800051e0:	37fd                	addiw	a5,a5,-1
    800051e2:	0001e717          	auipc	a4,0x1e
    800051e6:	40f72723          	sw	a5,1038(a4) # 800235f0 <cons+0xa0>
      consputc(BACKSPACE);
    800051ea:	10000513          	li	a0,256
    800051ee:	ea1ff0ef          	jal	8000508e <consputc>
    800051f2:	b701                	j	800050f2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051f4:	ee048fe3          	beqz	s1,800050f2 <consoleintr+0x32>
    800051f8:	bf21                	j	80005110 <consoleintr+0x50>
      consputc(c);
    800051fa:	4529                	li	a0,10
    800051fc:	e93ff0ef          	jal	8000508e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005200:	0001e797          	auipc	a5,0x1e
    80005204:	35078793          	addi	a5,a5,848 # 80023550 <cons>
    80005208:	0a07a703          	lw	a4,160(a5)
    8000520c:	0017069b          	addiw	a3,a4,1
    80005210:	0006861b          	sext.w	a2,a3
    80005214:	0ad7a023          	sw	a3,160(a5)
    80005218:	07f77713          	andi	a4,a4,127
    8000521c:	97ba                	add	a5,a5,a4
    8000521e:	4729                	li	a4,10
    80005220:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005224:	0001e797          	auipc	a5,0x1e
    80005228:	3cc7a423          	sw	a2,968(a5) # 800235ec <cons+0x9c>
        wakeup(&cons.r);
    8000522c:	0001e517          	auipc	a0,0x1e
    80005230:	3bc50513          	addi	a0,a0,956 # 800235e8 <cons+0x98>
    80005234:	a72fc0ef          	jal	800014a6 <wakeup>
    80005238:	bd6d                	j	800050f2 <consoleintr+0x32>

000000008000523a <consoleinit>:

void
consoleinit(void)
{
    8000523a:	1141                	addi	sp,sp,-16
    8000523c:	e406                	sd	ra,8(sp)
    8000523e:	e022                	sd	s0,0(sp)
    80005240:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005242:	00002597          	auipc	a1,0x2
    80005246:	50e58593          	addi	a1,a1,1294 # 80007750 <etext+0x750>
    8000524a:	0001e517          	auipc	a0,0x1e
    8000524e:	30650513          	addi	a0,a0,774 # 80023550 <cons>
    80005252:	63e000ef          	jal	80005890 <initlock>

  uartinit();
    80005256:	3f4000ef          	jal	8000564a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000525a:	00015797          	auipc	a5,0x15
    8000525e:	15e78793          	addi	a5,a5,350 # 8001a3b8 <devsw>
    80005262:	00000717          	auipc	a4,0x0
    80005266:	d2270713          	addi	a4,a4,-734 # 80004f84 <consoleread>
    8000526a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000526c:	00000717          	auipc	a4,0x0
    80005270:	cb270713          	addi	a4,a4,-846 # 80004f1e <consolewrite>
    80005274:	ef98                	sd	a4,24(a5)
}
    80005276:	60a2                	ld	ra,8(sp)
    80005278:	6402                	ld	s0,0(sp)
    8000527a:	0141                	addi	sp,sp,16
    8000527c:	8082                	ret

000000008000527e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000527e:	7179                	addi	sp,sp,-48
    80005280:	f406                	sd	ra,40(sp)
    80005282:	f022                	sd	s0,32(sp)
    80005284:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005286:	c219                	beqz	a2,8000528c <printint+0xe>
    80005288:	08054063          	bltz	a0,80005308 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000528c:	4881                	li	a7,0
    8000528e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005292:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005294:	00002617          	auipc	a2,0x2
    80005298:	61c60613          	addi	a2,a2,1564 # 800078b0 <digits>
    8000529c:	883e                	mv	a6,a5
    8000529e:	2785                	addiw	a5,a5,1
    800052a0:	02b57733          	remu	a4,a0,a1
    800052a4:	9732                	add	a4,a4,a2
    800052a6:	00074703          	lbu	a4,0(a4)
    800052aa:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800052ae:	872a                	mv	a4,a0
    800052b0:	02b55533          	divu	a0,a0,a1
    800052b4:	0685                	addi	a3,a3,1
    800052b6:	feb773e3          	bgeu	a4,a1,8000529c <printint+0x1e>

  if(sign)
    800052ba:	00088a63          	beqz	a7,800052ce <printint+0x50>
    buf[i++] = '-';
    800052be:	1781                	addi	a5,a5,-32
    800052c0:	97a2                	add	a5,a5,s0
    800052c2:	02d00713          	li	a4,45
    800052c6:	fee78823          	sb	a4,-16(a5)
    800052ca:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800052ce:	02f05963          	blez	a5,80005300 <printint+0x82>
    800052d2:	ec26                	sd	s1,24(sp)
    800052d4:	e84a                	sd	s2,16(sp)
    800052d6:	fd040713          	addi	a4,s0,-48
    800052da:	00f704b3          	add	s1,a4,a5
    800052de:	fff70913          	addi	s2,a4,-1
    800052e2:	993e                	add	s2,s2,a5
    800052e4:	37fd                	addiw	a5,a5,-1
    800052e6:	1782                	slli	a5,a5,0x20
    800052e8:	9381                	srli	a5,a5,0x20
    800052ea:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800052ee:	fff4c503          	lbu	a0,-1(s1)
    800052f2:	d9dff0ef          	jal	8000508e <consputc>
  while(--i >= 0)
    800052f6:	14fd                	addi	s1,s1,-1
    800052f8:	ff249be3          	bne	s1,s2,800052ee <printint+0x70>
    800052fc:	64e2                	ld	s1,24(sp)
    800052fe:	6942                	ld	s2,16(sp)
}
    80005300:	70a2                	ld	ra,40(sp)
    80005302:	7402                	ld	s0,32(sp)
    80005304:	6145                	addi	sp,sp,48
    80005306:	8082                	ret
    x = -xx;
    80005308:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000530c:	4885                	li	a7,1
    x = -xx;
    8000530e:	b741                	j	8000528e <printint+0x10>

0000000080005310 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005310:	7155                	addi	sp,sp,-208
    80005312:	e506                	sd	ra,136(sp)
    80005314:	e122                	sd	s0,128(sp)
    80005316:	f0d2                	sd	s4,96(sp)
    80005318:	0900                	addi	s0,sp,144
    8000531a:	8a2a                	mv	s4,a0
    8000531c:	e40c                	sd	a1,8(s0)
    8000531e:	e810                	sd	a2,16(s0)
    80005320:	ec14                	sd	a3,24(s0)
    80005322:	f018                	sd	a4,32(s0)
    80005324:	f41c                	sd	a5,40(s0)
    80005326:	03043823          	sd	a6,48(s0)
    8000532a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000532e:	0001e797          	auipc	a5,0x1e
    80005332:	2e27a783          	lw	a5,738(a5) # 80023610 <pr+0x18>
    80005336:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000533a:	e3a1                	bnez	a5,8000537a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000533c:	00840793          	addi	a5,s0,8
    80005340:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005344:	00054503          	lbu	a0,0(a0)
    80005348:	26050763          	beqz	a0,800055b6 <printf+0x2a6>
    8000534c:	fca6                	sd	s1,120(sp)
    8000534e:	f8ca                	sd	s2,112(sp)
    80005350:	f4ce                	sd	s3,104(sp)
    80005352:	ecd6                	sd	s5,88(sp)
    80005354:	e8da                	sd	s6,80(sp)
    80005356:	e0e2                	sd	s8,64(sp)
    80005358:	fc66                	sd	s9,56(sp)
    8000535a:	f86a                	sd	s10,48(sp)
    8000535c:	f46e                	sd	s11,40(sp)
    8000535e:	4981                	li	s3,0
    if(cx != '%'){
    80005360:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005364:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005368:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000536c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005370:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005374:	07000d93          	li	s11,112
    80005378:	a815                	j	800053ac <printf+0x9c>
    acquire(&pr.lock);
    8000537a:	0001e517          	auipc	a0,0x1e
    8000537e:	27e50513          	addi	a0,a0,638 # 800235f8 <pr>
    80005382:	58e000ef          	jal	80005910 <acquire>
  va_start(ap, fmt);
    80005386:	00840793          	addi	a5,s0,8
    8000538a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000538e:	000a4503          	lbu	a0,0(s4)
    80005392:	fd4d                	bnez	a0,8000534c <printf+0x3c>
    80005394:	a481                	j	800055d4 <printf+0x2c4>
      consputc(cx);
    80005396:	cf9ff0ef          	jal	8000508e <consputc>
      continue;
    8000539a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000539c:	0014899b          	addiw	s3,s1,1
    800053a0:	013a07b3          	add	a5,s4,s3
    800053a4:	0007c503          	lbu	a0,0(a5)
    800053a8:	1e050b63          	beqz	a0,8000559e <printf+0x28e>
    if(cx != '%'){
    800053ac:	ff5515e3          	bne	a0,s5,80005396 <printf+0x86>
    i++;
    800053b0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800053b4:	009a07b3          	add	a5,s4,s1
    800053b8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800053bc:	1e090163          	beqz	s2,8000559e <printf+0x28e>
    800053c0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800053c4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800053c6:	c789                	beqz	a5,800053d0 <printf+0xc0>
    800053c8:	009a0733          	add	a4,s4,s1
    800053cc:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800053d0:	03690763          	beq	s2,s6,800053fe <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    800053d4:	05890163          	beq	s2,s8,80005416 <printf+0x106>
    } else if(c0 == 'u'){
    800053d8:	0d990b63          	beq	s2,s9,800054ae <printf+0x19e>
    } else if(c0 == 'x'){
    800053dc:	13a90163          	beq	s2,s10,800054fe <printf+0x1ee>
    } else if(c0 == 'p'){
    800053e0:	13b90b63          	beq	s2,s11,80005516 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800053e4:	07300793          	li	a5,115
    800053e8:	16f90a63          	beq	s2,a5,8000555c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800053ec:	1b590463          	beq	s2,s5,80005594 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800053f0:	8556                	mv	a0,s5
    800053f2:	c9dff0ef          	jal	8000508e <consputc>
      consputc(c0);
    800053f6:	854a                	mv	a0,s2
    800053f8:	c97ff0ef          	jal	8000508e <consputc>
    800053fc:	b745                	j	8000539c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800053fe:	f8843783          	ld	a5,-120(s0)
    80005402:	00878713          	addi	a4,a5,8
    80005406:	f8e43423          	sd	a4,-120(s0)
    8000540a:	4605                	li	a2,1
    8000540c:	45a9                	li	a1,10
    8000540e:	4388                	lw	a0,0(a5)
    80005410:	e6fff0ef          	jal	8000527e <printint>
    80005414:	b761                	j	8000539c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005416:	03678663          	beq	a5,s6,80005442 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000541a:	05878263          	beq	a5,s8,8000545e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000541e:	0b978463          	beq	a5,s9,800054c6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005422:	fda797e3          	bne	a5,s10,800053f0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005426:	f8843783          	ld	a5,-120(s0)
    8000542a:	00878713          	addi	a4,a5,8
    8000542e:	f8e43423          	sd	a4,-120(s0)
    80005432:	4601                	li	a2,0
    80005434:	45c1                	li	a1,16
    80005436:	6388                	ld	a0,0(a5)
    80005438:	e47ff0ef          	jal	8000527e <printint>
      i += 1;
    8000543c:	0029849b          	addiw	s1,s3,2
    80005440:	bfb1                	j	8000539c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005442:	f8843783          	ld	a5,-120(s0)
    80005446:	00878713          	addi	a4,a5,8
    8000544a:	f8e43423          	sd	a4,-120(s0)
    8000544e:	4605                	li	a2,1
    80005450:	45a9                	li	a1,10
    80005452:	6388                	ld	a0,0(a5)
    80005454:	e2bff0ef          	jal	8000527e <printint>
      i += 1;
    80005458:	0029849b          	addiw	s1,s3,2
    8000545c:	b781                	j	8000539c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000545e:	06400793          	li	a5,100
    80005462:	02f68863          	beq	a3,a5,80005492 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005466:	07500793          	li	a5,117
    8000546a:	06f68c63          	beq	a3,a5,800054e2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000546e:	07800793          	li	a5,120
    80005472:	f6f69fe3          	bne	a3,a5,800053f0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005476:	f8843783          	ld	a5,-120(s0)
    8000547a:	00878713          	addi	a4,a5,8
    8000547e:	f8e43423          	sd	a4,-120(s0)
    80005482:	4601                	li	a2,0
    80005484:	45c1                	li	a1,16
    80005486:	6388                	ld	a0,0(a5)
    80005488:	df7ff0ef          	jal	8000527e <printint>
      i += 2;
    8000548c:	0039849b          	addiw	s1,s3,3
    80005490:	b731                	j	8000539c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005492:	f8843783          	ld	a5,-120(s0)
    80005496:	00878713          	addi	a4,a5,8
    8000549a:	f8e43423          	sd	a4,-120(s0)
    8000549e:	4605                	li	a2,1
    800054a0:	45a9                	li	a1,10
    800054a2:	6388                	ld	a0,0(a5)
    800054a4:	ddbff0ef          	jal	8000527e <printint>
      i += 2;
    800054a8:	0039849b          	addiw	s1,s3,3
    800054ac:	bdc5                	j	8000539c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800054ae:	f8843783          	ld	a5,-120(s0)
    800054b2:	00878713          	addi	a4,a5,8
    800054b6:	f8e43423          	sd	a4,-120(s0)
    800054ba:	4601                	li	a2,0
    800054bc:	45a9                	li	a1,10
    800054be:	4388                	lw	a0,0(a5)
    800054c0:	dbfff0ef          	jal	8000527e <printint>
    800054c4:	bde1                	j	8000539c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800054c6:	f8843783          	ld	a5,-120(s0)
    800054ca:	00878713          	addi	a4,a5,8
    800054ce:	f8e43423          	sd	a4,-120(s0)
    800054d2:	4601                	li	a2,0
    800054d4:	45a9                	li	a1,10
    800054d6:	6388                	ld	a0,0(a5)
    800054d8:	da7ff0ef          	jal	8000527e <printint>
      i += 1;
    800054dc:	0029849b          	addiw	s1,s3,2
    800054e0:	bd75                	j	8000539c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800054e2:	f8843783          	ld	a5,-120(s0)
    800054e6:	00878713          	addi	a4,a5,8
    800054ea:	f8e43423          	sd	a4,-120(s0)
    800054ee:	4601                	li	a2,0
    800054f0:	45a9                	li	a1,10
    800054f2:	6388                	ld	a0,0(a5)
    800054f4:	d8bff0ef          	jal	8000527e <printint>
      i += 2;
    800054f8:	0039849b          	addiw	s1,s3,3
    800054fc:	b545                	j	8000539c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800054fe:	f8843783          	ld	a5,-120(s0)
    80005502:	00878713          	addi	a4,a5,8
    80005506:	f8e43423          	sd	a4,-120(s0)
    8000550a:	4601                	li	a2,0
    8000550c:	45c1                	li	a1,16
    8000550e:	4388                	lw	a0,0(a5)
    80005510:	d6fff0ef          	jal	8000527e <printint>
    80005514:	b561                	j	8000539c <printf+0x8c>
    80005516:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005518:	f8843783          	ld	a5,-120(s0)
    8000551c:	00878713          	addi	a4,a5,8
    80005520:	f8e43423          	sd	a4,-120(s0)
    80005524:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005528:	03000513          	li	a0,48
    8000552c:	b63ff0ef          	jal	8000508e <consputc>
  consputc('x');
    80005530:	07800513          	li	a0,120
    80005534:	b5bff0ef          	jal	8000508e <consputc>
    80005538:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000553a:	00002b97          	auipc	s7,0x2
    8000553e:	376b8b93          	addi	s7,s7,886 # 800078b0 <digits>
    80005542:	03c9d793          	srli	a5,s3,0x3c
    80005546:	97de                	add	a5,a5,s7
    80005548:	0007c503          	lbu	a0,0(a5)
    8000554c:	b43ff0ef          	jal	8000508e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005550:	0992                	slli	s3,s3,0x4
    80005552:	397d                	addiw	s2,s2,-1
    80005554:	fe0917e3          	bnez	s2,80005542 <printf+0x232>
    80005558:	6ba6                	ld	s7,72(sp)
    8000555a:	b589                	j	8000539c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000555c:	f8843783          	ld	a5,-120(s0)
    80005560:	00878713          	addi	a4,a5,8
    80005564:	f8e43423          	sd	a4,-120(s0)
    80005568:	0007b903          	ld	s2,0(a5)
    8000556c:	00090d63          	beqz	s2,80005586 <printf+0x276>
      for(; *s; s++)
    80005570:	00094503          	lbu	a0,0(s2)
    80005574:	e20504e3          	beqz	a0,8000539c <printf+0x8c>
        consputc(*s);
    80005578:	b17ff0ef          	jal	8000508e <consputc>
      for(; *s; s++)
    8000557c:	0905                	addi	s2,s2,1
    8000557e:	00094503          	lbu	a0,0(s2)
    80005582:	f97d                	bnez	a0,80005578 <printf+0x268>
    80005584:	bd21                	j	8000539c <printf+0x8c>
        s = "(null)";
    80005586:	00002917          	auipc	s2,0x2
    8000558a:	1d290913          	addi	s2,s2,466 # 80007758 <etext+0x758>
      for(; *s; s++)
    8000558e:	02800513          	li	a0,40
    80005592:	b7dd                	j	80005578 <printf+0x268>
      consputc('%');
    80005594:	02500513          	li	a0,37
    80005598:	af7ff0ef          	jal	8000508e <consputc>
    8000559c:	b501                	j	8000539c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000559e:	f7843783          	ld	a5,-136(s0)
    800055a2:	e385                	bnez	a5,800055c2 <printf+0x2b2>
    800055a4:	74e6                	ld	s1,120(sp)
    800055a6:	7946                	ld	s2,112(sp)
    800055a8:	79a6                	ld	s3,104(sp)
    800055aa:	6ae6                	ld	s5,88(sp)
    800055ac:	6b46                	ld	s6,80(sp)
    800055ae:	6c06                	ld	s8,64(sp)
    800055b0:	7ce2                	ld	s9,56(sp)
    800055b2:	7d42                	ld	s10,48(sp)
    800055b4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800055b6:	4501                	li	a0,0
    800055b8:	60aa                	ld	ra,136(sp)
    800055ba:	640a                	ld	s0,128(sp)
    800055bc:	7a06                	ld	s4,96(sp)
    800055be:	6169                	addi	sp,sp,208
    800055c0:	8082                	ret
    800055c2:	74e6                	ld	s1,120(sp)
    800055c4:	7946                	ld	s2,112(sp)
    800055c6:	79a6                	ld	s3,104(sp)
    800055c8:	6ae6                	ld	s5,88(sp)
    800055ca:	6b46                	ld	s6,80(sp)
    800055cc:	6c06                	ld	s8,64(sp)
    800055ce:	7ce2                	ld	s9,56(sp)
    800055d0:	7d42                	ld	s10,48(sp)
    800055d2:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800055d4:	0001e517          	auipc	a0,0x1e
    800055d8:	02450513          	addi	a0,a0,36 # 800235f8 <pr>
    800055dc:	3cc000ef          	jal	800059a8 <release>
    800055e0:	bfd9                	j	800055b6 <printf+0x2a6>

00000000800055e2 <panic>:

void
panic(char *s)
{
    800055e2:	1101                	addi	sp,sp,-32
    800055e4:	ec06                	sd	ra,24(sp)
    800055e6:	e822                	sd	s0,16(sp)
    800055e8:	e426                	sd	s1,8(sp)
    800055ea:	1000                	addi	s0,sp,32
    800055ec:	84aa                	mv	s1,a0
  pr.locking = 0;
    800055ee:	0001e797          	auipc	a5,0x1e
    800055f2:	0207a123          	sw	zero,34(a5) # 80023610 <pr+0x18>
  printf("panic: ");
    800055f6:	00002517          	auipc	a0,0x2
    800055fa:	16a50513          	addi	a0,a0,362 # 80007760 <etext+0x760>
    800055fe:	d13ff0ef          	jal	80005310 <printf>
  printf("%s\n", s);
    80005602:	85a6                	mv	a1,s1
    80005604:	00002517          	auipc	a0,0x2
    80005608:	16450513          	addi	a0,a0,356 # 80007768 <etext+0x768>
    8000560c:	d05ff0ef          	jal	80005310 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005610:	4785                	li	a5,1
    80005612:	00005717          	auipc	a4,0x5
    80005616:	cef72d23          	sw	a5,-774(a4) # 8000a30c <panicked>
  for(;;)
    8000561a:	a001                	j	8000561a <panic+0x38>

000000008000561c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000561c:	1101                	addi	sp,sp,-32
    8000561e:	ec06                	sd	ra,24(sp)
    80005620:	e822                	sd	s0,16(sp)
    80005622:	e426                	sd	s1,8(sp)
    80005624:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005626:	0001e497          	auipc	s1,0x1e
    8000562a:	fd248493          	addi	s1,s1,-46 # 800235f8 <pr>
    8000562e:	00002597          	auipc	a1,0x2
    80005632:	14258593          	addi	a1,a1,322 # 80007770 <etext+0x770>
    80005636:	8526                	mv	a0,s1
    80005638:	258000ef          	jal	80005890 <initlock>
  pr.locking = 1;
    8000563c:	4785                	li	a5,1
    8000563e:	cc9c                	sw	a5,24(s1)
}
    80005640:	60e2                	ld	ra,24(sp)
    80005642:	6442                	ld	s0,16(sp)
    80005644:	64a2                	ld	s1,8(sp)
    80005646:	6105                	addi	sp,sp,32
    80005648:	8082                	ret

000000008000564a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000564a:	1141                	addi	sp,sp,-16
    8000564c:	e406                	sd	ra,8(sp)
    8000564e:	e022                	sd	s0,0(sp)
    80005650:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005652:	100007b7          	lui	a5,0x10000
    80005656:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000565a:	10000737          	lui	a4,0x10000
    8000565e:	f8000693          	li	a3,-128
    80005662:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005666:	468d                	li	a3,3
    80005668:	10000637          	lui	a2,0x10000
    8000566c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005670:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005674:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005678:	10000737          	lui	a4,0x10000
    8000567c:	461d                	li	a2,7
    8000567e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005682:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005686:	00002597          	auipc	a1,0x2
    8000568a:	0f258593          	addi	a1,a1,242 # 80007778 <etext+0x778>
    8000568e:	0001e517          	auipc	a0,0x1e
    80005692:	f8a50513          	addi	a0,a0,-118 # 80023618 <uart_tx_lock>
    80005696:	1fa000ef          	jal	80005890 <initlock>
}
    8000569a:	60a2                	ld	ra,8(sp)
    8000569c:	6402                	ld	s0,0(sp)
    8000569e:	0141                	addi	sp,sp,16
    800056a0:	8082                	ret

00000000800056a2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800056a2:	1101                	addi	sp,sp,-32
    800056a4:	ec06                	sd	ra,24(sp)
    800056a6:	e822                	sd	s0,16(sp)
    800056a8:	e426                	sd	s1,8(sp)
    800056aa:	1000                	addi	s0,sp,32
    800056ac:	84aa                	mv	s1,a0
  push_off();
    800056ae:	222000ef          	jal	800058d0 <push_off>

  if(panicked){
    800056b2:	00005797          	auipc	a5,0x5
    800056b6:	c5a7a783          	lw	a5,-934(a5) # 8000a30c <panicked>
    800056ba:	e795                	bnez	a5,800056e6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800056bc:	10000737          	lui	a4,0x10000
    800056c0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800056c2:	00074783          	lbu	a5,0(a4)
    800056c6:	0207f793          	andi	a5,a5,32
    800056ca:	dfe5                	beqz	a5,800056c2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800056cc:	0ff4f513          	zext.b	a0,s1
    800056d0:	100007b7          	lui	a5,0x10000
    800056d4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800056d8:	27c000ef          	jal	80005954 <pop_off>
}
    800056dc:	60e2                	ld	ra,24(sp)
    800056de:	6442                	ld	s0,16(sp)
    800056e0:	64a2                	ld	s1,8(sp)
    800056e2:	6105                	addi	sp,sp,32
    800056e4:	8082                	ret
    for(;;)
    800056e6:	a001                	j	800056e6 <uartputc_sync+0x44>

00000000800056e8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800056e8:	00005797          	auipc	a5,0x5
    800056ec:	c287b783          	ld	a5,-984(a5) # 8000a310 <uart_tx_r>
    800056f0:	00005717          	auipc	a4,0x5
    800056f4:	c2873703          	ld	a4,-984(a4) # 8000a318 <uart_tx_w>
    800056f8:	08f70263          	beq	a4,a5,8000577c <uartstart+0x94>
{
    800056fc:	7139                	addi	sp,sp,-64
    800056fe:	fc06                	sd	ra,56(sp)
    80005700:	f822                	sd	s0,48(sp)
    80005702:	f426                	sd	s1,40(sp)
    80005704:	f04a                	sd	s2,32(sp)
    80005706:	ec4e                	sd	s3,24(sp)
    80005708:	e852                	sd	s4,16(sp)
    8000570a:	e456                	sd	s5,8(sp)
    8000570c:	e05a                	sd	s6,0(sp)
    8000570e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005710:	10000937          	lui	s2,0x10000
    80005714:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005716:	0001ea97          	auipc	s5,0x1e
    8000571a:	f02a8a93          	addi	s5,s5,-254 # 80023618 <uart_tx_lock>
    uart_tx_r += 1;
    8000571e:	00005497          	auipc	s1,0x5
    80005722:	bf248493          	addi	s1,s1,-1038 # 8000a310 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005726:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000572a:	00005997          	auipc	s3,0x5
    8000572e:	bee98993          	addi	s3,s3,-1042 # 8000a318 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005732:	00094703          	lbu	a4,0(s2)
    80005736:	02077713          	andi	a4,a4,32
    8000573a:	c71d                	beqz	a4,80005768 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000573c:	01f7f713          	andi	a4,a5,31
    80005740:	9756                	add	a4,a4,s5
    80005742:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005746:	0785                	addi	a5,a5,1
    80005748:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000574a:	8526                	mv	a0,s1
    8000574c:	d5bfb0ef          	jal	800014a6 <wakeup>
    WriteReg(THR, c);
    80005750:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005754:	609c                	ld	a5,0(s1)
    80005756:	0009b703          	ld	a4,0(s3)
    8000575a:	fcf71ce3          	bne	a4,a5,80005732 <uartstart+0x4a>
      ReadReg(ISR);
    8000575e:	100007b7          	lui	a5,0x10000
    80005762:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005764:	0007c783          	lbu	a5,0(a5)
  }
}
    80005768:	70e2                	ld	ra,56(sp)
    8000576a:	7442                	ld	s0,48(sp)
    8000576c:	74a2                	ld	s1,40(sp)
    8000576e:	7902                	ld	s2,32(sp)
    80005770:	69e2                	ld	s3,24(sp)
    80005772:	6a42                	ld	s4,16(sp)
    80005774:	6aa2                	ld	s5,8(sp)
    80005776:	6b02                	ld	s6,0(sp)
    80005778:	6121                	addi	sp,sp,64
    8000577a:	8082                	ret
      ReadReg(ISR);
    8000577c:	100007b7          	lui	a5,0x10000
    80005780:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005782:	0007c783          	lbu	a5,0(a5)
      return;
    80005786:	8082                	ret

0000000080005788 <uartputc>:
{
    80005788:	7179                	addi	sp,sp,-48
    8000578a:	f406                	sd	ra,40(sp)
    8000578c:	f022                	sd	s0,32(sp)
    8000578e:	ec26                	sd	s1,24(sp)
    80005790:	e84a                	sd	s2,16(sp)
    80005792:	e44e                	sd	s3,8(sp)
    80005794:	e052                	sd	s4,0(sp)
    80005796:	1800                	addi	s0,sp,48
    80005798:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000579a:	0001e517          	auipc	a0,0x1e
    8000579e:	e7e50513          	addi	a0,a0,-386 # 80023618 <uart_tx_lock>
    800057a2:	16e000ef          	jal	80005910 <acquire>
  if(panicked){
    800057a6:	00005797          	auipc	a5,0x5
    800057aa:	b667a783          	lw	a5,-1178(a5) # 8000a30c <panicked>
    800057ae:	efbd                	bnez	a5,8000582c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057b0:	00005717          	auipc	a4,0x5
    800057b4:	b6873703          	ld	a4,-1176(a4) # 8000a318 <uart_tx_w>
    800057b8:	00005797          	auipc	a5,0x5
    800057bc:	b587b783          	ld	a5,-1192(a5) # 8000a310 <uart_tx_r>
    800057c0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800057c4:	0001e997          	auipc	s3,0x1e
    800057c8:	e5498993          	addi	s3,s3,-428 # 80023618 <uart_tx_lock>
    800057cc:	00005497          	auipc	s1,0x5
    800057d0:	b4448493          	addi	s1,s1,-1212 # 8000a310 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057d4:	00005917          	auipc	s2,0x5
    800057d8:	b4490913          	addi	s2,s2,-1212 # 8000a318 <uart_tx_w>
    800057dc:	00e79d63          	bne	a5,a4,800057f6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800057e0:	85ce                	mv	a1,s3
    800057e2:	8526                	mv	a0,s1
    800057e4:	c77fb0ef          	jal	8000145a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057e8:	00093703          	ld	a4,0(s2)
    800057ec:	609c                	ld	a5,0(s1)
    800057ee:	02078793          	addi	a5,a5,32
    800057f2:	fee787e3          	beq	a5,a4,800057e0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800057f6:	0001e497          	auipc	s1,0x1e
    800057fa:	e2248493          	addi	s1,s1,-478 # 80023618 <uart_tx_lock>
    800057fe:	01f77793          	andi	a5,a4,31
    80005802:	97a6                	add	a5,a5,s1
    80005804:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005808:	0705                	addi	a4,a4,1
    8000580a:	00005797          	auipc	a5,0x5
    8000580e:	b0e7b723          	sd	a4,-1266(a5) # 8000a318 <uart_tx_w>
  uartstart();
    80005812:	ed7ff0ef          	jal	800056e8 <uartstart>
  release(&uart_tx_lock);
    80005816:	8526                	mv	a0,s1
    80005818:	190000ef          	jal	800059a8 <release>
}
    8000581c:	70a2                	ld	ra,40(sp)
    8000581e:	7402                	ld	s0,32(sp)
    80005820:	64e2                	ld	s1,24(sp)
    80005822:	6942                	ld	s2,16(sp)
    80005824:	69a2                	ld	s3,8(sp)
    80005826:	6a02                	ld	s4,0(sp)
    80005828:	6145                	addi	sp,sp,48
    8000582a:	8082                	ret
    for(;;)
    8000582c:	a001                	j	8000582c <uartputc+0xa4>

000000008000582e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000582e:	1141                	addi	sp,sp,-16
    80005830:	e422                	sd	s0,8(sp)
    80005832:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005834:	100007b7          	lui	a5,0x10000
    80005838:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000583a:	0007c783          	lbu	a5,0(a5)
    8000583e:	8b85                	andi	a5,a5,1
    80005840:	cb81                	beqz	a5,80005850 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005842:	100007b7          	lui	a5,0x10000
    80005846:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000584a:	6422                	ld	s0,8(sp)
    8000584c:	0141                	addi	sp,sp,16
    8000584e:	8082                	ret
    return -1;
    80005850:	557d                	li	a0,-1
    80005852:	bfe5                	j	8000584a <uartgetc+0x1c>

0000000080005854 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005854:	1101                	addi	sp,sp,-32
    80005856:	ec06                	sd	ra,24(sp)
    80005858:	e822                	sd	s0,16(sp)
    8000585a:	e426                	sd	s1,8(sp)
    8000585c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000585e:	54fd                	li	s1,-1
    80005860:	a019                	j	80005866 <uartintr+0x12>
      break;
    consoleintr(c);
    80005862:	85fff0ef          	jal	800050c0 <consoleintr>
    int c = uartgetc();
    80005866:	fc9ff0ef          	jal	8000582e <uartgetc>
    if(c == -1)
    8000586a:	fe951ce3          	bne	a0,s1,80005862 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000586e:	0001e497          	auipc	s1,0x1e
    80005872:	daa48493          	addi	s1,s1,-598 # 80023618 <uart_tx_lock>
    80005876:	8526                	mv	a0,s1
    80005878:	098000ef          	jal	80005910 <acquire>
  uartstart();
    8000587c:	e6dff0ef          	jal	800056e8 <uartstart>
  release(&uart_tx_lock);
    80005880:	8526                	mv	a0,s1
    80005882:	126000ef          	jal	800059a8 <release>
}
    80005886:	60e2                	ld	ra,24(sp)
    80005888:	6442                	ld	s0,16(sp)
    8000588a:	64a2                	ld	s1,8(sp)
    8000588c:	6105                	addi	sp,sp,32
    8000588e:	8082                	ret

0000000080005890 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005890:	1141                	addi	sp,sp,-16
    80005892:	e422                	sd	s0,8(sp)
    80005894:	0800                	addi	s0,sp,16
  lk->name = name;
    80005896:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005898:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000589c:	00053823          	sd	zero,16(a0)
}
    800058a0:	6422                	ld	s0,8(sp)
    800058a2:	0141                	addi	sp,sp,16
    800058a4:	8082                	ret

00000000800058a6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800058a6:	411c                	lw	a5,0(a0)
    800058a8:	e399                	bnez	a5,800058ae <holding+0x8>
    800058aa:	4501                	li	a0,0
  return r;
}
    800058ac:	8082                	ret
{
    800058ae:	1101                	addi	sp,sp,-32
    800058b0:	ec06                	sd	ra,24(sp)
    800058b2:	e822                	sd	s0,16(sp)
    800058b4:	e426                	sd	s1,8(sp)
    800058b6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800058b8:	6904                	ld	s1,16(a0)
    800058ba:	db6fb0ef          	jal	80000e70 <mycpu>
    800058be:	40a48533          	sub	a0,s1,a0
    800058c2:	00153513          	seqz	a0,a0
}
    800058c6:	60e2                	ld	ra,24(sp)
    800058c8:	6442                	ld	s0,16(sp)
    800058ca:	64a2                	ld	s1,8(sp)
    800058cc:	6105                	addi	sp,sp,32
    800058ce:	8082                	ret

00000000800058d0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800058d0:	1101                	addi	sp,sp,-32
    800058d2:	ec06                	sd	ra,24(sp)
    800058d4:	e822                	sd	s0,16(sp)
    800058d6:	e426                	sd	s1,8(sp)
    800058d8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058da:	100024f3          	csrr	s1,sstatus
    800058de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800058e2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800058e4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800058e8:	d88fb0ef          	jal	80000e70 <mycpu>
    800058ec:	5d3c                	lw	a5,120(a0)
    800058ee:	cb99                	beqz	a5,80005904 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800058f0:	d80fb0ef          	jal	80000e70 <mycpu>
    800058f4:	5d3c                	lw	a5,120(a0)
    800058f6:	2785                	addiw	a5,a5,1
    800058f8:	dd3c                	sw	a5,120(a0)
}
    800058fa:	60e2                	ld	ra,24(sp)
    800058fc:	6442                	ld	s0,16(sp)
    800058fe:	64a2                	ld	s1,8(sp)
    80005900:	6105                	addi	sp,sp,32
    80005902:	8082                	ret
    mycpu()->intena = old;
    80005904:	d6cfb0ef          	jal	80000e70 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005908:	8085                	srli	s1,s1,0x1
    8000590a:	8885                	andi	s1,s1,1
    8000590c:	dd64                	sw	s1,124(a0)
    8000590e:	b7cd                	j	800058f0 <push_off+0x20>

0000000080005910 <acquire>:
{
    80005910:	1101                	addi	sp,sp,-32
    80005912:	ec06                	sd	ra,24(sp)
    80005914:	e822                	sd	s0,16(sp)
    80005916:	e426                	sd	s1,8(sp)
    80005918:	1000                	addi	s0,sp,32
    8000591a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000591c:	fb5ff0ef          	jal	800058d0 <push_off>
  if(holding(lk))
    80005920:	8526                	mv	a0,s1
    80005922:	f85ff0ef          	jal	800058a6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005926:	4705                	li	a4,1
  if(holding(lk))
    80005928:	e105                	bnez	a0,80005948 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000592a:	87ba                	mv	a5,a4
    8000592c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005930:	2781                	sext.w	a5,a5
    80005932:	ffe5                	bnez	a5,8000592a <acquire+0x1a>
  __sync_synchronize();
    80005934:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005938:	d38fb0ef          	jal	80000e70 <mycpu>
    8000593c:	e888                	sd	a0,16(s1)
}
    8000593e:	60e2                	ld	ra,24(sp)
    80005940:	6442                	ld	s0,16(sp)
    80005942:	64a2                	ld	s1,8(sp)
    80005944:	6105                	addi	sp,sp,32
    80005946:	8082                	ret
    panic("acquire");
    80005948:	00002517          	auipc	a0,0x2
    8000594c:	e3850513          	addi	a0,a0,-456 # 80007780 <etext+0x780>
    80005950:	c93ff0ef          	jal	800055e2 <panic>

0000000080005954 <pop_off>:

void
pop_off(void)
{
    80005954:	1141                	addi	sp,sp,-16
    80005956:	e406                	sd	ra,8(sp)
    80005958:	e022                	sd	s0,0(sp)
    8000595a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000595c:	d14fb0ef          	jal	80000e70 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005960:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005964:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005966:	e78d                	bnez	a5,80005990 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005968:	5d3c                	lw	a5,120(a0)
    8000596a:	02f05963          	blez	a5,8000599c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000596e:	37fd                	addiw	a5,a5,-1
    80005970:	0007871b          	sext.w	a4,a5
    80005974:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005976:	eb09                	bnez	a4,80005988 <pop_off+0x34>
    80005978:	5d7c                	lw	a5,124(a0)
    8000597a:	c799                	beqz	a5,80005988 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000597c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005980:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005984:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005988:	60a2                	ld	ra,8(sp)
    8000598a:	6402                	ld	s0,0(sp)
    8000598c:	0141                	addi	sp,sp,16
    8000598e:	8082                	ret
    panic("pop_off - interruptible");
    80005990:	00002517          	auipc	a0,0x2
    80005994:	df850513          	addi	a0,a0,-520 # 80007788 <etext+0x788>
    80005998:	c4bff0ef          	jal	800055e2 <panic>
    panic("pop_off");
    8000599c:	00002517          	auipc	a0,0x2
    800059a0:	e0450513          	addi	a0,a0,-508 # 800077a0 <etext+0x7a0>
    800059a4:	c3fff0ef          	jal	800055e2 <panic>

00000000800059a8 <release>:
{
    800059a8:	1101                	addi	sp,sp,-32
    800059aa:	ec06                	sd	ra,24(sp)
    800059ac:	e822                	sd	s0,16(sp)
    800059ae:	e426                	sd	s1,8(sp)
    800059b0:	1000                	addi	s0,sp,32
    800059b2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800059b4:	ef3ff0ef          	jal	800058a6 <holding>
    800059b8:	c105                	beqz	a0,800059d8 <release+0x30>
  lk->cpu = 0;
    800059ba:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800059be:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800059c2:	0310000f          	fence	rw,w
    800059c6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800059ca:	f8bff0ef          	jal	80005954 <pop_off>
}
    800059ce:	60e2                	ld	ra,24(sp)
    800059d0:	6442                	ld	s0,16(sp)
    800059d2:	64a2                	ld	s1,8(sp)
    800059d4:	6105                	addi	sp,sp,32
    800059d6:	8082                	ret
    panic("release");
    800059d8:	00002517          	auipc	a0,0x2
    800059dc:	dd050513          	addi	a0,a0,-560 # 800077a8 <etext+0x7a8>
    800059e0:	c03ff0ef          	jal	800055e2 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
