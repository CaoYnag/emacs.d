(require 'pyim) ;; manual require here

(with-eval-after-load 'pyim
  ;; 金手指设置，可以将光标处的编码，比如：拼音字符串，转换为中文。
  (global-set-key (kbd "M-j") 'pyim-convert-string-at-point)
  ;;  (global-set-key (kbd "M-j") '(lambda () (message "hello")))
  ;; 按 "C-<return>" 将光标前的 regexp 转换为可以搜索中文的 regexp.
  (define-key minibuffer-local-map (kbd "C-<return>") 'pyim-cregexp-convert-at-point)
  
  ;; 我使用全拼
  (setq pyim-default-scheme 'quanpin)
  ;; (setq pyim-default-scheme 'wubi)
  ;; (setq pyim-default-scheme 'cangjie)
  
  ;; pyim 探针设置
  ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
  ;; 我自己使用的中英文动态切换规则是：
  ;; 1. 光标只有在注释里面时，才可以输入中文。
  ;; 2. 光标前是汉字字符时，才能输入中文。
  ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
  (setq-default pyim-english-input-switch-functions
		'(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))
  
  (setq-default pyim-punctuation-half-width-functions
		'(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))
  
  ;; 开启代码搜索中文功能（比如拼音，五笔码等）
  (pyim-isearch-mode 1)
  
  ;; 设置选词框的绘制方式
  (if (and (functionp 'posframe-workable-p)
	   (posframe-workable-p))
      (setq pyim-page-tooltip 'posframe)
    (setq pyim-page-tooltip 'popup))
  
  ;; 显示5个候选词。
  (setq pyim-page-length 5)
  
  ;; Basedict
  (require 'pyim-basedict)
  (pyim-basedict-enable)
  
  (setq default-input-method "pyim")
  (global-set-key (kbd "C-\\") 'toggle-input-method)
  (setq pyim-enable-shortcode nil)
  )

(provide 'init-pyim)
