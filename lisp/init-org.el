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

  ;; (setq org-todo-keywords `((sequence "TODO" "CHECK")))
  
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

  ;; roam
  (setq org-roam-v2-ack t) ;; disable v2 warnings
  (defconst my-roam-dir "~/Documents/roam/")
  (if (not (file-directory-p my-roam-dir))
	  (make-directory my-roam-dir))
  (setq org-roam-directory (file-truename my-roam-dir))
  (setq org-roam-db-location (file-truename (concat my-roam-dir "org-roam.db")))
  (setq org-roam-database-connector 'sqlite3)
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8000
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20)
  (org-roam-db-autosync-mode)
  ;; (org-roam-server-mode)
  )
