(with-eval-after-load 'org-roam
  ;; disable org roam upgrade warnings.
  (setq org-roam-v2-ack t)
  
  ;; set org-roam directory
  (setq org-roam-directory "~/Documents/notes")

  ;; start roam
  ;; (add-hook 'after-init-hook 'org-roam-mode)
  (org-roam-setup)
  ;; setup org-roam server
  ;;(setq org-roam-server-host "0.0.0.0"
  ;;    org-roam-server-port 9999
  ;;    org-roam-server-export-inline-images t
  ;;    org-roam-server-authenticate nil
  ;;    org-roam-server-network-label-truncate t
  ;;    org-roam-server-network-label-truncate-length 60
  ;;    org-roam-server-network-label-wrap-length 20)
  ;;(org-roam-server-mode)
  )
