(with-eval-after-load 'org
  ;; use tab to intent code in src block
  ;; (setq org-src-tab-acts-natively t) ; not use this. use C-c ' to edit src.

  ;; do not indent when enter new line
  (setq org-adapt-indentation nil)

  ;; 自动换行
  (add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
  )
