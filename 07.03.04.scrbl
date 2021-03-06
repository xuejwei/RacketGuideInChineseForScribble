;07.03.04.scrbl
;7.3.4 可选关键字参数
#lang scribble/doc
@(require scribble/manual
          scribble/eval
          "utils.rkt"
          (for-label framework/framework
                     racket/contract
                     racket/gui))

@title[#:tag "optional-keywords-argument"]{可选关键字参数}

当然，@racket[ask-yes-or-no-question]（从上一个问题中引来）中有许多参数有合理的默认值，应该是可选的：

@racketblock[
(define (ask-yes-or-no-question question 
                                #:default answer
                                #:title [title "Yes or No?"]
                                #:width [w 400]
                                #:height [h 200])
  ...)
]

要指定这个函数的合约，我们需要再次使用@racket[->*]。它支持关键字，正如你在可选参数和强制参数部分中所期望的一样。在这种情况下，我们有强制关键字@racket[#:default]和可选关键字@racket[#:title]、@racket[#:width]和@racket[#:height]。所以，我们像这样写合约：

@racketblock[
(provide (contract-out
          [ask-yes-or-no-question
           (->* (string?
                 #:default boolean?)
                (#:title string?
                 #:width exact-integer?
                 #:height exact-integer?)

                boolean?)]))
]

也就是说，我们在第一节中使用了强制关键字，并在第二部分中选择了可选关键字。