
(defun sync-google-calendar()
  (interactive)
  (call-process "python" nil '(:file "~/work/emacs_sync/emacs_log.txt") nil "/home/gergeh/work/emacs_sync/sync.py" ))
;;;  -*- lexical-binding: t; -*-
(setq org-agenda-files '("~/work/notes/inbox.org"
                          "~/work/notes/gtd.org"
                          "~/work/notes/tickler.org"
                          "~/work/notes/projects.org"
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
  (org-expiry-insert-created)
  ;; (org-schedule "" "")
  ;; (org-back-to-heading)
  ;; (org-end-of-line)
  ;; (insert " ")
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

(defun capture-to-inbox ()
  (interactive)
  (org-capture nil "i"))
;; (defadvice org-capture-finalize
;;      (after delete-capture-frame activate)
;;    "Advise capture-finalize to close the frame"
;;    (if (equal "capture" (frame-parameter nil 'name))
;;        (delete-frame)))

;;  (defadvice org-capture-destroy
;;      (after delete-capture-frame activate)
;;    "Advise capture-destroy to close the frame"
;;    (if (equal "capture" (frame-parameter nil 'name))
;;        (delete-frame)))

;;  (use-package noflet
;;     :ensure t )
;; (defun make-capture-frame ()
;;    "Create a new frame and run org-capture."
;;    (interactive)
;;    (make-frame '((name . "capture")))
;;    (select-frame-by-name "capture")
;;    (delete-other-windows)
;;    (noflet ((switch-to-buffer-other-window (buf) (switch-to-buffer buf)))
;;            (org-capture)))

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


(setq org-bullets-bullet-list '("►"))



(setq org-todo-keywords '((sequence "TODO(t)" "INNER(i)" "WAITING(w)" "Activity(l)" "|" "DONE(d)" "CANCELLED(c)")))
(setq org-capture-templates '(("i" "inbox" entry
                                (file "~/work/notes/inbox.org")
                              "* %i%?")
                              ("T" "Tickler" entry
                                (file+headline "~/work/notes/tickler.org" "Tickler")
                                "* %i%? \n %U")))

;;(setq org-outline-path-complete-in-steps nil)
(setq org-refile-targets '(("~/work/notes/notes.org" :maxlevel . 3)
                            ("~/work/notes/references.org" :maxlevel . 3)
                            ("~/work/notes/someday.org" :maxlevel . 2)
                            ("~/work/notes/projects.org":maxlevel . 4)
                            ("~/work/notes/tickler.org" :maxlevel . 2)))
;; (setq org-agenda-custom-commands
      ;; '(("o" "At the office" tags-todo "@office"
         ;; ((org-agenda-overriding-header "Office")
          ;; (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))))

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))


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

(setq org-agenda-custom-commands
      '(("d" "DEL"
         ((tags-todo "del")
          (tags-todo "-{^.+}"))
         ((org-agenda-overriding-header "DEL")
        (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
        (org-agenda-sorting-strategy '(user-defined-up))))))

(add-to-list 'org-agenda-custom-commands
             '("t" "Todos"
               ((todo "TODO")
                )
               ((org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))

(add-to-list 'org-agenda-custom-commands
             '("c" "Calendar" (
                               (agenda ""
                                        ((org-agenda-span 2)                          ;; [1]
                                        (org-agenda-start-on-weekday nil)               ;; [2]
                                        (org-agenda-start-day "0d")               ;; [2]
                                        (org-agenda-time-grid nil)
                                        (org-agenda-repeating-timestamp-show-all t)   ;; [3]
                                        (org-agenda-entry-types '(:timestamp :sexp)))
                                        )
                               (todo "WAITING")
                               )
               )  ;; [4]
                                ;; other commands go here
)
;; (org-capture nil "i")

(add-to-list 'org-agenda-custom-commands
             '("g" "General view" (
                               (agenda "" ((org-agenda-span 2) (org-agenda-start-on-weekday nil) (org-agenda-start-day "0d") (org-agenda-entry-types '(:timestamp)) ))
                ;;                (todo "Activity" (
                ;; (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                ;; (org-agenda-sorting-strategy '(user-defined-up))))
                ;;                (todo "TODO" (
                ;; (org-agenda-cmp-user-defined 'Org-agenda-reverse-time-sort)
                ;; (org-agenda-sorting-strategy '(user-defined-up))))
                               (todo "WAITING" (
                (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up))))
                               )
                ))

(add-to-list 'org-agenda-custom-commands
             '("pc" "City"
                ((tags-todo "city")
                (tags-todo "-{^.+}"))
                ((org-agenda-overriding-header "City")
                (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))
(add-to-list 'org-agenda-custom-commands
             '("pa" "Applications"
                ((tags-todo "applications")
                (tags-todo "-{^.+}"))
                ((org-agenda-overriding-header "Applications")
                (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))
(add-to-list 'org-agenda-custom-commands
             '("pe" "Entrepreneurship"
                ((tags-todo "entrepreneurship")
                (tags-todo "-{^.+}"))
                ((org-agenda-overriding-header "Entrepreneurship")
                (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))
(add-to-list 'org-agenda-custom-commands
             '("ps" "Software engineering"
                ((tags-todo "sfe")
                (tags-todo "-{^.+}"))
                ((org-agenda-overriding-header "Software engineering")
                (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))
(add-to-list 'org-agenda-custom-commands
             '("ph" "Home"
                ((tags-todo "home")
                (tags-todo "-{^.+}"))
                ((org-agenda-overriding-header "Home")
                (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))
(add-to-list 'org-agenda-custom-commands
             '("pd" "Del"
                ((tags-todo "del")
                (tags-todo "-{^.+}"))
                ((org-agenda-overriding-header "Del")
                (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))
(add-to-list 'org-agenda-custom-commands
             '("pb" "Body"
                ((tags-todo "body")
                (tags-todo "-{^.+}"))
                ((org-agenda-overriding-header "Body")
                (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))
(add-to-list 'org-agenda-custom-commands
             '("pm" "Materialistic"
                ((tags-todo "materialistic")
                (tags-todo "-{^.+}"))
                ((org-agenda-overriding-header "Materialistic")
                (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))
(add-to-list 'org-agenda-custom-commands
             '("pl" "Leisure"
                ((tags-todo "leisure")
                (tags-todo "-{^.+}"))
                ((org-agenda-overriding-header "Leisure")
                (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))
(add-to-list 'org-agenda-custom-commands
             '("pi" "Self improvement"
                ((tags-todo "self_improvement")
                (tags-todo "-{^.+}"))
                ((org-agenda-overriding-header "Self improvement")
                (org-agenda-cmp-user-defined 'org-agenda-reverse-time-sort)
                (org-agenda-sorting-strategy '(user-defined-up)))))

(org-super-agenda-mode nil)
(setq org-super-agenda-groups
       '(;; Each group has an implicit boolean OR operator between its selectors.
         (:name "Day"  ; Optionally specify section name
                :time-grid t)  ; Items that have this TODO keyword
         ;; (:name "Todos"  ; Optionally specify section name
         ;;        :todo "TODO")  ; Items that have this TODO keyword
         (:name "Activity tasks"
                :todo "Activity")
         (:name "Waiting for "
                :todo "WAITING"
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

(setq org-agenda-sticky 1)

(setq org-archive-location "~/work/notes/archive/%s::")

(defun org-agenda-subtree-or-region (prefix)
  "Display an agenda view for the current subtree or region.
With prefix, display only TODO-keyword items."
  (interactive "p")
  (let (header)
    (if (use-region-p)
        (progn
          (setq header "Region")
          (put 'org-agenda-files 'org-restrict (list (buffer-file-name (current-buffer))))
          (setq org-agenda-restrict (current-buffer))
          (move-marker org-agenda-restrict-begin (region-beginning))
          (move-marker org-agenda-restrict-end
                       (save-excursion
                         (goto-char (1+ (region-end))) ; If point is at pos 0, include heading on that line
                         (org-end-of-subtree))))
      (progn
        ;; No region; restrict to subtree
        (setq header "Subtree")
        (org-agenda-set-restriction-lock 'subtree)))

    ;; sorting doesn't seem to be working, but the header is
    (let ((org-agenda-sorting-strategy '(priority-down timestamp-up))
          (org-agenda-overriding-header header))
      (org-search-view t "*"))
    (org-agenda-remove-restriction-lock t)
    (message nil)))

(defun org-info-open-new-window (path)
  "Open info in a new buffer"
  (setq available-windows
        (delete (selected-window) (window-list)))
  (setq new-window
         (or (car available-windows)
             (split-window-sensibly)
             (split-window-right)))
  (select-window new-window)
  (org-info-follow-link path))
(org-link-set-parameters "info" :follow #'org-info-open-new-window)
