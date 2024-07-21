(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(menu-bar-mode -1)

(load-theme 'doom-dracula)

(setq visible-bell t)
(setq-default tab-width 2)

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
	(format "%.2f seconds"
		(float-time
		(time-subtract after-init-time before-init-time)))
			gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

(set-face-attribute 'default nil :font "Jetbrains Mono" :height 100)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages")
			  		     ("elpa" . "https://elpa.gnu.org/packages/")))


(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package command-log-mode)

(use-package ivy
		:diminish
		:bind (("C-s" . swiper)
			:map ivy-minibuffer-map
			("TAB" . ivy-alt-done)
			("C-l" . ivy-alt-done)
			("C-j" . ivy-previous-line)
			("C-k" . ivy-next-line)
			:map ivy-switch-buffer-map
			("C-k" . ivy-previous-line)
			("C-l" . ivy-done)
			("C-d" . ivy-switch-buffer-kill))
  :config
  (ivy-mode 1))

(require 'evil)
(evil-mode 1)

(global-display-line-numbers-mode t)
(column-number-mode)

(use-package doom-modeline
  :ensure t
	:init (doom-modeline-mode 1)
	:custom ((doom-modeline-height 15)))

  ;; (use-package rainbow-delimeters
  ;;   :hook (prog-mode . rainbow-delimeters-mode))

(use-package which-key
  :init (which-key-mode)
	:diminish which-key-mode
	:config (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :init (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
					("C-x b" . counsel-ibuffer)
					("C-x C-f" . counsel-find-file)
					:map minibuffer-local-map
					("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

(use-package all-the-icons)

(use-package general
  :config
  (general-create-definer sztavi/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (sztavi/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

