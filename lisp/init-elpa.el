;; -*- coding: utf-8; lexical-binding: t; -*-

(defun my-initialize-package ()
  ;; optimization, no need to activate all the packages so early
  (cond
   (*emacs27*
    ;; you need run `M-x package-quickstart-refresh' at least once
    ;; to generate file "package-quickstart.el'.
    ;; It contains the `autoload' statements for all packages.
    ;; Please note once this file is created, you can't automatically
    ;; install missing package any more
    ;; You also need need re-generate this file if any package is upgraded.
    (setq package-quickstart t)

    ;; esup need call `package-initialize'
    ;; @see https://github.com/jschaf/esup/issues/84
    (when (or (featurep 'esup-child)
              (fboundp 'profile-dotemacs)
              (not (file-exists-p (concat my-emacs-d "elpa")))
              (my-vc-merge-p)
              noninteractive)
      (package-initialize)))
   (t
    ;; @see https://www.gnu.org/software/emacs/news/NEWS.27.1
    (package-initialize))))

(my-initialize-package)

;; List of visible packages from melpa-unstable (http://melpa.org).
;; Please add the package name into `melpa-include-packages'
;; if it's not visible after  `list-packages'.
(defvar melpa-include-packages
  '(ace-window ; latest stable is released on year 2014
    ace-pinyin
    pos-tip
    web-mode
    racket-mode
    auto-package-update
    web-mode
    kv
    esxml ; nov is dependent on latest esxml
    nov
    bbdb
    esup ; Emacs start up profiler
    native-complete
    company-native-complete
    js2-mode ; need new features
    git-timemachine ; stable version is broken when git rename file
    highlight-symbol
    undo-fu
    command-log-mode
    ;; evil ; @see https://github.com/emacs-evil/evil/commit/19cc5f8eef8bfffdec8082b604c7129782acb332
    ;; lsp-mode ; stable version has performance issue, but unstable version sends too many warnings
    vimrc-mode
    rjsx-mode ; fixed the indent issue in jsx
    package-lint ; for melpa pull request only
    auto-yasnippet
    typescript-mode ; the stable version lacks important feature (highlight function names)
    evil-exchange
    evil-find-char-pinyin
    ;; {{ dependencies of stable realgud are too old
    load-relative
    loc-changes
    test-simple
    ;; }}
    iedit
    undo-tree
    js-doc
    ;; {{ since stable v0.13.0 released, we go back to stable version
    ;; ivy
    ;; counsel
    ;; swiper
    ;; }}
    wgrep
    ;; {{ themes in melpa unstable
    ample-theme
    molokai-theme
    spacemacs-theme
    leuven-theme
    elpy ; use latest elpy since Python package API changes
    sublime-themes
    tangotango-theme
    darkburn-theme
    ujelly-theme
    afternoon-theme
    organic-green-theme
    inkpot-theme
    flatui-theme
    hc-zenburn-theme
    naquadah-theme
    seti-theme
    spacegray-theme
    jazz-theme
    espresso-theme
    phoenix-dark-pink-theme
    tango-plus-theme
    twilight-theme
    minimal-theme
    noctilux-theme
    soothe-theme
    heroku-theme
    hemisu-theme
    badger-theme
    distinguished-theme
    tao-theme
    ;; }}
    groovy-mode
    company ; I won't wait another 2 years for stable
    simple-httpd
    findr
    mwe-log-commands
    noflet
    db
    creole
    web
    buffer-move
    regex-tool
    legalese
    htmlize
    ;; pyim-basedict
    ;; pyim-wbdict
    ;; pyim
    scratch
    session
    inflections
    lua-mode
    pomodoro
    packed
    keyfreq
    gitconfig-mode
    textile-mode
    w3m
    workgroups2
    zoutline
    company-c-headers
    company-statistics)
  "Packages to install from melpa-unstable.")

(defvar melpa-stable-banned-packages nil
  "Banned packages from melpa-stable.")

(setq package-archives
      '(
	("gnu-tuna"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
	("melpa-tuna" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
	("org" . "https://orgmode.org/elpa/")
	;; ("melpa-163" . "https://mirrors.163.com/elpa/melpa/")
	;; ("melpa-stable-163" . "https://mirrors.163.com/elpa/melpa-stable/")
	;; ("gnu-ec" . "http://elpa.emacs-china.org/gnu/")
	;; ("melpa-ec" . "http://elpa.emacs-china.org/melpa/")
	;; ("melpa stable-ec" . "http://elpa.emacs-china.org/melpa-stable/")
	;; ("marmalade-ec" . "http://elpa.emacs-china.org/marmalade/")
	;; ("org-ec" . "http://elpa.emacs-china.org/org/")
	;; ("sunrise-ec" . "http://elpa.emacs-china.org/sunrise-commander/")
	;; ("user42-ec" . "http://elpa.emacs-china.org/user42/")
	;; ("gnu-ec"   	. "http://elpa.zilongshanren.com/gnu/")
    ;; ("melpa-ec" 	. "http://elpa.emacs-chinazilongshanren.com/melpa/")
	;; ("melpa-stable-ec" . "http://elpa.zilongshanren.com/melpa-stable/")
	;; ("org-ec" . "http://elpa.zilongshanren.com/org/")
	))

;; (defvar my-ask-elpa-mirror t)
;; (when (and (not noninteractive) ; no popup in batch mode
;;            my-ask-elpa-mirror
;;            (not (file-exists-p (file-truename (concat my-emacs-d "elpa"))))
;;            (yes-or-no-p "Switch to faster package repositories in China temporarily?
;; You still need modify `package-archives' in \"init-elpa.el\" to PERMANENTLY use this ELPA mirror."))
;;   (setq package-archives
;;         '(
;; 	  ("melpa" . "https://mirrors.163.com/elpa/melpa/")
;;       ("melpa-stable" . "https://mirrors.163.com/elpa/melpa-stable/"))))

;; Un-comment below line if you follow "Install stable version in easiest way"
;; (setq package-archives '(("myelpa" . "~/myelpa/")))

;; my local repository is always needed.
;; (push (cons "localelpa" (concat my-emacs-d "localelpa/")) package-archives)

(defun my-package-generate-autoloads-hack (pkg-desc pkg-dir)
  "Stop package.el from leaving open autoload files lying around."
  (let* ((path (expand-file-name (concat
                                  ;; pkg-desc is string in emacs 24.3.1,
                                  (if (symbolp pkg-desc) (symbol-name pkg-desc) pkg-desc)
                                  "-autoloads.el")
                                 pkg-dir)))
    (with-current-buffer (find-file-existing path)
      (kill-buffer nil))))
(advice-add 'package-generate-autoloads :after #'my-package-generate-autoloads-hack)

(defun my-package--add-to-archive-contents-hack (orig-func &rest args)
  "Some packages should be hidden."
  (let* ((package (nth 0 args))
         (archive (nth 1 args))
         (pkg-name (car package))
         (version (package--ac-desc-version (cdr package)))
         (add-to-p t))
    (cond
     ((string= archive "melpa-stable")
      (setq add-to-p
            (not (memq pkg-name melpa-stable-banned-packages))))

     ;; We still need use some unstable packages
     ((string= archive "melpa")
      (setq add-to-p
            (or (member pkg-name melpa-include-packages)
                ;; color themes are welcomed
                (string-match-p "-theme" (format "%s" pkg-name))))))

    (when my-debug
      (message "package name=%s version=%s package=%s" pkg-name version package))

    (when add-to-p
      ;; The package is visible through package manager
      (apply orig-func args))))
(advice-add 'package--add-to-archive-contents :around #'my-package--add-to-archive-contents-hack)

;; On-demand installation of packages
(defun require-package (package &optional min-version no-refresh)
  "Ask elpa to install given PACKAGE."
  (my-ensure 'package)
  (cond
   ((package-installed-p package min-version)
    t)
   ((or (assoc package package-archive-contents) no-refresh)
    (package-install package))
   (t
    (package-refresh-contents)
    (require-package package min-version t))))

;;------------------------------------------------------------------------------
;; Fire up package.el and ensure the following packages are installed.
;;------------------------------------------------------------------------------

(require-package 'async)
; color-theme 6.6.1 in elpa is buggy
(require-package 'amx)
(require-package 'avy)
(require-package 'popup) ; some old package need it
(require-package 'auto-yasnippet)
;; (require-package 'csv-mode) ; not found in emacs-china
(require-package 'expand-region) ; I prefer stable version
(require-package 'fringe-helper)
(require-package 'gitignore-mode)
(require-package 'gitconfig-mode)
(require-package 'wgrep)
(require-package 'request)
(require-package 'lua-mode)
(require-package 'yaml-mode)
(require-package 'paredit)
(require-package 'findr)
(require-package 'diredfl) ; font lock for `dired-mode'
(require-package 'pinyinlib)
(require-package 'find-by-pinyin-dired)
(require-package 'jump)
(require-package 'nvm)
(require-package 'writeroom-mode)
(require-package 'haml-mode)
(require-package 'markdown-mode)
(require-package 'link)
(require-package 'connection)
(require-package 'dictionary) ; dictionary requires 'link and 'connection
(require-package 'htmlize) ; prefer stable version
(require-package 'jade-mode)
(require-package 'diminish)
(require-package 'scratch)
(require-package 'rainbow-delimiters)
(require-package 'textile-mode)
(require-package 'git-timemachine)
(require-package 'exec-path-from-shell)
(require-package 'ivy)
(require-package 'swiper)
(require-package 'counsel) ; counsel => swiper => ivy
(require-package 'find-file-in-project)
(require-package 'counsel-bbdb)
(require-package 'command-log-mode)
(require-package 'regex-tool)
(require-package 'groovy-mode)
(require-package 'emmet-mode)
(require-package 'winum)
(require-package 'session)
(require-package 'unfill)
;; (require-package 'w3m) ; failed install
;; (require-package 'counsel-gtags) ; failed install
(require-package 'buffer-move)
(require-package 'ace-window)
(require-package 'cmake-mode)
(require-package 'cpputils-cmake)
(require-package 'bbdb)
(require-package 'pomodoro)
;; rvm-open-gem to get gem's code
(require-package 'rvm)
;; C-x r l to list bookmarks
(require-package 'js-doc)
(require-package 'js2-mode)
(require-package 'rjsx-mode)
(require-package 'tagedit)
(require-package 'git-link)
(require-package 'cliphist)
(require-package 'yasnippet)
(require-package 'yasnippet-snippets)
(require-package 'company)
(require-package 'native-complete)
(require-package 'company-native-complete)
(require-package 'company-c-headers)
(require-package 'company-statistics)
(require-package 'lsp-mode)
(require-package 'elpy)
(require-package 'legalese)
(require-package 'simple-httpd)
;; (require-package 'git-gutter) ; use my patched version
(require-package 'neotree)
(require-package 'hydra)
(require-package 'ivy-hydra) ; @see https://oremacs.com/2015/07/23/ivy-multiaction/
(require-package 'web-mode)
(require-package 'emms)
(require-package 'iedit)
(require-package 'websocket) ; for debug debugging of browsers
(require-package 'undo-tree)
(require-package 'undo-fu)
(require-package 'counsel-css)
(require-package 'auto-package-update)
(require-package 'keyfreq)
(require-package 'adoc-mode) ; asciidoc files
(require-package 'shackle)
(require-package 'toc-org)
(require-package 'elpa-mirror)
;; {{ @see https://pawelbx.github.io/emacs-theme-gallery/
;; (require-package 'color-theme)
(require-package 'visual-regexp) ;; Press "M-x vr-*"
(require-package 'vimrc-mode)
(require-package 'nov) ; read epub
(require-package 'rust-mode)
;; (require-package 'langtool) ; my own patched version is better
(require-package 'typescript-mode)
;; run "M-x pdf-tool-install" at debian and open pdf in GUI Emacs
(require-package 'pdf-tools)
;; (require-package 'pyim) ; failed install xr
;; (require-package 'pyim-basedict)
(require-package 'esup)
;; (require-package 'eim) ; failed install
;; (require-package 'ps-ccrypt)

;; {{ Fixed expiring GNU ELPA keys
;; GNU ELPA GPG key will expire on Sep-2019. So we need install this package to
;; update key or else users can't install packages from GNU ELPA.
;; @see https://www.reddit.com/r/emacs/comments/bn6k1y/updating_gnu_elpa_keys/
;; BTW, this setup uses MELPA only. So GNU ELPA GPG key is not used.
(require-package 'gnu-elpa-keyring-update)
;; }}

;; org => ppt
(require-package 'org-re-reveal)
(require-package 'magit)
(require-package 'ace-pinyin)
(require-package 'which-key)
(require-package 'highlight-symbol)

(local-require 'ps-ccrypt) ;; manual copy to 'site-lisp from git repo.

;; kill buffer without my confirmation
(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

(provide 'init-elpa)
