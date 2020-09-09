(require 'package)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

(setq inhibit-startup-screen 1
      column-number-mode t)

(setq package-archives '(("melpa" . "http://melpa.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")
			 ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :ensure t
  :config
  (setq exec-path-from-shell-variables '("PATH" "GOPATH" "NVM_DIR"))
  (exec-path-from-shell-initialize))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package helm
  :ensure t
  :init
  (require 'helm-config)
  :config
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (helm-mode 1))

(use-package projectile
  :ensure t
  :config
  (global-set-key (kbd "C-c p") 'projectile-command-map)
  (projectile-mode))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "C-x g") 'magit-status))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (;; Add major-modes
	 (go-mode . lsp-deferred)
	 ;; which-key integration
	 (lsp-mode . lsp-enable-which-key-integration)))

;; Set up before-save hooks to format buffer and add/delete go imports
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Optionally
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)
(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)

(use-package company
  :ensure t
  :config
  ;; Optionally enable completion-as-you-type behavior
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1))
