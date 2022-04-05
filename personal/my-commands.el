(require 'cl-lib)

(defun konsole(workdir command)
  (kill-new command)
                                        ; (shell-command (concat "konsole --new-tab --workdir " workdir  " -e " command " > /dev/null 2>&1 & disown") nil nil)
  (shell-command (concat "konsole --new-tab --workdir " workdir  " -e bash -ci \"wmctrl -a Konsole ; " command "\" > /dev/null 2>&1 & disown") nil nil))

(defun dw-run-test-old ()
  (interactive)
  (message "foobar33")
  (let ((test-file-full (file-relative-name buffer-file-name (projectile-project-root)))
        (server nil)
        (test-file nil)
        (workdir nil))
    (setq test-file-full (split-string test-file-full "/"))
    (setq server (car test-file-full))
    (setq test-file  (cdr test-file-full))
    (message "foobar33")
    (setq workdir (concat (projectile-project-root) "/"  (car test-file-full)) )

    (message "foobar")

    (when (string= (car test-file) "test")
      (if (string= (car (cdr test-file)) "client")
          (konsole workdir (concat "LANGUAGE=en-US npm run test-ng --file=" (string-join test-file "/") ""))
        (konsole  workdir (concat  "npm run test --noqueueinit --nodbinit --nobail --file=" (string-join  test-file "/") " -- -w" ))))))

(defun dw-run-test ()
  (interactive)
  (message "foobar33")
  (let ((test-file-full nil)
        (index nil)
        (test-file nil)
        (workdir nil))
    (setq test-file-full (split-string buffer-file-name "/"))
    (setq index (cl-position "test" test-file-full :test 'equal))
    (when  index
      (setq workdir (string-join (cl-subseq test-file-full 0 index) "/"  ))
      (setq test-file (string-join (cl-subseq test-file-full index) "/"  ))
      (if (cl-position "client" test-file-full :test 'equal)
          (konsole workdir (concat "LANGUAGE=en-US npm run test-ng --file=" test-file ""))
        (konsole  workdir (concat  "npm run test --noqueueinit --nodbinit --nobail --file=" test-file " -- -w" ))))))


(defun eslint-fix ()
  (interactive)
                                        ;  (message (concat "eslint --fixing " (buffer-file-name)))
  (shell-command (concat  "eslint --fix " (buffer-file-name)))
  (revert-buffer t t))

(defun dw-db-restore-prod ()
  (interactive)
  (konsole "~/workspace/direct-web" "npm run db-restore-prod-slim && notify-send -a db-restore-prod completed"))

(defun dw-deps ()
  (interactive)
  (konsole "~/workspace/direct-web" "npm run deps && notify-send -a deps completed"))

(defun dw-pm2-start ()
  (interactive)
  (konsole "~/workspace/direct-web" "pm2 start processes.json && pm2 stop 1 6 7"))

(defun dw-dc-up ()
  (interactive)
  (konsole "~/workspace/direct-web/package/docker" "docker-compose up -d")
  (konsole "~/workspace/login" "docker-compose up -d"))

(defun dw-dc-stop ()
  (interactive)
  (konsole "~/workspace/direct-web/package/docker" "docker-compose stop"))

(defun dw-dc-down ()
  (interactive)
  (konsole "~/workspace/direct-web/package/docker" "docker-compose down"))

(defun dw-db-snapshot ()
  (interactive)
  (konsole "~/workspace/direct-web/package/docker" "
docker-compose stop postgres
docker volume rm my-backup-volume
docker run --rm \
       -v my-backup-volume:/to \
       -v docker_postgres-data:/from:ro \
       \\$(docker-compose images -q postgres) \
       bash -c 'cp -r /from/* /to'
docker-compose start postgres
notify-send -a db-snapshot completed
"))

(defun dw-db-reset ()
  (interactive)
  (konsole "~/workspace/direct-web/package/docker" "
docker-compose stop postgres
docker run --rm \
       -v my-backup-volume:/from:ro \
       -v docker_postgres-data:/to \
       \\$(docker-compose images -q postgres) \
       bash -c 'rm -r /to/* ; cp -r /from/* /to'
docker-compose start postgres
notify-send -a db-restore completed
"))

(defun dw-migrate-up ()
  (interactive)
  (konsole "~/workspace/direct-web/scripts/migrate" "npm run migrate up"))

(defun dw-migrate-revert ()
  (interactive)
  (konsole "~/workspace/direct-web/scripts/migrate" "npm run migrate --revert 1"))

(defun dw-vpn ()
  (interactive)
  (konsole "~/vpn" "openvpn3 session-start --config client.ovpn"))

(defun dw-promisify ()
  (interactive)
  (konsole "~/workspace/codeshift" (format "npx jscodeshift -t promisify.js %s --name=aaaaaaaaaaaaaaaa" buffer-file-name)))
