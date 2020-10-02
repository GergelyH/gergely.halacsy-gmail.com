
;;;  -*- lexical-binding: t; -*-
(setq org-agenda-files '("~/work/notes/inbox.org"
                          "~/work/notes/gtd.org"
                          "~/work/notes/tickler.org"
                          "~/work/notes/schedule.org"))
(setq org-directory "~/work/notes")
;; (setq +todo-file "~/org/todo.org"
;;       org-agenda-files '("~/org"))
;; (setq +daypage-path "~/org/days/")

(setq org-agenda-todo-ignore-scheduled 'nil)

(require 'org-expiry)
;; Configure it a bit to my liking
(setq
  org-expiry-created-property-name "CREATED" ; Name of property when an item is created
  org-expiry-inactive-timestamps   t         ; Don't have everything in the agenda view
)

(defun mrb/insert-created-timestamp()
  "Insert a CREATED property using org-expiry.el for TODO entries"
  ;; (evil-insert-newline-below)
  ;; (evil-previous-line)
  ;; (org-expiry-insert-created)
  (org-schedule "" "")
  (org-back-to-heading)
  (org-end-of-line)
  (insert " ")
)

;; Whenever a TODO entry is created, I want a timestamp
;; Advice org-insert-todo-heading to insert a created timestamp using org-expiry
(defadvice org-insert-todo-heading (after mrb/created-timestamp-advice activate)
  "Insert a CREATED property using org-expiry.el for TODO entries"
  (mrb/insert-created-timestamp)
)
;; Make it active
(ad-activate 'org-insert-todo-heading)

(require 'org-capture)

(defadvice org-capture (after mrb/created-timestamp-advice activate)
  "Insert a CREATED property using org-expiry.el for TODO entries"
  ; Test if the captured entry is a TODO, if so insert the created
  ; timestamp property, otherwise ignore
  (when (member (org-get-todo-state) org-todo-keywords-1)
    (mrb/insert-created-timestamp)))
(ad-activate 'org-capture)

;; Add feature to allow easy adding of tags in a capture window
(defun mrb/add-tags-in-capture()
  (interactive)
  "Insert tags in a capture window without losing the point"
  (save-excursion
    (org-back-to-heading)
    (org-set-tags)))

;; (defun org-test-property ()
;;   (interactive)
;;   (message-box (org-entry-get (point) "CREATED")))
;; Bind this to a reasonable key
;; (define-key org-capture-mode-map "\C-c\C-t" 'mrb/add-tags-in-capture)

;; (defun org-sort-entries-by-reverse-date ()
;;   (interactive)
;;     (org-sort-entries t ?A)
;;   )


(setq org-bullets-bullet-list '("#"))



(setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "PARTIAL(p)" "RECURRING(r)" "AFTER(a)" "|" "DONE(d)" "CANCELLED(c)")))
(setq org-capture-templates '(("i" "inbox" entry
                                (file+headline "~/Dropbox/notes/inbox.org" "Tasks")
                              "* %i%?")
                              ("T" "Tickler" entry
                                (file+headline "~/Dropbox/notes/tickler.org" "Tickler")
                                "* %i%? \n %U")))

;;(setq org-outline-path-complete-in-steps nil)
(setq org-refile-targets '(("~/Dropbox/notes/gtd.org" :maxlevel . 3)
                            ("~/Dropbox/notes/someday.org" :level . 1)
                            ("~/Dropbox/notes/tickler.org" :maxlevel . 2)))
;; (setq org-agenda-custom-commands
      ;; '(("o" "At the office" tags-todo "@office"
         ;; ((org-agenda-overriding-header "Office")
          ;; (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))))

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

(setq org-agenda-custom-commands
      '(("o" "At the office" tags-todo "@office"
         ((org-agenda-overriding-header "Office")))))

(defun org-agenda-reverse-time-sort (a b)
  "Compare two `org-mode' agenda entries, `A' and `B', by some date property.

If a is before b, return -1. If a is after b, return 1. If they
are equal return t."
  (let* ((a-pos (get-text-property 0 'org-marker a))
          (b-pos (get-text-property 0 'org-marker b))
          (a-prority (org-entry-get a-pos "PRIORITY"))
          (b-prority (org-entry-get b-pos "PRIORITY"))
          (print a-prority)
          (a-date (or (org-entry-get a-pos "CREATED")
                      (format "<%s>" (org-read-date t nil "now"))))
          (b-date (or (org-entry-get b-pos "CREATED")
                      (format "<%s>" (org-read-date t nil "now"))))
          (cmp-prioriry (compare-strings a-prority nil nil b-prority nil nil))
          (cmp-date (compare-strings a-date nil nil b-date nil nil))
          )
    (if (eq cmp-prioriry t) 
        (if (eq cmp-date t) nil (signum cmp-date))
        (signum cmp-prioriry)
    )
    ))

(add-to-list 'org-agenda-custom-commands
             '("b" "Tasks Overview"
               ((todo "TODO")
                (todo "PARTIAL")
                (todo "RECURRING"))
               ((org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))

(add-to-list 'org-agenda-custom-commands
                   '("d" "Day view" agenda ""
         (
          ;; a slower way to do the same thing
          ;; (org-agenda-skip-function '(org-agenda-skip-entry-if 'notdeadline))
          (org-agenda-span 1)
          (org-agenda-start-day (org-today))
        )))

(org-super-agenda-mode t)
(setq org-super-agenda-groups
       '(;; Each group has an implicit boolean OR operator between its selectors.
         (:name "Today"  ; Optionally specify section name
                :time-grid t)  ; Items that have this TODO keyword
         (:name "Todos"  ; Optionally specify section name
                :todo "TODO")  ; Items that have this TODO keyword
         (:name "Partials"
                :todo "PARTIAL")
         (:name "Recurring"
                :todo "RECURRING"
                ))
)
(setq org-shift-today-by-days 0)

(defun org-today ()
  "Return today date, considering `org-extend-today-until'."
  (+ org-shift-today-by-days
    (time-to-days
      (org-time-since (* 3600 org-extend-today-until)))))

(defun org-increment-shift-today-by-days ()
  (interactive)
  (setq org-shift-today-by-days (+ 1 org-shift-today-by-days))
  (org-agenda-redo))

(defun org-decrement-shift-today-by-days ()
  (interactive)
  (setq org-shift-today-by-days (- org-shift-today-by-days 1))
  (org-agenda-redo))

(setq org-super-agenda-header-map (make-sparse-keymap))

(require 'org-gcal)



(setq org-gcal-client-id "734202814987-1q1s695v0vd53r4b7c3kdoie8f6c59u2.apps.googleusercontent.com"
      org-gcal-client-secret "Wwr7Iko59OsjFadDyVQg6nLR"
      org-gcal-file-alist '(("gergely.halacsy@gmail.com" .  "~/Dropbox/notes/schedule.org")
                            ))
;; (setq org-gcal-client-id "860972419948-hf9cqea7qhrjh5v6161hh62nsa5vmu05.apps.googleusercontent.com"
;;       org-gcal-client-secret "fgPsL-v_CY783qLIKuRHqgMr"
;;       org-gcal-file-alist '(("gergely.halacsy@gmail.com" .  "~/Dropbox/notes/schedule.org")
;;                             ))
