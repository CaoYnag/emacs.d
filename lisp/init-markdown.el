;; my conf about markdown-mode
(with-eval-after-load 'markdown-mode
  ;; 
  ;;(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)  
  (push '(".md" . markdown-mode) auto-mode-alist)

  (message "inited markdown.")
  )

(provide 'init-markdown)
