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

;; delete trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; setup ess for R
(require 'poly-R)
(require 'poly-markdown)
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

;; ace-window
(global-set-key (kbd "C-x o") 'ace-window)

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
