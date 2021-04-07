
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(setq package-archives '(
			 ("GNU ELPA" . "http://elpa.emacs-china.org/gnu/")
			 ("MELPA" . "http://elpa.emacs-china.org/melpa/")
			 ("MELPA Stable" . "http://elpa.emacs-china.org/melpa-stable/")
			 ("Marmalade" . "http://elpa.emacs-china.org/marmalade/")
			 ("Org" . "http://elpa.emacs-china.org/org/")
			 ("Sunrise Commander ELPA" . "http://elpa.emacs-china.org/sunrise-commander/")
			 ("user42 ELPA" . "http://elpa.emacs-china.org/user42/")
			 ))

(package-initialize)

(add-to-list 'load-path "~/.emacs.d/modes")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)  
(setq auto-mode-alist  
(cons '(".md" . markdown-mode) auto-mode-alist))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("716f0a8a9370912d9e6659948c2cb139c164b57ef5fda0f337f0f77d47fe9073" "57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693" "032d5dc72a31ebde5fae25a8c1ef48bac6ba223588a1563d10dbf3a344423879" default))
 '(package-selected-packages
   '(melancholy-theme afternoon-theme magit irony company-lua company-cmake company-c-headers ## company auto-correct))
 '(safe-local-variable-values
   '((company-clang-arguments "-I/usr/include/pcl-1.7/" "-I/usr/include/eigen3/"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; always show line number
(global-linum-mode t)


(setq inhibit-splash-screen t)
(setq default-tab-width 4)
(setq c-basic-offset 4)
(setq c-default-style "linux" c-basic-offset 4)

;; company settings
;; ===================================================
(require 'company)
(require 'irony)
(require 'company-irony)
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 2)
(setq company-dabbrev-downcase nil)
(add-to-list 'company-backends 'company-dabbrev)
(add-to-list 'company-backends 'company-dabbrev-code)
(add-to-list 'company-backends 'company-files)
(add-to-list 'company-backends 'company-semantic)
(add-to-list 'company-backends 'company-keywords)
(add-to-list 'company-backends 'company-irony)
;;(add-to-list 'company-backends 'company-gtags)
(add-to-list 'company-backends 'company-capf)
(require 'company-c-headers)
(add-to-list 'company-c-headers-path-system "/usr/include/c++/4.9.2/")
(add-to-list 'company-backends 'company-c-headers)
(global-set-key (kbd "C-;") 'company-complete-common)
;;使用M-n 和 M-p 选择候选项
;;company 颜色设置
(defun theme-dark ()
  (interactive)
   (set-face-foreground 'company-tooltip "#000")
    (set-face-background 'company-tooltip "#fff")
     (set-face-foreground 'company-scrollbar-bg "#fff")
      (set-face-background 'company-scrollbar-fg "#999")
)
(theme-dark)
;; end company settings

(load-theme 'melancholy t)
