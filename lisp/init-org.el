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
  (setq org-hide-leading-stars t)
  (setq org-ellipsis " ▾ ")

  ;; emphasis settings
  (setq org-hide-emphasis-markers t)
  (defface org-bold
	'((t :foreground "#d2268b"
		 ; :background "#fefefe" ; not match my theme
		 :weight bold
		 :underline t
		 :overline t))
	"Face for org-mode bold."
	:group 'org-faces )
  (setq org-emphasis-alist
		'(("*" org-bold)
          ("/" italic)
          ("_" underline)
          ("=" ;; (:background "maroon" :foreground "white")
           org-verbatim verbatim)
          ("~" ;; (:background "deep sky blue" :foreground "MidnightBlue")
           org-code verbatim)
          ("+" (:strike-through t))))

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
  (add-hook 'org-mode-hook  (lambda ()
                              (setq prettify-symbols-alist
									'(("lambda" . ?λ)
                                      ("#+begin_quote" . ?)
                                      ("#+end_quote" . ?)
                                      ("#+RESULTS:" . ?)
                                      ("[ ]" . ?)
                                      ("[-]" . ?)
                                      ("[X]" . ?)))
                              (prettify-symbols-mode)))


  ;; roam
  ;; (setq org-roam-v2-ack t) ;; disable v2 warnings
  (defconst my-roam-dir "~/Documents/roam/")
  (if (not (file-directory-p my-roam-dir))
	  (make-directory my-roam-dir))
  (setq org-roam-directory (file-truename my-roam-dir))
  (setq org-roam-db-location (file-truename (concat my-roam-dir "org-roam.db")))
  (setq org-roam-database-connector 'sqlite3)
  (org-roam-db-autosync-mode)
  (setq org-roam-capture-templates
		'(("z" "zettel" plain
           "%?"
           :if-new (file+head "main/${slug}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("s" "snippet" plain "%?"
           :if-new
           (file+head "snippets/${slug}.org" "#+title: ${title}\n#+filetags: :snippet:\n")
           :immediate-finish t
           :unnarrowed t)
		  ("t" "thought" plain "%?"
           :if-new
           (file+head "thoughts/${slug}.org" "#+title: ${title}\n#+filetags: :thought:\n")
           :immediate-finish t
           :unnarrowed t)))
  (cl-defmethod org-roam-node-type ((node org-roam-node))
	"Return the TYPE of NODE."
	(condition-case nil
		(file-name-nondirectory
		 (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))
  ;; custom selection template
  (setq org-roam-node-display-template
		(concat "${type:10} ${title:*} " (propertize "${tags:15}" 'face 'org-tag)))
  
  ;; org-roam-buffer
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


  ;; org roam ui
  (setq org-roam-ui-open-on-start nil)
  ;; (org-roam-ui-mode)
  )
