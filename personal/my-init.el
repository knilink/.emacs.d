;; https://www.simplify.ba/articles/2016/02/14/linting-javascript-in-gnu-emacs/
;; http://www.cyrusinnovation.com/initial-emacs-setup-for-reactreactnative/

(prelude-require-packages '(yasnippet
                            prettier-js
                            nodejs-repl))

;(require 'web-mode)
;;;

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
; (add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode))

(setq web-mode-markup-indent-offset 2
      web-mode-css-indent-offset 2
      web-mode-code-indent-offset 2)

(add-to-list 'web-mode-indentation-params '("lineup-args" . nil))

(custom-set-variables
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 )


(defun eslint-fix ()
  (interactive)
;  (message (concat "eslint --fixing " (buffer-file-name)))
  (shell-command (concat  "eslint --fix " (buffer-file-name)))
  (revert-buffer t t))


;===============================================================================
;setup js repl
(setq nodejs-repl-arguments '("--experimental-repl-await"))
(require 'nodejs-repl)
(add-hook
 'js2-mode-hook
 (lambda ()
   (define-key js-mode-map (kbd "C-x C-e") 'nodejs-repl-send-last-expression)
   (define-key js-mode-map (kbd "C-c C-j") 'nodejs-repl-send-line)
   (define-key js-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
   (define-key js-mode-map (kbd "C-c C-c") 'nodejs-repl-send-buffer)
   (define-key js-mode-map (kbd "C-c C-l") 'nodejs-repl-load-file)
   (define-key js-mode-map (kbd "C-c C-z") 'nodejs-repl-switch-to-repl)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; typescript
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
; (add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

(flycheck-add-mode 'typescript-tslint 'web-mode)
(remove-hook 'before-save-hook 'tide-format-before-save)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; prettier-js
(require 'prettier-js)
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'typescript-mode-hook 'prettier-js-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yasnippet
(require 'yasnippet)
(yas-global-mode +1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ace-window
(require 'ace-window)
(defun my-switch-to-window (n)
  (let ((window (nth (- n 1) (aw-window-list))))
    (if window (aw-switch-to-window window))))
(global-set-key (kbd "s-1") (lambda ()(interactive)(my-switch-to-window 1)))
(global-set-key (kbd "s-2") (lambda ()(interactive)(my-switch-to-window 2)))
(global-set-key (kbd "s-3") (lambda ()(interactive)(my-switch-to-window 3)))
(global-set-key (kbd "s-4") (lambda ()(interactive)(my-switch-to-window 4)))
(global-set-key (kbd "s-5") (lambda ()(interactive)(my-switch-to-window 5)))
(global-set-key (kbd "M-[") (lambda ()(interactive)(other-window -1)))
(global-set-key (kbd "M-]") (lambda ()(interactive)(other-window 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; avy
(global-set-key (kbd "C-'") 'avy-goto-char-2)

;;;my-init.el ends here
