(with-eval-after-load 'org
  ;; use tab to intent code in src block
  ;; (setq org-src-tab-acts-natively t) ; not use this. use C-c ' to edit src.

  ;; do not indent when enter new line
  (setq org-adapt-indentation nil)

  ;; set org-timer clock sound
  ;; then use org-timer-set-timer org-timer-pause-or-continue org-timer-stop to ctrl a timer.
  (setq org-clock-sound "~/Music/sounds/DingLing.mp3")
  ;; always show images when opening files.
  (setq org-startup-with-inline-images t)

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
  ;; (setq org-roam-v2-ack t) ;; disable v2 warnings
  (defconst my-roam-dir "~/Documents/roam/")
  (if (not (file-directory-p my-roam-dir))
	  (make-directory my-roam-dir))
  (setq org-roam-directory (file-truename my-roam-dir))
  (setq org-roam-db-location (file-truename (concat my-roam-dir "org-roam.db")))
  (setq org-roam-database-connector 'sqlite3)
  (setq org-roam-mode-sections
		'((org-roam-backlinks-section :unique t)
          org-roam-reflinks-section
		  org-roam-unlinked-references-section))
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
				 (display-buffer-in-side-window)
				 (side . right)
				 (slot . 0)
				 (window-width . 0.33)
				 (window-parameters . ((no-other-window . t)
                                       (no-delete-other-windows . t)))))
  (setq org-roam-graph-viewer "feh")
  (org-roam-db-autosync-mode)

  ;; org roam ui
  (setq org-roam-ui-open-on-start nil)
  ;; (org-roam-ui-mode)
  )
