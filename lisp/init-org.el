(with-eval-after-load 'org
  ;; use tab to intent code in src block
  ;; (setq org-src-tab-acts-natively t) ; not use this. use C-c ' to edit src.

  ;; do not indent when enter new line
  (setq org-adapt-indentation nil)

  ;; set org-timer clock sound
  ;; then use org-timer-set-timer org-timer-pause-or-continue org-timer-stop to ctrl a timer.
  (setq org-clock-sound "~/Music/sounds/DingLing.mp3")

  ;; encrypted file
  (require 'epa-file)
  (epa-file-enable)
  (setq epa-file-encrypt-to '("CaoYangCS@outlook.com"))
  ;; (epa-file-select-keys 'silent)

  ;; org crypt
  ;; (require 'org-crypt)
  ;; (org-crypt-use-before-save-magic)
  ;; (setq org-tags-exclude-from-inheritance (quote ("crypt")))
  ;; TODO conf my email addr in global.
  ;; (org-crypt-key "CaoYangCS@outlook.com")
  
  ;; 自动换行
  (add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
  ;; valign to support table align
  (add-hook 'org-mode-hook #'valign-mode)
  )
