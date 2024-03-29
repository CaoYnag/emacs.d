;; -*- coding: utf-8; lexical-binding: t; -*-

(add-hook 'after-init-hook 'global-company-mode)

(defvar my-company-zero-key-for-filter nil
  "If t, pressing 0 calls `company-filter-candidates' per company's status.")

(with-eval-after-load 'company
  (defun my-company-number ()
    "Forward to `company-complete-number'.
Unless the number is potentially part of the candidate.
In that case, insert the number."
    (interactive)
    (let* ((k (this-command-keys))
           (re (concat "^" company-prefix k))
           (n (if (equal k "0") 10 (string-to-number k))))
      (cond
       ((or (cl-find-if (lambda (s) (string-match re s)) company-candidates)
            (> n (length company-candidates))
            (looking-back "[0-9]+\\.[0-9]*" (line-beginning-position)))
        (self-insert-command 1))

       ((and (eq n 10) my-company-zero-key-for-filter)
        (company-filter-candidates))

       (t
        (company-complete-number n)))))

  ;; (require 'company)
  ;; (require 'irony)
  ;; (require 'company-irony)

  ;; @see https://github.com/company-mode/company-mode/issues/348
  (require 'company-statistics)
  (company-statistics-mode)
  (add-to-list 'company-backends 'company-cmake)
  ;;(require 'company-c-headers)
  (add-to-list 'company-backends 'company-c-headers)
  (add-to-list 'company-backends 'company-dabbrev)
  (add-to-list 'company-backends 'company-dabbrev-code)
  (add-to-list 'company-backends 'company-files)
  (add-to-list 'company-backends 'company-semantic)
  (add-to-list 'company-backends 'company-keywords)
  (add-to-list 'company-backends 'company-irony)
  ;;(add-to-list 'company-backends 'company-gtags)
  (add-to-list 'company-backends 'company-capf)
  (add-to-list 'company-backends #'company-tabnine)

  ;; irony
  (add-hook 'c++-mode-hook 'company-mode)
  (add-hook 'c-mode-hook 'company-mode)
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

  ;; can't work with TRAMP
  (setq company-backends (delete 'company-ropemacs company-backends))
  ;; company color settings
  ;; (defun theme-dark ()
  ;;  (interactive)
  ;;   (set-face-foreground 'company-tooltip "#000")
  ;;    (set-face-background 'company-tooltip "#fff")
  ;;     (set-face-foreground 'company-scrollbar-bg "#fff")
  ;;      (set-face-background 'company-scrollbar-fg "#999")
  ;; )
  ;; (theme-dark)
  
  ;; add global key to manual call completetion.
  ;; use M-n, M-p, M-[no] to select candidate
  (global-set-key (kbd "C-;") 'company-complete-common)

  ;; @see https://oremacs.com/2017/12/27/company-numbers/
  ;; Using digits to select company-mode candidates
  (let ((map company-active-map))
    (mapc
     (lambda (x)
       (define-key map (format "%d" x) 'my-company-number))
     (number-sequence 0 9)))

  (setq company-auto-commit t)
  ;; characters "/ ) . , ;"to trigger auto commit
  (setq company-auto-commit-chars '(92  41 46 44 59))

  ;; company-ctags is much faster out of box. No further optimiation needed
  ;; (unless (featurep 'company-ctags) (local-require 'company-ctags))
  ;; (company-ctags-auto-setup)

  ;; (setq company-backends (delete 'company-capf company-backends))

  ;; I don't like the downcase word in company-dabbrev
  (setq company-dabbrev-downcase nil
        ;; make previous/next selection in the popup cycles
        company-selection-wrap-around t
        ;; Some languages use camel case naming convention,
        ;; so company should be case sensitive.
        company-dabbrev-ignore-case nil
        ;; press M-number to choose candidate
        company-show-numbers t
        company-idle-delay 0.2
        company-clang-insert-arguments nil
        company-require-match nil
	;; company-minimum-prefix-length 2
	;; company-dabbrev-downcase nil
        company-ctags-ignore-case t ; I use company-ctags instead
        ;; @see https://github.com/company-mode/company-mode/issues/146
        company-tooltip-align-annotations t)

  ;; Press SPACE will accept the highlighted candidate and insert a space
  ;; "M-x describe-variable company-auto-complete-chars" for details.
  ;; So that's BAD idea.
  (setq company-auto-complete nil)

  ;; NOT to load company-mode for certain major modes.
  ;; Ironic that I suggested this feature but I totally forgot it
  ;; until two years later.
  ;; https://github.com/company-mode/company-mode/issues/29
  (setq company-global-modes
        '(not
          eshell-mode
          comint-mode
          erc-mode
          gud-mode
          rcirc-mode
          minibuffer-inactive-mode)))

(with-eval-after-load 'company-ispell
  (defun my-company-ispell-available-hack (orig-func &rest args)
    ;; in case evil is disabled
    (my-ensure 'evil-nerd-commenter)
    (cond
     ((and (derived-mode-p 'prog-mode)
           (or (not (company-in-string-or-comment)) ; respect advice in `company-in-string-or-comment'
               ;; I renamed the api in new version of evil-nerd-commenter
               (not (if (fboundp 'evilnc-pure-comment-p) (evilnc-pure-comment-p (point))
                      (evilnc-is-pure-comment (point)))))) ; auto-complete in comment only
      ;; only use company-ispell in comment when coding
      nil)
     (t
      (apply orig-func args))))
  (advice-add 'company-ispell-available :around #'my-company-ispell-available-hack))

(defun my-add-ispell-to-company-backends ()
  "Add ispell to the last of `company-backends'."
  (setq company-backends
        (add-to-list 'company-backends 'company-ispell)))

;; {{ setup company-ispell
(defun toggle-company-ispell ()
  "Toggle company-ispell."
  (interactive)
  (cond
   ((memq 'company-ispell company-backends)
    (setq company-backends (delete 'company-ispell company-backends))
    (message "company-ispell disabled"))
   (t
    (my-add-ispell-to-company-backends)
    (message "company-ispell enabled!"))))

(defun company-ispell-setup ()
  ;; @see https://github.com/company-mode/company-mode/issues/50
  (when (boundp 'company-backends)
    (make-local-variable 'company-backends)
    (my-add-ispell-to-company-backends)
    ;; @see https://github.com/redguardtoo/emacs.d/issues/473
    (cond
     ((and (boundp 'ispell-alternate-dictionary)
           ispell-alternate-dictionary)
      (setq company-ispell-dictionary ispell-alternate-dictionary))
     (t
       (setq company-ispell-dictionary (file-truename (concat my-emacs-d "misc/english-words.txt")))))))

;; message-mode use company-bbdb.
;; So we should NOT turn on company-ispell
(add-hook 'org-mode-hook 'company-ispell-setup)
;; }}


(provide 'init-company)
