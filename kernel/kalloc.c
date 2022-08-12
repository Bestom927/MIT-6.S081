#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run
{
    struct run *next;
};

struct
{
    struct spinlock lock;
    struct run *freelist;
} kmem;

#define RC_SIZE PHYSTOP / PGSIZE + 1
struct
{
    struct spinlock lock; // 物理页引用计数相关锁
    int cnt[RC_SIZE];     // 记录物理页的引用计数
} rc;

void kinit()
{
    initlock(&kmem.lock, "kmem");
    initlock(&rc.lock, "rc"); // 初始化引用计数锁
    freerange(end, (void *)PHYSTOP);
}

void freerange(void *pa_start, void *pa_end)
{
    char *p;
    p = (char *)PGROUNDUP((uint64)pa_start);
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    {
        set_ref_cnt((uint64)p, 1); // 设置物理页的引用计数为1，配合之后的kree函数
        kfree(p);
    }
}


void kfree(void *pa)
{
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
        panic("kfree");
    int cnt = dec_ref_cnt((uint64)pa); // 减小物理页引用计数
    if (cnt > 0)                       // 仍有进程引用该页，直接返回
    {
        return;
    }
    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);

    r = (struct run *)pa;

    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);
}

void *kalloc(void)
{
    struct run *r;

    acquire(&kmem.lock);
    r = kmem.freelist;
    if (r)
        kmem.freelist = r->next;
    release(&kmem.lock);

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk

    if (r)
        set_ref_cnt((uint64)r, 1); // 将引用计数设置为1
    return (void *)r;
}

void acquire_rc_lock() // 请求物理页引用计数锁
{
    acquire(&rc.lock);
}

void release_rc_lock() // 释放物理页引用计数锁
{
    release(&rc.lock);
}

void set_ref_cnt(uint64 pa, int cnt) // 设置物理页引用计数
{
    uint64 pfn = pa / PGSIZE;
    rc.cnt[pfn] = cnt;
}

int get_ref_cnt(uint64 pa) // 获取物理页引用计数
{
    uint64 pfn = pa / PGSIZE;
    return rc.cnt[pfn];
}

int inc_ref_cnt(uint64 pa) // 增加物理页引用计数
{
    uint64 pfn = pa / PGSIZE;
    rc.cnt[pfn]++;
    return rc.cnt[pfn];
}

int dec_ref_cnt(uint64 pa) // 减小物理页引用计数
{
    uint64 pfn = pa / PGSIZE;
    rc.cnt[pfn]--;
    return rc.cnt[pfn];
}
