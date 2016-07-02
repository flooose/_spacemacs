(setq org-directory "~/Documents/org-mode")
(setq org-default-notes-file (concat org-directory "/index.org"))

(setq org-todo-keywords
      '((sequence "TODO(t)" "BUY(b)" "|" "DONE(d)")))

(setq org-capture-templates
     '(("t" "Todo" entry (file+headline (concat org-directory "/index.org") "Tasks")
        "* TODO %?\n  %i\n  %a")
       ("g" "Generic" entry (file (concat org-directory "/index.org"))
        "* %?\n  %i\n  %a")
       ("j" "Journal" entry (file+datetree (concat org-directory "/journal.org.cpt"))
      "* %?\n\n\tEntered on %U\n  %i\n  %a")
       ("l" "Language" entry (file+datetree (concat org-directory "/language.org"))
      "* %?\nEntered on %U\n\n\t%i\n  %a")
       ("w" "Wortschatz" entry (file (concat org-directory "/vokab.org"))
      "* %?\n")
       ("s" "Shopping" entry (file (concat org-directory "/shopping.org"))
      "* TODO %?\n  %i\n")))

(setq org-agenda-files (list org-directory "~/Documents/org"))

;; Enable code blocks in org-mode for the following languages
(let ((languages '((emacs-lisp . t)
                   (ruby . t)
                   (js . t)
                   (css . t)
                   (lisp . t)
                   (sql . t)
                   (sh . t))))
  (org-babel-do-load-languages
   'org-babel-load-languages
   languages))

;; mobileorg
(setq org-mobile-directory "~/Dropbox/org")
(setq org-mobile-inbox-for-pull (concat org-directory "/from-mobile.org"))
(setq org-mobile-keywords (list "shopping" "todo"))
(setq org-mobile-files (list
                   (concat org-directory "/index.org")
                   (concat org-directory "/todo.org")
                   (concat org-directory "/shopping.org")
                   (concat org-directory "/vokab.org")))
