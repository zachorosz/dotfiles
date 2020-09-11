(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; Initialize package archive if not cached
(unless package-archive-contents
  (package-refresh-contents))

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

;; Load org and settings.org
(require 'org)
(org-babel-load-file (expand-file-name "settings.org" user-emacs-directory))
