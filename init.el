;; (package-initialize)

(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))

(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)) )
(setq *emacs27* (>= emacs-major-version 27))

;; don't GC during startup to save time
(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold most-positive-fixnum)

(defconst my-emacs-d (file-name-as-directory user-emacs-directory)
  "Directory of emacs.d .")

(defconst my-site-lisp-dir (concat my-emacs-d "site-lisp")
  "Directory of site-lisp .")

(defconst my-lisp-dir (concat my-emacs-d "lisp")
  "Directory of lisp.")

(defvar my-debug nil "Enable debug mode.")

(defun my-vc-merge-p ()
  "Use Emacs for git merge only?"
  (boundp 'startup-now))

(defun require-init (pkg &optional maybe-disabled)
  "Load PKG if MAYBE-DISABLED is nil or it's nil but start up in normal slowly."
  (when (or (not maybe-disabled) (not (my-vc-merge-p)))
    (load (file-truename (format "%s/%s" my-lisp-dir pkg)) t t)))

(defun my-add-subdirs-to-load-path (lisp-dir)
  "Add sub-directories under LISP-DIR into `load-path'."
  (let* ((default-directory lisp-dir))
    (setq load-path
          (append
           (delq nil
                 (mapcar (lambda (dir)
                           (unless (string-match-p "^\\." dir)
                             (expand-file-name dir)))
                         (directory-files my-site-lisp-dir)))
           load-path))))


(message "before init list")
;; init list
(let* ((file-name-handler-alist nil))
  (my-add-subdirs-to-load-path (file-name-as-directory my-site-lisp-dir))
  (require-init 'init-autoload t)
  (require-init 'init-utils)
  (require-init 'init-elpa)
  
  (require-init 'init-company t)
  (require-init 'init-citre)
  (require-init 'init-org)
  ;; (require-init 'init-org-roam) ;; init roam in init-org
  (require-init 'init-markdown t)
  ;; (require-init 'init-eim)
  (require-init 'init-pyim)
  (require-init 'init-file-types)
  (require-init 'init-writting)
  ;; (require-init 'init-wakatime) ;; stop use wakatime
  )

(message "init list done")

;; theme settings.
;; just placed here. unnecessary to add a init-theme.el
(add-to-list 'custom-theme-load-path (concat my-emacs-d "themes"))
(load-theme 'melancholy t)

(set-frame-font "-WQYF-WenQuanYi Micro Hei Mono-regular-normal-normal-*-*-*-*-*-*-0-iso10646-1" nil t)

;; some default styles
(global-linum-mode t)
(setq inhibit-splash-screen t)
(setq default-tab-width 4)
(setq-default c-basic-offset 4
	      tab-width 4
	      indent-tabs-mode t)
(setq c-default-style "linux" c-basic-offset 4)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("733ec9d07b97f4ee07ea7c975f72f633d43d209535fd3e0cd150a37a35bcaeec" "314045e2924c1390bcbc03c31dada444526b02e75f3dbef65199c7cbed0f4117" "8c9d3a0e2e54cf65fde8a10c500b03c8bf09adead9b3693a67bf2e6d311fdfe0" "716f0a8a9370912d9e6659948c2cb139c164b57ef5fda0f337f0f77d47fe9073" "57e3f215bef8784157991c4957965aa31bac935aca011b29d7d8e113a652b693" "032d5dc72a31ebde5fae25a8c1ef48bac6ba223588a1563d10dbf3a344423879" default))
 '(package-selected-packages
   '(go-fill-struct go-gopath go-impl go-imports company-irony-c-headers flycheck-golangci-lint flycheck-irony org-download emacsql-sqlite3 go-mode company-go ggo-mode org-roam-bibtex valign org-roam-server org-roam julia-repl julia-snail julia-mode flycheck simple-httpd highlight-symbol which-key ace-pinyin org-re-reveal gnu-elpa-keyring-update eim esup pyim pdf-tools typescript-mode rust-mode nov vimrc-mode visual-regexp elpa-mirror toc-org shackle adoc-mode keyfreq auto-package-update counsel-css undo-fu undo-tree websocket iedit emms web-mode ivy-hydra hydra neotree legalese elpy lsp-mode company-native-complete native-complete yasnippet-snippets cliphist git-link tagedit rjsx-mode js2-mode js-doc rvm pomodoro bbdb cpputils-cmake ace-window buffer-move counsel-gtags w3m unfill session winum emmet-mode groovy-mode regex-tool command-log-mode counsel-bbdb find-file-in-project counsel swiper ivy exec-path-from-shell git-timemachine textile-mode rainbow-delimiters scratch diminish jade-mode htmlize dictionary connection link haml-mode writeroom-mode nvm jump find-by-pinyin-dired pinyinlib diredfl findr paredit request wgrep gitconfig-mode gitignore-mode fringe-helper auto-yasnippet expand-region csv-mode popup avy amx async company-statistics cmake-mode markdown-mode company-tabnine org-bullets melancholy-theme afternoon-theme magit irony company-lua company-cmake company-c-headers ## company auto-correct))
 '(safe-local-variable-values
   '((company-clang-arguments "-I/usr/include/pcl-1.7/" "-I/usr/include/eigen3/"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
