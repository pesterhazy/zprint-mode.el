;;; zprint-mode.el --- Reformat Clojure(Script) code using zprint

;; Author: Paulus Esterhazy (pesterhazy@gmail.com)
;; URL: https://github.com/pesterhazy/zprint-mode.el
;; Version: 0.2
;; Keywords: tools
;; Package-Requires: ((emacs "24.3"))

;; This file is NOT part of GNU Emacs.

;; zprint-mode.el is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; zprint-mode.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with zprint-mode.el.
;; If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Reformat Clojure(Script) code using zprint

;;; Code:

(defconst zprint-mode-dir (if load-file-name (file-name-directory load-file-name) default-directory))

;;;###autoload
(defun zprint (&optional is-interactive)
  "Reformat code using zprint.
If region is active, reformat it; otherwise reformat entire buffer.
When called interactively, or with prefix argument IS-INTERACTIVE,
show a buffer if the formatting fails"
  (interactive)
  (let* ((b (if mark-active (min (point) (mark)) (point-min)))
         (e (if mark-active (max (point) (mark)) (point-max)))
         (in-file (make-temp-file "zprint"))
         (err-file (make-temp-file "zprint"))
         (out-file (make-temp-file "zprint"))
         (contents (buffer-substring-no-properties b e))
         (_ (with-temp-file in-file (insert contents))))

    (unwind-protect
        (let* ((error-buffer (get-buffer-create "*zprint-mode errors*"))
               (retcode
                (with-temp-buffer
                  (call-process "bash"
                                nil
                                (list (current-buffer) err-file)
                                nil
                                (concat zprint-mode-dir
                                        (file-name-as-directory "bin")
                                        "wrap-zprint")
                                in-file
                                out-file))))
          (with-current-buffer error-buffer
            (read-only-mode 0)
            (insert-file-contents err-file nil nil nil t)
            (special-mode))
          (if (eq retcode 0)
              (progn
                (if mark-active
                    (progn
                      ;; surely this can be done more elegantly?
                      (when (not (string= (with-temp-buffer
                                            (insert-file-contents out-file)
                                            (buffer-string))
                                          (buffer-substring-no-properties b e)))
                        (delete-region b e)
                        (insert-file-contents out-file nil nil nil nil)))
                  (insert-file-contents out-file nil nil nil t))
                (message "zprint applied"))
            (if is-interactive
                (display-buffer error-buffer)
              (message "zprint failed: see %s" (buffer-name error-buffer)))))
      (delete-file in-file)
      (delete-file err-file)
      (delete-file out-file))))

;;;###autoload
(define-minor-mode zprint-mode
  "Minor mode for reformatting Clojure(Script) code using zprint"
  :lighter " zprint"
  (if zprint-mode
      (add-hook 'before-save-hook 'zprint nil t)
    (remove-hook 'before-save-hook 'zprint t)))

(provide 'zprint-mode)

;;; zprint-mode.el ends here
