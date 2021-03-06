;04.09.01.scrbl
;4.9.1 使用赋值的指导原则
#lang scribble/doc
@(require scribble/manual
          scribble/eval
          "guide-utils.rkt")

@title[#:tag "using-set!"]{使用赋值的指导原则}

虽然使用@racket[set!]有时是适当的，Racket风格通常建议不使用@racket[set!]。下面的准则有助于解释什么时候使用@racket[set!]是适当的。

@itemize[

 @item{与任何现代语言一样，分配给共享标识符不是将参数传递给过程或获得结果的替代。

  @as-examples[@t{@bold{@italic{事实上很糟糕}}的示例：}
               @defs+int[
 [(define name "unknown")
  (define result "unknown")
  (define (greet)
    (set! result (string-append "Hello, " name)))]
 (set! name "John")
 (greet)
 result
 ]]

  @as-examples[@t{合适的示例：}
               @def+int[
 (define (greet name)
   (string-append "Hello, " name))
 (greet "John")
 (greet "Anna")
 ]]}

 @item{对局部变量的赋值序列远比嵌套绑定差。

  @as-examples[@t{@bold{差}的示例：}
               @interaction[
 (let ([tree 0])
   (set! tree (list tree 1 tree))
   (set! tree (list tree 2 tree))
   (set! tree (list tree 3 tree))
   tree)]]

  @as-examples[@t{好的示例：}
               @interaction[
 (let* ([tree 0]
        [tree (list tree 1 tree)]
        [tree (list tree 2 tree)]
        [tree (list tree 3 tree)])
   tree)]]}
 
 @item{使用赋值来从迭代中积累结果是不好的风格。通过循环参数积累更好。

  @as-examples[@t{略差的示例：}
               @def+int[
 (define (sum lst)
   (let ([s 0])
     (for-each (lambda (i) (set! s (+ i s)))
               lst)
     s))
 (sum '(1 2 3))
 ]]

  @as-examples[@t{好的示例：}
               @def+int[
 (define (sum lst)
   (let loop ([lst lst] [s 0])
     (if (null? lst)
         s
         (loop (cdr lst) (+ s (car lst))))))
 (sum '(1 2 3))
 ]]

  @as-examples[@t{更好（使用现有函数）示例：}
               @def+int[
 (define (sum lst)
   (apply + lst))
 (sum '(1 2 3))
 ]]

  @as-examples[@t{好的（一般的途径）示例：}
               @def+int[
 (define (sum lst)
   (for/fold ([s 0])
             ([i (in-list lst)])
     (+ s i)))
 (sum '(1 2 3))
 ]]}

 @item{对于有状态的对象的情况是必要的或合适的，那么用@racket[set!]实现对象的状态是比较好的。

  @as-examples[@t{合适的实例：}
               @def+int[
 (define next-number!
   (let ([n 0])
     (lambda ()
       (set! n (add1 n))
       n)))
 (next-number!)
 (next-number!)
 (next-number!)]]}
 ]

所有其它的情况都相同，则不使用赋值或变化的程序总是优于使用赋值或变化的程序。虽然应该避免副作用，但如果结果代码可读性更高，或者实现了更好的算法，则应该使用这些副作用。

使用可变值，如向量和哈希表，对程序风格的疑虑会比直接使用@racket[set!]要少。不过，在程序里简单地用@racket[vector-set!]替换@racket[set!]显然没有改善程序的风格。