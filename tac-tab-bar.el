;;; tac-tab-bar.el --- Tactics for tab-bar-mode -*- lexical-binding: t -*-

;; Author: Nathan Nichols
;; Maintainer: Nathan Nichols
;; Version: 1.0
;; Package-Requires: projectile
;; Homepage: https://resultsmotivated.com
;; Keywords: tab-bar, tabs

;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


;;; Commentary:

;; Functions for generating tab names in tab-bar-mode.

;;; Code:

(defun tactabbar-upper-left-window ()
  "Return window in the upper left corner of current window config."
  (seq-find
   (lambda (win)
     (and (window-live-p win)
          (with-selected-window win
            (and
             (null (window-in-direction 'left))
             (null (window-in-direction 'above))))))
   (window-list)))

(defun tactabbar-proj-or-nil ()
  "Projectile project of current buffer or nil."
  (let* ((pname (projectile-project-name))
         (proj-name (if (string= pname "-") nil pname )))
    proj-name))

(defun tactabbar-proj-or-major-mode ()
  "The name of the projectile project, or the current major mode."
  ;; Safe to assume that the current buffer is the buffer of the new tab
  (let* ((proj-name (tactabbar-proj-or-nil))
         (curr-major (format "%s" major-mode)))
      (or proj-name
          curr-major
          "Default")))

(defun tactabbar-get-tabs (&optional frame)
  "Return tabs of FRAME or current frame."
  (if frame
      (frame-parameter frame 'tabs)
    (frame-parameter (selected-frame) 'tabs)))

(defun tactabbar-get-current-tab ()
  "Return the current tab."
  (let ((tabs (tactabbar-get-tabs)))
    (tab-bar--current-tab-find tabs)))

(defun tactabbar-get-tab-wc ()
  "Return window configuration of the active `tab-bar-mode` tab."
  (or
     ;; The window config is stored as a frame parameter
     (alist-get 'wc (tactabbar-get-current-tab))
     ;; The window config is not stored in the tab (because it's
     ;; already stored in whatever variable holds the frame's
     ;; current window config.)
     (current-window-configuration)))

(defun tactabbar-tab-name-consistent ()
  "Generate tab name based on the window in the upper left corner."
  (let ((win1 (tactabbar-upper-left-window)))
    (if (window-live-p win1)
        (select-window win1 t))
    (tactabbar-proj-or-major-mode)))

(defun tactabbar-dired-new-tab ()
  "Open Dired in the home directory."
  (dired "~/"))


(provide 'tac-tab-bar)

;;; tac-tab-bar.el ends here
