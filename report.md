
# 计算机系统软件方案一实验报告
## 实验目的
实现以下功能：

- 嵌入shell的lisp解释器
- 多级反馈进程调度算法
- 共享内存
- 状态栏

## 实验环境
- operating system: Fedora release 28 (Twenty Eight)
- compiler:  gcc (GCC) 8.1.1 20180502 (Red Hat 8.1.1-1)
- debug: GNU gdb (GDB) Fedora 8.1-18.fc28
- editor: GNU Emacs 26.1
- vm: qemu

## 实验内容

### 嵌入shell的lisp解释器

在`scsh.c`中实现lisp语法解释器，涉及到`pipe.c`,`sysfile.c`,`file.h`等具体实现：
- memo文件类型，实现将输出重定向到内存中
- defun : 定义函数
- pipe: 实现pipe函数
- if: 条件控制
- equal: 字符串比较
- minus: 减法
- con: 并行运行指令
- pend: 串行运行指令
- repeat: 重复串行运行指令n次
- clk: 输出指令运行的时间片个数

### 多级反馈进程调度算法
在`proc.c`中实现lisp语法解释器，具体实现：
- 进程优先级与多级队列
- 时间片个数调整
### 共享内存
在`vm.c`，`proc.c`，`sysproc.c`等文件中实现共享内存，具体实现：
- 根据key得到共享内存虚拟地址
- 更据key释放共享内存
- 对共享内存物理地址进行管理
### 状态栏
在`console.c`等文件中实现状态栏，具体实现：
//to do

## 技术实现详情
### 嵌入shell的lisp解释器
数据结构与函数：
```c++
struct sexp //s表达式
struct atom //原子表达式
struct list //列表表达式
struct func //函数体，用于储存定义的函数
struct shared //函数储存在全局共享内存中
void runexp(struct sexp *exp)//运行表达式
struct sexp *parsesexp(char **, char *)//解析表达式
void defunc(struct list *lst) //定义函数
void storeexp(struct sexp **st, struct sexp *exp)//储存函数体到某一片内存中
```
### 多级反馈进程调度算法
数据结构:
```c++
struct pqueue //优先队列
void qpush(struct proc* np)//进程入队列
void scheduler(void)//多级反馈进程调度
```
### 共享内存
proc.c
- getshared函数：根据key得到虚拟共享内存地址
- releaseshared函数：释放虚拟共享内存

sysproc.c
- getsharem系统调用
- releasesharem系统调用

vm.c
- sharedmemo结构体：存储全局共享内存物理地址
- sharevm函数：申请物理内存
- desharevm函数：释放物理内存
##  状态栏
console.c
- title函数：显示状态栏
## 其他改动
### 系统调用
```c++
extern int sys_trace(void);
extern int sys_getsharem(void);//获取共享内存
extern int sys_releasesharem(void);//释放共享内存
extern int sys_split(void);//todo
extern int sys_memo(void);//lisp 表达式运行缓存
extern int sys_getmemo(void);//获取lisp 表达式运行缓存
extern int sys_setmemo(void);//刷新共享内存
extern int sys_att(void);//返回系统时间
```
### shell命令
- pecho: 无换行符的echo
- scsh: lisp shell
### 数据结构
```c++
struct cpu{
  int rtime;//时钟记录
  char consflag;//控制台输出锁
}
struct proc {
  struct proc* next;//位于优先队列的下一个进程
  uint priority;//优先级
  uint timepiece;//时间片个数
  char sharedrec[MAXSHAREDPG];//共享内存记录
  int widx;//todo
}
```

## 技术难点
### 嵌入shell的lisp解释器
- S表达式的求解需要将程序的输出缓存到内存中，据此需要一个类似pipe的机制，将程序的输出重定向到内存中，再从内存中读入。 
因此需要实现新的文件类型：memo，以及与之相关的读写操作。
- 函数定义需要储存AST（语法分析树）到一片连续的共享内存中，需要实现函数的存储，索引和调用。
## 用户手册
### 嵌入shell的lisp解释器
开机在sh下输入scsh命令进入lisp解释器
lisp表达式如下：
```scheme
;; 应用函数
(fun param1 param2 param3)
;; 比如(ls)为执行ls，(ls .)为执行参数为.的ls
;; 列表
'(a b c)
;; 目前用作函数定义的参数列表
;; defun
(defun funcname '(param1 param2) (exp param1 param2))
;; 比如(defun f '(x y) (echo x running y result (x y)))
;; (f echo a) 输出为 echo running a result a
比如：
```scheme
(defun f0 '(x) (pipe (grep x) (echo 123)))
;; (f0 12) 输出123, 即将echo 123的内容pipe到grep 12中
((pecho ls) (pecho .))
;; 等价于(ls .), pecho为无换行符的echo
(defun q '(x y n) (if (equal n 0) (clk (con x y)) (clk (pend x y))))
;; (q (ls) (repeat 10 (ls)) 0) 即输出将ls和repeat 10 (ls)并行执行的时间
;; (q (ls) (repeat 10 (ls)) 1) 即输出将ls和repeat 10 (ls)串行执行的时间，
```
### 共享内存
系统调用：
- getsharem系统调用：根据key得到共享内存地址
- releasesharem系统调用：根据key释放共享内存
### 状态栏
进入系统可见

## 成员分工
- 苏乐： 嵌入shell的lisp解释器, 多级反馈进程调度算法, 共享内存, 状态栏, 文档，ppt
- 胡凌峰： 多级反馈进程调度算法, 共享内存,  文档，ppt
- 李天阳： 多级反馈进程调度算法, 共享内存,  文档，ppt
- 房泽华： 多级反馈进程调度算法, 共享内存, 文档，ppt