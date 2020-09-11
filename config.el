;; package -- My Emacs config.
;;; Commentary:
;;; Helm, Company, Irony, Evil and more

;;; Code:

;; Adding melpa packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Starting in fullscreen
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(doom-Iosvkem))
 '(custom-safe-themes
   '("990e24b406787568c592db2b853aa65ecc2dcd08146c0d22293259d400174e37" "ae65ccecdcc9eb29ec29172e1bfb6cadbe68108e1c0334f3ae52414097c501d2" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "a3b6a3708c6692674196266aad1cb19188a6da7b4f961e1369a68f06577afa16" default))
 '(package-selected-packages
   '(which-key centaur-tabs emms yasnippet-snippets undo-tree tron-legacy-theme swiper spacemacs-theme solarized-theme smart-mode-line sly rainbow-delimiters projectile powerline paredit nasm-mode moe-theme irony-eldoc hydra helm haskell-mode god-mode flycheck-irony dracula-theme doom-themes dashboard cyberpunk-theme company-irony cmake-mode all-the-icons))
 '(send-mail-function 'smtpmail-send-it)
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 25))

(dolist (p package-selected-packages)
  (unless (package-installed-p p)
    (package-install p)))

;; My customizations
(setq mouse-wheel-progressive-speed nil)
(setq inhibit-splash-screen t) ; No splash screen
(setq make-backup-files nil) ; No backups
(setq ring-bell-function 'ignore) ; No bell ring
(setq auto-save-default nil)
(setq blink-cursor-mode nil)
(setq company-idle-delay 0.1)
(setq confirm-kill-emacs (quote y-or-n-p))
(setq confirm-kill-processes nil)
(setq create-lockfiles nil)
(setq delete-by-moving-to-trash t)
(setq indent-tabs-mode t)
(setq scroll-step 1)

(display-time)
(display-battery-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(electric-pair-mode 1)

(setq show-paren-delay 0) ; Parenthesises delay 0
(show-paren-mode t) ; Show matching parens

(winner-mode 1)

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(setq inhibit-compacting-font-caches t)
(windmove-default-keybindings)
(global-prettify-symbols-mode +1)

(add-hook 'text-mode-hook
	  (lambda ()
	    (hl-line-mode 1)
	    (auto-fill-mode 1)
	    (display-line-numbers-mode)))

(add-hook 'prog-mode-hook
	  (lambda ()
	    (hl-line-mode 1)
	    (display-line-numbers-mode)
	    (auto-save-mode)
	    (hs-minor-mode 1)
	    (toggle-truncate-lines))) ;Set line numbers for code only

(add-hook 'asm-mode-hook #'nasm-mode)

;; Remove useless whitespace before saving a file
(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(add-hook 'irony-mode-hook #'irony-eldoc)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;; Freenode
;; nickname : h4ck3r9696
;; Password : ilovepotatoes
;; E-Mail : phi.crypto@gmail.com

;; Custom keybindings

(defun my/image-autorevet ()
  "Make the image autoatically revert when changed on disk."
  (interactive)
  (auto-image-file-mode)
  (auto-revert-mode))

(defun my/vs-compile ()
  "Compile project and then lauch exe in eshell."
  (interactive)
  (when (compile "make -k")
    (if (get-buffer "*eshell*")
	(switch-to-buffer-other-window "*eshell*")
      (eshell))))

;; Hydra keybindings configuration

(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

(defhydra hydra-move (global-map "C-c m")
  "move"
  ("h" backward-char "Left")
  ("l" forward-char "Right")
  ("j" next-line "Down")
  ("k" previous-line "Up"))

(setq compile-command "cmake --build ../build") ; Default compile
(global-set-key (quote [f5]) 'my/vs-compile) ; f5 to compile

(global-set-key (kbd "C-s") 'swiper)

;; Undo-tree mode
(global-undo-tree-mode 1)

;; Hide show
(global-set-key (kbd "C-c c") 'hs-hide-block)
(global-set-key (kbd "C-c o") 'hs-show-block)

;; Company
(add-hook 'after-init-hook 'global-company-mode)

;; Flycheck config
(add-hook 'c++-mode-hook (lambda () (flycheck-mode 1)))
(add-hook 'c-mode-hook (lambda () (flycheck-mode 1)))

(add-hook 'emacs-lisp-mode-hook (lambda ()
				  (flycheck-mode 1)
				  (rainbow-delimiters-mode 1)
				  (paredit-mode 1)))

(add-hook 'lisp-mode-hook (lambda ()
			    (rainbow-delimiters-mode 1)
			    (paredit-mode 1)))

(require 'dashboard)
(setq dashboard-init-info "Hacks and glory awaits!")
(setq dashboard-startup-banner 'logo)

(dashboard-setup-startup-hook)

(require 'which-key)
(which-key-mode)

(require 'emms-setup)
(emms-all)
(emms-default-players)

(setq emms-source-file-default-directory "~/Music/")

(require 'god-mode)
(global-set-key (kbd "C-z") #'god-local-mode)
(global-set-key (kbd "C-<") #'end-of-buffer)

;; (require 'moe-theme)
;; (setq moe-theme-resize-org-title '(1.5 1.4 1.3 1.2 1.1 1.0 1.0 1.0 1.0))
;; (moe-dark)

(setq sml/theme 'respectful)
(sml/setup)

;;; Configuring helm
(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)

(yas-global-mode 1)

;; Projectile for project management
(projectile-mode 1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Configuring haskell-mode for company
(add-hook 'haskell-mode-hook
	  (lambda ()
	    (set (make-local-variable 'company-backends)
		 (append '((company-capf company-dabbrev-code))
			 company-backends))))

(setq inferior-lisp-program "/usr/bin/sbcl")

(provide '.emacs)
;;; .emacs ends here
(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Fira Code" :foundry "CTDB" :slant normal :weight normal :height 68 :width normal)))))
