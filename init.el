;; keep customizations in own file
(setq custom-file "~/.emacs.d/private/emacs-custom.el")
(load custom-file)

;; global font size
(set-face-attribute 'default (selected-frame) :height 120)

(load-theme 'spacemacs-light)

;; what time is it?
(display-time-mode 1)

;; we don't always want to do this manually
(toggle-frame-maximized)

;; cursor to bar
(setq-default cursor-type 'bar)

;; get rid of temporary files
(setq temporary-file-directory "~/tmp")
(setq create-lockfiles nil)
(setq backup-directory-alist
			`((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
			`((".*" ,temporary-file-directory t)))

;; See https://github.com/syl20bnr/spacemacs/issues/2667 for why this is necessary
(setq global-auto-revert-non-file-buffers nil)

;; delete trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; setup ess for R
(require 'poly-R)
(require 'poly-markdown)
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

;; ace-window
(global-set-key (kbd "C-x o") 'ace-window)


(global-set-key (kbd "C-x r e") 'er/expand-region)

;;
;; ccrypt integration
;;
(require 'ps-ccrypt "~/.emacs.d/private/modes/ps-ccrypt.el")

;; numbers and stuff
(global-linum-mode t)
(setq line-number-mode t)
(setq column-number-mode t)

;; predictable behaviour for guests
(delete-selection-mode 1)

;; load enabled scripts
(dolist (item (nthcdr 2 (directory-files "~/.emacs.d/private/scripts-enabled/" t)))
  (load-file item))

;; KEYBINDINGS

;; Yank keymap
(setq flooose-yank-keymap (make-sparse-keymap))
(define-key flooose-yank-keymap "l" (lambda () (interactive)
                                      (save-excursion
                                        (back-to-indentation)
                                        (set-mark-command nil)
                                        (move-end-of-line nil)
                                        (kill-ring-save 'doesnt-matter-because 'of-next-argument t)
                                        )))
(global-set-key (kbd "C-c w") flooose-yank-keymap)

;; Navigation keymap
(setq flooose-navigation-keymap (make-sparse-keymap))
(global-set-key (kbd "C-c n") flooose-navigation-keymap)
(define-key flooose-navigation-keymap "a" 'back-to-indentation)

;; make working with strings easier
(global-set-key (kbd "C-=") 'er/expand-region)

;; taken from http://emacsredux.com/blog/2013/05/30/joining-lines/
(defun top-join-line ()
  "Join the current line with the line beneath it."
  (interactive)
  (delete-indentation 1))
(global-set-key (kbd "C-^") 'top-join-line)

;; rgrep
(global-set-key (kbd "C-, g") 'rgrep)

(defun flooose-open-line ()
  "Open line below current line and go to it"
  (interactive)
  (end-of-line)
  (newline-and-indent))
(global-set-key (kbd "C-<return>") 'flooose-open-line)
(global-set-key (kbd "C-o") 'flooose-open-line)

(defun flooose-open-line-above ()
  "Open line above and got to it"
  (interactive)
  (beginning-of-line)
  (newline)
  (previous-line))
(global-set-key (kbd "C-S-<return>") 'flooose-open-line-above)
(global-set-key (kbd "C-S-o") 'flooose-open-line-above)

;; javascript
(add-to-list 'auto-mode-alist '("\\.js$" . web-mode))
(setq flymake-jslint-command "eslint")
(add-hook 'js2-mode-hook 'flymake-jslint-load)
(add-hook 'web-mode-hook
          (lambda ()
            (if (or (equal web-mode-content-type "jsx") (equal web-mode-content-type "javascript"))
                (flymake-jslint-load))))

;; We always want to indent 2
(setq typescript-indent-level 2)
(setq js2-basic-offset 2)
(setq js-indent-level 2)
(setq js3-indent-level 2)

;; tide typescript ide
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; format options
(setq tide-format-options '(:insertSpaceAfterFunctionKeywordForAnonymousFunctions t :placeOpenBraceOnNewLineForFunctions nil))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (progn
                (web-mode-set-content-type "tsx")
                (setup-tide-mode)))))

(setq web-mode-content-types-alist
      '(("jsx" . "\\.js[x]?\\'")
        ("jsx" . "\\.ts[x]?\\'")))

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (web-mode-set-content-type "jsx"))))


(setq projectile-globally-ignored-directories (append projectile-globally-ignored-directories "node_modules")
              (setup-tide-mode))
